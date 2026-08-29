# 🎬 工作流详解

本文档详细介绍所有可用的工作流及其使用方法。

## 📋 工作流清单

### 核心工作流（推荐新手从这些开始）

| 工作流 | 文件 | 用途 | 难度 |
|--------|------|------|------|
| T2V Turbo | `t2v_turbo.json` | 文本生成视频（加速版） | ⭐ |
| I2V Turbo | `i2v_turbo.json` | 图片生成视频（加速版） | ⭐⭐ |
| R2V Turbo | `r2v_turbo.json` | 参考生成视频（加速版） | ⭐⭐⭐ |
| 完整短剧管道 | `drama_pipeline.json` | 从剧本到成片 | ⭐⭐⭐⭐⭐ |

### 高级工作流

| 工作流 | 文件 | 用途 | 特性 |
|--------|------|------|------|
| 音频同步 | `audio_sync.json` | 视频+配音 | T8音频模型 |
| 多镜头 | `multishot.json` | 多场景串联 | H3-Multishot节点 |
| 运动控制 | `motion_control.json` | 精确运动控制 | Motion Context节点 |
| 高清放大 | `upscale.json` | 视频超分辨率 | 4倍放大 |

## 🔰 快速开始

### 1. Text-to-Video (T2V)

**适用场景**: 从文字描述直接生成视频

**步骤**:
1. 加载工作流: `workflows/t2v_turbo.json`
2. 在 "CLIP Text Encode" 节点输入提示词
3. 设置参数:
   - Steps: 4 (Turbo模式)
   - CFG: 1.2
   - Resolution: 768p
4. 点击 "Queue Prompt"

**示例提示词**:
```
A beautiful sunset over the ocean, waves crashing on the shore, 
cinematic lighting, 4k quality, peaceful atmosphere
```

**预期输出**: 5秒768p视频，生成时间2.5-3分钟

### 2. Image-to-Video (I2V)

**适用场景**: 让静态图片动起来

**步骤**:
1. 加载工作流: `workflows/i2v_turbo.json`
2. 使用 "Load Image" 节点上传图片
3. 添加简短的动作描述（可选）
4. 设置参数同T2V
5. 点击 "Queue Prompt"

**技巧**:
- 图片分辨率建议512x512或更高
- 动作描述要简洁明确
- 可以使用角色设定图生成动画

### 3. Reference-to-Video (R2V)

**适用场景**: 使用参考图像/视频生成新内容

**步骤**:
1. 加载工作流: `workflows/r2v_turbo.json`
2. 上传参考图像（最多9张）
3. 上传参考视频（最多3个，可选）
4. 输入提示词描述想要的变化
5. 点击 "Queue Prompt"

**应用场景**:
- 保持角色一致性
- 延续视频风格
- 基于现有素材创作

## 🎯 工作流参数说明

### 通用参数

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| **Steps** | 4 (Turbo) / 20 (标准) | 步数越多质量越好，速度越慢 |
| **CFG** | 1.0-1.5 (Turbo) / 2.0 (标准) | 提示词遵循度 |
| **Resolution** | 768p (1344x768) | 推荐平衡点 |
| **Sampler** | Euler a (Turbo) / DPM++ 2M (标准) | 采样器类型 |
| **Seed** | -1 (随机) / 固定值 | -1每次不同，固定值可复现 |

### Turbo模式专用

```yaml
Steps: 4
CFG: 1.0-1.5
LoRA: minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16
Sampler: Euler a
Quality: 9/10 (vs 标准20步)
Speed: 5x faster
```

### 标准模式

```yaml
Steps: 20
CFG: 2.0
LoRA: 无
Sampler: DPM++ 2M Karras
Quality: 10/10
Speed: 基准速度
```

## 🎨 提示词技巧

### 基本结构

```
[主体描述], [动作/场景], [风格/氛围], [技术参数]
```

### 示例

**人物场景**:
```
A young woman with long black hair, walking through a cherry blossom garden, 
petals falling around her, soft natural lighting, cinematic composition, 4k
```

**风景场景**:
```
Majestic mountain landscape at sunrise, mist covering the valleys, 
golden hour lighting, wide angle shot, ultra detailed, photorealistic
```

**抽象场景**:
```
Swirling colorful particles in dark space, neon lights, cyberpunk aesthetic, 
dynamic motion, high contrast, futuristic
```

### 负面提示词（如支持）

```
blurry, low quality, distorted, deformed, ugly, bad anatomy
```

## 🎵 音频工作流

### T8音频集成

**工作流**: `examples/workflows/H3_Turbo_Stable_4V4A.json`

**特点**:
- 同时生成视频和立体声音频
- 4步视频 + 4步音频
- 自动同步

**配置**:
```yaml
视频VAE: minimax_h3_video_vae_fp16.safetensors
音频VAE: minimax_h3_audio_vae_fp32.safetensors
视频步骤: 4
音频步骤: 4
输出格式: MP4 (H.264 + AAC)
```

## 🔄 批量生成

### 使用批处理脚本

```powershell
.\scripts\batch_generate.ps1 \
  -prompts prompts.txt \
  -resolution 768p \
  -steps 4 \
  -output_dir ./output/batch_001
```

**prompts.txt格式**:
```
A cat sitting on a windowsill
A dog running in the park
A bird flying over the ocean
```

### 高级批量选项

```powershell
.\scripts\batch_generate.ps1 \
  -prompts prompts.txt \
  -images ./input_images/ \
  -resolution 768p \
  -steps 4 \
  -cfg 1.2 \
  -seed random \
  -output_dir ./output/batch_002 \
  -parallel 2  # 并行数量（谨慎使用）
```

## 💡 最佳实践

### 1. 测试流程

1. 先用480p快速测试提示词效果
2. 满意后再用768p正式生成
3. 保存满意的seed值用于复现

### 2. 资源管理

- 生成前关闭浏览器标签页
- 定期清理 `ComfyUI/temp/` 目录
- 监控VRAM使用 (`nvidia-smi dmon`)

### 3. 质量控制

- 使用固定seed复现好结果
- 调整CFG找到最佳平衡点
- 尝试不同的采样器

### 4. 效率提升

- 创建常用提示词模板
- 使用预设分辨率
- 批量生成相似内容

## 🐛 常见问题

### Q: 生成的视频黑屏或静止？

**A**: 
1. 检查提示词是否太简单
2. 增加CFG值到1.5-2.0
3. 尝试不同的seed
4. 确保模型文件完整

### Q: 视频中有闪烁或抖动？

**A**:
1. 使用Motion Context节点稳定
2. 增加步骤数到8步
3. 降低运动幅度描述

### Q: 音频和视频不同步？

**A**:
1. 使用专门的音频同步工作流
2. 确保视频和音频步数一致
3. 检查VAE模型版本匹配

## 📚 参考资源

- [官方Minimax H3文档](https://github.com/MiniMax-AI/MiniMax-H3)
- [ComfyUI工作流库](https://comfyworkflows.com/)
- [提示词工程指南](https://github.com/1038lab/ComfyUI-MiniMax-H3-Promptor)

---

**最后更新**: 2026-08-29  
**维护者**: [Your Name]

> 💡 **提示**: 欢迎提交你的工作流改进建议！
