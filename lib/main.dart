import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // 앱에 넣은 글꼴(Jua, OFL)의 라이선스를 라이선스 화면에 보여준다.
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(const ['Jua (글꼴)'], text);
  });
  runApp(const ProviderScope(child: TodoPetApp()));
}
