# Proxies & Service Mesh — Use Cases Walkthrough

---

## 1. Global Content Delivery (Netflix / YouTube)
**Scenario:** Netflix serves video content globally with low latency.

**Why this fits:**
- Edge caching reduces origin load
- CDN minimizes latency via geographic proximity
- Scales to millions of concurrent users

**Architecture:**
User → CDN → Regional Edge Cache → Origin (Reverse Proxy) → Storage

**Scale Numbers:**
- QPS: 1M+
- Data: Petabytes
- Latency: <50 ms edge, <200 ms origin

**Pitfalls:**
- Cache invalidation complexity
- Hotspot traffic (viral content)
- Regional outages

---

## 2. API Platform (Stripe / Twilio)
**Scenario:** Stripe processes API requests from developers worldwide.

**Why this fits:**
- API Gateway enforces auth + rate limits
- Reverse proxy handles TLS + routing
- Load balancer ensures high availability

**Architecture:**
Client → CDN → LB → API Gateway → Services → DB

**Scale Numbers:**
- QPS: 100K–500K
- Data: TB–PB
- Latency: <100 ms

**Pitfalls:**
- Misconfigured rate limits blocking users
- Auth bottlenecks
- Gateway becoming latency hotspot

---

## 3. Microservices Platform (Uber / Airbnb)
**Scenario:** Uber services communicate across hundreds of microservices.

**Why this fits:**
- Service mesh provides mTLS security
- Sidecars enable retries + circuit breaking
- Observability without code changes

**Architecture:**
Service A ↔ Sidecar ↔ Sidecar ↔ Service B → DB

**Scale Numbers:**
- QPS: 1M+
- Services: 100+
- Latency: <200 ms end-to-end

**Pitfalls:**
- Service mesh complexity
- Debugging distributed failures
- Sidecar latency overhead

---

## 4. High-Frequency Trading (Finance Systems)
**Scenario:** Trading systems require ultra-low latency order routing.

**Why this fits:**
- L4 load balancers minimize overhead
- No heavy proxy logic
- Direct TCP routing

**Architecture:**
Client → NLB (L4) → Trading Engine → DB

**Scale Numbers:**
- QPS: 10K–100K
- Latency: <1 ms critical path

**Pitfalls:**
- Network jitter
- TLS overhead impact
- Failover delays

---

## 5. SaaS Multi-Tenant Platform (Shopify)
**Scenario:** Shopify serves multiple tenants with isolation.

**Why this fits:**
- API Gateway manages tenants + auth
- Reverse proxy routes by domain/path
- Load balancing isolates failures

**Architecture:**
User → CDN → LB → API Gateway → Tenant Services → DB

**Scale Numbers:**
- QPS: 200K+
- Tenants: millions
- Latency: <150 ms

**Pitfalls:**
- Tenant noisy neighbor issues
- Incorrect routing causing data leaks
- Scaling database per tenant

---

## 6. Real-Time Chat (WhatsApp / Slack)
**Scenario:** Messaging systems require persistent connections.

**Why this fits:**
- L7 load balancer supports WebSockets
- Reverse proxy manages connection upgrades
- Horizontal scaling of chat servers

**Architecture:**
Client → LB (WebSocket) → Chat Servers → Message Queue → DB

**Scale Numbers:**
- Connections: 10M+
- Latency: <50 ms message delivery

**Pitfalls:**
- Connection drops during deploys
- Sticky session issues
- Backpressure handling
