import 'package:drift/drift.dart' show Value;
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
    // 온보딩을 마친 사용자 기준으로 하단 탭을 확인한다.
    await tester.runAsync(
      () => db
          .update(db.userProfile)
          .write(const UserProfileCompanion(onboardingDone: Value(true))),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          nowProvider.overrideWithValue(() => DateTime(2026, 11, 25, 9)),
        ],
        child: const TodoPetApp(),
      ),
    );

    // 시작 분기가 온보딩 완료 여부를 DB에서 읽을 때까지 기다린다.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();

    for (final label in ['홈', '할일', '상점', '설정']) {
      expect(find.widgetWithText(NavigationDestination, label), findsOneWidget);
    }

    await tester.tap(find.widgetWithText(NavigationDestination, '상점'));
    await tester.pump(const Duration(milliseconds: 500));
    // 상점 화면에만 있는 먹이 이름으로 전환을 확인한다.
    expect(find.text('기본 사료'), findsOneWidget);

    // 위젯 트리를 내려 자정 타이머를 정리한다.
    await tester.pumpWidget(const SizedBox());
  });
}
