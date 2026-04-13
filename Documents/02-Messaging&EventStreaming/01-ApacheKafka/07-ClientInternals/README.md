# Kafka Client Internals - Curriculum

Deep dive into how producer and consumer clients work under the hood — essential for troubleshooting performance, debugging rebalances, and tuning for scale.

---

## Module 1: Producer Internals
- [ ] **Producer components**:
  - [ ] **RecordAccumulator**: in-memory buffer, groups records into batches per (topic, partition)
  - [ ] **Sender thread**: background thread that drains accumulator and sends to brokers
  - [ ] **NetworkClient**: manages connections, in-flight requests per broker
  - [ ] **Metadata**: cluster topology (topics, partitions, leaders) — refreshed periodically
- [ ] **Send flow**:
  1. [ ] `send()` serializes key/value
  2. [ ] Partitioner picks partition
  3. [ ] Record added to batch in RecordAccumulator
  4. [ ] Returns Future immediately
  5. [ ] Sender thread drains ready batches (full or linger.ms elapsed)
  6. [ ] Sends ProduceRequest to broker (leader of partition)
  7. [ ] On response → completes Future → invokes callback
- [ ] **In-flight requests**: `max.in.flight.requests.per.connection` (default 5)
  - [ ] >1 allows batching, but can reorder without idempotence
- [ ] **Buffer exhaustion**: if accumulator full → `send()` blocks up to `max.block.ms`

## Module 2: Producer Metadata Management
- [ ] **Metadata cache**: producer maintains knowledge of topics, partitions, leader brokers
- [ ] **`metadata.max.age.ms`** (default 5 min): periodic metadata refresh
- [ ] **Forced refresh**: on `UnknownTopicOrPartition`, `NotLeaderForPartition` errors
- [ ] **`metadata.max.idle.ms`**: evict idle topics from metadata cache (since 2.5)
- [ ] **Bootstrap servers**: initial broker list, only used to discover cluster
  - [ ] After first fetch, producer learns all brokers and contacts them directly
- [ ] **Connection pool**: one connection per broker (not per partition)
- [ ] **Network troubleshooting**: check `MetadataRequest` rate and errors

## Module 3: Producer Error Handling & Retries
- [ ] **Retriable errors**: `NotEnoughReplicas`, `NotLeaderForPartition`, `RequestTimeout`
- [ ] **Non-retriable errors**: `RecordTooLarge`, `SerializationException`, `AuthorizationException`
- [ ] **Retry mechanism**:
  - [ ] `retries` (default Integer.MAX_VALUE since 2.1)
  - [ ] `retry.backoff.ms` (default 100ms)
  - [ ] Bounded by `delivery.timeout.ms` (default 2 min) — total time budget
- [ ] **With idempotence**: duplicates prevented via sequence numbers
- [ ] **Callback on failure**: called with exception if all retries exhausted
- [ ] **Common errors**:
  - [ ] `TimeoutException`: batch expired, possibly broker overloaded
  - [ ] `NotEnoughReplicasException`: `min.insync.replicas` not met
  - [ ] `OutOfOrderSequenceException`: broker sequence gap (idempotence broken)

## Module 4: Consumer Internals
- [ ] **Consumer components**:
  - [ ] **Fetcher**: builds and sends FetchRequests to partition leaders
  - [ ] **Coordinator**: manages group membership, heartbeats, commits
  - [ ] **SubscriptionState**: tracks assigned partitions, positions, offsets
  - [ ] **NetworkClient**: same as producer, connection pooling per broker
- [ ] **Poll flow**:
  1. [ ] `poll()` triggers any pending heartbeats/commits
  2. [ ] Fetcher returns any pre-fetched records (pipelined)
  3. [ ] Fetcher sends FetchRequests for partitions without buffered data
  4. [ ] Returns ConsumerRecords to application
- [ ] **Fetcher pipelining**: consumer sends fetch before previous records are processed
  - [ ] Reduces idle time between polls
- [ ] **Fetch batching**: one FetchRequest covers many partitions on same broker

## Module 5: Heartbeat & Session Management
- [ ] **Heartbeat thread** (separate from poll thread, since 0.10.1):
  - [ ] Sends heartbeat every `heartbeat.interval.ms` (default 3s)
  - [ ] Coordinator tracks last heartbeat per member
- [ ] **`session.timeout.ms`** (default 45s): if no heartbeat for this long → member is dead
- [ ] **`max.poll.interval.ms`** (default 5 min): max time between `poll()` calls
  - [ ] Tracked separately — a hanging poll doesn't get kicked out by session timeout alone
  - [ ] Protects against slow processing freezing the consumer
- [ ] **Why two timeouts**:
  - [ ] session.timeout.ms: detects crashed/network-partitioned consumers quickly
  - [ ] max.poll.interval.ms: tolerates slow processing
