# Jira Complete Tasks

## Description

Jira에서 완료되지 않은 작업들을 Done 상태로 일괄 전환합니다.

## When to use

- 사용자가 작업을 완료 처리하고 싶을 때
- "작업 완료", "Done으로 변경", "complete tasks", "close issues" 등의 요청이 있을 때
- 특정 작업들을 일괄 완료 처리하고 싶을 때

## Input Schema

```json
{
  "dryRun": {
    "type": "boolean",
    "description": "true면 미리보기만, false면 실제 업데이트",
    "default": true
  },
  "jql": {
    "type": "string",
    "description": "완료할 작업을 찾을 JQL 쿼리",
    "default": "project = SCRUM AND status NOT IN (Done, Closed) AND resolution = Unresolved"
  }
}
```

## Instructions

1. PowerShell 스크립트를 실행하여 완료 대상 작업 조회 및 상태 변경
2. dry-run 모드로 실행하여 변경될 내용 미리보기
3. 실제 업데이트가 필요하면 --no-dry-run 플래그 사용
4. 결과를 파싱하여 사용자에게 보기 좋게 표시

## Implementation

### 미리보기 (기본)
```bash
cd scripts && node jira-complete-tasks.mjs --dry-run
```

### 실제 업데이트
```bash
cd scripts && node jira-complete-tasks.mjs --no-dry-run
```

### JQL 커스터마이징
```bash
cd scripts && node jira-complete-tasks.mjs --no-dry-run --jql "project = SCRUM AND assignee = currentUser() AND status = 'In Progress'"
```

## Output Format

조회된 작업들을 다음 형식으로 표시:

```
🔄 작업 완료 처리 (DRY-RUN 모드)

총 N개 작업 발견
- 완료 예정: X개
- 건너뜀: Y개
- 실패: Z개

[SCRUM-XX] 작업 제목
  상태 변경: In Progress → Done
  전환 ID: 41
  상태: would-complete

실제 업데이트하려면 --no-dry-run 플래그를 사용하세요.
```

실제 업데이트 시:
```
✅ 작업 완료 처리 완료

총 N개 작업을 Done으로 전환했습니다.
```
