# Kafka Consumer Groups - Curriculum

## Module 1: Consumer Group Fundamentals
- [ ] **Consumer group**: set of consumers that cooperatively consume a topic
- [ ] Each partition is consumed by **exactly one** consumer in the group
- [ ] `group.id` identifies the group — all consumers with same group.id are in one group
- [ ] **Maximum parallelism** = number of partitions (extra consumers are idle)
- [ ] **Multiple groups** on same topic: each group gets independent copy of messages
- [ ] Group metadata stored in internal topic `__consumer_offsets`
- [ ] **Group coordinator**: one broker assigned per group, manages membership and offsets

## Module 2: Partition Assignment Strategies
- [ ] **RangeAssignor** (default pre-2.4): assign contiguous ranges per topic
  - [ ] Problem: uneven distribution with multiple topics
- [ ] **RoundRobinAssignor**: distribute partitions round-robin across consumers
  - [ ] Better distribution, but not sticky (all partitions reassigned on rebalance)
- [ ] **StickyAssignor**: keep existing assignments as much as possible
  - [ ] Minimizes partition movement during rebalance
- [ ] **CooperativeStickyAssignor** (default since 3.0): sticky + incremental rebalance
  - [ ] Consumers only pause partitions that are actually being moved
  - [ ] Modern production default
- [ ] `partition.assignment.strategy` config (list for fallback negotiation)

## Module 3: Rebalance Protocol
- [ ] **When rebalance happens**:
  - [ ] Consumer joins group
  - [ ] Consumer leaves group (close, crash, timeout)
  - [ ] Topic partitions added
  - [ ] Consumer fails to poll within `max.poll.interval.ms`
- [ ] **Eager rebalance** (stop-the-world, old protocol):
  - [ ] All consumers stop → release all partitions → rejoin → receive new assignment
  - [ ] Pause during rebalance = consumer lag spike
- [ ] **Incremental cooperative rebalance** (new):
  - [ ] Only partitions that need to move are revoked
  - [ ] Consumers keep processing unaffected partitions
  - [ ] Two-phase: revoke → rejoin → assign → revoke moved → rejoin again
- [ ] **Rebalance listener**: `ConsumerRebalanceListener`
  - [ ] `onPartitionsRevoked()`: commit offsets, flush state
  - [ ] `onPartitionsAssigned()`: initialize state, seek to position

## Module 4: Static Group Membership
- [ ] **Problem**: rolling restart causes multiple rebalances (pod leaves + pod joins)
- [ ] **Static membership**: consumer has stable identity via `group.instance.id`
- [ ] On restart within `session.timeout.ms`, consumer rejoins with same identity → no rebalance
- [ ] Greatly reduces rebalance noise for Kubernetes deployments
- [ ] Requires unique `group.instance.id` per consumer instance
- [ ] **Use case**: long-running consumers with state (Kafka Streams, materialized views)
- [ ] Combine with larger `session.timeout.ms` (1-5 minutes) for restart tolerance

## Module 5: Consumer Lag
- [ ] **Lag** = (latest offset in partition) - (committed offset of consumer group)
- [ ] **Per-partition lag**: can be uneven due to hot partitions
- [ ] **Total lag**: sum across all partitions in group
- [ ] **Causes of lag**:
  - [ ] Slow processing (downstream DB slow, GC pauses)
  - [ ] Insufficient consumer instances
  - [ ] Partition skew (one consumer overloaded)
  - [ ] Large batches + expensive per-record processing
- [ ] **Monitoring tools**:
  - [ ] `kafka-consumer-groups.sh --describe --group <name>`
  - [ ] Burrow (LinkedIn) — advanced lag monitoring
  - [ ] Kafka Lag Exporter for Prometheus
  - [ ] AKHQ, Kafdrop, Confluent Control Center

## Module 6: Consumer Group Operations
- [ ] **List groups**: `kafka-consumer-groups.sh --list`
- [ ] **Describe group**: shows members, lag, offset per partition
- [ ] **Reset offsets**: `--reset-offsets --to-earliest/--to-latest/--to-datetime/--shift-by`
- [ ] **Delete group**: only if no active members
- [ ] **Offset management**:
  - [ ] Consumer must not be running when resetting offsets
  - [ ] Reset scenarios: reprocess data, skip bad data, testing
- [ ] `__consumer_offsets` is a compacted topic with 50 partitions by default

## Module 7: Advanced Patterns & Anti-Patterns
- [ ] **Rebalance storms**: rapid consecutive rebalances
  - [ ] Causes: unstable deployments, session timeout too aggressive, slow processing
  - [ ] Fix: static membership, tune timeouts, fix slow processing
- [ ] **Zombie consumers**: old consumer still processing after rebalance
  - [ ] Prevented by: transactional producer with fencing, idempotent consumers
- [ ] **Consumer hang patterns**:
  - [ ] Long GC pause > session.timeout.ms → kicked out
  - [ ] Slow processing > max.poll.interval.ms → kicked out
  - [ ] Fix: tune poll records, increase timeouts, process async
- [ ] **Anti-pattern**: creating new consumer per request — use long-lived consumer
- [ ] **Anti-pattern**: processing inside poll loop synchronously with slow I/O
  - [ ] Fix: separate thread pool, track offsets carefully
- [ ] **Anti-pattern**: unbalanced keys creating hot partition → one consumer saturated

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Run 3 consumers in a group on 6-partition topic, observe assignment |
| Module 3 | Kill a consumer, observe rebalance timing with eager vs cooperative |
| Module 4 | Deploy with `group.instance.id`, measure rebalance count during rolling restart |
| Module 5 | Simulate consumer lag, monitor with `kafka-consumer-groups.sh` |
| Module 6 | Reset offsets to reprocess last 1 hour of data |
| Module 7 | Reproduce rebalance storm scenario, fix with timeout tuning + static membership |

## Key Resources
- Kafka: The Definitive Guide — Chapter 4 (Consumers)
- "Cooperative Rebalance in Kafka Consumer" — Confluent blog (KIP-429)
- "Static Membership" — KIP-345
- "Consumer Group Rebalance Protocol" — Kafka design docs
