import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../points/domain/point_rules.dart';
import '../data/todo_service.dart';
import '../domain/categories.dart';
import '../domain/todo_enums.dart';
import 'date_label.dart';
import 'todo_form_sheet.dart';
import 'todo_providers.dart';

/// 할일 화면 (PRD F2, 기획서 5.2): 오늘 / 캘린더 / 완료.
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider).value;
    final today = dateKey(ref.watch(nowProvider)());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('할일 · ${dateLabel(today)}'),
          actions: [
            if (balance != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: const Icon(Icons.stars, size: 18),
                  label: Text('${balance}P'),
                ),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: '오늘'),
              Tab(text: '캘린더'),
              Tab(text: '완료'),
            ],
          ),
        ),
        // 탭 위치를 읽으려고 DefaultTabController 아래 context를 쓴다.
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            tooltip: '할일 추가',
            onPressed: () =>
                _add(context, ref, _defaultDate(context, ref, today)),
            child: const Icon(Icons.add),
          ),
        ),
        body: TabBarView(
          children: [
            _TodayTab(today: today),
            _CalendarTab(today: today),
            const _HistoryTab(),
          ],
        ),
      ),
    );
  }

  /// 새 할일의 기본 날짜: 캘린더 탭에서 오늘 이후 날짜를 골랐으면 그 날짜, 아니면 오늘.
  /// 지난 날짜를 기본으로 하면 바로 지연 할일이 되므로 오늘로 둔다.
  String _defaultDate(BuildContext context, WidgetRef ref, String today) {
    final onCalendar = DefaultTabController.of(context).index == 1;
    final selected = ref.read(calendarDateProvider);
    if (!onCalendar || selected == null) return today;
    return daysBetween(today, selected) > 0 ? selected : today;
  }

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    String defaultDate,
  ) async {
    final result = await showTodoForm(context, defaultDate: defaultDate);
    final draft = result?.draft;
    if (draft == null || !context.mounted) return;
    await runTodoAction(context, ref, () async {
      await ref.read(todoServiceProvider).add(draft);
      return '할일을 추가했어요';
    });
  }
}

class _TodayTab extends ConsumerWidget {
  const _TodayTab({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todayTodosProvider);
    return Column(
      children: [
        const _QuickAddField(),
        Expanded(
          child: todos.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('불러오지 못했어요: $e')),
            data: (items) => items.isEmpty
                ? const Center(child: Text('오늘 할일을 등록해 보세요'))
                : ListView(
                    padding: const EdgeInsets.only(bottom: 88),
                    children: [
                      for (final item in items)
                        _TodoTile(item: item, today: today),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// 캘린더: 날짜를 고르면 그날 할일. 오늘만 완료할 수 있고 다른 날은 보기만 한다.
class _CalendarTab extends ConsumerStatefulWidget {
  const _CalendarTab({required this.today});

  final String today;

  @override
  ConsumerState<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<_CalendarTab> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(calendarDateProvider) ?? widget.today;
    final p = selected.split('-').map(int.parse).toList();
    final isToday = selected == widget.today;
    final todos = ref.watch(dateTodosProvider(selected));

    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        CalendarDatePicker(
          initialDate: DateTime(p[0], p[1], p[2]),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (d) =>
              ref.read(calendarDateProvider.notifier).select(keyFromDate(d)),
        ),
        const Divider(height: 1),
        ListTile(
          title: Text(
            dateLabel(selected),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...todos.when(
          loading: () => [const Center(child: CircularProgressIndicator())],
          error: (e, _) => [Text('불러오지 못했어요: $e')],
          data: (items) => items.isEmpty
              ? [const ListTile(title: Text('이날 할일이 없어요'))]
              : [
                  for (final item in items)
                    isToday
                        ? _TodoTile(item: item, today: widget.today)
                        : _ReadOnlyTile(item: item),
                ],
        ),
      ],
    );
  }
}

/// 오늘이 아닌 날의 할일 (보기만).
class _ReadOnlyTile extends StatelessWidget {
  const _ReadOnlyTile({required this.item});

  final TodayTodo item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, label, color) = switch (item.status) {
      OccurrenceStatus.completed => (Icons.check_circle, '완료', scheme.primary),
      OccurrenceStatus.absent => (Icons.cancel_outlined, '결석', scheme.error),
      OccurrenceStatus.canceled => (Icons.undo, '취소', scheme.outline),
      null => (Icons.circle_outlined, '예정', scheme.outline),
    };
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(item.todo.title),
      subtitle: Text(
        '$label · ${PointRules.basePoints(item.todo.difficulty)}P'
        '${item.todo.deletedAt != null ? ' · 삭제됨' : ''}',
      ),
    );
  }
}

/// 완료 기록: 최근 완료한 순서, 날짜별로 묶는다.
class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(completedHistoryProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('불러오지 못했어요: $e')),
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('아직 완료한 할일이 없어요'));
            }
            final theme = Theme.of(context);
            final children = <Widget>[];
            String? lastDate;
            for (final h in items) {
              if (h.date != lastDate) {
                lastDate = h.date;
                children.add(
                  ListTile(
                    title: Text(
                      dateLabel(h.date),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                );
              }
              final t = h.completedAt.toLocal();
              children.add(
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(h.todo.title),
                  trailing: Text(
                    '${t.hour.toString().padLeft(2, '0')}:'
                    '${t.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: children,
            );
          },
        );
  }
}

