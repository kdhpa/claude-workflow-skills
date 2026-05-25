# Jira Reschedule Skill
param(
    [bool]$dryRun = $true,
    [int]$daysToAdd = 7
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $projectRoot = "E:\UnityProject\M_Project"
    $scriptPath = Join-Path $projectRoot "scripts\jira-reschedule.mjs"

    # 실행 인자 구성
    $args = @()
    if ($dryRun) {
        $args += "--dry-run"
    } else {
        $args += "--no-dry-run"
    }
    $args += "--days-to-add"
    $args += $daysToAdd

    # Node.js 스크립트 실행
    Push-Location (Join-Path $projectRoot "scripts")
    $result = node jira-reschedule.mjs @args 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
    Pop-Location

    if ($exitCode -ne 0) {
        Write-Host "❌ Jira 재조정 실패" -ForegroundColor Red
        Write-Host $result
        exit 1
    }

    # JSON 파싱
    $json = $result | ConvertFrom-Json

    $summary = $json.summary
    $changes = $json.changes
    $errors = $json.errors

    # 결과 출력
    Write-Host ""
    if ($summary.dryRun) {
        Write-Host "🔄 마감일 재조정 (DRY-RUN 모드)" -ForegroundColor Cyan
    } else {
        Write-Host "✅ 마감일 재조정 완료" -ForegroundColor Green
    }
    Write-Host ""

    Write-Host "총 $($summary.totalFound)개 작업 발견" -ForegroundColor White
    Write-Host "- 재조정 $(if ($summary.dryRun) { '예정' } else { '완료' }): $($summary.rescheduled)개" -ForegroundColor Green
    if ($summary.skipped -gt 0) {
        Write-Host "- 건너뜀: $($summary.skipped)개" -ForegroundColor Yellow
    }
    if ($summary.failed -gt 0) {
        Write-Host "- 실패: $($summary.failed)개" -ForegroundColor Red
    }
    Write-Host ""

    if ($changes.Count -gt 0) {
        foreach ($change in $changes) {
            $key = $change.key
            $summary_text = $change.summary
            $oldDate = $change.oldDueDate
            $newDate = $change.newDueDate
            $status = $change.status

            Write-Host "[$key] $summary_text" -ForegroundColor Yellow
            Write-Host "  현재 마감일: $oldDate" -ForegroundColor Gray
            Write-Host "  새 마감일: $newDate (+$daysToAdd일)" -ForegroundColor Gray
            Write-Host "  상태: $status" -ForegroundColor $(if ($status -eq 'rescheduled') { 'Green' } elseif ($status -eq 'would-reschedule') { 'Cyan' } else { 'Red' })

            if ($change.error) {
                Write-Host "  오류: $($change.error)" -ForegroundColor Red
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

    if ($summary.dryRun -and $summary.rescheduled -gt 0) {
        Write-Host "💡 실제 업데이트하려면 dryRun=false로 다시 실행하세요." -ForegroundColor Cyan
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
