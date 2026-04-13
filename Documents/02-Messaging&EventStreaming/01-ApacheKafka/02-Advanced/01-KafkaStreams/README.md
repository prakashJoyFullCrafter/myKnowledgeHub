# Kafka Streams - Curriculum

## Module 1: Kafka Streams Fundamentals
- [ ] **What is Kafka Streams**: Java library for stream processing ON TOP of Kafka
- [ ] NOT a separate cluster — runs inside your application (embedded)
- [ ] Kafka Streams vs Consumer API: higher level, stateful, fault-tolerant, exactly-once
- [ ] Kafka Streams vs Flink/Spark: simpler (library vs cluster), Kafka-only, lower ops overhead
- [ ] **When to use**: Kafka-to-Kafka transformations, aggregations, joins, materialized views
- [ ] **When NOT to use**: multi-source data (use Flink), ML pipelines, complex batch
- [ ] Requires Kafka for: input/output topics, state store backup, coordination

## Module 2: Topology & Processing Model
- [ ] **Topology**: directed acyclic graph (DAG) of processing nodes
- [ ] **Source processor**: reads from input topic
- [ ] **Stream processor**: transforms records (filter, map, join, aggregate)
- [ ] **Sink processor**: writes to output topic
- [ ] **Sub-topology**: independent partitioning unit, scaled by partition count
- [ ] **Stream threads**: `num.stream.threads` config — parallelism per instance
- [ ] **Tasks**: one per input partition per sub-topology, assigned to stream threads
- [ ] Horizontal scaling: add more instances, tasks redistribute automatically

## Module 3: KStream vs KTable vs GlobalKTable
- [ ] **KStream**: record stream — each record is independent event
  - [ ] "Alice bought coffee" (event, appended)
  - [ ] Every record is processed
- [ ] **KTable**: changelog stream — each record is an update to keyed state
  - [ ] "Alice's current balance is $100" (latest per key)
  - [ ] Backed by compacted topic + local state store
- [ ] **GlobalKTable**: replicated to ALL instances (not partitioned)
  - [ ] Use case: small reference data (countries, currencies, lookup tables)
  - [ ] Joins with GlobalKTable don't require co-partitioning
- [ ] **Duality**: KStream ↔ KTable — every stream is a changelog of a table

## Module 4: Stateless Operations
- [ ] `filter(predicate)`, `filterNot(predicate)`
- [ ] `map((k,v) -> newKV)`, `mapValues(v -> newV)`
- [ ] `flatMap`, `flatMapValues` — one record → multiple records
- [ ] `branch(predicates...)` — split stream into multiple streams
- [ ] `merge(stream)` — combine two streams
- [ ] `peek((k,v) -> ...)` — side effect, doesn't transform
- [ ] `foreach` — terminal operation with side effect
- [ ] `selectKey` — change the key (triggers repartitioning downstream)
- [ ] **Co-partitioning requirement**: joins require same key, same partition count, same partitioner

## Module 5: Stateful Operations & State Stores
- [ ] **Aggregations**: `groupByKey` → `count`, `reduce`, `aggregate`
- [ ] **State store**: local storage for aggregation results (RocksDB by default, can use in-memory)
- [ ] **Changelog topic**: backup of state store, compacted topic for fault tolerance
  - [ ] Named `<app-id>-<store-name>-changelog`
- [ ] On failure/rebalance: state is rebuilt by replaying changelog
- [ ] **Interactive queries**: query state stores directly (`store.get(key)`) for local state
- [ ] `KafkaStreams.store(StoreQueryParameters)` — access state store
- [ ] **Standby replicas**: `num.standby.replicas` — warm copies for faster recovery

## Module 6: Windowing
- [ ] **Tumbling window**: fixed-size, non-overlapping (every 5 min)
  - [ ] `TimeWindows.of(Duration.ofMinutes(5))`
- [ ] **Hopping window**: fixed-size, overlapping (5 min every 1 min)
  - [ ] `TimeWindows.of(5m).advanceBy(1m)`
