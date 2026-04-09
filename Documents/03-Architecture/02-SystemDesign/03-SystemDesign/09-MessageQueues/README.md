# Message Queues (System Design View) - Curriculum

System design perspective on asynchronous messaging. Complements the Kafka/RabbitMQ deep dives in Section 02.

---

## Module 1: Why Message Queues?
- [ ] **Decoupling**: producer doesn't need to know about consumers
- [ ] **Async processing**: respond immediately, process later (email, notifications, reports)
- [ ] **Load leveling**: absorb traffic spikes, consumers process at their own pace
- [ ] **Reliability**: messages persist even if consumers are down
- [ ] **Fan-out**: one event triggers multiple independent actions
- [ ] Synchronous vs asynchronous communication trade-offs

## Module 2: Messaging Models
- [ ] **Point-to-point (Queue)**: one producer, one consumer per message
  - [ ] Use case: task queue, job processing, work distribution
- [ ] **Publish-Subscribe (Topic)**: one producer, multiple consumers receive the same message
  - [ ] Use case: event broadcasting, notifications, data sync across services
- [ ] **Request-Reply**: async request with correlation ID, response on separate queue
- [ ] **Priority Queue**: high-priority messages processed first
- [ ] **Dead Letter Queue (DLQ)**: failed messages routed for inspection/retry

## Module 3: Delivery Semantics
- [ ] **At-most-once**: fire and forget — message may be lost, never duplicated
  - [ ] Fastest, use for metrics/logs where loss is acceptable
- [ ] **At-least-once**: retry until acknowledged — message may be duplicated
  - [ ] Most common, requires idempotent consumers
- [ ] **Exactly-once**: message processed exactly once — hardest to achieve
  - [ ] Kafka transactional API, deduplication at consumer
- [ ] **Idempotent consumers**: processing same message twice produces same result
  - [ ] Strategies: deduplication key, database unique constraint, idempotency token

## Module 4: Ordering, Partitioning & Backpressure
- [ ] **Message ordering**: guaranteed within partition/queue, not across
- [ ] **Partitioning**: split topic by key for parallel processing with ordering per key
- [ ] **Consumer groups**: each message processed by one consumer in the group (load balancing)
- [ ] **Backpressure**: when consumers can't keep up with producers
  - [ ] Solutions: buffering, rate limiting producers, scaling consumers, dropping messages
- [ ] **Message TTL**: expire old messages to prevent unbounded queue growth

## Module 5: Technology Comparison
- [ ] **Apache Kafka**: distributed log, high throughput, replayable, partitioned
  - [ ] Best for: event streaming, event sourcing, log aggregation, high-volume
- [ ] **RabbitMQ**: traditional message broker, routing, exchanges, flexible
  - [ ] Best for: task queues, complex routing, request-reply, moderate volume
- [ ] **Amazon SQS**: managed queue, no ops, auto-scaling
  - [ ] Best for: simple task queues on AWS, decoupling microservices
- [ ] **Amazon SNS**: managed pub-sub, fan-out to SQS/Lambda/HTTP
- [ ] **Google Pub/Sub**: managed, global, auto-scaling
- [ ] **Redis Streams**: lightweight streaming, good for moderate throughput
- [ ] Decision guide: throughput needs × routing complexity × operational burden × cloud vs self-hosted

## Module 6: Messaging in System Design
- [ ] **Event-driven architecture**: services communicate via events, not API calls
- [ ] **Outbox pattern**: write to DB + outbox table atomically, poll outbox to publish
- [ ] **Saga pattern**: coordinate distributed transactions via messaging
- [ ] **CQRS**: separate read and write models, sync via events
- [ ] **Event sourcing**: store events as source of truth, rebuild state by replaying
- [ ] **Choreography vs orchestration**: events vs central coordinator
- [ ] Messaging anti-patterns: distributed monolith, event soup, hidden coupling

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Design order processing: order-service → queue → payment, inventory, notification |
| Module 3 | Implement idempotent consumer with deduplication table |
| Module 4 | Partition a Kafka topic by user_id, observe ordering guarantees |
| Module 5 | Same use case on Kafka vs RabbitMQ vs SQS — compare complexity and performance |
| Module 6 | Design event-driven e-commerce with outbox pattern and saga |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapter 11)
- Enterprise Integration Patterns - Hohpe & Woolf
- "The Log" - Jay Kreps (Kafka creator, foundational blog post)
- System Design Interview - Alex Xu
