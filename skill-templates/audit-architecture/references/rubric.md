# Audit Rubric — The Six Dimensions

Score each dimension **Strong / Partial / Weak**. Every rating must cite real file paths.

| # | Dimension | The question it answers |
|---|-----------|-------------------------|
| 1 | Seams at the axes of variation | Does what-varies sit behind a narrow interface with a stable core? |
| 2 | Vertical-slice locality | Is a feature's code *together*, or smeared across horizontal layers? |
| 3 | Copy-the-sibling symmetry | Is there an obvious nearest neighbor to copy, with an identical skeleton? |
| 4 | Open config vs edit-everywhere | Can you extend by adding a field/entry, or must you edit N places? |
| 5 | Agent context locality | To add a thing, how much must an agent load — one neighbor or the whole system? |
| 6 | The discipline layer | Do rules + linters keep the patterns from rotting? |

**Scoring guide:** Strong = an agent could add the next item by copying one neighbor with high
confidence. Partial = the pattern exists but is inconsistent or undocumented. Weak = no pattern; the
agent must understand a lot of the system to add anything.

**Pick the representative axis first.** Find the kind of thing this codebase adds most often
(endpoints, components, integrations, providers, model types, jobs, data models). Trace dimensions
1–5 through it — that is where "copy the sibling" either works or doesn't.

---

## 1. Seams at the axes of variation

The thing that changes most should live behind one narrow contract; the core that orchestrates it
should not change when you add a variant.

**Strong signals:** a named interface/protocol/abstract base or a dispatch registry at the variation
point; the core depends on the abstraction, not concretes; adding a variant doesn't touch the core.
**Weak signals:** `if type == ...` / `switch(provider)` ladders repeated in many files; the core
imports concrete implementations directly; new variant = edits scattered across the core.

**Example finding:** *"`services/notifier.ts` has a 7-case `switch(channel)` repeated in 3 files. The
channel is the axis of variation but there's no `Notifier` interface — adding Slack means editing all
three. Opportunity (seam): extract a `Notifier` interface with one impl per channel; the dispatcher
picks by key."*

## 2. Vertical-slice locality

A feature's code should be co-located (one folder/module owns it end to end), not spread across
horizontal layers (`controllers/`, `services/`, `models/`, `dtos/`) where one feature touches four
directories.

**Strong signals:** feature/domain folders each containing their own route + logic + types + tests;
you can delete a feature by deleting one folder. **Weak signals:** strictly horizontal top-level
layering; adding one feature requires creating files in 4+ sibling layers; high `ls`/file-jump count
to understand one feature.

**Example finding:** *"A new endpoint requires edits in `routes/`, `controllers/`, `services/`,
`repositories/`, and `dto/` — five directories for one feature. An agent must load all five to add
one. Opportunity: group by feature (`features/orders/{route,handler,types,test}`) so the next
endpoint is one folder to copy. (Bigger bet — refactor.)"*

## 3. Copy-the-sibling symmetry

Siblings on the main axis should share an identical skeleton — same files, same order, same naming —
so the nearest neighbor is a reliable template.

**Strong signals:** every sibling folder has the same file set (`x.ts`, `config.ts`, `index.ts`,
`x.test.ts`); consistent naming; registration is one line in one place. **Weak signals:** siblings
diverge (some have tests, some don't; different file layouts); inconsistent names; no clear "closest
example" to copy.

**Example finding:** *"`integrations/stripe/` has `client.ts + types.ts + webhook.ts + test`, but
`integrations/twilio/` is a single 600-line `index.ts`. There's no canonical skeleton, so an agent
has no reliable sibling to copy. Opportunity (open config + convention): pick the cleanest slice as
the template, align the others, document the skeleton in `CLAUDE.md`."*

## 4. Open config vs edit-everywhere

Capabilities/options should be addable as a field or registry entry that everything already reads —
not by editing every implementation.

**Strong signals:** a shared schema/base type that variants extend; a registry/map where one entry
wires a new thing; capability flags so consumers tolerate unknown options. **Weak signals:** adding
an option means editing every provider/handler; parallel enums/lists that must be kept in sync by
hand; copy-pasted option handling.

**Example finding:** *"Adding a per-request option (e.g., `timeout`) requires editing all 5 providers.
Opportunity (open config): hoist options onto a shared base config the runtime reads once; providers
opt in via a capability flag instead of each re-implementing it."*

## 5. Agent context locality

Estimate the blast radius of "add one item on the main axis." The smaller and more local, the better
the codebase is as a prompt.

**Strong signals:** add = create one folder + one registration line; the agent needs ~one neighbor +
the interface. **Weak signals:** add touches many distant files; hidden cross-file coupling; global
state or implicit wiring the agent can't see from the neighbor.

**Example finding:** *"To add a provider you edit the registry, a union type, a factory switch, an
env-var loader, and a docs page — 5 distant files an agent must discover. Opportunity: collapse wiring
to a single registration call co-located with the slice so the neighbor shows the whole move."*

## 6. The discipline layer (keeps it true)

Conventions rot without enforcement. Two channels: **rules** teach the pattern (the why); **linters /
fitness functions** enforce it (the law).

**Strong signals:** a `CLAUDE.md`/`AGENTS.md` that states the architecture and "to add X, do Y";
project skills/commands encoding procedures; import-boundary lint (eslint-plugin-boundaries,
dependency-cruiser, import-linter), typed schemas (Zod/pydantic), a `validate`/`lint`/`typecheck`
step in CI. **Weak signals:** no rules file or a stale one; no boundary enforcement; conventions live
only in people's heads.

**Example finding:** *"No `CLAUDE.md` and no import boundaries. Slice symmetry will drift the first
time someone's in a hurry. Opportunity (quick win): add a `CLAUDE.md` 'when adding a feature' section,
and a dependency-cruiser rule forbidding cross-feature imports — convention becomes enforced."*

---

## Turning observations into findings

Each finding in the report should carry:

- **Observation** — what you saw, with file paths.
- **Why it hurts** — the concrete cost to an agent adding the next thing (more context, more files,
  drift, easy to get wrong).
- **Opportunity** — the actionable change, labeled **seam** or **open config** (or **rule/lint** for
  the discipline layer).
- **Example to copy** — point at the best existing sibling/pattern in *their* repo when one exists.
- **Effort** — **S** (config/rule/lint/doc, hours), **M** (localized restructure), **L** (refactor).

Sort findings by leverage: highest agent-extensibility payoff for lowest effort first. Quick wins
(S) go in their own section; M/L and refactors are "bigger bets."
