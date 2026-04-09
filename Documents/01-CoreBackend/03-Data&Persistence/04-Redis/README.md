# Redis

In-memory data store for caching, sessions, and messaging.

## Core
1. **Data Structures** - Strings, lists, sets, sorted sets, hashes, streams, expiration
2. **Caching Patterns** - Cache-aside, write-through, eviction, stampede, invalidation
3. **Pub/Sub** - Real-time messaging, pattern subscriptions, vs Streams
4. **Session Store** - Distributed sessions with Spring, serialization, clustering
5. **Lua Scripting** - Atomic operations, rate limiting, distributed locks

## Production
6. **Persistence** - RDB snapshots, AOF append-only, RDB+AOF combined, fsync policies (3 modules)
7. **Cluster & Sentinel** - High availability, replication, sharding, hash slots, failover (4 modules)
8. **Spring Data Redis** - RedisTemplate, operations API, @RedisHash, caching, distributed locks (5 modules)
