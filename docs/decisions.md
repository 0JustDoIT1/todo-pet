# 결정 기록

이 파일은 CLAUDE.md에서 불러와 매번 읽힌다. 짧게 유지한다.
- **결정 시트**: 프로젝트를 시작할 때 채운다. 정하지 못한 칸은 `미정`으로 둔다.
- **기본 부품**: 흔한 기능에 무엇을 쓰기로 했는지. 같은 종류의 요청은 조사 없이 이 표를 따른다.
- **변경 로그**: 확정되거나 바뀐 결정을 한 줄씩. 오래된 줄이 20개를 넘으면 위 표에 반영한 뒤 정리한다.

## 결정 시트

| 분류 | 항목 | 결정 |
| --- | --- | --- |
| 플랫폼 | 대상 플랫폼·기기 | 모바일 앱. Phase 1 개발·검증은 Android, ios/ 폴더는 생성만(빌드는 Mac 필요). 패키지명 `com.justdoit.todopet` (변경 금지) |
| 플랫폼 | 개발 OS / 셸 | Windows / PowerShell |
| 스택 | 언어·프레임워크 (버전까지) | Flutter 3.44.8 (stable) / Dart 3.12.2 |
| 스택 | 패키지 매니저 | pub (`flutter pub`) |
| 구조 | 렌더링 방식 / 앱 구조 | 미정 |
| 구조 | 상태관리 | Riverpod |
| 구조 | API 방식 | 미정 |
| 구조 | 디렉터리 규칙 | 기능별: `lib/features/<기능>/{domain,data,ui}`, 공통 `lib/core/`. domain은 Flutter 의존 없는 순수 Dart |
| 데이터 | DB / ORM / 마이그레이션 도구 | 로컬 SQLite / Drift |
| 데이터 | 시드·데이터 입력 방식 | 시드 없음. DB 생성 시 user_profile 1행만 넣음. 종·먹이·카테고리는 코드 상수 |
| 데이터 | 스키마 버전 관리 | Drift schemaVersion + `drift_schemas/`(`dart run drift_dev make-migrations`). 생성 코드(`*.g.dart`)는 커밋 |
| 인증 | 방식과 권한 모델 | Phase 1 없음, Phase 3.5~4 소셜 로그인·클라우드 백업 |
| 외부 서비스 | 사용 서비스와 월 비용 상한 | Phase 1 앱 런타임 외부 서비스 없음 (에셋 생성은 개발자가 AI 이미지 도구로 수동 작업) |
| 품질 | 테스트 수준 (L0~L3) | L1 |
| 품질 | 린터 / 포매터 | flutter_lints 6 (템플릿 기본) / `dart format` |
| 코드 규칙 | 에러 처리 / 로깅 / 주석 언어 | 규칙 위반은 sealed 도메인 예외(`lib/core/error/`)로 던지고 화면에서 한국어로 안내 / `debugPrint`만, 개인 데이터(할일 제목 등)는 로그 금지 / 한국어 주석 |
| Git | 브랜치 전략 / 커밋 형식 | main + 작업별 브랜치(`feat/`·`fix/`·`docs/`·`chore/`·`refactor/`·`test/` + 내용). 작업이 끝나면 main에 `git merge --ff-only`로 로컬 병합(PR 없음). 커밋은 `feat\|fix\|refactor\|test\|docs\|chore: 요약`(한국어), Co-Authored-By 트레일러 없음. 커밋·병합·푸시는 승인 후 |
| 배포 | 환경 구분 / CI / 배포 대상 | 미정 |

## 기본 부품

| 용도 | 선택 | 이유 | 날짜 |
| --- | --- | --- | --- |
| 토스트·알림 | 미정 | | |
| 모달·다이얼로그 | 미정 | | |
| 폼 검증 | 미정 | | |
| 날짜·시간 처리 | 내장 DateTime + `lib/core/date/`(날짜 키 변환, 현재 시각 Provider). 한국어 날짜 표시가 필요해지면 intl 검토 | 필요 기능이 고정 형식 문자열과 테스트용 시각 고정뿐, 시각 읽는 곳이 서비스 한 곳 | 2026-11-25 |
| 아이콘 | 미정 | | |
| HTTP 클라이언트 | 미정 | | |
| 펫 그래픽 | 개발 시점 AI 생성(ChatGPT 이미지) 1×4 표정 시트 + 코드 모션, `docs/ART_PROMPTS.md` | MysteryTalk에서 같은 방식 사용, 직접 도트 제작보다 단순 | 2026-11-25 |

## 변경 로그

형식: `- YYYY-MM-DD | 결정 | 이유 | 영향 문서`

