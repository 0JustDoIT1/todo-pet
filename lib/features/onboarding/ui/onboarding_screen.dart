import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/pet_picker_sheet.dart';
import '../../pet/ui/pet_sprite.dart';
import '../data/onboarding_service.dart';

/// 온보딩 (PRD F6, 기획서 5.9): 소개 → 펫 고르기·이름 → 첫 할일 1~3개.
/// 마지막 단계에서 한 번에 저장한다.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  PetChoice? _pet;
  final _todos = List.generate(
    OnboardingService.maxFirstTodos,
    (_) => TextEditingController(),
  );
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _todos) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _finish() async {
    final pet = _pet!;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(onboardingServiceProvider)
          .finish(
            speciesId: pet.speciesId,
            petName: pet.name,
            todoTitles: [for (final c in _todos) c.text],
          );
      ref.invalidate(onboardingDoneProvider);
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: switch (_step) {
            0 => _intro(context),
            1 => PetPickerForm(
              buttonLabel: '다음',
              onDone: (choice) => setState(() {
                _pet = choice;
                _step = 2;
              }),
            ),
            _ => _firstTodos(context),
          },
        ),
      ),
    );
  }

  Widget _intro(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final s in starterSpecies)
              PetSprite(
                speciesId: s.id,
                stage: 1,
                cell: SpriteCell.happy,
                size: 88,
              ),
          ],
        ),
        Text(
          '할일을 끝내면 포인트가 쌓이고,\n그 포인트로 펫을 돌봐요',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        const Text(
          '먹이를 주고 놀아 주면 펫이 조금씩 자라요.\n돌보지 못해도 아프거나 떠나지 않아요.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => setState(() => _step = 1),
          child: const Text('시작하기'),
        ),
      ],
    );
  }

  Widget _firstTodos(BuildContext context) {
    final theme = Theme.of(context);
    final pet = _pet!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        // 이름 뒤 조사(와/과)가 받침에 따라 달라 이름은 따로 줄에 둔다.
        Row(
          spacing: 8,
          children: [
            PetSprite(speciesId: pet.speciesId, stage: 1, size: 48),
            Text(pet.name, style: theme.textTheme.titleMedium),
          ],
        ),
        Text('오늘 할일을 적어 주세요', style: theme.textTheme.titleLarge),
        const Text('하나만 적어도 괜찮아요. 완료하면 10P를 받아요.'),
        for (final (i, c) in _todos.indexed)
          TextField(
            controller: c,
            decoration: InputDecoration(labelText: '할일 ${i + 1}'),
          ),
        if (_error != null)
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        Row(
          children: [
            TextButton(
              onPressed: _saving ? null : () => setState(() => _step = 1),
              child: const Text('이전'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _saving ? null : _finish,
              child: const Text('시작하기'),
            ),
          ],
        ),
      ],
    );
  }
}
