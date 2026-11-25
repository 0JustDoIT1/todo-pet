import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/date/date_key.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/todo/domain/todo_enums.dart';
import 'package:todo_pet/features/todo/domain/todo_rules.dart';

const wed = '2026-11-25';
const monBit = 1, wedBit = 4;

void main() {
  group('날짜 유틸', () {
    test('2026-11-25는 수요일 비트(4)', () {
      expect(weekdayBit(wed), wedBit);
      expect(weekdayBit('2026-11-23'), monBit);
      expect(weekdayBit('2026-11-29'), 64); // 일요일
    });

    test('daysBetween은 월·연 경계를 넘어도 일수를 센다', () {
      expect(daysBetween('2026-12-30', '2027-01-02'), 3);
      expect(daysBetween(wed, '2026-11-24'), -1);
    });
  });

  group('validate', () {
    void expectInvalid(TodoDraft draft) =>
        expect(() => TodoRules.validate(draft), throwsA(isA<InvalidTodo>()));

    test('제목이 비면 거부', () {
      expectInvalid(
        const TodoDraft(type: TodoType.oneTime, title: '  ', date: wed),
      );
    });

    test('원타임은 날짜가 필요하다', () {
      expectInvalid(const TodoDraft(type: TodoType.oneTime, title: '물'));
    });

    test('체크리스트는 하위항목이 하나 이상 필요하다 (공백 항목은 세지 않음)', () {
      expectInvalid(
        const TodoDraft(
          type: TodoType.checklist,
          title: '장보기',
          date: wed,
          items: [' '],
        ),
      );
    });

    test('반복은 요일이 하나 이상 필요하다', () {
      expectInvalid(
        const TodoDraft(type: TodoType.repeat, title: '운동', repeatWeekdays: 0),
      );
      expectInvalid(
        const TodoDraft(
          type: TodoType.repeat,
          title: '운동',
          repeatWeekdays: 128,
        ),
      );
    });

    test('올바른 입력은 통과한다', () {
      TodoRules.validate(
        const TodoDraft(
          type: TodoType.repeat,
          title: '운동',
          repeatWeekdays: TodoRules.everyDay,
        ),
      );
    });
  });

  group('canCompleteToday', () {
    bool oneTime(String date) => TodoRules.canCompleteToday(
      type: TodoType.oneTime,
      date: date,
      repeatWeekdays: null,
      startDate: '2026-11-20',
      today: wed,
    );

    test('원타임: 오늘·지난 날짜는 가능, 미래는 불가', () {
      expect(oneTime(wed), isTrue);
      expect(oneTime('2026-11-23'), isTrue);
      expect(oneTime('2026-11-26'), isFalse);
    });

    test('반복: 오늘 요일이 포함되고 시작일 이후일 때만 가능', () {
      bool repeat(int mask, String start) => TodoRules.canCompleteToday(
        type: TodoType.repeat,
        date: null,
        repeatWeekdays: mask,
        startDate: start,
        today: wed,
      );
      expect(repeat(wedBit, wed), isTrue);
      expect(repeat(monBit, wed), isFalse);
      expect(repeat(wedBit, '2026-11-26'), isFalse);
    });
  });

  group('delayDays', () {
    test('처음 날짜보다 늦은 일수, 미래·없음은 0', () {
      expect(TodoRules.delayDays(originalDate: '2026-11-22', today: wed), 3);
      expect(TodoRules.delayDays(originalDate: wed, today: wed), 0);
      expect(TodoRules.delayDays(originalDate: '2026-11-30', today: wed), 0);
      expect(TodoRules.delayDays(originalDate: null, today: wed), 0);
    });
  });
}
