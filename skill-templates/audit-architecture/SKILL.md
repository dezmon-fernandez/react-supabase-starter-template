---
name: audit-architecture
description: >-
  Audit a codebase for how easily an AI coding agent can keep EXTENDING it — "is this codebase a
  good prompt?" Scores six architecture dimensions (seams, vertical-slice locality, copy-the-sibling
  symmetry, open-config vs edit-everywhere, agent context locality, the discipline layer) and
  produces a prioritized report of actionable opportunities (quick wins + optional refactors).
  Use when the user wants an architecture / agent-extensibility / AI-readiness audit of a repo —
  triggers like "audit my architecture", "run an architecture audit", "is my repo agent-friendly?",
  "audit my codebase as a prompt", "where can I make this easier for AI agents to extend?",
  "review my architecture for AI coding". This is NOT a correctness/bug/security review — it judges
  how well the codebase serves as context for an agent adding the next feature. Language-agnostic.
---

# Audit Architecture

Audit a codebase against one question: **how good a prompt is it for an AI coding agent?**

The thesis: a system stays agent-workable when **adding the Nth thing is "copy the (N-1)th."** Then
the agent never needs the whole system in context — it needs one neighbor. This skill finds where a
codebase does and doesn't have that property, and gives concrete, actionable ways to improve it.

**Scope:** architecture & agent-extensibility only. Do NOT hunt for bugs, security holes, or perf
issues (other reviews do that). **Audit and suggest only — never edit code** unless the user
explicitly asks afterward.

## Two extension patterns to look for

Every healthy extension point is one of these (the audit names which one each opportunity is):

- **Seam** — a narrow interface/contract with swappable implementations behind it; extend by *writing
  a new implementation* (e.g., implement `IAdapter`, add a handler the dispatcher routes to).
- **Open config** — a field/entry on a *shared* schema or registry that everything already reads;
  extend by *adding data, not code* (e.g., add one field every type inherits, register in one line).

## Workflow

1. **Read `references/rubric.md` first.** It defines the six dimensions, the signals of strong vs weak
   for each, how to score, and example findings. The audit is only as good as faithful use of it.

2. **Explore the repo (gather evidence, don't guess).**
   - Map the top-level structure (languages, packages/modules, how folders are organized).
   - Identify the **representative axis of variation** — the kind of thing this codebase adds *most
     often* (e.g., API endpoints, UI components, integrations/connectors, model/provider types,
     workflow steps, data models). Most findings are sharpest when traced through this axis.
   - Find the actual siblings on that axis and open 2–3 of them side by side. Look for an interface
     or registry they share. Check for a rules file (`CLAUDE.md`/`AGENTS.md`/`.cursorrules`), and
     for linters / fitness functions (eslint boundaries, dependency-cruiser, import linters, typed
     schemas, a `validate`/`lint` script in CI).

3. **Score each of the six dimensions** (Strong / Partial / Weak) using `references/rubric.md`, citing
   real file paths as evidence for every judgment.

4. **Write the report** using `assets/report-template.md` (copy its structure). Default output path:
   `ARCHITECTURE-AUDIT.md` at the repo root (confirm or adjust with the user). The report must:
   - lead with a one-glance **scorecard** (dimension → rating → one-liner),
   - give **prioritized findings**, split into **Quick wins** (S effort) and **Bigger bets**
     (M/L, includes optional refactors),
   - make every finding actionable with: observation + file evidence → why it hurts agent
     extensibility → the opportunity → a concrete example sibling to copy / pattern to apply →
     suggested change (label it **seam** or **open config**) → effort (S/M/L),
   - be **honest about strengths**, not just gaps — call out what already makes it a good prompt.

## Rules

- Ground every finding in real files you actually read. No generic advice that could apply to any repo.
- Prefer the cheapest intervention that moves the needle: a `CLAUDE.md` rule or a lint boundary often
  beats a refactor. Suggest refactors only when the payoff is real, and mark them as bigger bets.
- Match advice to the stack you actually see (the patterns are universal; the mechanisms are not).
- Keep it concrete and kind — the goal is momentum, not a scolding.
