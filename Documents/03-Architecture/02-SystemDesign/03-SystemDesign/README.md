# System Design Concepts

Distributed system fundamentals for large-scale applications.

## Infrastructure Fundamentals
1. **CAP Theorem** - Consistency, Availability, Partition Tolerance, PACELC, consistency models (4 modules)
2. **Load Balancing** - L4/L7, algorithms, health checks, tools, Kubernetes (5 modules)
3. **Sharding** - Strategies, shard key selection, challenges, tools (5 modules)
4. **CDN** - Push/pull, cache control, invalidation, edge computing (5 modules)
5. **Consistent Hashing** - Hash ring, virtual nodes, alternatives, real-world usage (5 modules)

## System Building Blocks
6. **Caching** - Strategies (read/write), eviction, distributed cache, invalidation (7 modules)
7. **Database Replication** - Topologies, sync/async, replication lag, failover (6 modules)
8. **SQL vs NoSQL** - Relational, document, column, graph, time-series, decision framework (5 modules)
9. **Message Queues** - Pub-sub, delivery semantics, ordering, backpressure, technology comparison (6 modules)
10. **Proxies & Reverse Proxies** - Forward, reverse, API gateway, tools, sidecar pattern (5 modules)
11. **Communication Protocols** - HTTP versions, polling/SSE/WebSocket, REST/GraphQL/gRPC, serialization (5 modules)
12. **Blob / Object Storage** - S3 patterns, pre-signed URLs, multipart, architecture patterns (5 modules)
13. **Distributed ID Generation** - UUID, Snowflake, database-based, decision guide (5 modules)

## Reliability, Security & Operations
16. **Reliability & Resilience** - Failure modes, timeouts/retries/backoff, circuit breakers, bulkheads, graceful degradation, failover, DR, chaos engineering (7 modules)
17. **Observability & Operations** - Three pillars (metrics/logs/traces), SLI/SLO/SLA, alerting, dashboards, debugging distributed systems, incident response, capacity planning (7 modules)
18. **Security in System Design** - AuthN/AuthZ architecture, OAuth/OIDC, encryption (TLS/mTLS/at-rest), secrets management, rate limiting/abuse, multi-tenant isolation, audit/compliance (7 modules)

## Data & Processing Internals
19. **Distributed Transactions & Correctness** - 2PC, saga (architecture view), idempotency end-to-end, exactly-once myths, deduplication, reconciliation, escrow/ledger patterns (7 modules)
20. **Data Internals** - B-tree, LSM tree, compaction, inverted indexes, MVCC, WAL, query planning, consensus (Raft/Paxos), hot partitions (8 modules)
21. **Stream Processing & Real-Time** - Stream vs batch vs queue, event time vs processing time, windowing, watermarks, exactly-once in streams, CDC pipelines, consumer lag/backpressure (7 modules)

## Advanced Design Topics
22. **Search & Ranking Systems** - Inverted index deep dive, ranking/relevance (BM25, LTR), autocomplete/typeahead, vector search, hybrid retrieval, search infrastructure at scale (6 modules)
23. **Platform & Deployment** - Containers/K8s in design, service discovery, config management, deployment strategies, autoscaling, IaC/GitOps, CI/CD (7 modules)
24. **Domain-Specific Design Patterns** - Feeds/timelines, chat/presence, payments/ledger, booking/reservations, notifications, recommendations, analytics, file storage/sync, multi-tenant SaaS, rate limiting (10 modules)
25. **Multi-Region & Geo-Distribution** - Active-active vs active-passive, data replication across regions, global traffic management, leader placement, cross-region consistency, cost/latency/consistency trade-offs (7 modules)

## Interview & Practice
14. **Back-of-the-Envelope Estimation** - QPS, storage, bandwidth, memory, framework (6 modules)
15. **System Design Interview Framework** - 4-step process, requirements, design, deep dive, 15 classic problems (7 modules)
