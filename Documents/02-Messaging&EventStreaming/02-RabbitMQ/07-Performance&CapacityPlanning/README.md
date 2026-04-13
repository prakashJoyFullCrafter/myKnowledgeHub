# RabbitMQ Performance & Capacity Planning - Curriculum

How to size, benchmark, and tune RabbitMQ for production workloads.

---

## Module 1: Performance Factors
- [ ] **Throughput drivers**:
  - [ ] Queue type (classic vs quorum vs stream)
  - [ ] Message size and count
  - [ ] Persistence (transient vs persistent)
  - [ ] Ack mode (auto vs manual)
  - [ ] Prefetch count
  - [ ] Publisher confirms
  - [ ] Connection and channel count
  - [ ] Exchange type (fanout fastest, headers slowest)
- [ ] **Latency drivers**:
  - [ ] Network round-trip
  - [ ] Persistence (disk write)
  - [ ] Replication (quorum queue consensus)
  - [ ] Flow control backpressure
- [ ] **Resource constraints**:
  - [ ] CPU: Erlang scheduler, scheduling, TLS, routing
  - [ ] Memory: queue state, message store, GC
  - [ ] Disk: persistent messages, paging, mnesia
  - [ ] Network: publishing, delivery, replication

## Module 2: Queue Type Performance Characteristics
- [ ] **Classic queue (transient)**:
  - [ ] ~50K-100K msg/sec per queue
  - [ ] Lowest latency
  - [ ] Not fault-tolerant across nodes
- [ ] **Classic queue (persistent)**:
  - [ ] ~10K-30K msg/sec per queue
  - [ ] Disk I/O is the bottleneck
- [ ] **Quorum queue**:
  - [ ] ~10K-30K msg/sec per queue
  - [ ] Replication adds latency (Raft consensus)
  - [ ] Always persistent (no transient option)
- [ ] **Stream**:
  - [ ] 100K-1M msg/sec (append-only log, Kafka-like)
  - [ ] Best for high-throughput, long retention, replay
- [ ] **Choosing for performance**:
  - [ ] High throughput + HA → Streams
  - [ ] Traditional messaging + HA → Quorum
  - [ ] Max throughput, low durability → Classic transient
  - [ ] Legacy or simple → Classic persistent

## Module 3: Sizing Formulas
- [ ] **Throughput target**: messages/sec or MB/sec
- [ ] **Queue count**:
  - [ ] Each queue is one Erlang process
  - [ ] For high throughput: partition across multiple queues
  - [ ] Queue count = target_throughput / per_queue_throughput
- [ ] **Node count**:
  - [ ] Based on aggregate throughput and HA requirements
  - [ ] Typical: 3 nodes for quorum queues (2 replica + 1 majority survival)
- [ ] **Memory sizing**:
  - [ ] Queue memory (inflight messages)
  - [ ] Connection/channel memory
  - [ ] Message store (for persistent messages)
  - [ ] Rule: keep queues short, let messages flow through
- [ ] **Disk sizing**:
  - [ ] Persistent messages: count × size × safety factor
  - [ ] Quorum queues: 3x (replication)
  - [ ] Message store overhead: ~1.5-2x raw data

## Module 4: Tuning for Throughput
- [ ] **Publisher side**:
  - [ ] Use channels, not new connections per message
  - [ ] Batch publishes over single channel
  - [ ] Publisher confirms in async mode (NOT `waitForConfirms` per message)
  - [ ] Fewer TCP writes = higher throughput
- [ ] **Consumer side**:
  - [ ] Prefetch tuned to processing speed
  - [ ] Manual ack in batches (multi-ack)
  - [ ] Multiple consumers per queue (competing consumers)
- [ ] **Broker side**:
  - [ ] `channel_max`: limit channels per connection
  - [ ] `connection_max`: limit total connections
  - [ ] `heartbeat`: tune for network conditions
  - [ ] OS: file descriptor limits (`ulimit -n`)
  - [ ] OS: TCP buffers, somaxconn

## Module 5: Tuning for Latency
- [ ] **Low-latency settings**:
  - [ ] Transient messages (no disk write)
  - [ ] Auto-ack (no round-trip for ack)
  - [ ] Prefetch high (pipeline aggressively)
  - [ ] No publisher confirms (fire-and-forget)
