# Database per Service — Use Cases Walkthrough

---

## 1. E-Commerce Order Processing (Amazon-like)

**Scenario**  
Processing customer orders with payments, inventory, and user data.

**Why this fits**
- Strong service boundaries (orders, payments, users)
- Different consistency needs (payments vs catalog)
- High scalability requirements

**Architecture sketch**
Client → Order Service → Orders DB  
Order Service → Payment Service (API)  
Order Service → Inventory Service (API)  
Services → Event Bus (ORDER_CREATED, PAYMENT_DONE)  
Event Bus → Read Models / Analytics  

**Scale numbers**
- 5K–50K QPS peak
- Data: TBs (orders history)
- Latency: <200 ms end-to-end

**Pitfalls observed**
- Saga failures causing partial orders  
- Overuse of synchronous API calls  
- Inconsistent inventory states  

---

## 2. Real-Time Product Search (Amazon / eBay)

**Scenario**  
Searching millions of products with filters and ranking.

**Why this fits**
- Search requires specialized DB (Elasticsearch)
- High read throughput
- Eventual consistency acceptable

**Architecture sketch**
Catalog Service → PostgreSQL (source of truth)  
Catalog → Event Bus → Search Service  
Search Service → Elasticsearch index  
Client → Search API → Elasticsearch  

**Scale numbers**
- 10K–100K QPS
- Data: 100M+ products
- Latency: <100 ms

**Pitfalls observed**
- Stale search index after updates  
- Poor mapping design → slow queries  
- Reindexing downtime issues  

---

## 3. Session Management (Netflix / Facebook)

**Scenario**  
Managing user sessions for millions of concurrent users.

**Why this fits**
- Key-value access pattern
- Ultra-low latency required
- TTL-based expiry

**Architecture sketch**
Client → API Gateway  
API → Session Service  
Session Service → Redis  
Redis → TTL expiry  

**Scale numbers**
- 100K–1M QPS
- Data: GBs (in-memory)
- Latency: <1 ms lookup

**Pitfalls observed**
- Redis memory exhaustion  
- Missing persistence → data loss  
- Hot key issues  

---

## 4. Activity Feed (Twitter / Instagram)

**Scenario**  
Displaying user activity feeds with millions of updates.

**Why this fits**
- Append-only write-heavy workload
- Time-ordered queries
- Massive scale

**Architecture sketch**
User Actions → Event Bus  
Event Bus → Feed Service  
Feed Service → Cassandra  
Client → Feed API → Cassandra  

**Scale numbers**
- Writes: 1M+/sec
- Data: PB scale
- Latency: 1–10 ms read

**Pitfalls observed**
- Wide partition problems  
- Poor data modeling → slow queries  
- Backfill complexity  

---

## 5. Analytics & Reporting (Enterprise BI)

**Scenario**  
Generating business reports across all services.

**Why this fits**
- Cross-service aggregation required
- No impact on production DBs
- Large-scale historical queries

**Architecture sketch**
Services → Event Bus / CDC  
Event Bus → Data Pipeline  
Pipeline → Data Warehouse  
BI Tools → Warehouse  

**Scale numbers**
- Data: TB–PB
- Query latency: seconds–minutes
- Ingestion: 10K–1M events/sec

**Pitfalls observed**
- Direct DB access (anti-pattern)  
- Data lag confusion  
- Schema evolution breaking pipelines  

---

## 6. Payment Processing System (Stripe-like)

**Scenario**  
Handling financial transactions with high consistency.

**Why this fits**
- Strong consistency required
- Clear service boundaries
- Audit/compliance needs

**Architecture sketch**
Client → Payment Service  
Payment Service → PostgreSQL  
Payment Service → Event Bus  
Event Bus → Ledger / Audit Service  

**Scale numbers**
- 1K–10K TPS
- Data: TBs
- Latency: <300 ms

**Pitfalls observed**
- Incorrect compensation logic  
- Duplicate event handling issues  
- Data inconsistency across services  

