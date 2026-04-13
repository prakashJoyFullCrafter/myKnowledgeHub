# Apache Kafka

Distributed event streaming platform — mastery-level curriculum.

## Sections

### Foundations
1. **Core Concepts** (4 topics) — Topics & Partitions, Producers & Consumers, Consumer Groups, Offsets — full module breakdown
2. **Advanced** (5 topics) — Kafka Streams, Schema Registry, Exactly-Once, KSQL, Kafka Connect
3. **Spring Integration** (2 topics) — Spring Kafka, Producer/Consumer Configuration
4. **Cluster & Operations** — Architecture, KRaft, replication, topic management, performance tuning, monitoring, security

### Mastery Deep Dives
5. **Storage Internals** — Log structure, record format, indexes, page cache, zero-copy, log cleaner, tiered storage (KIP-405), disk layout, crash recovery
6. **Replication Protocol** — LEO/HW, follower fetch, ISR management, leader election, leader epoch (KIP-101), KRaft controller, durability guarantees
7. **Client Internals** — Producer RecordAccumulator/Sender, metadata management, consumer fetcher/coordinator, heartbeat/session, rebalance protocol internals, troubleshooting
8. **Multi-DC & Disaster Recovery** — Stretched vs replicated clusters, MirrorMaker 2, offset translation, active-active, Cluster Linking, backup strategies, failover runbooks
9. **Security Deep Dive** — Threat model, TLS/mTLS, SASL (PLAIN/SCRAM/Kerberos/OAUTHBEARER), ACLs, encryption at rest, multi-tenant isolation, audit/compliance
10. **Capacity Planning & Troubleshooting** — Sizing formulas, partition count, benchmarking, key metrics, common problems, anti-patterns, JVM tuning, scaling operations
