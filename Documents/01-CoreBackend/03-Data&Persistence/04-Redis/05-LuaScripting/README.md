# Redis Lua Scripting - Curriculum

## Module 1: Why Lua in Redis?
- [ ] **Atomicity**: entire script runs as single command — no other client can interfere
- [ ] **Reduce round-trips**: multiple commands in one Redis call
- [ ] **Custom logic**: conditional operations, complex data manipulation
- [ ] **Performance**: no network overhead between commands
- [ ] **No locks needed**: script execution is atomic by design
- [ ] **Why Lua**: small, fast, embedded in Redis since version 2.6
- [ ] **Alternative**: Redis Functions (Redis 7+) — stored procedures
- [ ] **Trade-off**: scripts are blocking — long scripts stall entire Redis

## Module 2: EVAL & EVALSHA
- [ ] **EVAL script numkeys key [key ...] arg [arg ...]**:
  - [ ] `script`: Lua code as string
  - [ ] `numkeys`: how many of the following args are keys
  - [ ] `KEYS[1], KEYS[2]...`: accessed as Lua array
  - [ ] `ARGV[1], ARGV[2]...`: non-key arguments
- [ ] **Example**:
  ```
  EVAL "return redis.call('SET', KEYS[1], ARGV[1])" 1 mykey myvalue
  ```
- [ ] **EVALSHA sha1 numkeys key ... arg ...**:
  - [ ] Execute cached script by SHA1 hash
  - [ ] Faster than sending full script every call
  - [ ] If not cached: `NOSCRIPT` error → fall back to EVAL
- [ ] **SCRIPT LOAD**: pre-load script, returns SHA1
- [ ] **SCRIPT EXISTS sha1**: check if cached
- [ ] **SCRIPT FLUSH**: clear script cache
- [ ] **Client libraries** handle EVALSHA/EVAL fallback automatically

## Module 3: Basic Lua Syntax for Redis
- [ ] **Local variables**: `local x = 1`
- [ ] **Types**: nil, boolean, number, string, table, function
- [ ] **Tables**: Lua's only composite type (used as arrays, maps, objects)
- [ ] **String concatenation**: `"hello" .. " " .. "world"`
- [ ] **Control flow**: `if`, `else`, `elseif`, `for`, `while`, `repeat...until`
- [ ] **Functions**: `function foo() ... end`
- [ ] **Comments**: `--` single line, `--[[ ... ]]` multi-line
- [ ] **String functions**: `string.format`, `string.sub`, `string.len`
- [ ] **Conversions**: `tonumber()`, `tostring()`

## Module 4: `redis.call()` and `redis.pcall()`
- [ ] **`redis.call(command, key, arg, ...)`**: execute a Redis command
  - [ ] Throws error on command failure → script aborts
- [ ] **`redis.pcall(command, key, arg, ...)`**: protected call
  - [ ] Returns error as value instead of throwing
  - [ ] Use when you want to handle errors in the script
- [ ] **Return value types**:
  - [ ] Redis integer → Lua number
  - [ ] Redis simple string → Lua string
  - [ ] Redis bulk string → Lua string (or false if nil)
  - [ ] Redis array → Lua table
  - [ ] Redis error → Lua error (call) or table with `err` field (pcall)

## Module 5: Script Return Values
- [ ] **Returning to client**:
  - [ ] `return 42` → integer
  - [ ] `return "ok"` → string
  - [ ] `return {1, 2, 3}` → array
  - [ ] `return true` → 1
  - [ ] `return false` → nil
  - [ ] `return nil` → nil
- [ ] **Status reply**: `return redis.status_reply("OK")`
- [ ] **Error reply**: `return redis.error_reply("something failed")`
- [ ] **Nested tables**: returned as nested arrays
- [ ] **No Lua-specific types** beyond Redis type system

