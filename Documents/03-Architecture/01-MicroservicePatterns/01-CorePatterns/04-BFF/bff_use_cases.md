# BFF Use Cases Walkthrough

---

## 1. E-Commerce Mobile App (Amazon-style)

### Scenario
A mobile shopping app needs fast product pages on slow networks.

### Why this fits
- Strict payload limits (<2KB)
- High latency sensitivity (mobile networks)
- Fixed UI screens → predictable data shape

### Architecture sketch
Client (Mobile App)
→ API Gateway
→ Mobile BFF
→ Product / Inventory / Review Services
→ DB

### Scale numbers
- QPS: 5k–50k
- Payload: ~0.5–2KB
- Latency budget: ~200ms

### Pitfalls
- Overloading BFF with pricing logic
- Ignoring image optimization
- Sequential service calls

---

## 2. Web Application (Netflix-style)

### Scenario
A rich web UI with large datasets and personalization.

### Why this fits
- Large payloads acceptable (40KB+)
- SSR/SEO requirements
- Complex aggregation across services

### Architecture sketch
Browser
→ API Gateway
→ Web BFF
→ Recommendation / Content / User Services
→ DB

### Scale numbers
- QPS: 10k–100k
- Payload: 20–50KB
- Latency: ~300ms

### Pitfalls
- Over-fetching due to poor transformation
- Coupling UI logic to services
- Lack of caching

---

## 3. Partner API (Stripe-style)

### Scenario
External developers integrate with a stable API.

### Why this fits
- Versioned contracts required
- Strong SLA guarantees
- Client-specific rate limiting

### Architecture sketch
Partner Client
→ API Gateway
→ Partner BFF
→ Domain Services
→ DB

### Scale numbers
- QPS: 1k–10k
- Payload: 1–10KB
- Latency: ~300–500ms

### Pitfalls
- Breaking API contracts
- Missing versioning
- Poor documentation

---

## 4. IoT Platform (Smart Devices)

### Scenario
Low-power devices sending minimal data over cellular.

### Why this fits
- Extremely small payloads (<100 bytes)
- Different protocol (binary/MQTT)
- Tight memory constraints

### Architecture sketch
IoT Device
→ Gateway
→ IoT BFF
→ Data Ingestion Services
→ DB

### Scale numbers
- QPS: 100k+
- Payload: <100 bytes
- Latency: ~100ms

### Pitfalls
- Using JSON instead of binary
- Large payload responses
- No batching strategy

---

## 5. Internal Admin Dashboard

### Scenario
Internal tool for operations and analytics.

### Why this fits
- Aggregates many services
- Flexible but still structured queries
- Not performance-critical

### Architecture sketch
Admin UI
→ API Gateway
→ Admin BFF
→ Multiple Domain Services
→ DB

### Scale numbers
- QPS: 100–1k
- Payload: 10–30KB
- Latency: ~500ms acceptable

### Pitfalls
- Over-engineering BFF instead of using GraphQL
- Adding business logic
- Lack of observability

---

## 6. Multi-Team SaaS Platform

### Scenario
Multiple frontend teams building independent products.

### Why this fits
- Team autonomy required
- Different product surfaces
- Independent deployments

### Architecture sketch
Clients (multiple)
→ API Gateway
→ Multiple BFFs (per team)
→ Shared Domain Services
→ DB

### Scale numbers
- QPS: 10k–100k
- Payload: varies (1–50KB)
- Latency: ~200–400ms

### Pitfalls
- BFF sprawl (too many services)
- Inconsistent standards
- Shared logic duplication
