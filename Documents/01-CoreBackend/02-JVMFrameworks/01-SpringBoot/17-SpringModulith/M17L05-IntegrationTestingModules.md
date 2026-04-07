# Spring Modulith: Integration Testing Modules — Complete Study Guide

> **Module 5 | Brutally Detailed Reference**
> Covers `@ApplicationModuleTest` for isolated module bootstrapping, the speed advantage over `@SpringBootTest`, the `Scenario` API for event-driven flow testing, mocking other modules, and verifying event publications. Full working examples with output comparisons throughout.

---

## Table of Contents

1. [`@ApplicationModuleTest` — Bootstrap Only the Module Under Test](#1-applicationmoduletest--bootstrap-only-the-module-under-test)
2. [Faster Tests — Context Size Comparison](#2-faster-tests--context-size-comparison)
3. [The `Scenario` API — Testing Event-Driven Flows](#3-the-scenario-api--testing-event-driven-flows)
4. [Testing a Module in Isolation — Mocking Other Modules](#4-testing-a-module-in-isolation--mocking-other-modules)
5. [Verifying Event Publication](#5-verifying-event-publication)
6. [Advanced Scenario Patterns](#6-advanced-scenario-patterns)
7. [Quick Reference Cheat Sheet](#7-quick-reference-cheat-sheet)

---

## 1. `@ApplicationModuleTest` — Bootstrap Only the Module Under Test

### 1.1 What `@ApplicationModuleTest` Does

`@ApplicationModuleTest` is a test annotation that starts a **partial Spring application context** containing only:
- The beans in the module being tested
- Beans from modules that the tested module directly depends on
- Infrastructure beans (datasource, transaction manager, etc.)

It does **not** load beans from unrelated modules.

```java
// Standard @SpringBootTest — loads EVERYTHING
@SpringBootTest
class OrderServiceFullContextTest {
    // Context contains:
    // ✓ order module beans
    // ✓ inventory module beans
    // ✓ user module beans
    // ✓ notification module beans
    // ✓ loyalty module beans
    // ✓ analytics module beans
    // ✓ shipping module beans
    // ✓ reporting module beans
    // = ALL beans in the entire application
}

// @ApplicationModuleTest — loads only what ORDER needs
@ApplicationModuleTest
class OrderServiceModuleTest {
    // Context contains:
    // ✓ order module beans  (the module under test)
    // ✓ inventory module beans (order depends on inventory)
    // ✓ user module beans (order depends on user)
    // ✗ notification module (order doesn't depend on it — excluded!)
    // ✗ loyalty module (excluded)
    // ✗ analytics module (excluded)
    // ✗ shipping module (excluded)
    // ✗ reporting module (excluded)
}
```

### 1.2 Basic Setup

```java
import org.springframework.modulith.test.ApplicationModuleTest;
import org.springframework.modulith.test.Scenario;
import org.springframework.beans.factory.annotation.Autowired;
import org.junit.jupiter.api.Test;

// Spring Modulith infers which module to test from the test class's package
// Test class is in com.myapp.order.* → loads the "order" module
@ApplicationModuleTest
class OrderServiceTest {

    @Autowired
    private OrderService orderService;  // from order module — available

    @Autowired
    private InventoryService inventoryService;  // from inventory — available (order depends on it)

    // @Autowired
    // private NotificationService notificationService;  // NOT available — not in context!

    @Test
    void createOrder_persistsAndReturns() {
        CreateOrderRequest req = new CreateOrderRequest(1L, List.of(10L, 20L));
        Order order = orderService.createOrder(req);

        assertThat(order.getId()).isNotNull();
        assertThat(order.getStatus()).isEqualTo(OrderStatus.PENDING);
    }
}
```

### 1.3 Bootstrap Modes

`@ApplicationModuleTest` has three bootstrap modes that control how much of the dependency graph is loaded:

```java
// Mode 1: STANDALONE — loads ONLY the module itself, mocks all dependencies
// Best for: pure unit-style tests, module with many dependencies you want to mock
@ApplicationModuleTest(mode = BootstrapMode.STANDALONE)
class OrderStandaloneTest {
    // Only order module beans loaded
    // InventoryService, UserService, etc. are NOT loaded
    // You must @MockitoBean all external dependencies
    @MockitoBean
    private InventoryService inventoryService;
    @MockitoBean
    private UserService userService;
}

// Mode 2: DIRECT_DEPENDENCIES (default) — loads module + its direct dependencies
// Best for: integration tests with real collaborators, most common choice
@ApplicationModuleTest  // mode = DIRECT_DEPENDENCIES by default
class OrderIntegrationTest {
    // order module + all modules order directly depends on (inventory, user)
    // @ApplicationModule(allowedDependencies = {"inventory", "user"}) defines this
}

// Mode 3: ALL_DEPENDENCIES — loads module + transitive dependency tree
// Best for: complex integration scenarios, end-to-end module testing
@ApplicationModuleTest(mode = BootstrapMode.ALL_DEPENDENCIES)
class OrderFullDependencyTest {
    // order → inventory → warehouse (transitively included)
    // order → user → auth (transitively included)
    // All transitive deps are loaded
}
```

### 1.4 Specifying Which Module to Test

By convention, the tested module is inferred from the test class's package. You can also specify it explicitly:

```java
// Test is in com.myapp.order.test — Spring Modulith infers "order" module
package com.myapp.order;

@ApplicationModuleTest
class OrderTest { ... }

// Explicit module specification (if test is in a different package)
@ApplicationModuleTest(module = "order")
class OrderModuleTestExplicit { ... }
```

---

## 2. Faster Tests — Context Size Comparison

### 2.1 Why Context Size Matters

Spring Boot's biggest test bottleneck is ApplicationContext startup. The fewer beans, the faster the context:

```
Typical Spring Boot application with 8 modules:
  Total beans loaded by @SpringBootTest: ~350 beans
  Context startup time: 8–15 seconds

Same test with @ApplicationModuleTest (DIRECT_DEPENDENCIES):
  Beans loaded for "order" module: ~45 beans
  Context startup time: 1–2 seconds

Savings: 6–13 seconds per test class
In a suite of 20 module test classes:
  @SpringBootTest:          8s × 20 = 160 seconds = 2m 40s
  @ApplicationModuleTest:  1.5s × 20 = 30 seconds = 0m 30s
  → 5× faster
```

### 2.2 Context Caching Behavior

Spring caches application contexts between tests with the same configuration. `@ApplicationModuleTest` produces **different context keys** per module, so each module gets its own cached context:

```
Test run execution order:

OrderServiceTest    (@ApplicationModuleTest)    → starts "order" context   [1.5s]
OrderControllerTest (@ApplicationModuleTest)    → reuses "order" context   [0.0s] ← cached!
InventoryTest       (@ApplicationModuleTest)    → starts "inventory" context [1.2s]
InventoryRepoTest   (@ApplicationModuleTest)    → reuses "inventory" context [0.0s] ← cached!
UserServiceTest     (@ApplicationModuleTest)    → starts "user" context    [1.0s]
UserControllerTest  (@ApplicationModuleTest)    → reuses "user" context    [0.0s] ← cached!

Total cold-start time: 3.7 seconds (only 3 contexts started)
vs @SpringBootTest: 8s × 6 = 48 seconds (6 full contexts, each one identical)
```

### 2.3 Measuring the Difference

```java
// Add this to see context startup time in tests:
@ApplicationModuleTest
class OrderServiceTest {

    @BeforeAll
    static void logStartup() {
        // The context is started before @BeforeAll — but you can use Spring Boot Actuator
        // or simply observe the time in your test runner output
    }

    // IntelliJ / Maven shows per-test timing:
    // OrderServiceTest > createOrder_persistsAndReturns() PASSED (0.123s)
    // vs
    // OrderServiceFullContextTest > createOrder... PASSED (8.456s)  ← includes context startup
}
```

---

## 3. The `Scenario` API — Testing Event-Driven Flows

### 3.1 What the `Scenario` API Solves

Testing event-driven systems is notoriously difficult. When `OrderService.createOrder()` publishes `OrderPlacedEvent` and `InventoryService` handles it asynchronously, how do you assert the end result in a test?

Without `Scenario`:
```java
// PROBLEM: async event handling — race condition
@Test
void createOrder_reservesInventory() throws InterruptedException {
    orderService.createOrder(req);

    Thread.sleep(500);  // wait for async handler — FRAGILE!
    // Race condition: 500ms might not be enough on slow CI

    verify(inventoryService).reserve(any(), any());
    // Or: assertThat(inventoryRepository.findReservation(orderId)).isPresent()
}
```

With `Scenario` — no `Thread.sleep()`, no race conditions:
```java
@Test
void createOrder_reservesInventory(Scenario scenario) {
    scenario
        .stimulate(() -> orderService.createOrder(req))
        .andWaitForEventOfType(InventoryReservedEvent.class)
        .toArrive();
    // Spring Modulith blocks until the event arrives or times out
    // Clean, deterministic, no Thread.sleep()
}
```

### 3.2 `Scenario` — Injection and Setup

```java
@ApplicationModuleTest
class OrderModuleScenarioTest {

    // Scenario is injected by Spring Modulith's test infrastructure
    // It's a method parameter — inject per test, not as a field
    @Test
    void myTest(Scenario scenario) {
        // use scenario
    }
}
```

### 3.3 `stimulate()` → `andWaitForEventOfType()` — The Full Flow

```java
@ApplicationModuleTest
class OrderFlowTest {

    @Autowired
    private OrderService orderService;

    @Test
    void placingOrder_triggersInventoryReservation(Scenario scenario) {

        CreateOrderRequest request = new CreateOrderRequest(
            userId: 1L,
            productIds: List.of(10L, 20L),
            shippingAddress: "123 Main St"
        );

        // Stimulate: execute the action that publishes the event
        // andWaitForEventOfType: block until this event type is received
        // toArrive(): assert the event DID arrive (throws if not received within timeout)
        scenario
            .stimulate(() -> orderService.createOrder(request))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArrive();
    }

    @Test
    void placingOrder_triggersInventoryReservation_withAssertion(Scenario scenario) {

        scenario
            .stimulate(() -> orderService.createOrder(request()))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArriveAndVerify(event -> {
                // Assert on the CONTENT of the received event
                assertThat(event.orderId()).isNotNull();
                assertThat(event.productIds()).containsExactlyInAnyOrder(10L, 20L);
                assertThat(event.status()).isEqualTo(ReservationStatus.CONFIRMED);
            });
    }
}
```

### 3.4 Publishing an Event as the Stimulus

Instead of calling a service method, you can publish an event directly as the stimulus:

```java
@ApplicationModuleTest
class InventoryModuleTest {

    @Test
    void whenOrderPlaced_inventoryIsReserved(Scenario scenario) {
        // Publish the event directly (simulating the order module publishing it)
        // and wait for the downstream effect
        scenario
            .publish(new OrderPlacedEvent(orderId: 42L, productIds: List.of(10L, 20L)))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArriveAndVerify(event ->
                assertThat(event.orderId()).isEqualTo(42L)
            );
    }

    @Test
    void whenOrderCancelled_inventoryIsReleased(Scenario scenario) {
        // First: create a reservation
        scenario
            .publish(new OrderPlacedEvent(42L, List.of(10L)))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArrive();

        // Then: cancel the order and verify reservation is released
        scenario
            .publish(new OrderCancelledEvent(42L, "Customer request"))
            .andWaitForEventOfType(InventoryReleasedEvent.class)
            .toArrive();
    }
}
```

### 3.5 `andWaitForStateChange()` — Assert Side Effects Without an Event

Not all downstream effects publish events. `andWaitForStateChange()` polls for a condition to become true:

```java
@ApplicationModuleTest
class NotificationModuleTest {

    @Autowired
    private NotificationRepository notificationRepository;

    @Test
    void whenOrderPlaced_notificationIsCreated(Scenario scenario) {
        scenario
            .publish(new OrderPlacedEvent(42L, 1L, List.of(10L), BigDecimal.TEN))
            .andWaitForStateChange(() ->
                // Poll this supplier until it returns non-null
                notificationRepository.findByOrderId(42L).orElse(null)
            )
            .andVerify(notification -> {
                assertThat(notification).isNotNull();
                assertThat(notification.getType()).isEqualTo(NotificationType.ORDER_CONFIRMATION);
                assertThat(notification.getStatus()).isEqualTo(NotificationStatus.SENT);
            });
    }
}
```

### 3.6 `Scenario` Timeout Configuration

```java
// Default timeout is 5 seconds
// Override per test:
scenario
    .publish(new SlowProcessingEvent())
    .andWaitForEventOfType(ProcessingCompleteEvent.class)
    .withTimeout(Duration.ofSeconds(30))  // longer for slow operations
    .toArrive();

// Or configure globally:
// application.properties (in test scope):
# spring.modulith.test.scenario-timeout=PT10S  (ISO-8601 duration: 10 seconds)
```

---

## 4. Testing a Module in Isolation — Mocking Other Modules

### 4.1 `STANDALONE` Mode — Full Isolation

```java
@ApplicationModuleTest(mode = BootstrapMode.STANDALONE)
class OrderServiceIsolatedTest {

    // order module's real beans ARE loaded
    @Autowired
    private OrderService orderService;

    // Other modules are NOT loaded — must mock them
    @MockitoBean
    private InventoryService inventoryService;    // mock the inventory public API

    @MockitoBean
    private UserService userService;             // mock the user public API

    @Test
    void createOrder_checksInventory() {
        // Arrange: mock responses
        when(inventoryService.checkAvailability(List.of(10L, 20L)))
            .thenReturn(true);
        when(userService.getProfile(1L))
            .thenReturn(new UserProfile(1L, "alice", "alice@example.com"));

        // Act
        Order order = orderService.createOrder(
            new CreateOrderRequest(1L, List.of(10L, 20L)));

        // Assert
        assertThat(order.getStatus()).isEqualTo(OrderStatus.PENDING);
        verify(inventoryService).checkAvailability(List.of(10L, 20L));
    }

    @Test
    void createOrder_whenInventoryUnavailable_throws() {
        when(inventoryService.checkAvailability(any()))
            .thenReturn(false);  // simulate out-of-stock

        assertThatThrownBy(() ->
            orderService.createOrder(new CreateOrderRequest(1L, List.of(99L))))
            .isInstanceOf(InsufficientInventoryException.class);
    }
}
```

### 4.2 Mocking Specific Dependencies in `DIRECT_DEPENDENCIES` Mode

Sometimes you want real collaborators for most dependencies but a mock for one:

```java
@ApplicationModuleTest  // DIRECT_DEPENDENCIES mode — loads real inventory and user beans
class OrderServiceTest {

    @Autowired
    private OrderService orderService;

    // Replace the real payment gateway with a mock (it would call an external API)
    @MockitoBean
    private PaymentGatewayClient paymentGatewayClient;

    @Test
    void createOrder_chargesPaymentGateway() {
        when(paymentGatewayClient.charge(any(), any()))
            .thenReturn(PaymentResult.success("charge-123"));

        orderService.createOrder(new CreateOrderRequest(1L, List.of(10L)));

        verify(paymentGatewayClient).charge(
            argThat(charge -> charge.userId().equals(1L)),
            argThat(amount -> amount.compareTo(BigDecimal.ZERO) > 0)
        );
    }
}
```

### 4.3 Custom Module Configuration for Tests

```java
// Provide test-specific beans to replace real implementations
@ApplicationModuleTest
@Import(OrderTestConfig.class)  // import test-specific configuration
class OrderServiceTest {

    @Configuration
    static class OrderTestConfig {

        // Replace real email sender with a no-op for tests
        @Bean
        @Primary  // overrides the real bean
        EmailSender testEmailSender() {
            return (to, subject, body) -> {
                // no-op: don't actually send emails in tests
                log.info("TEST: Would send email to {} with subject: {}", to, subject);
            };
        }
    }
}
```

### 4.4 Testing the Module's Repository Layer

```java
@ApplicationModuleTest
class OrderRepositoryTest {

    @Autowired
    private OrderRepository orderRepository;

    // @ApplicationModuleTest includes JPA/DataSource infrastructure
    // Use @Transactional to rollback test data after each test

    @Test
    @Transactional
    void save_and_find() {
        OrderEntity entity = new OrderEntity(1L, BigDecimal.TEN, OrderStatus.PENDING);
        OrderEntity saved = orderRepository.save(entity);

        assertThat(saved.getId()).isNotNull();

        Optional<OrderEntity> found = orderRepository.findById(saved.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getStatus()).isEqualTo(OrderStatus.PENDING);
    }

    @Test
    @Transactional
    void findByStatus_returnsMatchingOrders() {
        orderRepository.save(new OrderEntity(1L, BigDecimal.TEN, OrderStatus.PENDING));
        orderRepository.save(new OrderEntity(2L, BigDecimal.ONE, OrderStatus.PENDING));
        orderRepository.save(new OrderEntity(3L, BigDecimal.TEN, OrderStatus.SHIPPED));

        List<OrderEntity> pending = orderRepository.findByStatus(OrderStatus.PENDING);
        assertThat(pending).hasSize(2);
    }
}
```

---

## 5. Verifying Event Publication

### 5.1 `ApplicationEvents` — Captured Event Assertions

Spring Modulith provides `ApplicationEvents` as an injectable test component that captures all events published during a test:

```java
@ApplicationModuleTest
class OrderEventPublicationTest {

    @Autowired
    private OrderService orderService;

    @Test
    void createOrder_publishesOrderPlacedEvent(ApplicationEvents events) {
        // Act
        orderService.createOrder(new CreateOrderRequest(1L, List.of(10L, 20L)));

        // Assert: was an OrderPlacedEvent published?
        assertThat(events.ofType(OrderPlacedEvent.class))
            .hasSize(1);
    }

    @Test
    void createOrder_publishedEventHasCorrectData(ApplicationEvents events) {
        CreateOrderRequest req = new CreateOrderRequest(1L, List.of(10L, 20L));

        orderService.createOrder(req);

        // Get the published event and assert its content
        OrderPlacedEvent published = events.ofType(OrderPlacedEvent.class)
            .findFirst()
            .orElseThrow(() -> new AssertionError("Expected OrderPlacedEvent to be published"));

        assertThat(published.userId()).isEqualTo(1L);
        assertThat(published.productIds()).containsExactlyInAnyOrder(10L, 20L);
        assertThat(published.total()).isGreaterThan(BigDecimal.ZERO);
        assertThat(published.occurredAt()).isNotNull();
    }

    @Test
    void cancelOrder_publishesOrderCancelledEvent(ApplicationEvents events) {
        // Setup: create an order first
        Order order = orderService.createOrder(new CreateOrderRequest(1L, List.of(10L)));
        events.clear();  // clear the OrderPlacedEvent from setup

        // Act
        orderService.cancelOrder(order.getId(), "Customer request");

        // Assert: OrderCancelledEvent was published, OrderPlacedEvent was NOT
        assertThat(events.ofType(OrderCancelledEvent.class)).hasSize(1);
        assertThat(events.ofType(OrderPlacedEvent.class)).isEmpty();

        OrderCancelledEvent cancelled = events.ofType(OrderCancelledEvent.class).findFirst().get();
        assertThat(cancelled.orderId()).isEqualTo(order.getId());
        assertThat(cancelled.reason()).isEqualTo("Customer request");
    }

    @Test
    void createOrder_publishesExactlyOneEvent(ApplicationEvents events) {
        orderService.createOrder(new CreateOrderRequest(1L, List.of(10L)));
        orderService.createOrder(new CreateOrderRequest(1L, List.of(20L)));

        // Assert: exactly 2 events for 2 orders
        assertThat(events.ofType(OrderPlacedEvent.class)).hasSize(2);
    }
}
```

### 5.2 `scenario.forPublication()` — Asserting the Event Publication Registry

`scenario.forPublication()` verifies that an event was written to the **event publication registry** (the outbox table), not just dispatched in-memory:

```java
@ApplicationModuleTest
class OrderPublicationRegistryTest {

    @Autowired
    private OrderService orderService;

    @Test
    void createOrder_persistsEventToPublicationRegistry(Scenario scenario) {
        // forPublication: verifies the event is in the persistent outbox
        // (requires spring-modulith-events-jpa or -jdbc)
        scenario
            .stimulate(() -> orderService.createOrder(testRequest()))
            .andWaitForEventOfType(OrderPlacedEvent.class)
            .toArrive();

        // Alternatively, verify the publication was completed:
        // (event was processed, not just published)
    }

    @Test
    void eventIsMarkedCompleteAfterHandling(Scenario scenario) {
        scenario
            .publish(new OrderPlacedEvent(42L, 1L, List.of(10L), BigDecimal.TEN))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArrive();

        // At this point, the OrderPlacedEvent publication should be COMPLETE in the DB
        // (inventory handler ran and marked it complete)
    }
}
```

### 5.3 Combining `ApplicationEvents` with `Scenario`

```java
@ApplicationModuleTest
class FullFlowTest {

    @Test
    void orderCreation_triggersCompleteFlow(Scenario scenario, ApplicationEvents applicationEvents) {

        // Stimulate the flow
        scenario
            .stimulate(() -> orderService.createOrder(testRequest()))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArrive();

        // Also verify which events were published (using ApplicationEvents)
        assertThat(applicationEvents.ofType(OrderPlacedEvent.class)).hasSize(1);
        assertThat(applicationEvents.ofType(InventoryReservedEvent.class)).hasSize(1);

        // Verify NO unexpected events were published
        assertThat(applicationEvents.ofType(PaymentProcessedEvent.class)).isEmpty();
    }
}
```

### 5.4 Asserting No Event Was Published

```java
@Test
void createOrder_whenAlreadyExists_doesNotPublishDuplicate(ApplicationEvents events) {
    // Create the first order — publishes event
    orderService.createOrder(new CreateOrderRequest(1L, List.of(10L)));
    events.clear();  // Reset after setup

    // Try to create duplicate
    assertThatThrownBy(() ->
        orderService.createOrder(new CreateOrderRequest(1L, List.of(10L))))
        .isInstanceOf(DuplicateOrderException.class);

    // Assert: NO event published when order creation fails
    assertThat(events.ofType(OrderPlacedEvent.class)).isEmpty();
}
```

---

## 6. Advanced Scenario Patterns

### 6.1 Multi-Step Scenarios

```java
@ApplicationModuleTest
class OrderLifecycleTest {

    @Test
    void orderLifecycle_placeShipDeliver(Scenario scenario) {

        // Step 1: Place order — wait for inventory reservation
        scenario
            .stimulate(() -> orderService.createOrder(testRequest()))
            .andWaitForEventOfType(InventoryReservedEvent.class)
            .toArriveAndVerify(event ->
                assertThat(event.status()).isEqualTo(ReservationStatus.CONFIRMED));

        Long orderId = getLastCreatedOrderId();

        // Step 2: Ship the order — wait for shipping notification
        scenario
            .stimulate(() -> orderService.shipOrder(orderId, "TRACK-123"))
            .andWaitForEventOfType(OrderShippedEvent.class)
            .toArriveAndVerify(event ->
                assertThat(event.trackingNumber()).isEqualTo("TRACK-123"));

        // Step 3: Deliver — wait for loyalty points event
        scenario
            .stimulate(() -> orderService.confirmDelivery(orderId))
            .andWaitForEventOfType(LoyaltyPointsAwardedEvent.class)
            .toArrive();
    }
}
```

### 6.2 Testing Event Handler Failures and Retries

```java
@ApplicationModuleTest
class EventHandlerFailureTest {

    @MockitoBean
    private ExternalPaymentGateway paymentGateway;

    @Test
    void whenPaymentGatewayFails_orderEventStaysIncomplete(Scenario scenario) {
        // Simulate payment gateway failure
        when(paymentGateway.charge(any(), any()))
            .thenThrow(new PaymentGatewayException("Service unavailable"));

        // The listener will fail, but the order should still be saved
        assertThatCode(() ->
            scenario
                .stimulate(() -> orderService.createOrder(testRequest()))
                .andWaitForEventOfType(OrderPlacedEvent.class)
                .toArrive()
        ).doesNotThrowAnyException();

        // The event publication for the payment handler should be INCOMPLETE
        // (will be retried on next startup)
        assertThat(incompletePublications.findIncompletePublications())
            .anyMatch(pub -> pub.getEventType().contains("OrderPlacedEvent"));
    }
}
```

### 6.3 `@RecordApplicationEvents` — Simpler Alternative to `ApplicationEvents`

```java
// @RecordApplicationEvents automatically records all events in the test
@ApplicationModuleTest
@RecordApplicationEvents  // enables ApplicationEvents injection
class OrderEventRecordingTest {

    @Autowired
    ApplicationEvents events;  // field injection (instead of method param)

    @Test
    void createOrder_recordsEvents() {
        orderService.createOrder(testRequest());

        assertThat(events.ofType(OrderPlacedEvent.class)).hasSize(1);
    }
}
```

### 6.4 Full Module Test Suite Structure

```java
// Recommended structure: one test class per concern

// 1. Unit-like tests for business logic (fastest)
@ApplicationModuleTest(mode = BootstrapMode.STANDALONE)
class OrderBusinessRulesTest {
    @MockitoBean InventoryService inventory;
    @MockitoBean UserService user;

    @Test void orderCannotExceedCreditLimit() { ... }
    @Test void orderRequiresPositiveQuantity() { ... }
}

// 2. Integration tests with real dependencies
@ApplicationModuleTest  // DIRECT_DEPENDENCIES
class OrderServiceIntegrationTest {
    @Test void createOrder_persistsToDatabase() { ... }
    @Test void createOrder_checksRealInventory() { ... }
}

// 3. Event-driven flow tests
@ApplicationModuleTest
class OrderEventFlowTest {
    @Test void createOrder_publishesEvent(Scenario s) { ... }
    @Test void createOrder_triggersInventoryReservation(Scenario s) { ... }
}

// 4. Event publication tests
@ApplicationModuleTest
class OrderEventPublicationTest {
    @Test void createOrder_writesEventToOutbox(ApplicationEvents e) { ... }
    @Test void cancelOrder_publishesCancelledEvent(ApplicationEvents e) { ... }
}
```

---

## 7. Quick Reference Cheat Sheet

### `@ApplicationModuleTest` Bootstrap Modes

```java
// STANDALONE: only the module itself, mock all deps
@ApplicationModuleTest(mode = BootstrapMode.STANDALONE)

// DIRECT_DEPENDENCIES (default): module + its declared dependencies
@ApplicationModuleTest

// ALL_DEPENDENCIES: module + full transitive dependency tree
@ApplicationModuleTest(mode = BootstrapMode.ALL_DEPENDENCIES)
```

### `Scenario` API

```java
// Stimulate via method call, wait for event
scenario.stimulate(() -> service.doSomething(req))
        .andWaitForEventOfType(SomeEvent.class)
        .toArrive();

// Stimulate via method call, wait for event, assert event content
scenario.stimulate(() -> service.doSomething(req))
        .andWaitForEventOfType(SomeEvent.class)
        .toArriveAndVerify(event -> assertThat(event.field()).isEqualTo("expected"));

// Publish event as stimulus
scenario.publish(new OrderPlacedEvent(42L, ...))
        .andWaitForEventOfType(InventoryReservedEvent.class)
        .toArrive();

// Wait for state change instead of event
scenario.stimulate(() -> service.doSomething())
        .andWaitForStateChange(() -> repository.findById(id).orElse(null))
        .andVerify(result -> assertThat(result).isNotNull());

// Custom timeout
scenario.stimulate(...)
        .andWaitForEventOfType(SlowEvent.class)
        .withTimeout(Duration.ofSeconds(30))
        .toArrive();
```

### `ApplicationEvents` Assertions

```java
// Inject as method parameter (or field with @RecordApplicationEvents)
void myTest(ApplicationEvents events) {

    service.doAction();

    // Assert event was published
    assertThat(events.ofType(MyEvent.class)).hasSize(1);

    // Assert event content
    MyEvent event = events.ofType(MyEvent.class).findFirst().orElseThrow();
    assertThat(event.field()).isEqualTo("expected");

    // Assert no event published
    assertThat(events.ofType(UnexpectedEvent.class)).isEmpty();

    // Clear events between steps
    events.clear();
}
```

### Mocking Other Modules

```java
@ApplicationModuleTest(mode = BootstrapMode.STANDALONE)
class IsolatedTest {
    @MockitoBean   // replaces the real bean
    private InventoryService inventoryService;

    @Test
    void test() {
        when(inventoryService.checkAvailability(any())).thenReturn(true);
        // ...
        verify(inventoryService).checkAvailability(List.of(10L));
    }
}
```

### Key Rules to Remember

1. **`@ApplicationModuleTest` infers the module from test class package** — place tests in `com.myapp.order` to test the order module.
2. **Default mode is `DIRECT_DEPENDENCIES`** — loads the module + everything it directly depends on.
3. **`Scenario` eliminates `Thread.sleep()` in async tests** — it blocks deterministically until the expected event arrives or times out.
4. **`scenario.publish()` simulates an incoming event** — tests the module's listener behavior without needing the publishing module.
5. **`scenario.stimulate()` tests the full flow** — call a service method and verify downstream events.
6. **`ApplicationEvents` captures all events in the test thread** — use `events.clear()` between steps to reset.
7. **`STANDALONE` mode requires `@MockitoBean` for all dependencies** — nothing else is in the context.
8. **Context is cached per module** — 10 test classes for the same module share one context startup.
9. **`andWaitForStateChange()` polls a supplier** — useful when the downstream effect doesn't publish an event.
10. **Default `Scenario` timeout is 5 seconds** — override with `.withTimeout(Duration.ofSeconds(N))` for slow operations.

---

*End of Integration Testing Modules Study Guide — Module 5*
