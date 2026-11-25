import 'package:flutter/material.dart';

/// 활성 펫과 오늘 할일 미리보기 (PRD 7장). 지금은 빈 화면.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: const Center(child: Text('펫과 오늘 할일이 여기에 표시됩니다')),
    );
  }
}
