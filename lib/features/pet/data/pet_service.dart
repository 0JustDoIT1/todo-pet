import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/date/date_key.dart';
import '../../../core/date/now_provider.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/error/app_exception.dart';
import '../../points/data/point_service.dart';
import '../../points/domain/point_reason.dart';
import '../domain/foods.dart';
import '../domain/pet_rules.dart';
import '../domain/species.dart';

/// 화면에 보여줄 펫 상태 (시간 경과 반영).
class PetView {
  const PetView({required this.pet, required this.stats});

  final Pet pet;
  final PetStats stats;

  int get hunger => stats.hungerValue;
  int get mood => stats.moodValue;
  int get affection => pet.exp;
  PetExpression get expression => PetRules.expression(stats);
}

/// 먹이 결과.
class FeedResult {
  const FeedResult({required this.view, required this.grewUp});

  final PetView view;

  /// 이번 먹이로 단계가 올랐는지.
  final bool grewUp;
}

/// 펫 생성·먹이·탭·교체 (PRD 3.3).
/// 배고픔·기분은 읽을 때 계산하고, 값이 바뀌는 동작에서만 저장한다.
/// pets.exp 컬럼은 애정도로 쓴다.
class PetService {
  PetService(this._db, this._points, this._now);

  final AppDatabase _db;
  final PointService _points;
  final DateTime Function() _now;

  /// 펫을 만든다(온보딩 선택·입양). 활성 펫이 없으면 활성으로 정한다.
  Future<int> create({required String speciesId, required String name}) =>
      _db.transaction(() async {
        if (speciesById(speciesId) == null) throw const UnknownSpecies();
        final cleanName = PetRules.validateName(name);
        final owned = await (_db.select(
          _db.pets,
        )..where((p) => p.speciesId.equals(speciesId))).getSingleOrNull();
        if (owned != null) throw const PetAlreadyOwned();

        final id = await _db
            .into(_db.pets)
            .insert(
              PetsCompanion.insert(
                speciesId: speciesId,
                name: cleanName,
                mood: PetRules.initialStat,
                hunger: PetRules.initialStat,
                lastUpdatedAt: _now(),
              ),
            );
        final profile = await _profile();
        if (profile.activePetId == null) {
          await _setProfileActive(id);
        }
        return id;
      });

  /// 아직 없는 시작 종을 포인트로 입양한다 (PRD 3.3). 활성 펫은 바꾸지 않는다.
  /// 종·이름 검증, 포인트 지출, 펫 생성은 한 트랜잭션이라 하나라도 실패하면 모두 취소된다.
  Future<int> adopt({required String speciesId, required String name}) =>
      _db.transaction(() async {
        final id = await create(speciesId: speciesId, name: name);
        await _points.spend(
          price: PetRules.adoptionPrice,
          reason: PointReason.adoption,
          itemId: speciesId,
        );
        return id;
      });

  /// 활성 펫의 현재 상태. 펫이 없으면 null.
  Future<PetView?> activePet() async {
    final id = (await _profile()).activePetId;
    if (id == null) return null;
    return _view(await _getPet(id));
  }

  /// 보유한 모든 펫 (활성 펫이 아닌 펫은 수치가 멈춰 있다).
  Future<List<Pet>> allPets() => _db.select(_db.pets).get();

  /// 먹이를 사서 바로 활성 펫에게 준다. 포인트 지출과 펫 갱신은 한 트랜잭션.
  Future<FeedResult> feed(String foodId) => _db.transaction(() async {
    final food = foodById(foodId);
    if (food == null) throw const FoodNotFound();
    final pet = await _activeOrThrow();
    final stats = _current(pet);
    if (!PetRules.canFeed(stats)) throw const PetFull();

    await _points.spend(
      price: food.price,
      reason: PointReason.food,
      itemId: food.id,
    );

    final after = PetRules.afterFood(stats, food);
    final affection = pet.exp + food.affection;
    final stage = PetRules.stageFor(stage: pet.stage, affection: affection);
    await _save(pet.id, after, exp: affection, stage: stage);
    return FeedResult(
      view: _view(await _getPet(pet.id)),
      grewUp: stage > pet.stage,
    );
  });

