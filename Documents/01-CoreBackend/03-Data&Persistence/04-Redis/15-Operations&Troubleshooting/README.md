# Redis Operations & Troubleshooting - Curriculum

Day-2 operations: monitoring, troubleshooting, capacity planning, and incident response for production Redis.

---

## Module 1: INFO Command Deep Dive
- [ ] **`INFO`**: comprehensive server information grouped into sections
- [ ] **Sections**:
  - [ ] `server` — version, uptime, OS
  - [ ] `clients` — connected clients, blocked clients, max buffer
  - [ ] `memory` — used, rss, peak, fragmentation, policy
  - [ ] `persistence` — RDB/AOF state, fork times
  - [ ] `stats` — ops/sec, keyspace hits/misses, expired/evicted counts
  - [ ] `replication` — role, replicas, offset, lag
  - [ ] `cpu` — CPU used by server/children
  - [ ] `commandstats` — per-command call count, usec, msec
  - [ ] `latencystats` — per-command latency histogram
  - [ ] `keyspace` — db0, db1... key counts, avg TTL
- [ ] **Targeted query**: `INFO memory`, `INFO replication`
- [ ] **Parse programmatically**: key-value pairs, easy to consume
- [ ] **Automation**: scrape INFO for monitoring and alerting

## Module 2: Key Metrics to Monitor
- [ ] **Latency**:
  - [ ] `redis-cli --latency` (intrinsic)
  - [ ] `LATENCY LATEST`
  - [ ] p50, p95, p99 command latency
- [ ] **Throughput**:
  - [ ] `instantaneous_ops_per_sec`
  - [ ] `total_commands_processed`
- [ ] **Memory**:
  - [ ] `used_memory`, `used_memory_rss`, `used_memory_peak`
  - [ ] `mem_fragmentation_ratio`
  - [ ] `maxmemory` headroom
- [ ] **Hit ratio** (for caches):
  - [ ] `keyspace_hits`, `keyspace_misses`
  - [ ] ratio = hits / (hits + misses)
- [ ] **Persistence**:
  - [ ] `rdb_last_bgsave_status`, `rdb_last_bgsave_time_sec`
  - [ ] `aof_last_write_status`
  - [ ] Loading state (startup)
- [ ] **Replication**:
  - [ ] Master: `connected_slaves`, `master_repl_offset`
  - [ ] Replica: `master_link_status`, `master_last_io_seconds_ago`, `master_sync_in_progress`
- [ ] **Evictions**:
  - [ ] `evicted_keys` — count
  - [ ] Growing rate = memory pressure
- [ ] **Connections**:
  - [ ] `connected_clients`, `blocked_clients`
  - [ ] `rejected_connections` (over maxclients)

## Module 3: Monitoring Tools
- [ ] **Prometheus + redis_exporter**:
  - [ ] oliver006/redis_exporter — most popular
  - [ ] Exposes Redis metrics in Prometheus format
  - [ ] Supports cluster, sentinel, multi-instance
- [ ] **Grafana dashboards**:
  - [ ] Redis official dashboard (ID 763)
  - [ ] Redis Cluster dashboard (ID 11692)
- [ ] **RedisInsight**: official GUI with real-time metrics
- [ ] **DataDog / New Relic / cloud-native**: integrated Redis monitoring
- [ ] **`redis-cli --stat`**: live per-second stats in terminal
- [ ] **`redis-cli --latency-history`**: historical latency sampling
- [ ] **`redis-cli --bigkeys` / `--hotkeys` / `--memkeys`**: forensic analysis
- [ ] **MONITOR command**: NEVER use in production (huge perf impact)

## Module 4: Alerting Strategy
- [ ] **Critical alerts** (page immediately):
  - [ ] Redis down / unreachable
  - [ ] Master-replica replication broken
  - [ ] Memory > 95% of maxmemory
  - [ ] High eviction rate (unexpected for non-cache)
  - [ ] Persistence (RDB/AOF) last save failed
- [ ] **Warning alerts**:
  - [ ] Memory > 80%
  - [ ] Fragmentation ratio > 1.5
  - [ ] Replication lag growing
  - [ ] Slow log entries spiking
  - [ ] Rejected connections
  - [ ] Hit ratio dropping (for caches)
- [ ] **Informational**:
  - [ ] Throughput baseline changes
  - [ ] Unusual command patterns
- [ ] **Runbooks**: every alert must link to a runbook with diagnosis + remediation

## Module 5: Common Production Issues
- [ ] **Issue: High latency spikes**
  - [ ] Causes: big keys, expensive commands, fork during BGSAVE, swap, network
  - [ ] Diagnosis: `LATENCY DOCTOR`, slow log, `INFO stats`
  - [ ] Fix: eliminate big keys, tune fork timing, disable swap, optimize network