- [ ] **Session window**: dynamic size, activity-based
  - [ ] `SessionWindows.with(Duration.ofMinutes(30))` — gap-based
- [ ] **Sliding window** (Kafka 2.7+): fires on every new record within window
- [ ] **Grace period**: allow late events up to N ms after window ends
- [ ] `suppress(Suppressed.untilWindowCloses(...))` — emit only after window closes
- [ ] **Windowed key**: stored as `(key, window)` — use `WindowStore` for queries

## Module 7: Joins
- [ ] **KStream-KStream join**: windowed (must specify window)
  - [ ] Inner, left, outer joins
  - [ ] Use case: correlate two event streams (click + impression)
- [ ] **KStream-KTable join**: non-windowed, enriches stream with table lookup
  - [ ] Inner, left join (no outer — makes no sense)
  - [ ] Use case: enrich events with reference data
- [ ] **KTable-KTable join**: non-windowed, maintains joined table state
  - [ ] Inner, left, outer joins
- [ ] **KStream-GlobalKTable join**: no co-partitioning required, no repartition
  - [ ] Use case: small lookup tables shared by all instances
- [ ] **Co-partitioning requirement** for KStream-KTable: same key, same partitions

## Module 8: Exactly-Once in Streams
- [ ] `processing.guarantee=exactly_once_v2` (since 2.5, recommended)
- [ ] Uses Kafka transactions under the hood
- [ ] Atomic: read input → update state → write output → commit offsets
- [ ] `exactly_once` (legacy, deprecated) vs `exactly_once_v2` (better performance)
- [ ] Performance impact: ~20-30% throughput reduction vs at-least-once
- [ ] Only works within Kafka — external sinks need separate idempotency

## Module 9: Error Handling & DLQ
- [ ] **DeserializationExceptionHandler**:
  - [ ] `LogAndContinueExceptionHandler` — log and skip bad records
  - [ ] `LogAndFailExceptionHandler` — stop processing on bad record
  - [ ] Custom handler: route to DLQ topic
- [ ] **ProductionExceptionHandler**: errors when producing to output topic
- [ ] **Uncaught exception handler**: fatal errors in processor code
  - [ ] `REPLACE_THREAD`, `SHUTDOWN_CLIENT`, `SHUTDOWN_APPLICATION`
- [ ] **Dead Letter Queue pattern**: route bad records to `<topic>.DLT`
- [ ] Testing error scenarios: inject bad records with TopologyTestDriver

## Module 10: Testing Kafka Streams
- [ ] **TopologyTestDriver**: unit test topology without running Kafka
  - [ ] `driver.createInputTopic()`, `driver.createOutputTopic()`
  - [ ] Send records, assert outputs
  - [ ] Fast, deterministic, no broker needed
- [ ] **EmbeddedKafka / Testcontainers**: integration tests with real broker
- [ ] Testing state stores: use `driver.getKeyValueStore()`
- [ ] Testing windowed aggregations: advance wall clock via `driver.advanceWallClockTime()`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build simple topology: read topic A, filter, write to topic B |
| Module 3 | Build KTable from a changelog topic, query latest value per key |
| Module 4 | Build stateless pipeline: tokenize, filter, route to topics |
| Module 5 | Build word count with state store, query via interactive queries |
| Module 6 | Build 5-minute tumbling window count of events per user |
| Module 7 | Enrich click stream with user table via KStream-KTable join |
| Module 8 | Enable exactly-once, measure throughput impact |
| Module 9 | Implement DLQ routing for deserialization errors |
| Module 10 | Write topology test with TopologyTestDriver covering happy path + error |

## Key Resources
- Kafka Streams documentation (kafka.apache.org/documentation/streams)
- "Mastering Kafka Streams and ksqlDB" — Mitch Seymour (O'Reilly)
- Confluent Kafka Streams tutorial
- "Kafka Streams in Action" — William P. Bejeck Jr.
