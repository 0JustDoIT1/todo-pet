import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 포인트 잔액 알약 (동전 + "125 P").
class PointPill extends StatelessWidget {
  const PointPill(this.balance, {super.key});

  final int balance;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
      decoration: BoxDecoration(
        color: AppColors.butter,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.coin,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 1.5),
            ),
            child: Text(
              'P',
              style: style?.copyWith(fontSize: 14, color: AppColors.ink),
            ),
          ),
          Text('$balance P', style: style),
        ],
      ),
    );
  }
}
