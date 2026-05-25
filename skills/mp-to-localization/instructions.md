# MP to Localization Skill

## 목적
.mp.txt 스크립트 파일을 파싱하여:
1. 자동으로 StringID 생성
2. 번역 텍스트를 Google Sheets에 기입
3. .mp.txt 파일을 StringID로 교체 (연출 코드는 유지)

## 입력
- .mp.txt 파일 경로 (필수)
- Google Sheets ID 또는 이름 (선택, 기본값: "무간론파")
- 챕터 프리픽스 (선택, 자동 감지)

## 워크플로우

### 1. 파일 읽기 및 파싱
- .mp.txt 파일 읽기
- 라인별 파싱:
  ```
  ; 코멘트 → 무시
  @command → 커맨드 라인 (그대로 유지)
  Speaker: Text direction:codes → 대화 라인
  일반 텍스트 → Narration 처리
  ```

### 2. StringID 생성 규칙
```
형식: {CHAPTER}_{TYPE}_{NUM}

CHAPTER:
- PROL (프롤로그)
- CH01, CH02, ... (챕터)
- 파일명 또는 Source 코멘트에서 자동 감지

TYPE:
- NARR: Narration, 서술 텍스트
- 캐릭터명: DokgoYeon, HaYeonju, UnSeoha 등
- SFX: 효과음
- COMMENT: 메타 설명

NUM:
- 001부터 시작, 타입별로 독립 카운팅
```

### 3. 텍스트 추출
각 대화 라인에서:
- **텍스트**: 마크업 포함 (`<sp:240>`, `<size:1.3>`, `<link="shake">` 등)
- **연출 코드**: `speed:1.5 emotion:normal pos:left` 등
- **화자**: Speaker 이름

### 4. Google Sheets 기입
테이블 구조:
| StringID | Context | Speaker | KO | EN | JP | CN |
|----------|---------|---------|----|----|----|----|
| PROL_NARR_001 | 프롤로그 시작 | Narration | 검은 천장 아래... | | | |
| PROL_DOKGOYEON_001 | 독고연 대사 | DokgoYeon | 이름만 남기고... | | | |

- 기존 데이터 삭제 (헤더 제외)
- 새 데이터 일괄 기입
- EN/JP/CN 컬럼은 비워둠 (번역 대기)

### 5. .mp.txt 업데이트
원본:
```
Narration: 검은 천장 아래, 열여섯 사람이 거의 동시에 눈을 <link="shake">떴다.</link> mode:narration speed:1.0
DokgoYeon: 이름만 남기고 다 지웠다, 이건가. emotion:cold pos:center
```

변환 후:
```
Narration: PROL_NARR_001 mode:narration speed:1.0
DokgoYeon: PROL_DOKGOYEON_001 emotion:cold pos:center
```

- 원본 백업: `{filename}.backup.mp.txt`
- 텍스트만 StringID로 교체
- 연출 코드, 커맨드 라인은 그대로 유지

## Context 자동 생성 규칙
- 첫 10단어 또는 20자 사용
- 화자명 포함
- 예: "독고연 첫 대사", "프롤로그 시작", "효과음 발소리"

## 에러 처리
- 파일이 없으면 에러 메시지
- Google Sheets 연결 실패 시 로컬 CSV로 백업
- 파싱 실패 라인은 건너뛰고 경고 출력

## 출력
1. 처리 완료 메시지
   - 총 라인 수
   - StringID 생성 개수
   - Google Sheets URL
2. 백업 파일 경로
3. 업데이트된 .mp.txt 파일

## 사용 예시
```
사용자: /mp-to-localization Assets/Resources/Scripts/chapter1_demo.mp.txt
```

## 주의사항
- **절대 질문하지 않음**: AskUserQuestion 사용 금지
- 모든 파라미터는 자동 감지 또는 기본값 사용
- 에러 발생 시 결과만 보고하고 계속 진행
- 기존 Google Sheets 데이터는 완전히 대체됨
