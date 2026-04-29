# BFF (Backend for Frontend) — One-Page Cheat Sheet

## Definition
Backend for Frontend (BFF) is an architectural pattern where each client (mobile, web, partner) has a dedicated backend that aggregates and transforms data specifically for that client.
It solves over-fetching, under-fetching, and client-specific logic by moving presentation concerns to a server layer.

---

## Core Components

| Component        | Role                                      | Key Property |
|------------------|-------------------------------------------|-------------|
| API Gateway      | Routing, auth, rate limiting              | Infra-only (no business logic) |
| BFF Service      | Aggregation + transformation              | Client-specific |
| Domain Services  | Business logic + data ownership           | Single source of truth |
| Service Clients  | HTTP clients for downstream services      | Shared infra only |
| Client (App/Web) | Consumes optimized API                    | Thin client |

---

## Key Algorithms / Protocols

- Parallel aggregation (Promise.all / coroutines) — reduce latency
- Fan-out / fan-in pattern — call N services → return 1 response
- Circuit breaker (Resilience4j) — prevent cascading failures
- Retry with backoff — handle transient failures
- HTTP caching (ETag, Cache-Control) — reduce load
- Pagination / cursor-based — limit payload size

---

## Performance Numbers (Typical)

- Mobile BFF payload: **0.5KB – 2KB**
- Web payload: **20KB – 50KB**
- Aggregation latency (parallel): **~150–300ms**
- Sequential API calls: **~800–1200ms**
- Service call timeout: **2–3 seconds**
- Throughput: **1k–10k RPS per BFF (Node/Java typical)**

---

## Configuration Knobs

| Knob | Default | Tuning Guidance |
|------|--------|----------------|
| Timeout | 2s | Lower for mobile-critical paths |
| Retry count | 2–3 | Avoid >3 to prevent amplification |
| Circuit breaker threshold | 50% failure | Lower for critical services |
| Cache TTL | 30–300s | Short for dynamic data |
| Max parallel calls | Unlimited | Cap to avoid overload |
| Rate limit | Per IP/client | Tune per client type |
| Payload size | Not enforced | Keep <2KB for mobile |
| Logging level | INFO | DEBUG only for dev |

---

## Failure Modes

| Failure | Impact | Mitigation |
|--------|--------|-----------|
| Downstream service failure | Partial/failed response | Circuit breaker + fallback |
| Timeout cascade | High latency | Set strict timeouts |
| Over-fetching regression | Performance drop | Enforce response contracts |
| BFF overload | High CPU/memory | Rate limiting + scaling |
| Dependency coupling | Cascading failures | No BFF-to-BFF calls |

---

## When to Use / NOT Use

**Use BFF when:**
- Multiple client types (mobile, web, IoT)
- Performance-critical mobile apps
- Separate frontend teams
- Need client-specific APIs

**Do NOT use when:**
- Single client only
- Small team / early stage
- GraphQL already solves flexibility
- No strong performance constraints

---

## Comparison vs Alternatives

| Feature | BFF | GraphQL | API Gateway | General API |
|--------|-----|--------|------------|------------|
| Layer | App | App | Infra | App |
| Flexibility | Low | High | None | Low |
| Payload optimization | Best | Good | None | Poor |
| Team autonomy | High | Medium | Low | Low |
| Complexity | Medium | High | Low | Low |

---

## Common Pitfalls

- Shared BFF for all clients
- Business logic inside BFF
- BFF calling another BFF
- Over-engineering too early
- Ignoring ownership boundaries
