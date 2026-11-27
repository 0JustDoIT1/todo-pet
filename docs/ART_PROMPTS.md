# 그림 프롬프트 (PRD 3.5)

개발할 때 AI 이미지 생성으로 그림을 만들기 위한 프롬프트와 규칙. 앱은 실행 중에 AI를 호출하지 않는다. 출처 기록은 [ASSETS.md](../ASSETS.md).

스타일은 **2D 픽셀아트(도트)**다. 화면 UI(카드·버튼·색)는 부드러운 파스텔 테마로 따로 만든다(`lib/core/ui/app_theme.dart`). `[x]`는 이미 앱에 들어간 그림, `[ ]`는 아직 만들 그림.

## 0. 만드는 방법 (사용자)

1. 아래 프롬프트의 ``` 안쪽만 **그대로** 이미지 생성 도구(ChatGPT 이미지 생성 등)에 붙여넣는다. 프롬프트 하나에 그림 하나.
2. **2·3단계 펫은 같은 종의 1단계 그림(`assets/pets/<species>/stage1.png` 또는 그 원본)을 참고 이미지로 함께 올리고** 생성한다. 그래야 같은 캐릭터로 나온다.
3. 그림체가 기존 그림과 달라지면 기존 펫 그림을 참고 이미지로 올리고 프롬프트 맨 앞에 `Match the pixel art style of the reference image exactly.`를 붙인다.
4. 생성 도구가 주는 크기 그대로(예: 1536×1024, 1024×1536, 1024×1024) PNG로 저장한다. 줄이거나 자르지 않는다.
5. 파일 이름은 각 항목의 `원본 파일 이름`으로 하고, 한 폴더에 모아 경로를 알려 준다.
6. 마음에 안 드는 그림은 다시 생성해도 된다. 생김새 문장(`The pet:`·`Item:`·`Room:` 뒷부분)은 바꿔도 된다.

Claude가 하는 일: 투명 배경 정리 → 칸 나누기 → nearest-neighbor로 규격 크기 축소 → `assets/`에 넣기 → 앱에 연결 → `ASSETS.md` 기록.

## 1. 규칙

- **저장 위치와 최종 규격 (Claude가 맞춤)**

  | 종류 | 앱 안 위치 | 최종 크기 | 배경 |
  | --- | --- | --- | --- |
  | 펫 표정 시트 | `assets/pets/<species>/stage<N>.png` | 256×64 (1행 × 4칸, 칸 64×64) | 투명 |
  | 먹이 | `assets/food/<id>.png` | 32×32 | 투명 |
  | 배경 | `assets/backgrounds/<id>.png` | 192×288 (세로 2:3) | 채움 |
  | 소품 | `assets/props/<id>.png` | 48×48 | 투명 |
  | 프리즈 | `assets/items/freeze.png` | 32×32 | 투명 |
  | 앱 아이콘 | `assets/icon/app_icon.png` | 1024×1024 | 채움 |

- **표정 칸 순서**: `기본 | 눈 감음 | 기쁨 | 배고픔`.
- **표정 칸 선택 (앱)**: 배고픔 30 이하 → 배고픔 칸, 기분 70 이상 → 기쁨 칸, 그 외 → 기본 칸(눈 감음과 교대). 탭하면 기쁨 칸 + 점프.
- **움직임은 그리지 않는다**: 흔들림·점프·좌우 걷기는 코드로 만든다. 걷기 프레임은 만들지 않는다. 3단계는 걸을 때 좌우 반전하므로 몸을 살짝 오른쪽으로 돌린 자세로 그린다.
- **그림자 없음**: 바닥 그림자는 앱에서 그린다.
- **먹이 모양**: 고양이·강아지·토끼 모두에게 주는 먹이라 특정 동물을 떠올리게 하는 모양(뼈다귀, 생선, 당근 등)은 쓰지 않는다.
- **배경 바닥은 비워 둔다**: 소품은 사용자가 따로 놓으므로 배경 바닥에 가구·물건을 그리지 않는다. 위쪽 약 40%는 벽, 아래쪽 약 60%는 바닥.
- **특정 작품 캐릭터 금지**: 기존 게임·애니메이션의 고유한 생김새를 따라 하지 않는다.
- **앱 표시**: Flutter에서 `FilterQuality.none`으로 그린다(픽셀이 흐려지지 않게).

## 2. 펫 9장 (고양이·강아지·토끼 × 1~3단계)

### [x] 고양이 1단계 — 원본 파일 이름 `cat_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby kitten, orange tabby with a cream belly, big eyes, short stubby tail.
```

### [x] 고양이 2단계 — 원본 파일 이름 `cat_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same kitten as the reference image, grown a little bigger and more mature, longer tail, small golden bell collar. Keep the same colors and face.
```

### [ ] 고양이 3단계 — 원본 파일 이름 `cat_stage3.png` (고양이 2단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same cat as the reference image, now a young adult cat, taller and more confident, long fluffy tail held up, golden bell collar. Keep the same colors and face.
```

