---
name: knowledge-base-curator
description: 'Automates the full knowledge base workflow: ingesting raw materials, extracting concepts, deduplicating (rule 6), project archiving, and maintaining index/log files per AGENTS.md. Invoke when user asks for knowledge organization, material processing, project archiving, deduplication, content curation, or any knowledge base maintenance task.'
metadata:
  short-description: 自动化知识库管理：素材入库、项目归档、查重合并、增量维护
---

> **本 Skill 的唯一依据：[AGENTS.md](AGENTS.md)**
> 所有操作必须先查阅 AGENTS.md 的对应章节。本 Skill 是 AGENTS.md 的执行辅助，不是替代。

## 📌 Skill 定位

- **目标**：辅助 AGENTS.md 的自动执行——将用户的模糊需求（「整理一下这个」「归档项目」「检查重复」）转化为符合四层架构的标准化操作
- **操作范围**：`raw/`、`wiki/`、`schema/`、`projects/`、`archive/`、`docs/`
- **不操作**：`.obsidian/`、`.claudian/`、`.claude/`

---
---
---

## 🔄 核心工作流（5 大场景）

### 场景判断树

```
用户输入
    ↓
┌─ 是新素材（Markdown/视频文字/笔记）？→ 工作流 1：raw → wiki
├─ 是代码项目/文件夹要归档？        → 工作流 2：项目归档
├─ 是「检查重复/合并」需求？        → 工作流 3：查重合并
├─ 是修改/调整已有知识？            → 工作流 4：内容修改
├─ 是回答问题/引用知识？            → 工作流 5：引用链回答
└─ 不明确？                         → 主动询问用户意图
```

> **每一个工作流完成后，都必须更新 `wiki/index.md` 和写入 `wiki/log.md`**（除非是工作流 5 纯查询操作）。

---
---
---

## 工作流 1：新素材入库（raw → wiki）

> **对应 AGENTS.md：五、规则 2 + 九、迭代流程**

### 标准步骤（强制顺序）

```
Step 1: 放入 raw/  →  Step 2: 查重检查  →  Step 3: 生成 sources/
    ↓
Step 4: 提炼 concepts/  →  Step 5: 更新 index.md  →  Step 6: 写入 log.md
```

#### Step 1：分类放入 raw/

| 素材类型 | 目标目录 | 处理方式 |
|---------|---------|---------|
| Markdown 文章 | `raw/articles/` | **原文不动**直接放入 |
| 随手笔记/文本 | `raw/notes/` | **原文不动**直接放入 |
| 视频/音频内容（有文字稿） | `raw/video/` | 只保存文字稿部分 |
| 截图/图片 | `raw/assets/` | 原样保存 |

> **原则**：raw 层永远不变，保证溯源能力。

#### Step 2：强制查重检查（规则 6）

在生成任何 wiki 文件之前，先执行工作流 3 的查重流程。

**查重关键词**：从素材中提取前 2–4 个核心概念 → 搜索 `wiki/concepts/` 中含相同标签的文件 → 按规则 6.2 的 4 个维度评估。

- 如果触发合并条件 → 跳至工作流 3
- 如果无需合并 → 继续 Step 3

#### Step 3：生成 sources/ 文件

每 1 篇原始内容 → 1 个 source 文件，命名格式：`YYYY-MM-DD-简要标题.md`

**source 文件结构**：

```markdown
# 来源摘要：[原始标题/内容简述]

- 来源类型：[文章/笔记/视频文字稿/其他]
- 原始位置：[raw/ 下的相对路径]
- 摘要日期：YYYY-MM-DD

## 核心内容

[用 3–5 个要点概括原始内容的核心信息]

## 可提炼的概念

[列出本文中值得单独创建 concept 文件的 1–3 个核心主题]

## 相关已有知识

[[已有相关概念文件 1]]
[[已有相关概念文件 2]]
```

#### Step 4：提炼 concept 文件

从 source 中提取独立概念，每个概念一个文件。

**每篇 concept 必须包含四字段（规则 3）**：

