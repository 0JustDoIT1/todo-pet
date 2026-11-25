import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/features/points/data/point_service.dart';
import 'package:todo_pet/features/todo/data/day_rollover_service.dart';
import 'package:todo_pet/features/todo/data/todo_service.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';
import 'package:todo_pet/features/todo/domain/todo_rules.dart';

void main() {
  late AppDatabase db;
  late TodoService todos;
  late DayRolloverService rollover;
  late DateTime now;

  /// 2026-11-25(수)에 시작해 [day]일로 시계를 옮긴다.
  void setDay(int day) => now = DateTime(2026, 11, day, 9);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    setDay(25);
    final points = PointService(db, () => now);
    todos = TodoService(db, points, () => now);
    rollover = DayRolloverService(db, () => now);
    await rollover.run(); // 설치 후 첫 실행
  });
  tearDown(() => db.close());

  Future<Todo> todo(int id) =>
      (db.select(db.todos)..where((t) => t.id.equals(id))).getSingle();

  Future<Map<String, OccurrenceStatus>> occurrences(int todoId) async {
    final rows = await (db.select(
      db.todoOccurrences,
    )..where((o) => o.todoId.equals(todoId))).get();
    return {for (final o in rows) o.date: o.status};
  }

  Future<String?> lastProcessed() async =>
      (await db.select(db.userProfile).getSingle()).lastProcessedDate;

  test('첫 실행은 어제를 마지막 처리일로 남기고 아무것도 바꾸지 않는다', () async {
    expect(await lastProcessed(), '2026-11-24');
  });

  test('3일 만에 열면 미완료 원타임은 오늘로 이월되고 처음 날짜와 지연 일수가 남는다', () async {
    final id = await todos.quickAdd('밀린 일');
    setDay(28);
    await rollover.run();

    final t = await todo(id);
    expect(t.date, '2026-11-28');
    expect(t.originalDate, '2026-11-25');
    expect((await todos.todayList()).single.delayDays, 3);
    expect(await lastProcessed(), '2026-11-27');
  });

  test('완료한 원타임은 이월하지 않는다', () async {
    final id = await todos.quickAdd('끝낸 일');
    await todos.complete(id);
    setDay(26);
    await rollover.run();

    expect((await todo(id)).date, '2026-11-25');
  });

  test('미래 날짜 원타임은 그대로 둔다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.oneTime,
        title: '다음 주',
        date: '2026-12-01',
      ),
    );
    setDay(27);
    await rollover.run();

    expect((await todo(id)).date, '2026-12-01');
  });

  test('매일 반복은 밀린 날마다 결석, 완료한 날은 완료로 남는다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.repeat,
        title: '운동',
        repeatWeekdays: TodoRules.everyDay,
      ),
    );
    await todos.complete(id); // 25일 완료
    setDay(28);
    await rollover.run();

    expect(await occurrences(id), {
      '2026-11-25': OccurrenceStatus.completed,
      '2026-11-26': OccurrenceStatus.absent,
      '2026-11-27': OccurrenceStatus.absent,
    });
  });

  test('요일 반복은 해당 요일만 결석으로 기록한다', () async {
    // 금요일(16)만 반복. 25(수)~30(월) 사이 금요일은 27일
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.repeat,
        title: '금요 정리',
        repeatWeekdays: 16,
      ),
    );
    setDay(30);
    await rollover.run();

    expect(await occurrences(id), {'2026-11-27': OccurrenceStatus.absent});
  });

  test('취소만 하고 다시 완료하지 않은 회차는 결석이 된다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.repeat,
        title: '운동',
        repeatWeekdays: TodoRules.everyDay,
      ),
    );
    await todos.complete(id);
    await todos.cancel(id);
    setDay(26);
    await rollover.run();

    expect(await occurrences(id), {'2026-11-25': OccurrenceStatus.absent});
  });

  test('삭제한 반복 할일은 삭제한 날부터 결석을 기록하지 않는다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.repeat,
        title: '운동',
        repeatWeekdays: TodoRules.everyDay,
      ),
    );
    setDay(26);
    await rollover.run(); // 25일 결석
    await todos.delete(id); // 26일 삭제
    setDay(29);
    await rollover.run();

    expect(await occurrences(id), {'2026-11-25': OccurrenceStatus.absent});
  });

  test('같은 날 여러 번 실행해도 결과가 같다', () async {
    final id = await todos.add(
      const TodoDraft(
        type: TodoType.repeat,
        title: '운동',
        repeatWeekdays: TodoRules.everyDay,
      ),
    );
    setDay(27);
    await rollover.run();
    final first = await occurrences(id);
    await rollover.run();

    expect(await occurrences(id), first);
    expect(first, hasLength(2));
  });

  test('기기 시계가 뒤로 가도 마지막 처리일을 되돌리지 않는다', () async {
    setDay(28);
    await rollover.run();
    setDay(26);
    await rollover.run();

    expect(await lastProcessed(), '2026-11-27');
  });
}
