# Data Internals (System Design Perspective) - Curriculum

How storage engines, indexes, and consensus protocols work internally — the knowledge that separates "can use a database" from "can design data-intensive systems."

> PostgreSQL-specific details (MVCC tuning, pg configs) are in Data & Persistence. This module covers **general storage engine concepts** for system design.

---

## Module 1: Storage Engine Fundamentals
- [ ] A storage engine is the component that stores and retrieves data on disk
- [ ] **Two fundamental approaches**: update-in-place (B-tree) vs append-only (LSM tree)
- [ ] **Page-based storage** (B-tree engines): data stored in fixed-size pages (4KB-16KB)
  - [ ] PostgreSQL, MySQL InnoDB, SQL Server, Oracle
- [ ] **Log-structured storage** (LSM engines): data written sequentially, merged in background
  - [ ] RocksDB, LevelDB, Cassandra, HBase, ScyllaDB
- [ ] **Trade-off**: B-tree = fast reads, slower writes; LSM = fast writes, slower reads
- [ ] Design decision: storage engine choice determines your system's performance characteristics

## Module 2: B-Tree Indexes
- [ ] **B-tree**: balanced tree structure, O(log n) reads and writes
- [ ] Each node = one disk page, tree is shallow (3-4 levels for millions of rows)
- [ ] **How reads work**: traverse tree from root → internal nodes → leaf (data page)
- [ ] **How writes work**: find correct leaf page → update in place → write modified page to disk
- [ ] **Write-Ahead Log (WAL)**: every write goes to WAL FIRST, then to data page
  - [ ] Crash recovery: replay WAL to reconstruct uncommitted changes
  - [ ] WAL is append-only → sequential writes → fast
- [ ] **Page splits**: when a page is full, split into two → rebalance tree
- [ ] **Clustered index**: data rows stored IN the index (InnoDB primary key)
- [ ] **Secondary index**: separate tree pointing to primary key / row location
- [ ] **Covering index**: includes extra columns → query answered from index alone (index-only scan)

## Module 3: LSM Trees & Compaction
- [ ] **LSM tree** (Log-Structured Merge Tree): all writes go to in-memory buffer (memtable)
- [ ] When memtable fills → flush to disk as sorted immutable file (SSTable)
- [ ] **Reads**: check memtable → check SSTables (newest first) → bloom filter to skip files
- [ ] **Bloom filter**: probabilistic data structure — "definitely not here" or "maybe here"
- [ ] **Compaction**: background process merges SSTables to reclaim space and reduce read amplification
  - [ ] **Size-tiered compaction**: merge similarly-sized SSTables (good for write-heavy)
  - [ ] **Leveled compaction**: organize into levels of increasing size (better read performance)
- [ ] **Write amplification**: data written multiple times due to compaction (LSM trade-off)
- [ ] **Read amplification**: may need to check multiple SSTables (mitigated by bloom filters)
- [ ] **Space amplification**: old versions exist until compaction (LSM uses more disk temporarily)
- [ ] **When to choose LSM**: write-heavy workloads, time-series, analytics, logging

## Module 4: Inverted Indexes
- [ ] **Inverted index**: maps each term → list of documents containing it
  - [ ] "database" → [doc1, doc5, doc23]
  - [ ] "distributed" → [doc5, doc12, doc23]
- [ ] Foundation of full-text search (Elasticsearch, Solr, PostgreSQL tsvector)
- [ ] **Indexing pipeline**: tokenize → normalize (lowercase, stemming) → build inverted index
- [ ] **TF-IDF**: term frequency × inverse document frequency — basic relevance scoring
- [ ] **BM25**: improved ranking algorithm (used by Elasticsearch by default)
- [ ] **Positional index**: stores positions for phrase queries ("distributed database")
- [ ] **Updates**: new documents appended to index segments, merged periodically (similar to LSM)
- [ ] Design decision: when your system needs search, understand the cost of maintaining inverted indexes

## Module 5: MVCC (Multi-Version Concurrency Control)
- [ ] **Problem**: how to allow concurrent reads and writes without locking everything
- [ ] **MVCC solution**: each write creates a new version; readers see a consistent snapshot
- [ ] **How it works** (simplified):
  - [ ] Each row has: created_by_txn (xmin) and deleted_by_txn (xmax)
  - [ ] Reader sees only rows where: xmin < reader's txn AND (xmax is empty OR xmax > reader's txn)
- [ ] **Snapshot isolation**: each transaction sees a consistent snapshot of the database
- [ ] **Write conflicts**: two transactions writing same row → one must abort (first-writer-wins)
- [ ] **VACUUM (PostgreSQL)**: clean up old versions that no transaction can see anymore
- [ ] **MVCC in other systems**: MySQL InnoDB (undo logs), Oracle (rollback segments)
- [ ] Design implication: long-running transactions hold old versions → bloat → performance degradation

