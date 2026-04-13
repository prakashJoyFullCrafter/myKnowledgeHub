# Redis Advanced Features & Modules - Curriculum

Beyond the basics: Streams deep dive, RESP3/client-side caching, and the Redis modules ecosystem (RedisJSON, RediSearch, RedisBloom, RedisTimeSeries).

---

## Module 1: Streams Deep Dive
- [ ] **Streams**: append-only log with consumer groups (Redis 5+)
- [ ] **Beyond basics** (covered in Data Structures module):
- [ ] **Entry IDs**: `ms-seq` format, auto-generated or explicit
  - [ ] `XADD stream * ...` — auto ID
  - [ ] `XADD stream 1234567890-0 ...` — explicit
- [ ] **Consumer groups**:
  - [ ] `XGROUP CREATE stream groupname $ MKSTREAM`
  - [ ] `$` = "only new messages from now"
  - [ ] `0` = "all messages from start"
- [ ] **Reading**:
  - [ ] `XREADGROUP GROUP grp consumer STREAMS stream >`
  - [ ] `>` = "only unread messages for this consumer"
  - [ ] Specific ID = "pending entry list" replay
- [ ] **Acknowledgement**: `XACK stream group id` — remove from PEL
- [ ] **Pending Entries List (PEL)**: unacked messages per consumer
  - [ ] `XPENDING stream group` — overview
  - [ ] `XPENDING stream group - + count consumer` — detailed list
- [ ] **Claim stuck messages**:
  - [ ] `XCLAIM stream group new-consumer min-idle-time id`
  - [ ] `XAUTOCLAIM` (Redis 6.2+) — automatic scan for idle messages
- [ ] **Trim**: `XTRIM stream MAXLEN ~1000` — approximate trim (faster)
- [ ] **Stream vs List/Pub-Sub**:
  - [ ] Streams: persistent, consumer groups, ack, replay
  - [ ] Lists: simple queue, no groups
  - [ ] Pub/Sub: ephemeral broadcast

## Module 2: RESP Protocol & RESP3
- [ ] **RESP (Redis Serialization Protocol)**: Redis's wire protocol
- [ ] **RESP2** (default for backward compat): simple, text-based with prefixes
  - [ ] `+OK\r\n` — simple string
  - [ ] `-Error msg\r\n` — error
  - [ ] `:42\r\n` — integer
  - [ ] `$5\r\nhello\r\n` — bulk string
  - [ ] `*2\r\n...\r\n...\r\n` — array
- [ ] **RESP3** (Redis 6+): extended protocol
  - [ ] Adds types: map, set, double, boolean, big number, verbatim
  - [ ] Push type: server-initiated messages (invalidation)
  - [ ] Enables client-side caching
  - [ ] Opt-in: `HELLO 3 AUTH ...`
- [ ] **Inline commands**: simple text commands (`PING\r\n`) — also valid RESP
- [ ] **Pipelining at protocol level**: send multiple commands, read replies in order

## Module 3: Client-Side Caching (Redis 6+)
- [ ] **Client-side caching**: cache values on client, Redis invalidates when data changes
- [ ] **Tracking mode** (default):
  - [ ] Client subscribes to invalidation messages
  - [ ] Redis tracks which clients read which keys
  - [ ] On modification, Redis sends invalidation push to interested clients
  - [ ] Clients drop their local copies
- [ ] **Broadcast mode**:
  - [ ] Client subscribes to key prefixes (`user:*`)
  - [ ] Redis sends invalidation for any key matching
  - [ ] No per-client tracking (lower memory on server)
- [ ] **Commands**:
  - [ ] `CLIENT TRACKING ON` — enable default mode
  - [ ] `CLIENT TRACKING ON BCAST PREFIX user:` — broadcast mode
  - [ ] `CLIENT TRACKING OFF`
- [ ] **Requires RESP3** or separate connection for invalidations
- [ ] **Use case**: read-heavy apps, reduce Redis reads by 10-100x
- [ ] **Client support**: Lettuce, Jedis, Go redis — check library docs

