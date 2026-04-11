# Domain-Specific Design Patterns - Curriculum

Full case-study breakdowns for the most common system design problems. Each is an archetype you will encounter repeatedly in interviews and real systems.

> Module 7 of System Design Interview Framework lists these as bullet points. This topic provides the deep treatment each one deserves.

---

## Module 1: Feeds & Timelines
- [ ] **The problem**: show each user a personalized feed of posts from people they follow
- [ ] **Fan-out on write**: when user posts → write to every follower's feed cache
  - [ ] Pros: fast reads (pre-computed); Cons: expensive writes for celebrities (millions of followers)
- [ ] **Fan-out on read**: when user opens feed → query all followed users' posts → merge → rank
  - [ ] Pros: cheap writes; Cons: slow reads (many queries, merge on the fly)
- [ ] **Hybrid approach** (Twitter/Instagram): fan-out on write for normal users, fan-out on read for celebrities
- [ ] **Feed ranking**: chronological vs algorithmic (engagement signals, ML model)
- [ ] **Feed storage**: pre-computed feed in Redis (list of post IDs per user)
- [ ] **Infinite scroll / pagination**: cursor-based pagination (not offset-based)
- [ ] **Key challenge**: consistency — user posts, then checks own feed, expects to see it immediately

## Module 2: Chat & Real-Time Presence
- [ ] **Connection**: WebSocket for bidirectional real-time communication
- [ ] **Message flow**: sender → WebSocket server → message queue → recipient's WebSocket server → recipient
- [ ] **Message storage**: write to DB for persistence + deliver in real-time via WebSocket
- [ ] **Group chat**: fan-out message to all group members
- [ ] **Delivery status**: sent (server received) → delivered (device received) → read (user opened)
  - [ ] Track per-message, per-recipient status
- [ ] **Presence (online/offline)**: heartbeat-based — no heartbeat for N seconds → mark offline
  - [ ] Store in Redis with TTL, broadcast status changes to contacts
- [ ] **Offline messages**: queue messages, deliver when user reconnects
- [ ] **End-to-end encryption**: Signal protocol — keys on devices, server can't read messages
- [ ] **Scaling WebSockets**: sticky sessions or connection registry (which server has which user)
- [ ] **Key challenge**: ordering messages in group chat, handling network interruptions gracefully

## Module 3: Payment Systems & Ledgers
- [ ] **Core principle**: money must never be lost, duplicated, or miscounted
- [ ] **Double-entry ledger**: every transaction = debit entry + credit entry, always balanced
- [ ] **Idempotency**: every payment API call has idempotency key — retries are safe
- [ ] **Payment flow**: intent → authorize → capture → settle
  - [ ] Authorization: verify funds, place hold
  - [ ] Capture: actually move money
  - [ ] Settlement: batch reconciliation with payment processor (daily)
- [ ] **Escrow**: hold funds between parties until conditions met (marketplace pattern)
- [ ] **Reconciliation**: compare internal ledger vs payment gateway records (daily, automated)
- [ ] **PCI compliance**: never store raw card numbers — use payment processor tokens
- [ ] **Failure handling**: payment succeeds but order fails → refund; order succeeds but payment fails → cancel
- [ ] **Key challenge**: exactly-once payment processing, handling timeouts from payment gateway

## Module 4: Booking & Reservation Systems
- [ ] **The problem**: limited inventory (hotel rooms, seats, time slots) — prevent double-booking
- [ ] **Optimistic approach**: allow booking, check conflicts before confirming
  - [ ] Database constraint: `UNIQUE (resource_id, date)` prevents double-booking at DB level
  - [ ] SELECT FOR UPDATE: lock the row during booking transaction
- [ ] **Pessimistic approach**: lock resource immediately when user starts booking flow
  - [ ] Temporary hold: reserve for 10-15 minutes, release if not confirmed
  - [ ] Redis with TTL: `SETNX resource:date → user_id` with expiry
- [ ] **Overbooking**: intentionally book more than capacity (airlines), handle statistically
- [ ] **Distributed booking**: multiple services/regions — need distributed lock or single source of truth
- [ ] **Waitlist**: when fully booked, queue users, notify when slot opens
- [ ] **Key challenge**: race conditions under high concurrency (concert tickets, flash sales)

## Module 5: Notification Systems
- [ ] **Channels**: push notification (mobile), email, SMS, in-app, WebSocket
- [ ] **Architecture**: event → notification service → channel router → channel-specific sender
- [ ] **Template engine**: notification templates with variables (user name, order ID)
- [ ] **Priority & rate limiting**: urgent (payment failure) vs low (weekly digest), per-user throttle
- [ ] **User preferences**: opt-in/opt-out per channel per notification type
- [ ] **Delivery tracking**: sent → delivered → opened → clicked
- [ ] **Batching**: aggregate multiple events into one notification (5 new likes → "5 people liked your post")
- [ ] **Retry & DLQ**: failed sends retry with backoff, dead letter queue for persistent failures
- [ ] **Key challenge**: not annoying users (over-notification), ensuring critical notifications always arrive

## Module 6: Recommendation Systems
- [ ] **Collaborative filtering**: "users who liked X also liked Y"
  - [ ] User-based: find similar users, recommend what they liked
  - [ ] Item-based: find similar items to what user already liked
- [ ] **Content-based filtering**: recommend items with similar attributes to user's preferences
- [ ] **Hybrid**: combine collaborative + content-based (Netflix approach)
- [ ] **Architecture**: offline model training → feature store → online serving → A/B testing
- [ ] **Candidate generation → ranking → re-ranking**: three-stage pipeline
  - [ ] Candidate generation: fast, broad retrieval (embedding similarity, rules)
  - [ ] Ranking: ML model scores each candidate
  - [ ] Re-ranking: business rules (diversity, freshness, already seen)
