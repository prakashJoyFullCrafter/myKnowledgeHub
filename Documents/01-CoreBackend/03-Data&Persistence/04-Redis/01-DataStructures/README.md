# Redis Data Structures - Curriculum

## Module 1: Strings
- [ ] **String**: binary-safe, up to 512 MB
- [ ] **Basic commands**: `SET`, `GET`, `DEL`, `EXISTS`, `STRLEN`
- [ ] **Atomic counters**: `INCR`, `DECR`, `INCRBY`, `DECRBY`, `INCRBYFLOAT`
  - [ ] Use case: page view counters, rate limiting counters
- [ ] **Batch operations**: `MSET`, `MGET` (multi-get in one round-trip)
- [ ] **Conditional set**: `SETNX` (set if not exists), `SETEX` (set with expiry)
- [ ] **Modern alternatives**:
  - [ ] `SET key value NX EX 60` — atomic: set if not exists with 60s TTL
  - [ ] `SET key value XX` — only set if exists
- [ ] **Sub-strings**: `GETRANGE`, `SETRANGE`, `APPEND`
- [ ] **Underlying encoding**: `int`, `embstr` (≤44 bytes), `raw` (larger)
- [ ] **Use cases**: cache values, counters, simple flags, session tokens

## Module 2: Lists
- [ ] **List**: linked list of strings, ordered, duplicates allowed
- [ ] **Push/pop**:
  - [ ] `LPUSH key val` — push to head (left)
  - [ ] `RPUSH key val` — push to tail (right)
  - [ ] `LPOP`, `RPOP` — pop from head/tail
- [ ] **Range/inspect**:
  - [ ] `LRANGE key 0 -1` — get all elements
  - [ ] `LINDEX key i`, `LLEN key`, `LREM key count value`
- [ ] **Blocking operations**:
  - [ ] `BLPOP`, `BRPOP` — block until element available (simple queue)
  - [ ] Use case: work queue with multiple consumers
- [ ] **Move between lists**: `LMOVE source dest LEFT RIGHT` (reliable queue pattern)
- [ ] **Trim**: `LTRIM key start stop` — keep only a range (fixed-size recent items)
- [ ] **Encoding**: `listpack` (small) → `quicklist` (large, linked list of listpacks)
- [ ] **Use cases**: task queues, recent activity feeds, logs, timelines

## Module 3: Sets
- [ ] **Set**: unordered collection of unique strings
- [ ] **Add/remove**: `SADD`, `SREM`, `SISMEMBER`, `SCARD` (count), `SMEMBERS`
- [ ] **Random access**: `SRANDMEMBER`, `SPOP` (remove and return random)
- [ ] **Set operations**:
  - [ ] `SUNION` — union
  - [ ] `SINTER` — intersection
  - [ ] `SDIFF` — difference
  - [ ] `SUNIONSTORE`, `SINTERSTORE`, `SDIFFSTORE` — store result
- [ ] **Use cases**:
  - [ ] Unique tags, permissions, roles
  - [ ] "Users who liked post X" (intersect with "users who liked post Y")
  - [ ] Distinct visitors
- [ ] **Encoding**: `intset` (all integers, small) → `listpack` → `hashtable`

## Module 4: Sorted Sets (ZSet)
- [ ] **Sorted set**: set of unique strings ordered by a floating-point score
- [ ] **Add/update**: `ZADD key score member`
  - [ ] Options: `NX` (only add new), `XX` (only update), `GT`/`LT` (only if greater/less)
  - [ ] `CH` (return changed count), `INCR` (increment score)
- [ ] **Range queries**:
  - [ ] `ZRANGE key start stop [WITHSCORES]` — by index
  - [ ] `ZRANGE key min max BYSCORE` — by score
  - [ ] `ZRANGE key min max BYLEX` — by lexicographic order
  - [ ] `ZRANGESTORE` — store result in another key
- [ ] **Rank queries**: `ZRANK`, `ZREVRANK`, `ZSCORE`
- [ ] **Aggregate**: `ZUNIONSTORE`, `ZINTERSTORE` with WEIGHTS, AGGREGATE
- [ ] **Encoding**: `listpack` (small) → `skiplist` + `hashtable` (large)
- [ ] **Use cases**:
  - [ ] **Leaderboards** (top players by score)
  - [ ] Priority queues
  - [ ] Time-series (score = timestamp)
  - [ ] Rate limiting (sliding window)
  - [ ] Secondary index (score = indexed value)

## Module 5: Hashes
- [ ] **Hash**: map of field-value pairs (like object/dict)
- [ ] **Field operations**:
  - [ ] `HSET key field value` (single or multiple)
  - [ ] `HGET`, `HMGET`, `HGETALL`, `HKEYS`, `HVALS`
  - [ ] `HDEL`, `HEXISTS`, `HLEN`, `HSTRLEN`
- [ ] **Counters**: `HINCRBY`, `HINCRBYFLOAT` — atomic field increment
- [ ] **Conditional**: `HSETNX` — set field only if not exists
- [ ] **Iteration**: `HSCAN` — cursor-based iteration (non-blocking)
- [ ] **Encoding**: `listpack` (small) → `hashtable` (large)
- [ ] **Use cases**:
  - [ ] Object storage (user profile with fields)
  - [ ] Counters grouped by entity
  - [ ] Field-level TTL in Redis 7.4+ (`HEXPIRE`)
- [ ] **Hash vs String**: hash is more memory-efficient for structured objects

## Module 6: Bitmaps
- [ ] **Bitmap**: not a separate type — bit-level operations on strings
- [ ] **Commands**:
  - [ ] `SETBIT key offset value` — set individual bit (0 or 1)
  - [ ] `GETBIT key offset`
  - [ ] `BITCOUNT key [start end]` — count set bits
  - [ ] `BITPOS key bit` — find first 0 or 1
  - [ ] `BITOP AND/OR/XOR/NOT dest key1 [key2 ...]`
