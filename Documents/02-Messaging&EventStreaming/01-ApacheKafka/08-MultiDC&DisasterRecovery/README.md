# Kafka Multi-DC & Disaster Recovery - Curriculum

How to run Kafka across multiple datacenters for high availability, geo-distribution, and disaster recovery.

---

## Module 1: Multi-DC Architectures Overview
- [ ] **Why multi-DC**: disaster recovery, geo-distribution, regulatory, migration
- [ ] **Three main approaches**:
  - [ ] **Stretched cluster**: one cluster spanning multiple DCs (low latency required)
  - [ ] **Cluster replication**: separate clusters, replicate data between them (MirrorMaker 2, Cluster Linking)
  - [ ] **Cluster linking** (Confluent): byte-for-byte replication preserving offsets
- [ ] **Stretched cluster trade-offs**:
  - [ ] Pros: transparent failover, active-active reads
  - [ ] Cons: cross-DC latency on every write, requires <50ms network, ISR complications
- [ ] **Replicated clusters trade-offs**:
  - [ ] Pros: independent clusters, tolerates high latency
  - [ ] Cons: asynchronous (data loss possible), failover complexity
- [ ] **Rule**: for <50ms latency DCs → stretched possible; otherwise → replicated

## Module 2: MirrorMaker 2 (MM2)
- [ ] **MM2 = Kafka Connect + custom connectors** for cross-cluster replication
- [ ] **Components**:
  - [ ] MirrorSourceConnector: replicates topics from source to target
  - [ ] MirrorCheckpointConnector: translates consumer offsets (source → target)
  - [ ] MirrorHeartbeatConnector: monitors replication health
- [ ] **Topic renaming**: `<source-alias>.<topic>` in target cluster (avoid loops)
- [ ] **Replication flows**: one-way, two-way, hub-spoke, fan-out
- [ ] **Configuration**:
  - [ ] `clusters=source,target`
  - [ ] `source->target.enabled=true`
  - [ ] `topics=.*` (regex for topic selection)
  - [ ] `sync.topic.configs.enabled=true`
- [ ] **Deployment modes**:
  - [ ] Dedicated MM2 cluster (standalone)
  - [ ] On existing Kafka Connect cluster
- [ ] **Operational considerations**: lag monitoring, bandwidth planning, broker impact

## Module 3: Replication Lag & Offset Translation
- [ ] **Replication lag**: delay between source write and target write
  - [ ] Causes: network bandwidth, MM2 worker count, target cluster speed
  - [ ] Monitor: `MirrorSourceConnector` metrics, consumer lag on internal topics
- [ ] **Offset mismatch problem**:
  - [ ] Source topic offset ≠ target topic offset (different ordering, partition skew)
  - [ ] Consumers that switch clusters need translated offsets
- [ ] **Offset translation** (MM2):
  - [ ] MirrorCheckpointConnector maintains (source offset → target offset) mappings
  - [ ] Stored in `<source>.checkpoints.internal` topic
  - [ ] `RemoteClusterUtils.translateOffsets()` — API to get translated offsets
  - [ ] Approximation: may have small gaps, re-consume or skip a few records
- [ ] **Cluster Linking advantage**: byte-for-byte replication → offsets preserved identically
  - [ ] Consumers switch clusters without offset translation

## Module 4: Disaster Recovery Strategies
- [ ] **RPO (Recovery Point Objective)**: how much data can you lose?
  - [ ] Async replication → RPO = replication lag (seconds to minutes)
  - [ ] Sync replication → RPO = 0 but latency cost
- [ ] **RTO (Recovery Time Objective)**: how fast must you recover?
  - [ ] Automated failover: seconds-to-minutes
  - [ ] Manual failover: minutes-to-hours
- [ ] **DR topologies**:
  - [ ] **Active-passive**: primary writes, DR cluster is standby
  - [ ] **Active-active**: both clusters accept writes (conflict risk!)
  - [ ] **Hub-spoke**: central cluster + regional spokes
- [ ] **Failover steps** (active-passive):
  1. [ ] Detect primary DC failure (automation or manual)
  2. [ ] Redirect producers to DR cluster
  3. [ ] Translate consumer offsets to DR cluster
  4. [ ] Restart consumers pointing to DR cluster
- [ ] **Failback** (return to primary): replicate DR → primary, switch over

