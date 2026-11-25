import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/shop/ui/shop_screen.dart';
import '../../features/todo/ui/todo_screen.dart';
import 'main_tab.dart';

/// 하단 탭(홈·할일·상점·설정) 화면. PRD 7장.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    TodoScreen(),
    ShopScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(mainTabProvider);
    return Scaffold(
      body: IndexedStack(index: tab.index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab.index,
        onDestinationSelected: (i) =>
            ref.read(mainTabProvider.notifier).select(MainTab.values[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.checklist), label: '할일'),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: '상점',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
