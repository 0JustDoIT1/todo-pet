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
| 코드 규칙 | 에러 처리 / 로깅 / 주석 언어 | 미정 |
| Git | 브랜치 전략 / 커밋 형식 | main + feature/*, Conventional Commits |
| 배포 | 환경 구분 / CI / 배포 대상 | 미정 |

## 기본 부품

| 용도 | 선택 | 이유 | 날짜 |
| --- | --- | --- | --- |
| 토스트·알림 | 미정 | | |
| 모달·다이얼로그 | 미정 | | |
| 폼 검증 | 미정 | | |
| 날짜·시간 처리 | 미정 | | |
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
