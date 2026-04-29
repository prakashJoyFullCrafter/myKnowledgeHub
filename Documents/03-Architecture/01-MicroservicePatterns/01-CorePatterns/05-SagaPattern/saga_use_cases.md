# SAGA PATTERN — REAL-WORLD USE CASES

---

## 1. E-Commerce Order Processing
**Scenario:** Amazon-like checkout (order → inventory → payment → shipping)

**Why this fits:**
- Multiple independent services
- Requires compensation (refund, release stock)
- Payment is pivot transaction

**Architecture sketch:**
Client → Orchestrator  
→ Order Service (T1)  
→ Inventory Service (T2)  
→ Payment Service (T3 pivot)  
→ Shipping Service (T4)  
← Compensation on failure  

**Scale numbers:**
- QPS: 1k–10k  
- Data: KB per order  
- Latency: 200ms–2s  

**Pitfalls:**
- Double charges (missing idempotency)
- Wrong pivot handling
- Stuck orders in DLQ

---

## 2. Ride Booking (Uber)
**Scenario:** Rider requests trip → driver assigned → payment held → trip completed

**Why this fits:**
- Real-time distributed decisions
- Cancellation requires compensation
- Partial failures common

**Architecture sketch:**
App → Matching Service  
→ Driver Service  
→ Payment Hold  
→ Trip Service  
← Cancel → release driver + refund  

**Scale numbers:**
- QPS: 10k+  
- Data: small  
- Latency: <500ms  

**Pitfalls:**
- Driver double assignment
- Race conditions
- Retry storms

---

## 3. Travel Booking (Flight + Hotel)
**Scenario:** Expedia booking flight + hotel together

**Why this fits:**
- Cross-provider transactions
- Independent systems
- High failure probability

**Architecture sketch:**
User → Booking Saga  
→ Flight API  
→ Hotel API  
→ Payment  
← Compensation: cancel flight/hotel  

**Scale numbers:**
- QPS: 100–1k  
- Data: moderate  
- Latency: 1–5s  

**Pitfalls:**
- External API inconsistency
- Refund delays
- Partial cancellations

---

## 4. Food Delivery (DoorDash)
**Scenario:** Order → restaurant accept → driver assign → payment

**Why this fits:**
- Real-time orchestration
- Human + system steps
- High failure/cancel rate

**Architecture sketch:**
User → Order Service  
→ Restaurant Service  
→ Driver Service  
→ Payment  
← Cancel → refund + notify  

**Scale numbers:**
- QPS: 5k–20k  
- Data: small  
- Latency: <1s  

**Pitfalls:**
- Order accepted but no driver
- Refund inconsistencies
- Timeout handling

---

## 5. Loan Processing (Bank)
**Scenario:** Loan application → credit check → approval → disbursement

**Why this fits:**
- Long-running workflow
- Human approvals
- Strong audit requirements

**Architecture sketch:**
User → Orchestrator  
→ Credit Service  
→ Approval Workflow  
→ Payment Disbursement  
← Reject → cancel application  

**Scale numbers:**
- QPS: 10–100  
- Data: large  
- Latency: minutes–days  

**Pitfalls:**
- Manual step delays
- State inconsistency
- Audit gaps

---

## 6. Data Pipeline (ETL)
**Scenario:** Ingest → validate → transform → load → notify

**Why this fits:**
- Sequential steps
- Retry-heavy
- Failure isolation needed

**Architecture sketch:**
Source → Ingest  
→ Validate  
→ Transform  
→ Load DB  
→ Notify  
← Failure → rollback/load fix  

**Scale numbers:**
- QPS: batch  
- Data: GB–TB  
- Latency: seconds–hours  

**Pitfalls:**
- Partial loads
- Duplicate processing
- Data corruption
