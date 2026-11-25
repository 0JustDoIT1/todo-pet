import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 하단 탭 순서.
enum MainTab { home, todo, shop, settings }

/// 현재 하단 탭. 다른 화면에서 탭을 옮길 때 쓴다 (예: 홈의 '전체보기').
class MainTabNotifier extends Notifier<MainTab> {
  @override
  MainTab build() => MainTab.home;

  void select(MainTab tab) => state = tab;
}

final mainTabProvider = NotifierProvider<MainTabNotifier, MainTab>(
  MainTabNotifier.new,
);
