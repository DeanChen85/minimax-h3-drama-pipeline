# 🔧 故障排除指南

本文档列出常见问题及其解决方案。

## 📋 目录

- [安装问题](#安装问题)
- [运行时错误](#运行时错误)
- [性能问题](#性能问题)
- [质量问题](#质量问题)
- [工作流问题](#工作流问题)

## 安装问题

### Q1: Python依赖安装失败

**错误信息**:
```
ERROR: Could not find a version that satisfies the requirement torch==2.x.x
```

**解决方案**:
```bash
# 使用正确的CUDA版本
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 或指定版本
pip install torch==2.1.0+cu121 -f https://download.pytorch.org/whl/torch_stable.html
```

### Q2: Git克隆速度慢

**解决方案**:
```bash
# 使用国内镜像
git clone https://ghproxy.com/https://github.com/comfyanonymous/ComfyUI.git

# 或使用代理
git config --global http.proxy http://127.0.0.1:7890
```

### Q3: 模型下载失败

**解决方案**:
1. 检查网络连接
2. 使用HuggingFace镜像
3. 手动下载后放到正确目录

```bash
# HuggingFace镜像
export HF_ENDPOINT=https://hf-mirror.com
```

## 运行时错误

### Q1: CUDA Out of Memory (OOM)

**错误信息**:
```
RuntimeError: CUDA out of memory. Tried to allocate X GiB
```

**解决方案**:

**立即解决**:
1. 降低分辨率到480p
2. 使用INT4量化模型
3. 关闭其他GPU应用

**长期解决**:
```bash
# 添加启动参数
python main.py --disable-pinned-memory --fp16-intermediates
```

**检查VRAM使用**:
```powershell
nvidia-smi dmon -s pum
```

### Q2: 模块导入错误

**错误信息**:
```
ModuleNotFoundError: No module named 'xxx'
```

**解决方案**:
```bash
# 安装缺失模块
pip install xxx

# 或重新安装所有依赖
pip install -r requirements.txt --force-reinstall
```

### Q3: ComfyUI启动失败

**错误信息**:
```
ImportError: DLL load failed
```

**解决方案**:
1. 确认CUDA版本匹配
2. 重装PyTorch
3. 检查Visual C++ Redistributable

```bash
# 验证CUDA
nvcc --version

# 验证PyTorch CUDA支持
python -c "import torch; print(torch.cuda.is_available())"
```

## 性能问题

### Q1: 生成速度太慢

**症状**: 5秒视频需要15分钟以上

**检查清单**:
- [ ] 是否使用了Turbo LoRA？
- [ ] 步骤数是否为4或8？
- [ ] 是否启用了SageAttention？
- [ ] 模型是否为FP8或INT8量化？

**优化步骤**:
1. 切换到Turbo 4步模式
2. 安装SageAttention
3. 使用FP8模型
4. 启用VAE缓存（长视频）

**预期改进**:
- 标准20步: 15-20分钟
- Turbo 8步: 5-7分钟
- Turbo 4步: 2.5-3分钟 ← **目标**

### Q2: VRAM占用过高

**症状**: VRAM持续在22GB以上

**解决方案**:
1. 确认使用了 `--disable-pinned-memory`
2. 切换到INT8或INT4模型
3. 降低分辨率
4. 关闭浏览器和其他GPU应用

**监控命令**:
```powershell
# PowerShell
Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM

# 或使用
nvidia-smi
```

### Q3: CPU占用100%

**原因**: VRAM不足导致频繁CPU-GPU数据传输

**解决方案**:
1. 增加物理内存到64GB
2. 使用更小量化模型
3. 减少并发任务

## 质量问题

### Q1: 视频黑屏或全灰

**可能原因**:
1. 提示词太简单
2. CFG值过低
3. 模型文件损坏

**解决方案**:
```yaml
提示词: 增加细节描述
CFG: 提高到1.5-2.0
Seed: 尝试不同的seed值
模型: 重新下载模型文件
```

### Q2: 画面闪烁或抖动

**原因**: 帧间不一致

**解决方案**:
1. 使用Motion Context节点
2. 增加步骤数到8步
3. 降低运动幅度描述
4. 使用参考视频保持一致性

### Q3: 音频不同步

**症状**: 声音和口型对不上

**解决方案**:
1. 使用专门的音频同步工作流
2. 确保视频和音频步数一致（都4步或都8步）
3. 检查VAE模型版本匹配
4. 使用 `H3_Turbo_Stable_4V4A.json` 工作流

### Q4: 人物变形或解剖错误

**解决方案**:
1. 添加负面提示词（如支持）
2. 使用Reference-to-Video保持角色一致性
3. 提高CFG值
4. 尝试不同的seed

## 工作流问题

### Q1: 工作流加载失败

**错误信息**:
```
Node type 'XXX' not found
```

**解决方案**:
1. 安装缺失的自定义节点
2. 重启ComfyUI
3. 检查工作流JSON文件完整性

```bash
# 查看缺失节点
grep -o '"class_type": "[^"]*"' workflow.json | sort -u
```

### Q2: 节点连接错误

**症状**: 红色连线或错误提示

**解决方案**:
1. 检查数据类型匹配
2. 确认节点版本兼容
3. 参考示例工作流重新连接

### Q3: 输出为空或错误

**检查清单**:
- [ ] 所有必需输入已连接
- [ ] 模型路径正确
- [ ] 参数在有效范围内
- [ ] 磁盘空间充足

## 高级故障排除

### 启用详细日志

```bash
python main.py --verbose
```

### 收集诊断信息

运行诊断脚本：
```powershell
.\scripts\check_config.ps1 -detailed
```

输出包含：
- 系统配置
- GPU信息
- 已安装节点
- 模型文件列表
- VRAM状态

### 重置ComfyUI

如果问题无法解决，可以尝试重置：

```bash
# 备份工作流
cp -r ComfyUI/user worklfows_backup/

# 删除缓存
rm -rf ComfyUI/.cache
rm -rf ComfyUI/temp/*

# 重新启动
python main.py
```

## 📞 获取帮助

如果以上方法都无法解决问题：

1. **搜索现有Issues**: https://github.com/YOUR_USERNAME/minimax-h3-drama-pipeline/issues
2. **创建新Issue**: 包含详细错误信息和日志
3. **Reddit社区**: r/ComfyUI
4. **Discord**: https://discord.gg/comfyui

### Issue报告模板

```markdown
**问题描述**
[简要描述问题]

**环境信息**
- OS: Windows 11
- GPU: RTX 3090
- ComfyUI: 0.33.2
- Python: 3.10

**错误信息**
```
[粘贴完整错误日志]
```

**复现步骤**
1. ...
2. ...
3. ...

**已尝试的解决方案**
- [ ] 重启ComfyUI
- [ ] 检查模型文件
- [ ] 更新到最新版本

**截图**
[如有，添加截图]
```

---

**最后更新**: 2026-08-29  
**维护者**: [Your Name]

> 💡 **提示**: 遇到问题先查看本文档，大部分常见问题都有解决方案！
