# Consistent Hashing - Curriculum

## Module 1: The Problem
- [ ] Simple hashing: `server = hash(key) % N`
- [ ] When N changes (add/remove server): almost ALL keys remap → cache storm, data migration
- [ ] Need: a scheme where adding/removing nodes moves minimal data

## Module 2: Hash Ring
- [ ] Map both keys and servers onto a circular hash space (0 to 2^32-1)
- [ ] Each key is assigned to the **next server clockwise** on the ring
- [ ] Adding a node: only keys between new node and its predecessor remap
- [ ] Removing a node: only that node's keys remap to the next clockwise node
- [ ] On average, only `K/N` keys move (K = total keys, N = total nodes)

## Module 3: Virtual Nodes
- [ ] Problem: with few physical nodes, distribution is uneven
- [ ] **Virtual nodes (vnodes)**: each physical node maps to multiple points on the ring
- [ ] More vnodes → more even distribution (typically 100-200 vnodes per physical node)
- [ ] Heterogeneous capacity: powerful servers get more vnodes
- [ ] Trade-off: more vnodes = better distribution but more metadata to manage

## Module 4: Alternatives
- [ ] **Jump consistent hashing**: O(1) memory, no ring, faster — but only works when servers are numbered 0..N
- [ ] **Rendezvous hashing (HRW)**: compute score for each server, pick highest — no ring needed
  - [ ] O(N) per lookup, but elegant and no metadata
- [ ] **Maglev hashing** (Google): lookup table for ultra-fast consistent hashing at scale
- [ ] Comparison: ring (flexible) vs jump (fast, limited) vs rendezvous (simple, O(N))

## Module 5: Real-World Usage
- [ ] **Distributed caches**: Memcached, Redis Cluster — route keys to correct shard
- [ ] **Database sharding**: DynamoDB, Cassandra partition assignment
- [ ] **Load balancing**: consistent hashing for sticky sessions without server affinity
- [ ] **CDN**: mapping content to edge servers
- [ ] **Distributed storage**: Amazon S3, HDFS data placement
- [ ] Implementation in Java: `TreeMap` as hash ring, `MD5`/`MurmurHash` for hashing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement a hash ring in Java with `TreeMap<Integer, String>` |
| Module 3 | Add virtual nodes, measure distribution evenness before and after |
| Module 4 | Implement rendezvous hashing, compare key distribution with consistent hashing |
| Module 5 | Build a simple distributed cache client that uses consistent hashing for routing |

## Key Resources
- "Consistent Hashing and Random Trees" - Karger et al. (original paper)
- Designing Data-Intensive Applications - Martin Kleppmann
- System Design Interview - Alex Xu (Chapter: Consistent Hashing)
- "Maglev: A Fast and Reliable Software Network Load Balancer" - Google
