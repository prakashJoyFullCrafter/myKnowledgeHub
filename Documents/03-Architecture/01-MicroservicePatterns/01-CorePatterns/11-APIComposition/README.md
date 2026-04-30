# API Composition - Curriculum

> One of the two canonical solutions to the **cross-service query problem** in microservices (the other being CQRS). Coined by Chris Richardson — a service composes data from multiple downstream services into a single client response, replacing the cross-database JOIN that database-per-service forbids.

## Module 1: The Problem
- [ ] **Database-per-service** prohibits cross-service JOINs — the data needed for one client request lives in 3-5 services
- [ ] Naive options all fail:
  - [ ] Cross-DB JOIN — violates encapsulation, creates coupling
  - [ ] Shared DB — defeats microservice independence
  - [ ] Client makes N parallel calls — leaks topology to clients, chatty over slow networks (mobile)
- [ ] **API Composition pattern**: a dedicated **composer** queries multiple services, combines results in-memory, returns one response
- [ ] Two query strategies in microservices (Richardson's taxonomy):
  - [ ] **API Composition** — synchronous fan-out at query time
  - [ ] **CQRS** — denormalised read model populated by events (covered in `03-DataPatterns/01-CQRS/`)
- [ ] Pick API Composition when: low complexity, freshness matters, joins are simple, building first
- [ ] Pick CQRS when: high read throughput, complex joins, can tolerate eventual consistency, mature event infra
- [ ] Most real systems use **both** — Composition for the simple/low-volume cases, CQRS for the hot read paths

## Module 2: Where the Composer Lives
- [ ] **API Gateway as composer** (single composer for all clients)
  - [ ] Pros: client-agnostic, central place for cross-cutting concerns
  - [ ] Cons: gateway becomes complex; one composition logic for many client shapes
- [ ] **BFF as composer** (per-client-type composer — see `04-BFF/`)
  - [ ] Pros: composition tailored to client (mobile vs web vs partner API)
  - [ ] Cons: duplication across BFFs; need to keep them aligned
- [ ] **Dedicated composer service** (its own microservice owning the composed query)
  - [ ] Pros: clean separation, owns its own SLAs; can be scaled independently
  - [ ] Cons: yet another service; usually overkill unless composition is non-trivial
- [ ] **Inside an existing service** (the "lead" service composes from others)
  - [ ] Pros: zero new infra
  - [ ] Cons: that service now depends on others; coupling creeps in
- [ ] **Anti-pattern**: client composes (each mobile/web client makes 5 calls)
  - [ ] Slow on high-latency networks, leaks service topology, version-coupling all clients to all services
- [ ] **Decision heuristic**: start in the BFF/gateway; promote to dedicated composer only when the logic gets non-trivial or has its own scaling needs

## Module 3: Fan-Out Strategies
- [ ] **Parallel fan-out** (the default — almost always correct)
  - [ ] Total latency ≈ slowest call (`max(t1, t2, ...)`) instead of sum
  - [ ] JVM: `CompletableFuture.allOf(...)`, Project Reactor `Mono.zip(...)`, Mutiny `Uni.combine().all()`, Kotlin coroutines `coroutineScope { ... }`
  - [ ] Always set per-call timeouts; total timeout = max(call timeouts), NOT sum
- [ ] **Sequential fan-out** (only when call B truly needs result of A)
  - [ ] Latency = sum; expensive — minimise serial steps
  - [ ] Look hard for opportunities to parallelise (often you only need a key from A, which the client already has)
- [ ] **Hybrid**: first call(s) sequential to obtain identifiers, then parallel fan-out using those keys
- [ ] **Speculative fan-out**: kick off all probable calls in parallel, discard the unused ones — trades cost for latency
- [ ] **Conditional fan-out**: only call services whose data is requested (GraphQL resolvers do this naturally; REST needs explicit field selection)

## Module 4: Partial Failure & Resilience
- [ ] In a 5-call composition, the probability that at least one fails is ~5x the per-call failure rate — **partial failure is the normal case**
- [ ] Failure-handling strategies:
  - [ ] **Fail the whole response** (strict consistency) — only when EVERY field is critical
  - [ ] **Return partial response with `null`/`unavailable` markers** (the usual choice) — preserves client functionality
  - [ ] **Fallback values** (cached, default, or computed) — for recoverable degradation
  - [ ] **Tiered importance**: critical-call failure → fail; optional-call failure → degrade
- [ ] **Per-call resilience controls** (combine, don't substitute):
  - [ ] **Timeouts**: aggressive (faster than client SLA budget); use `min(remaining_budget, max_call_timeout)` for cascading deadlines
  - [ ] **Retries**: only on transient errors; respect retry budget; ALWAYS with backoff + jitter
  - [ ] **Circuit breakers**: per downstream — fail fast when downstream is sick (see `02-Resilience/01-CircuitBreaker/`)
  - [ ] **Bulkheads**: separate thread pool / semaphore per downstream so one slow service doesn't starve others
- [ ] **Hedged requests** (Google's "Tail at Scale"): send to two replicas if first hasn't responded by P95 — cuts tail latency at the cost of duplicate work
- [ ] **Deadline propagation**: pass remaining time budget downstream (gRPC deadlines, custom HTTP header) so downstream can give up early
- [ ] **Composition response shape** must explicitly document optional/missing-field semantics — clients can't guess

## Module 5: The N+1 Problem & Batching
- [ ] **The N+1 problem**: composer fetches a list of N orders, then loops calling user-service N times for each order's user — 1 + N calls
- [ ] **Solutions**:
  - [ ] **Batch APIs**: downstream exposes `GET /users?ids=1,2,3,...` — composer makes one call instead of N
  - [ ] **DataLoader pattern** (originally Facebook GraphQL): coalesce concurrent loads of the same type within a single request into one batched call
    - [ ] JVM implementations: `java-dataloader`, Spring GraphQL, graphql-java DataLoader
  - [ ] **Cache within request**: same user fetched twice in one composition → one call
  - [ ] **Cache across requests**: short-TTL cache on stable lookups (user names, product catalogues)
- [ ] **Pagination interaction**: large lists multiply N+1 — always batch loads from paginated lists
- [ ] **GraphQL composition**: server-side resolvers naturally fan out per-field; without DataLoader, GraphQL is the worst N+1 generator imaginable
- [ ] **Schema design implication**: every entity that's commonly fetched in lists needs a batch-by-IDs endpoint — make this a service contract requirement

## Module 6: GraphQL as Composition Technology
- [ ] GraphQL is API Composition with a query language and schema in front of it — the same fan-out pattern, formalised
- [ ] **GraphQL gateway / federation** (Apollo Federation, Hot Chocolate, Spring GraphQL):
  - [ ] Each service exposes a typed sub-graph; gateway federates them
  - [ ] Query planner decomposes a client query into sub-requests, fans out, composes
  - [ ] **Pros**: client-driven field selection (no over-fetch), strongly typed, evolves without versioning, single endpoint
  - [ ] **Cons**: caching is hard (every query different), monitoring/auth shifts to schema level, federation infra is heavy
- [ ] **REST composition** vs **GraphQL composition**:
  - [ ] REST: composer code defines what to fetch — composition logic in code
  - [ ] GraphQL: clients define what to fetch — composition logic driven by query
  - [ ] Both fan out the same way; both face the same N+1 / partial-failure / latency issues
- [ ] **gRPC + REST aggregation patterns**: gRPC for service-to-service (cheaper fan-out), REST/GraphQL at the edge
- [ ] **Anti-pattern**: GraphQL on top of monolith — solves a problem you don't have, adds complexity for nothing

## Module 7: Anti-Patterns & When NOT to Use API Composition
- [ ] **The chained-call anti-pattern**: A→B→C→D synchronous chain (latency sums, failures cascade)
  - [ ] Fix: parallelise where possible; switch to event-driven if truly sequential at scale
- [ ] **The "god composer" anti-pattern**: composer accumulates business logic, becomes a hidden monolith
  - [ ] Fix: keep composers thin (fetch + merge only); push logic back into owning services
- [ ] **Missing timeouts**: one slow downstream → composer threads pile up → composer dies
  - [ ] Fix: per-call timeouts ALWAYS; bulkheads to limit blast radius
- [ ] **Hot-path composition**: 100k QPS endpoint that fans out to 5 services every request → 500k QPS aggregate downstream pressure
  - [ ] Fix: this is the canonical case for switching to **CQRS** with a denormalised read model
- [ ] **Inconsistent reads**: parallel calls return data from slightly different points in time → composed view is internally inconsistent
  - [ ] Mitigate: snapshot consistency (uncommon in microservices) or accept and document
- [ ] **No correlation IDs**: composer fans out 5 calls, can't trace which downstream caused which slowness
  - [ ] Fix: distributed tracing (OpenTelemetry) — non-negotiable for composition
- [ ] **Composition for everything**: composing data that one service owns end-to-end (just call that service)
- [ ] **Skipping caching**: hot lookups (user profiles, product catalogues) re-fetched per request → infrastructure bill explodes
  - [ ] Fix: short-TTL distributed cache (Redis) in front of stable lookups

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a `GET /orders/{id}/details` endpoint that composes from order, payment, inventory, user services; place it first in BFF, then refactor to dedicated composer — compare |
| Module 3 | Implement parallel fan-out with `CompletableFuture.allOf`; add per-call timeouts; measure tail latency vs sequential |
| Module 4 | Make the same composer return partial responses when one downstream is down; mark unavailable fields explicitly in the response shape |
| Module 4 | Add Resilience4j circuit breakers + bulkheads per downstream; kill a downstream and verify composer stays responsive |
| Module 5 | Build a list endpoint that triggers N+1; introduce a batch API on the downstream; add `java-dataloader`; measure call reduction |
| Module 6 | Wrap the same composition in a small Spring GraphQL service with Apollo Federation; compare developer experience and observability |
| Module 7 | Take a hot-path composition serving 1k+ QPS; sketch the CQRS migration: which read model would replace it, what events would feed it? |

## Cross-References
- `01-MicroservicePatterns/01-CorePatterns/01-APIGateway/` — gateway can host composition (one option)
- `01-MicroservicePatterns/01-CorePatterns/04-BFF/` — BFF often IS the composer (per-client)
- `01-MicroservicePatterns/01-CorePatterns/06-DatabasePerService/` — the constraint that creates the composition need
- `01-MicroservicePatterns/03-DataPatterns/01-CQRS/` — the alternative query strategy (eventual consistency, denormalised read model)
- `01-MicroservicePatterns/03-DataPatterns/05-EventDrivenPatterns/` — Event-Carried State Transfer reduces composition need
- `01-MicroservicePatterns/02-Resilience/01-CircuitBreaker/` — per-downstream protection
- `01-MicroservicePatterns/02-Resilience/03-Bulkhead/` — isolate slow downstreams
- `01-MicroservicePatterns/02-Resilience/02-Retry&Backoff/` — retry policy on transient downstream failures
- `02-SystemDesign/03-SystemDesign/17-Observability&Operations/` — distributed tracing for composition

## Key Resources
- **Microservices Patterns** - Chris Richardson (Chapter 7: Implementing queries — API Composition vs CQRS)
- **microservices.io** - "API Composition" pattern (Chris Richardson, canonical reference)
- **"The Tail at Scale"** - Jeff Dean & Luiz André Barroso (Communications of the ACM) — hedged requests, latency at scale
- **"Hands-On Microservices with Spring Boot"** - Magnus Larsson (composition examples)
- **DataLoader spec** - github.com/graphql/dataloader (the canonical pattern)
- **Apollo Federation** documentation — apollographql.com (modern GraphQL composition)
- **gRPC Deadlines** documentation — deadline propagation pattern
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 4 on data integration; Chapter 11 on materialized views as composition alternative)
