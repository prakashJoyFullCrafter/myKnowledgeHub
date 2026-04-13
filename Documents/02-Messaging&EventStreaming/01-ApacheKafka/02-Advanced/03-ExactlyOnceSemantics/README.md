# Kafka Exactly-Once Semantics (EOS) - Curriculum

## Module 1: The Duplicate Problem
- [ ] **Why duplicates happen**:
  - [ ] Producer retries: network timeout → retry → original also succeeded → duplicate
  - [ ] Consumer rebalance: offset not committed yet → reprocess after rebalance
  - [ ] Application crash: processed but offset not committed
- [ ] **At-most-once**: no duplicates, but may lose messages
- [ ] **At-least-once**: no loss, but duplicates possible → requires idempotent processing
- [ ] **Exactly-once**: no loss, no duplicates (holy grail)
- [ ] **Impossibility result**: exactly-once DELIVERY is impossible in distributed systems
- [ ] **Exactly-once PROCESSING** is possible: at-least-once delivery + idempotent processing

## Module 2: Idempotent Producer
- [ ] `enable.idempotence=true` (default since Kafka 3.0)
- [ ] **How it works**:
  - [ ] Producer requests Producer ID (PID) from broker on init
  - [ ] Each message has sequence number per (PID, partition)
  - [ ] Broker caches last 5 sequence numbers per (PID, partition)
  - [ ] Duplicate (same seq num) → dropped, original ack returned
  - [ ] Out-of-order (seq gap) → `OutOfOrderSequenceException`
- [ ] **Guarantees**: exactly-once WRITE to a single partition within a single producer session
- [ ] **Does NOT guarantee**:
  - [ ] Exactly-once across producer restarts (PID changes on restart)
  - [ ] Exactly-once across multiple partitions
  - [ ] Exactly-once end-to-end (consumer side)
- [ ] **Prerequisites**:
  - [ ] `acks=all`
  - [ ] `max.in.flight.requests.per.connection <= 5`
  - [ ] `retries > 0`

## Module 3: Transactional Producer
- [ ] **Goal**: atomic writes across multiple partitions and topics
- [ ] `transactional.id`: unique, stable ID per producer instance (survives restart)
- [ ] **API**:
  ```
  producer.initTransactions();      // once, at startup
  producer.beginTransaction();
  producer.send(record1);
  producer.send(record2);
  producer.commitTransaction();     // or abortTransaction()
  ```
- [ ] **Producer fencing via epoch**: older producer with same transactional.id is fenced out
  - [ ] Prevents zombie producers from committing after restart
- [ ] **Transaction log**: internal topic `__transaction_state` stores transaction state

## Module 4: Transaction Coordinator & Markers
- [ ] **Transaction Coordinator**: broker managing a transactional.id (via hash)
- [ ] **Steps of a transaction**:
  1. [ ] `initTransactions` → register with coordinator, get PID + epoch
  2. [ ] `beginTransaction` → local state change
  3. [ ] `send` → coordinator adds partition to transaction
  4. [ ] `commitTransaction` → coordinator writes PREPARE_COMMIT → markers to all partitions → COMPLETE
- [ ] **Transaction markers**: special records in user topics indicating commit/abort
  - [ ] Consumer uses these to determine which records are committed
- [ ] **Atomicity**: two-phase commit across partitions via transaction log + markers
- [ ] `transaction.timeout.ms`: max duration before coordinator aborts stale transaction

## Module 5: Consumer Isolation Levels
- [ ] `isolation.level=read_uncommitted` (default): see all messages including uncommitted
- [ ] `isolation.level=read_committed`: skip aborted transaction messages
  - [ ] **Last Stable Offset (LSO)**: highest offset where all transactions are decided
  - [ ] Consumer reads up to LSO, not HW
  - [ ] Aborted messages are buffered and skipped
- [ ] **Performance impact**: `read_committed` is slightly slower (needs to track aborts)
- [ ] **Always use `read_committed` when consuming transactional topics**

## Module 6: Read-Process-Write (Consume-Transform-Produce)
- [ ] **Pattern**: read from input topic → process → write to output topic → commit offsets
- [ ] **Without transactions**: can fail between processing and offset commit → duplicates
- [ ] **With transactions**:
  ```
  producer.beginTransaction();
  producer.send(outputRecord);
  producer.sendOffsetsToTransaction(offsets, consumerGroupMetadata);
  producer.commitTransaction();
  ```
- [ ] `sendOffsetsToTransaction()`: atomic offset commit + produce
- [ ] On failure: transaction aborts → next consumer read sees previous committed offset
- [ ] This is the foundation of Kafka Streams `exactly_once_v2`

## Module 7: Exactly-Once in Kafka Streams
- [ ] `processing.guarantee=exactly_once_v2` (recommended, since 2.5)
- [ ] Streams automatically handles:
  - [ ] Transactional producer setup
  - [ ] Offset commits within transactions
  - [ ] State store changelog within transactions
- [ ] **`exactly_once` (v1)**: one producer per task — doesn't scale well
- [ ] **`exactly_once_v2`**: one producer per stream thread — better resource usage
- [ ] **Performance impact**: 20-30% throughput reduction
- [ ] **When to use**: financial data, counters, aggregations that must be exact

## Module 8: Limits & Anti-Patterns
- [ ] **Exactly-once is ONLY within Kafka**:
  - [ ] Producing from Kafka to a database → requires idempotent writes (DB side)
  - [ ] Consuming from a database to Kafka → requires CDC with dedup
  - [ ] Side effects (HTTP calls, emails) cannot be exactly-once with Kafka alone
- [ ] **Transaction size matters**:
  - [ ] Long transactions block consumers (buffer aborts until LSO advances)
  - [ ] Keep transactions small (< seconds)
- [ ] **Anti-pattern**: enabling transactions for high-volume stateless transformations
  - [ ] Overhead not worth it — use at-least-once + idempotent consumer
- [ ] **Anti-pattern**: mixing transactional and non-transactional producers on same partition
- [ ] **Decision tree**:
  - [ ] Metrics/logs → at-most-once (fastest)
  - [ ] Most use cases → at-least-once + idempotent (simple, fast)
  - [ ] Money/counters → exactly-once (slower, safe)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Enable idempotent producer, simulate retries, verify no duplicates |
| Module 3 | Build transactional producer sending to 2 topics atomically |
| Module 4 | Inspect `__transaction_state` topic during an active transaction |
| Module 5 | Produce with `commit`/`abort`, observe `read_committed` vs `read_uncommitted` |
| Module 6 | Build read-process-write loop with `sendOffsetsToTransaction` |
| Module 7 | Enable `exactly_once_v2` in Streams, benchmark vs at-least-once |
| Module 8 | Identify 3 scenarios where exactly-once doesn't apply (external sinks) |

## Key Resources
- "Exactly-Once Semantics Are Possible: Here's How Kafka Does It" — Confluent blog
- KIP-98: Exactly Once Delivery and Transactional Messaging
- KIP-447: Producer scalability for exactly-once semantics
- "Transactions in Apache Kafka" — Confluent blog
