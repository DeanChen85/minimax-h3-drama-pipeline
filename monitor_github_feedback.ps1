# GitHub Feedback Monitor Script
$ErrorActionPreference = "Stop"
Write-Host "📊 Checking GitHub feedback for minimax-h3-drama-pipeline..." -ForegroundColor Cyan

# 从外部安全文件读取 Token
$tokenFile = "G:\ComfyUI-aki-v3\.git_github_token.txt"
if (Test-Path $tokenFile) {
    $env:GH_TOKEN = Get-Content $tokenFile
} else {
    Write-Host "❌ Token file not found" -ForegroundColor Red
    exit 1
}

$gh = "C:\Program Files\GitHub CLI\gh.exe"

# Get repository stats
$stats = & $gh api repos/DeanChen85/minimax-h3-drama-pipeline | ConvertFrom-Json

Write-Host "`n--- Repository Stats ---" -ForegroundColor Yellow
Write-Host "⭐ Stars: $($stats.stargazers_count)"
Write-Host "🍴 Forks: $($stats.forks_count)"
Write-Host "👀 Watchers: $($stats.subscribers_count)"

# Check for new issues
$issues = & $gh api repos/DeanChen85/minimax-h3-drama-pipeline/issues?state=open | ConvertFrom-Json
Write-Host "`n--- Open Issues ($($issues.Count)) ---" -ForegroundColor Yellow
if ($issues.Count -gt 0) {
    foreach ($issue in $issues) {
        Write-Host "  [#$($issue.number)] $($issue.title) (by $($issue.user.login))" -ForegroundColor White
    }
} else {
    Write-Host "  No open issues. Great job!" -ForegroundColor Green
}

# Save report
$report = "GitHub Feedback Report - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
$report += "Stars: $($stats.stargazers_count), Forks: $($stats.forks_count)`n"
$report | Out-File -FilePath "G:\ComfyUI-aki-v3\github_feedback_log.txt" -Append

Write-Host "`n✅ Report saved to github_feedback_log.txt" -ForegroundColor Green

# 发送飞书通知
$feishuMsg = "📊 **GitHub 仓库每日报告**`n`n"
$feishuMsg += "⭐ Stars: $($stats.stargazers_count)`n"
$feishuMsg += "🍴 Forks: $($stats.forks_count)`n"
$feishuMsg += "👀 Watchers: $($stats.subscribers_count)`n`n"

if ($issues.Count -gt 0) {
    $feishuMsg += "📋 **开放 Issues ($($issues.Count))**`n"
    foreach ($issue in $issues | Select-Object -First 3) {
        $feishuMsg += "• #$($issue.number) - $($issue.title)`n"
    }
} else {
    $feishuMsg += "✅ 目前无开放 Issues`n"
}

& "G:\ComfyUI-aki-v3\send_feishu_msg.ps1" -Message $feishuMsg -Title "📊 GitHub 每日报告" 2>&1 | Out-Null
Write-Host "📢 Feishu notification sent"
