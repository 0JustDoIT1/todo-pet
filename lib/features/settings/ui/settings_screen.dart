import 'package:flutter/material.dart';

/// 활성 펫 교체·이름 변경, 라이선스·에셋 출처 (PRD 7장). 지금은 빈 화면.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('설정 항목이 여기에 표시됩니다')),
    );
  }
}
