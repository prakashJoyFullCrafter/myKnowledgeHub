# RabbitMQ Exchanges & Queues - Curriculum

## Module 1: The AMQP Mental Model
- [ ] **RabbitMQ is NOT a queue broker** — it's a message router with queues
- [ ] **Producers publish to exchanges**, never directly to queues
- [ ] **Consumers consume from queues**, never directly from exchanges
- [ ] **Bindings** connect exchanges to queues with routing rules
- [ ] Flow: `Producer → Exchange → (binding) → Queue → Consumer`
- [ ] This decoupling is what makes RabbitMQ flexible — producers know nothing about queues
- [ ] Contrast with Kafka: Kafka producers write to topics (queues), no exchange layer

## Module 2: Queues Fundamentals
- [ ] **Queue**: ordered (FIFO) buffer for messages
- [ ] **Queue name**: string, up to 255 bytes — names starting with `amq.` are reserved
- [ ] **Queue properties**:
  - [ ] `durable` — queue survives broker restart (metadata saved to disk)
  - [ ] `exclusive` — only the declaring connection can use it, auto-deleted on disconnect
  - [ ] `auto-delete` — deleted when last consumer unsubscribes
  - [ ] `arguments` — optional arguments (TTL, max length, queue type, etc.)
- [ ] **Durability is independent of message persistence** — durable queue + transient message = lost on restart
- [ ] Each queue is an **Erlang process** — lightweight, isolated, supervised
- [ ] Queue lives on ONE node (its "home" node) unless quorum/classic mirrored

## Module 3: Queue Types
- [ ] **Classic queue** (default, legacy):
  - [ ] Single node, not replicated by default
  - [ ] Uses classic mirrored queues policy for HA (deprecated in 3.13+)
  - [ ] Fast for transient, simple use cases
- [ ] **Quorum queue** (recommended for HA, since 3.8):
  - [ ] Raft-based replicated queue
  - [ ] Strong consistency, automatic leader election
  - [ ] Always durable, always persistent
  - [ ] Declared with `x-queue-type: quorum` argument
  - [ ] Limitations: no priority, no exclusive, no transient
- [ ] **Stream** (since 3.9):
  - [ ] Append-only log, Kafka-like semantics
  - [ ] Replicated, supports replay from offset
  - [ ] Declared with `x-queue-type: stream`
  - [ ] Different protocol for reads (binary streaming)
- [ ] **Classic vs Quorum vs Stream — decision guide**:
  - [ ] Traditional message queue → Quorum (since 3.8)
  - [ ] Append-only log / replay needed → Stream
  - [ ] Legacy or ephemeral → Classic

## Module 4: Queue Arguments
- [ ] **TTL (Time To Live)**:
  - [ ] Per-queue: `x-message-ttl` (all messages expire after N ms)
  - [ ] Per-message: `expiration` property (individual message TTL)
  - [ ] Queue TTL: `x-expires` (queue itself is deleted if unused for N ms)
- [ ] **Length limits**:
  - [ ] `x-max-length` — max number of messages
  - [ ] `x-max-length-bytes` — max total size in bytes
- [ ] **Overflow behavior** (`x-overflow`):
  - [ ] `drop-head` (default): drop oldest when full
  - [ ] `reject-publish`: reject new publishes when full
  - [ ] `reject-publish-dlx`: reject and dead-letter
- [ ] **Dead-letter configuration**:
  - [ ] `x-dead-letter-exchange`: where to send dead letters
  - [ ] `x-dead-letter-routing-key`: optional routing key override
- [ ] **Priority queues** (classic only):
  - [ ] `x-max-priority` — enable priority (1-255)
  - [ ] Higher priority messages delivered first

## Module 5: Exchange Types
- [ ] **Direct exchange**:
  - [ ] Routes by exact routing key match
  - [ ] Use case: unicast, load balancing to one consumer group
  - [ ] Example: `order.created` → routes to queues bound with exactly `order.created`
- [ ] **Fanout exchange**:
  - [ ] Ignores routing key, broadcasts to ALL bound queues
  - [ ] Use case: pub/sub, event broadcasting, cache invalidation
  - [ ] Fastest exchange type (no routing logic)
