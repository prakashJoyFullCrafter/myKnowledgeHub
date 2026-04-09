# Kafka Cluster & Operations - Curriculum

## Module 1: Kafka Architecture
- [ ] **Broker**: single Kafka server that stores data and serves clients
- [ ] **Cluster**: multiple brokers working together
- [ ] **Controller**: one broker elected as controller — manages partition leaders, broker membership
- [ ] **ZooKeeper** (legacy): metadata storage, broker coordination, leader election
- [ ] **KRaft** (Kafka 3.3+ production-ready): replace ZooKeeper with Kafka's own Raft consensus
  - [ ] KRaft benefits: simpler operations, faster failover, no ZooKeeper dependency
  - [ ] Migration: ZooKeeper → KRaft migration path
- [ ] Minimum production cluster: 3 brokers (for replication factor 3)

## Module 2: Replication & Fault Tolerance
- [ ] **Replication factor**: number of copies of each partition (typically 3)
- [ ] **Leader replica**: handles all reads and writes for a partition
- [ ] **Follower replicas**: passively replicate from leader
- [ ] **ISR (In-Sync Replicas)**: followers that are caught up with leader
  - [ ] `min.insync.replicas=2` + `acks=all` → no data loss even if one broker dies
- [ ] **Unclean leader election**: allow out-of-sync replica to become leader (data loss risk)
  - [ ] `unclean.leader.election.enable=false` (recommended for data safety)
- [ ] Broker failure: partition leaders re-elected from ISR automatically
- [ ] Rack awareness: spread replicas across racks/AZs for fault tolerance

## Module 3: Topic Management
- [ ] `kafka-topics.sh --create --topic orders --partitions 12 --replication-factor 3`
- [ ] `kafka-topics.sh --describe --topic orders` — view partition assignments
- [ ] Partition count: cannot decrease, can only increase (but breaks key ordering!)
- [ ] **Log retention**: `retention.ms` (time-based), `retention.bytes` (size-based)
- [ ] **Log compaction**: `cleanup.policy=compact` — keep latest value per key
  - [ ] Use case: changelog topics, KTable backing, current state snapshots
- [ ] **Log segments**: partition split into segment files, configurable size/time
- [ ] Topic configs: per-topic override via `kafka-configs.sh`
- [ ] `__consumer_offsets` — internal topic for consumer offset storage

## Module 4: Performance Tuning
- [ ] **Producer tuning**:
  - [ ] `batch.size` + `linger.ms` — batch messages for throughput
  - [ ] `compression.type=lz4` or `zstd` — reduce network and disk I/O
  - [ ] `buffer.memory` — producer buffer size before blocking
  - [ ] `acks=all` for durability, `acks=1` for lower latency
- [ ] **Consumer tuning**:
  - [ ] `fetch.min.bytes` + `fetch.max.wait.ms` — batch fetching
  - [ ] `max.poll.records` — limit records per poll (avoid long processing)
  - [ ] `max.poll.interval.ms` — max time between polls before rebalance
  - [ ] `session.timeout.ms` — failure detection speed
- [ ] **Broker tuning**:
  - [ ] `num.io.threads`, `num.network.threads` — I/O and network thread pools
  - [ ] `log.flush.interval.messages`, `log.flush.interval.ms` — disk flush frequency
  - [ ] OS tuning: page cache, disk I/O scheduler, file descriptors

## Module 5: Monitoring & Operations
- [ ] **Key metrics to monitor**:
  - [ ] Under-replicated partitions (broker falling behind)
  - [ ] Active controller count (exactly 1 expected)
  - [ ] Consumer lag (latest offset - committed offset)
  - [ ] Request latency (produce, fetch)
  - [ ] Disk usage per broker
  - [ ] ISR shrink/expand rate
- [ ] **Tools**:
  - [ ] `kafka-consumer-groups.sh --describe` — view consumer lag
  - [ ] Kafka Manager / AKHQ / Kafdrop — web UI for cluster management
  - [ ] Prometheus + JMX Exporter → Grafana dashboards
  - [ ] Confluent Control Center (commercial)
  - [ ] Burrow (LinkedIn) — consumer lag monitoring
- [ ] **Operational tasks**:
  - [ ] Rolling restart: restart brokers one at a time (zero downtime)
  - [ ] Partition reassignment: rebalance data across brokers after adding nodes
  - [ ] Broker decommission: reassign partitions before removing broker
  - [ ] Upgrading Kafka: rolling upgrade with inter-broker protocol version
- [ ] **Security**:
  - [ ] SSL/TLS encryption for data in transit
  - [ ] SASL authentication (SCRAM, Kerberos, OAUTHBEARER)
  - [ ] ACLs: `kafka-acls.sh` — per-topic, per-group permissions

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Deploy 3-broker Kafka cluster with KRaft (Docker Compose) |
| Module 2 | Kill a broker, observe automatic leader election and recovery |
| Module 3 | Configure log compaction on a topic, observe key-based retention |
| Module 4 | Benchmark: tune batch.size + linger.ms, measure throughput improvement |
| Module 5 | Set up Prometheus + Grafana dashboard for Kafka, alert on consumer lag |

## Key Resources
- Apache Kafka documentation (kafka.apache.org)
- Kafka: The Definitive Guide — Neha Narkhede, Gwen Shapira, Todd Palino
- Confluent blog — operational best practices
- "Monitoring Kafka" — Datadog guide
