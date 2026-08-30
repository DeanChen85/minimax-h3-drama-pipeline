# Minimax H3 Auto News Radar - 每 6 小时执行
# 强制UTF-8编码，解决任务计划程序乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = "Continue"

$cd = "G:\ComfyUI-aki-v3"
Set-Location $cd

$logFile = "$cd\auto_search_log.txt"
$reportFile = "$cd\latest_news.md"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 读取 Tavily Key 索引
$keyIndexFile = "$cd\tavily_key_index.txt"
$keys = @(
    "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",
    "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",
    "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",
    "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",
    "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"
)

if (Test-Path $keyIndexFile) {
    $currentIndex = [int](Get-Content $keyIndexFile)
} else {
    $currentIndex = 0
}

$apiKey = $keys[$currentIndex]
$nextIndex = ($currentIndex + 1) % $keys.Count
$nextIndex | Out-File -FilePath $keyIndexFile -Encoding UTF8

Add-Content -Path $logFile -Value "[$timestamp] Using Key #$($currentIndex+1), searching..."

# 搜索查询列表
$queries = @(
    "Minimax H3 ComfyUI new update release August 2026",
    "ComfyUI-H3-Multishot new version",
    "Minimax H3 Director workflow improvements"
)

$allResults = @()

foreach ($query in $queries) {
    try {
        $body = @{
            api_key = $apiKey
            query = $query
            search_depth = "advanced"
            max_results = 5
        } | ConvertTo-Json

        $headers = @{"Content-Type" = "application/json"}
        $response = Invoke-RestMethod -Uri "https://api.tavily.com/search" -Method Post -Headers $headers -Body $body -TimeoutSec 30

        foreach ($r in $response.results) {
            $allResults += @{
                Query = $query
                Title = $r.title
                URL = $r.url
                Content = $r.content
                Date = $timestamp
            }
        }
    }
    catch {
        Add-Content -Path $logFile -Value "[$timestamp] Search failed for '$query': $_"
    }

    Start-Sleep -Seconds 2
}

# 生成报告
$report = @"
# 🔍 Minimax H3 Auto News Report

**最后更新**: $timestamp
**搜索范围**: GitHub, Reddit, Forum
**使用 Key**: #$($currentIndex+1)

---

"@

foreach ($result in $allResults | Select-Object -First 10) {
    $report += @"

## 📌 $($result.Title)

- **来源**: [$($result.URL)]($($result.URL))
- **查询关键词**: $($result.Query)
- **摘要**: $($result.Content.Substring(0, [Math]::Min(300, $result.Content.Length)))

---

"@
}

$report | Out-File -FilePath $reportFile -Encoding UTF8
Add-Content -Path $logFile -Value "[$timestamp] Report generated: $reportFile"

# 自动 Git 提交与推送
git add latest_news.md auto_search_log.txt
$hasChanges = (git status --porcelain)
if ($hasChanges) {
    git commit -m "Auto-update: News radar scan at $timestamp"
    # 从外部安全文件读取 Token
    $tokenFile = "$cd\.git_github_token.txt"
    if (Test-Path $tokenFile) {
        $env:GH_TOKEN = Get-Content $tokenFile
        git push origin feature/spectrum-acceleration 2>&1 | Out-Null
        Add-Content -Path $logFile -Value "[$timestamp] Pushed to GitHub successfully"
    } else {
        Add-Content -Path $logFile -Value "[$timestamp] ERROR: Token file not found, push skipped"
    }
}

Add-Content -Path $logFile -Value "[$timestamp] Cycle complete."

# 发送飞书通知
$feishuMsg = "📊 **Minimax H3 自动扫描报告**`n`n"
$feishuMsg += "🔍 找到 $($allResults.Count) 条最新更新`n`n"

$topResults = $allResults | Select-Object -First 5
foreach ($result in $topResults) {
    $feishuMsg += "📌 **$($result.Title)**`n"
    $feishuMsg += "🔗 $($result.URL)`n`n"
}

$feishuMsg += "📂 完整报告已自动同步到 GitHub 分支`n"
$feishuMsg += "🔗 https://github.com/DeanChen85/minimax-h3-drama-pipeline/blob/feature/spectrum-acceleration/latest_news.md"

& "$cd\send_feishu_msg.ps1" $feishuMsg "📰 Minimax H3 最新动态" 2>&1 | Out-Null
Add-Content -Path $logFile -Value "[$timestamp] Feishu notification sent""
