# RabbitMQ Operations & Troubleshooting - Curriculum

Day-2 operations: upgrades, alarms, partition recovery, migration, and diagnostics.

---

## Module 1: CLI Tools Reference
- [ ] **`rabbitmqctl`**: primary operations tool (Erlang RPC to node)
  - [ ] `status`, `cluster_status`, `node_health_check`
  - [ ] `list_queues`, `list_exchanges`, `list_bindings`, `list_connections`, `list_channels`
  - [ ] `add_user`, `set_permissions`, `set_policy`
  - [ ] `start_app`, `stop_app`, `reset`, `force_reset`
- [ ] **`rabbitmq-diagnostics`**: health and diagnostics
  - [ ] `status`, `server_version`, `memory_breakdown`
  - [ ] `alarms` — active alarms (memory, disk)
  - [ ] `check_port_listener`, `check_running`, `check_local_alarms`
  - [ ] `listeners` — active network listeners
  - [ ] `node_health_check` — comprehensive health probe
- [ ] **`rabbitmq-queues`**: quorum queue operations
  - [ ] `quorum_status` — quorum queue state
  - [ ] `rebalance quorum` — rebalance leaders across nodes
  - [ ] `add_member`, `delete_member`, `grow`, `shrink`
- [ ] **`rabbitmq-streams`**: stream operations
  - [ ] `add_replica`, `delete_replica`
- [ ] **`rabbitmq-plugins`**: plugin management
- [ ] **Environment variables**: `RABBITMQ_NODENAME`, `RABBITMQ_NODE_IP_ADDRESS`

## Module 2: Alarms & Flow Control
- [ ] **Memory alarm**: broker memory usage > `vm_memory_high_watermark` (default 0.4 of RAM)
  - [ ] Effect: ALL publishers are blocked
  - [ ] Consumers continue to drain queues
  - [ ] Recovery: reduce memory usage, consumers catch up, alarm clears
- [ ] **Disk alarm**: free disk space < `disk_free_limit` (default 50MB or 2GB depending on version)
  - [ ] Effect: ALL publishers are blocked
  - [ ] Prevent broker from running out of disk
  - [ ] Recovery: free disk space, alarm clears
- [ ] **Checking alarms**:
  - [ ] `rabbitmq-diagnostics alarms`
  - [ ] Management UI → Overview → Nodes (red warning icon)
  - [ ] Prometheus metric: `rabbitmq_alarms_memory_used`
- [ ] **Flow control**: per-connection blocking (not an alarm, but similar symptom)
  - [ ] Slow queues cause publishers to be slowed down (not blocked entirely)
  - [ ] Monitor `connection.flow` state
- [ ] **Publisher behavior during alarm**:
  - [ ] AMQP `connection.blocked` frame sent to client
  - [ ] Client library pauses publishing
  - [ ] On alarm clear: `connection.unblocked` → resume

## Module 3: Memory Issues & Troubleshooting
- [ ] **High memory causes**:
  - [ ] Long queue depth (many unconsumed messages)
  - [ ] Many connections/channels
  - [ ] Large messages (whole message held in memory)
  - [ ] Message store (persistent messages in cache)
  - [ ] Mnesia (metadata for millions of queues)
- [ ] **Diagnosis**: `rabbitmq-diagnostics memory_breakdown`
  - [ ] Shows where memory is going (queue_index, queues, connections, mnesia, binary, etc.)
- [ ] **Remediation**:
  - [ ] Scale consumers to drain queues
  - [ ] Add length limits (`x-max-length`)
  - [ ] Enable lazy queues (Classic only, deprecated for Quorum)
  - [ ] Reduce prefetch on consumers
  - [ ] Close idle connections
- [ ] **Preventive**:
  - [ ] Queue length limits
  - [ ] Connection limits per vhost (`max-connections`)
  - [ ] Monitoring with alerts before hitting watermark

## Module 4: Network Partition Handling
- [ ] **Network partition**: cluster split into groups that can't reach each other
- [ ] **Problem**: Mnesia splits → metadata diverges
- [ ] **Partition handling strategies**:
  - [ ] `pause_minority` (recommended): minority side stops accepting traffic
    - [ ] 3-node cluster, 1 node partitioned → that 1 node pauses
    - [ ] Majority continues serving
  - [ ] `autoheal`: automatically rebuild by restarting minority nodes
    - [ ] Simpler but can lose data
  - [ ] `ignore`: do nothing (split brain, bad idea)
- [ ] **Configuration**: `cluster_partition_handling = pause_minority`
- [ ] **Recovery**:
  - [ ] Network restored
  - [ ] Paused nodes restart and rejoin
  - [ ] Quorum queues re-elect leaders automatically
- [ ] **Detection**: `rabbitmqctl cluster_status` shows partitions
- [ ] **Quorum queues and streams**: tolerate partitions better (Raft consensus)

## Module 5: Upgrade Strategies
- [ ] **Rolling upgrade**: upgrade one node at a time, zero downtime
  - [ ] Supported between compatible versions
  - [ ] Order matters: upgrade feature-flag-enabled nodes last
- [ ] **Feature flags**:
  - [ ] New features require explicit enabling
  - [ ] `rabbitmqctl enable_feature_flag <flag>`
  - [ ] Ensures all cluster nodes support the feature before enabling
- [ ] **Blue-green upgrade**: spin up new cluster, migrate workload, shut down old
  - [ ] Safer for major version upgrades
  - [ ] Uses Shovel or Federation to replicate
- [ ] **Before upgrade**:
  - [ ] Review release notes for breaking changes
  - [ ] Backup Mnesia and message store
  - [ ] Test upgrade in staging first
  - [ ] Check feature flag compatibility
