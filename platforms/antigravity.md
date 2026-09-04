# Адаптер: Google Antigravity (agy)

Проверено по локальной установке `agy 1.1.26`, встроенным skills `agy-customizations` и `antigravity-guide`, и официальной документации (`https://antigravity.google/docs/skills`, `/docs/subagents`, `/docs/plugins`, `/docs/cli/features`, `/docs/cli/reference`). Antigravity меняется быстро: перед фиксацией команды в промпте проверь `agy --help`, `/help` внутри TUI и live-документацию.

## Признаки платформы

- CLI `agy`; глобальная конфигурация в `~/.gemini/config/`; служебные данные в `~/.gemini/antigravity-cli/`.
- В workspace: каталоги `.agents/` (`.agents/skills/`, `.agents/agents/`, `.agents/plugins/`, `.agents/rules/`), правила в `GEMINI.md` или `AGENTS.md`.
- Внутри сессии доступны `/skills`, `/agents`, `/boost`, `/teamwork-preview`, `/planning`, `/tasks`, `/permissions`.

## Skills

- Расположение: workspace `.agents/skills/<name>/SKILL.md`, глобально `~/.gemini/config/skills/<name>/SKILL.md`. Поддерживается также `.agent/skills/` (устаревший вариант).
- Обнаружение: в контекст попадают только `name` и `description` skills; полный `SKILL.md` читается при активации. Агент активирует skill по описанию или когда пользователь называет его в запросе.
- Просмотр установленных: `/skills` внутри `agy`. Вне сессии — `ls ~/.gemini/config/skills .agents/skills`.
- Как закрепить skill в промпте: назови его точным именем и потребуй прочитать `SKILL.md` полностью до действий. Слэш-синтаксис `/<skill>` для активации skill не документирован официально; не полагайся на него в промпте.
- Установка: скопировать или клонировать каталог skill в одну из директорий выше; после этого он обнаруживается автоматически. Skills CLI (`npx skills add <owner/repo@skill>` из корня проекта) ставит skill в workspace `.agents/skills/`; глобальный `~/.agents/skills` Antigravity не читает — для глобальной установки используй `~/.gemini/config/skills/` (копия или symlink). После установки проверь `/skills`. Graphify ставится командой `graphify install --platform antigravity`.

## Plugins

- Расположение: `.agents/plugins/<name>/` или `~/.gemini/config/plugins/<name>/` с `plugin.json`; плагин может содержать `skills/`, `rules/`, `hooks.json`, `mcp_config.json`, `agents/`.
- Команды: `agy plugin list`, `agy plugin install <target>` (поддерживается `plugin@marketplace`), `agy plugin import [gemini|claude]`, `agy plugin enable|disable <name>`, `agy plugin validate [path]`.
- Включение управляется `~/.gemini/config/config.json` (`"plugins": {"<dir>": {"enabled": true|false}}`).

## Subagents

- Определения: `.agents/agents/<name>.md` (или `<name>/agent.md`), глобально `~/.gemini/config/agents/<name>.md`, в плагинах `plugins/<name>/agents/`. Frontmatter: `name`, `description`, `tools` (например `view_file`, `run_command`, `grep_search`), `model` (`inherit|flash|pro`), `commandExecutionPolicy` (`off|auto|eager|sandbox`); тело файла — system prompt.
- Встроенные сабагенты: `research`, `browser`, `self`.
- Запуск: главный агент вызывает инструмент `invoke_subagent`; несколько сабагентов могут работать одновременно; сабагент не наследует историю разговора родителя. Панель `/agents` показывает и позволяет одобрять действия сабагентов; `/tasks` — фоновые задачи.
- Оркестрация: `/boost <task>` (multi-agent deep reasoning) и `/teamwork-preview <task>` (команда агентов для длинных проектов). Используй их только по явному разрешению пользователя: они дороже одиночной сессии.
- Неверное имя инструмента в `tools` может подвесить сабагент — не выдумывай имена инструментов.
- В промпте для сабагентов пиши: «Делегируй направление X сабагенту через `invoke_subagent`, передав ему подтверждённые пути и контракт; результат проверь сам».

## Repository tools и Graphify

- Базовые инструменты: просмотр файлов, grep-поиск, выполнение команд в терминале (при `commandExecutionPolicy`/`toolPermission`, разрешающих запуск), web search.
- Graphify: skill `graphify` в `~/.gemini/config/skills/graphify/` плюс CLI `graphify` (`graphify update .`, `graphify query`, `graphify explain`, `graphify path`). Порядок в промпте: Graphify → чтение исходников → правки; fallback — grep и чтение файлов.
- Rules: `GEMINI.md` / `AGENTS.md` действуют всегда для своей директории; учитывай их как ограничения проекта.

## Browser tooling

- Встроенный сабагент `browser` и browser-возможности IDE (`https://antigravity.google/docs/ide/browser`). В CLI-сессии для воспроизводимого browser QA предпочитай установленный skill `playwright-cli`, если он есть; иначе делегируй проверку сабагенту `browser` или зафиксируй, что browser-проверка не выполнена.

## Режимы выполнения

| Режим промпта | Как выразить в Antigravity |
| --- | --- |
| Plan only | Запуск `agy --mode plan` или `/planning` внутри сессии; в промпте — «не изменяй файлы, выдай план». |
| Plan → approval → implementation | `/planning` для плана, после утверждения обычный режим; или прямое указание в промпте «остановись после плана и жди подтверждения». |
| Autonomous implementation | Обычный режим; для сокращения подтверждений `agy --mode accept-edits` либо `toolPermission` в `~/.gemini/antigravity-cli/settings.json` (`request-review`, `proceed-in-sandbox`, `always-proceed`, `strict`). `--dangerously-skip-permissions` только по осознанному выбору пользователя. |

Неинтерактивный запуск: `agy -p "<prompt>"` (`--output-format json|stream-json`, `--effort low|medium|high`).

## Чего не переносить из других платформ

- Нет slash-команды `/graphify` как в Claude Code — используй skill `graphify` и CLI.
- Нет инструмента `Agent`/`Task` из Claude Code и нет `$skill` из Codex.
- `/plan` из Codex здесь называется `/planning` или задаётся флагом `--mode plan`.
