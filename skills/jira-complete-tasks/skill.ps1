# Jira Complete Tasks Skill
param(
    [bool]$dryRun = $true,
    [string]$jql = "project = SCRUM AND status NOT IN (Done, Closed) AND resolution = Unresolved"
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $projectRoot = "E:\UnityProject\M_Project"
    $scriptPath = Join-Path $projectRoot "scripts\jira-complete-tasks.mjs"

    # 실행 인자 구성
    $args = @()
    if ($dryRun) {
        $args += "--dry-run"
    } else {
        $args += "--no-dry-run"
    }
    if ($jql) {
        $args += "--jql"
        $args += $jql
    }

    # Node.js 스크립트 실행
    Push-Location (Join-Path $projectRoot "scripts")
    $result = node jira-complete-tasks.mjs @args 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
    Pop-Location

    if ($exitCode -ne 0) {
        Write-Host "❌ Jira 작업 완료 처리 실패" -ForegroundColor Red
        Write-Host $result
        exit 1
    }

    # JSON 파싱
    $json = $result | ConvertFrom-Json

    $summary = $json.summary
    $transitions = $json.transitions
    $errors = $json.errors

    # 결과 출력
    Write-Host ""
    if ($summary.dryRun) {
        Write-Host "🔄 작업 완료 처리 (DRY-RUN 모드)" -ForegroundColor Cyan
    } else {
        Write-Host "✅ 작업 완료 처리 완료" -ForegroundColor Green
    }
    Write-Host ""

    Write-Host "총 $($summary.totalFound)개 작업 발견" -ForegroundColor White
    Write-Host "- 완료 $(if ($summary.dryRun) { '예정' } else { '완료' }): $($summary.completed)개" -ForegroundColor Green
    if ($summary.skipped -gt 0) {
        Write-Host "- 건너뜀: $($summary.skipped)개" -ForegroundColor Yellow
    }
    if ($summary.failed -gt 0) {
        Write-Host "- 실패: $($summary.failed)개" -ForegroundColor Red
    }
    Write-Host ""

    if ($transitions.Count -gt 0) {
        foreach ($transition in $transitions) {
            $key = $transition.key
            $summary_text = $transition.summary
            $fromStatus = $transition.fromStatus
            $toStatus = $transition.toStatus
            $transitionId = $transition.transitionId
            $status = $transition.status

            Write-Host "[$key] $summary_text" -ForegroundColor Yellow
            Write-Host "  상태 변경: $fromStatus → $toStatus" -ForegroundColor Gray
            Write-Host "  전환 ID: $transitionId" -ForegroundColor Gray
            Write-Host "  상태: $status" -ForegroundColor $(if ($status -eq 'completed') { 'Green' } elseif ($status -eq 'would-complete') { 'Cyan' } else { 'Red' })

            if ($transition.error) {
                Write-Host "  오류: $($transition.error)" -ForegroundColor Red
            }

            Write-Host ""
        }
    }

    if ($errors.Count -gt 0) {
        Write-Host "⚠️  오류 목록:" -ForegroundColor Yellow
        foreach ($error in $errors) {
            Write-Host "  [$($error.key)] $($error.error)" -ForegroundColor Red
        }
        Write-Host ""
    }

    if ($summary.dryRun -and $summary.completed -gt 0) {
        Write-Host "💡 실제 업데이트하려면 dryRun=false로 다시 실행하세요." -ForegroundColor Cyan
        Write-Host ""
    }

    if ($json.message) {
        Write-Host $json.message -ForegroundColor Gray
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
