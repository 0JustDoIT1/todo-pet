import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_pet/app.dart';
import 'package:todo_pet/core/date/now_provider.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/core/db/database_provider.dart';

void main() {
  testWidgets('앱이 뜨고 하단 탭 4개로 화면을 전환한다', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          nowProvider.overrideWithValue(() => DateTime(2026, 11, 25, 9)),
        ],
        child: const TodoPetApp(),
      ),
    );

    for (final label in ['홈', '할일', '상점', '설정']) {
      expect(find.widgetWithText(NavigationDestination, label), findsOneWidget);
    }

    await tester.tap(find.widgetWithText(NavigationDestination, '상점'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('먹이와 입양이 여기에 표시됩니다'), findsOneWidget);

    // 위젯 트리를 내려 자정 타이머를 정리한다.
    await tester.pumpWidget(const SizedBox());
  });
}