- [ ] **Cold start**: new user (no history) or new item (no interactions) — use popularity, demographics, content features
- [ ] **Feature store**: pre-computed user/item features for low-latency serving (Feast, Tecton)
- [ ] **Key challenge**: cold start, real-time personalization, avoiding filter bubbles

## Module 7: Analytics & Metrics Systems
- [ ] **The problem**: ingest billions of events/day, query them in real-time and batch
- [ ] **Event ingestion**: client SDK → event collector → Kafka → processing → storage
- [ ] **Storage**: time-series database (InfluxDB, TimescaleDB) or columnar (ClickHouse, Druid, BigQuery)
- [ ] **Pre-aggregation**: compute aggregates during ingestion (counters, sums per minute/hour)
  - [ ] Raw events for ad-hoc queries, pre-aggregated for dashboards
- [ ] **Query patterns**: time-range queries, GROUP BY dimensions, top-K, percentiles
- [ ] **Lambda/Kappa**: batch layer for historical accuracy + speed layer for real-time
- [ ] **Dashboard serving**: materialized views or caching layer for dashboard queries
- [ ] **Data retention**: hot (recent, fast storage) → warm (older, cheaper) → cold (archive)
- [ ] **Key challenge**: high cardinality dimensions (millions of unique user IDs), query performance at scale

## Module 8: File Storage & Sync
- [ ] **The problem**: store files, sync across devices, handle conflicts (Dropbox, Google Drive)
- [ ] **Chunking**: split files into fixed-size chunks (4MB), store each chunk with content hash
  - [ ] Deduplication: same content = same hash → store once
  - [ ] Incremental sync: only upload/download changed chunks
- [ ] **Metadata service**: tracks files, chunks, versions, sharing permissions
- [ ] **Sync protocol**: client watches local filesystem → detect changes → upload chunks → notify other clients
- [ ] **Conflict resolution**: two users edit same file offline → create conflict copy, let user resolve
- [ ] **Versioning**: keep N versions, diff between versions, restore old versions
- [ ] **Storage**: chunks in object storage (S3), metadata in relational DB
- [ ] **Key challenge**: efficient sync (minimize data transfer), conflict handling, real-time notification

## Module 9: Multi-Tenant SaaS
- [ ] **Tenant isolation**: shared infra vs dedicated infra per tenant
  - [ ] Small tenants: shared everything (DB, compute) — cheapest
  - [ ] Medium tenants: shared compute, separate DB schema
  - [ ] Enterprise tenants: dedicated compute + DB — strongest isolation, highest cost
- [ ] **Tenant-aware routing**: tenant ID in subdomain, header, or JWT → route to correct resources
- [ ] **Data isolation**: row-level security, schema-per-tenant, or DB-per-tenant
- [ ] **Noisy neighbor prevention**: per-tenant rate limits, resource quotas, fair scheduling
- [ ] **Customization**: per-tenant configuration, branding, feature flags
- [ ] **Onboarding/offboarding**: automated tenant provisioning and data cleanup
- [ ] **Billing**: usage metering per tenant (API calls, storage, compute)
- [ ] **Key challenge**: isolation vs cost efficiency, scaling from 10 to 10,000 tenants

## Module 10: Rate Limiting & Abuse Prevention Systems
- [ ] **Rate limiter architecture**: centralized (API gateway) vs distributed (per-service + shared state)
- [ ] **Algorithms in practice**:
  - [ ] Token bucket: smooth rate, allows bursts (most common)
  - [ ] Sliding window log: exact, but memory-heavy
  - [ ] Sliding window counter: approximate, memory-efficient (recommended)
- [ ] **Distributed rate limiting**: Redis-based counters shared across instances
  - [ ] Race condition: use Redis Lua scripts for atomic increment + check
- [ ] **Multi-level limiting**: per IP, per user, per API key, per endpoint, global
- [ ] **Abuse patterns**: credential stuffing, scraping, bot traffic, API abuse
- [ ] **Response**: HTTP 429 + Retry-After header, exponential backoff suggestion
- [ ] **Graceful handling**: distinguish rate-limited users from system errors
- [ ] **Key challenge**: accurate distributed counting at high throughput, not rate-limiting legitimate burst traffic

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design Twitter feed for 500M users — hybrid fan-out, ranking, caching |
| Module 2 | Design WhatsApp — message delivery, group chat, presence, E2E encryption |
| Module 3 | Design Stripe payment processing — ledger, idempotency, reconciliation |
| Module 4 | Design airline seat booking — prevent double-booking under 10K concurrent users |
| Module 5 | Design notification system for a food delivery app — multi-channel, priority, batching |
| Module 6 | Design YouTube recommendation — candidate generation, ranking, cold start |
| Module 7 | Design real-time analytics for a mobile app — event ingestion, dashboards, retention |
| Module 8 | Design Dropbox — chunking, sync, conflict resolution, sharing |
| Module 9 | Design multi-tenant SaaS for 1000 tenants — isolation model, scaling, billing |
| Module 10 | Design distributed rate limiter — algorithm choice, Redis implementation, multi-level |

## Key Resources
- **System Design Interview Vol. 1 & 2** - Alex Xu
- **Designing Data-Intensive Applications** - Martin Kleppmann
- **ByteByteGo** (bytebytego.com)
- Engineering blogs: Netflix, Uber, Airbnb, Stripe, Discord, Slack, Instagram, Twitter
- "Scaling Instagram Infrastructure" - Instagram engineering
- "How Stripe Builds APIs" - Stripe engineering blog
