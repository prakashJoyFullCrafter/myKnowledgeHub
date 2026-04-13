# Redis Distributed Patterns - Curriculum

Distributed locks, rate limiters, leader election, and coordination primitives built on Redis.

---

## Module 1: Why Redis for Distributed Coordination?
- [ ] **Redis characteristics** that make it useful:
  - [ ] Atomic operations (single-threaded command execution)
  - [ ] TTL support (auto-cleanup)
  - [ ] Pub/Sub for notifications
  - [ ] Lua scripting for multi-step atomic operations
  - [ ] Widely deployed, fast, simple API
- [ ] **Redis limitations** for distributed coordination:
  - [ ] Single-master architecture (not a consensus system like etcd/ZooKeeper)
  - [ ] Failover takes time, can lose data
  - [ ] NOT suitable for strong consistency guarantees
- [ ] **When Redis is "good enough"**:
  - [ ] Short-lived locks
  - [ ] Rate limiting (some tolerance for edge cases)
  - [ ] Leader election for non-critical services
  - [ ] Cache coordination
- [ ] **When to use etcd/ZooKeeper instead**:
  - [ ] Critical consensus (financial, safety-critical)
  - [ ] Long-term leader election
  - [ ] Strict linearizability required

## Module 2: Simple Distributed Lock
- [ ] **Basic pattern** (single Redis):
  ```
  SET lock-key unique-value NX PX 30000  # set if not exists, 30s TTL
  ```
- [ ] **Why unique value**: identifies owner for safe release
- [ ] **Why TTL**: auto-release if holder crashes
- [ ] **Acquire**:
  - [ ] Success: returned "OK", lock held for 30 seconds
  - [ ] Failure: nil, another holder has it
- [ ] **Release** (must be atomic — use Lua):
  ```lua
  if redis.call('GET', KEYS[1]) == ARGV[1] then
      return redis.call('DEL', KEYS[1])
  else
      return 0
  end
  ```
- [ ] **Why Lua for release**: prevents deleting someone else's lock (check-then-delete race)

## Module 3: Lock Correctness Problems
- [ ] **Problem 1: Clock drift**
  - [ ] TTL based on wall clock
  - [ ] Clock skew between nodes can cause issues
- [ ] **Problem 2: GC pauses**
  - [ ] Process gets lock → GC pause → lock expires → another process gets it
  - [ ] Original process resumes, thinks it still holds the lock
  - [ ] Two processes in critical section!
- [ ] **Problem 3: Network delays**
  - [ ] Lock acquired, message to client delayed
  - [ ] TTL already counting on server
  - [ ] Effective hold time < requested
- [ ] **Problem 4: Failover**
  - [ ] Lock acquired on master
  - [ ] Master fails before replication
  - [ ] New master doesn't have the lock
  - [ ] Two processes hold lock
- [ ] **Fundamental issue**: Redis locks are NOT safe for critical sections without fencing

## Module 4: Fencing Tokens
- [ ] **Fencing token**: monotonically increasing number returned with each lock
- [ ] **Usage**:
  1. [ ] Client acquires lock → receives token (e.g., 5)
  2. [ ] Client does work, sends token to downstream system
  3. [ ] Downstream system tracks highest seen token, rejects lower
- [ ] **Why it works**: even if two clients think they hold the lock, only the one with the HIGHER token is accepted
- [ ] **Implementation**: INCR a counter alongside SET NX
  ```lua
  if redis.call('SET', KEYS[1], ARGV[1], 'NX', 'PX', ARGV[2]) then
      return redis.call('INCR', KEYS[2])
  end
  return nil
  ```
- [ ] **Fencing is the only way to ensure safety** — this is a Martin Kleppmann lesson

## Module 5: Redlock Algorithm
- [ ] **Redlock** (proposed by Antirez): lock across N independent Redis masters
- [ ] **Algorithm**:
  1. [ ] Get current time (ms)
  2. [ ] Try to acquire lock on all N masters (with short timeout each)
  3. [ ] Lock is acquired if majority ((N/2)+1) succeed AND total time < TTL
  4. [ ] Hold time = TTL - elapsed time
  5. [ ] Release: delete on all masters
- [ ] **Claims**: works even if some masters fail
- [ ] **Criticism** (Martin Kleppmann, "How to do distributed locking"):
  - [ ] Still vulnerable to GC pauses
  - [ ] Relies on synchronized clocks
  - [ ] Doesn't provide fencing tokens
- [ ] **Antirez's response**: defends Redlock for specific use cases
- [ ] **Verdict**: Redlock is better than single-instance, but not bulletproof
  - [ ] Acceptable for efficiency-based locks (avoid duplicate work)
  - [ ] NOT for correctness-critical locks (need fencing tokens + consensus)

## Module 6: Redisson — Production Lock Library
- [ ] **Redisson**: Java Redis client with rich distributed data structures
- [ ] **Features**:
  - [ ] `RLock` — basic distributed lock
  - [ ] `RFairLock` — FIFO fairness
  - [ ] `RReadWriteLock` — multiple readers, exclusive writer
  - [ ] `RSemaphore` — limited-count lock
  - [ ] `RPermitExpirableSemaphore` — with expiration
- [ ] **Lock features**:
  - [ ] **Watchdog**: auto-renews lease while holder is alive
  - [ ] **Reentrant**: same thread can re-acquire (like `ReentrantLock`)
  - [ ] **Tryable**: `tryLock(wait, lease, unit)`
  - [ ] **Integrated with Redlock**: `getMultiLock(lock1, lock2, lock3)`
