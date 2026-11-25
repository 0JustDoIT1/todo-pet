import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/ui/day_change_watcher.dart';
import 'core/ui/main_shell.dart';

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
      home: const DayChangeWatcher(child: MainShell()),
    );
  }
}