## Module 4: RedisJSON Module
- [ ] **RedisJSON**: native JSON document type for Redis
- [ ] **Not bundled** — Redis module (plugin), available in Redis Stack
- [ ] **Features**:
  - [ ] Store, update, query JSON documents natively
  - [ ] JSONPath support for sub-document access
  - [ ] Atomic partial updates
- [ ] **Commands** (prefix `JSON.`):
  - [ ] `JSON.SET key $ '{"name":"Alice","age":30}'`
  - [ ] `JSON.GET key $.name`
  - [ ] `JSON.ARRAPPEND key $.tags '"new"'`
  - [ ] `JSON.NUMINCRBY key $.age 1`
  - [ ] `JSON.DEL key $.field`
- [ ] **vs storing JSON as string**:
  - [ ] Native: atomic field updates, query subset, smaller memory
  - [ ] String: simpler, works everywhere
- [ ] **Integrates with RediSearch**: index and query JSON documents

## Module 5: RediSearch Module
- [ ] **RediSearch**: full-text search and secondary indexing
- [ ] **Features**:
  - [ ] Full-text search (BM25 ranking, stemming, fuzzy)
  - [ ] Secondary indexes on hash or JSON fields
  - [ ] Aggregations (GROUP BY, REDUCE)
  - [ ] Geospatial queries
  - [ ] Vector similarity (KNN, HNSW)
- [ ] **Create index**:
  ```
  FT.CREATE idx:users ON HASH PREFIX 1 user: SCHEMA
    name TEXT SORTABLE
    age NUMERIC SORTABLE
    tags TAG
  ```
- [ ] **Search**:
  ```
  FT.SEARCH idx:users "@name:alice @age:[20 30]"
  ```
- [ ] **Aggregation**:
  ```
  FT.AGGREGATE idx:users "*" GROUPBY 1 @city REDUCE COUNT 0
  ```
- [ ] **Vector search** (for AI/ML):
  - [ ] Store embeddings, search by cosine similarity
  - [ ] Use case: semantic search, recommendation
- [ ] **Alternative to**: PostgreSQL full-text search, small-scale Elasticsearch

## Module 6: RedisTimeSeries Module
- [ ] **RedisTimeSeries**: optimized time-series data type
- [ ] **Features**:
  - [ ] Efficient storage for timestamp → value pairs
  - [ ] Labels (tags) for filtering
  - [ ] Downsampling, aggregation rules
  - [ ] Retention policies
- [ ] **Commands** (prefix `TS.`):
  - [ ] `TS.CREATE key RETENTION 86400 LABELS sensor cpu host server1`
  - [ ] `TS.ADD key timestamp value`
  - [ ] `TS.RANGE key fromTs toTs` — query range
  - [ ] `TS.MRANGE fromTs toTs FILTER label=value` — multi-key range
  - [ ] `TS.CREATERULE src dest AGGREGATION avg 60000` — downsample
- [ ] **Use cases**:
  - [ ] IoT sensor data
  - [ ] Application metrics
  - [ ] Real-time analytics dashboards
- [ ] **vs InfluxDB/TimescaleDB**:
  - [ ] Redis TS is simpler, faster, Redis-native
  - [ ] Less features for complex queries
  - [ ] Good for hot data, integrate with DB for cold data

## Module 7: RedisBloom Module
- [ ] **RedisBloom**: probabilistic data structures
- [ ] **Bloom Filter**:
  - [ ] Space-efficient membership test
  - [ ] False positives possible, false negatives NEVER
  - [ ] Use case: "have we seen this email before?" (pre-filter before DB check)
  - [ ] `BF.ADD filter item`, `BF.EXISTS filter item`
- [ ] **Cuckoo Filter**: like bloom but supports deletes
  - [ ] `CF.ADD filter item`, `CF.DEL filter item`
