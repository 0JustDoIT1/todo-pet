import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 둥근 테두리 안에 탭을 나란히 두고, 선택한 탭을 분홍 알약으로 채운다.
/// AppBar.bottom에도 넣을 수 있다. 탭 모양은 테마의 tabBarTheme.
class PillTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PillTabBar({super.key, required this.labels});

  final List<String> labels;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
    child: Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: TabBar(tabs: [for (final l in labels) Tab(text: l)]),
    ),
  );
}
