# Prose gate

A PostToolUse hook that fires after every `Edit`/`Write`. When the edited file is
governance prose — `CLAUDE.md`, anything under `.agents/documentation/`, `.agents/plans/`,
or `.agents/feature-ideas/`, a skill, or a command — it injects a reminder into the
editing session's context to run the authoring-for-agents smell test over the changed
text. On any other path it is silent, and it never fails loudly: a malformed payload
yields an empty path, which simply doesn't match.

The point: rules, standards, plans, feature ideas, skills, and commands are prose future
sessions will obey. This hook makes the smell test fire at the moment such prose changes,
instead of relying on the author to remember it.

## Requirements

- `jq` on PATH.
- `.agents/documentation/authoring-for-agents.md` present in the repo (the reminder
  points the session at it).

## Install

1. Copy `prose-gate.sh` to `.claude/hooks/prose-gate.sh` in the target repo.
2. `chmod +x .claude/hooks/prose-gate.sh`
3. Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/prose-gate.sh",
            "statusMessage": "prose gate: authoring-for-agents smell test"
          }
        ]
      }
    ]
  }
}
```

## Verify

Edit any file under `.claude/skills/` (or `CLAUDE.md`) in a Claude Code session: the
session's context gains the smell-test reminder after the edit tool completes. Edit a
source file: nothing happens.

## Tuning

The watched paths are the `case` patterns in `prose-gate.sh`. If the repo keeps its
global rules in `AGENTS.md` or its standards somewhere other than
`.agents/documentation/`, add those patterns to the same `case` arm.
