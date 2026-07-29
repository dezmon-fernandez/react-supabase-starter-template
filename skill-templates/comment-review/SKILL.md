---
name: comment-review
description: >-
  Review code prose (comments + docstrings) against the repo's commenting standard: the
  Comments section of the coding standards ("Comment the why, once": one owning site per
  invariant, the always-keep and cut-on-sight lists, the citation rules) and the authoring
  standard for any .agents/ prose in the diff. Audits the working diff by default, or the
  files/paths passed as arguments. Reports violations with the exact rule each one breaks
  and the suggested rewrite; applies fixes only when asked ("fix them" / "--fix"). Use when
  asked to "review the comments", "run comment review", "check the prose", or before
  committing a change that added or reworked comments, docstrings, or .agents/ documents.
---

# comment-review — audit prose against the commenting standard

Judge every comment and docstring the change touches against the standards named below.
The standards are the source of truth — read them fresh each run and cite them per
finding; never enforce a rule from memory that the documents no longer state.

## The standards (read all that apply, in this order)

1. **The Comments section of `.agents/documentation/coding-standards.md`** — the commenting
   rule set: one owning site per invariant, one-sentence statements elsewhere, what to
   always keep and what to cut on sight, and the citation rules (no plan labels or
   edge-case ids; a reference tag only after the constraint is stated).
2. **`[PROJECT-SPECIFIC: the owning documents for domain facts]`** — a code comment
   carrying a domain fact must state it in one sentence and cite the owning document; a
   domain fact found in code but absent from its owning document is itself a finding
   (relocate, then cite).
3. **`.agents/documentation/authoring-for-agents.md`** — applies to any `.agents/` prose,
   skill, or CLAUDE.md text in the diff; run its smell test over those files.

## Procedure

1. **Scope.** No arguments → `git diff HEAD --name-only` plus untracked files, filtered
   to code files, `*.md`, and `.agents/` prose. Arguments → exactly those paths.
2. **Read each file's prose** and hold every comment/docstring to the earn-its-place
   test — it stays only if it states something the code cannot make obvious (an
   outside-world fact, or business logic critical to changing the code correctly):
   - Does it restate the adjacent code, or anything a competent reader gets from the
     code itself? → cut.
   - Does it compensate for an unclear name or a tangled block? → the finding is the
     code: propose the domain rename or restructure that makes the comment unnecessary.
   - Does it re-derive reasoning owned by another site, an owning document, or a test?
     → collapse to one sentence naming the owner.
   - Is it architecture guidance or domain reference living in code? → relocate to the
     owning document, leave a one-sentence statement with the citation.
   - Does a block run long? → usually over-explaining; the full account belongs in the
     owning document, one sentence here.
   - Is it an outside-world fact (vendor API quirk, billing rule, payload shape) with
     no owning document? → add it to the owning document — never delete it.
   - Does a bare citation stand in for a stated constraint? → write the sentence.
   Judge in both directions: missing prose is a finding too — a non-obvious constraint
   or critical business rule the change relies on but never states.
3. **Report.** One finding per violation: `file:line`, the rule broken (quote the
   standard's phrase), and the concrete rewrite (or "delete" / "add"). Order by file.
   If the scope is clean, say so.
4. **Fix only on request.** When the user asked for fixes in the same breath (e.g.
   "review and fix"), apply the rewrites and summarize what changed per file. Otherwise
   stop at the report — the diff's author decides.

## Done when

- Every in-scope file has a pass/finding verdict.
- Every finding cites the standard it breaks and carries an actionable rewrite.
- Zero outside-world facts were deleted (relocations name their destination).
