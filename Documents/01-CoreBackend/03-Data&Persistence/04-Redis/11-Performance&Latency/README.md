# Redis Performance & Latency - Curriculum

How to achieve and maintain low-latency, high-throughput Redis: pipelining, transactions, slow log, and latency diagnosis.

---

## Module 1: Performance Fundamentals
- [ ] **Redis is fast** — 100K+ ops/sec on commodity hardware
- [ ] **Typical latency**:
  - [ ] Same machine: ~30-100 μs per operation
  - [ ] Same datacenter: 0.2-1 ms
  - [ ] Cross-region: 50-200 ms (avoid!)
- [ ] **Performance factors**:
  - [ ] Network RTT (dominant factor for simple commands)
  - [ ] Command complexity (O(1) vs O(N) vs O(N log N))
  - [ ] Data size (big values take longer to transfer)
  - [ ] Single-threaded: slow commands block everything
- [ ] **Golden rule**: minimize round-trips, avoid O(N) commands on large data

## Module 2: Pipelining
- [ ] **Pipelining**: send multiple commands without waiting for each reply
- [ ] **Why**: amortizes network RTT across many commands
- [ ] **Speedup**: can be 10-50x for many small operations
- [ ] **Example**:
  - [ ] 1000 individual SETs: 1000 × RTT = 500ms (at 0.5ms RTT)
  - [ ] Pipelined: 1000 × processing_time + RTT = ~50ms
- [ ] **Client library usage**:
  - [ ] Jedis: `pipeline = jedis.pipelined(); pipeline.set(...); pipeline.sync();`
  - [ ] Lettuce: `commands.set(...)` (async by default, batch with `flushCommands`)
  - [ ] Spring Data Redis: `redisTemplate.executePipelined(...)`
- [ ] **Caveats**:
  - [ ] Not atomic (unlike transactions)
  - [ ] Memory cost: accumulates commands on client AND server
  - [ ] Keep batch size reasonable (1K-10K commands)

## Module 3: Transactions (MULTI/EXEC)
- [ ] **Redis transactions**: group of commands executed atomically
- [ ] **Commands**:
  - [ ] `MULTI`: start transaction
  - [ ] `<queued commands>`: collected, not yet executed
  - [ ] `EXEC`: execute all queued atomically
  - [ ] `DISCARD`: abandon transaction
