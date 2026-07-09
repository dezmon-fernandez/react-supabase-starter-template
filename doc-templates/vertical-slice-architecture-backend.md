# Vertical Slice Architecture — Backend

> Base template — specialize for target stack. Replace `[STACK-SPECIFIC]` sections.

Scope: backend services and data engines — systems whose features share a persistent store and expose entry points (CLI commands, jobs, API routes). For frontend/fullstack apps, read `vertical-slice-architecture.md` — it defines the feature-composition import model those apps use; the boundary rules below assume slices integrate through the schema instead.

## The Core Rule: Directories Are Capabilities, Never Stages

A stage is where data flows; a slice is where code lives. Name folders for what the system does, never for the pipeline step they perform. The tree is the system's mental model — `features/` alone should tell a reader what the service does.

Two shapes are banned:

1. **Stage-named top-level directories** (`sources/`, `handlers/`, `processors/`, `store/`, `api/` as horizontal layers) — one feature ends up smeared across all of them, and adding one capability touches every layer.
2. **A query/repository module shared across slices** — it becomes an unowned god-file every task threads through.

## Layout: A Shared Kernel Under Feature Slices

```
migrations/                 schema — source of truth
src/<service>/
  kernel/                   infrastructure ONLY
    config.*                environment / settings
    db.*                    engine/connection + generic write helpers (e.g. idempotent upsert)
    rows.*                  row/record models mirroring the schema, one per table
    contracts.*             cross-cutting interfaces that slices implement
    clients/                read-only external API clients (fetch; never write the store)
    tests/
  features/
    <capability_a>/
      <logic>.*             the slice's decisions and transformations
      queries.*             every read/write this slice performs against the store
      tests/
    <capability_b>/
      ...
```

### Kernel: infrastructure only

What belongs: config, database engine + generic write helpers, row models mirroring the schema, pure domain functions with exactly one correct implementation, read-only external API clients, cross-cutting contracts.

The litmus: anything that **decides, fetches-and-writes, or serves an operator command** belongs in a slice. A kernel that accretes feature logic becomes a god-layer.

### Feature slices

Each `features/<capability>/` owns its logic modules, its `queries` module, its entry points, and its co-located `tests/`. Registration is one entry in one registry, made in the same change — an entry point without a registry entry is an unfinished feature.

[STACK-SPECIFIC: the registry — script/entry-point table, route table, or DI container.]

## Slice Boundaries

- A slice's production code imports **only the kernel and its own slice**. Zero cross-slice imports.
- **Readers own their reads.** To read a table another slice writes, write the query in your own `queries` module. The schema (migrations + the kernel's row models) is the contract between slices — queries against shared tables are the integration point, not imports.
- Tests may import another slice's writers to seed scenarios; production code may not.

## Enforcement

Conventions rot without it. Use all three rungs:

1. **Rules teach.** The project rules file states the layout and "to add X, copy Y."
2. **Linters enforce.** An import-boundary linter fails the build on any cross-slice import: the kernel never imports a slice, and no slice imports another. [STACK-SPECIFIC: import-linter (Python), dependency-cruiser or eslint-plugin-boundaries (JS/TS); where the contracts live.]
3. **Structure prevents.** A module that never imports a dependency cannot misuse it. Scoping a task to one slice makes out-of-bounds edits impossible, not merely discouraged.

**Definition of done, task-agnostic:** lint, format check, import contracts, typecheck, and tests all pass before any task is complete. [STACK-SPECIFIC: the exact commands.]

## Copy the Sibling

- Keep a **named canonical skeleton** per slice kind: the rules file points at one exemplary file — "a new collector copies `features/<x>/<file>`."
- Siblings share an identical file set, ordering, and naming, so the nearest neighbor is a reliable template.
- The metric: **adding the Nth thing is copying the (N−1)th.** A developer or agent then needs one neighbor plus the interface in context — never the whole system.

## The Extraction Litmus

Extract only what has one right answer; policy stays inline in its slice.

- Safe to share: code with a single correct behavior — payload parsing for one feed, identity resolution, one piece of math.
- Never shared: what a slice decides or an operator tunes — thresholds, window filters, failure-containment granularity.
- The test is the name: an extraction must carry a **domain name with one meaning**. If it needs a framework name (`runner`, `handler`, `BaseX`), it is abstracting over deliberate differences — keep the copies. Visible duplication reads better than a shared abstraction over deliberate differences.
- Sharing follows the three-feature rule (`vertical-slice-architecture.md` defines the process): first instance inline, second duplicated, third extracted.

## Readability Floor

- **Variable names are never abbreviated.** Loop and comprehension bindings are as much a part of the interface as a function's parameters. A short name saves the writer keystrokes and costs every future reader a lookup.
- **No comment needs another document open to make sense.** State the reasoning in full, in place. A citation (ticket number, plan section, migration number) never stands in for the explanation — references dangle when the target renumbers or disappears.
- **Layout is formatter-enforced**, and the format check is part of the done gate — no hand-negotiated style.

## Refactor Discipline

A structural refactor ships with behavior-preservation proof:

- test-function count identical before and after,
- functions relocated verbatim,
- public entry-point names stable,
- full done gate green.

Prove invariance; never assert it.

## Testing

- Tests live with their slice: `features/<slice>/tests/`, `kernel/tests/`.
- **Pure halves** (parsing, logic — no I/O) run without a database and stay fast.
- **Integration halves** are marked and run against an isolated test database; the suite skips them when the database is absent. [STACK-SPECIFIC: the marker and fixture.]

## [STACK-SPECIFIC] Project Structure

> Replace with the actual tree for this stack.

## [STACK-SPECIFIC] Slice Skeleton

> Replace with the files a slice contains in this stack, naming the canonical sibling to copy.
