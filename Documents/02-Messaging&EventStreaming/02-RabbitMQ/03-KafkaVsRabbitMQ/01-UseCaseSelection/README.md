# Kafka vs RabbitMQ: Use Case Selection - Curriculum

## Module 1: Fundamental Model Differences
- [ ] **RabbitMQ** = traditional message broker (smart broker, dumb consumers)
  - [ ] Broker routes messages based on exchange rules
  - [ ] Messages are acknowledged and REMOVED from queue
  - [ ] Push model (broker pushes to consumers)
  - [ ] Queue-centric
- [ ] **Kafka** = distributed append-only log (dumb broker, smart consumers)
  - [ ] Broker just appends to log
  - [ ] Messages REMAIN after consumption (until retention)
  - [ ] Pull model (consumers pull from partitions)
  - [ ] Log-centric
- [ ] **Core difference**: RabbitMQ deletes on consume, Kafka retains for retention period
- [ ] **Implication**: Kafka enables replay, RabbitMQ doesn't (except Streams)

## Module 2: Delivery Semantics
- [ ] **RabbitMQ**:
  - [ ] At-most-once: auto-ack
  - [ ] At-least-once: manual ack after processing
  - [ ] No native exactly-once (idempotent consumer required)
  - [ ] Per-message ack (individual message granularity)
- [ ] **Kafka**:
  - [ ] At-most-once: commit offset before processing
  - [ ] At-least-once: commit offset after processing (most common)
  - [ ] Exactly-once: transactions + read-committed consumer (within Kafka only)
  - [ ] Per-partition offset (batch granularity, implicit through position)
- [ ] **Both require idempotent consumers for true end-to-end exactly-once**

## Module 3: Routing & Flexibility
- [ ] **RabbitMQ wins on routing flexibility**:
  - [ ] Complex topologies: direct, fanout, topic, headers exchanges
  - [ ] Wildcard pattern matching in topic exchange
  - [ ] Per-message priority
  - [ ] Per-message TTL
  - [ ] Message-level routing decisions
- [ ] **Kafka is simpler**: topic + partition key, that's it
  - [ ] Partition key determines partition (no routing beyond that)
  - [ ] Consumer subscription is topic-level, not message-level
- [ ] **Use case for RabbitMQ**: task routing, selective subscriptions, complex filtering
- [ ] **Use case for Kafka**: event stream to be consumed by many consumers

## Module 4: Throughput Characteristics
- [ ] **RabbitMQ throughput**:
  - [ ] Classic queue: 20K-50K msg/sec per queue
  - [ ] Quorum queue: 10K-30K msg/sec per queue (slower due to replication)
  - [ ] Streams: 100K+ msg/sec
  - [ ] Overall: tens of thousands to low hundreds of thousands
- [ ] **Kafka throughput**:
  - [ ] Millions of messages/sec per cluster
  - [ ] Sequential disk I/O is hugely efficient
  - [ ] Per-partition: 10-100 MB/sec depending on config
- [ ] **Scaling**:
  - [ ] RabbitMQ: scale via more queues, more consumers
  - [ ] Kafka: scale via more partitions (horizontal)
- [ ] **Rule of thumb**: if you need > 100K msg/sec sustained, lean Kafka

## Module 5: Retention & Replay
- [ ] **RabbitMQ**: messages deleted on ack (no replay by default)
  - [ ] **Streams**: append-only log, supports replay from offset/timestamp
- [ ] **Kafka**: retention-based, replay by resetting consumer offset
  - [ ] Default retention: 7 days, often extended to weeks/months
  - [ ] Compacted topics keep latest value per key indefinitely
- [ ] **Use case for replay**:
  - [ ] Bug fix → reprocess old data
  - [ ] New consumer → historical events
  - [ ] Event sourcing → rebuild state
- [ ] **If replay matters**: choose Kafka (or RabbitMQ Streams)

