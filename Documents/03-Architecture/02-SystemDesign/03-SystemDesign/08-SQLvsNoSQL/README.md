# SQL vs NoSQL - Curriculum

## Module 1: SQL (Relational) Databases
- [ ] ACID properties: Atomicity, Consistency, Isolation, Durability
- [ ] Structured schema: tables, rows, columns, foreign keys
- [ ] Joins: normalize data, query across tables
- [ ] Strong consistency by default
- [ ] Vertical scaling primarily (read replicas for horizontal reads)
- [ ] Best for: complex queries, transactions, relational data, well-defined schema
- [ ] Examples: PostgreSQL, MySQL, Oracle, SQL Server

## Module 2: NoSQL Database Types
- [ ] **Key-Value stores**: simplest model, O(1) lookups by key
  - [ ] Redis, Memcached, DynamoDB (also document), etcd
  - [ ] Use cases: caching, session storage, feature flags, rate limiting
- [ ] **Document stores**: JSON-like documents, flexible schema, nested data
  - [ ] MongoDB, CouchDB, Firestore
  - [ ] Use cases: content management, user profiles, catalogs, event logs
- [ ] **Wide-Column stores**: rows with dynamic columns, column families
  - [ ] Cassandra, HBase, ScyllaDB
  - [ ] Use cases: time-series, IoT, analytics, write-heavy workloads
- [ ] **Graph databases**: nodes + edges + properties, relationship-first
  - [ ] Neo4j, Amazon Neptune, ArangoDB
  - [ ] Use cases: social networks, recommendation engines, fraud detection, knowledge graphs
- [ ] **Time-Series databases**: optimized for time-stamped data
  - [ ] InfluxDB, TimescaleDB (PostgreSQL extension), Prometheus
  - [ ] Use cases: metrics, monitoring, IoT sensor data, financial data
- [ ] **Search engines**: full-text search, inverted indexes
  - [ ] Elasticsearch, OpenSearch, Solr
  - [ ] Use cases: search, log aggregation, analytics

## Module 3: SQL vs NoSQL Decision Framework
- [ ] **Choose SQL when**:
  - [ ] Data is relational with complex joins
  - [ ] ACID transactions are required
  - [ ] Schema is well-defined and stable
  - [ ] Complex queries (aggregations, GROUP BY, subqueries)
  - [ ] Data integrity is critical (financial, medical)
- [ ] **Choose NoSQL when**:
  - [ ] Schema is flexible or evolving rapidly
  - [ ] Massive write throughput needed
  - [ ] Horizontal scaling is essential
  - [ ] Data is denormalized by nature (documents, events)
  - [ ] Specific access pattern (key lookup, graph traversal, time-series)
- [ ] **Polyglot persistence**: use different databases for different parts of the system
  - [ ] PostgreSQL for orders + Redis for cache + Elasticsearch for search + Cassandra for analytics

## Module 4: Scaling Comparison
- [ ] SQL scaling: vertical first, then read replicas, then sharding (hard)
- [ ] NoSQL scaling: designed for horizontal scaling from the start
- [ ] **NewSQL**: distributed SQL databases (CockroachDB, TiDB, YugabyteDB, Spanner)
  - [ ] SQL interface + horizontal scaling + ACID + distributed
  - [ ] Trade-off: higher latency than single-node SQL
- [ ] When to consider NewSQL: need SQL + scale + strong consistency

## Module 5: Data Modeling Differences
- [ ] SQL: **normalize** (reduce duplication, use joins)
- [ ] NoSQL: **denormalize** (embed data, optimize for read patterns)
- [ ] SQL: model the DATA first, then worry about queries
- [ ] NoSQL: model the QUERIES first, then structure data to serve them
- [ ] Example: "User with orders"
  - [ ] SQL: `users` table + `orders` table + JOIN
  - [ ] Document DB: embed orders array inside user document
  - [ ] Wide-column: partition by user_id, columns for each order
- [ ] NoSQL anti-pattern: using a document DB like a relational DB (excessive references)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Model an e-commerce system in PostgreSQL (normalized, 3NF) |
| Module 2 | Implement same data in MongoDB (embedded), Redis (cache), Elasticsearch (search) |
| Module 3 | Given 5 scenarios, justify SQL vs NoSQL choice for each |
| Module 4 | Compare query performance: PostgreSQL vs MongoDB vs Cassandra at 1M records |
| Module 5 | Model "Twitter feed" in SQL (normalized) vs Cassandra (denormalized), compare query complexity |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapters 2-3)
- MongoDB documentation - Data Modeling
- "SQL vs NoSQL" - Fireship (YouTube, quick overview)
- System Design Interview - Alex Xu
- "How Discord Stores Billions of Messages" (Cassandra → ScyllaDB migration)