- [ ] **During upgrade**:
  - [ ] One node at a time: stop → upgrade → start → wait for cluster_status OK
  - [ ] Monitor cluster health between nodes
- [ ] **After upgrade**:
  - [ ] Enable new feature flags
  - [ ] Verify producers/consumers still work
  - [ ] Check for deprecation warnings in logs

## Module 6: Migration: Classic Mirrored → Quorum Queues
- [ ] **Why migrate**: classic mirrored queues are deprecated in 3.13+
- [ ] **Quorum queues are better**: stronger consistency, faster failover, less complex
- [ ] **Migration strategies**:
  - [ ] **Strategy 1: Declare new queue**
    - [ ] Create new queue with `x-queue-type: quorum`
    - [ ] Switch producers to new queue
    - [ ] Drain old queue with existing consumers
    - [ ] Delete old queue
  - [ ] **Strategy 2: Shovel-based migration**
    - [ ] Create quorum queue alongside classic mirrored
    - [ ] Shovel messages from old to new
    - [ ] Switch consumers to new queue
    - [ ] Switch producers to new queue
    - [ ] Delete old queue
  - [ ] **Strategy 3: Blue-green cluster**
    - [ ] New cluster with quorum queues
    - [ ] Federate from old to new
    - [ ] Migrate apps gradually
- [ ] **Gotchas**:
  - [ ] Quorum queues don't support priority, exclusive, or transient
  - [ ] Some queue args differ
  - [ ] Test thoroughly in staging

## Module 7: Common Production Issues
- [ ] **Issue 1: Queue depth growing**
  - [ ] Symptom: monitoring shows queue depth increasing
  - [ ] Causes: slow consumers, consumer down, downstream failure, spike in producers
  - [ ] Fix: scale consumers, restart stuck consumer, identify upstream cause
- [ ] **Issue 2: Consumer churn / repeated rebalancing**
  - [ ] Symptom: consumers reconnecting frequently
  - [ ] Causes: heartbeat too aggressive, network issues, OOM, channel errors
  - [ ] Fix: tune heartbeat, fix underlying crash
- [ ] **Issue 3: Broker OOM crash**
  - [ ] Symptom: broker killed by OS OOM killer
  - [ ] Causes: unbounded queues, memory leak, insufficient RAM
  - [ ] Fix: queue length limits, more RAM, investigate memory_breakdown
- [ ] **Issue 4: Messages stuck in unacked state**
  - [ ] Symptom: unacked count grows, delivery doesn't advance
  - [ ] Causes: consumer hung, slow processing, too-high prefetch
  - [ ] Fix: reduce prefetch, investigate consumer, kill and restart
- [ ] **Issue 5: Publisher connection blocked**
  - [ ] Symptom: `connection.blocked` frame, publishing slow/paused
  - [ ] Causes: memory alarm, disk alarm, flow control
  - [ ] Fix: check alarms, drain queues, add disk
- [ ] **Issue 6: Cluster split-brain after partition**
  - [ ] Symptom: nodes show different metadata
  - [ ] Causes: `ignore` partition strategy, network issues
  - [ ] Fix: change to `pause_minority`, restart minority side
- [ ] **Issue 7: Slow or blocked quorum queue leader**
  - [ ] Causes: disk issue, network issue, overloaded node
  - [ ] Fix: `rabbitmq-queues rebalance quorum` to move leader

## Module 8: Operational Runbook & Best Practices
- [ ] **Daily monitoring checklist**:
  - [ ] Cluster status (all nodes up)
  - [ ] Queue depths (no unexpected growth)
  - [ ] Memory/disk headroom
  - [ ] Alarm status
  - [ ] Consumer lag (application-level metric)
- [ ] **Log analysis**:
  - [ ] Location: `/var/log/rabbitmq/`
  - [ ] Key patterns: `ERROR`, `CRASH REPORT`, `Memory alarm`, `partition`
  - [ ] Forward to central logging (ELK, Splunk)
- [ ] **Backup strategy**:
  - [ ] Definitions export: `rabbitmqctl export_definitions` (topology)
  - [ ] Message store: filesystem snapshots (while broker stopped for consistency)
  - [ ] Don't rely on broker as primary storage — use it as transport
- [ ] **Best practices**:
  - [ ] Always use queue length limits
  - [ ] Always use manual ack (not auto-ack) for important work
  - [ ] Use publisher confirms for durable workloads
  - [ ] Set up monitoring BEFORE going to production
  - [ ] Practice failover/DR drills quarterly
  - [ ] Keep up with RabbitMQ releases (security patches)
  - [ ] Use quorum queues, not classic mirrored
  - [ ] Test upgrades in staging first

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Run 10 `rabbitmq-diagnostics` commands, understand output |
| Module 2 | Trigger memory alarm by publishing without consumers, observe blocking |
| Module 3 | Run `memory_breakdown`, identify top memory consumers |
| Module 4 | Simulate network partition with iptables, test `pause_minority` |
| Module 5 | Practice rolling upgrade on 3-node Docker cluster |
| Module 6 | Migrate a classic mirrored queue to quorum queue |
| Module 7 | Reproduce and fix 3 common issues from the list |
| Module 8 | Write operational runbook for your RabbitMQ deployment |

## Key Resources
- rabbitmq.com/admin-guide.html (official admin guide)
- rabbitmq.com/monitoring.html
- rabbitmq.com/upgrade.html
- rabbitmq.com/partitions.html
- rabbitmq.com/production-checklist.html
- "RabbitMQ in Depth" — Chapters 9-11
- CloudAMQP operational blog posts
