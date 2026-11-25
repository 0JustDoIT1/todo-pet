/// 도메인 규칙 위반. 화면은 이 예외를 잡아 [message]로 안내한다.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// 사용자에게 보여줄 한국어 문구.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class TodoNotFound extends AppException {
  const TodoNotFound() : super('할일을 찾을 수 없어요.');
}

class AlreadyCompleted extends AppException {
  const AlreadyCompleted() : super('이미 완료한 할일이에요.');
}

class ChecklistIncomplete extends AppException {
  const ChecklistIncomplete() : super('모든 항목을 체크해야 완료할 수 있어요.');
}

class CancelNotAllowed extends AppException {
  const CancelNotAllowed() : super('완료 취소는 완료한 날에만 할 수 있어요.');
}

class InsufficientPoints extends AppException {
  const InsufficientPoints() : super('포인트가 부족해요.');
}

/// 할일 입력값이 규칙에 맞지 않음. 문구는 원인별로 넘긴다.
class InvalidTodo extends AppException {
  const InvalidTodo(super.message);
}

class TodoNotDueToday extends AppException {
  const TodoNotDueToday() : super('오늘 할일만 완료할 수 있어요.');
}

class TodoLocked extends AppException {
  const TodoLocked() : super('완료한 할일은 수정할 수 없어요. 완료를 취소한 뒤 수정해 주세요.');
}
