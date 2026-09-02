# ECS — Entity/Component/System (Opt-In)

Load on demand. The opt-in gate lives in `dojo-principles → ECS Architecture`; this file is
the rule set.

- Entities = IDs only. Components = pure data, no behavior. Systems = stateless functions
  that read/write components.
- No back-pointers: a component never references its entity; a system receives views
  (id + component tuples), never object graphs.
- No per-entity virtual dispatch: behavior lives in systems iterating archetypes, not in
  entity methods.
- System order is explicit data: scheduling is part of the design, reviewed like any
  dependency graph — hidden ordering assumptions are the classic ECS bug.
- Legacy escape hatch: maintain existing OOP consistency unless explicitly instructed to
  introduce ECS — retrofitting ECS into an OOP codebase mid-project is a randori/kaizen
  decision, never a green-step choice.
