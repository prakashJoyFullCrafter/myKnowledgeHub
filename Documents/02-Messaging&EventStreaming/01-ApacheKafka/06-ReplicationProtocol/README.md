# Kafka Replication Protocol - Curriculum

Deep dive into how Kafka replicates data safely and elects leaders — the protocol that determines durability and availability guarantees.

---

## Module 1: Replica Roles & Terminology
- [ ] **Replica**: copy of a partition stored on a broker
- [ ] **Leader**: the ONE replica handling all reads and writes for a partition
- [ ] **Follower**: replica that fetches from leader, serves as failover
- [ ] **Assigned Replicas (AR)**: all replicas for a partition (static configuration)
- [ ] **ISR (In-Sync Replicas)**: subset of AR that is caught up with leader
- [ ] **OSR (Out-of-Sync Replicas)**: replicas that have fallen behind
- [ ] Replicas are balanced across brokers by controller (roughly equal leader count per broker)

## Module 2: Log End Offset (LEO) & High Watermark (HW)
- [ ] **Log End Offset (LEO)**: offset of the next record to be appended to a replica's log
  - [ ] Each replica has its own LEO (leader's LEO advances first)
- [ ] **High Watermark (HW)**: highest offset that has been replicated to all ISR
  - [ ] `HW = min(LEO of all ISR)`
  - [ ] Consumers can only read up to HW — anything beyond is "uncommitted"
- [ ] **Why HW exists**: ensures consumers only see data that survives leader failure
- [ ] **HW advancement**: leader tracks follower fetch offsets, advances HW when all ISR caught up
- [ ] HW is propagated to followers via fetch response (they learn the HW from leader)

## Module 3: Follower Fetch Protocol
- [ ] **Followers are active pullers** — they fetch from leader (not push)
- [ ] **Fetch request flow**:
  1. [ ] Follower sends FetchRequest with its current LEO
  2. [ ] Leader responds with records starting from LEO
  3. [ ] Follower appends to its own log → updates its LEO
  4. [ ] Next fetch request signals new LEO → leader tracks this
- [ ] **Fetch sessions** (KIP-227): incremental fetches to reduce metadata overhead
- [ ] **`replica.fetch.min.bytes`, `replica.fetch.max.bytes`, `replica.fetch.wait.max.ms`**: follower fetch tuning
- [ ] **Idle follower**: one not fetching recently → may be evicted from ISR

## Module 4: ISR Management
- [ ] **When a follower leaves ISR**:
  - [ ] Hasn't fetched within `replica.lag.time.max.ms` (default 30s)
  - [ ] Broker down or too slow to keep up
- [ ] **When a follower rejoins ISR**:
  - [ ] Has caught up to leader's LEO (at least once)
  - [ ] Automatic — no manual intervention
- [ ] **ISR shrink/expand**: controller tracks changes, propagates metadata updates
- [ ] **Monitor**: `UnderReplicatedPartitions` metric — any > 0 is a concern
- [ ] **`min.insync.replicas`** + **`acks=all`** + `RF=3`: classic no-data-loss config
  - [ ] With `min.insync.replicas=2`, writes fail if only leader alive (refuses to accept)

## Module 5: Leader Election
- [ ] **Normal leader election** (planned):
  - [ ] Triggered by: broker shutdown, preferred leader rebalance
  - [ ] Controller picks next ISR replica, updates metadata
  - [ ] Old followers re-fetch from new leader
- [ ] **Unplanned leader election** (broker crash):
  - [ ] Controller detects via metadata timeout
  - [ ] Picks new leader from current ISR
  - [ ] Failover time: seconds (depends on session timeouts)
- [ ] **Unclean leader election** (`unclean.leader.election.enable`):
  - [ ] If ALL ISR dead, allow non-ISR replica to become leader
  - [ ] **DATA LOSS**: records written since last ISR commit are lost
  - [ ] **Default: disabled** — partition goes offline rather than lose data
  - [ ] **Trade-off**: availability vs durability
- [ ] **Preferred leader**: first replica in assignment list
  - [ ] `auto.leader.rebalance.enable=true` → periodic rebalancing to preferred

## Module 6: Leader Epoch (KIP-101)
- [ ] **The problem it solves**: log divergence after leader changes
  - [ ] Old leader may have records new leader doesn't know about
  - [ ] Using HW alone → data loss in specific scenarios
- [ ] **Leader epoch**: monotonically increasing number, bumped on every leader change
- [ ] Each record batch is tagged with the leader epoch at write time
- [ ] **Leader epoch cache**: broker stores (epoch, starting_offset) mappings
- [ ] **OffsetForLeaderEpoch API**: follower asks leader "what was my last offset in epoch X?"
  - [ ] If mismatch → truncate follower's log to correct point
- [ ] **Result**: no more log divergence, no data loss in leader-failover edge cases
- [ ] Critical for: rolling restarts, unclean shutdowns, network partitions

## Module 7: Controller (KRaft) & Metadata Management
- [ ] **Controller**: special broker(s) managing cluster metadata
- [ ] **Old**: ZooKeeper-based controller (one elected broker)
- [ ] **New (KRaft, Kafka 3.3+ production-ready)**:
  - [ ] Controllers form a Raft quorum (3 or 5 nodes)
  - [ ] Metadata stored in `__cluster_metadata` topic (self-hosted)
  - [ ] Faster failover (no ZK session timeouts)
  - [ ] Supports larger clusters (millions of partitions)
- [ ] **Controller responsibilities**:
  - [ ] Broker membership tracking
  - [ ] Leader election on broker failure
  - [ ] Partition state management
  - [ ] Metadata propagation to all brokers
- [ ] **Metadata propagation**: brokers fetch metadata updates from controller via metadata log

## Module 8: Durability Guarantees & Failure Modes
- [ ] **Strongest durability config**:
  - [ ] `replication.factor=3`
  - [ ] `min.insync.replicas=2`
  - [ ] Producer `acks=all` + `enable.idempotence=true`
  - [ ] `unclean.leader.election.enable=false`
- [ ] **What this guarantees**:
  - [ ] No data loss if single broker fails
  - [ ] No duplicates via idempotence
  - [ ] Partition goes offline rather than losing data (availability sacrificed)
- [ ] **Failure scenarios**:
  - [ ] Single broker down → leader re-election, no loss
  - [ ] Two brokers down (RF=3) → partition degraded, still writable if ISR ≥ 2
  - [ ] All ISR down → partition offline (unless unclean election enabled)
  - [ ] Network partition → minority side rejects writes (controller quorum)
- [ ] **Durability vs availability**: always understand which side of CAP you're choosing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Inspect replica LEO and HW via `kafka-log-dirs.sh` and JMX metrics |
| Module 3 | Monitor follower fetch behavior with JMX, observe fetch requests |
| Module 4 | Throttle a follower's network, watch it fall out of ISR |
| Module 5 | Kill leader broker, measure failover time for leader re-election |
| Module 6 | Force unclean leader election scenario, observe data loss |
| Module 7 | Deploy KRaft cluster (no ZooKeeper), observe metadata propagation |
| Module 8 | Test partition behavior with RF=3, min.isr=2 when losing 1, 2, 3 brokers |

## Key Resources
- KIP-101: Alter Replication Protocol to use Leader Epoch
- KIP-500: Replace ZooKeeper with a Self-Managed Metadata Quorum (KRaft)
- "Kafka Replication Protocol" — Apache Kafka design docs
- "Hardening Kafka Replication" — LinkedIn engineering blog
- Kafka: The Definitive Guide — Chapter 6 (Reliable Data Delivery)