## Module 6: Key Declaration Rule (IMPORTANT)
- [ ] **Rule**: all keys the script touches MUST be passed as KEYS
- [ ] **Why**: Redis Cluster uses this to check if all keys are on same node
- [ ] **Violation**: script that constructs key names dynamically and accesses them won't work in cluster
- [ ] **Example BAD** (won't work in cluster):
  ```
  -- EVAL "return redis.call('GET', 'user:' .. ARGV[1])" 0 123
  ```
- [ ] **Example GOOD**:
  ```
  -- EVAL "return redis.call('GET', KEYS[1])" 1 user:123
  ```
- [ ] **Hash tags**: `{user:123}.name`, `{user:123}.email` → same slot (if multiple keys needed)
- [ ] **`redis.replicate_commands()`**: allow non-deterministic scripts in replication (deprecated, now default)

## Module 7: Common Scripts — Rate Limiting
- [ ] **Fixed window rate limiter**:
  ```lua
  local current = redis.call('INCR', KEYS[1])
  if current == 1 then
      redis.call('EXPIRE', KEYS[1], ARGV[1])
  end
  if current > tonumber(ARGV[2]) then
      return 0  -- rate limited
  end
  return 1  -- allowed
  ```
- [ ] **Sliding window rate limiter** (with sorted set):
  ```lua
  local now = tonumber(ARGV[1])
  local window = tonumber(ARGV[2])
  redis.call('ZREMRANGEBYSCORE', KEYS[1], 0, now - window)
  local count = redis.call('ZCARD', KEYS[1])
  if count >= tonumber(ARGV[3]) then
      return 0
  end
  redis.call('ZADD', KEYS[1], now, now)
  redis.call('EXPIRE', KEYS[1], window / 1000)
  return 1
  ```
- [ ] **Token bucket**: maintains token count + last refill time, refills on demand

## Module 8: Common Scripts — Distributed Locks
- [ ] **Lock acquisition** (can just use `SET NX EX` without Lua)
- [ ] **Lock release with ownership check** (NEEDS Lua for atomicity):
  ```lua
  if redis.call('GET', KEYS[1]) == ARGV[1] then
      return redis.call('DEL', KEYS[1])
  else
      return 0
  end
  ```
- [ ] **Why Lua here**: prevents deleting someone else's lock (owner check + delete must be atomic)
- [ ] **Lock extension**: refresh TTL if still owner
- [ ] **Redisson** and similar libraries use Lua scripts internally for lock logic

## Module 9: Script Limitations & Pitfalls
- [ ] **Blocking execution**: long scripts stall Redis — keep scripts short
  - [ ] `SCRIPT KILL` — try to kill running script (only before writes)
- [ ] **No global state between calls**: each script execution is isolated
- [ ] **No random determinism required** (since Redis 5): scripts can be non-deterministic
- [ ] **Lua 5.1** (not modern Lua 5.4) — limited standard library
- [ ] **Debugging**: limited — use `redis.log(redis.LOG_WARNING, "msg")`
- [ ] **No lambdas across scripts**: no shared functions, no OO
- [ ] **Script caching**: cache is per-instance and cleared on restart or FLUSH
- [ ] **Never use `KEYS *` in scripts**: blocking scan on huge dataset

## Module 10: Redis Functions (Redis 7+)
- [ ] **Redis Functions**: evolved replacement for Lua scripts
- [ ] **Advantages**:
  - [ ] Stored in Redis (not just cached) — persist across restarts
  - [ ] Grouped in libraries (multiple related functions together)
  - [ ] Replicated via AOF and replicas
  - [ ] Managed like data (FCALL, FUNCTION LOAD, FUNCTION LIST)
- [ ] **Commands**:
  - [ ] `FUNCTION LOAD` — load a library
  - [ ] `FCALL function_name numkeys key arg` — call a function
  - [ ] `FUNCTION LIST` — list loaded functions
  - [ ] `FUNCTION DELETE` — remove
- [ ] **When to use**: server-side logic that should persist, shared across applications
- [ ] **Lua scripts still work**: no deprecation

## Module 11: Spring Data Redis Lua Support
- [ ] **`RedisScript<T>`**:
  - [ ] `RedisScript.of("EVAL script", Long.class)`
  - [ ] `redisTemplate.execute(script, keys, args)`
- [ ] **Script auto-caching**: Spring uses EVALSHA with EVAL fallback
- [ ] **Loading from classpath**: `ResourceScriptSource`
  - [ ] Keep scripts in `src/main/resources/scripts/*.lua`
- [ ] **Example rate limiter bean**:
  ```java
  @Bean
  RedisScript<Long> rateLimitScript() {
      return RedisScript.of(
          new ClassPathResource("scripts/rate_limit.lua"), Long.class);
  }
  ```
- [ ] **Redisson**: provides higher-level abstractions (locks, rate limiters) built on Lua

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Write a simple Lua script with EVAL and EVALSHA |
| Module 3 | Write a script with control flow, local variables |
| Module 4 | Use redis.call and redis.pcall, handle errors |
| Module 5 | Return different types (int, string, array, status, error) |
| Module 6 | Write a cluster-safe script using proper KEYS declaration |
| Module 7 | Implement fixed window and sliding window rate limiters |
| Module 8 | Implement distributed lock with ownership check |
| Module 9 | Identify blocking patterns in long scripts, refactor |
| Module 10 | Migrate a Lua script to a Redis Function |
| Module 11 | Load Lua script from classpath in Spring Boot, use via RedisScript |

## Key Resources
- redis.io/docs/interact/programmability/eval-intro/
- redis.io/docs/interact/programmability/functions-intro/
- "Programming in Lua" — free online book (lua.org/pil)
- Spring Data Redis ScriptSupport documentation
- Redisson Lua-based features
