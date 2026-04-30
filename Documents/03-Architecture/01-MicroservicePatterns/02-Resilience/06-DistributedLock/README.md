# Distributed Lock - Curriculum

## Module 1: The Problem
- [ ] In a single JVM, `synchronized` / `ReentrantLock` is enough — only one thread at a time
- [ ] Across multiple JVMs (replicas, pods, processes), local locks are useless — each JVM has its own lock object
- [ ] Need: **mutual exclusion across processes** for a shared external resource (file, row, S3 object, third-party API quota)
- [ ] Common scenarios: deduping work items, serializing writes to non-transactional resources, rate-limiting calls to a 3rd party, cron-job exclusion (single execution), inventory reservation
- [ ] **Fundamental tension** with the CAP theorem: a "correct" distributed lock requires consensus → unavoidable cost in latency and availability
- [ ] **Distributed Lock vs Leader Election**:
  - [ ] Lock = "give me exclusive access to *this resource* for a short time" (per-resource, short-lived)
  - [ ] Leader Election = "I am the singular leader of this *role*" (per-role, long-lived, with failover)
  - [ ] They share infrastructure (etcd, ZK, Redis) but have different semantics and SLAs

## Module 2: Properties Every Distributed Lock Needs
- [ ] **Mutual exclusion**: at any moment, at most one client holds the lock for a given key (safety)
- [ ] **Deadlock-free**: lock auto-releases even if the holder crashes (no orphaned locks forever) — usually via TTL/lease
- [ ] **Fault tolerance**: lock service survives single-node failure (replication, quorum)
- [ ] **Liveness**: a non-faulty client trying to acquire eventually succeeds (after the holder releases or expires)
- [ ] **Fencing** (the *killer* property): each lock acquisition returns a monotonically increasing token; downstream resource rejects writes with a stale token
  - [ ] Without fencing, a paused/slow holder can return from GC and corrupt state after another client took over
  - [ ] Martin Kleppmann's classic critique: "How to do distributed locking" — locks WITHOUT fencing are unsafe under any GC pause / network delay
- [ ] **Reentrancy** (sometimes): same client can re-acquire a lock it already holds (mirrors `ReentrantLock`)
- [ ] **Fairness** (sometimes): FIFO acquisition vs barging — usually optional and expensive

## Module 3: Implementation Approaches
- [ ] **Database-backed lock** (`SELECT FOR UPDATE`, advisory locks)
  - [ ] Postgres: `pg_advisory_lock(key)` / `pg_try_advisory_lock(key)` — session-scoped, automatic release on disconnect
  - [ ] Pros: transactional with your existing DB, simple, no new infra
  - [ ] Cons: DB becomes a contention point, doesn't scale to high-throughput locks, connection-tied lifetime is fragile
- [ ] **Redis single-node lock** (`SET key value NX PX 30000`)
  - [ ] Atomic check-and-set with TTL; release with Lua script that compares the unique value before deleting (so you don't release someone else's lock)
  - [ ] Pros: very fast, simple
  - [ ] Cons: not safe under Redis failover (lock can be lost during master→replica promotion); still needs fencing
- [ ] **Redlock** (multi-Redis algorithm by Antirez)
  - [ ] Acquire lock on majority of N independent Redis nodes within a bounded time
  - [ ] Pros: tolerates single-instance Redis failure
  - [ ] Cons: **controversial** — Kleppmann argues it's still unsafe under clock drift / GC pauses; Antirez disagrees; production use requires fencing tokens at the resource level either way
- [ ] **ZooKeeper lock** (ephemeral sequential znodes)
  - [ ] Apache Curator `InterProcessMutex` / `InterProcessSemaphoreMutex` recipes
  - [ ] Pros: well-tested, strong consistency (ZAB), built-in watch on predecessor for queueing
  - [ ] Cons: ZK ops complexity; relatively heavy for short-lived locks
- [ ] **etcd lock** (lease + transaction)
  - [ ] `clientv3/concurrency.NewMutex` — lease-backed, lost-leader detection
  - [ ] Strong consistency (Raft); used internally by Kubernetes for resource locking
- [ ] **Consul lock** (session-based KV)
  - [ ] `consul lock` CLI for shell scripts; Go API for application code
- [ ] **Hazelcast / Apache Ignite** distributed `Lock` interface (in-memory data grid)
- [ ] **Kubernetes `coordination.k8s.io/Lease`** — primarily for leader election, can be adapted for short-term locks

## Module 4: Failure Modes & Pitfalls
- [ ] **Stop-the-world pause** (long GC, OS suspend, VM migration): holder believes it still owns the lock; lease has actually expired; another client took it; both write → corruption
  - [ ] **Mitigation**: fencing tokens at the resource layer — never trust the lock alone
