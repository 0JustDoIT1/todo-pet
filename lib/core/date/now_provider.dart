import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 시각을 돌려주는 함수. 테스트에서는 overrideWithValue로 고정 시각을 넣는다.
final nowProvider = Provider<DateTime Function()>((ref) => DateTime.now);
