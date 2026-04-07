# Spring Modulith - Curriculum

Structuring Spring Boot applications as modular monoliths with clear boundaries, before (or instead of) going to microservices.

---

## Module 1: Why Modulith?
- [ ] Monolith vs microservices vs **modular monolith** - the middle ground
- [ ] Problems with big-ball-of-mud monoliths: tangled dependencies, hard to test, hard to split
- [ ] Problems with premature microservices: distributed complexity, network latency, data consistency
- [ ] Modular monolith: logical modules within a single deployable, enforced boundaries
- [ ] Spring Modulith: official Spring project for building modular monoliths
- [ ] When to start modulith, when to extract to microservices

## Module 2: Application Modules
- [ ] `spring-modulith-core` dependency
- [ ] **Module detection**: each top-level package = one module
  - [ ] `com.myapp.order` → Order module
  - [ ] `com.myapp.inventory` → Inventory module
  - [ ] `com.myapp.user` → User module
- [ ] **Module API**: only classes in root package are public API
- [ ] **Internal packages**: sub-packages are internal (e.g., `com.myapp.order.internal`)
- [ ] `@ApplicationModule` annotation for explicit configuration
- [ ] Named interfaces: `@NamedInterface` for exposing specific sub-packages
- [ ] Open vs closed modules: `allowedDependencies` for strict control

## Module 3: Verifying Module Boundaries
- [ ] `ApplicationModules.of(Application.class)` - detect all modules
- [ ] `.verify()` - fail on illegal cross-module dependencies
- [ ] What's verified:
  - [ ] No cycles between modules
  - [ ] No access to internal packages of other modules
  - [ ] Only allowed dependencies are used
- [ ] Integration with unit tests: verify on every build
- [ ] Generating module documentation: `ApplicationModules.of(...).toDocumentation()`
- [ ] PlantUML / Asciidoc output for architecture diagrams
- [ ] Comparison with ArchUnit rules (Spring Modulith is higher-level)

## Module 4: Application Events for Module Communication
- [ ] Why: modules should communicate via events, not direct method calls
- [ ] Spring `ApplicationEventPublisher` for publishing domain events
- [ ] `@ApplicationModuleListener` - handle events from other modules
- [ ] `@Async` event listeners for non-blocking processing
- [ ] `@TransactionalEventListener(phase = AFTER_COMMIT)` - fire after transaction success
- [ ] **Event publication registry** (`spring-modulith-events`):
  - [ ] Persisting events to database for reliability
  - [ ] Re-publishing incomplete events on restart
  - [ ] Event publication log: `spring-modulith-events-jpa` / `spring-modulith-events-jdbc`
- [ ] Event externalization: publishing to Kafka/RabbitMQ/SQS when ready for microservices
- [ ] `@Externalized` annotation for automatic event forwarding to message broker

## Module 5: Integration Testing Modules
- [ ] `@ApplicationModuleTest` - bootstrap only the module under test + its dependencies
- [ ] Faster tests: smaller application context than `@SpringBootTest`
- [ ] `Scenario` API for testing event-driven flows:
  - [ ] `scenario.publish(new OrderPlaced(...)).andWaitForEventOfType(InventoryReserved.class)`
  - [ ] Asserting that publishing an event triggers expected downstream behavior
- [ ] Testing module in isolation: mock other modules
- [ ] Verifying event publication: `scenario.forPublication(OrderPlaced.class)`

## Module 6: From Modulith to Microservices
- [ ] Modulith as stepping stone: start monolith, split later
- [ ] Identifying extraction candidates: modules with clear boundaries, different scaling needs
- [ ] Event externalization: swap in-process events to Kafka/RabbitMQ with `@Externalized`
- [ ] Module → microservice migration path:
  1. Module with internal events
  2. Enable event externalization (dual-write)
  3. Extract module to separate service
  4. Remove internal event path
- [ ] Strangler fig pattern with Spring Modulith
- [ ] Keeping some modules in the monolith (not everything needs to be extracted)
- [ ] Shared kernel: common types across modules (value objects, events)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Restructure a Spring Boot app into modules: order, user, inventory, notification |
| Module 3 | Add module verification test, fix all boundary violations |
| Module 4 | Replace direct service calls with application events between modules |
| Module 5 | Write `@ApplicationModuleTest` for each module in isolation |
| Module 6 | Extract one module to a separate service, replace events with Kafka |

## Key Resources
- Spring Modulith Reference Documentation
- Spring Modulith examples on GitHub
- Oliver Drotbohm - "Spring Modulith" talks (Spring I/O, Devoxx)
- Fundamentals of Software Architecture - Mark Richards & Neal Ford
