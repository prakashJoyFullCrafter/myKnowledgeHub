# Idempotency - Curriculum

## Module 1: The Problem
- [ ] **Definition**: an operation is idempotent if applying it N times produces the same effect as applying it once
- [ ] Distributed systems can't avoid duplicates: retries on timeout, network hiccups, at-least-once delivery, client double-clicks, broker redelivery
- [ ] **The "did it succeed?" problem**: client sends request → timeout → did the server process it? Resending without idempotency = double-charge, duplicate order, double-shipped item
- [ ] **At-least-once + idempotency = effectively exactly-once** (the only realistic path to "exactly once")
- [ ] Naive vs intrinsic vs key-based idempotency:
  - [ ] **Intrinsic**: operation is naturally idempotent (`SET x = 5`, `DELETE id=42`, `PUT /resource/{id}`)
  - [ ] **Non-idempotent**: `INSERT new_row`, `balance -= 100`, `POST /charge` — needs explicit guard
- [ ] HTTP semantics: GET, PUT, DELETE are *defined* idempotent; POST is not — but you can make POST idempotent with a key

## Module 2: HTTP Idempotency Keys
- [ ] **Idempotency-Key header** (RFC draft, established convention): client generates UUID, sends with request; server stores `(key → response)` mapping
- [ ] First request: process normally, store result keyed by idempotency key
- [ ] Duplicate request (same key): return the stored response without re-executing
- [ ] **Stripe's model** (the canonical reference): keys scoped to API key + endpoint, 24-hour retention, returns identical original response
- [ ] **Lifecycle states** of a stored key: `IN_PROGRESS` → `COMPLETED(response)` → expired/purged
  - [ ] In-progress handling: second request sees `IN_PROGRESS` → wait? return 409 Conflict? return cached? (Stripe returns 409)
- [ ] **Key generation**: client-side UUID v4 — never server-generated (defeats the purpose)
- [ ] **Scope**: per-tenant, per-endpoint — never global (key collisions across endpoints would be catastrophic)
- [ ] **Retention**: long enough to outlive client retry windows (24h typical), short enough to bound storage
- [ ] **Failure semantics**: if request fails with 5xx, should retry with **same key** be allowed? Stripe says yes — same key, same retry, idempotent

## Module 3: Storage & Implementation Strategies
- [ ] **Dedup table**: `(idempotency_key PRIMARY KEY, request_hash, response, status, created_at)` in your primary DB
  - [ ] Pros: transactional with business writes — same commit guarantees consistency
  - [ ] Cons: bloats main DB
- [ ] **Redis dedup**: `SET key value NX EX 86400` — atomic check-and-set; first wins, others return cached
  - [ ] Pros: fast, auto-expires; Cons: not transactional with DB writes (race window)
- [ ] **Database unique constraint**: `INSERT ... ON CONFLICT DO NOTHING` keyed by business identifier (order_id, payment_intent_id) — simplest when you control the natural key
- [ ] **Request hashing**: store hash of (method + path + body) — detect "same key, different payload" → return 422 (Stripe behavior)
- [ ] **Outbox + idempotency**: outbox guarantees at-least-once delivery; consumer dedup via idempotency key in event payload
- [ ] **Token-based**: server issues a one-time token (e.g. `POST /charges/intent` returns token, `POST /charges` consumes it) — DB-enforced single use
- [ ] Transactional safety: dedup write + business write must be in same transaction, OR both protected by the same lock — otherwise lost updates between check and act

## Module 4: Idempotent Consumers (Messaging)
- [ ] **Idempotent Consumer** (Chris Richardson pattern): consumer dedupes by message ID before processing
- [ ] Why needed: Kafka/RabbitMQ/SQS are at-least-once by default → consumer will see duplicates on rebalance, redelivery, partition reassignment
- [ ] **Per-message ID** (`messageId` from broker, OR business key from payload, OR producer-generated UUID)
- [ ] Implementations:
  - [ ] **Processed-message table**: `(message_id PK, processed_at)` — insert before processing; conflict = already done
  - [ ] **Bloom filter + DB fallback**: fast negative check, DB confirms positives (high-throughput)
  - [ ] **Kafka exactly-once-semantics (EOS)**: transactional producer + isolation.level=read_committed — only within Kafka, not end-to-end
  - [ ] **Kafka Streams `processing.guarantee=exactly_once_v2`** — transactional state stores
