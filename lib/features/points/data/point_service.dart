import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/error/app_exception.dart';
import '../../todo/domain/todo_enums.dart';
import '../domain/point_reason.dart';
import '../domain/point_rules.dart';

/// 포인트 지급·취소·지출을 DB에 기록한다 (PRD 3.2).
/// 회차 상태 변경과 포인트 이력 추가는 항상 한 트랜잭션으로 묶는다.
class PointService {
  PointService(this._db, this._now);

  final AppDatabase _db;
  final DateTime Function() _now;

  String get _today => dateKey(_now());

  /// 잔액 = 포인트 이력 합계.
  Future<int> balance() async {
    final sum = _db.pointHistory.amount.sum();
    final row = await (_db.selectOnly(
      _db.pointHistory,
    )..addColumns([sum])).getSingle();
    return row.read(sum) ?? 0;
  }

  /// 오늘 적립 합계(완료 지급 + 취소 차감). 지출은 빼고 계산한다.
  Future<int> todayEarned() async {
    final sum = _db.pointHistory.amount.sum();
    final query = _db.selectOnly(_db.pointHistory)
      ..addColumns([sum])
      ..where(
        _db.pointHistory.date.equals(_today) &
            _db.pointHistory.reason.isInValues([
              PointReason.completion,
              PointReason.cancel,
            ]),
      );
    final row = await query.getSingle();
    return row.read(sum) ?? 0;
  }

  /// 오늘 회차를 완료하고 지급한 포인트를 돌려준다(상한에 닿았으면 0).
  Future<int> complete(int todoId) => _db.transaction(() async {
    final today = _today;
    final todo =
        await (_db.select(_db.todos)
              ..where((t) => t.id.equals(todoId) & t.deletedAt.isNull()))
            .getSingleOrNull();
    if (todo == null) throw const TodoNotFound();

    if (todo.type == TodoType.checklist) {
      final items = await (_db.select(
        _db.checklistItems,
      )..where((i) => i.todoId.equals(todoId))).get();
      if (!PointRules.isChecklistComplete(items.map((i) => i.checked))) {
        throw const ChecklistIncomplete();
      }
    }

    final existing = await _findOccurrence(todoId, today);
    if (!PointRules.canComplete(existing?.status)) {
      throw const AlreadyCompleted();
    }

    final grant = PointRules.completionGrant(
      difficulty: todo.difficulty,
      todayEarned: await todayEarned(),
    );

    final now = _now();
    final int occurrenceId;
    if (existing == null) {
      occurrenceId = await _db
          .into(_db.todoOccurrences)
          .insert(
            TodoOccurrencesCompanion.insert(
              todoId: todoId,
              date: today,
              status: OccurrenceStatus.completed,
              completedAt: Value(now),
            ),
          );
    } else {
      occurrenceId = existing.id;
      await (_db.update(
        _db.todoOccurrences,
      )..where((o) => o.id.equals(existing.id))).write(
        TodoOccurrencesCompanion(
          status: const Value(OccurrenceStatus.completed),
          completedAt: Value(now),
        ),
      );
    }

    await _db
        .into(_db.pointHistory)
        .insert(
          PointHistoryCompanion.insert(
            amount: grant,
            reason: PointReason.completion,
            date: today,
            occurrenceId: Value(occurrenceId),
            createdAt: now,
          ),
        );
    return grant;
  });

  /// 오늘 완료한 회차를 취소하고 차감액(음수)을 돌려준다.
  Future<int> cancel(int todoId) => _db.transaction(() async {
    final today = _today;
    final occurrence = await _findOccurrence(todoId, today);
    if (occurrence == null ||
        !PointRules.canCancel(
          current: occurrence.status,
          completedDate: occurrence.date,
          today: today,
        )) {
      throw const CancelNotAllowed();
    }

    final lastGrant =
        await (_db.select(_db.pointHistory)
              ..where(
                (p) =>
                    p.occurrenceId.equals(occurrence.id) &
                    p.reason.equalsValue(PointReason.completion),
              )
              ..orderBy([(p) => OrderingTerm.desc(p.id)])
              ..limit(1))
            .getSingle();
    final deduction = PointRules.cancelDeduction(lastGrant.amount);

    await (_db.update(
      _db.todoOccurrences,
    )..where((o) => o.id.equals(occurrence.id))).write(
      const TodoOccurrencesCompanion(
        status: Value(OccurrenceStatus.canceled),
        completedAt: Value(null),
      ),
    );
    await _db
        .into(_db.pointHistory)
        .insert(
          PointHistoryCompanion.insert(
            amount: deduction,
            reason: PointReason.cancel,
            date: today,
            occurrenceId: Value(occurrence.id),
            createdAt: _now(),
          ),
        );
    return deduction;
  });

  /// 먹이 구매·입양 지출. 잔액이 모자라면 [InsufficientPoints].
  /// 호출하는 쪽의 트랜잭션 안에서 불러도 된다.
  Future<void> spend({
    required int price,
    required PointReason reason,
    required String itemId,
  }) => _db.transaction(() async {
    if (!PointRules.canSpend(balance: await balance(), price: price)) {
      throw const InsufficientPoints();
    }
    await _db
        .into(_db.pointHistory)
        .insert(
          PointHistoryCompanion.insert(
            amount: -price,
            reason: reason,
            date: _today,
            itemId: Value(itemId),
            createdAt: _now(),
          ),
        );
  });

  Future<TodoOccurrence?> _findOccurrence(int todoId, String date) =>
      (_db.select(_db.todoOccurrences)
            ..where((o) => o.todoId.equals(todoId) & o.date.equals(date)))
          .getSingleOrNull();
}

final pointServiceProvider = Provider<PointService>(
  (ref) => PointService(ref.watch(appDatabaseProvider), ref.watch(nowProvider)),
);
