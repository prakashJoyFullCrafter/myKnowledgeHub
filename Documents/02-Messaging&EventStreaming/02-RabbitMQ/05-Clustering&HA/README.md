# RabbitMQ Clustering & High Availability - Curriculum

## Module 1: RabbitMQ Clustering
- [ ] **Cluster**: multiple RabbitMQ nodes sharing users, vhosts, exchanges, bindings, policies
- [ ] **Queues are NOT replicated by default** — only metadata (exchanges, bindings) is shared across nodes
- [ ] Node types: disc nodes (persist metadata to disk) vs RAM nodes (metadata in memory only)
- [ ] Cluster formation: `rabbitmqctl join_cluster rabbit@node1`
- [ ] Peer discovery: manual, DNS, AWS, Kubernetes, Consul, etcd
- [ ] Erlang cookie: shared secret for node authentication
- [ ] Cluster network partition handling: `pause_minority`, `autoheal`, `ignore`

## Module 2: Quorum Queues (Recommended for HA)
- [ ] **Quorum queues** (RabbitMQ 3.8+): Raft-based replicated queues — the modern HA solution
- [ ] Replicated across N nodes (typically 3 or 5), leader + followers
- [ ] **Leader** handles all operations, **followers** replicate
- [ ] Automatic leader election on node failure
- [ ] Declaration: `x-queue-type: quorum` argument
- [ ] Quorum queue vs classic mirrored queue: quorum is safer, faster failover, recommended
- [ ] Limitations: no non-durable messages, no `exclusive`, no `global QoS`
- [ ] Poison message handling: `x-delivery-limit` — requeue limit before dead-lettering

## Module 3: Classic Mirrored Queues (Legacy)
- [ ] **Mirrored queues** (deprecated in 3.13+): policy-based replication
- [ ] `ha-mode: all` — mirror to all nodes (high overhead)
- [ ] `ha-mode: exactly`, `ha-params: 2` — mirror to N nodes
- [ ] `ha-sync-mode: automatic` — sync new mirrors automatically
- [ ] Why deprecated: complex, split-brain prone, slower than quorum queues
- [ ] **Migration path**: classic mirrored → quorum queues

## Module 4: Streams (Append-Only Log)
- [ ] **RabbitMQ Streams** (3.9+): Kafka-like append-only log on RabbitMQ
- [ ] Replicated, persistent, supports replay from offset
- [ ] Declaration: `x-queue-type: stream` argument
- [ ] Consumers: `x-stream-offset: first | last | timestamp | offset`
- [ ] Use cases: replay, audit log, event sourcing — when you want Kafka-like behavior without Kafka
- [ ] Streams vs Quorum Queues: streams for replay/log, quorum for traditional messaging

## Module 5: Operations & Monitoring
- [ ] **RabbitMQ Management Plugin**: web UI on port 15672
  - [ ] Overview: connections, channels, queues, exchanges, message rates
  - [ ] Per-queue: depth, message rates, consumer count, memory usage
- [ ] **CLI tools**: `rabbitmqctl`, `rabbitmq-diagnostics`, `rabbitmq-queues`
- [ ] **Key metrics to monitor**:
  - [ ] Queue depth (messages ready + unacknowledged)
  - [ ] Message rates (publish, deliver, acknowledge)
  - [ ] Consumer count and utilization
  - [ ] Node memory and disk usage
  - [ ] Connection and channel count
- [ ] **Prometheus integration**: `rabbitmq_prometheus` plugin → Grafana dashboards
- [ ] **Alarms**: memory alarm (publisher blocked), disk alarm (all publishing stops)
- [ ] **Shovel & Federation**: replicate messages between clusters / data centers
  - [ ] Shovel: reliable message forwarding between brokers
  - [ ] Federation: link exchanges/queues across clusters (multi-DC)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Deploy 3-node RabbitMQ cluster with Docker Compose |
| Module 2 | Create quorum queue, kill a node, observe automatic failover |
| Module 3 | Migrate a classic mirrored queue to quorum queue |
| Module 4 | Create a stream, publish events, replay from offset |
| Module 5 | Set up Prometheus + Grafana monitoring, alert on queue depth |

## Key Resources
- RabbitMQ Clustering Guide (rabbitmq.com/clustering)
- RabbitMQ Quorum Queues documentation
- RabbitMQ Streams documentation
- "RabbitMQ in Depth" - Gavin Roy
