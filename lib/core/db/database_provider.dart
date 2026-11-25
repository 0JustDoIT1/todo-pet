import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// 앱 전체에서 하나의 DB 연결을 쓴다. 테스트에서는 overrideWithValue로 메모리 DB를 넣는다.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
