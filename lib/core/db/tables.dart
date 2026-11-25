import 'package:drift/drift.dart';

import '../../features/points/domain/point_reason.dart';
import '../../features/todo/domain/todo_enums.dart';

// 날짜 컬럼(*Date)은 현지 기준 'yyyy-MM-dd' 문자열이다 (PRD 5장: 일일 기준은 현지 자정).
// 종·먹이·카테고리는 코드 상수라 문자열 id만 저장한다 (PRD 6장).

@TableIndex(name: 'todos_date', columns: {#date})
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<TodoType>()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get difficulty => textEnum<Difficulty>()();
  TextColumn get categoryId => text().nullable()();

  /// 원타임·체크리스트의 현재 날짜. 이월하면 바뀐다.
  TextColumn get date => text().nullable()();

  /// 처음 정한 날짜. "N일 지연" 표시에 쓴다.
  TextColumn get originalDate => text().nullable()();

  /// 반복 요일 비트마스크 (월=1, 화=2, … 일=64). 매일은 127.
  IntColumn get repeatWeekdays => integer().nullable()();

  /// 만든 날. 반복 할일은 이 날부터 결석을 기록한다.
  TextColumn get startDate => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// 삭제는 표시만 한다(지난 기록과 포인트 보존).
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get todoId => integer().references(Todos, #id)();
  TextColumn get title => text().withLength(min: 1)();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();
}

/// 할일 회차(할일 + 날짜). 포인트 중복 지급 방지 기준.
@TableIndex(name: 'todo_occurrences_date', columns: {#date})
class TodoOccurrences extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get todoId => integer().references(Todos, #id)();
  TextColumn get date => text()();
  TextColumn get status => textEnum<OccurrenceStatus>()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {todoId, date},
  ];
}

/// 포인트 이력. 추가만 하고 수정·삭제하지 않는다. 잔액은 amount 합계.
@TableIndex(name: 'point_history_date', columns: {#date})
class PointHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get reason => textEnum<PointReason>()();
  TextColumn get date => text()();
  IntColumn get occurrenceId =>
      integer().nullable().references(TodoOccurrences, #id)();

  /// 먹이 id 또는 입양한 종 id.
  TextColumn get itemId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class Pets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get speciesId => text().unique()();
  TextColumn get name => text().withLength(min: 1, max: 10)();
  IntColumn get stage => integer().withDefault(const Constant(1))();
  IntColumn get exp => integer().withDefault(const Constant(0))();
  IntColumn get mood => integer()();
  IntColumn get hunger => integer()();
  DateTimeColumn get lastUpdatedAt => dateTime()();
  IntColumn get tapCount => integer().withDefault(const Constant(0))();
  TextColumn get tapDate => text().nullable()();
}

/// 항상 1행(id = 1).
class UserProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get activePetId => integer().nullable().references(Pets, #id)();
  TextColumn get lastProcessedDate => text().nullable()();
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
