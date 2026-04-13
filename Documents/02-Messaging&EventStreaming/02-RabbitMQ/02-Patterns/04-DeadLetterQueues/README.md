# RabbitMQ Dead Letter Queues (DLQ) - Curriculum

## Module 1: What is a Dead Letter?
- [ ] **Dead letter**: a message that has failed to be processed successfully
- [ ] **Three conditions** that make a message dead-lettered:
  1. [ ] **Rejected** with `requeue=false` (basic.reject or basic.nack)
  2. [ ] **TTL expired** (message-level or queue-level)
  3. [ ] **Queue length exceeded** with `x-overflow=reject-publish-dlx`
- [ ] **Dead Letter Exchange (DLX)**: exchange where dead letters are routed
- [ ] **Dead Letter Routing Key**: optional override of routing key for dead letters
- [ ] **Use cases**: error handling, retry logic, debugging, audit, compliance

## Module 2: Configuring DLX
- [ ] **Queue-level arguments** (set on queue declaration):
  - [ ] `x-dead-letter-exchange`: exchange to route dead letters to
  - [ ] `x-dead-letter-routing-key`: optional routing key (else uses original)
- [ ] **Example declaration**:
  ```
  queue.declare("orders", args={
      "x-dead-letter-exchange": "dlx",
      "x-dead-letter-routing-key": "orders.failed"
  })
  ```
- [ ] **The DLX and DLQ must exist** — declare them before the main queue
- [ ] **Setup flow**:
  1. [ ] Declare DLX exchange (e.g., `dlx`)
  2. [ ] Declare DLQ queue (e.g., `orders.dlq`)
  3. [ ] Bind DLQ to DLX
  4. [ ] Declare main queue with `x-dead-letter-exchange=dlx`

## Module 3: Dead Letter Message Headers
- [ ] When a message is dead-lettered, RabbitMQ adds `x-death` header with metadata
- [ ] **`x-death` structure** (array of entries, most recent first):
  - [ ] `reason`: `rejected`, `expired`, or `maxlen`
  - [ ] `queue`: original queue
  - [ ] `time`: when dead-lettered
  - [ ] `exchange`: original exchange
  - [ ] `routing-keys`: original routing keys
  - [ ] `count`: how many times dead-lettered (for retry loops)
- [ ] **Inspect `x-death`**: useful for debugging, retry logic, metrics
- [ ] **`x-first-death-*`** headers: info about the FIRST time the message was dead-lettered

## Module 4: Retry Pattern with DLQ + TTL
- [ ] **Classic retry pattern**: use DLQ to implement delayed retry
- [ ] **Setup**:
  ```
  main-queue (x-dead-letter-exchange=retry-exchange)
  retry-queue (x-message-ttl=5000, x-dead-letter-exchange=main-exchange)
  ```
- [ ] **Flow**:
  1. [ ] Consumer rejects message from `main-queue`
  2. [ ] Message dead-letters to `retry-queue`
  3. [ ] After 5 seconds TTL, message expires from `retry-queue`
  4. [ ] Message dead-letters from `retry-queue` back to `main-exchange` → `main-queue`
  5. [ ] Consumer processes again
- [ ] **Result**: delayed retry without blocking consumer thread
- [ ] **Limit retries**: track count in header, dead-letter to final DLQ after N attempts

## Module 5: Exponential Backoff with Multiple Queues
- [ ] **Problem**: single retry TTL doesn't scale retries
- [ ] **Solution**: multiple retry queues with increasing TTLs
- [ ] **Example**:
  ```
  retry-queue-5s  (TTL 5s)   → main-queue
  retry-queue-30s (TTL 30s)  → main-queue
  retry-queue-5m  (TTL 5min) → main-queue
  parking-lot-queue          (no consumer, manual inspection)
  ```
- [ ] **Flow**:
  - [ ] 1st failure → retry after 5s
  - [ ] 2nd failure → retry after 30s
  - [ ] 3rd failure → retry after 5m
  - [ ] 4th failure → parking lot (manual intervention)
- [ ] **Consumer logic**: read `x-death[0].count` to decide which retry queue to use
- [ ] **Alternative**: RabbitMQ Delayed Message Plugin (simpler, but requires plugin)

## Module 6: Poison Message Handling
- [ ] **Poison message**: message that cannot be processed successfully, causes infinite retry loop
- [ ] **Symptoms**: consumer repeatedly fails, CPU spinning, growing DLQ
- [ ] **Detection**:
  - [ ] Track retry count in `x-death` header
  - [ ] Maximum retry threshold before permanent dead-lettering
- [ ] **Quorum queue built-in**: `x-delivery-limit` argument — automatic poison message handling
  - [ ] After N deliveries, message is dead-lettered (or dropped)
  - [ ] No manual retry logic needed
- [ ] **Parking lot queue**: final destination for un-processable messages
  - [ ] No consumer attached
  - [ ] Manual review, diagnosis, possible replay
- [ ] **Alerting**: alert on DLQ depth growing

## Module 7: Spring AMQP Error Handling & Retry
- [ ] **`@RabbitListener` retry**: configured via `RetryTemplate` in listener container factory
  - [ ] `max-attempts`, `initial-interval`, `multiplier`, `max-interval`
  - [ ] Retries in-memory on the consumer (blocks thread during backoff)
- [ ] **Dead letter configuration**:
  - [ ] Declare main queue with DLX argument
  - [ ] Spring AMQP handles routing on permanent failure
- [ ] **`RepublishMessageRecoverer`**: alternative to DLX
  - [ ] Publishes failed message to error queue with exception headers
  - [ ] Useful for adding diagnostic info
- [ ] **`@RetryableTopic`** (Spring Kafka-like pattern, for RabbitMQ since Spring AMQP 2.x+):
  - [ ] Declarative retry with delayed queues (creates retry topology automatically)
- [ ] **Best practice**: use broker-level retry (DLQ + TTL), not in-memory

## Module 8: DLQ Monitoring & Operations
- [ ] **Key metrics**:
  - [ ] DLQ depth (total dead letters)
  - [ ] DLQ arrival rate (how fast messages are dying)
  - [ ] Per-reason breakdown (rejected vs expired vs maxlen)
  - [ ] Time-to-dead-letter (histogram)
- [ ] **Alerting**:
  - [ ] DLQ depth > threshold → investigate
  - [ ] Sudden spike → deployment regression, bad data, upstream outage
- [ ] **Replay from DLQ**:
  - [ ] Tool: `rabbitmq-replay` (community), custom script via Management API
  - [ ] Move messages from DLQ back to main queue
  - [ ] Usually after fix is deployed
- [ ] **DLQ inspection**:
  - [ ] Management UI → queue → "Get Messages" (careful, acks/requeues)
  - [ ] Headers show failure reason and original routing
- [ ] **Cleanup**: DLQ cleanup policy — TTL on DLQ to prevent indefinite growth

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up DLX, force rejection, verify dead letter routing |
| Module 3 | Publish message, reject it, inspect x-death header |
| Module 4 | Implement retry pattern with TTL + DLX → re-queue |
| Module 5 | Build exponential backoff with 3 retry queues + parking lot |
| Module 6 | Reproduce poison message scenario, fix with quorum queue delivery-limit |
| Module 7 | Configure Spring AMQP with DLQ + retry |
| Module 8 | Monitor DLQ depth, build replay script from DLQ to main queue |

## Key Resources
- RabbitMQ documentation — Dead Letter Exchanges (rabbitmq.com/dlx.html)
- "Reliability Guide" — rabbitmq.com/reliability.html
- Spring AMQP Reference — Error Handling
- "Poison Message Handling" — Quorum Queues doc
