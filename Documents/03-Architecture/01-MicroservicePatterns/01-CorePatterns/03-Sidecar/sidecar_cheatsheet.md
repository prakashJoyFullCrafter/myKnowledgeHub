# SIDECAR PATTERN — ONE-PAGE CHEAT SHEET

## Definition
Sidecar Pattern: A deployment pattern where a helper container runs alongside the main application container in the same pod, providing cross-cutting capabilities like networking, logging, or security.
It separates infrastructure concerns from business logic while sharing the same environment (network, storage).

---

## Core Components

| Component | Role | Key Property |
|----------|------|-------------|
| Application Container | Business logic | No infra concerns |
| Sidecar Container | Provides infra features | Independent lifecycle |
| Shared Network | Communication via localhost | Low latency |
| Shared Volume | Data exchange (logs/config) | Optional |
| Control Plane (optional) | Central config (Istio) | Global policy |

---

## Key Algorithms / Protocols

- mTLS (Mutual TLS): Secure service-to-service encryption  
- Circuit Breaking: Stops calls to failing services  
- Retry with Backoff: Handles transient failures  
- Load Balancing: Distributes requests across instances  
- Distributed Tracing (OpenTelemetry): Tracks request flow  
- Connection Pooling: Reuses connections (PgBouncer)  

---

## Performance Numbers

- Sidecar latency overhead: **1–5 ms per hop**  
- Library overhead: **~1–5 µs**  
- Envoy memory: **50–100 MB per pod**  
- Linkerd memory: **~10 MB per pod**  
- CPU overhead: **~1–3% per sidecar**  
- High-throughput impact: Significant at **>1000 RPS**  

---

## Configuration Knobs

| Setting | Default | Guidance |
|--------|--------|----------|
| retries.attempts | 2–3 | Increase for unstable networks |
| timeout | 1–5s | Keep < SLA |
| circuit breaker threshold | ~50% errors | Tune per service |
| memory limit | varies | Set 3–4x request |
| CPU limit | varies | Allow burst capacity |
| log buffer size | small | Increase for spikes |
| connection pool size | low (5–10) | Tune for DB-heavy apps |

---

## Failure Modes

1. Startup race condition → Use native sidecars  
2. Sidecar OOMKilled → Increase memory limits  
3. Retry storms → Separate sidecar vs library retries  
4. Misconfigured routing → Validate config (istioctl)  
5. Log loss on shutdown → Use native sidecar lifecycle  

---

## When to Use vs NOT Use

### Use
- Polyglot microservices  
- Large systems (20+ services)  
- Strong security/compliance (mTLS)  
- Platform/SRE team exists  

### Avoid
- Small systems (<10 services)  
- Single-language stack  
- Ultra-low latency (<10ms SLA)  
- No platform expertise  

---

## Comparison vs Alternatives

| Feature | Sidecar | Library |
|--------|--------|--------|
| Language support | Any | Per language |
| Performance | Slower | Faster |
| Deployment | Independent | Coupled |
| Flexibility | Lower | Higher |
| Ops complexity | High | Low |

---

## Common Pitfalls

- Forgetting resource limits → pod eviction risk  
- Double retries → traffic explosion  
- Ignoring latency overhead  
- Overusing mesh in small systems  
- Poor debugging visibility  

---

## Source
Based on Modules 1–4 study guides fileciteturn3file0
