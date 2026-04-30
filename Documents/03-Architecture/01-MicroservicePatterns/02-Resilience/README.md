# Resilience Patterns

Patterns for building fault-tolerant microservices.

1. **Circuit Breaker** - States, transitions, fallbacks, Resilience4j, monitoring (4 modules)
2. **Retry & Backoff** - Exponential backoff, jitter, idempotency, retry budget (4 modules)
3. **Bulkhead** - Thread pool vs semaphore, isolation, sizing, combining with circuit breaker (4 modules)
4. **Rate Limiting** - Token bucket, sliding window, distributed limiting, HTTP 429 (4 modules)
5. **Idempotency** - Idempotency keys, dedup tables, idempotent consumers, exactly-once semantics (5 modules)
6. **Distributed Lock** - Mutual exclusion across processes, fencing tokens, Redis/ZK/etcd, Kleppmann critique (5 modules)
7. **Backpressure & Flow Control** - Pull vs push, Reactive Streams, Kafka/RabbitMQ flow control, load shedding (6 modules)
