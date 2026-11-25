import '../../../core/date/date_key.dart';
import '../../../core/error/app_exception.dart';
import 'todo_enums.dart';

/// 할일 등록·수정 입력값 (PRD 3.1).
class TodoDraft {
  const TodoDraft({
    required this.type,
    required this.title,
    this.difficulty = Difficulty.low,
    this.categoryId,
    this.date,
    this.repeatWeekdays,
    this.items = const [],
  });

  final TodoType type;
  final String title;
  final Difficulty difficulty;
  final String? categoryId;

  /// 원타임·체크리스트의 날짜 ('yyyy-MM-dd').
  final String? date;

  /// 반복 요일 비트마스크 (월=1 … 일=64, 매일=127).
  final int? repeatWeekdays;

  /// 체크리스트 하위항목 제목.
  final List<String> items;
}

/// 할일 규칙 (PRD 3.1). 순수 함수만 둔다. 날짜는 'yyyy-MM-dd'.
abstract final class TodoRules {
  static const everyDay = 127;

  /// 입력값 검증. 문제가 있으면 [InvalidTodo].
  static void validate(TodoDraft draft) {
    if (draft.title.trim().isEmpty) {
      throw const InvalidTodo('제목을 입력해 주세요.');
    }
    switch (draft.type) {
      case TodoType.oneTime:
        if (draft.date == null) throw const InvalidTodo('날짜를 정해 주세요.');
      case TodoType.checklist:
        if (draft.date == null) throw const InvalidTodo('날짜를 정해 주세요.');
        if (draft.items.where((i) => i.trim().isNotEmpty).isEmpty) {
          throw const InvalidTodo('하위항목을 하나 이상 추가해 주세요.');
        }
      case TodoType.repeat:
        final mask = draft.repeatWeekdays ?? 0;
        if (mask <= 0 || mask > everyDay) {
          throw const InvalidTodo('반복할 요일을 골라 주세요.');
        }
    }
  }

  /// 반복 할일이 [date]에 해당하는지 (시작일 이후 + 요일 일치).
  static bool isRepeatDueOn({
    required int repeatWeekdays,
    required String startDate,
    required String date,
  }) =>
      daysBetween(startDate, date) >= 0 &&
      repeatWeekdays & weekdayBit(date) != 0;

  /// 오늘 완료할 수 있는지. 원타임·체크리스트는 오늘 또는 지난 날짜(이월)만,
  /// 반복은 오늘 해당하는 회차만 완료할 수 있다. 미래 날짜는 완료할 수 없다.
  static bool canCompleteToday({
    required TodoType type,
    required String? date,
    required int? repeatWeekdays,
    required String startDate,
    required String today,
  }) => switch (type) {
    TodoType.repeat => isRepeatDueOn(
      repeatWeekdays: repeatWeekdays ?? 0,
      startDate: startDate,
      date: today,
    ),
    _ => date != null && daysBetween(date, today) >= 0,
  };

  /// "N일 지연" 일수. 처음 정한 날짜보다 오늘이 늦은 만큼 (0 이하이면 0).
  static int delayDays({required String? originalDate, required String today}) {
    if (originalDate == null) return 0;
    final days = daysBetween(originalDate, today);
    return days > 0 ? days : 0;
  }
}
