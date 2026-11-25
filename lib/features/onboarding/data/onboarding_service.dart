import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/error/app_exception.dart';
import '../../pet/data/pet_service.dart';
import '../../todo/data/todo_service.dart';

/// 온보딩 (PRD F6). 펫과 첫 할일을 한 번에 저장하고 완료로 표시한다.
/// 중간에 앱을 끄면 아무것도 저장되지 않아 다시 열 때 처음부터 한다.
class OnboardingService {
  OnboardingService(this._db, this._pets, this._todos);

  final AppDatabase _db;
  final PetService _pets;
  final TodoService _todos;

  /// 첫 할일은 1~3개 (기획서 5.9).
  static const maxFirstTodos = 3;

  Future<bool> isDone() async =>
      (await _db.select(_db.userProfile).getSingle()).onboardingDone;

  Future<void> finish({
    required String speciesId,
    required String petName,
    required List<String> todoTitles,
  }) => _db.transaction(() async {
    final titles = todoTitles
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (titles.isEmpty) {
      throw const InvalidTodo('첫 할일을 하나 이상 적어 주세요.');
    }
    if (titles.length > maxFirstTodos) {
      throw const InvalidTodo('첫 할일은 3개까지 적을 수 있어요.');
    }

    await _pets.create(speciesId: speciesId, name: petName);
    for (final title in titles) {
      await _todos.quickAdd(title);
    }
    await _db
        .update(_db.userProfile)
        .write(const UserProfileCompanion(onboardingDone: Value(true)));
  });
}

final onboardingServiceProvider = Provider<OnboardingService>(
  (ref) => OnboardingService(
    ref.watch(appDatabaseProvider),
    ref.watch(petServiceProvider),
    ref.watch(todoServiceProvider),
  ),
);

final onboardingDoneProvider = FutureProvider<bool>(
  (ref) => ref.watch(onboardingServiceProvider).isDone(),
);
