# Agent Prompt Architect (智能体提示词架构师)

[English](README.md) | [Русский](README_RU.md) | [中文](README_ZH.md)

---

`agent-prompt-architect` 是专为 AI 助手与智能体开发平台（Gemini CLI, Antigravity, Claude Code, Codex 等）设计的专业技能（Skill），专注于为 **coding**（编程）、**design**（前端与设计）以及 **repository**（代码库级演进）智能体构建并优化开箱即用的高质量提示词。

该技能将用户的高阶需求转化为单一、自闭环、可直接执行的结构化提示词，明确限定目标、任务边界（Scope In/Out）、技术不变性、完成准则（Definition of Done）及可观察的验证手段。

## 核心特性

- **基于 Graphify 的代码库认知（Repository Grounding through Graphify）**：针对现有代码库的任何任务，生成的提示词强制要求在规划与修改前使用 [Graphify](https://github.com/Graphify-Labs/graphify) 分析代码库架构。智能体必须首先理清依赖图谱、入口点、调用链和变更波及范围（Blast Radius）；若知识图谱不可用，则明确降级至代码搜索与源文件通读。对于从零开始的全新（Greenfield）任务，自动略过 Graphify。
- **精准的技能路由（Mindful Skill Routing）**：仅从目标环境已确认安装的工具中精准挑选最小且充分的专业技能组合（涵盖设计规范、UI 样式、动画系统、浏览器测试、代码精简优化等），杜绝盲目挂载导致上下文膨胀。
- **执行不变性与 DoD（Execution Invariants & DoD）**：提示词指导目标智能体自主完成全流程交付，优先采用精准局部修改而非大面积重写，并行化无依赖操作，并通过真实测试及浏览器运行时行为进行验证。

## 仓库结构

```text
agent-prompt-architect/
├── SKILL.md                          # 核心技能规范与提示词生成工作流
├── references/
│   ├── prompt-blueprint.md           # 完整提示词蓝图模板、执行不变性与 DoD
│   └── skill-routing.md              # 已安装技能的路由矩阵与选择规则
├── LICENSE                           # MIT 开源许可证
├── .gitignore                        # 忽略规则（临时文件、本地缓存）
├── README.md                         # 英文文档 (English)
├── README_RU.md                      # 俄文文档 (Русский)
└── README_ZH.md                      # 中文文档 (中文)
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

智能体将输出包含角色设定、Graphify 调研步骤、清晰的 Scope 边界及 Definition of Done 的完整提示词块。若目标环境已确认包含对应技能（如 `impeccable`, `ui-styling`, `playwright-cli`），则会在提示词中精确路由；否则将基于平台原生通用工具组织工作流。

## 许可证

[MIT](LICENSE) © 2026 Akumanion (AkumaHacai)
