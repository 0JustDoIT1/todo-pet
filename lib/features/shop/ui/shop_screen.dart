import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/error/app_exception.dart';
import '../../pet/data/pet_service.dart';
import '../../pet/domain/foods.dart';
import '../../pet/domain/pet_rules.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/pet_actions.dart';
import '../../pet/ui/pet_picker_sheet.dart';
import '../../pet/ui/pet_providers.dart';
import '../../todo/ui/todo_providers.dart';

/// 상점 (PRD 7장): 먹이 구매(바로 급여), 시작 종 입양.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider).value ?? 0;
    final pet = ref.watch(activePetProvider).value;
    final owned = <String>{
      for (final p in ref.watch(ownedPetsProvider).value ?? const <Pet>[])
        p.speciesId,
    };
    final adoptable = starterSpecies.where((s) => !owned.contains(s.id));
    final full = pet != null && !PetRules.canFeed(pet.stats);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('상점'),
        actions: [
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _Header(
            '먹이',
            pet == null
                ? '함께하는 펫이 없어요'
                : full
                ? '배가 불러서 지금은 먹을 수 없어요'
                : '사면 바로 ${pet.pet.name}에게 줘요',
          ),
          for (final f in foods)
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(f.name),
              subtitle: Text('배고픔 +${f.hunger} · 기분 +${f.mood}'),
              trailing: FilledButton.tonal(
                onPressed: pet == null || full || balance < f.price
                    ? null
                    : () => feedPet(context, ref, f),
                child: Text('${f.price}P'),
              ),
            ),
          // 시작 종을 모두 입양하면 입양 영역을 숨긴다 (PRD 3.3).
          if (adoptable.isNotEmpty) ...[
            const Divider(height: 32),
            _Header('입양', '새 펫은 1단계부터 시작해요. 함께할 펫은 설정에서 바꿀 수 있어요.'),
            for (final s in adoptable)
              ListTile(
                leading: Text(
                  s.placeholder,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(s.name),
                trailing: FilledButton.tonal(
                  onPressed: balance < PetRules.adoptionPrice
                      ? null
                      : () => _adopt(context, ref, owned),
                  child: Text('${PetRules.adoptionPrice}P'),
                ),
              ),
          ],
          if (balance < PetRules.adoptionPrice && adoptable.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '입양까지 ${PetRules.adoptionPrice - balance}P 남았어요',
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _adopt(
    BuildContext context,
    WidgetRef ref,
    Set<String> owned,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final choice = await showPetPicker(context, excludeSpecies: owned);
    if (choice == null) return;
    String message;
    try {
      await ref
          .read(petServiceProvider)
          .adopt(speciesId: choice.speciesId, name: choice.name);
      message = '입양 완료: ${choice.name} -${PetRules.adoptionPrice}P';
    } on AppException catch (e) {
      message = e.message;
    }
    ref.invalidate(ownedPetsProvider);
    ref.invalidate(balanceProvider);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    subtitle: Text(subtitle),
  );
}
