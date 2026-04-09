# Event Sourcing - Curriculum

## Module 1: Concept
- [ ] Traditional: store current state (overwrite on update) — lose history
- [ ] Event sourcing: store **sequence of events** as the source of truth
- [ ] Current state = replay all events from beginning (or from snapshot)
- [ ] Events are immutable, append-only — never delete or modify
- [ ] Example: bank account — store `Deposited($100)`, `Withdrawn($30)`, not `balance = $70`

## Module 2: Core Components
- [ ] **Event Store**: append-only log of domain events, ordered by sequence number
  - [ ] Per-aggregate event stream: `order-123` → [OrderCreated, ItemAdded, OrderPaid]
- [ ] **Aggregate**: domain entity rebuilt by replaying its events
- [ ] **Projections**: read models built by processing events (denormalized query views)
- [ ] **Snapshots**: periodic state snapshot to avoid replaying all events from beginning
  - [ ] Snapshot every N events (e.g., every 100), replay only events after snapshot
- [ ] **Event handlers**: react to events — update projections, trigger side effects, notify other services

## Module 3: Event Design & Evolution
- [ ] **Event naming**: past tense (`OrderCreated`, `PaymentReceived`, `ItemShipped`)
- [ ] **Event payload**: include all data needed to reconstruct state change
- [ ] **Event versioning**: events are immutable — how to handle schema changes?
  - [ ] **Upcasting**: transform old event format to new on read
  - [ ] **New event type**: add `OrderCreatedV2`, keep both
  - [ ] **Weak schema**: use flexible formats (JSON), add optional fields
- [ ] **Event ordering**: guaranteed within aggregate, not across aggregates

## Module 4: Benefits & Challenges
- [ ] **Benefits**:
  - [ ] Complete audit trail — every change is recorded
  - [ ] Temporal queries — "what was the state at 3pm yesterday?"
  - [ ] Debugging — replay events to reproduce bugs
  - [ ] New projections — reprocess all events to build new read model
  - [ ] Event-driven integration — events naturally flow to other services
- [ ] **Challenges**:
  - [ ] Complexity — fundamentally different from CRUD
  - [ ] Eventual consistency — projections lag behind writes
  - [ ] Storage growth — events accumulate forever (compaction, archival)
  - [ ] Event schema evolution — versioning is hard
  - [ ] Querying — can't query event store directly, need projections
  - [ ] Learning curve — team must understand event-driven thinking

## Module 5: Tools & Implementation
- [ ] **EventStoreDB**: purpose-built event store, subscriptions, projections
- [ ] **Axon Framework**: Java, `@Aggregate`, `@EventSourcingHandler`, `@EventHandler`
- [ ] **Kafka as event store**: append-only log, but lacks per-aggregate streams and optimistic concurrency
- [ ] **PostgreSQL as event store**: events table + sequence, works for moderate scale
- [ ] **Event sourcing + CQRS**: natural combination — events sync read models
- [ ] When to use: complex domain, audit requirements, temporal queries, event-driven architecture
- [ ] When to avoid: simple CRUD, team unfamiliar, no clear benefit from history

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build event-sourced bank account: Deposited, Withdrawn, rebuild balance from events |
| Module 3 | Add a new field to an event, implement upcasting for backward compatibility |
| Module 4 | Build a new projection from existing events (e.g., "monthly spending report") |
| Module 5 | Compare: Axon Framework vs custom PostgreSQL event store for same domain |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 6: Event Sourcing)
- "Event Sourcing" - Martin Fowler (blog)
- EventStoreDB documentation (eventstore.com)
- Implementing Domain-Driven Design - Vaughn Vernon