### [x] 강아지 1단계 — 원본 파일 이름 `dog_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby puppy, light brown fur with one darker brown ear, floppy ears, big eyes.
```

### [x] 강아지 2단계 — 원본 파일 이름 `dog_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same puppy as the reference image, grown a little bigger and more mature, wagging tail, small red scarf. Keep the same colors and face.
```

### [ ] 강아지 3단계 — 원본 파일 이름 `dog_stage3.png` (강아지 2단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same dog as the reference image, now a young adult dog, taller and more confident, tail up, red scarf. Keep the same colors and face.
```

### [x] 토끼 1단계 — 원본 파일 이름 `rabbit_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby bunny, white fur with pink inner ears, short ears, fluffy round tail.
```

### [x] 토끼 2단계 — 원본 파일 이름 `rabbit_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same bunny as the reference image, grown a little bigger and more mature, long upright ears, a small flower on one ear. Keep the same colors and face.
```

### [ ] 토끼 3단계 — 원본 파일 이름 `rabbit_stage3.png` (토끼 2단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same rabbit as the reference image, now a young adult rabbit, taller and more graceful, long upright ears, a flower crown. Keep the same colors and face.
```

**격자가 잘 안 나올 때**: 마지막 줄(`The pet:`)은 그대로 두고, 4칸 대신 한 칸씩 4번 생성해도 된다. 그때는 4칸을 설명하는 줄들을 `Single pet, centered, square image, expression: <neutral idle / eyes closed / happy / hungry>.`로 바꾸고, 원본 파일 이름 뒤에 `_1`~`_4`를 붙인다(예: `cat_stage3_1.png`).

## 3. 먹이 3장

