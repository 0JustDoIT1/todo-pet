# 그림 프롬프트 (PRD 3.5)

개발할 때 AI 이미지 생성으로 그림을 만들기 위한 프롬프트와 규칙. 앱은 실행 중에 AI를 호출하지 않는다. 출처 기록은 [ASSETS.md](../ASSETS.md).

스타일은 **매끈한 2D 일러스트**다(2026-11-27 도트에서 전환). 지금 앱에 있는 도트 그림은 이 문서로 새로 만든 그림으로 교체한다.

## 0. 만드는 방법 (사용자)

1. **한 대화창에서 순서대로** 생성한다. 같은 대화에서 만들어야 그림체가 맞는다. 첫 그림은 `cat_stage1`로 한다.
2. 아래 프롬프트를 **그대로** 붙여넣는다. 프롬프트 하나에 그림 하나.
3. **2·3단계 펫은 같은 종의 1단계 그림을 참고 이미지로 함께 올린다.** 그래야 같은 캐릭터로 나온다.
4. 그림체가 흔들리면 `cat_stage1` 그림을 참고 이미지로 올리고 프롬프트 맨 앞에 `Match the art style of the reference image exactly.`를 붙인다.
5. 크기: 배경은 **세로 1024×1536**, 나머지는 **정사각형 1024×1024**. 받은 PNG를 줄이거나 자르지 않고 저장한다.
6. 배경이 투명하게 나오지 않으면 "make the background transparent"로 다시 요청한다. 단색 배경을 지우면 테두리가 지저분해진다.
7. 파일 이름은 각 항목의 `원본 파일 이름`으로 하고, 한 폴더에 모아 경로를 알려 준다. 마음에 안 드는 그림은 다시 생성해도 되고, `The pet:`·`Item:`·`Room:` 뒤 생김새 문장은 바꿔도 된다.

Claude가 하는 일: 투명 영역 정리 → (펫) 2×2를 칸마다 잘라 같은 기준선·크기로 맞춰 1×4 시트로 재배치 → 고품질 축소(Lanczos, 반투명 가장자리 유지) → `assets/`에 넣기 → 앱 표시 방식 전환 → `ASSETS.md` 기록.

## 1. 규칙

- **저장 위치와 최종 규격 (Claude가 맞춤)**

  | 종류 | 앱 안 위치 | 최종 크기 | 배경 |
  | --- | --- | --- | --- |
  | 펫 표정 시트 | `assets/pets/<species>/stage<N>.png` | 2048×512 (1행 × 4칸, 칸 512×512) | 투명 |
  | 먹이 | `assets/food/<id>.png` | 256×256 | 투명 |
  | 배경 | `assets/backgrounds/<id>.png` | 1024×1536 | 채움 |
  | 소품 | `assets/props/<id>.png` | 384×384 | 투명 |
  | 프리즈 | `assets/items/freeze.png` | 256×256 | 투명 |
  | 앱 아이콘 | `assets/icon/app_icon.png` | 1024×1024 | 채움 |

- **표정 칸 순서**: 생성은 2×2(왼쪽 위 기본, 오른쪽 위 눈 감음, 왼쪽 아래 기쁨, 오른쪽 아래 배고픔), 앱 시트는 `기본 | 눈 감음 | 기쁨 | 배고픔`.
- **표정 칸 선택 (앱)**: 배고픔 30 이하 → 배고픔 칸, 기분 70 이상 → 기쁨 칸, 그 외 → 기본 칸(눈 감음과 교대). 탭하면 기쁨 칸 + 점프.
- **움직임은 그리지 않는다**: 흔들림·점프·찌그러짐·좌우 걷기는 코드로 만든다. 걷기 프레임은 만들지 않는다. 3단계는 걸을 때 좌우 반전하므로 몸을 살짝 오른쪽으로 돌린 자세로 그린다.
- **그림자 없음**: 바닥 그림자는 앱에서 그린다.
- **먹이 모양**: 고양이·강아지·토끼 모두에게 주는 먹이라 특정 동물을 떠올리게 하는 모양(뼈다귀, 생선, 당근 등)은 쓰지 않는다.
- **배경 바닥은 비워 둔다**: 소품은 사용자가 따로 놓으므로 배경 바닥에 가구·물건을 그리지 않는다.
- **특정 작품 캐릭터 금지**: 기존 게임·애니메이션의 고유한 생김새를 따라 하지 않는다.
- **앱 표시**: Flutter에서 `FilterQuality.medium`으로 그린다.

## 2. 펫 9장 (고양이·강아지·토끼 × 1~3단계)

