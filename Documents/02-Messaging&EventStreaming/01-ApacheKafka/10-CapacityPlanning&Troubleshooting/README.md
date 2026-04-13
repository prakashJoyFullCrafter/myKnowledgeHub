# Kafka Capacity Planning & Troubleshooting - Curriculum

How to size, benchmark, and diagnose Kafka clusters in production — essential skills for running Kafka at scale.

---

## Module 1: Capacity Planning Fundamentals
- [ ] **Key capacity dimensions**:
  - [ ] Throughput: MB/sec produce, MB/sec consume
  - [ ] Storage: retention × throughput × replication factor
  - [ ] Network: broker NIC bandwidth (producers + consumers + replication)
  - [ ] Partitions: brokers support N partitions per broker
  - [ ] CPU: compression, TLS, request handling
- [ ] **Capacity planning inputs**:
  - [ ] Producer throughput (events/sec × avg size)
  - [ ] Consumer count × fan-out ratio
  - [ ] Retention period (hours, days, weeks)
  - [ ] Replication factor (typically 3)
  - [ ] Peak vs average (headroom planning)
- [ ] **Capacity formula** (storage):
  - [ ] `storage = throughput × retention × replication_factor × 1.3 (overhead)`
  - [ ] Example: 100 MB/s × 7 days × 3 × 1.3 ≈ 236 TB cluster storage
- [ ] **Network formula**:
  - [ ] Ingress: producer throughput
  - [ ] Egress: consumer_count × throughput + (RF-1) × throughput (replication)

## Module 2: Partition Count & Broker Sizing
- [ ] **Partition count sizing**:
  - [ ] Max consumer parallelism: `num_partitions >= num_consumers`
  - [ ] Throughput target: `partitions = target_throughput / per_partition_throughput`
  - [ ] Per-partition throughput: ~10-50 MB/s (depends on tuning)
  - [ ] Target 3x expected consumers for future growth
- [ ] **Partition limits per broker**:
  - [ ] ZooKeeper era: ~4000 partitions per broker, ~200K per cluster
  - [ ] KRaft era: 10x higher (millions per cluster)
  - [ ] More partitions = more files, more memory, slower leader election
- [ ] **Broker CPU sizing**:
  - [ ] 8-16 cores typical for production
  - [ ] TLS overhead: ~30% CPU
  - [ ] Compression: depends on algorithm (lz4 cheap, zstd more)
- [ ] **Broker memory sizing**:
  - [ ] JVM heap: 6-8 GB (NOT more — keep memory for page cache)
  - [ ] OS page cache: majority of memory (32-128 GB typical)
- [ ] **Broker disk sizing**:
  - [ ] SSDs for low latency, HDDs for cost-heavy throughput
  - [ ] Multiple disks (JBOD) for parallelism
  - [ ] Target: 60-70% disk utilization max (room for compaction, spikes)

## Module 3: Benchmarking Methodology
- [ ] **Tools**:
  - [ ] `kafka-producer-perf-test.sh`: producer throughput and latency
  - [ ] `kafka-consumer-perf-test.sh`: consumer throughput
  - [ ] `trogdor` (Kafka internal): distributed testing framework
  - [ ] OpenMessaging Benchmark: cross-platform comparison
- [ ] **Producer benchmark example**:
  ```
  kafka-producer-perf-test.sh \
    --topic bench --num-records 10000000 --record-size 1024 \
    --throughput -1 \
    --producer-props bootstrap.servers=... acks=all compression.type=lz4
  ```
- [ ] **Key metrics to measure**:
  - [ ] Max sustained throughput (records/sec, MB/sec)
  - [ ] Latency percentiles (p50, p95, p99, p99.9)
  - [ ] Error rate under load
  - [ ] Resource utilization (CPU, disk, network)
- [ ] **Test scenarios**:
  - [ ] Ramp up to find saturation point
  - [ ] Sustained load (soak test) — catches leaks and cumulative issues
  - [ ] Spike test — sudden load change
  - [ ] Failure injection — broker kill during load
