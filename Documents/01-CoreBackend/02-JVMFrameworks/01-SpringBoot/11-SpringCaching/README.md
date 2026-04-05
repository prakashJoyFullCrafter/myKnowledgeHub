# Spring Caching - Curriculum

## Module 1: Cache Abstraction
- [ ] `@EnableCaching` to activate caching
- [ ] `@Cacheable` - cache method results
- [ ] `@CacheEvict` - remove entries from cache
- [ ] `@CachePut` - update cache without skipping method execution
- [ ] `@Caching` - combine multiple cache operations
- [ ] Cache key generation: default, SpEL-based, custom `KeyGenerator`
- [ ] Conditional caching: `condition` and `unless` attributes

## Module 2: Cache Providers
- [ ] ConcurrentMapCacheManager (default, in-memory, dev only)
- [ ] Caffeine: high-performance in-memory cache
  - [ ] `maximumSize`, `expireAfterWrite`, `expireAfterAccess`
  - [ ] Cache statistics and monitoring
- [ ] Redis: distributed cache
  - [ ] `RedisCacheManager` configuration
  - [ ] TTL per cache name
  - [ ] Serialization: JSON vs JDK
- [ ] EhCache 3: on-heap, off-heap, disk
- [ ] Hazelcast: distributed in-memory

## Module 3: Cache Patterns & Strategies
- [ ] Cache-Aside (Lazy Loading) with `@Cacheable`
- [ ] Write-Through with `@CachePut`
- [ ] Cache warming on startup
- [ ] TTL-based vs event-based invalidation
- [ ] Cache stampede prevention (`sync = true`)
- [ ] Multi-level caching: L1 (Caffeine local) + L2 (Redis distributed)

## Module 4: Advanced Caching
- [ ] Custom `CacheManager` with multiple cache configurations
- [ ] Cache per service / per entity TTL
- [ ] Cache metrics with Micrometer (hit rate, miss rate, evictions)
- [ ] Cache in microservices: local vs distributed decision
- [ ] Cache versioning for deployment safety
- [ ] Testing cached methods: verify caching behavior

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Add caching to a REST API service layer |
| Module 2 | Configure Caffeine for local + Redis for distributed |
| Module 3 | Implement cache warming and invalidation strategy |
| Module 4 | Monitor cache hit/miss rates with Grafana |

## Key Resources
- Spring Cache Abstraction Reference
- Caffeine documentation
- Spring Data Redis Reference
