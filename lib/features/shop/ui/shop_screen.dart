import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/ui/app_theme.dart';
import '../../../core/ui/pill_tab_bar.dart';
import '../../../core/ui/point_pill.dart';
import '../../pet/data/pet_service.dart';
import '../../pet/domain/foods.dart';
import '../../pet/domain/pet_rules.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/pet_actions.dart';
import '../../pet/ui/pet_picker_sheet.dart';
import '../../pet/ui/pet_providers.dart';
import '../../pet/ui/pet_sprite.dart';
import '../../todo/ui/todo_providers.dart';

/// 상점 (PRD 3.8): 탭별 상품. 지금은 먹이(사면 바로 급여)·펫(시작 종 입양).
/// 배경·소품·프리즈 탭은 해당 기능과 함께 붙인다.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider).value ?? 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('상점'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: PointPill(balance),
            ),
          ],
          bottom: const PillTabBar(labels: ['먹이', '펫']),
        ),
        body: TabBarView(
          children: [
            _FoodTab(balance: balance),
            _PetTab(balance: balance),
          ],
        ),
      ),
    );
  }
}

class _FoodTab extends ConsumerWidget {
  const _FoodTab({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(activePetProvider).value;
    final full = pet != null && !PetRules.canFeed(pet.stats);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _Notice(
          pet == null
              ? '함께하는 펫이 없어요'
              : full
              ? '배가 불러서 지금은 먹을 수 없어요'
              : '사면 바로 ${pet.pet.name}에게 줘요',
        ),
        _Grid(
          children: [
            for (final f in foods)
              _ItemCard(
                image: FoodIcon(f, size: 64),
                name: f.name,
                detail: '배고픔 +${f.hunger}\n기분 +${f.mood}',
                price: f.price,
                onBuy: pet == null || full || balance < f.price
                    ? null
                    : () => feedPet(context, ref, f),
              ),
          ],
        ),
      ],
    );
  }
}

class _PetTab extends ConsumerWidget {
  const _PetTab({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = <String>{
      for (final p in ref.watch(ownedPetsProvider).value ?? const <Pet>[])
        p.speciesId,
    };
    final adoptable = starterSpecies.where((s) => !owned.contains(s.id));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        // 시작 종을 모두 입양하면 안내만 보여준다 (PRD 3.3).
        if (adoptable.isEmpty)
          const _Notice('모두 함께하고 있어요')
        else ...[
          _Notice(
            balance < PetRules.adoptionPrice
                ? '입양까지 ${PetRules.adoptionPrice - balance}P 남았어요'
                : '새 펫은 1단계부터 시작해요. 함께할 펫은 설정에서 바꿀 수 있어요.',
          ),
          _Grid(
            children: [
              for (final s in adoptable)
                _ItemCard(
                  image: PetSprite(speciesId: s.id, stage: 1, size: 72),
                  name: s.name,
                  detail: '입양\n1단계부터',
                  price: PetRules.adoptionPrice,
                  onBuy: balance < PetRules.adoptionPrice
                      ? null
                      : () => _adopt(context, ref, owned),
                ),
            ],
          ),
        ],
      ],
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

/// 탭 맨 위 안내 문장.
class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.inkSoft),
    ),
  );
}

/// 상품 카드 3열.
class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 3,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 0.5,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: children,
  );
}

/// 그림, 이름, 효과, 가격, 구매 버튼.
class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.onBuy,
  });

  final Widget image;
  final String name;
  final String detail;
  final int price;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: image)),
          Text(name, style: textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            detail,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.inkSoft,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 6),
          Text('$price P', style: textTheme.titleSmall),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: FilledButton(
              onPressed: onBuy,
              style: FilledButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('구매'),
            ),
          ),
        ],
      ),
    );
  }
}
