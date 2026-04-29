# SIDECAR PATTERN — USE CASES WALKTHROUGH

---

## 1. Service Mesh Proxy (Istio / Envoy)

**Scenario**  
Uber-style microservices platform uses Envoy sidecars for all service-to-service communication.

**Why this fits**
- Centralized traffic control (retries, mTLS)
- Language-agnostic (polyglot services)
- Zero code changes in apps

**Architecture sketch**
App → localhost:15001 → Envoy Sidecar  
Envoy → Service B Sidecar → Service B App  
Control Plane → Envoy (config)  

**Scale numbers**
- QPS: 1k–50k per service  
- Latency budget: +1–5 ms per hop  
- Pods: 100–1000+

**Pitfalls**
- Latency amplification across multiple hops  
- Misconfigured retries → cascading failures  
- High memory usage (Envoy ~100MB/pod)  

---

## 2. Database Connection Pooling (PgBouncer)

**Scenario**  
Fintech API uses PgBouncer sidecar to manage PostgreSQL connections.

**Why this fits**
- Reduces DB connection overhead  
- Handles failover transparently  
- Keeps app simple (localhost only)

**Architecture sketch**
App → localhost:5432 → PgBouncer  
PgBouncer → PostgreSQL Cluster  

**Scale numbers**
- App connections: 100+  
- DB connections: ~5–20 pooled  
- Latency: negligible (<1 ms)

**Pitfalls**
- Pool exhaustion under spikes  
- Incorrect pool mode (session vs transaction)  
- Debugging hidden DB issues  

---

## 3. Logging Sidecar (Fluentd)

**Scenario**  
E-commerce platform ships logs from pods to Elasticsearch using Fluentd.

**Why this fits**
- Decouples logging from app  
- Supports legacy log formats  
- Centralized observability

**Architecture sketch**
App → /var/log/app.log  
Fluentd → Elasticsearch  

**Scale numbers**
- Log volume: GBs/hour  
- Latency: seconds acceptable  
- CPU: spikes during bursts  

**Pitfalls**
- OOM during log spikes  
- Log loss if sidecar crashes  
- Disk filling if backpressure ignored  

---

## 4. Metrics Adapter (StatsD → Prometheus)

**Scenario**  
Gaming backend emits StatsD metrics, converted by sidecar to Prometheus.

**Why this fits**
- Avoids rewriting app metrics  
- Standardizes observability  
- Works across languages

**Architecture sketch**
App → UDP 8125 (StatsD)  
Sidecar → /metrics HTTP  
Prometheus → scrape  

**Scale numbers**
- Metrics/sec: 10k–100k  
- Latency: near real-time (<5s)  
- CPU: moderate parsing load  

**Pitfalls**
- Packet loss (UDP)  
- High cardinality metrics  
- Misconfigured mappings  

---

## 5. Secret Injection (Vault Agent)

**Scenario**  
Banking service uses Vault sidecar to inject and rotate secrets.

**Why this fits**
- No secrets in code  
- Auto-rotation support  
- Secure file-based access

**Architecture sketch**
Vault → Sidecar → shared volume  
App → reads secrets  

**Scale numbers**
- Secret refresh: minutes–hours  
- Latency: negligible  
- Pods: 100s  

**Pitfalls**
- App not reloading secrets  
- Vault outages → stale secrets  
- Misconfigured permissions  

---

## 6. API Authentication Proxy (OAuth2)

**Scenario**  
SaaS dashboard uses OAuth2 proxy sidecar for authentication.

**Why this fits**
- Removes auth logic from app  
- Centralized security policy  
- Easy integration with identity providers

**Architecture sketch**
User → Proxy → App  
Proxy → Identity Provider  

**Scale numbers**
- QPS: 100–10k  
- Latency: +5–20 ms (auth overhead)  
- Session cache reduces load  

**Pitfalls**
- Token expiry handling  
- Added latency on every request  
- Debugging auth failures  

---

## Source
Based on Module 4 study guide