### [ ] 고양이 1단계 — 원본 파일 이름 `cat_stage1.png` (가장 먼저)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: a tiny round baby kitten, orange tabby with a cream belly, big shiny eyes, short stubby tail.
```

### [ ] 고양이 2단계 — 원본 파일 이름 `cat_stage2.png` (고양이 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same kitten as the reference image, grown a little bigger, longer tail, a small golden bell collar. Keep the same colors and face.
```

### [ ] 고양이 3단계 — 원본 파일 이름 `cat_stage3.png` (고양이 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same kitten as the reference image, now a young adult cat, taller and more confident, long fluffy tail held up, golden bell collar. Keep the same colors and face.
```

### [ ] 강아지 1단계 — 원본 파일 이름 `dog_stage1.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: a tiny round baby puppy, light brown fur with one darker brown ear, floppy ears, big shiny eyes.
```

### [ ] 강아지 2단계 — 원본 파일 이름 `dog_stage2.png` (강아지 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same puppy as the reference image, grown a little bigger, wagging tail, a small red scarf. Keep the same colors and face.
```

### [ ] 강아지 3단계 — 원본 파일 이름 `dog_stage3.png` (강아지 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same puppy as the reference image, now a young adult dog, taller and more confident, tail up, red scarf. Keep the same colors and face.
```

### [ ] 토끼 1단계 — 원본 파일 이름 `rabbit_stage1.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: a tiny round baby bunny, white fur with pink inner ears, short ears, fluffy round tail.
```

### [ ] 토끼 2단계 — 원본 파일 이름 `rabbit_stage2.png` (토끼 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, front view facing the viewer, sitting, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same bunny as the reference image, grown a little bigger, long upright ears, a small flower on one ear. Keep the same colors and face.
```

### [ ] 토끼 3단계 — 원본 파일 이름 `rabbit_stage3.png` (토끼 1단계를 참고 이미지로)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading and small pink cheek blush, rounded chubby shapes, cozy and friendly mood. No text, no letters, no logos, no watermark.
Square image with a 2x2 grid of 4 equal cells on a fully transparent background: no background color, no cell borders, no grid lines, no ground shadow.
The same character in every cell, full body, standing on four legs in a three-quarter view with the body turned slightly to the right and the face looking at the viewer, centered at the same position and the same size in each cell, with generous empty margin around it.
Top-left: neutral idle. Top-right: eyes closed (blink), otherwise identical to top-left. Bottom-left: happy, smiling with curved eyes. Bottom-right: hungry, droopy ears, a small sweat drop, slightly sad.
Only the face and posture change between cells.
The pet: the same bunny as the reference image, now a young adult rabbit, taller and more graceful, long upright ears, a flower crown. Keep the same colors and face.
```

**격자가 잘 안 나올 때**: 2×2 대신 한 칸씩 4번 생성해도 된다. 둘째·셋째·넷째 줄을 `Single pet, centered, square image, fully transparent background, no ground shadow. Expression: <neutral idle / eyes closed (blink) / happy, smiling with curved eyes / hungry, droopy ears, small sweat drop>.`로 바꾸고, 원본 파일 이름 뒤에 `_1`~`_4`를 붙인다(예: `cat_stage1_1.png`).

## 3. 먹이 3장

### [ ] 기본 사료 — 원본 파일 이름 `food_basic.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single item icon centered in a square image, filling about 70% of it, fully transparent background, no ground shadow.
Item: a round pink pet bowl with a white paw print, filled with colorful round food pellets (light brown, green and orange), a generic pet food that suits any small animal.
```

### [ ] 간식 — 원본 파일 이름 `food_snack.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single item icon centered in a square image, filling about 70% of it, fully transparent background, no ground shadow.
Item: two heart-shaped cookies with pink icing and tiny sprinkles, a generic treat that suits any small animal (not a bone, not a fish).
```

### [ ] 특별식 — 원본 파일 이름 `food_special.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single item icon centered in a square image, filling about 70% of it, fully transparent background, no ground shadow.
Item: a festive plate with a small strawberry shortcake and a little star sparkle, no seasonal decorations.
```

## 4. 배경 4장 (기본 방 + 상점 배경 3종)

홈 화면을 가득 채우는 맵이다. 위쪽 약 40%는 벽, 아래쪽 약 60%는 펫이 서고 소품을 놓는 바닥이다. 앱은 위아래 UI(포인트·상태 카드·버튼)를 그 위에 얹는다.

### [ ] 기본 방 — 원본 파일 이름 `bg_default.png` (처음부터 장착, 판매 안 함)
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, warm dark-brown outlines, flat pastel colors with gentle soft shading, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent). An empty cozy room for a pet game home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above with gentle perspective. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: soft peach wall with a large arched window showing a blue sky with fluffy clouds and green bushes, warm light-pink wooden floor tiles.
```

