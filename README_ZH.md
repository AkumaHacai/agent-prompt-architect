# Agent Prompt Architect (智能体提示词架构师)

[English](README.md) | [Русский](README_RU.md) | [中文](README_ZH.md)

---

`agent-prompt-architect` 是专为 AI 助手与智能体开发平台（Gemini CLI, Antigravity, Claude Code, Codex 等）设计的专业技能（Skill），专注于为 **coding**（编程）、**design**（前端与设计）以及 **repository**（代码库级演进）智能体构建并优化开箱即用的高质量提示词。

该技能将用户的高阶需求转化为单一、自闭环、可直接执行的结构化提示词，明确限定目标、任务边界（Scope In/Out）、技术不变性、完成准则（Definition of Done）及可观察的验证手段。

## 核心特性

- **基于 Graphify 的代码库认知（Repository Grounding through Graphify）**：针对现有代码库的任何任务，生成的提示词强制要求在规划与修改前使用 [Graphify](https://github.com/Graphify-Labs/graphify) 分析代码库架构。智能体必须首先理清依赖图谱、入口点、调用链和变更波及范围（Blast Radius）；若知识图谱不可用，则明确降级至代码搜索与源文件通读。对于从零开始的全新（Greenfield）任务，自动略过 Graphify。
- **精准的技能路由（Mindful Skill Routing）**：仅从目标环境已确认安装的工具中精准挑选最小且充分的专业技能组合（涵盖设计规范、UI 样式、动画系统、浏览器测试、代码精简优化等），杜绝盲目挂载导致上下文膨胀。
- **执行不变性与 DoD（Execution Invariants & DoD）**：提示词指导目标智能体自主完成全流程交付，优先采用精准局部修改而非大面积重写，并行化无依赖操作，并通过真实测试及浏览器运行时行为进行验证。
- **最小充分分解（Minimum Sufficient Decomposition）**：仅在各方向（design、frontend、backend、database、integration/QA 等）真正独立时才拆分工作流；仅当设计本身是独立任务时才将设计与实现分离；强制执行 **work pruning**，移除用户未要求的重构、清理、新依赖、基础设施、文档与测试。
- **执行模式（Execution Modes）**：每份提示词固定为 `Plan only`、`Plan → approval → implementation` 或 `Autonomous implementation` 之一。大型任务在生成前会询问是否需要审批计划以及是否允许子代理；小型任务不询问。
- **子代理策略（Subagent Policy）**：仅在存在独立、可验证的工作流且获得用户许可时使用子代理；主代理始终是 orchestrator，负责核查每个子代理结果、整合并执行最终验证。
- **技能发现与安装策略**：将所需能力映射到目标环境中真实可用的技能；缺失能力触发发现（`find-skills`、平台安装器）与最小化、任务驱动的安装，若无法安装则明确回退方案。
- **平台适配器**：共享核心加 `platforms/antigravity.md`、`platforms/claude.md`、`platforms/codex.md`，包含经验证的平台机制（技能目录、插件安装命令、子代理工具、计划模式）。未知平台 → 仅使用通用规则。

## 仓库结构

```text
agent-prompt-architect/
├── SKILL.md                          # 触发条件、核心流程、不变量、参考链接
├── references/
│   ├── prompt-blueprint.md           # 提示词模板、执行模式、不变量、质量检查
│   ├── task-decomposition.md         # 任务规模、工作流拆分规则、设计与实现分离、工作裁剪
│   ├── subagent-policy.md            # 何时使用子代理、主代理职责
│   └── skill-routing.md              # 能力 → 技能、安装策略、回退、已知技能图谱
├── platforms/
│   ├── antigravity.md                # Antigravity (agy)：技能、插件、子代理、模式
│   ├── claude.md                     # Claude Code：技能、插件、子代理、计划模式
│   └── codex.md                      # Codex CLI：技能、代理、沙箱、计划模式
├── LICENSE                           # MIT 许可证
├── .gitignore                        # 临时文件与本地产物的忽略规则
├── README.md                         # 仓库文档 (English)
├── README_RU.md                      # 仓库文档 (Русский)
└── README_ZH.md                      # 仓库文档 (中文)
```

## 安装与配置

### Gemini CLI（官方支持）

使用 Git 仓库地址直接安装技能：

```bash
gemini skills install https://github.com/AkumaHacai/agent-prompt-architect.git
```

验证已安装的技能列表：

```text
/skills list
```

Gemini CLI 技能存储目录说明：
- **用户级目录**：`~/.gemini/skills/` 或 `~/.agents/skills/`
- **项目级目录**：`.gemini/skills/` 或 `.agents/skills/`

### Claude Code

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.claude/skills/agent-prompt-architect
```

通过 `/agent-prompt-architect` 调用，或由 Claude 按描述自动激活。

### Codex CLI

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.agents/skills/agent-prompt-architect
```

通过 `$agent-prompt-architect` 或 `/skills` 调用。

### Antigravity 与手动安装

克隆至 Antigravity / Gemini 自定义技能目录：

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.gemini/config/skills/agent-prompt-architect
```

或者通过软链接挂载：

```bash
ln -s /path/to/agent-prompt-architect ~/.gemini/config/skills/agent-prompt-architect
```

安装完成后，智能体即可通过名称 `agent-prompt-architect` 自动识别并激活。

## 示例用法

用户向 AI 助手发出调用请求：

```text
使用技能 agent-prompt-architect。
请为 coding 智能体编写一份完整就绪的提示词：在现有 Tailwind CSS Next.js 项目中增加深浅色主题切换功能，要求在 localStorage 中持久化状态、避免首屏加载闪烁（FOUC），并通过 Playwright 进行浏览器端端到端验证。
```

智能体将输出包含角色设定、执行模式、Graphify 调研步骤、清晰的 Scope 边界及 Definition of Done 的完整提示词块。若目标环境已确认包含对应技能（如 `impeccable`, `ui-styling`, `playwright-cli`），则会在提示词中精确路由；否则将基于平台原生通用工具组织工作流并明确说明回退。

对于大型请求（例如「重新设计 dashboard 并实现」或「新增通知系统：API、数据库与 UI」），技能会先询问是否需要在实现前审批计划、是否允许子代理，然后输出按 design/implementation 或 backend/database/frontend/integration 拆分并经过裁剪的计划。

## 许可证

[MIT](LICENSE) © 2026 Akumanion (AkumaHacai)
