# Spring Modulith: Application Modules — Complete Study Guide

> **Module 2 | Brutally Detailed Reference**
> Covers `spring-modulith-core` setup, automatic module detection by package structure, the public API vs internal packages contract, `@ApplicationModule` explicit configuration, named interfaces for sub-package exposure, and open vs closed module control. Full working examples and violation output throughout.

---

## Table of Contents

1. [`spring-modulith-core` Dependency](#1-spring-modulith-core-dependency)
2. [Module Detection — Package Structure Rules](#2-module-detection--package-structure-rules)
3. [Module API — What Is Public vs Internal](#3-module-api--what-is-public-vs-internal)
4. [Internal Packages — Hiding Implementation Details](#4-internal-packages--hiding-implementation-details)
5. [`@ApplicationModule` — Explicit Configuration](#5-applicationmodule--explicit-configuration)
6. [Named Interfaces — `@NamedInterface`](#6-named-interfaces--namedinterface)
7. [Open vs Closed Modules — `allowedDependencies`](#7-open-vs-closed-modules--alloweddependencies)
8. [Verification — `ApplicationModules.verify()`](#8-verification--applicationmodulesverify)
9. [Practical Module Design Patterns](#9-practical-module-design-patterns)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. `spring-modulith-core` Dependency

### 1.1 Maven Setup

```xml
<!-- Option A: Use the BOM (recommended — manages all Modulith versions) -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.modulith</groupId>
            <artifactId>spring-modulith-bom</artifactId>
            <version>1.2.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>
    <!-- Core: module detection, verification, documentation -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-core</artifactId>
    </dependency>

    <!-- Testing: @ApplicationModuleTest, event publication assertions -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-test</artifactId>
        <scope>test</scope>
    </dependency>

    <!-- Events: @ApplicationModuleListener, event publication log -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-events-api</artifactId>
    </dependency>

    <!-- Event persistence with JPA (for reliable event delivery) -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-events-jpa</artifactId>
    </dependency>

    <!-- Observability: module-aware metrics and tracing -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-observability</artifactId>
    </dependency>

    <!-- Documentation: PlantUML diagram generation -->
    <dependency>
        <groupId>org.springframework.modulith</groupId>
        <artifactId>spring-modulith-docs</artifactId>
        <scope>test</scope>  <!-- only needed during test/documentation phase -->
    </dependency>
</dependencies>
```

### 1.2 Gradle Setup

```groovy
// build.gradle
dependencies {
    implementation platform("org.springframework.modulith:spring-modulith-bom:1.2.0")

    implementation "org.springframework.modulith:spring-modulith-core"
    implementation "org.springframework.modulith:spring-modulith-events-api"

    testImplementation "org.springframework.modulith:spring-modulith-test"
}
```

### 1.3 What `spring-modulith-core` Provides

```
spring-modulith-core adds:
  - ApplicationModules: discovers and models the module structure
  - Module boundary verification: detects violations
  - @ApplicationModule: explicit module configuration annotation
  - @NamedInterface: expose sub-package as named interface
  - Documenter: generates PlantUML / AsciiDoc module diagrams
  - Module dependency analysis: detects cycles, dependency directions
```

---

## 2. Module Detection — Package Structure Rules

### 2.1 The Detection Rule

Spring Modulith's core rule: **each direct sub-package of the main application package is one module**.

```
com.myapp/                    ← main application package (contains @SpringBootApplication)
  ├── Application.java        ← main class (NOT a module)
  ├── order/                  ← ORDER MODULE (direct sub-package)
  │   ├── OrderService.java
  │   └── OrderController.java
  ├── inventory/              ← INVENTORY MODULE (direct sub-package)
  │   ├── InventoryService.java
  │   └── StockLevel.java
  ├── user/                   ← USER MODULE (direct sub-package)
  │   └── UserService.java
  └── notification/           ← NOTIFICATION MODULE (direct sub-package)
      └── NotificationService.java

Spring Modulith automatically detects:
  Module "order"        → com.myapp.order
  Module "inventory"    → com.myapp.inventory
  Module "user"         → com.myapp.user
  Module "notification" → com.myapp.notification
```

### 2.2 Module Names

By default, the module name equals the package name's last segment:

```
Package                    Module Name
─────────────────────────────────────────
com.myapp.order         → "order"
com.myapp.inventory     → "inventory"
com.myapp.user          → "user"
com.myapp.notification  → "notification"
```

### 2.3 `ApplicationModules.of()` — Discovering Modules

```java
// The entry point for all module analysis
ApplicationModules modules = ApplicationModules.of(MyApplication.class);

// Print discovered modules to stdout
modules.forEach(System.out::println);
// Output:
// Module order -> Logical name: order
//   Base package: com.myapp.order
//   Spring beans:
//     + com.myapp.order.OrderService
//     + com.myapp.order.OrderController
//   Excluded: com.myapp.order.internal (internal)
//
// Module inventory -> Logical name: inventory
//   Base package: com.myapp.inventory
//   ...

// Check if a class belongs to a specific module
Optional<ApplicationModule> module = modules.getModuleByType(OrderService.class);
module.ifPresent(m -> System.out.println("OrderService is in: " + m.getName()));
// OrderService is in: order
```

### 2.4 What Does NOT Become a Module

```java
// These are NOT modules:

// 1. The main application package itself
@SpringBootApplication
public class MyApplication { ... }
// com.myapp itself is NOT a module — it's the root

// 2. Sub-sub-packages (only direct sub-packages become modules)
com.myapp.order.service   // NOT a module — goes into order module as internal
com.myapp.order.repository // NOT a module — goes into order module as internal

// 3. Packages deeper than one level:
com.myapp.domain.order     // NOT detected — "domain" would be a module, "order" is inside it
// To fix: move to com.myapp.order

// 4. Excluded packages (if configured)
```

### 2.5 Example: Multi-Level Package — Pitfall

```
Pitfall: developer organizes by layer instead of domain:

com.myapp/
  ├── controllers/           ← "controllers" module (wrong!)
  │   ├── OrderController.java
  │   └── UserController.java
  ├── services/              ← "services" module (wrong!)
  │   ├── OrderService.java
  │   └── UserService.java
  └── repositories/          ← "repositories" module (wrong!)
      ├── OrderRepository.java
      └── UserRepository.java

This creates modules by technical concern, not business domain.
OrderController, OrderService, OrderRepository belong in the SAME module.

Correct structure:
com.myapp/
  ├── order/
  │   ├── OrderController.java
  │   ├── OrderService.java
  │   └── internal/
  │       └── OrderRepository.java
  └── user/
      ├── UserService.java
      └── internal/
          └── UserRepository.java
```

---

## 3. Module API — What Is Public vs Internal

### 3.1 The Public API Contract

In a Spring Modulith module, the **root package** contains the module's public API. Only these types can be used by other modules:

```
com.myapp.order/             ← root package = public API
  ├── OrderService.java      ← PUBLIC: other modules can inject this
  ├── CreateOrderRequest.java ← PUBLIC: other modules can instantiate this
  ├── OrderSummary.java      ← PUBLIC: DTO returned to other modules
  ├── OrderPlacedEvent.java  ← PUBLIC: event published for other modules
  └── internal/              ← INTERNAL: other modules cannot access
      ├── OrderEntity.java   ← INTERNAL: JPA entity — own by the module
      ├── OrderRepository.java ← INTERNAL: Spring Data repo
      ├── OrderValidator.java  ← INTERNAL: implementation detail
      └── OrderEmailHelper.java ← INTERNAL: helper class

Rule: If another module needs something from the order module,
      it must be in com.myapp.order (not com.myapp.order.internal)
```

### 3.2 Java Visibility vs Spring Modulith Visibility

An important distinction: Spring Modulith enforces **module-level** visibility on top of Java's class-level visibility:

```java
// OrderRepository is Java-public but Modulith-internal
// It's in com.myapp.order.internal — inaccessible from other modules

package com.myapp.order.internal;

public class OrderRepository {          // Java: public
    // ...                               // Modulith: INTERNAL (wrong package)
}

// UserService.java (another module) trying to use it:
package com.myapp.user;

@Service
public class UserService {

    @Autowired
    private OrderRepository orderRepo;  // ← Spring Modulith VIOLATION
    // Even though OrderRepository is Java-public, it's in order.internal
    // Spring Modulith's verify() will catch this
}
```

```
Java visibility:     public/protected/package-private/private (class-level)
Modulith visibility: public API (root package) vs internal (sub-packages)

They are ORTHOGONAL.
A class can be Java-public but Modulith-internal.
Modulith enforces a stricter, domain-level encapsulation.
```

### 3.3 What Belongs in the Root Package (Public API)

```java
// ✅ PUBLIC API — goes in com.myapp.order directly:

// 1. Service facade (the entry point for the module)
public interface OrderService {
    Order createOrder(CreateOrderRequest request);
    OrderSummary getOrder(Long orderId);
    void cancelOrder(Long orderId);
}

// 2. DTOs / Value objects passed in or out
public record CreateOrderRequest(Long userId, List<Long> productIds, String shippingAddress) {}
public record OrderSummary(Long id, BigDecimal total, OrderStatus status) {}

// 3. Domain events published by this module
public record OrderPlacedEvent(Long orderId, String customerEmail, List<Long> productIds) {}
public record OrderCancelledEvent(Long orderId, String reason) {}

// 4. Enums used in the public API
public enum OrderStatus { PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED }

// 5. Exceptions thrown by the public API
public class OrderNotFoundException extends RuntimeException { ... }
public class InsufficientInventoryException extends RuntimeException { ... }
```

### 3.4 What Belongs in Internal Packages

```java
// ❌ INTERNAL — goes in com.myapp.order.internal:

// 1. JPA entities (implementation detail of how data is stored)
@Entity
class OrderEntity { ... }      // package-private or class in internal package

// 2. Spring Data repositories
interface OrderJpaRepository extends JpaRepository<OrderEntity, Long> { ... }

// 3. Service implementation (only the interface is public API)
@Service
class OrderServiceImpl implements OrderService { ... }

// 4. Validators, mappers, helpers
class OrderValidator { ... }
class OrderEntityMapper { ... }
class OrderPricingCalculator { ... }

// 5. Outbound adapters (Feign clients, REST templates)
class PaymentGatewayClient { ... }

// 6. Internal events (not published to other modules)
record OrderInventoryReservedEvent(Long orderId) {} // internal coordination
```

---

## 4. Internal Packages — Hiding Implementation Details

### 4.1 The `internal` Sub-Package Convention

Spring Modulith automatically treats **any sub-package** of a module as internal. The convention (not a requirement) is to name it `internal`:

```
com.myapp.order/
  ├── OrderService.java          ← public API
  └── internal/                  ← internal (by position as sub-package)
      ├── data/                  ← internal (nested sub-package)
      │   └── OrderEntity.java
      └── service/               ← internal (nested sub-package)
          └── OrderServiceImpl.java

ALL of these are treated as internal by Spring Modulith:
  com.myapp.order.internal
  com.myapp.order.internal.data
  com.myapp.order.internal.service
  com.myapp.order.repository
  com.myapp.order.service
  com.myapp.order.anything_else
```

### 4.2 Alternative Internal Package Names

You're not forced to name the sub-package `internal` — any sub-package is internal:

```
com.myapp.order/
  ├── OrderService.java         ← public API (root package)
  ├── data/                     ← internal (sub-package, any name works)
  │   ├── OrderEntity.java
  │   └── OrderRepository.java
  ├── web/                      ← internal (sub-package)
  │   └── OrderController.java
  └── events/                   ← CAREFUL: internal by default
      ├── OrderPlacedEventHandler.java  ← internal handler (fine)
      └── OrderPlacedEvent.java ← CAREFUL: if you want this to be public API,
                                    move to root package OR use @NamedInterface
```

### 4.3 Violation Detection — What the Error Looks Like

When `ApplicationModules.verify()` detects a violation:

```
org.springframework.modulith.core.Violations
  Module 'user' depends on non-exposed type
  'com.myapp.order.internal.OrderEntity' in module 'order'.
  Offending type: com.myapp.user.UserOrderHistory

  Suggested fix:
    1. Move OrderEntity to com.myapp.order (expose as public API)
    2. OR: Create a public DTO in com.myapp.order that UserOrderHistory can use instead
    3. OR: Use a @NamedInterface to expose a specific sub-package
```

### 4.4 Restructuring Example — Moving from Layers to Modules

```
BEFORE (layered, violates module boundaries):

com.myapp/
  ├── controller/
  │   ├── OrderController.java      (references OrderEntity — data layer)
  │   └── UserController.java
  ├── service/
  │   ├── OrderService.java         (references UserRepository — crosses concern)
  │   └── UserService.java
  └── repository/
      ├── OrderRepository.java
      └── UserRepository.java

AFTER (domain modules with Spring Modulith):

com.myapp/
  ├── order/
  │   ├── OrderService.java          (public API interface)
  │   ├── OrderSummary.java          (public DTO)
  │   ├── OrderPlacedEvent.java      (public event)
  │   └── internal/
  │       ├── OrderController.java   (HTTP layer — internal to order)
  │       ├── OrderServiceImpl.java  (implementation — internal)
  │       ├── OrderEntity.java       (JPA entity — internal)
  │       └── OrderRepository.java   (Spring Data repo — internal)
  └── user/
      ├── UserService.java           (public API interface)
      ├── UserProfile.java           (public DTO)
      └── internal/
          ├── UserController.java
          ├── UserEntity.java
          └── UserRepository.java
```

---

## 5. `@ApplicationModule` — Explicit Configuration

### 5.1 When to Use `@ApplicationModule`

By default, Spring Modulith infers module configuration from package structure. `@ApplicationModule` is for **explicit overrides**:

```java
// Place @ApplicationModule on the module's "marker" class
// Convention: package-info.java file or a dedicated class in the module root

@ApplicationModule(
    displayName = "Order Management",             // human-readable name for docs
    allowedDependencies = {"inventory", "user"},  // only these modules can be depended on
    type = ApplicationModule.Type.OPEN            // OPEN or CLOSED (default)
)
package com.myapp.order;  // in package-info.java

// OR on a dedicated marker class:
package com.myapp.order;

@ApplicationModule(displayName = "Order Management")
class OrderModule { }     // empty class, just carries the annotation
```

### 5.2 `package-info.java` — Recommended Approach

```java
// src/main/java/com/myapp/order/package-info.java
@ApplicationModule(
    displayName = "Order Management",
    allowedDependencies = {"inventory", "user"}
)
package com.myapp.order;

import org.springframework.modulith.ApplicationModule;
```

### 5.3 `displayName` — Human-Readable Module Name

```java
@ApplicationModule(displayName = "Order Management")
package com.myapp.order;
// Default (without annotation): "order" (just the package name)
// With displayName: "Order Management" in documentation and diagrams
```

### 5.4 Type — `OPEN` vs `CLOSED`

```java
// OPEN module (default if not specified):
//   - Any module can access its public API
//   - No restriction on who depends on you
@ApplicationModule(type = ApplicationModule.Type.OPEN)
package com.myapp.order;

// CLOSED module:
//   - NOBODY can access this module unless explicitly listed
//   - Completely locked down
//   - Used for infrastructure modules, shared utilities
@ApplicationModule(type = ApplicationModule.Type.CLOSED)
package com.myapp.infrastructure;
// Result: only modules explicitly allowed can use this
// (see Section 7 for allowedDependencies)
```

---

## 6. Named Interfaces — `@NamedInterface`

### 6.1 The Problem Named Interfaces Solve

Sometimes you need to expose a sub-package — for example, an `events` package with event classes that other modules subscribe to, or a `spi` package with extension points:

```
Problem:
  com.myapp.order/
    ├── OrderService.java       ← public API (root)
    └── events/                 ← INTERNAL by default
        ├── OrderPlacedEvent.java   ← you WANT this visible to other modules
        └── OrderCancelledEvent.java ← you WANT this visible too
        └── OrderInternalEvent.java ← you DON'T want this visible

  How to expose events/ without exposing ALL of order's sub-packages?
  → @NamedInterface
```

### 6.2 Declaring a Named Interface

```java
// Option 1: package-info.java in the sub-package
// src/main/java/com/myapp/order/events/package-info.java
@NamedInterface("events")
package com.myapp.order.events;

import org.springframework.modulith.NamedInterface;
```

### 6.3 Using Named Interfaces in `allowedDependencies`

```java
// Other modules reference named interfaces with module::interface syntax
@ApplicationModule(
    allowedDependencies = {
        "inventory",           // entire inventory module
        "order::events"        // ONLY the events named interface of order
    }
)
package com.myapp.notification;
// notification can use:
//   - Everything in com.myapp.inventory (root package)
//   - ONLY com.myapp.order.events.* (named interface)
//   - NOT com.myapp.order.OrderService (root package excluded if using :: syntax)
//   - NOT com.myapp.order.internal.* (always excluded)
```

### 6.4 Multiple Named Interfaces

```java
// A module can expose multiple named interfaces for different purposes

// com/myapp/order/events/package-info.java
@NamedInterface("events")
package com.myapp.order.events;

// com/myapp/order/spi/package-info.java
@NamedInterface("spi")
package com.myapp.order.spi;
// Extension points: OrderPricingStrategy, OrderValidator SPI interfaces

// Usage by another module:
@ApplicationModule(allowedDependencies = "order::spi")
package com.myapp.pricing;
// pricing can ONLY use the SPI, not the events or root API
```

### 6.5 Complete Named Interface Example

```
com.myapp.order/
  ├── OrderService.java              ← public root API
  ├── OrderSummary.java              ← public root API
  ├── events/                        ← @NamedInterface("events")
  │   ├── package-info.java
  │   ├── OrderPlacedEvent.java      ← exposed via named interface
  │   └── OrderCancelledEvent.java   ← exposed via named interface
  ├── spi/                           ← @NamedInterface("spi")
  │   ├── package-info.java
  │   └── OrderDiscountStrategy.java ← extension point interface
  └── internal/
      ├── OrderEntity.java           ← NEVER accessible
      └── OrderRepository.java       ← NEVER accessible
```

```java
// notification module can subscribe to events without knowing Order internals
@ApplicationModule(allowedDependencies = "order::events")
package com.myapp.notification;

// In NotificationService:
@ApplicationModuleListener
void on(OrderPlacedEvent event) {    // ← from order.events (accessible via @NamedInterface)
    emailService.sendConfirmation(event.customerEmail());
}

// This would fail: notification → order.internal
@Autowired
private OrderRepository orderRepo; // ← VIOLATION: internal even if ::events is allowed
```

---

## 7. Open vs Closed Modules — `allowedDependencies`

### 7.1 Open Modules (Default)

```java
// By default, all modules are OPEN:
// Any other module can import from your public API

// No @ApplicationModule annotation needed for open behavior:
package com.myapp.order;
// Anyone can use OrderService, OrderSummary, etc.
```

### 7.2 Closed Modules

```java
// CLOSED module: nobody can depend on this UNLESS explicitly listed
@ApplicationModule(type = ApplicationModule.Type.CLOSED)
package com.myapp.infrastructure;
// ERROR: no module is allowed to use infrastructure by default
// Must explicitly list it: allowedDependencies = {"infrastructure"}
```

### 7.3 `allowedDependencies` — Restricting What You Depend On

`allowedDependencies` restricts **outgoing** dependencies — what modules THIS module is allowed to depend on:

```java
// Order module may ONLY depend on inventory and user
@ApplicationModule(
    displayName = "Order Management",
    allowedDependencies = {"inventory", "user"}
)
package com.myapp.order;

// If order tries to use anything from notification or billing:
// → verify() FAILS with a violation
// → Acts as architectural guardrail: "order should not know about notifications"
```

```
Visualization:
  order → inventory  ✓ (listed in allowedDependencies)
  order → user       ✓ (listed in allowedDependencies)
  order → notification ✗ VIOLATION (not listed)
  order → billing    ✗ VIOLATION (not listed)
```

### 7.4 Dependency Restrictions — Which Direction

```java
// allowedDependencies = what THIS module can call
@ApplicationModule(allowedDependencies = {"inventory", "user"})
package com.myapp.order;

// To restrict WHO CAN CALL YOU:
// → Use CLOSED type
@ApplicationModule(type = ApplicationModule.Type.CLOSED)
package com.myapp.security;
// Nobody can use security module types unless... 
// the CALLER's module lists "security" in their allowedDependencies:
@ApplicationModule(allowedDependencies = {"security"})
package com.myapp.user;
// Now user → security is allowed
```

### 7.5 Practical Dependency Strategy

```
Common patterns:

1. Strict layering (domain doesn't know infrastructure):
   @ApplicationModule(allowedDependencies = {})  ← depends on NOTHING
   package com.myapp.domain;

   @ApplicationModule(allowedDependencies = {"domain"})
   package com.myapp.application;

   @ApplicationModule(allowedDependencies = {"domain", "application"})
   package com.myapp.infrastructure;

2. Domain modules depending on shared kernel:
   @ApplicationModule(allowedDependencies = {"shared"})
   package com.myapp.order;

   @ApplicationModule(allowedDependencies = {"shared"})
   package com.myapp.inventory;

   // No order → inventory dependency allowed

3. Event-driven (modules only share events, not services):
   @ApplicationModule(allowedDependencies = {"order::events", "shared"})
   package com.myapp.notification;
   // notification listens to events but doesn't call OrderService

4. No restrictions (full open, just verify no internal access):
   // No @ApplicationModule annotation — all public APIs accessible
   // Still verifies: no access to internal packages
```

---

## 8. Verification — `ApplicationModules.verify()`

### 8.1 The Verification Test

```java
// src/test/java/com/myapp/ModularityTests.java
class ModularityTests {

    ApplicationModules modules = ApplicationModules.of(MyApplication.class);

    @Test
    void verifiesModuleStructure() {
        // This verifies ALL of the following:
        // 1. No module accesses another module's internal classes
        // 2. No circular dependencies between modules
        // 3. allowedDependencies constraints are respected
        // 4. Named interface access is valid
        modules.verify();
    }
}
```

### 8.2 What Verify Checks

```
verify() checks:

1. ✓ Internal package access
   com.myapp.user.UserService → com.myapp.order.internal.OrderEntity
   VIOLATION: order.internal is not accessible from user module

2. ✓ Circular dependencies
   order → inventory AND inventory → order
   VIOLATION: cycle detected between order and inventory

3. ✓ allowedDependencies
   order declares allowedDependencies = {"inventory"}
   order.OrderService → notification.NotificationService
   VIOLATION: order is not allowed to depend on notification

4. ✓ Named interface access
   notification declares allowedDependencies = {"order::events"}
   notification.Handler → order.OrderService
   VIOLATION: order.OrderService is not part of the "events" interface
```

### 8.3 Generating Documentation

```java
class DocumentationTests {

    ApplicationModules modules = ApplicationModules.of(MyApplication.class);

    @Test
    void writeDocumentationSnippets() {
        new Documenter(modules)
            .writeModulesAsPlantUml()              // single overview diagram
            .writeIndividualModulesAsPlantUml()    // one diagram per module
            .writeAggregatingDocument();            // AsciiDoc documentation
    }
}
```

Generated PlantUML output:
```plantuml
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

Component(order, "Order Management", "Module")
Component(inventory, "inventory", "Module")
Component(user, "user", "Module")
Component(notification, "notification", "Module")

Rel(order, inventory, "uses")
Rel(order, user, "uses")
Rel(notification, order, "listens to events")
@enduml
```

---

## 9. Practical Module Design Patterns

### 9.1 Recommended Module Structure

```
com.myapp.order/                           ← Module root = Public API
  ├── package-info.java                    ← @ApplicationModule configuration
  ├── OrderService.java                    ← Public: service interface
  ├── OrderSummary.java                    ← Public: DTO (returned to callers)
  ├── CreateOrderRequest.java              ← Public: DTO (received from callers)
  ├── OrderNotFoundException.java          ← Public: exception
  ├── OrderStatus.java                     ← Public: enum
  │
  ├── events/                              ← @NamedInterface("events")
  │   ├── package-info.java
  │   ├── OrderPlacedEvent.java
  │   └── OrderCancelledEvent.java
  │
  └── internal/                            ← Module internals (hidden)
      ├── OrderServiceImpl.java            ← Implementation of OrderService
      ├── OrderEntity.java                 ← JPA entity
      ├── OrderRepository.java             ← Spring Data repo
      ├── OrderMapper.java                 ← Entity ↔ DTO mapper
      ├── OrderValidator.java              ← Input validation
      └── web/
          └── OrderController.java         ← REST controller (internal to module)
```

### 9.2 Interface + Implementation Split

```java
// Public API: com.myapp.order.OrderService (interface in root package)
package com.myapp.order;

public interface OrderService {
    OrderSummary createOrder(CreateOrderRequest request);
    OrderSummary getOrder(Long orderId);
    void cancelOrder(Long orderId);
}

// Implementation: com.myapp.order.internal.OrderServiceImpl (in internal)
package com.myapp.order.internal;

@Service
class OrderServiceImpl implements OrderService {

    private final OrderRepository repository;
    private final OrderMapper mapper;
    private final ApplicationEventPublisher events;
    private final InventoryService inventory;  // public API of inventory module
    private final UserService user;            // public API of user module

    @Override
    public OrderSummary createOrder(CreateOrderRequest request) {
        // Uses only public APIs of other modules
        UserProfile profile = user.getProfile(request.userId());
        if (!inventory.checkAvailability(request.productIds())) {
            throw new InsufficientInventoryException(request.productIds());
        }
        OrderEntity entity = mapper.toEntity(request, profile);
        repository.save(entity);
        events.publishEvent(new OrderPlacedEvent(entity.getId(), profile.email(), request.productIds()));
        return mapper.toSummary(entity);
    }
}
```

### 9.3 Shared Kernel Module

```java
// A "shared" module contains types used by multiple modules
// It must have NO dependencies on other domain modules
// (to prevent indirect coupling)

// com.myapp.shared/
//   ├── Money.java          ← Value object (used by order and billing)
//   ├── UserId.java         ← Value object (used by order, user, inventory)
//   └── AuditInfo.java      ← Common auditing fields

@ApplicationModule(
    displayName = "Shared Kernel",
    allowedDependencies = {}  // depends on NOTHING — pure domain types
)
package com.myapp.shared;

// Other modules reference it:
@ApplicationModule(allowedDependencies = {"shared", "user"})
package com.myapp.order;
```

---

## 10. Quick Reference Cheat Sheet

### Package Structure Rules

```
com.myapp/                 ← root (NOT a module)
  ├── MyApplication.java   ← @SpringBootApplication (NOT a module)
  ├── order/               ← ORDER module (direct sub-package)
  ├── inventory/           ← INVENTORY module
  └── user/                ← USER module

Within a module:
  com.myapp.order/         ← PUBLIC API (accessible by other modules)
  com.myapp.order.*/       ← INTERNAL (inaccessible by other modules)
  com.myapp.order.internal ← INTERNAL (conventional name)
```

### `@ApplicationModule` Annotation

```java
@ApplicationModule(
    displayName = "Human readable name",        // for docs/diagrams
    allowedDependencies = {"mod1", "mod2::iface"}, // outgoing deps allowed
    type = ApplicationModule.Type.OPEN          // OPEN (default) or CLOSED
)
package com.myapp.order;
```

### `@NamedInterface` Annotation

```java
// In sub-package's package-info.java:
@NamedInterface("events")
package com.myapp.order.events;

// Reference with module::interface syntax:
allowedDependencies = {"order::events"}  // only events sub-package
allowedDependencies = {"order"}          // all of order's root public API
```

### Verification Test (Run in CI)

```java
class ModularityTest {
    ApplicationModules modules = ApplicationModules.of(MyApplication.class);

    @Test
    void verify() {
        modules.verify();  // fails with detailed violations if structure is wrong
    }
}
```

### Key Rules to Remember

1. **Direct sub-packages = modules** — only first-level sub-packages under the main class's package.
2. **Root package = public API** — types in `com.myapp.order` are accessible; types in `com.myapp.order.*` are not.
3. **All sub-packages are internal** — regardless of name (`internal`, `service`, `data`, etc.).
4. **Java `public` ≠ Modulith public** — a class can be Java-public but Modulith-internal (it's in a sub-package).
5. **`@NamedInterface` exposes a sub-package** — the only way to make a sub-package accessible to other modules.
6. **`allowedDependencies` restricts outgoing deps** — what this module can call; use `CLOSED` type to restrict incoming.
7. **No `@ApplicationModule` = open module** — any other module can use your public API by default.
8. **`verify()` in CI** — the test is fast (no Spring context) and catches violations immediately.
9. **Prefer interface + impl split** — interface in root package (public), implementation in internal (hidden).
10. **Shared kernel has no domain deps** — `allowedDependencies = {}` prevents the shared module from coupling modules together.

---

*End of Application Modules Study Guide — Module 2*
