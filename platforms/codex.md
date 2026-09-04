# Адаптер: OpenAI Codex CLI

Проверено по локальной установке `codex-cli 0.153.0` (`codex --help`, `codex features list`) и официальной документации (`https://developers.openai.com/codex/skills`, `/codex/multi-agent`, `/codex/cli/slash-commands`; часть страниц перенаправляет на `learn.chatgpt.com/docs/...`). Codex меняется быстро: перед фиксацией команды в промпте проверь `codex --help`, `/help` внутри TUI и текущую документацию.

## Признаки платформы

- CLI `codex`; конфигурация `~/.codex/config.toml`; правила проекта в `AGENTS.md`; каталоги `~/.codex/agents/`, `~/.codex/plugins/`, `~/.codex/rules/`.
- Внутри сессии: `/skills`, `/plan`, `/model`, `/review`; упоминание skill через `$<skill-name>`.

## Skills

- Расположение: репозиторий `.agents/skills/<name>/SKILL.md` (от cwd до корня репозитория), пользователь `~/.agents/skills/<name>/SKILL.md`, админ `/etc/codex/skills`, плюс системные skills, встроенные в Codex. Локальные установки могут также содержать `~/.codex/skills/`; источник истины — список `/skills` внутри сессии.
- Обнаружение: неявное по `description`; явное — `$<skill-name>` в тексте или выбор через `/skills`.
- Как закрепить skill в промпте: «Используй `$<skill-name>` и прочитай его `SKILL.md` полностью до действий». Например `$graphify`.
- Установка: `$skill-installer <name>` для курируемых skills; `npx skills add <owner/repo@skill> -g -y` пишет в `~/.agents/skills`, который Codex читает; `graphify install --platform codex`. Отключение: `[[skills.config]]` с `path` и `enabled = false` в `config.toml`. Новый skill подхватывается автоматически, при необходимости перезапусти Codex.
- Опциональные метаданные skill — `agents/openai.yaml` внутри каталога skill.

## Plugins

- `codex plugin` управляет плагинами; маркетплейсы и включённые плагины хранятся в `config.toml` (`[marketplaces.<name>]`, `[plugins."<plugin>@<marketplace>"] enabled = true`). Плагин может содержать skills и hooks. Не устанавливай плагины без разрешения пользователя.

## Subagents

- Включены по умолчанию: секция `[agents]` в `config.toml`, ключи `agents.enabled` (по умолчанию `true`), `agents.max_concurrent_threads_per_session`, `agents.default_subagent_model`, `agents.default_subagent_reasoning_effort`.
- Встроенные роли: `default`, `worker` (реализация и правки), `explorer` (чтение и исследование). Пользовательские роли — TOML-файлы в `~/.codex/agents/` или `.codex/agents/` с полями `name`, `description`, `developer_instructions`.
- Запуск: отдельного tool-имени в промпте нет; главный агент делегирует по инструкции в тексте («spawn agents for X and Y in parallel», «delegate this to an explorer agent»). Codex дожидается всех результатов и возвращает сводку; сабагенты наследуют sandbox и approval policy родителя.
- Стоимость: сабагенты потребляют больше токенов, чем одиночный прогон; используй только по политике [subagent-policy.md](../references/subagent-policy.md).
- Список сессий агентов на локальном app-server: `codex agents`.
- В промпте для сабагентов пиши: «Раздели работу между агентами ролей `worker` для направлений X и Y (по одному агенту на направление); каждому передай подтверждённые пути и контракт; результаты проверь сам, интеграцию и validation выполни в главном потоке».

## Repository tools и Graphify

- Чтение, поиск и команды выполняются через shell в sandbox; политика sandbox — `-s read-only|workspace-write|danger-full-access`, одобрения — `-a on-request|never`, `--approve-for-me`.
- Graphify: skill `$graphify` и CLI `graphify` (`graphify update .`, `graphify query`, `graphify explain`, `graphify path`). Порядок: Graphify → чтение затронутых файлов → правки; fallback — `rg`/`grep` и чтение файлов.
- `AGENTS.md` в репозитории — обязательные правила проекта; учитывай их как ограничения в промпте.
- Параллельность внутри одного агента: независимые команды объединяются; для параллельных потоков — сабагенты или `codex exec` в отдельных рабочих копиях.

## Browser tooling

- Встроенных browser-инструментов в CLI нет; feature-флаги `browser_use`/`computer_use` относятся к среде Codex, а не к локальной установке по умолчанию. Для browser QA используй установленный skill `playwright-cli` или MCP-сервер браузера; если их нет — зафиксируй, что browser-проверка не выполнялась.

## Режимы выполнения

| Режим промпта | Как выразить в Codex |
| --- | --- |
| Plan only | `/plan <task>` внутри сессии (plan mode) или запуск с `-s read-only`; в промпте — «не изменяй файлы, выдай план». |
| Plan → approval → implementation | `/plan`, затем после утверждения обычный режим; либо указание в промпте «остановись после плана и жди подтверждения». |
| Autonomous implementation | `codex --full-auto` (workspace-write без запросов на каждую команду) или `codex exec "<prompt>"` для неинтерактивного прогона; `--dangerously-bypass-approvals-and-sandbox` только по осознанному выбору пользователя во внешне изолированной среде. |

Review: `codex review` / `/review` для непрерывной проверки diff.

## Чего не переносить из других платформ

- Нет slash-вызова `/graphify` и инструмента `Agent` из Claude Code; нет `invoke_subagent` и `/boost` из Antigravity.
- Правила — `AGENTS.md`, а не `CLAUDE.md` или `GEMINI.md`.
- Не указывай имена инструментов сабагентов: Codex выбирает механизм сам по текстовой инструкции.
