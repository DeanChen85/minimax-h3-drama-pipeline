# -*- coding: utf-8 -*-
"""
飞书消息发送脚本 - Python版本
彻底解决 PowerShell 编码问题
"""
import requests
import json
import sys
import os
from datetime import datetime

def send_feishu_message(message, title="Minimax H3 专员汇报"):
    """发送飞书卡片消息"""
    webhook_file = r"G:\ComfyUI-aki-v3\.feishu_webhook.txt"

    if not os.path.exists(webhook_file):
        print("Webhook file not found")
        return False

    with open(webhook_file, 'r', encoding='utf-8') as f:
        webhook = f.read().strip()

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    payload = {
        "msg_type": "interactive",
        "card": {
            "header": {
                "title": {
                    "tag": "plain_text",
                    "content": title
                },
                "template": "blue"
            },
            "elements": [
                {
                    "tag": "div",
                    "text": {
                        "tag": "plain_text",
                        "content": message
                    }
                },
                {
                    "tag": "note",
                    "elements": [
                        {
                            "tag": "plain_text",
                            "content": f"⏰ Time: {timestamp} | 📂 Source: GitHub Auto Monitor"
                        }
                    ]
                }
            ]
        }
    }

    try:
        # 使用 ensure_ascii=False 保持中文原样
        json_data = json.dumps(payload, ensure_ascii=False, indent=2)
        response = requests.post(
            webhook,
            headers={"Content-Type": "application/json; charset=utf-8"},
            data=json_data.encode('utf-8'),
            timeout=15
        )
        response.raise_for_status()
        print("Message sent successfully")
        return True
    except Exception as e:
        print(f"Failed: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        msg = sys.argv[1]
        title = sys.argv[2] if len(sys.argv) >= 3 else "Minimax H3 Report"
        send_feishu_message(msg, title)
    else:
        # 测试消息
        test_msg = "🧪 Python 编码测试\n\n"
        test_msg += "✅ 如果你看到这条消息且所有字符都正常，说明 Python 方案完美解决了编码问题！\n\n"
        test_msg += "🎯 测试内容：\n"
        test_msg += "- 中文：完整可读\n"
        test_msg += "- Emoji：🚀 🎉 📊 ⭐ 🍴\n"
        test_msg += "- 英文：Normal display\n"
        test_msg += "- 链接：https://github.com/DeanChen85/minimax-h3-drama-pipeline"
        send_feishu_message(test_msg, "🧪 Python 终极测试")