# 펫·먹이 그림 프롬프트 (PRD 3.3)

펫과 먹이 그림을 개발할 때 AI 이미지 생성으로 만들기 위한 규칙과 프롬프트. 앱은 실행 중에 AI를 호출하지 않는다. 출처 기록은 [ASSETS.md](../ASSETS.md).

## 1. 규칙
- **저장 위치·이름**: 펫은 `assets/pets/<species>/stage<N>.png`(예: `assets/pets/cat/stage1.png`), 먹이는 `assets/food/<id>.png`. `<species>`·`<id>`는 영문 소문자와 `-`만 쓴다.
- **규격 (앱에 넣기 전에 맞춤)**
  - 펫: 1행 × 4칸 = **256×64**, 칸마다 64×64. 칸 순서는 `기본 | 눈 감음 | 기쁨 | 배고픔`.
  - 먹이: 한 장 **32×32**.
  - 배경은 투명. 생성 도구가 큰 그림을 주면 nearest-neighbor로 줄이고, 가장자리 반투명 픽셀을 정리한다.
- **한 장으로 생성**: 네 칸을 한 이미지로 만들어야 같은 캐릭터로 나온다. 격자가 잘 안 나오면 같은 스타일 블록으로 칸마다 따로 만든 뒤 합친다.
- **같은 종의 단계끼리 맞추기**: 2단계를 만들 때 1단계 그림을 참고 이미지로 함께 넣고 "same species, slightly bigger and more mature"로 지시한다.
- **표정 칸 선택 (앱)**: 배고픔 30 이하 → 배고픔 칸, 기분 70 이상 → 기쁨 칸, 그 외 → 기본 칸(눈 감음과 교대).
- **움직임은 그리지 않는다**: 흔들림·점프는 코드로 만든다. 걷기·이동 프레임은 만들지 않는다.
- **특정 작품 캐릭터 금지**: 기존 게임·애니메이션 펫의 고유한 생김새를 따라 하지 않는다. 일반적인 동물·생물 유형으로만 그린다.
- **기록**: 그림을 넣으면 도구·생성일·보정 내용을 `ASSETS.md`에 적고, 아래 체크박스를 채운다.
- **앱 표시**: Flutter에서 `FilterQuality.none`으로 그린다(픽셀이 흐려지지 않게).

### 스타일 블록 (모든 프롬프트 앞에 붙임)
```
Cute pixel art virtual pet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
```

### 펫 시트 지시문
```
Sprite sheet: 1 row x 4 columns, every cell the same square size, the pet centered in each cell at the same position and scale.
Cells from left: neutral idle, eyes closed (blink), happy (smiling, eyes curved), hungry (droopy, small sweat drop).
The same character in every cell; only the face and posture change.
```

## 2. 시작 펫 3종 (2026-11-25 결정: 고양이·강아지·토끼)
종 id는 코드 상수(`lib/features/pet/domain/species.dart`)와 같다. 각 프롬프트 앞에 스타일 블록과 펫 시트 지시문을 붙인다. 2단계는 1단계 그림을 참고 이미지로 함께 넣는다. 생김새 문장은 초안이라 바꿔도 된다.

### [ ] 고양이 1단계 → `assets/pets/cat/stage1.png` (256×64)
```
Stage 1 (baby): a tiny round kitten, orange tabby with a cream belly, big eyes, short stubby tail.
```

### [ ] 고양이 2단계 → `assets/pets/cat/stage2.png` (256×64)
```
Stage 2 (child): same kitten as the reference image, slightly bigger and more mature, longer tail, small bell collar.
```

### [ ] 강아지 1단계 → `assets/pets/dog/stage1.png` (256×64)
```
Stage 1 (baby): a tiny round puppy, light brown with one darker ear patch, floppy ears, big eyes.
```

### [ ] 강아지 2단계 → `assets/pets/dog/stage2.png` (256×64)
```
Stage 2 (child): same puppy as the reference image, slightly bigger and more mature, wagging tail, red scarf.
```

### [ ] 토끼 1단계 → `assets/pets/rabbit/stage1.png` (256×64)
```
Stage 1 (baby): a tiny round bunny, white with pink inner ears, short ears, fluffy tail.
```

### [ ] 토끼 2단계 → `assets/pets/rabbit/stage2.png` (256×64)
```
Stage 2 (child): same bunny as the reference image, slightly bigger and more mature, long upright ears, small flower on one ear.
```

## 3. 먹이 아이콘 3종 (기획서 3.5)
먹이 id는 코드 상수(`lib/features/pet/domain/foods.dart`)와 같다. 각 프롬프트 앞에 아래 블록을 붙인다.
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, centered,
fully transparent background, no text, no logos, no watermark.
```

### [ ] 기본 사료 → `assets/food/basic.png` (32×32)
```
Item: a small bowl of round pet kibble.
```

### [ ] 간식 → `assets/food/snack.png` (32×32)
```
Item: a bone-shaped cookie treat.
```

### [ ] 특별식 → `assets/food/special.png` (32×32)
```
Item: a festive plate with a small cake and a star sparkle.
```