- [ ] **Bit fields**: `BITFIELD` — arbitrary bit-width fields
- [ ] **Memory efficient**: 1M users = 125 KB (1 bit per user)
- [ ] **Use cases**:
  - [ ] Daily active users (bit per user per day)
  - [ ] Feature flags per user
  - [ ] A/B test assignment
  - [ ] Presence detection (online users)
  - [ ] Real-time analytics

## Module 7: HyperLogLog
- [ ] **HyperLogLog**: probabilistic cardinality estimator
- [ ] Estimate count of unique items with ~12 KB for any size
- [ ] **Error rate**: ~0.81% standard error
- [ ] **Commands**:
  - [ ] `PFADD key element [element ...]`
  - [ ] `PFCOUNT key` — estimated cardinality
  - [ ] `PFMERGE dest key1 key2 ...` — union HLLs
- [ ] **Use cases**:
  - [ ] Unique visitor count
  - [ ] Unique search terms
  - [ ] Distinct IPs, emails, any countable unique thing
- [ ] **Trade-off**: approximation for massive memory savings vs `SET` (exact but unbounded)

## Module 8: Streams
- [ ] **Stream**: append-only log with consumer groups (like a mini Kafka)
- [ ] **Append**: `XADD stream * field value` (auto-generated ID)
- [ ] **Read**:
  - [ ] `XREAD` — simple read
  - [ ] `XRANGE` / `XREVRANGE` — range queries
  - [ ] `XLEN` — stream length
- [ ] **Consumer groups**:
  - [ ] `XGROUP CREATE stream groupname $`
  - [ ] `XREADGROUP GROUP groupname consumername STREAMS stream >`
  - [ ] `XACK` — acknowledge processed message
  - [ ] `XPENDING` — list unacked messages
  - [ ] `XAUTOCLAIM` — reclaim stuck messages from dead consumer
- [ ] **Retention**: `XADD stream MAXLEN ~1000 ...` — trim to approx length
- [ ] **Use cases**: event logs, audit trails, lightweight event streaming, job queues

## Module 9: Geospatial
- [ ] **Geo**: latitude/longitude indexing built on sorted sets
- [ ] **Commands**:
  - [ ] `GEOADD key lon lat member`
  - [ ] `GEOSEARCH` — search by radius or bounding box
  - [ ] `GEODIST key member1 member2 [m|km|mi]`
  - [ ] `GEOPOS key member` — coordinates
- [ ] **Internally**: uses sorted set with geohash scores
- [ ] **Use cases**: "find nearby restaurants", ride-sharing, delivery tracking
- [ ] **Limitation**: flat-earth calculations (small error over long distances)

## Module 10: Key Expiration & TTL
- [ ] **TTL commands**:
  - [ ] `EXPIRE key seconds` — set TTL
  - [ ] `PEXPIRE key milliseconds` — millisecond precision
  - [ ] `EXPIREAT`, `PEXPIREAT` — absolute expiry time
  - [ ] `TTL key`, `PTTL key` — remaining time
  - [ ] `PERSIST key` — remove TTL
- [ ] **Options** (Redis 7.0+): `NX`, `XX`, `GT`, `LT` for conditional expiry
- [ ] **Field-level TTL** (Redis 7.4+): `HEXPIRE`, `HPEXPIRE`
- [ ] **Expiration mechanics**:
  - [ ] **Passive**: expired keys removed when accessed
  - [ ] **Active**: periodic scan samples random keys, removes expired
  - [ ] Not deterministic — dead keys may linger briefly
- [ ] **Memory eviction vs expiration**:
  - [ ] TTL expiry: time-based removal
  - [ ] Eviction: memory-pressure removal (when maxmemory reached)

## Module 11: Choosing the Right Data Structure
- [ ] **Key-value lookup** → String
- [ ] **FIFO/LIFO queue** → List (with `LPUSH`/`RPOP`)
- [ ] **Pub/sub-like queue, replay** → Stream
- [ ] **Unique membership** → Set
- [ ] **Ranking / ordered by score** → Sorted Set
- [ ] **Object with fields** → Hash
- [ ] **Boolean per user at scale** → Bitmap
- [ ] **Unique count approximation** → HyperLogLog
- [ ] **Location-based queries** → Geo
- [ ] **Counters** → String with `INCR` (or Hash field with `HINCRBY`)
- [ ] **Leaderboard** → Sorted Set
- [ ] **Rate limiter** → String INCR + EXPIRE, or Sorted Set for sliding window

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a visit counter with `INCR`, add TTL for daily reset |
| Module 2 | Build a work queue with `LPUSH` + `BRPOP`, multiple workers |
| Module 3 | Track unique tags per post with Set, compute intersection of two posts |
| Module 4 | Build a game leaderboard with Sorted Set, query top 10 |
| Module 5 | Store user profiles as Hashes, compare memory vs JSON strings |
| Module 6 | Track daily active users with Bitmap, count with `BITCOUNT` |
| Module 7 | Estimate unique visitors over a year with HyperLogLog |
| Module 8 | Build event log with Streams + consumer groups |
| Module 9 | Build "nearby stores" feature with Geo commands |
| Module 10 | Compare passive vs active expiration with different access patterns |
| Module 11 | Given 5 scenarios, pick the optimal data structure and justify |

## Key Resources
- redis.io/docs/data-types/ (official data types documentation)
- "Redis in Action" — Josiah L. Carlson
- redis.io/commands (full command reference)
- "Seven Databases in Seven Weeks" — Redis chapter
