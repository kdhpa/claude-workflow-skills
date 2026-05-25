# Jira Reschedule

## Description

Jira에서 연체된 작업들의 마감일을 자동으로 재조정합니다.

## When to use

- 사용자가 연체된 작업의 마감일을 미루고 싶을 때
- "마감일 미루기", "작업 연기", "reschedule", "연체 작업 재조정" 등의 요청이 있을 때
- 오래된 작업들을 정리하고 싶을 때

## Input Schema

```json
{
  "dryRun": {
    "type": "boolean",
    "description": "true면 미리보기만, false면 실제 업데이트",
    "default": true
  },
  "daysToAdd": {
    "type": "number",
    "description": "마감일에 추가할 일수",
    "default": 7
  }
}
```

## Instructions

1. PowerShell 스크립트를 실행하여 연체된 작업 조회 및 마감일 업데이트
2. dry-run 모드로 실행하여 변경될 내용 미리보기
3. 실제 업데이트가 필요하면 --no-dry-run 플래그 사용
4. 결과를 파싱하여 사용자에게 보기 좋게 표시

## Implementation

### 미리보기 (기본)
```bash
cd scripts && node jira-reschedule.mjs --dry-run
```

### 실제 업데이트
```bash
cd scripts && node jira-reschedule.mjs --no-dry-run
```

### 일수 커스터마이징
```bash
cd scripts && node jira-reschedule.mjs --no-dry-run --days-to-add 14
```

## Output Format

조회된 작업들을 다음 형식으로 표시:

```
🔄 마감일 재조정 (DRY-RUN 모드)

총 N개 작업 발견
- 재조정 예정: X개
- 건너뜀: Y개
- 실패: Z개

[SCRUM-XX] 작업 제목
  현재 마감일: 2024-01-01
  새 마감일: 2024-01-08 (+7일)
  상태: would-reschedule

실제 업데이트하려면 --no-dry-run 플래그를 사용하세요.
```

실제 업데이트 시:
```
✅ 마감일 재조정 완료

총 N개 작업 재조정됨
```
