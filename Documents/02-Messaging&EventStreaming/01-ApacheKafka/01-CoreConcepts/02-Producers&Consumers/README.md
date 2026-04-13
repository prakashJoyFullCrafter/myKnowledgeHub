# Kafka Producers & Consumers - Curriculum

## Module 1: Producer API Fundamentals
- [ ] `KafkaProducer<K, V>` — thread-safe, reusable, heavyweight (create once)
- [ ] `ProducerRecord(topic, partition, key, value, headers)` — partition/key optional
- [ ] Send methods:
  - [ ] **Fire-and-forget**: `producer.send(record)` — no delivery guarantee
  - [ ] **Synchronous**: `producer.send(record).get()` — blocks, slow
  - [ ] **Asynchronous with callback**: `producer.send(record, callback)` — recommended
- [ ] `Future<RecordMetadata>` returned — contains offset, timestamp, partition
- [ ] `producer.flush()` — block until all buffered records are sent
- [ ] `producer.close()` — graceful shutdown, flushes pending records

## Module 2: Producer Acknowledgements & Durability
- [ ] **`acks=0`** (fire-and-forget): no ack, fastest, data loss possible
- [ ] **`acks=1`** (leader ack): leader confirms, data loss if leader crashes before replication
- [ ] **`acks=all`** (or `acks=-1`): all ISR confirm, strongest durability
  - [ ] Combined with `min.insync.replicas=2` for true no-data-loss
- [ ] **Durability vs latency trade-off**: `acks=all` adds latency of slowest ISR
- [ ] `retries` (default: Integer.MAX_VALUE) — auto-retry on retriable errors
- [ ] `retry.backoff.ms` — wait between retries
- [ ] `delivery.timeout.ms` — upper bound on total time for send (default 2 min)

## Module 3: Producer Batching & Compression
- [ ] **Batch**: group of records to same partition sent together
- [ ] `batch.size` (bytes, default 16KB): max batch size before sending
- [ ] `linger.ms` (default 0): wait time to accumulate more records before sending
- [ ] Higher `linger.ms` + larger `batch.size` → better throughput, higher latency
- [ ] **Compression**: `compression.type=none|gzip|snappy|lz4|zstd`
  - [ ] `lz4`: fast compression, good ratio (recommended default)
  - [ ] `zstd`: better ratio, more CPU (new workloads)
  - [ ] Compression applied per batch, broker stores compressed
- [ ] `buffer.memory` (default 32MB): producer-side buffer
- [ ] `max.block.ms`: block if buffer full (backpressure)

## Module 4: Partitioner & Keys
- [ ] Default partitioner (since 2.4): **sticky partitioner**
  - [ ] With key: `murmur2(key) % num_partitions`
  - [ ] Without key: sticks to one partition per batch, rotates on batch send
- [ ] **UniformStickyPartitioner** (older): better distribution than round-robin
- [ ] **Custom partitioner**: implement `Partitioner` interface
- [ ] **Key semantics**:
  - [ ] Same key → same partition → ordered processing per key
  - [ ] Null key → distributed across partitions
  - [ ] Use `user_id`, `order_id`, `device_id` as key for related-event ordering
- [ ] **Headers**: metadata attached to records (not key/value), useful for tracing, routing, schema ID

## Module 5: Idempotent Producer
- [ ] **Problem**: retries can cause duplicates (network timeout, retry, original also succeeded)
- [ ] `enable.idempotence=true` (default since Kafka 3.0)
- [ ] Producer gets a PID (producer ID) from broker
- [ ] Each message has a sequence number per (PID, partition)
- [ ] Broker deduplicates based on sequence number
- [ ] Prerequisites: `acks=all`, `max.in.flight.requests.per.connection<=5`, `retries>0`
- [ ] Guarantees exactly-once SEND to a partition (within single session)
- [ ] Does NOT guarantee exactly-once across producer restarts (need transactions for that)

## Module 6: Consumer API Fundamentals
- [ ] `KafkaConsumer<K, V>` — NOT thread-safe, one per thread
- [ ] `subscribe(Collection<String> topics)` — dynamic assignment, rebalance-aware
- [ ] `assign(Collection<TopicPartition>)` — manual partition assignment (no rebalance)
- [ ] **Poll loop** is the core pattern:
  ```
  while (running) {
      ConsumerRecords<K,V> records = consumer.poll(Duration.ofMillis(100));
      process(records);
      consumer.commitSync(); // or async
  }
  ```
- [ ] `poll()` must be called regularly — else consumer is considered dead (rebalance)
- [ ] `consumer.close()` — commits offsets, leaves group cleanly

## Module 7: Consumer Configuration
- [ ] **Critical configs**:
  - [ ] `group.id`: consumer group identifier
  - [ ] `bootstrap.servers`: broker list
  - [ ] `auto.offset.reset`: `earliest` | `latest` | `none` (behavior on no committed offset)
  - [ ] `enable.auto.commit`: true (default) or false for manual control
  - [ ] `auto.commit.interval.ms`: auto-commit frequency
- [ ] **Poll behavior**:
  - [ ] `max.poll.records`: max records per poll (default 500)
  - [ ] `max.poll.interval.ms`: max time between polls before considered failed (default 5 min)
  - [ ] `fetch.min.bytes`, `fetch.max.wait.ms`: server-side batching
  - [ ] `fetch.max.bytes`, `max.partition.fetch.bytes`: max bytes per fetch
- [ ] **Session management**:
  - [ ] `session.timeout.ms`: how long before coordinator considers consumer dead (default 45s)
  - [ ] `heartbeat.interval.ms`: heartbeat frequency (default 3s)

## Module 8: Serialization & Error Handling
- [ ] **Built-in serializers**: String, Integer, Long, ByteArray, UUID
- [ ] **JSON**: custom serializer or `JsonSerializer` from Spring Kafka
- [ ] **Avro** (recommended for production): compact, schema evolution, requires Schema Registry
- [ ] **Protobuf**: compact, schema evolution, gRPC-friendly
- [ ] **Deserialization errors** ("poison pills"):
  - [ ] `DeserializationExceptionHandler` (Kafka Streams)
  - [ ] `ErrorHandlingDeserializer` (Spring Kafka): wraps deserializer, routes errors
  - [ ] Skip, DLQ, or stop on poison pill — design decision
- [ ] **Schema compatibility**: enforce via Schema Registry to prevent poison pills at source

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build producer that sends 10K records with callback, measure async vs sync throughput |
| Module 2 | Measure latency for `acks=0`, `acks=1`, `acks=all` under various loads |
| Module 3 | Tune `batch.size` + `linger.ms`, measure throughput improvement |
| Module 4 | Build producer with custom partitioner routing by tenant_id |
| Module 5 | Enable idempotence, simulate retry scenarios, verify no duplicates |
| Module 6 | Build consumer with manual commit, handle graceful shutdown |
| Module 7 | Tune `max.poll.records` for slow processing, avoid rebalance |
| Module 8 | Inject poison pill, handle with `ErrorHandlingDeserializer` + DLQ |

## Key Resources
- Kafka: The Definitive Guide — Chapters 3-4
- Confluent Producer/Consumer tutorials
- "Kafka Producer Best Practices" — Confluent blog
