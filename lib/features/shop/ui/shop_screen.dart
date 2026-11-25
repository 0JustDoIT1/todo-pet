import 'package:flutter/material.dart';

/// 먹이 구매·시작 종 입양 (PRD 7장). 지금은 빈 화면.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상점')),
      body: const Center(child: Text('먹이와 입양이 여기에 표시됩니다')),
    );
  }
}
