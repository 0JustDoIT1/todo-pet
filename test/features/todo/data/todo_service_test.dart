import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/points/data/point_service.dart';
import 'package:todo_pet/features/todo/data/todo_service.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';
import 'package:todo_pet/features/todo/domain/todo_rules.dart';

void main() {
  late AppDatabase db;
  late PointService points;
  late TodoService todos;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 25, 9); // 수요일
    points = PointService(db, () => now);
    todos = TodoService(db, points, () => now);
  });
  tearDown(() => db.close());

  Future<int> addChecklist({String date = '2026-11-25'}) => todos.add(
    TodoDraft(
      type: TodoType.checklist,
      title: '장보기',
      date: date,
      items: const ['우유', '빵'],
    ),
  );

  Future<List<ChecklistItem>> itemsOf(int todoId) => (db.select(
    db.checklistItems,
  )..where((i) => i.todoId.equals(todoId))).get();

  test('빠른 등록은 오늘·난이도 하로 저장되고 완료하면 5P', () async {
    final id = await todos.quickAdd(' 물 마시기 ');
    final todo = await (db.select(
      db.todos,
    )..where((t) => t.id.equals(id))).getSingle();

    expect(todo.title, '물 마시기');
    expect(todo.date, '2026-11-25');
    expect(todo.difficulty, Difficulty.low);
    expect(await todos.complete(id), 5);
  });

  test('미래 날짜 할일은 완료할 수 없다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.oneTime,
        title: '내일 일',
        date: '2026-11-26',
      ),
    );
    await expectLater(todos.complete(id), throwsA(isA<TodoNotDueToday>()));
  });

  test('오늘 요일이 아닌 반복 할일은 완료할 수 없다', () async {
    final id = await todos.add(
      const TodoDraft(type: TodoType.repeat, title: '월요 운동', repeatWeekdays: 1),
    );
    await expectLater(todos.complete(id), throwsA(isA<TodoNotDueToday>()));
  });

  test('완료한 할일은 수정할 수 없고, 취소하면 수정할 수 있다', () async {
    final id = await todos.quickAdd('물');
    await todos.complete(id);
    const draft = TodoDraft(
      type: TodoType.oneTime,
      title: '물 2L',
      date: '2026-11-25',
    );

    await expectLater(todos.update(id, draft), throwsA(isA<TodoLocked>()));
    await todos.cancel(id);
    await todos.update(id, draft);
  });

  test('할일 종류는 바꿀 수 없다', () async {
    final id = await todos.quickAdd('물');
    await expectLater(
      todos.update(
        id,
        const TodoDraft(type: TodoType.repeat, title: '물', repeatWeekdays: 127),
      ),
      throwsA(isA<InvalidTodo>()),
    );
  });

  test('체크리스트 마지막 항목을 체크하면 자동 완료되고 포인트를 지급한다', () async {
    final id = await addChecklist();
    final items = await itemsOf(id);

    expect(await todos.setItemChecked(items[0].id, true), isNull);
    expect(await todos.setItemChecked(items[1].id, true), 5);
    expect(await points.balance(), 5);
  });

  test('완료된 체크리스트는 항목을 해제할 수 없다 (취소 먼저)', () async {
    final id = await addChecklist();
    for (final item in await itemsOf(id)) {
      await todos.setItemChecked(item.id, true);
    }

    final first = (await itemsOf(id)).first;
    await expectLater(
      todos.setItemChecked(first.id, false),
      throwsA(isA<TodoLocked>()),
    );
  });

  test('미래 날짜 체크리스트는 다 체크해도 완료되지 않는다', () async {
    final id = await addChecklist(date: '2026-11-27');
    int? last;
    for (final item in await itemsOf(id)) {
      last = await todos.setItemChecked(item.id, true);
    }
    expect(last, isNull);
    expect(await points.balance(), 0);
  });

  test('체크리스트 수정 시 제목이 같은 항목은 체크 상태를 유지한다', () async {
    final id = await addChecklist(date: '2026-11-27');
    final milk = (await itemsOf(id)).firstWhere((i) => i.title == '우유');
    await todos.setItemChecked(milk.id, true);

    await todos.update(
      id,
      const TodoDraft(
        type: TodoType.checklist,
        title: '장보기',
        date: '2026-11-27',
        items: ['우유', '계란'],
      ),
    );

    final checked = {for (final i in await itemsOf(id)) i.title: i.checked};
    expect(checked, {'우유': true, '계란': false});
  });

  test('삭제한 할일은 목록과 완료에서 빠지지만 포인트 이력은 남는다', () async {
    final id = await todos.quickAdd('물');
    await todos.complete(id);
    await todos.delete(id);

    expect(await todos.todayList(), isEmpty);
    await expectLater(todos.complete(id), throwsA(isA<TodoNotFound>()));
    expect(await points.balance(), 5);
  });

  group('todayList', () {
    test('오늘 반복·오늘 원타임·지난 원타임은 보이고, 미래·다른 요일은 안 보인다', () async {
      await todos.add(
        const TodoDraft(
          type: TodoType.repeat,
          title: '수요 운동',
          repeatWeekdays: 4,
        ),
      );
      await todos.add(
        const TodoDraft(
          type: TodoType.repeat,
          title: '월요 운동',
          repeatWeekdays: 1,
        ),
      );
      await todos.quickAdd('오늘 일');
      await todos.add(
        const TodoDraft(
          type: TodoType.oneTime,
          title: '내일 일',
          date: '2026-11-26',
        ),
      );

      final titles = (await todos.todayList()).map((t) => t.todo.title);
      expect(titles, unorderedEquals(['수요 운동', '오늘 일']));
    });

    test('지난 날짜 원타임은 지연 일수와 함께 보인다', () async {
      now = DateTime(2026, 11, 22, 9);
      await todos.quickAdd('밀린 일');
      now = DateTime(2026, 11, 25, 9);

      final item = (await todos.todayList()).single;
      expect(item.delayDays, 3);
    });

    test('오늘 완료한 원타임은 완료 상태로 남고, 지난 날 완료한 원타임은 빠진다', () async {
      final id = await todos.quickAdd('물');
      await todos.complete(id);
      expect((await todos.todayList()).single.isCompleted, isTrue);

      now = DateTime(2026, 11, 26, 9);
      expect(await todos.todayList(), isEmpty);
    });

    test('반복 할일은 어제 완료했어도 오늘 다시 보인다', () async {
      final id = await todos.add(
        const TodoDraft(
          type: TodoType.repeat,
          title: '운동',
          repeatWeekdays: 127,
        ),
      );
      await todos.complete(id);

      now = DateTime(2026, 11, 26, 9);
      final item = (await todos.todayList()).single;
      expect(item.status, isNull);
    });
  });
}
