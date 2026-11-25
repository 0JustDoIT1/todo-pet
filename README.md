# todolist

Flutter 기반 투두리스트 + 도트 펫 육성 앱의 기획 뼈대입니다.

## 현재 범위

- `docs/PRD.md`: Phase 1 MVP, MVP 제외 목록, 정산·펫 상태 초기 규칙
- `docs/decisions.md`: 확정된 기술 선택과 미정 사항
- `docs/ART_PROMPTS.md`: 펫·먹이 그림 AI 생성 규칙과 프롬프트
- `ASSETS.md`: 에셋 출처·라이선스
- `CLAUDE.md`, `.claude/`: project-skeleton(공통 v1.1)의 개발 규칙과 명령 템플릿
- `docs/modules/`: 적용 중인 모듈 규칙 (db, mobile)

앱 코드와 Flutter 프로젝트는 아직 생성하지 않았습니다. 원본 기획서는 사용자 제공 `투두리스트_펫육성게임_기획서.docx`입니다.

원본 기획서와 달라진 점: 펫 그래픽은 64×64 스프라이트시트를 직접 그리지 않고, 개발할 때 AI 이미지 생성으로 표정 시트(1×4)를 만들고 움직임은 코드로 처리합니다.
