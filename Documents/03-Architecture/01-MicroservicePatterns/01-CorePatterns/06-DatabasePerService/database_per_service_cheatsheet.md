# Database per Service — One-Page Cheat Sheet

## Definition
Each microservice owns its own database and no other service can access it directly.  
All cross-service data access must go through APIs or events, ensuring loose coupling and independent evolution.

---

## Core Components

| Component | Role | Key Property |
|----------|------|-------------|
| Service | Owns business logic + data | Autonomous |
| Database | Private data store | Exclusive ownership |
| API Layer | Exposes data externally | Controlled contract |
| Event Bus | Async communication | Decoupling |
| Read Models (CQRS) | Precomputed views | Fast queries |
| Saga Coordinator | Manages workflows | Eventual consistency |

---

## Key Algorithms / Protocols

- API Composition — Aggregate data via multiple service calls  
- CQRS — Separate read/write models for performance  
- Saga Pattern — Distributed transaction with compensations  
- Transactional Outbox — Reliable event publishing  
- Event-driven Sync — Keep local data copies updated  
- CDC (Change Data Capture) — Stream DB changes to other systems  

---

## Performance Numbers (Typical)

| Metric | Value |
|-------|------|
| API call latency | 10–100 ms |
| Redis lookup | <1 ms |
| PostgreSQL query | 5–20 ms |
| Elasticsearch search | 50–200 ms |
| Cassandra write | <5 ms |
| Kafka throughput | 100K–1M msgs/sec |
| Event propagation lag | ms–seconds |

---

## Configuration Knobs

| Knob | Default | Tuning Guidance |
|-----|--------|----------------|
| DB connection pool | 10–50 | Increase for high concurrency |
| API timeout | 2–5s | Reduce to avoid cascading failures |
| Retry policy | 3 retries | Use exponential backoff |
| Circuit breaker | Disabled | Enable for resilience |
| Cache TTL | 5–60 min | Shorter for dynamic data |
| Event batch size | 100–1000 | Increase for throughput |
| Replication lag alert | ~1s | Lower for critical systems |

---

## Failure Modes

| Failure | Mitigation |
|--------|-----------|
| Service unavailable | Retry + circuit breaker |
| Partial saga failure | Compensation actions |
| Stale data | TTL + fallback API call |
| Event duplication | Idempotent consumers |
| DB overload | Read replicas / caching |

---

## When to Use / Not Use

| Use When | Avoid When |
|---------|-----------|
| Need independent scaling | Small/simple system |
| Multiple teams/services | Low engineering maturity |
| Different data patterns | Strong consistency everywhere |
| High scalability needs | Tight latency requirements across services |

---

## Comparison vs Alternatives

| Approach | Pros | Cons |
|---------|------|------|
| Database per Service | Decoupled, scalable | Complex |
| Shared DB | Simple | Tight coupling |
| Monolith | Easy dev | Poor scaling |
| Data Lake | Great analytics | Not for transactions |

---

## Common Pitfalls

- Cross-service DB queries (breaks isolation)  
- Ignoring eventual consistency  
- Overusing synchronous API calls  
- Not handling duplicate events  
- Skipping proper data ownership boundaries  