- [ ] **Common mistakes**:
  - [ ] Benchmarking on same machine (I/O contention)
  - [ ] Using unrealistic message sizes
  - [ ] Not warming up JVMs before measurement
  - [ ] Ignoring consumer side

## Module 4: Key Metrics & Monitoring
- [ ] **Broker metrics (JMX)**:
  - [ ] `UnderReplicatedPartitions` — should be 0
  - [ ] `ActiveControllerCount` — should be exactly 1
  - [ ] `OfflinePartitionsCount` — should be 0
  - [ ] `RequestHandlerAvgIdlePercent` — should be > 0.3
  - [ ] `NetworkProcessorAvgIdlePercent` — should be > 0.3
  - [ ] `BytesInPerSec`, `BytesOutPerSec` — throughput
  - [ ] `MessagesInPerSec` — record rate
  - [ ] `LogFlushRateAndTimeMs` — disk flush performance
  - [ ] `ProduceRequestLatency`, `FetchRequestLatency` — percentiles
- [ ] **Consumer metrics**:
  - [ ] `records-lag-max` — max lag across partitions
  - [ ] `fetch-rate` — fetch frequency
  - [ ] `records-consumed-rate`
- [ ] **Producer metrics**:
  - [ ] `record-send-rate`, `record-error-rate`
  - [ ] `request-latency-avg`, `request-latency-max`
  - [ ] `record-queue-time-avg` — time in accumulator
- [ ] **OS metrics**:
  - [ ] CPU, memory, disk I/O, network bandwidth
  - [ ] Page cache hit ratio
  - [ ] Swap usage (should be 0)
- [ ] **Tools**: Prometheus JMX exporter + Grafana, Datadog, Confluent Control Center

## Module 5: Common Problems & Root Causes
- [ ] **High producer latency**:
  - [ ] Check: `acks=all` + slow replica → increase `min.insync.replicas` awareness
  - [ ] Check: broker overloaded → scale or tune
  - [ ] Check: network saturation → reduce batch rate or compress
- [ ] **Consumer lag growing**:
  - [ ] Downstream bottleneck (DB, API, processing)
  - [ ] Not enough consumers (fewer than partitions)
  - [ ] Hot partition (skewed key distribution)
  - [ ] GC pauses or long processing
- [ ] **Under-replicated partitions**:
  - [ ] Slow follower (network, disk, CPU)
  - [ ] Broker at capacity
  - [ ] Leader imbalance → one broker overloaded
- [ ] **Rebalance storms**:
  - [ ] Slow consumer processing exceeding `max.poll.interval.ms`
  - [ ] GC pauses exceeding `session.timeout.ms`
  - [ ] Fix: tune timeouts, use static membership, optimize processing
- [ ] **ISR shrinking frequently**:
  - [ ] Network issues, disk saturation, CPU contention
  - [ ] `replica.lag.time.max.ms` too aggressive
- [ ] **"No space left on device"**:
  - [ ] Retention too long, spike in traffic, compaction lag
  - [ ] Fix: tune retention, add disks, enable tiered storage

## Module 6: Anti-Patterns & Design Mistakes
- [ ] **Too many partitions**:
  - [ ] More files → slower leader election, more OS file handles
  - [ ] Diminishing returns past a point
  - [ ] Fix: partition count aligned with actual parallelism needs
- [ ] **Too few partitions**:
  - [ ] Cannot scale consumers beyond partition count
  - [ ] Fix: repartition topic (break key ordering!) or new topic with more partitions
- [ ] **Hot partition (skewed keys)**:
  - [ ] Celebrity problem, time-based keys, small cardinality
  - [ ] Fix: compound keys, salting, random prefix
- [ ] **Large messages (> 1 MB)**:
  - [ ] Causes: page cache thrashing, high memory, GC pressure
  - [ ] Fix: store in object store, pass reference in Kafka message