### [x] 기본 사료 — 원본 파일 이름 `food_basic.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a small round pet bowl filled with colorful round food pellets (light brown, green and orange), a generic pet food that suits any small animal.
```

### [x] 간식 — 원본 파일 이름 `food_snack.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a heart-shaped cookie with pink icing, a generic treat that suits any small animal (not a bone, not a fish).
```

### [x] 특별식 — 원본 파일 이름 `food_special.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a festive plate with a small strawberry cake and a little star sparkle.
```

## 4. 배경 4장 (기본 방 + 상점 배경 3종)

홈 화면을 가득 채우는 맵이다. 앱은 위아래 UI(포인트·상태 카드·버튼)를 그 위에 얹는다. 그림이 생기기 전에는 기본 방을 코드로 그린다(`lib/features/home/ui/room_background.dart`).

### [ ] 기본 방 — 원본 파일 이름 `bg_default.png` (처음부터 장착, 판매 안 함)
```
Pixel art game background, 16-bit style, soft pastel palette, clean outlines, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent), readable when shrunk to 192x288 pixels. An empty cozy room for a virtual pet home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: soft peach wall with a large arched window showing a blue sky with fluffy clouds and green bushes, warm light-pink wooden floor tiles.
```

### [ ] 민트 방 — 원본 파일 이름 `bg_mint.png`
```
Pixel art game background, 16-bit style, soft pastel palette, clean outlines, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent), readable when shrunk to 192x288 pixels. An empty cozy room for a virtual pet home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: pastel mint wallpaper with tiny white polka dots, a round window with white curtains, light natural wood floor.
```

### [ ] 별밤 방 — 원본 파일 이름 `bg_night.png`
```
Pixel art game background, 16-bit style, soft pastel palette, clean outlines, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent), readable when shrunk to 192x288 pixels. An empty cozy room for a virtual pet home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: soft dusty-blue wall with a big window showing a starry night sky and a crescent moon, a string of small warm lights along the top, lavender wooden floor.
```

### [ ] 정원 — 원본 파일 이름 `bg_garden.png`
```
Pixel art game background, 16-bit style, soft pastel palette, clean outlines, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent), readable when shrunk to 192x288 pixels. An outdoor garden for a virtual pet home screen, straight-on front view.
The sky, fence and flower bushes fill the upper 40%, the lawn fills the lower 60% seen from slightly above. A clear horizontal line where the fence meets the lawn.
Keep the lawn completely empty and plain: no furniture, no objects, no characters, no animals.
Garden: pastel blue sky with fluffy clouds, a white picket fence with small pink and yellow flowers, soft light-green lawn.
```

## 5. 소품 4장

홈 맵 바닥 위에 사용자가 놓는다. 바닥을 약간 위에서 내려다보는 각도로 그린다.

### [ ] 방석 — 원본 파일 이름 `prop_cushion.png`
```
Pixel art game item, 16-bit style, clean dark outline, limited palette, soft shading, single object centered, square image,
readable at 48x48 pixels, seen from the front and slightly above, fully transparent background, no ground shadow, no text, no logos, no watermark.
Item: a round fluffy pink pet bed cushion with a cream scalloped rim.
```

### [ ] 화분 — 원본 파일 이름 `prop_plant.png`
```
Pixel art game item, 16-bit style, clean dark outline, limited palette, soft shading, single object centered, square image,
readable at 48x48 pixels, seen from the front and slightly above, fully transparent background, no ground shadow, no text, no logos, no watermark.
Item: a leafy green houseplant in a cream pot with pink stripes.
```

### [ ] 장난감 공 — 원본 파일 이름 `prop_ball.png`
```
Pixel art game item, 16-bit style, clean dark outline, limited palette, soft shading, single object centered, square image,
readable at 48x48 pixels, seen from the front and slightly above, fully transparent background, no ground shadow, no text, no logos, no watermark.
Item: a soft round toy ball with pastel rainbow stripes and a small star pattern.
```

### [ ] 스탠드 조명 — 원본 파일 이름 `prop_lamp.png`
```
Pixel art game item, 16-bit style, clean dark outline, limited palette, soft shading, single object centered, square image,
readable at 48x48 pixels, seen from the front and slightly above, fully transparent background, no ground shadow, no text, no logos, no watermark.
Item: a small floor lamp with a cream round lampshade and a light-wood stand, glowing softly.
```

## 6. 프리즈 아이콘 1장

### [ ] 프리즈 — 원본 파일 이름 `item_freeze.png`
```
Pixel art item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a light-blue ice crystal shaped like a small shield with a white snowflake in the middle and a tiny sparkle.
```

## 7. 앱 아이콘 1장

펫 1단계 그림을 모두 만든 뒤에 만든다. 고양이 1단계 그림을 참고 이미지로 함께 올린다(다른 종으로 바꿔도 된다).

### [x] 앱 아이콘 — 원본 파일 이름 `app_icon.png`
```
App icon, 1024x1024, square, pixel art 16-bit style, clean dark outline, limited palette.
The kitten from the reference image, only its head and front paws, peeking up from behind a large white checkmark.
Solid warm orange background filling the whole square (not transparent), the character centered and filling about 60% of the icon,
simple and readable at small sizes, no text, no letters, no logos, no watermark, no rounded corners.
```
