import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../todo/ui/todo_providers.dart';
import '../data/pet_service.dart';
import '../domain/foods.dart';
import 'pet_providers.dart';

/// 먹이를 사서 활성 펫에게 주고 결과를 SnackBar로 알린다 (홈·상점 공용).
/// 성공하면 결과를, 실패하면 null을 돌려준다.
Future<FeedResult?> feedPet(
  BuildContext context,
  WidgetRef ref,
  FoodItem food,
) async {
  final messenger = ScaffoldMessenger.of(context);
  FeedResult? result;
  String message;
  try {
    result = await ref.read(petServiceProvider).feed(food.id);
    message = result.grewUp
        ? '${food.name} -${food.price}P · 쑥 자랐어요!'
        : '${food.name} -${food.price}P';
  } on AppException catch (e) {
    message = e.message;
  }
  ref.invalidate(activePetProvider);
  ref.invalidate(balanceProvider);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  return result;
}