## Module 6: Ordering Guarantees
- [ ] **RabbitMQ**: FIFO within a queue, one consumer
  - [ ] Multiple consumers on same queue = NO ordering guarantee
  - [ ] Single Active Consumer (SAC) preserves ordering with failover
- [ ] **Kafka**: strict ordering within a partition
  - [ ] Key → partition → ordered events for that key
  - [ ] Across partitions: no ordering
- [ ] **Both support**: ordered processing per key (partition/queue key)
- [ ] **Fine-grained ordering at high concurrency**: Kafka wins (many partitions)

## Module 7: When to Choose RabbitMQ
- [ ] **Task queues**: background jobs, worker pools (image processing, email)
- [ ] **Complex routing**: need topic/headers exchanges, per-message priority/TTL
- [ ] **Request-reply**: synchronous RPC over async messaging
- [ ] **Lower volume, lower latency**: 1-100K msg/sec sweet spot
- [ ] **Simple setup**: easier to operate, less tuning required
- [ ] **Protocol diversity**: AMQP + STOMP + MQTT + (WebSockets via plugins)
- [ ] **Short-lived, ephemeral messages**: immediate delivery, no retention
- [ ] **Delayed delivery**: per-message delays via plugin
- [ ] **Legacy systems**: AMQP is a standard, integrates with many tools
- [ ] **Multi-protocol broker**: when you need STOMP or MQTT alongside AMQP

## Module 8: When to Choose Kafka
- [ ] **Event streaming**: continuous high-volume event flow
- [ ] **Event sourcing**: log is source of truth, rebuild state
- [ ] **Log aggregation**: application logs, metrics, audit trails
- [ ] **Stream processing**: Kafka Streams, Flink, ksqlDB
- [ ] **Data pipelines**: CDC, ETL, data lake ingestion
- [ ] **High throughput**: > 100K msg/sec sustained
- [ ] **Long retention**: days/weeks/months of events
- [ ] **Replay needed**: reprocess, new consumers, debugging
- [ ] **Multiple consumer groups**: each group independently consumes all events
- [ ] **Exactly-once streaming**: within Kafka ecosystem
- [ ] **Ordered events per key at high scale**: partition-based ordering

## Module 9: Hybrid Architectures
- [ ] **Using both together**: common at scale, each for what it's best at
- [ ] **Pattern 1**: Kafka for events, RabbitMQ for tasks
  - [ ] Kafka: domain events, analytics, data pipelines
  - [ ] RabbitMQ: background jobs, priority queues, RPC
- [ ] **Pattern 2**: RabbitMQ for real-time notifications, Kafka for durable stream
  - [ ] RabbitMQ: fan-out notifications to WebSocket servers
  - [ ] Kafka: audit log, analytics, event store
- [ ] **Pattern 3**: Kafka Connect bridges to RabbitMQ
  - [ ] Sink events from Kafka into RabbitMQ for routing
  - [ ] Source events from RabbitMQ into Kafka for processing/retention
- [ ] **Pattern 4**: migration — gradually move from RabbitMQ to Kafka (or vice versa)
- [ ] **Operational cost**: running both adds complexity — justify the value

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Write a paragraph explaining Kafka and RabbitMQ to a non-technical person |
| Module 2 | Implement at-least-once delivery in both, compare ack mechanics |
| Module 3 | Build same routing logic in RabbitMQ (topic exchange) and Kafka (consumer filter) |
| Module 4 | Benchmark throughput on same hardware, similar workload |
| Module 5 | Demonstrate replay in Kafka vs Streams in RabbitMQ |
| Module 6 | Test ordering with 3 consumers, single key |
| Modules 7-8 | Given 5 scenarios, justify RabbitMQ or Kafka choice |
| Module 9 | Design hybrid architecture for an e-commerce platform |

## Key Resources
- "Kafka vs RabbitMQ" — Confluent comparison
- "Choosing between Kafka and RabbitMQ" — CloudAMQP blog
- "Designing Data-Intensive Applications" — Martin Kleppmann (Chapter 11)
- RabbitMQ and Kafka official documentation
