import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/points/domain/point_reason.dart';
import '../../features/todo/domain/todo_enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Todos,
    ChecklistItems,
    TodoOccurrences,
    PointHistory,
    Pets,
    UserProfile,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// [executor]를 넘기지 않으면 기기의 'todo_pet' DB를 연다. 테스트는 메모리 DB를 넘긴다.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'todo_pet'));

  // 스키마를 바꾸면 버전을 올리고 `dart run drift_dev make-migrations`를 실행한다.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await into(userProfile).insert(const UserProfileCompanion());
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
