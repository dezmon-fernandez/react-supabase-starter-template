---
description: "Review an implementation against its plan — confirm every part of the contract is met and tested, and find the cases the plan missed"
argument-hint: [path-to-plan] [diff or paths implemented]
---

# Review plan and code

## Inputs: $ARGUMENTS

The first argument is the plan — the contract the code was built to satisfy. The rest is the code or
diff implemented from it. Judge the code against the plan and the codebase, never against the
implementer's account of what it did.

## Mission

Answer two questions, independently:

1. **Does the code satisfy the plan?** Every acceptance criterion, behavioral rule, and edge case the
   plan specifies is implemented and tested.
2. **What did the plan miss?** Cases the code must handle that the plan never named.

A case the plan failed to name is the more valuable find — it exposes a gap in the plan, not just
the code.

## Process

### 1. Load the contract

Extract every condition the code must meet — surfaces and their semantics, data shapes, invariants,
edge cases, acceptance criteria — from wherever the plan states them, into one flat list. This list
is what you verify against.

### 2. Read the implementation

Read the changed code and its tests. For each condition, locate where the code satisfies it and the
test that exercises it.

### 3. Pass 1 — Conformance

For every condition: is it implemented, and is there a test that proves it? Cite the evidence
(`file:line`). A condition with no test fails the pass. Confirm every path of each public method has a
test.

### 4. Pass 2 — Completeness

Read the public surfaces for cases the plan did not name but the code must handle — boundaries, empty
or malformed input, error and ordering paths, domain rules implied but unstated. Each one you find is
a hole in the plan.

### 5. Coordinate-leakage sweep

Read the diff's identifiers, comments, docstrings, and test names as a stranger holding the repo at
HEAD, every planning doc deleted. Anything that needs the plan, a roadmap, or the chat open to make
sense is leaked tribal knowledge — a test named for a spec row instead of the behavior it pins, a
comment citing a coordinate instead of stating its reason. A durable citation that follows an inline
reason (PRD §, a migration) is sanctioned; flag one only when it stands alone. A leak is a **code
defect**; when the plan instructed the leaked name, it is also a **plan gap**.

### 6. Classify each finding

- **Met** — satisfied and tested.
- **Code defect** — the plan was clear; the code does not satisfy it. The fix is in the code.
- **Plan gap** — the code is reasonable; the plan was silent or ambiguous. The fix is in the plan.
- **Standard gap** — a recurring miss with no convention governing it. The fix is in the coding
  standards.

A code defect is corrected against this slice. A plan gap or standard gap is corrected at its source,
so the next slice does not reproduce it. You report; the operator decides what merges.

## Output

```markdown
## Conformance
| Contract condition | Implemented | Tested | Evidence (file:line) | Finding |
|---|---|---|---|---|
| <condition> | yes/no | yes/no | <where> | met / code defect |
| input maps to a typed result | yes | yes | path/to/file:NN | met |
| empty input rejected | no | no | — | code defect |

Every public-method path tested: <yes, or the untested paths>

## Cases the plan missed
- <case> — what breaks without it — <plan gap | standard gap>
- unbounded input — OOM on a payload the plan never bounded — plan gap

## Verdict
- **Pass**, or **changes needed**.
- Code to fix: <list, or none>.
- Plan or standards to update: <list, or none>.
```

## Quality criteria

- [ ] Every contract condition is checked and carries file:line evidence.
- [ ] Every public-method path is confirmed tested.
- [ ] Unenumerated cases are actively searched for, not just the listed ones verified.
- [ ] The diff was swept for planning-coordinate leakage in identifiers, comments, docstrings, and test names.
- [ ] Each finding is classified so its fix routes to the code, the plan, or the standards.

## Report

- Pass or changes-needed, with counts: met, code defects, plan gaps, standard gaps.
- The single most important finding.
- What to route back to the plan or the coding standards.
