# Multi-Region & Geo-Distributed Design - Curriculum

How to design systems that operate across multiple geographic regions — for latency, availability, and compliance.

---

## Module 1: Why Multi-Region?
- [ ] **Latency**: serve users from nearest region (200ms cross-continent → 20ms same-region)
- [ ] **Availability**: survive entire region failure (AWS us-east-1 outage shouldn't take you down)
- [ ] **Compliance**: data residency laws require data to stay in specific regions
  - [ ] GDPR: EU user data in EU; DPDPA: Indian user data in India
  - [ ] Financial regulations: some countries require in-country data processing
- [ ] **Cost of multi-region**: complexity, data replication, operational overhead, higher infrastructure cost
- [ ] **Single-region is fine** for: internal tools, early-stage startups, non-critical systems
- [ ] **Multi-region is needed** for: global consumer apps, financial systems, SLA > 99.95%
- [ ] Design decision: don't go multi-region until you have a clear reason (latency, compliance, or HA requirement)

## Module 2: Active-Passive vs Active-Active
- [ ] **Active-passive (primary-secondary)**:
  - [ ] One region handles all traffic, second region is standby
  - [ ] On failure: DNS failover to passive region
  - [ ] Pros: simple, no write conflicts, lower cost
  - [ ] Cons: passive region idle (wasted resources), failover latency (minutes)
  - [ ] Use case: DR for business-critical systems, compliance
- [ ] **Active-active (multi-primary)**:
  - [ ] All regions handle read AND write traffic simultaneously
  - [ ] Pros: low latency globally, no single point of failure, zero-downtime failover
  - [ ] Cons: write conflicts, data consistency complexity, higher cost
  - [ ] Use case: global consumer apps (Netflix, Uber, Airbnb)
- [ ] **Active-active for reads, active-passive for writes**: common middle ground
  - [ ] All regions serve reads from local replicas
  - [ ] Writes routed to primary region
  - [ ] Simpler than full active-active, good enough for most systems
- [ ] Design decision: start with active-passive; move to active-active only when latency or SLA demands it

## Module 3: Data Replication Across Regions
- [ ] **Synchronous replication**: write confirmed only after ALL regions acknowledge
  - [ ] Strong consistency, but latency = cross-region round trip (100-300ms per write)
  - [ ] Only for: financial transactions, critical metadata
- [ ] **Asynchronous replication**: write confirmed locally, replicated to other regions in background
  - [ ] Fast writes, but replication lag → temporary inconsistency
  - [ ] Risk: data loss if primary region fails before replication
- [ ] **Semi-synchronous**: write confirmed after at least one remote region acknowledges
  - [ ] Balance between consistency and latency
- [ ] **Conflict resolution** (for active-active writes):
  - [ ] Last-writer-wins (LWW): simplest, but can lose data
  - [ ] Vector clocks: detect conflicts, let application resolve
  - [ ] CRDTs (Conflict-free Replicated Data Types): automatic resolution for specific data structures
  - [ ] Application-level merge: custom logic (e.g., merge shopping carts)
- [ ] **Replication lag monitoring**: alert when lag exceeds acceptable threshold
- [ ] Design decision: most systems use async replication with conflict resolution for specific entities

## Module 4: Global Traffic Management
- [ ] **GeoDNS**: resolve DNS to nearest region's IP based on client location
  - [ ] Route 53 geolocation/geoproximity routing, Cloudflare geo-steering
- [ ] **Anycast**: same IP advertised from multiple regions, network routes to nearest
  - [ ] Used by CDNs (Cloudflare), DNS providers
- [ ] **Global load balancer**: Google Cloud Global LB, AWS Global Accelerator
  - [ ] Health checks per region → automatic failover
  - [ ] Latency-based routing: route to lowest-latency region (not always nearest)
- [ ] **Regional failover**:
  - [ ] Health check detects region failure → DNS/LB routes traffic to surviving regions
  - [ ] Surviving regions must handle increased load (capacity planning for N-1 regions)
- [ ] **Sticky routing**: route same user to same region for session consistency
- [ ] **Traffic splitting**: gradually shift traffic between regions (canary for region migration)
- [ ] Design decision: DNS-based for simple failover, global LB for latency-based routing

## Module 5: Leader Placement & Data Partitioning
- [ ] **Single global leader**: one region owns all writes for a data entity
  - [ ] Simple consistency, but all writes have cross-region latency for remote users
- [ ] **Regional leader**: each region is leader for its local users' data
  - [ ] User data partitioned by geography: EU users' data → EU region
  - [ ] Works when data has natural geographic affinity (user profiles, local content)
- [ ] **Per-entity leader**: each entity (row, record) assigned to a home region
  - [ ] Entity moves to user's region: user moves EU → US, data migrates
  - [ ] Complex but optimal for global active-active
- [ ] **Cross-region reads**: always OK (read from nearest replica)
- [ ] **Cross-region writes**: route to leader's region → replication lag for local reads
- [ ] **CockroachDB / Spanner approach**: automatic leader placement near writers, Raft consensus
- [ ] Design decision: regional partitioning by user location is the most practical starting point

## Module 6: Cross-Region Consistency Patterns
- [ ] **Eventual consistency** (default): writes propagate asynchronously, reads may be stale
  - [ ] Acceptable for: social media feeds, product catalogs, non-critical data
- [ ] **Read-your-writes**: after writing, user always sees their own write (even if others don't yet)
  - [ ] Implementation: route user's reads to the region they wrote to (for a short window)
  - [ ] Or: include write timestamp in session, only serve if replica is caught up
- [ ] **Causal consistency**: if A causes B, everyone sees A before B
  - [ ] Implementation: causal dependency tracking, vector clocks
- [ ] **Strong consistency across regions**: consensus (Raft/Paxos) spanning regions
  - [ ] Latency: every write waits for majority of regions → expensive
  - [ ] Google Spanner: TrueTime (atomic clocks + GPS) for global strong consistency
  - [ ] CockroachDB: uses NTP with bounded uncertainty
- [ ] **Consistency per operation**: not all operations need the same consistency level
  - [ ] Account balance: strong consistency
  - [ ] Profile picture: eventual consistency
  - [ ] Order status: read-your-writes
- [ ] Design decision: define consistency requirements PER ENTITY and PER OPERATION, not globally

## Module 7: Cost, Latency & Consistency Trade-offs
- [ ] **The multi-region trilemma**: you optimize for two of: low cost, low latency, strong consistency
- [ ] **Cost factors**:
  - [ ] Cross-region data transfer: $0.01-0.02/GB (AWS) — adds up at scale
  - [ ] Duplicate infrastructure: compute, storage, databases in each region
  - [ ] Operational cost: more regions = more to monitor, debug, deploy
- [ ] **Latency factors**:
  - [ ] Same-region: 1-5ms
  - [ ] Cross-continent: 100-300ms round trip
  - [ ] Strong consistency writes: at least one cross-region round trip
- [ ] **Region selection**: start with regions closest to your users
  - [ ] US-East + EU-West covers most global traffic
  - [ ] Add Asia-Pacific for APAC users
  - [ ] Availability Zones within a region: simpler HA without multi-region complexity
- [ ] **Start small**: multi-AZ first → active-passive second region → active-active later
- [ ] **Testing multi-region**: chaos testing (kill a region), failover drills, replication lag simulation
- [ ] Design framework:
  - [ ] Step 1: Do you actually need multi-region? (most systems don't)
  - [ ] Step 2: Active-passive or active-active?
  - [ ] Step 3: How to partition data across regions?
  - [ ] Step 4: What consistency level per entity?
  - [ ] Step 5: How to handle failover?

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Evaluate: does your e-commerce system need multi-region? Justify with latency/compliance/HA analysis |
| Module 2 | Design active-passive DR for a fintech system — failover process, RPO, RTO |
| Module 3 | Design active-active for a chat app — how to handle two users in different regions editing same group? |
| Module 4 | Design global traffic routing: GeoDNS + health checks + failover for a 3-region deployment |
| Module 5 | Design data partitioning for a global social media app — which data is regional, which is global? |
| Module 6 | Define consistency levels for an e-commerce system: user profile, inventory, orders, recommendations |
| Module 7 | Cost estimate: single-region vs 2-region active-passive vs 3-region active-active for 100TB data |

## Key Resources
- **Designing Data-Intensive Applications** - Martin Kleppmann (Chapters 5, 8, 9)
- "How Netflix Serves Millions Globally" - Netflix Tech Blog
- "Building Uber's Global Platform" - Uber engineering blog
- Google Spanner paper: "Spanner: Google's Globally-Distributed Database"
- AWS Multi-Region Architecture whitepaper
- CockroachDB multi-region documentation
