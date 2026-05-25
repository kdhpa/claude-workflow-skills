# Jira Upcoming Tasks Skill
param()

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $projectRoot = "E:\UnityProject\M_Project"
    $scriptPath = Join-Path $projectRoot "scripts\jira-upcoming-tasks.mjs"
    $runScriptPath = Join-Path $projectRoot "scripts\run-jira-mcp.ps1"

    # PowerShell 스크립트 실행
    Push-Location (Join-Path $projectRoot "scripts")
    $result = & $runScriptPath -ScriptPath "jira-upcoming-tasks.mjs" 2>&1
    Pop-Location

    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Jira 조회 실패" -ForegroundColor Red
        Write-Host $result
        exit 1
    }

    # JSON 파싱
    $json = $result | ConvertFrom-Json

    if ($json.isError) {
        Write-Host "❌ Jira 조회 중 오류가 발생했습니다." -ForegroundColor Red
        Write-Host $json.content[0].text
        exit 1
    }

    # 작업 목록 파싱
    $issuesData = $json.content[0].text | ConvertFrom-Json
    $issues = $issuesData.issues

    if ($null -eq $issues -or $issues.Count -eq 0) {
        Write-Host ""
        Write-Host "✅ 다가오는 작업이 없습니다." -ForegroundColor Green
        Write-Host ""
        exit 0
    }

    # 결과 출력
    Write-Host ""
    Write-Host "📅 다가오는 작업 ($($issues.Count)개)" -ForegroundColor Cyan
    Write-Host ""

    foreach ($issue in $issues) {
        $key = $issue.key
        $summary = $issue.fields.summary
        $status = $issue.fields.status.name
        $priority = $issue.fields.priority.name
        $duedate = $issue.fields.duedate
        $startdate = $issue.fields.customfield_10015

        Write-Host "[$key] $summary" -ForegroundColor Yellow
        Write-Host "  상태: $status" -ForegroundColor Gray

        if ($priority) {
            Write-Host "  우선순위: $priority" -ForegroundColor Gray
        }

        if ($startdate) {
            Write-Host "  시작: $startdate" -ForegroundColor Gray
        }

        if ($duedate) {
            Write-Host "  마감: $duedate" -ForegroundColor Gray
        }

        Write-Host "  🔗 https://m-project.atlassian.net/browse/$key" -ForegroundColor Blue
        Write-Host ""
    }

    exit 0
}
catch {
    Write-Host ""
    Write-Host "❌ 오류 발생: $_" -ForegroundColor Red
    Write-Host ""
    exit 1
}
