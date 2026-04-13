# Kafka Topics & Partitions - Curriculum

## Module 1: Topics Fundamentals
- [ ] **Topic**: logical category/feed of messages (e.g., `orders`, `payments`, `user-events`)
- [ ] Topics are multi-producer, multi-consumer — decoupled
- [ ] Topics are append-only logs — messages are never modified, only appended
- [ ] Messages in a topic are retained based on policy (not consumption)
- [ ] Topic naming conventions: `<domain>.<event-type>.<version>` (e.g., `ecommerce.order-created.v1`)
- [ ] Reserved topic prefix: `__` (internal topics like `__consumer_offsets`, `__transaction_state`)

## Module 2: Partitions — The Unit of Parallelism
- [ ] **Partition**: ordered, immutable sequence of records (sub-log of a topic)
- [ ] A topic has N partitions, each partition is stored on a single broker (leader) + replicas
- [ ] **Ordering guarantee**: within a partition, NOT across partitions
- [ ] **Parallelism**: one partition = one consumer (within a consumer group)
- [ ] Partition offset: monotonically increasing 64-bit integer per partition
- [ ] Each message identified by (topic, partition, offset)
- [ ] Partitions distribute data and load across brokers

## Module 3: Partition Key & Message Distribution
- [ ] **With a key**: `partition = hash(key) % num_partitions` → same key always to same partition
- [ ] **Without a key**: round-robin (old) or sticky partitioner (new default since 2.4)
- [ ] **Sticky partitioner**: batches messages to same partition until batch is full → better batching
- [ ] **Custom partitioner**: implement `Partitioner` interface for custom routing
- [ ] Choose key to ensure related messages are ordered together (e.g., `user_id` for user events)
- [ ] **Hot partition problem**: skewed key distribution → one partition overloaded
- [ ] Mitigation: compound keys, salting, custom partitioner with rebalancing

## Module 4: Choosing Partition Count
- [ ] **Too few partitions**: limits consumer parallelism (max consumers = partitions)
- [ ] **Too many partitions**: more open file handles, more memory, slower leader election
- [ ] **Rule of thumb**: `max(target_throughput / producer_throughput, target_throughput / consumer_throughput)`
- [ ] Start with: 3x expected consumer count for future scaling
- [ ] **Cannot decrease** partition count — can only increase
- [ ] **Increasing partitions breaks key ordering** — existing keys may hash to different partitions
- [ ] Target: 1000-4000 partitions per broker, 100K-200K total per cluster (KRaft improves this)

## Module 5: Replication Fundamentals
- [ ] **Replication factor (RF)**: number of copies per partition (recommended: 3)
- [ ] **Leader replica**: handles ALL reads and writes for a partition
- [ ] **Follower replicas**: passively fetch from leader, serve as failover
- [ ] **ISR (In-Sync Replicas)**: followers caught up within `replica.lag.time.max.ms`
- [ ] `min.insync.replicas=2` + `acks=all` → guarantees no data loss on single broker failure
- [ ] **Preferred leader**: first replica in the assignment list — auto-balanced if enabled
- [ ] **Rack awareness** (`broker.rack`): spread replicas across racks/AZs

## Module 6: Log Retention & Compaction
- [ ] **Delete policy** (`cleanup.policy=delete`, default):
  - [ ] `retention.ms`: delete messages older than this (default 7 days)
  - [ ] `retention.bytes`: delete oldest segments when exceeded (default unlimited)
- [ ] **Compact policy** (`cleanup.policy=compact`):
  - [ ] Keep only the latest value per key — older values eventually removed
  - [ ] Use case: database snapshot, KTable backing store, current state storage
  - [ ] Tombstones (key with null value) → mark for deletion
  - [ ] `min.cleanable.dirty.ratio`, `delete.retention.ms`, `segment.ms`
- [ ] **Combined policy** (`cleanup.policy=delete,compact`): compact old, delete very old
- [ ] **Log compaction process**: background cleaner thread, operates per-segment

## Module 7: Topic Configuration & Management
- [ ] **Critical topic configs**:
  - [ ] `num.partitions`, `replication.factor`, `min.insync.replicas`
  - [ ] `retention.ms`, `retention.bytes`, `cleanup.policy`
  - [ ] `segment.bytes`, `segment.ms` — controls segment file rolling
  - [ ] `max.message.bytes` — max message size accepted
  - [ ] `compression.type` — topic-level compression override
- [ ] **CLI operations**:
  - [ ] `kafka-topics.sh --create/--alter/--describe/--delete`
  - [ ] `kafka-configs.sh --entity-type topics --alter --add-config`
  - [ ] `kafka-reassign-partitions.sh` — move partitions between brokers
- [ ] **Topic deletion**: `delete.topic.enable=true` (default), async cleanup

## Module 8: Topic Design Patterns
- [ ] **One topic per event type**: clean schema, easy consumption
- [ ] **Topic per bounded context**: align with domain boundaries
- [ ] **Fat topic** (many event types in one topic): requires schema envelope, harder consumption
- [ ] **Partitioning by tenant**: multi-tenant isolation via tenant_id key
- [ ] **Event versioning**: `.v1`, `.v2` suffix for breaking changes
- [ ] **Dead Letter Topic (DLT)**: `<original-topic>.DLT` for failed messages
- [ ] **Retry topic pattern**: `<topic>.retry.5s`, `<topic>.retry.30s` for tiered retries

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Create topic with 6 partitions, produce messages, observe offset progression per partition |
| Module 3 | Produce with and without key, observe distribution across partitions |
| Module 4 | Benchmark: compare throughput with 3 vs 12 vs 48 partitions for same workload |
| Module 5 | Kill partition leader, observe follower promotion and ISR changes |
| Module 6 | Create compact topic, produce updates to same key, observe compaction behavior |
| Module 7 | Modify retention dynamically with `kafka-configs.sh`, observe deletion |
| Module 8 | Design topic layout for an order processing system (orders, payments, shipping) |

## Key Resources
- Kafka: The Definitive Guide — Chapter 2 (Topics)
- "How to Choose the Number of Topics/Partitions" — Confluent blog
- Apache Kafka documentation — Topics section