```markdown
# 概念标题

标签：#标签1 #标签2  #标签3

来源：[[对应的 source 文件]] 或 原始素材路径

相关：[[关联文件1]] [[关联文件2]]

## 核心结论

[用一句话概括整篇知识的价值——结论前置，必须写]

---
---
---

## 正文

[结构化呈现，使用表格、列表、代码块]
```

**标签选择规则（强制）**：
1. 先阅读 `schema/tags.md`，优先从已有标签中选择 2–4 个
2. 如需新标签 → 按 AGENTS.md「四、tags.md 规范」先在 tags.md 追加登记 → 再使用
3. 不使用过于宽泛的标签（如只用 `#知识` 无效）

**代码摘录规则**：
- 如果素材含代码/可代码化的逻辑 → 以代码块形式摘录，标注语言类型
- 保留核心逻辑与注释，去除冗余/装饰代码
- 每个代码块前简要说明用途

#### Step 5：更新 index.md

按 AGENTS.md「四、index.md 格式规范」：
- 在 `## concepts/` 表格中追加一行：`| [[文件名]] | #标签1 #标签2 | 一句话描述 |`
- 在 `## sources/` 表格中追加一行（如适用）
- 更新「最后更新：YYYY-MM-DD」日期

#### Step 6：写入 log.md

按 AGENTS.md「四、log.md 格式规范」，在文件头部追加（日期倒序）：

```markdown
## YYYY-MM-DD — 简明主题

### 新增文件

- [[concept 文件名]] — 描述
- [[source 文件名]] — 描述

### 修改文件

- [[已有文件]] — 做了什么修改

### 归档 / 移除

- [[已移除文件名]] — 原因
- [[concept 文件名]] — 一句话描述
- [[source 文件名]] — 一句话描述

### 查重与合并

[根据 Step 2 结果写：
  - 未发现高相似度文件，无需合并
  或
  - [[文件A]] 与 [[文件B]] 因 [原因，如 #Python #爬虫 标签重合]，合并至 [[文件A]]]
```

---
---
---

## 工作流 2：项目归档

> **对应 AGENTS.md：六、项目归档规范**

### 触发条件
- 用户说「归档这个项目」「这个项目用完了」「项目打包」
## 工作流 2：项目归档（编程类项目 / Skill）

> **对应 AGENTS.md：七、项目归档流程 + 规则 6**

### 标准步骤

```
归档检查 → 提取 concept → 打包项目 → 放入 archive/ → 更新 index → 写 log
```

#### Step 1：归档前检查

确认 AGENTS.md 六、项目归档规范的 5 项检查清单：
1. README.md 是否包含基本说明
2. 是否已提取核心 concept 到 wiki/concepts/
3. 是否已确认无敏感信息
4. 源文件是否可删除（确认用户意愿）
5. 版本标签是否标记（可选）

#### Step 2：提取核心 concept

执行工作流 1 的 Step 3→Step 4，从项目中提取可复用的知识点写入 wiki/concepts/

#### Step 3：打包

```powershell
# 使用 quick-archive.ps1
powershell -File tools/quick-archive.ps1 -ProjectPath "projects/myproject"
```

**建议排除**的大目录：`node_modules`、`.git`、`__pycache__`、`dist`、`build`、`.venv`、`venv`

#### Step 4：放入 archive/

打包好的 zip 自动放入 `archive/YYYY_tech/archives/` 目录

#### Step 5：更新 index.md

在 `archive/` 索引中追加一条归档记录

#### Step 6：写入 log.md

```markdown
## YYYY-MM-DD — 归档：项目名

### 归档

- 项目路径：projects/xxx
- 归档位置：archive/YYYY_tech/archives/xxx_YYYYMM.zip
- 已提取 concept：[[concept 文件 1]]、[[concept 文件 2]]
Step 1: 查重检查（规则 6）→ Step 2: 提取核心代码 → Step 3: 打包归档
                     ↓                                              ↓
               Step 4: 更新 wiki/concepts/（新建 or 合并）    Step 5: 更新 index.md + log.md
```

#### Step 1：查重检查（**必须先做**）

