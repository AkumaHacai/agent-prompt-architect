# Agent Prompt Architect

[English](README.md) | [Русский](README_RU.md) | [中文](README_ZH.md)

---

`agent-prompt-architect` is a specialized skill for AI assistants and agentic coding environments, designed to architect and refine production-ready prompts for **coding**, **design**, and **repository** agents.

It transforms high-level user requests into a single, self-contained, copy-pasteable prompt with strictly defined goals, explicit task boundaries (Scope In / Scope Out), technical invariants, Definition of Done (DoD), and reproducible verification procedures.

## Key Capabilities

- **Repository Grounding through Graphify**: For any task modifying an existing codebase, the prompt mandates an initial architectural discovery phase using [Graphify](https://github.com/safishamsi/graphify). The agent must inspect dependency graphs, god nodes, entry points, and blast radius before planning or touching code (with an explicit fallback to source inspection if Graphify is unavailable).
- **Mindful Skill Routing**: Intelligently selects the minimal sufficient combination of specialized skills (e.g., UI/UX styling, motion/GSAP, browser automation, refactoring audit) from installed tools, avoiding indiscriminate context bloat.
- **Execution Invariants & DoD**: Enforces autonomous task completion, minimal localized patches over full file rewrites, parallelization of independent reads/actions, and validation via concrete tests and observable runtime behavior.

## Repository Structure

```text
agent-prompt-architect/
├── SKILL.md                          # Main skill specification and generation workflow
├── references/
│   ├── prompt-blueprint.md           # Comprehensive prompt blueprint, invariants, and DoD
│   └── skill-routing.md              # Routing matrix and selection criteria for installed skills
├── .gitignore                        # Git ignore rules for temporary and local artifacts
├── README.md                         # Repository documentation (English)
├── README_RU.md                      # Репозиторий и документация (Русский)
└── README_ZH.md                      # 仓库文档 (中文)
```

## Installation

To use this skill in Antigravity or Gemini CLI, place the repository into your skills directory:

### Option 1: Clone from GitHub

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git /home/code/.gemini/config/skills/agent-prompt-architect
```

### Option 2: Symlink (if already cloned locally)

```bash
ln -s /path/to/agent-prompt-architect /home/code/.gemini/config/skills/agent-prompt-architect
```

Once linked, the skill becomes immediately available to the agent under the name `agent-prompt-architect`.

## Example Usage

User prompt to trigger the skill:

```text
Use the agent-prompt-architect skill.
Draft a complete, executable prompt for a coding agent: implement a dark/light theme toggle in an existing Next.js + Tailwind CSS repository, persist preference in localStorage, eliminate flash-of-unauthenticated-theme (FOUC), and verify the UI behavior in a real browser using Playwright.
```

The skill will output a structured, ready-to-run prompt block detailing the agent role, repository grounding steps, skill invocations (`impeccable`, `ui-styling`, `playwright-cli`), explicit scope, and clear acceptance criteria.
