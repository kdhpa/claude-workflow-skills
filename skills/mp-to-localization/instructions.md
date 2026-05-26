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

### 4. 자동 번역
각 한국어 텍스트를 자동 번역:
- **EN**: 영어 번역 (자연스러운 미국식 영어)
- **JP**: 일본어 번역 (히라가나/가타카나/한자 적절히 사용)
- **CN**: 중국어 간체 번역

번역 시 주의사항:
- 인라인 마크업 태그 위치 유지: `<sp:240>`, `<size:1.3>`, `<link="shake">` 등
- 화자 톤과 감정 유지
- 문화적 뉘앙스 고려
- 게임 대사 스타일 유지 (자연스럽고 간결하게)

### 5. Google Sheets 기입
테이블 구조:
| StringID | KO | EN | JP | CN |
|----------|----|----|----|----|
| PROL_NARR_001 | 검은 천장 아래... | Under the black ceiling... | 黒い天井の下で... | 在黑色的天花板下... |
| PROL_DOKGOYEON_001 | 이름만 남기고... | Only the name remains... | 名前だけ残して... | 只留下名字... |

- 기존 데이터 삭제 (헤더 제외)
- 모든 언어(KO, EN, JP, CN)를 한 번에 기입
- 번역은 자동으로 생성됨

### 6. .mp.txt 업데이트
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

## 번역 품질 가이드라인
- 원문의 의미와 톤을 정확히 전달
- 게임 대사 특성 고려 (간결하고 임팩트 있게)
- 마크업 태그는 의미상 적절한 위치에 유지
- 캐릭터 성격과 말투 반영
- 문화적 차이 고려 (직역보다는 자연스러운 의역)

## 에러 처리
- 파일이 없으면 에러 메시지
- Google Sheets 연결 실패 시 로컬 CSV로 백업
- 파싱 실패 라인은 건너뛰고 경고 출력

## 출력
1. 처리 완료 메시지
   - 총 라인 수
   - StringID 생성 개수
   - 번역된 언어 수 (KO, EN, JP, CN)
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
