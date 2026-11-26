# 에셋 출처·라이선스 (PRD 3.5)

앱에 들어가는 그림·소리 파일의 출처를 적는다. 생성 프롬프트와 규격은 [docs/ART_PROMPTS.md](docs/ART_PROMPTS.md).

| 파일 | 출처 (생성 도구·생성일) | 보정 내용 | 라이선스 |
| --- | --- | --- | --- |
| `assets/pets/cat/stage1.png`, `stage2.png` | ChatGPT 이미지 생성(OpenAI), 2026-11 | 4칸 분리 → 4칸 공통 영역으로 자르기 → 정사각형 맞춤 → 64×64 축소(면적 평균) → 투명도 이진화 → 256×64 시트 | 생성 도구 이용약관에 따름(출시 전 상업 이용 조건 확인, PRD 9장) |
| `assets/pets/dog/stage1.png`, `stage2.png` | 같음 | 같음 | 같음 |
| `assets/pets/rabbit/stage1.png`, `stage2.png` | 같음 | 같음 | 같음 |
| `assets/food/basic.png`, `snack.png`, `special.png` | ChatGPT 이미지 생성(OpenAI), 2026-11 | 그림 영역 자르기 → 정사각형 맞춤 → 32×32 축소 → 투명도 이진화 | 같음 |
| `assets/icon/app_icon.png`, Android `mipmap-*/ic_launcher.png`, iOS `AppIcon.appiconset/*.png` | ChatGPT 이미지 생성(OpenAI), 2026-11 | 1024×1024로 축소, 플랫폼별 기존 크기로 다시 저장(투명도 없음) | 같음 |

- 원본은 저장소 밖(사용자 기획 폴더)에 있다. 보정은 일회성 Pillow 스크립트로 했고, 같은 그림을 다시 넣을 때는 위 보정 순서를 따른다.
- 특별식 그림에는 호랑가시나무(크리스마스) 장식이 있다. 계절감이 문제되면 프롬프트에 `no seasonal decorations`를 넣어 다시 만든다.