翻越 `wiki/concepts/`，搜索与当前项目技术栈/主题相关的文件，按规则 6.2 评估相似度。

- 高相似度 → 按规则 6.4 合并：保留已有文件为主载体，将新项目代码作为新增小节追加
- 低相似度 → 新建 concept 文件

#### Step 2：提取核心代码到 wiki/concepts/

从项目中提取有价值的内容，每类一个 concept 文件（遵循四字段格式）：

| 文件类型 | 命名建议 | 内容要点 |
|---------|---------|---------|
| 核心算法/逻辑 | `[项目名]核心算法.md` | 关键函数、核心逻辑代码块 |
| 技术方案设计 | `[项目名]架构设计.md` | 架构图/流程图说明、设计决策 |
| 关键代码片段 | `[项目名]核心代码.md` | 代表性代码 + 注释 |
| 开发经验总结 | `[项目名]踩坑记录.md` | 问题、解决方案、经验教训 |

**代码摘录格式**：

```python
# 用途：[说明这段代码做什么]
# 源文件：[相对项目中的路径]
[代码内容]
```

#### Step 3：项目打包归档

- 将整个项目目录压缩为 ZIP 文件
- 命名格式：`[项目名]_YYYYMM.zip`
- 存放路径：`archive/YYYY_tech/archives/[项目名]_YYYYMM.zip`
- 其中 `YYYY_tech` 按年份 + 类型组织（tech/design/其他）

#### Step 4：更新 index.md

- 在 `## concepts/` 表格中追加新建 concept 文件
- 更新最后更新日期

#### Step 5：写入 log.md

```markdown
## YYYY-MM-DD — 项目归档：[项目名]

### 新增文件

- [[concept 文件名 1]] — 一句话描述
- [[concept 文件名 2]] — 一句话描述

### 归档/清理

- 归档：`archive/YYYY_tech/archives/[项目名]_YYYYMM.zip`

### 查重与合并

- 未发现高相似度项目，新建 concept 文件
- 或：[[已有文件]] 与本项目因 [原因] 相似，新项目代码追加至 [[已有文件]]，不新建独立 concept
```

---
---
---

## 工作流 3：查重合并

> **对应 AGENTS.md：规则 6 + 六、规则 5**

### 触发条件
- 用户说「检查有没有重复」「合并一下」「去重」
- 自动：工作流 1 的 Step 2 触发时自动进入

### 查重流程

**Step 1：提取候选概念**

从待处理素材中提取 2–4 个核心关键词/标签

