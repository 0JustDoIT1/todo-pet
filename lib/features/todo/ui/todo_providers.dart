import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/ui/day_change_watcher.dart';
import '../../points/data/point_service.dart';
import '../data/todo_service.dart';

/// 오늘 목록. 날짜 넘김 처리가 끝난 뒤에 불러온다.
final todayTodosProvider = FutureProvider<List<TodayTodo>>((ref) async {
  await ref.watch(dayRolloverProvider.future);
  return ref.watch(todoServiceProvider).todayList();
});

/// 포인트 잔액.
final balanceProvider = FutureProvider<int>(
  (ref) => ref.watch(pointServiceProvider).balance(),
);

/// 할일 관련 동작을 실행하고, 결과 문구나 오류 문구를 SnackBar로 보여준 뒤 목록·잔액을 새로 고친다.
Future<void> runTodoAction(
  BuildContext context,
  WidgetRef ref,
  Future<String?> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  String? message;
  try {
    message = await action();
  } on AppException catch (e) {
    message = e.message;
  }
  ref.invalidate(todayTodosProvider);
  ref.invalidate(balanceProvider);
  if (message != null) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 지급·차감 포인트 문구.
String pointMessage(int amount) => switch (amount) {
  > 0 => '+${amount}P',
  < 0 => '${amount}P',
  _ => '오늘 받을 수 있는 포인트를 다 받았어요',
};
