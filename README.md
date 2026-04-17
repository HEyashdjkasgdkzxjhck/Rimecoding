# RimeCoding 输入法词库

🤖 自动化构建 | 📚 持续更新 | 🌏 开源共享

一个用于 Rime 输入法的中英文自动翻译词库，支持输入中文自动转换为对应的英文术语。

## 词库规模

- **总词条数**: 9655+
- **分类词库**: UE Blueprint (7000+) / 通用 CS / 机器学习 / 日常词汇

## 功能特点

- **Tab 键翻译**: 输入中文后按 Tab 键自动转换为英文
- **智能提示**: 自动显示英文候选词
- **持续更新**: 社区驱动的词库扩充

## 支持领域

- 🎮 Unreal Engine 蓝图开发
- 🤖 机器学习 / 深度学习
- 💻 编程术语
- 📝 通用计算机词汇

## 快速开始

### 1. 安装 Rime

推荐使用 [小狼毫 Weasel](https://github.com/rime/weasel) 或其他 Rime 引擎发行版

### 2. 下载词库

```bash
git clone https://github.com/yourusername/rimecoding.git
```

### 3. 部署

复制以下文件到 Rime 配置目录：

- `rimecoding.schema.yaml` → schema 文件
- `rimecoding_dict.lua` → 词典文件
- `rimecoding_processor.lua` → 处理器
- `rimecoding_translator.lua` → 翻译器

Windows 配置目录: `%APPDATA%\Rime\`
macOS: `~/Library/Rime/`
Linux: `~/.config/ibus/rime/` 或 `~/.rime/`

### 4. 重新部署

右键点击输入法图标 → 重新部署

## 使用方法

1. 输入中文（如 `蓝图`）
2. 按 **Tab** 键翻译为英文（`Blueprint`）
3. 或等待自动出现英文候选词

## 贡献词条

我们欢迎社区贡献！

### 贡献方式

#### 方式一: 提交 Issue
在 [GitHub Issues](https://github.com/yourusername/rimecoding/issues) 中报告缺失的词条

#### 方式二: 提交 Pull Request

1. Fork 本仓库
2. 编辑 `lua/rimecoding.lua` 文件
3. 提交 PR

### 词条格式

```lua
["中文"] = "English",
```

### 常用缩写

| 中文 | 英文 |
|------|------|
| 获取 | Get |
| 设置 | Set |
| 创建 | Create |
| 销毁 | Destroy |
| 添加 | Add |
| 移除 | Remove |
| 组件 | Component |
| Actor | Actor |
| 变换 | Transform |
| 位置 | Location |
| 旋转 | Rotation |
| 缩放 | Scale |
| 碰撞 | Collision |

## 词库结构

```
rimecoding/
├── lua/
│   └── rimecoding.lua      # 主词库文件
├── schema/
│   └── rimecoding.schema.yaml
├── script/
│   ├── merge_dicts.py      # 词库合并脚本
│   └── ue_dict_generator.py # UE 词库生成器
├── README.md
└── CONTRIBUTING.md
```

## 开发

### 生成 UE 词库

```bash
python script/ue_dict_generator.py
```

### 合并词库

```bash
python script/merge_dicts.py
```

## License

MIT License

## 致谢

- [Rime 输入法](https://rime.im/) - 强大的开源输入法引擎
- [Unreal Engine 文档](https://docs.unrealengine.com/) - UE API 参考