**Step 2：搜索 wiki/concepts/**

```powershell
Select-String -Path "wiki/concepts/*.md" -Pattern "关键词1|关键词2"
```

**Step 3：按 4 维度评估（规则 6.2）**

| 维度 | 评估内容 | 合并阈值 |
|------|---------|---------|
| V1 主题重合度 | 标题/核心结论是否实质相同 | >=70% |
| V2 内容覆盖度 | 新内容是否完全被已有覆盖 | >=80% |
| V3 标签一致性 | 标签交叉程度 | 至少 2 个相同 |
| V4 时效性 | 新信息是否更新/修正旧信息 | 手动判断 |

**Step 4：决定处理方式**

- **V1>=70% & V2>=80%** → **内容强合并**（已有文件追加关键信息）
- **V1>=70% & V2<80%** → **弱合并**（在已有文件中加「参见」链接）
- **V1<70%** → **不合并**，作为新 concept 创建

**Step 5：执行合并**

**强合并**：在已有 concept 中追加新信息，更新「相关」字段
**弱合并**：在已有 concept 末尾添加 `> 另见：[[新文件]]`，同时新文件中引用已有文件

**Step 6：更新 log.md**

```markdown
## YYYY-MM-DD — 合并操作

### 合并

- [[目标文件]] ← [[源文件]] — [强合并/弱合并]
- 原因：[简短的合并理由]
```

---
---
---

## 工作流 4：内容修改

> **对应 AGENTS.md：七、内容修改规范**

### 适用场景
- 修正错误信息
- 补充/更新内容
- 调整结构/格式
- 更新过时信息

### 流程

**Step 1：定位文件**
在 wiki/ 中找到要修改的文件

**Step 2：标注变更**

- **修正错误**直接改原文，末尾标注 `> [!NOTE] 于 YYYY-MM-DD 修正`
- **补充内容**直接在对应章节追加，标注 `> [!NOTE] 于 YYYY-MM-DD 补充`
- **过时信息**用 `> [!WARNING] 待更新` 标注，修改后替换为 `> [!NOTE] 于 YYYY-MM-DD 更新`

**Step 3：更新 index.md**（如描述变化）

**Step 4：写入 log.md**

```markdown
## YYYY-MM-DD — 修改：文件名

### 修改

- [[文件名]] — [修正/补充/更新了什么]
```
## 工作流 3：查重合并（规则 6 的完整执行）

> **对应 AGENTS.md：五、规则 6**

### 标准步骤（5 步强制顺序）

#### Step 1：确定查重范围

- **查重目标**：`wiki/concepts/` 目录下所有文件
- **查重起点**：从待新增/待处理内容的前 2–4 个核心标签入手

#### Step 2：关键词搜索

使用搜索工具，按以下顺序在 `wiki/concepts/` 中查找：
1. 核心标签重合的文件
2. 文件名关键词匹配
3. 核心结论内容相似度

#### Step 3：逐项评估（4 维度）

对每个命中文件，按以下 4 维度打分，**满足任意 2 项即视为高相似度**：

| 维度 | 判断标准 |
|------|---------|
| 核心结论重叠 | 是否描述同一主题或包含关系 |
| 标签重合 | 是否共享 ≥ 2 个相同标签 |
| 知识范围覆盖 | 一者是另一者的子集或超集 |
| 代码同域 | 代码是否属于同一技术栈/问题域 |

#### Step 4：决策处理方式

| 情形 | 处理 |
|------|------|
| 2 文件内容互补 | 合并为 1 个 concept，保留两者来源/相关字段 |
| 1 文件被另一者包含 | 保留更完整者，将被包含文件 ZIP 归档至 `archive/` |
| 3+ 文件围绕同一主题 | 在 log.md 中标注「建议创建 summary」，**不自动创建** |
| 无高相似度 | 记录「无需合并」 |

#### Step 5：记录到 log.md（**必须**）

无论是否合并，结果必须写入 log.md 的「查重与合并」段落。

---
---
---

## 工作流 4：内容修改（对已有知识的调整）

> **对应 AGENTS.md：五、规则 1 — 只做增量处理，不重建整个库**

### 修改原则

| 场景 | 允许操作 | 不允许 |
|------|---------|--------|
| 修正错别字/格式 | ✅ 直接修改 | 不改内容实质 |
| 补充遗漏信息 | ✅ 追加新小节 | 不删除原有内容 |
| 内容已过时/错误 | ✅ 开头添加 `> ⚠ 内容已过时，参见 [[新文件]]` | 不直接删除文件 |
| 内容重复 → 合并 | ✅ 按工作流 3 处理 | 不直接删除冗余文件（先归档） |
| 大规模重组 | ❌ **需要用户确认** | 不自动执行 |

### 修改后的更新

任何修改后必须：
1. 更新 `wiki/index.md` 中对应行（如涉及归档标记）
2. 写入 `wiki/log.md` 的「修改文件」段落

---
---
---

## 工作流 5：引用链回答

> **对应 AGENTS.md：七、引用规范**

### 触发条件
- 用户提问并要求引用知识来源
- 用户说「从 wiki 里找一下xxx」

### 流程

**Step 1：检索 wiki**

```powershell
Select-String -Path "wiki/concepts/*.md" -Pattern "关键词"
```

**Step 2：提取相关信息**
读取匹配文件，提取最相关的内容

**Step 3：标注来源**
在回答中标注 `[[来源文件名]]` 或 `（来源：wiki/concepts/xxx.md）`

**Step 4：引用链**
- 如果回答涉及多个 concept → 展示引用链
- 如果用户要深入某个点 → 定位到具体 source

---
---
---

## 🧩 模块 A：代码摘录增强

### A.1 代码项目类型的 concept 特殊要求

当素材涉及代码/技术项目时，concept 文件中必须增加以下结构：

```markdown
## 技术要点

### 核心逻辑

[用自然语言描述代码的核心逻辑，避免贴整段代码]

### 关键实现

```python
# 摘录最核心的 10-20 行代码
def core_function():
    pass
```

### 集成方式

[如果这是一个库/工具/脚本，说明如何安装、导入、使用]

### 依赖关系

[列出主要依赖和技术栈]

### 注意事项

[边界情况、性能问题、版本兼容等]
```

### A.2 代码项目归档额外要求

归档代码项目前，必须确保：
1. README.md 包含：用途说明、安装方式、使用示例
2. 核心算法/逻辑已提取到 wiki/concepts/
3. 注释关键参数和配置项

---
---
---

## 🧩 模块 B：插件协同模板

### B.1 与 Obsidian 协同

| Obsidian 特性 | 本 Skill 对应 |
|-------------|------------|
| [[Wiki链接]] | wiki/concepts/ 内联引用 |
| #标签 | schema/tags.md 标签体系 |
| 属性（Properties） | concept 四字段 |
| Graph View | 模块 C 知识图谱 |
| 模板 | concept 文件结构模板 |

### B.2 与 AI 工具协同

| AI 工具 | 协作方式 |
|--------|---------|
| Claude/Cursor | 读取 wiki/ 做上下文增强 |
| ChatGPT | 输出格式兼容 Markdown |
| Copilot | 代码注释中引用 concept |

---
---
---

## 🧩 模块 C：知识图谱自动化

> **对应 AGENTS.md：规则 4**

### C.1 自动更新触发

当以下操作发生时自动执行知识图谱更新：
- 新增 concept 文件
- 新增 source 文件
- 修改 concept 中的「相关」字段
- 合并操作

### C.2 图谱输出

知识图谱支持以下输出形式（按需调用）：
- **关联文件列表**：列出与新概念最相关的 3-5 个现有 concept
> **对应 AGENTS.md：五、规则 4 — 回答必须带引用链**

### 回答规范

1. **先查 wiki/**：用户提问时，先在 `wiki/concepts/` 和 `wiki/sources/` 中搜索相关内容
2. **标注来源**：回答中引用的每个概念，标注来源文件链接 `[[文件名]]`
3. **结论先行**：直接给出答案，再附引用链
4. **闭环反哺**（规则 5）：如果回答产生了新的高质量结论 → 作为新 concept 文件写入 `wiki/concepts/`，走工作流 1

---
---
---

## 🧪 操作前必查清单（执行任何操作前逐项核对）

| # | 检查项 | 对应 AGENTS.md 章节 | 状态 |
|---|--------|-------------------|------|
| 1 | 是否翻越了 `wiki/concepts/` 进行查重检查？ | 五、规则 6 | ✅/❌ |
| 2 | 标签是否来自 `schema/tags.md` 已登记的标签？ | 四、tags.md 标签规范 | ✅/❌ |
| 3 | concept 文件是否包含四字段：标题/核心结论/来源/相关？ | 五、规则 3 | ✅/❌ |
| 4 | 代码摘录是否标注了语言类型？ | 六、格式要求 | ✅/❌ |
| 5 | 是否已按规范更新 `wiki/index.md`？ | 四、index.md 格式规范 | ✅/❌ |
| 6 | 是否已按规范写入 `wiki/log.md`？ | 四、log.md 格式规范 | ✅/❌ |

> 如果任何一项为 ❌，暂停当前操作，先补全缺失项。

---
---
---

## ⚠ 常见问题处理

### Q1：用户说「整理一下这个」但没有明确说明整理什么？
**处理**：不要猜测。请用户明确：是新素材入库？还是已有内容调整？

### Q2：同一主题有多个 concept，是否应该合并？
**处理**：按规则 6.2 评估——满足任意 2 项相似度维度 → 合并；否则在「相关」字段中互相引用即可。

### Q3：log.md 条目写什么内容合适？
**处理**：按四、log.md 格式规范的模板写——日期、新增/修改文件、查重结果、归档路径。简洁但完整。

### Q4：概念命名用英文还是中文？
**处理**：文件名用中文标题（如 `Scrapling爬虫框架研究.md`），符合 AGENTS.md「六、文件规范——命名」。

### Q5：查重后发现高相似度，但用户明确要求新建文件怎么办？
**处理**：尊重用户指令，但在 log.md 中注明：「用户要求新建独立文件，尽管与 [[已有文件]] 存在标签重合（#标签1 #标签2）」，并在 concept 文件的「相关」字段中引用已有文件。

---
---
---

## 🛠 增强辅助模块

> **AGENTS.md 之外的实用工具与模板，辅助知识库高效运转**

---
---
---

### 模块 A：代码智能提取

> **从项目中提取、组织和索引代码知识的增强方法**

#### A.1 代码块识别规则

```markdown
```语言名称
代码内容
```
```

**提取维度**：

| 维度 | 说明 | 示例 |
|------|------|------|
| 语言类型 | 代码块声明的语言 | `python`, `javascript`, `bash` |
| 功能类型 | 代码用途分类 | 算法/配置/测试/工具函数 |
| 依赖关系 | 外部依赖识别 | `import` 语句分析 |

#### A.2 代码摘录增强格式

```markdown
### 代码片段：[功能描述]

**用途**：[解决什么问题]
**语言**：[编程语言]
**依赖**：[需要的库/模块]

```python
# 核心逻辑
import module

def example():
    """说明"""
    pass
```

**使用示例**：
```python
result = example()
```
```

#### A.3 代码质量快速评估

| 评估项 | 判断 | 处理 |
|--------|------|------|
| 完整性 | 是否有完整逻辑 | 不完整 → 标注「片段」 |
| 可读性 | 注释/命名是否清晰 | 不清晰 → 补充说明 |
| 安全性 | 是否有敏感信息 | 有 → 脱敏处理 |

#### A.4 代码索引模板

用于在 `wiki/concepts/` 中建立代码导航：

```markdown
# 代码索引：[项目/主题]

## 按语言

- [[文件1#片段1]] — 功能
- [[文件2#片段2]] — 功能

## 按功能

- [[文件1#片段1]] — 数据处理
- [[文件2#片段2]] — API调用
```

---
---
---

### 模块 B：Obsidian 插件协同

> **Dataview / Templater / QuickAdd 的实用模板**

#### B.1 Dataview 查询模板

```dataview
TABLE without id
  file.link as "文件",
  tags as "标签",
  file.mtime as "修改时间"
FROM "wiki/concepts"
WHERE contains(tags, "#标签名")
SORT file.mtime DESC
LIMIT 10
```

**常用查询**：

| 场景 | 查询 |
|------|------|
| 按标签筛选 | `WHERE contains(tags, "#Python")` |
| 按时间排序 | `SORT file.mtime DESC` |
| 按来源关联 | `WHERE contains(source, [[source文件]])` |

#### B.2 Templater 自动化模板

**新建 concept**：

```markdown
---
---
---
created: <% tp.date.now("YYYY-MM-DD HH:mm") %>
---
---
---

# <% tp.file.title %>

标签：<% tp.system.prompt("输入标签") %>

来源：[[<% tp.system.prompt("来源文件") %>]]

相关：

## 核心结论

[一句话概括]

---
---
---

## 正文
```

**新建 source**：

```markdown
---
---
---
created: <% tp.date.now("YYYY-MM-DD HH:mm") %>
type: source
---
---
---

# 来源摘要：<% tp.file.title %>

- 来源类型：[文章/笔记/视频]
- 摘要日期：<% tp.date.now("YYYY-MM-DD") %>

## 核心内容

1.
2.
3.

## 可提炼的概念

-
```

#### B.3 QuickAdd 快速操作

| 宏 | 用途 |
|----|------|
| 快速添加 concept | 输入标题 → 选择标签 → 自动创建 |
| 快速添加 source | 粘贴内容 → 自动分类生成摘要 |
| 批量处理 raw/ | 扫描待处理文件 → 逐个引导 |

---
---
---

### 模块 C：知识图谱自动化

> **自动识别实体和关系，增强知识关联**

#### C.1 实体自动识别

| 实体类型 | 识别模式 | 处理 |
|---------|---------|------|
| 文件引用 | `[[文件名]]` | 建立双向链接索引 |
| 标签 | `#标签名` | 聚合到 tags.md |
| URL | `http(s)://...` | 提取为参考链接 |
| 代码块 | ` ```language ` | 分类到代码索引 |
| 日期 | `YYYY-MM-DD` | 建立时间线标记 |

#### C.2 关系自动发现规则

| 关系类型 | 发现方法 | 表示 |
|---------|---------|------|
| 引用关系 | `[[文件名]]` 链接 | 「相关」字段 |
| 标签共现 | 相同标签数量 | 分类聚合视图 |
| 时间序列 | 日期标记 | 时间线视图 |
| 层级关系 | 标题结构 | 大纲视图 |

#### C.3 知识图谱可视化

- **局部图谱**：单个 concept 的关联网络
- **主题图谱**：按标签聚合的主题集群
- **时间图谱**：知识演进时间线

---
---
---

### 模块 D：实用辅助工具

> **工具脚本位于 `tools/` 目录，AI 根据需要调用执行**

#### 工具清单

| 工具 | 脚本 | 用途 | 调用场景 |
|------|------|------|----------|
| 待处理清单 | [list-pending.ps1](tools/list-pending.ps1) | 扫描 raw/ 和 projects/，生成处理优先级清单 | 「有哪些待处理内容」「整理 raw」 |
| 批量移动 | [batch-move.ps1](tools/batch-move.ps1) | 整理 raw/ 未分类素材，自动分类和重命名 | 「整理 raw/ 未分类的文件」 |
| 快速打包 | [quick-archive.ps1](tools/quick-archive.ps1) | 快速打包项目到 archive/ | 「归档项目 X」「打包项目」 |
| 文件转换 | [convert-doc.ps1](tools/convert-doc.ps1) | PDF/PPT/DOC/Excel/图片 转 Markdown | 「把这个 PDF 转成文字」「PPT 转 md」 |
| 链接检查 | [link-check.ps1](tools/link-check.ps1) | 检测 wiki 内部死链和外部链接 | 「检查死链」「健康检查」 |
| 待处理清单 | [list-pending.ps1](file:///e:/obsidian-codex/projects/knowledge-base-curator/tools/list-pending.ps1) | 扫描 raw/ 和 projects/，生成处理优先级清单 | 「有哪些待处理内容」「整理 raw」 |
| 批量移动 | [batch-move.ps1](file:///e:/obsidian-codex/projects/knowledge-base-curator/tools/batch-move.ps1) | 整理 raw/ 未分类素材，自动分类和重命名 | 「整理 raw/ 未分类的文件」 |
| 快速打包 | [quick-archive.ps1](file:///e:/obsidian-codex/projects/knowledge-base-curator/tools/quick-archive.ps1) | 快速打包项目到 archive/ | 「归档项目 X」「打包项目」 |
| 文件转换 | [convert-doc.ps1](file:///e:/obsidian-codex/projects/knowledge-base-curator/tools/convert-doc.ps1) | PDF/PPT/DOC/Excel/图片 转 Markdown | 「把这个 PDF 转成文字」「PPT 转 md」 |
| 链接检查 | [link-check.ps1](file:///e:/obsidian-codex/projects/knowledge-base-curator/tools/link-check.ps1) | 检测 wiki 内部死链和外部链接 | 「检查死链」「健康检查」 |

---
---
---

#### D.1 待处理清单生成器

**脚本**：`tools/list-pending.ps1`

**用法**：
```powershell
# 默认扫描最近 7 天
powershell -File tools/list-pending.ps1

# 指定天数
powershell -File tools/list-pending.ps1 -Days 14

# 指定输出路径
powershell -File tools/list-pending.ps1 -OutputPath "wiki/pending.md"
```

**扫描目录**：
- `raw/articles/` — 待处理文章
- `raw/notes/` — 待处理笔记
- `raw/video/` — 待处理视频文字稿
- `raw/assets/` — 待处理素材
- `projects/` — 待归档项目

---
---
---

#### D.2 文件转换（PDF / PPT / DOC / Excel / 图片 → Markdown）

**脚本**：`tools/convert-doc.ps1`（基于 markitdown）

**用法**：
```powershell
# 基础用法（输出到 raw/articles/）
powershell -File tools/convert-doc.ps1 -Path "文档.pdf"

# 指定输出目录
powershell -File tools/convert-doc.ps1 -Path "PPT.pptx" -OutputDir "raw/articles"

# 指定输出文件名
powershell -File tools/convert-doc.ps1 -Path "表格.xlsx" -OutputFile "产品数据表.md"

# 覆盖已存在文件
powershell -File tools/convert-doc.ps1 -Path "资料.pdf" -Overwrite
```

**支持格式**：
| 类型 | 扩展名 |
|------|--------|
| 文档 | `.pdf` `.docx` `.html` `.htm` `.epub` `.txt` |
| 表格 | `.xlsx` `.xls` `.csv` |
| 演示 | `.pptx` |
| 数据 | `.json` `.xml` |
| 图片 | `.png` `.jpg` `.jpeg` `.bmp` `.gif` `.tif` `.tiff`（OCR 提取文字） |

**输出位置**：默认写入 `raw/articles/`，随后可按工作流 1 继续提炼为 concept

---
---
---

#### D.3 批量移动与重命名助手

**脚本**：`tools/batch-move.ps1`

**用法**：
```powershell
# 预览模式（不实际执行）
powershell -File tools/batch-move.ps1 -SourcePath "raw/未分类" -DryRun

# 确认执行
powershell -File tools/batch-move.ps1 -SourcePath "raw/未分类"
```

**自动分类规则**：
| 文件类型 | 目标目录 |
|---------|---------|
| .md 含「视频」「文字稿」 | `raw/video/` |
| .md 其他 | `raw/articles/` |
| 图片/截图 | `raw/assets/` |

**重命名格式**：`YYYY-MM-DD-简短标题.扩展名`

---
---
---

#### D.4 快速打包助手

**脚本**：`tools/quick-archive.ps1`

**用法**：
```powershell
# 基本打包
powershell -File tools/quick-archive.ps1 -ProjectPath "projects/mytool"

# 打包并排除大目录
powershell -File tools/quick-archive.ps1 -ProjectPath "projects/mytool" -Exclude "node_modules",".git"
```

**输出路径**：`archive/YYYY_tech/archives/项目名_YYYYMM.zip`

**打包前检查**：
- [ ] 已提取核心 concept 到 wiki/concepts/
- [ ] 已确认无敏感信息
- [ ] 确认原始项目可归档

---
---
---

#### D.5 链接健康检查

**脚本**：`tools/link-check.ps1`

**用法**：
```powershell
powershell -File tools/link-check.ps1

# 指定 wiki 路径
powershell -File tools/link-check.ps1 -WikiPath "wiki"
```

**检测范围**：
- 内部链接 `[[文件名]]` — 检测死链
- 外部链接 `[text](url)` — 汇总列出

---
---
---

#### D.6 一致性维护周期

| 检查项 | 频率 | 处理 |
|--------|------|------|
| 死链检测 | 每周 | `tools/link-check.ps1` |
| 待处理清单 | 每周 | `tools/list-pending.ps1` |
| 文件转换入库 | 按需 | `tools/convert-doc.ps1` |
| 标签一致性 | 每月 | 手动检查 tags.md |
| 重复文件 | 每月 | 按规则 6 处理 |

---
---
---

## 📖 快速索引

| 功能 | 位置 |
|------|------|
| AGENTS.md 核心规则 | 五、规则 1-6 |
| 代码摘录增强 | 模块 A |
| 插件协同模板 | 模块 B |
| 知识图谱自动化 | 模块 C |
| 实用工具脚本 | 模块 D / tools/ |

---
---
---

> 善用工具，让知识管理更高效。











