# -*- coding: utf-8 -*-
"""
Minimax H3 自动新闻雷达 - Python版本
每6小时自动搜索最新动态并通知
"""
import requests
import json
import os
import subprocess
from datetime import datetime

def load_tavily_key():
    """读取 Tavily API Key（轮换）"""
    key_index_file = r"G:\ComfyUI-aki-v3\tavily_key_index.txt"
    keys = [
        "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",
        "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",
        "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",
        "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",
        "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"
    ]

    if os.path.exists(key_index_file):
        with open(key_index_file, 'r', encoding='utf-8-sig') as f:
            content = f.read().strip()
            current_index = int(content) if content else 0
    else:
        current_index = 0

    api_key = keys[current_index]
    next_index = (current_index + 1) % len(keys)

    with open(key_index_file, 'w', encoding='utf-8') as f:
        f.write(str(next_index))

    return api_key, current_index + 1

def search_tavily(api_key, query):
    """执行 Tavily 搜索"""
    try:
        response = requests.post(
            "https://api.tavily.com/search",
            headers={"Content-Type": "application/json"},
            json={
                "api_key": api_key,
                "query": query,
                "search_depth": "advanced",
                "max_results": 5
            },
            timeout=30
        )
        response.raise_for_status()
        return response.json().get("results", [])
    except Exception as e:
        print(f"Search failed for '{query}': {e}")
        return []

def send_feishu(message, title="📰 Minimax H3 最新动态"):
    """发送飞书通知"""
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
                "title": {"tag": "plain_text", "content": title},
                "template": "blue"
            },
            "elements": [
                {
                    "tag": "div",
                    "text": {"tag": "plain_text", "content": message}
                },
                {
                    "tag": "note",
                    "elements": [
                        {"tag": "plain_text", "content": f"⏰ Time: {timestamp} | 📂 Source: GitHub Auto Monitor"}
                    ]
                }
            ]
        }
    }

    try:
        json_data = json.dumps(payload, ensure_ascii=False)
        response = requests.post(
            webhook,
            headers={"Content-Type": "application/json; charset=utf-8"},
            data=json_data.encode('utf-8'),
            timeout=15
        )
        response.raise_for_status()
        print("Feishu message sent")
        return True
    except Exception as e:
        print(f"Feishu failed: {e}")
        return False

def git_commit_and_push():
    """自动提交并推送"""
    cd = r"G:\ComfyUI-aki-v3"
    try:
        subprocess.run(["git", "add", "latest_news.md", "auto_search_log.txt"], cwd=cd, check=True)
        result = subprocess.run(["git", "status", "--porcelain"], cwd=cd, capture_output=True, text=True)
        if result.stdout.strip():
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            subprocess.run(["git", "commit", "-m", f"Auto-update: News radar scan at {timestamp}"], cwd=cd, check=True)

            # 读取 token
            token_file = os.path.join(cd, ".git_github_token.txt")
            if os.path.exists(token_file):
                with open(token_file, 'r', encoding='utf-8') as f:
                    token = f.read().strip()
                env = os.environ.copy()
                env["GH_TOKEN"] = token
                subprocess.run(["git", "push", "origin", "feature/spectrum-acceleration"], cwd=cd, env=env, check=True)
                print("Pushed to GitHub")
                return True
    except Exception as e:
        print(f"Git operation failed: {e}")
    return False

def main():
    """主函数"""
    cd = r"G:\ComfyUI-aki-v3"
    log_file = os.path.join(cd, "auto_search_log.txt")
    report_file = os.path.join(cd, "latest_news.md")
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # 读取 Tavily Key
    api_key, key_num = load_tavily_key()
    print(f"[{timestamp}] Using Key #{key_num}, searching...")

    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(f"[{timestamp}] Using Key #{key_num}, searching...\n")

    # 搜索查询
    queries = [
        "Minimax H3 ComfyUI new update release August 2026",
        "ComfyUI-H3-Multishot new version",
        "Minimax H3 Director workflow improvements"
    ]

    all_results = []
    for query in queries:
        results = search_tavily(api_key, query)
        for r in results:
            all_results.append({
                "Query": query,
                "Title": r.get("title", ""),
                "URL": r.get("url", ""),
                "Content": r.get("content", ""),
                "Date": timestamp
            })

    # 生成 Markdown 报告
    report = f"# 🔍 Minimax H3 Auto News Report\n\n"
    report += f"**最后更新**: {timestamp}\n"
    report += f"**搜索范围**: GitHub, Reddit, Forum\n"
    report += f"**使用 Key**: #{key_num}\n\n---\n\n"

    for result in all_results[:10]:
        report += f"## 📌 {result['Title']}\n\n"
        report += f"- **来源**: [{result['URL']}]({result['URL']})\n"
        report += f"- **查询关键词**: {result['Query']}\n"
        report += f"- **摘要**: {result['Content'][:300]}\n\n---\n\n"

    with open(report_file, 'w', encoding='utf-8') as f:
        f.write(report)

    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(f"[{timestamp}] Report generated\n")

    # 发送飞书通知
    if all_results:
        feishu_msg = f"📊 **Minimax H3 自动扫描报告**\n\n"
        feishu_msg += f"🔍 找到 {len(all_results)} 条最新更新\n\n"
        for result in all_results[:5]:
            feishu_msg += f"📌 **{result['Title']}**\n"
            feishu_msg += f"🔗 {result['URL']}\n\n"
        feishu_msg += f"📂 完整报告已自动同步到 GitHub 分支\n"
        feishu_msg += f"🔗 https://github.com/DeanChen85/minimax-h3-drama-pipeline/blob/feature/spectrum-acceleration/latest_news.md"

        send_feishu(feishu_msg, "📰 Minimax H3 最新动态")

        with open(log_file, 'a', encoding='utf-8') as f:
            f.write(f"[{timestamp}] Feishu notification sent\n")

    # Git 提交推送
    git_commit_and_push()

    print(f"[{timestamp}] Cycle complete.")

if __name__ == "__main__":
    main()