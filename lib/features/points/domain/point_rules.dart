import '../../todo/domain/todo_enums.dart';

/// 포인트 정산 규칙 (PRD 3.2). Flutter·DB에 의존하지 않는 순수 함수만 둔다.
/// 날짜는 현지 기준 'yyyy-MM-dd' 문자열이다.
abstract final class PointRules {
  /// 일일 적립 상한.
  static const dailyCap = 100;

  /// 난이도별 완료 포인트 (하/중/상 = 5/10/20).
  static int basePoints(Difficulty difficulty) => switch (difficulty) {
    Difficulty.low => 5,
    Difficulty.mid => 10,
    Difficulty.high => 20,
  };

  /// 완료 시 지급할 포인트.
  ///
  /// [todayEarned]는 오늘 날짜의 완료 지급과 취소 차감을 합한 값이다(먹이·입양 지출은 빼고 계산).
  /// 상한을 넘는 부분은 지급하지 않고, 상한에 이미 닿았으면 0을 돌려준다(0P로 기록).
  static int completionGrant({
    required Difficulty difficulty,
    required int todayEarned,
  }) {
    final remaining = dailyCap - todayEarned;
    if (remaining <= 0) return 0;
    final base = basePoints(difficulty);
    return base < remaining ? base : remaining;
  }

  /// 회차를 완료 처리할 수 있는지. 이미 완료된 회차는 다시 지급하지 않는다.
  /// 취소한 회차는 다시 완료할 수 있다.
  static bool canComplete(OccurrenceStatus? current) =>
      current != OccurrenceStatus.completed;

  /// 완료 취소는 완료한 날 당일에만 할 수 있다.
  static bool canCancel({
    required OccurrenceStatus? current,
    required String completedDate,
    required String today,
  }) => current == OccurrenceStatus.completed && completedDate == today;

  /// 취소 시 차감액. 지급 당시 금액만큼 음수로 기록한다.
  static int cancelDeduction(int grantedAmount) => -grantedAmount;

  /// 구매 가능 여부. 잔액이 음수이거나 가격보다 적으면 살 수 없다.
  static bool canSpend({required int balance, required int price}) =>
      balance >= price;

  /// 체크리스트는 하위항목이 하나 이상 있고 모두 체크됐을 때 완료된다.
  static bool isChecklistComplete(Iterable<bool> checked) =>
      checked.isNotEmpty && checked.every((c) => c);

  /// 한 회차에 걸린 포인트 이력 합계가 정상인지 (중복 지급 검사).
  /// 정상은 0(미지급 또는 취소됨)이거나 마지막 지급액과 같을 때다.
  static bool isOccurrenceBalanceValid({
    required int netAmount,
    required int lastGrant,
  }) => netAmount == 0 || netAmount == lastGrant;
}
