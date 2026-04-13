# Redis Caching Patterns - Curriculum

## Module 1: Why Cache? Fundamentals
- [ ] **Cache**: fast, in-memory storage to reduce load on slow data sources
- [ ] **Benefits**: lower latency, reduced DB load, higher throughput
- [ ] **Costs**: staleness, complexity, memory, consistency challenges
- [ ] **Cache hit** vs **cache miss** — hit ratio is the key metric
- [ ] **What to cache**: hot data, expensive queries, computed results, external API responses
- [ ] **What NOT to cache**: rarely accessed data, frequently changing data (low hit ratio), security-critical data
- [ ] **Cost of a cache miss**: 10-100x more expensive than a hit — minimize misses

## Module 2: Cache-Aside (Lazy Loading)
- [ ] **Pattern** (most common):
  1. [ ] Read: check cache → hit? return. miss? read DB → populate cache → return
  2. [ ] Write: write DB → invalidate cache (or update cache)
- [ ] **Pros**: cache holds only requested data, robust to cache outage
- [ ] **Cons**: first read is slow (cache miss), possible stale data window
- [ ] **Best for**: read-heavy workloads, data that may or may not be cached
- [ ] **Spring**: `@Cacheable` implements this pattern
- [ ] **Risk**: cache miss storm on cold cache — use cache warming

