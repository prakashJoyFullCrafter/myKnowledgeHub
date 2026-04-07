# Why Modulith? — Complete Study Guide

> **Module 1 | Brutally Detailed Reference**
> Covers the architecture spectrum from monolith to microservices, the specific failure modes of each extreme, the modular monolith as a principled middle ground, Spring Modulith as the official implementation, and the decision framework for when to extract services. Full examples and diagrams throughout.

---

## Table of Contents

1. [The Architecture Spectrum](#1-the-architecture-spectrum)
2. [Problems with Big-Ball-of-Mud Monoliths](#2-problems-with-big-ball-of-mud-monoliths)
3. [Problems with Premature Microservices](#3-problems-with-premature-microservices)
4. [The Modular Monolith — The Middle Ground](#4-the-modular-monolith--the-middle-ground)
5. [Spring Modulith — Official Spring Project](#5-spring-modulith--official-spring-project)
6. [When to Start Modulith, When to Extract](#6-when-to-start-modulith-when-to-extract)
7. [Quick Reference Cheat Sheet](#7-quick-reference-cheat-sheet)

---

## 1. The Architecture Spectrum

### 1.1 The Three Archetypes

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Architecture Spectrum                            │
│                                                                          │
│  Monolith              Modular Monolith          Microservices           │
│  ─────────             ────────────────          ─────────────           │
│  ┌────────┐            ┌──────────────┐          ┌───┐ ┌───┐ ┌───┐     │
│  │  ALL   │            │ ┌──┐   ┌──┐ │          │ A │ │ B │ │ C │     │
│  │  CODE  │            │ │A │   │B │ │          └─┬─┘ └─┬─┘ └─┬─┘     │
│  │  IN    │            │ └──┘   └──┘ │            │     │     │        │
│  │  ONE   │            │ ┌──┐   ┌──┐ │            └─────┼─────┘        │
│  │  PLACE │            │ │C │   │D │ │              network calls       │
│  └────────┘            │ └──┘   └──┘ │                                 │
│                         │   single   │                                 │
│  Single process         │ deployable │          Separate processes      │
│  Single deploy          └──────────┘          Separate deploys         │
│  No network calls       Enforced boundaries    Network overhead         │
│                                                                          │
│  ◄── Simplicity ────────────────────────────── Complexity ──────────►  │
│  ◄── Coupling ──────────────── Isolation ────────────────────────────►  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Monolith

A monolith is a **single deployable unit** where all code runs in one process:

```
Traditional Monolith:
  - One JAR/WAR deployed to one or more servers
  - All business logic in one codebase
  - In-process method calls (no network)
  - Shared database
  - Single build and deployment pipeline

Examples: Early Amazon, Early Netflix, GitHub (Rails monolith), Basecamp
```

**Spectrum of monoliths:**
```
Majestic Monolith           Big Ball of Mud
─────────────────           ───────────────
Well-structured,            No clear structure,
clear layers,               everything calls everything,
testable                    impossible to maintain
      │                            │
      │    ← entropy over time →   │
      └────────────────────────────┘
Most monoliths start on the left and drift right without discipline.
```

### 1.3 Microservices

Microservices decompose the system into **independent, separately deployable services**:

```
Microservices:
  - Each service: own process, own deploy, own database
  - Communication: HTTP/REST, gRPC, message queues
  - Independent scaling
  - Polyglot (different languages per service)
  - Conway's Law: org structure maps to system structure

Examples: Netflix (700+ services), Amazon, Uber, Spotify
```

### 1.4 Modular Monolith

A modular monolith keeps **single-process simplicity** but adds **enforced module boundaries**:

```
Modular Monolith:
  - One deployable JAR
  - Modules have explicit public APIs
  - Cross-module access goes through API, not internals
  - No network calls (in-process)
  - Shared or separate schemas (schema-per-module common)
  - Clear dependencies graph between modules

The key word is ENFORCED — not just conventions but compile-time or test-time guarantees.
```

---

## 2. Problems with Big-Ball-of-Mud Monoliths

### 2.1 What Is a Big Ball of Mud?

A "big ball of mud" (term coined by Brian Foote and Joseph Yoder, 1997) describes a system with **no recognizable structure** — code organized by accident rather than design.

### 2.2 Tangled Dependencies

```
Big Ball of Mud dependency graph:
                              UserController
                             /      |        \
                    UserService  OrderService  EmailService
                   /    |    \      |        /     |    \
              UserRepo  │  PayRepo  │  EmailRepo   │  AuditRepo
                 │      │     │     │       │      │     │
                 └──────┴─────┴─────┴───────┴──────┴─────┘
                          Shared DB layer calls EVERYTHING

Every class can reference every other class.
"I need to change the user password logic" — must understand
the side effects in OrderService, EmailService, AuditRepo...
```

**In code:**
```java
// Big-ball-of-mud: OrderService reaching directly into User internals
@Service
public class OrderService {

    @Autowired
    private UserRepository userRepository;      // fine: own data

    @Autowired
    private ProductRepository productRepository; // fine: own data

    @Autowired
    private UserInternalHelper userInternalHelper; // PROBLEM: internal of Users module
    // ↑ This is a red flag: OrderService knows about User INTERNALS

    @Autowired
    private EmailTemplateService emailTemplates;  // PROBLEM: crosses into Notifications
    // ↑ Order shouldn't know about email templates

    @Autowired
    private InvoicePdfGenerator invoiceGenerator; // PROBLEM: crosses into Billing
    // ↑ Order creation is now coupled to billing PDF generation

    public Order createOrder(CreateOrderRequest req) {
        // Grabs user payment method directly from internals
        PaymentMethod pm = userInternalHelper.getDefaultPaymentMethod(req.userId());
        // Generates invoice using billing internals
        byte[] pdf = invoiceGenerator.generate(order);
        // Sends email using notification internals
        emailTemplates.sendOrderConfirmation(order, pdf);
        // ...
    }
}
```

**The impact:**
```
Symptom:                    Cause:
─────────────────────────────────────────────────────────
"Can't change X without     X is referenced by 20 other classes
  breaking Y and Z"         None of them should know about X

"Test takes 30 seconds"     Test for OrderService must load
                            UserInternalHelper, EmailTemplates,
                            InvoicePdfGenerator, and their deps

"Need 5 people to review    The change touches 8 packages
  a 'simple' change"        because everything is entangled

"Nobody knows what this     No module owns it — it's shared by all
  class is for"
```

### 2.3 Hard to Test

```java
// Testing OrderService in a big ball of mud:
@SpringBootTest  // must load THE ENTIRE APPLICATION CONTEXT
class OrderServiceTest {
    // Needs:
    //  - UserRepository + UserInternalHelper (User domain)
    //  - ProductRepository (Catalog domain)
    //  - EmailTemplateService (Notification domain)
    //  - InvoicePdfGenerator (Billing domain)
    //  - PaymentGatewayClient (Payment domain — hits external service!)
    //  - InventoryService (Warehouse domain)
    // All of these must be available or mocked

    // A "unit test" for OrderService is effectively an integration test
    // because there are no boundaries — everything is one unit.
}

// Result:
// - Tests are slow (full context startup: 30+ seconds)
// - Tests are fragile (unrelated change in EmailTemplate breaks OrderService test)
// - Tests are hard to write (mocking graph is enormous)
// - Low test coverage because it's too painful
```

### 2.4 Hard to Split (Later)

The cruelest trap: the monolith grows for years, then the team decides "let's split into microservices":

```
Expected: clean split along business lines
    Monolith → UserService + OrderService + CatalogService

Actual: spaghetti extraction
    OrderService's createOrder() calls:
        - userRepo.findById()                — in User module
        - productRepo.checkInventory()       — in Catalog module
        - paymentRepo.getPaymentMethod()     — in Payment module
        - auditLog.record()                  — in Audit module
        - emailService.sendConfirmation()    — in Notification module

    To make OrderService a microservice, you need:
    - 5 network calls where there used to be 5 method calls
    - Distributed transaction handling (what if payment succeeds but email fails?)
    - Service discovery, circuit breakers, retry logic
    - All for code that was never designed for distribution

    Common outcome: "microservices migration" takes 2 years,
    costs millions, and results in a distributed monolith
    (still all coupled, but now with network latency too)
```

---

## 3. Problems with Premature Microservices

### 3.1 What "Premature" Means

Microservices are a solution to specific scaling problems. Adopting them before those problems exist is premature:

```
"Premature optimization is the root of all evil." — Donald Knuth

Applied to architecture:
"Premature decomposition is the root of all distributed complexity."

Signs of premature microservices:
  - Team is < 20 engineers
  - Domain is not well-understood yet
  - Extracting services for technical reasons, not business reasons
  - "We'll be Netflix someday" (maybe, but you're not Netflix today)
```

### 3.2 Distributed Complexity

```
In-process call (monolith):
  orderService.createOrder(req)
  → 0ms, never fails (no network), no serialization, no versioning

Network call (microservices):
  POST https://order-service/api/orders (body: JSON)
  → 2-50ms latency, can fail (timeout, connection refused, 500),
    JSON serialization/deserialization, must handle versioning

What you gain:     What you lose:
  Isolated deploy    Simple call semantics
  Independent scale  Transactional consistency
  Tech freedom       Observability (now need distributed tracing)
                     Simplicity

For a team of 5, the "what you lose" column often outweighs "what you gain".
```

**The "fallacies of distributed computing" (Peter Deutsch, 1994):**
```
Assumptions developers make that are wrong in distributed systems:
1. The network is reliable         — packets drop, TCP connections reset
2. Latency is zero                 — your 1ms in-process call becomes 5ms + variance
3. Bandwidth is infinite           — you're now serializing every object over the wire
4. The network is secure           — each service boundary is an attack surface
5. Topology doesn't change         — services move, IP addresses change
6. There is one administrator      — now you have DevOps per service
7. Transport cost is zero          — serialization, TLS, HTTP overhead
8. The network is homogeneous      — protocol mismatches, version drift
```

### 3.3 Network Latency Compounds

```
Monolith: User views their order history
  OrderController → OrderService.getUserOrders() → DB query
  Latency: ~5ms (DB query)

Microservices "death star" pattern: Same operation
  Order Service → calls User Service (verify user)   → +5ms
               → calls Product Service (get details) → +5ms per item
               → calls Review Service (get ratings)  → +5ms
               → calls Inventory Service (get stock) → +5ms
               → calls Recommendation Service        → +5ms
  Total: 30ms minimum, with any one service down → partial failure

The N+1 problem for microservices:
  A page that made 1 DB query in the monolith
  may make 15 network calls in the microservices version.
```

### 3.4 Data Consistency

```
Monolith transaction:
  @Transactional
  public void placeOrder(OrderRequest req) {
      Order order = orderRepo.save(new Order(req));
      inventoryService.reserve(req.items());         // same transaction
      paymentService.charge(req.payment());           // same transaction
      // If anything fails: everything rolls back atomically
  }

Microservices equivalent:
  Order Service:
    POST /orders → creates order record
    ↓ what if this succeeds but the next step fails?
  Inventory Service:
    POST /inventory/reserve → reserves items
    ↓ what if this succeeds but the next step fails?
  Payment Service:
    POST /payments/charge → charges customer
    ↓ what if this fails?

  Now you need:
  - Saga pattern (choreography or orchestration)
  - Compensating transactions (cancel order, release inventory)
  - Eventual consistency instead of ACID transactions
  - Idempotency keys for retry safety
  - Distributed tracing to understand what happened

  This is solvable but requires significant engineering investment.
  Not worth it if you have 3 backend engineers.
```

### 3.5 Operational Overhead

```
Monolith operations:
  - 1 deployment pipeline
  - 1 service to monitor
  - 1 set of logs to search
  - 1 database
  - 1 alert rule set

Microservices operations (for 10 services):
  - 10 deployment pipelines
  - 10 services to monitor (Kubernetes + Prometheus)
  - Distributed logging (ELK Stack, Grafana Loki)
  - Distributed tracing (Jaeger, Zipkin, AWS X-Ray)
  - Service mesh (Istio) for mTLS, circuit breakers
  - API Gateway for external traffic
  - 10 databases (or shared schema with careful isolation)
  - 10× the infrastructure cost

Until you have a dedicated platform/infra team,
the operational cost of microservices can consume
more engineering time than business feature development.
```

---

## 4. The Modular Monolith — The Middle Ground

### 4.1 Core Principles

```
A modular monolith satisfies:

1. Single deployable unit      — still one JAR, one process
2. Logical module separation   — code organized into modules
3. Enforced boundaries         — modules can't reach into each other's internals
4. Explicit public API         — each module publishes what others can use
5. Dependency direction        — dependencies go one way (no cycles)

The key: boundaries are ENFORCED, not just conventional.
```

### 4.2 Modular Monolith Package Structure

```
com.myapp/
  ├── order/                    ← Order module
  │   ├── OrderModule.java      ← module marker class
  │   ├── OrderController.java  ← public API (REST)
  │   ├── OrderService.java     ← public API (service)
  │   ├── OrderPlacedEvent.java ← public API (events)
  │   └── internal/             ← INTERNAL — not accessible from other modules
  │       ├── OrderRepository.java
  │       ├── OrderEntity.java
  │       ├── OrderValidator.java
  │       └── OrderEmailHelper.java  ← internal helper
  │
  ├── inventory/                ← Inventory module
  │   ├── InventoryService.java ← public API
  │   ├── StockLevel.java       ← public API (value object)
  │   └── internal/
  │       ├── InventoryRepository.java
  │       └── ReservationEntity.java
  │
  ├── user/                     ← User module
  │   ├── UserService.java      ← public API
  │   ├── UserProfile.java      ← public API (DTO)
  │   └── internal/
  │       ├── UserEntity.java
  │       └── UserRepository.java
  │
  └── notification/             ← Notification module
      ├── NotificationService.java  ← public API
      └── internal/
          ├── EmailSender.java
          └── EmailTemplates.java

Rule: order.internal.* is INVISIBLE to inventory.*, user.*, notification.*
      Only order.OrderService, order.OrderPlacedEvent are accessible.
```

### 4.3 Module Interaction Patterns

```java
// CORRECT: Order module uses public API of other modules
@Service
public class OrderService {

    private final InventoryService inventoryService; // public API of Inventory module
    private final UserService userService;           // public API of User module
    // Note: NO reference to InventoryRepository, UserEntity, or any internal class

    public Order createOrder(CreateOrderRequest req) {
        // Uses public API — Inventory module can change internals freely
        boolean inStock = inventoryService.checkAvailability(req.items());
        if (!inStock) throw new OutOfStockException();

        // Uses public API — User module can refactor UserEntity without breaking this
        UserProfile user = userService.getProfile(req.userId());

        Order order = new Order(req, user.email());
        orderRepository.save(order);

        // Instead of calling NotificationService directly:
        // Publish an event — Notification module listens and reacts
        // Order module doesn't know who handles the event
        eventPublisher.publishEvent(new OrderPlacedEvent(order.id(), user.email(), req.items()));

        return order;
    }
}

// WRONG: Order reaching into Inventory internals
@Service
public class OrderService {

    @Autowired
    private ReservationEntity reservationEntity;  // ❌ Inventory INTERNAL
    @Autowired
    private InventoryRepository inventoryRepo;    // ❌ Inventory INTERNAL
    // If Spring Modulith is configured, this would fail at application startup
    // with a detailed violation report
}
```

### 4.4 Events as the Decoupling Mechanism

```java
// Order module publishes an event — no knowledge of who handles it
public record OrderPlacedEvent(Long orderId, String customerEmail, List<Long> productIds) {}

@Service
public class OrderService {
    private final ApplicationEventPublisher eventPublisher;

    public Order createOrder(CreateOrderRequest req) {
        Order order = save(req);
        eventPublisher.publishEvent(new OrderPlacedEvent(
            order.id(), customer.email(), req.productIds()));
        return order;
    }
}

// Notification module handles the event — no knowledge of Order internals
@Component
public class OrderNotificationHandler {

    @ApplicationModuleListener  // Spring Modulith annotation
    public void on(OrderPlacedEvent event) {
        emailService.sendOrderConfirmation(event.customerEmail(), event.orderId());
    }
}

// Inventory module handles the same event — independently
@Component
public class InventoryReservationHandler {

    @ApplicationModuleListener
    public void on(OrderPlacedEvent event) {
        inventoryService.reserve(event.productIds(), event.orderId());
    }
}

// Result:
// Order module has ZERO dependencies on Notification or Inventory modules
// Adding a new module that reacts to OrderPlacedEvent requires ZERO changes to Order
```

### 4.5 Modular Monolith vs Big Ball of Mud — Direct Comparison

```
Big Ball of Mud:              Modular Monolith:
─────────────────             ─────────────────────────────
Any class can use any class   Internal classes are hidden
No ownership                  Each module owns its domain
Tests need full context       Tests can isolate one module
Split requires refactoring    Split is straightforward (boundaries exist)
Change ripples everywhere     Changes stay within module boundary
```

---

## 5. Spring Modulith — Official Spring Project

### 5.1 What Spring Modulith Is

Spring Modulith is an **official Spring project** (part of the Spring ecosystem, not a community project) that provides:

1. **Structural verification** — test that your package structure matches the modular monolith rules
2. **Module API** — programming model for defining module boundaries
3. **Event infrastructure** — `@ApplicationModuleListener`, transactional event publishing, event logs
4. **Documentation generation** — auto-generates module dependency diagrams from code
5. **Integration test support** — `@ApplicationModuleTest` for testing one module in isolation
6. **Observability** — module-aware metrics, tracing, and logging

```xml
<!-- Spring Modulith BOM -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-bom</artifactId>
    <version>1.2.0</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>

<!-- Core -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-core</artifactId>
</dependency>

<!-- Testing support -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-test</artifactId>
    <scope>test</scope>
</dependency>

<!-- Event persistence (for reliability) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-api</artifactId>
</dependency>
```

### 5.2 Structural Verification — `ApplicationModules`

```java
// This test verifies that your package structure respects module boundaries.
// Run it as part of CI — it catches violations before they reach production.
class ModularityTest {

    ApplicationModules modules = ApplicationModules.of(MyApplication.class);

    @Test
    void verifiesModuleStructure() {
        modules.verify();
        // What it checks:
        // - No module accesses another module's internal classes
        // - No circular dependencies between modules
        // - Modules are well-defined (named packages directly under root)
    }

    @Test
    void printsDiagram() {
        // Prints ASCII dependency diagram — useful for architecture review
        new Documenter(modules)
            .writeModulesAsPlantUml()        // generates PlantUML diagram
            .writeIndividualModulesAsPlantUml()
            .writeAggregatingDocument();
    }
}

// If OrderService imports InventoryRepository (internal):
// org.springframework.modulith.core.Violations:
//   - Module 'order' depends on non-exposed type
//     'com.myapp.inventory.internal.InventoryRepository'
//     in module 'inventory'
//   Declare a named interface or use the module's public API.
```

### 5.3 `@ApplicationModuleTest` — Isolated Module Testing

```java
// Test only the Order module — other modules are NOT loaded
@ApplicationModuleTest   // loads ONLY the order module's beans
class OrderModuleTest {

    @Autowired
    OrderService orderService;

    // inventory.internal.InventoryRepository is NOT available — boundary enforced
    // notification.internal.EmailSender is NOT available — boundary enforced

    @MockitoBean
    InventoryService inventoryService; // mock the public API of Inventory module

    @Test
    void createOrder_notifiesViaEvent() {
        // arrange: mock inventory response
        when(inventoryService.checkAvailability(any())).thenReturn(true);

        // act
        Order order = orderService.createOrder(testRequest());

        // assert: an OrderPlacedEvent was published
        // Spring Modulith provides event publication tracking
        assertThat(publishedEvents).contains(OrderPlacedEvent.class);
    }
}
// Result: test starts in milliseconds (not 30 seconds)
// because it only loads one module's beans
```

### 5.4 Event Publication Log (Reliability)

Spring Modulith provides reliable event delivery by persisting events before processing:

```java
// application.properties
spring.modulith.events.externalization.enabled=true

// Event is persisted to a log table BEFORE being dispatched
// If the application crashes after persisting but before handling:
// → Event is replayed on restart
// → Guarantees at-least-once delivery

@ApplicationModuleListener
@Transactional  // handles the event transactionally
public void on(OrderPlacedEvent event) {
    // If this throws, the event remains in the log as "incomplete"
    // and will be retried
    inventoryService.reserve(event.productIds(), event.orderId());
}
```

---

## 6. When to Start Modulith, When to Extract

### 6.1 Start with Modulith When

```
✅ START WITH MODULITH:

Team size: 2–15 engineers
  → One team can understand the whole system
  → Coordination overhead of separate services > benefit

Domain uncertainty: first 1-2 years
  → You don't know your domain boundaries yet
  → "If you get the module cut wrong, you can refactor cheaply in a monolith.
     If you get the service cut wrong, you have a distributed monolith."
  → Martin Fowler: "Don't start with microservices; begin with a modular monolith"

Simple operational needs:
  → One deployment, one monitoring setup, one database
  → No dedicated DevOps/platform team

Low traffic/scale:
  → One server can handle current and near-future load
  → Pre-product-market-fit startup

SLA requirements are uniform:
  → All parts of the system have same availability/latency requirements
  → No need for independent scaling of components
```

### 6.2 Consider Extracting a Module to Microservice When

```
✅ CONSIDER EXTRACTING WHEN:

Independently scalable:
  → The "search" module needs 100× the CPU of everything else
  → The "video processing" module has wildly different resource needs
  → Extract only the module that needs independent scaling

Team autonomy:
  → Two teams are fighting over the same codebase
  → One team's deployments are blocking the other's
  → Conway's Law: separate teams → separate services
  → Extract at team boundary, not at technical boundary

Different technology requirements:
  → "We need to use Python ML libraries for the recommendation engine"
  → "The real-time bidding engine needs Go for GC-free performance"
  → Technology mismatch makes co-location impractical

Different SLA requirements:
  → Payment processing: 99.999% availability, strict audit, PCI compliance
  → Content delivery: 99.9% is fine, no special compliance
  → Run payment as a separate service with its own SLA

Regulatory isolation:
  → GDPR: personal data must be in EU region
  → SOC 2 / PCI DSS: certain operations need strict audit boundaries
  → Extract just the compliance-sensitive module

Module is genuinely ready:
  → Module has clear, stable API (rarely changes)
  → Module has high cohesion (everything inside belongs together)
  → Module has low coupling (few dependencies on other modules)
  → Spring Modulith makes this visible: dependency graph shows the module is already isolated
```

### 6.3 The Extraction Path (Why Modulith Makes It Easier)

```
Starting from a well-structured modular monolith:

Step 1: Identify the candidate module
  → Spring Modulith's dependency diagram shows OrderProcessing
    is only called via one public API method and publishes two events

Step 2: The boundaries already exist
  → OrderProcessing.internal is already hidden from other modules
  → Public API is already defined
  → Integration is already event-based (no in-process calls)

Step 3: Physical extraction
  → Move com.myapp.orderprocessing → its own Maven module / Git repo
  → Replace in-process event publishing with Kafka/RabbitMQ
  → Replace in-process API call with HTTP/gRPC
  → Zero other code changes needed (other modules used public API only)

Without modulith (extracting from big ball of mud):
  → OrderProcessing calls UserRepository (10 direct DB calls)
  → UserRepository must become network calls or a shared DB (both bad)
  → EmailSender is woven through OrderProcessing internals
  → Extracting takes months, not days
```

### 6.4 Decision Framework

```
┌─────────────────────────────────────────────────────────────────┐
│                   Architecture Decision Tree                    │
│                                                                  │
│  Is the domain well understood?                                  │
│  ├── NO  → Modular Monolith (refactor boundaries cheaply)       │
│  └── YES ↓                                                       │
│                                                                  │
│  Is the team size > 20 engineers working on the same area?      │
│  ├── NO  → Modular Monolith (coordination overhead not worth it)│
│  └── YES ↓                                                       │
│                                                                  │
│  Does the team have dedicated DevOps/platform capability?        │
│  ├── NO  → Modular Monolith (operational burden too high)        │
│  └── YES ↓                                                       │
│                                                                  │
│  Are there specific scaling, compliance, or team isolation needs?│
│  ├── NO  → Modular Monolith                                      │
│  └── YES → Extract SPECIFIC modules (not everything)            │
│             Keep everything else in the monolith                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.5 Real-World Progression

```
Year 1 (Startup): Monolith (get product out fast)
  → All code in one place, move fast, discover the domain

Year 2 (Growth): Modular Monolith (structure what you have)
  → Introduce module boundaries
  → Start using Spring Modulith for verification
  → Discover which modules are high-cohesion

Year 3+ (Scale): Extract selectively
  → Identify the one module causing deployment conflicts
  → Identify the one module needing independent scaling
  → Extract THAT module; keep everything else as modular monolith
  → Result: 1-3 services + 1 modular monolith (not 15 microservices)

The goal is NOT "eventually microservices"
The goal is "right architecture for current constraints"
For most teams at most stages: modular monolith is the right answer.

Companies that succeeded with monoliths:
  Stack Overflow: serves millions with a single .NET monolith
  Shopify: Ruby on Rails modular monolith, $6B revenue
  Basecamp: Rails monolith for decades
  GitHub: Rails monolith for years before selective extraction
```

---

## 7. Quick Reference Cheat Sheet

### Architecture Comparison

| Aspect | Big-Ball Monolith | Modular Monolith | Microservices |
|---|---|---|---|
| **Deploy complexity** | Simple | Simple | Complex |
| **Code organization** | None | Enforced modules | Per-service |
| **Test speed** | Slow (full context) | Fast (per module) | Complex (mocks) |
| **Refactoring** | Risky | Safe within module | Very costly |
| **Scalability** | All-or-nothing | All-or-nothing | Per-service |
| **Transactions** | ACID easy | ACID easy | Sagas needed |
| **Team autonomy** | Low | Medium | High |
| **Operational cost** | Low | Low | High |
| **Right for** | Prototype | Most production apps | Large teams, clear domains |

### Spring Modulith Quick Start

```java
// 1. Package structure: direct sub-packages of root = modules
com.myapp.order.*         → Order module
com.myapp.inventory.*     → Inventory module
com.myapp.order.internal. → hidden (not accessible outside order)

// 2. Verify structure in test
ApplicationModules.of(MyApp.class).verify();

// 3. Test one module in isolation
@ApplicationModuleTest
class OrderModuleTest { ... }

// 4. Decouple with events
eventPublisher.publishEvent(new OrderPlacedEvent(...));

@ApplicationModuleListener
void on(OrderPlacedEvent e) { ... }
```

### When to Use What

```
Modular Monolith: team < 20, domain uncertain, no dedicated DevOps, uniform SLA
Extract a module: > 20 engineers in conflict, independent scaling needed, regulatory boundary
Microservices: multiple autonomous teams, well-understood domain, platform team exists
```

### Key Rules to Remember

1. **Start modular, not microservices** — get domain boundaries right first; extraction is easier later.
2. **Enforced boundaries, not conventions** — `ApplicationModules.verify()` in CI catches violations automatically.
3. **`internal` package = invisible** — Spring Modulith treats sub-packages named `internal` as hidden.
4. **Events decouple modules** — publisher doesn't know who listens; listeners don't know about publisher internals.
5. **`@ApplicationModuleTest` = fast tests** — only loads one module's beans; not a full `@SpringBootTest`.
6. **Good modular monolith → easy extraction** — well-bounded modules can become microservices without major refactoring.
7. **Distributed complexity is real cost** — sagas, retries, timeouts, tracing = non-trivial engineering investment.
8. **Conway's Law drives architecture** — extract services at team boundaries, not at technical layer boundaries.
9. **Modulith ≠ "we'll fix it later"** — it's a legitimate long-term architecture, not a waypoint to microservices.
10. **Stack Overflow runs on one server** — don't optimize for Netflix scale before you have Netflix traffic.

---

*End of Why Modulith? Study Guide — Module 1*
