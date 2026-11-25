import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/date/date_key.dart';
import 'package:todo_pet/features/todo/domain/rollover_rules.dart';

void main() {
  test('addDays는 월·연 경계를 넘는다', () {
    expect(addDays('2026-12-31', 1), '2027-01-01');
    expect(addDays('2026-03-01', -1), '2026-02-28');
  });

  group('daysToProcess', () {
    test('처음 실행이면 처리할 날이 없다', () {
      expect(
        RolloverRules.daysToProcess(lastProcessed: null, today: '2026-11-25'),
        isEmpty,
      );
    });

    test('어제까지 처리했으면 처리할 날이 없다', () {
      expect(
        RolloverRules.daysToProcess(
          lastProcessed: '2026-11-24',
          today: '2026-11-25',
        ),
        isEmpty,
      );
    });

    test('며칠 안 열었으면 마지막 처리일 다음 날부터 어제까지', () {
      expect(
        RolloverRules.daysToProcess(
          lastProcessed: '2026-11-21',
          today: '2026-11-25',
        ),
        ['2026-11-22', '2026-11-23', '2026-11-24'],
      );
    });

    test('기기 시계가 뒤로 가면 처리할 날이 없다', () {
      expect(
        RolloverRules.daysToProcess(
          lastProcessed: '2026-11-28',
          today: '2026-11-25',
        ),
        isEmpty,
      );
    });
  });
}
