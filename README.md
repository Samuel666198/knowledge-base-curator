# 知识库管理助手（knowledge-base-curator）

一个面向 AI 助手的知识库自动化管理 Skill。自动化完成全流程：素材入库、项目归档、查重合并、增量维护、索引更新。

> 本 Skill 是 [AGENTS.md](file:///e:/obsidian-codex/AGENTS.md) 的执行辅助，所有操作均以 AGENTS.md 为唯一依据。

## 目录结构

```
knowledge-base-curator-skill/
├── SKILL.md          # Skill 主文件（AI 助手的完整操作指南）
└── tools/             # 辅助工具脚本
    ├── list-pending.ps1    # 扫描待处理清单
    ├── batch-move.ps1       # 批量移动与重命名
    ├── quick-archive.ps1  # 项目快速打包归档
    ├── convert-doc.ps1    # 文件格式转换（PDF/PPT/DOC/Excel/图片 → Markdown）
    ├── link-check.ps1     # 死链检查
    └── _convert_doc.py   # markitdown 调用封装
```

## 5 大核心工作流

| 工作流 | 适用场景 | 核心操作 |
|--------|---------|---------|
| 1. 新素材入库 | Markdown / 视频文字稿 / 笔记 / 截图 | raw → sources → concepts，按规则 6 查重，更新 index/log |
| 2. 项目归档 | 编程类项目 / Skill 项目 | 提取核心 concept → 打包 archive → 写入索引 |
| 3. 查重合并 | 已有内容出现重复或相似 | 4 维度评估，合并或归档 |
| 4. 内容修改 | 修正 / 补充 / 标记过时 | 增量处理，不删除原文件 |
| 5. 引用链回答 | 用户提问已有知识 | 先查 wiki，结论先行，附来源链接 |

## Skill 定位

- **目标**：将用户的模糊需求（「整理一下」「归档项目」「检查重复」）转化为符合四层架构的标准化操作
- **操作范围**：`raw/`、`wiki/`、`schema/`、`projects/`、`archive/`、`docs/`
- **不操作**：`.obsidian/`、`.claudian/`、`.claude/`

## 核心规则摘要

1. **规则 1（增量处理）**：只做增量，不重建整个库
2. **规则 3（concept 四字段）**：每个 concept 文件必须包含「标签 / 来源 / 相关 / 核心结论
3. **规则 4（引用链）**：回答必须带来源链接 `[[文件名]]`
4. **规则 5（闭环反哺）**：回答产生的新知识 → 作为新 concept 写入 wiki
5. **规则 6（查重合并）**：4 维度评估（核心结论重叠 / 标签重合 / 知识范围覆盖 / 代码同域），满足任意 2 项即合并

## tools 工具脚本使用

所有工具脚本位于 `tools/` 目录，PowerShell 执行：

```powershell
# 列出待处理内容
powershell -File tools/list-pending.ps1

# 文件格式转换（PDF/PPT/DOC/Excel/图片 → Markdown）
powershell -File tools/convert-doc.ps1 -Path "文档.pdf"

# 项目快速归档
powershell -File tools/quick-archive.ps1 -ProjectPath "projects/mytool"

# 批量移动与重命名
powershell -File tools/batch-move.ps1 -SourcePath "raw/未分类"

# 死链检查
powershell -File tools/link-check.ps1
```

## 文件规范

| 文件类型 | 命名 |
|---------|------|
| concept | `中文标题.md`（如 `Scrapling爬虫框架研究.md`） |
| source | `YYYY-MM-DD-简要标题.md` |
| 归档包 | `[项目名]_YYYYMM.zip` |

## 维护周期

| 检查项 | 频率 | 工具 |
|--------|------|------|
| 死链检测 | 每周 | `tools/link-check.ps1 |
| 待处理清单 | 每周 | `tools/list-pending.ps1 |
| 文件转换入库 | 按需 | `tools/convert-doc.ps1 |
| 标签一致性 | 每月 | 手动检查 tags.md |
| 重复文件 | 每月 | 按规则 6 处理 |

## 常见问题

- **「整理一下这个」怎么处理？** 请用户明确：是新素材入库？还是已有内容调整？
- **内容重复是否合并？** 按规则 6.2 评估——满足任意 2 项 → 合并；否则互相引用。
- **概念命名用英文还是中文？** 文件名用中文标题，符合 AGENTS.md「六、文件规范——命名」。
- **查重后发现高相似度，但用户明确要求新建文件怎么办？** 尊重用户指令，但在 log.md 中注明，并在 concept 文件的「相关」字段中引用已有文件。

## License

MIT
