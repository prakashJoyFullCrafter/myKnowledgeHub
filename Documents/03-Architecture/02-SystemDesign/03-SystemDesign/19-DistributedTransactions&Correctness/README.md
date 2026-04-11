# Distributed Transactions & Workflow Correctness - Curriculum

How to design systems that maintain data correctness across multiple services without a shared database.

> Saga pattern implementation details are in Microservice Patterns. This module is about **correctness as an architecture discipline**.

---

## Module 1: The Distributed Transaction Problem
- [ ] Single DB transactions are easy — ACID guarantees everything
- [ ] Microservices = multiple databases = no shared transaction boundary
- [ ] **The fundamental trade-off**: distributed consistency is expensive (latency, complexity, availability)
- [ ] Real-world scenarios that need this:
  - [ ] Place order → deduct inventory → charge payment → send confirmation
  - [ ] Transfer money between two accounts in different banks
  - [ ] Book flight + hotel + car as a single reservation
- [ ] Design question: how much consistency do you actually need? (not everything needs strong consistency)

## Module 2: Two-Phase Commit (2PC)
- [ ] **Phase 1 (Prepare)**: coordinator asks all participants "can you commit?"
- [ ] **Phase 2 (Commit/Abort)**: if all say yes → commit; if any says no → abort
- [ ] **Coordinator**: single point of failure — if coordinator crashes after prepare, participants are stuck
- [ ] **Blocking protocol**: participants hold locks while waiting for coordinator decision
- [ ] **Problems**: slow (synchronous), doesn't scale, coordinator is SPOF, holding locks blocks throughput
- [ ] **Where it's still used**: within a single database (internal 2PC), XA transactions (legacy)
- [ ] **Why it's avoided in microservices**: tight coupling, latency, availability loss
- [ ] **Three-Phase Commit (3PC)**: adds pre-commit phase, reduces blocking — rarely used in practice

## Module 3: Saga Pattern (Architecture Perspective)
- [ ] **Saga**: sequence of local transactions, each with a compensating transaction for rollback
- [ ] **Choreography**: each service publishes events, next service reacts
  - [ ] Pros: decoupled, no central coordinator
  - [ ] Cons: hard to track flow, cyclic dependencies, debugging nightmare at scale
- [ ] **Orchestration**: central orchestrator directs the saga step by step
  - [ ] Pros: clear flow, easy to monitor, explicit error handling
  - [ ] Cons: orchestrator is a critical component, can become bottleneck
  - [ ] Tools: Temporal, Camunda, AWS Step Functions, Conductor
- [ ] **Pivot transaction**: the point of no return — before it, compensate backward; after it, retry forward
- [ ] **Design decision**: choreography for simple flows (2-3 steps), orchestration for complex flows

## Module 4: Idempotency End-to-End
- [ ] **Idempotency**: processing the same request multiple times produces the same result
- [ ] **Why essential**: retries, at-least-once delivery, duplicate messages are INEVITABLE in distributed systems
- [ ] **Idempotency key**: unique key per operation (client-generated UUID, request ID)
- [ ] **Implementation patterns**:
  - [ ] Database unique constraint on idempotency key
  - [ ] Idempotency table: store (key, status, result) — return cached result on duplicate
  - [ ] Conditional writes: `UPDATE ... WHERE version = X` (optimistic locking)
  - [ ] Natural idempotency: `SET balance = 100` is idempotent; `SET balance = balance - 10` is NOT
- [ ] **End-to-end idempotency**: client → API gateway → service → database — every layer must handle duplicates
- [ ] **Stripe's approach**: client sends `Idempotency-Key` header, server deduplicates
- [ ] Design decision: idempotency must be designed from day one, not bolted on later

## Module 5: Exactly-Once Myths & Deduplication
- [ ] **Exactly-once delivery is impossible** in distributed systems (Two Generals Problem)
- [ ] **Exactly-once processing** is achievable via: at-least-once delivery + idempotent consumer
- [ ] **Deduplication strategies**:
  - [ ] Message-level dedup: store processed message IDs, skip duplicates
  - [ ] Database-level dedup: unique constraints prevent duplicate effects
  - [ ] Kafka exactly-once: producer idempotency + transactional API (within Kafka only)
- [ ] **Dedup window**: how long to remember processed IDs? (trade-off: memory vs safety)
- [ ] **Outbox pattern**: write event + business data in same DB transaction → guaranteed consistency
  - [ ] CDC (Debezium) or polling to publish from outbox table
- [ ] Design decision: choose dedup strategy based on volume, latency tolerance, and storage cost

## Module 6: Reconciliation & Repair
- [ ] **Reconciliation**: compare data across systems to find and fix inconsistencies
- [ ] **Why needed**: even with sagas and idempotency, edge cases WILL cause drift
- [ ] **Reconciliation patterns**:
  - [ ] Batch reconciliation: nightly/hourly job compares source vs destination
  - [ ] Real-time reconciliation: stream-based comparison (Kafka Streams, Flink)
  - [ ] Self-healing: automatically fix detected inconsistencies
- [ ] **Examples**:
  - [ ] Payment reconciliation: compare orders DB vs payment gateway records
  - [ ] Inventory reconciliation: compare order service vs warehouse service counts
  - [ ] Ledger reconciliation: double-entry bookkeeping — debits must equal credits
- [ ] **Alerting on drift**: monitor reconciliation results, alert on mismatches above threshold
- [ ] Design decision: every system with distributed data needs a reconciliation strategy

## Module 7: Escrow, Ledger & Compensation Patterns
- [ ] **Double-entry ledger**: every transaction has a debit and credit entry — always balanced
  - [ ] Used by: payments, wallet systems, marketplace payouts, banking
  - [ ] Immutable: never delete/update entries, only add new correcting entries
- [ ] **Escrow pattern**: hold funds/resources in intermediate state until conditions met
  - [ ] Marketplace: buyer pays → escrow → seller delivers → escrow releases to seller
  - [ ] Booking: reserve seat → hold for 15 min → confirm or release
- [ ] **Compensation**: undo the effect of a completed transaction
  - [ ] Refund (payment), restock (inventory), cancel (booking)
  - [ ] Compensation is NOT rollback — it's a new forward action that reverses the effect
  - [ ] Compensation can fail too — need retry + manual intervention fallback
- [ ] **Eventual consistency contract**: define SLA for how long inconsistency is acceptable
  - [ ] "Balance will be consistent within 5 seconds" — communicate to users
- [ ] Design decision: for financial systems, always use ledger pattern + reconciliation

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Identify which operations in an e-commerce system need distributed consistency |
| Module 2 | Explain why 2PC fails for a 3-service order flow — draw the failure scenario |
| Module 3 | Design orchestrated saga for: order → inventory → payment → notification (with compensations) |
| Module 4 | Design idempotency for a payment API — key generation, storage, dedup flow |
| Module 5 | Implement outbox pattern: write order + outbox row in same transaction, poll and publish |
| Module 6 | Design reconciliation job for orders vs payments — what to compare, how to fix drift |
| Module 7 | Design a marketplace payment flow using escrow + double-entry ledger |

## Key Resources
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapters 7, 9, 12)
- **Enterprise Integration Patterns** - Hohpe & Woolf
- "Life Beyond Distributed Transactions" - Pat Helland (foundational paper)
- Temporal.io documentation (workflow orchestration)
- Stripe's idempotency documentation
- "Building a Reliable, High-Throughput Ledger at Scale" - Uber engineering blog
