# 🚀 RTX 3090 性能优化指南

本指南专门针对 **NVIDIA RTX 3090 (24GB VRAM)** 配置，提供经过实战验证的性能优化方案。

**最新更新 (2026-08-29)**:
*   **ComfyUI v0.34.0**: 官方已发布最新版本，包含 Minimax H3 原生性能改进，强烈建议升级。
*   **Spectrum MiniMax H3 (v0.2.20)**: 最新的社区加速节点，通过频谱特征预测跳过部分 Transformer 层，实测可提升约 30% 生成速度。

## 📊 基准性能

### 标准配置（无优化）
| 分辨率 | 步骤数 | 生成时间 | VRAM使用 |
|--------|--------|----------|----------|
| 480p | 20步 | 8-10分钟 | 20GB |
| 768p | 20步 | 15-20分钟 | 22GB |
| 1080p | 20步 | 25-30分钟 | OOM |

### 优化后配置
| 分辨率 | 步骤数 | 生成时间 | 提升倍数 | VRAM使用 |
|--------|--------|----------|----------|----------|
| 480p | 4步 (Turbo) | 1.5-2分钟 | **5x** | 16GB |
| 768p | 4步 (Turbo) | 3-5分钟 | **4x** | 18GB |
| 768p | 8步 (Turbo) | 5-8分钟 | **2.5x** | 20GB |

## ⚡ 核心优化方案

### 1. Turbo LoRA加速（最重要！）⭐⭐⭐⭐⭐

**效果**: 5倍速度提升，几乎无损质量

**安装**:
```bash
cd ComfyUI/custom_nodes
git clone https://github.com/Larryvrh/ComfyUI-MiniMax-H3-Turbo.git
```

**使用方法**:
1. 加载Turbo工作流: `workflows/t2v_turbo.json`
2. 选择LoRA: `minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors`
3. 设置步骤数为 **4步**
4. CFG值设为 **1.0-1.5**

**可用Turbo LoRA版本**:
- ✅ `minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors` (1.82GB) - **推荐**
- ✅ `minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors` (1.82GB) - 质量更好
- ✅ `minimax_h3_turbo_4step_ema_ckpt850_pruned_comfyui.safetensors` (0.58GB) - 体积小

### 2. SageAttention加速 ⭐⭐⭐⭐⭐

**效果**: 额外15-20%速度提升，无质量损失

**安装**:
```bash
pip install sageattention
```

**启用方法**:

**方法A**: 启动参数
```bash
python main.py --use-sage-attention
```

**方法B**: 在工作流中添加节点
- 在UNETLoader和BasicGuider之间插入 "Patch Sage Attention KJ" 节点
- 设置 `sage_attention` 为 `auto`

**RTX 3090兼容性**: ✅ 完美支持（24GB VRAM足够）

### 3. 模型量化 ⭐⭐⭐⭐

**效果**: 节省40-60%显存，轻微质量损失

**推荐量化版本**:

| 模型 | 原始大小 | 量化后 | 显存节省 | 质量损失 |
|------|----------|--------|----------|----------|
| FP16 | ~40GB | - | - | 无 |
| **FP8** | **~20GB** | **19.52GB** | **40%** | **轻微** |
| INT8 | ~20GB | 19.53GB | 40% | 轻微 |
| INT4 | ~10GB | 10.56GB | 60% | 中等 |

**推荐使用**: `minimax_h3_fl2va_pruned_fp8_scaled.safetensors` (19.52GB)

### 4. VAE缓存优化 ⭐⭐⭐

**效果**: 长视频（>100帧）额外15-25%加速

**启用方法**:
1. 安装EasyCache节点
2. 在4步Turbo模式下有效
3. 注意：与Spectrum节点冲突，二选一

### 5. 启动参数优化 ⭐⭐⭐⭐⭐

**RTX 3090专用参数**:

```bash
python main.py \
  --disable-pinned-memory \      # 必需！启用CPU卸载
  --fp16-intermediates \         # 减少激活内存
  --force-fp16 \                 # 强制FP16计算
  --use-split-cross-attention    # 分割交叉注意力
```

**重要说明**:
- ❌ **不要使用** `--lowvram` 参数（会与 `--disable-pinned-memory` 冲突）
- ✅ `--disable-pinned-memory` 让ComfyUI知道H3占用全部VRAM，触发CPU卸载

## 🔧 高级优化技巧

### 1. VRAM管理

