# Microservices Service Decomposition — Use Cases Walkthrough

---

## 1. E-Commerce Checkout (Amazon-style)

**Scenario:** Customer places an order on an e-commerce platform.

**Why this fits:**
- Multiple independent domains (orders, payments, inventory)
- Requires scalability per domain
- High need for fault isolation

**Architecture sketch:**
Client → API Gateway  
→ Order Service  
→ Payment Service  
→ Inventory Service  
→ Event Bus → Notification Service  

**Scale numbers:**
- 1k–50k QPS (peak)
- Data: TBs (orders, catalog)
- Latency: 100–300 ms

**Pitfalls:**
- Chatty service calls during checkout  
- Payment + order consistency issues  
- Over-splitting into nano-services  

---

## 2. Ride Sharing (Uber)

**Scenario:** Matching riders with drivers in real time.

**Why this fits:**
- Real-time matching logic
- Independent scaling (matching vs payments)
- High availability requirements

**Architecture sketch:**
Client → Gateway  
→ Matching Service  
→ Driver Location Service  
→ Pricing Service  
→ Event Stream  

**Scale numbers:**
- 10k–100k QPS
- Data: GBs–TBs (locations)
- Latency: <100 ms

**Pitfalls:**
- Latency from multiple service hops  
- State synchronization issues  
- Hotspot scaling (city-level spikes)  

---

## 3. Streaming Platform (Netflix)

**Scenario:** User streams video content globally.

**Why this fits:**
- Heavy read traffic
- Independent scaling for streaming vs recommendations
- Global distribution

**Architecture sketch:**
Client → CDN  
→ Playback Service  
→ Recommendation Service  
→ Metadata Service  
→ Event Bus  

**Scale numbers:**
- 100k+ QPS
- Data: PB scale
- Latency: <50 ms (playback start)

**Pitfalls:**
- Cache invalidation complexity  
- Cross-region consistency  
- Over-centralized metadata service  

---

## 4. Payment Processing (Stripe-like)

**Scenario:** Processing online payments securely.

**Why this fits:**
- Strong consistency requirements
- Isolated failure domains
- Regulatory constraints

**Architecture sketch:**
Client → Gateway  
→ Payment Service  
→ Fraud Detection Service  
→ Bank APIs  
→ Event Bus  

**Scale numbers:**
- 1k–20k QPS
- Data: TB scale (transactions)
- Latency: 200–500 ms

**Pitfalls:**
- Distributed transaction complexity  
- Retry duplication issues  
- Tight coupling with external APIs  

---

## 5. Social Media Feed (Facebook)

**Scenario:** Generating personalized user feed.

**Why this fits:**
- High fan-out read pattern
- Independent scaling of feed vs write path
- Event-driven updates

**Architecture sketch:**
Client → Gateway  
→ Feed Service  
→ Post Service  
→ Graph Service  
→ Cache Layer  
→ Event Bus  

**Scale numbers:**
- 100k–1M QPS
- Data: PB scale
- Latency: <200 ms

**Pitfalls:**
- Feed generation bottlenecks  
- Cache stampede issues  
- Eventual consistency confusion  

---

## 6. Banking System

**Scenario:** Handling account transactions and balances.

**Why this fits:**
- Strong consistency requirements
- Clear domain boundaries (accounts, transactions)
- High reliability

**Architecture sketch:**
Client → Gateway  
→ Account Service  
→ Transaction Service  
→ Fraud Service  
→ Ledger DB  

**Scale numbers:**
- 500–5k QPS
- Data: TB scale
- Latency: <300 ms

**Pitfalls:**
- Incorrect service boundaries (entity services)  
- Complex rollback logic  
- Overuse of synchronous calls  

---

## Summary Insight

Microservices fit best when:
- Domains are clearly separable
- Teams need independence
- Scaling needs differ across components
