/// 할일 종류 (PRD F1).
enum TodoType { oneTime, repeat, checklist }

/// 난이도 하/중/상 (PRD F3).
enum Difficulty { low, mid, high }

/// 할일 회차 상태 (PRD 3.2·3.4). 취소해도 행은 남기고 상태만 바꾼다.
enum OccurrenceStatus { completed, canceled, absent }
