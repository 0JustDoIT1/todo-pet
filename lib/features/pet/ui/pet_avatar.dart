import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/pet_rules.dart';
import '../domain/species.dart';

/// 펫 표시 (PRD 3.5). 그림이 생기기 전까지 종별 이모지 + 표정 배지로 대신한다.
/// 움직임은 코드로: 평소에는 위아래로 숨쉬듯 움직이고, [jumpSignal]이 바뀌면 한 번 뛴다.
class PetAvatar extends StatefulWidget {
  const PetAvatar({
    super.key,
    required this.speciesId,
    required this.stage,
    required this.expression,
    this.jumpSignal = 0,
  });

  final String speciesId;
  final int stage;
  final PetExpression expression;

  /// 값이 바뀔 때마다 점프한다 (탭 반응).
  final int jumpSignal;

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar> with TickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();
  late final AnimationController _jump = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void didUpdateWidget(PetAvatar old) {
    super.didUpdateWidget(old);
    if (old.jumpSignal != widget.jumpSignal) _jump.forward(from: 0);
  }

  @override
  void dispose() {
    _idle.dispose();
    _jump.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final species = speciesById(widget.speciesId);
    // 2단계는 조금 더 크게.
    final size = widget.stage >= 2 ? 120.0 : 92.0;
    final badge = switch (widget.expression) {
      PetExpression.happy => '💛',
      PetExpression.hungry => '🍚',
      PetExpression.neutral => null,
    };

    return AnimatedBuilder(
      animation: Listenable.merge([_idle, _jump]),
      builder: (context, child) {
        final bob = math.sin(_idle.value * 2 * math.pi) * 4;
        final jump = math.sin(_jump.value * math.pi) * -36;
        return Transform.translate(offset: Offset(0, bob + jump), child: child);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(species?.placeholder ?? '❓', style: TextStyle(fontSize: size)),
          if (badge != null)
            Positioned(
              right: -8,
              top: -4,
              child: Text(badge, style: const TextStyle(fontSize: 28)),
            ),
        ],
      ),
    );
  }
}
