import '../../../core/error/app_exception.dart';
import 'foods.dart';

/// 펫 표정 (PRD 3.5). 눈 감음은 화면에서 기본 표정과 교대로 쓴다.
enum PetExpression { neutral, happy, hungry }

/// 시간 경과를 반영한 현재 수치. 저장값은 정수지만 계산은 실수로 한다.
class PetStats {
  const PetStats({required this.hunger, required this.mood});

  final double hunger;
  final double mood;

  int get hungerValue => PetRules.toDisplay(hunger);
  int get moodValue => PetRules.toDisplay(mood);
}

/// 펫 상태 규칙 (PRD 3.3, 기획서 3.2·3.4). 순수 함수만 둔다.
/// '초기값'이라고 적은 수치는 기획서에 없어 정한 값이며 조정할 수 있다.
abstract final class PetRules {
  static const initialStat = 80;
  static const maxStat = 100;

  /// 배고픔: 24시간에 100 → 0 (기획서 3.4).
  static const hungerPerHour = 100 / 24;

  /// 기분: 50시간에 100 → 0. 초기값.
  static const moodPerHour = 2.0;

  /// 탭: 하루 10회까지 기분 +2, 애정도 +1. 기분 +2·애정도 +1은 초기값.
  static const dailyTapLimit = 10;
  static const tapMood = 2;
  static const tapAffection = 1;

  /// 애정도 50 이상이면 2단계 (기획서 3.2). Phase 1은 2단계까지.
  static const stage2Affection = 50;
  static const maxStagePhase1 = 2;

  static const nameMaxLength = 10;

  /// 마지막 갱신 시각부터 지난 시간만큼 줄인 현재 수치.
  static PetStats decayed({
    required int hunger,
    required int mood,
    required DateTime lastUpdatedAt,
    required DateTime now,
  }) {
    final elapsed = now.difference(lastUpdatedAt);
    final hours = elapsed.isNegative
        ? 0.0
        : elapsed.inSeconds / Duration.secondsPerHour;
    return PetStats(
      hunger: _clamp(hunger - hours * hungerPerHour),
      mood: _clamp(mood - hours * moodPerHour),
    );
  }

  /// 저장·표시용 정수 (0~100).
  static int toDisplay(double value) => value.round().clamp(0, maxStat);

  /// 배고픔이 가득 차(100) 있으면 먹이를 살 수 없다 (PRD 3.3).
  static bool canFeed(PetStats stats) => stats.hungerValue < maxStat;

  /// 먹이를 먹은 뒤 수치.
  static PetStats afterFood(PetStats stats, FoodItem food) => PetStats(
    hunger: _clamp(stats.hunger + food.hunger),
    mood: _clamp(stats.mood + food.mood),
  );

  /// 오늘 탭으로 기분을 더 올릴 수 있는지. [tapDate]가 오늘이 아니면 횟수는 0부터.
  static bool canGainFromTap({
    required int tapCount,
    required String? tapDate,
    required String today,
  }) => tapDate != today || tapCount < dailyTapLimit;

  /// 오늘 탭 횟수 (날짜가 바뀌었으면 0).
  static int tapsToday({
    required int tapCount,
    required String? tapDate,
    required String today,
  }) => tapDate == today ? tapCount : 0;

  /// 애정도에 따른 단계. 단계는 내려가지 않는다.
  static int stageFor({required int stage, required int affection}) {
    final byAffection = affection >= stage2Affection ? 2 : 1;
    final next = byAffection > stage ? byAffection : stage;
    return next > maxStagePhase1 ? maxStagePhase1 : next;
  }

  /// 표정 선택: 배고픔 30 이하 → 배고픔, 기분 70 이상 → 기쁨, 그 외 기본.
  static PetExpression expression(PetStats stats) {
    if (stats.hungerValue <= 30) return PetExpression.hungry;
    if (stats.moodValue >= 70) return PetExpression.happy;
    return PetExpression.neutral;
  }

  /// 이름 검증(앞뒤 공백 제거 후 1~10자). 정리한 이름을 돌려준다.
  static String validateName(String name) {
    final trimmed = name.trim();
    // 글자 수는 유니코드 코드포인트 기준 (한글 한 글자 = 1).
    if (trimmed.isEmpty || trimmed.runes.length > nameMaxLength) {
      throw const InvalidPetName();
    }
    return trimmed;
  }

  static double _clamp(double v) => v.clamp(0, maxStat.toDouble());
}