## Module 6: Query Planning Basics
- [ ] **Query planner/optimizer**: converts SQL into an execution plan
- [ ] **Execution plan**: tree of operations (scan → filter → join → sort → project)
- [ ] **Scan types**:
  - [ ] Sequential scan: read all rows (full table scan)
  - [ ] Index scan: use B-tree index to find specific rows
  - [ ] Index-only scan: answer from index without touching table (covering index)
  - [ ] Bitmap scan: index lookup → bitmap of matching pages → fetch pages
- [ ] **Join algorithms**:
  - [ ] Nested loop: for each row in A, scan B (good for small datasets)
  - [ ] Hash join: build hash table on smaller table, probe with larger (good for equality joins)
  - [ ] Merge join: sort both tables, merge (good for pre-sorted data)
- [ ] **Statistics**: planner uses table statistics (row count, value distribution) to choose plan
  - [ ] Stale statistics → bad plans → poor performance → run ANALYZE
- [ ] **EXPLAIN ANALYZE**: run the query, show actual execution plan with timing
- [ ] Design implication: know what makes a query slow so you can design schemas that perform

## Module 7: Consensus Algorithms
- [ ] **The consensus problem**: how do distributed nodes agree on a value despite failures?
- [ ] **Why it matters**: leader election, distributed locks, replicated state machines, metadata management
- [ ] **Paxos** (Lamport):
  - [ ] Proposer → Acceptors → Learners
  - [ ] Proposal: prepare → promise → accept → accepted
  - [ ] Theoretically elegant, notoriously hard to implement
  - [ ] Used by: Google Chubby, Google Spanner
- [ ] **Raft** (Ongaro & Ousterhout):
  - [ ] Designed to be understandable (unlike Paxos)
  - [ ] Leader election → log replication → safety
  - [ ] Leader sends heartbeats; on timeout, follower starts election
  - [ ] Committed = majority of nodes have the entry
  - [ ] Used by: etcd, CockroachDB, TiDB, Kafka KRaft, Consul, RabbitMQ quorum queues
- [ ] **Raft vs Paxos**: same guarantees, Raft is more practical and widely adopted
- [ ] **ZAB (ZooKeeper Atomic Broadcast)**: ZooKeeper's consensus protocol (similar to Raft)
- [ ] Design implication: when you say "strongly consistent" in a design, there's a consensus protocol underneath

## Module 8: Hot Partitions & Secondary Indexes
- [ ] **Hot partition**: one shard/partition receives disproportionate traffic
  - [ ] Celebrity problem: one user ID generates massive fan-out
  - [ ] Time-based keys: all writes go to "today's" partition
- [ ] **Mitigation**:
  - [ ] Salting: add random prefix to hot keys → spread across partitions
  - [ ] Compound keys: user_id + timestamp → distribute writes
  - [ ] Application-level splitting: detect hot keys, route to dedicated handling
- [ ] **Secondary indexes in distributed systems**:
  - [ ] **Local secondary index**: each partition maintains its own index (write-fast, read-scatter)
  - [ ] **Global secondary index**: single index across all partitions (read-fast, write-scatter)
- [ ] **Partition-aware queries**: design queries to target single partition (include partition key)
- [ ] Design decision: secondary index strategy affects read/write performance trade-offs dramatically

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare PostgreSQL (B-tree) vs Cassandra (LSM) for a time-series workload — explain WHY |
| Module 2 | Draw how a B-tree index lookup works for `SELECT * WHERE id = 42` across 3 levels |
| Module 3 | Explain compaction and why LSM trees have write amplification — draw the merge process |
| Module 4 | Build a simple inverted index for 5 documents, query it for "distributed AND systems" |
| Module 5 | Explain how two concurrent transactions see different versions of the same row (draw timeline) |
| Module 6 | Run EXPLAIN ANALYZE on a slow query, identify whether it needs an index or a join change |
| Module 7 | Walk through a Raft leader election: 5 nodes, leader dies, new leader elected |
| Module 8 | Design partition strategy for Twitter-like system — handle celebrity hot partition problem |

## Key Resources
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapters 3, 5, 7, 9) — THE book for this topic
- "In Search of an Understandable Consensus Algorithm" - Ongaro & Ousterhout (Raft paper)
- "The Log: What every software engineer should know" - Jay Kreps
- Use the Index, Luke (use-the-index-luke.com) — SQL indexing deep dive
- PostgreSQL EXPLAIN documentation
