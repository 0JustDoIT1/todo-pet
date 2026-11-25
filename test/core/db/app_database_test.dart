import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> insertTodo() => db
      .into(db.todos)
      .insert(
        TodosCompanion.insert(
          type: TodoType.oneTime,
          title: '물 마시기',
          difficulty: Difficulty.low,
          date: const Value('2026-11-25'),
          originalDate: const Value('2026-11-25'),
          startDate: '2026-11-25',
          createdAt: DateTime(2026, 11, 25),
        ),
      );

  TodoOccurrencesCompanion occurrence(int todoId) =>
      TodoOccurrencesCompanion.insert(
        todoId: todoId,
        date: '2026-11-25',
        status: OccurrenceStatus.completed,
      );

  test('DB를 만들면 사용자 프로필 1행이 생긴다', () async {
    final profiles = await db.select(db.userProfile).get();
    expect(profiles, hasLength(1));
    expect(profiles.single.onboardingDone, isFalse);
  });

  test('같은 할일·같은 날짜의 회차는 두 번 만들 수 없다 (포인트 중복 지급 방지 기준)', () async {
    final todoId = await insertTodo();
    await db.into(db.todoOccurrences).insert(occurrence(todoId));

    expect(
      () => db.into(db.todoOccurrences).insert(occurrence(todoId)),
      throwsA(isA<SqliteException>()),
    );
  });

  test('외래 키가 켜져 있어 없는 할일의 회차는 만들 수 없다', () async {
    expect(
      () => db.into(db.todoOccurrences).insert(occurrence(999)),
      throwsA(isA<SqliteException>()),
    );
  });

  test('같은 종의 펫은 한 마리만 둘 수 있다', () async {
    PetsCompanion pet() => PetsCompanion.insert(
      speciesId: 'cat',
      name: '나비',
      mood: 80,
      hunger: 80,
      lastUpdatedAt: DateTime(2026, 11, 25),
    );
    await db.into(db.pets).insert(pet());

    expect(
      () => db.into(db.pets).insert(pet()),
      throwsA(isA<SqliteException>()),
    );
  });
}
