# Stream Processing & Real-Time Systems - Curriculum

How to design systems that process data continuously as it arrives — not in batches.

> Kafka API details and Spring Cloud Stream are in Messaging section. This module covers **stream processing as an architecture pattern**.

---

## Module 1: Stream Processing vs Batch vs Queue Processing
- [ ] **Batch processing**: collect data → process all at once (hourly/daily)
  - [ ] Tools: Hadoop MapReduce, Spark batch, cron jobs
  - [ ] Latency: minutes to hours
- [ ] **Queue processing**: message arrives → one consumer processes it → done
  - [ ] Tools: RabbitMQ, SQS
  - [ ] Latency: seconds; Focus: task execution
- [ ] **Stream processing**: continuous flow of events → process in real-time → emit results
  - [ ] Tools: Kafka Streams, Apache Flink, Spark Structured Streaming
  - [ ] Latency: milliseconds to seconds; Focus: continuous computation
- [ ] **Key difference**: stream processing maintains STATE across events (aggregations, joins, windows)
- [ ] **Lambda architecture**: batch + speed layer (complex, dual maintenance)
- [ ] **Kappa architecture**: stream-only, reprocess by replaying log (simpler, Kafka-native)
- [ ] Design decision: when do you need stream processing vs a simple consumer?

## Module 2: Event Time vs Processing Time
- [ ] **Processing time**: when the system processes the event (wall clock)
- [ ] **Event time**: when the event actually occurred (embedded in the event)
- [ ] **Why it matters**: events arrive out of order and late
  - [ ] Mobile app offline → sends events hours later
  - [ ] Network delay → event from 1pm arrives at 1:05pm
- [ ] **Skew**: difference between event time and processing time
- [ ] **If you use processing time**: your aggregations will be WRONG for late/out-of-order events
- [ ] **Design rule**: always use event time for correctness; processing time only for monitoring
- [ ] Every event should carry its own timestamp — don't rely on arrival time

## Module 3: Windowing
- [ ] **Why windows?** Streams are infinite — you need bounded chunks to compute aggregates
- [ ] **Tumbling window**: fixed-size, non-overlapping (e.g., every 5 minutes)
  - [ ] Use case: "orders per 5-minute interval"
- [ ] **Hopping/sliding window**: fixed-size, overlapping (e.g., 5-min window every 1 min)
  - [ ] Use case: "moving average over last 5 minutes, updated every minute"
- [ ] **Session window**: dynamic size, grouped by activity with gaps
  - [ ] Use case: "user session = events with < 30 min gap between them"
- [ ] **Global window**: all events in one window (rarely useful alone)
- [ ] **Late events**: what happens when an event arrives after its window closed?
  - [ ] Allowed lateness: accept late events up to a threshold, update results
  - [ ] Drop: discard events beyond the threshold
  - [ ] Side output: route late events to a separate stream for handling

## Module 4: Watermarks & Triggers
- [ ] **Watermark**: system's estimate of "all events up to time T have arrived"
  - [ ] When watermark passes window end → window is complete → emit result
  - [ ] Watermark too fast: misses late events (incorrect results)
  - [ ] Watermark too slow: high latency (delayed results)
- [ ] **Heuristic watermarks**: based on observed event times (practical, imperfect)
- [ ] **Perfect watermarks**: only possible when you control the event source completely
- [ ] **Triggers**: when to emit window results
  - [ ] On watermark: emit once when window closes
  - [ ] On event count: emit every N events
  - [ ] On processing time: emit every N seconds
  - [ ] Early + on-time + late triggers: emit approximate early, update on watermark, correct on late
- [ ] Design decision: watermark strategy depends on your latency vs correctness requirements

## Module 5: Exactly-Once in Stream Processing
- [ ] **The challenge**: stream processors may crash and restart — how to avoid duplicates?
- [ ] **At-least-once + idempotent sink**: process may duplicate, but sink handles it
  - [ ] Database upsert, deduplication table
