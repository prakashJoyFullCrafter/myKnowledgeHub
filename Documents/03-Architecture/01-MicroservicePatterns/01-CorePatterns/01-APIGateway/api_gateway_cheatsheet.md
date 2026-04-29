# API Gateway — One-Page Cheat Sheet (Gold Tier)

## Definition
An API Gateway is a centralized entry point that manages, secures, and routes all client requests to backend services.  
It abstracts internal architecture while enforcing cross-cutting concerns like authentication, rate limiting, and observability.

---

## Core Components

| Component | Role | Key Property |
|----------|------|-------------|
| Route | Maps request → service | Path/header/method matching |
| Auth Layer | Validates identity | JWT / API key / OAuth |
| Rate Limiter | Controls traffic | Token bucket (burst + sustained) |
| Load Balancer | Distributes requests | Round-robin / least-connections |
| Transformer | Modifies request/response | Header/body rewrite |
| Aggregator | Combines multiple services | Fan-out / fan-in |
| Cache | Stores responses | TTL / cache key |
| Observability | Logs + traces | Correlation / trace IDs |

---

## Key Algorithms / Protocols
- Token Bucket → Burst-friendly rate limiting  
- Round Robin → Even traffic distribution  
- Least Connections → Load-aware balancing  
- Circuit Breaker → Fail fast on unhealthy services  
- JWT (RS256) → Stateless authentication  
- mTLS → Mutual authentication between services  
- W3C Trace Context → Distributed tracing standard  

---

## Performance Numbers (Typical)
- Gateway latency overhead:
  - NGINX / Envoy: <1–2 ms  
  - Kong / Traefik: ~2–5 ms  
  - Spring Cloud Gateway: ~5–15 ms  
  - AWS API Gateway: ~1–15 ms  

- Throughput:
  - KrakenD: ~1M+ req/sec  
  - NGINX: ~500k+ req/sec  
  - Envoy: ~200k–500k req/sec  

- Rate limiting defaults:
  - 10–100 req/sec per user typical  
  - Burst: 2–10× sustained rate  

---

## Configuration Knobs (Critical)

| Knob | Default | Tuning Guidance |
|-----|--------|----------------|
| Rate limit (RPS) | 10–100 | Match backend capacity |
| Burst capacity | 2× rate | Increase for UX smoothing |
| Timeout | 3–5s | Lower to prevent thread blocking |
| Retry count | 2–3 | Avoid retry storms |
| Circuit breaker threshold | 50% errors | Lower for critical services |
| Cache TTL | 30–300s | Balance freshness vs load |
| Connection pool size | 50–500 | Match traffic concurrency |
| Health check interval | 5s | Lower for faster failover |

---

## Failure Modes & Mitigation

| Failure | Cause | Mitigation |
|--------|------|-----------|
| Cascade failure | Slow backend | Circuit breaker |
| Retry storm | Aggressive retries | Exponential backoff |
| Rate limit bypass | Multi-instance | Shared Redis counters |
| Cache stampede | Expired cache spike | Stale-while-revalidate |
| Auth bottleneck | Centralized auth | Token caching |

---

## When to Use vs NOT Use

**Use When**
- Microservices architecture  
- Need centralized security  
- Multiple clients (mobile/web)  
- Need observability + control  
- API monetization / rate limiting  

**Avoid When**
- Simple monolith  
- Ultra-low latency (<1ms critical path)  
- Small system (<3 services)  
- No cross-cutting concerns needed  

---

## Comparison vs Alternatives

| Feature | API Gateway | Reverse Proxy | Load Balancer |
|--------|------------|--------------|---------------|
| Auth | Full (JWT/OAuth) | Basic | None |
| Rate limiting | Advanced | Basic | None |
| Routing | Advanced | Medium | Basic |
| Observability | Rich | Logs only | Minimal |
| Aggregation | Yes | No | No |

---

## Common Pitfalls
- Putting business logic in gateway  
- Overusing retries → cascading failures  
- Poor cache key design → data leaks  
- Not sharing rate limit state across instances  
- Ignoring timeout tuning  

---

## Key Insight
The API Gateway enforces **DRY at system level** — all cross-cutting concerns are implemented once, not per service.
