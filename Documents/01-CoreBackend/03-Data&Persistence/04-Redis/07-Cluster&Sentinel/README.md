# Redis Cluster & Sentinel - Curriculum

## Module 1: Redis Sentinel (High Availability)
- [ ] Problem: single Redis instance = single point of failure
- [ ] Sentinel: monitors Redis master + replicas, automatic failover
- [ ] Architecture: master + N replicas + 3+ Sentinel instances
- [ ] **Monitoring**: Sentinels ping master/replicas, detect failures
- [ ] **Automatic failover**: master down → Sentinel promotes replica → redirects clients
- [ ] **Notification**: Sentinel notifies clients of new master address
- [ ] Configuration: `sentinel monitor mymaster 127.0.0.1 6379 2` (quorum of 2)
- [ ] `sentinel down-after-milliseconds` — failure detection timeout
- [ ] `sentinel failover-timeout` — max time for failover process
- [ ] Spring Boot: `spring.redis.sentinel.master`, `spring.redis.sentinel.nodes`
- [ ] Sentinel does NOT shard data — all data on master, replicas are copies

## Module 2: Redis Replication
- [ ] Master-replica replication: master handles writes, replicas handle reads
- [ ] `REPLICAOF host port` — configure replica
- [ ] Asynchronous replication: replica may lag behind master
- [ ] `WAIT numreplicas timeout` — synchronous replication for specific writes
- [ ] Read from replicas: `READONLY` command, or `spring.redis.lettuce.read-from=REPLICA`
- [ ] Replication topology: chain replication (master → replica1 → replica2) to reduce master load

## Module 3: Redis Cluster (Sharding + HA)
- [ ] Redis Cluster: automatic sharding across multiple masters
- [ ] **Hash slots**: 16384 slots distributed across master nodes
  - [ ] Key → `CRC16(key) % 16384` → slot → node
- [ ] Each master owns a subset of slots + has 1+ replicas for HA
- [ ] Minimum: 3 masters + 3 replicas = 6 nodes
- [ ] **Multi-key operations**: only work if keys are on same slot
  - [ ] Hash tags: `{user:123}.profile` and `{user:123}.orders` → same slot
- [ ] `CLUSTER NODES`, `CLUSTER INFO`, `CLUSTER SLOTS` — inspect cluster state
- [ ] **MOVED redirect**: client asks wrong node → gets `MOVED slot host:port` → redirects
- [ ] **ASK redirect**: during slot migration, client follows `ASK` to new node
- [ ] Adding/removing nodes: `redis-cli --cluster add-node`, `--cluster reshard`
- [ ] Spring Boot: `spring.redis.cluster.nodes`, Lettuce/Jedis cluster support

## Module 4: Cluster vs Sentinel Decision
- [ ] **Sentinel**: HA for single-dataset Redis (all data fits in one node's memory)
  - [ ] Simpler setup, no sharding, read scaling via replicas
- [ ] **Cluster**: HA + sharding for large datasets or high write throughput
  - [ ] Data split across masters, automatic failover per shard
  - [ ] Multi-key operations limited to same hash slot
- [ ] **When Sentinel**: dataset < single node memory, read-heavy, simplicity preferred
- [ ] **When Cluster**: dataset > single node memory, write-heavy, need horizontal scaling
- [ ] **Managed Redis**: AWS ElastiCache, GCP Memorystore, Azure Cache — handles clustering for you

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Set up Sentinel with 1 master + 2 replicas + 3 Sentinels, simulate master failure |
| Module 2 | Configure read-from-replica in Spring Boot, measure read throughput improvement |
| Module 3 | Deploy 6-node Redis Cluster, observe hash slot distribution, test MOVED redirects |
| Module 4 | Design: "10GB cache" → Sentinel. "500GB dataset" → Cluster. Justify each choice |

## Key Resources
- Redis Sentinel documentation (redis.io)
- Redis Cluster specification (redis.io)
- "Redis Cluster Tutorial" — redis.io
- AWS ElastiCache documentation (for managed Redis)
