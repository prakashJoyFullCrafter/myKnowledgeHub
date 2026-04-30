# Message Queues — Use Cases Walkthrough

---

## 1. E-commerce Order Processing

**Scenario:** Amazon processes millions of orders and triggers inventory, payment, and shipping asynchronously.

**Why this fits:**
- Decouples multiple downstream services
- Handles spikes (e.g., Black Friday)
- Enables fan-out to many consumers

**Architecture sketch:**
Order Service → Queue (order.placed)
→ Inventory Service
→ Payment Service
→ Email Service
→ Analytics

**Scale numbers:**
- 10K–100K QPS
- Payload: 1–5 KB
- Latency: < 1–2 sec acceptable

**Pitfalls:**
- Duplicate order processing
- Out-of-order events
- Missing idempotency

---

## 2. Log Aggregation (Observability)

**Scenario:** Netflix collects logs from thousands of microservices into a central system.

**Why this fits:**
- High throughput ingestion
- Replay for debugging
- Multiple consumers (monitoring, analytics)

**Architecture sketch:**
Services → Kafka Topic (logs)
→ Monitoring
→ Alerting
→ Data Lake

**Scale numbers:**
- 1M+ msgs/sec
- Payload: 0.5–2 KB
- Latency: seconds OK

**Pitfalls:**
- Storage explosion
- Poor partitioning
- Consumer lag

---

## 3. Ride-Sharing Notifications

**Scenario:** Uber sends ride updates (driver arriving, trip started).

**Why this fits:**
- Real-time event delivery
- Fan-out to multiple channels
- Handles bursts of activity

**Architecture sketch:**
Ride Service → SNS
→ SQS (push notifications)
→ SQS (SMS)
→ Lambda (real-time alerts)

**Scale numbers:**
- 5K–20K QPS
- Payload: <1 KB
- Latency: < 1 sec

**Pitfalls:**
- Message loss (SNS only)
- Duplicate notifications
- TTL misconfiguration

---

## 4. Financial Transaction Processing

**Scenario:** Stripe processes payments with guaranteed consistency.

**Why this fits:**
- Reliability critical (no loss)
- Ordered per account
- Supports retries

**Architecture sketch:**
Payment Service → Queue
→ Fraud Check
→ Ledger Update
→ Notification

**Scale numbers:**
- 1K–10K QPS
- Payload: 1–3 KB
- Latency: < 2–5 sec

**Pitfalls:**
- Double charging (no idempotency)
- Ordering violations
- No DLQ handling

---

## 5. IoT Sensor Data Pipeline

**Scenario:** Smart home devices stream telemetry data.

**Why this fits:**
- Massive scale ingestion
- Buffering for bursts
- Parallel processing

**Architecture sketch:**
Devices → Gateway → Kafka
→ Stream Processing
→ Storage (DB/Data Lake)

**Scale numbers:**
- 100K–1M QPS
- Payload: <1 KB
- Latency: seconds acceptable

**Pitfalls:**
- Hot partitions
- Backpressure ignored
- Data loss in spikes

---

## 6. Email Campaign System

**Scenario:** Mailchimp sends millions of emails in batches.

**Why this fits:**
- Task queue model
- Rate limiting required
- Retry on failure

**Architecture sketch:**
Campaign Service → Queue
→ Worker Pool
→ Email Provider API

**Scale numbers:**
- 10K–50K jobs/sec
- Payload: 1–10 KB
- Latency: minutes OK

**Pitfalls:**
- Rate limits exceeded
- Retry storms
- No prioritization

---

## Key Takeaways
- Use queues for **decoupling + scaling**
- Always design for **idempotency**
- Monitor **lag + backpressure**
- Choose tech based on **scale + complexity**
