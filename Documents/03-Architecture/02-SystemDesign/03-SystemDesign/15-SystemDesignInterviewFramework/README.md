# System Design Interview Framework - Curriculum

A structured approach for tackling any system design problem.

---

## Module 1: The 4-Step Framework
- [ ] **Step 1: Requirements Clarification** (3-5 minutes)
- [ ] **Step 2: Back-of-the-Envelope Estimation** (3-5 minutes)
- [ ] **Step 3: High-Level Design** (10-15 minutes)
- [ ] **Step 4: Deep Dive** (15-20 minutes)
- [ ] Total: ~45 minutes for a typical system design interview
- [ ] Golden rule: drive the conversation, don't wait for interviewer to ask

## Module 2: Step 1 — Requirements Clarification
- [ ] **Functional requirements**: what does the system DO?
  - [ ] Core features only (3-5 max) — don't design everything
  - [ ] Example (URL shortener): create short URL, redirect to original, analytics
- [ ] **Non-functional requirements (NFRs)**: quality attributes
  - [ ] Scale: DAU, MAU, peak traffic
  - [ ] Latency: p99 < X ms?
  - [ ] Availability: 99.9%? 99.99%?
  - [ ] Consistency: strong vs eventual — which operations need what?
  - [ ] Durability: can we lose data? (zero tolerance for payments, acceptable for metrics)
- [ ] **Constraints & assumptions**:
  - [ ] Read:write ratio
  - [ ] Average size of data objects
  - [ ] Global or single-region?
  - [ ] Budget/cost sensitivity?

## Module 3: Step 2 — Estimation
- [ ] Estimate QPS (read + write), storage (5 years), bandwidth, cache needs
- [ ] This determines whether you need sharding, caching, CDN, etc.
- [ ] Don't spend too long — 2-3 key numbers are enough
- [ ] Signals to interviewer: you think about scale before designing

## Module 4: Step 3 — High-Level Design
- [ ] Draw the big picture: clients → load balancer → services → databases → caches
- [ ] Identify core components:
  - [ ] **API design**: define key endpoints (REST/gRPC), request/response format
  - [ ] **Data model**: key entities, relationships, which database type
  - [ ] **Service architecture**: monolith vs microservices, which services
- [ ] Walk through the main flow end-to-end (e.g., "user creates a short URL → stores in DB → returns")
- [ ] Get buy-in from interviewer before going deeper

## Module 5: Step 4 — Deep Dive
- [ ] Interviewer will guide OR you propose: "I'd like to dive into [X], it's the most interesting part"
- [ ] Common deep dive areas:
  - [ ] **Database design**: schema, indexing, sharding strategy, replication
  - [ ] **Caching layer**: what to cache, eviction, invalidation, cache-aside vs read-through
  - [ ] **Scaling**: how to handle 10x, 100x traffic growth
  - [ ] **Reliability**: single points of failure, failover, data redundancy
  - [ ] **Consistency**: how to handle conflicts, eventual vs strong, conflict resolution
  - [ ] **Rate limiting**: protect system from abuse
  - [ ] **Monitoring**: key metrics, alerting, dashboards
- [ ] Trade-offs: always discuss pros/cons of your choices — there's no perfect design

## Module 6: Common Mistakes
- [ ] Jumping into solution without clarifying requirements
- [ ] Designing too many features (focus on core 3-5)
- [ ] Ignoring scale — treating it like a CRUD app
- [ ] Not discussing trade-offs — every choice has downsides
- [ ] Over-engineering: adding Kafka/microservices/sharding when not needed
- [ ] Monologue: not checking in with interviewer
- [ ] Ignoring failure modes: what happens when X goes down?

## Module 7: Classic Design Problems (Practice List)
- [ ] **URL Shortener** (TinyURL): hashing, base62, database, redirection, analytics
- [ ] **Rate Limiter**: token bucket, sliding window, distributed rate limiting
- [ ] **Chat System** (WhatsApp): WebSocket, message storage, delivery status, group chat
- [ ] **Notification System**: push/SMS/email, priority, template, rate limiting, delivery tracking
- [ ] **News Feed** (Twitter/Facebook): fan-out on write vs fan-out on read, ranking, caching
- [ ] **Search Autocomplete**: trie, prefix matching, top-K, caching
- [ ] **Distributed Cache** (Redis): consistent hashing, eviction, replication, persistence
- [ ] **Web Crawler**: BFS, URL frontier, politeness, deduplication, distributed crawling
- [ ] **Unique ID Generator**: Snowflake, UUID v7, ticket server
- [ ] **Payment System**: idempotency, double-entry ledger, reconciliation, PCI compliance
- [ ] **Video Streaming** (YouTube): upload pipeline, transcoding, adaptive bitrate, CDN
- [ ] **File Storage** (Dropbox): chunking, deduplication, sync protocol, conflict resolution
- [ ] **Proximity Service** (Yelp/Uber): geohash, quadtree, geospatial indexing
- [ ] **Key-Value Store**: partitioning, replication, consistency, conflict resolution (Dynamo paper)
- [ ] **Metrics Monitoring** (Datadog): time-series DB, aggregation, alerting, dashboards

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-5 | Practice one design problem per day using the 4-step framework |
| Module 6 | Record yourself, review for common mistakes |
| Module 7 | Work through all 15 classic problems (2-3 per week) |

## Key Resources
- **System Design Interview Vol. 1 & 2** - Alex Xu (the best structured resource)
- **Designing Data-Intensive Applications** - Martin Kleppmann (the theory bible)
- **ByteByteGo** (bytebytego.com) - Alex Xu's visual system design platform
- **Grokking the System Design Interview** - Educative.io
- **System Design Primer** - GitHub (donnemartin/system-design-primer)
- **Engineering blogs**: Meta, Netflix, Uber, Airbnb, Stripe, Discord, Slack
