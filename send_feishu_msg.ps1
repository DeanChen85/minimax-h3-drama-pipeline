# Feishu Message Send Script
# Usage: .\send_feishu_msg.ps1 "message content" "optional title"

$ErrorActionPreference = "Stop"

$cd = "G:\ComfyUI-aki-v3"
$webhookFile = "$cd\.feishu_webhook.txt"

if (-not (Test-Path $webhookFile)) {
    Write-Host "Webhook file not found: $webhookFile" -ForegroundColor Red
    exit 1
}

$webhook = (Get-Content $webhookFile -Raw).Trim()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Receive args
if ($args.Count -ge 1) {
    $Message = $args[0]
} else {
    $Message = "Default test message"
}

if ($args.Count -ge 2) {
    $Title = $args[1]
} else {
    $Title = "Minimax H3 专员汇报"
}

$body = @{
    msg_type = "interactive"
    card = @{
        header = @{
            title = @{
                tag = "plain_text"
                content = $Title
            }
            template = "blue"
        }
        elements = @(
            @{
                tag = "div"
                text = @{
                    tag = "lark_md"
                    content = $Message
                }
            }
            @{
                tag = "note"
                elements = @(
                    @{
                        tag = "plain_text"
                        content = "Time: $timestamp | Source: GitHub Auto Monitor"
                    }
                )
            }
        )
    }
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri $webhook -Method Post -ContentType "application/json" -Body $body -TimeoutSec 15
    Write-Host "Message sent successfully" -ForegroundColor Green
}
catch {
    Write-Host "Failed to send: $_" -ForegroundColor Red
    exit 1
}