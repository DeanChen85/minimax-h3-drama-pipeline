# 📦 安装指南

本指南将帮助你从零开始搭建Minimax H3短剧视频生成系统。

## 🎯 前置要求

### 硬件要求

| 组件 | 最低配置 | 推荐配置 | 已验证配置 |
|------|----------|----------|------------|
| **GPU** | NVIDIA RTX 3090 (24GB) | RTX 3090/4090 | ✅ RTX 3090 24GB |
| **CPU** | Intel i7 / AMD Ryzen 7 | Intel Xeon / Ryzen 9 | ✅ Xeon W-2235 |
| **内存** | 32GB RAM | 64GB RAM | ✅ 64GB |
| **存储** | 500GB SSD | 1TB NVMe SSD | ✅ 1TB SSD |

### 软件要求

- **操作系统**: Windows 10/11 (推荐) 或 Linux
- **Python**: 3.10 或更高版本
- **CUDA**: 11.8 或 12.x
- **Git**: 最新版

## 🚀 快速安装（推荐）

### 步骤1: 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/minimax-h3-drama-pipeline.git
cd minimax-h3-drama-pipeline
```

### 步骤2: 运行自动安装脚本

**Windows:**
```powershell
.\scripts\setup_environment.ps1
```

**Linux:**
```bash
chmod +x scripts/setup_environment.sh
./scripts/setup_environment.sh
```

该脚本会自动：
- ✅ 检查系统要求
- ✅ 安装Python依赖
- ✅ 下载必要的模型文件
- ✅ 配置ComfyUI环境
- ✅ 设置环境变量

### 步骤3: 启动ComfyUI

```bash
cd ComfyUI
python main.py --disable-pinned-memory --fp16-intermediates
```

> **重要**: `--disable-pinned-memory` 和 `--fp16-intermediates` 参数对RTX 3090的VRAM管理至关重要！

### 步骤4: 访问Web界面

打开浏览器访问: `http://127.0.0.1:8188`

## 📋 手动安装（高级用户）

### 1. 安装ComfyUI

```bash
# 克隆ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

# 安装依赖
pip install -r requirements.txt
```

### 2. 安装自定义节点

```bash
cd custom_nodes

# Minimax H3核心节点
git clone https://github.com/HM-RunningHub/ComfyUI_RH_MinMaxH3.git
git clone https://github.com/Larryvrh/ComfyUI-MiniMax-H3-Turbo.git
git clone https://github.com/AIMixer/ComfyUI_MiniMaxH3_Director.git
git clone https://github.com/T8mars/comfyui-minimax-h3-audio-T8.git
git clone https://github.com/your-repo/ComfyUI-ClipProj.git
git clone https://github.com/your-repo/ComfyUI-H3-Motion-Context.git
git clone https://github.com/your-repo/ComfyUI-H3-Multishot.git
```

### 3. 下载模型文件

#### 扩散模型
```bash
cd ../models/diffusion_models

# 推荐: FP8量化版本（平衡质量和速度）
# 下载地址: https://huggingface.co/MiniMax-AI/MiniMax-H3
wget [FP8模型下载链接]
```

#### LoRA模型
```bash
cd ../loras

# Turbo LoRA (4步版本)
wget [Turbo 4-step LoRA下载链接]

# Turbo LoRA (8步版本)
wget [Turbo 8-step LoRA下载链接]
```

#### VAE模型
```bash
cd ../vae

# 视频VAE
wget [Video VAE下载链接]

# 音频VAE
wget [Audio VAE下载链接]
```

### 4. 加载工作流

1. 启动ComfyUI
2. 点击菜单 "Load" → "Load Workflow"
3. 选择 `workflows/t2v_turbo.json`
4. 点击 "Queue Prompt" 测试

## ⚙️ 配置优化

### RTX 3090专用启动参数

编辑 `ComfyUI/main.py` 或在启动时添加：

```bash
python main.py \
  --disable-pinned-memory \      # 启用CPU卸载，24GB必需
  --fp16-intermediates \         # 减少激活内存
  --use-sage-attention           # 启用SageAttention（如果已安装）
```

### 环境变量设置

创建 `.env` 文件：

```env
# Tavily API Keys (用于自动监控更新)
TAVILY_API_KEY_1=tvly-dev-xxxxx
TAVILY_API_KEY_2=tvly-dev-xxxxx
TAVILY_API_KEY_3=tvly-dev-xxxxx

# LLM API Keys (可选，用于创意生成)
OPENAI_API_KEY=sk-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
```

## 🔍 验证安装

运行配置检查脚本：

```powershell
.\scripts\check_config.ps1
```

应该看到类似输出：

```
✅ ComfyUI版本: 0.33.2
✅ GPU: NVIDIA GeForce RTX 3090 (24GB)
✅ CUDA版本: 12.x
✅ 已安装节点: 7个
✅ 模型文件: 15个
✅ VRAM优化: 已启用
```

## ❓ 常见问题

### Q: 显存不足 (OOM) 怎么办？

**A**: 
1. 确保使用了 `--disable-pinned-memory` 参数
2. 使用INT8或INT4量化模型
3. 降低分辨率到480p
4. 关闭其他占用显存的程序

### Q: 生成速度慢怎么办？

**A**:
1. 使用Turbo LoRA (4步模式)
2. 安装SageAttention
3. 使用FP8量化模型
4. 启用VAE缓存

### Q: 如何更新模型？

**A**:
运行自动监控脚本：
```powershell
.\scripts\monitor_updates.ps1
```

或手动检查：
```powershell
.\check_minimax_h3_updates.ps1
```

## 📞 需要帮助？

- 查看 [故障排除指南](TROUBLESHOOTING.md)
- 提交 [GitHub Issue](https://github.com/YOUR_USERNAME/minimax-h3-drama-pipeline/issues)
- 加入 Discord 社区: https://discord.gg/comfyui

---

**下一步**: 查看 [配置说明](CONFIGURATION.md) 了解详细配置选项