class _QuickAddField extends ConsumerStatefulWidget {
  const _QuickAddField();

  @override
  ConsumerState<_QuickAddField> createState() => _QuickAddFieldState();
}

class _QuickAddFieldState extends ConsumerState<_QuickAddField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text;
    if (title.trim().isEmpty) return;
    await runTodoAction(context, ref, () async {
      await ref.read(todoServiceProvider).quickAdd(title);
      _controller.clear();
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: '빠르게 추가 (오늘 · 중 10P)',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            tooltip: '추가',
            onPressed: _submit,
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.item, required this.today});

  final TodayTodo item;
  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = item.todo;
    final service = ref.read(todoServiceProvider);
    final theme = Theme.of(context);
    final done = item.isCompleted;

    final checkbox = Checkbox(
      value: done,
      onChanged: (checked) => runCompletion(
        context,
        ref,
        checked == true
            ? () => service.complete(todo.id)
            : () => service.cancel(todo.id),
      ),
    );

    final title = Text(
      todo.title,
      style: done
          ? TextStyle(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.outline,
            )
          : null,
    );

    final subtitle = Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${PointRules.basePoints(todo.difficulty)}P'),
        if (todo.type == TodoType.repeat)
          _Badge(weekdaysLabel(todo.repeatWeekdays ?? 0)),
        if (todo.type == TodoType.checklist)
          _Badge(
            '체크리스트 ${item.items.where((i) => i.checked).length}/${item.items.length}',
          ),
        if (categoryById(todo.categoryId) case final c?) _Badge(c.name),
        if (item.delayDays > 0)
          _Badge('${item.delayDays}일 지연', color: theme.colorScheme.error),
      ],
    );

    final edit = IconButton(
      tooltip: '수정',
      icon: const Icon(Icons.edit_outlined),
      onPressed: () => _edit(context, ref),
    );

    if (todo.type != TodoType.checklist) {
      return ListTile(
        leading: checkbox,
        title: title,
        subtitle: subtitle,
        trailing: edit,
      );
    }

    return ExpansionTile(
      leading: checkbox,
      title: title,
      subtitle: subtitle,
      trailing: edit,
      childrenPadding: const EdgeInsets.only(left: 40),
      children: [
        for (final i in item.items)
          CheckboxListTile(
            dense: true,
            value: i.checked,
            title: Text(i.title),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) => runCompletion(
              context,
              ref,
              () => service.setItemChecked(i.id, checked ?? false),
            ),
          ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final result = await showTodoForm(
      context,
      defaultDate: today,
      initial: item.todo,
      initialItems: item.items,
    );
    if (result == null || !context.mounted) return;
    final service = ref.read(todoServiceProvider);
    await runTodoAction(context, ref, () async {
      if (result.delete) {
        await service.delete(item.todo.id);
        return '할일을 삭제했어요';
      }
      await service.update(item.todo.id, result.draft!);
      return '수정했어요';
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: c)),
    );
  }
}