- 2026-11-21 | 기획서 기반 Phase 1 뼈대 작성, 템플릿 공통 v1.1 적용 | 사용자 요청 | docs/PRD.md, CLAUDE.md
- 2026-11-25 | 펫 그래픽을 직접 도트 제작 → 개발 시점 AI 생성 정적 에셋(1×4 표정 시트 + 코드 모션)으로 전환, 앱 안 AI 생성은 MVP 제외 | 제작 단순화, 로컬 우선 유지 | docs/PRD.md, docs/ART_PROMPTS.md, ASSETS.md, CLAUDE.md
- 2026-11-25 | PRD v0.2: 템플릿 구조 재정리, 포인트·펫 상태 초기 규칙 추가 (이번만 Claude 직접 수정 허용, 차단 원복) | 기획 검수 | docs/PRD.md
- 2026-11-25 | 모듈 db·mobile 적용, llm·game-mod 파일 삭제, 개발 OS Windows/PowerShell 확정 | 구조 정리 | CLAUDE.md, docs/modules/, .env.example
- 2026-11-25 | PRD v0.3 e2e 재검토: 체크리스트는 전체 완료 시만 지급, 시작 종 추가 입양 허용(상점 탭 유지), 기분은 표정에만 연결, 종·먹이·카테고리는 코드 상수, 날짜 넘김은 앱 열 때 일괄 처리, 취소 차감은 지급 당시 금액·완료된 할일 수정 불가·오늘/이월만 완료·배고픔 100이면 구매 불가·최저 먹이 5P 이하 | 과설계 제거·누락 보완 | docs/PRD.md(사용자가 직접 복사해 반영), CLAUDE.md, docs/ART_PROMPTS.md
- 2026-11-25 | Flutter 프로젝트 생성: Flutter 3.44.8 고정, 패키지명 com.justdoit.todopet, Dart 패키지 todo_pet, Android 먼저(ios/ 생성만), 기능별 폴더, flutter_lints | 사용자 선택 | docs/decisions.md, CLAUDE.md, pubspec.yaml
- 2026-11-25 | 패키지 추가(버전 고정): flutter_riverpod 3.5.0, drift 2.35.4, drift_flutter 0.3.1, dev: drift_dev 2.35.3, build_runner 2.15.1. Riverpod 코드 생성은 쓰지 않음 | 사용자 승인, pub.dev·dry-run으로 호환 확인 | pubspec.yaml, pubspec.lock
- 2026-11-25 | DB 스키마 v1 (todos·checklist_items·todo_occurrences·point_history·pets·user_profile). 취소는 회차 행을 남기고 status만 변경, 날짜는 현지 'yyyy-MM-dd' 문자열 | 사용자 승인 | lib/core/db/, drift_schemas/
- 2026-11-25 | 온보딩은 첫 할일 등록 때 펫·할일을 한 번에 저장하고 완료 처리, 첫 완료 보상 안내는 포인트 이력이 비었을 때 1회 | 같은 종 중복 저장 방지 (사용자 승인) | PRD 7장 수정 제안
- 2026-11-25 | 일일 상한은 완료 지급·취소 차감만 합산(지출 제외), 하위항목 0개 체크리스트는 완료 불가 | PRD 3.2 해석 (사용자 확정) | lib/features/points/domain/point_rules.dart
- 2026-11-25 | 에러 처리 sealed 도메인 예외, 로깅 debugPrint만, 한국어 주석, 날짜는 내장 DateTime + 현재 시각 Provider | 포인트 서비스 착수 전 결정 | docs/decisions.md
- 2026-11-25 | Git 방식을 MysteryTalk와 같게: 작업별 브랜치 + main에 fast-forward 로컬 병합, 한국어 커밋 메시지, Co-Authored-By 없음 | 1인 프로젝트라 PR 불필요, 기록을 한 줄로 유지 (사용자 요청) | docs/decisions.md, CLAUDE.md
- 2026-11-25 | 원본 기획서(PDF) 대조: 빠른 등록·상세 등록 기본 난이도 '중'(PRD의 '하' 대체), '가장 싼 먹이 5P 이하' 규칙 삭제(기본 사료 10P = 중 1건), 카테고리 8종은 기획서 2.9 이름으로 코드 상수 유지(Phase 2에 같은 id로 테이블 시드) | 사용자 결정 | lib/features/todo/domain/, PRD 3.1·3.3 수정 제안
- 2026-11-25 | 펫 수치는 기획서 값 사용 예정: 배고픔 시간당 약 4.2 감소(24시간에 100→0), 먹이 기본 사료 10P(배고픔+20·기분+5)·간식 30P(+10·+15)·특별식 100P(+50·+30) | 기획서 3.4·3.5 확정값 | 펫 작업 때 반영, PRD 9장 수정 제안
- 2026-11-25 | 한국어 날짜 선택 창을 위해 flutter_localizations(SDK 포함, 버전 없음) 사용 | 프레임워크 내장 | pubspec.yaml, lib/app.dart
- 2026-11-25 | 펫 성장은 애정도 50에서 2단계(기획서 3.2, Phase 1은 2단계까지), pets.exp 컬럼을 애정도로 사용. 초기값: 기분 시간당 -2, 애정도 먹이 +5/+5/+15·탭 +1, 탭 기분 +2 | 사용자 결정(성장 기준), 기획서에 없는 수치는 초기값 | lib/features/pet/domain/, PRD 3.3 수정 제안
- 2026-11-25 | 배고픔·기분은 읽을 때 경과 시간으로 계산하고 먹이·탭·교체 때만 저장 | 자주 열 때 소수점 감소가 버려지는 문제 방지 | lib/features/pet/data/pet_service.dart
- 2026-11-25 | 시작 펫 3종: 고양이(cat)·강아지(dog)·토끼(rabbit). 그림 전까지 이모지로 임시 표시 | 사용자 결정 | lib/features/pet/domain/species.dart, docs/ART_PROMPTS.md, PRD 9장 수정 제안
- 2026-11-25 | 온보딩: 소개 → 펫 고르기·이름 → 첫 할일 1~3개(기획서 5.9), 마지막에 한 번에 저장. 첫 완료 보상 안내는 포인트 이력이 없을 때 첫 지급 직후 1회 | 기존 결정(첫 할일 등록 때 저장) 구현 | lib/features/onboarding/