- [ ] **No compression**:
  - [ ] Massive waste of network and storage
  - [ ] Fix: `lz4` or `zstd` always in production
- [ ] **Auto-commit with slow processing**:
  - [ ] Fix: manual commit after processing, tune `max.poll.records`
- [ ] **One topic for everything**:
  - [ ] Schema chaos, ACL nightmare, consumer fan-in
  - [ ] Fix: one topic per event type / domain boundary
- [ ] **Ignoring consumer lag monitoring**:
  - [ ] Silent data freshness degradation
  - [ ] Fix: alert on lag growth and absolute thresholds

## Module 7: JVM Tuning for Brokers
- [ ] **Heap size**: 6-8 GB (NOT more — keep memory for page cache)
  - [ ] Too big → long GC pauses
  - [ ] Too small → frequent GC, OOM
- [ ] **Garbage collector**: G1GC (default for modern JVM) or ZGC (Java 21+)
  - [ ] G1GC: predictable pauses, good default
  - [ ] ZGC: sub-millisecond pauses at larger heaps
- [ ] **G1GC tuning**:
  - [ ] `-XX:MaxGCPauseMillis=20` — target pause time
  - [ ] `-XX:InitiatingHeapOccupancyPercent=35`
  - [ ] `-XX:G1HeapRegionSize=16M`
- [ ] **Monitor GC**: log GC (`-Xlog:gc*`), watch for long pauses
- [ ] **Avoid**: CMS (deprecated), Parallel GC (too long pauses)
- [ ] **Off-heap memory**: most Kafka memory usage is off-heap (direct buffers, page cache)

## Module 8: Scaling Operations
- [ ] **Adding a broker**:
  - [ ] Deploy new broker with unique `broker.id`
  - [ ] Reassign partitions to new broker (`kafka-reassign-partitions.sh`)
  - [ ] Throttle reassignment to avoid disrupting traffic
- [ ] **Removing a broker (decommission)**:
  - [ ] Move all partitions away (reassign to others)
  - [ ] Shut down broker cleanly
  - [ ] Remove from cluster metadata
- [ ] **Partition reassignment**:
  - [ ] Generate plan: `--generate`
  - [ ] Execute: `--execute` with throttle
  - [ ] Verify: `--verify`
  - [ ] Throttle: `--throttle 50000000` (bytes/sec)
- [ ] **Increasing partition count**:
  - [ ] Online operation, no downtime
  - [ ] **WARNING**: existing keys may hash to different partitions → ordering broken
  - [ ] Consider new topic + migration instead of in-place add
- [ ] **Topic migration**: use MirrorMaker 2 or create new topic with more partitions
- [ ] **Rolling restart**: one broker at a time, wait for ISR recovery between each

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Calculate storage/network requirements for 100MB/s, 7-day retention, RF=3 |
| Module 2 | Size a cluster for 1 GB/s throughput with 20 consumers |
| Module 3 | Run `kafka-producer-perf-test` to find max throughput of a test broker |
| Module 4 | Set up Prometheus + Grafana dashboard with all key Kafka metrics |
| Module 5 | Reproduce 3 problems (hot partition, slow consumer, under-replication) and fix each |
| Module 6 | Identify anti-patterns in a given Kafka configuration, propose fixes |
| Module 7 | Tune JVM for a broker: set G1GC, measure GC pause distribution |
| Module 8 | Add a broker to a 3-broker cluster, reassign partitions, verify balance |

## Key Resources
- "Kafka: The Definitive Guide" — Chapter 11 (Administering), Chapter 12 (Monitoring)
- "Sizing Apache Kafka" — Confluent whitepaper
- LinkedIn engineering blog on Kafka operations
- Apache Kafka Operations documentation
- Datadog "Monitoring Kafka" guide
- "Kafka Performance Tuning" — Confluent blog series
