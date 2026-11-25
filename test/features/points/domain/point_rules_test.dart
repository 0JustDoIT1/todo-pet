import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/features/points/domain/point_rules.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';

void main() {
  group('basePoints', () {
    test('난이도 하/중/상은 5/10/20P', () {
      expect(PointRules.basePoints(Difficulty.low), 5);
      expect(PointRules.basePoints(Difficulty.mid), 10);
      expect(PointRules.basePoints(Difficulty.high), 20);
    });
  });

  group('completionGrant (일일 상한 100P)', () {
    test('상한 여유가 충분하면 기본 포인트를 지급한다', () {
      expect(
        PointRules.completionGrant(difficulty: Difficulty.high, todayEarned: 0),
        20,
      );
    });

    test('상한까지 남은 만큼만 지급한다', () {
      expect(
        PointRules.completionGrant(
          difficulty: Difficulty.high,
          todayEarned: 95,
        ),
        5,
      );
    });

    test('상한에 닿았으면 0P', () {
      expect(
        PointRules.completionGrant(
          difficulty: Difficulty.low,
          todayEarned: 100,
        ),
        0,
      );
    });

    test('취소 차감이 반영된 합계 기준이라 취소하면 다시 여유가 생긴다', () {
      // 100P 적립 후 20P 취소 → 오늘 합계 80
      expect(
        PointRules.completionGrant(
          difficulty: Difficulty.high,
          todayEarned: 100 - 20,
        ),
        20,
      );
    });
  });

  group('완료와 취소', () {
    test('완료된 회차는 다시 완료할 수 없고, 미완료·취소 회차는 완료할 수 있다', () {
      expect(PointRules.canComplete(OccurrenceStatus.completed), isFalse);
      expect(PointRules.canComplete(null), isTrue);
      expect(PointRules.canComplete(OccurrenceStatus.canceled), isTrue);
    });

    test('취소는 완료한 날 당일에만 가능하다', () {
      expect(
        PointRules.canCancel(
          current: OccurrenceStatus.completed,
          completedDate: '2026-11-25',
          today: '2026-11-25',
        ),
        isTrue,
      );
      expect(
        PointRules.canCancel(
          current: OccurrenceStatus.completed,
          completedDate: '2026-11-24',
          today: '2026-11-25',
        ),
        isFalse,
      );
    });

    test('완료되지 않은 회차는 취소할 수 없다', () {
      expect(
        PointRules.canCancel(
          current: OccurrenceStatus.canceled,
          completedDate: '2026-11-25',
          today: '2026-11-25',
        ),
        isFalse,
      );
    });

    test('취소 차감액은 지급 당시 금액이다 (상한으로 0P였으면 0)', () {
      expect(PointRules.cancelDeduction(20), -20);
      expect(PointRules.cancelDeduction(0), 0);
    });
  });

  group('중복 지급 검사', () {
    test('지급 → 취소 → 재지급 흐름의 합계는 정상이다', () {
      const grant = 10;
      var net = grant; // 지급
      expect(
        PointRules.isOccurrenceBalanceValid(netAmount: net, lastGrant: grant),
        isTrue,
      );
      net += PointRules.cancelDeduction(grant); // 취소
      expect(
        PointRules.isOccurrenceBalanceValid(netAmount: net, lastGrant: grant),
        isTrue,
      );
      net += grant; // 재완료
      expect(
        PointRules.isOccurrenceBalanceValid(netAmount: net, lastGrant: grant),
        isTrue,
      );
    });

    test('취소 없이 두 번 지급되면 비정상이다', () {
      expect(
        PointRules.isOccurrenceBalanceValid(netAmount: 20, lastGrant: 10),
        isFalse,
      );
    });
  });

  group('지출', () {
    test('잔액이 가격 이상이어야 살 수 있다', () {
      expect(PointRules.canSpend(balance: 5, price: 5), isTrue);
      expect(PointRules.canSpend(balance: 4, price: 5), isFalse);
    });

    test('잔액이 음수면 살 수 없다', () {
      expect(PointRules.canSpend(balance: -5, price: 0), isFalse);
    });
  });

  group('체크리스트 완료', () {
    test('모든 하위항목이 체크되면 완료', () {
      expect(PointRules.isChecklistComplete([true, true]), isTrue);
      expect(PointRules.isChecklistComplete([true, false]), isFalse);
    });

    test('하위항목이 없으면 완료가 아니다', () {
      expect(PointRules.isChecklistComplete([]), isFalse);
    });
  });
}
