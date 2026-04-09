# Outbox Pattern - Curriculum

## Module 1: The Dual-Write Problem
- [ ] Scenario: save order to DB AND publish event to Kafka — two separate systems
- [ ] What if DB commits but Kafka publish fails? → event lost, inconsistency
- [ ] What if Kafka publishes but DB fails? → event sent for non-existent order
- [ ] **Cannot atomically write to two different systems** without distributed transactions
- [ ] Outbox pattern: make it a single-system write, then reliably propagate

## Module 2: How Outbox Works
- [ ] **Step 1**: In same DB transaction: save entity + insert event into `outbox` table
- [ ] **Step 2**: Separate process reads outbox table → publishes to message broker → marks as sent
- [ ] Atomicity guaranteed: entity and outbox event are in the same transaction
- [ ] **Outbox table schema**: `id`, `aggregate_type`, `aggregate_id`, `event_type`, `payload` (JSON), `created_at`, `sent_at`

## Module 3: Delivery Mechanisms
- [ ] **Polling publisher**: background job polls outbox table for unsent events, publishes, marks sent
  - [ ] Simple, works everywhere, but polling interval = latency
  - [ ] Implementation: `@Scheduled` in Spring, query `WHERE sent_at IS NULL ORDER BY created_at`
- [ ] **Transaction log tailing (CDC)**: read database commit log, stream changes to broker
  - [ ] **Debezium**: captures INSERT on outbox table from PostgreSQL WAL / MySQL binlog
  - [ ] Debezium + Kafka Connect: automatic, near-real-time, no polling
  - [ ] Lower latency, no polling overhead, but operational complexity (Debezium, Kafka Connect)
- [ ] **Debezium Outbox Event Router**: built-in transformation for outbox table → clean Kafka events

## Module 4: Consumer-Side Considerations
- [ ] **At-least-once delivery**: outbox may send duplicate events (retry after failure)
- [ ] **Idempotent consumers**: must handle duplicates safely
  - [ ] Deduplication table: store processed event IDs, skip if already seen
  - [ ] Natural idempotency: `UPDATE SET status = 'PAID'` is naturally idempotent
- [ ] **Ordering**: events for same aggregate are ordered (same partition key in Kafka)
- [ ] **Cleanup**: delete or archive old outbox rows to prevent table bloat

## Module 5: Implementation
- [ ] **Spring + JPA**: save entity + outbox event in `@Transactional` method
- [ ] **Spring Modulith**: `@Externalized` annotation auto-writes to outbox, publishes to broker
- [ ] **Debezium + Kafka Connect**: deploy Debezium connector pointing at outbox table
- [ ] **Microservices Patterns**: outbox per service, each service has its own outbox table
- [ ] Monitoring: track outbox lag (unsent events), alert if lag grows

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement outbox: order-service saves order + outbox event in one transaction |
| Module 3 | Compare polling publisher (Spring @Scheduled) vs Debezium CDC — measure latency |
| Module 4 | Implement idempotent consumer with deduplication table |
| Module 5 | Full flow: order-service → outbox → Debezium → Kafka → notification-service |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 3: Outbox)
- Debezium documentation — Outbox Event Router
- "Reliable Microservices Data Exchange With the Outbox Pattern" - Gunnar Morling (blog)
- Spring Modulith Event Externalization documentation
