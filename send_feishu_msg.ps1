# Feishu Message Send Script - Base64 encoded for maximum compatibility
# Usage: .\send_feishu_msg.ps1 "message" "title"

# 强制UTF-8编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ErrorActionPreference = "Stop"

$cd = "G:\ComfyUI-aki-v3"
$webhookFile = "$cd\.feishu_webhook.txt"

if (-not (Test-Path $webhookFile)) {
    Write-Host "Webhook not found" -ForegroundColor Red
    exit 1
}

$webhook = (Get-Content $webhookFile -Raw).Trim()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

if ($args.Count -ge 1) {
    $Message = $args[0]
} else {
    $Message = "Test"
}

if ($args.Count -ge 2) {
    $Title = $args[1]
} else {
    $Title = "Minimax H3 Report"
}

# 使用UTF-8显式编码中文字符串
$utf8 = [System.Text.Encoding]::UTF8
$titleBytes = $utf8.GetBytes($Title)
$messageBytes = $utf8.GetBytes($Message)
$timestampBytes = $utf8.GetBytes("Time: $timestamp | Source: GitHub Auto Monitor")

$titleBase64 = [Convert]::ToBase64String($titleBytes)
$messageBase64 = [Convert]::ToBase64String($messageBytes)
$timestampBase64 = [Convert]::ToBase64String($timestampBytes)

# 使用Python（如果可用）或者使用纯JSON with escaped Unicode
$jsonString = @"
{"msg_type":"interactive","card":{"header":{"title":{"tag":"plain_text","content":"$Title"},"template":"blue"},"elements":[{"tag":"div","text":{"tag":"plain_text","content":"$Message"}},{"tag":"note","elements":[{"tag":"plain_text","content":"Time: $timestamp | Source: GitHub Auto Monitor"}]}]}}
"@

# 写入临时文件，使用 UTF-8 无 BOM
$tempFile = [System.IO.Path]::GetTempFileName()
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($tempFile, $jsonString, $utf8NoBom)
$bodyBytes = [System.IO.File]::ReadAllBytes($tempFile)
Remove-Item $tempFile -Force

try {
    $response = Invoke-RestMethod -Uri $webhook -Method Post -ContentType "application/json; charset=utf-8" -Body $bodyBytes -TimeoutSec 15
    Write-Host "Message sent successfully" -ForegroundColor Green
}
catch {
    Write-Host "Failed: $_" -ForegroundColor Red
    exit 1
}