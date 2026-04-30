# Event-Driven Patterns - Curriculum

> Martin Fowler's taxonomy: **"event-driven" means at least four different things**, and most arguments about event-driven architecture are people talking past each other because they mean different patterns. Pick deliberately.

## Module 1: The Taxonomy & Why It Matters
- [ ] Fowler's four patterns under the "event-driven" umbrella:
  1. [ ] **Event Notification** — "something happened, ask me if you want details"
  2. [ ] **Event-Carried State Transfer** — "something happened, here's all the data you'll need"
  3. [ ] **Event Sourcing** — "the events ARE the state; the current state is a fold over events"
  4. [ ] **CQRS** — "split the write side from the read side; often (not always) communicated via events"
- [ ] Most teams say "we're event-driven" and mean (1) but design (2) without knowing it — this causes pain
- [ ] Each pattern has different consistency, coupling, replay, storage, and operational characteristics
- [ ] Decision matters: choosing the wrong pattern gives you all the costs of events with none of the benefits
- [ ] **Common confusion**: "events" the message vs "events" the architectural style — always clarify which sense you mean
- [ ] **Common confusion 2**: event vs message vs command — events describe the past (`OrderPlaced`); commands request the future (`PlaceOrder`); messages are the transport
- [ ] **Common confusion 3**: pub/sub is a *transport*, not an architecture — you can do request/reply over pub/sub and event-notification over HTTP

## Module 2: Event Notification
- [ ] **Definition**: producer emits a small event ("OrderPlaced, id=123") with minimal data; consumers that need details call back to the producer to fetch
- [ ] **Payload**: identifiers + minimal context — NOT the full state
- [ ] **Flow**: `Producer → emits OrderPlaced(id=123) → Consumer reads event → Consumer calls Producer.GET /orders/123 for details`
- [ ] **Pros**:
  - [ ] Loose coupling at the data level — consumer can't depend on event payload shape
  - [ ] Producer remains source of truth; no data duplication
  - [ ] Small events = cheap transport
