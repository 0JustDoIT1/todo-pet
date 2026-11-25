import '../../../core/date/date_key.dart';

/// 날짜 넘김 규칙 (PRD 3.4). 날짜는 'yyyy-MM-dd'.
abstract final class RolloverRules {
  /// 처리할 날짜 목록: 마지막 처리일 다음 날부터 어제까지.
  /// 처음 실행([lastProcessed]가 null)이면 처리할 날이 없다.
  static List<String> daysToProcess({
    required String? lastProcessed,
    required String today,
  }) {
    if (lastProcessed == null) return const [];
    final count = daysBetween(lastProcessed, today) - 1;
    return [for (var i = 1; i <= count; i++) addDays(lastProcessed, i)];
  }
}