- [ ] **Topic exchange**:
  - [ ] Routes by routing key pattern matching
  - [ ] Wildcards: `*` (one word), `#` (zero or more words)
  - [ ] Use case: selective subscription, event taxonomies
  - [ ] Example: `logs.#` matches `logs.error.db`, `logs.info.api`
- [ ] **Headers exchange**:
  - [ ] Routes by message headers (not routing key)
  - [ ] `x-match=all` (all headers match) or `x-match=any` (any header matches)
  - [ ] Rarely used — topic exchange usually suffices
- [ ] **Consistent-hash exchange** (plugin):
  - [ ] Routes by hash of routing key → distribute across N queues
  - [ ] Use case: partitioning messages across workers

## Module 6: Special Exchanges
- [ ] **Default exchange**: nameless exchange (empty string ""), direct type
  - [ ] Automatically binds every queue with routing key = queue name
  - [ ] Convenient for simple send-to-queue scenarios
  - [ ] `channel.basicPublish("", "my-queue", ...)` → goes to "my-queue"
- [ ] **Reserved exchanges** (`amq.*`):
  - [ ] `amq.direct`, `amq.fanout`, `amq.topic`, `amq.headers`
  - [ ] Pre-declared, cannot be deleted
- [ ] **Alternate exchange** (`alternate-exchange` argument):
  - [ ] Fallback for unroutable messages (instead of dropping)
  - [ ] Used for debugging and unrouted message capture

## Module 7: Exchange & Queue Declaration
- [ ] **Declaration is idempotent** — safe to call multiple times if properties match
- [ ] **Property mismatch = error** — declaring with different properties causes `PRECONDITION_FAILED`
- [ ] **Passive declaration** (`passive=true`): check existence without creating
- [ ] **Who declares what**:
  - [ ] Producers and consumers can both declare — declare on startup (idempotent)
  - [ ] Alternative: deploy-time declaration via management UI or scripts
- [ ] **Declarative best practice**:
  - [ ] Version-control topology (exchanges, queues, bindings) as code
  - [ ] Use Spring AMQP `@Bean` or `definitions.json` for initial setup

## Module 8: Lifecycle & Anti-Patterns
- [ ] **Queue creation storm**: creating thousands of short-lived queues → overwhelms broker
  - [ ] Fix: reuse queues, use temporary queues only when needed
- [ ] **Unbounded queues**: no length limits → memory runaway → broker alarm
  - [ ] Fix: always set `x-max-length` or `x-max-length-bytes`
- [ ] **Forgotten temporary queues**: not auto-deleted, accumulate over time
  - [ ] Fix: use `auto-delete=true` + `exclusive=true` for temporary
- [ ] **Persistent to transient queue**: messages lost on restart despite `delivery-mode=2`
  - [ ] Fix: durable queue + persistent message + publisher confirms
- [ ] **Priority on high-volume queue**: priority queues are slower than normal
  - [ ] Fix: use multiple queues with separate consumers instead
- [ ] **Fanout with thousands of consumers**: each gets own queue → O(N) routing overhead
  - [ ] Fix: consider pub/sub via Streams for high-fanout scenarios

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Publish and consume with default exchange — observe the queue-name routing |
| Module 3 | Create classic, quorum, and stream queue — compare behavior on node restart |
| Module 4 | Set TTL + max-length + DLX, observe message expiration and DLQ routing |
| Module 5 | Create all 4 exchange types, bind queues, test routing behavior |
| Module 6 | Configure alternate exchange, publish unroutable message, observe fallback |
| Module 7 | Declare topology via Spring `@Bean` definitions with version control |
| Module 8 | Identify 3 anti-patterns in a sample config and fix them |

## Key Resources
- RabbitMQ documentation — Queues, Exchanges, Bindings
- "RabbitMQ in Depth" — Gavin Roy (Chapters 2-4)
- RabbitMQ Tutorials (rabbitmq.com/getstarted)
- "Quorum Queues" — rabbitmq.com/quorum-queues.html
