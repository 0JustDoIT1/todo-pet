import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/error/app_exception.dart';
import '../../pet/data/pet_service.dart';
import '../../pet/domain/pet_rules.dart';
import '../../pet/domain/species.dart';
import '../../pet/ui/pet_providers.dart';
import '../../pet/ui/pet_sprite.dart';

/// 설정 (PRD 7장): 활성 펫 교체·이름 변경, 오픈소스 라이선스·에셋 출처.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pets = ref.watch(ownedPetsProvider).value ?? const <Pet>[];
    final activeId = ref.watch(activePetProvider).value?.pet.id;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(title: Text('함께하는 펫', style: theme.textTheme.titleMedium)),
          if (pets.isEmpty) const ListTile(title: Text('아직 함께하는 펫이 없어요')),
          for (final pet in pets)
            ListTile(
              leading: PetSprite(
                speciesId: pet.speciesId,
                stage: pet.stage,
                size: 48,
              ),
              title: Text(pet.name),
              subtitle: Text(
                '${speciesById(pet.speciesId)?.name ?? ''} · ${pet.stage}단계'
                '${pet.id == activeId ? ' · 함께하는 중' : ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: '이름 바꾸기',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _rename(context, ref, pet),
                  ),
                  if (pet.id != activeId)
                    FilledButton.tonal(
                      onPressed: () => _switch(context, ref, pet),
                      child: const Text('함께하기'),
                    ),
                ],
              ),
            ),
          const Divider(height: 32),
          ListTile(title: Text('정보', style: theme.textTheme.titleMedium)),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('오픈소스 라이선스'),
            onTap: () =>
                showLicensePage(context: context, applicationName: '투두펫'),
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('그림 출처'),
            onTap: () => _showAssetSources(context),
          ),
        ],
      ),
    );
  }

  Future<void> _switch(BuildContext context, WidgetRef ref, Pet pet) async {
    final messenger = ScaffoldMessenger.of(context);
    String message;
    try {
      await ref.read(petServiceProvider).setActive(pet.id);
      message = '함께하는 펫: ${pet.name}';
    } on AppException catch (e) {
      message = e.message;
    }
    ref.invalidate(activePetProvider);
    ref.invalidate(ownedPetsProvider);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _rename(BuildContext context, WidgetRef ref, Pet pet) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(initial: pet.name),
    );
    if (name == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    String message;
    try {
      await ref.read(petServiceProvider).rename(pet.id, name);
      message = '이름을 바꿨어요';
    } on AppException catch (e) {
      message = e.message;
    }
    ref.invalidate(activePetProvider);
    ref.invalidate(ownedPetsProvider);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// 그림 출처. ASSETS.md와 같은 내용을 유지한다.
  void _showAssetSources(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('그림 출처'),
      content: const Text(
        '펫·먹이 그림과 앱 아이콘은 ChatGPT 이미지 생성(OpenAI)으로 만들고 '
        '크기와 투명 배경을 다듬어 넣었어요 (2026년 11월).',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    ),
  );
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});

  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('이름 바꾸기'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      maxLength: PetRules.nameMaxLength,
      decoration: const InputDecoration(labelText: '이름'),
      onSubmitted: (v) => Navigator.pop(context, v),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('취소'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _controller.text),
        child: const Text('저장'),
      ),
    ],
  );
}
