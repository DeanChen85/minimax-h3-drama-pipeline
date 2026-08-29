# 🤝 贡献指南

感谢你对Minimax H3短剧视频生成系统的兴趣！我们欢迎所有形式的贡献。

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [提交Issue](#提交issue)
- [提交Pull Request](#提交pull-request)
- [开发环境设置](#开发环境设置)
- [代码规范](#代码规范)
- [文档规范](#文档规范)

## 行为准则

本项目采用开放和包容的态度，请：

- ✅ 尊重所有参与者
- ✅ 提供建设性反馈
- ✅ 关注技术讨论
- ❌ 避免人身攻击
- ❌ 不要发布无关内容

## 如何贡献

### 1. 报告Bug

如果你发现了bug：

1. 搜索现有Issues，确认是否已报告
2. 如果没有，创建新Issue
3. 包含以下信息：
   - 系统配置（GPU、内存、ComfyUI版本）
   - 复现步骤
   - 错误日志
   - 截图（如有）

**Issue模板**:
```markdown
**Bug描述**
简要描述问题

**环境信息**
- GPU: RTX 3090
- ComfyUI版本: 0.33.2
- Python版本: 3.10

**复现步骤**
1. ...
2. ...
3. ...

**预期行为**
...

**实际行为**
...

**日志**
```
[粘贴相关日志]
```
```

### 2. 提出新功能建议

我们欢迎新功能建议！请：

1. 先搜索现有Issues
2. 描述功能需求和应用场景
3. 说明为什么这个功能有价值
4. 如果可能，提供实现思路

### 3. 改进文档

文档永远可以更好！你可以：

- 修正拼写或语法错误
- 添加缺失的说明
- 改进示例
- 翻译文档
- 添加截图或图表

### 4. 提交代码

#### 小型修复（拼写错误、小bug）

直接提交Pull Request即可。

#### 大型改动（新功能、重构）

1. 先创建Issue讨论
2. 获得维护者同意后开始开发
3. 遵循代码规范
4. 添加测试（如适用）
5. 更新文档

## 提交Pull Request

### PR检查清单

在提交PR前，请确认：

- [ ] 代码符合项目规范
- [ ] 添加了必要的测试
- [ ] 更新了相关文档
- [ ] PR描述清晰说明了改动内容
- [ ] 关联了相关Issue（如有）

### PR流程

1. Fork本仓库
2. 创建功能分支
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. 提交更改
   ```bash
   git commit -m "Add amazing feature"
   ```
4. 推送到分支
   ```bash
   git push origin feature/amazing-feature
   ```
5. 创建Pull Request

### PR描述模板

```markdown
## 描述
简要说明这个PR做了什么

## 相关Issue
Fixes #123

## 改动类型
- [ ] Bug修复
- [ ] 新功能
- [ ] 文档改进
- [ ] 性能优化
- [ ] 其他

## 测试
说明如何测试这些改动

## 截图（如适用）
[添加截图]

## 检查清单
- [ ] 代码符合规范
- [ ] 添加了测试
- [ ] 更新了文档
- [ ] 没有破坏性改动
```

## 开发环境设置

### 1. 克隆仓库

```bash
git clone https://github.com/YOUR_USERNAME/minimax-h3-drama-pipeline.git
cd minimax-h3-drama-pipeline
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 设置预提交钩子（可选）

```bash
pip install pre-commit
pre-commit install
```

## 代码规范

### Python代码

- 遵循PEP 8规范
- 使用4空格缩进
- 函数和类添加docstring
- 变量命名使用snake_case
- 常量使用UPPER_CASE

**示例**:
```python
def generate_video(prompt: str, steps: int = 4) -> dict:
    """
    Generate video from text prompt using Minimax H3.
    
    Args:
        prompt: Text description of the video
        steps: Number of denoising steps (default: 4 for Turbo)
    
    Returns:
        Dictionary containing video path and metadata
    """
    # Implementation here
    pass
```

### PowerShell脚本

- 使用动词-名词命名函数
- 添加注释说明
- 处理错误情况
- 提供参数验证

**示例**:
```powershell
function Test-Configuration {
    <#
    .SYNOPSIS
    Check if system meets requirements
    
    .DESCRIPTION
    Validates GPU, VRAM, and software versions
    #>
    
    param(
        [switch]$Detailed
    )
    
    # Implementation
}
```

### Markdown文档

- 使用清晰的标题层级
- 代码块指定语言
- 链接使用相对路径
- 添加适当的emoji增强可读性

## 文档规范

### 文档结构

每个文档应包含：

1. **标题**: 清晰说明文档主题
2. **简介**: 简要说明文档目的
3. **目录**: 长文档需要目录
4. **正文**: 分章节详细说明
5. **示例**: 提供实际例子
6. **参考**: 相关链接和资源

### 写作风格

- 使用简洁明了的语言
- 避免行话，或解释术语
- 使用主动语态
- 提供具体步骤
- 包含截图或图表（如需要）

### 多语言支持

我们欢迎翻译贡献！

- 中文文档放在 `docs/zh-CN/`
- 英文文档放在 `docs/en/`
- 保持同步更新

## 🎯 优先贡献领域

目前特别需要的贡献：

1. **工作流优化**
   - 新的创意工作流
   - 性能改进
   - 质量提升技巧

2. **文档完善**
   - 更多示例
   - 视频教程脚本
   - 常见问题解答

3. **自动化脚本**
   - 批量处理工具
   - 监控脚本
   - 部署工具

4. **集成方案**
   - 与其他工具的集成
   - API封装
   - Web UI前端

## 📞 联系方式

- **GitHub Issues**: 技术问题和建议
- **Discord**: https://discord.gg/comfyui
- **Email**: [your-email@example.com]

## 🙏 致谢

感谢所有贡献者的努力！你的每一次贡献都让这个项目变得更好。

---

**最后更新**: 2026-08-29  
**维护者**: [Your Name]
