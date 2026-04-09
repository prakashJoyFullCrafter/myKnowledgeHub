# Database Sharding - Curriculum

## Module 1: Sharding Fundamentals
- [ ] **What is sharding?** Horizontal partitioning of data across multiple database instances
- [ ] Why shard? Single DB limits: storage, write throughput, connection count
- [ ] Sharding vs **vertical partitioning** (splitting columns into separate tables)
- [ ] Sharding vs **replication** (copies of same data vs splitting data)
- [ ] When to shard vs when to scale vertically (scale up hardware first)
- [ ] The cost of sharding: complexity, cross-shard queries, operational burden

## Module 2: Sharding Strategies
- [ ] **Hash-based sharding**: `shard = hash(key) % num_shards`
  - [ ] Even distribution, but resharding is painful
- [ ] **Range-based sharding**: shard by ranges (e.g., users A-M → shard 1, N-Z → shard 2)
  - [ ] Good for range queries, but hotspot risk
- [ ] **Directory-based sharding**: lookup table maps keys to shards
  - [ ] Most flexible, but lookup table is a single point of failure
- [ ] **Consistent hashing**: minimal data movement when adding/removing shards
- [ ] **Geographic sharding**: shard by region (EU data in EU shard, US in US shard)

## Module 3: Shard Key Selection
- [ ] **The most critical decision** in sharding — cannot easily change later
- [ ] Good shard key: high cardinality, even distribution, aligns with query patterns
- [ ] Bad shard key: low cardinality (e.g., country), monotonically increasing (e.g., timestamp)
- [ ] **Hotspot problem**: one shard gets disproportionate traffic
- [ ] Hotspot mitigation: compound shard keys, salting, random prefix
- [ ] Examples: `user_id` (good for user-centric apps), `order_id` (good for order service)

## Module 4: Challenges & Solutions
- [ ] **Cross-shard queries**: joins across shards are expensive (scatter-gather)
- [ ] **Cross-shard transactions**: 2PC (two-phase commit) or Saga pattern
- [ ] **Rebalancing**: adding shards requires data migration — consistent hashing helps
- [ ] **Referential integrity**: foreign keys don't work across shards
- [ ] **Auto-increment IDs**: need distributed ID generation (Snowflake, UUID)
- [ ] **Schema changes**: must be applied to all shards consistently
- [ ] **Backup and recovery**: per-shard backups, coordinated restore

## Module 5: Tools & Real-World
- [ ] **Vitess** (MySQL): YouTube/Slack scale, automatic sharding, connection pooling
- [ ] **Citus** (PostgreSQL): distributed PostgreSQL, transparent sharding
- [ ] **MongoDB**: built-in sharding with mongos router
- [ ] **CockroachDB**: automatic sharding and rebalancing (NewSQL)
- [ ] **Application-level sharding**: custom routing in code (Spring multi-datasource)
- [ ] Real-world: how Instagram, Pinterest, Uber shard their databases

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Design sharding strategy for a social media app (posts, users, feeds) |
| Module 3 | Evaluate shard key options for an e-commerce order system |
| Module 4 | Solve: "How to get a user's orders when users and orders are on different shards?" |
| Module 5 | Set up Citus on PostgreSQL for a multi-tenant SaaS app |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapter 6: Partitioning)
- Vitess documentation (vitess.io)
- "Sharding Pinterest" - engineering blog
- System Design Interview - Alex Xu
