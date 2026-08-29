# ⚙️ 配置说明

本文档详细说明系统的各项配置选项。

## 🎯 核心配置文件

### 1. ComfyUI启动配置

**文件位置**: `ComfyUI/main.py` 或启动脚本

**关键参数**:

```bash
python main.py \
  --port 8188 \                    # Web界面端口
  --listen 127.0.0.1 \             # 监听地址
  --disable-pinned-memory \        # RTX 3090必需！
  --fp16-intermediates \           # 减少内存使用
  --force-fp16 \                   # 强制FP16计算
  --use-split-cross-attention      # 优化注意力机制
```

**参数说明**:

| 参数 | 作用 | 推荐值 |
|------|------|--------|
| `--disable-pinned-memory` | 启用CPU卸载 | ✅ 必需(RTX 3090) |
| `--fp16-intermediates` | FP16中间激活 | ✅ 推荐 |
| `--lowvram` | 低显存模式 | ❌ 不要使用(冲突) |
| `--medvram` | 中等显存模式 | ⚠️ 可选 |
| `--highvram` | 高显存模式 | ❌ 不要使用 |

### 2. 环境变量配置

**文件位置**: `.env` (根目录)

```env
# Tavily API Keys (用于自动监控)
TAVILY_API_KEY_1=tvly-dev-xxxxx
TAVILY_API_KEY_2=tvly-dev-xxxxx
TAVILY_API_KEY_3=tvly-dev-xxxxx
TAVILY_API_KEY_4=tvly-dev-xxxxx
TAVILY_API_KEY_5=tvly-dev-xxxxx

# LLM API Keys (可选)
OPENAI_API_KEY=sk-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
GOOGLE_API_KEY=xxxxx

# ComfyUI配置
COMFYUI_PORT=8188
COMFYUI_HOST=127.0.0.1
```

### 3. 模型路径配置

**默认路径结构**:
```
ComfyUI/models/
├── diffusion_models/     # Minimax H3主模型
│   ├── minimax_h3_fl2va_pruned_fp8_scaled.safetensors
│   └── ...
├── loras/                # LoRA模型
│   ├── minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors
│   └── ...
├── vae/                  # VAE模型
│   ├── minimax_h3_video_vae_fp16.safetensors
│   └── minimax_h3_audio_vae_fp32.safetensors
└── checkpoints/          # 传统检查点（不使用）
```

## 🔧 工作流配置

### T2V工作流参数

```json
{
  "nodes": {
    "CLIPTextEncode": {
      "inputs": {
        "text": "A beautiful sunset over the ocean",
        "clip": ["CLIP", 0]
      }
    },
    "KSampler": {
      "inputs": {
        "seed": -1,
        "steps": 4,
        "cfg": 1.2,
        "sampler_name": "euler",
        "scheduler": "normal",
        "denoise": 1.0
      }
    },
    "MiniMaxH3TurboLoRA": {
      "inputs": {
        "lora_name": "minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors",
        "strength_model": 1.0,
        "low_vram": false
      }
    }
  }
}
```

### 关键参数说明

| 参数 | 范围 | 推荐值 | 说明 |
|------|------|--------|------|
| **steps** | 1-50 | 4 (Turbo) / 20 (标准) | 步数越多质量越好 |
| **cfg** | 0.5-20 | 1.0-1.5 (Turbo) / 2.0 (标准) | 提示词遵循度 |
| **seed** | -1或正整数 | -1 (随机) | -1每次不同 |
| **denoise** | 0.0-1.0 | 1.0 | 去噪强度 |
| **resolution** | - | 768p (1344x768) | 推荐平衡点 |

## 🎨 提示词配置

### 系统提示词模板

**文件位置**: `examples/prompts/system_prompts.txt`

```
You are an AI video director. Create detailed video prompts for MiniMax H3.

Format:
[Subject], [Action/Motion], [Environment], [Lighting], [Style], [Technical specs]

Examples:
- A young woman with flowing hair, walking slowly through cherry blossoms, 
  spring garden, soft natural light, cinematic, 4k quality
- Majestic eagle soaring above mountains, wings spread wide, alpine landscape, 
  golden hour, epic composition, ultra detailed
```

