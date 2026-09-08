---
name: handover
description: >-
  Distill the live session into .agents/handover.md so a fresh session can resume at
  full speed after /prime — often straight into /generate-feature-plan. Use when asked
  to "do a handover" or "hand this off", or before the operator clears context mid-task.
---

# handover — the state a fresh session needs to continue

`.agents/handover.md` is **live session state, consumed once and deleted**. The reader
is the next session: no memory of this conversation, and it will act on whatever this
file says. Often its first real move after consuming is `/generate-feature-plan` — the
handover does not do that research, it makes that research focused.

A handover is four things, and the task is the spine the other three hang on:

1. **The task** — the goal the next session exists to accomplish.
2. **What has been done** toward it — finished and proven, or stopped partway with
   what moves it.
3. **The details that matter** — gotchas, limitations, constraints, practices to
   follow, each marked by how we know it.
4. **Where to explore** — the directions worth researching next.

Pull these out of the conversation, not just the tree: a constraint the operator stated
once, a behavior that surprised us, an approach tried and abandoned and why. Anything
not written here is lost, and a fresh session either repeats the work or acts on
something we never actually checked.

## Procedure

1. **Leave the tree in a coherent state first.** A half-applied refactor is the worst
   thing to hand over. Either finish the change, or revert it and say so — ask the
   operator which, if it is not obvious. Never hand over a tree that does not build.
2. **Check the tree state**: `git status`, `git log --oneline -1`, and the branch's
   relationship to its remote. Write what they returned.
3. **Reread the conversation** for the details that never landed in a file.
4. **Write `.agents/handover.md`** from the template below.

## Rules

- **Say how you know.** Every fact carries the check behind it — the command that
  passed, the source file read, the measurement. No check → mark it assumed.
  - ❌ `refactored the config service`
  - ✅ `config.service.ts reads environment from runtime config; npm test green (74 passing)`
  - ❌ `the API rejects empty tags`
  - ✅ `API 400s on empty tags (curl against staging); assumed prod matches (never tested)`
- **Outcomes, not narrative.** The current position, not the game log — except when the
  failed path is the lesson worth keeping.
- **Operator constraints verbatim.** Paraphrasing a prohibition weakens it.
  - ❌ `operator prefers we hold off on committing`
  - ✅ `"do not commit or push anything until I've reviewed the diff"`
- **Never record consent that was not given.** Approval to commit, push, deploy, or
  spend attaches to a specific reviewed change and does not survive the context — if it
  was not granted for the work that remains, say it must be asked for again.
- **Short.** A page. A long handover is skimmed, and a skimmed handover is the same as
  no handover.

## Output template

The opening blockquote is verbatim. Everything in `<angle brackets>` is guidance to
replace. Cut anything with nothing real in it.

```markdown
> **You are resuming a session.** Run `/prime` — it consumes this file and deletes
> it. This file describes one moment and is wrong the instant work resumes — do not
> keep it, and never treat it as documentation.

## Task

<The goal this session is driving toward, in two or three sentences, and the first
move on resume — naming the command or file. Everything below serves this.>

## Done

- <finished and proven, each with its evidence>

## Where we left off

- <exactly where it stopped, named by file and function, and what moves it — the
  next step, the decision that unblocks it, or the external process still running>

## Details that matter

<Everything the next session must keep in mind to work this task: gotchas, limitations,
constraints, practices to follow. Mark each by how we know it.>

- <verified, with the check — like: `API 400s on empty tags (curl against staging)`>
- <assumed, flagged — like: `prod behaves the same (never tested)`>
- <a belief this session disproved, stated as disproven so it is not revived>
- <operator prohibition, quoted verbatim — like: `"do not push until I've reviewed"`>

## Explore

- <directions worth researching next and what each would settle — this feeds the next
  session's /generate-feature-plan>
- <open decisions awaiting the operator, and what each one unblocks>
```
