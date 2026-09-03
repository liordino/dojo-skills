---
name: randori
disable-model-invocation: true
description: >
  Relentless interview-driven design session. Use when defining a feature or stress-testing a
  plan against the project's existing domain language. Triggers on: /randori, or automatically
  from hajime's DEFINE phase when the design isn't already done. Interviews the human one
  question at a time, builds the shared domain language and non-goals in .dojo/CONTEXT.md, writes ADRs
  for non-obvious decisions, and produces the plan: .dojo/TASKS.md (every wave a verifiable outcome)
  for multi-wave work, plus the intent line and wave 1 goal that feed the kata cycle. Has a
  scoping mode that outputs questions when answers live with other people. Always supervised —
  this is a dialogue, never autonomous.
---

# Randori — Interview-Driven Design

*Assumes the governance trio (`dojo-principles`, `dojo-project`, `dojo-conduct`) is loaded — hajime loads it at session start; if you're starting from here, load it first.*

*乱取り — freeform sparring, handling whatever comes. Relentless questioning until every branch
of the design tree is resolved and the language is sharp.*

Always supervised. Narrate your reasoning and think alongside the human.

---

## Two modes: design grill (default) vs scoping reconnaissance

Sometimes you can't design yet because the information lives with other people (a team, a
stakeholder, a domain expert). Then run **scoping mode** — triggered when the human says "I
need to scope this with my team first" / "help me figure out what to ask," or when the grill
hits unknowns only others can resolve.

**Scoping mode:** run the same probing interview, but when something can't be resolved — not in
the human's head, not in the codebase, not in the docs — don't guess and don't stall:
**catalogue it.** Explore the codebase/graph first to answer what you can yourself; collect
only the genuinely external unknowns. Produce **`.dojo/session/scoping-questions.md`**: each unknown phrased
as a clear question, grouped by who/what can resolve it, with *why it matters* (what decision
it unblocks). Skip Step 0 and the design steps — the question set *is* the output. A later
design-grill run consumes the answers as its starting point: scope → gather → design.

---

## Step 0 — Scope and leverage gate (FIRST, before designing)

Establish *what actually needs building* before *how*. Work through these with the human,
exploring the codebase/graph to answer what you can yourself:

1. **What already exists** — in the codebase, environment, or upstream — that provides part of
   this?
2. **What is the true minimal delta**, starting from existing data/artifacts/seams?
3. **Is the boundary drawn right?** Could the task start later in the pipeline or end earlier?
4. **What are we tempted to build that we don't need?** Name it, cut it.

State the result plainly — "Given that X and Y exist, the actual work is just Z" — and confirm
the reduced boundary before the grill. The reduced scope must still *fully* achieve the
outcome: cut redundant work, never necessary work.

---

## The method

- **One question at a time.** Walk each branch of the design tree; let each answer inform the
  next. Never batch.
- **Every question carries your recommended answer** — "I'd recommend Y because [reason]. Your
  call." Confirmation or correction, never blank-page invention.
- **Facts are found; decisions are made.** If the codebase, graph, or docs can answer it
  (rg/sg/graphify), it is a *fact* — read it, never ask it. A *decision* (a trade-off, a
  boundary, a name, a tolerance) belongs to the human — never make one for them, and never
  grill yourself: a question you could answer from the repo was a fact, not a decision.
- **Keep going until every question material to the plan is resolved** — not before.
- **Elicit the non-goals.** Suggest candidate non-goals and confirm each: "Should this also
  handle X? I'd make that an explicit non-goal because [reason] — agree?" Record confirmed
  non-goals in .dojo/CONTEXT.md → Non-Goals; they bind every future session and autonomous run.

---

## .dojo/CONTEXT.md — the contract

.dojo/CONTEXT.md holds **exactly three sections, nothing else** (no implementation detail, no spec,
no scratch pad):

- **Glossary** — canonical domain terms and meanings. The highest-leverage output: code,
  conversation, and docs all derive from one model. **For every term, pin what it explicitly
  excludes or is confused with, not only what it means** — *"when we say X we do not mean Y"* —
  e.g. "score" in music ≠ a test grade; "wave" in this project ≠ an electromagnetic wave.
  Conceptual exclusions are the highest-leverage glossary line — they prevent the most
  expensive downstream confusion (a team that thinks a term means what it means in *their*
  prior context, and ships accordingly). Distinct from Non-Goals (which are scope, not term
  meaning).
- **Non-Goals** — the confirmed boundary of what this project deliberately isn't.
- **Decisions** — durable recorded choices (log sink, etc.) with one-line rationale; anything
  with a real trade-off also gets an ADR.

During the interview: call out term **conflicts** with the glossary immediately; pin
**confusions** ("is this the X you mean, or the Y-other-domain X?"); replace **vague** terms
with precise canonical ones; stress-test **relationships** with concrete scenarios ("If a
Customer cancels mid-cycle, what happens to the open Invoice?"). Update inline as terms
crystallize. Mark genuinely unsettled terms `(provisional)` and challenge them in later
sessions — settled glossary outranks memory, but provisional means provisional. The
three-section contract is enforced, not remembered: this repo's lint asserts it (R15), and
hajime verifies it at scaffold in projects.

---

## Record decisions (ADRs)

Write an ADR only when **all three** hold: hard to reverse · surprising without context · the
result of a real trade-off. Most decisions don't qualify. Write to
`.dojo/adr/NNNN-short-title.md` (create the directory lazily).

---

## Produce the plan

**Distill the intent:** one sentence — the problem this solves, and for whom. It goes to
`.dojo/session/dojo-session.md`'s `intent:` so every later step carries the final objective.

**Express every wave as a verifiable outcome**, in the domain language just sharpened.
Good: "A Customer with no payment method on file receives PaymentMethodMissingError at
checkout, before order total calculation." Bad: "Add payment validation."

**Split before starting, not after failing.** A wave is a *single* verifiable outcome,
completable in one focused pass. Needs "and"? Spans unrelated surfaces? Can't name the one
check that proves it? It's two waves. The stuck protocol catching an oversized wave is the
expensive way to learn this.

**Write .dojo/TASKS.md whenever the work spans more than one wave** (single-wave work skips it):

```markdown
# Tasks — [project name]
intent: [the one sentence]

## Wave 1 — [verifiable outcome]
status: pending

## Wave 2 — [verifiable outcome]
status: pending
```

`status:` is one of `pending | done | invalidated`. kata-commit marks waves done and advances;
kaizen rewrites this file when reality changes. Order waves by dependency.

---

## Hand off

Summarize: shared understanding reached, .dojo/CONTEXT.md terms added/sharpened, non-goals confirmed,
ADRs written, the intent line, and the plan (.dojo/TASKS.md or the single wave goal). Confirm wave 1
with the human, then hand back to the calling context (usually hajime §6) ready for
`/kata-red`. **Do not begin implementation until the human confirms shared understanding** —
the grill ends in an explicit confirmation, never by drifting into building. A finished plan
is a hand-off, not a starting gun.
