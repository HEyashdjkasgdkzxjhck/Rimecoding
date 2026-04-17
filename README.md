# RimeCoding 输入法词库

[English](README_EN.md) | 简体中文

<p align="center">
  <img src="https://img.shields.io/badge/词条数-9655+-green.svg" alt="词条数">
  <img src="https://img.shields.io/badge/UE%20Blueprint-7000+-blue.svg" alt="UE词条">
  <img src="https://img.shields.io/github/license/HEyashdjkasgdkzxjhck/Rimecoding" alt="License">
</p>

🤖 输入中文 → 按 Tab 键 → 自动转换为英文术语

## 功能特点

- **Tab 键翻译** - 输入中文后按 Tab 键即时转换为英文
- **智能提示** - 自动显示英文候选词
- **持续更新** - 社区驱动，词库不断扩充
- **多领域覆盖** - UE Blueprint / 机器学习 / 编程术语

## 词库规模

| 分类 | 词条数 |
|------|--------|
| UE Blueprint 术语 | 7000+ |
| 计算机通用词汇 | 1700+ |
| 机器学习术语 | 500+ |
| **总计** | **9655+** |

## 支持领域

<p align="center">
  🎮 Unreal Engine Blueprint &nbsp;|&nbsp; 🤖 机器学习 &nbsp;|&nbsp; 💻 编程术语
</p>

## 快速开始

### 1. 安装 Rime 引擎

推荐使用 [小狼毫 Weasel](https://github.com/rime/weasel)（Windows）或 [鼠须管](https://github.com/rime/squirrel)（macOS）

### 2. 下载词库

```bash
git clone https://github.com/HEyashdjkasgdkzxjhck/Rimecoding.git
```

### 3. 部署文件

复制以下文件到 Rime 配置目录：

| 文件 | 说明 |
|------|------|
| `lua/rimecoding.lua` | 主词库（9655+ 词条） |
| `rimecoding.schema.yaml` | 输入方案 |
| `rimecoding_translator.lua` | 翻译器 |
| `rimecoding_processor.lua` | Tab 键处理器 |

**配置文件目录：**
- Windows: `%APPDATA%\Rime\`
- macOS: `~/Library/Rime/`
- Linux: `~/.config/ibus/rime/` 或 `~/.rime/`

### 4. 重新部署

右键点击输入法图标 → **重新部署**

## 使用方法

### 输入示例

| 输入 | 按键 | 输出 |
|------|------|------|
| `lantuhui` | Tab | `Blueprint` |
| `huoqvwActor` | Tab | `GetActor` |
| `shezhiweizhi` | Tab | `SetLocation` |
| `pengzhuangjiance` | Tab | `CollisionDetection` |

### 常用 UE 术语

```
蓝图 → Blueprint
获取位置 → GetLocation
设置旋转 → SetRotation
创建组件 → CreateComponent
销毁Actor → DestroyActor
碰撞检测 → CollisionDetection
骨骼网格体 → SkeletalMesh
动画蓝图 → AnimInstance
行为树 → BehaviorTree
相机组件 → CameraComponent
```

## 贡献词条

欢迎社区贡献！🎉

### 方式一：提交 Issue

在 [Issues](https://github.com/HEyashdjkasgdkzxjhck/Rimecoding/issues) 中报告缺失的词条

### 方式二：提交 Pull Request

1. Fork 本仓库
2. 编辑 `lua/rimecoding.lua`
3. 提交 PR

### 词条格式

```lua
["中文词"] = "EnglishTerm",
```

### 贡献规范

- 每行一个词条
- 使用 UTF-8 编码
- 英文术语使用 UE 官方拼写
- 不要添加重复词条

## 项目结构

```
Rimecoding/
├── lua/
│   └── rimecoding.lua          # 主词库文件
├── README.md                    # 本文件
├── CONTRIBUTING.md              # 贡献指南
└── LICENSE                      # MIT 许可证
```

## 更新日志

### v1.7 (2026-04-17)
- 词条总数：9655+
- UE Blueprint 词库：7000+
- 基于 UE 命名规范自动生成

### v1.4 (2026-04-16)
- 词条总数：2590
- 合并 cs-dict 专业词库

## 致谢

- [Rime 输入法](https://rime.im/) - 强大的开源输入法引擎
- [Unreal Engine 文档](https://docs.unrealengine.com/) - UE API 参考

## License

MIT License - 欢迎自由使用和分享


#请我喝瓶可乐
<img width="828" height="1124" alt="image" src="https://github.com/user-attachments/assets/9fca5569-58e0-43f0-9c78-bad79b78f790" />

