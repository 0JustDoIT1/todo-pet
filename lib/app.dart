import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/ui/day_change_watcher.dart';
import 'core/ui/main_shell.dart';
import 'features/onboarding/data/onboarding_service.dart';
import 'features/onboarding/ui/onboarding_screen.dart';

class TodoPetApp extends StatelessWidget {
  const TodoPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '투두펫',
      theme: ThemeData(colorSchemeSeed: Colors.orange),
      locale: const Locale('ko'),
      supportedLocales: const [Locale('ko')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const _StartGate(),
    );
  }
}

/// 온보딩을 마치지 않았으면 온보딩, 마쳤으면 하단 탭 화면.
class _StartGate extends ConsumerWidget {
  const _StartGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(onboardingDoneProvider)) {
      AsyncData(value: true) => const DayChangeWatcher(child: MainShell()),
      AsyncData(value: false) => const OnboardingScreen(),
      AsyncError(:final error) => Scaffold(
        body: Center(child: Text('시작하지 못했어요: $error')),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}
