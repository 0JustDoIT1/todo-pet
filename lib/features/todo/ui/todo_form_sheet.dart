import 'package:flutter/material.dart';

import '../../../core/db/app_database.dart';
import '../../../core/error/app_exception.dart';
import '../../points/domain/point_rules.dart';
import '../domain/categories.dart';
import '../domain/todo_enums.dart';
import '../domain/todo_rules.dart';
import 'date_label.dart';

/// 상세 등록·수정 결과. [delete]가 true면 삭제 요청.
class TodoFormResult {
  const TodoFormResult.save(TodoDraft this.draft) : delete = false;
  const TodoFormResult.delete() : draft = null, delete = true;

  final TodoDraft? draft;
  final bool delete;
}

/// 상세 등록(새 할일) 또는 수정([initial]) 시트를 띄운다.
Future<TodoFormResult?> showTodoForm(
  BuildContext context, {
  required String defaultDate,
  Todo? initial,
  List<ChecklistItem> initialItems = const [],
}) => showModalBottomSheet<TodoFormResult>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _TodoFormSheet(
    defaultDate: defaultDate,
    initial: initial,
    initialItems: initialItems,
  ),
);

const _typeNames = {
  TodoType.oneTime: '한 번',
  TodoType.repeat: '반복',
  TodoType.checklist: '체크리스트',
};

class _TodoFormSheet extends StatefulWidget {
  const _TodoFormSheet({
    required this.defaultDate,
    required this.initial,
    required this.initialItems,
  });

  /// 새 할일의 기본 날짜 (수정할 때는 할일의 날짜를 쓴다).
  final String defaultDate;
  final Todo? initial;
  final List<ChecklistItem> initialItems;

  @override
  State<_TodoFormSheet> createState() => _TodoFormSheetState();
}

class _TodoFormSheetState extends State<_TodoFormSheet> {
  late final TextEditingController _title;
  late TodoType _type;
  late Difficulty _difficulty;
  String? _categoryId;
  late String _date;
  late int _weekdays;
  late final List<TextEditingController> _items;
  String? _error;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final t = widget.initial;
    _title = TextEditingController(text: t?.title ?? '');
    _type = t?.type ?? TodoType.oneTime;
    _difficulty = t?.difficulty ?? Difficulty.mid;
    _categoryId = t?.categoryId;
    _date = t?.date ?? widget.defaultDate;
    _weekdays = t?.repeatWeekdays ?? TodoRules.everyDay;
    _items = [
      for (final i in widget.initialItems) TextEditingController(text: i.title),
      if (widget.initialItems.isEmpty) TextEditingController(),
    ];
  }

  @override
  void dispose() {
    _title.dispose();
    for (final c in _items) {
      c.dispose();
    }
    super.dispose();
  }

  TodoDraft get _draft => TodoDraft(
    type: _type,
    title: _title.text,
    difficulty: _difficulty,
    categoryId: _categoryId,
    date: _type == TodoType.repeat ? null : _date,
    repeatWeekdays: _type == TodoType.repeat ? _weekdays : null,
    items: _type == TodoType.checklist ? [for (final c in _items) c.text] : [],
  );

  void _save() {
    final draft = _draft;
    try {
      TodoRules.validate(draft);
    } on AppException catch (e) {
      setState(() => _error = e.message);
      return;
    }
    Navigator.pop(context, TodoFormResult.save(draft));
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('할일을 삭제할까요?'),
        content: const Text('받은 포인트와 지난 기록은 그대로 남아요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      Navigator.pop(context, const TodoFormResult.delete());
    }
  }

  Future<void> _pickDate() async {
    final p = _date.split('-').map(int.parse).toList();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(p[0], p[1], p[2]),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = keyFromDate(picked));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(
              _isEdit ? '할일 수정' : '할일 추가',
              style: theme.textTheme.titleLarge,
            ),
            TextField(
              controller: _title,
              autofocus: !_isEdit,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            // 종류는 등록할 때만 고를 수 있다. 수정할 때는 글자로만 보여준다
            // (비활성 버튼은 선택된 칸이 보이지 않음).
            if (_isEdit)
              Text('종류: ${_typeNames[_type]}', style: theme.textTheme.bodyLarge)
            else
              SegmentedButton<TodoType>(
                segments: [
                  for (final t in TodoType.values)
                    ButtonSegment(value: t, label: Text(_typeNames[t]!)),
                ],
                selected: {_type},
                // 선택 아이콘이 있으면 '체크리스트'가 두 줄로 꺾여 뺀다.
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
            SegmentedButton<Difficulty>(
              segments: [
                for (final (d, name) in [
                  (Difficulty.low, '하'),
                  (Difficulty.mid, '중'),
                  (Difficulty.high, '상'),
                ])
                  ButtonSegment(
                    value: d,
                    label: Text('$name ${PointRules.basePoints(d)}P'),
                  ),
              ],
              selected: {_difficulty},
              onSelectionChanged: (s) => setState(() => _difficulty = s.first),
            ),
            if (_type == TodoType.repeat)
              Wrap(
                spacing: 6,
                children: [
                  for (var i = 0; i < 7; i++)
                    FilterChip(
                      label: Text(weekdayName(i)),
                      selected: _weekdays & (1 << i) != 0,
                      onSelected: (on) => setState(
                        () => _weekdays = on
                            ? _weekdays | (1 << i)
                            : _weekdays & ~(1 << i),
                      ),
                    ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event),
                label: Text(dateLabel(_date)),
              ),
            DropdownButtonFormField<String?>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: '카테고리 (선택)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('없음')),
                for (final c in todoCategories)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
            if (_type == TodoType.checklist) ...[
              for (final (i, c) in _items.indexed)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: c,
                        decoration: InputDecoration(labelText: '항목 ${i + 1}'),
                      ),
                    ),
                    IconButton(
                      tooltip: '항목 삭제',
                      onPressed: _items.length == 1
                          ? null
                          : () => setState(() => _items.removeAt(i).dispose()),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              TextButton.icon(
                onPressed: () =>
                    setState(() => _items.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('항목 추가'),
              ),
            ],
            if (_error != null)
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            Row(
              children: [
                if (_isEdit)
                  TextButton(
                    onPressed: _confirmDelete,
                    child: Text(
                      '삭제',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                const Spacer(),
                FilledButton(onPressed: _save, child: const Text('저장')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
