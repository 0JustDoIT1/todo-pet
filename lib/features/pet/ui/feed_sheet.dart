import 'package:flutter/material.dart';

import '../domain/foods.dart';
import 'pet_sprite.dart';

/// 먹이 고르기 (기획서 5.8). 고른 먹이를 돌려준다. 구매·급여는 호출하는 쪽에서 한다.
Future<FoodItem?> showFeedSheet(
  BuildContext context, {
  required int balance,
  required bool full,
}) => showModalBottomSheet<FoodItem>(
  context: context,
  useSafeArea: true,
  builder: (context) => SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(full ? '배가 불러서 지금은 먹을 수 없어요' : '먹이 주기 (보유 ${balance}P)'),
        ),
        for (final f in foods)
          ListTile(
            leading: FoodIcon(f),
            title: Text(f.name),
            subtitle: Text('배고픔 +${f.hunger} · 기분 +${f.mood}'),
            trailing: Text('${f.price}P'),
            enabled: !full && balance >= f.price,
            onTap: () => Navigator.pop(context, f),
          ),
      ],
    ),
  ),
);