- [ ] **Usage**:
  ```java
  RLock lock = redisson.getLock("myLock");
  lock.lock(10, TimeUnit.SECONDS);
  try { /* critical section */ }
  finally { lock.unlock(); }
  ```
- [ ] **Recommendation**: use Redisson for Java apps needing Redis locks

## Module 7: Rate Limiting — Fixed Window
- [ ] **Fixed window counter**: simple rate limiter
- [ ] **Logic**: count requests per time window (e.g., 100/minute)
- [ ] **Lua script**:
  ```lua
  local current = redis.call('INCR', KEYS[1])
  if current == 1 then
      redis.call('EXPIRE', KEYS[1], ARGV[1])  -- window size
  end
  if current > tonumber(ARGV[2]) then
      return 0  -- limited
  end
  return 1  -- allowed
  ```
- [ ] **Pros**: simple, fast, low memory
- [ ] **Cons**: bursts at window boundaries (double rate possible)
  - [ ] Example: 100 at 0:59.9, 100 at 1:00.1 → 200 in 0.2s

## Module 8: Rate Limiting — Sliding Window
- [ ] **Sliding window log** (exact but expensive):
  - [ ] Store timestamp of each request in sorted set
  - [ ] Remove old entries, count remaining
  ```lua
  local now = tonumber(ARGV[1])
  local window = tonumber(ARGV[2])
  redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, now - window)
  local count = redis.call('ZCARD', KEYS[1])
  if count >= tonumber(ARGV[3]) then
      return 0
  end
  redis.call('ZADD', KEYS[1], now, now)
  redis.call('EXPIRE', KEYS[1], math.ceil(window / 1000))
  return 1
  ```
- [ ] **Memory cost**: one entry per request (not scalable for high rate)
- [ ] **Sliding window counter** (approximation):
  - [ ] Weighted average of current and previous fixed window
  - [ ] Memory efficient
  - [ ] Good enough accuracy for most use cases

## Module 9: Rate Limiting — Token Bucket
- [ ] **Token bucket**: bucket refills at constant rate, requests consume tokens
- [ ] **Parameters**: capacity (burst), refill rate
- [ ] **Lua implementation**:
  ```lua
  local bucket = redis.call('HMGET', KEYS[1], 'tokens', 'last_refill')
  local tokens = tonumber(bucket[1]) or tonumber(ARGV[1])  -- capacity
  local last = tonumber(bucket[2]) or tonumber(ARGV[4])    -- now
  local now = tonumber(ARGV[4])
  local refill = tonumber(ARGV[2])                          -- rate per sec
  local capacity = tonumber(ARGV[1])
  local elapsed = (now - last) / 1000
  tokens = math.min(capacity, tokens + elapsed * refill)
  if tokens < 1 then
      redis.call('HMSET', KEYS[1], 'tokens', tokens, 'last_refill', now)
      return 0
  end
  tokens = tokens - 1
  redis.call('HMSET', KEYS[1], 'tokens', tokens, 'last_refill', now)
  redis.call('EXPIRE', KEYS[1], tonumber(ARGV[3]))
  return 1
  ```
- [ ] **Pros**: allows bursts up to capacity, smooth average rate
- [ ] **Cons**: slightly more complex than fixed window

## Module 10: Leader Election
- [ ] **Pattern**: only one instance should do a task (leader/primary)
- [ ] **Simple approach**: SET NX with TTL as leader heartbeat
  ```
  SET leader-key instance-id NX PX 30000
  ```
- [ ] **Each instance tries periodically**: one succeeds, becomes leader
- [ ] **Renewal**: leader periodically renews TTL (before expiry)
- [ ] **Failover**: when leader stops renewing, another instance takes over on next attempt
- [ ] **Pitfalls**:
  - [ ] Brief window of two "leaders" during failover (GC pause, network delay)
  - [ ] Not suitable for strong consistency
- [ ] **Alternative**: etcd, ZooKeeper, Consul for critical leader election
- [ ] **Use Redis for**: background job coordination, "run once across cluster" tasks

## Module 11: Pub/Sub-Based Coordination
- [ ] **Pattern**: use Pub/Sub for invalidation, notifications
- [ ] **Cache invalidation broadcast**:
  - [ ] Any instance invalidates → publishes `invalidate:key`
  - [ ] All subscribers update their local cache
- [ ] **Config change notification**:
  - [ ] Admin updates config → publishes `config:updated`
  - [ ] Services reload
- [ ] **Event fan-out**: notify many services of a cross-cutting event
- [ ] **Limitations**:
  - [ ] Pub/Sub is best-effort — no guarantees
  - [ ] Subscribers offline during publish miss the message
  - [ ] For reliable notifications: use Streams

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare Redis vs etcd for leader election scenario |
| Module 2 | Build simple SET NX EX lock, release with Lua |
| Module 3 | Reproduce GC pause scenario, demonstrate lock safety issue |
| Module 4 | Implement fencing token pattern with Redis |
| Module 5 | Implement Redlock across 3 Redis instances |
| Module 6 | Use Redisson RLock in a Spring Boot app with watchdog |
| Module 7 | Build fixed-window rate limiter with Lua |
| Module 8 | Compare exact (log) vs approximate (counter) sliding window |
| Module 9 | Implement token bucket rate limiter |
| Module 10 | Build leader election for a scheduled task |
| Module 11 | Implement cache invalidation broadcast via Pub/Sub |

## Key Resources
- "Distributed Locks with Redis" — redis.io/docs/manual/patterns/distributed-locks/
- "How to do distributed locking" — Martin Kleppmann
- Antirez's Redlock response — antirez.com
- Redisson documentation — redisson.org
- "Rate Limiting Strategies" — Stripe engineering blog
