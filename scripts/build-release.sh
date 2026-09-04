#!/usr/bin/env bash
# Builds the release archives into dist/.
# Every archive carries the complete skill: the target agent's platform may
# differ from the platform the architect itself runs on, so all adapters ship
# in all bundles. The three skill bundles wrap the files in an
# agent-prompt-architect/ directory and add a platform-specific INSTALL.md;
# the chat bundle stays flat so START_HERE.md is the first thing seen.
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT=$(pwd)
NAME=agent-prompt-architect
DIST=$ROOT/dist
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

rm -rf "$DIST"
mkdir -p "$DIST"

# Source of truth: tracked files only.
git archive --format=tar HEAD | (mkdir -p "$WORK/src" && tar -x -C "$WORK/src")
rm -rf "$WORK/src/scripts"
rm -f "$WORK/src/.gitignore"

# skill_bundle <suffix> <install-md-path>
skill_bundle() {
  local suffix=$1
  local install=$2
  local dir="$WORK/$suffix"
  rm -rf "$dir"
  mkdir -p "$dir/$NAME"
  cp -r "$WORK/src/." "$dir/$NAME/"
  cp "$install" "$dir/$NAME/INSTALL.md"
  (cd "$dir" && zip -qr "$DIST/$NAME-$suffix.zip" "$NAME")
}

cat > "$WORK/INSTALL-claude-code.md" <<'EOF'
# Install for Claude Code

Unpack this archive so that `SKILL.md` ends up at
`~/.claude/skills/agent-prompt-architect/SKILL.md`:

```bash
unzip agent-prompt-architect-claude-code.zip -d ~/.claude/skills/
```

For one project only, unpack into `.claude/skills/` at the repository root instead.

Restart Claude Code, then confirm the skill is loaded:

```text
/help
```

The skill appears under custom commands. Invoke it with `/agent-prompt-architect`,
or just describe the task and let Claude pick it up by description.

Platform notes for prompts you generate are in `platforms/claude.md`; keep the
other adapters, since the agent you write a prompt for may run elsewhere.

To update, unpack a newer archive over the same directory. To remove:

```bash
rm -rf ~/.claude/skills/agent-prompt-architect
```
EOF

cat > "$WORK/INSTALL-codex.md" <<'EOF'
# Install for Codex CLI

Unpack this archive so that `SKILL.md` ends up at
`~/.agents/skills/agent-prompt-architect/SKILL.md`:

```bash
unzip agent-prompt-architect-codex.zip -d ~/.agents/skills/
```

For one repository only, unpack into `.agents/skills/` at the repository root instead.

Restart Codex, then confirm the skill is loaded:

```text
/skills
```

Invoke it by typing `$agent-prompt-architect`, or let Codex select it from the
description.

Platform notes for prompts you generate are in `platforms/codex.md`; keep the
other adapters, since the agent you write a prompt for may run elsewhere.

To update, unpack a newer archive over the same directory. To remove:

```bash
rm -rf ~/.agents/skills/agent-prompt-architect
```
EOF

cat > "$WORK/INSTALL-antigravity.md" <<'EOF'
# Install for Antigravity (agy)

Unpack this archive so that `SKILL.md` ends up at
`~/.gemini/config/skills/agent-prompt-architect/SKILL.md`:

```bash
unzip agent-prompt-architect-antigravity.zip -d ~/.gemini/config/skills/
```

For one workspace only, unpack into `.agents/skills/` at the workspace root instead.
Antigravity does not read `~/.agents/skills`, so use the path above for a global install.

Restart `agy`, then confirm the skill is loaded:

```text
/skills
```

Name the skill in your request, or let the agent activate it from the description.

Platform notes for prompts you generate are in `platforms/antigravity.md`; keep the
other adapters, since the agent you write a prompt for may run elsewhere.

To update, unpack a newer archive over the same directory. To remove:

```bash
rm -rf ~/.gemini/config/skills/agent-prompt-architect
```
EOF

skill_bundle claude-code "$WORK/INSTALL-claude-code.md"
skill_bundle codex       "$WORK/INSTALL-codex.md"
skill_bundle antigravity "$WORK/INSTALL-antigravity.md"

# Chat bundle: flat layout, START_HERE.md is the entry point, no install step.
CHAT="$WORK/chat"
mkdir -p "$CHAT"
cp -r "$WORK/src/." "$CHAT/"
(cd "$CHAT" && zip -qr "$DIST/$NAME-chat.zip" .)

# Full source archive.
(cd "$ROOT" && git archive --format=zip -o "$DIST/$NAME-full.zip" HEAD)

cd "$DIST"
sha256sum ./*.zip > SHA256SUMS.txt
ls -l
