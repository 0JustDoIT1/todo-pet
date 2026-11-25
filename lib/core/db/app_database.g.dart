// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TodoType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TodoType>($TodosTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Difficulty, String> difficulty =
      GeneratedColumn<String>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Difficulty>($TodosTable.$converterdifficulty);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalDateMeta = const VerificationMeta(
    'originalDate',
  );
  @override
  late final GeneratedColumn<String> originalDate = GeneratedColumn<String>(
    'original_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatWeekdaysMeta = const VerificationMeta(
    'repeatWeekdays',
  );
  @override
  late final GeneratedColumn<int> repeatWeekdays = GeneratedColumn<int>(
    'repeat_weekdays',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    difficulty,
    categoryId,
    date,
    originalDate,
    repeatWeekdays,
    startDate,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('original_date')) {
      context.handle(
        _originalDateMeta,
        originalDate.isAcceptableOrUnknown(
          data['original_date']!,
          _originalDateMeta,
        ),
      );
    }
    if (data.containsKey('repeat_weekdays')) {
      context.handle(
        _repeatWeekdaysMeta,
        repeatWeekdays.isAcceptableOrUnknown(
          data['repeat_weekdays']!,
          _repeatWeekdaysMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: $TodosTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      difficulty: $TodosTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      originalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_date'],
      ),
      repeatWeekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_weekdays'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TodoType, String, String> $convertertype =
      const EnumNameConverter<TodoType>(TodoType.values);
  static JsonTypeConverter2<Difficulty, String, String> $converterdifficulty =
      const EnumNameConverter<Difficulty>(Difficulty.values);
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final TodoType type;
  final String title;
  final Difficulty difficulty;
  final String? categoryId;

  /// 원타임·체크리스트의 현재 날짜. 이월하면 바뀐다.
  final String? date;

  /// 처음 정한 날짜. "N일 지연" 표시에 쓴다.
  final String? originalDate;

  /// 반복 요일 비트마스크 (월=1, 화=2, … 일=64). 매일은 127.
  final int? repeatWeekdays;

  /// 만든 날. 반복 할일은 이 날부터 결석을 기록한다.
  final String startDate;
  final DateTime createdAt;

  /// 삭제는 표시만 한다(지난 기록과 포인트 보존).
  final DateTime? deletedAt;
  const Todo({
    required this.id,
    required this.type,
    required this.title,
    required this.difficulty,
    this.categoryId,
    this.date,
    this.originalDate,
    this.repeatWeekdays,
    required this.startDate,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['type'] = Variable<String>($TodosTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    {
      map['difficulty'] = Variable<String>(
        $TodosTable.$converterdifficulty.toSql(difficulty),
      );
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || originalDate != null) {
      map['original_date'] = Variable<String>(originalDate);
    }
    if (!nullToAbsent || repeatWeekdays != null) {
      map['repeat_weekdays'] = Variable<int>(repeatWeekdays);
    }
    map['start_date'] = Variable<String>(startDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      difficulty: Value(difficulty),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      originalDate: originalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(originalDate),
      repeatWeekdays: repeatWeekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatWeekdays),
      startDate: Value(startDate),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      type: $TodosTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      title: serializer.fromJson<String>(json['title']),
      difficulty: $TodosTable.$converterdifficulty.fromJson(
        serializer.fromJson<String>(json['difficulty']),
      ),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      date: serializer.fromJson<String?>(json['date']),
      originalDate: serializer.fromJson<String?>(json['originalDate']),
      repeatWeekdays: serializer.fromJson<int?>(json['repeatWeekdays']),
      startDate: serializer.fromJson<String>(json['startDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(
        $TodosTable.$convertertype.toJson(type),
      ),
      'title': serializer.toJson<String>(title),
      'difficulty': serializer.toJson<String>(
        $TodosTable.$converterdifficulty.toJson(difficulty),
      ),
      'categoryId': serializer.toJson<String?>(categoryId),
      'date': serializer.toJson<String?>(date),
      'originalDate': serializer.toJson<String?>(originalDate),
      'repeatWeekdays': serializer.toJson<int?>(repeatWeekdays),
      'startDate': serializer.toJson<String>(startDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Todo copyWith({
    int? id,
    TodoType? type,
    String? title,
    Difficulty? difficulty,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> date = const Value.absent(),
    Value<String?> originalDate = const Value.absent(),
    Value<int?> repeatWeekdays = const Value.absent(),
    String? startDate,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Todo(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    difficulty: difficulty ?? this.difficulty,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    date: date.present ? date.value : this.date,
    originalDate: originalDate.present ? originalDate.value : this.originalDate,
    repeatWeekdays: repeatWeekdays.present
        ? repeatWeekdays.value
        : this.repeatWeekdays,
    startDate: startDate ?? this.startDate,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      originalDate: data.originalDate.present
          ? data.originalDate.value
          : this.originalDate,
      repeatWeekdays: data.repeatWeekdays.present
          ? data.repeatWeekdays.value
          : this.repeatWeekdays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('originalDate: $originalDate, ')
          ..write('repeatWeekdays: $repeatWeekdays, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    difficulty,
    categoryId,
    date,
    originalDate,
    repeatWeekdays,
    startDate,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.difficulty == this.difficulty &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.originalDate == this.originalDate &&
          other.repeatWeekdays == this.repeatWeekdays &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<TodoType> type;
  final Value<String> title;
  final Value<Difficulty> difficulty;
  final Value<String?> categoryId;
  final Value<String?> date;
  final Value<String?> originalDate;
  final Value<int?> repeatWeekdays;
  final Value<String> startDate;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.originalDate = const Value.absent(),
    this.repeatWeekdays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required TodoType type,
    required String title,
    required Difficulty difficulty,
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.originalDate = const Value.absent(),
    this.repeatWeekdays = const Value.absent(),
    required String startDate,
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
  }) : type = Value(type),
       title = Value(title),
       difficulty = Value(difficulty),
       startDate = Value(startDate),
       createdAt = Value(createdAt);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? difficulty,
    Expression<String>? categoryId,
    Expression<String>? date,
    Expression<String>? originalDate,
    Expression<int>? repeatWeekdays,
    Expression<String>? startDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (difficulty != null) 'difficulty': difficulty,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (originalDate != null) 'original_date': originalDate,
      if (repeatWeekdays != null) 'repeat_weekdays': repeatWeekdays,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  TodosCompanion copyWith({
    Value<int>? id,
    Value<TodoType>? type,
    Value<String>? title,
    Value<Difficulty>? difficulty,
    Value<String?>? categoryId,
    Value<String?>? date,
    Value<String?>? originalDate,
    Value<int?>? repeatWeekdays,
    Value<String>? startDate,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      originalDate: originalDate ?? this.originalDate,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TodosTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(
        $TodosTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (originalDate.present) {
      map['original_date'] = Variable<String>(originalDate.value);
    }
    if (repeatWeekdays.present) {
      map['repeat_weekdays'] = Variable<int>(repeatWeekdays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('difficulty: $difficulty, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('originalDate: $originalDate, ')
          ..write('repeatWeekdays: $repeatWeekdays, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<int> todoId = GeneratedColumn<int>(
    'todo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES todos (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, todoId, title, checked, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}todo_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final int id;
  final int todoId;
  final String title;
  final bool checked;
  final int sortOrder;
  const ChecklistItem({
    required this.id,
    required this.todoId,
    required this.title,
    required this.checked,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['todo_id'] = Variable<int>(todoId);
    map['title'] = Variable<String>(title);
    map['checked'] = Variable<bool>(checked);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      todoId: Value(todoId),
      title: Value(title),
      checked: Value(checked),
      sortOrder: Value(sortOrder),
    );
  }

  factory ChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<int>(json['id']),
      todoId: serializer.fromJson<int>(json['todoId']),
      title: serializer.fromJson<String>(json['title']),
      checked: serializer.fromJson<bool>(json['checked']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'todoId': serializer.toJson<int>(todoId),
      'title': serializer.toJson<String>(title),
      'checked': serializer.toJson<bool>(checked),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ChecklistItem copyWith({
    int? id,
    int? todoId,
    String? title,
    bool? checked,
    int? sortOrder,
  }) => ChecklistItem(
    id: id ?? this.id,
    todoId: todoId ?? this.todoId,
    title: title ?? this.title,
    checked: checked ?? this.checked,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      title: data.title.present ? data.title.value : this.title,
      checked: data.checked.present ? data.checked.value : this.checked,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('checked: $checked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, todoId, title, checked, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.title == this.title &&
          other.checked == this.checked &&
          other.sortOrder == this.sortOrder);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<int> id;
  final Value<int> todoId;
  final Value<String> title;
  final Value<bool> checked;
  final Value<int> sortOrder;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.title = const Value.absent(),
    this.checked = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int todoId,
    required String title,
    this.checked = const Value.absent(),
    required int sortOrder,
  }) : todoId = Value(todoId),
       title = Value(title),
       sortOrder = Value(sortOrder);
  static Insertable<ChecklistItem> custom({
    Expression<int>? id,
    Expression<int>? todoId,
    Expression<String>? title,
    Expression<bool>? checked,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (title != null) 'title': title,
      if (checked != null) 'checked': checked,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? todoId,
    Value<String>? title,
    Value<bool>? checked,
    Value<int>? sortOrder,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      checked: checked ?? this.checked,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<int>(todoId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('title: $title, ')
          ..write('checked: $checked, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $TodoOccurrencesTable extends TodoOccurrences
    with TableInfo<$TodoOccurrencesTable, TodoOccurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<int> todoId = GeneratedColumn<int>(
    'todo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES todos (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OccurrenceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OccurrenceStatus>($TodoOccurrencesTable.$converterstatus);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, todoId, date, status, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoOccurrence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('todo_id')) {
      context.handle(
        _todoIdMeta,
        todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {todoId, date},
  ];
  @override
  TodoOccurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoOccurrence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      todoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}todo_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      status: $TodoOccurrencesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TodoOccurrencesTable createAlias(String alias) {
    return $TodoOccurrencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OccurrenceStatus, String, String> $converterstatus =
      const EnumNameConverter<OccurrenceStatus>(OccurrenceStatus.values);
}

class TodoOccurrence extends DataClass implements Insertable<TodoOccurrence> {
  final int id;
  final int todoId;
  final String date;
  final OccurrenceStatus status;
  final DateTime? completedAt;
  const TodoOccurrence({
    required this.id,
    required this.todoId,
    required this.date,
    required this.status,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['todo_id'] = Variable<int>(todoId);
    map['date'] = Variable<String>(date);
    {
      map['status'] = Variable<String>(
        $TodoOccurrencesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TodoOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return TodoOccurrencesCompanion(
      id: Value(id),
      todoId: Value(todoId),
      date: Value(date),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory TodoOccurrence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoOccurrence(
      id: serializer.fromJson<int>(json['id']),
      todoId: serializer.fromJson<int>(json['todoId']),
      date: serializer.fromJson<String>(json['date']),
      status: $TodoOccurrencesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'todoId': serializer.toJson<int>(todoId),
      'date': serializer.toJson<String>(date),
      'status': serializer.toJson<String>(
        $TodoOccurrencesTable.$converterstatus.toJson(status),
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  TodoOccurrence copyWith({
    int? id,
    int? todoId,
    String? date,
    OccurrenceStatus? status,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => TodoOccurrence(
    id: id ?? this.id,
    todoId: todoId ?? this.todoId,
    date: date ?? this.date,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  TodoOccurrence copyWithCompanion(TodoOccurrencesCompanion data) {
    return TodoOccurrence(
      id: data.id.present ? data.id.value : this.id,
      todoId: data.todoId.present ? data.todoId.value : this.todoId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoOccurrence(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, todoId, date, status, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoOccurrence &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.date == this.date &&
          other.status == this.status &&
          other.completedAt == this.completedAt);
}

class TodoOccurrencesCompanion extends UpdateCompanion<TodoOccurrence> {
  final Value<int> id;
  final Value<int> todoId;
  final Value<String> date;
  final Value<OccurrenceStatus> status;
  final Value<DateTime?> completedAt;
  const TodoOccurrencesCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  TodoOccurrencesCompanion.insert({
    this.id = const Value.absent(),
    required int todoId,
    required String date,
    required OccurrenceStatus status,
    this.completedAt = const Value.absent(),
  }) : todoId = Value(todoId),
       date = Value(date),
       status = Value(status);
  static Insertable<TodoOccurrence> custom({
    Expression<int>? id,
    Expression<int>? todoId,
    Expression<String>? date,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  TodoOccurrencesCompanion copyWith({
    Value<int>? id,
    Value<int>? todoId,
    Value<String>? date,
    Value<OccurrenceStatus>? status,
    Value<DateTime?>? completedAt,
  }) {
    return TodoOccurrencesCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      date: date ?? this.date,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<int>(todoId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $TodoOccurrencesTable.$converterstatus.toSql(status.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $PointHistoryTable extends PointHistory
    with TableInfo<$PointHistoryTable, PointHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PointReason, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PointReason>($PointHistoryTable.$converterreason);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurrenceIdMeta = const VerificationMeta(
    'occurrenceId',
  );
  @override
  late final GeneratedColumn<int> occurrenceId = GeneratedColumn<int>(
    'occurrence_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES todo_occurrences (id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    reason,
    date,
    occurrenceId,
    itemId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'point_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('occurrence_id')) {
      context.handle(
        _occurrenceIdMeta,
        occurrenceId.isAcceptableOrUnknown(
          data['occurrence_id']!,
          _occurrenceIdMeta,
        ),
      );
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      reason: $PointHistoryTable.$converterreason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      occurrenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_id'],
      ),
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PointHistoryTable createAlias(String alias) {
    return $PointHistoryTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PointReason, String, String> $converterreason =
      const EnumNameConverter<PointReason>(PointReason.values);
}

class PointHistoryData extends DataClass
    implements Insertable<PointHistoryData> {
  final int id;
  final int amount;
  final PointReason reason;
  final String date;
  final int? occurrenceId;

  /// 먹이 id 또는 입양한 종 id.
  final String? itemId;
  final DateTime createdAt;
  const PointHistoryData({
    required this.id,
    required this.amount,
    required this.reason,
    required this.date,
    this.occurrenceId,
    this.itemId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    {
      map['reason'] = Variable<String>(
        $PointHistoryTable.$converterreason.toSql(reason),
      );
    }
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || occurrenceId != null) {
      map['occurrence_id'] = Variable<int>(occurrenceId);
    }
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PointHistoryCompanion toCompanion(bool nullToAbsent) {
    return PointHistoryCompanion(
      id: Value(id),
      amount: Value(amount),
      reason: Value(reason),
      date: Value(date),
      occurrenceId: occurrenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      createdAt: Value(createdAt),
    );
  }

  factory PointHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointHistoryData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      reason: $PointHistoryTable.$converterreason.fromJson(
        serializer.fromJson<String>(json['reason']),
      ),
      date: serializer.fromJson<String>(json['date']),
      occurrenceId: serializer.fromJson<int?>(json['occurrenceId']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'reason': serializer.toJson<String>(
        $PointHistoryTable.$converterreason.toJson(reason),
      ),
      'date': serializer.toJson<String>(date),
      'occurrenceId': serializer.toJson<int?>(occurrenceId),
      'itemId': serializer.toJson<String?>(itemId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PointHistoryData copyWith({
    int? id,
    int? amount,
    PointReason? reason,
    String? date,
    Value<int?> occurrenceId = const Value.absent(),
    Value<String?> itemId = const Value.absent(),
    DateTime? createdAt,
  }) => PointHistoryData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    reason: reason ?? this.reason,
    date: date ?? this.date,
    occurrenceId: occurrenceId.present ? occurrenceId.value : this.occurrenceId,
    itemId: itemId.present ? itemId.value : this.itemId,
    createdAt: createdAt ?? this.createdAt,
  );
  PointHistoryData copyWithCompanion(PointHistoryCompanion data) {
    return PointHistoryData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      date: data.date.present ? data.date.value : this.date,
      occurrenceId: data.occurrenceId.present
          ? data.occurrenceId.value
          : this.occurrenceId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointHistoryData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amount, reason, date, occurrenceId, itemId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointHistoryData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.date == this.date &&
          other.occurrenceId == this.occurrenceId &&
          other.itemId == this.itemId &&
          other.createdAt == this.createdAt);
}

class PointHistoryCompanion extends UpdateCompanion<PointHistoryData> {
  final Value<int> id;
  final Value<int> amount;
  final Value<PointReason> reason;
  final Value<String> date;
  final Value<int?> occurrenceId;
  final Value<String?> itemId;
  final Value<DateTime> createdAt;
  const PointHistoryCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.date = const Value.absent(),
    this.occurrenceId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PointHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required PointReason reason,
    required String date,
    this.occurrenceId = const Value.absent(),
    this.itemId = const Value.absent(),
    required DateTime createdAt,
  }) : amount = Value(amount),
       reason = Value(reason),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<PointHistoryData> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? reason,
    Expression<String>? date,
    Expression<int>? occurrenceId,
    Expression<String>? itemId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (date != null) 'date': date,
      if (occurrenceId != null) 'occurrence_id': occurrenceId,
      if (itemId != null) 'item_id': itemId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PointHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<PointReason>? reason,
    Value<String>? date,
    Value<int?>? occurrenceId,
    Value<String?>? itemId,
    Value<DateTime>? createdAt,
  }) {
    return PointHistoryCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      itemId: itemId ?? this.itemId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $PointHistoryTable.$converterreason.toSql(reason.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (occurrenceId.present) {
      map['occurrence_id'] = Variable<int>(occurrenceId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointHistoryCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('date: $date, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('itemId: $itemId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<int> stage = GeneratedColumn<int>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
    'exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hungerMeta = const VerificationMeta('hunger');
  @override
  late final GeneratedColumn<int> hunger = GeneratedColumn<int>(
    'hunger',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tapCountMeta = const VerificationMeta(
    'tapCount',
  );
  @override
  late final GeneratedColumn<int> tapCount = GeneratedColumn<int>(
    'tap_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tapDateMeta = const VerificationMeta(
    'tapDate',
  );
  @override
  late final GeneratedColumn<String> tapDate = GeneratedColumn<String>(
    'tap_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    speciesId,
    name,
    stage,
    exp,
    mood,
    hunger,
    lastUpdatedAt,
    tapCount,
    tapDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    }
    if (data.containsKey('exp')) {
      context.handle(
        _expMeta,
        exp.isAcceptableOrUnknown(data['exp']!, _expMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('hunger')) {
      context.handle(
        _hungerMeta,
        hunger.isAcceptableOrUnknown(data['hunger']!, _hungerMeta),
      );
    } else if (isInserting) {
      context.missing(_hungerMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('tap_count')) {
      context.handle(
        _tapCountMeta,
        tapCount.isAcceptableOrUnknown(data['tap_count']!, _tapCountMeta),
      );
    }
    if (data.containsKey('tap_date')) {
      context.handle(
        _tapDateMeta,
        tapDate.isAcceptableOrUnknown(data['tap_date']!, _tapDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stage'],
      )!,
      exp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      hunger: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hunger'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      tapCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tap_count'],
      )!,
      tapDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tap_date'],
      ),
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
  final int id;
  final String speciesId;
  final String name;
  final int stage;
  final int exp;
  final int mood;
  final int hunger;
  final DateTime lastUpdatedAt;
  final int tapCount;
  final String? tapDate;
  const Pet({
    required this.id,
    required this.speciesId,
    required this.name,
    required this.stage,
    required this.exp,
    required this.mood,
    required this.hunger,
    required this.lastUpdatedAt,
    required this.tapCount,
    this.tapDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['species_id'] = Variable<String>(speciesId);
    map['name'] = Variable<String>(name);
    map['stage'] = Variable<int>(stage);
    map['exp'] = Variable<int>(exp);
    map['mood'] = Variable<int>(mood);
    map['hunger'] = Variable<int>(hunger);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    map['tap_count'] = Variable<int>(tapCount);
    if (!nullToAbsent || tapDate != null) {
      map['tap_date'] = Variable<String>(tapDate);
    }
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      speciesId: Value(speciesId),
      name: Value(name),
      stage: Value(stage),
      exp: Value(exp),
      mood: Value(mood),
      hunger: Value(hunger),
      lastUpdatedAt: Value(lastUpdatedAt),
      tapCount: Value(tapCount),
      tapDate: tapDate == null && nullToAbsent
          ? const Value.absent()
          : Value(tapDate),
    );
  }

  factory Pet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<int>(json['id']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      name: serializer.fromJson<String>(json['name']),
      stage: serializer.fromJson<int>(json['stage']),
      exp: serializer.fromJson<int>(json['exp']),
      mood: serializer.fromJson<int>(json['mood']),
      hunger: serializer.fromJson<int>(json['hunger']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      tapCount: serializer.fromJson<int>(json['tapCount']),
      tapDate: serializer.fromJson<String?>(json['tapDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'speciesId': serializer.toJson<String>(speciesId),
      'name': serializer.toJson<String>(name),
      'stage': serializer.toJson<int>(stage),
      'exp': serializer.toJson<int>(exp),
      'mood': serializer.toJson<int>(mood),
      'hunger': serializer.toJson<int>(hunger),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'tapCount': serializer.toJson<int>(tapCount),
      'tapDate': serializer.toJson<String?>(tapDate),
    };
  }

  Pet copyWith({
    int? id,
    String? speciesId,
    String? name,
    int? stage,
    int? exp,
    int? mood,
    int? hunger,
    DateTime? lastUpdatedAt,
    int? tapCount,
    Value<String?> tapDate = const Value.absent(),
  }) => Pet(
    id: id ?? this.id,
    speciesId: speciesId ?? this.speciesId,
    name: name ?? this.name,
    stage: stage ?? this.stage,
    exp: exp ?? this.exp,
    mood: mood ?? this.mood,
    hunger: hunger ?? this.hunger,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    tapCount: tapCount ?? this.tapCount,
    tapDate: tapDate.present ? tapDate.value : this.tapDate,
  );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      name: data.name.present ? data.name.value : this.name,
      stage: data.stage.present ? data.stage.value : this.stage,
      exp: data.exp.present ? data.exp.value : this.exp,
      mood: data.mood.present ? data.mood.value : this.mood,
      hunger: data.hunger.present ? data.hunger.value : this.hunger,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      tapCount: data.tapCount.present ? data.tapCount.value : this.tapCount,
      tapDate: data.tapDate.present ? data.tapDate.value : this.tapDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('name: $name, ')
          ..write('stage: $stage, ')
          ..write('exp: $exp, ')
          ..write('mood: $mood, ')
          ..write('hunger: $hunger, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('tapCount: $tapCount, ')
          ..write('tapDate: $tapDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    speciesId,
    name,
    stage,
    exp,
    mood,
    hunger,
    lastUpdatedAt,
    tapCount,
    tapDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.name == this.name &&
          other.stage == this.stage &&
          other.exp == this.exp &&
          other.mood == this.mood &&
          other.hunger == this.hunger &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.tapCount == this.tapCount &&
          other.tapDate == this.tapDate);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<int> id;
  final Value<String> speciesId;
  final Value<String> name;
  final Value<int> stage;
  final Value<int> exp;
  final Value<int> mood;
  final Value<int> hunger;
  final Value<DateTime> lastUpdatedAt;
  final Value<int> tapCount;
  final Value<String?> tapDate;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.name = const Value.absent(),
    this.stage = const Value.absent(),
    this.exp = const Value.absent(),
    this.mood = const Value.absent(),
    this.hunger = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.tapCount = const Value.absent(),
    this.tapDate = const Value.absent(),
  });
  PetsCompanion.insert({
    this.id = const Value.absent(),
    required String speciesId,
    required String name,
    this.stage = const Value.absent(),
    this.exp = const Value.absent(),
    required int mood,
    required int hunger,
    required DateTime lastUpdatedAt,
    this.tapCount = const Value.absent(),
    this.tapDate = const Value.absent(),
  }) : speciesId = Value(speciesId),
       name = Value(name),
       mood = Value(mood),
       hunger = Value(hunger),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<Pet> custom({
    Expression<int>? id,
    Expression<String>? speciesId,
    Expression<String>? name,
    Expression<int>? stage,
    Expression<int>? exp,
    Expression<int>? mood,
    Expression<int>? hunger,
    Expression<DateTime>? lastUpdatedAt,
    Expression<int>? tapCount,
    Expression<String>? tapDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (name != null) 'name': name,
      if (stage != null) 'stage': stage,
      if (exp != null) 'exp': exp,
      if (mood != null) 'mood': mood,
      if (hunger != null) 'hunger': hunger,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (tapCount != null) 'tap_count': tapCount,
      if (tapDate != null) 'tap_date': tapDate,
    });
  }

  PetsCompanion copyWith({
    Value<int>? id,
    Value<String>? speciesId,
    Value<String>? name,
    Value<int>? stage,
    Value<int>? exp,
    Value<int>? mood,
    Value<int>? hunger,
    Value<DateTime>? lastUpdatedAt,
    Value<int>? tapCount,
    Value<String?>? tapDate,
  }) {
    return PetsCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      name: name ?? this.name,
      stage: stage ?? this.stage,
      exp: exp ?? this.exp,
      mood: mood ?? this.mood,
      hunger: hunger ?? this.hunger,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      tapCount: tapCount ?? this.tapCount,
      tapDate: tapDate ?? this.tapDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stage.present) {
      map['stage'] = Variable<int>(stage.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (hunger.present) {
      map['hunger'] = Variable<int>(hunger.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (tapCount.present) {
      map['tap_count'] = Variable<int>(tapCount.value);
    }
    if (tapDate.present) {
      map['tap_date'] = Variable<String>(tapDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('name: $name, ')
          ..write('stage: $stage, ')
          ..write('exp: $exp, ')
          ..write('mood: $mood, ')
          ..write('hunger: $hunger, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('tapCount: $tapCount, ')
          ..write('tapDate: $tapDate')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _activePetIdMeta = const VerificationMeta(
    'activePetId',
  );
  @override
  late final GeneratedColumn<int> activePetId = GeneratedColumn<int>(
    'active_pet_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pets (id)',
    ),
  );
  static const VerificationMeta _lastProcessedDateMeta = const VerificationMeta(
    'lastProcessedDate',
  );
  @override
  late final GeneratedColumn<String> lastProcessedDate =
      GeneratedColumn<String>(
        'last_processed_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activePetId,
    lastProcessedDate,
    onboardingDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active_pet_id')) {
      context.handle(
        _activePetIdMeta,
        activePetId.isAcceptableOrUnknown(
          data['active_pet_id']!,
          _activePetIdMeta,
        ),
      );
    }
    if (data.containsKey('last_processed_date')) {
      context.handle(
        _lastProcessedDateMeta,
        lastProcessedDate.isAcceptableOrUnknown(
          data['last_processed_date']!,
          _lastProcessedDateMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activePetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}active_pet_id'],
      ),
      lastProcessedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_processed_date'],
      ),
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final int? activePetId;
  final String? lastProcessedDate;
  final bool onboardingDone;
  const UserProfileData({
    required this.id,
    this.activePetId,
    this.lastProcessedDate,
    required this.onboardingDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || activePetId != null) {
      map['active_pet_id'] = Variable<int>(activePetId);
    }
    if (!nullToAbsent || lastProcessedDate != null) {
      map['last_processed_date'] = Variable<String>(lastProcessedDate);
    }
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      activePetId: activePetId == null && nullToAbsent
          ? const Value.absent()
          : Value(activePetId),
      lastProcessedDate: lastProcessedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProcessedDate),
      onboardingDone: Value(onboardingDone),
    );
  }

  factory UserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      activePetId: serializer.fromJson<int?>(json['activePetId']),
      lastProcessedDate: serializer.fromJson<String?>(
        json['lastProcessedDate'],
      ),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activePetId': serializer.toJson<int?>(activePetId),
      'lastProcessedDate': serializer.toJson<String?>(lastProcessedDate),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
    };
  }

  UserProfileData copyWith({
    int? id,
    Value<int?> activePetId = const Value.absent(),
    Value<String?> lastProcessedDate = const Value.absent(),
    bool? onboardingDone,
  }) => UserProfileData(
    id: id ?? this.id,
    activePetId: activePetId.present ? activePetId.value : this.activePetId,
    lastProcessedDate: lastProcessedDate.present
        ? lastProcessedDate.value
        : this.lastProcessedDate,
    onboardingDone: onboardingDone ?? this.onboardingDone,
  );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      activePetId: data.activePetId.present
          ? data.activePetId.value
          : this.activePetId,
      lastProcessedDate: data.lastProcessedDate.present
          ? data.lastProcessedDate.value
          : this.lastProcessedDate,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('activePetId: $activePetId, ')
          ..write('lastProcessedDate: $lastProcessedDate, ')
          ..write('onboardingDone: $onboardingDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, activePetId, lastProcessedDate, onboardingDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.activePetId == this.activePetId &&
          other.lastProcessedDate == this.lastProcessedDate &&
          other.onboardingDone == this.onboardingDone);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<int?> activePetId;
  final Value<String?> lastProcessedDate;
  final Value<bool> onboardingDone;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.activePetId = const Value.absent(),
    this.lastProcessedDate = const Value.absent(),
    this.onboardingDone = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    this.activePetId = const Value.absent(),
    this.lastProcessedDate = const Value.absent(),
    this.onboardingDone = const Value.absent(),
  });
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<int>? activePetId,
    Expression<String>? lastProcessedDate,
    Expression<bool>? onboardingDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activePetId != null) 'active_pet_id': activePetId,
      if (lastProcessedDate != null) 'last_processed_date': lastProcessedDate,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<int?>? activePetId,
    Value<String?>? lastProcessedDate,
    Value<bool>? onboardingDone,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      activePetId: activePetId ?? this.activePetId,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activePetId.present) {
      map['active_pet_id'] = Variable<int>(activePetId.value);
    }
    if (lastProcessedDate.present) {
      map['last_processed_date'] = Variable<String>(lastProcessedDate.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('activePetId: $activePetId, ')
          ..write('lastProcessedDate: $lastProcessedDate, ')
          ..write('onboardingDone: $onboardingDone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $TodoOccurrencesTable todoOccurrences = $TodoOccurrencesTable(
    this,
  );
  late final $PointHistoryTable pointHistory = $PointHistoryTable(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final Index todosDate = Index(
    'todos_date',
    'CREATE INDEX todos_date ON todos (date)',
  );
  late final Index todoOccurrencesDate = Index(
    'todo_occurrences_date',
    'CREATE INDEX todo_occurrences_date ON todo_occurrences (date)',
  );
  late final Index pointHistoryDate = Index(
    'point_history_date',
    'CREATE INDEX point_history_date ON point_history (date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    todos,
    checklistItems,
    todoOccurrences,
    pointHistory,
    pets,
    userProfile,
    todosDate,
    todoOccurrencesDate,
    pointHistoryDate,
  ];
}

typedef $$TodosTableCreateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      required TodoType type,
      required String title,
      required Difficulty difficulty,
      Value<String?> categoryId,
      Value<String?> date,
      Value<String?> originalDate,
      Value<int?> repeatWeekdays,
      required String startDate,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
    });
typedef $$TodosTableUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<int> id,
      Value<TodoType> type,
      Value<String> title,
      Value<Difficulty> difficulty,
      Value<String?> categoryId,
      Value<String?> date,
      Value<String?> originalDate,
      Value<int?> repeatWeekdays,
      Value<String> startDate,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
    });

final class $$TodosTableReferences
    extends BaseReferences<_$AppDatabase, $TodosTable, Todo> {
  $$TodosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItem>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'todos__id__checklist_items__todo_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.todoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TodoOccurrencesTable, List<TodoOccurrence>>
  _todoOccurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.todoOccurrences,
    aliasName: 'todos__id__todo_occurrences__todo_id',
  );

  $$TodoOccurrencesTableProcessedTableManager get todoOccurrencesRefs {
    final manager = $$TodoOccurrencesTableTableManager(
      $_db,
      $_db.todoOccurrences,
    ).filter((f) => f.todoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _todoOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TodoType, TodoType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Difficulty, Difficulty, String>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.todoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> todoOccurrencesRefs(
    Expression<bool> Function($$TodoOccurrencesTableFilterComposer f) f,
  ) {
    final $$TodoOccurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoOccurrences,
      getReferencedColumn: (t) => t.todoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoOccurrencesTableFilterComposer(
            $db: $db,
            $table: $db.todoOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TodoType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Difficulty, String> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.todoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> todoOccurrencesRefs<T extends Object>(
    Expression<T> Function($$TodoOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$TodoOccurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.todoOccurrences,
      getReferencedColumn: (t) => t.todoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoOccurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.todoOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, $$TodosTableReferences),
          Todo,
          PrefetchHooks Function({
            bool checklistItemsRefs,
            bool todoOccurrencesRefs,
          })
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TodoType> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<Difficulty> difficulty = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> originalDate = const Value.absent(),
                Value<int?> repeatWeekdays = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                type: type,
                title: title,
                difficulty: difficulty,
                categoryId: categoryId,
                date: date,
                originalDate: originalDate,
                repeatWeekdays: repeatWeekdays,
                startDate: startDate,
                createdAt: createdAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TodoType type,
                required String title,
                required Difficulty difficulty,
                Value<String?> categoryId = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<String?> originalDate = const Value.absent(),
                Value<int?> repeatWeekdays = const Value.absent(),
                required String startDate,
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                type: type,
                title: title,
                difficulty: difficulty,
                categoryId: categoryId,
                date: date,
                originalDate: originalDate,
                repeatWeekdays: repeatWeekdays,
                startDate: startDate,
                createdAt: createdAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodosTable, Todo>(table),
                  $$TodosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({checklistItemsRefs = false, todoOccurrencesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checklistItemsRefs) db.checklistItems,
                    if (todoOccurrencesRefs) db.todoOccurrences,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checklistItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Todo,
                          $TodosTable,
                          ChecklistItem,
                          $ChecklistItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TodosTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TodosTableReferences(
                                db,
                                table,
                                p0,
                              ).checklistItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'todo_id',
                          typedResults: items,
                        ),
                      if (todoOccurrencesRefs)
                        await $_getPrefetchedDataByColumns<
                          Todo,
                          $TodosTable,
                          TodoOccurrence,
                          $TodoOccurrencesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TodosTableReferences
                              ._todoOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TodosTableReferences(
                                db,
                                table,
                                p0,
                              ).todoOccurrencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'todo_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, $$TodosTableReferences),
      Todo,
      PrefetchHooks Function({
        bool checklistItemsRefs,
        bool todoOccurrencesRefs,
      })
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      required int todoId,
      required String title,
      Value<bool> checked,
      required int sortOrder,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      Value<int> todoId,
      Value<String> title,
      Value<bool> checked,
      Value<int> sortOrder,
    });

final class $$ChecklistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem> {
  $$ChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TodosTable _todoIdTable(_$AppDatabase db) =>
      db.todos.createAlias('checklist_items__todo_id__todos__id');

  $$TodosTableProcessedTableManager get todoId {
    final $_column = $_itemColumn<int>('todo_id')!;

    final manager = $$TodosTableTableManager(
      $_db,
      $_db.todos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_todoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TodosTableFilterComposer get todoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableFilterComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TodosTableOrderingComposer get todoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableOrderingComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TodosTableAnnotationComposer get todoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableAnnotationComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItem,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (ChecklistItem, $$ChecklistItemsTableReferences),
          ChecklistItem,
          PrefetchHooks Function({bool todoId})
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> todoId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                todoId: todoId,
                title: title,
                checked: checked,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int todoId,
                required String title,
                Value<bool> checked = const Value.absent(),
                required int sortOrder,
              }) => ChecklistItemsCompanion.insert(
                id: id,
                todoId: todoId,
                title: title,
                checked: checked,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChecklistItemsTable, ChecklistItem>(table),
                  $$ChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({todoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (todoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.todoId,
                                referencedTable: $$ChecklistItemsTableReferences
                                    ._todoIdTable(db),
                                referencedColumn:
                                    $$ChecklistItemsTableReferences
                                        ._todoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItem,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (ChecklistItem, $$ChecklistItemsTableReferences),
      ChecklistItem,
      PrefetchHooks Function({bool todoId})
    >;
typedef $$TodoOccurrencesTableCreateCompanionBuilder =
    TodoOccurrencesCompanion Function({
      Value<int> id,
      required int todoId,
      required String date,
      required OccurrenceStatus status,
      Value<DateTime?> completedAt,
    });
typedef $$TodoOccurrencesTableUpdateCompanionBuilder =
    TodoOccurrencesCompanion Function({
      Value<int> id,
      Value<int> todoId,
      Value<String> date,
      Value<OccurrenceStatus> status,
      Value<DateTime?> completedAt,
    });

final class $$TodoOccurrencesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TodoOccurrencesTable, TodoOccurrence> {
  $$TodoOccurrencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TodosTable _todoIdTable(_$AppDatabase db) =>
      db.todos.createAlias('todo_occurrences__todo_id__todos__id');

  $$TodosTableProcessedTableManager get todoId {
    final $_column = $_itemColumn<int>('todo_id')!;

    final manager = $$TodosTableTableManager(
      $_db,
      $_db.todos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_todoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PointHistoryTable, List<PointHistoryData>>
  _pointHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pointHistory,
    aliasName: 'todo_occurrences__id__point_history__occurrence_id',
  );

  $$PointHistoryTableProcessedTableManager get pointHistoryRefs {
    final manager = $$PointHistoryTableTableManager(
      $_db,
      $_db.pointHistory,
    ).filter((f) => f.occurrenceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pointHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TodoOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $TodoOccurrencesTable> {
  $$TodoOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OccurrenceStatus, OccurrenceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TodosTableFilterComposer get todoId {
    final $$TodosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableFilterComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pointHistoryRefs(
    Expression<bool> Function($$PointHistoryTableFilterComposer f) f,
  ) {
    final $$PointHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pointHistory,
      getReferencedColumn: (t) => t.occurrenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointHistoryTableFilterComposer(
            $db: $db,
            $table: $db.pointHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TodoOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoOccurrencesTable> {
  $$TodoOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TodosTableOrderingComposer get todoId {
    final $$TodosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableOrderingComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TodoOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoOccurrencesTable> {
  $$TodoOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OccurrenceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$TodosTableAnnotationComposer get todoId {
    final $$TodosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.todoId,
      referencedTable: $db.todos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodosTableAnnotationComposer(
            $db: $db,
            $table: $db.todos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pointHistoryRefs<T extends Object>(
    Expression<T> Function($$PointHistoryTableAnnotationComposer a) f,
  ) {
    final $$PointHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pointHistory,
      getReferencedColumn: (t) => t.occurrenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.pointHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TodoOccurrencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoOccurrencesTable,
          TodoOccurrence,
          $$TodoOccurrencesTableFilterComposer,
          $$TodoOccurrencesTableOrderingComposer,
          $$TodoOccurrencesTableAnnotationComposer,
          $$TodoOccurrencesTableCreateCompanionBuilder,
          $$TodoOccurrencesTableUpdateCompanionBuilder,
          (TodoOccurrence, $$TodoOccurrencesTableReferences),
          TodoOccurrence,
          PrefetchHooks Function({bool todoId, bool pointHistoryRefs})
        > {
  $$TodoOccurrencesTableTableManager(
    _$AppDatabase db,
    $TodoOccurrencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoOccurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoOccurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> todoId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<OccurrenceStatus> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => TodoOccurrencesCompanion(
                id: id,
                todoId: todoId,
                date: date,
                status: status,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int todoId,
                required String date,
                required OccurrenceStatus status,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => TodoOccurrencesCompanion.insert(
                id: id,
                todoId: todoId,
                date: date,
                status: status,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodoOccurrencesTable, TodoOccurrence>(table),
                  $$TodoOccurrencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({todoId = false, pointHistoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pointHistoryRefs) db.pointHistory],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (todoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.todoId,
                                referencedTable:
                                    $$TodoOccurrencesTableReferences
                                        ._todoIdTable(db),
                                referencedColumn:
                                    $$TodoOccurrencesTableReferences
                                        ._todoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pointHistoryRefs)
                    await $_getPrefetchedDataByColumns<
                      TodoOccurrence,
                      $TodoOccurrencesTable,
                      PointHistoryData,
                      $PointHistoryTable
                    >(
                      currentTable: table,
                      referencedTable: $$TodoOccurrencesTableReferences
                          ._pointHistoryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TodoOccurrencesTableReferences(
                            db,
                            table,
                            p0,
                          ).pointHistoryRefs,
                      currentColumn: 'id',
                      referencedColumn: 'occurrence_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TodoOccurrencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoOccurrencesTable,
      TodoOccurrence,
      $$TodoOccurrencesTableFilterComposer,
      $$TodoOccurrencesTableOrderingComposer,
      $$TodoOccurrencesTableAnnotationComposer,
      $$TodoOccurrencesTableCreateCompanionBuilder,
      $$TodoOccurrencesTableUpdateCompanionBuilder,
      (TodoOccurrence, $$TodoOccurrencesTableReferences),
      TodoOccurrence,
      PrefetchHooks Function({bool todoId, bool pointHistoryRefs})
    >;
typedef $$PointHistoryTableCreateCompanionBuilder =
    PointHistoryCompanion Function({
      Value<int> id,
      required int amount,
      required PointReason reason,
      required String date,
      Value<int?> occurrenceId,
      Value<String?> itemId,
      required DateTime createdAt,
    });
typedef $$PointHistoryTableUpdateCompanionBuilder =
    PointHistoryCompanion Function({
      Value<int> id,
      Value<int> amount,
      Value<PointReason> reason,
      Value<String> date,
      Value<int?> occurrenceId,
      Value<String?> itemId,
      Value<DateTime> createdAt,
    });

final class $$PointHistoryTableReferences
    extends
        BaseReferences<_$AppDatabase, $PointHistoryTable, PointHistoryData> {
  $$PointHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TodoOccurrencesTable _occurrenceIdTable(_$AppDatabase db) => db
      .todoOccurrences
      .createAlias('point_history__occurrence_id__todo_occurrences__id');

  $$TodoOccurrencesTableProcessedTableManager? get occurrenceId {
    final $_column = $_itemColumn<int>('occurrence_id');
    if ($_column == null) return null;
    final manager = $$TodoOccurrencesTableTableManager(
      $_db,
      $_db.todoOccurrences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_occurrenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PointHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PointReason, PointReason, String> get reason =>
      $composableBuilder(
        column: $table.reason,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TodoOccurrencesTableFilterComposer get occurrenceId {
    final $$TodoOccurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.todoOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoOccurrencesTableFilterComposer(
            $db: $db,
            $table: $db.todoOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TodoOccurrencesTableOrderingComposer get occurrenceId {
    final $$TodoOccurrencesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.todoOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoOccurrencesTableOrderingComposer(
            $db: $db,
            $table: $db.todoOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointHistoryTable> {
  $$PointHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PointReason, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TodoOccurrencesTableAnnotationComposer get occurrenceId {
    final $$TodoOccurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.todoOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TodoOccurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.todoOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointHistoryTable,
          PointHistoryData,
          $$PointHistoryTableFilterComposer,
          $$PointHistoryTableOrderingComposer,
          $$PointHistoryTableAnnotationComposer,
          $$PointHistoryTableCreateCompanionBuilder,
          $$PointHistoryTableUpdateCompanionBuilder,
          (PointHistoryData, $$PointHistoryTableReferences),
          PointHistoryData,
          PrefetchHooks Function({bool occurrenceId})
        > {
  $$PointHistoryTableTableManager(_$AppDatabase db, $PointHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PointHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<PointReason> reason = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int?> occurrenceId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PointHistoryCompanion(
                id: id,
                amount: amount,
                reason: reason,
                date: date,
                occurrenceId: occurrenceId,
                itemId: itemId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amount,
                required PointReason reason,
                required String date,
                Value<int?> occurrenceId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                required DateTime createdAt,
              }) => PointHistoryCompanion.insert(
                id: id,
                amount: amount,
                reason: reason,
                date: date,
                occurrenceId: occurrenceId,
                itemId: itemId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PointHistoryTable, PointHistoryData>(table),
                  $$PointHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({occurrenceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (occurrenceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.occurrenceId,
                                referencedTable: $$PointHistoryTableReferences
                                    ._occurrenceIdTable(db),
                                referencedColumn: $$PointHistoryTableReferences
                                    ._occurrenceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PointHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointHistoryTable,
      PointHistoryData,
      $$PointHistoryTableFilterComposer,
      $$PointHistoryTableOrderingComposer,
      $$PointHistoryTableAnnotationComposer,
      $$PointHistoryTableCreateCompanionBuilder,
      $$PointHistoryTableUpdateCompanionBuilder,
      (PointHistoryData, $$PointHistoryTableReferences),
      PointHistoryData,
      PrefetchHooks Function({bool occurrenceId})
    >;
typedef $$PetsTableCreateCompanionBuilder =
    PetsCompanion Function({
      Value<int> id,
      required String speciesId,
      required String name,
      Value<int> stage,
      Value<int> exp,
      required int mood,
      required int hunger,
      required DateTime lastUpdatedAt,
      Value<int> tapCount,
      Value<String?> tapDate,
    });
typedef $$PetsTableUpdateCompanionBuilder =
    PetsCompanion Function({
      Value<int> id,
      Value<String> speciesId,
      Value<String> name,
      Value<int> stage,
      Value<int> exp,
      Value<int> mood,
      Value<int> hunger,
      Value<DateTime> lastUpdatedAt,
      Value<int> tapCount,
      Value<String?> tapDate,
    });

final class $$PetsTableReferences
    extends BaseReferences<_$AppDatabase, $PetsTable, Pet> {
  $$PetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserProfileTable, List<UserProfileData>>
  _userProfileRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProfile,
    aliasName: 'pets__id__user_profile__active_pet_id',
  );

  $$UserProfileTableProcessedTableManager get userProfileRefs {
    final manager = $$UserProfileTableTableManager(
      $_db,
      $_db.userProfile,
    ).filter((f) => f.activePetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProfileRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hunger => $composableBuilder(
    column: $table.hunger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tapCount => $composableBuilder(
    column: $table.tapCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tapDate => $composableBuilder(
    column: $table.tapDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userProfileRefs(
    Expression<bool> Function($$UserProfileTableFilterComposer f) f,
  ) {
    final $$UserProfileTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.activePetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfileTableFilterComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hunger => $composableBuilder(
    column: $table.hunger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tapCount => $composableBuilder(
    column: $table.tapCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tapDate => $composableBuilder(
    column: $table.tapDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get hunger =>
      $composableBuilder(column: $table.hunger, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tapCount =>
      $composableBuilder(column: $table.tapCount, builder: (column) => column);

  GeneratedColumn<String> get tapDate =>
      $composableBuilder(column: $table.tapDate, builder: (column) => column);

  Expression<T> userProfileRefs<T extends Object>(
    Expression<T> Function($$UserProfileTableAnnotationComposer a) f,
  ) {
    final $$UserProfileTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProfile,
      getReferencedColumn: (t) => t.activePetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProfileTableAnnotationComposer(
            $db: $db,
            $table: $db.userProfile,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetsTable,
          Pet,
          $$PetsTableFilterComposer,
          $$PetsTableOrderingComposer,
          $$PetsTableAnnotationComposer,
          $$PetsTableCreateCompanionBuilder,
          $$PetsTableUpdateCompanionBuilder,
          (Pet, $$PetsTableReferences),
          Pet,
          PrefetchHooks Function({bool userProfileRefs})
        > {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> speciesId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> stage = const Value.absent(),
                Value<int> exp = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> hunger = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<int> tapCount = const Value.absent(),
                Value<String?> tapDate = const Value.absent(),
              }) => PetsCompanion(
                id: id,
                speciesId: speciesId,
                name: name,
                stage: stage,
                exp: exp,
                mood: mood,
                hunger: hunger,
                lastUpdatedAt: lastUpdatedAt,
                tapCount: tapCount,
                tapDate: tapDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String speciesId,
                required String name,
                Value<int> stage = const Value.absent(),
                Value<int> exp = const Value.absent(),
                required int mood,
                required int hunger,
                required DateTime lastUpdatedAt,
                Value<int> tapCount = const Value.absent(),
                Value<String?> tapDate = const Value.absent(),
              }) => PetsCompanion.insert(
                id: id,
                speciesId: speciesId,
                name: name,
                stage: stage,
                exp: exp,
                mood: mood,
                hunger: hunger,
                lastUpdatedAt: lastUpdatedAt,
                tapCount: tapCount,
                tapDate: tapDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PetsTable, Pet>(table),
                  $$PetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userProfileRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userProfileRefs) db.userProfile],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userProfileRefs)
                    await $_getPrefetchedDataByColumns<
                      Pet,
                      $PetsTable,
                      UserProfileData,
                      $UserProfileTable
                    >(
                      currentTable: table,
                      referencedTable: $$PetsTableReferences
                          ._userProfileRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PetsTableReferences(db, table, p0).userProfileRefs,
                      currentColumn: 'id',
                      referencedColumn: 'active_pet_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetsTable,
      Pet,
      $$PetsTableFilterComposer,
      $$PetsTableOrderingComposer,
      $$PetsTableAnnotationComposer,
      $$PetsTableCreateCompanionBuilder,
      $$PetsTableUpdateCompanionBuilder,
      (Pet, $$PetsTableReferences),
      Pet,
      PrefetchHooks Function({bool userProfileRefs})
    >;
typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<int?> activePetId,
      Value<String?> lastProcessedDate,
      Value<bool> onboardingDone,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<int?> activePetId,
      Value<String?> lastProcessedDate,
      Value<bool> onboardingDone,
    });

final class $$UserProfileTableReferences
    extends BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData> {
  $$UserProfileTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PetsTable _activePetIdTable(_$AppDatabase db) =>
      db.pets.createAlias('user_profile__active_pet_id__pets__id');

  $$PetsTableProcessedTableManager? get activePetId {
    final $_column = $_itemColumn<int>('active_pet_id');
    if ($_column == null) return null;
    final manager = $$PetsTableTableManager(
      $_db,
      $_db.pets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activePetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastProcessedDate => $composableBuilder(
    column: $table.lastProcessedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  $$PetsTableFilterComposer get activePetId {
    final $$PetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activePetId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableFilterComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastProcessedDate => $composableBuilder(
    column: $table.lastProcessedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$PetsTableOrderingComposer get activePetId {
    final $$PetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activePetId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableOrderingComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastProcessedDate => $composableBuilder(
    column: $table.lastProcessedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  $$PetsTableAnnotationComposer get activePetId {
    final $$PetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activePetId,
      referencedTable: $db.pets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PetsTableAnnotationComposer(
            $db: $db,
            $table: $db.pets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileData,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (UserProfileData, $$UserProfileTableReferences),
          UserProfileData,
          PrefetchHooks Function({bool activePetId})
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> activePetId = const Value.absent(),
                Value<String?> lastProcessedDate = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                activePetId: activePetId,
                lastProcessedDate: lastProcessedDate,
                onboardingDone: onboardingDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> activePetId = const Value.absent(),
                Value<String?> lastProcessedDate = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                activePetId: activePetId,
                lastProcessedDate: lastProcessedDate,
                onboardingDone: onboardingDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTable, UserProfileData>(table),
                  $$UserProfileTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activePetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activePetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activePetId,
                                referencedTable: $$UserProfileTableReferences
                                    ._activePetIdTable(db),
                                referencedColumn: $$UserProfileTableReferences
                                    ._activePetIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileData,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (UserProfileData, $$UserProfileTableReferences),
      UserProfileData,
      PrefetchHooks Function({bool activePetId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$TodoOccurrencesTableTableManager get todoOccurrences =>
      $$TodoOccurrencesTableTableManager(_db, _db.todoOccurrences);
  $$PointHistoryTableTableManager get pointHistory =>
      $$PointHistoryTableTableManager(_db, _db.pointHistory);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
}
