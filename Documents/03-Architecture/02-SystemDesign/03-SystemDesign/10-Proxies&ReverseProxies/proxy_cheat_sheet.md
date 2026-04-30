# Proxies & Service Mesh — One-Page Cheat Sheet

## 🧠 Definition
A proxy is an intermediary that routes and manages network traffic between clients and servers.  
A service mesh extends this by deploying sidecar proxies to control service-to-service communication.

---

## ⚙️ Core Components

| Component | Role | Key Property |
|----------|-----|-------------|
| Forward Proxy | Acts for client | Hides client IP |
| Reverse Proxy | Acts for server | Hides backend topology |
| Load Balancer | Distributes traffic | High availability |
| API Gateway | Manages APIs | Auth, rate limiting |
| Sidecar Proxy | Per-service proxy | Decentralized control |
| Control Plane | Config manager | Central policy |
| Data Plane | Traffic handlers | Envoy sidecars |

---

## 🔑 Key Algorithms / Protocols
- Round Robin — sequential distribution  
- Least Connections — send to least busy server  
- IP Hash — sticky sessions  
- TLS / mTLS — encryption + identity  
- HTTP CONNECT — tunneling HTTPS  
- Circuit Breaker — fail fast on errors  
- Retry w/ Backoff — resilience strategy  

---

## 📊 Performance Numbers (Typical)
- Nginx: ~50K static req/sec, ~15K proxy req/sec  
- HAProxy: millions req/sec (L4)  
- Sidecar overhead: +1–5ms per hop  
- TLS handshake: ~1–10ms  
- Cache hit latency: ~1ms vs backend ~50ms  

---

## 🎛️ Configuration Knobs

| Knob | Default | Tuning Tip |
|-----|--------|-----------|
| worker_processes | auto | match CPU cores |
| worker_connections | 1024 | increase for high concurrency |
| keepalive_timeout | 65s | lower for latency-sensitive apps |
| proxy_cache_valid | off | enable for read-heavy endpoints |
| gzip_comp_level | 1 | use 5–6 for balance |
| limit_req rate | none | set per-IP limits |
| timeout | varies | must exceed downstream latency |
| max_connections | varies | protect backend |

---

## 💥 Failure Modes

| Failure | Mitigation |
|--------|-----------|
| Backend crash | Health checks + failover |
| Overload (traffic spike) | Rate limiting + caching |
| Cascading failures | Circuit breakers |
| TLS misconfig | Centralized cert mgmt |
| Proxy bottleneck | Scale horizontally |

---

## ✅ When to Use

| Use | Avoid |
|----|------|
| Microservices (10+) | Small apps (<5 services) |
| Need mTLS security | Low-latency critical systems |
| API management | Simple monolith |
| High traffic scaling | No platform team |

---

## ⚖️ Comparison

| Feature | Reverse Proxy | Load Balancer | API Gateway | Service Mesh |
|--------|--------------|--------------|-------------|--------------|
| Routing | ✅ | ✅ | ✅ | ✅ |
| Load balancing | Basic | Primary | Yes | Yes |
| Auth | ❌ | ❌ | ✅ | Partial |
| Caching | ✅ | ❌ | Limited | ❌ |
| Observability | Logs | Metrics | Analytics | Full tracing |

---

## ⚠️ Common Pitfalls
- Using service mesh too early  
- Misconfigured timeouts (cascade failures)  
- Ignoring cache invalidation  
- Overusing API gateway for simple routing  
- Not monitoring latency overhead  
