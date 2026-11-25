import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/error/app_exception.dart';
import '../../points/data/point_service.dart';
import '../domain/todo_enums.dart';
import '../domain/todo_rules.dart';

/// 오늘 목록의 한 줄.
class TodayTodo {
  const TodayTodo({
    required this.todo,
    required this.status,
    required this.delayDays,
    required this.items,
  });

  final Todo todo;

  /// 오늘 회차 상태 (없으면 null = 아직 안 함).
  final OccurrenceStatus? status;
  final int delayDays;

  /// 체크리스트 하위항목 (다른 종류는 빈 목록).
  final List<ChecklistItem> items;

  bool get isCompleted => status == OccurrenceStatus.completed;
}

/// 할일 등록·수정·삭제·완료 (PRD 3.1). 포인트는 [PointService]가 처리한다.
class TodoService {
  TodoService(this._db, this._points, this._now);

  final AppDatabase _db;
  final PointService _points;
  final DateTime Function() _now;

  String get _today => dateKey(_now());

  /// 빠른 등록: 제목만, 오늘·난이도 하.
  Future<int> quickAdd(String title) =>
      add(TodoDraft(type: TodoType.oneTime, title: title, date: _today));

  /// 상세 등록.
  Future<int> add(TodoDraft draft) => _db.transaction(() async {
    TodoRules.validate(draft);
    final isRepeat = draft.type == TodoType.repeat;
    final id = await _db
        .into(_db.todos)
        .insert(
          TodosCompanion.insert(
            type: draft.type,
            title: draft.title.trim(),
            difficulty: draft.difficulty,
            categoryId: Value(draft.categoryId),
            date: Value(isRepeat ? null : draft.date),
            originalDate: Value(isRepeat ? null : draft.date),
            repeatWeekdays: Value(isRepeat ? draft.repeatWeekdays : null),
            startDate: _today,
            createdAt: _now(),
          ),
        );
    await _insertItems(id, draft.items);
    return id;
  });

  /// 수정. 오늘 완료한 할일은 [TodoLocked]. 종류는 바꿀 수 없다.
  /// 체크리스트 하위항목은 새 목록으로 바꾸되, 제목이 같은 항목은 체크 상태를 유지한다.
  Future<void> update(int todoId, TodoDraft draft) => _db.transaction(() async {
    final todo = await _getTodo(todoId);
    if (draft.type != todo.type) {
      throw const InvalidTodo('할일 종류는 바꿀 수 없어요.');
    }
    TodoRules.validate(draft);
    await _ensureNotCompletedToday(todoId);

    final isRepeat = todo.type == TodoType.repeat;
    final dateChanged = !isRepeat && draft.date != todo.date;
    await (_db.update(_db.todos)..where((t) => t.id.equals(todoId))).write(
      TodosCompanion(
        title: Value(draft.title.trim()),
        difficulty: Value(draft.difficulty),
        categoryId: Value(draft.categoryId),
        date: Value(isRepeat ? null : draft.date),
        // 사용자가 날짜를 직접 바꾸면 지연 기준도 새 날짜로 한다.
        originalDate: dateChanged ? Value(draft.date) : const Value.absent(),
        repeatWeekdays: Value(isRepeat ? draft.repeatWeekdays : null),
      ),
    );

    if (todo.type == TodoType.checklist) {
      final old = await _items(todoId);
      final checkedTitles = {
        for (final i in old)
          if (i.checked) i.title,
      };
      await (_db.delete(
        _db.checklistItems,
      )..where((i) => i.todoId.equals(todoId))).go();
      await _insertItems(todoId, draft.items, checkedTitles: checkedTitles);
    }
  });

  /// 삭제 표시. 지난 기록과 포인트는 남는다.
  Future<void> delete(int todoId) async {
    await _getTodo(todoId);
    await (_db.update(_db.todos)..where((t) => t.id.equals(todoId))).write(
      TodosCompanion(deletedAt: Value(_now())),
    );
  }

  /// 오늘 완료. 지급한 포인트를 돌려준다.
  Future<int> complete(int todoId) => _db.transaction(() async {
    final todo = await _getTodo(todoId);
    _ensureDueToday(todo);
    return _points.complete(todoId);
  });

