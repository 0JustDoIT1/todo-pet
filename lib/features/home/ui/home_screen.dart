import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/ui/app_theme.dart';
import '../../../core/ui/main_tab.dart';
import '../../../core/ui/point_pill.dart';
import '../../pet/data/pet_service.dart';
import '../../pet/domain/pet_rules.dart';
import '../../pet/domain/foods.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/feed_sheet.dart';
import '../../pet/ui/pet_actions.dart';
import '../../pet/ui/pet_avatar.dart';
import '../../pet/ui/pet_picker_sheet.dart';
import '../../pet/ui/pet_providers.dart';
import '../../pet/ui/pet_sprite.dart';
import '../../todo/ui/todo_providers.dart';
import 'room_background.dart';

/// 홈 (PRD 7장): 화면을 채우는 방(맵) 위에 활성 펫, 상태 카드, 돌보기·꾸미기, 오늘 할일 요약.
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
    if (food == null || !mounted) return;
    final result = await feedPet(context, ref, food);
    if (result == null || !mounted) return;
    setState(() => _jump++);
    _say(result.grewUp ? '쑥 자랐어요!' : '맛있어요!');
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
    ref.invalidate(ownedPetsProvider);
  }

  void _decorateSoon() => _toast('꾸미기는 곧 열려요');

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(activePetProvider);
    final balance = ref.watch(balanceProvider).value;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: RoomBackground()),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _TopBar(balance: balance),
                Expanded(
                  child: pet.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('펫을 불러오지 못했어요: $e')),
                    data: (view) => view == null
                        ? _NoPet(onPick: _pickPet)
                        : _petStage(view),
                  ),
                ),
                if (pet.value != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: _BigButton(
                            label: '돌보기',
                            color: AppColors.butter,
                            icon: FoodIcon(foods.first, size: 36),
                            onTap: () => _feed(pet.value!),
                          ),
                        ),
                        Expanded(
                          child: _BigButton(
                            label: '꾸미기',
                            color: AppColors.pinkSoft,
                            icon: const Icon(
                              Icons.checkroom,
                              size: 32,
                              color: AppColors.ink,
                            ),
                            onTap: _decorateSoon,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _TodaySummary(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 방 위의 상태 카드와 펫. 펫은 바닥 쪽에 선다.
  Widget _petStage(PetView view) => Stack(
    children: [
      Positioned(left: 16, top: 12, child: _StatusCard(view: view)),
      Align(
        alignment: const Alignment(0, 0.55),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 44,
              child: _bubble == null ? null : _SpeechBubble(_bubble!),
            ),
            GestureDetector(
              onTap: _tap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 200,
                height: 180,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // 바닥 그림자
                    Container(
                      width: 110,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.ink.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      child: PetAvatar(
                        speciesId: view.pet.speciesId,
                        stage: view.pet.stage,
                        expression: view.expression,
                        jumpSignal: _jump,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// 맨 위 줄: 앱 이름과 포인트.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.balance});

  final int? balance;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 16, 12),
    decoration: const BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
    ),
    child: Row(
      spacing: 8,
      children: [
        const Icon(Icons.pets, color: AppColors.pink, size: 28),
        Text('투두펫', style: Theme.of(context).textTheme.headlineSmall),
        const Spacer(),
        if (balance != null) PointPill(balance!),
      ],
    ),
  );
}

/// 이름·단계와 기분·배고픔·애정도 게이지.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.view});

  final PetView view;

  @override
  Widget build(BuildContext context) {
    final species = speciesById(view.pet.speciesId);
    final done = view.pet.stage >= PetRules.maxStagePhase1;
    return Container(
      width: 210,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.paper.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            '${view.pet.name} · ${view.pet.stage}단계',
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          if (species != null)
            Text(
              species.name,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.inkSoft),
            ),
          _StatBar(
            icon: Icons.sentiment_satisfied_alt,
            label: '기분',
            value: view.mood,
            color: AppColors.mood,
          ),
          _StatBar(
            icon: Icons.restaurant,
            label: '배고픔',
            value: view.hunger,
            color: AppColors.hunger,
          ),
          _StatBar(
            icon: Icons.favorite,
            label: '애정도',
            value: view.affection,
            max: PetRules.stage2Affection,
            color: AppColors.affection,
            caption: done
                ? '${view.affection}'
                : '${view.affection}/${PetRules.stage2Affection}',
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.max = 100,
    this.caption,
  });

  final IconData icon;
  final String label;
  final int value;
  final int max;
  final Color color;

  /// 막대 오른쪽 숫자. 없으면 막대만.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.labelLarge;
    return Row(
      spacing: 6,
      children: [
        Icon(icon, size: 18, color: AppColors.ink),
        SizedBox(width: 42, child: Text(label, style: small)),
        Expanded(
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColors.line, width: 1.5),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (value / max).clamp(0, 1).toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ),
        if (caption != null) Text(caption!, style: small),
      ],
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.ink, width: 1.5),
    ),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

/// 돌보기·꾸미기 같은 큰 알약 버튼.
class _BigButton extends StatelessWidget {
  const _BigButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: const StadiumBorder(
      side: BorderSide(color: AppColors.ink, width: 2),
    ),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            icon,
            Text(label, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    ),
  );
}

class _NoPet extends StatelessWidget {
  const _NoPet({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const Text('🥚', style: TextStyle(fontSize: 72)),
          Text(
            '아직 함께하는 펫이 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FilledButton(onPressed: onPick, child: const Text('펫 고르기')),
        ],
      ),
    ),
  );
}

/// 오늘 할일 완료/전체. 누르면 할일 탭으로 간다.
class _TodaySummary extends ConsumerWidget {
  const _TodaySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todayTodosProvider).value ?? const [];
    final done = todos.where((t) => t.isCompleted).length;
    final style = Theme.of(context).textTheme.titleMedium;

    return Material(
      color: AppColors.paper,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.line, width: 1.5),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => ref.read(mainTabProvider.notifier).select(MainTab.todo),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            spacing: 10,
            children: [
              const Icon(Icons.assignment_turned_in_outlined),
              Text.rich(
                TextSpan(
                  style: style,
                  children: [
                    const TextSpan(text: '오늘 할 일  '),
                    TextSpan(
                      text: '$done',
                      style: const TextStyle(color: AppColors.pink),
                    ),
                    TextSpan(text: '/${todos.length}'),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
