# Minimax H3 Auto Sync Script
$ErrorActionPreference = "Stop"
Write-Host "🔄 Starting auto-sync to GitHub..." -ForegroundColor Cyan

$cd = "G:\ComfyUI-aki-v3"
Set-Location $cd

# Add all changes
git add .

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Auto-update: $timestamp"

    # 从外部安全文件读取 Token
    $tokenFile = "$cd\.git_github_token.txt"
    if (Test-Path $tokenFile) {
        $env:GH_TOKEN = Get-Content $tokenFile
        git push origin master
        Write-Host "✅ Sync completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ Token file not found: $tokenFile" -ForegroundColor Red
    }
} else {
    Write-Host "✨ No changes detected. Everything is up to date." -ForegroundColor Yellow
}