- [ ] **Cons**:
  - [ ] **Reintroduces synchronous coupling** at fetch time — if producer is down, consumer can't process
  - [ ] N consumers + 1 event = N callback calls (chatty)
  - [ ] Causal coupling: event order must align with eventual consistency at producer (event arrives before producer's data is queryable → 404)
- [ ] **Best for**: low-frequency events, consumers rarely need full data, want to minimise data duplication
- [ ] **Worst for**: high-throughput pipelines, autonomous downstream systems, offline/batch consumers
- [ ] **Anti-pattern**: emitting fat events that consumers ignore the payload of and call back anyway — pick a lane

## Module 3: Event-Carried State Transfer (ECST)
- [ ] **Definition**: producer emits the full (or sufficient) state needed for downstream processing; consumers don't need to call back
- [ ] **Payload**: the relevant state snapshot — `OrderPlaced{id, customerId, items, total, address, ...}`
- [ ] **Flow**: `Producer → emits OrderPlaced(full state) → Consumer processes locally; no callback needed`
- [ ] **Pros**:
  - [ ] Consumer is **autonomous** — works even if producer is down
  - [ ] Better latency (no second round-trip)
  - [ ] Natural fit for replay, caching, materialised views
- [ ] **Cons**:
  - [ ] Larger event payloads
  - [ ] **Schema becomes a contract**: change the event shape → coordinated consumer upgrades
  - [ ] Data duplication across consumers (each may store its own copy)
  - [ ] Privacy/security — sensitive data now travels through the event bus and lives in consumer stores
- [ ] **Schema management is non-negotiable**: schema registry (Confluent), Avro/Protobuf, additive-only changes, version policy
- [ ] **Best for**: autonomous downstream systems, event-sourced/streaming architectures, materialised view builders, analytics pipelines
- [ ] **Worst for**: rapidly evolving schemas, regulated data domains where state replication is restricted
- [ ] **Hybrid**: emit identifier + commonly-needed fields; consumer can call back for rare fields

## Module 4: Event Sourcing & CQRS as Event-Driven Patterns
- [ ] **Event Sourcing** (covered in depth in `02-EventSourcing/`):
  - [ ] Events are the **system of record**; state is a projection
  - [ ] Append-only log; replay rebuilds state at any point in time
  - [ ] Strongest form of "event-driven" — events ARE the data, not just notifications about it
  - [ ] Often combined with ECST for downstream propagation
- [ ] **CQRS** (covered in depth in `01-CQRS/`):
  - [ ] Separates the write model (commands) from the read model (queries)
  - [ ] Often (not necessarily) communicated via events: command → event → projection → read model
  - [ ] CQRS without ES = "two databases kept in sync"; CQRS with ES = "events drive everything"
- [ ] **The four-quadrant view**:
  - [ ] (1) Event Notification + sync DB → simple decoupled microservices
  - [ ] (2) ECST + sync DB → autonomous services with replicated read state
  - [ ] (3) ES + CQRS → full event-driven, projections everywhere
  - [ ] (4) Hybrid — most real systems mix patterns by domain
- [ ] **Maturity ladder** (typical evolution): Notification → ECST → CQRS → ES — don't skip stages without reason
- [ ] **Cost ladder**: each step adds infrastructure (schema registry, projections, snapshots, event store, replay tooling)

## Module 5: Choreography vs Orchestration (Cross-Cutting)
- [ ] All four event-driven patterns face this orthogonal choice for multi-step workflows:
- [ ] **Choreography**: services react to events independently — no central coordinator
  - [ ] Pros: fully decoupled, no SPOF, simple per service
  - [ ] Cons: emergent flow is hard to see/debug, cyclic dependencies possible, hard to evolve
  - [ ] Best for: 2-4 step flows, autonomous teams
- [ ] **Orchestration**: a central orchestrator (Saga, Temporal workflow, BPM engine) drives the flow
  - [ ] Pros: explicit flow, easy to visualise, central error handling
  - [ ] Cons: orchestrator becomes critical infra, more coupling to coordinator
  - [ ] Best for: 5+ steps, regulated workflows, audit requirements
- [ ] **The "I lost the flow" problem in choreography**: distributed traces become essential — without OpenTelemetry, debugging an event chain is archaeology
- [ ] **Hybrid**: orchestrate the high-stakes steps, choreograph the rest

## Module 6: Common Anti-Patterns
- [ ] **Distributed monolith via events**: services synchronously chained through events; one slow consumer blocks everything → all the cost of events, none of the benefit
- [ ] **Schema chaos**: no registry, free-form JSON, every consumer parses defensively → schema migrations become operational nightmares
- [ ] **Event-as-RPC**: emitting `CalculateTaxRequested` and waiting for `CalculateTaxResponded` — that's just RPC over a queue (slower, less reliable than HTTP)
- [ ] **Forgetting at-least-once semantics**: every event consumer needs idempotency (see `02-Resilience/05-Idempotency/`)
- [ ] **Tight coupling via implicit ordering**: relying on broker-level message order across topics/partitions → fragile
- [ ] **Event payload bloat**: ECST gone wrong — multi-MB events with everything anyone might want
- [ ] **No replay strategy**: events flow forward only; no plan for adding a new consumer that needs historical data → forced to backfill from DB
  - [ ] Solution: choose a transport with retention (Kafka), or design for snapshot + delta
- [ ] **No DLQ / poison-message handling**: malformed event blocks the partition forever
- [ ] **Mixed semantics in one topic**: notification events and ECST events on the same topic → consumers can't reason about contracts
- [ ] **Event Sourcing for everything**: ES is heavy; only adopt where audit/replay/temporal-query is a real need

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Take a system you call "event-driven" and classify each event flow into one of Fowler's four patterns — note where you mix |
| Module 2 | Implement order processing with Event Notification: small `OrderPlaced(id)` event, consumer calls back for details; measure latency and producer load |
| Module 3 | Reimplement the same flow with ECST: full payload in the event, consumer never calls back; compare throughput, decoupling, schema impact |
| Module 4 | Add a CQRS read model fed by ECST events; observe consistency lag |
| Module 5 | Take a 5-step saga: implement once with choreography (event chain), once with orchestration (Temporal); compare debuggability when one step fails |
| Module 6 | Audit one of your event topics: any of the anti-patterns present? Pick one to fix this quarter |

## Cross-References
- `01-MicroservicePatterns/03-DataPatterns/01-CQRS/` — CQRS in depth
- `01-MicroservicePatterns/03-DataPatterns/02-EventSourcing/` — Event Sourcing in depth
- `01-MicroservicePatterns/03-DataPatterns/03-OutboxPattern/` — reliable publishing for any of these patterns
- `01-MicroservicePatterns/01-CorePatterns/05-SagaPattern/` — choreography vs orchestration in detail
- `01-MicroservicePatterns/02-Resilience/05-Idempotency/` — idempotent consumers (mandatory)
- `01-MicroservicePatterns/02-Resilience/07-Backpressure/` — flow control on event streams
- `02-SystemDesign/04-ArchitecturePatterns/` — Event-Driven as one of the application architecture patterns
- `02-Messaging&EventStreaming/01-Kafka/` — Kafka as the dominant event-driven transport on the JVM
- `02-Messaging&EventStreaming/02-RabbitMQ/` — RabbitMQ for event notification & queueing styles

## Key Resources
- **"What do you mean by 'Event-Driven'?"** - Martin Fowler (the canonical taxonomy article)
- **"Many Meanings of Event-Driven Architecture"** - Martin Fowler (GOTO conference talk)
- **Building Event-Driven Microservices** - Adam Bellemare (O'Reilly — the most thorough modern treatment)
- **Designing Event-Driven Systems** - Ben Stopford (Confluent — free)
- **Enterprise Integration Patterns** - Gregor Hohpe & Bobby Woolf (the classical reference)
- **Implementing Domain-Driven Design** - Vaughn Vernon (events in DDD)
- **"The Many Meanings of Event-Driven Architecture"** - Martin Kleppmann (DDIA Chapter 11)
- **Confluent Schema Registry** documentation — versioning, compatibility modes
