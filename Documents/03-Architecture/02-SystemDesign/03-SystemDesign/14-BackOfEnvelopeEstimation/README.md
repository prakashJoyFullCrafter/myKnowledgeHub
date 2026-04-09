# Back-of-the-Envelope Estimation - Curriculum

The first step in every system design: estimate scale before designing.

---

## Module 1: Key Numbers Every Engineer Should Know
- [ ] **Latency numbers**:
  - [ ] L1 cache: ~1 ns
  - [ ] L2 cache: ~4 ns
  - [ ] RAM access: ~100 ns
  - [ ] SSD random read: ~16 us
  - [ ] HDD seek: ~4 ms
  - [ ] Same datacenter round trip: ~0.5 ms
  - [ ] Cross-continent round trip: ~150 ms
- [ ] **Throughput numbers**:
  - [ ] SSD sequential read: ~1 GB/s
  - [ ] HDD sequential read: ~200 MB/s
  - [ ] Network (1 Gbps): ~125 MB/s
  - [ ] Network (10 Gbps): ~1.25 GB/s
- [ ] **Storage sizes**:
  - [ ] ASCII character: 1 byte
  - [ ] UTF-8 character: 1-4 bytes
  - [ ] UUID: 36 bytes (string) or 16 bytes (binary)
  - [ ] Typical tweet/message: ~200 bytes
  - [ ] Typical image (compressed): ~200 KB
  - [ ] Typical 1-minute video (720p): ~30 MB

## Module 2: QPS (Queries Per Second) Estimation
- [ ] **DAU (Daily Active Users)** → peak QPS formula:
  - [ ] Average QPS = DAU * avg_queries_per_user / 86400
  - [ ] Peak QPS = Average QPS * 2-5x (peak factor)
- [ ] Example: 10M DAU, 10 queries/day each
  - [ ] Average: 10M * 10 / 86400 = ~1,157 QPS
  - [ ] Peak: ~3,500 - 5,800 QPS
- [ ] **Write vs Read ratio**: most systems are read-heavy (90-99% reads)
- [ ] Single server capacity: ~1K-10K QPS depending on complexity

## Module 3: Storage Estimation
- [ ] Formula: `daily_data = DAU * actions_per_day * data_per_action`
- [ ] Example: messaging app, 10M DAU, 20 messages/day, 200 bytes/msg
  - [ ] Daily: 10M * 20 * 200B = 40 GB/day
  - [ ] Yearly: 40 GB * 365 = ~14.6 TB/year
  - [ ] 5 years: ~73 TB
- [ ] Factor in: metadata, indexes (2-3x raw data), replication (3x), compression (0.3-0.5x)
- [ ] Media storage: images/videos dominate (orders of magnitude more than text)

## Module 4: Bandwidth Estimation
- [ ] **Ingress** (incoming): write QPS * average request size
- [ ] **Egress** (outgoing): read QPS * average response size
- [ ] Example: image service, 1000 upload QPS * 200KB = 200 MB/s ingress
- [ ] Example: image service, 10000 read QPS * 200KB = 2 GB/s egress
- [ ] CDN offloads most egress for static content

## Module 5: Memory Estimation (Caching)
- [ ] **80/20 rule**: 20% of data generates 80% of traffic — cache the hot 20%
- [ ] Formula: `cache_size = daily_read_data * 0.2`
- [ ] Example: 10M reads/day * 1KB avg = 10 GB/day → cache 2 GB
- [ ] Redis single node: ~25 GB usable memory, ~100K ops/sec
- [ ] Factor in: cache overhead, serialization, expiry, cluster overhead

## Module 6: Estimation Framework
- [ ] **Step 1**: Clarify scale — DAU, MAU, peak vs average
- [ ] **Step 2**: Estimate QPS (reads and writes separately)
- [ ] **Step 3**: Estimate storage (5-year horizon)
- [ ] **Step 4**: Estimate bandwidth (ingress + egress)
- [ ] **Step 5**: Estimate memory for caching
- [ ] **Step 6**: Estimate number of servers needed
- [ ] **Powers of 2 cheat sheet**:
  - [ ] 2^10 = 1 KB (thousand)
  - [ ] 2^20 = 1 MB (million)
  - [ ] 2^30 = 1 GB (billion)
  - [ ] 2^40 = 1 TB (trillion)
  - [ ] 2^50 = 1 PB
- [ ] **Common shortcuts**:
  - [ ] 1 day = 86,400 seconds ≈ ~100K seconds
  - [ ] 1 month ≈ 2.5M seconds
  - [ ] 1 year ≈ 30M seconds

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Memorize the latency numbers table |
| Modules 2-5 | Estimate for Twitter: QPS, storage, bandwidth, cache for 500M DAU |
| Modules 2-5 | Estimate for YouTube: video storage, CDN bandwidth for 2B MAU |
| Module 6 | Practice 5 rapid estimations (2 minutes each): URL shortener, chat, feed, search, notification |

## Key Resources
- System Design Interview - Alex Xu (Chapter 2: Back-of-the-envelope Estimation)
- "Latency Numbers Every Programmer Should Know" - Jeff Dean (Google)
- "Numbers Everyone Should Know" - Brendan Gregg
- ByteByteGo system design cheat sheets
