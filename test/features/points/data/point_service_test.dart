import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/points/data/point_service.dart';
import 'package:todo_pet/features/points/domain/point_reason.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';

void main() {
  late AppDatabase db;
  late PointService service;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 25, 9);
    service = PointService(db, () => now);
  });
  tearDown(() => db.close());

  Future<int> addTodo({
    Difficulty difficulty = Difficulty.mid,
    TodoType type = TodoType.oneTime,
  }) => db
      .into(db.todos)
      .insert(
        TodosCompanion.insert(
          type: type,
          title: '할일',
          difficulty: difficulty,
          date: const Value('2026-11-25'),
          originalDate: const Value('2026-11-25'),
          startDate: '2026-11-25',
          createdAt: now,
        ),
      );

  Future<int> occurrenceNet(int todoId) async {
    final occ = await (db.select(
      db.todoOccurrences,
    )..where((o) => o.todoId.equals(todoId))).getSingle();
    final rows = await (db.select(
      db.pointHistory,
    )..where((p) => p.occurrenceId.equals(occ.id))).get();
    return rows.fold<int>(0, (sum, r) => sum + r.amount);
  }

  test('완료하면 난이도 포인트를 지급하고 이력에 남긴다', () async {
    final id = await addTodo(difficulty: Difficulty.high);

    expect(await service.complete(id), 20);
    expect(await service.balance(), 20);
    expect(await service.todayEarned(), 20);
  });

  test('같은 회차를 두 번 완료하면 AlreadyCompleted, 잔액은 그대로', () async {
    final id = await addTodo();
    await service.complete(id);

    await expectLater(service.complete(id), throwsA(isA<AlreadyCompleted>()));
    expect(await service.balance(), 10);
  });

  test('완료 → 취소 → 재완료하면 회차 합계는 지급액 1건과 같다', () async {
    final id = await addTodo();

    await service.complete(id);
    expect(await service.cancel(id), -10);
    expect(await service.balance(), 0);
    await service.complete(id);

    expect(await occurrenceNet(id), 10);
    expect(await service.balance(), 10);
  });

  test('다음 날에는 취소할 수 없다', () async {
    final id = await addTodo();
    await service.complete(id);

    now = DateTime(2026, 11, 26, 9);
    await expectLater(service.cancel(id), throwsA(isA<CancelNotAllowed>()));
  });

  test('일일 상한 100P를 넘는 부분은 지급하지 않고 0P로 기록한다', () async {
    for (var i = 0; i < 4; i++) {
      await service.complete(await addTodo(difficulty: Difficulty.high));
    }
    expect(await service.todayEarned(), 80);

    // 95까지 채운 뒤 20P짜리를 완료하면 5P만 지급
    await service.complete(await addTodo(difficulty: Difficulty.mid));
    await service.complete(await addTodo(difficulty: Difficulty.low));
    expect(await service.todayEarned(), 95);
    expect(
      await service.complete(await addTodo(difficulty: Difficulty.high)),
      5,
    );

    // 상한 도달 후 완료는 0P로 기록
    final overId = await addTodo(difficulty: Difficulty.high);
    expect(await service.complete(overId), 0);
    expect(await occurrenceNet(overId), 0);
    expect(await service.balance(), 100);
  });

  test('다음 날이 되면 상한이 초기화된다', () async {
    for (var i = 0; i < 5; i++) {
      await service.complete(await addTodo(difficulty: Difficulty.high));
    }
    now = DateTime(2026, 11, 26, 9);

    expect(await service.todayEarned(), 0);
    expect(
      await service.complete(await addTodo(difficulty: Difficulty.high)),
      20,
    );
  });

  test('지급 뒤 난이도를 바꿔도 취소 차감액은 지급 당시 금액이다', () async {
    final id = await addTodo(difficulty: Difficulty.low);
    await service.complete(id);
    await (db.update(db.todos)..where((t) => t.id.equals(id))).write(
      const TodosCompanion(difficulty: Value(Difficulty.high)),
    );

    expect(await service.cancel(id), -5);
  });

  test('잔액이 모자라면 InsufficientPoints, 이력도 남지 않는다', () async {
    await service.complete(await addTodo(difficulty: Difficulty.low));

    await expectLater(
      service.spend(price: 10, reason: PointReason.food, itemId: 'apple'),
      throwsA(isA<InsufficientPoints>()),
    );
    expect(await service.balance(), 5);

    await service.spend(price: 5, reason: PointReason.food, itemId: 'apple');
    expect(await service.balance(), 0);
  });

  test('지출 뒤 취소로 잔액이 음수가 되면 구매할 수 없다', () async {
    final id = await addTodo();
    await service.complete(id);
    await service.spend(price: 10, reason: PointReason.food, itemId: 'apple');
    await service.cancel(id);

    expect(await service.balance(), -10);
    await expectLater(
      service.spend(price: 0, reason: PointReason.food, itemId: 'apple'),
      throwsA(isA<InsufficientPoints>()),
    );
  });

  test('지출은 일일 상한 계산에 들어가지 않는다', () async {
    await service.complete(await addTodo(difficulty: Difficulty.high));
    await service.spend(price: 20, reason: PointReason.food, itemId: 'apple');

    expect(await service.todayEarned(), 20);
  });

  test('하위항목을 다 체크하지 않은 체크리스트는 완료할 수 없다', () async {
    final id = await addTodo(type: TodoType.checklist);
    for (final (i, checked) in [true, false].indexed) {
      await db
          .into(db.checklistItems)
          .insert(
            ChecklistItemsCompanion.insert(
              todoId: id,
              title: '항목 $i',
              checked: Value(checked),
              sortOrder: i,
            ),
          );
    }

    await expectLater(
      service.complete(id),
      throwsA(isA<ChecklistIncomplete>()),
    );
    expect(await service.balance(), 0);
  });

  test('삭제된 할일은 완료할 수 없다', () async {
    final id = await addTodo();
    await (db.update(db.todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(deletedAt: Value(now)),
    );

    await expectLater(service.complete(id), throwsA(isA<TodoNotFound>()));
  });
}
