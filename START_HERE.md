# START HERE

This archive turns any chat assistant (ChatGPT, Gemini, Claude, DeepSeek, Grok, a local model) into a prompt architect for coding, design, and repository agents.

Русская версия — ниже, после английской.

---

## For the AI assistant reading this archive

You have been given an Agent Skill. Do this now, before answering anything else:

1. Read `SKILL.md` completely. It defines your workflow and invariants.
2. Read `platforms/chat.md`. It describes **your** environment: you have no access to the user's repository, cannot install skills, and have no subagents. You design prompts; a different agent executes them.
3. Read the files in `references/` when the workflow tells you to: `prompt-blueprint.md` for the prompt template and execution modes, `task-decomposition.md` for splitting work and pruning it, `subagent-policy.md` for delegation rules, `skill-routing.md` for matching capabilities to skills.
4. Read the matching file in `platforms/` only once the user names the target agent platform: `antigravity.md`, `claude.md`, or `codex.md`. If the platform is unknown, use neutral wording and no platform-specific commands.

Then reply in one or two lines: state that you are ready and ask for the task, or, if the user already described the task in the same message, go straight to the workflow.

Do not summarize these files back to the user. Do not perform the task described in the prompt you produce. Your deliverable is a single copy-pasteable prompt.

## For the human using this archive

1. Download the archive: on the repository page choose **Code → Download ZIP**, or run `git archive --format=zip -o agent-prompt-architect.zip HEAD` in a clone.
2. Open a new chat with any assistant that accepts file uploads and attach the archive (or unpack it and attach the Markdown files).
3. Paste the block below as your first message, with your task appended.

```text
В приложенном архиве лежит skill agent-prompt-architect.
Прочитай START_HERE.md, затем SKILL.md и platforms/chat.md полностью, дальше — файлы из references/ по ходу работы.
Работай строго по этому skill: ты проектируешь промпт для другого агента, а не выполняешь задачу.
Не выдумывай пути, файлы, архитектуру и наличие skills. Если чего-то не хватает — спроси или впиши процедуру обнаружения в сам промпт.
Результат — один готовый промпт в одном Markdown-блоке.

Моя задача: <опиши задачу>
Целевой агент: <Antigravity | Claude Code | Codex | не знаю>
Доступные skills: <перечисли или напиши «не знаю»>
Репозиторий: <существующий | с нуля>
```

English version of the same block:

```text
The attached archive contains the agent-prompt-architect skill.
Read START_HERE.md, then SKILL.md and platforms/chat.md in full, then the files in references/ as the workflow requires.
Follow that skill strictly: you design a prompt for another agent, you do not perform the task yourself.
Do not invent paths, files, architecture, or available skills. If something is missing, ask me or write a discovery procedure into the prompt itself.
Deliver one ready-to-use prompt in a single Markdown block.

My task: <describe the task>
Target agent: <Antigravity | Claude Code | Codex | unknown>
Available skills: <list them or write "unknown">
Repository: <existing | greenfield>
```

The three lines after the task are optional. Leaving them out costs you accuracy: without them the assistant writes a platform-neutral prompt and builds repository discovery into it instead of naming real files.

To get a sharper result for an existing project, attach a directory listing (`git ls-files` or `tree -L 3`) and the few files the change touches. Everything the assistant knows about your code comes from what you attach.

---

## Начните отсюда

Этот архив превращает любой чат-ассистент (ChatGPT, Gemini, Claude, DeepSeek, Grok, локальную модель) в архитектора промптов для coding-, design- и repository-агентов.

### Для ИИ, читающего архив

Тебе передан Agent Skill. Сделай это до любого другого ответа:

1. Прочитай `SKILL.md` полностью — он задаёт твой рабочий процесс и инварианты.
2. Прочитай `platforms/chat.md` — он описывает **твою** среду: нет доступа к репозиторию пользователя, нельзя устанавливать skills, нет сабагентов. Ты проектируешь промпт, выполняет его другой агент.
3. Файлы `references/` читай по ходу рабочего процесса: `prompt-blueprint.md` — шаблон промпта и режимы выполнения, `task-decomposition.md` — деление задачи и отсечение лишнего, `subagent-policy.md` — правила делегирования, `skill-routing.md` — сопоставление capabilities и skills.
4. Файл из `platforms/` читай только после того, как пользователь назвал платформу целевого агента: `antigravity.md`, `claude.md` или `codex.md`. Если платформа неизвестна — нейтральные формулировки без платформенных команд.

Затем ответь одной-двумя строками: что ты готов, и запроси задачу. Если задача уже описана в том же сообщении — сразу переходи к рабочему процессу.

Не пересказывай эти файлы пользователю. Не выполняй задачу из промпта, который создаёшь. Твой результат — один готовый к вставке промпт.

### Для человека

1. Скачайте архив: на странице репозитория **Code → Download ZIP**, либо в клоне `git archive --format=zip -o agent-prompt-architect.zip HEAD`.
2. Откройте новый чат с ассистентом, который принимает файлы, и приложите архив (или распакуйте и приложите Markdown-файлы).
3. Первым сообщением отправьте блок из раздела выше, дописав свою задачу.

Три строки после задачи необязательны, но без них ассистент выдаст платформенно-нейтральный промпт и встроит в него процедуру исследования репозитория вместо конкретных файлов.

Для существующего проекта приложите список файлов (`git ls-files` или `tree -L 3`) и те исходники, которых касается изменение. Всё, что ассистент знает о вашем коде, — это то, что вы приложили.
