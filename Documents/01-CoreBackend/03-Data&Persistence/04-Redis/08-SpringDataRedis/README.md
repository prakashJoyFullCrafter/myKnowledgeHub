# Spring Data Redis - Curriculum

## Module 1: Setup & RedisTemplate
- [ ] `spring-boot-starter-data-redis` dependency
- [ ] Auto-configuration: `spring.redis.host`, `spring.redis.port`, `spring.redis.password`
- [ ] **Lettuce** (default) vs **Jedis**: Lettuce is non-blocking (Netty), Jedis is blocking
- [ ] `RedisTemplate<K, V>` — generic operations on any key/value types
- [ ] `StringRedisTemplate` — convenience for `String` key/value (most common)
- [ ] Serializers: `JdkSerializationRedisSerializer` (default, ugly keys), `StringRedisSerializer`, `Jackson2JsonRedisSerializer`, `GenericJackson2JsonRedisSerializer`
- [ ] **Best practice**: configure JSON serializer for human-readable keys and values

## Module 2: Operations API
- [ ] `opsForValue()` — String operations: `set()`, `get()`, `increment()`, `setIfAbsent()`
- [ ] `opsForList()` — List operations: `leftPush()`, `rightPop()`, `range()`
- [ ] `opsForSet()` — Set operations: `add()`, `members()`, `intersect()`, `union()`
- [ ] `opsForZSet()` — Sorted Set: `add(value, score)`, `rangeByScore()`, `rank()`
- [ ] `opsForHash()` — Hash operations: `put()`, `get()`, `entries()`, `increment()`
- [ ] `expire(key, duration)` — set TTL
- [ ] `delete(key)` — remove key
- [ ] `hasKey(key)` — check existence
- [ ] Pipeline: `executePipelined()` — batch multiple commands in one round-trip

## Module 3: @RedisHash Repositories
- [ ] `@RedisHash("users")` — map object to Redis hash
- [ ] `@Id` — unique identifier
- [ ] `@Indexed` — create secondary index for findBy queries
- [ ] `@TimeToLive` — per-entity TTL
- [ ] `CrudRepository<User, String>` — standard Spring Data repository
- [ ] Derived queries: `findByEmail(String email)` (requires `@Indexed`)
- [ ] Limitations: no complex queries, no joins, no sorting (use for simple key-value objects)
- [ ] When to use: session-like objects, configuration, simple entities with TTL

## Module 4: Redis Cache Integration
- [ ] `@EnableCaching` + `RedisCacheManager`
- [ ] `@Cacheable(value = "users", key = "#id")` — cache method results in Redis
- [ ] `@CacheEvict`, `@CachePut` — invalidate and update
- [ ] Cache configuration: TTL per cache name, serialization, key prefix
- [ ] `RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofMinutes(30))`
- [ ] Multiple cache managers: Caffeine (L1) + Redis (L2)
- [ ] Cache key design: `service:entity:id` convention for readable keys

## Module 5: Advanced Patterns
- [ ] **Distributed locking**: `setIfAbsent(key, value, timeout)` — simple lock
  - [ ] **Redisson**: `RLock` — production-grade distributed lock with auto-renewal
  - [ ] **Redlock algorithm**: lock across multiple independent Redis masters
- [ ] **Rate limiting with Redis**: `INCR` + `EXPIRE` for counter, Lua script for atomicity
- [ ] **Reactive Redis**: `ReactiveRedisTemplate` with Lettuce for WebFlux apps
- [ ] **Redis Streams with Spring**: `StreamListener`, `StreamMessageListenerContainer`
- [ ] **Connection pool tuning**: `spring.redis.lettuce.pool.max-active`, `max-idle`, `min-idle`
- [ ] Monitoring: Redis `INFO` command, `SLOWLOG`, Spring Boot Actuator Redis health indicator

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Configure RedisTemplate with JSON serializer, verify readable keys in redis-cli |
| Module 2 | Build a leaderboard with Sorted Sets using `opsForZSet()` |
| Module 3 | Build a session-like entity with `@RedisHash`, `@Indexed`, `@TimeToLive` |
| Module 4 | Add Redis caching to a REST API, configure per-cache TTL, monitor hit/miss |
| Module 5 | Implement distributed lock with Redisson, rate limiter with INCR+EXPIRE |

## Key Resources
- Spring Data Redis Reference Documentation
- Lettuce documentation (lettuce.io)
- Redisson documentation (redisson.org)
- "Redis Best Practices" — redis.io