  /// 오늘 완료 취소. 차감액(음수)을 돌려준다.
  Future<int> cancel(int todoId) => _points.cancel(todoId);

  /// 체크리스트 하위항목 체크. 마지막 항목을 체크해 모두 체크되면 자동으로 완료하고
  /// 지급한 포인트를 돌려준다(완료되지 않았으면 null).
  Future<int?> setItemChecked(int itemId, bool checked) =>
      _db.transaction(() async {
        final item = await (_db.select(
          _db.checklistItems,
        )..where((i) => i.id.equals(itemId))).getSingle();
        await _ensureNotCompletedToday(item.todoId);

        await (_db.update(_db.checklistItems)
              ..where((i) => i.id.equals(itemId)))
            .write(ChecklistItemsCompanion(checked: Value(checked)));

        final items = await _items(item.todoId);
        if (!checked || items.any((i) => !i.checked)) return null;

        final todo = await _getTodo(item.todoId);
        if (!_isDueToday(todo)) return null; // 미래 날짜는 체크만 하고 완료하지 않는다.
        return _points.complete(item.todoId);
      });

  /// 오늘 목록: 오늘 해당하는 반복 + 오늘·지난 날짜의 원타임·체크리스트.
  /// 지난 날에 이미 완료한 원타임·체크리스트는 뺀다.
  Future<List<TodayTodo>> todayList() async {
    final today = _today;
    final todos = await (_db.select(
      _db.todos,
    )..where((t) => t.deletedAt.isNull())).get();

    final result = <TodayTodo>[];
    for (final todo in todos) {
      if (!_isDueToday(todo)) continue;

      final occurrences = await (_db.select(
        _db.todoOccurrences,
      )..where((o) => o.todoId.equals(todo.id))).get();
      final completedBefore = occurrences.any(
        (o) =>
            o.status == OccurrenceStatus.completed &&
            daysBetween(o.date, today) > 0,
      );
      if (todo.type != TodoType.repeat && completedBefore) continue;

      final todayOcc = occurrences.where((o) => o.date == today).firstOrNull;
      result.add(
        TodayTodo(
          todo: todo,
          status: todayOcc?.status,
          delayDays: TodoRules.delayDays(
            originalDate: todo.originalDate,
            today: today,
          ),
          items: todo.type == TodoType.checklist
              ? await _items(todo.id)
              : const [],
        ),
      );
    }
    return result;
  }

  bool _isDueToday(Todo todo) => TodoRules.canCompleteToday(
    type: todo.type,
    date: todo.date,
    repeatWeekdays: todo.repeatWeekdays,
    startDate: todo.startDate,
    today: _today,
  );

  void _ensureDueToday(Todo todo) {
    if (!_isDueToday(todo)) throw const TodoNotDueToday();
  }

  Future<void> _ensureNotCompletedToday(int todoId) async {
    final occ =
        await (_db.select(_db.todoOccurrences)
              ..where((o) => o.todoId.equals(todoId) & o.date.equals(_today)))
            .getSingleOrNull();
    if (occ?.status == OccurrenceStatus.completed) throw const TodoLocked();
  }

  Future<Todo> _getTodo(int todoId) async {
    final todo =
        await (_db.select(_db.todos)
              ..where((t) => t.id.equals(todoId) & t.deletedAt.isNull()))
            .getSingleOrNull();
    if (todo == null) throw const TodoNotFound();
    return todo;
  }

  Future<List<ChecklistItem>> _items(int todoId) =>
      (_db.select(_db.checklistItems)
            ..where((i) => i.todoId.equals(todoId))
            ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
          .get();

  Future<void> _insertItems(
    int todoId,
    List<String> titles, {
    Set<String> checkedTitles = const {},
  }) async {
    final cleaned = titles.map((t) => t.trim()).where((t) => t.isNotEmpty);
    for (final (i, title) in cleaned.indexed) {
      await _db
          .into(_db.checklistItems)
          .insert(
            ChecklistItemsCompanion.insert(
              todoId: todoId,
              title: title,
              checked: Value(checkedTitles.contains(title)),
              sortOrder: i,
            ),
          );
    }
  }
}

final todoServiceProvider = Provider<TodoService>(
  (ref) => TodoService(
    ref.watch(appDatabaseProvider),
    ref.watch(pointServiceProvider),
    ref.watch(nowProvider),
  ),
);
