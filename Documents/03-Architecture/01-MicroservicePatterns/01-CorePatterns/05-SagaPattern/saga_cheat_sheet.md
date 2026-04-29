# SAGA PATTERN — ONE PAGE CHEAT SHEET

## Definition
Saga is a pattern for managing distributed transactions by breaking them into a sequence of local transactions coordinated via events or a central orchestrator.
Each step commits independently and failures are handled via compensating transactions instead of global rollback.

---

## Core Components
| Component | Role | Key Property |
|----------|------|-------------|
| Saga | Overall workflow | Eventually consistent |
| Step (T1..Tn) | Local transaction | Atomic per service |
| Compensation (C1..Cn) | Undo step | Must be idempotent |
| Orchestrator | Central controller | Strong visibility |
| Event Bus | Communication layer | Decoupled services |
| Saga State | Progress tracking | Persistent |

---

## Key Algorithms / Protocols
- Forward Recovery: Retry transient failures with backoff  
- Backward Recovery: Execute compensations in reverse order  
- Idempotency: Ensure repeated execution is safe  
- Exponential Backoff + Jitter: Avoid retry storms  
- Pivot Transaction: Defines point-of-no-return  
- DLQ Handling: Capture unrecoverable failures  

---

## Performance Numbers (Typical)
- Saga duration: ms → days (depends on workflow)  
- Retry latency: 100ms → 30s backoff  
- Throughput: 100–10k+ sagas/sec (with Kafka/Temporal)  
- Event delivery: at-least-once (duplicates expected)  
- Compensation delay: seconds → minutes  
- DLQ recovery: minutes → hours  

---

## Configuration Knobs
| Setting | Default | Guidance |
|--------|--------|----------|
| Max retries | 3–5 | Increase for transient-heavy systems |
| Backoff base | 100ms | Tune for service latency |
| Max delay | 30s | Prevent long stalls |
| Timeout | 30s | Match downstream SLA |
| Idempotency key | sagaId+step | Always deterministic |
| DLQ threshold | after retries | Monitor aggressively |
| Saga timeout | hours/days | Prevent zombie sagas |

---

## Failure Modes
| Failure | Mitigation |
|--------|-----------|
| Partial completion | Compensation logic |
| Duplicate execution | Idempotency |
| Stuck saga | DLQ + manual intervention |
| Network partition | Retry + backoff |
| Post-pivot failure | Forward recovery |

---

## When to Use / Avoid

### Use
- Distributed microservices transactions  
- Long-running workflows  
- Need for scalability over strict consistency  
- Event-driven systems  

### Avoid
- Simple CRUD in single DB  
- Strong consistency required (bank ledger)  
- Low-latency critical path (<10ms)  
- Small systems (overkill)  

---

## Comparison vs Alternatives
| Approach | Consistency | Complexity | Use Case |
|----------|------------|-----------|---------|
| Saga | Eventual | Medium | Microservices |
| 2PC | Strong | High | Legacy DB systems |
| Monolith | Strong | Low | Small apps |
| Eventual only | Weak | Low | Async pipelines |

---

## Common Pitfalls
- Missing compensations  
- Non-idempotent operations  
- Wrong error classification  
- Ignoring pivot transaction  
- No observability/monitoring  