  /// 탭 반응. 반응은 항상 하고, 기분·애정도는 하루 10회까지만 오른다.
  /// 이번 탭으로 수치가 올랐으면 true.
  Future<bool> tap() => _db.transaction(() async {
    final pet = await _activeOrThrow();
    final today = dateKey(_now());
    if (!PetRules.canGainFromTap(
      tapCount: pet.tapCount,
      tapDate: pet.tapDate,
      today: today,
    )) {
      return false;
    }

    final stats = _current(pet);
    final after = PetStats(
      hunger: stats.hunger,
      mood: (stats.mood + PetRules.tapMood).clamp(0, 100).toDouble(),
    );
    final affection = pet.exp + PetRules.tapAffection;
    await _save(
      pet.id,
      after,
      exp: affection,
      stage: PetRules.stageFor(stage: pet.stage, affection: affection),
      tapCount:
          PetRules.tapsToday(
            tapCount: pet.tapCount,
            tapDate: pet.tapDate,
            today: today,
          ) +
          1,
      tapDate: today,
    );
    return true;
  });

  /// 활성 펫 교체. 이전 펫은 지금 수치로 저장해 멈추고,
  /// 새 펫은 갱신 시각만 지금으로 옮겨 비활성 기간을 감소에서 뺀다.
  Future<void> setActive(int petId) => _db.transaction(() async {
    final next = await _getPet(petId);
    final currentId = (await _profile()).activePetId;
    if (currentId == petId) return;

    if (currentId != null) {
      final current = await _getPet(currentId);
      await _save(current.id, _current(current));
    }
    await (_db.update(_db.pets)..where((p) => p.id.equals(next.id))).write(
      PetsCompanion(lastUpdatedAt: Value(_now())),
    );
    await _setProfileActive(next.id);
  });

  /// 이름 변경.
  Future<void> rename(int petId, String name) async {
    final cleanName = PetRules.validateName(name);
    await _getPet(petId);
    await (_db.update(_db.pets)..where((p) => p.id.equals(petId))).write(
      PetsCompanion(name: Value(cleanName)),
    );
  }

  PetStats _current(Pet pet) => PetRules.decayed(
    hunger: pet.hunger,
    mood: pet.mood,
    lastUpdatedAt: pet.lastUpdatedAt,
    now: _now(),
  );

  PetView _view(Pet pet) => PetView(pet: pet, stats: _current(pet));

  Future<void> _save(
    int petId,
    PetStats stats, {
    int? exp,
    int? stage,
    int? tapCount,
    String? tapDate,
  }) => (_db.update(_db.pets)..where((p) => p.id.equals(petId))).write(
    PetsCompanion(
      hunger: Value(stats.hungerValue),
      mood: Value(stats.moodValue),
      lastUpdatedAt: Value(_now()),
      exp: exp == null ? const Value.absent() : Value(exp),
      stage: stage == null ? const Value.absent() : Value(stage),
      tapCount: tapCount == null ? const Value.absent() : Value(tapCount),
      tapDate: tapDate == null ? const Value.absent() : Value(tapDate),
    ),
  );

  Future<Pet> _activeOrThrow() async {
    final id = (await _profile()).activePetId;
    if (id == null) throw const PetNotFound();
    return _getPet(id);
  }

  Future<Pet> _getPet(int id) async {
    final pet = await (_db.select(
      _db.pets,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    if (pet == null) throw const PetNotFound();
    return pet;
  }

  Future<UserProfileData> _profile() => _db.select(_db.userProfile).getSingle();

  Future<void> _setProfileActive(int petId) => _db
      .update(_db.userProfile)
      .write(UserProfileCompanion(activePetId: Value(petId)));
}

final petServiceProvider = Provider<PetService>(
  (ref) => PetService(
    ref.watch(appDatabaseProvider),
    ref.watch(pointServiceProvider),
    ref.watch(nowProvider),
  ),
);