- [ ] **Atomicity guarantee**: all commands execute sequentially with no other client in between
- [ ] **NOT ACID like SQL**:
  - [ ] No rollback on error (command errors don't undo earlier)
  - [ ] Syntax errors: all commands aborted
  - [ ] Runtime errors: other commands still execute
- [ ] **Use case**: atomic increment + log, conditional updates
- [ ] **Performance**: faster than sending individually, similar to pipelining
- [ ] **Difference from pipelining**:
  - [ ] Pipelining: batch network, NOT atomic
  - [ ] Transaction: ATOMIC, also batched
  - [ ] Can combine: pipeline includes MULTI/EXEC

## Module 4: Optimistic Locking (WATCH)
- [ ] **WATCH**: mark keys to watch — transaction aborts if watched keys change
- [ ] **Check-and-set (CAS) pattern**:
  ```
  WATCH key
  val = GET key
  new_val = compute(val)
  MULTI
  SET key new_val
  EXEC  -- aborts (nil reply) if key changed since WATCH
  ```
- [ ] **Retry loop**: on abort, retry the whole operation
- [ ] **Use case**: concurrent update where you need "if still X, set to Y"
- [ ] **Alternative**: Lua script (simpler, avoids retry loop)
- [ ] **Limitations**:
  - [ ] Retries under contention
  - [ ] Not a distributed lock (use SET NX EX or Redlock for that)

## Module 5: Command Complexity Awareness
- [ ] **O(1) commands** (fast, safe at any scale):
  - [ ] GET, SET, DEL, EXISTS, INCR, HSET, HGET, SADD, ZADD, LPUSH, RPUSH
- [ ] **O(log N) commands**:
  - [ ] Sorted set operations: ZADD, ZRANGE by index, ZSCORE
- [ ] **O(N) commands** (can be SLOW on large data):
  - [ ] `KEYS pattern` — scans ALL keys (NEVER use in production)
  - [ ] `SMEMBERS set` — returns whole set
  - [ ] `HGETALL hash` — returns whole hash
  - [ ] `LRANGE 0 -1` — returns whole list
- [ ] **O(N log N)**:
  - [ ] `ZRANGE BYSCORE` on large sorted set
- [ ] **Alternatives for large collections**:
  - [ ] Use `SCAN`, `SSCAN`, `HSCAN`, `ZSCAN` — cursor-based iteration
  - [ ] Non-blocking, incremental
- [ ] **Rule**: any O(N) command on a large key will block Redis for milliseconds or more

## Module 6: SCAN Iteration
- [ ] **SCAN**: cursor-based iteration over keys (non-blocking)
- [ ] **Example**:
  ```
  SCAN 0 MATCH "user:*" COUNT 100
  -> [cursor, [keys...]]
  SCAN <cursor> ...  (continue until cursor == 0)
  ```
- [ ] **`COUNT`**: hint (not limit), default 10
- [ ] **`MATCH`**: glob filter AFTER scan (can return fewer than COUNT)
- [ ] **`TYPE`**: filter by type (Redis 6.0+)
- [ ] **Guarantees**:
  - [ ] Every key present at start of scan is returned (if not modified during)
  - [ ] Some keys may be returned multiple times (rare)
  - [ ] Keys added during scan may or may not be returned
- [ ] **Variants**: `SSCAN`, `HSCAN`, `ZSCAN` for iterating within collections

## Module 7: Slow Log
- [ ] **Slow log**: records slow commands for analysis
- [ ] **Configuration**:
  - [ ] `slowlog-log-slower-than 10000` — threshold in microseconds (default 10ms)
  - [ ] `slowlog-max-len 128` — max entries to keep
- [ ] **Commands**:
  - [ ] `SLOWLOG GET [N]` — recent slow entries
  - [ ] `SLOWLOG LEN` — count
  - [ ] `SLOWLOG RESET`
- [ ] **Entry info**: id, timestamp, duration (μs), command + args, client addr
- [ ] **Alert on**: consistent slow commands, unexpected slow patterns
- [ ] **Common slow commands**:
  - [ ] `KEYS *` on large DB
  - [ ] `HGETALL` on huge hashes
  - [ ] Expensive Lua scripts
  - [ ] `DEL` on large keys (use `UNLINK` for async delete)

## Module 8: Latency Monitoring
- [ ] **Latency framework** (Redis 2.8+):
  - [ ] Tracks events: AOF fsync, RDB fork, expire cycle, rehashing, etc.
  - [ ] `latency-monitor-threshold 100` — ms threshold
- [ ] **Commands**:
  - [ ] `LATENCY LATEST` — recent latency events
  - [ ] `LATENCY HISTORY event` — history for specific event
  - [ ] `LATENCY RESET` — clear
  - [ ] `LATENCY GRAPH event` — ASCII graph
  - [ ] `LATENCY DOCTOR` — advisor with recommendations
- [ ] **Key events**:
  - [ ] `fork`: time to fork child (for BGSAVE/BGREWRITEAOF)
  - [ ] `aof-write`, `aof-fsync-always`
  - [ ] `expire-cycle`: key expiration scan
  - [ ] `eviction-cycle`, `eviction-del`
- [ ] **`redis-cli --latency`**: measure latency to Redis from client
- [ ] **`redis-cli --latency-dist`**: distribution/histogram
- [ ] **`redis-cli --latency-history`**: sampled over time

## Module 9: Big Keys & Hot Keys
- [ ] **Big key**: single key with huge value/data structure
  - [ ] Detection: `redis-cli --bigkeys`, `MEMORY USAGE key`
  - [ ] Problems: slow operations, memory imbalance, slow cluster slot migration
  - [ ] Fix: split, shard, compress, move to DB
- [ ] **Hot key**: key accessed disproportionately
  - [ ] Problem: all load on one node (in cluster), no benefit from scaling
  - [ ] Detection: `redis-cli --hotkeys` (requires LFU eviction), monitoring
  - [ ] Fix: replicate key to multiple nodes (read replicas, local cache), local cache on app
- [ ] **Detection in production**:
  - [ ] Sampling with client-side metrics
  - [ ] Redis OBJECT FREQ (requires `maxmemory-policy allkeys-lfu`)
  - [ ] Slow log hints

## Module 10: DEL vs UNLINK
- [ ] **DEL**: synchronous deletion — blocks if key is large
- [ ] **UNLINK**: asynchronous deletion — returns immediately, background thread frees memory
- [ ] **Use UNLINK for large keys** to avoid blocking
- [ ] **Same semantics**: key is gone from keyspace immediately
- [ ] **FLUSHDB/FLUSHALL ASYNC**: same async behavior
- [ ] **Example**:
  ```
  UNLINK big-key  -- non-blocking
  DEL small-key   -- fine for small keys
  ```

## Module 11: Connection Pooling & Client Tuning
- [ ] **Connection pool**: reuse TCP connections
  - [ ] Opening new connection is expensive
  - [ ] Pool size: tune for concurrency (too many = resource waste, too few = contention)
- [ ] **Lettuce** (Spring default): single connection, multiplexed, reactive
- [ ] **Jedis**: one connection per thread (blocking model)
- [ ] **Spring config**:
  - [ ] `spring.redis.lettuce.pool.max-active=50`
  - [ ] `spring.redis.lettuce.pool.max-idle=20`
  - [ ] `spring.redis.lettuce.pool.min-idle=5`
- [ ] **Timeouts**:
  - [ ] Connect timeout: how long to wait for TCP connect
  - [ ] Command timeout: how long to wait for response
- [ ] **TCP keepalive**: detect dead connections

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Benchmark throughput on same machine vs same network vs cross-region |
| Module 2 | Pipeline 10K SETs, compare to sequential, measure speedup |
| Module 3 | Build atomic counter + log operation with MULTI/EXEC |
| Module 4 | Implement CAS update with WATCH, observe retries under contention |
| Module 5 | Run KEYS * on large DB, observe blocking (in test env!) |
| Module 6 | Iterate large keyspace with SCAN, track cursor |
| Module 7 | Enable slow log, trigger slow operations, inspect entries |
| Module 8 | Use LATENCY DOCTOR to diagnose simulated latency issues |
| Module 9 | Find and fix a big key scenario |
| Module 10 | Delete a large key with DEL, then UNLINK, compare latency |
| Module 11 | Tune connection pool in Spring Boot, measure throughput |

## Key Resources
- redis.io/docs/management/optimization/
- redis.io/docs/management/optimization/latency/
- "Redis Latency Troubleshooting" — redis.io
- redis.io/commands/scan/
- "Scaling Redis at Twitter" — Twitter engineering
