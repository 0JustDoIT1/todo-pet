import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/todo/data/day_rollover_service.dart';
import '../date/now_provider.dart';

/// 날짜 넘김 처리 결과. 이 Provider를 다시 계산하면 처리가 한 번 더 돈다.
/// 날짜에 따라 달라지는 목록 Provider는 이것을 watch한다.
final dayRolloverProvider = FutureProvider<void>(
  (ref) => ref.watch(dayRolloverServiceProvider).run(),
);

/// 앱을 다시 열 때와 켜 둔 채 자정을 넘길 때 날짜 넘김을 다시 처리한다 (PRD 3.4).
class DayChangeWatcher extends ConsumerStatefulWidget {
  const DayChangeWatcher({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DayChangeWatcher> createState() => _DayChangeWatcherState();
}

class _DayChangeWatcherState extends ConsumerState<DayChangeWatcher> {
  late final AppLifecycleListener _lifecycle;
  Timer? _midnight;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refresh);
    _scheduleMidnight();
  }

  void _refresh() {
    ref.invalidate(dayRolloverProvider);
    _scheduleMidnight();
  }

  void _scheduleMidnight() {
    _midnight?.cancel();
    final now = ref.read(nowProvider)();
    final next = DateTime(now.year, now.month, now.day + 1);
    // 자정 직후에 처리되도록 1초 여유를 둔다.
    _midnight = Timer(
      next.difference(now) + const Duration(seconds: 1),
      _refresh,
    );
  }

  @override
  void dispose() {
    _midnight?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