- [ ] **Tuning**:
  - [ ] Slow processing → increase `max.poll.interval.ms`
  - [ ] Fast failure detection → decrease `session.timeout.ms`

## Module 6: Rebalance Protocol Internals
- [ ] **Rebalance trigger**: member join/leave, partition change, timeout
- [ ] **Eager rebalance (old protocol)**:
  - [ ] Phase 1: Coordinator sends "prepare to rebalance" → all consumers STOP
  - [ ] Phase 2: Consumers call `JoinGroup` → coordinator picks leader
  - [ ] Phase 3: Leader computes assignment → sends via `SyncGroup`
  - [ ] Phase 4: Consumers receive new partitions → resume
  - [ ] Problem: full pause, even for unchanged partitions
- [ ] **Incremental cooperative rebalance** (KIP-429, default since 3.0):
  - [ ] Only partitions being moved are revoked
  - [ ] Two-round protocol: revoke moved → rejoin → receive new
  - [ ] Unchanged partitions keep processing throughout
- [ ] **Generation ID**: bumped on each rebalance — stale requests are rejected
- [ ] **Consumer rebalance listener callbacks**:
  - [ ] `onPartitionsRevoked`: commit offsets BEFORE losing partitions
  - [ ] `onPartitionsAssigned`: initialize state, seek to starting position
  - [ ] `onPartitionsLost`: new in cooperative, called when zombie fencing occurs

## Module 7: Common Pitfalls & Anti-Patterns
- [ ] **Long poll processing** → max.poll.interval.ms exceeded → kicked out → rebalance storm
  - [ ] Fix: reduce `max.poll.records`, process async, increase `max.poll.interval.ms`
- [ ] **GC pauses > session.timeout.ms** → consumer kicked out
  - [ ] Fix: tune JVM (G1GC), monitor GC time, increase timeout
- [ ] **Not committing on shutdown** → reprocess on restart
  - [ ] Fix: `commitSync()` in `finally` block before `close()`
- [ ] **Creating consumer per request** → expensive, overloads coordinator
  - [ ] Fix: long-lived consumer, separate thread per consumer
- [ ] **Shared consumer across threads** → ConcurrentModificationException
  - [ ] Fix: one consumer per thread, or use `pause()`/`resume()` for manual control
- [ ] **Poison pill blocking progress** → consumer stuck on bad message
  - [ ] Fix: `ErrorHandlingDeserializer`, route to DLQ, skip
- [ ] **Rebalance during processing** → partial work lost
  - [ ] Fix: commit before rebalance via `onPartitionsRevoked`

## Module 8: Troubleshooting Client Issues
- [ ] **Diagnostic tools**:
  - [ ] Enable DEBUG logging on `org.apache.kafka.clients` package
  - [ ] JMX metrics: record rate, request latency, error rate, retry rate
  - [ ] `kafka-consumer-groups.sh --describe`: see consumer state, lag, assignment
  - [ ] Thread dumps: stuck consumer, GC pause, coordinator issues
- [ ] **Common symptoms and causes**:
  - [ ] "RebalanceInProgressException" → slow poll, fix processing time
  - [ ] "CommitFailedException" → rebalance happened during commit, re-process
  - [ ] "NetworkException" → broker unreachable or overloaded
  - [ ] Consumer lag growing with idle CPU → downstream bottleneck (DB, HTTP)
  - [ ] High producer send latency → broker slow, tune acks or investigate broker
- [ ] **Metrics to watch**:
  - [ ] Producer: `record-send-rate`, `record-error-rate`, `request-latency-avg`
  - [ ] Consumer: `records-consumed-rate`, `records-lag-max`, `fetch-latency-avg`
  - [ ] Coordinator: `join-rate`, `sync-rate`, `heartbeat-rate`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Enable DEBUG logging, trace a `send()` through RecordAccumulator and Sender |
| Module 2 | Monitor metadata refresh rate, force a topic change, observe refresh |
| Module 3 | Simulate broker unavailability, observe retry behavior |
| Module 4 | Enable DEBUG, trace a `poll()` through Fetcher and Coordinator |
| Module 5 | Tune timeouts for a slow-processing consumer, avoid kicks |
| Module 6 | Reproduce rebalance storm, fix with cooperative sticky + static membership |
| Module 7 | Identify 3 pitfalls in a sample codebase, fix them |
| Module 8 | Debug a "consumer lag growing" scenario using metrics + thread dumps |

## Key Resources
- Apache Kafka source code (clients module)
- KIP-429: Kafka Consumer Incremental Rebalance Protocol
- KIP-62: Allow consumer to send heartbeats from a background thread
- "Kafka Internals" series — Jack Vanlightly blog
- "Kafka Client Internals" — Confluent training course
