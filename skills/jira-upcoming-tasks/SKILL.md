# Jira Upcoming Tasks

## Description

Jira에서 다가오는 작업들을 조회합니다 (앞으로 2주 이내 마감일 또는 지난주부터 시작된 작업).

## When to use

- 사용자가 다가오는 작업을 확인하고 싶을 때
- "다음 작업", "upcoming tasks", "앞으로 할 일", "이번주 작업" 등의 요청이 있을 때
- 장기적인 작업 계획을 확인하고 싶을 때

## Input Schema

```json
{}
```

## Instructions

1. PowerShell 스크립트를 실행하여 Jira 작업 조회
2. 결과를 파싱하여 사용자에게 보기 좋게 표시
3. 각 작업의 키, 제목, 상태, 마감일, 우선순위 표시

## Implementation

```bash
cd scripts && powershell.exe -ExecutionPolicy Bypass -File run-jira-mcp.ps1 -ScriptPath jira-upcoming-tasks.mjs
```

## Output Format

조회된 작업들을 다음 형식으로 표시:

```
📅 다가오는 작업 (N개)

[SCRUM-XX] 작업 제목
  상태: In Progress
  우선순위: High
  시작: YYYY-MM-DD
  마감: YYYY-MM-DD
  🔗 https://m-project.atlassian.net/browse/SCRUM-XX

[SCRUM-YY] 다른 작업
  ...
```

작업이 없으면:
```
✅ 다가오는 작업이 없습니다.
```
