# Kafka Storage Internals - Curriculum

Deep dive into how Kafka stores and serves data on disk — the knowledge needed to tune, troubleshoot, and design at scale.

---

## Module 1: Log Structure on Disk
- [ ] **Partition = directory** on broker filesystem
  - [ ] Path: `log.dirs/<topic>-<partition>/`
  - [ ] Example: `/var/kafka-logs/orders-0/`
- [ ] **Segments**: partition log is split into segment files
  - [ ] Active segment (currently being written) + older sealed segments
  - [ ] New segment created when: `segment.bytes` reached OR `segment.ms` elapsed
- [ ] **Segment files**:
  - [ ] `00000000000000000000.log` — the actual records (binary)
  - [ ] `00000000000000000000.index` — offset → position index
  - [ ] `00000000000000000000.timeindex` — timestamp → offset index
  - [ ] `00000000000000000000.snapshot` — producer state snapshot
  - [ ] Filename = base offset (first offset in segment)
- [ ] **Sealed segments are immutable** — never modified after close

## Module 2: Record Format
- [ ] **Record batch** (v2 format, current):
  - [ ] Header: base offset, producer ID, epoch, base sequence, records count
  - [ ] Body: variable-length records (with delta encoding for offsets/timestamps)
  - [ ] Compressed together if compression enabled
- [ ] **Individual record**:
  - [ ] Length, attributes, timestamp delta, offset delta
  - [ ] Key length + key, value length + value
  - [ ] Headers (array of key-value pairs)
- [ ] **Compression**: applied at batch level → better ratio than per-record
- [ ] Broker stores the batch AS-IS — no decompression on broker (zero-copy friendly)
- [ ] CRC32 checksum for corruption detection

## Module 3: Indexes
- [ ] **Offset index** (.index):
  - [ ] Sparse index: not every offset, one entry per N bytes
  - [ ] `log.index.interval.bytes` (default 4KB)
  - [ ] Maps logical offset → physical position in .log file
  - [ ] Used by consumers to start reading at specific offset
- [ ] **Time index** (.timeindex):
  - [ ] Maps timestamp → offset (for `offsetsForTimes()` API)
  - [ ] Required for `log.message.timestamp.type=LogAppendTime`
- [ ] **Index lookup**: binary search the index → find position → read from .log
- [ ] Indexes are memory-mapped (mmap) for fast access
- [ ] Index files are truncated/rebuilt on broker restart if inconsistent

## Module 4: Page Cache & Zero-Copy
- [ ] **OS page cache is Kafka's read cache** — Kafka does NOT maintain its own cache
- [ ] **Write path**:
  - [ ] Producer sends batch → broker writes to OS page cache → returns (fast)
  - [ ] Background: OS flushes dirty pages to disk (fsync rarely forced)
  - [ ] `log.flush.interval.messages/ms` — usually left at defaults (let OS handle)
- [ ] **Read path (zero-copy)**:
  - [ ] Consumer requests data → broker calls `sendfile()` syscall
  - [ ] Data goes from page cache DIRECTLY to network socket (no user-space copy)
  - [ ] No deserialization on broker — just bytes
  - [ ] Massively reduces CPU and memory bandwidth
- [ ] **Implications**:
  - [ ] Give broker lots of OS memory for page cache (not JVM heap)
  - [ ] Small JVM heap (6-8GB) + large page cache = optimal
  - [ ] Cold reads hit disk, hot reads hit page cache (fast)

## Module 5: Log Cleaner (Compaction)
- [ ] **Log cleaner threads**: background process that compacts log-compacted topics
- [ ] **How compaction works**:
  - [ ] Build offset map (key → latest offset) for dirty segments
  - [ ] Copy live records to new segment (latest per key)
  - [ ] Replace old segments with compacted versions
