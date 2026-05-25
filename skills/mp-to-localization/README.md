# MP to Localization Skill

## 개요
Unity 무간론파 프로젝트용 현지화(Localization) 자동화 스킬입니다.

.mp.txt 스크립트를 파싱하여 StringID를 자동 생성하고, Google Sheets에 번역 데이터를 기입한 후, 최종 .mp.txt 파일을 StringID 기반으로 변환합니다.

## 워크플로우

```
[시나리오 작성] → [.mp.txt 작성] → [스킬 실행]
                                        ↓
                        ┌───────────────┴───────────────┐
                        ↓                               ↓
              [Google Sheets 기입]            [.mp.txt 변환]
              (번역 작업용)                   (StringID로 교체)
```

## 사용법

### 1. 커맨드 실행
```bash
/mp-to-localization Assets/Resources/Scripts/chapter1_demo.mp.txt
```

### 2. 자동 처리
- 파일 파싱
- StringID 생성 (PROL_NARR_001, CH01_DOKGOYEON_001 등)
- Google Sheets "무간론파" 업데이트
- .mp.txt 파일을 StringID로 변환

### 3. 결과 확인
- 백업 파일: `chapter1_demo.backup.mp.txt`
- 변환 파일: `chapter1_demo.mp.txt` (업데이트됨)
- Google Sheets: 번역 대기 상태로 기입됨

## 변환 예시

### Before (원본 .mp.txt)
```
; Source: Assets/_Project/scenario/Chapter/프롤로그.md
@dialogue_start
Narration: 검은 천장 아래, 열여섯 사람이 거의 동시에 눈을 <link="shake">떴다.</link> mode:narration speed:1.0
DokgoYeon: 이름만 남기고 다 지웠다, 이건가. emotion:cold pos:center
UsaHyeon: 됐다. 대충 파악했어. 이 안에 쓸 만한 놈들은 있네. speed:1.2
쾅!
@dialogue_end
```

### After (변환 .mp.txt)
```
; Source: Assets/_Project/scenario/Chapter/프롤로그.md
@dialogue_start
Narration: PROL_NARR_001 mode:narration speed:1.0
DokgoYeon: PROL_DOKGOYEON_001 emotion:cold pos:center
UsaHyeon: PROL_USAHYEON_001 speed:1.2
PROL_SFX_001
@dialogue_end
```

### Google Sheets 결과

| StringID | Context | Speaker | KO | EN | JP | CN |
|----------|---------|---------|----|----|----|----|
| PROL_NARR_001 | 프롤로그 시작 | Narration | 검은 천장 아래, 열여섯 사람이 거의 동시에 눈을 `<link="shake">`떴다.`</link>` | (empty) | (empty) | (empty) |
| PROL_DOKGOYEON_001 | 독고연 대사 | DokgoYeon | 이름만 남기고 다 지웠다, 이건가. | (empty) | (empty) | (empty) |
| PROL_USAHYEON_001 | 우사현 대사 | UsaHyeon | 됐다. 대충 파악했어. 이 안에 쓸 만한 놈들은 있네. | (empty) | (empty) | (empty) |
| PROL_SFX_001 | 효과음 | SFX | 쾅! | (empty) | (empty) | (empty) |

## StringID 생성 규칙

### 챕터 감지
- 파일명에서 자동 감지: `프롤로그.md` → PROL
- 코멘트에서 감지: `; Source: .../챕터1.md` → CH01
- 기본값: SCENE

### 타입 분류
- **NARR**: Narration, 서술 텍스트
- **캐릭터명**: DokgoYeon, UsaHyeon, HaYeonju 등
- **SFX**: 효과음 (짧은 텍스트, 느낌표/의성어)
- **COMMENT**: 메타 설명

### 카운터
- 타입별로 독립적으로 001부터 시작
- 예: PROL_NARR_001, PROL_NARR_002, PROL_DOKGOYEON_001

## 마크업 처리

인라인 마크업은 **번역 텍스트에 포함**됩니다:
```
<sp:240>        - 공백/지연
<size:1.3>      - 텍스트 크기
<link="shake">  - 효과 링크
```

번역자가 언어별로 마크업 위치를 조정할 수 있습니다:
```
KO: 방금 분명히 <size:1.3>뭔가</size> 지나갔어.
EN: Something <size:1.3>definitely</size> passed by.
JP: 今確かに<size:1.3>何か</size>通り過ぎた。
```

## 연출 코드 처리

연출 코드는 .mp.txt에만 유지되며, Google Sheets에는 포함되지 않습니다:
```
speed:1.5        - 타이핑 속도
emotion:normal   - 감정 상태
pos:left         - 캐릭터 위치
mode:narration   - 대화 모드
delay:0.35       - 대기 시간
```

## 다음 단계

1. **번역 작업**: Google Sheets에서 EN/JP/CN 컬럼 번역
2. **게임 적용**: LocalizationManager가 StringID로 텍스트 조회
3. **검증**: Unity에서 .mp.txt 실행 테스트

## 기술 스택
- Claude Code Skill
- Google Sheets API (MCP)
- Unity MP Script Parser

## 버전
- 1.0.0 - 초기 릴리즈
