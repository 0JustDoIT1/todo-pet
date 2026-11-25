import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/onboarding/data/onboarding_service.dart';
import 'package:todo_pet/features/pet/data/pet_service.dart';
import 'package:todo_pet/features/points/data/point_service.dart';
import 'package:todo_pet/features/todo/data/todo_service.dart';

void main() {
  late AppDatabase db;
  late OnboardingService onboarding;
  late PetService pets;
  late TodoService todos;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    DateTime now() => DateTime(2026, 11, 25, 9);
    final points = PointService(db, now);
    pets = PetService(db, points, now);
    todos = TodoService(db, points, now);
    onboarding = OnboardingService(db, pets, todos);
  });
  tearDown(() => db.close());

  test('마치면 펫·첫 할일을 저장하고 완료로 표시한다 (빈 칸은 무시)', () async {
    expect(await onboarding.isDone(), isFalse);

    await onboarding.finish(
      speciesId: 'rabbit',
      petName: '토토',
      todoTitles: ['물 마시기', ' ', '산책'],
    );

    expect(await onboarding.isDone(), isTrue);
    expect((await pets.activePet())!.pet.name, '토토');
    final titles = (await todos.todayList()).map((t) => t.todo.title);
    expect(titles, unorderedEquals(['물 마시기', '산책']));
  });

  test('첫 할일이 없으면 거부하고 아무것도 저장하지 않는다', () async {
    await expectLater(
      onboarding.finish(speciesId: 'cat', petName: '나비', todoTitles: ['  ']),
      throwsA(isA<InvalidTodo>()),
    );
    expect(await onboarding.isDone(), isFalse);
    expect(await pets.activePet(), isNull);
  });

  test('펫 이름이 잘못되면 할일도 저장되지 않는다 (한 트랜잭션)', () async {
    await expectLater(
      onboarding.finish(speciesId: 'cat', petName: '', todoTitles: ['물']),
      throwsA(isA<InvalidPetName>()),
    );
    expect(await todos.todayList(), isEmpty);
    expect(await onboarding.isDone(), isFalse);
  });

  test('첫 할일은 3개까지', () async {
    await expectLater(
      onboarding.finish(
        speciesId: 'cat',
        petName: '나비',
        todoTitles: ['a', 'b', 'c', 'd'],
      ),
      throwsA(isA<InvalidTodo>()),
    );
  });
}