- [ ] **`min.cleanable.dirty.ratio`**: only compact when this much is "dirty" (default 0.5)
- [ ] **`delete.retention.ms`**: how long tombstones (null value) persist
- [ ] **`min.compaction.lag.ms`**: minimum age before a message can be compacted
- [ ] **Active segment is never compacted** (only sealed segments)
- [ ] Monitoring: `log-cleaner.log` on broker, cleaner thread metrics

## Module 6: Tiered Storage (KIP-405)
- [ ] **Problem**: keeping weeks/months of data on broker disks is expensive
- [ ] **Solution** (Kafka 3.6+): offload old segments to cheap remote storage (S3, GCS)
- [ ] **Two tiers**:
  - [ ] **Local tier**: recent segments on broker disk (fast reads)
  - [ ] **Remote tier**: old segments on object storage (cheap, slower)
- [ ] **Transparent to clients** — broker fetches from remote on demand
- [ ] **Benefits**:
  - [ ] Cheaper long retention (S3 pennies per GB vs SSD dollars)
  - [ ] Smaller brokers (less local disk)
  - [ ] Faster broker recovery (less data to replicate)
- [ ] **Configuration**:
  - [ ] `remote.log.storage.system.enable=true`
  - [ ] `remote.log.storage.manager.class.name=<plugin>`
  - [ ] Per-topic: `remote.storage.enable=true`, `local.retention.ms`, `retention.ms`
- [ ] **Confluent Tiered Storage**: commercial version, production-proven for years

## Module 7: Disk Layout & Performance
- [ ] **Sequential writes**: Kafka writes append-only → sequential disk I/O → fast even on HDD
- [ ] **Multiple log.dirs**: spread partitions across multiple disks for parallelism
  - [ ] JBOD (Just a Bunch Of Disks): no RAID, Kafka handles distribution
  - [ ] If one disk fails: only affected partitions go offline (Kafka 3.7+ KRaft support)
- [ ] **Filesystem choice**: XFS (recommended) or ext4
- [ ] **Disk type**: SSDs preferred for low latency, HDDs acceptable for throughput-only
- [ ] **Network storage** (EBS, NAS): acceptable but adds latency, watch for throttling
- [ ] **Disk usage monitoring**:
  - [ ] `kafka-log-dirs.sh --describe` — per-partition disk usage
  - [ ] Prometheus: `kafka_log_log_size` metric

## Module 8: Recovery & Crash Consistency
- [ ] **Clean shutdown**: broker flushes state, writes recovery point
- [ ] **Crash recovery on startup**:
  - [ ] For each partition, read segments from recovery point
  - [ ] Rebuild indexes if inconsistent
  - [ ] Validate checksums, truncate corrupt tail records
  - [ ] **Log recovery** can take minutes for large brokers — tuning critical
- [ ] **`num.recovery.threads.per.data.dir`**: parallel recovery per disk
- [ ] **`recovery.point.offset.checkpoint`**: file tracking flushed state
- [ ] **Replication-based recovery**: after recovery, sync missing data from leader
- [ ] **Unclean shutdown cost**: longer recovery, potential tail truncation

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Inspect a partition directory, look at segment files and record format with `kafka-dump-log.sh` |
| Module 3 | Use `kafka-dump-log.sh --index-sanity-check` to inspect indexes |
| Module 4 | Run producer + consumer, observe page cache usage with `vmstat` and `free -m` |
| Module 5 | Create compact topic, inject duplicate keys, watch compaction via log cleaner metrics |
| Module 6 | Configure tiered storage with MinIO backend, verify old segments offloaded |
| Module 7 | Benchmark throughput with 1 disk vs 4 disks (JBOD) |
| Module 8 | Kill broker uncleanly, measure recovery time, tune recovery threads |

## Key Resources
- Apache Kafka documentation — Storage section
- "The Log: What every software engineer should know" — Jay Kreps
- KIP-405: Tiered Storage
- "Kafka Storage Internals" — Confluent blog
- `kafka-dump-log.sh` tool documentation
