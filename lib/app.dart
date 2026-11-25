import 'package:flutter/material.dart';

import 'core/ui/main_shell.dart';

class TodoPetApp extends StatelessWidget {
  const TodoPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '투두펫',
      theme: ThemeData(colorSchemeSeed: Colors.orange),
      home: const MainShell(),
    );
  }
}
