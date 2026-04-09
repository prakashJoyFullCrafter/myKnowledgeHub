# Database per Service - Curriculum

The foundational data ownership pattern in microservices — every other data pattern builds on this.

---

## Module 1: The Pattern
- [ ] Each microservice **owns its data** — private database, no shared tables
- [ ] Other services cannot access another service's database directly — only through its API
- [ ] Why? Loose coupling, independent deployment, independent scaling, technology freedom
- [ ] Without this: you have a distributed monolith (services coupled through shared DB)

## Module 2: Implementation Strategies
- [ ] **Private database per service**: each service gets its own database instance
  - [ ] Strongest isolation, independent scaling, different DB technology per service
  - [ ] Highest cost (many database instances)
- [ ] **Schema per service**: shared database server, private schema per service
  - [ ] Lower cost, but shared resource (CPU, memory, connections)
  - [ ] Access control via database permissions — enforce boundary
- [ ] **Table per service**: shared schema, dedicated tables per service
  - [ ] Weakest isolation, easy to break boundaries (join across tables)
  - [ ] Acceptable only as stepping stone during migration from monolith

## Module 3: Challenges & Solutions
- [ ] **Cross-service queries**: can't JOIN across databases
  - [ ] Solution: API composition — service aggregates data from multiple services via API calls
  - [ ] Solution: CQRS — build denormalized read model from events
- [ ] **Cross-service transactions**: can't use ACID across services
  - [ ] Solution: Saga pattern — sequence of local transactions with compensations
  - [ ] Solution: Outbox pattern — reliable event publishing
- [ ] **Data duplication**: services may need copies of each other's data
  - [ ] Solution: event-driven sync — subscribe to events, maintain local copy
  - [ ] Accept eventual consistency for read data
- [ ] **Referential integrity**: no foreign keys across service boundaries
  - [ ] Solution: eventual consistency checks, compensating actions on orphaned data
- [ ] **Reporting**: can't query across all services
  - [ ] Solution: data lake/warehouse — aggregate data via events or CDC

## Module 4: Choosing Database Per Service
- [ ] **Polyglot persistence**: pick the best DB for each service's needs
  - [ ] Order service → PostgreSQL (relational, transactions)
  - [ ] Product search → Elasticsearch (full-text search)
  - [ ] Session service → Redis (key-value, fast)
  - [ ] Activity feed → Cassandra (write-heavy, time-series)
- [ ] **Migration from shared DB**: gradual extraction
  1. Identify service boundaries and data ownership
  2. Create API for data access (stop direct DB queries)
  3. Duplicate data to new DB, sync via CDC/events
  4. Cut over: service reads/writes from own DB
  5. Remove old tables from shared DB
- [ ] Anti-pattern: shared database between services — "integration database"
- [ ] Anti-pattern: service directly querying another service's DB "just for reporting"

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Design data ownership for e-commerce: user, order, product, inventory — which service owns what? |
| Module 3 | Implement "order with user details" query using API composition (no cross-DB join) |
| Module 4 | Extract product service from shared DB: create API, sync data, cut over |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 2: Database per Service)
- "Database per Service" - microservices.io
- Building Microservices - Sam Newman (Chapter: Data)
- Monolith to Microservices - Sam Newman
