# Service Decomposition - Curriculum

How to identify the right service boundaries — the hardest decision in microservices.

---

## Module 1: Why Decomposition Matters
- [ ] Wrong boundaries → distributed monolith (worst of both worlds)
- [ ] Too fine-grained → excessive network calls, operational overhead, data consistency nightmares
- [ ] Too coarse-grained → not getting benefits of microservices
- [ ] Boundaries are expensive to change later — invest time upfront

## Module 2: Decomposition Strategies
- [ ] **By business capability**: align services to what the business DOES
  - [ ] Examples: Order Management, Inventory, Shipping, Payment, User Management
  - [ ] Stable boundaries — business capabilities change slowly
  - [ ] Recommended as primary approach
- [ ] **By subdomain (DDD)**: align services to Domain-Driven Design bounded contexts
  - [ ] Core domain: competitive advantage → invest most (Order Processing)
  - [ ] Supporting domain: needed but not differentiating (Invoicing)
  - [ ] Generic domain: commodity → buy/use existing (Email, Auth)
  - [ ] Each bounded context = potential service boundary
- [ ] **By team (Inverse Conway's Law)**: organize services around team structure
  - [ ] "Organizations design systems that mirror their communication structures"
  - [ ] Inverse: design team structure to get the architecture you want
  - [ ] Each team owns 1-3 services end-to-end (build, deploy, operate)

## Module 3: Identifying Boundaries
- [ ] **Event Storming**: collaborative workshop to discover domain events, commands, aggregates
  - [ ] Sticky notes: orange = events, blue = commands, yellow = aggregates, pink = hotspots
  - [ ] Natural clusters of events/commands → service boundaries
- [ ] **Context Mapping (DDD)**: map relationships between bounded contexts
  - [ ] Upstream/downstream, shared kernel, anti-corruption layer, conformist
- [ ] **Data ownership**: who owns this entity? → that service owns it
  - [ ] If two services need the same data → one owns it, other subscribes to events
- [ ] **Change frequency**: things that change together should be in the same service
- [ ] **Coupling analysis**: high coupling between modules → maybe they should be one service

## Module 4: Sizing & Anti-Patterns
- [ ] **Right size indicators**:
  - [ ] Team of 5-8 can own and operate it (two-pizza team)
  - [ ] Can be rewritten in 2-4 weeks
  - [ ] Has clear, bounded API (5-10 endpoints, not 100)
  - [ ] Owns its data — no shared database
  - [ ] Can be deployed independently
- [ ] **Too small (nano-services)**:
  - [ ] One function = one service (just use a function, not a service)
  - [ ] Excessive inter-service calls for simple operations
  - [ ] Operational overhead exceeds benefits
- [ ] **Too large (mini-monolith)**:
  - [ ] Multiple teams work on same service
  - [ ] Deploys are coordinated across teams
  - [ ] Service has 50+ endpoints covering unrelated domains
- [ ] **Anti-pattern: entity service** — User Service, Order Service as CRUD wrappers (anemic services)
  - [ ] Better: services around behavior/capability, not data entities

## Module 5: Practical Approach
- [ ] **Start with monolith** (monolith-first): build modular monolith, extract when needed
- [ ] **Use Spring Modulith**: verify module boundaries before extracting
- [ ] **Extract incrementally**: Strangler Fig pattern, one service at a time
- [ ] **Extraction order**: start with the most independent, least-coupled module
- [ ] **Validate boundary**: if extracting a module requires changing 10 other modules → wrong boundary
- [ ] **Living architecture**: boundaries evolve — be ready to merge or split services

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Map business capabilities for an e-commerce domain, identify 6-8 potential services |
| Module 3 | Run an Event Storming session (even solo) for a domain you know, cluster into bounded contexts |
| Module 4 | Audit a microservices system: are any services too small (nano) or too large (mini-monolith)? |
| Module 5 | Take a monolith, identify the first module to extract, plan the strangler approach |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 2: Decomposition)
- Building Microservices (2nd ed.) - Sam Newman (Chapter: Decomposition)
- Domain-Driven Design - Eric Evans (Bounded Contexts)
- "Event Storming" - Alberto Brandolini
- Team Topologies - Matthew Skelton & Manuel Pais (team structure → architecture)
