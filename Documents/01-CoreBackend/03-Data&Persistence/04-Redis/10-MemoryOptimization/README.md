# Redis Memory Optimization - Curriculum

How to minimize Redis memory footprint: encodings, thresholds, fragmentation, and measurement.

---

## Module 1: Memory Matters
- [ ] **Redis stores everything in RAM** — memory is the #1 cost
- [ ] **Memory efficiency enables**:
  - [ ] Fitting more data on same hardware
  - [ ] Lower infrastructure cost
  - [ ] Better cache hit ratio (more keys cached)
- [ ] **Memory budget**:
  - [ ] Leave 20-30% headroom (fragmentation, temporary spikes, COW during fork)
  - [ ] Don't exceed 50% of RAM for single instance (leave room for fork)
- [ ] **Key insight**: small structural changes can save 10x memory

## Module 2: Memory Overhead Per Key
- [ ] **Every key has overhead**:
  - [ ] dict entry in keyspace (~40 bytes)
  - [ ] redisObject wrapping value (~16-24 bytes)
  - [ ] TTL dict entry if expiring (~24 bytes)
  - [ ] Key string itself (SDS overhead ~5 bytes + length)
- [ ] **Per-key overhead**: ~80-100 bytes minimum, regardless of value size
- [ ] **Small values are disproportionately expensive**:
  - [ ] 10M keys with 10-byte values: ~1 GB (mostly overhead!)
  - [ ] 10M keys packed into 10K hashes: ~100 MB (10x less)
- [ ] **Lesson**: group related small values into hashes or lists

## Module 3: Encoding Threshold Tuning
- [ ] **Small data structures use compact encodings** (listpack)
- [ ] **Crossing thresholds converts to larger encoding** — memory spike
- [ ] **Thresholds to know and tune**:
  - [ ] `hash-max-listpack-entries 128` — hash stays listpack up to 128 fields
  - [ ] `hash-max-listpack-value 64` — max field/value size in bytes
  - [ ] `list-max-listpack-size -2` — 8KB per listpack node in quicklist
  - [ ] `set-max-intset-entries 512` — intset for integer-only small sets
  - [ ] `set-max-listpack-entries 128`, `set-max-listpack-value 64`
  - [ ] `zset-max-listpack-entries 128`, `zset-max-listpack-value 64`
- [ ] **Raising thresholds**:
  - [ ] Pro: more compact storage for medium-sized structures
  - [ ] Con: slower O(N) operations on listpack vs O(1) on hashtable
  - [ ] Rule: raise until CPU cost outweighs memory savings
- [ ] **Inspect**: `OBJECT ENCODING key` to see current encoding

## Module 4: Key Naming & Design
- [ ] **Short key names save memory**:
  - [ ] `user:123` vs `com.example.users.profile:123` — 7 vs 29 bytes
  - [ ] At scale, key length matters more than you think
- [ ] **Avoid long separators**: `::` instead of `:`, or single character
- [ ] **Use shorter encodings**:
  - [ ] UUIDs: 36 chars vs 16 bytes raw
  - [ ] Timestamps: use UNIX epoch int, not formatted string
- [ ] **Consistent naming for compaction**:
  - [ ] Same prefix so compression/encoding works
- [ ] **Anti-pattern**: putting data in the key (`cache:query:SELECT * FROM users WHERE...`)
  - [ ] Fix: hash the query, use hash as key

## Module 5: Hash Field Packing (10x Savings)
- [ ] **Technique**: store millions of small objects as nested hashes
- [ ] **Naive approach**: one key per user
  ```
  SET user:1 "alice"
  SET user:2 "bob"
  ... (10M keys × 100 bytes overhead = 1 GB)
  ```
- [ ] **Hash packing**: bucket users into hashes
  ```
  HSET users:bucket:0 user:1 "alice"
  HSET users:bucket:0 user:2 "bob"
  ... (bucket sharding: bucket = user_id / 1000)
  ```
- [ ] **Memory savings**: each hash field is ~5-10 bytes, no dict entry overhead
- [ ] **Trade-off**:
  - [ ] Can't set per-field TTL (use Redis 7.4+ `HEXPIRE` for that)
  - [ ] Keep buckets under `hash-max-listpack-entries` for listpack encoding
- [ ] **Used by**: Instagram, Twitter, others at massive scale

## Module 6: Avoiding Big Keys
- [ ] **Big key**: single key with very large value (MB+) or huge data structure (millions of elements)
- [ ] **Problems with big keys**:
  - [ ] Slow operations block server (single thread)
  - [ ] Large network transfers
  - [ ] Memory fragmentation
  - [ ] Cluster slot migration difficulty
  - [ ] Replication spikes
- [ ] **Detection**:
  - [ ] `redis-cli --bigkeys` — sample big keys
  - [ ] `MEMORY USAGE key` — exact size
  - [ ] `OBJECT FREQ/IDLETIME`
- [ ] **Solutions**:
  - [ ] Split big hash into multiple keys
  - [ ] Paginate large lists/zsets
  - [ ] Compress values (gzip) — saves memory but costs CPU
  - [ ] Move to database if > few MB per key
- [ ] **Rule**: target < 1 MB per key, avoid > 10 MB

