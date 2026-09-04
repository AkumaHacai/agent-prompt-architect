# Адаптер: Claude Code

Проверено по локальной установке Claude Code 2.1.260 и официальной документации (`https://code.claude.com/docs/en/skills`, `/docs/en/sub-agents`, `/docs/en/plugins`, `/docs/en/discover-plugins`, `/docs/en/common-workflows`). Перед фиксацией команды в промпте сверься с `/help` и текущей документацией.

## Признаки платформы

- CLI `claude`; конфигурация в `~/.claude/` (`skills/`, `agents/`, `plugins/`, `settings.json`), проектная в `.claude/`; правила в `CLAUDE.md`.
- Внутри сессии: slash-команды `/help`, `/plugin`, `/reload-plugins`, `/agents`, `/context`; инструменты `Skill`, `Agent`, `Read`, `Grep`, `Glob`, `Bash`, `Edit`, `Write`, `WebFetch`, `WebSearch`.

## Skills

- Расположение: `~/.claude/skills/<name>/SKILL.md` (личные), `.claude/skills/<name>/SKILL.md` (проектные), skills плагинов — как `/<plugin>:<skill>`. Файлы `.claude/commands/*.md` работают как skills.
- Обнаружение: Claude видит `name` и `description` всех skills и подгружает тело при использовании. Явный вызов — `/<skill-name>` в чате или инструмент `Skill` изнутри агента. Список — `/help` (вкладка custom commands) или `/context`.
- Frontmatter `disable-model-invocation: true` запрещает автоматическую активацию: такой skill сработает только по `/<name>`.
- Как закрепить skill в промпте: «Вызови `/<name>` (или инструмент `Skill` с именем `<name>`) и прочитай его инструкции полностью до действий». Например `/graphify .` для Graphify.
- Установка отдельного skill: положить каталог в `~/.claude/skills/` или `.claude/skills/`; `npx skills add <owner/repo@skill> -g -y` (skills CLI поддерживает Claude Code как целевую платформу); `graphify install --platform claude`. Новый skill виден после перезапуска сессии.

## Plugins и marketplaces

- `/plugin marketplace add <owner/repo | git-url | path>` регистрирует каталог; `/plugin install <plugin>@<marketplace>` устанавливает; `/plugin list`, `/plugin enable|disable|uninstall`, `/reload-plugins` применяет изменения без перезапуска.
- Shell-эквиваленты для скриптов: `claude plugin marketplace add …`, `claude plugin install <plugin>@<marketplace> [--scope user|project|local]`, `claude plugin validate <path>`.
- Официальный marketplace `claude-plugins-official` добавляется автоматически; сообщество — `/plugin marketplace add anthropics/claude-plugins-community`.
- Тест локального плагина: `claude --plugin-dir ./plugin`. Плагин может содержать `skills/`, `agents/`, `hooks/hooks.json`, `.mcp.json`, `.lsp.json`.
- Не выполняй `/plugin install` от имени пользователя без разрешения: плагины выполняют код с правами пользователя.

## Subagents

- Встроенные: `Explore` (read-only поиск), `Plan` (read-only исследование для плана), `general-purpose`, `claude`. Пользовательские: `.claude/agents/<name>.md`, `~/.claude/agents/<name>.md`, плагины `agents/`. Frontmatter: `name`, `description`, опционально `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `skills`, `background`, `isolation: worktree`.
- Запуск: инструмент `Agent` (в версиях ≤ 2.1.62 назывался `Task`); в чате — «use a subagent to …» или `@"<name> (agent)"`. Несколько вызовов `Agent` в одном сообщении выполняются параллельно. `subagent_type: "fork"` наследует контекст родителя; `/subtask` запускает форк из чата.
- Контекст сабагента изолирован: он получает только описание задачи, `CLAUDE.md` и снимок git status; передавай ему подтверждённые пути и контракты явно.
- Ограничения: глубина вложенности по умолчанию 3, одновременно до 20; сабагенты не могут задавать вопросы пользователю (`AskUserQuestion` недоступен) — все решения принимает главный агент. Результат сабагента возвращается как отчёт, его нужно проверить по файлам.
- Продолжение диалога с уже запущенным сабагентом — `SendMessage`.
- В промпте для сабагентов пиши: «Запусти сабагентов через инструмент `Agent` параллельно для направлений X и Y (по одному на направление, тип `general-purpose`), передай каждому подтверждённые пути и контракт, запрети им редактировать общие файлы; интеграцию и проверку выполни сам».

## Repository tools и Graphify

- Чтение и поиск: `Read`, `Grep`, `Glob`, `Bash`; ссылки `@path/to/file` в чате; для широкого поиска — сабагент `Explore`. LSP-плагины (`typescript-lsp`, `pyright-lsp` и т. п.) дают навигацию по определениям и диагностики.
- Graphify: `/graphify .` создаёт или обновляет `graphify-out/`; запросы к графу — по инструкциям skill `graphify` (`graphify query`, `graphify explain`, `graphify path`). Порядок: Graphify → чтение затронутых файлов → правки; fallback — `Grep`/`Glob`/`Read`.
- Параллельность: независимые вызовы инструментов объединяются в одном сообщении; долгие команды — `Bash` с `run_in_background`; изолированные параллельные сессии — `claude --worktree <name>`.

## Browser tooling

- Skill `playwright-cli`, если установлен, — основной механизм воспроизводимого browser QA. Skill `claude-in-chrome` (при включённом расширении) — интерактивная проверка в браузере пользователя. Если ни одного нет — зафиксируй в промпте, что browser-проверка не выполнялась.

## Режимы выполнения

| Режим промпта | Как выразить в Claude Code |
| --- | --- |
| Plan only | Запуск `claude --permission-mode plan` или `Shift+Tab` до `⏸ plan mode on`; в промпте — «не изменяй файлы, выдай план». |
| Plan → approval → implementation | Plan mode → пользователь утверждает план (`ExitPlanMode`) → реализация; либо указание в промпте «остановись после плана и жди подтверждения». |
| Autonomous implementation | Обычный режим или `--permission-mode acceptEdits` / `auto`; `--dangerously-skip-permissions` только по осознанному выбору пользователя. |

Режимы разрешений: `default`, `acceptEdits`, `plan`, `auto`, `bypassPermissions`. Неинтерактивный запуск: `claude -p "<prompt>"`.

## Чего не переносить из других платформ

- Нет `$skill`-синтаксиса Codex и `invoke_subagent` Antigravity.
- Нет `/planning` и `/boost`; вместо них plan mode и `Agent`.
- `AGENTS.md` не является файлом правил Claude Code; правила — `CLAUDE.md`.