- [ ] **Issue: Memory OOM**
  - [ ] Causes: unbounded keyspace, no eviction policy, big keys, fragmentation
  - [ ] Diagnosis: `MEMORY STATS`, `--bigkeys`, check maxmemory
  - [ ] Fix: set eviction policy, find big keys, enable activedefrag, scale up
- [ ] **Issue: Consumer lag growing**
  - [ ] Causes: slow consumer, downstream bottleneck, hot partition
  - [ ] Diagnosis: per-consumer lag metrics, consumer logs
  - [ ] Fix: scale consumers, optimize processing, fix downstream
- [ ] **Issue: Connection exhaustion**
  - [ ] Causes: too many clients, connection leak, slow clients blocking pool
  - [ ] Diagnosis: `INFO clients`, `CLIENT LIST`
  - [ ] Fix: tune maxclients, fix leak, tune connection pool
- [ ] **Issue: Replication broken**
  - [ ] Causes: network, full sync failing, replica out of sync
  - [ ] Diagnosis: `INFO replication` on master and replica
  - [ ] Fix: check backlog size, restart replica, investigate network
- [ ] **Issue: Slow BGSAVE / fork**
  - [ ] Causes: large dataset, huge memory, transparent huge pages
  - [ ] Fix: disable THP, use RDB preamble, increase RAM

## Module 6: Capacity Planning
- [ ] **Inputs**:
  - [ ] Dataset size (current and projected)
  - [ ] Workload type (read-heavy, write-heavy, mixed)
  - [ ] Latency requirements
  - [ ] HA needs (Sentinel vs Cluster)
  - [ ] Persistence requirements
- [ ] **Memory sizing formula**:
  - [ ] `max_memory = dataset × 1.5 (overhead) × 1.5 (headroom)`
  - [ ] Sentinel: same across replicas
  - [ ] Cluster: divide by shard count
- [ ] **CPU sizing**:
  - [ ] Single-threaded command execution — more cores help for I/O threads, children
  - [ ] 4-8 cores typical for busy production instance
- [ ] **Network**:
  - [ ] Bandwidth = ops/sec × avg response size
  - [ ] 1 Gbps OK for most, 10 Gbps for extreme throughput
- [ ] **Disk** (if persistence):
  - [ ] RDB: size of dataset × N snapshots retained
  - [ ] AOF: 1.5-3x RDB size (depends on write pattern)
  - [ ] SSDs recommended for production
- [ ] **Scaling triggers**:
  - [ ] Memory > 75%
  - [ ] CPU > 70% sustained
  - [ ] Latency degradation
  - [ ] Throughput approaching tested limit

## Module 7: Scaling Strategies
- [ ] **Vertical scaling**:
  - [ ] Bigger instance (more RAM, faster CPU)
  - [ ] Simple, works until hardware limit
  - [ ] Ceiling: ~100-500 GB RAM practical
- [ ] **Read scaling via replicas**:
  - [ ] Add read replicas, route reads to them
  - [ ] Lag tolerance required
  - [ ] Works with Sentinel
- [ ] **Horizontal scaling via Cluster**:
  - [ ] Shard data across multiple masters
  - [ ] Automatic hash-slot-based partitioning
  - [ ] Complex: multi-key operations limited, client must support cluster mode
- [ ] **Functional partitioning**:
  - [ ] Different Redis instances for different purposes (cache, session, queue)
  - [ ] Simpler than cluster, each instance focused
- [ ] **When to shard**:
  - [ ] Dataset won't fit in one instance
  - [ ] Write throughput limited by single master
  - [ ] Near single-instance ceiling

## Module 8: Backup & Restore
- [ ] **RDB snapshots**:
  - [ ] `BGSAVE` creates RDB file (fork-based)
  - [ ] Copy the file for backup
  - [ ] Simple, atomic
- [ ] **AOF backups**:
  - [ ] Copy AOF file (may need to quiesce writes for consistency)
  - [ ] `BGREWRITEAOF` compacts it first
- [ ] **Automated backup**:
  - [ ] Scheduled snapshot + copy to S3/GCS
  - [ ] Retention policy (daily × N, weekly × M, monthly × K)
  - [ ] Encryption for sensitive data
- [ ] **Restore**:
  - [ ] Stop Redis
  - [ ] Replace `dump.rdb` or `appendonly.aof` in data directory
  - [ ] Start Redis — auto-loads
- [ ] **Point-in-time recovery**: AOF with specific time (rewind AOF file — advanced)
- [ ] **Test restores regularly** — untested backups are not backups
- [ ] **Managed Redis**: AWS ElastiCache, Memorystore handle backups for you

