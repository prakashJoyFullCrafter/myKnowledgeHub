# Redis Internals & Architecture - Curriculum

How Redis works under the hood: single-threaded event loop, memory model, encodings, and I/O threads.

---

## Module 1: Single-Threaded Model
- [ ] **Redis is single-threaded for command execution**
- [ ] All commands processed sequentially by one thread
- [ ] **Why it works**:
  - [ ] Data is in memory — no slow disk seeks between commands
  - [ ] No context switches, no locks, no lock contention
  - [ ] Simple concurrency model, easy to reason about
- [ ] **Why it's fast**: every operation is O(N) instructions on memory
- [ ] **Implications**:
  - [ ] All commands are atomic (no in-flight concurrent commands)
  - [ ] No locking needed for state consistency
  - [ ] Slow commands BLOCK the entire server
- [ ] **"Single-threaded" caveats**:
  - [ ] I/O threads (6.0+) handle network reads/writes in parallel
  - [ ] Background threads for AOF rewrite, RDB, SLOWLOG, etc.
  - [ ] Lua and Redis Functions run on main thread (still blocking)

## Module 2: Event Loop
- [ ] **Redis uses an event-driven single-threaded model**
- [ ] **Event loop**: processes file events (network) and time events (timers)
- [ ] **I/O multiplexing**: epoll (Linux), kqueue (BSD/macOS), select (fallback)
- [ ] **File events**:
  - [ ] Client connects → register for read events
  - [ ] Client sends command → read event fires → process command → send response
  - [ ] Write events for outbound responses
- [ ] **Time events**:
  - [ ] Triggered periodically (every 100ms by default via `hz` config)
  - [ ] Tasks: expire keys, evict keys, rehash, cluster heartbeat, etc.
- [ ] **Single-pass processing**: read all ready events → process → write responses → next iteration
- [ ] **Ultra-low latency**: typical command latency 0.1-0.3 ms

## Module 3: I/O Threads (Redis 6+)
- [ ] **Problem**: on high-throughput workloads, single thread bottleneck on network I/O
- [ ] **Solution**: I/O threads parallelize SOCKET read/write (not command execution)
- [ ] **Configuration**:
  - [ ] `io-threads 4` — number of threads (plus the main thread)
  - [ ] `io-threads-do-reads yes` — also parallelize reads (default: writes only)
- [ ] **Benefits**: 2-3x throughput for high-volume workloads
- [ ] **Command execution still single-threaded** — only I/O is parallelized
- [ ] **When to enable**: high-throughput, mostly-simple commands, network-bound
- [ ] **When NOT**: low-throughput (no benefit), CPU-bound workloads

## Module 4: RedisObject & Memory Model
- [ ] **redisObject**: internal struct wrapping every stored value
  - [ ] `type`: data type (string, list, hash, set, zset, stream)
  - [ ] `encoding`: physical encoding (int, embstr, listpack, hashtable, etc.)
  - [ ] `refcount`: reference counting (for shared objects)
  - [ ] `lru`: LRU clock value (for eviction)
  - [ ] `ptr`: pointer to actual data
- [ ] **Memory overhead per object**: ~16-24 bytes just for redisObject
- [ ] **Shared integer objects**: integers 0-9999 are pre-allocated and reused
- [ ] **Reference counting**: used for shared objects (not for regular data)
- [ ] **No garbage collection**: manual memory management (jemalloc)
- [ ] **jemalloc**: memory allocator used by Redis (performance and fragmentation)

## Module 5: String Encodings
- [ ] Strings can have 3 internal encodings:
- [ ] **`int`**: 64-bit integer stored directly
  - [ ] Used when value is a valid integer, fits in long
  - [ ] Most efficient — no allocation for value
  - [ ] `OBJECT ENCODING key` returns `int`
- [ ] **`embstr`**: embedded string (single allocation)
  - [ ] Used for strings ≤ 44 bytes
  - [ ] String data allocated contiguously with redisObject
  - [ ] Faster allocation, better cache locality
- [ ] **`raw`**: separate allocation
  - [ ] Used for strings > 44 bytes
  - [ ] redisObject + separate SDS string allocation
- [ ] **SDS (Simple Dynamic String)**: Redis's string implementation
  - [ ] Stores length (O(1) strlen), binary-safe, pre-allocates for growth

## Module 6: List Encodings
- [ ] **Old**: ziplist (small) → linkedlist (large)
- [ ] **Current (Redis 7+)**: listpack (small) → quicklist (large)
- [ ] **`listpack`**: compact sequential encoding, one allocation for whole list
  - [ ] Fast for small lists, minimal memory
  - [ ] Used when total size and count below thresholds
- [ ] **`quicklist`**: doubly-linked list of listpacks
  - [ ] Each node is a listpack containing multiple elements
  - [ ] Combines efficiency of listpack with O(1) list operations
- [ ] **Conversion thresholds**:
  - [ ] `list-max-listpack-size -2` (each node: 8 KB listpack)
  - [ ] `list-compress-depth 0` (compression of middle nodes)
- [ ] **Why quicklist**: memory efficient AND fast for large lists