### [ ] 민트 방 — 원본 파일 이름 `bg_mint.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, warm dark-brown outlines, flat pastel colors with gentle soft shading, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent). An empty cozy room for a pet game home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above with gentle perspective. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: pastel mint wallpaper with tiny white polka dots, a round window with white curtains, light natural wood floor.
```

### [ ] 별밤 방 — 원본 파일 이름 `bg_night.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, warm dark-brown outlines, flat pastel colors with gentle soft shading, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent). An empty cozy room for a pet game home screen, straight-on front view.
The back wall fills the upper 40%, the floor fills the lower 60% seen from slightly above with gentle perspective. A clear horizontal line where wall meets floor.
Keep the floor completely empty and plain: no furniture, no rugs, no objects, no characters, no animals.
Room: soft dusty-blue wall with a big window showing a starry night sky and a crescent moon, string of small warm lights along the top, lavender wooden floor.
```

### [ ] 정원 — 원본 파일 이름 `bg_garden.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, warm dark-brown outlines, flat pastel colors with gentle soft shading, cozy and friendly mood. No text, no letters, no logos, no watermark.
Portrait image 1024x1536, filled edge to edge (not transparent). An outdoor garden scene for a pet game home screen, straight-on front view.
The background (sky, fence, flower bushes) fills the upper 40%, the ground fills the lower 60% seen from slightly above with gentle perspective. A clear horizontal line where the fence meets the lawn.
Keep the lawn completely empty and plain: no furniture, no objects, no characters, no animals.
Garden: pastel blue sky with fluffy clouds, a white picket fence with small pink and yellow flowers, soft light-green lawn.
```

## 5. 소품 4장

홈 맵 바닥 위에 사용자가 놓는다. 바닥을 약간 위에서 내려다보는 각도로 그린다.

### [ ] 방석 — 원본 파일 이름 `prop_cushion.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single object centered in a square image, filling about 75% of it, seen from the front and slightly above, fully transparent background, no ground shadow.
Item: a round fluffy pink pet bed cushion with a cream scalloped rim.
```

### [ ] 화분 — 원본 파일 이름 `prop_plant.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single object centered in a square image, filling about 75% of it, seen from the front and slightly above, fully transparent background, no ground shadow.
Item: a leafy green houseplant in a cream pot with pink stripes.
```

### [ ] 장난감 공 — 원본 파일 이름 `prop_ball.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single object centered in a square image, filling about 60% of it, seen from the front and slightly above, fully transparent background, no ground shadow.
Item: a soft round toy ball with pastel rainbow stripes and a small star pattern.
```

### [ ] 스탠드 조명 — 원본 파일 이름 `prop_lamp.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single object centered in a square image, filling about 75% of it, seen from the front and slightly above, fully transparent background, no ground shadow.
Item: a small floor lamp with a cream round lampshade and a light-wood stand, glowing softly.
```

## 6. 프리즈 아이콘 1장

### [ ] 프리즈 — 원본 파일 이름 `item_freeze.png`
```
Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading, rounded shapes. No text, no letters, no logos, no watermark.
Single item icon centered in a square image, filling about 70% of it, fully transparent background, no ground shadow.
Item: a light-blue ice crystal shaped like a small shield with a white snowflake in the middle and a tiny sparkle.
```

## 7. 앱 아이콘 1장 (선택)

지금 아이콘(도트 고양이)을 일러스트로 바꾸고 싶을 때만. 고양이 1단계 그림을 참고 이미지로 함께 올린다(다른 종으로 바꿔도 된다). 배경색은 지금 적응형 아이콘 배경색 `#FC5D01`과 맞춘다.

### [ ] 앱 아이콘 — 원본 파일 이름 `app_icon.png`
```
App icon, 1024x1024, square. Soft cute 2D illustration in a kawaii sticker style, smooth clean lines, thick warm dark-brown outline, flat pastel colors with gentle soft shading.
The kitten from the reference image, only its head and front paws, peeking up from behind a large white checkmark.
Solid warm orange background (#FC5D01) filling the whole square (not transparent), the character centered and filling about 60% of the icon,
simple and readable at small sizes, no text, no letters, no logos, no watermark, no rounded corners.
```
