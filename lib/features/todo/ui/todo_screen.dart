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

/// 오늘 보기 (PRD F2). 빠른 등록, 완료·취소, 체크리스트, 상세 등록·수정.
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todayTodosProvider);
    final balance = ref.watch(balanceProvider).value;
    final today = dateKey(ref.watch(nowProvider)());

    return Scaffold(
      appBar: AppBar(
        title: Text('오늘 · ${dateLabel(today)}'),
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
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '할일 추가',
        onPressed: () => _add(context, ref, today),
        child: const Icon(Icons.add),
      ),
      body: Column(
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
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref, String today) async {
    final result = await showTodoForm(context, today: today);
    final draft = result?.draft;
    if (draft == null || !context.mounted) return;
    await runTodoAction(context, ref, () async {
      await ref.read(todoServiceProvider).add(draft);
      return '할일을 추가했어요';
    });
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
      onChanged: (checked) => runTodoAction(
        context,
        ref,
        () async => pointMessage(
          checked == true
              ? await service.complete(todo.id)
              : await service.cancel(todo.id),
        ),
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
            onChanged: (checked) => runTodoAction(context, ref, () async {
              final grant = await service.setItemChecked(
                i.id,
                checked ?? false,
              );
              return grant == null ? null : pointMessage(grant);
            }),
          ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final result = await showTodoForm(
      context,
      today: today,
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