## Module 7: Hash, Set, Sorted Set Encodings
- [ ] **Hash**:
  - [ ] Small: `listpack` (pairs of field-value inline)
  - [ ] Large: `hashtable` (dict structure)
  - [ ] Thresholds: `hash-max-listpack-entries 128`, `hash-max-listpack-value 64`
- [ ] **Set**:
  - [ ] Small integer-only: `intset` (sorted integer array)
  - [ ] Small mixed: `listpack` (Redis 7+)
  - [ ] Large: `hashtable`
  - [ ] Thresholds: `set-max-intset-entries 512`, `set-max-listpack-entries 128`
- [ ] **Sorted Set**:
  - [ ] Small: `listpack` (sorted by score)
  - [ ] Large: `skiplist` + `hashtable` combo
    - [ ] Skiplist: ordered by score for range queries
    - [ ] Hashtable: O(1) member → score lookup
  - [ ] Thresholds: `zset-max-listpack-entries 128`, `zset-max-listpack-value 64`

## Module 8: Dict (Hashtable) Implementation
- [ ] **dict**: Redis's hashtable implementation for keyspace and large data structures
- [ ] **Chaining**: open hashing with linked lists for collisions
- [ ] **Progressive rehashing**:
  - [ ] Two hashtables: `ht[0]` (old) and `ht[1]` (new)
  - [ ] During resize, operations migrate buckets incrementally
  - [ ] Prevents long pause from full rehash (important for single-threaded!)
- [ ] **Load factor**: triggers resize around 1.0 (1 item per bucket avg)
- [ ] **Hash function**: SipHash (cryptographic, resistant to DoS)
- [ ] **Used for**: keyspace, hash type, set type (large), sorted set secondary index

## Module 9: Keyspace & Database Model
- [ ] **Keyspace**: global dict mapping keys → values
- [ ] **Redis databases**: 16 by default (`databases 16`), selected with `SELECT n`
  - [ ] NOT for multi-tenancy — same server, just namespaces
  - [ ] Discouraged for new code — use separate instances or key prefixes
  - [ ] Cluster mode supports only database 0
- [ ] **Expire dict**: separate dict tracking TTLs for each expiring key
  - [ ] Active expiration samples random keys and removes expired
  - [ ] Passive: expired keys removed when accessed
- [ ] **`hz` config**: background task frequency (default 10 Hz)
  - [ ] Higher = more responsive expiration, more CPU
  - [ ] Dynamic `hz`: scales with client count (default)

## Module 10: Persistence Internals
- [ ] **RDB snapshots**:
  - [ ] `BGSAVE`: fork child process, child writes snapshot
  - [ ] Copy-on-write: child sees parent's memory, only copies modified pages
  - [ ] Parent continues serving clients
  - [ ] Fork can be slow on large instances (GB scale) — latency spike during fork
- [ ] **AOF (Append-Only File)**:
  - [ ] Every write command appended to log
  - [ ] fsync policy: `always`, `everysec`, `no`
  - [ ] `BGREWRITEAOF`: fork child, write compacted version
- [ ] **Combined mode** (Redis 7+ default): `aof-use-rdb-preamble yes`
  - [ ] AOF starts with RDB snapshot, then append operations
  - [ ] Faster recovery, smaller file

## Module 11: Replication Internals
- [ ] **PSYNC protocol**: partial sync on brief disconnect
- [ ] **Replication backlog**: ring buffer of recent writes for fast resync
  - [ ] Size: `repl-backlog-size` (default 1 MB)
  - [ ] Too small = more full resyncs
- [ ] **Full sync**: master forks → RDB → sends to replica → replica loads
  - [ ] Expensive, avoided via backlog if possible
- [ ] **Command stream**: after sync, master sends each write to replica
- [ ] **Async by default**: replica may lag behind master
- [ ] **Diskless replication**: RDB sent directly over socket (avoid disk I/O)
  - [ ] `repl-diskless-sync yes`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Run a slow command (`KEYS *` on large DB), observe other clients blocked |
| Module 2 | Monitor event loop latency via `LATENCY HISTORY` |
| Module 3 | Enable I/O threads, benchmark throughput improvement |
| Module 4 | Use `DEBUG OBJECT key` to see encoding and refcount |
| Module 5 | Set a string, observe encoding change (int → embstr → raw) |
| Module 6 | Push 200 items to a list, observe listpack → quicklist conversion |
| Module 7 | Add elements to hash/set/zset, observe encoding thresholds |
| Module 8 | Simulate rehash by flooding keyspace, measure progressive rehash |
| Module 9 | Configure `hz`, observe effect on expiration latency |
| Module 10 | Trigger BGSAVE on large instance, observe fork latency |
| Module 11 | Disconnect and reconnect a replica, observe partial vs full sync |

## Key Resources
- redis.io/docs/reference/internals/
- "Redis Internals" — Salvatore Sanfilippo (antirez) blog posts
- Redis source code (github.com/redis/redis) — `src/object.c`, `src/dict.c`
- "Redis in Action" — Chapter 9 (scaling)
- "Redis Design and Implementation" book (huangz1990)
