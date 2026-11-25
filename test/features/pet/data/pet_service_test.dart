import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_pet/core/db/app_database.dart';
import 'package:todo_pet/core/error/app_exception.dart';
import 'package:todo_pet/features/pet/data/pet_service.dart';
import 'package:todo_pet/features/pet/domain/pet_rules.dart';
import 'package:todo_pet/features/points/data/point_service.dart';
import 'package:todo_pet/features/points/domain/point_reason.dart';

void main() {
  late AppDatabase db;
  late PointService points;
  late PetService pets;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 25, 9);
    points = PointService(db, () => now);
    pets = PetService(db, points, () => now);
  });
  tearDown(() => db.close());

  /// 테스트용 포인트 지급 (완료 이력 대신 바로 기록).
  Future<void> givePoints(int amount) => db
      .into(db.pointHistory)
      .insert(
        PointHistoryCompanion.insert(
          amount: amount,
          reason: PointReason.completion,
          date: '2026-11-25',
          createdAt: now,
        ),
      );

  Future<Pet> petRow(int id) =>
      (db.select(db.pets)..where((p) => p.id.equals(id))).getSingle();

  test('처음 만든 펫은 초기값 80으로 활성 펫이 된다', () async {
    expect(await pets.activePet(), isNull);
    await pets.create(speciesId: 'cat', name: '나비');

    final view = (await pets.activePet())!;
    expect(view.pet.name, '나비');
    expect(view.hunger, 80);
    expect(view.mood, 80);
    expect(view.pet.stage, 1);
  });

  test('같은 종은 두 번 만들 수 없다', () async {
    await pets.create(speciesId: 'cat', name: '나비');
    await expectLater(
      pets.create(speciesId: 'cat', name: '나비2'),
      throwsA(isA<PetAlreadyOwned>()),
    );
  });

  test('시간이 지나면 읽을 때 줄어든 값이 보이고, DB 저장값은 그대로다', () async {
    final id = await pets.create(speciesId: 'cat', name: '나비');
    now = now.add(const Duration(hours: 12));

    expect((await pets.activePet())!.hunger, 30); // 80 - 50
    expect((await petRow(id)).hunger, 80);
  });

  test('먹이를 사면 포인트를 쓰고 수치·애정도가 오른다', () async {
    await givePoints(10);
    final id = await pets.create(speciesId: 'cat', name: '나비');

    final result = await pets.feed('basic');
    expect(result.view.hunger, 100);
    expect(result.view.mood, 85);
    expect(result.view.affection, 5);
    expect(await points.balance(), 0);
    expect((await petRow(id)).hunger, 100);
  });

  test('포인트가 모자라면 먹일 수 없고 펫도 그대로다', () async {
    await givePoints(5);
    await pets.create(speciesId: 'cat', name: '나비');

    await expectLater(pets.feed('basic'), throwsA(isA<InsufficientPoints>()));
    expect((await pets.activePet())!.affection, 0);
    expect(await points.balance(), 5);
  });

  test('배고픔이 100이면 먹일 수 없고 포인트도 쓰지 않는다', () async {
    await givePoints(20);
    await pets.create(speciesId: 'cat', name: '나비');
    await pets.feed('basic'); // 80 → 100

    await expectLater(pets.feed('basic'), throwsA(isA<PetFull>()));
    expect(await points.balance(), 10);
  });

  test('애정도 50에 닿는 먹이에서 2단계로 성장한다', () async {
    await givePoints(1000);
    final id = await pets.create(speciesId: 'cat', name: '나비');
    await (db.update(db.pets)..where((p) => p.id.equals(id))).write(
      const PetsCompanion(exp: Value(45), hunger: Value(10)),
    );

    final result = await pets.feed('basic');
    expect(result.grewUp, isTrue);
    expect(result.view.pet.stage, 2);
  });

  test('탭은 하루 10회까지만 수치를 올리고, 다음 날 다시 오른다', () async {
    await pets.create(speciesId: 'cat', name: '나비');
    for (var i = 0; i < 10; i++) {
      expect(await pets.tap(), isTrue);
    }
    expect(await pets.tap(), isFalse);
    final view = (await pets.activePet())!;
    expect(view.mood, 100); // 80 + 2×10
    expect(view.affection, 10);

    now = DateTime(2026, 11, 26, 9);
    expect(await pets.tap(), isTrue);
  });

  test('교체하면 이전 펫은 멈추고, 다시 활성화해도 비활성 기간만큼 줄지 않는다', () async {
    final cat = await pets.create(speciesId: 'cat', name: '나비');
    final dog = await pets.create(speciesId: 'dog', name: '바둑');
    expect((await pets.activePet())!.pet.id, cat);

    now = now.add(const Duration(hours: 6)); // 고양이 80 → 55
    await pets.setActive(dog);
    expect((await petRow(cat)).hunger, 55);

    now = now.add(const Duration(hours: 24)); // 강아지만 시간이 흐른다
    expect((await pets.activePet())!.hunger, 0);
    await pets.setActive(cat);
    expect((await pets.activePet())!.hunger, 55);
  });

  test('이름 변경은 1~10자 규칙을 따른다', () async {
    final id = await pets.create(speciesId: 'cat', name: '나비');
    await pets.rename(id, ' 치즈 ');
    expect((await petRow(id)).name, '치즈');
    await expectLater(pets.rename(id, ''), throwsA(isA<InvalidPetName>()));
  });

  test('펫이 없으면 먹이·탭은 PetNotFound', () async {
    await expectLater(pets.feed('basic'), throwsA(isA<PetNotFound>()));
    await expectLater(pets.tap(), throwsA(isA<PetNotFound>()));
  });

  test('표정은 현재 수치로 정해진다', () async {
    await pets.create(speciesId: 'cat', name: '나비');
    expect((await pets.activePet())!.expression, PetExpression.happy); // 기분 80

    now = now.add(const Duration(hours: 12)); // 배고픔 30
    expect((await pets.activePet())!.expression, PetExpression.hungry);
  });
}
