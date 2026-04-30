# Hexagonal, Onion, Clean Architecture & Anti-Corruption Layer - Curriculum

> Three names for the same idea ("**The Dependency Rule**: dependencies point inward, toward the domain, never outward"), plus the DDD pattern that protects your domain from foreign models.

## Module 1: The Problem
- [ ] Traditional layered architectures couple the **domain** to the **infrastructure** (DB, web framework, message broker)
- [ ] Symptoms: business logic leaks JPA annotations, services call repository implementations directly, you can't unit-test without spinning up a DB, swapping Postgres for MongoDB requires touching 50 files
- [ ] **Root cause**: dependency direction is wrong — domain depends on infrastructure, instead of infrastructure depending on domain
- [ ] **The Dependency Rule** (Robert C. Martin): source-code dependencies must point only **inward**, toward higher-level policy
- [ ] Goal: the **domain** (use cases + entities) should be unit-testable in isolation, with no framework, no DB, no HTTP — and should outlive any technology choice
- [ ] Three near-identical formulations:
  - [ ] **Hexagonal** (Alistair Cockburn, 2005) — "Ports & Adapters"
  - [ ] **Onion** (Jeffrey Palermo, 2008) — concentric rings
  - [ ] **Clean** (Robert C. Martin, 2012) — entities → use cases → adapters → frameworks
- [ ] Common confusion: these are **boundary/dependency architectures**, not "the architecture" — they coexist with microservices, layered, event-driven, etc.

## Module 2: Hexagonal Architecture (Ports & Adapters)
- [ ] **Hexagon** = the application core (domain + use cases) with **ports** (interfaces) on its edges
- [ ] **Ports** are interfaces owned by the domain that describe what the domain *needs* (driven ports) or *offers* (driving ports)
- [ ] **Adapters** implement ports and connect to the outside world; they're swappable
- [ ] **Two flavours of port/adapter**:
  - [ ] **Driving (primary, inbound)**: adapters that *call into* the application — REST controllers, CLI handlers, gRPC handlers, message listeners → invoke use case ports
  - [ ] **Driven (secondary, outbound)**: adapters that the application *calls out to* — DB repositories, email senders, payment gateways → implement ports defined by the domain
- [ ] **Why hexagons?** Cockburn used 6 sides to suggest "many sides" without implying a hierarchy — there's no top or bottom
- [ ] **Test substitution**: in tests, replace driven adapters with in-memory fakes (no Mockito gymnastics needed) — domain tests run in milliseconds with zero infrastructure
- [ ] **Spring example**:
  - [ ] Driving adapter: `@RestController OrderController` calls a use case interface
  - [ ] Use case: `PlaceOrderUseCase` (interface in domain), `PlaceOrderService` (implementation in domain)
  - [ ] Driven port: `OrderRepository` interface (in domain)
  - [ ] Driven adapter: `JpaOrderRepository implements OrderRepository` (in infrastructure)

## Module 3: Onion & Clean Architecture (the Same Idea, Different Diagrams)
- [ ] **Onion** (Palermo): concentric rings — Domain Model → Domain Services → Application Services → Infrastructure/UI/Tests on the outside
  - [ ] Rule: outer rings depend on inner; inner rings know nothing of outer
- [ ] **Clean Architecture** (Uncle Bob): four rings
  - [ ] **Entities** (innermost) — enterprise-wide business rules, agnostic of any application
  - [ ] **Use Cases** — application-specific business rules, orchestrate entities
  - [ ] **Interface Adapters** — controllers, presenters, gateways; translate between use cases and external formats
  - [ ] **Frameworks & Drivers** (outermost) — Spring, Hibernate, Kafka, Web, DB
- [ ] **Boundary Crossing** uses interfaces (ports) + dependency inversion — outer ring implements interfaces defined by the inner ring
- [ ] **Mental model**: the database is a *plug-in* to your application, not the foundation of it
- [ ] All three (Hexagonal/Onion/Clean) collapse to: **"depend on abstractions you own; let infrastructure depend on you"**

## Module 4: Project Structure & Implementation in JVM
- [ ] **Module/package layout** (one common convention):
  - [ ] `domain/` — entities, value objects, domain services, port interfaces (zero framework imports)
  - [ ] `application/` — use case orchestration (can import domain only)
  - [ ] `infrastructure/` — adapters: JPA repositories, REST controllers, Kafka listeners, external API clients
  - [ ] `bootstrap/` (or `app/`) — Spring config, `@SpringBootApplication`, wiring
- [ ] **Multi-module Maven/Gradle**: enforce dependency direction with module boundaries — `domain` module has no Spring/JPA on classpath at all
- [ ] **ArchUnit / jQAssistant**: write executable architecture tests
  - [ ] `noClasses().that().resideIn("..domain..").should().dependOnClassesThat().resideIn("..infrastructure..")`
- [ ] **DTOs at every boundary**: domain entities don't leak to controllers (no `@JsonProperty` on a domain entity); use request/response DTOs
- [ ] **Mapping**: MapStruct, manual mappers, or static factories — explicit boundary translation, not field-by-field reflection magic
- [ ] **Spring caveat**: `@Component`/`@Service` annotations on domain classes leak Spring into the domain — purists put them only on infrastructure/wiring; pragmatists tolerate `@Service` on use cases
- [ ] **Frameworks that lean this way**: Spring Modulith (modular monolith with enforced boundaries), Axon (DDD + ES + CQRS), jMolecules (annotation-driven hexagonal/DDD)
- [ ] **Cost**: more code, more interfaces, more mapping — pays off when the domain is non-trivial; overkill for CRUD apps

