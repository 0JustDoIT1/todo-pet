/// 시작 펫 3종 (2026-11-25 결정). id는 DB와 그림 경로(`assets/pets/<id>/`)에 쓰이므로 바꾸지 않는다.
class PetSpecies {
  const PetSpecies(this.id, this.name, this.placeholder);

  final String id;
  final String name;

  /// 그림이 생기기 전까지 쓰는 임시 표시.
  final String placeholder;
}

const starterSpecies = [
  PetSpecies('cat', '고양이', '🐱'),
  PetSpecies('dog', '강아지', '🐶'),
  PetSpecies('rabbit', '토끼', '🐰'),
];

PetSpecies? speciesById(String id) {
  for (final s in starterSpecies) {
    if (s.id == id) return s;
  }
  return null;
}
