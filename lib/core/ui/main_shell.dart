import 'package:flutter/material.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/shop/ui/shop_screen.dart';
import '../../features/todo/ui/todo_screen.dart';

/// 하단 탭(홈·할일·상점·설정) 화면. PRD 7장.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    TodoScreen(),
    ShopScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
