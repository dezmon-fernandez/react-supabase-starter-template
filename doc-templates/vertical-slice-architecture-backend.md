# Vertical Slice Architecture — Backend

> Base template — specialize for target stack. Replace `[STACK-SPECIFIC]` sections.

Scope: backend services — APIs, workers, data pipelines. For frontend/fullstack apps, read `vertical-slice-architecture.md`, which defines the feature-composition model those apps use.

## Why Slices

An agent (or developer) working on one feature should load one folder and have the full picture: the routes, the logic, the models, the errors, and the tests. Organize by layer instead and every feature is smeared across the tree — each task starts with an exploration tax, and each change ripples through folders the task never mentioned.

## The Core Rule: Organize by Capability, Never by Layer or Stage

A layer is *how* code executes; a stage is *where data flows*; a slice is *what the system does*. Name folders for capabilities. The tree is the system's mental model — `features/` alone should tell a reader what the service does.

Two shapes are banned:

1. **Layer- or stage-named top-level directories** (`controllers/`, `services/`, `models/`, `repositories/`, `sources/`, `processors/` as the organizing principle) — one feature ends up spread across all of them.
2. **A data-access or utility god-module shared by every feature** — it becomes an unowned file that every task threads through and no slice is responsible for.

## What a Slice Owns

Every property below is a rule for writing new code, and together they are the definition of done for a slice. `[STACK-SPECIFIC: map each artifact to this stack's file names.]`

| # | Property | The rule | Why it matters to an agent |
|---|----------|----------|---------------------------|
| 1 | Own folder | All the feature's code lives under one folder | One read loads everything; deleting the feature = deleting one folder |
| 2 | Local models | The feature's domain/persistence models live in the slice | The data shape is visible next to the logic that uses it |
| 3 | Local schemas | Request/response validation lives in the slice | The boundary contract is visible where it's enforced |
| 4 | Local entry points | Routes / CLI commands / job definitions live in (or register from) the slice | The way in is discoverable from the slice itself |
| 5 | Local business logic | The substance lives in the slice's service/logic module, not in `utils/` or `lib/` | The decision-making code is where the feature is |
| 6 | Local errors | Feature-specific error types live in the slice | An error is defined next to the code that raises it |
| 7 | Colocated tests | `tests/` sits inside the slice | Modifying the feature surfaces its tests without a separate search |
| 8 | Explicit public API | One index/barrel module controls what the slice exports | Consumers know what's supported; everything else is internal |
| 9 | Internals stay internal | Helpers not in the public API are never imported from outside | Refactoring inside a slice can't break other slices |
| 10 | Minimal cross-slice coupling | The slice imports from as few other slices as possible, always via their public API | Changes don't ripple; the agent can plan, implement, and validate inside one slice |

Cohesion beats line count: a long, cohesive logic module is healthier than a short one that reaches into many other slices. Judge a slice by rule 10, not by file size.

Not every slice needs every artifact — start with the minimum and add files as the feature grows. What it does have must live in the slice.

## Core: Infrastructure Only

`core/` (or `kernel/`, `lib/`) holds what exists before any feature: config, database/client setup, logging, middleware, base error types, cross-cutting contracts, external service clients.

The litmus: anything that **makes a feature-level decision** belongs in a slice. A core that accretes feature logic becomes a god-layer — the layered architecture reborn under a different name.

## Shared: What Stays Out of Slices

Keep shared and small:

- Cross-cutting concerns: auth middleware, logging, request correlation.
- Database connection / session management.
- Framework setup itself.
- Domain-free utilities (date helpers, string formatting).

Everything else follows the three-feature rule (`vertical-slice-architecture.md` defines the process): first instance inline in its slice, second duplicated, third extracted to shared.

## Cross-Slice Dependencies

- **Read** from another slice only through its public API (rule 8) — never reach into its internals.
- **Write** to another slice's data only by calling that slice's public API — the owning slice stays the only writer of its data.
- Keep the dependency count low (rule 10). If a slice needs many others, its boundary is drawn wrong — redraw the slice, don't add imports.
- `[STACK-SPECIFIC: some services integrate slices through the shared persistence schema instead of imports (each slice queries shared tables itself, and slice-to-slice imports are banned entirely). State which contract this stack uses.]`

## Writing New Code in a Sliced Codebase

- **A new capability is a new slice.** Never a new file in a layer folder, never a new case in a shared module.
- **Copy the sibling.** Before writing, find the nearest existing slice of the same kind and mirror its skeleton — same file set, same ordering, same naming. The rules file names one canonical exemplar per slice kind; keep siblings symmetric so the nearest neighbor is always a reliable template. The target: **adding the Nth thing is copying the (N−1)th.**
- **Register in the same change.** A slice's entry point gets its registry entry (route table, script registry, DI container) in the change that creates it — an unregistered entry point is an unfinished feature. `[STACK-SPECIFIC: the registry.]`
- **Extract only what has one right answer.** Policy — thresholds, filters, anything a feature decides or an operator tunes — stays inline in its slice. The test is the name: an extraction must carry a domain name with one meaning; if it needs a framework name (`runner`, `handler`, `BaseX`), it is abstracting over deliberate differences — keep the copies.

## Enforcement

Conventions rot without it. Use all three rungs:

1. **Rules teach.** The project rules file states the layout and names the canonical sibling to copy.
2. **Linters enforce.** An import-boundary linter fails the build when core imports a slice, or a slice imports another slice's internals. `[STACK-SPECIFIC: import-linter (Python), dependency-cruiser or eslint-plugin-boundaries (JS/TS); where the contracts live.]`
3. **Structure prevents.** A module that never imports a dependency cannot misuse it — the boundaries make out-of-scope edits impossible, not merely discouraged.

**Definition of done, task-agnostic:** lint, format check, import-boundary check, typecheck, and tests all pass before any task is complete. `[STACK-SPECIFIC: the exact commands.]`

## Slice Self-Check

A slice is done when every row in the What a Slice Owns table passes for it — cite the file that satisfies each row. A row that can't be cited is the next thing to fix.

## [STACK-SPECIFIC] Project Structure

> Replace with the actual tree for this stack.

## [STACK-SPECIFIC] Slice Skeleton

> Replace with the files a slice contains in this stack, naming the canonical sibling to copy.
