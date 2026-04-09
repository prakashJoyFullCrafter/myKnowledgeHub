# Distributed ID Generation - Curriculum

## Module 1: Why Distributed IDs?
- [ ] Single DB auto-increment breaks with multiple databases/shards
- [ ] Need: globally unique, sortable, low latency, high throughput
- [ ] ID requirements vary by use case: sortable? compact? human-readable? unguessable?

## Module 2: UUID
- [ ] **UUID v4**: 128-bit random, `550e8400-e29b-41d4-a716-446655440000`
  - [ ] Truly random, no coordination needed, zero collision probability
  - [ ] Downsides: 36 chars (storage), not sortable, bad for B-tree index performance
- [ ] **UUID v7** (2024+): time-ordered UUID, sortable, random suffix
  - [ ] Best of both: globally unique + time-sortable + no coordination
  - [ ] Recommended as default choice for new systems
- [ ] **ULID**: 128-bit, Crockford Base32, time-ordered, lexicographically sortable
  - [ ] `01ARZ3NDEKTSV4RRFFQ69G5FAV` — shorter string than UUID

## Module 3: Snowflake ID
- [ ] Twitter Snowflake: 64-bit integer, time-sortable
- [ ] Structure: `| 1 bit unused | 41 bits timestamp | 10 bits machine ID | 12 bits sequence |`
  - [ ] Timestamp: milliseconds since custom epoch → 69 years
  - [ ] Machine ID: 1024 unique workers
  - [ ] Sequence: 4096 IDs per millisecond per machine
- [ ] Total: ~4 million IDs/sec per machine, globally unique, sortable
- [ ] Advantages: 64-bit (efficient indexing), sortable, compact
- [ ] Challenges: clock drift (NTP sync), machine ID assignment, epoch selection
- [ ] Variations: Discord Snowflake, Instagram ID, Sony Sonyflake

## Module 4: Database-Based Approaches
- [ ] **Auto-increment with step**: DB1 generates odd IDs, DB2 even IDs
  - [ ] Simple, but hard to add more databases
- [ ] **Ticket server** (Flickr): centralized DB that generates IDs
  - [ ] `REPLACE INTO tickets (stub) VALUES ('a'); SELECT LAST_INSERT_ID();`
  - [ ] Simple, but single point of failure (mitigate with two ticket servers, odd/even)
- [ ] **Sequence table with ranges**: each service claims a range (e.g., 1-1000), generates locally
  - [ ] Reduces DB calls, but gaps in sequences
- [ ] **Redis INCR**: atomic increment, fast, but need persistence for durability

## Module 5: Choosing the Right Strategy
- [ ] | Strategy | Sortable | Size | Coordination | Throughput |
  | --- | --- | --- | --- | --- |
  | UUID v4 | No | 128 bit | None | Unlimited |
  | UUID v7 | Yes | 128 bit | None | Unlimited |
  | ULID | Yes | 128 bit | None | Unlimited |
  | Snowflake | Yes | 64 bit | Machine ID | ~4M/sec/node |
  | DB auto-inc | Yes | 64 bit | Single DB | Limited |
  | Ticket server | Yes | 64 bit | Central server | Moderate |
- [ ] **Default recommendation**: UUID v7 (simple, no coordination, sortable)
- [ ] **High-volume systems**: Snowflake (compact 64-bit, fast, sortable)
- [ ] **Simple single-DB apps**: auto-increment is fine
- [ ] Anti-pattern: using sequential IDs in public URLs (enumeration attack) → use UUID/ULID for external

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Generate UUID v4 vs UUID v7 — compare B-tree index insert performance in PostgreSQL |
| Module 3 | Implement a Snowflake ID generator in Java (64-bit, timestamp + machine + sequence) |
| Module 4 | Build a ticket server with Redis INCR, benchmark throughput |
| Module 5 | Given a multi-shard e-commerce system, justify your ID strategy choice |

## Key Resources
- "Announcing Snowflake" - Twitter engineering blog
- "Sharding & IDs at Instagram" - Instagram engineering blog
- RFC 9562 - UUID v7 specification
- System Design Interview - Alex Xu (Chapter: Unique ID Generator)
