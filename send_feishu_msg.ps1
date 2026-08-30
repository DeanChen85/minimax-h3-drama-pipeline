# Feishu Message Send Script - UTF-8 enforced for Scheduled Tasks
# Usage: .\send_feishu_msg.ps1 "message" "title"

# 强制设置 UTF-8 编码（解决任务计划程序运行时的乱码问题）
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

# Build JSON using hashtable
$payload = @{
    msg_type = "interactive"
    card     = @{
        header = @{
            title = @{
                tag     = "plain_text"
                content = $Title
            }
            template = "blue"
        }
        elements = @(
            @{
                tag  = "div"
                text = @{
                    tag     = "plain_text"
                    content = $Message
                }
            }
            @{
                tag  = "note"
                elements = @(
                    @{
                        tag     = "plain_text"
                        content = "Time: $timestamp | Source: GitHub Auto Monitor"
                    }
                )
            }
        )
    }
} | ConvertTo-Json -Depth 10

# Save to UTF-8 file WITHOUT BOM (关键：飞书需要纯UTF-8)
$tempFile = [System.IO.Path]::GetTempFileName()
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($tempFile, $payload, $utf8NoBom)
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