## Module 7: Memory Commands & Inspection
- [ ] **`MEMORY USAGE key [SAMPLES count]`**: estimated memory for a key
- [ ] **`MEMORY STATS`**: detailed global memory breakdown
  - [ ] `used_memory`, `used_memory_rss`, `used_memory_peak`
  - [ ] `total.allocated`, `dataset.bytes`
  - [ ] `clients.normal`, `clients.replicas`
  - [ ] `aof.buffer`, `replication.backlog`
  - [ ] `fragmentation`, `allocator_*`
- [ ] **`INFO memory`**: summary memory metrics
  - [ ] `used_memory` — Redis allocator view
  - [ ] `used_memory_rss` — OS view (includes fragmentation)
  - [ ] `mem_fragmentation_ratio` — rss / used_memory
- [ ] **`MEMORY DOCTOR`**: advisor for common issues
- [ ] **`DEBUG OBJECT key`**: internal object info (encoding, refcount, lru)

## Module 8: Memory Fragmentation
- [ ] **Fragmentation**: used memory in RAM vs what Redis tracks
  - [ ] `mem_fragmentation_ratio > 1.5` = concerning
  - [ ] `> 2.0` = actively problematic
- [ ] **Causes**:
  - [ ] Mixed allocation sizes
  - [ ] Frequent allocate/free cycles
  - [ ] Different expiration times causing holes
- [ ] **Effects**:
  - [ ] OS reports more memory used than Redis thinks
  - [ ] Can hit OOM even with "free" Redis memory
- [ ] **Mitigation**:
  - [ ] **Active defragmentation**: `activedefrag yes` (Redis 4+)
  - [ ] Configurable thresholds: `active-defrag-ignore-bytes`, `active-defrag-threshold-*`
  - [ ] Background process that compacts memory
  - [ ] Use `MEMORY PURGE` to trigger malloc purge

## Module 9: jemalloc & Allocator Tuning
- [ ] **jemalloc**: Redis's memory allocator (default on Linux)
- [ ] **Why jemalloc**: better fragmentation handling than glibc malloc
- [ ] **`allocator_*` metrics** in `MEMORY STATS` expose jemalloc internals
- [ ] **Active defragmentation** works with jemalloc only
- [ ] **Alternative allocators**: tcmalloc, libc malloc (compile-time choice)
- [ ] **Monitoring**:
  - [ ] Track `allocator_frag_ratio` alongside `mem_fragmentation_ratio`
  - [ ] Watch for growing fragmentation over time

## Module 10: maxmemory & Eviction
- [ ] **`maxmemory`**: hard limit on memory usage
  - [ ] Default: unlimited (DANGEROUS on systems without other cap)
  - [ ] Set to leave OS headroom
- [ ] **Eviction policies** (`maxmemory-policy`):
  - [ ] `noeviction`: return OOM errors (default, safest for persistent data)
  - [ ] `allkeys-lru`: evict LRU from all keys
  - [ ] `volatile-lru`: evict LRU from keys with TTL
  - [ ] `allkeys-lfu`: evict least-frequently-used
  - [ ] `volatile-lfu`: same for keys with TTL
  - [ ] `allkeys-random`, `volatile-random`: evict randomly
  - [ ] `volatile-ttl`: evict shortest TTL first
- [ ] **Recommendation**:
  - [ ] Cache workload: `allkeys-lru` or `allkeys-lfu`
  - [ ] Persistent data: `noeviction` + monitor + scale proactively
  - [ ] Mixed: `volatile-lru` (evict cache, keep persistent)

## Module 11: Compression Techniques
- [ ] **Client-side compression**: gzip/lz4 values before storing
  - [ ] Pro: save memory for compressible data (text, JSON)
  - [ ] Con: CPU cost, opaque to Redis commands
  - [ ] Don't compress: small values, already-compressed data
- [ ] **JSON → binary format**: MessagePack, Protobuf — smaller than JSON
- [ ] **RedisJSON module**: binary-encoded JSON (smaller + queryable)
- [ ] **Integer encoding**: store numbers as integers, not strings
- [ ] **Bitmap for booleans**: 1 bit per value vs 80+ bytes per key

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Measure memory for 1M small keys vs 1M fields in hashes |
| Module 3 | Create hash with 100 fields, observe encoding, add 50 more, observe conversion |
| Module 4 | Rename keys to shorter versions, measure memory impact |
| Module 5 | Pack 1M user records into bucketed hashes, compare to one-key-per-user |
| Module 6 | Find big keys with `--bigkeys`, refactor |
| Module 7 | Use `MEMORY USAGE` and `MEMORY STATS` to understand a running instance |
| Module 8 | Induce fragmentation via mixed workload, enable activedefrag, measure |
| Module 9 | Monitor jemalloc stats over time |
| Module 10 | Set maxmemory + eviction policy, fill to limit, observe eviction |
| Module 11 | Compare JSON vs MessagePack vs Protobuf storage for typical objects |

## Key Resources
- redis.io/docs/manual/admin/memory-optimization/
- "Storing 250 million user objects in Redis" — Instagram engineering
- "Memory Optimization" — Redis docs
- redis.io/docs/reference/eviction/
- "Active defragmentation" — Redis 4.0 release notes
