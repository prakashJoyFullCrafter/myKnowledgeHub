# CAP Theorem - Curriculum

## Module 1: CAP Fundamentals
- [ ] **Consistency (C)**: every read receives the most recent write or an error
- [ ] **Availability (A)**: every request receives a non-error response (no guarantee it's the latest)
- [ ] **Partition Tolerance (P)**: system continues to operate despite network partitions between nodes
- [ ] You can only guarantee 2 of 3 during a network partition
- [ ] Why CA is impossible in distributed systems (partitions WILL happen)
- [ ] CAP is about behavior DURING a partition, not during normal operation

## Module 2: CP vs AP Systems
- [ ] **CP systems** (sacrifice availability during partition):
  - [ ] MongoDB (primary election blocks writes)
  - [ ] HBase, Redis Sentinel, ZooKeeper, etcd
  - [ ] Use case: financial transactions, inventory counts — correctness over uptime
- [ ] **AP systems** (sacrifice consistency during partition):
  - [ ] Cassandra, DynamoDB, CouchDB, Riak
  - [ ] Use case: social media feeds, shopping carts — availability over strict correctness
- [ ] Most systems are tunable: DynamoDB lets you choose per-request (strong vs eventual)

## Module 3: Consistency Models
- [ ] **Strong consistency**: reads always reflect latest write (linearizability)
- [ ] **Eventual consistency**: reads may be stale, but will converge
- [ ] **Causal consistency**: preserves cause-and-effect ordering
- [ ] **Read-your-writes consistency**: user always sees their own updates
- [ ] **Monotonic reads**: never see older data after seeing newer data
- [ ] Quorum reads/writes: `R + W > N` for strong consistency

## Module 4: Beyond CAP
- [ ] **PACELC theorem**: extends CAP — if Partition, choose A or C; Else, choose Latency or Consistency
  - [ ] PA/EL: Cassandra, DynamoDB (availability + low latency)
  - [ ] PC/EC: MongoDB, HBase (consistency always)
  - [ ] PA/EC: rare but possible (available during partition, consistent otherwise)
- [ ] CAP criticism: too simplistic, real systems have nuanced trade-offs
- [ ] **BASE** vs **ACID**: Basically Available, Soft state, Eventual consistency
- [ ] Real-world: most systems are "CP with tunable consistency" or "AP with conflict resolution"

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Classify 10 databases/systems as CP or AP with justification |
| Module 3 | Design a system that needs read-your-writes consistency (user profile updates) |
| Module 4 | Apply PACELC to analyze trade-offs in a multi-region e-commerce system |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapter 9)
- "Please stop calling databases CP or AP" - Martin Kleppmann (blog)
- "CAP Twelve Years Later" - Eric Brewer