## Module 5: Active-Active Multi-DC
- [ ] **Active-active**: both clusters accept writes for same topics
- [ ] **Cycle prevention**: MM2 renames topics to avoid infinite replication loops
  - [ ] DC1 writes `orders` → replicated as `dc1.orders` in DC2
  - [ ] DC2 consumers read both `orders` (local) and `dc1.orders` (remote)
- [ ] **Conflict handling**: no automatic resolution in Kafka
  - [ ] Use different key spaces per DC (user_id routing)
  - [ ] Accept eventual consistency for merged topics
- [ ] **Use case**: geo-distributed apps (US users in US DC, EU users in EU DC)
- [ ] **Complexity**: monitoring, consumer configuration, conflict resolution — only when needed

## Module 6: Cluster Linking (Confluent)
- [ ] **Confluent-only feature** (not Apache Kafka)
- [ ] **Byte-for-byte replication**: no re-encoding, no offset translation needed
- [ ] **Mirror topics**: destination topic is read-only, offsets match source exactly
- [ ] **Advantages over MM2**:
  - [ ] No connect cluster needed (built into brokers)
  - [ ] Offsets preserved exactly → seamless consumer failover
  - [ ] Lower latency, less operational overhead
  - [ ] Schema Registry replication built-in
- [ ] **Use cases**: cluster migration, DR, hybrid cloud
- [ ] **Limitations**: commercial only, one-directional mirror topics (must be promoted to become writable)

## Module 7: Backup & Restore
- [ ] **Kafka is NOT designed as a backup system** — replication ≠ backup
- [ ] **Problem**: replication copies corruptions and deletions
- [ ] **Approaches**:
  - [ ] **Replicate to DR cluster** (RPO-focused, not true backup)
  - [ ] **Sink to object storage**: Kafka Connect S3 Sink → S3 → Glacier
  - [ ] **Tiered storage**: old segments in S3 (KIP-405)
  - [ ] **Snapshot brokers** (file-level): filesystem snapshots, cluster-consistent is hard
- [ ] **Point-in-time recovery**:
  - [ ] S3 archive → replay via Kafka Connect source
  - [ ] Expensive and slow, but ultimate DR
- [ ] **What to back up**:
  - [ ] Topic data (events)
  - [ ] Topic configurations
  - [ ] ACLs
  - [ ] Schema Registry schemas
  - [ ] Consumer group offsets
- [ ] **Test restores regularly** — untested backups are not backups

## Module 8: Operations & Runbooks
- [ ] **Monitoring replication**:
  - [ ] MM2 connector status (running, paused, failed)
  - [ ] Replication lag per topic (source LEO - target LEO)
  - [ ] MM2 worker health (Connect task status)
- [ ] **Alerting**:
  - [ ] Replication lag > threshold
  - [ ] Connector failure
  - [ ] Checkpoint gaps (offset translation broken)
- [ ] **Runbook: Failover to DR**:
  1. [ ] Assess primary status (is it really down?)
  2. [ ] Stop producers pointing to primary
  3. [ ] Translate consumer offsets via MM2 checkpoint
  4. [ ] Restart consumers with DR bootstrap servers
  5. [ ] Restart producers with DR bootstrap servers
  6. [ ] Monitor DR cluster health
  7. [ ] Plan failback when primary recovers
- [ ] **Regular drills**: test failover quarterly, measure actual RTO

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare stretched vs replicated cluster for 2 DCs with 80ms latency — justify choice |
| Module 2 | Deploy MM2 between 2 local Kafka clusters (Docker), replicate a topic |
| Module 3 | Observe offset translation via RemoteClusterUtils during active replication |
| Module 4 | Document RPO/RTO targets for a fictional fintech system |
| Module 5 | Set up active-active MM2, observe topic renaming and consumer config |
| Module 6 | Compare MM2 vs Cluster Linking features (read documentation) |
| Module 7 | Implement S3 sink backup, test restore via source connector |
| Module 8 | Write DR runbook, execute failover drill end-to-end |

## Key Resources
- KIP-382: MirrorMaker 2.0
- "MirrorMaker 2.0 in Action" — Confluent blog
- Confluent Cluster Linking documentation
- "Multi-Region Kafka Deployments" — Confluent whitepaper
- "Disaster Recovery for Apache Kafka" — Confluent blog series
