# Kafka Offsets - Curriculum

## Module 1: Offset Fundamentals
- [ ] **Offset**: 64-bit monotonically increasing integer per partition
- [ ] Each partition has its own offset sequence — NOT global
- [ ] Messages are uniquely identified by `(topic, partition, offset)`
- [ ] **Log End Offset (LEO)**: offset of the next record to be appended
- [ ] **High Watermark (HW)**: highest offset visible to consumers (replicated to ISR)
- [ ] Consumers can only read up to HW — uncommitted records are invisible
- [ ] **Committed offset**: last offset consumer group has processed (stored in `__consumer_offsets`)

## Module 2: `__consumer_offsets` Internal Topic
- [ ] Default: 50 partitions, replication factor 3 (cluster-level config)
- [ ] Compacted topic — retains latest offset per (group, topic, partition) key
- [ ] Group metadata also stored here: members, assignments
- [ ] **Offset retention**: `offsets.retention.minutes` (default 7 days)
  - [ ] If group inactive for this duration → offsets deleted → `auto.offset.reset` kicks in
- [ ] Partition assignment: `hash(group.id) % num_partitions` → determines coordinator broker
- [ ] Monitor: under-replicated partitions on this topic indicate cluster issue

## Module 3: Auto-Commit vs Manual Commit
- [ ] **Auto-commit** (`enable.auto.commit=true`, default):
  - [ ] `auto.commit.interval.ms` (default 5s): commit every N ms during poll
  - [ ] Committed in poll(), NOT after processing → risk of losing progress on crash
  - [ ] Can cause duplicate processing: poll → crash → restart → reprocess
  - [ ] Acceptable for: idempotent consumers, at-least-once semantics
- [ ] **Manual commit** (`enable.auto.commit=false`):
  - [ ] `commitSync()`: blocks until broker confirms, retries on retriable errors
  - [ ] `commitAsync()`: fire-and-forget, faster, no retry
  - [ ] `commitSync(offsets)`: commit specific offsets (per-partition control)
  - [ ] Common pattern: commitAsync during processing + commitSync on close

## Module 4: Delivery Semantics
- [ ] **At-most-once**:
  - [ ] Commit offset BEFORE processing
  - [ ] Crash after commit, before processing → message lost
  - [ ] Use case: metrics, logs (loss acceptable)
- [ ] **At-least-once** (most common):
  - [ ] Commit offset AFTER processing
  - [ ] Crash after processing, before commit → reprocess on restart
  - [ ] Requires **idempotent processing** to avoid duplicate effects
- [ ] **Exactly-once** (EOS):
  - [ ] Kafka transactions: read-process-write atomically
  - [ ] Only within Kafka — external systems need idempotency
  - [ ] See Exactly-Once Semantics module for details

## Module 5: Seeking & Offset Control
- [ ] `consumer.seek(partition, offset)`: move to specific offset
- [ ] `consumer.seekToBeginning(partitions)`: reprocess from start
- [ ] `consumer.seekToEnd(partitions)`: skip to latest (tail)
- [ ] `consumer.offsetsForTimes(Map<TP, Long>)`: find offset by timestamp
- [ ] **`auto.offset.reset` behavior**:
  - [ ] `latest` (default): new groups start from end — skip old messages
  - [ ] `earliest`: new groups start from beginning — replay all
  - [ ] `none`: throw error if no committed offset
- [ ] Applied only when: (1) new group, or (2) committed offset out of range

## Module 6: Offset Reset Scenarios
- [ ] **Reprocessing data** (e.g., bug fix, new logic):
  - [ ] Stop consumer → reset offsets → restart
  - [ ] `kafka-consumer-groups.sh --reset-offsets --to-earliest --group X --topic Y --execute`
- [ ] **Skip bad data** (poison pill):
  - [ ] Reset to specific offset past the bad message
  - [ ] `--reset-offsets --to-offset 12345`
- [ ] **Time-based reset** (e.g., replay last 24 hours):
  - [ ] `--reset-offsets --to-datetime 2024-01-15T00:00:00.000`
- [ ] **Shift by N**:
  - [ ] `--reset-offsets --shift-by -1000` (replay last 1000)
- [ ] **Danger**: consumer must not be running, or reset is refused

## Module 7: Offset Storage Alternatives
- [ ] **External offset storage**: commit to DB instead of Kafka
  - [ ] Use case: need to commit offset and business data atomically
  - [ ] Pattern: DB transaction writes business data + offset
  - [ ] On restart: `consumer.seek()` to the offset from DB
- [ ] **Outbox pattern**: offset managed by Kafka, business data written via outbox
- [ ] **Kafka Streams**: offsets managed automatically as part of processing
- [ ] **Transactional consumer-producer**: `sendOffsetsToTransaction()` — atomic commit with produce

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Produce messages, inspect LEO and HW via `kafka-log-dirs.sh` |
| Module 2 | Look at `__consumer_offsets` topic, identify commits for your group |
| Module 3 | Implement manual commit with error handling, measure impact on throughput |
| Module 4 | Simulate at-most-once vs at-least-once, observe behavior on crash |
| Module 5 | Seek to timestamp using `offsetsForTimes()` to replay 1 hour of data |
| Module 6 | Reset offsets using all 4 modes (earliest, datetime, offset, shift-by) |
| Module 7 | Implement external offset storage pattern with PostgreSQL |

## Key Resources
- Kafka: The Definitive Guide — Chapter 4 (Offsets section)
- "Kafka Consumer Offset Management" — Confluent blog
- Apache Kafka documentation — Consumer configuration