## Module 9: Upgrades
- [ ] **Minor version upgrade** (e.g., 7.0.5 → 7.0.8):
  - [ ] Usually safe
  - [ ] Test in staging
  - [ ] Rolling restart replicas then failover master
- [ ] **Major version upgrade** (e.g., 6.x → 7.x):
  - [ ] Read release notes carefully
  - [ ] Backward compatibility mostly maintained
  - [ ] Test with production-like workload
  - [ ] Blue-green: stand up new version, replicate, switch over
- [ ] **Rolling upgrade for Sentinel setup**:
  - [ ] Upgrade all replicas
  - [ ] Trigger failover to upgraded replica
  - [ ] Upgrade old master (now replica)
- [ ] **Rolling upgrade for Cluster**:
  - [ ] Upgrade replicas, failover, upgrade old masters
  - [ ] Works for minor and compatible major versions
- [ ] **Client library compatibility**: newer Redis may add features, check client library support

## Module 10: Incident Response Runbooks
- [ ] **Runbook: Redis down**:
  1. [ ] Check process status, logs
  2. [ ] Check OS: memory, disk, CPU
  3. [ ] Check Sentinel/Cluster status
  4. [ ] Restart if safe, verify data intact
  5. [ ] Post-incident: root cause analysis
- [ ] **Runbook: High latency**:
  1. [ ] `LATENCY DOCTOR`
  2. [ ] Check slow log
  3. [ ] Check `--bigkeys` output (in test, not prod!)
  4. [ ] Check concurrent BGSAVE/BGREWRITEAOF
  5. [ ] Check fragmentation, swap
  6. [ ] Fix root cause
- [ ] **Runbook: Memory pressure**:
  1. [ ] Check eviction policy
  2. [ ] Identify big keys
  3. [ ] Check for unexpected key growth (CDC bug, loop)
  4. [ ] Scale up or enable eviction
  5. [ ] Long-term: memory optimization
- [ ] **Runbook: Failover**:
  1. [ ] Verify master is truly down (Sentinel check)
  2. [ ] Wait for automatic failover or trigger manual
  3. [ ] Verify replica promoted, clients reconnected
  4. [ ] Investigate original failure
  5. [ ] Rebuild as replica once master recovers

## Module 11: Production Checklist
- [ ] **Security**:
  - [ ] Authentication enabled (AUTH or ACL)
  - [ ] TLS for client and replication traffic
  - [ ] Network isolation (private subnet, firewall)
  - [ ] Dangerous commands disabled or renamed
- [ ] **Reliability**:
  - [ ] Persistence enabled (RDB + AOF or AOF with rewrite)
  - [ ] HA configured (Sentinel or Cluster)
  - [ ] `maxmemory` set with appropriate eviction policy
  - [ ] `min.insync.replicas` or equivalent for writes
- [ ] **Performance**:
  - [ ] Transparent Huge Pages DISABLED
  - [ ] `overcommit_memory = 1` (for fork)
  - [ ] Swap disabled or minimized
  - [ ] jemalloc in use
- [ ] **Observability**:
  - [ ] Prometheus + Grafana monitoring
  - [ ] Alerts for critical metrics
  - [ ] Slow log enabled
  - [ ] Log shipping to central store
- [ ] **Backup**:
  - [ ] Automated daily backups
  - [ ] Offsite storage
  - [ ] Restore tested regularly
- [ ] **Operations**:
  - [ ] Runbooks documented
  - [ ] On-call rotation
  - [ ] Incident response plan
  - [ ] Quarterly DR drills

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Parse INFO output, extract key metrics |
| Module 2 | Set up monitoring for 10 key metrics |
| Module 3 | Deploy Prometheus + redis_exporter + Grafana |
| Module 4 | Configure 5 critical alerts with runbook links |
| Module 5 | Reproduce 3 common issues, walk through runbooks |
| Module 6 | Capacity plan for a 100 GB dataset with HA |
| Module 7 | Compare vertical vs horizontal scaling for a given workload |
| Module 8 | Configure automated backups, test restore |
| Module 9 | Perform rolling upgrade on 3-node Sentinel setup |
| Module 10 | Write runbook for "Redis latency spike" incident |
| Module 11 | Audit a Redis deployment against the production checklist |

## Key Resources
- redis.io/docs/management/admin/
- redis.io/docs/management/optimization/
- redis.io/docs/management/upgrades/
- oliver006/redis_exporter (Prometheus exporter)
- "Redis Administration" — redis.io
- "Redis Best Practices" — redis.io
- "Troubleshooting Redis" — redis.io
