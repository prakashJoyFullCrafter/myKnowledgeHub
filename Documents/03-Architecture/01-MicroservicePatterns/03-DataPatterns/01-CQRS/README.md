# CQRS - Curriculum

## Module 1: Concept
- [ ] **Command Query Responsibility Segregation**: separate the write model (commands) from the read model (queries)
- [ ] Traditional CRUD: same model for reads and writes — works until it doesn't
- [ ] Problem: reads and writes have different optimization needs (reads want denormalized, writes want normalized)
- [ ] CQRS: two models, each optimized independently

## Module 2: Architecture
- [ ] **Write side (Command)**: receives commands → validates → updates write store → publishes events
- [ ] **Read side (Query)**: subscribes to events → updates read store → serves queries
- [ ] **Write store**: normalized, optimized for consistency (PostgreSQL, event store)
- [ ] **Read store**: denormalized, optimized for query patterns (Elasticsearch, Redis, materialized views)
- [ ] **Sync mechanism**: events (Kafka, RabbitMQ), CDC (Debezium), or database triggers
- [ ] **Eventual consistency**: read model may lag behind write model — must be acceptable

## Module 3: Variations
- [ ] **CQRS without event sourcing** (simpler): same DB, different query/command services, shared tables or materialized views
- [ ] **CQRS with event sourcing**: write side stores events, read side projects events into query-optimized views
- [ ] **Single DB CQRS**: separate read/write repositories in code, same database — lowest complexity
- [ ] **Two DB CQRS**: separate databases for read and write — highest flexibility, highest complexity
- [ ] Materialized views as lightweight CQRS (PostgreSQL `CREATE MATERIALIZED VIEW`)

## Module 4: When to Use & Anti-Patterns
- [ ] **When CQRS is worth it**:
  - [ ] Read/write ratio is heavily skewed (99% reads)
  - [ ] Read and write models are fundamentally different shapes
  - [ ] Need to scale reads and writes independently
  - [ ] Complex domain with event sourcing
- [ ] **When to avoid**:
  - [ ] Simple CRUD with no performance issues
  - [ ] Strong consistency required (eventual consistency not acceptable)
  - [ ] Small team — CQRS adds significant complexity
- [ ] **Anti-pattern**: applying CQRS to every service (most services don't need it)
- [ ] **Anti-pattern**: ignoring eventual consistency in UI (user writes, refreshes, doesn't see change)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build order service: write to PostgreSQL, project to Elasticsearch for search queries |
| Module 3 | Compare: same-DB CQRS (materialized view) vs two-DB CQRS (PostgreSQL + Redis) |
| Module 4 | Evaluate: which services in your system actually benefit from CQRS? |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 7: CQRS)
- "CQRS" - Martin Fowler (blog)
- Implementing Domain-Driven Design - Vaughn Vernon
- Axon Framework documentation (CQRS + Event Sourcing)
