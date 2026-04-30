# Message Queues — One-Page Cheat Sheet (Gold Tier)

## Definition
Message queues enable asynchronous, decoupled communication between services. They provide reliability, buffering, and scalability by separating producers from consumers.

---

## Core Components

| Component        | Role                              | Key Property |
|------------------|-----------------------------------|-------------|
| Producer         | Sends messages                    | Decoupled from consumers |
| Broker           | Stores & routes messages          | Durable / scalable |
| Queue / Topic    | Message storage abstraction       | FIFO / partitioned |
| Consumer         | Processes messages                | Competing / independent |
| Offset / ACK     | Tracks processing progress        | Enables reliability |

---

## Key Algorithms / Protocols
- At-least-once delivery → retry until ACK  
- At-most-once → auto-ACK before processing  
- Exactly-once → transactional + idempotent producer  
- Partitioning → hash(key) % N  
- Consumer groups → load balancing across partitions  
- Backpressure → throttle producers or scale consumers  

---

## Performance Numbers (Typical)
- Kafka: 1M+ msgs/sec, latency ~5–50 ms  
- RabbitMQ: ~10K–100K msgs/sec, latency ~1–10 ms  
- SQS: virtually unlimited throughput, latency ~10–100 ms  
- Pub/Sub: ~10M msgs/sec (managed)  
- Redis Streams: ~100K msgs/sec  

---

## Configuration Knobs

| Setting | Default | Guidance |
|--------|--------|---------|
| Partitions | Low (e.g. 1–3) | Increase for parallelism |
| Retention | 1–7 days | Set based on replay needs |
| Visibility Timeout | 30s | > max processing time |
| Batch Size | Small | Increase for throughput |
| Consumer Count | 1 | Scale with partitions |
| TTL | None / high | Set to max acceptable lag |
| ACK Mode | Manual | Use for reliability |

---

## Failure Modes

| Failure | Impact | Mitigation |
|--------|--------|-----------|
| Consumer crash | Duplicate processing | Idempotent consumer |
| Broker crash | Message loss | Persistence / replication |
| Slow consumers | Queue buildup | Auto-scale / backpressure |
| Network loss | ACK lost | Retry logic |
| Poison message | Infinite retries | DLQ |

---

## When to Use vs NOT Use

**Use when:**
- Async processing needed  
- Decoupling services  
- Handling traffic spikes  
- Multiple consumers  

**Do NOT use when:**
- Immediate response required  
- Strong ACID across services  
- Real-time bidirectional (use WebSockets)

---

## Comparison

| Feature | Kafka | RabbitMQ | SQS |
|--------|------|---------|-----|
| Model | Log | Broker | Queue |
| Replay | Yes | No | No |
| Throughput | Very high | Medium | High |
| Ops | High | Medium | None |
| Best for | Streaming | Routing | Simplicity |

---

## Common Pitfalls
- Not using idempotent consumers  
- Choosing bad partition key (hot partitions)  
- Ignoring backpressure  
- No DLQ configured  
- Overusing Kafka for simple use cases  

---

## Golden Rules
- Default: **At-least-once + idempotency**  
- Scale via **partitions + consumers**  
- Use **TTL + DLQ** for safety  
- Prefer **simple systems first (SQS/RabbitMQ)**  
- Use Kafka only when you need **replay + high throughput**
