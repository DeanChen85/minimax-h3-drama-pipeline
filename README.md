# 🎬 Minimax H3 自动化短剧视频生成系统

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ComfyUI](https://img.shields.io/badge/ComfyUI-0.34.0-blue)](https://github.com/comfyanonymous/ComfyUI)
[![RTX 3090](https://img.shields.io/badge/GPU-RTX%203090%2024GB-green)](https://www.nvidia.com/geforce/graphics-cards/30-series/rtx-3090/)
[![Minimax H3](https://img.shields.io/badge/Model-MiniMax%20H3-orange)](https://github.com/MiniMax-AI/MiniMax-H3)

> **云端LLM API + 本地Minimax H3 = 高效短剧视频自动化管道**

这是一个基于 **ComfyUI** 和 **Minimax H3** 模型的完整短剧视频生成系统，结合云端大语言模型（LLM）的创意能力和本地GPU的视频渲染能力，实现从剧本到成片的自动化生产流程。

## ✨ 核心特性

- 🤖 **双引擎架构**: 云端LLM负责创意和剧本，本地RTX 3090负责视频渲染
- ⚡ **5倍加速**: 通过Turbo LoRA + SageAttention实现极速生成
- 🎵 **音频同步**: 内置T8音频模型，自动生成配音和音效
- 📦 **50+工作流**: 涵盖T2V、I2V、R2V等多种场景
- 🔍 **自动监控**: Tavily API每日2次检查最新模型和优化方案
- 💡 **持续优化**: 基于RTX 3090的详细性能调优指南

## 🚀 快速开始

### 系统要求

- **GPU**: NVIDIA RTX 3090 (24GB VRAM)
- **CPU**: Intel Xeon或同等性能处理器
- **内存**: 64GB RAM 
- **存储**: 500GB可用空间 (模型文件约200GB)
- **系统**: Windows 10/11 或 Linux
- **Python**: 3.10+
- **ComfyUI**: 0.33.2+ (建议升级到0.34.0)

### 一键安装

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/minimax-h3-drama-pipeline.git
cd minimax-h3-drama-pipeline

# 2. 运行环境设置脚本 (Windows)
.\scripts\setup_environment.ps1

# 3. 启动ComfyUI
cd ComfyUI
python main.py --disable-pinned-memory --fp16-intermediates
```

详细安装步骤请查看 [INSTALLATION.md](docs/INSTALLATION.md)

## 📁 项目结构

```
minimax-h3-drama-pipeline/
├── README.md                    # 项目说明（本文件）
├── LICENSE                      # MIT许可证
├── .gitignore                   # Git忽略规则
│
├── docs/                        # 详细文档
│   ├── INSTALLATION.md         # 安装指南
│   ├── CONFIGURATION.md        # 配置说明
│   ├── OPTIMIZATION.md         # RTX 3090优化指南
│   ├── WORKFLOWS.md            # 工作流详解
│   └── TROUBLESHOOTING.md      # 故障排除
│
├── workflows/                   # 核心工作流
│   ├── t2v_turbo.json          # Text-to-Video (Turbo加速)
│   ├── i2v_turbo.json          # Image-to-Video
│   ├── r2v_turbo.json          # Reference-to-Video
│   ├── drama_pipeline.json     # 完整短剧管道
│   └── audio_sync.json         # 音频同步工作流
│
├── scripts/                     # 自动化脚本
│   ├── setup_environment.ps1   # 环境设置
│   ├── check_config.ps1        # 配置检查
│   ├── monitor_updates.ps1     # 更新监控
│   └── batch_generate.ps1      # 批量生成
│
├── examples/                    # 示例
│   ├── prompts/                # 示例提示词
│   ├── input_images/           # 示例输入图片
│   └── output_videos/          # 示例输出视频
│
└── assets/                      # 媒体资源
    ├── screenshots/            # 截图
    ├── diagrams/               # 架构图
    └── demo_video.mp4          # 演示视频
```

## 🎯 核心工作流

### 1. Text-to-Video (T2V)
从文本提示直接生成视频，支持4步Turbo加速

### 2. Image-to-Video (I2V)
将静态图片转换为动态视频

### 3. Reference-to-Video (R2V)
使用参考图像和视频生成新内容

### 4. 完整短剧管道
从剧本→分镜→角色设计→视频生成→音频合成的全流程

## ⚡ 性能优化

针对 **RTX 3090 (24GB)** 的优化方案：

| 优化项 | 效果 | 说明 |
|--------|------|------|
| Turbo LoRA (4步) | 5x速度 | 几乎无损质量 |
| SageAttention | +20%速度 | bf16 kernel加速 |
| FP8量化模型 | 节省40%显存 | 轻微质量损失 |
| VAE缓存 | +15%速度 | 长视频更有效 |

详细优化指南请查看 [OPTIMIZATION.md](docs/OPTIMIZATION.md)

## 📊 系统架构

```
┌─────────────────┐
│   云端 LLM API   │  ← 创意生成、剧本编写、提示词优化
│  (Claude/GPT等)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ComfyUI 工作流  │  ← 任务编排、节点连接
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Minimax H3 模型 │  ← 本地视频渲染 (RTX 3090)
│   (24GB VRAM)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   输出视频文件   │  ← MP4格式，含音频
└─────────────────┘
```

## 🔧 已安装组件

### 自定义节点 (7个)
- ✅ ComfyUI_RH_MinMaxH3
- ✅ ComfyUI-MiniMax-H3-Turbo
- ✅ ComfyUI_MiniMaxH3_Director
- ✅ comfyui-minimax-h3-audio-T8
- ✅ ComfyUI-ClipProj
- ✅ ComfyUI-H3-Motion-Context
- ✅ ComfyUI-H3-Multishot

### 模型文件 (15个)
- **扩散模型**: 5个 (FP8, INT8, INT4量化版本)
- **LoRA模型**: 8个 (包含最新Turbo 4步和8步版本)
- **VAE模型**: 2个 (视频+音频)

## 📖 文档导航

- 📘 [安装指南](docs/INSTALLATION.md) - 从零开始的详细安装步骤
- ⚙️ [配置说明](docs/CONFIGURATION.md) - 系统配置和参数调整
- 🚀 [优化指南](docs/OPTIMIZATION.md) - RTX 3090性能优化
- 🎬 [工作流详解](docs/WORKFLOWS.md) - 所有工作流的使用说明
- 🔧 [故障排除](docs/TROUBLESHOOTING.md) - 常见问题和解决方案
- 📝 [更新日志](docs/CHANGELOG.md) - 版本更新记录

## 🎥 演示

### 示例输出

| 类型 | 分辨率 | 时长 | 生成时间 |
|------|--------|------|----------|
| T2V (Turbo) | 768p | 5秒 | 1.5-2分钟 |
| I2V (Turbo) | 768p | 5秒 | 2-3分钟 |
| R2V (标准) | 480p | 10秒 | 8-10分钟 |

*[此处插入演示视频或GIF]*

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

1. Fork本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

详见 [CONTRIBUTING.md](docs/CONTRIBUTING.md)

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- **ComfyUI团队** - 提供强大的节点式工作流引擎
- **MiniMax官方** - 开源高质量的H3视频模型
- **社区贡献者** - Larryvrh, AIMixer, Kijai等节点的开发者
- **Reddit r/ComfyUI** - 活跃的社区讨论和支持

## 📞 联系方式

- **GitHub Issues**: 报告问题或提出建议
- **Discord**: [加入社区](https://discord.gg/comfyui)
- **Reddit**: r/ComfyUI, r/StableDiffusion

---

**最后更新**: 2026-08-29  
**维护者**: Dean Chen
**状态**: 🟢 活跃开发中

> 💡 **提示**: 本项目仍在快速发展中，欢迎star关注最新动态！
