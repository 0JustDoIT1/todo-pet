import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/pet/domain/foods.dart';
import 'package:todo_pet/features/pet/domain/pet_rules.dart';

void main() {
  final t0 = DateTime(2026, 11, 25, 9);

  PetStats decayedAfter(Duration d, {int hunger = 100, int mood = 100}) =>
      PetRules.decayed(
        hunger: hunger,
        mood: mood,
        lastUpdatedAt: t0,
        now: t0.add(d),
      );

  group('시간 경과 감소', () {
    test('배고픔은 24시간에 100 → 0, 12시간이면 50', () {
      expect(decayedAfter(const Duration(hours: 24)).hungerValue, 0);
      expect(decayedAfter(const Duration(hours: 12)).hungerValue, 50);
    });

    test('기분은 시간당 2씩 준다', () {
      expect(decayedAfter(const Duration(hours: 10)).moodValue, 80);
    });

    test('0 아래로 내려가지 않는다 (벌칙 없음)', () {
      final s = decayedAfter(const Duration(days: 7));
      expect(s.hungerValue, 0);
      expect(s.moodValue, 0);
    });

    test('짧은 시간의 감소도 실수로 계산해 버려지지 않는다', () {
      // 10분 = 약 0.69 감소. 정수로 버리면 0이 된다.
      final s = decayedAfter(const Duration(minutes: 10));
      expect(s.hunger, closeTo(100 - 10 / 60 * 100 / 24, 0.0001));
    });

    test('시계가 뒤로 가면 감소하지 않는다', () {
      expect(decayedAfter(const Duration(hours: -3)).hungerValue, 100);
    });
  });

  group('먹이', () {
    final basic = foodById('basic')!;

    test('기획서 가격·효과: 기본 사료 10P, 배고픔 +20, 기분 +5', () {
      expect(basic.price, 10);
      expect(basic.hunger, 20);
      expect(basic.mood, 5);
      expect(foodById('snack')!.price, 30);
      expect(foodById('special')!.price, 100);
    });

    test('먹은 뒤 수치는 100을 넘지 않는다', () {
      final after = PetRules.afterFood(
        const PetStats(hunger: 90, mood: 98),
        basic,
      );
      expect(after.hungerValue, 100);
      expect(after.moodValue, 100);
    });

    test('배고픔이 100이면 먹일 수 없다', () {
      expect(PetRules.canFeed(const PetStats(hunger: 100, mood: 50)), isFalse);
      expect(PetRules.canFeed(const PetStats(hunger: 99, mood: 50)), isTrue);
    });
  });

  group('탭', () {
    test('하루 10회까지 수치가 오르고, 날짜가 바뀌면 다시 셀 수 있다', () {
      bool can(int count, String? date) => PetRules.canGainFromTap(
        tapCount: count,
        tapDate: date,
        today: '2026-11-25',
      );
      expect(can(9, '2026-11-25'), isTrue);
      expect(can(10, '2026-11-25'), isFalse);
      expect(can(10, '2026-11-24'), isTrue);
      expect(can(0, null), isTrue);
    });
  });

  group('성장', () {
    test('애정도 50 이상이면 2단계, 단계는 내려가지 않고 2단계가 끝', () {
      expect(PetRules.stageFor(stage: 1, affection: 49), 1);
      expect(PetRules.stageFor(stage: 1, affection: 50), 2);
      expect(PetRules.stageFor(stage: 2, affection: 10), 2);
      expect(PetRules.stageFor(stage: 2, affection: 999), 2);
    });
  });

  group('표정', () {
    PetExpression exp(double hunger, double mood) =>
        PetRules.expression(PetStats(hunger: hunger, mood: mood));

    test('배고픔 30 이하가 가장 먼저, 그다음 기분 70 이상이면 기쁨', () {
      expect(exp(30, 90), PetExpression.hungry);
      expect(exp(31, 70), PetExpression.happy);
      expect(exp(31, 69), PetExpression.neutral);
    });
  });

  group('이름', () {
    test('앞뒤 공백을 빼고 1~10자 (한글도 한 글자 = 1)', () {
      expect(PetRules.validateName(' 나비 '), '나비');
      expect(PetRules.validateName('가나다라마바사아자차'), '가나다라마바사아자차');
      expect(
        () => PetRules.validateName('가나다라마바사아자차카'),
        throwsA(isA<InvalidPetName>()),
      );
      expect(() => PetRules.validateName('  '), throwsA(isA<InvalidPetName>()));
    });
  });
}
