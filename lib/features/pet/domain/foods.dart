/// 먹이 3종 (기획서 3.5). id는 DB(포인트 이력)에 저장되므로 바꾸지 않는다.
class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.hunger,
    required this.mood,
    required this.affection,
  });

  final String id;
  final String name;
  final int price;
  final int hunger;
  final int mood;

  /// 애정도 증가량. 기획서에 수치가 없어 초기값(조정 가능).
  final int affection;
}

const foods = [
  FoodItem(
    id: 'basic',
    name: '기본 사료',
    price: 10,
    hunger: 20,
    mood: 5,
    affection: 5,
  ),
  FoodItem(
    id: 'snack',
    name: '간식',
    price: 30,
    hunger: 10,
    mood: 15,
    affection: 5,
  ),
  FoodItem(
    id: 'special',
    name: '특별식',
    price: 100,
    hunger: 50,
    mood: 30,
    affection: 15,
  ),
];

FoodItem? foodById(String id) {
  for (final f in foods) {
    if (f.id == id) return f;
  }
  return null;
}
