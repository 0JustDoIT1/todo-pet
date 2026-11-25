/// 고정 카테고리 8종 (기획서 2.9). id는 DB에 저장되므로 바꾸지 않는다.
/// Phase 2에서 카테고리 테이블을 만들면 같은 id로 시드한다.
class TodoCategory {
  const TodoCategory(this.id, this.name, this.examples);

  final String id;
  final String name;
  final String examples;
}

const todoCategories = [
  TodoCategory('work', '일/공부', '회의, 과제, 업무, 시험공부'),
  TodoCategory('health', '운동/건강', '운동, 병원, 약 챙기기'),
  TodoCategory('housework', '집안일', '청소, 빨래, 장보기, 요리'),
  TodoCategory('growth', '자기계발', '독서, 강의, 언어공부'),
  TodoCategory('social', '약속/모임', '연락하기, 만남, 경조사'),
  TodoCategory('admin', '행정/서류', '공과금, 은행업무, 서류처리'),
  TodoCategory('leisure', '취미/휴식', '게임, 영화, 산책'),
  TodoCategory('etc', '기타', '그 외'),
];

TodoCategory? categoryById(String? id) {
  for (final c in todoCategories) {
    if (c.id == id) return c;
  }
  return null;
}
