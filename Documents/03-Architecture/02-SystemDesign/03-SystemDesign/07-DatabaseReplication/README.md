# Database Replication - Curriculum

## Module 1: Replication Fundamentals
- [ ] Why replicate? High availability, fault tolerance, read scaling, geo-distribution
- [ ] **Primary (master)**: handles writes
- [ ] **Replica (slave/follower)**: receives copy of data, handles reads
- [ ] Replication ≠ sharding: replication copies ALL data, sharding splits data

## Module 2: Replication Topologies
- [ ] **Single-leader (master-slave)**: one primary, multiple replicas
  - [ ] Simple, no write conflicts, most common
  - [ ] Failover: promote replica to primary
- [ ] **Multi-leader (master-master)**: multiple primaries, each accepts writes
  - [ ] Use case: multi-datacenter (one primary per DC)
  - [ ] Challenge: write conflicts, conflict resolution strategies
- [ ] **Leaderless**: any node accepts reads and writes (Cassandra, DynamoDB)
  - [ ] Quorum: `R + W > N` for consistency
  - [ ] Anti-entropy: background process repairs inconsistencies

## Module 3: Synchronous vs Asynchronous
- [ ] **Synchronous replication**: primary waits for replica acknowledgment before confirming write
  - [ ] Guarantees consistency, but slower (latency of slowest replica)
- [ ] **Asynchronous replication**: primary confirms immediately, replica catches up later
  - [ ] Faster writes, but replica can be stale (replication lag)
  - [ ] Risk: data loss if primary fails before replication
- [ ] **Semi-synchronous**: at least one replica confirms synchronously, rest async
  - [ ] PostgreSQL: `synchronous_commit`, `synchronous_standby_names`
  - [ ] MySQL: semi-sync replication plugin

## Module 4: Replication Lag & Consistency
- [ ] **Replication lag**: time between write on primary and visibility on replica
- [ ] Problems caused by lag:
  - [ ] **Read-after-write inconsistency**: user writes, then reads from replica → doesn't see own write
  - [ ] **Monotonic read violation**: user sees newer data, then older data on different replica
  - [ ] **Causal ordering violation**: effect visible before cause
- [ ] Solutions:
  - [ ] Read-your-writes: route user's reads to primary after their writes
  - [ ] Monotonic reads: sticky sessions (same replica per user)
  - [ ] Causal consistency: track causal dependencies

## Module 5: Failover & High Availability
- [ ] **Automatic failover**: detect primary failure → promote replica → redirect traffic
- [ ] Split-brain problem: two nodes think they're primary → data divergence
- [ ] Fencing: STONITH (Shoot The Other Node In The Head) to prevent split-brain
- [ ] **PostgreSQL**: Patroni for automated failover, pg_rewind for re-joining old primary
- [ ] **MySQL**: Group Replication, InnoDB Cluster, Orchestrator
- [ ] **Redis**: Sentinel for automatic failover, Redis Cluster for sharding + replication
- [ ] RPO (Recovery Point Objective) and RTO (Recovery Time Objective)

## Module 6: Real-World Patterns
- [ ] **Read replicas**: route read queries to replicas, writes to primary
  - [ ] Spring: `@Transactional(readOnly = true)` → route to replica datasource
  - [ ] AWS RDS: up to 15 read replicas
- [ ] **Cross-region replication**: replicas in different regions for low-latency global reads
- [ ] **Streaming replication** (PostgreSQL): WAL streaming to replicas in real-time
- [ ] **Logical replication** (PostgreSQL): replicate specific tables, cross-version, data transformation
- [ ] **CDC (Change Data Capture)**: Debezium captures DB changes, streams to Kafka
- [ ] **Blue-green deployments** with replication: switch traffic between two clusters

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up PostgreSQL primary + 2 replicas with streaming replication |
| Module 3 | Measure replication lag under write load (sync vs async) |
| Module 4 | Reproduce read-after-write inconsistency, implement sticky session fix |
| Module 5 | Simulate primary failure, observe Patroni automatic failover |
| Module 6 | Configure read/write splitting in Spring Boot with multiple datasources |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapter 5: Replication)
- PostgreSQL Replication documentation
- "How Slack Scaled to 100K+ Simultaneous Connections" - engineering blog
- Patroni documentation (for PostgreSQL HA)