## Module 3: Read-Through
- [ ] **Pattern**: application treats cache as the data source; cache loads from DB on miss
- [ ] **Who implements the DB loading**: the cache layer (library or abstraction), not app code
- [ ] **Pros**: simpler app code (no miss handling)
- [ ] **Cons**: requires cache layer that integrates with DB, less control
- [ ] **Difference from cache-aside**: app doesn't know about DB — cache handles it
- [ ] **Redis use**: typically implemented in a wrapping library (e.g., Spring's `CacheManager`)

## Module 4: Write-Through
- [ ] **Pattern**: write to cache AND DB synchronously in one operation
- [ ] **Flow**:
  1. [ ] App writes to cache
  2. [ ] Cache layer writes to DB
  3. [ ] Both confirm before returning
- [ ] **Pros**: cache always consistent with DB
- [ ] **Cons**: slower writes (double write), cache populated with data that may never be read
- [ ] **Best combined with read-through**: read-through + write-through = "caching as DB access layer"

## Module 5: Write-Behind (Write-Back)
- [ ] **Pattern**: write to cache, async flush to DB later
- [ ] **Pros**: fastest writes (no DB wait), batching reduces DB load
- [ ] **Cons**: data loss risk if cache crashes before flush
- [ ] **Use cases**: high write throughput, can tolerate small data loss
- [ ] **Not recommended for Redis as cache**: Redis typically can't be source of truth for important data
- [ ] **Exception**: Redis with AOF + replication CAN be used as primary, then write-behind to cold storage

## Module 6: Write-Around
- [ ] **Pattern**: write directly to DB, skip cache entirely; cache is populated only on read
- [ ] **Pros**: avoids caching data that's written but never read
- [ ] **Cons**: recent writes are slow to read (cache miss)
- [ ] **Best for**: write-heavy with rare re-reads (log entries, audit data)
- [ ] **Combined with cache-aside read**: only hot data ends up in cache

## Module 7: Cache Eviction Policies
- [ ] **Eviction**: removing data when cache is full
- [ ] **Redis `maxmemory-policy` options**:
  - [ ] `noeviction`: return errors when memory full (no cache behavior)
  - [ ] `allkeys-lru`: evict least recently used (any key)
  - [ ] `volatile-lru`: LRU among keys with TTL
  - [ ] `allkeys-lfu`: least frequently used (better for skewed access)
  - [ ] `volatile-lfu`: LFU among keys with TTL
  - [ ] `allkeys-random`, `volatile-random`
  - [ ] `volatile-ttl`: evict shortest TTL first
- [ ] **LRU vs LFU**:
  - [ ] LRU: optimizes for recency (time-based locality)
  - [ ] LFU: optimizes for frequency (popular items stay)
- [ ] **Default**: `noeviction` — MUST be changed if Redis used as cache
- [ ] **Recommendation**: `allkeys-lru` for general caching, `allkeys-lfu` for skewed workloads

## Module 8: Cache Stampede / Thundering Herd
- [ ] **Problem**: popular cached item expires → many requests simultaneously hit DB to regenerate
- [ ] **Symptoms**: spike in DB load when popular cache expires, high latency, cascading failure
- [ ] **Solution 1: Locking** — only one request regenerates, others wait
  - [ ] `SET lock NX EX 30` → only one process gets lock
  - [ ] Others wait and retry (or return stale)
- [ ] **Solution 2: Probabilistic early expiry** — refresh before TTL
  - [ ] XFetch algorithm: probabilistically refresh cache before expiry
  - [ ] Spread regeneration load over time
- [ ] **Solution 3: Stale-while-revalidate** — serve stale, refresh async
  - [ ] Lower latency, tolerates slight staleness
- [ ] **Solution 4: Refresh-ahead** — proactively refresh hot keys before expiry
- [ ] **Anti-pattern**: same TTL for all entries → synchronized expiration waves
  - [ ] Fix: add jitter to TTL

## Module 9: Cache Invalidation Strategies
- [ ] "There are only two hard things in CS: cache invalidation and naming things" — Phil Karlton
- [ ] **TTL-based**: simple, but tolerate staleness within TTL window
- [ ] **Event-based**: invalidate on specific events
  - [ ] DB trigger → publish event → invalidate cache
  - [ ] App code: write DB → invalidate cache (race condition prone!)
- [ ] **CDC-based**: stream DB changes (Debezium) → cache invalidation
- [ ] **Version-based**: include version in cache key (`user:v2:123`)
- [ ] **Cache tags**: invalidate all keys sharing a tag (Redis with Lua or external tracker)
- [ ] **Write-through**: write to cache too, so cache is always fresh
- [ ] **Race condition**: read DB → write cache (old value) AND concurrent update DB → cache now stale
  - [ ] Solutions: WATCH/MULTI, write-through, delete-on-write instead of update

## Module 10: Cache Warming
- [ ] **Cold cache problem**: fresh cache has 0% hit ratio → all traffic to DB
- [ ] **Warming strategies**:
  - [ ] **Pre-population**: load hot keys before traffic starts (deployment time)
  - [ ] **Replay**: after cache flush, replay recent requests
  - [ ] **Gradual**: allow warm-up during first few minutes (traffic ramp)
- [ ] **Tools**:
  - [ ] Script that iterates hot keys and populates cache
  - [ ] Shadow traffic: route copy of production traffic to warm new cache
- [ ] **When to warm**:
  - [ ] After cache flush or restart
  - [ ] Blue/green deployment with new cache
  - [ ] Cache failover to new instance
- [ ] **Trade-off**: warming cost vs cold-start pain

## Module 11: Multi-Level Caching
- [ ] **L1 (in-process, Caffeine/Guava)**:
  - [ ] Microsecond latency
  - [ ] Limited size per instance
  - [ ] Per-instance (not shared)
- [ ] **L2 (Redis)**:
  - [ ] Millisecond latency
  - [ ] Large shared cache
  - [ ] Cross-instance consistency
- [ ] **L3 (CDN)**: for HTTP responses
- [ ] **Flow**: check L1 → miss → check L2 → miss → check DB → populate both
- [ ] **Invalidation challenge**: invalidating L1 across instances requires pub/sub
- [ ] **Best practice**: short TTL on L1 (seconds), longer TTL on L2 (minutes)
- [ ] **Spring**: compose `CompositeCacheManager` with Caffeine + Redis

## Module 12: Redis as Distributed Cache
- [ ] **Shared state**: all app instances see the same cache
- [ ] **Consistency**: all instances invalidate consistently (single source of truth)
- [ ] **Pub/Sub for invalidation**: publish invalidation events, subscribers drop L1 copies
- [ ] **Redis 6+ client-side caching**: automatic invalidation via RESP3 tracking
- [ ] **HA**: Sentinel or Cluster for failover
- [ ] **Sharding**: Cluster for large caches
- [ ] **Monitoring**: hit ratio, memory usage, eviction rate, latency

## Module 13: Anti-Patterns
- [ ] **Caching without TTL**: grows forever until OOM
- [ ] **Same TTL for all keys**: synchronized expiration → thundering herd
- [ ] **Cache never warmed**: cold cache kills DB
- [ ] **Cache without monitoring**: no visibility into hit ratio or eviction
- [ ] **Caching mutable data without invalidation**: stale reads forever
- [ ] **Caching sensitive data**: security risk (PII in cache memory)
- [ ] **Over-caching**: caching everything → complex, low hit ratio
- [ ] **Cache as primary store**: expecting Redis to never lose data without persistence

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement cache-aside for a REST API, measure hit ratio |
| Modules 3-6 | Compare cache patterns for different workloads |
| Module 7 | Benchmark `allkeys-lru` vs `allkeys-lfu` with skewed access |
| Module 8 | Reproduce thundering herd, implement locking solution |
| Module 9 | Implement event-based invalidation with Redis Pub/Sub |
| Module 10 | Build cache warming script for hot keys |
| Module 11 | Implement multi-level cache (Caffeine + Redis) in Spring Boot |
| Module 12 | Monitor cache metrics in production |
| Module 13 | Audit a caching config for anti-patterns |

## Key Resources
- "Caching at Netflix: The Hidden Microservice" — Netflix blog
- redis.io/docs/manual/client-side-caching/
- Spring Cache Abstraction docs
- "Designing Data-Intensive Applications" — Chapter 6 (caching section)
