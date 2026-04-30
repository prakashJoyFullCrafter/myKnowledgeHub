# COMMUNICATION PROTOCOLS — USE CASE WALKTHROUGHS

---

## 1. E-commerce Checkout (Amazon-like)

**Scenario:** User places an order on an e-commerce platform.

**Why this fits:**
- Requires strong consistency (payment + inventory)
- Latency-sensitive (user waiting)
- Side effects can be async (email, analytics)

**Architecture sketch:**
Client → API → OrderService  
→ InventoryService (sync)  
→ PaymentService (sync)  
→ DB write  
→ Queue.publish(order.placed)  
→ Email / Analytics workers  

**Scale numbers:**
- QPS: 1K–10K (peak 50K)
- Latency: <200ms
- Data: ~1–5 KB per request

**Pitfalls:**
- Cascading failures from payment API
- Overselling if inventory async
- Blocking on email service
- No circuit breaker → outage amplification

---

## 2. Real-Time Chat (WhatsApp / Slack)

**Scenario:** Users send/receive messages instantly.

**Why this fits:**
- Requires bidirectional communication
- Low latency (<100ms)
- High frequency small messages

**Architecture sketch:**
Client ↔ WebSocket Gateway  
→ Chat Service  
→ Message Queue  
→ Fan-out to recipients  
→ Push to connected clients  

**Scale numbers:**
- QPS: 100K–1M messages/sec
- Latency: <100ms
- Data: ~100 bytes/message

**Pitfalls:**
- Sticky sessions required
- Message ordering issues
- Scaling WebSocket connections
- Backpressure during spikes

---

## 3. Analytics Pipeline (Kafka + Avro)

**Scenario:** User activity events streamed for analytics.

**Why this fits:**
- High throughput
- Async processing
- Schema evolution required

**Architecture sketch:**
Client → Event Producer  
→ Kafka (partitioned)  
→ Consumers (Spark / Flink)  
→ Data warehouse  

**Scale numbers:**
- QPS: 100K–5M events/sec
- Latency: seconds acceptable
- Data: ~1 KB/event

**Pitfalls:**
- Schema breaking changes
- Consumer lag buildup
- Partition skew
- Data duplication

---

## 4. Video Streaming (Netflix)

**Scenario:** Streaming video to millions of users globally.

**Why this fits:**
- High bandwidth delivery
- Requires low startup latency
- Uses CDN + HTTP optimization

**Architecture sketch:**
Client → CDN Edge  
→ Origin servers  
→ Chunked video delivery (HTTP/2/3)  
→ Adaptive bitrate streaming  

**Scale numbers:**
- QPS: millions globally
- Latency: <1s startup
- Data: MB–GB per stream

**Pitfalls:**
- Buffering under packet loss
- CDN cache misses
- Poor bitrate adaptation
- TCP HOL blocking (fixed by QUIC)

---

## 5. Ride Matching System (Uber)

**Scenario:** Matching riders with nearby drivers.

**Why this fits:**
- Real-time updates
- Geospatial queries
- Event-driven architecture

**Architecture sketch:**
Client → API  
→ Location Service (updates)  
→ Matching Service  
→ Queue (driver updates)  
→ Notifications via WebSocket  

**Scale numbers:**
- QPS: 10K–100K
- Latency: <200ms
- Data: small JSON payloads

**Pitfalls:**
- Stale location data
- Race conditions in matching
- High fan-out notifications
- Inconsistent state across services

---

## 6. ML Inference Pipeline (Async Jobs)

**Scenario:** User uploads image for AI processing.

**Why this fits:**
- Long-running task (>1s)
- Async processing required
- Result delivered later

**Architecture sketch:**
Client → API (POST)  
→ Queue.publish(job)  
→ Worker (ML model)  
→ Store result  
→ Notify via polling / SSE  

**Scale numbers:**
- QPS: 100–10K
- Latency: seconds–minutes
- Data: MB per request

**Pitfalls:**
- Queue backlog growth
- Timeouts if done sync
- Missing idempotency
- Lost job tracking

