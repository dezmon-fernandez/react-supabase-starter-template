# Authoring for agents

How to author a document a generative AI will read and act on — a plan, roadmap, workflow command,
or standard; anything that specifies or instructs. Not working text (chat, scratch notes, commit
discussion), which keeps a working voice.

## What it carries

**Grounded and self-contained.** The reader acts from this document and the sources it names, nothing
more. Carry the context the task needs; for anything external, name it with what it gives — "read X
for the error-handling pattern step 3 mirrors," never "see X." A pointer without a reason is a
breadcrumb the reader has to chase.

**Structured.** Predictable, named sections in the same shape every time. An empty section is a
visible gap, to author and reader both — it turns "did I cover everything?" into "is every section
filled?" and tells the reader where to look.

**Verifiable.** State how the reader knows they succeeded: observable conditions and the commands or
tests that confirm them. A document an agent works from needs a defined "done," not a sense of one.

## How it reads

**No inherited context.** Leave out prior versions, past decisions, and how the document came to be.
Include a fact only when it changes what the reader does — then state the fact, not the history.

**Instruct; never differentiate.** Write every line for a reader who has only this document — not the
sibling it varies, the version it replaces, or the session that produced it. A sentence that
positions the document against an alternative ("no separate X," "unlike Y," "instead of the old
way") encodes design history the reader can't see — cut it and state the rule it was arguing for.
Likewise, examples lifted from the authoring session narrow the rule to the case just seen — state
the litmus they point at, keeping at most one example chosen to teach.

**Show structure; don't describe it.** A template teaches by shape: skeleton fields, labeled lists,
and fill-in bullets the reader completes. A prose paragraph specifying what a section "should
contain" is a description of structure that forces the reader to invent the structure — replace it
with the skeleton itself.

**No self-narration.** The document never describes its own standing — concise, authoritative,
canonical, the source of truth. A document that calls itself self-contained has, in that sentence,
reached outside itself. State the content; let it stand.

**Authority by demonstration.** It reads as truth because every line is specific, necessary, and
justified — not because it claims to be. Replace "this is the right approach because…" with the
instruction itself.

## Smell test

- Does any sentence describe the document rather than do its job?
- Does any sentence compare the document to a sibling, a prior version, or the conversation that
  produced it?
- Does any placeholder describe in prose a structure it could show as a skeleton?
- Does any reference lack the reason it's there?
- Could the reader act without chasing something the document names but doesn't carry?
- Is any rationale present because of how the work happened, not because it changes what to do?
- Is "done" defined — can the reader check their own success?

Each failure is a cut or a rewrite.

## Worked examples

Each pair is a before and an after.

**Cutting a rationale section.** A section existed to argue why slices should be small:

> ## Why granular (the keystone)
> A too-big slice forces a wall-of-a-plan and bundles many architecture decisions into one coarse
> approve-gate ("the data modeling felt decided for me").

Cut. The principle now appears once, in the Mission, as an operating rule:

> Each slice is a single unit of work: one architecture decision to make, small enough to plan and
> implement in one session, large enough to ship and stand on its own.

The reader needs the rule, not its biography.

**Replacing an essay with the instruction it circled.** A reviewer command opened by arguing for its
own method:

> ## Why this works (don't skip the framing)
> The executor that wrote the code is anchored — it shares the blind spots that produced any gap and
> rationalizes its own choices. You don't…

Became:

> Judge the code against the plan and the codebase, never against the implementer's account of what
> it did.

**Giving a reference its reason.** "Read the plan" became:

> Read the plan's contract, acceptance criteria, behavioral rules, and edge-case table. Extract them
> as a flat list of conditions the code must meet — this list is what you verify against.
