import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/ui/day_change_watcher.dart';
import '../data/pet_service.dart';

/// 활성 펫의 현재 상태 (없으면 null).
/// 앱을 다시 열 때(날짜 넘김 재처리) 함께 새로 계산되도록 dayRolloverProvider를 본다.
final activePetProvider = FutureProvider<PetView?>((ref) async {
  await ref.watch(dayRolloverProvider.future);
  return ref.watch(petServiceProvider).activePet();
});

/// 보유한 펫 목록 (입양 가능 종, 설정의 펫 교체).
final ownedPetsProvider = FutureProvider<List<Pet>>(
  (ref) => ref.watch(petServiceProvider).allPets(),
);
