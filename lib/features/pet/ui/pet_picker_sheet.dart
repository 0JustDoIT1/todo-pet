import 'package:flutter/material.dart';

import '../../../core/error/app_exception.dart';
import '../domain/pet_rules.dart';
import '../domain/species.dart';

/// 펫 고르기 결과.
typedef PetChoice = ({String speciesId, String name});

/// 펫 고르기를 시트로 띄운다 (홈에서 펫이 없을 때, 입양).
/// [excludeSpecies]에 있는 종은 고를 수 없다 (이미 함께하는 펫).
Future<PetChoice?> showPetPicker(
  BuildContext context, {
  Set<String> excludeSpecies = const {},
}) => showModalBottomSheet<PetChoice>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(
      left: 20,
      right: 20,
      top: 16,
      bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
    ),
    child: PetPickerForm(
      exclude: excludeSpecies,
      onDone: (choice) => Navigator.pop(context, choice),
    ),
  ),
);

/// 시작 펫 종 선택 + 이름짓기 (PRD F4·F6). 시트와 온보딩이 같이 쓴다.
class PetPickerForm extends StatefulWidget {
  const PetPickerForm({
    super.key,
    required this.onDone,
    this.exclude = const {},
    this.buttonLabel = '함께하기',
  });

  final ValueChanged<PetChoice> onDone;
  final Set<String> exclude;
  final String buttonLabel;

  @override
  State<PetPickerForm> createState() => _PetPickerFormState();
}

class _PetPickerFormState extends State<PetPickerForm> {
  final _name = TextEditingController();
  String? _speciesId;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _done() {
    if (_speciesId == null) {
      setState(() => _error = '함께할 펫을 골라 주세요.');
      return;
    }
    try {
      final name = PetRules.validateName(_name.text);
      widget.onDone((speciesId: _speciesId!, name: name));
    } on AppException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text('함께할 펫을 골라 주세요', style: theme.textTheme.titleLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final s in starterSpecies)
              ChoiceChip(
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(s.placeholder, style: const TextStyle(fontSize: 40)),
                      Text(s.name),
                    ],
                  ),
                ),
                showCheckmark: false,
                selected: _speciesId == s.id,
                onSelected: widget.exclude.contains(s.id)
                    ? null
                    : (_) => setState(() => _speciesId = s.id),
              ),
          ],
        ),
        TextField(
          controller: _name,
          maxLength: PetRules.nameMaxLength,
          decoration: const InputDecoration(labelText: '이름'),
          onSubmitted: (_) => _done(),
        ),
        if (_error != null)
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        FilledButton(onPressed: _done, child: Text(widget.buttonLabel)),
      ],
    );
  }
}
