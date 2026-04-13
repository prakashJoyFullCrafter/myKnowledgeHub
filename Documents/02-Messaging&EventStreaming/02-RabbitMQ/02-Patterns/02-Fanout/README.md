# RabbitMQ Fanout & Pub/Sub Pattern - Curriculum

## Module 1: Fanout Exchange Fundamentals
- [ ] **Fanout exchange**: broadcasts messages to ALL bound queues, ignoring routing key
- [ ] Simplest and fastest exchange type (no routing logic)
- [ ] **Pub/Sub pattern**: publisher doesn't know about subscribers
- [ ] **Architecture**:
  ```
  Publisher → Fanout Exchange → Queue 1 → Subscriber 1
                             → Queue 2 → Subscriber 2
                             → Queue 3 → Subscriber 3
  ```
- [ ] **Each subscriber has its OWN queue** — different from work queues (shared queue)
- [ ] **Use cases**: notifications, cache invalidation, event broadcasting, audit logging

## Module 2: Temporary Queues for Subscribers
- [ ] **Anonymous queue**: queue with empty name → broker generates unique name
  - [ ] `channel.queueDeclare()` returns generated name like `amq.gen-abc123`
- [ ] **Exclusive**: only this connection can use it
- [ ] **Auto-delete**: deleted when last consumer disconnects
- [ ] **Common pattern for subscribers**:
  1. [ ] Subscriber creates anonymous, exclusive, auto-delete queue
  2. [ ] Binds queue to fanout exchange
  3. [ ] Consumes from queue
  4. [ ] On disconnect: queue is automatically cleaned up
- [ ] **Advantages**: no manual cleanup, no stale queues after client restart
- [ ] **Disadvantages**: messages lost while subscriber is offline

## Module 3: Persistent Subscribers vs Temporary
- [ ] **Temporary subscribers**: anonymous queue, receive only while connected
  - [ ] Use case: UI clients, real-time dashboards, monitoring
- [ ] **Persistent subscribers**: named durable queue, receive messages even while offline
  - [ ] Use case: critical business events, audit logs, analytics
  - [ ] Queue persists, messages accumulate while subscriber is down
  - [ ] Must manage queue lifecycle (cleanup when deprecated)
- [ ] **Competing consumers within a subscriber**: multiple workers on same named queue
  - [ ] Scales processing within one logical subscriber
  - [ ] Each message processed once within that subscriber

## Module 4: Fanout Use Cases Deep Dive
- [ ] **Event broadcasting**: notify all services of a domain event
  - [ ] `order.created` → broadcast → inventory, shipping, analytics, email
- [ ] **Cache invalidation**: notify all app instances to invalidate cache
  - [ ] Each instance has its own queue → all instances receive
- [ ] **Live notifications**: broadcast to all connected WebSocket servers
- [ ] **Configuration updates**: notify all services of config change
- [ ] **Audit/compliance**: every service sends events to a central audit logger
- [ ] **Distributed tracing**: broadcast trace samples to all collectors

## Module 5: Fanout vs Topic Exchange
- [ ] **Fanout**: broadcast to all → every subscriber gets every message
  - [ ] Simple, fast, no filtering
  - [ ] Wasteful if subscribers only care about subset of events
- [ ] **Topic**: pattern-based routing → subscribers filter via binding patterns
  - [ ] More flexible — subscribe to specific event types
  - [ ] Slight routing overhead
- [ ] **When to use Fanout**:
  - [ ] Truly everyone needs every message (cache invalidation)
  - [ ] Small, fixed set of subscribers
  - [ ] Maximum simplicity and speed
- [ ] **When to use Topic**:
  - [ ] Subscribers want selective subscriptions
  - [ ] Event taxonomy with categories
  - [ ] Future subscribers with different interests
- [ ] **Rule of thumb**: start with topic exchange, fallback to fanout if genuinely broadcasting

## Module 6: Scaling Fanout
- [ ] **Many subscribers**: each subscriber = 1 queue + N consumers
  - [ ] 100 subscribers × 3 workers = 100 queues, 300 channels
  - [ ] Broker memory scales with queue count
- [ ] **Broadcast storm**: single publish multiplied by subscriber count
  - [ ] 1000 msg/s × 100 subscribers = 100K msg/s delivered
  - [ ] Network and broker load proportional
- [ ] **Thundering herd**: all subscribers react to same event simultaneously
  - [ ] Overwhelms downstream services
  - [ ] Mitigation: jitter, rate limiting, circuit breakers downstream
- [ ] **Alternative for high-fanout**: RabbitMQ Streams (single log, many readers, no duplication)
  - [ ] Better for 1000+ subscribers, long retention, replay

## Module 7: Message Duplication & Idempotency
- [ ] **Each subscriber's queue gets its own copy** — RabbitMQ duplicates the message
- [ ] **Same subscriber multiple consumers**: competing for queue (load balanced)
- [ ] **Different subscribers**: independent copies, independent processing
- [ ] **Idempotency still matters**: retries, redelivery, network issues
- [ ] **Message ID for dedup**: use `message-id` property to detect duplicates
- [ ] **Consumer-side deduplication**: track processed message IDs (in DB or Redis)

## Module 8: Anti-Patterns & Best Practices
- [ ] **Anti-pattern**: fanout with thousands of subscribers
  - [ ] Fix: consider Streams or Kafka for high-fanout scenarios
- [ ] **Anti-pattern**: persistent queues for temporary subscribers
  - [ ] Fix: use auto-delete + exclusive queues
- [ ] **Anti-pattern**: slow consumer on fanout exchange
  - [ ] Fix: consumer timeout, queue length limits, graceful degradation
- [ ] **Anti-pattern**: fanout for work distribution (should be work queue)
- [ ] **Best practice**: one queue per logical subscriber (not per consumer instance)
- [ ] **Best practice**: monitor per-queue depth and consumer count
- [ ] **Best practice**: set queue length limits to prevent runaway in failure scenarios

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build notification service with fanout exchange and 3 subscribers |
| Module 2 | Implement UI dashboard with temporary queues for live updates |
| Module 3 | Compare temporary vs persistent subscriber behavior during disconnection |
| Module 4 | Build cache invalidation system for a multi-instance app |
| Module 5 | Refactor fanout to topic exchange with selective subscriptions |
| Module 6 | Benchmark broker with 10 vs 100 vs 1000 fanout subscribers |
| Module 7 | Implement consumer-side deduplication with Redis |
| Module 8 | Audit a sample topology for fanout anti-patterns |

## Key Resources
- RabbitMQ Tutorial 3: Publish/Subscribe
- RabbitMQ documentation — Exchanges (fanout section)
- "RabbitMQ in Depth" — Chapter 3
