# Circuit Breaker — Use Cases Walkthrough

---

## 1. Payment Processing (e.g., Stripe-like system)

**Scenario**  
An e-commerce platform processes payments via an external payment gateway.

**Why this fits**
- External dependency (high failure risk)
- No acceptable degraded fallback → must fail fast
- High latency sensitivity (user checkout)

**Architecture Sketch**
Client → API → Order Service  
→ Circuit Breaker  
→ Retry (inner)  
→ Payment Gateway (external)  
→ Fallback → return error immediately  

**Scale Numbers**
- QPS: 1k–10k  
- Latency budget: < 300 ms  
- Timeout: 2–3s  

**Pitfalls**
- Retrying outside CB → duplicate charges risk  
- Too long timeout → checkout hangs  
- Wrong fallback (fake success) → financial loss  

---

## 2. Product Catalog (e.g., Amazon listing service)

**Scenario**  
A product page fetches catalog data from a backend service.

**Why this fits**
- Read-heavy workload  
- Data is cacheable  
- Partial degradation acceptable  

**Architecture Sketch**
Client → API → Product Service  
→ Circuit Breaker  
→ Catalog Service  
→ Cache fallback (Redis)  

**Scale Numbers**
- QPS: 50k–200k  
- Latency: 50–150 ms  
- Cache size: GBs  

**Pitfalls**
- Not labeling stale data  
- Cache miss + CB open → blank UI  
- Over-aggressive thresholds → false trips  

---

## 3. Recommendation Engine (e.g., Netflix recommendations)

**Scenario**  
User homepage loads personalized recommendations.

**Why this fits**
- Non-critical feature  
- Has meaningful default fallback  
- High variability in latency  

**Architecture Sketch**
Client → API → Recommendation Service  
→ Circuit Breaker  
→ ML Service  
→ Fallback → trending/top content  

**Scale Numbers**
- QPS: 100k+  
- Latency budget: 100–300 ms  
- Model response: 200–500 ms  

**Pitfalls**
- Blocking page load on slow ML service  
- No fallback → empty homepage  
- Not isolating via bulkhead  

---

## 4. Inventory / Stock Service (e.g., e-commerce checkout)

**Scenario**  
Checkout service verifies stock availability.

**Why this fits**
- Strong consistency needed  
- Cannot serve stale data  
- Partial degradation possible  

**Architecture Sketch**
Client → Checkout Service  
→ Circuit Breaker  
→ Inventory Service  
→ Fallback → “availability unknown”  

**Scale Numbers**
- QPS: 5k–20k  
- Latency: < 200 ms  
- Data freshness: real-time  

**Pitfalls**
- Returning stale inventory → overselling  
- Treating 404 as failure → false trips  
- Too many probes → overload recovering service  

---

## 5. External API Integration (e.g., weather or maps API)

**Scenario**  
App fetches weather/location data from third-party API.

**Why this fits**
- Unreliable external system  
- Network latency + rate limits  
- Optional feature  

**Architecture Sketch**
Client → API → Service  
→ Circuit Breaker  
→ External API  
→ Fallback → cached/last known data  

**Scale Numbers**
- QPS: 1k–50k  
- Latency: 200–800 ms  
- Cache TTL: minutes  

**Pitfalls**
- No CB → cascading failure  
- Ignoring rate-limit errors  
- Excess retries → API throttling  

---

## 6. Authentication Service (e.g., OAuth provider)

**Scenario**  
Service validates user tokens with an auth server.

**Why this fits**
- Security-critical  
- No safe fallback  
- High availability required  

**Architecture Sketch**
Client → API → Auth Service  
→ Circuit Breaker  
→ Identity Provider  
→ Fallback → reject request  

**Scale Numbers**
- QPS: 10k–100k  
- Latency: < 100 ms  
- Token validation: real-time  

**Pitfalls**
- Allowing fallback → security breach  
- Slow auth → system-wide slowdown  
- Misclassifying errors → missed trips  

---