**监控VRAM使用**:
```powershell
# PowerShell命令
nvidia-smi dmon -s pum
```

**优化策略**:
- 关闭浏览器和其他GPU应用
- 使用任务管理器监控VRAM
- 生成前清理缓存: `ComfyUI/temp/` 目录

### 2. 批量生成优化

**使用批处理脚本**:
```powershell
.\scripts\batch_generate.ps1 -prompts prompts.txt -resolution 768p -steps 4
```

**优势**:
- 自动队列管理
- VRAM自动释放
- 错误恢复机制

### 3. 音频同步优化

**T8音频模型配置**:
```yaml
音频VAE: minimax_h3_audio_vae_fp32.safetensors
音频步骤: 4步（与视频同步）
采样率: 44100 Hz
格式: Stereo
```

**工作流**: `examples/workflows/H3_Turbo_Stable_4V4A.json`

## 📈 性能对比测试

### 测试环境
- GPU: NVIDIA RTX 3090 (24GB)
- CPU: Intel Xeon W-2235
- RAM: 64GB
- 分辨率: 768p (1344x768)
- 时长: 5秒

### 测试结果

| 配置 | 时间 | VRAM峰值 | 质量评分 |
|------|------|----------|----------|
| 标准20步 | 18分钟 | 22GB | 10/10 |
| Turbo 8步 | 7分钟 | 20GB | 9.5/10 |
| **Turbo 4步** | **3.5分钟** | **18GB** | **9/10** |
| Turbo 4步 + Sage | **2.8分钟** | **18GB** | **9/10** |
| Turbo 4步 + Sage + FP8 | **2.5分钟** | **14GB** | **8.5/10** |

## 💡 最佳实践建议

### 日常使用推荐配置

```yaml
模型: minimax_h3_fl2va_pruned_fp8_scaled.safetensors
LoRA: minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors
步骤: 4步
分辨率: 768p (1344x768)
CFG: 1.2
采样器: Euler a
加速: SageAttention + Sol-Attn
预期时间: 2.5-3分钟 (5秒视频)
```

### 高质量模式

```yaml
模型: minimax_h3_fl2va_pruned_fp8_scaled.safetensors
LoRA: minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors
步骤: 8步
分辨率: 768p
CFG: 2.0
采样器: DPM++ 2M Karras
加速: SageAttention only
预期时间: 5-7分钟 (5秒视频)
```

### 极速模式

```yaml
模型: minimax_h3_fl2va_pruned_int4_convrot.safetensors
LoRA: minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors
步骤: 4步
分辨率: 480p (864x480)
CFG: 1.0
采样器: Euler
加速: Turbo + EasyCache + Sol-Attn
预期时间: <2分钟 (5秒视频)
```

## ⚠️ 注意事项

### Do's ✅
- ✅ 始终使用 `--disable-pinned-memory` 参数
- ✅ 定期更新Turbo LoRA到最新版本
- ✅ 监控VRAM使用情况
- ✅ 生成前关闭不必要的程序
- ✅ 使用FP8或INT8量化模型节省显存

### Don'ts ❌
- ❌ 不要同时运行多个生成任务
- ❌ 不要在20步模式下使用EasyCache
- ❌ 不要使用 `--lowvram` 参数
- ❌ 不要忽略温度监控（保持GPU <80°C）
- ❌ 不要在生成过程中切换工作流

## 🔍 故障排除

### 问题1: OOM (Out of Memory)

**解决方案**:
1. 检查是否使用了 `--disable-pinned-memory`
2. 切换到INT4量化模型
3. 降低分辨率到480p
4. 减少批次大小

### 问题2: 生成速度慢

**解决方案**:
1. 确认已安装Turbo LoRA
2. 检查步骤数是否为4或8
3. 启用SageAttention
4. 使用FP8量化模型

### 问题3: 质量下降明显

**解决方案**:
1. 从INT4升级到FP8或INT8
2. 从4步升级到8步Turbo
3. 提高CFG值到1.5-2.0
4. 使用更高质量的LoRA版本

---

**参考资源**:
- [GitHub: tonyd2wild/minimax-h3-local](https://github.com/tonyd2wild/minimax-h3-local)
- [GitHub: alesha-pro/tools](https://github.com/alesha-pro/tools)
- [Reddit: RTX 3090性能讨论](https://www.reddit.com/r/comfyui/comments/1vi7yxw/)

**最后更新**: 2026-08-29
