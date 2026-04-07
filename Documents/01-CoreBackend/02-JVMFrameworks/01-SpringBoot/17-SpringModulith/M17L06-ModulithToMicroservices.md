# Spring Modulith: From Modulith to Microservices — Complete Study Guide

> **Module 6 | Brutally Detailed Reference**
> Covers the modulith as a stepping stone, identifying extraction candidates, event externalization with `@Externalized`, the four-step migration path, the Strangler Fig pattern, keeping most modules in the monolith, and the shared kernel pattern. Full working examples throughout.

---

## Table of Contents

1. [Modulith as Stepping Stone](#1-modulith-as-stepping-stone)
2. [Identifying Extraction Candidates](#2-identifying-extraction-candidates)
3. [Event Externalization — `@Externalized`](#3-event-externalization--externalized)
4. [The Four-Step Migration Path](#4-the-four-step-migration-path)
5. [Strangler Fig Pattern with Spring Modulith](#5-strangler-fig-pattern-with-spring-modulith)
6. [Keeping Some Modules in the Monolith](#6-keeping-some-modules-in-the-monolith)
7. [Shared Kernel — Common Types Across Modules](#7-shared-kernel--common-types-across-modules)
8. [Quick Reference Cheat Sheet](#8-quick-reference-cheat-sheet)

---

## 1. Modulith as Stepping Stone

### 1.1 The Spectrum Revisited

```
Year 0 (Product idea):
  Build a Big Ball of Mud monolith fast
  → Gets product to market. Proves the idea. Terrible to maintain.

Year 1 (Finding product-market fit):
  Introduce Spring Modulith — enforce module boundaries
  → Same deployable, same operations, but now you know where the seams are

Year 2 (Scaling the team):
  Two teams fighting over the same codebase
  → Extract ONE module that team B owns
  → Everything else: still in the modulith

Year 3+ (Selective extraction):
  Extract modules that genuinely need independent scaling
  → Not everything. Not all at once.
  → Result: 3 microservices + 1 modular monolith

Target state for most teams:
  NOT: 15 microservices (Netflix)
  YES: 2-4 microservices for the modules that need it + 1 modulith for the rest
```

### 1.2 Why Modulith Is the Right Starting Point

```
Starting with microservices:
  "We'll design our services now and extract them right"
  
  Problem: you don't know your domain yet
  Wrong service boundaries = distributed monolith
  Cost: extremely expensive to fix after the fact
  
  "Getting the service boundaries wrong means a
   multi-year, multi-million dollar migration."
   — Sam Newman, Building Microservices

Starting with a modular monolith:
  "We'll enforce boundaries now and extract when we're sure"
  
  Benefit: boundaries are cheap to change (refactoring, not re-architecting)
  Benefit: you discover the right boundaries by operating the system
  Benefit: extraction is straightforward when the time comes
  
  "A well-structured modular monolith can be
   split into microservices with minimal code changes."
```

### 1.3 What Spring Modulith Gives You Before Extraction

```
Before extraction, Spring Modulith provides:
  ✓ Module boundaries verified in tests (no accidental coupling)
  ✓ Event-driven communication already in place
  ✓ Module dependency diagram (know what depends on what)
  ✓ @ApplicationModuleTest for isolated module testing
  ✓ Event publication registry (outbox pattern built-in)
  ✓ @Externalized ready to flip (no code changes needed)

When you decide to extract:
  → The module already behaves like a separate service
  → Events are already the API between modules
  → @Externalized routes events to the message broker automatically
  → You move code, not architecture
```

---

## 2. Identifying Extraction Candidates

### 2.1 Signals That a Module Should Be Extracted

Not all modules should be extracted. Most should stay in the monolith. Look for these specific signals:

```
Signal 1: Team ownership conflict
  Problem: Two teams deploying the same JAR → coordination overhead
           Team A's release blocks Team B's release
  Solution: Extract at the team boundary
  Example: Platform team owns auth, product team owns orders
           → extract auth to its own service

Signal 2: Genuinely different scaling needs
  Problem: One module uses 100× the CPU/memory of everything else
           Scaling the monolith to serve it means over-provisioning everything else
  Solution: Extract that specific module and scale it independently
  Example: Image processing, ML inference, search indexing
           → extract processing module, scale it to 20 instances
           → monolith stays at 3 instances

Signal 3: Different deployment risk profile
  Problem: One module changes frequently (risky), others change rarely
           Every high-risk change requires redeploying stable code
  Solution: Extract the high-churn module to deploy independently
  Example: A/B testing engine changes weekly, core accounting never changes
           → extract A/B testing, deploy it independently

Signal 4: Regulatory or compliance isolation
  Problem: One module handles PCI DSS data (card numbers), another doesn't
           PCI compliance scope bleeds into the whole monolith
  Solution: Extract the regulated module to minimize compliance scope
  Example: Payment processing → separate service with strict audit controls

Signal 5: Technology mismatch
  Problem: One module genuinely needs a different tech stack
           Python ML model called from Java monolith
           Go service for ultra-low GC pauses
  Solution: Extract that module and use the right tech

Signal 6: Module's API is stable
  Bad time to extract: module API is changing weekly
           → tight version coupling between services
  Good time to extract: module API has been stable for months
           → service versioning is manageable
```

### 2.2 Using the Module Diagram to Find Candidates

```java
// Generate the module diagram and look for modules that are:
// 1. Depended on by nobody (leaf modules — easiest to extract)
// 2. Only depended on by one other module
// 3. Have few incoming/outgoing dependencies

class ArchitectureDocumentation {
    ApplicationModules modules = ApplicationModules.of(MyApplication.class);

    @Test
    void generateDiagram() {
        new Documenter(modules).writeModulesAsPlantUml();
        // target/spring-modulith-docs/all-modules.puml
    }
}
```

```
Dependency diagram analysis:

  user ←── order ──── inventory
    └─────────────── notification
                     loyalty (no incoming deps, only depends on order events)
                     ↑
                     Leaf module — easiest extraction candidate!

  Extraction priority:
  1. Leaf modules (no one depends on them) — easiest
  2. Modules with single incoming dependency — easy
  3. Hub modules (many things depend on them) — hardest, extract last or never
```

### 2.3 Extraction Readiness Checklist

```
For each candidate module, check:

Module boundaries:
  □ Module has clear, stable public API (rarely changes signature)
  □ Module has zero access to other modules' internals (verify() passes)
  □ Module communicates via events (not direct calls) for side effects

Data ownership:
  □ Module owns its tables (no shared tables with other modules)
  □ If tables are shared: can they be separated? (schema migration needed?)
  □ Module queries are within its own schema

Communication:
  □ Read dependencies (direct calls for queries) are minimal
  □ Write dependencies (side effects) are event-driven
  □ Event types are already published via ApplicationEventPublisher

Operational:
  □ Team is ready to own the new service's deployments
  □ Monitoring, alerting, runbooks prepared for a new service
  □ Kubernetes/docker infrastructure ready

Code:
  □ Module has its own @ApplicationModuleTest suite
  □ Module integration tests pass in isolation (BootstrapMode.STANDALONE)
```

---

## 3. Event Externalization — `@Externalized`

### 3.1 How `@Externalized` Works in the Migration Context

`@Externalized` is the bridge between in-process event delivery and message broker delivery:

```
BEFORE @Externalized:
  OrderService publishes OrderPlacedEvent
  → InventoryHandler.on(event) runs IN-PROCESS
  → NotificationHandler.on(event) runs IN-PROCESS
  (everything in the same JVM)

DURING migration (dual-write with @Externalized):
  OrderService publishes OrderPlacedEvent
  → InventoryHandler.on(event) runs IN-PROCESS      ← still in monolith (old path)
  → NotificationHandler.on(event) runs IN-PROCESS   ← still in monolith (old path)
  → Kafka topic "orders.placed" ← NEW: also forwarded to broker

  Extracted Inventory Service (new JVM):
  → @KafkaListener("orders.placed") runs IN NEW SERVICE ← new path

AFTER extraction complete:
  OrderService publishes OrderPlacedEvent
  → Kafka topic "orders.placed" ← only path
  → InventoryHandler runs IN EXTRACTED SERVICE
  (InventoryHandler no longer in the monolith)
```

### 3.2 Adding `@Externalized` to an Existing Event

```java
// BEFORE: event without externalization
// com.myapp.order.OrderPlacedEvent
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total,
    Instant occurredAt
) {}

// AFTER: add @Externalized — one annotation, event now dual-published
// com.myapp.order.OrderPlacedEvent
import org.springframework.modulith.events.Externalized;

@Externalized("orders.placed")   // Kafka topic / RabbitMQ exchange / SQS queue name
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total,
    Instant occurredAt
) {}

// Zero changes to OrderService, InventoryHandler, or NotificationHandler
// Spring Modulith automatically dual-publishes:
// 1. In-process via ApplicationEventPublisher (existing handlers still work)
// 2. Kafka topic "orders.placed" (for the future extracted service)
```

### 3.3 Routing Key Configuration

```java
// Simple topic (default routing key is the fully-qualified event class name)
@Externalized("orders.placed")
public record OrderPlacedEvent(Long orderId, ...) {}

// Custom routing key (SpEL expression referencing the event fields)
@Externalized(target = "orders", key = "#{#event.orderId}")
public record OrderPlacedEvent(Long orderId, ...) {}
// → Kafka key = orderId (routes same-order events to same partition)

// Dynamic topic name (SpEL on the target)
@Externalized("orders.#{#event.region}.placed")
public record OrderPlacedEvent(Long orderId, String region, ...) {}
// → "orders.US.placed" or "orders.EU.placed"

// Interface-based routing (implement RoutingKey)
@Externalized("orders")
public record OrderPlacedEvent(Long orderId, ...) implements RoutingKey {
    @Override
    public String getRoutingKey() {
        return "order-" + orderId;
    }
}
```

---

## 4. The Four-Step Migration Path

### 4.1 Overview

```
Step 1: Module with internal events
        Everything in the monolith, event-driven boundaries already in place

Step 2: Enable event externalization (dual-write)
        Add @Externalized — events go to both in-process AND message broker
        No service extracted yet — safety net

Step 3: Extract module to separate service
        New service reads from the message broker
        Old in-process handler still runs (dual consumption)
        Verify new service works correctly

Step 4: Remove internal event path
        Delete the in-process handler from the monolith
        New service is the sole consumer of the event
        Migration complete
```

### 4.2 Step 1 — Module with Internal Events (Starting State)

```
Monolith state:
  com.myapp/
    ├── order/
    │   ├── OrderService.java            ← publishes OrderPlacedEvent
    │   ├── OrderPlacedEvent.java        ← event (no @Externalized yet)
    │   └── internal/
    │       └── OrderServiceImpl.java
    ├── inventory/
    │   ├── InventoryService.java
    │   └── internal/
    │       ├── InventoryServiceImpl.java
    │       └── OrderInventoryHandler.java  ← @ApplicationModuleListener
    └── notification/
        └── internal/
            └── OrderNotificationHandler.java ← @ApplicationModuleListener
```

```java
// Step 1: Everything is in-process
// com.myapp.order.OrderPlacedEvent — no @Externalized
public record OrderPlacedEvent(Long orderId, Long userId, List<Long> productIds,
                                BigDecimal total, Instant occurredAt) {}

// com.myapp.inventory.internal.OrderInventoryHandler
@Component
class OrderInventoryHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent event) {
        inventoryService.reserve(event.orderId(), event.productIds());
        // publishes InventoryReservedEvent back
    }
}
```

### 4.3 Step 2 — Enable Event Externalization (Dual-Write)

**Code change: add `@Externalized` to the event. That's it.**

```java
// ONE ANNOTATION ADDED — nothing else changes
@Externalized("orders.placed")   // ← the only code change in Step 2
public record OrderPlacedEvent(Long orderId, Long userId, List<Long> productIds,
                                BigDecimal total, Instant occurredAt) {}
```

```yaml
# Add Kafka dependency and config
spring:
  kafka:
    bootstrap-servers: localhost:9092
    producer:
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
```

```xml
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-kafka</artifactId>
</dependency>
```

```
After Step 2 — dual publication in action:
  OrderService publishes OrderPlacedEvent
  → Spring Modulith persists to event_publication (outbox) ← atomic with order save
  → After TX commit:
       → In-process: OrderInventoryHandler.on() still runs ← unchanged
       → Kafka: "orders.placed" topic ← NEW

At this point: two consumers of the event
  1. In-process handler (old path)
  2. Kafka topic (new path, future extracted service will read this)

NOTHING BREAKS. The system still works exactly as before.
The Kafka messages are simply not yet consumed by anyone.
```

### 4.4 Step 3 — Extract Module to Separate Service

```
Create the new Inventory microservice:
  inventory-service/
    ├── src/main/java/com/myapp/inventory/
    │   ├── InventoryApplication.java      ← @SpringBootApplication
    │   ├── InventoryService.java
    │   └── OrderInventoryKafkaHandler.java ← reads from Kafka
    └── pom.xml                             ← own build, own deploy
```

```java
// New inventory-service: reads from Kafka instead of in-process
@Component
class OrderInventoryKafkaHandler {

    private final InventoryService inventoryService;

    @KafkaListener(topics = "orders.placed", groupId = "inventory-service")
    void on(OrderPlacedEvent event) {
        // SAME LOGIC as before — just triggered from Kafka instead of in-process
        inventoryService.reserve(event.orderId(), event.productIds());
    }
}
```

```
During Step 3 — BOTH paths active (dual consumption):
  OrderService publishes OrderPlacedEvent
  → In-process: OrderInventoryHandler.on() ← STILL IN MONOLITH
  → Kafka:      OrderInventoryKafkaHandler.on() ← IN NEW SERVICE

BOTH handlers run for the same event!
This is intentional:
  - Lets you verify the new service works correctly
  - Makes the new service idempotent (same event processed twice = same result)
  - If the new service has a bug: the old path is the fallback
  - Run both paths for a soak period (hours, days) before cutting over
```

**Idempotency in the extracted service — required for dual consumption:**

```java
@KafkaListener(topics = "orders.placed")
void on(OrderPlacedEvent event) {
    // Check if already processed (idempotency guard)
    if (inventoryRepository.existsReservationForOrder(event.orderId())) {
        log.info("Reservation already exists for order {}, skipping", event.orderId());
        return;
    }
    inventoryService.reserve(event.orderId(), event.productIds());
}
```

### 4.5 Step 4 — Remove the Internal Event Path

After the new service has been running correctly for the soak period:

```java
// Step 4a: Delete the in-process handler from the monolith
// DELETE this file: com.myapp.inventory.internal.OrderInventoryHandler.java
// (it no longer lives in the monolith)

// Step 4b: Remove the inventory module from the monolith's @ApplicationModule
// (or just delete the package)
// com.myapp.inventory/ package → DELETE (it now lives in its own service)

// Step 4c: Update order module's allowedDependencies
// @ApplicationModule(allowedDependencies = {"inventory", "user"})
// → @ApplicationModule(allowedDependencies = {"user"})
// (no longer depends on inventory module directly)
```

```
Final state:
  Monolith:
    ├── order/       ← publishes OrderPlacedEvent → Kafka
    ├── user/
    └── notification/ ← still in monolith (in-process @ApplicationModuleListener)

  Inventory Service (separate JVM):
    └── @KafkaListener("orders.placed") ← handles it now

  Communication:
    order → [Kafka: orders.placed] → inventory-service (async)
    order → notification (in-process, still in monolith)
```

### 4.6 Timeline Summary

```
Week 1: Step 1 — Verify module structure, confirm event-driven boundaries
Week 2: Step 2 — Add @Externalized, deploy to staging, verify Kafka messages flow
Week 3: Step 3 — Build and deploy inventory-service, enable dual consumption
Week 4: Step 3 (soak) — Both paths running, monitor for differences, fix issues
Week 5: Step 4 — Remove in-process handler, inventory fully extracted

Total: ~5 weeks for one module extraction
vs. Extracting from a big-ball-of-mud: 6-18 months
```

---

## 5. Strangler Fig Pattern with Spring Modulith

### 5.1 What the Strangler Fig Pattern Is

The Strangler Fig is a pattern for incrementally replacing parts of a system without a big-bang rewrite. Named after the fig tree that grows around a host tree and eventually replaces it:

```
Classic Strangler Fig:
  Old monolith receives all traffic
  ↓
  New service built alongside it
  ↓
  Traffic gradually routed to new service (feature by feature)
  ↓
  Old monolith code removed when fully replaced

Spring Modulith variant:
  Old module in monolith receives all requests (internal)
  ↓
  New service built alongside it
  ↓
  Events dual-published (in-process + broker) [Step 2]
  ↓
  New service processes events from broker [Step 3]
  ↓
  In-process path removed [Step 4]
```

### 5.2 Strangler Fig with API Gateway Routing

For modules that handle HTTP requests (not just events), use an API gateway or reverse proxy to gradually route traffic:

```
Architecture during migration:

Client → API Gateway → [routing rules]
                          ├── /api/orders/** → Monolith (old path)
                          └── /api/inventory/** → Inventory Service (new path)

Step 1: All traffic → Monolith
Step 2: Inventory APIs → Inventory Service (10% traffic, canary)
Step 3: Inventory APIs → Inventory Service (100% traffic)
Step 4: Remove inventory module from Monolith
```

```yaml
# Example with Spring Cloud Gateway:
spring:
  cloud:
    gateway:
      routes:
        # Route inventory requests to the new service
        - id: inventory-service
          uri: http://inventory-service:8080
          predicates:
            - Path=/api/inventory/**
          filters:
            - StripPrefix=0

        # Everything else goes to the monolith
        - id: monolith
          uri: http://monolith:8080
          predicates:
            - Path=/**
```

### 5.3 Data Migration During Strangler Fig

When the extracted module needs its own database:

```sql
-- Phase 1: Module still in monolith, reads/writes to shared DB
-- All inventory tables in the main DB

-- Phase 2: Dual-write period
-- Monolith writes to main DB
-- New service writes to its own DB (eventually consistent)
-- New service reads from its own DB

-- Phase 3: Cut over reads to new service DB
-- New service is the source of truth

-- Phase 4: Stop writing to main DB tables
-- Clean up old inventory tables from main DB (decommission)

-- Key: add inventory_service_id to the event for cross-service correlation
@Externalized("orders.placed")
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    ...
) {}
-- Inventory service uses orderId to create its own reservation ID
```

---

## 6. Keeping Some Modules in the Monolith

### 6.1 The Goal Is NOT "Eventually All Microservices"

```
Common misconception: Modulith is a waypoint to full microservices
Reality: Modulith is a valid long-term architecture for most of the system

Target state for most companies:
  ┌─────────────────────────────────────────────────┐
  │               Modular Monolith                  │
  │  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
  │  │  order   │  │   user   │  │ catalog  │      │
  │  └──────────┘  └──────────┘  └──────────┘      │
  │  ┌──────────┐  ┌──────────┐                    │
  │  │reporting │  │analytics │                    │
  │  └──────────┘  └──────────┘                    │
  └──────────────────────┬──────────────────────────┘
                         │ events (Kafka)
          ┌──────────────┴──────────────┐
          ↓                             ↓
  ┌───────────────┐            ┌────────────────┐
  │ Inventory     │            │ ML Recommender │
  │ Service       │            │ Service        │
  │ (extracted:   │            │ (extracted:    │
  │  independent  │            │  Python,       │
  │  scaling)     │            │  GPU nodes)    │
  └───────────────┘            └────────────────┘

Only extract what genuinely NEEDS extraction.
Keep everything else in the modulith.
```

### 6.2 Modules That Should Almost Never Be Extracted

```
Don't extract modules that:

1. Change frequently together (tight logical coupling)
   Example: order + pricing + discount
   They need to deploy together → extracting creates coordination overhead

2. Need strong consistency (ACID transactions)
   Example: account + ledger + audit
   Distributed transactions (sagas) are complex and error-prone

3. Have no scaling differential
   Example: reporting module — same load as everything else
   No benefit to independent scaling

4. Are small (< 1000 lines)
   Overhead of a service (deployments, monitoring, networking)
   outweighs the benefits for a tiny module

5. Have many read dependencies
   Example: "every other module needs to call this module's service"
   Cross-service reads = N network calls instead of N method calls
   Performance cost is often not worth it
```

### 6.3 Modules That Are Good Extraction Candidates

```
Extract modules that:

1. Have genuinely different scaling needs
   Image processing, video transcoding, search indexing
   → 1 monolith instance, 50 processing instances

2. Need different tech
   ML inference (Python), real-time bidding (Go), legacy COBOL...
   → Language mismatch makes co-location impractical

3. Have clear team ownership AND the team is large enough
   "Team B owns inventory, Team A owns orders"
   Both teams have 5+ engineers AND their own DevOps capability

4. Have strict compliance/security boundaries
   PCI DSS payment processing, HIPAA health data, GDPR personal data
   → Compliance scope isolation justifies extraction

5. Have stable, rarely-changing APIs
   The service boundary won't be refactored next month
   → Service versioning is manageable
```

---

## 7. Shared Kernel — Common Types Across Modules

### 7.1 What a Shared Kernel Is

A shared kernel is a module that contains types used by multiple other modules. It avoids duplication while keeping modules independent:

```
Without shared kernel (duplication problem):
  com.myapp.order.Money   (order's copy)
  com.myapp.billing.Money (billing's copy — drifts out of sync over time)
  com.myapp.pricing.Money (pricing's copy — different rounding behavior!)

With shared kernel:
  com.myapp.shared.Money  (one authoritative definition)
  order, billing, pricing all depend on com.myapp.shared
```

### 7.2 What Belongs in the Shared Kernel

```java
// com.myapp.shared/ — the shared kernel module

// 1. Value objects used across domain modules
public record Money(BigDecimal amount, Currency currency) {
    Money { amount = amount.setScale(2, RoundingMode.HALF_UP); }
    public Money add(Money other) { ... }
    public Money multiply(int factor) { ... }
}

public record UserId(long value) {
    UserId { if (value <= 0) throw new IllegalArgumentException(); }
}

public record ProductId(long value) {}
public record OrderId(long value) {}

// 2. Common enums
public enum Currency { USD, EUR, GBP, JPY }
public enum Country { US, GB, DE, FR }

// 3. Common exceptions
public class EntityNotFoundException extends RuntimeException { ... }
public class ValidationException extends RuntimeException { ... }

// 4. Cross-module event types (events that multiple modules need to know about)
// Careful: not ALL events go here — only events that multiple modules produce or consume
public record UserDeletedEvent(UserId userId, Instant deletedAt) {}
```

### 7.3 What Does NOT Belong in the Shared Kernel

```java
// ❌ Module-specific types
// OrderPlacedEvent stays in order module — not in shared
// Only notification and inventory care about it
// Those modules can depend on order module's events

// ❌ Implementation details
// OrderRepository stays in order module
// Services stay in their own modules

// ❌ Spring beans / infrastructure
// No @Service, @Repository, @Component in shared kernel
// Shared kernel = pure Java value objects and interfaces only

// ❌ Business logic
// Pricing rules → pricing module
// Discount calculation → discount module
// Shared kernel is for primitive types, not business logic
```

### 7.4 Shared Kernel Module Configuration

```java
// com.myapp.shared is a leaf module — depends on NOTHING
@ApplicationModule(
    displayName = "Shared Kernel",
    allowedDependencies = {}  // no dependencies — prevents circular coupling
)
package com.myapp.shared;

// Other modules explicitly declare their dependency on shared:
@ApplicationModule(
    allowedDependencies = {"shared", "user"}
)
package com.myapp.order;

@ApplicationModule(
    allowedDependencies = {"shared"}
)
package com.myapp.inventory;
```

### 7.5 Shared Kernel in the Extracted Service Context

When a module is extracted, the shared kernel types must also be available to the new service:

```xml
<!-- Strategy 1: Shared kernel as its own Maven module (recommended) -->

<!-- Parent pom.xml -->
<modules>
    <module>shared-kernel</module>       ← published to Maven repo
    <module>monolith</module>            ← depends on shared-kernel
    <module>inventory-service</module>   ← depends on shared-kernel
</modules>

<!-- monolith/pom.xml -->
<dependency>
    <groupId>com.myapp</groupId>
    <artifactId>shared-kernel</artifactId>
    <version>${project.version}</version>
</dependency>

<!-- inventory-service/pom.xml -->
<dependency>
    <groupId>com.myapp</groupId>
    <artifactId>shared-kernel</artifactId>
    <version>${project.version}</version>
</dependency>
```

```java
// Shared kernel Maven module structure:
// shared-kernel/src/main/java/com/myapp/shared/
//   ├── Money.java
//   ├── UserId.java
//   ├── OrderId.java
//   └── ProductId.java
//   (no Spring dependencies — pure Java)

// IMPORTANT: shared-kernel JAR version must be compatible across both
// the monolith and all extracted services
// → Pin to a specific version
// → Versioning strategy: semantic versioning, backward-compatible changes only
```

### 7.6 Event Schema as Shared Contract

Events shared between the monolith and extracted services are a contract — they must be versioned carefully:

```java
// Version 1: initial event (in shared-kernel 1.0.0)
@Externalized("orders.placed")
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total
) {}

// Version 2: adding a new field (backward-compatible — just add with default)
@Externalized("orders.placed")
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total,
    String currency        // new field — old consumers get null, which they must handle
) {}

// Version 3: renaming a field (BREAKING — requires migration strategy)
// → Don't rename. Add new field, keep old, deprecate old, remove in v4.
// This is why shared kernel changes must be carefully managed.

// Producer can always add fields (additive changes are safe)
// Consumers must handle null for unknown fields (Jackson: @JsonIgnoreProperties(ignoreUnknown = true))
```

---

## 8. Quick Reference Cheat Sheet

### The Four-Step Migration

```
Step 1: Module + in-process @ApplicationModuleListener
         (event-driven boundaries already in place)

Step 2: Add @Externalized to event record
         OrderPlacedEvent now goes to Kafka AND in-process
         Zero code changes to publisher or listeners

Step 3: Build new service with @KafkaListener
         BOTH paths active (dual consumption)
         Verify new service works, run soak period

Step 4: Remove @ApplicationModuleListener from monolith
         Delete the module from monolith
         New service is the only consumer
```

### `@Externalized` Quick Reference

```java
@Externalized("topic-name")              // simple topic
@Externalized(target="topic", key="#{#event.orderId}")  // with routing key
@Externalized("topic.#{#event.region}")  // dynamic topic via SpEL
```

### Extraction Candidate Signals

```
✅ Extract:   Different scaling needs, team conflict, compliance boundary,
              tech mismatch, stable API
❌ Keep:      Changes together with other modules, needs ACID, small module,
              many read dependencies, no dedicated team
```

### Shared Kernel Rules

```java
// Shared kernel module:
@ApplicationModule(allowedDependencies = {})  // depends on NOTHING
package com.myapp.shared;
// Contains: value objects, enums, cross-module event types, common exceptions
// Does NOT contain: Spring beans, business logic, module-specific types

// In a multi-service architecture: publish as a Maven artifact
// All services depend on the same shared-kernel version
```

### Key Rules to Remember

1. **Modulith is the destination, not a waypoint** — most modules should stay in the monolith permanently.
2. **Extract at team boundaries, not technical boundaries** — if two teams fight over one codebase, extract; if one team owns everything, keep it together.
3. **`@Externalized` is the only code change for Step 2** — add one annotation to the event record, nothing else.
4. **Dual consumption is safe — make listeners idempotent** — during Step 3, both in-process and Kafka handlers run; idempotency prevents double-processing issues.
5. **Soak period before Step 4** — let both paths run in parallel for days/weeks before removing the in-process handler.
6. **Leaf modules are easiest to extract first** — start with modules nobody else depends on.
7. **Shared kernel depends on nothing** — `allowedDependencies = {}` prevents the shared module from coupling domain modules together transitively.
8. **Event schema is a contract** — breaking changes to `@Externalized` events require careful versioning; add fields, never remove or rename.
9. **Not every module needs extraction** — 2-4 extracted services + 1 modulith is a better target than 15 microservices.
10. **The four steps take weeks, not months** — if you've maintained module boundaries, extraction is a move-code operation, not a redesign.

---

*End of From Modulith to Microservices Study Guide — Module 6*