### 提示词优化技巧

1. **具体化**: 避免模糊描述
   - ❌ "a nice scene"
   - ✅ "a serene lake at sunrise with mist"

2. **结构化**: 按层次描述
   ```
   主体 + 动作 + 环境 + 光线 + 风格 + 技术参数
   ```

3. **控制运动**: 明确想要的动作
   - ✅ "slowly rotating"
   - ✅ "gentle waving"
   - ❌ "moving" (太模糊)

## 📊 性能配置

### VRAM管理

**RTX 3090 (24GB) 推荐配置**:

```yaml
模型选择:
  - FP8量化: 19.52GB, 质量9/10
  - INT8量化: 19.53GB, 质量8.5/10
  - INT4量化: 10.56GB, 质量7/10

启动参数:
  - --disable-pinned-memory: 必需
  - --fp16-intermediates: 推荐
  - --force-fp16: 可选

运行时:
  - 关闭浏览器标签页
  - 监控VRAM: nvidia-smi dmon
  - 清理缓存: ComfyUI/temp/
```

### 批处理配置

**文件位置**: `scripts/batch_config.json`

```json
{
  "batch_size": 5,
  "resolution": "768p",
  "steps": 4,
  "cfg": 1.2,
  "output_format": "mp4",
  "parallel_jobs": 1,
  "auto_cleanup": true,
  "error_recovery": true
}
```

## 🔌 API集成配置

### LLM API配置

**OpenAI**:
```python
import openai

openai.api_key = "sk-xxxxx"
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": prompt}]
)
```

**Anthropic Claude**:
```python
import anthropic

client = anthropic.Anthropic(api_key="sk-ant-xxxxx")
response = client.messages.create(
    model="claude-3-opus",
    max_tokens=1000,
    messages=[{"role": "user", "content": prompt}]
)
```

### ComfyUI API

**发送工作流**:
```python
import requests
import json

with open('workflows/t2v_turbo.json', 'r') as f:
    workflow = json.load(f)

# 修改参数
workflow['nodes']['KSampler']['inputs']['steps'] = 4

# 发送到ComfyUI
response = requests.post(
    'http://127.0.0.1:8188/prompt',
    json={"prompt": workflow}
)
```

## 🔄 自动更新配置

### Tavily API轮换

**文件位置**: `get_tavily_key.ps1`

```powershell
$apiKeys = @(
    "tvly-dev-key1",
    "tvly-dev-key2",
    "tvly-dev-key3",
    "tvly-dev-key4",
    "tvly-dev-key5"
)

# 自动轮换逻辑
$currentIndex = Get-Content tavily_key_index.txt
$nextIndex = ($currentIndex + 1) % $apiKeys.Count
```

### 定时任务配置

**Windows Task Scheduler**:
```powershell
# 创建每日两次检查任务
.\setup_minimax_h3_scheduler.ps1

# 执行时间: 9:00 AM 和 9:00 PM
```

## 🛡️ 安全配置

### API密钥管理

**不要硬编码密钥**:
```python
# ❌ 错误做法
api_key = "sk-xxxxx"

# ✅ 正确做法
import os
api_key = os.getenv('OPENAI_API_KEY')
```

### .gitignore配置

确保敏感文件不被上传:
```gitignore
.env
*.key
*.secret
tavily_key_index.txt
```

## 📝 配置检查清单

部署前确认:

- [ ] ComfyUI版本 >= 0.33.2
- [ ] 已添加 `--disable-pinned-memory` 参数
- [ ] 模型文件完整且路径正确
- [ ] 自定义节点已安装
- [ ] 环境变量已配置
- [ ] API密钥安全存储
- [ ] VRAM监控工具就绪
- [ ] 备份策略已设置

---

**最后更新**: 2026-08-29  
**维护者**: [Your Name]

> 💡 **提示**: 定期检查和更新配置以保持最佳性能！
