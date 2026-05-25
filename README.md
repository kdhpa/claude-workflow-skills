# JIRA Skills Plugin for Claude Code

JIRA 작업 관리를 위한 Claude Code 플러그인입니다.

## 기능

이 플러그인은 다음 스킬을 제공합니다:

### JIRA 작업 관리
- **/jira-skills:today-tasks** - 오늘 시작일/마감일인 진행중인 작업 조회
- **/jira-skills:complete-tasks** - 완료된 작업 처리
- **/jira-skills:reschedule** - 연체된 작업 마감일 재조정
- **/jira-skills:upcoming-tasks** - 다가오는 작업 조회

### Unity 현지화 작업
- **/jira-skills:mp-to-localization** - MP 스크립트를 StringID로 변환하고 Google Sheets에 번역 데이터 기입

## 설치

### 1. 플러그인 설치

```bash
# Git 저장소에서 직접 설치
claude plugin install https://github.com/kdhpa/claude-workflow-skills

# 또는 로컬 디렉토리에서 테스트
claude --plugin-dir E:/claude-jira-skills
```

### 2. 환경 변수 설정

플러그인이 작동하려면 다음 환경 변수를 설정해야 합니다:

#### Windows (PowerShell)

```powershell
# 영구적으로 설정
[System.Environment]::SetEnvironmentVariable('JIRA_HOST', 'your-domain.atlassian.net', 'User')
[System.Environment]::SetEnvironmentVariable('JIRA_EMAIL', 'your-email@example.com', 'User')
[System.Environment]::SetEnvironmentVariable('JIRA_API_TOKEN', 'your-api-token', 'User')
[System.Environment]::SetEnvironmentVariable('JIRA_DEFAULT_PROJECT', 'SCRUM', 'User')

# 또는 현재 세션만
$env:JIRA_HOST = "your-domain.atlassian.net"
$env:JIRA_EMAIL = "your-email@example.com"
$env:JIRA_API_TOKEN = "your-api-token"
$env:JIRA_DEFAULT_PROJECT = "SCRUM"
```

#### Linux/Mac (Bash)

```bash
# ~/.bashrc 또는 ~/.zshrc에 추가
export JIRA_HOST="your-domain.atlassian.net"
export JIRA_EMAIL="your-email@example.com"
export JIRA_API_TOKEN="your-api-token"
export JIRA_DEFAULT_PROJECT="SCRUM"
```

### 3. JIRA API 토큰 발급

1. https://id.atlassian.com/manage-profile/security/api-tokens 방문
2. "Create API token" 클릭
3. 토큰 이름 입력 (예: "Claude MCP")
4. 생성된 토큰을 복사하여 `JIRA_API_TOKEN` 환경 변수에 설정

## 사용 방법

### 오늘 할 일 확인

```bash
/jira-skills:today-tasks
```

출력 예시:
```
📋 오늘의 작업 (2개)

[SCRUM-123] UI 컴포넌트 개발
  상태: In Progress
  마감: 2026-05-25
  🔗 https://m-project.atlassian.net/browse/SCRUM-123

[SCRUM-124] 버그 수정
  상태: In Progress
  마감: 2026-05-25
  🔗 https://m-project.atlassian.net/browse/SCRUM-124
```

### 연체된 작업 마감일 미루기

```bash
# 미리보기 (기본)
/jira-skills:reschedule

# 실제 업데이트 (7일 추가)
/jira-skills:reschedule --no-dry-run

# 커스텀 일수 (14일 추가)
/jira-skills:reschedule --no-dry-run --days-to-add 14
```

### 완료된 작업 처리

```bash
/jira-skills:complete-tasks
```

### 다가오는 작업 확인

```bash
/jira-skills:upcoming-tasks
```

## 의존성

이 플러그인은 다음 MCP 서버를 사용합니다:

- [@tom28881/mcp-jira-server](https://www.npmjs.com/package/@tom28881/mcp-jira-server)

플러그인 설치 시 자동으로 구성됩니다.

## 프로젝트별 설정 (선택사항)

특정 프로젝트에서만 다른 JIRA 설정을 사용하려면, 프로젝트의 `.env` 파일을 생성하고 환경 변수를 오버라이드할 수 있습니다:

```bash
# .env
JIRA_HOST=different-domain.atlassian.net
JIRA_DEFAULT_PROJECT=OTHER
```

## 문제 해결

### 스킬이 작동하지 않을 때

1. 환경 변수가 올바르게 설정되었는지 확인:
   ```bash
   # Windows
   echo $env:JIRA_HOST

   # Linux/Mac
   echo $JIRA_HOST
   ```

2. Node.js가 설치되어 있는지 확인:
   ```bash
   node --version
   ```

3. MCP 서버가 정상 작동하는지 테스트:
   ```bash
   npx -y @tom28881/mcp-jira-server
   ```

4. Claude Code를 재시작하거나 `/reload-plugins` 실행

### 환경 변수가 적용되지 않을 때

- Windows: PowerShell을 재시작하거나 시스템을 재시작
- Linux/Mac: 터미널을 재시작하거나 `source ~/.bashrc` 실행

## 개발

### 로컬 테스트

```bash
# 플러그인 디렉토리에서 직접 로드
claude --plugin-dir ./

# 변경사항 적용
/reload-plugins
```

### 플러그인 검증

```bash
cd E:/claude-jira-plugin
claude plugin validate
```

## 라이선스

MIT

## 기여

이슈나 PR은 환영합니다!

## 버전 히스토리

### 1.0.0 (2026-05-25)

- 초기 릴리스
- JIRA 작업 조회 스킬
- 작업 완료 처리 스킬
- 마감일 재조정 스킬
- 다가오는 작업 조회 스킬
