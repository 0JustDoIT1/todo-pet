import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../domain/rollover_rules.dart';
import '../domain/todo_enums.dart';
import '../domain/todo_rules.dart';

/// 날짜 넘김 처리 (PRD 3.4). 앱을 열 때, 그리고 켜 둔 채 자정을 넘길 때 부른다.
/// 전체를 한 트랜잭션으로 처리하고 마지막 처리일을 남겨, 같은 날짜를 두 번 처리하지 않는다.
class DayRolloverService {
  DayRolloverService(this._db, this._now);

  final AppDatabase _db;
  final DateTime Function() _now;

  Future<void> run() => _db.transaction(() async {
    final today = dateKey(_now());
    final yesterday = addDays(today, -1);
    final profile = await _db.select(_db.userProfile).getSingle();
    final days = RolloverRules.daysToProcess(
      lastProcessed: profile.lastProcessedDate,
      today: today,
    );

    if (days.isNotEmpty) {
      await _carryOver(today);
      await _recordAbsences(days);
    }

    // 처음 실행이거나 날짜가 앞으로 갔을 때만 기록한다(기기 시계가 뒤로 가도 되돌리지 않음).
    final last = profile.lastProcessedDate;
    if (last == null || daysBetween(last, yesterday) > 0) {
      await _db
          .update(_db.userProfile)
          .write(UserProfileCompanion(lastProcessedDate: Value(yesterday)));
    }
  });

  /// 미완료 원타임·체크리스트를 오늘로 옮긴다. 처음 날짜(originalDate)는 그대로 둔다.
  Future<void> _carryOver(String today) async {
    final todos =
        await (_db.select(_db.todos)..where(
              (t) =>
                  t.deletedAt.isNull() &
                  t.type.isInValues([TodoType.oneTime, TodoType.checklist]) &
                  t.date.isSmallerThanValue(today),
            ))
            .get();

    for (final todo in todos) {
      final completed =
          await (_db.select(_db.todoOccurrences)..where(
                (o) =>
                    o.todoId.equals(todo.id) &
                    o.status.equalsValue(OccurrenceStatus.completed),
              ))
              .get();
      if (completed.isNotEmpty) continue;

      await (_db.update(_db.todos)..where((t) => t.id.equals(todo.id))).write(
        TodosCompanion(date: Value(today)),
      );
    }
  }

  /// 반복 할일의 지난 회차 중 완료하지 않은 날을 결석으로 기록한다.
  /// 취소만 하고 다시 완료하지 않은 회차도 결석으로 바꾼다.
  Future<void> _recordAbsences(List<String> days) async {
    final repeats = await (_db.select(
      _db.todos,
    )..where((t) => t.type.equalsValue(TodoType.repeat))).get();

    for (final todo in repeats) {
      final deletedOn = todo.deletedAt == null
          ? null
          : dateKey(todo.deletedAt!);
      for (final day in days) {
        // 삭제한 날부터는 기록하지 않는다.
        if (deletedOn != null && daysBetween(deletedOn, day) >= 0) break;
        if (!TodoRules.isRepeatDueOn(
          repeatWeekdays: todo.repeatWeekdays ?? 0,
          startDate: todo.startDate,
          date: day,
        )) {
          continue;
        }

        final occ =
            await (_db.select(_db.todoOccurrences)
                  ..where((o) => o.todoId.equals(todo.id) & o.date.equals(day)))
                .getSingleOrNull();
        if (occ == null) {
          await _db
              .into(_db.todoOccurrences)
              .insert(
                TodoOccurrencesCompanion.insert(
                  todoId: todo.id,
                  date: day,
                  status: OccurrenceStatus.absent,
                ),
              );
        } else if (occ.status == OccurrenceStatus.canceled) {
          await (_db.update(
            _db.todoOccurrences,
          )..where((o) => o.id.equals(occ.id))).write(
            const TodoOccurrencesCompanion(
              status: Value(OccurrenceStatus.absent),
            ),
          );
        }
      }
    }
  }
}

final dayRolloverServiceProvider = Provider<DayRolloverService>(
  (ref) => DayRolloverService(
    ref.watch(appDatabaseProvider),
    ref.watch(nowProvider),
  ),
);
