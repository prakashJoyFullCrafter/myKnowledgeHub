# SERVICE MESH — ONE-PAGE CHEAT SHEET

## Definition
A service mesh is a dedicated infrastructure layer that manages service-to-service communication (east-west traffic) in microservices architectures. It provides security, reliability, and observability without requiring application code changes.

---

## Core Components
| Component        | Role                              | Key Property |
|-----------------|----------------------------------|-------------|
| Data Plane      | Handles traffic (sidecars/eBPF)  | Per-request processing |
| Control Plane   | Config + policy distribution     | Centralized brain |
| Sidecar Proxy   | Intercepts service traffic       | Language-agnostic |
| mTLS Engine     | Encrypts/authenticates traffic   | Zero-trust |
| Observability   | Metrics, logs, tracing           | Auto-generated |

---

## Key Protocols / Algorithms
- mTLS — mutual authentication + encryption
- xDS (Envoy APIs) — dynamic config distribution
- Circuit Breaking — isolate failing services
- Retry + Timeout — resilience patterns
- Load Balancing — round-robin / least-conn
- Distributed Tracing — request propagation

---

## Performance Numbers (Typical)
- Latency overhead: 1–5 ms per hop (Envoy), <1 ms (Linkerd), ~0.05 ms (Cilium)
- Memory per pod: 50–100 MB (Istio), ~10 MB (Linkerd), 0 MB (Cilium)
- CPU overhead: 1–3% per pod (Envoy), ~0.5% (Linkerd)
- Throughput: Cilium ~3× Envoy (kernel-level)
- Cluster overhead: +20–25% RAM capacity needed

---

## Configuration Knobs (Important)
| Setting | Default | Guidance |
|--------|--------|---------|
| Retry attempts | 2–3 | Avoid retry storms |
| Timeout | None | Always set (e.g., 2–5s) |
| Circuit breaker threshold | 5 errors | Tune per service |
| Load balancing | Round-robin | Use least-conn for uneven load |
| mTLS mode | PERMISSIVE | Move to STRICT gradually |
| Connection pool | Default | Limit to prevent overload |
| Rate limit | Off | Enable for critical services |

---

## Failure Modes
- Sidecar injection failure → Pods fail to start → Check webhook/config
- Misconfigured routing → Wrong traffic split → Validate configs
- mTLS STRICT breakage → Unmeshed callers fail → Use PERMISSIVE first
- Control plane outage → Config freeze → Ensure HA setup
- Circuit breaker too aggressive → Healthy pods ejected → Tune thresholds

---

## When to Use / NOT Use
| Use When | Avoid When |
|----------|-----------|
| >10 services | <5 services |
| Polyglot system | Single language |
| Need mTLS compliance | No security requirement |
| Observability gaps | Simple architecture |
| Platform/SRE team exists | No ops ownership |

---

## Comparison vs Alternatives
| Feature | Service Mesh | API Gateway | Library |
|--------|-------------|-------------|--------|
| Traffic | East-West | North-South | Internal |
| Language support | Any | Any | Language-specific |
| mTLS | Automatic | Limited | Manual |
| Observability | Full | External only | Partial |
| Complexity | High | Medium | Low |

---

## Common Pitfalls
- Adopting too early (overengineering)
- Ignoring resource overhead
- Skipping observability-first phase
- Misconfiguring mTLS (causing outages)
- No dedicated platform team