- [ ] **Inbox pattern**: dual of Outbox — write incoming message to inbox table in same TX as business effect; dedup by message ID
- [ ] Consumer offset commit timing matters: commit *after* business commit (at-least-once + idempotent) — never before (at-most-once)

## Module 5: Edge Cases & Anti-Patterns
- [ ] **Same key, different payload**: client sent two different requests with same key → server returns 422 (don't silently apply one)
- [ ] **Concurrent duplicates** (two retries arrive simultaneously): need atomic check-and-insert (DB constraint OR Redis NX) — naive `if not exists then insert` has a race
- [ ] **Partial failure within request**: charge succeeded, email failed → retry hits cached "success" but email never sent
  - [ ] Solution: don't cache until *all* effects committed; or use outbox for downstream effects
- [ ] **Idempotency key reuse across endpoints**: client uses same key for `POST /charges` and `POST /refunds` → must be scoped per endpoint
- [ ] **Long-running operations**: request takes 60s, client times out at 30s and retries — server is still processing first request
  - [ ] Solution: `IN_PROGRESS` state + 409, OR async pattern (return 202 + status URL)
- [ ] **Retention expiry**: client retries after 25 hours, key was purged → treated as new request → duplicate effect
  - [ ] Mitigate: business-key uniqueness as second line of defense (e.g. `order_external_ref` UNIQUE)
- [ ] **Anti-pattern: idempotency by GET-before-POST**: "check if exists, then create" — race condition, NOT idempotent
- [ ] **Anti-pattern: idempotency by client-side dedup only** — useless if there are multiple clients or the client crashes mid-retry
- [ ] **Idempotency vs commutativity**: `x += 5` is not idempotent; `x = 5` is. Idempotent ≠ associative ≠ commutative — common confusion
- [ ] **Side effects outside the DB** (sending email, calling 3rd party API) — wrap in outbox, or accept best-effort, or use 3rd party's own idempotency keys (Stripe, Twilio support them)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a `POST /payments` endpoint with `Idempotency-Key` header support, Stripe-style behavior (409 on in-progress, cached response on duplicate) |
| Module 3 | Implement dedup with both Postgres (transactional) and Redis (NX) — measure latency overhead |
| Module 3 | Replay 1000 duplicate requests concurrently; verify exactly one effect, identical responses |
| Module 4 | Build an Inbox-pattern Kafka consumer in Spring; force redelivery (kill before commit) and verify single effect |
| Module 4 | Enable Kafka EOS in a Streams app; observe transactional commits |
| Module 5 | Reproduce: same key, different payload → 422; concurrent first requests → only one wins; expired key → new effect (and the business-key safety net catches it) |

## Cross-References
- `01-MicroservicePatterns/02-Resilience/02-Retry&Backoff/` — retry is unsafe without this pattern
- `01-MicroservicePatterns/03-DataPatterns/03-OutboxPattern/` — outbox produces at-least-once; consumers need idempotency
- `01-MicroservicePatterns/03-DataPatterns/01-CQRS/` — command handlers should be idempotent
- `01-MicroservicePatterns/01-CorePatterns/05-SagaPattern/` — compensating transactions must be idempotent
- `02-Messaging&EventStreaming/01-Kafka/` — EOS, transactional producer, consumer offset semantics

## Key Resources
- **Stripe API documentation** — Idempotency Keys (the canonical real-world implementation)
- **Microservices Patterns** - Chris Richardson (Idempotent Consumer pattern)
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 11: end-to-end argument, exactly-once)
- **"Exactly-Once Semantics in Apache Kafka"** - Confluent blog (Apurva Mehta, Jay Kreps)
- **RFC draft: The Idempotency-Key HTTP Header Field** (draft-ietf-httpapi-idempotency-key-header)
- **AWS / GCP / Azure SDKs** — built-in client retry + idempotency token patterns
