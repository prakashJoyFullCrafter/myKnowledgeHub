# Caching (System-Level) - Curriculum

## Module 1: Caching Fundamentals
- [ ] Why cache? Reduce latency, reduce database/API load, improve throughput
- [ ] **Cache hit** vs **cache miss** vs **cache hit ratio**
- [ ] What to cache: database queries, API responses, computed results, session data, static assets
- [ ] What NOT to cache: frequently changing data, security-sensitive data, write-heavy data
- [ ] Cache locality: temporal (recently accessed) and spatial (nearby data)
- [ ] Cost of caching: memory, staleness, complexity, consistency

## Module 2: Caching Strategies (Read Patterns)
- [ ] **Cache-Aside (Lazy Loading)**: app checks cache → miss → read DB → write to cache
  - [ ] Most common pattern, app controls caching logic
  - [ ] Risk: cache miss storm on cold start
- [ ] **Read-Through**: cache itself fetches from DB on miss (cache is the data source)
  - [ ] Simpler app code, cache handles fetching
- [ ] **Refresh-Ahead**: proactively refresh cache before TTL expires
  - [ ] Reduces cache miss latency for hot keys
  - [ ] Risk: wasted refreshes for cold keys

## Module 3: Caching Strategies (Write Patterns)
- [ ] **Write-Through**: write to cache AND DB synchronously
  - [ ] Strong consistency, but slower writes (two writes per operation)
- [ ] **Write-Behind (Write-Back)**: write to cache, async flush to DB
  - [ ] Fast writes, but risk of data loss if cache crashes before flush
- [ ] **Write-Around**: write directly to DB, invalidate or skip cache
  - [ ] Good when writes rarely read back immediately

## Module 4: Cache Eviction Policies
- [ ] **LRU (Least Recently Used)**: evict least recently accessed — most common
- [ ] **LFU (Least Frequently Used)**: evict least frequently accessed — good for skewed access
- [ ] **FIFO (First In, First Out)**: evict oldest entry
- [ ] **TTL (Time to Live)**: expire after fixed duration
- [ ] **Random**: surprisingly effective, zero overhead
- [ ] **W-TinyLFU** (Caffeine): combines LRU + LFU, state-of-the-art for in-process caching

## Module 5: Distributed Caching
- [ ] **In-process cache** (Caffeine, Guava): fastest, but per-instance, not shared
- [ ] **Distributed cache** (Redis, Memcached): shared across instances, network hop cost
- [ ] **Multi-level caching**: L1 (in-process) + L2 (distributed) — best of both
- [ ] **Redis**: rich data structures, persistence, pub-sub, Lua scripting
- [ ] **Memcached**: simpler, multi-threaded, pure key-value
- [ ] Redis vs Memcached: Redis (features) vs Memcached (simplicity, multi-threaded)
- [ ] **Cache cluster**: Redis Cluster, consistent hashing for key distribution
- [ ] **Cache replication**: Redis Sentinel for HA, replica reads

## Module 6: Cache Invalidation & Consistency
- [ ] "There are only two hard things in CS: cache invalidation and naming things"
- [ ] **TTL-based**: simple, but stale data during TTL window
- [ ] **Event-based**: invalidate on write events (DB trigger, app event, CDC)
- [ ] **Version-based**: include version in cache key, increment on change
- [ ] **Cache stampede** (thundering herd): many threads fetch same key on miss simultaneously
  - [ ] Solutions: locking (only one fetches), probabilistic early expiry, `sync=true`
- [ ] **Dogpile effect**: expired key causes burst of DB queries
- [ ] **Stale-while-revalidate**: serve stale, refresh in background

## Module 7: Caching in Architecture
- [ ] **Browser cache** → **CDN cache** → **API Gateway cache** → **Application cache** → **Database cache**
- [ ] HTTP caching: `Cache-Control`, `ETag`, `Last-Modified`, `304 Not Modified`
- [ ] Database query cache (MySQL query cache — deprecated, PostgreSQL materialized views)
- [ ] Connection pool as a form of caching
- [ ] Cache warming: pre-populate on deployment or startup
- [ ] Monitoring: hit ratio, miss ratio, eviction rate, memory usage, latency

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Implement cache-aside + write-through for a user profile service |
| Module 4 | Benchmark LRU vs LFU eviction on a skewed access pattern |
| Module 5 | Set up Redis as distributed cache, Caffeine as L1, measure hit ratio |
| Module 6 | Simulate cache stampede, implement locking solution |
| Module 7 | Design full caching strategy for an e-commerce product catalog |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann
- Redis documentation (redis.io)
- Caffeine GitHub (ben-manes/caffeine)
- "Scaling Memcache at Facebook" (paper)
- System Design Interview - Alex Xu
