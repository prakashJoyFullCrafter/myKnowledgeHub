# Redis

In-memory data store — mastery-level curriculum covering caching, messaging, distributed primitives, internals, and operations.

## Sections

### Foundations
1. **Data Structures** — Strings, Lists, Sets, Sorted Sets, Hashes, Bitmaps, HyperLogLog, Streams, Geospatial, TTL, choosing the right type (11 modules)
2. **Caching Patterns** — Cache-aside, read/write-through, write-behind, write-around, eviction, stampede, invalidation, warming, multi-level (13 modules)
3. **Pub/Sub** — Publish/subscribe model, pattern subscriptions, delivery guarantees, sharded pub/sub, vs Streams, Spring integration (10 modules)
4. **Session Store** — Distributed sessions, Spring Session with Redis, serialization, expiration, security, multi-tenant (10 modules)
5. **Lua Scripting** — EVAL/EVALSHA, Lua syntax, redis.call, rate limiting, distributed locks, Redis Functions (11 modules)

### Production
6. **Persistence** — RDB snapshots, AOF, combined mode, fsync policies (3 modules)
7. **Cluster & Sentinel** — Sentinel HA, replication, Redis Cluster, hash slots, decision guide (4 modules)
8. **Spring Data Redis** — RedisTemplate, Operations API, @RedisHash, cache integration, distributed patterns (5 modules)

### Mastery Deep Dives
9. **Internals & Architecture** — Single-threaded model, event loop, I/O threads (6+), redisObject, encodings (int/embstr/raw, listpack, quicklist, intset, skiplist), dict progressive rehash, persistence internals, replication internals (11 modules)
10. **Memory Optimization** — Per-key overhead, encoding thresholds, hash packing (10x savings), big keys, MEMORY commands, fragmentation, jemalloc, maxmemory + eviction, compression (11 modules)
11. **Performance & Latency** — Pipelining, MULTI/EXEC transactions, WATCH optimistic locking, command complexity, SCAN, slow log, LATENCY framework, big/hot keys, DEL vs UNLINK, connection pooling (11 modules)
12. **Security Deep Dive** — Threat model, protected mode, AUTH, ACL (Redis 6+), TLS, mTLS, command renaming, CONFIG SET attack, running as non-root, input validation, audit, hardening checklist (12 modules)
13. **Distributed Patterns** — Simple distributed locks, correctness problems, fencing tokens, Redlock, Redisson, rate limiting (fixed/sliding window/token bucket), leader election, pub/sub coordination (11 modules)
14. **Advanced Features & Modules** — Streams deep dive (XACK/XPENDING/XAUTOCLAIM), RESP3, client-side caching, RedisJSON, RediSearch (full-text/vector), RedisTimeSeries, RedisBloom, Redis Stack, RedisInsight, client library ecosystem (10 modules)
15. **Operations & Troubleshooting** — INFO command, key metrics, monitoring tools, alerting, common production issues, capacity planning, scaling strategies, backup/restore, upgrades, runbooks, production checklist (11 modules)
