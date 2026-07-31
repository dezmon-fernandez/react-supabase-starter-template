# Authoring for agents

How to author a document a generative AI will read and act on — a plan, roadmap, workflow command,
or standard; anything that specifies or instructs. Not working text (chat, scratch notes, commit
discussion), which keeps a working voice.

## What it carries

**Grounded and self-contained.** The reader acts from this document and the sources it names, nothing
more. Carry the context the task needs. For anything external, name it with what it gives: "read X
for the error-handling pattern step 3 mirrors," not a bare "see X."

**Structured.** Predictable, named sections in the same shape every time. An empty section is a
visible gap, to author and reader both — it turns "did I cover everything?" into "is every section
filled?"

**Verifiable.** State how the reader knows they succeeded: observable conditions and the commands or
tests that confirm them.

## How it reads

**No inherited context.** Leave out prior versions, past decisions, and how the document came to be.
Include a fact only when it changes what the reader does — then state the fact, not the history.

**The far reader.** Write to a junior engineer opening the document cold, months after it was
written: no session memory, no adjacent conversation, no shared shorthand. Choose plain, concrete
terms over abstraction.

**One idea per sentence.** A sentence that stacks clauses with dashes and parentheses makes the
reader hold all of them at once to parse any of them. Split it: state one fact and stop, then state
the next.

**Define a term where the reader first meets it.** Not only words coined in the authoring session,
but any acronym, domain term, or internal name a competent newcomer to the codebase would not
already know. Gloss it in parentheses at first use, or list it in a short terms section.

**Every word earns its place.** A principle that fits in one or two sentences gets one or two
sentences. State it once, plainly enough to land in one pass, and never restate it in new words. A
rule needing a paragraph of justification needs sharpening, not padding. Words spend a reader's
finite attention, a human's and a model's alike.

**Instruct; never differentiate.** Write every line for a reader who has only this document — not the
sibling it varies, the version it replaces, or the session that produced it. A sentence positioning
the document against an alternative, like "unlike the old way," encodes design history the reader
can't see. Cut it, and state the rule it was arguing for. Examples lifted from the authoring session
narrow the rule to the case just seen. State the litmus they point at, and keep at most one example
chosen to teach.

**Show structure; don't describe it.** A template teaches by shape: skeleton fields, labeled lists,
and fill-in bullets the reader completes. A prose paragraph specifying what a section "should
contain" forces the reader to invent the structure. Replace it with the skeleton itself.

**No self-narration.** The document never describes its own standing — concise, authoritative,
canonical, the source of truth. State the content; let it stand.

**Authority by demonstration.** It reads as truth because every line is specific, necessary, and
justified — not because it claims to be. Replace "this is the right approach because…" with the
instruction itself.

## Smell test

- Does any sentence describe the document rather than do its job?
- Does any sentence carry the history of the work — a comparison to a sibling or a prior version, or
  rationale that exists because of how the work happened rather than because it changes what to do?
- Would a junior engineer opening the document cold hit a term, abstraction, or shorthand they
  cannot decode — an internal name, an acronym, or a word coined in the authoring session? A term's
  only legitimate sources are ordinary vocabulary, an inline gloss at first use, or a durable
  document the sentence names.
- Does any sentence carry more than one idea, stacked with dashes or parentheses?
- Does any point take more words than it needs — restated after it landed, padded with justification
  instead of sharpened, or given a paragraph where two sentences carry it?
- Does any placeholder describe in prose a structure it could show as a skeleton?
- Does any reference lack the reason it's there?
- Could the reader act without chasing something the document names but doesn't carry?
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
