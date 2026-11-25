# todopet

할일을 완료하면 포인트가 쌓이고, 그 포인트로 도트 펫을 돌보는 Flutter 앱입니다. 로컬 우선(Drift/SQLite), 한국어 우선.

## 현재 상태 (Phase 1)

PRD Phase 1 기능 F1~F6이 화면까지 들어가 있습니다. 펫·먹이 그림은 아직 없어서 이모지로 대신 보여줍니다.

- 할일: 원타임·반복·체크리스트, 빠른·상세 등록, 오늘·캘린더·완료 보기, 이월·결석 처리
- 포인트: 난이도별 지급, 일일 상한 100P, 당일 취소 차감
- 펫: 시작 3종(고양이·강아지·토끼), 배고픔·기분 감소, 먹이 3종, 탭 반응, 애정도 50에서 2단계, 입양·교체
- 온보딩: 펫 고르기 → 첫 할일 → 첫 완료 보상 안내

## 실행

```powershell
flutter pub get
flutter run          # Android 에뮬레이터·기기
flutter test
```

Flutter 3.44.8 / Dart 3.12.2. 에뮬레이터 포트·저장 공간 문제는 `CLAUDE.md` 실행 환경을 참고하세요.

## 문서

- `docs/PRD.md`: 기능 기준선 (Phase 1 MVP, MVP 제외 목록, 규칙)
- `docs/decisions.md`: 확정된 기술 선택과 결정 기록
- `docs/ART_PROMPTS.md`: 펫·먹이 그림 AI 생성 규칙과 프롬프트
- `ASSETS.md`: 에셋 출처·라이선스
- `CLAUDE.md`, `.claude/`: project-skeleton(공통 v1.1)의 개발 규칙과 명령 템플릿
- `docs/modules/`: 적용 중인 모듈 규칙 (db, mobile)

원본 기획서와 달라진 점: 펫 그래픽은 64×64 스프라이트시트를 직접 그리지 않고, 개발할 때 AI 이미지 생성으로 표정 시트(1×4)를 만들고 움직임은 코드로 처리합니다.
