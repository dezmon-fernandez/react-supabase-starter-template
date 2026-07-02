---
description: "Create a comprehensive feature plan whose contract lives inside the implementation phases — data shapes in Foundation, surfaces and behavior in Core Logic, edge cases as the validation test list. Directive: pseudocode and specs, never literal code"
---

# Plan a new task

## Feature: $ARGUMENTS

## Mission

Transform a feature request into a **comprehensive implementation plan** through systematic codebase analysis, external research, and strategic planning.

**Core Principle**: We do NOT write code in this phase. Our goal is a context-rich implementation plan that enables one-pass implementation success for ai agents. The plan specifies contract and approach — signatures, types, data models, behavioral rules, edge cases — with the HOW sketched in pseudocode. **Litmus**: if the implementer could paste it and be done, it's code — back off to pseudocode.

**One Home Per Fact**: The contract lives inside the implementation phases — each fact stated once, in the phase that delivers it: data shapes in Foundation, call semantics beside the logic that implements them, edge cases as the validation test list. Every line holds its weight: if a line can be removed and its message is still communicated elsewhere, it doesn't belong.

**Two Readers**: The plan serves the implementation agent, which needs exhaustive detail, and the human approver, who needs to weigh the decisions — so the decisions come first (KEY DECISIONS) and the detail sits below them. Write conclusions, never deliberation: the weighing happened in this session; the plan records what was chosen and why. Litmus: a passage that poses a question and then answers it keeps the answer and loses the question. Any name the plan instructs into code — a test name, a docstring, a comment — is behavior-named and self-contained: plan-internal labels and roadmap coordinates die with this document, which is deleted at merge.

**Key Philosophy**: Context is King. The plan must contain ALL information needed for implementation - patterns, mandatory reading, documentation, the contract, a pseudocode implementation plan, and validation commands - so the execution agent succeeds on the first attempt.

## Planning Process

### Phase 1: Feature Understanding

**Deep Feature Analysis:**

- Extract the core problem being solved
- Identify user value and business impact
- Determine feature type: New Capability/Enhancement/Refactor/Bug Fix
- Assess complexity: Low/Medium/High
- Map affected systems and components

**Create User Story Format Or Refine If Story Was Provided By The User:**

```
As a <type of user>
I want to <action/goal>
So that <benefit/value>
```

### Phase 2: Codebase Intelligence Gathering

**Use specialized agents and parallel analysis:**

**1. Project Structure Analysis**

- Detect primary language(s), frameworks, and runtime versions
- Map directory structure and architectural patterns
- Identify service/component boundaries and integration points
- Locate configuration files (pyproject.toml, package.json, etc.)
- Find environment setup and build processes

**2. Pattern Recognition** (Use specialized subagents when beneficial)

- Search for similar implementations in codebase
- Identify coding conventions:
  - Naming patterns (CamelCase, snake_case, kebab-case)
  - File organization and module structure
  - Error handling approaches
  - Logging patterns and standards
- Extract common patterns for the feature's domain
- Document anti-patterns to avoid
- Check CLAUDE.md for project-specific rules and conventions

**3. Dependency Analysis**

- Catalog external libraries relevant to feature
- Understand how libraries are integrated (check imports, configs)
- Find relevant documentation in docs/, ai_docs/, .agents/reference or ai-wiki if available
- Note library versions and compatibility requirements

**4. Testing Patterns**

- Identify test framework and structure (pytest, jest, etc.)
- Find similar test examples for reference
- Understand test organization (unit vs integration)
- Note coverage requirements and testing standards

**5. Integration Points**

- Identify existing files that need updates
- Determine new files that need creation and their locations
- Map router/API registration patterns
- Understand database/model patterns if applicable
- Identify authentication/authorization patterns if relevant

**Clarify Ambiguities:**

- If requirements are unclear at this point, ask the user to clarify before you continue
- Get specific implementation preferences (libraries, approaches, patterns)
- Resolve architectural decisions before proceeding

### Phase 3: External Research & Documentation

**Use specialized subagents when beneficial for external research:**

**Documentation Gathering:**

- Research latest library versions and best practices
- Find official documentation with specific section anchors
- Locate implementation examples and tutorials
- Identify common gotchas and known issues
- Check for breaking changes and migration guides

**Technology Trends:**

- Research current best practices for the technology stack
- Find relevant blog posts, guides, or case studies
- Identify performance optimization patterns
- Document security considerations

**Compile Research References:**

```markdown
## Relevant Documentation

- [Library Official Docs](https://example.com/docs#section)
  - Specific feature implementation guide
  - Why: Needed for X functionality
- [Framework Guide](https://example.com/guide#integration)
  - Integration patterns section
  - Why: Shows how to connect components
```

### Phase 4: Deep Strategic Thinking

**Think Harder About:**

- How does this feature fit into the existing architecture?
- What are the critical dependencies and order of operations?
- What could go wrong? (Edge cases, race conditions, errors)
- How will this be tested comprehensively?
- What performance implications exist?
- Are there security considerations?
- How maintainable is this approach?

**Design Decisions:**

- Choose between alternative approaches with clear rationale
- Design for extensibility and future modifications
- Plan for backward compatibility if needed
- Consider scalability implications

### Phase 5: Plan Structure Generation

**Create the plan with the following structure:**

Whats below here is a template for you to fill for the implementation agent. State each fact once, in the phase that delivers it. Task lines use the action keywords CREATE / UPDATE / ADD / REMOVE / REFACTOR / MIRROR. It contains no literal, paste-ready code.

