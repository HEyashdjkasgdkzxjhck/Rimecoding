# 贡献指南

感谢您对 RimeCoding 词库的贡献！

## 如何贡献

### 1. 添加新词条

编辑 `lua/rimecoding.lua` 文件，添加新的中英文对照：

```lua
["中文词"] = "EnglishTerm",
```

### 2. 词条格式要求

- 中文和英文之间用 ` = ` 分隔
- 英文值用双引号包裹
- 每行一个词条
- 保持 UTF-8 编码

### 3. 排序规则

词库按中文长度降序排列，长词优先匹配。

### 4. 提交 PR

1. Fork 本仓库
2. 创建分支: `git checkout -b add-new-terms`
3. 添加词条
4. 提交: `git commit -m "Add: 新词条"`
5. Push: `git push origin add-new-terms`
6. 创建 Pull Request

## 常用术语对照表

### UE Blueprint 动词

| 中文 | 英文 | 示例 |
|------|------|------|
| 获取 | Get | GetActorLocation |
| 设置 | Set | SetActorRotation |
| 添加 | Add | AddComponent |
| 移除 | Remove | RemoveComponent |
| 创建 | Create | CreateWidget |
| 销毁 | Destroy | DestroyActor |
| 启用 | Enable | EnableInput |
| 禁用 | Disable | DisableInput |
| 显示 | Show | ShowComponent |
| 隐藏 | Hide | HideComponent |

### UE 名词

| 中文 | 英文 |
|------|------|
| Actor | Actor |
| 组件 | Component |
| 变换 | Transform |
| 位置 | Location |
| 旋转 | Rotation |
| 缩放 | Scale |
| 速度 | Velocity |
| 骨骼 | Skeleton |
| 动画 | Animation |
| 材质 | Material |
| 碰撞 | Collision |
| 相机 | Camera |
| 玩家 | Player |
| 敌人 | Enemy |
| 技能 | Ability |

### 常用组合

| 中文 | 英文 |
|------|------|
| 获取位置 | GetLocation |
| 设置位置 | SetLocation |
| 获取旋转 | GetRotation |
| 设置旋转 | SetRotation |
| 创建组件 | CreateComponent |
| 销毁组件 | DestroyComponent |
| 添加标签 | AddTag |
| 移除标签 | RemoveTag |
| 获取Actor | GetActor |
| 设置Actor | SetActor |

## 注意事项

- 请确保英文术语拼写正确
- 优先使用 UE 官方术语
- 不要添加重复词条
- 保持编码一致（UTF-8）

## 问题反馈

如有问题，请提交 [GitHub Issue](https://github.com/yourusername/rimecoding/issues)
