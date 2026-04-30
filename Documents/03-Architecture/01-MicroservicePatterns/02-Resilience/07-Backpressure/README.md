# Backpressure & Flow Control - Curriculum

## Module 1: The Problem
- [ ] **Backpressure** = the mechanism by which a slow consumer signals "I can't keep up" back to a fast producer
- [ ] Without it, the producer overwhelms the consumer → unbounded queues → memory exhaustion → OOM kill or cascading failure
- [ ] Symptoms of missing backpressure: ever-growing queues, latency creeping up, GC death spiral, OOM crashes, queue lag alerts
- [ ] **Little's Law** (`L = λW`): queue length = arrival rate × time in system → if `λ` exceeds service rate forever, `L` grows without bound
- [ ] **Backpressure ≠ rate limiting**:
  - [ ] **Rate limiting**: producer-side, "I won't send more than N/sec regardless of consumer state" (proactive throttle)
  - [ ] **Backpressure**: consumer-side signal flowing upstream, "slow down, I'm full" (reactive throttle)
  - [ ] Both are needed in different layers
- [ ] **Backpressure ≠ buffering**: buffering hides the problem temporarily; backpressure addresses it
- [ ] **The end-to-end argument**: backpressure must propagate all the way to the original producer (or be absorbed by a deliberate buffer/drop policy) — partial backpressure just shifts the bottleneck

## Module 2: Strategies — Slow, Buffer, Drop, Block
- [ ] When a consumer is overwhelmed, four fundamental options:
  - [ ] **Slow the producer (block / pause)**: backpressure proper — best for correctness, slowest in throughput terms
  - [ ] **Buffer**: queue between producer and consumer — absorbs bursts but unbounded buffers = OOM
  - [ ] **Drop / shed load**: discard messages when full — best for latency-sensitive (telemetry, video frames); worst for correctness
  - [ ] **Sample / aggregate**: keep representative subset (every Nth, or pre-aggregate) — partial drop with structure
- [ ] **Bounded buffer + drop policy** is the practical default:
  - [ ] Drop oldest (head) — keep latest data, lose history (logs, metrics)
  - [ ] Drop newest (tail) — preserve order, refuse new (transactions, orders)
  - [ ] Block until space — backpressure proper
  - [ ] Reject with error — let producer decide (HTTP 429, RST, NACK)
- [ ] **Buffering's hidden cost**: bufferbloat — large buffers add tail latency without adding capacity (paper: "Bufferbloat", Jim Gettys)
- [ ] **Choosing**: durability needs (drop = data loss), latency targets (large buffer = bad tail), upstream's ability to slow down

## Module 3: Pull vs Push & Reactive Streams
- [ ] **Push model** (producer-driven): producer emits as fast as it can; backpressure must be a separate signal flowing back
- [ ] **Pull model** (consumer-driven): consumer requests N items at a time → producer responds — natural backpressure
- [ ] **Reactive Streams** (the JVM standard): protocol with `Publisher`, `Subscriber`, `Subscription`
  - [ ] Subscriber calls `subscription.request(n)` to demand N items — producer must NOT exceed
  - [ ] Standard interfaces in `java.util.concurrent.Flow.*` (Java 9+)
  - [ ] Implementations: **Project Reactor** (Spring WebFlux), **RxJava 3**, **Akka Streams**, **Mutiny** (Quarkus)
- [ ] **Reactor operators for backpressure handling**:
  - [ ] `onBackpressureBuffer(n)` — bounded buffer with overflow strategy
  - [ ] `onBackpressureDrop()` — drop on overflow
  - [ ] `onBackpressureLatest()` — keep only most recent
  - [ ] `onBackpressureError()` — fail fast
- [ ] **gRPC**: built-in flow control via HTTP/2 `WINDOW_UPDATE` frames; client/server can throttle each other transparently
- [ ] **HTTP/2 & HTTP/3**: stream-level flow control via window updates — automatic if you use the protocol correctly
- [ ] **TCP backpressure**: receive window size — OS-level flow control; explains why blocking I/O has natural backpressure but async I/O often doesn't

## Module 4: Backpressure in Messaging Systems
- [ ] **Kafka**:
  - [ ] No producer-side backpressure by default — `producer.send()` buffers locally, blocks when buffer full (`buffer.memory`, `max.block.ms`)
  - [ ] Consumer side: `max.poll.records`, `fetch.max.bytes` — consumer pulls at its own pace; broker holds messages until they're fetched (built-in pull-based backpressure)
  - [ ] **Consumer lag** = the visible measurement of insufficient backpressure; alert on it
  - [ ] Pause/resume: `consumer.pause(partitions)` to stop fetching specific partitions while processing — explicit backpressure
- [ ] **RabbitMQ**:
  - [ ] **Consumer prefetch (`basic.qos`)** — limits unacked messages per consumer (default 0 = unlimited!) — set this or you'll OOM
  - [ ] Publisher confirms (`confirm.select`) — broker tells producer when persisted, slowing producer naturally
  - [ ] **Flow control**: broker can pause connections that are pushing too fast (`connection.blocked` notification)
  - [ ] Memory & disk alarms: broker stops accepting publishes when thresholds breached
- [ ] **AWS SQS**: consumer pull, `MaxNumberOfMessages` per request — natural pull-based backpressure
- [ ] **NATS / NATS JetStream**: flow control via subscriber-acknowledged delivery; pull consumers in JetStream
- [ ] **Apache Pulsar**: built-in subscription-level flow control with permits
- [ ] **Pattern**: process-then-ack, never ack-then-process — preserves backpressure semantics through retries