- [ ] **Kafka exactly-once semantics**:
  - [ ] Producer idempotency: broker deduplicates based on producer ID + sequence number
  - [ ] Transactional API: read-process-write as atomic operation (within Kafka)
  - [ ] Consumer: `read_committed` isolation level
- [ ] **Flink exactly-once**: checkpointing + two-phase commit to external sinks
- [ ] **Chandy-Lamport checkpointing**: snapshot distributed state without stopping processing
- [ ] **End-to-end exactly-once**: source → processor → sink must ALL participate
- [ ] Design truth: exactly-once is expensive — use it for financial data, accept at-least-once for metrics

## Module 6: CDC Pipelines & Data Contracts
- [ ] **Change Data Capture (CDC)**: capture database changes as a stream of events
  - [ ] Log-based CDC: read database WAL/binlog (Debezium + Kafka Connect)
  - [ ] Query-based CDC: poll for changes (simpler but misses deletes, higher latency)
- [ ] **CDC use cases**:
  - [ ] Sync data to search index (PostgreSQL → Elasticsearch)
  - [ ] Sync to cache (DB change → invalidate/update Redis)
  - [ ] Build materialized views across services
  - [ ] Event sourcing retrofit: add events to a legacy system without rewriting it
- [ ] **Data contracts**: schema agreement between producer and consumer
  - [ ] Schema Registry (Confluent): enforce Avro/Protobuf/JSON Schema compatibility
  - [ ] Backward compatible: new schema can read old data
  - [ ] Forward compatible: old schema can read new data
  - [ ] Breaking changes: add to DLQ, version the topic, or run parallel consumers
- [ ] **Schema evolution**: add optional fields (safe), remove optional fields (safe), change types (dangerous)
- [ ] Design decision: CDC is the bridge between "database-centric" and "event-driven" architectures

## Module 7: Consumer Lag & Backpressure
- [ ] **Consumer lag**: how far behind the consumer is from the latest produced message
  - [ ] Lag = latest offset - consumer offset
  - [ ] Critical metric: if lag grows, consumer can't keep up → data freshness degrades
- [ ] **Causes of lag**: slow processing, insufficient consumers, GC pauses, downstream bottleneck
- [ ] **Backpressure**: when producers outpace consumers
  - [ ] **Buffer**: queue absorbs burst (Kafka partitions = natural buffer)
  - [ ] **Drop**: discard old/low-priority events (acceptable for metrics, not for payments)
  - [ ] **Throttle producer**: rate limit or block producers (SQS, reactive streams)
  - [ ] **Scale consumers**: add more consumer instances (requires enough partitions)
- [ ] **Monitoring**: alert on consumer lag growth rate, not just absolute lag
- [ ] **Partition count**: can't have more consumers than partitions — plan partition count for max parallelism
- [ ] Design decision: always design for backpressure scenarios — "what if consumers are 10x slower?"

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design a real-time fraud detection system — justify stream processing over batch |
| Module 2 | Draw timeline: 5 events with event-time vs arrival-time — show how processing-time aggregation gives wrong results |
| Module 3 | Design windowing for "trending topics in last hour, updated every minute" |
| Module 4 | Explain watermark trade-off: what happens with 1-min watermark vs 10-min watermark for a mobile app? |
| Module 5 | Design exactly-once payment deduction from Kafka → database sink |
| Module 6 | Design CDC pipeline: PostgreSQL orders table → Kafka → Elasticsearch search index |
| Module 7 | Design consumer scaling strategy for Black Friday traffic spike (10x normal) |

## Key Resources
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 11: Stream Processing)
- **Streaming Systems** - Akidau, Chernyak, Lax (THE book on stream processing)
- "The World Beyond Batch: Streaming 101 & 102" - Tyler Akidau (foundational blog posts)
- Apache Flink documentation (concepts section)
- Confluent blog on Kafka Streams and exactly-once semantics
