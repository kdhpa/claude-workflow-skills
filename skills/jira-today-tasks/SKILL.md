# Jira Today Tasks

## Description

Jira에서 오늘 시작일이나 마감일인 진행중인 작업들을 조회합니다.

## When to use

- 사용자가 오늘 해야 할 일을 확인하고 싶을 때
- "오늘 할 일", "오늘 작업", "오늘의 Jira", "today's tasks" 등의 요청이 있을 때
- 작업 현황을 파악하고 싶을 때

## Input Schema

```json
{}
```

## Instructions

1. PowerShell 스크립트를 실행하여 Jira 작업 조회
2. 결과를 파싱하여 사용자에게 보기 좋게 표시
3. 각 작업의 키, 제목, 상태, 마감일, 링크 표시

## Implementation

```bash
cd scripts && powershell.exe -ExecutionPolicy Bypass -File run-jira-mcp.ps1 -ScriptPath jira-today-tasks.mjs
```

## Output Format

조회된 작업들을 다음 형식으로 표시:

```
📋 오늘의 작업 (N개)

[SCRUM-XX] 작업 제목
  상태: In Progress
  마감: YYYY-MM-DD
  🔗 https://m-project.atlassian.net/browse/SCRUM-XX

[SCRUM-YY] 다른 작업
  ...
```

작업이 없으면:
```
✅ 오늘 시작일/마감일인 진행중인 작업이 없습니다.
```
