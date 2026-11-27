import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../../core/ui/app_theme.dart';
import '../../../core/ui/pill_tab_bar.dart';
import '../../../core/ui/point_pill.dart';
import '../../pet/ui/pet_providers.dart';
import '../../pet/ui/pet_sprite.dart';
import '../../points/domain/point_rules.dart';
import '../data/todo_service.dart';
import '../domain/categories.dart';
import '../domain/todo_enums.dart';
import 'category_style.dart';
import 'date_label.dart';
import 'todo_form_sheet.dart';
import 'todo_providers.dart';

/// 할일 화면 (PRD F2): 오늘 / 캘린더 / 완료. 등록은 '새 할 일 추가하기' 줄에서.
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
          title: const Text('할일'),
          actions: [
            if (balance != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PointPill(balance),
              ),
          ],
          bottom: const PillTabBar(labels: ['오늘', '캘린더', '완료']),
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
}

/// 등록 화면을 열고, 저장하면 추가한다.
Future<void> _addTodo(
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

/// '새 할 일 추가하기' 줄.
class _AddRow extends ConsumerWidget {
  const _AddRow({required this.date});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
    child: Material(
      color: AppColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.line, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _addTodo(context, ref, date),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              Text(
                '새 할 일 추가하기',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.inkSoft),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// 오늘 진행률 카드: 날짜, 완료/전체, 막대, 활성 펫 얼굴.
class _ProgressCard extends ConsumerWidget {
  const _ProgressCard({required this.today, required this.items});

  final String today;
  final List<TodayTodo> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = items.where((t) => t.isCompleted).length;
    final total = items.length;
    final pet = ref.watch(activePetProvider).value;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    dateLabel(today),
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.inkSoft,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: textTheme.titleLarge,
                      children: [
                        const TextSpan(text: '오늘 '),
                        TextSpan(
                          text: '$done',
                          style: const TextStyle(color: AppColors.pink),
                        ),
                        TextSpan(text: '/$total 완료'),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : done / total,
                      minHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (pet != null)
              PetSprite(
                speciesId: pet.pet.speciesId,
                stage: pet.pet.stage,
                cell: done == total && total > 0
                    ? SpriteCell.happy
                    : SpriteCell.neutral,
                size: 64,
              ),
          ],
        ),
      ),
    );
  }
}

class _TodayTab extends ConsumerWidget {
  const _TodayTab({required this.today});

  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todayTodosProvider);
    return todos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('불러오지 못했어요: $e')),
      data: (items) => ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        children: [
          _ProgressCard(today: today, items: items),
          _AddRow(date: today),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('오늘 할일을 등록해 보세요')),
            ),
          for (final item in items) _TodoTile(item: item, today: today),
        ],
      ),
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
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      children: [
        Card(
          child: CalendarDatePicker(
            initialDate: DateTime(p[0], p[1], p[2]),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            onDateChanged: (d) =>
                ref.read(calendarDateProvider.notifier).select(keyFromDate(d)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Text(
            dateLabel(selected),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // 지난 날짜에 추가하면 바로 지연 할일이 되므로 오늘·앞으로만 추가한다.
        if (daysBetween(widget.today, selected) >= 0) _AddRow(date: selected),
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
              padding: const EdgeInsets.only(bottom: 24),
              children: children,
            );
          },
        );
  }
}

/// 할일 카드: 체크박스, 제목, 칩(카테고리·반복·체크리스트·지연), 포인트. 누르면 수정.
class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.item, required this.today});

  final TodayTodo item;
  final String today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = item.todo;
    final service = ref.read(todoServiceProvider);
    final textTheme = Theme.of(context).textTheme;
    final done = item.isCompleted;

    final checkbox = Transform.scale(
      scale: 1.3,
      child: Checkbox(
        value: done,
        onChanged: (checked) => runCompletion(
          context,
          ref,
          checked == true
              ? () => service.complete(todo.id)
              : () => service.cancel(todo.id),
        ),
      ),
    );

    final chips = Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        if (categoryById(todo.categoryId) case final c?)
          _Chip(
            categoryStyle(c.id).$1,
            c.name,
            background: categoryStyle(c.id).$2,
          ),
        if (todo.type == TodoType.repeat)
          _Chip(Icons.repeat, weekdaysLabel(todo.repeatWeekdays ?? 0)),
        if (todo.type == TodoType.checklist)
          _Chip(
            Icons.checklist,
            '${item.items.where((i) => i.checked).length}/${item.items.length}',
          ),
        if (item.delayDays > 0)
          _Chip(
            Icons.schedule,
            '${item.delayDays}일 지연',
            background: AppColors.pinkSoft,
            foreground: const Color(0xFFD9534F),
          ),
      ],
    );

    return Card(
      color: done ? AppColors.pinkSoft : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _edit(context, ref),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              checkbox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        todo.title,
                        style: textTheme.titleMedium?.copyWith(
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: done ? AppColors.inkSoft : null,
                        ),
                      ),
                    ),
                    if (chips.children.isNotEmpty) chips,
                    // 체크리스트 하위항목은 카드 안에서 바로 체크한다.
                    for (final i in item.items)
                      InkWell(
                        onTap: () => runCompletion(
                          context,
                          ref,
                          () => service.setItemChecked(i.id, !i.checked),
                        ),
                        child: Row(
                          spacing: 6,
                          children: [
                            Icon(
                              i.checked
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 20,
                              color: i.checked
                                  ? AppColors.pink
                                  : AppColors.inkSoft,
                            ),
                            Expanded(
                              child: Text(
                                i.title,
                                style: textTheme.bodyMedium?.copyWith(
                                  decoration: i.checked
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _PointTag(PointRules.basePoints(todo.difficulty)),
              ),
            ],
          ),
        ),
      ),
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

/// 아이콘 + 글자 칩.
class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.text, {this.background, this.foreground});

  final IconData icon;
  final String text;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? AppColors.ink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background ?? AppColors.cream,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(icon, size: 14, color: fg),
          Text(text, style: TextStyle(fontSize: 12, color: fg)),
        ],
      ),
    );
  }
}

/// 오른쪽 포인트 표시 "10 P".
class _PointTag extends StatelessWidget {
  const _PointTag(this.points);

  final int points;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.butter,
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: AppColors.line, width: 1.5),
    ),
    child: Text('$points P', style: Theme.of(context).textTheme.titleSmall),
  );
}
