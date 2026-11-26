import 'package:flutter/material.dart';

import '../domain/foods.dart';
import '../domain/pet_rules.dart';

/// 표정 시트의 칸 (PRD 3.5): 기본 | 눈 감음 | 기쁨 | 배고픔.
enum SpriteCell { neutral, blink, happy, hungry }

/// 펫 표정 시트(1행 × 4칸)에서 한 칸만 보여준다. 픽셀이 흐려지지 않게 FilterQuality.none.
class PetSprite extends StatelessWidget {
  const PetSprite({
    super.key,
    required this.speciesId,
    required this.stage,
    this.cell = SpriteCell.neutral,
    this.size = 64,
  });

  final String speciesId;
  final int stage;
  final SpriteCell cell;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = stage.clamp(1, PetRules.maxStagePhase1);
    return SizedBox.square(
      dimension: size,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: size * 4,
          maxHeight: size,
          // 칸 0~3 → 정렬 x -1, -1/3, 1/3, 1
          alignment: Alignment(-1 + cell.index * 2 / 3, 0),
          child: Image.asset(
            'assets/pets/$speciesId/stage$s.png',
            width: size * 4,
            height: size,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.none,
          ),
        ),
      ),
    );
  }
}

/// 먹이 아이콘 (32×32 원본을 확대).
class FoodIcon extends StatelessWidget {
  const FoodIcon(this.food, {super.key, this.size = 40});

  final FoodItem food;
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/food/${food.id}.png',
    width: size,
    height: size,
    filterQuality: FilterQuality.none,
  );
}