- [ ] **Count-Min Sketch**: frequency estimation
  - [ ] Count occurrences with sublinear memory
  - [ ] Use case: "how many times has this URL been visited?"
  - [ ] `CMS.INCRBY sketch url 1`, `CMS.QUERY sketch url`
- [ ] **Top-K**: maintain top-K frequent items
  - [ ] `TOPK.ADD topk item`, `TOPK.LIST topk`
- [ ] **T-Digest**: quantile approximation
- [ ] **HyperLogLog** (built-in, not a module): cardinality estimation
- [ ] **When to use**: huge cardinality, approximate answers OK, memory-constrained

## Module 8: Redis Stack
- [ ] **Redis Stack**: distribution that bundles Redis + popular modules
- [ ] **Included**:
  - [ ] Redis (base)
  - [ ] RedisJSON
  - [ ] RediSearch
  - [ ] RedisTimeSeries
  - [ ] RedisBloom
  - [ ] RedisInsight (GUI)
- [ ] **Docker**: `docker run redis/redis-stack`
- [ ] **Redis Cloud**: managed Redis Stack (free tier available)
- [ ] **Licensing**: Redis Source Available License (RSALv2) for modules
- [ ] **Use case**: want more than just key-value — search, JSON, time-series in one place

## Module 9: RedisInsight
- [ ] **RedisInsight**: official GUI for Redis
- [ ] **Features**:
  - [ ] Key browser (filter, search)
  - [ ] CLI with autocomplete
  - [ ] Performance dashboards
  - [ ] Slow log viewer
  - [ ] Memory analysis
  - [ ] Workbench for RedisJSON, RediSearch
- [ ] **Alternative tools**:
  - [ ] `redis-cli --stat` — command-line live stats
  - [ ] `medis` (open source GUI)
  - [ ] `P3X Redis UI` (web-based)

## Module 10: Client Library Ecosystem
- [ ] **Java**:
  - [ ] **Jedis**: blocking, thread-per-connection, simple
  - [ ] **Lettuce**: non-blocking, Netty-based, reactive (Spring default)
  - [ ] **Redisson**: high-level, distributed data structures
- [ ] **Python**: `redis-py` (official), `aioredis` (async)
- [ ] **Node.js**: `node-redis`, `ioredis` (more features)
- [ ] **Go**: `go-redis`, `redigo`
- [ ] **C#**: `StackExchange.Redis`
- [ ] **Rust**: `redis-rs`
- [ ] **Library features to look for**:
  - [ ] Automatic reconnection
  - [ ] Sentinel and Cluster support
  - [ ] Pipelining
  - [ ] Pub/Sub
  - [ ] Script caching (EVALSHA)
  - [ ] TLS support
  - [ ] Client-side caching (Redis 6+)
  - [ ] RESP3 support

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build work queue with Streams + consumer groups + XCLAIM |
| Module 2 | Inspect RESP traffic with tcpdump or `redis-cli MONITOR` |
| Module 3 | Enable client-side caching in Lettuce, measure Redis load reduction |
| Module 4 | Store and query JSON documents with RedisJSON |
| Module 5 | Build product search with RediSearch (text + filters) |
| Module 6 | Track CPU metrics with RedisTimeSeries, downsample to hourly |
| Module 7 | Implement "have I seen this URL?" with Bloom filter |
| Module 8 | Run Redis Stack with Docker, explore RedisInsight |
| Module 9 | Use RedisInsight to analyze memory on a live Redis |
| Module 10 | Compare Jedis vs Lettuce vs Redisson for a project |

## Key Resources
- redis.io/docs/stack/ (Redis Stack)
- redis.io/docs/data-types/streams/ (Streams tutorial)
- redis.io/docs/manual/client-side-caching/
- redis.io/docs/stack/json/ (RedisJSON)
- redis.io/docs/stack/search/ (RediSearch)
- redis.io/docs/stack/timeseries/
- redis.io/docs/stack/bloom/
- redis.io/docs/connect/clients/ (client libraries)
