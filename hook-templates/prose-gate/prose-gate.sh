#!/usr/bin/env bash
# Prose gate — fired by the PostToolUse hook in .claude/settings.json after every
# Edit/Write. Receives the tool-call JSON on stdin. If the edited path is governance
# prose (CLAUDE.md anywhere, a documentation standard, a skill, a command), emits the
# JSON that injects the authoring-for-agents smell-test reminder into the editing
# session's context. Any other path: silent, exit 0 — the gate must never make noise
# on code edits and must never fail loudly (a malformed payload yields an empty path,
# which simply doesn't match).

changed_path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

case "$changed_path" in
  */CLAUDE.md | */.agents/documentation/* | */.claude/skills/* | */.claude/commands/*)
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PostToolUse",
        additionalContext: "This edit touched prose future sessions will obey. Before committing it, run the smell test in .agents/documentation/authoring-for-agents.md over the changed text, reading it as a stranger with no memory of this session: self-contained, no session-minted vocabulary, no dangling references."
      }
    }'
    ;;
esac
