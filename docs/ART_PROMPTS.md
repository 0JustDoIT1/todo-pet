# 펫·먹이·앱 아이콘 그림 프롬프트 (PRD 3.5)

개발할 때 AI 이미지 생성으로 그림을 만들기 위한 프롬프트와 규칙. 앱은 실행 중에 AI를 호출하지 않는다. 출처 기록은 [ASSETS.md](../ASSETS.md).

## 0. 만드는 방법 (사용자)

1. 아래 2~4장의 프롬프트를 **그대로** 이미지 생성 도구(ChatGPT 이미지 생성 등)에 붙여넣는다. 프롬프트 하나에 그림 하나.
2. **2단계 펫은 1단계 그림을 참고 이미지로 함께 올리고** 생성한다. 그래야 같은 캐릭터로 나온다.
3. 생성 도구가 주는 크기 그대로(예: 1536×1024, 1024×1024) PNG로 저장한다. 줄이거나 자르지 않는다.
4. 파일 이름은 각 항목 제목의 `원본 파일 이름`으로 하고, 한 폴더에 모아 경로를 알려 준다.
5. 마음에 안 드는 그림은 다시 생성해도 된다. 생김새 문장(`The pet:` 뒷부분)은 바꿔도 된다.

Claude가 하는 일: 투명 배경 정리 → 칸 나누기 → nearest-neighbor로 규격 크기 축소 → `assets/`에 넣기 → 앱을 이모지에서 그림으로 전환 → `ASSETS.md` 기록.

## 1. 규칙

- **저장 위치(앱 안)**: 펫 `assets/pets/<species>/stage<N>.png`, 먹이 `assets/food/<id>.png`, 앱 아이콘 `assets/icon/app_icon.png`.
- **최종 규격 (Claude가 맞춤)**
  - 펫: 1행 × 4칸 = **256×64**, 칸마다 64×64. 칸 순서 `기본 | 눈 감음 | 기쁨 | 배고픔`.
  - 먹이: **32×32**.
  - 앱 아이콘: **1024×1024**, 배경 채움(투명 아님).
  - 펫·먹이 배경은 투명.
- **움직임은 그리지 않는다**: 흔들림·점프는 코드로 만든다. 걷기 프레임은 만들지 않는다.
- **특정 작품 캐릭터 금지**: 기존 게임·애니메이션의 고유한 생김새를 따라 하지 않는다.
- **앱 표시**: Flutter에서 `FilterQuality.none`으로 그린다(픽셀이 흐려지지 않게).
- **표정 칸 선택 (앱)**: 배고픔 30 이하 → 배고픔 칸, 기분 70 이상 → 기쁨 칸, 그 외 → 기본 칸(눈 감음과 교대). 탭하면 기쁨 칸 + 점프.

## 2. 펫 6장 (고양이·강아지·토끼 × 1·2단계)

### [ ] 고양이 1단계 — 원본 파일 이름 `cat_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby kitten, orange tabby with a cream belly, big eyes, short stubby tail.
```

### [ ] 고양이 2단계 — 원본 파일 이름 `cat_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same kitten as the reference image, grown a little bigger and more mature, longer tail, small golden bell collar. Keep the same colors and face.
```

### [ ] 강아지 1단계 — 원본 파일 이름 `dog_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby puppy, light brown fur with one darker brown ear, floppy ears, big eyes.
```

### [ ] 강아지 2단계 — 원본 파일 이름 `dog_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same puppy as the reference image, grown a little bigger and more mature, wagging tail, small red scarf. Keep the same colors and face.
```

### [ ] 토끼 1단계 — 원본 파일 이름 `rabbit_stage1.png`
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: a tiny round baby bunny, white fur with pink inner ears, short ears, fluffy round tail.
```

### [ ] 토끼 2단계 — 원본 파일 이름 `rabbit_stage2.png` (1단계 그림을 참고 이미지로 함께 올림)
```
Cute pixel art virtual pet sprite sheet, 16-bit style, chibi round body, front view facing the viewer,
clean dark outline, limited palette (about 16 colors), soft shading, readable at 64x64 pixels,
fully transparent background, no ground shadow, no text, no logos, no watermark.
Wide image with exactly 4 equal square cells in a single row, the pet centered in each cell at the same position and the same size.
Cells from left to right: 1) neutral idle, 2) eyes closed (blink), 3) happy (smiling, eyes curved), 4) hungry (droopy ears, small sweat drop).
The same character in every cell; only the face and posture change.
The pet: the same bunny as the reference image, grown a little bigger and more mature, long upright ears, a small flower on one ear. Keep the same colors and face.
```

**격자가 잘 안 나올 때**: 마지막 줄(`The pet:`)은 그대로 두고, 4칸 대신 한 칸씩 4번 생성해도 된다. 그때는 둘째 줄부터 셋째 줄을 `Single pet, centered, square image, expression: <neutral idle / eyes closed / happy / hungry>.`로 바꾸고, 원본 파일 이름 뒤에 `_1`~`_4`를 붙인다(예: `cat_stage1_1.png`).

## 3. 먹이 아이콘 3장

고양이·강아지·토끼 모두에게 주는 먹이라 특정 동물을 떠올리게 하는 모양(뼈다귀, 생선, 당근 등)은 쓰지 않는다.

### [ ] 기본 사료 — 원본 파일 이름 `food_basic.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a small round pet bowl filled with colorful round food pellets (light brown, green and orange), a generic pet food that suits any small animal.
```

### [ ] 간식 — 원본 파일 이름 `food_snack.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a heart-shaped cookie with pink icing, a generic treat that suits any small animal (not a bone, not a fish).
```

### [ ] 특별식 — 원본 파일 이름 `food_special.png`
```
Pixel art food item icon, 16-bit style, clean dark outline, limited palette, single item centered, square image,
readable at 32x32 pixels, fully transparent background, no text, no logos, no watermark.
Item: a festive plate with a small strawberry cake and a little star sparkle.
```

## 4. 앱 아이콘 1장

펫 1단계 그림을 모두 만든 뒤에 만든다. 고양이 1단계 그림을 참고 이미지로 함께 올린다(다른 종으로 바꿔도 된다).

### [ ] 앱 아이콘 — 원본 파일 이름 `app_icon.png`
```
App icon, 1024x1024, square, pixel art 16-bit style, clean dark outline, limited palette.
The kitten from the reference image, only its head and front paws, peeking up from behind a large white checkmark.
Solid warm orange background filling the whole square (not transparent), the character centered and filling about 60% of the icon,
simple and readable at small sizes, no text, no letters, no logos, no watermark, no rounded corners.
```
