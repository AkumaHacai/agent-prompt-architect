# Agent Prompt Architect

[English](README.md) | [Русский](README_RU.md) | [中文](README_ZH.md)

---

`agent-prompt-architect` — специализированный скилл для AI-ассистентов и агентных платформ (Gemini CLI, Antigravity, Claude Code, Codex), предназначенный для проектирования и улучшения готовых промптов для **coding-**, **design-** и **repository-агентов**.

Скилл преобразует высокоуровневый запрос пользователя в один самодостаточный, готовый к выполнению промпт с четко зафиксированными целями, границами (Scope In / Scope Out), техническими инвариантами, критериями готовности (Definition of Done) и воспроизводимой проверкой.

## Ключевые возможности

- **Repository grounding through Graphify**: для любой работы с существующей кодовой базой в создаваемый промпт обязательно закладывается предварительное исследование архитектуры через [Graphify](https://github.com/Graphify-Labs/graphify). Агент обязан исследовать граф зависимостей, точки входа и blast radius до составления плана и правок кода (с прозрачным fallback на поиск по коду при отсутствии графа). Для greenfield-задач с нуля Graphify не добавляется.
- **Осознанная маршрутизация скиллов**: скилл анализирует задачу и подбирает минимальный достаточный набор специализированных инструментов (дизайн, верстка, анимации, браузерное тестирование, оптимизация) только из числа подтверждённых в целевой среде, исключая случайное раздувание контекста.
- **Инварианты выполнения**: создаваемый промпт ориентирует целевого агента на автономное завершение задачи, точечные экономные изменения, параллелизацию независимых операций и валидацию реальными тестами/поведением в рантайме.
- **Минимально достаточная декомпозиция**: задача делится на направления (design, frontend, backend, database, integration/QA, ...) только при их реальной независимости; дизайн отделяется от реализации только когда дизайн — самостоятельная задача; обязательная фаза **work pruning** убирает рефакторинг, cleanup, новые зависимости, инфраструктуру, документацию и тесты, которых пользователь не просил.
- **Режимы выполнения**: каждый промпт фиксирует один из режимов `Plan only`, `Plan → approval → implementation`, `Autonomous implementation`. Для крупных задач скилл до генерации спрашивает про утверждение плана и разрешение сабагентов; для малых — нет.
- **Политика сабагентов**: сабагенты используются только для независимых проверяемых направлений и с разрешения пользователя; главный агент остаётся orchestrator, проверяет результаты, интегрирует и выполняет финальную валидацию.
- **Обнаружение и установка skills**: capabilities сопоставляются с реально доступными в целевой среде skills; отсутствующая capability запускает поиск (`find-skills`, установщики платформы) и минимальную установку, обусловленную задачей, либо явный fallback, если установка невозможна.
- **Платформенные адаптеры**: общее ядро плюс `platforms/antigravity.md`, `platforms/claude.md`, `platforms/codex.md` с проверенными механизмами (каталоги skills, команды установки plugins, инструменты сабагентов, plan mode). Неизвестная платформа → только общие правила.

## Структура репозитория

```text
agent-prompt-architect/
├── SKILL.md                          # Триггер, основной workflow, инварианты, ссылки на references
├── references/
│   ├── prompt-blueprint.md           # Шаблон промпта, режимы выполнения, инварианты, контроль качества
│   ├── task-decomposition.md         # Размер задачи, правила деления на направления, design vs implementation, work pruning
│   ├── subagent-policy.md            # Когда сабагенты оправданы, обязанности orchestrator
│   └── skill-routing.md              # Capabilities → skills, политика установки, fallback, карта известных skills
├── platforms/
│   ├── antigravity.md                # Antigravity (agy): skills, plugins, subagents, режимы
│   ├── claude.md                     # Claude Code: skills, plugins, subagents, plan mode
│   └── codex.md                      # Codex CLI: skills, agents, sandbox, plan mode
├── LICENSE                           # Лицензия MIT
├── .gitignore                        # Исключения временных и локальных файлов
├── README.md                         # Документация репозитория (English)
├── README_RU.md                      # Документация репозитория (Русский)
└── README_ZH.md                      # 仓库文档 (中文)
```

## Установка скилла

### Gemini CLI (официальный способ)

Установка скилла напрямую по URL репозитория:

```bash
gemini skills install https://github.com/AkumaHacai/agent-prompt-architect.git
```

Проверка установленных навыков:

```text
/skills list
```

Расположение каталогов навыков в Gemini CLI:
- **Пользовательские**: `~/.gemini/skills/` или `~/.agents/skills/`
- **Уровня проекта**: `.gemini/skills/` или `.agents/skills/`

### Claude Code

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.claude/skills/agent-prompt-architect
```

Вызов: `/agent-prompt-architect` либо автоматически по описанию.

### Codex CLI

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.agents/skills/agent-prompt-architect
```

Вызов: `$agent-prompt-architect` либо через `/skills`.

### Antigravity и ручная установка

Клонирование в каталог пользовательских навыков:

```bash
git clone https://github.com/AkumaHacai/agent-prompt-architect.git ~/.gemini/config/skills/agent-prompt-architect
```

Либо через символическую ссылку, если репозиторий уже склонирован:

```bash
ln -s /path/to/agent-prompt-architect ~/.gemini/config/skills/agent-prompt-architect
```

После размещения скилл автоматически определяется по имени `agent-prompt-architect`.

## Пример использования

Запрос пользователя к ассистенту для активации скилла:

```text
Используй скилл agent-prompt-architect.
Составь готовый промпт для coding-агента: нужно добавить переключатель светлой и темной темы в существующий Next.js проект на Tailwind CSS, сохранив состояние в localStorage, предотвратив мигание темы при загрузке (FOUC) и проверив результат в браузере через Playwright.
```

В ответ скилл сгенерирует цельный, готовый к копированию блок с ролью, режимом выполнения, этапом исследования репозитория через Graphify, строгими границами (Scope In / Scope Out) и критериями приемки. Если в целевой среде подтверждено наличие профильных скиллов (`impeccable`, `ui-styling`, `playwright-cli`), промпт маршрутизирует их; иначе задача будет сформулирована на базе стандартных инструментов среды с явным fallback.

Для крупного запроса (например «переработай dashboard и реализуй новый дизайн» или «добавь систему уведомлений: API, БД и UI») скилл сначала спросит, нужно ли утверждать план перед реализацией и разрешены ли сабагенты, затем выдаст декомпозированный план с направлениями design/implementation или backend/database/frontend/integration и отсечённым scope.

## Лицензия

[MIT](LICENSE) © 2026 Akumanion (AkumaHacai)