```markdown
# Feature: <feature-name>

The following plan should be complete, but its important that you validate documentation and codebase patterns and task sanity before you start implementing.

Pay special attention to naming of existing utils types and models. Import from the right files etc.

## Feature Description

<Detailed description of the feature, its purpose, and value to users>

## User Story

As a <type of user>
I want to <action/goal>
So that <benefit/value>

## Problem Statement

<Clearly define the specific problem or opportunity this feature addresses>

## Solution Statement

<Describe the proposed solution approach and how it solves the problem>

## Feature Metadata

**Feature Type**: [New Capability/Enhancement/Refactor/Bug Fix]
**Estimated Complexity**: [Low/Medium/High]
**Primary Systems Affected**: [List of main components/services]
**Dependencies**: [External libraries or services required]

## KEY DECISIONS (approve these)

<The approval surface — every architecture decision this plan makes, one line each: what was chosen,
over what alternative, and the phase below that delivers it. A well-cut slice carries ONE primary
decision; list tactical ones after it. Rationale longer than a line goes in NOTES — point to it.>

1. <decision> — over <rejected alternative> — delivered in <phase>

---

## CONTEXT REFERENCES

### Relevant Codebase Files IMPORTANT: YOU MUST READ THESE FILES BEFORE IMPLEMENTING!

<List files with line numbers and relevance>

- `path/to/file.py` (lines 15-45) - Why: Contains pattern for X that we'll mirror
- `path/to/test.py` - Why: Test pattern example

### New Files to Create

- `path/to/new_service.py` - Service implementation for X functionality

### Relevant Documentation YOU SHOULD READ THESE BEFORE IMPLEMENTING!

- [Documentation Link 1](https://example.com/doc1#section)
  - Specific section: Authentication setup
  - Why: Required for implementing secure endpoints

### Patterns to Follow

<Specific conventions extracted from the codebase to mirror — include short idiom examples from the project. These are conventions to follow, not this feature's implementation.>

---

## IMPLEMENTATION PLAN

<The build, in dependency order — each fact defined once, in the phase that delivers it>

Every task uses this shape:

### {ACTION} {target_file}

- **CONTRACT**: {what becomes observably true}
- **APPROACH**: {pseudocode — the algorithm's shape, no literal code}
- **PATTERN**: {file:line to mirror}
- **GOTCHA**: {constraints to avoid}
- **VALIDATE**: `{executable command}`

### Phase 1: Foundation — data & shapes

<Describe the foundational data work needed before main implementation>

**Shapes (declared once, here — later phases reference, never redefine):**

- `<Type/Model>` — <field: type + constraint + meaning, per field>
- `<optional field>` — <what None means>
- `<key / schema-enforced rule>`

**Tasks:**

- Define schemas, types, and models
- Write the migrations or config those shapes require

### Phase 2: Core Logic — surfaces & behavior

<Describe the main implementation work; pseudocode the core logic>

**Invariants (cross-surface, one line each, observable by a test):**

- <ordering / idempotency / isolation rule>

**Surfaces (defined beside the logic that implements them):**

- `<name(typed inputs) -> typed return>` — <what the value means; a `bool`: when True, when False;
  an optional: what None means; error behavior>

**Tasks:**

- Implement core business logic (pseudocode the algorithm; no literal code)
- Build each surface against the shapes from Foundation

### Phase 3: Integration — wiring

<Describe how the feature connects to existing functionality>

**Tasks:**

- Register components, routes, or entry points
- Connect callers and update configuration

### Phase 4: Validation — edge cases are the test list

<List every path of every public surface — boundaries, missing/empty/malformed input, error paths>

**Test list (each line becomes a test named for the behavior it pins):**

- `<surface>`: <condition> → <required behavior>

**Validation commands (run every one, in order):**

- `<lint>`
- `<type-check>`
- `<unit tests>`
- `<integration tests>`
- `<manual probe>`

---

## ACCEPTANCE CRITERIA

<Specific, observable criteria that must be met for completion — each traceable to a phase>

- [ ] <criterion>

## NOTES

<The "Why X (decision)" paragraphs backing each KEY DECISIONS entry that needs more than its one
line; trade-offs; anything the implementer needs that fits nowhere above.>
```

## Output Format

**Filename**: `.agents/plans/{kebab-case-descriptive-name}.md`

- Replace `{kebab-case-descriptive-name}` with short, descriptive feature name
- Examples: `add-user-authentication.md`, `implement-search-api.md`, `refactor-database-layer.md`

**Directory**: Create `.agents/plans/` if it doesn't exist

## Quality Criteria

- [ ] KEY DECISIONS lists every architecture decision, one line each, ahead of the detail
- [ ] Each contract fact appears exactly once, in the phase that delivers it
- [ ] Every `bool`/optional surface states its truth/None conditions
- [ ] Every edge-case line has a behavior-named test; no minted row IDs anywhere
- [ ] Conclusions only — no passage weighs an alternative, poses a question, or walks one back
- [ ] One idea per line; enumerable facts (surfaces, vocabularies, edge cases) are lists or tables, not prose
- [ ] Every line holds weight — nothing can be cut without losing information
- [ ] Another developer could implement from the plan + referenced files alone
- [ ] Tasks ordered by dependency, each atomic with an executable VALIDATE command
- [ ] Pattern references include specific file:line numbers
- [ ] No literal, paste-ready code anywhere

## Report

After creating the Plan, provide:

- Summary of feature and approach
- Full path to created Plan file
- Complexity assessment
- Key implementation risks or considerations
- Estimated confidence score for one-pass success
