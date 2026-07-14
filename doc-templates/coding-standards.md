# Coding Standards

> This entire file should be specialized for the target stack. The sections below define the structure — replace all content with framework-specific conventions, examples, and rules during planning/execution. A Next.js template and a Python agent template will look completely different.

## [STACK-SPECIFIC] Naming Conventions

> Replace with the stack's actual naming conventions for files, directories, variables, functions, types, constants. Include a table mapping each code element to its convention with real examples from this stack.

## [STACK-SPECIFIC] Type System

> Replace with the stack's type system rules:
> - TypeScript: strict mode, no `any`, `z.infer`, explicit return types, `satisfies`
> - Python: type hints, mypy/pyright config, Pydantic models
> - Go: interface conventions, error returns
> Include the actual config (tsconfig, mypy settings, etc.) and real code examples.

## [STACK-SPECIFIC] Import / Module Conventions

> Replace with how this stack organizes imports:
> - Path aliases, import ordering
> - Named vs default exports
> - `type` imports (TypeScript)
> - Circular dependency prevention
> Include a real import block showing the conventions.

## Functions

These apply across all stacks:

- **Keep functions short.** ~30 lines max, extract a helper beyond that.
- **Single responsibility.** If the name has "and", split it.
- **Early returns** over nested conditionals. Guard clauses at the top.
- **Limit parameters to 3.** Use an options object / dataclass / struct for more.

[STACK-SPECIFIC: Add a before/after code example in this stack's language showing the early return pattern.]

## Module Organization: Stanzas

Within a module, group code by what changes together, never by what looks alike. A file serving many parallel features — a CLI's subcommands, a router's routes, an event map's handlers — reads as one identically-shaped block per feature (a *stanza*), over a short shared section holding only what two or more stanzas use. Never organize by layer (all parsers together, then all handlers): no real task is ever "change all the parsers" — every task is "change one feature," and layering splits that one task across the whole file.

The test: adding the next feature means copying one sibling stanza top to bottom. When that stops being true, the shape has drifted — fix the drift, don't invent a new organization.

## Components

These apply to UI stacks. Remove this section for non-UI stacks (agents, CLI tools, APIs).

- **One component per file** for anything non-trivial.
- **Props interfaces** defined in the same file, above the component.
- **Destructure props** in the function signature.
- **Handle all states**: loading, error, empty, success.
- **Colocate** — keep components near the feature that uses them, not in a global folder (except shared UI like shadcn).

[STACK-SPECIFIC: Component patterns for this framework — server vs client components, directive usage, lifecycle hooks, state management, rendering patterns. Include real code examples.]

## Comments

- **Comment the why, once.** Every invariant has ONE owning site — the module that enforces it — where the full reasoning lives. Every other site that touches the invariant states the constraint in one standalone sentence (naming the owning module is welcome), never re-derives it: prose has no CI, so each duplicated derivation is a copy that silently rots when the code changes.
- **Always keep:** external-world facts the code cannot express and tests cannot cheaply pin — vendor API quirks, billing/quota asymmetries, provider payload shapes. Deleting these loses knowledge that was paid for in incidents, credits, or debugging.
- **Cut on sight:** a comment restating the adjacent code or assert; a module docstring restating its functions' docstrings; prose re-deriving reasoning that already lives at the owning site or in a test that pins it; commented-out code (version control has history).
- **The one-sentence form still stands alone** — it states the constraint, never a bare citation. A plan task label, an edge-case row ID, a spec section number, or a migration number is not an explanation: those dangle the moment the doc is deleted or the numbering shifts. A trailing reference tag is permitted only *after* the constraint is stated, and only against a numbering the repo maintains as durable.
- **Scope: prose commentary only.** Imports, function calls, and a comment naming a sibling module because the pattern mirrors it are the codebase, not documentation — those are fine.

[STACK-SPECIFIC: TODO format, doc comment conventions (JSDoc, docstrings, GoDoc, etc.)]

## Dependencies

- **Pin exact versions** in templates. Users can loosen after scaffolding.
- **Minimize dependencies.** Before adding a package: can a 10-line utility do the job?
- **Audit before adding.** Check bundle size, maintenance status, community standard.

[STACK-SPECIFIC: Package manager conventions, lockfile handling, dependency grouping (runtime vs dev vs peer)]

## [STACK-SPECIFIC] Linting and Formatting

> Replace with the stack's linter/formatter config, auto-fix commands, and pre-commit hooks. Include the actual config file contents or key settings.

## [STACK-SPECIFIC] Framework-Specific Patterns

> Replace with patterns unique to this framework that don't fit elsewhere:
> - Data fetching conventions (server components, loaders, hooks, decorators)
> - Routing patterns
> - State management approach
> - Server/client boundaries
> - Build and bundling considerations
