# RabbitMQ Federation & Multi-DC - Curriculum

How to replicate messages across clusters and datacenters — federation, shovel, and multi-DC topologies.

---

## Module 1: Why Federation & Shovel?
- [ ] **Clustering limitations**:
  - [ ] All cluster nodes must have low-latency connection (< 10ms ideal)
  - [ ] WAN latency breaks Mnesia replication
  - [ ] Cannot span datacenters safely
- [ ] **Federation and Shovel bridge brokers across WANs**:
  - [ ] Async replication
  - [ ] Tolerant of high latency
  - [ ] Survive network partitions
- [ ] **Use cases**:
  - [ ] Multi-DC deployment (US + EU)
  - [ ] DR (primary + standby cluster)
  - [ ] Cloud migration (on-prem → cloud)
  - [ ] Hybrid topologies (edge → central)
- [ ] **Federation vs Shovel — choose one**:
  - [ ] Federation: config-driven, exchange/queue level, self-healing
  - [ ] Shovel: simpler, link-based, more flexible routing

## Module 2: Federation Plugin
- [ ] **Federation**: link upstream exchanges/queues to downstream
- [ ] **Plugin**: `rabbitmq_federation` (bundled, enable with `rabbitmq-plugins enable`)
- [ ] **Federation upstream**: the source broker (from which messages flow)
- [ ] **Federation downstream**: the destination (where messages arrive)
- [ ] **Configuration flow**:
  1. [ ] Define upstream on downstream: `rabbitmqctl set_parameter federation-upstream my-upstream '{"uri":"amqp://upstream-host"}'`
  2. [ ] Apply federation policy: `rabbitmqctl set_policy federate-me "^federated\\." '{"federation-upstream-set":"all"}'`
  3. [ ] Matching exchanges/queues are automatically federated
- [ ] **Self-healing**: reconnects automatically after network issues
- [ ] **Bidirectional**: set up federation in both directions for bi-directional flow
- [ ] **Loop prevention**: uses `x-received-from` header to prevent infinite loops

## Module 3: Exchange Federation
- [ ] **Federated exchange**: messages published to upstream exchange are replicated to downstream
- [ ] **How it works**:
  - [ ] Downstream creates a queue bound to the upstream exchange
  - [ ] Consumes messages and re-publishes to local exchange
  - [ ] Local consumers bind normally to the local exchange
- [ ] **Topology**:
  ```
  Upstream: exchange A
  Downstream: queue "federation: A" → exchange A → local consumers
  ```
- [ ] **Behavior**: messages flow from upstream to downstream, one-way
- [ ] **Use case**: broadcast events to multiple regions
- [ ] **Configuration**: set policy on downstream, matching exchange pattern

## Module 4: Queue Federation
- [ ] **Federated queue**: downstream queue pulls messages from upstream queue
- [ ] **How it works**:
  - [ ] Downstream queue consumes from upstream queue via federation link
  - [ ] Messages are MOVED (not copied) to downstream
  - [ ] Prefetch-based load balancing
- [ ] **Different from exchange federation**:
  - [ ] Exchange: fan-out (all downstream get same messages)
  - [ ] Queue: load balance (messages distributed across downstream)
- [ ] **Use case**:
  - [ ] Move work from a central queue to regional processors
  - [ ] Load-balance global work across regions
- [ ] **Downstream has priority**: if local consumers can process, upstream won't send
  - [ ] Only pulls when downstream is available

## Module 5: Shovel Plugin
- [ ] **Shovel**: simpler alternative — "forward messages from source to destination"
- [ ] **Plugin**: `rabbitmq_shovel`, management plugin `rabbitmq_shovel_management`
- [ ] **Shovel types**:
  - [ ] **Static shovel**: configured in RabbitMQ config file, static link
  - [ ] **Dynamic shovel**: configured via runtime parameters, managed at runtime
- [ ] **Configuration**:
  ```
  rabbitmqctl set_parameter shovel my-shovel '{
    "src-protocol": "amqp091",
    "src-uri": "amqp://source",
    "src-queue": "source-queue",
    "dest-protocol": "amqp091",
    "dest-uri": "amqp://destination",
    "dest-exchange": "dest-exchange"
  }'
  ```