## Module 5: Backpressure in Stream Processing & Web Servers
- [ ] **Kafka Streams**: pull-based; `max.poll.records` controls processing batch; punctuators run on consumer thread (no overflow)
- [ ] **Apache Flink**: per-task buffers + credit-based flow control; task manager grants credits to upstream → upstream emits within credit; UI shows backpressure as colored bars per operator
- [ ] **Spark Structured Streaming**: micro-batch model — `maxOffsetsPerTrigger` (Kafka) / `maxFilesPerTrigger` (files) bound input size per batch
- [ ] **Akka Streams / Reactor**: explicit backpressure via Reactive Streams protocol
- [ ] **Web servers**:
  - [ ] **Sync servers (Tomcat thread-per-request)**: natural backpressure via thread pool exhaustion → connection queue → TCP RST when full
  - [ ] **Async servers (Netty, WebFlux, Vert.x)**: must implement explicit backpressure or risk unbounded event loop queues
  - [ ] **HTTP 429 (Too Many Requests)** — server-side load shedding; signal to client to slow down
  - [ ] **HTTP 503 + Retry-After** — temporary unavailability with hint
- [ ] **Load shedder pattern** (Netflix Concurrency Limits / Tomcat MaxConnections / Envoy admission control):
  - [ ] Adaptive limits based on observed latency (TCP Vegas-style) — reject early to protect tail latency
  - [ ] Better than fixed limits; Netflix's Adaptive Concurrency Limits library

## Module 6: Anti-Patterns & Operational Concerns
- [ ] **Unbounded queues**: any unbounded `LinkedBlockingQueue`, `Channel`, or in-memory list — guaranteed OOM under load
  - [ ] Fix: bounded variants with explicit overflow policy
- [ ] **Producer doesn't observe consumer state**: fire-and-forget that ignores 429/NACK/full-buffer signals
  - [ ] Fix: respect signals; implement retry with backoff + jitter; circuit-break the producer if consumer chronically slow
- [ ] **Backpressure stops at the wrong layer**: consumer slows DB writes but keeps fetching from Kafka → in-memory queue between fetch and write fills → OOM
  - [ ] Fix: backpressure must propagate to the *fetch* loop, not just the *processing* loop
- [ ] **Async without backpressure**: switching from blocking to async "for performance" but removing the natural backpressure that thread-pool exhaustion provided
  - [ ] Fix: explicit bounded buffers + reactive operators; never assume async = free scaling
- [ ] **Hiding backpressure with retries**: consumer overloaded → returns 503 → producer retries immediately → consumer more overloaded
  - [ ] Fix: respect Retry-After, exponential backoff, retry budget, circuit breaker
- [ ] **Backpressure across team boundaries** is political: "their team needs to slow down" is hard — formalise via SLOs and rate-limit contracts
- [ ] **Observability for backpressure**:
  - [ ] Per-stage queue depth (gauge)
  - [ ] Consumer lag (Kafka)
  - [ ] Active connections / pool exhaustion events
  - [ ] Drop counter (when load shedding)
  - [ ] Latency tail (P99/P999) — backpressure issues show up in tail before mean
- [ ] **Capacity planning principle**: provision for `λ < μ` (arrival < service rate) at peak — backpressure is for *unexpected* spikes, not your steady state

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a producer-consumer with `LinkedBlockingQueue(1000)`; experiment with each overflow policy (block/drop/error); measure throughput, latency, drop rate |
| Module 3 | Implement the same data flow with Project Reactor: try `onBackpressureBuffer`, `onBackpressureDrop`, `onBackpressureLatest`; observe behaviour under fast producer, slow consumer |
| Module 4 | Configure a Kafka consumer with `max.poll.records=10`; deliberately slow the processor; watch consumer lag rise; tune to hold lag steady |
| Module 4 | Set RabbitMQ prefetch to 0 (default) and 1 — observe difference in fairness and memory |
| Module 5 | Deploy a small Flink job; visualise backpressure in the Flink UI; introduce a slow operator and watch the upstream colour change |
| Module 5 | Add Netflix Adaptive Concurrency Limits to a Spring service; load-test; compare tail latency vs fixed-limit throttling |
| Module 6 | Audit one of your services: list every queue, channel, and pool — is each one bounded? What's the overflow policy? |

## Cross-References
- `01-MicroservicePatterns/02-Resilience/02-Retry&Backoff/` — retry policies must respect backpressure signals
- `01-MicroservicePatterns/02-Resilience/04-RateLimiting/` — producer-side complement to consumer-side backpressure
- `01-MicroservicePatterns/02-Resilience/01-CircuitBreaker/` — circuit breaker is the "give up entirely" end of the spectrum
- `01-MicroservicePatterns/02-Resilience/03-Bulkhead/` — isolation limits the blast radius when backpressure fails
- `02-SystemDesign/03-SystemDesign/09-MessageQueues/` — broker-level flow control
- `02-SystemDesign/03-SystemDesign/21-StreamProcessing&RealTime/` — Flink/Spark/Kafka Streams flow control
- `02-Messaging&EventStreaming/01-Kafka/` — consumer prefetch, lag, pause/resume in detail

## Key Resources
- **"Reactive Streams"** specification — reactive-streams.org
- **Reactive Programming with RxJava** - Tomasz Nurkiewicz & Ben Christensen
- **Hands-On Reactive Programming in Spring 5** - Oleh Dokuka & Igor Lozynskyi
- **"Bufferbloat: Dark Buffers in the Internet"** - Jim Gettys, Kathleen Nichols (ACM Queue)
- **Netflix Concurrency Limits** library — github.com/Netflix/concurrency-limits
- **"Performance Under Load"** - Jon Moore (Comcast) — adaptive load shedding
- **Apache Flink documentation** — Backpressure & Credit-Based Flow Control
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 11: Stream Processing — backpressure section)
- **HTTP/2 RFC 7540** — Section 5.2 Flow Control
