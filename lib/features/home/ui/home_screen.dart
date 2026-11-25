import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/ui/main_tab.dart';
import '../../pet/data/pet_service.dart';
import '../../pet/domain/pet_rules.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/feed_sheet.dart';
import '../../pet/ui/pet_avatar.dart';
import '../../pet/ui/pet_picker_sheet.dart';
import '../../pet/ui/pet_providers.dart';
import '../../todo/ui/todo_providers.dart';

/// 홈 (PRD 7장, 기획서 5.1): 포인트 잔액, 활성 펫, 오늘 할일 미리보기.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _ticker;
  int _jump = 0;
  String? _bubble;
  Timer? _bubbleTimer;

  @override
  void initState() {
    super.initState();
    // 배고픔·기분은 시간에 따라 줄어서 1분마다 다시 계산한다.
    _ticker = Timer.periodic(
      const Duration(minutes: 1),
      (_) => ref.invalidate(activePetProvider),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _bubbleTimer?.cancel();
    super.dispose();
  }

  void _say(String text) {
    _bubbleTimer?.cancel();
    setState(() => _bubble = text);
    _bubbleTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _bubble = null);
    });
  }

  void _toast(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _tap() async {
    setState(() => _jump++);
    try {
      final gained = await ref.read(petServiceProvider).tap();
      _say(gained ? '좋아요!' : '오늘은 충분히 놀았어요');
    } on AppException catch (e) {
      _toast(e.message);
    }
    ref.invalidate(activePetProvider);
  }

  Future<void> _feed(PetView pet) async {
    final balance = ref.read(balanceProvider).value ?? 0;
    final food = await showFeedSheet(
      context,
      balance: balance,
      full: !PetRules.canFeed(pet.stats),
    );
    if (food == null) return;
    try {
      final result = await ref.read(petServiceProvider).feed(food.id);
      setState(() => _jump++);
      _say(result.grewUp ? '쑥 자랐어요!' : '맛있어요!');
      _toast('${food.name} -${food.price}P');
    } on AppException catch (e) {
      _toast(e.message);
    }
    ref.invalidate(activePetProvider);
    ref.invalidate(balanceProvider);
  }

  Future<void> _pickPet() async {
    final choice = await showPetPicker(context);
    if (choice == null) return;
    try {
      await ref
          .read(petServiceProvider)
          .create(speciesId: choice.speciesId, name: choice.name);
    } on AppException catch (e) {
      _toast(e.message);
    }
    ref.invalidate(activePetProvider);
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(activePetProvider);
    final balance = ref.watch(balanceProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pet.when(
            loading: () => const SizedBox(
              height: 320,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('펫을 불러오지 못했어요: $e'),
            data: (view) =>
                view == null ? _NoPet(onPick: _pickPet) : _petCard(view),
          ),
          const SizedBox(height: 24),
          const _TodayPreview(),
        ],
      ),
    );
  }

  Widget _petCard(PetView view) {
    final theme = Theme.of(context);
    final species = speciesById(view.pet.speciesId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          children: [
            SizedBox(
              height: 32,
              child: _bubble == null
                  ? null
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(_bubble!),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: _tap,
              child: SizedBox(
                height: 170,
                child: Center(
                  child: PetAvatar(
                    speciesId: view.pet.speciesId,
                    stage: view.pet.stage,
                    expression: view.expression,
                    jumpSignal: _jump,
                  ),
                ),
              ),
            ),
            Text(
              '${view.pet.name} · ${species?.name ?? ''} · ${view.pet.stage}단계',
              style: theme.textTheme.titleMedium,
            ),
            _Gauge(label: '배고픔', value: view.hunger, icon: Icons.restaurant),
            _Gauge(label: '기분', value: view.mood, icon: Icons.mood),
            _Gauge(
              label: '애정도',
              value: view.affection,
              max: PetRules.stage2Affection,
              icon: Icons.favorite,
              done: view.pet.stage >= PetRules.maxStagePhase1,
            ),
            FilledButton.icon(
              onPressed: () => _feed(view),
              icon: const Icon(Icons.restaurant),
              label: const Text('먹이 주기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoPet extends StatelessWidget {
  const _NoPet({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        spacing: 12,
        children: [
          const Text('🥚', style: TextStyle(fontSize: 72)),
          const Text('아직 함께하는 펫이 없어요'),
          FilledButton(onPressed: onPick, child: const Text('펫 고르기')),
        ],
      ),
    ),
  );
}

class _Gauge extends StatelessWidget {
  const _Gauge({
    required this.label,
    required this.value,
    required this.icon,
    this.max = 100,
    this.done = false,
  });

  final String label;
  final int value;
  final IconData icon;
  final int max;

  /// 더 오를 단계가 없으면 숫자만 보여준다.
  final bool done;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 8,
    children: [
      Icon(icon, size: 18),
      SizedBox(width: 48, child: Text(label)),
      Expanded(
        child: LinearProgressIndicator(
          value: (value / max).clamp(0, 1).toDouble(),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      SizedBox(
        width: 56,
        child: Text(done ? '$value' : '$value/$max', textAlign: TextAlign.end),
      ),
    ],
  );
}

/// 오늘 할일 미리보기 5개 + 전체보기.
class _TodayPreview extends ConsumerWidget {
  const _TodayPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todayTodosProvider).value ?? const [];
    final theme = Theme.of(context);
    final done = todos.where((t) => t.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '오늘 할일 $done/${todos.length}',
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  ref.read(mainTabProvider.notifier).select(MainTab.todo),
              child: const Text('전체보기'),
            ),
          ],
        ),
        if (todos.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('오늘 할일을 등록해 보세요'),
          ),
        for (final t in todos.take(5))
          ListTile(
            dense: true,
            leading: Icon(
              t.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            ),
            title: Text(
              t.todo.title,
              style: t.isCompleted
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
          ),
      ],
    );
  }
}
