import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/ui/day_change_watcher.dart';
import '../../../core/ui/main_tab.dart';
import '../../points/data/point_service.dart';
import '../data/todo_service.dart';

/// 오늘 목록. 날짜 넘김 처리가 끝난 뒤에 불러온다.
final todayTodosProvider = FutureProvider<List<TodayTodo>>((ref) async {
  await ref.watch(dayRolloverProvider.future);
  return ref.watch(todoServiceProvider).todayList();
});

/// 캘린더에서 고른 날짜의 할일.
final dateTodosProvider = FutureProvider.family<List<TodayTodo>, String>((
  ref,
  date,
) async {
  await ref.watch(dayRolloverProvider.future);
  return ref.watch(todoServiceProvider).listForDate(date);
});

/// 완료 기록.
final completedHistoryProvider = FutureProvider<List<CompletedTodo>>(
  (ref) => ref.watch(todoServiceProvider).completedHistory(),
);

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
  ref.invalidate(dateTodosProvider);
  ref.invalidate(completedHistoryProvider);
  ref.invalidate(balanceProvider);
  if (message != null) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 완료·취소·체크리스트 체크를 실행하고 포인트 문구를 보여준다.
/// [action]은 지급(양수)·차감(음수)한 포인트를 돌려주고, 포인트 변화가 없으면 null.
/// 앱에서 처음 포인트를 받은 순간이면 보상 안내를 한 번 띄운다 (PRD F6).
Future<void> runCompletion(
  BuildContext context,
  WidgetRef ref,
  Future<int?> Function() action,
) async {
  final isFirst = !await ref.read(pointServiceProvider).hasHistory();
  int? amount;
  if (!context.mounted) return;
  await runTodoAction(context, ref, () async {
    amount = await action();
    return amount == null ? null : pointMessage(amount!);
  });
  if (isFirst && (amount ?? 0) > 0 && context.mounted) {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('첫 포인트를 받았어요!'),
        content: const Text(
          '할일을 끝낼 때마다 포인트가 쌓여요.\n'
          '홈에서 포인트로 먹이를 사 줄 수 있어요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(mainTabProvider.notifier).select(MainTab.home);
            },
            child: const Text('홈으로 가기'),
          ),
        ],
      ),
    );
  }
}

/// 지급·차감 포인트 문구.
String pointMessage(int amount) => switch (amount) {
  > 0 => '+${amount}P',
  < 0 => '${amount}P',
  _ => '오늘 받을 수 있는 포인트를 다 받았어요',
};
