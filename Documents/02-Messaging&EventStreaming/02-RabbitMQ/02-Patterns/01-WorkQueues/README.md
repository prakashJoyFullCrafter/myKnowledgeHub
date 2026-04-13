# RabbitMQ Work Queues Pattern - Curriculum

## Module 1: Work Queue Fundamentals
- [ ] **Work queue (task queue)**: distribute time-consuming tasks across multiple workers
- [ ] **Decoupling**: producer doesn't wait for task completion
- [ ] **Use cases**: email sending, image processing, PDF generation, report generation, long-running jobs
- [ ] **Architecture**:
  ```
  Producer → Queue → Multiple Consumers (workers)
  ```
- [ ] **Competing consumers**: each message delivered to ONE worker (load balancing)
- [ ] Scale horizontally: add more workers to process faster
- [ ] Different from pub/sub: work queues distribute work, pub/sub broadcasts

## Module 2: Round-Robin Dispatch
- [ ] **Default behavior**: broker round-robins messages across consumers on same queue
- [ ] Each worker gets every Nth message (N = consumer count)
- [ ] **Problem**: round-robin doesn't account for processing time
  - [ ] Worker A gets light tasks → idle quickly
  - [ ] Worker B gets heavy tasks → overloaded
  - [ ] Result: unfair distribution
- [ ] **Fair dispatch fix**: use prefetch count (see Module 4)

## Module 3: Message Acknowledgements
- [ ] **Why ack matters**: without ack, if worker crashes mid-processing, message is lost
- [ ] **Manual ack pattern**:
  1. [ ] Worker receives message (auto-ack OFF)
  2. [ ] Worker processes task
  3. [ ] Worker acks on success → broker removes message
  4. [ ] On failure (exception or crash) → broker redelivers to another worker
- [ ] **Requeue semantics**:
  - [ ] `basic.nack(requeue=true)` — retry (can loop if always failing)
  - [ ] `basic.nack(requeue=false)` — discard or dead-letter
- [ ] **Delivery tag**: used to ack specific messages (per-channel sequence)
- [ ] **Multi-ack**: ack multiple messages at once with `multiple=true`
- [ ] **Ack timeout**: `consumer_timeout` (default 30 min) — kick consumer if ack takes too long

## Module 4: Prefetch & Fair Dispatch
- [ ] **Prefetch count** (`basic.qos`): max unacked messages per consumer
- [ ] **Fair dispatch**: set `prefetch=1` → broker only sends new message after previous is acked
  - [ ] Ensures busy worker doesn't hoard messages
  - [ ] Idle workers get work immediately
- [ ] **Throughput trade-off**:
  - [ ] `prefetch=1`: fairest distribution, but slower (network latency per message)
  - [ ] `prefetch=10-50`: better throughput, still reasonably fair
  - [ ] `prefetch=unlimited`: fastest, but unfair and memory-heavy
- [ ] **Choosing prefetch**:
  - [ ] Fast tasks (< 100ms): prefetch 100-500
  - [ ] Medium tasks (100ms-1s): prefetch 10-50
  - [ ] Slow tasks (> 1s): prefetch 1-5
- [ ] **Global vs per-consumer**: use per-consumer prefetch (default behavior)

## Module 5: Durability & Persistence
- [ ] **Durable queue** + **persistent messages** = survive broker restart
- [ ] **Durable queue**: `queue.declare(durable=true)` — metadata written to disk
- [ ] **Persistent message**: `delivery_mode=2` — message written to disk
- [ ] **Both required** — durable queue + transient message = message lost on restart
- [ ] **Caveat**: persistence doesn't guarantee durability DURING in-flight delivery
  - [ ] Message could be in RAM between receipt and disk flush
  - [ ] Add publisher confirms for guarantee
- [ ] **Performance cost of persistence**: 10-100x slower than transient
- [ ] **Mixed approach**: transient for low-value tasks, persistent for critical ones

## Module 6: Competing Consumers Pattern
- [ ] **Pattern**: multiple independent consumers compete for messages from same queue
- [ ] Also called "work queue" or "load-balanced queue"
- [ ] **Benefits**:
  - [ ] Horizontal scaling (add workers)
  - [ ] Fault tolerance (worker crash → others continue)
  - [ ] Load balancing (broker distributes fairly with prefetch)
- [ ] **Challenges**:
  - [ ] Order NOT preserved (tasks processed in parallel)
  - [ ] If ordering needed → single consumer OR single active consumer (SAC)
- [ ] **Single Active Consumer (SAC)**: only one consumer gets messages, others standby
  - [ ] Queue arg: `x-single-active-consumer: true`
  - [ ] Use case: ordering required but want failover

## Module 7: Priority Queues
- [ ] **Priority queue**: higher-priority messages delivered first
- [ ] **Enable**: `x-max-priority: N` argument (1-255, typical 1-10)
- [ ] **Publishing**: set `priority` property on message
- [ ] **How it works**: multiple internal queues under the hood (one per priority level)
- [ ] **Limitations**:
  - [ ] Only **classic queues** (not quorum, not stream)
  - [ ] Slower than non-priority (internal sorting overhead)
  - [ ] Doesn't guarantee strict ordering if consumer prefetches multiple
- [ ] **Use case**: mix urgent and batch work in same queue
- [ ] **Alternative**: separate queues per priority (usually better)

## Module 8: Scaling & Anti-Patterns
- [ ] **Scaling workers**: add instances (Kubernetes pods, containers)
  - [ ] Each instance = one consumer = one channel on one connection
  - [ ] Monitor queue depth → scale when depth grows
- [ ] **Auto-scaling**: HPA on queue depth metric (Prometheus + custom metrics)
- [ ] **Anti-patterns**:
  - [ ] **Too many workers**: more workers than prefetch * queues → idle workers
  - [ ] **Auto-ack**: lost messages on crash
  - [ ] **No prefetch limit**: memory runaway
  - [ ] **Requeue=true on permanent error**: infinite loop
  - [ ] **Long-running tasks without heartbeat**: broker thinks consumer is dead
  - [ ] **Synchronous processing in consumer thread**: blocks channel, limits throughput
- [ ] **Best practices**:
  - [ ] Manual ack after processing
  - [ ] Prefetch tuned to task duration
  - [ ] Idempotent tasks (handle duplicate delivery)
  - [ ] Dead-letter queue for poison messages
  - [ ] Heartbeat tuned for long tasks

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build image resize service: producer + 3 workers, measure throughput |
| Module 2 | Observe unfair distribution with prefetch=unlimited, mixed task durations |
| Module 3 | Implement manual ack with exception handling and requeue logic |
| Module 4 | Tune prefetch for different task profiles, benchmark throughput |
| Module 5 | Test durability: kill broker, verify persistent messages survive |
| Module 6 | Implement competing consumers, simulate worker crashes |
| Module 7 | Build priority queue with 3 levels, verify delivery order |
| Module 8 | Identify 5 anti-patterns in a sample codebase, fix them |

## Key Resources
- RabbitMQ Tutorial 2: Work Queues
- "RabbitMQ in Depth" — Chapter 6 (Consumers)
- rabbitmq.com/consumer-prefetch.html
- "Reliability Guide" — rabbitmq.com/reliability.html
