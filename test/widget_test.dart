import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_pet/app.dart';

void main() {
  testWidgets('앱이 뜨고 하단 탭 4개로 화면을 전환한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TodoPetApp()));

    for (final label in ['홈', '할일', '상점', '설정']) {
      expect(find.widgetWithText(NavigationDestination, label), findsOneWidget);
    }

    await tester.tap(find.widgetWithText(NavigationDestination, '상점'));
    await tester.pumpAndSettle();
    expect(find.text('먹이와 입양이 여기에 표시됩니다'), findsOneWidget);
  });
}
