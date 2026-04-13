# Kafka vs RabbitMQ: Throughput Comparison - Curriculum

## Module 1: Architectural Throughput Drivers
- [ ] **Kafka's throughput secrets**:
  - [ ] Sequential disk I/O (append-only log) — fast even on HDDs
  - [ ] Zero-copy (sendfile) — data goes directly from page cache to network
  - [ ] Batching at producer and broker level
  - [ ] Compression at batch level (better ratio)
  - [ ] Parallel consumption via partitions
- [ ] **RabbitMQ's throughput characteristics**:
  - [ ] In-memory queue with optional disk persistence
  - [ ] Per-message routing adds overhead
  - [ ] Erlang process per queue (scalable but per-queue limit)
  - [ ] Classic queues faster than quorum queues (no replication overhead)

## Module 2: Typical Throughput Numbers
- [ ] **Kafka** (commodity hardware, properly tuned):
  - [ ] Single partition: 10-50 MB/sec (10K-100K small messages/sec)
  - [ ] Per broker: 100-500 MB/sec aggregate
  - [ ] Cluster: millions of messages/sec
- [ ] **RabbitMQ** (classic queues, commodity hardware):
  - [ ] Single queue, transient: ~50K msg/sec
  - [ ] Single queue, persistent: ~10K-20K msg/sec
  - [ ] Quorum queue, persistent: ~10K msg/sec (replication overhead)
  - [ ] Streams: 100K+ msg/sec (Kafka-like)
- [ ] **Caveats**:
  - [ ] Numbers vary wildly with message size, durability, replication, tuning
  - [ ] These are rough ballparks — always benchmark your workload
- [ ] **Key insight**: Kafka is 10-100x higher throughput for large-scale streaming

## Module 3: Latency Comparison
- [ ] **Kafka latency**:
  - [ ] Producer to consumer: 2-10 ms typical (tuned)
  - [ ] Lower bound: ~2 ms (no batching)
  - [ ] Batching for throughput adds latency (linger.ms)
  - [ ] Acks=all adds replication latency
- [ ] **RabbitMQ latency**:
  - [ ] End-to-end: 1-10 ms typical
  - [ ] Single-hop routing is fast
  - [ ] No batching overhead
- [ ] **For low-latency workloads**: both comparable if tuned
- [ ] **Kafka can achieve lower p99 latency**: with proper partition count and consumer parallelism

## Module 4: Scalability Models
- [ ] **Kafka scaling**:
  - [ ] Horizontal: add brokers + increase partitions
  - [ ] Partitions = parallelism unit
  - [ ] Consumers scale up to partition count
  - [ ] Rebalance on topology changes
- [ ] **RabbitMQ scaling**:
  - [ ] Horizontal: add cluster nodes
  - [ ] Queues are per-node (except quorum/streams)
  - [ ] Each queue is an Erlang process — queue is the unit of parallelism
  - [ ] Scale consumers on same queue for parallelism
- [ ] **Scaling ceiling**:
  - [ ] Kafka: limited by cluster size, partition count, network
  - [ ] RabbitMQ: limited by queue throughput, Erlang process performance

## Module 5: Message Size Impact
- [ ] **Both brokers**: throughput in msg/sec decreases as message size grows
- [ ] **Throughput in MB/sec**: increases with size (better batching/compression)
- [ ] **Kafka**:
  - [ ] Optimal message size: 1KB-10KB
  - [ ] > 1MB: possible but tuning required (`max.message.bytes`, `replica.fetch.max.bytes`)
  - [ ] Large messages: consider storing payload in S3, passing reference
- [ ] **RabbitMQ**:
  - [ ] Optimal: small messages (< 10KB)
  - [ ] Large messages: memory pressure, GC pauses, reduced throughput
  - [ ] Anti-pattern: multi-MB messages in AMQP
- [ ] **Recommendation**: keep messages small in both systems

