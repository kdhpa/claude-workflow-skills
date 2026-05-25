# Jira Today Tasks Skill
# 오늘이 시작일과 마감일 사이에 있는 진행중인 작업 조회

param()

$ErrorActionPreference = "Stop"
$OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $projectRoot = "E:\UnityProject\M_Project"
    $scriptPath = Join-Path $projectRoot "scripts\jira-today-formatted.mjs"

    # Node.js로 직접 실행하여 포맷팅된 출력 받기
    Push-Location $projectRoot
    & node $scriptPath
    $exitCode = $LASTEXITCODE
    Pop-Location

    exit $exitCode
}
catch {
    Write-Host ""
    Write-Host "❌ 오류 발생: $_" -ForegroundColor Red
    Write-Host ""
    exit 1
}