- [ ] **Clock drift**: lease-based locks assume bounded clock skew; large drift breaks safety
  - [ ] Mitigation: prefer monotonic clocks; use consensus-based systems (Raft) for critical locks
- [ ] **Network partition + Redis failover**: client acquires on master → master crashes before replicating → new master has no record → second client acquires → **two holders**
  - [ ] Mitigation: Redlock (with caveats), or use CP system (etcd, ZK), or fence at resource layer
- [ ] **Lock leakage**: holder crashes after work but before release → next acquirer waits TTL
  - [ ] Mitigation: short TTL + lease renewal heartbeats; ephemeral nodes (ZK) auto-clean on session loss
- [ ] **Lock-and-die during long work**: holder acquires 30s lock, work takes 60s → lock expires mid-work → another client acquires → race
  - [ ] Mitigation: heartbeat/extend the lease, OR design work to be idempotent + fenced
- [ ] **Acquisition timeout vs lock TTL** are different parameters — confusing them is a common bug
- [ ] **Hot key contention**: thousands of clients fighting for the same lock → throughput collapses, retry storms
  - [ ] Mitigation: shard the lock key, use a queue instead, or rethink the design
- [ ] **Anti-pattern: distributed lock as your primary correctness mechanism** — locks fail; design the protected resource to be safe under double-execution (idempotency + fencing) and use the lock only for performance/efficiency

## Module 5: When to Use, When Not To
- [ ] **Good fits**:
  - [ ] Singleton scheduled job exclusion (use ShedLock, not raw locks)
  - [ ] Serializing access to a non-transactional external system (file in S3, single-API-key 3rd party)
  - [ ] Coordinating brief critical sections during a migration / one-off operation
  - [ ] Inventory reservation with strict "no oversell" within short windows
- [ ] **Better alternatives often available**:
  - [ ] **DB transaction + row lock** — if the resource is in a DB, just use the DB
  - [ ] **Idempotency keys** — make the operation safe under duplicate execution (eliminates the need for many locks)
  - [ ] **Optimistic concurrency** (version column / CAS) — better throughput, no lock service dependency
  - [ ] **Single-writer pattern** — partition work so each key is owned by exactly one consumer (Kafka partition assignment)
  - [ ] **Leader election** — for "exactly one across the cluster, long-lived"
  - [ ] **Queue / actor / event sourcing** — serialize via message ordering instead of locks
- [ ] **Decision heuristic**: "Do I need a lock, or do I need correctness under concurrency?" — usually the latter, and locks are just one (often inferior) means to it
- [ ] Per-tenant / per-key locks scale better than global locks (sharded contention)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement the same critical section three ways: local `ReentrantLock`, Postgres advisory lock, Redis `SET NX` — measure throughput and failure behaviour |
| Module 3 | Build a Redis lock helper in Java with: unique value, Lua-script release, TTL, retry-with-backoff acquire — handle the edge cases |
| Module 3 | Use Apache Curator `InterProcessMutex` against a local ZK; observe queue ordering with 5 contending clients |
| Module 4 | Reproduce the "GC pause" failure: pause holder for 60s with `kill -STOP`, watch second client acquire, both try to write — observe corruption WITHOUT fencing |
| Module 4 | Add fencing tokens (resource rejects writes with token < highest-seen) — re-run; observe corruption is now impossible |
| Module 5 | Refactor a "lock-protected" cron job into a partitioned design (Kafka consumer group); compare resilience and throughput |

## Cross-References
- `01-MicroservicePatterns/01-CorePatterns/08-LeaderElection/` — sister pattern, shared infrastructure
- `01-MicroservicePatterns/02-Resilience/05-Idempotency/` — fencing tokens are an idempotency mechanism
- `01-MicroservicePatterns/03-DataPatterns/01-CQRS/` — single-writer principle replaces many lock use cases
- `02-SystemDesign/03-SystemDesign/19-DistributedTransactions&Correctness/` — consensus, linearizability theory
- `02-SystemDesign/03-SystemDesign/20-DataInternals/` — Raft, Paxos, ZAB

## Key Resources
- **"How to do distributed locking"** - Martin Kleppmann (the canonical critique; required reading)
- **"Is Redlock safe?"** - Antirez (Salvatore Sanfilippo's response — read both sides)
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 8: trouble with distributed systems; Chapter 9: linearizability)
- **The Chubby Lock Service** - Mike Burrows (Google) — the foundational paper
- **Apache Curator recipes** — `InterProcessMutex`, `InterProcessSemaphore`
- **etcd `concurrency` package** — production-quality reference implementation
- **Redis `SET NX EX`** docs and Redlock spec (redis.io/topics/distlock)
- **ShedLock** - lock implementation focused on scheduled jobs (lukas-krecan/ShedLock)
