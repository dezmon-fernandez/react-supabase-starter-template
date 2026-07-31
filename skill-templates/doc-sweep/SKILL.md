---
name: doc-sweep
description: >-
  Find docs and pointers the code has outgrown — a shipped idea still filed as unbuilt, two
  docs owning the same question, a reference to a file that is gone, a citation tag pointing
  at no rule, CLAUDE.md's architecture tree or command list falling behind the filesystem.
  Every finding is proved by a check against the repo, not a judgement call. Reports by
  default; changes files only when asked ("fix them" / "--fix"). Use when asked to "sweep the
  docs", "run a doc sweep", "audit the agents tree", "find stale docs", or after shipping a
  slice, a route, a command, or a table.
---

# doc-sweep — find docs and pointers the code has outgrown

`/piv-loop:generate-plan` reads `.agents/` and CLAUDE.md for context, so a doc describing
finished work is a false statement the next planner will act on.

Your job: find those, prove each one with a check against the repo, and report. Do not guess
from prose.

## Read first

- **CLAUDE.md** — the repo's rules for the `.agents/` tree: which docs are deleted when their
  work ships, which retire piece by piece, and any citation numbering it maintains as durable.
- **`.agents/documentation/authoring-for-agents.md`** — the smell test for `.agents/` prose.

## Part 1 — is the doc still true?

For every `*.md` under `.agents/`:

1. **Build claims.** Take what the doc says exists, and check each claim against the artifact
   that owns it: a module → the filesystem · an endpoint → `[PROJECT-SPECIFIC: the API spec or
   route table]` · a table or column → `[PROJECT-SPECIFIC: the schema source of truth]` · a
   command → `[PROJECT-SPECIFIC: the CLI or script registry]`.
   Says UNBUILT but everything resolves? Finding. Says BUILT but nothing resolves? Finding.
2. **Ownership.** Two docs answering the same question is a finding, and the fix is a merge,
   not a delete. `[PROJECT-SPECIFIC: if doc frontmatter declares what question each doc owns,
   compare those declarations first.]`
3. **References.** A doc naming a file that no longer exists is dangling. A doc nothing else
   names is an orphan — report it, but that alone is not a verdict.

Note which docs git tracks. An untracked doc cannot be recovered after deletion, and that
belongs in the report.

## Part 2 — do the pointers still land?

4. **Citation tags.** Where the repo sanctions a durable numbering (a rules list in CLAUDE.md,
   PRD section numbers), count the entries the numbering actually has, grep the code for every
   tag, and flag any tag above the count — that is a leaked plan number. For tags in range,
   read the target and confirm it is the one the sentence is about: inserting an entry
   renumbers every tag below it, and a wrong tag still reads as correct.
5. **Architecture tree** — every feature slice and shared-core directory should appear in
   CLAUDE.md's tree.
6. **Command reference** — compare CLAUDE.md's command list against
   `[PROJECT-SPECIFIC: where commands are registered — the CLI module, package.json scripts]`,
   both ways. Then check any per-command marker (cost, safety, destructive) matches what the
   command does.
7. **Boundary promises** — any rule CLAUDE.md states about a surface ("routes under X touch
   only Y," "module A never imports B") — check it against the artifact that proves it:
   `[PROJECT-SPECIFIC: the API spec, the import graph, the route table]`.
8. **PRD citations** — every `PRD §N` and phase number cited in code must exist in
   `.agents/PRD.md`.
9. **Skills** — `.claude/skills/` against CLAUDE.md's list, both ways.
10. **Settings** — `.env.example` against `[PROJECT-SPECIFIC: the settings/config module]`,
    both ways.

## Don't

- **Don't delete a half-built doc.** One half shipped and the other did not is the normal
  case; re-status it naming both.
- **Don't delete plans.** `/piv-loop:review-plan-code` runs after execution and needs the
  plan. Report a shipped plan as a candidate and let the operator decide.
- **Don't review writing quality.** You check whether a statement is still true, not whether it
  reads well.
- **Don't check generated artifacts themselves.** `[PROJECT-SPECIFIC: artifacts CI already
  keeps in sync with the code — an API spec, a schema snapshot.]` You check what the docs
  *say about* them.

## Report

Group by finding type. For each: the file and line, the claim, the check that disproved it,
and one of — DELETE · RE-STATUS (give the new line) · MERGE (name the partner) · FIX POINTER
(name the right target). Mark deletions recoverable or not. Clean tree? Say so.

Change files only if asked. Before deleting any doc, find where each decision it carries also
lives — a docstring, CLAUDE.md, the PRD, a sibling — and name it. If a decision lives only
there, move it first.

## Done when

- Every `.agents/` doc is either current or has a finding with a fix.
- Every citation tag in the code is in range and on target.
- Every finding names the check that produced it.
- No deletion drops a decision that exists nowhere else.
