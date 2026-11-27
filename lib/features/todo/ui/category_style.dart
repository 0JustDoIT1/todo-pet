import 'package:flutter/material.dart';

/// 카테고리별 아이콘과 칩 색 (화면 표시용). 카테고리 목록 자체는 domain/categories.dart.
(IconData, Color) categoryStyle(String id) => switch (id) {
  'work' => (Icons.laptop_mac, const Color(0xFFE6DDF7)),
  'health' => (Icons.fitness_center, const Color(0xFFDDF0D5)),
  'housework' => (Icons.shopping_basket_outlined, const Color(0xFFFCE3D3)),
  'growth' => (Icons.menu_book_outlined, const Color(0xFFDCEBF7)),
  'social' => (Icons.people_outline, const Color(0xFFFDE0E6)),
  'admin' => (Icons.description_outlined, const Color(0xFFEDE7DF)),
  'leisure' => (Icons.sports_esports_outlined, const Color(0xFFFFF0C2)),
  _ => (Icons.label_outline, const Color(0xFFF1EAE4)),
};
