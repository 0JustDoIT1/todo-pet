import 'package:flutter/material.dart';

import '../../../core/ui/app_theme.dart';

/// 홈 맵의 기본 방. 배경 그림(`bg_default`)이 들어오기 전까지 코드로 그린다.
/// 위쪽 [wallRatio]는 벽, 나머지는 바닥 (docs/ART_PROMPTS.md 4장과 같은 비율).
class RoomBackground extends StatelessWidget {
  const RoomBackground({super.key});

  static const wallRatio = 0.4;

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _RoomPainter(), size: Size.infinite);
}

class _RoomPainter extends CustomPainter {
  const _RoomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final floorTop = h * RoomBackground.wallRatio;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, floorTop),
      Paint()..color = AppColors.wall,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, floorTop, w, h - floorTop),
      Paint()..color = AppColors.floor,
    );

    // 바닥 타일: 가운데로 모이는 세로줄과 아래로 갈수록 넓어지는 가로줄.
    final tile = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;
    final vanish = Offset(w / 2, floorTop - h * 0.5);
    for (var i = -6; i <= 6; i++) {
      final bottomX = w / 2 + i * w / 5;
      final t = (floorTop - vanish.dy) / (h - vanish.dy);
      final topX = vanish.dx + (bottomX - vanish.dx) * t;
      canvas.drawLine(Offset(topX, floorTop), Offset(bottomX, h), tile);
    }
    var y = floorTop;
    var step = h * 0.05;
    while (y < h) {
      y += step;
      step *= 1.25;
      canvas.drawLine(Offset(0, y), Offset(w, y), tile);
    }

    // 걸레받이
    canvas.drawRect(
      Rect.fromLTWH(0, floorTop - 6, w, 8),
      Paint()..color = const Color(0xFFF2C2AE),
    );

    // 아치 창문
    final winW = w * 0.4;
    final winH = floorTop * 0.5;
    final left = w * 0.5 - winW / 2 + w * 0.2;
    final top = floorTop * 0.4;
    final window = RRect.fromRectAndCorners(
      Rect.fromLTWH(left, top, winW, winH),
      topLeft: Radius.circular(winW / 2),
      topRight: Radius.circular(winW / 2),
    );
    canvas.drawRRect(
      window.inflate(8),
      Paint()..color = const Color(0xFFE9A58C),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFFBFE3F7));
    final frame = Paint()
      ..color = const Color(0xFFE9A58C)
      ..strokeWidth = 6;
    canvas.drawLine(
      Offset(left + winW / 2, top),
      Offset(left + winW / 2, top + winH),
      frame,
    );
    canvas.drawLine(
      Offset(left, top + winH * 0.55),
      Offset(left + winW, top + winH * 0.55),
      frame,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
