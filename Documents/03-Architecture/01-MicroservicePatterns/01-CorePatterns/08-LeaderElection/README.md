# Leader Election - Curriculum

## Module 1: The Problem
- [ ] Multiple replicas of the same service running for HA — but some work must be done by **exactly one** instance at a time
- [ ] Examples: scheduled jobs, cluster controllers, sequence generators, primary DB writer, partition assigners
- [ ] Naive approaches fail: cron on every replica = duplicate runs; "first one to start wins" = no failover
- [ ] **Split-brain**: two nodes both believe they are leader → divergent state, data corruption
- [ ] Goal: at most one leader at any time (safety) + a leader is elected within bounded time after failure (liveness)
- [ ] Trade-off triangle: **Safety** (no two leaders) vs **Liveness** (always have a leader) vs **Performance** (election cost)

## Module 2: Election Algorithms
- [ ] **Bully Algorithm**: highest-ID node wins; on leader failure, any node starts election by messaging higher-ID nodes
  - [ ] Simple, O(n²) messages worst case, assumes synchronous network
- [ ] **Ring Algorithm**: nodes arranged in logical ring; election token passes around collecting IDs; highest wins
- [ ] **Raft**: term-based leader election with randomized timeouts; leader sends heartbeats; followers convert to candidate on timeout
  - [ ] Election safety: at most one leader per term (majority quorum required)
  - [ ] Used by: etcd, Consul, CockroachDB, TiKV, MongoDB (modified)
- [ ] **Paxos / Multi-Paxos**: classical consensus; leader election is a special case of consensus
- [ ] **ZAB (ZooKeeper Atomic Broadcast)**: ZooKeeper's variant; FIFO order + leader election
- [ ] **Lease-based**: leader holds a time-bounded lease in shared store; renews before expiry; on failure, lease expires and others compete
  - [ ] Simplest in practice; used by Kubernetes, Google Chubby, Redis Redlock
- [ ] Quorum requirement: need **majority** (`N/2 + 1`) to avoid split-brain in network partitions

## Module 3: Implementations & Tooling
- [ ] **ZooKeeper**: ephemeral sequential znodes; lowest sequence = leader; watchers notified on leader death
  - [ ] Apache Curator `LeaderSelector` / `LeaderLatch` recipes (don't roll your own)
- [ ] **etcd**: lease + key-value with `compare-and-swap`; election API built-in (`clientv3/concurrency.NewElection`)
- [ ] **Consul**: session + KV lock; `consul lock` CLI for shell-level leader election
- [ ] **Kubernetes**: `coordination.k8s.io/Lease` objects; `client-go/tools/leaderelection` package — used by every controller
- [ ] **Redis**: Redlock algorithm (multi-instance), or simple `SET NX EX` for single-master scenarios (with caveats)
- [ ] **Spring Integration Leader**: `LeaderInitiator` with ZooKeeper / Hazelcast / etcd backend; `@OnGrantedEvent` / `@OnRevokedEvent`
- [ ] **ShedLock** (JVM): annotates `@Scheduled` methods to ensure single execution across replicas — JDBC, Redis, ZooKeeper, MongoDB providers
- [ ] **Hazelcast / Apache Ignite**: in-memory data grid with built-in cluster leader election
- [ ] **Akka Cluster Singleton**: actor-based singleton across cluster

## Module 4: Failure Modes & Pitfalls
- [ ] **Split-brain**: network partition → both sides elect a leader → must use majority quorum to prevent
- [ ] **Stale leader**: GC pause / OS suspend → leader thinks it still leads but lease has expired and another took over
  - [ ] Solution: **fencing tokens** — monotonically increasing token issued per leadership; downstream rejects stale tokens
- [ ] **Clock skew**: lease-based election assumes bounded clock drift; use monotonic clocks where possible
- [ ] **Thundering herd**: leader dies → all followers race to become leader → election storm
  - [ ] Solution: randomized election timeouts (Raft does this)
- [ ] **Flapping leadership**: marginal network → leader keeps changing → no work gets done
  - [ ] Solution: hysteresis, longer lease durations, dampening
- [ ] **Lease expiry during work**: leader runs a long job, lease expires mid-job, new leader starts same job
  - [ ] Solution: check leadership before each side-effect; use fencing tokens at the resource level
- [ ] **The "8 fallacies"**: never assume the network is reliable, latency is zero, or topology doesn't change

## Module 5: Use Cases & Patterns
- [ ] **Singleton Scheduler**: only one replica runs `@Scheduled` jobs (ShedLock pattern)
- [ ] **Controller / Reconciler**: only the leader watches resources and acts (K8s controller pattern)
- [ ] **Partition Assignment**: leader assigns Kafka partitions, shards, or work units to workers
- [ ] **Primary/Replica Failover**: database primary election (PostgreSQL with Patroni, MongoDB replica sets)
- [ ] **Distributed Lock holder**: leader manages a critical resource on behalf of all clients
- [ ] **Coordinator for Saga / Workflow**: only the leader drives long-running workflows
- [ ] **Cache Warmer / Materialized View Builder**: expensive precomputation done once, leader publishes to all
- [ ] **Anti-pattern**: using leader election when **sharding** would scale better (leader = bottleneck)
- [ ] Decision: do you really need a single leader, or can the work be **partitioned** across all replicas?

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement Bully algorithm in Java with 5 simulated nodes; kill the leader and observe re-election |
| Module 3 | Add ShedLock (JDBC provider) to a Spring Boot scheduled job; run 3 replicas, verify single execution |
| Module 3 | Build a singleton worker with Spring Integration `LeaderInitiator` + ZooKeeper |
| Module 3 | Implement leader election with etcd `clientv3/concurrency` from a Java client |
| Module 4 | Simulate GC pause: pause leader for 30s, verify fencing token rejects stale writes |
| Module 5 | Refactor a "leader-only scheduler" into a partitioned design — compare throughput |

## Cross-References
- `02-SystemDesign/03-SystemDesign/19-DistributedTransactions&Correctness/` — consensus & correctness
- `02-SystemDesign/03-SystemDesign/20-DataInternals/` — Raft, Paxos in depth
- `01-MicroservicePatterns/01-CorePatterns/02-ServiceMesh/` — control-plane leader election (Istiod)
- `01-MicroservicePatterns/02-Resilience/` — failover and quorum overlap

## Key Resources
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapter 9: Consistency and Consensus)
- **In Search of an Understandable Consensus Algorithm (Raft)** - Diego Ongaro
- **The Chubby Lock Service** - Mike Burrows (Google paper)
- **ZooKeeper Recipes** - Apache Curator documentation (curator.apache.org)
- **Kubernetes Leader Election** - `client-go/tools/leaderelection` source
- **ShedLock** - github.com/lukas-krecan/ShedLock
- **etcd concurrency package** - etcd.io documentation