## Module 5: Anti-Corruption Layer (DDD Pattern)
- [ ] **Problem**: your bounded context must integrate with a legacy system / external API / partner team whose model is incompatible with yours — directly using their model **corrupts** yours
- [ ] **Solution**: build an **Anti-Corruption Layer** (ACL) — a translation layer that shields your domain from theirs
- [ ] Components inside an ACL:
  - [ ] **Adapter**: speaks the foreign protocol (REST/SOAP/queue)
  - [ ] **Translator**: converts foreign data structures to your domain model
  - [ ] **Facade**: presents a clean, domain-aligned interface to your application
- [ ] ACL belongs in the **infrastructure** ring of Hexagonal/Clean — it's an adapter that happens to also do semantic translation
- [ ] **Examples**:
  - [ ] Wrapping a legacy mainframe billing API with a `BillingPort` your domain consumes
  - [ ] Translating a partner's order schema to your `Order` aggregate
  - [ ] Putting a SOAP-to-domain translator behind a clean Java interface
- [ ] **Strangler Fig + ACL**: when migrating off a legacy system, the ACL is the seam where new code talks to old; it shrinks over time
- [ ] **Trade-offs**: more code and a translation layer to maintain — but prevents the legacy schema from infecting your domain forever
- [ ] **Anti-pattern**: skipping the ACL "to save time" — you'll spend 10× later untangling the foreign model from your business logic

## Module 6: Practice & Anti-Patterns
- [ ] **Don't apply blindly to CRUD**: a 200-LOC microservice with three GET endpoints doesn't need 4 modules and 12 interfaces
- [ ] **Apply to the core domain**, not to supporting/generic subdomains (DDD's strategic design — invest where complexity lives)
- [ ] **Anti-patterns**:
  - [ ] **Anaemic domain** wrapped in hexagonal layers — interfaces everywhere, business logic still in services (no benefit, all the cost)
  - [ ] **Over-abstraction**: a port for every conceivable substitution; 90% of ports never get a second adapter
  - [ ] **Leaky domain**: JPA `@Entity` on a domain object — you've coupled the domain to Hibernate
  - [ ] **Adapter logic in the domain**: HTTP status codes, JSON shape, Kafka headers — all of these belong in adapters, not in use cases
  - [ ] **Reflection-based mapping with no tests**: silent breakage when fields drift
- [ ] **Migration path**: monolithic CRUD → extract use cases → introduce ports for the boundaries that hurt → expand only as the domain grows
- [ ] **Conway-aware**: hexagonal works best when one team owns one bounded context end-to-end; cross-team dependencies still need negotiation
- [ ] **Pairs naturally with**: DDD (bounded contexts → hexagons), CQRS (separate use case ports for commands vs queries), Event Sourcing (events as a driven port)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Refactor a small Spring service from layered to hexagonal: extract a `UseCase` interface, move JPA repositories behind a `Repository` port |
| Module 3 | Draw the same system as Hexagonal, Onion, and Clean diagrams — convince yourself they're the same idea |
| Module 4 | Set up a multi-module Maven project with strict module dependencies; verify domain module has zero Spring on its classpath |
| Module 4 | Add an ArchUnit test that fails if any class in `..domain..` imports from `..infrastructure..` |
| Module 5 | Wrap a real third-party API (Stripe, Twilio, a legacy SOAP service) with an ACL — keep their model out of your domain |
| Module 6 | Look at a hexagonal codebase you maintain; count: how many ports have only one adapter? Are they pulling their weight? |

## Cross-References
- `02-SystemDesign/01-DesignPrinciples/01-SOLID/` — Dependency Inversion is the underlying SOLID principle
- `02-SystemDesign/01-DesignPrinciples/04-DomainDrivenDesign/` — bounded contexts, aggregates, ubiquitous language
- `02-SystemDesign/04-ArchitecturePatterns/` — hexagonal complements (does not replace) those higher-level patterns
- `01-MicroservicePatterns/03-DataPatterns/04-StranglerFig/` — ACL is the seam in strangler migrations
- `01-MicroservicePatterns/03-DataPatterns/01-CQRS/` — CQRS commands and queries are natural use case ports

## Key Resources
- **"Hexagonal Architecture"** - Alistair Cockburn (the original 2005 article — alistair.cockburn.us/hexagonal-architecture)
- **Clean Architecture** - Robert C. Martin (the book)
- **"The Onion Architecture"** - Jeffrey Palermo (2008 blog series)
- **Domain-Driven Design** - Eric Evans (Chapter 14: Maintaining Model Integrity → Anti-Corruption Layer)
- **Implementing Domain-Driven Design** - Vaughn Vernon
- **Get Your Hands Dirty on Clean Architecture** - Tom Hombergs (Java/Spring focus)
- **Spring Modulith** documentation (spring.io/projects/spring-modulith)
- **jMolecules** - github.com/xmolecules/jmolecules (annotations for hexagonal/DDD on JVM)
