# Microservices Service Decomposition — One-Page Cheat Sheet

## Definition
Service decomposition is the process of breaking a system into independently deployable services aligned to business capabilities.  
The goal is to maximize team autonomy, scalability, and maintainability while minimizing coupling and operational overhead.

---

## Core Components

| Component | Role | Key Property |
|----------|------|-------------|
| Service | Deployable unit | Owns one business capability |
| API | Communication interface | Stable, versioned |
| Database | Data storage | Owned by one service only |
| Team | Ownership | 1 team per service |
| Events | Async communication | Decouples services |
| Gateway | Routing | Controls traffic + rollout |

---

## Key Algorithms / Protocols

- REST: synchronous request/response communication  
- gRPC: high-performance service communication  
- Event-driven (Pub/Sub): async decoupling via events  
- Saga pattern: distributed transaction coordination  
- Strangler Fig: incremental migration strategy  
- Circuit Breaker: failure isolation  

---

## Performance Numbers (Typical)

- Network call latency: 5–50 ms per service hop  
- DB query: 1–10 ms (local), 10–100 ms (remote)  
- Service-to-service chain: 3–10 calls typical  
- Throughput: 100–10,000 req/sec per service (depends on scaling)  
- Deployment time: seconds–minutes per service  

---

## Configuration Knobs

| Knob | Default | Guidance |
|------|--------|---------|
| Service size | Undefined | Aim: 5–15 endpoints |
| Team size | N/A | 5–8 engineers per service |
| Timeout | 30s | Reduce to 1–5s for resilience |
| Retry count | 3 | Use exponential backoff |
| Circuit breaker | Off | Enable for external calls |
| Cache TTL | None | Add for read-heavy services |
| API versioning | Optional | Required for independent deploys |
| Autoscaling | Manual | Use based on CPU/latency |

---

## Failure Modes

| Failure | Cause | Mitigation |
|--------|------|-----------|
| Distributed Monolith | Tight coupling | Redesign boundaries |
| Nano-services | Over-splitting | Merge services |
| Mini-monolith | Oversized service | Split by domain |
| Chatty calls | Too many service calls | Aggregate operations |
| Data inconsistency | Distributed state | Use events + sagas |

---

## When to Use vs NOT Use

| Use When | Avoid When |
|---------|-----------|
| Multiple teams | Small team (<10) |
| Independent scaling needed | Simple application |
| Complex domain | Domain unclear |
| High deployment frequency | Stable, low-change system |

---

## Comparison vs Alternatives

| Approach | Pros | Cons |
|---------|------|------|
| Monolith | Simple, fast | Hard to scale teams |
| Modular Monolith | Best starting point | Limited scaling |
| Microservices | Scalable, flexible | Operational complexity |
| Nano-services | Fine-grained | High overhead |
| Mini-monolith | Fewer services | No independence |

---

## Common Pitfalls

- Designing services around database tables (entity services)  
- Splitting too early without domain knowledge  
- Ignoring team structure (Conway’s Law)  
- Excessive synchronous calls between services  
- Not planning for merging/splitting later  

---

## Golden Rule

**Start with a modular monolith → Extract gradually → Continuously evolve boundaries**
