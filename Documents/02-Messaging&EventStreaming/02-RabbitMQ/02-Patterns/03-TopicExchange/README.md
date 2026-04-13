# RabbitMQ Topic Exchange Pattern - Curriculum

## Module 1: Topic Exchange Fundamentals
- [ ] **Topic exchange**: routes messages based on wildcard pattern matching against routing key
- [ ] Most flexible and commonly used exchange type
- [ ] **Routing key**: dot-separated words (e.g., `order.us.created`, `log.error.db`)
- [ ] **Binding key**: pattern with wildcards (e.g., `order.*.created`, `log.error.#`)
- [ ] Supports hierarchical event taxonomies
- [ ] **Use cases**: log routing, event subscription, multi-region routing, categorized notifications

## Module 2: Wildcards in Depth
- [ ] **`*` (star)**: matches EXACTLY one word
  - [ ] `order.*.created` matches `order.us.created`, `order.eu.created`
  - [ ] Does NOT match `order.created` (missing word) or `order.us.retail.created` (extra word)
- [ ] **`#` (hash)**: matches ZERO or MORE words
  - [ ] `order.#` matches `order`, `order.created`, `order.us.created.international`
  - [ ] `#.error.#` matches `db.error`, `api.error.500`, `auth.service.error.timeout.retry`
- [ ] **Combined**: `order.*.critical.#` matches `order.us.critical`, `order.eu.critical.fraud.detected`
- [ ] **Just `#`**: matches everything (equivalent to fanout)
- [ ] **Matching is word-level**, not substring — `order.created` doesn't match `ord.*`

## Module 3: Event Taxonomy Design
- [ ] **Design the routing key schema BEFORE implementation** — hard to change later
- [ ] **Pattern 1: entity.event**
  - [ ] `order.created`, `order.updated`, `user.registered`, `payment.failed`
  - [ ] Simple, common, good for most use cases
- [ ] **Pattern 2: entity.event.detail**
  - [ ] `order.created.international`, `payment.failed.insufficient_funds`
  - [ ] More granular, allows finer filtering
- [ ] **Pattern 3: bounded-context.entity.event**
  - [ ] `sales.order.created`, `billing.invoice.paid`
  - [ ] Good for microservice boundaries
- [ ] **Pattern 4: region.entity.event**
  - [ ] `us.order.created`, `eu.user.login`
  - [ ] Geographic routing across regions
- [ ] **Avoid**: putting IDs or data in routing key (unbounded cardinality)

## Module 4: Selective Subscription Patterns
- [ ] **Subscribe to all events of an entity**: `order.#`
- [ ] **Subscribe to specific event type**: `*.created` or `order.*.created`
- [ ] **Subscribe to error events across all services**: `#.error.#`
- [ ] **Subscribe to region-specific events**: `us.#`
- [ ] **Subscribe to critical alerts**: `*.critical.#` or `alert.critical.*`
- [ ] **Multi-subscription**: bind same queue with multiple patterns
  - [ ] Queue bound with `order.#` AND `payment.#` receives both entity types

## Module 5: Multi-Binding on Same Queue
- [ ] **Use case**: consumer cares about events matching multiple patterns
- [ ] **Pattern**:
  ```
  binding 1: queue bound to topic-exchange with pattern "order.created"
  binding 2: queue bound to topic-exchange with pattern "order.cancelled"
  binding 3: queue bound to topic-exchange with pattern "order.refunded"
  ```
- [ ] Message matching ANY binding → queue receives it (once, not duplicated)
- [ ] Alternative: single binding `order.*` — simpler but matches ALL order events
- [ ] **Trade-off**: explicit multi-binding (precise) vs wildcard (evolvable)

## Module 6: Topic Exchange Performance
- [ ] **Routing algorithm**: trie-based matching, efficient even with many bindings
- [ ] **Performance factors**:
  - [ ] Number of bindings on exchange
  - [ ] Pattern complexity (depth, wildcard use)
  - [ ] Routing key length
- [ ] **Scale**:
  - [ ] Up to ~10K bindings per exchange: performant
  - [ ] Beyond 100K bindings: noticeable overhead
- [ ] **Benchmarking**: measure with realistic binding count using PerfTest
- [ ] **Anti-pattern**: one binding per entity instance (millions of bindings)
  - [ ] Fix: use broader patterns, filter in application code

## Module 7: Topic Exchange vs Direct vs Fanout
- [ ] **Direct**: exact match, fastest, use for static routing
- [ ] **Topic**: pattern match, flexible, default choice for event routing
- [ ] **Fanout**: broadcast all, fastest broadcast, use for "everyone cares"
- [ ] **Decision**:
  - [ ] All subscribers want all messages → Fanout
  - [ ] Exact 1:1 routing key mapping → Direct
  - [ ] Hierarchical events with selective subscription → Topic ✓ (most common)
- [ ] **Migration path**: start with topic; add fanout/direct only if needed

## Module 8: Real-World Patterns
- [ ] **Log aggregation**:
  - [ ] Routing keys: `<service>.<level>.<component>`
  - [ ] Queue bound with `*.error.#` → error queue
  - [ ] Queue bound with `#` → all logs queue
- [ ] **Event-driven microservices**:
  - [ ] Each service publishes events with `<domain>.<event>` pattern
  - [ ] Other services subscribe to relevant patterns
  - [ ] Decoupled publishers and consumers
- [ ] **Multi-tenant routing**:
  - [ ] Include tenant in routing key: `tenant-abc.order.created`
  - [ ] Per-tenant consumers bound to `tenant-abc.#`
  - [ ] Alternative: separate vhosts (stronger isolation)
- [ ] **Notification routing**:
  - [ ] `notification.<channel>.<priority>`: `notification.email.high`
  - [ ] Email service binds with `notification.email.#`
  - [ ] High-priority service binds with `notification.*.high`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build log routing: publish with `app.level.component`, subscribe with patterns |
| Module 2 | Test all wildcard combinations, verify matching behavior |
| Module 3 | Design routing key schema for an e-commerce event system |
| Module 4 | Build 5 selective subscription patterns for a monitoring system |
| Module 5 | Implement queue with 3 bindings for different event types |
| Module 6 | Benchmark topic exchange with 100, 1K, 10K bindings |
| Module 7 | Refactor a fanout topology to topic exchange for better filtering |
| Module 8 | Design multi-tenant event routing for a SaaS platform |

## Key Resources
- RabbitMQ Tutorial 5: Topics
- rabbitmq.com/tutorials/tutorial-five-java.html
- "RabbitMQ in Depth" — Chapter 3