- [ ] **Source options**: queue, exchange
- [ ] **Destination options**: exchange (with routing key), queue (via default exchange)
- [ ] **Ack mode**: `on-confirm` (safest), `on-publish`, `no-ack`
- [ ] **Reconnect**: automatic on failure
- [ ] **Use cases**: migration, one-way sync, selective forwarding

## Module 6: Federation vs Shovel — Decision Guide
- [ ] **Federation**:
  - [ ] Pros: configured via policy (applies to many exchanges), bidirectional easy, self-healing
  - [ ] Cons: less flexible routing, exchange/queue-centric
  - [ ] Best for: large-scale multi-DC with many federated exchanges
- [ ] **Shovel**:
  - [ ] Pros: simple, flexible routing (source queue → dest exchange with routing key), easy to reason about
  - [ ] Cons: one link at a time, less scalable for many links
  - [ ] Best for: point-to-point forwarding, migration, small-scale bridging
- [ ] **Choosing**:
  - [ ] Many exchanges, same pattern → Federation
  - [ ] One-off forwarding → Shovel
  - [ ] Complex routing (change routing key, change exchange) → Shovel
- [ ] **Both support**: filtering via exchange bindings, TLS, ack modes, reconnect

## Module 7: Multi-DC Topologies
- [ ] **Hub-and-spoke**:
  - [ ] Central hub cluster
  - [ ] Regional spoke clusters federated to hub
  - [ ] Hub is source of truth, spokes serve local consumers
  - [ ] Simple, but hub is SPOF
- [ ] **Mesh**:
  - [ ] All DCs federated to each other (N × (N-1) links)
  - [ ] Any DC can publish and all others receive
  - [ ] Complex, higher bandwidth cost
- [ ] **Active-passive**:
  - [ ] Primary DC handles traffic
  - [ ] Secondary DC is DR standby (federated from primary)
  - [ ] On failover: consumers switch to secondary
- [ ] **Active-active**:
  - [ ] Both DCs accept writes
  - [ ] Federation in both directions
  - [ ] Watch for cycles (federation loop prevention handles this)
- [ ] **Design considerations**:
  - [ ] Network bandwidth between DCs (cost)
  - [ ] Acceptable replication lag (seconds? minutes?)
  - [ ] Failover time (RPO/RTO)
  - [ ] Conflict handling (none in RabbitMQ — app-level)

## Module 8: Operations & Monitoring
- [ ] **Monitoring federation/shovel**:
  - [ ] Management UI → Federation / Shovel tabs
  - [ ] Link status: running, error, reconnecting
  - [ ] Per-link statistics: messages transferred, rate
- [ ] **Alerting**:
  - [ ] Federation link down → immediate alert
  - [ ] Replication lag growing → investigate bottleneck
  - [ ] Reconnect loop → network or config issue
- [ ] **Network considerations**:
  - [ ] Bandwidth for peak traffic
  - [ ] TLS for inter-DC (always for public WAN)
  - [ ] Firewall rules: 5671/5672 bidirectional
- [ ] **Failover**:
  - [ ] DNS switching to redirect producers/consumers
  - [ ] App-level connection URL update
  - [ ] Quorum queue leaders re-elect on node failure
- [ ] **Runbook**: document failover procedure, test regularly
- [ ] **Common issues**:
  - [ ] High latency causes acks to time out → increase timeouts
  - [ ] Duplicates during reconnect → idempotent consumers
  - [ ] Upstream/downstream version mismatch → upgrade in order

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | List 3 multi-DC use cases where federation applies |
| Module 2 | Enable federation plugin, configure upstream parameter |
| Module 3 | Set up exchange federation, publish to upstream, verify downstream |
| Module 4 | Set up queue federation for load balancing between 2 clusters |
| Module 5 | Configure dynamic shovel to migrate messages from old broker to new |
| Module 6 | Document which to use (federation vs shovel) for 5 scenarios |
| Module 7 | Design multi-DC topology for a global application (3 DCs, active-active) |
| Module 8 | Set up monitoring, simulate failure, measure recovery time |

## Key Resources
- rabbitmq.com/federation.html (Federation plugin)
- rabbitmq.com/shovel.html (Shovel plugin)
- rabbitmq.com/distributed.html (Distributed RabbitMQ)
- "Federation vs Shovel" — CloudAMQP blog
- "Multi-Data Center RabbitMQ" — CloudAMQP webinar/blog
