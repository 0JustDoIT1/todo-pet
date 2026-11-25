import 'package:flutter/material.dart';

/// 오늘·캘린더·완료 보기 (PRD F2). 지금은 빈 화면.
class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('할일')),
      body: const Center(child: Text('할일 목록이 여기에 표시됩니다')),
    );
  }
}
