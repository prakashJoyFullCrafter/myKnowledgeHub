# Tactical DDD - Curriculum

The implementation-level building blocks: how to model a Bounded Context in code.

## Topics
### Building Blocks
- [ ] **Entity** - has identity that persists over time, mutable
- [ ] **Value Object** - defined by attributes, immutable, no identity
  - [ ] Use VOs aggressively to push behavior out of entities
  - [ ] Equality by value, not reference
- [ ] **Aggregate** - cluster of entities + VOs treated as a consistency boundary
  - [ ] **Aggregate Root** - single entry point, controls invariants
  - [ ] Reference other aggregates by ID, not by object reference
  - [ ] Keep aggregates small (rule of thumb: one aggregate per transaction)
- [ ] **Domain Event** - something meaningful happened in the domain
  - [ ] Past tense naming: `OrderPlaced`, `PaymentReceived`
  - [ ] Used for cross-aggregate consistency and integration
- [ ] **Repository** - persistence abstraction for aggregates
  - [ ] One repository per aggregate root, not per entity
- [ ] **Domain Service** - logic that doesn't naturally belong on an entity or VO
  - [ ] Stateless, named with domain verbs
- [ ] **Application Service** - orchestrates use cases (vs Domain Service which is pure domain)
- [ ] **Factory** - encapsulates complex aggregate creation

### Modelling Practices
- [ ] Avoid anemic domain model (data classes + service procedures)
- [ ] Push behavior into entities and VOs
- [ ] Invariants enforced inside the aggregate
- [ ] Eventual consistency between aggregates
- [ ] Specification pattern for complex queries
- [ ] CQRS as a tactical evolution: separate read/write models
- [ ] Event Sourcing pairing with DDD
- [ ] Common mistakes: aggregate too large, leaking domain into infra
