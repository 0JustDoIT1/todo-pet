import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/pet_rules.dart';
import 'pet_sprite.dart';

/// 홈의 펫 (PRD 3.5). 그림은 표정 시트, 움직임은 코드로 만든다.
/// - 평소: 위아래로 숨쉬듯 움직이고, 기본 표정이면 가끔 눈을 감는다.
/// - [jumpSignal]이 바뀌면(탭·먹이) 기쁨 칸으로 바꾸고 한 번 뛴다.
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

  /// 값이 바뀔 때마다 점프한다.
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
  late final Timer _blinkTimer;
  bool _blinking = false;
  bool _cheering = false;
  Timer? _cheerTimer;

  @override
  void initState() {
    super.initState();
    // 3초마다 0.15초 눈을 감는다.
    _blinkTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _blinking = true);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _blinking = false);
      });
    });
  }

  @override
  void didUpdateWidget(PetAvatar old) {
    super.didUpdateWidget(old);
    if (old.jumpSignal != widget.jumpSignal) {
      _jump.forward(from: 0);
      _cheerTimer?.cancel();
      setState(() => _cheering = true);
      _cheerTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _cheering = false);
      });
    }
  }

  @override
  void dispose() {
    _blinkTimer.cancel();
    _cheerTimer?.cancel();
    _idle.dispose();
    _jump.dispose();
    super.dispose();
  }

  SpriteCell get _cell {
    if (_cheering) return SpriteCell.happy;
    return switch (widget.expression) {
      PetExpression.hungry => SpriteCell.hungry,
      PetExpression.happy => SpriteCell.happy,
      PetExpression.neutral =>
        _blinking ? SpriteCell.blink : SpriteCell.neutral,
    };
  }

  @override
  Widget build(BuildContext context) {
    // 2단계는 조금 더 크게.
    final size = widget.stage >= 2 ? 160.0 : 136.0;
    return AnimatedBuilder(
      animation: Listenable.merge([_idle, _jump]),
      builder: (context, child) {
        final bob = math.sin(_idle.value * 2 * math.pi) * 4;
        final jump = math.sin(_jump.value * math.pi) * -36;
        return Transform.translate(offset: Offset(0, bob + jump), child: child);
      },
      child: PetSprite(
        speciesId: widget.speciesId,
        stage: widget.stage,
        cell: _cell,
        size: size,
      ),
    );
  }
}