- [ ] **Trade-off**: these sacrifice durability for latency
- [ ] **Network tuning**:
  - [ ] Co-locate producer/consumer/broker in same AZ
  - [ ] Low-latency network (10 Gbps, tuned TCP)
  - [ ] Consider UDP-based alternatives if AMQP overhead matters
- [ ] **Erlang VM tuning**:
  - [ ] Schedulers tied to CPU cores (`+S` flag)
  - [ ] Larger distribution buffers for cluster traffic
- [ ] **Monitoring**: measure p50, p99, p99.9 — not just average

## Module 6: Benchmarking with PerfTest
- [ ] **RabbitMQ PerfTest**: official benchmarking tool
- [ ] **Install**: download from github.com/rabbitmq/rabbitmq-perf-test
- [ ] **Basic usage**:
  ```
  ./runjava com.rabbitmq.perf.PerfTest \
    --producers 4 --consumers 4 \
    --rate 10000 --size 1024 \
    --queue bench --exchange amq.direct
  ```
- [ ] **Key parameters**:
  - [ ] `--rate`: target message rate (or -1 for max)
  - [ ] `--producers`, `--consumers`: count
  - [ ] `--size`: message size in bytes
  - [ ] `--flag persistent`: persistent messages
  - [ ] `--confirm`: enable publisher confirms
  - [ ] `--queue-type quorum|stream`: test different queue types
  - [ ] `--predeclared`: use existing topology
- [ ] **Output**: sent rate, received rate, latency percentiles
- [ ] **Interpretation**: throughput, latency distribution, error rate

## Module 7: Hardware & OS Tuning
- [ ] **CPU**: 8-16 cores typical for production
  - [ ] RabbitMQ scales with cores (Erlang schedulers)
  - [ ] Disable HyperThreading for predictable latency? (test your workload)
- [ ] **Memory**: 16-64 GB typical
  - [ ] Keep queues short → less memory needed
  - [ ] Leave room for page cache
- [ ] **Disk**:
  - [ ] SSDs: required for persistent workloads
  - [ ] Separate disks for mnesia (metadata) and message store
  - [ ] XFS or ext4 filesystem
  - [ ] Disable `atime` (`noatime` mount option)
- [ ] **Network**:
  - [ ] 10 Gbps for high-throughput
  - [ ] Tune TCP: `net.core.somaxconn`, `net.ipv4.tcp_keepalive_time`
- [ ] **OS limits**:
  - [ ] `ulimit -n 65536` (file descriptors)
  - [ ] `fs.file-max` for system-wide limit
  - [ ] Kernel parameters: `vm.swappiness=1` (avoid swap)
- [ ] **NUMA**: consider NUMA-aware pinning for large servers

## Module 8: Capacity Planning Worksheet
- [ ] **Inputs**:
  - [ ] Peak message rate (msg/sec)
  - [ ] Average message size (bytes)
  - [ ] Persistence requirement (yes/no)
  - [ ] Durability requirement (HA/DR needed?)
  - [ ] Retention (how long can messages sit in queue)
  - [ ] Consumer count and processing time per message
- [ ] **Outputs**:
  - [ ] Queue type selection
  - [ ] Number of queues
  - [ ] Node count
  - [ ] Hardware specs per node
  - [ ] Expected disk usage
  - [ ] Expected network bandwidth
- [ ] **Rules of thumb**:
  - [ ] Target 50% peak utilization (headroom for spikes)
  - [ ] Don't let queues grow unbounded (set length limits)
  - [ ] Monitor queue depth trends
  - [ ] Benchmark before production rollout
- [ ] **Scale-up trigger**: queue depth growing, consumer lag, broker CPU > 70%

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Identify performance factors in a given system configuration |
| Module 2 | Benchmark all 3 queue types with same workload, compare |
| Module 3 | Calculate capacity for 50K msg/sec with 1KB persistent messages |
| Module 4 | Tune publisher: measure throughput improvement with batch confirms |
| Module 5 | Benchmark latency under different ack modes |
| Module 6 | Run PerfTest scenario with classic vs quorum queue, compare results |
| Module 7 | Apply OS tuning recommendations, measure before/after |
| Module 8 | Complete capacity planning for a hypothetical e-commerce system |

## Key Resources
- RabbitMQ PerfTest — github.com/rabbitmq/rabbitmq-perf-test
- "RabbitMQ Performance" — CloudAMQP blog series
- "Quorum Queue Performance" — rabbitmq.com/blog
- rabbitmq.com/production-checklist.html
- "Networking and RabbitMQ" — rabbitmq.com/networking.html