## Module 6: Durability & Replication Cost
- [ ] **Kafka durability**:
  - [ ] `acks=all` + `min.insync.replicas=2` + RF=3: strong durability
  - [ ] Replication cost: each write goes to leader + 2 followers = 3x network
  - [ ] Still very fast (sequential I/O)
- [ ] **RabbitMQ durability**:
  - [ ] Classic mirrored queues: each write to all mirrors (slow)
  - [ ] Quorum queues: Raft consensus, write to majority
  - [ ] Streams: append-only replicated log (fast)
- [ ] **Throughput cost of durability**:
  - [ ] Kafka: 20-30% overhead with acks=all + RF=3
  - [ ] RabbitMQ: 50-70% overhead with quorum queues vs classic
- [ ] **No free lunch**: durability always costs throughput

## Module 7: Benchmarking Methodology
- [ ] **Kafka tools**:
  - [ ] `kafka-producer-perf-test.sh`: producer throughput
  - [ ] `kafka-consumer-perf-test.sh`: consumer throughput
  - [ ] OpenMessaging Benchmark Framework
- [ ] **RabbitMQ tools**:
  - [ ] `perf-test` (PerfTest from RabbitMQ Java client)
  - [ ] `rabbitmq-perf-test --rate 10000 --size 1024 --consumers 5 --producers 2`
  - [ ] OpenMessaging Benchmark Framework (covers both)
- [ ] **Benchmarking best practices**:
  - [ ] Realistic message size and workload mix
  - [ ] Long enough runs (minutes, not seconds)
  - [ ] Warmup period (JVM, caches, connections)
  - [ ] Realistic durability and ack settings
  - [ ] Separate producer/consumer/broker machines
  - [ ] Measure percentile latencies (p50, p99, p99.9), not just average
  - [ ] Monitor broker CPU, memory, disk, network during test
- [ ] **Common mistakes**:
  - [ ] Benchmarking with auto-ack (not realistic)
  - [ ] All processes on one machine (I/O contention)
  - [ ] Unrealistic batching settings
  - [ ] Ignoring consumer side

## Module 8: Resource Requirements Comparison
- [ ] **Kafka broker**:
  - [ ] CPU: 8-16 cores (TLS, compression)
  - [ ] Memory: 32-64 GB (most for OS page cache, small JVM heap 6-8GB)
  - [ ] Disk: SSDs for low latency, lots of capacity for retention
  - [ ] Network: 10 Gbps recommended
- [ ] **RabbitMQ node**:
  - [ ] CPU: 4-8 cores (Erlang is efficient)
  - [ ] Memory: 8-32 GB (queues live in memory primarily)
  - [ ] Disk: SSDs for persistent queues
  - [ ] Network: 1-10 Gbps depending on load
- [ ] **Rule of thumb**:
  - [ ] RabbitMQ is lighter-weight for moderate workloads
  - [ ] Kafka demands more resources but scales further
- [ ] **Cost**: Kafka typically more expensive to run at scale, but more cost-efficient per message at extreme scale

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Explain zero-copy and why it makes Kafka fast |
| Module 2 | Find published benchmarks for both, compare methodology |
| Module 3 | Measure end-to-end latency on both with same hardware |
| Module 4 | Scale Kafka consumers up to partition count, observe behavior |
| Module 5 | Benchmark both with 1KB vs 100KB messages, measure impact |
| Module 6 | Measure throughput impact of durability settings on both |
| Module 7 | Run `rabbitmq-perf-test` and `kafka-producer-perf-test` with same workload |
| Module 8 | Size hardware for 100K msg/sec on both, compare cost |

## Key Resources
- OpenMessaging Benchmark Framework (github.com/openmessaging/benchmark)
- "Benchmarking Apache Kafka" — Confluent blog
- CloudAMQP benchmarks (Kafka vs RabbitMQ)
- "Kafka vs RabbitMQ: Architectural Differences" — blogs
- RabbitMQ PerfTest documentation
