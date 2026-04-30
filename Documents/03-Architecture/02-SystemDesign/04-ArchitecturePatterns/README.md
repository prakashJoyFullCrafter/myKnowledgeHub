# Architecture Patterns - Curriculum

> **Application architecture patterns** (Mark Richards / Neal Ford taxonomy) — sit between **GoF design patterns** (object level) and **microservice patterns** (distributed system level). They describe how to organise a single application or system at the highest structural level.

## Module 1: Pattern Selection — How to Choose
- [ ] No "best" architecture — every pattern is a set of trade-offs across **architectural characteristics** (NFRs)
- [ ] Key trade-off axes: deployability, elasticity, fault tolerance, performance, scalability, simplicity, testability, evolvability, cost
- [ ] **Rate each pattern on a star scale** for each characteristic — Mark Richards' "characteristics ratings"
- [ ] Common selection mistakes:
  - [ ] Resume-driven architecture ("microservices because everyone uses them")
  - [ ] One-size-fits-all (forcing event-driven everywhere)
  - [ ] Ignoring team topology (Conway's Law guarantees it bites you)
- [ ] Decision inputs: domain complexity, team size & maturity, deployment cadence, scale targets, budget, regulatory constraints
- [ ] **Architecture quantum**: smallest deployable + independently functional unit — defines real boundaries (single quantum vs distributed)

## Module 2: Layered (N-Tier) Architecture
- [ ] **Structure**: Presentation → Business → Persistence → Database (closed layers — call only the layer below)
- [ ] **Open vs closed layers**: closed = strict; open = skip-layer allowed (use sparingly)
- [ ] **The "sinkhole anti-pattern"**: requests pass through layers doing nothing → hint that layers are wrong abstraction
- [ ] **Strengths**: simple, well-understood, low cost, great for small teams, separation of technical concerns
- [ ] **Weaknesses**: monolithic deployment, change ripples across layers (each feature touches every layer), poor elasticity, low evolvability
- [ ] **Best fit**: small applications, MVPs, internal tools, teams new to architecture
- [ ] **Worst fit**: high-scale systems, frequent independent deployments, polyglot teams
- [ ] **Characteristics**: deployability ★, elasticity ★, simplicity ★★★★★, cost ★★★★★, evolvability ★

## Module 3: Microkernel (Plug-In) Architecture
- [ ] **Structure**: minimal **core system** + **plug-in modules** registered at runtime/build time
- [ ] **Core** holds general logic, lifecycle, plug-in registry, contracts; **plug-ins** hold variant/domain logic
- [ ] **Examples**: IDEs (Eclipse, IntelliJ, VS Code), browsers (extensions), Jenkins, Salesforce, insurance rules engines
- [ ] **Plug-in contracts**: well-defined interfaces (ports), often with versioning to allow plug-in evolution
- [ ] **Strengths**: extensibility without core changes, third-party ecosystem possible, simple core
- [ ] **Weaknesses**: contract design is hard, cross-plug-in dependencies are painful, runtime plug-in loading adds complexity
- [ ] **Best fit**: products with variant features per customer/region, rule engines, extensible platforms
- [ ] **Characteristics**: deployability ★★★★, evolvability ★★★★★, simplicity ★★★, fault tolerance ★★ (plug-in faults can crash core)

## Module 4: Event-Driven Architecture
- [ ] Two topologies:
  - [ ] **Broker**: events published to topics, consumers subscribe — choreography style, no central control (Kafka, RabbitMQ pub/sub)
  - [ ] **Mediator**: central event mediator orchestrates multi-step processes (Camunda, Apache Camel)
- [ ] **Async by default** — no request/response coupling
- [ ] **Strengths**: high scalability, high responsiveness, decoupled producers/consumers, natural fit for real-time
- [ ] **Weaknesses**: hard to reason about flow, complex error handling, eventual consistency everywhere, debugging requires distributed tracing
- [ ] **Required infrastructure**: durable broker, schema registry, dead-letter handling, replay capability
- [ ] **Best fit**: real-time systems, IoT, streaming analytics, systems with many independent reactors to one trigger
- [ ] **Anti-patterns**: distributed monolith via events (chained synchronous-feeling event chains), missing idempotency in consumers
- [ ] **Characteristics**: scalability ★★★★★, performance ★★★★★, simplicity ★, testability ★★, evolvability ★★★★★

## Module 5: Pipeline (Pipes & Filters) Architecture
- [ ] **Structure**: linear sequence of independent **filters** connected by **pipes**; data flows one direction, transformed at each step
- [ ] **Filter types**: producer (source), transformer, tester (filter/route), consumer (sink)
- [ ] **Examples**: Unix shell pipelines, ETL pipelines, compilers, image processing, log processing (Logstash, Fluentd)
- [ ] **Strengths**: composable, each filter independently testable, naturally parallelisable, simple mental model
- [ ] **Weaknesses**: rigid linear flow, performance limited by slowest filter, not great for interactive/random-access logic
- [ ] **Best fit**: data transformation, batch processing, anything fundamentally a sequence of transformations
- [ ] **Modern incarnations**: Kafka Streams (KStream/KTable transformations), Apache Beam, Spring Cloud Data Flow
- [ ] **Characteristics**: simplicity ★★★★, modularity ★★★★★, performance ★★★, elasticity ★★★

## Module 6: Space-Based (Tuple-Space / Cloud) Architecture
- [ ] Designed for **extreme variable load** where traditional DB becomes bottleneck
- [ ] **Structure**: processing units (with in-memory data grid) + virtualised middleware (messaging grid, data grid, processing grid, deployment manager) + data writer (async DB persistence)
- [ ] **Removes the DB from the request path** — replicated in-memory data across processing units
- [ ] **Examples**: high-concurrency ticketing, online auctions, ad bidding, GigaSpaces (the canonical implementation), Hazelcast/Apache Ignite-based systems
- [ ] **Strengths**: extreme elasticity, very high throughput, no central DB bottleneck
- [ ] **Weaknesses**: complex infrastructure, data conflict resolution is hard, eventual consistency, expensive
- [ ] **Best fit**: variable load with sudden spikes, low-latency requirements, when DB scaling has hit limits
- [ ] **Worst fit**: low-traffic apps (massive overkill), apps with strict ACID requirements
- [ ] **Characteristics**: elasticity ★★★★★, performance ★★★★★, scalability ★★★★★, simplicity ★, cost ★

## Module 7: Service-Based & Microservices (Comparison)
- [ ] **Service-based architecture** (the "Goldilocks" — Mark Richards' favourite for many cases):
  - [ ] Coarse-grained services (4-12 in a domain), each independently deployable
  - [ ] **Shared database** (or schema-per-service in same DB) — avoids distributed-transaction complexity
  - [ ] No service mesh / no orchestration overhead — much simpler than microservices
  - [ ] Pros: most benefits of microservices without the pain; great for medium domains
- [ ] **Microservices** (covered in detail in `01-MicroservicePatterns/`):
  - [ ] Fine-grained, single-responsibility, polyglot, database-per-service, full ops investment
  - [ ] Pros: max independence, scalability, polyglot; Cons: distributed system complexity tax
- [ ] **Decision criteria**:
  - [ ] Service-based: 4-12 services, shared DB acceptable, single deployment domain
  - [ ] Microservices: many services, strict isolation, polyglot teams, mature DevOps
- [ ] **The migration path**: monolith → modular monolith → service-based → microservices (skip stages at your peril)
- [ ] **Characteristics (service-based)**: deployability ★★★★, simplicity ★★★, evolvability ★★★★, cost ★★★★
- [ ] **Characteristics (microservices)**: deployability ★★★★★, scalability ★★★★★, simplicity ★, cost ★

## Module 8: Combining Patterns & Pattern Anti-Patterns
- [ ] Patterns can compose: microservices internally use Layered; event-driven mediator can wrap a pipeline; microkernel core can dispatch via events
- [ ] **Hybrid example**: e-commerce — microservices at the boundary, event-driven for order flows, pipeline for analytics ingestion
- [ ] **Common anti-patterns**:
  - [ ] **Distributed Big Ball of Mud**: microservices with no boundaries → all the cost, none of the benefit
  - [ ] **Resume-driven**: choosing patterns for novelty, not need
  - [ ] **Architecture without governance**: pattern decided once, eroded over years, nobody enforces
  - [ ] **Stretching a pattern past its sweet spot**: layered architecture serving 10,000 RPS, microservices for a 3-person team
- [ ] **Architecture Decision Records (ADRs)**: capture *why* you chose pattern X, so future teams know the rationale
- [ ] **Fitness functions**: automated tests for architectural characteristics (e.g. ArchUnit checks layer dependencies; load tests verify scalability targets)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Pick a real system you've built; rate it on Mark Richards' 9 characteristics; identify which pattern it actually is (not which it claims to be) |
| Module 2 | Identify the "sinkhole" layers in a real layered app — what would removing them simplify? |
| Module 3 | Design a microkernel for a tax-calculation engine: define the core contract and 3 country-specific plug-ins |
| Module 4 | Build a small event-driven pipeline (Kafka): producer → 3 consumers → DLQ; trace flow with OpenTelemetry |
| Module 5 | Implement a 5-stage pipeline as Unix shell, then as Kafka Streams — compare ergonomics |
| Module 6 | Read a Hazelcast/Apache Ignite case study; sketch how it would change your highest-load endpoint |
| Module 7 | Take a microservices system you know and ask: "would service-based have been simpler with the same outcomes?" |
| Module 8 | Write 3 ADRs for a system you maintain — capture the architectural decisions that aren't obvious from the code |

## Cross-References
- `02-SystemDesign/02-DesignPatterns/` — GoF patterns (object level — one level *down* from these)
- `01-MicroservicePatterns/` — distributed pattern catalogue (one level *up* from these for distributed systems)
- `02-SystemDesign/01-DesignPrinciples/04-DomainDrivenDesign/` — DDD informs service decomposition
- `03-EnterpriseArchitecture/02-SolutionArchitecture/01-TradeOffAnalysis/` — characteristics ratings as a trade-off tool
- `03-EnterpriseArchitecture/02-SolutionArchitecture/05-C4Model/` — diagram these patterns

## Key Resources
- **Fundamentals of Software Architecture** - Mark Richards & Neal Ford (the canonical modern reference)
- **Software Architecture: The Hard Parts** - Neal Ford, Mark Richards, Pramod Sadalage, Zhamak Dehghani
- **Pattern-Oriented Software Architecture (POSA) Vol 1** - Buschmann et al. (foundational)
- **Software Architecture Patterns** - Mark Richards (free O'Reilly mini-book)
- **Building Evolutionary Architectures** - Neal Ford et al. (fitness functions)
- **DeveloperToArchitect.com** - Mark Richards' video series (free, excellent)
