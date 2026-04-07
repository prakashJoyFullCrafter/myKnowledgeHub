# Spring Modulith: Application Events for Module Communication — Complete Study Guide

> **Module 4 | Brutally Detailed Reference**
> Covers why events beat direct calls, `ApplicationEventPublisher`, `@ApplicationModuleListener`, async and transactional listeners, the event publication registry for reliability, event replay on restart, and `@Externalized` for Kafka/RabbitMQ/SQS forwarding. Full working examples throughout.

---

## Table of Contents

1. [Why Events, Not Direct Method Calls](#1-why-events-not-direct-method-calls)
2. [`ApplicationEventPublisher` — Publishing Domain Events](#2-applicationeventpublisher--publishing-domain-events)
3. [`@ApplicationModuleListener` — Handling Module Events](#3-applicationmodulelistener--handling-module-events)
4. [`@Async` Event Listeners](#4-async-event-listeners)
5. [`@TransactionalEventListener` — Fire After Commit](#5-transactionaleventlistener--fire-after-commit)
6. [Event Publication Registry — Reliability](#6-event-publication-registry--reliability)
7. [Persisting Events — JPA and JDBC Backends](#7-persisting-events--jpa-and-jdbc-backends)
8. [Re-publishing Incomplete Events on Restart](#8-re-publishing-incomplete-events-on-restart)
9. [Event Externalization — Kafka, RabbitMQ, SQS](#9-event-externalization--kafka-rabbitmq-sqs)
10. [`@Externalized` — Automatic Event Forwarding](#10-externalized--automatic-event-forwarding)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. Why Events, Not Direct Method Calls

### 1.1 The Problem with Direct Calls Between Modules

When modules communicate via direct method calls, the calling module **must know about** the receiving module. This creates coupling:

```java
// PROBLEM: OrderService directly calling other modules
@Service
class OrderServiceImpl implements OrderService {

    // OrderService depends on 4 other modules directly
    private final InventoryService inventoryService;     // order → inventory
    private final NotificationService notificationService; // order → notification
    private final LoyaltyService loyaltyService;          // order → loyalty
    private final AnalyticsService analyticsService;      // order → analytics

    public Order createOrder(CreateOrderRequest req) {
        Order order = save(req);

        // Order must orchestrate all side effects:
        inventoryService.reserve(req.productIds());        // changes other module's state
        notificationService.sendConfirmation(order);       // couples to notification logic
        loyaltyService.awardPoints(req.userId(), order);   // couples to loyalty logic
        analyticsService.trackPurchase(order);             // couples to analytics logic

        return order;
    }
}
```

**What's wrong:**
```
1. Dependency graph: order → inventory, notification, loyalty, analytics
   Adding a 5th side effect means changing OrderService

2. Testing OrderService requires mocking all 4 dependencies
   Even though OrderService's core logic doesn't use them

3. allowedDependencies in @ApplicationModule must list all 4 modules
   Any new feature adding a side effect requires updating @ApplicationModule

4. Ordering matters: what if notification should fire BEFORE loyalty?
   Now you're building an orchestration layer in the wrong place

5. If loyaltyService.awardPoints() throws, does the order get saved?
   If the order is already in DB, does rolling back notification work?
   Transaction management becomes complex

6. "I just need to add order tracking" requires changing OrderService
   → Every new feature touches the same class
```

### 1.2 The Event-Driven Solution

```java
// SOLUTION: OrderService publishes ONE event, other modules react
@Service
class OrderServiceImpl implements OrderService {

    private final ApplicationEventPublisher events;
    // No dependency on notification, loyalty, analytics, or shipping!

    public Order createOrder(CreateOrderRequest req) {
        Order order = save(req);

        // Publish ONE event — don't know who handles it, don't care
        events.publishEvent(new OrderPlacedEvent(
            order.getId(),
            req.getUserId(),
            req.getProductIds(),
            order.getTotal()
        ));

        return order;
    }
}

// Each module handles the event INDEPENDENTLY
// Adding a new side effect = new listener, ZERO changes to OrderService

@Component
class InventoryEventHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent e) { inventoryService.reserve(e.productIds()); }
}

@Component
class NotificationEventHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent e) { emailService.sendConfirmation(e.orderId()); }
}

@Component
class LoyaltyEventHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent e) { loyaltyService.awardPoints(e.userId(), e.total()); }
}

// New requirement: add order tracking — ZERO changes to order module
@Component
class TrackingEventHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent e) { trackingService.initializeTracking(e.orderId()); }
}
```

### 1.3 Dependency Direction Comparison

```
Direct calls:               Event-driven:
─────────────────           ─────────────────────────
order → inventory           order (publishes OrderPlacedEvent)
order → notification              ↑
order → loyalty             inventory (subscribes)
order → analytics           notification (subscribes)
order → shipping            loyalty (subscribes)
                            analytics (subscribes)
                            shipping (subscribes)

Direct calls: 5 outgoing dependencies from order module
Events: 0 outgoing dependencies from order module
        Each subscriber depends on the event TYPE only
        Adding new subscribers: 0 changes to order module
```

### 1.4 The Rule

```
Rule: Modules should not call each other's services directly.
      They should publish events and let interested modules react.

Exception: read operations (queries) often need direct calls
  e.g., OrderService calls UserService.getProfile() to read user data before creating order
  Read queries are OK as direct calls — they don't trigger side effects in other modules
  Write side effects should be event-driven
```

---

## 2. `ApplicationEventPublisher` — Publishing Domain Events

### 2.1 Defining Domain Events

Domain events are simple, immutable value objects describing something that happened:

```java
// Domain event: something that HAPPENED in the order module
// Published in: com.myapp.order (root package = public API)

public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total,
    Instant occurredAt
) {
    // Static factory — sets timestamp automatically
    public static OrderPlacedEvent of(Long orderId, Long userId,
                                       List<Long> productIds, BigDecimal total) {
        return new OrderPlacedEvent(orderId, userId,
            List.copyOf(productIds), total, Instant.now());
    }
}

public record OrderCancelledEvent(
    Long orderId,
    String reason,
    Instant occurredAt
) {}

public record OrderShippedEvent(
    Long orderId,
    String trackingNumber,
    Instant shippedAt
) {}
```

**Naming convention:** past tense — something that already happened:
```
✅ OrderPlacedEvent     (not: PlaceOrderEvent or OrderPlaceCommand)
✅ UserRegisteredEvent  (not: RegisterUserEvent)
✅ PaymentProcessedEvent
✅ InventoryReservedEvent
```

### 2.2 Publishing Events

```java
@Service
class OrderServiceImpl implements OrderService {

    private final OrderRepository repository;
    private final ApplicationEventPublisher events;

    // Method 1: Inject ApplicationEventPublisher (most common)
    @Override
    @Transactional
    public Order createOrder(CreateOrderRequest req) {
        Order order = repository.save(new Order(req));

        // Publish WITHIN the transaction (before commit)
        // With @TransactionalEventListener(AFTER_COMMIT): fires after commit
        // With @ApplicationModuleListener: fires after commit by default
        events.publishEvent(OrderPlacedEvent.of(
            order.getId(), req.getUserId(), req.getProductIds(), order.getTotal()));

        return order;
    }
}
```

### 2.3 Using `ApplicationEvents` in `@ApplicationModuleTest`

```java
// In tests, ApplicationEvents can capture published events for assertion
@ApplicationModuleTest
class OrderModuleTest {

    @Autowired
    private OrderService orderService;

    @Test
    void createOrder_publishesOrderPlacedEvent(ApplicationEvents events) {
        // act
        orderService.createOrder(new CreateOrderRequest(1L, List.of(10L, 20L)));

        // assert: event was published
        assertThat(events.ofType(OrderPlacedEvent.class)).hasSize(1);

        OrderPlacedEvent published = events.ofType(OrderPlacedEvent.class).findFirst().get();
        assertThat(published.userId()).isEqualTo(1L);
        assertThat(published.productIds()).containsExactly(10L, 20L);
    }
}
```

---

## 3. `@ApplicationModuleListener` — Handling Module Events

### 3.1 What `@ApplicationModuleListener` Is

`@ApplicationModuleListener` is Spring Modulith's purpose-built annotation for cross-module event handling. It is a composed annotation that combines:

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Async("applicationModuleEventMulticaster")  // runs in dedicated thread pool
@Transactional(propagation = Propagation.REQUIRES_NEW) // new transaction per listener
@TransactionalEventListener                  // fires after the publisher's TX commits
public @interface ApplicationModuleListener {
    Phase phase() default Phase.AFTER_COMMIT;
}
```

So `@ApplicationModuleListener` gives you all of this automatically:
- **Runs after the publishing transaction commits** (no risk of reacting to a rolled-back event)
- **Runs in a separate transaction** (listener failure doesn't roll back the publisher)
- **Runs asynchronously** (publisher doesn't wait for listeners to finish)

### 3.2 Basic Usage

```java
// Notification module listens to Order module events
@Component
class OrderNotificationHandler {

    private final EmailService emailService;

    @ApplicationModuleListener
    void on(OrderPlacedEvent event) {
        emailService.sendOrderConfirmation(event.orderId(), event.userId());
    }

    @ApplicationModuleListener
    void on(OrderShippedEvent event) {
        emailService.sendShippingNotification(event.orderId(), event.trackingNumber());
    }

    @ApplicationModuleListener
    void on(OrderCancelledEvent event) {
        emailService.sendCancellationNotice(event.orderId(), event.reason());
    }
}

// Inventory module listens to Order module events
@Component
class OrderInventoryHandler {

    private final InventoryService inventoryService;

    @ApplicationModuleListener
    void on(OrderPlacedEvent event) {
        // Reserve inventory for the placed order
        inventoryService.reserve(event.orderId(), event.productIds());
    }

    @ApplicationModuleListener
    void on(OrderCancelledEvent event) {
        // Release reserved inventory when order is cancelled
        inventoryService.releaseReservation(event.orderId());
    }
}
```

### 3.3 `@ApplicationModuleListener` Transaction Behavior

```
Publisher transaction commits:
  BEGIN TRANSACTION
    order = repository.save(new Order(...))
    events.publishEvent(new OrderPlacedEvent(...))
  COMMIT   ← @ApplicationModuleListener fires HERE (after commit)

  After commit, in a NEW transaction:
    BEGIN TRANSACTION (new)
      inventoryHandler.on(OrderPlacedEvent)
      inventoryService.reserve(...)
    COMMIT (independent of order's transaction)

Why this matters:
  If inventory reservation fails → inventory transaction rolls back
  Order transaction is already committed → order is NOT rolled back
  This is "eventual consistency" — use event publication registry for reliability (Section 6)
```

---

## 4. `@Async` Event Listeners

### 4.1 When to Use `@Async` Separately

`@ApplicationModuleListener` already runs asynchronously via its built-in `@Async`. But if you're using plain Spring `@EventListener`, you need explicit `@Async`:

```java
// Standard Spring @EventListener — synchronous by default (runs in publisher's thread)
@Component
class SyncHandler {
    @EventListener
    void on(OrderPlacedEvent event) {
        // Runs in the SAME thread as the publisher
        // Publisher WAITS for this to complete
        heavyProcessing(event);  // this blocks the publisher!
    }
}

// Add @Async to make it non-blocking
@Component
class AsyncHandler {
    @Async  // runs in a separate thread pool
    @EventListener
    void on(OrderPlacedEvent event) {
        // Publisher does NOT wait — returns immediately
        heavyProcessing(event);
    }
}
```

### 4.2 Async Configuration

```java
@Configuration
@EnableAsync
public class AsyncConfig implements AsyncConfigurer {

    @Override
    @Bean(name = "applicationModuleEventMulticaster")
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(4);
        executor.setMaxPoolSize(16);
        executor.setQueueCapacity(500);
        executor.setThreadNamePrefix("module-event-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }

    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return (throwable, method, params) -> {
            log.error("Async event handler exception in {}.{}(): {}",
                method.getDeclaringClass().getSimpleName(),
                method.getName(),
                throwable.getMessage(),
                throwable);
        };
    }
}
```

### 4.3 Thread Safety with `@Async`

```java
// CAUTION: @Async runs in a DIFFERENT thread
// The SecurityContext and request-scoped beans are NOT automatically available

@Async
@EventListener
void on(OrderPlacedEvent event) {
    // SecurityContextHolder.getContext() may be empty here!
    // HttpServletRequest is not available here!

    // If you need the user identity: include it in the event:
    // event.userId() — propagate via event, not via thread-local
}

// Spring Security provides DelegatingSecurityContextExecutor for propagation
// if you need the security context in async listeners
```

---

## 5. `@TransactionalEventListener` — Fire After Commit

### 5.1 Why Fire After Commit?

Without `@TransactionalEventListener`, an event fires **within** the publisher's transaction — which means the listener might react to an event from a transaction that later gets rolled back:

```
Without AFTER_COMMIT:
  BEGIN TRANSACTION
    order = repository.save(new Order(...))  ← order in DB (not yet committed)
    events.publishEvent(new OrderPlacedEvent(...))
    → NotificationHandler.on(event) fires NOW ← email sent to customer
    throw new RuntimeException("something went wrong")
  ROLLBACK  ← order NEVER committed
  
  Customer received an email for an order that doesn't exist in the DB!

With AFTER_COMMIT:
  BEGIN TRANSACTION
    order = repository.save(new Order(...))
    events.publishEvent(new OrderPlacedEvent(...))
  COMMIT  ← only NOW does the listener fire
  → NotificationHandler.on(event) fires  ← email sent AFTER successful commit
  
  Email only sent when the order is really in the database.
```

### 5.2 All Transaction Phases

```java
// Phase 1: BEFORE_COMMIT (rare) — runs just before TX commits
@TransactionalEventListener(phase = TransactionPhase.BEFORE_COMMIT)
void beforeCommit(OrderPlacedEvent event) {
    // Still inside the publisher's transaction
    // Useful: last-chance validation before commit
    // CAUTION: exceptions here will roll back the publisher's TX
}

// Phase 2: AFTER_COMMIT (default, most common) — runs after TX commits
@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
void afterCommit(OrderPlacedEvent event) {
    // Publisher's TX is committed — order is in DB
    // Safe to send emails, call external APIs, etc.
    // Failure here does NOT roll back the order
}

// Phase 3: AFTER_ROLLBACK — runs when TX rolls back
@TransactionalEventListener(phase = TransactionPhase.AFTER_ROLLBACK)
void afterRollback(OrderPlacedEvent event) {
    // Publisher's TX rolled back — order was NOT saved
    // Useful: compensating actions, alerting, cleanup
}

// Phase 4: AFTER_COMPLETION — runs after TX either commits OR rolls back
@TransactionalEventListener(phase = TransactionPhase.AFTER_COMPLETION)
void afterCompletion(OrderPlacedEvent event) {
    // Fires regardless of commit/rollback
    // Useful: audit logging, metrics, cleanup
}
```

### 5.3 `@TransactionalEventListener` vs `@ApplicationModuleListener`

```java
// PREFER @ApplicationModuleListener for cross-module events:
@ApplicationModuleListener
void on(OrderPlacedEvent event) { ... }
// Automatically: AFTER_COMMIT + REQUIRES_NEW tx + Async

// USE @TransactionalEventListener when you need control:
@Async
@Transactional(propagation = Propagation.REQUIRES_NEW)
@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
void on(OrderPlacedEvent event) { ... }
// This is what @ApplicationModuleListener expands to

// USE plain @EventListener only for:
// - Synchronous same-module events (no cross-module)
// - Events that don't need transaction awareness
// - Application lifecycle events (ContextRefreshedEvent, etc.)
@EventListener
void onContextReady(ContextRefreshedEvent event) { ... }
```

---

## 6. Event Publication Registry — Reliability

### 6.1 The Reliability Problem

Even with `@ApplicationModuleListener` (AFTER_COMMIT + new TX), there's a reliability gap:

```
Timeline of a potential failure:

1. OrderService transaction COMMITS
2. OrderPlacedEvent is dispatched to listeners
3. JVM CRASHES (power failure, OOM, deployment restart)
4. InventoryHandler.on() NEVER ran
5. NotificationHandler.on() NEVER ran

Result: Order is in DB but:
  - Inventory was never reserved (oversell risk)
  - Customer never received confirmation email

Without the Event Publication Registry:
  → These events are LOST
  → Manual intervention required
  → No way to know which events weren't processed
```

### 6.2 The Event Publication Registry Solution

Spring Modulith's event publication registry solves this with a simple mechanism:

```
With Event Publication Registry:

1. BEFORE dispatching listeners:
   → Write event to publication log table: {eventType, serializedEvent, status=INCOMPLETE, publishedAt}
   → This write is part of the PUBLISHER's transaction — atomic with the domain change

2. Dispatch event to all listeners asynchronously

3. After each listener completes successfully:
   → Mark publication as COMPLETE in the log

4. On application restart:
   → Find all INCOMPLETE publications in the log
   → Re-publish them — listeners run again

Result: at-least-once delivery guarantee
  Every event will be processed by every listener, eventually.
```

```
Database state during processing:

event_publication table:
  id | listener_id                    | event_type         | serialized_event | publication_date        | completion_date
  1  | com.myapp.notification...on()  | OrderPlacedEvent   | {...}            | 2024-01-15T10:30:00Z   | NULL        ← INCOMPLETE
  2  | com.myapp.inventory...on()     | OrderPlacedEvent   | {...}            | 2024-01-15T10:30:00Z   | NULL        ← INCOMPLETE
  
After notification listener completes:
  1  | com.myapp.notification...on()  | OrderPlacedEvent   | {...}            | 2024-01-15T10:30:00Z   | 2024-01-15T10:30:01Z ← COMPLETE

After inventory listener completes:
  2  | com.myapp.inventory...on()     | OrderPlacedEvent   | {...}            | 2024-01-15T10:30:00Z   | 2024-01-15T10:30:01Z ← COMPLETE
```

---

## 7. Persisting Events — JPA and JDBC Backends

### 7.1 Dependencies

```xml
<!-- Event publication registry API (required) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-api</artifactId>
</dependency>

<!-- Option A: JPA backend (if you already use Spring Data JPA) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-jpa</artifactId>
</dependency>

<!-- Option B: JDBC backend (lighter — no JPA required) -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-jdbc</artifactId>
</dependency>

<!-- Option C: MongoDB backend -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-mongodb</artifactId>
</dependency>
```

### 7.2 Database Schema (Auto-Created)

```sql
-- Spring Modulith creates this table automatically
-- (via spring.modulith.events.jdbc.schema-initialization.enabled=true, default)

CREATE TABLE event_publication (
    id               UUID         PRIMARY KEY,
    listener_id      TEXT         NOT NULL,     -- fully-qualified listener method
    serialized_event TEXT         NOT NULL,     -- JSON-serialized event
    event_type       TEXT         NOT NULL,     -- fully-qualified event class name
    publication_date TIMESTAMPTZ  NOT NULL,     -- when published
    completion_date  TIMESTAMPTZ              -- NULL = INCOMPLETE, set when done
);

CREATE INDEX event_publication_completion_date
    ON event_publication (completion_date);  -- fast lookup of incomplete events
```

### 7.3 Configuration

```yaml
# application.yml
spring:
  modulith:
    events:
      jdbc:
        schema-initialization:
          enabled: true    # auto-create event_publication table
      republication-enabled: true  # re-publish incomplete events on startup (default: true)
```

```java
// That's it — no @Enable annotation needed.
// Adding spring-modulith-events-jpa to the classpath auto-configures everything.
// Events published via ApplicationEventPublisher are automatically persisted
// when listeners are marked with @ApplicationModuleListener.
```

### 7.4 How the Registry Integrates with Your Publisher

```java
// Your code doesn't change — the registry is transparent
@Service
class OrderServiceImpl implements OrderService {

    private final ApplicationEventPublisher events; // standard Spring interface

    @Transactional
    public Order createOrder(CreateOrderRequest req) {
        Order order = repository.save(new Order(req));

        // This call now triggers:
        // 1. Event persisted to event_publication table (INCOMPLETE)
        //    in the SAME transaction as the order save — atomic
        // 2. After TX commits: event dispatched to listeners asynchronously
        // 3. After each listener completes: publication marked COMPLETE
        events.publishEvent(OrderPlacedEvent.of(order.getId(), req.getUserId(), ...));

        return order;
    }
}
```

### 7.5 Monitoring the Publication Log

```java
@Service
public class EventPublicationMonitor {

    private final CompletedEventPublications completedPublications;
    private final IncompleteEventPublications incompletePublications;

    // Find all events that haven't been processed (potential failures)
    public List<TargetEventPublication> getIncompleteEvents() {
        return incompletePublications.findIncompletePublications();
    }

    // Find events stuck more than 1 hour (likely failed listeners)
    public List<TargetEventPublication> getStuckEvents() {
        return incompletePublications.findIncompletePublicationsPublishedBefore(
            Instant.now().minus(Duration.ofHours(1))
        );
    }

    // Delete completed events older than 7 days (routine cleanup)
    @Scheduled(cron = "0 0 2 * * *")  // 2am daily
    public void cleanupOldEvents() {
        completedPublications.deleteCompletedPublicationsBefore(
            Instant.now().minus(Duration.ofDays(7)));
        log.info("Cleaned up event publications older than 7 days");
    }
}
```

---

## 8. Re-publishing Incomplete Events on Restart

### 8.1 Automatic Republication

By default, Spring Modulith checks for incomplete event publications at startup and re-dispatches them:

```
Application restart sequence:
  1. Spring context starts
  2. Spring Modulith scans event_publication table
  3. Finds rows where completion_date IS NULL
  4. For each incomplete publication:
     a. Deserializes the event from serialized_event column
     b. Re-dispatches to the specific listener (listener_id column)
     c. Listener runs again (idempotency matters — see Section 8.3)
     d. On success: marks as complete
```

```yaml
spring:
  modulith:
    events:
      republication-enabled: true   # default: true
```

### 8.2 Manual Republication

```java
@Service
public class EventRepublicationService {

    private final IncompleteEventPublications incompletePublications;
    private final EventPublicationRegistry registry;

    // Manually trigger republication (e.g., from admin endpoint)
    public void republishAllIncomplete() {
        incompletePublications
            .findIncompletePublications()
            .forEach(registry::republish);
    }

    // Republish events that have been incomplete for more than N minutes
    public int republishStale(Duration olderThan) {
        List<TargetEventPublication> stale =
            incompletePublications.findIncompletePublicationsPublishedBefore(
                Instant.now().minus(olderThan));

        stale.forEach(registry::republish);
        return stale.size();
    }
}

// Admin REST endpoint:
@PostMapping("/admin/events/republish")
@PreAuthorize("hasRole('ADMIN')")
public ResponseEntity<Map<String, Integer>> republishEvents() {
    int count = republishService.republishStale(Duration.ofMinutes(5));
    return ResponseEntity.ok(Map.of("republished", count));
}
```

### 8.3 Idempotency — Critical for Reliable Re-publishing

Since events can be re-published (at-least-once delivery), **listeners MUST be idempotent** — running them twice must produce the same result as running them once:

```java
// NOT idempotent — running twice creates two reservations!
@ApplicationModuleListener
void on(OrderPlacedEvent event) {
    // If this runs twice: inventory reserved twice for same order
    inventoryService.reserve(event.orderId(), event.productIds()); // BAD
}

// IDEMPOTENT — check before acting
@ApplicationModuleListener
@Transactional(propagation = Propagation.REQUIRES_NEW)
void on(OrderPlacedEvent event) {
    // Check: has this already been processed?
    if (inventoryService.isAlreadyReserved(event.orderId())) {
        log.info("Inventory already reserved for order {}, skipping", event.orderId());
        return;
    }
    inventoryService.reserve(event.orderId(), event.productIds());
}

// IDEMPOTENT — upsert instead of insert
@ApplicationModuleListener
void on(OrderPlacedEvent event) {
    // Database upsert: INSERT ... ON CONFLICT DO NOTHING
    // Safe to call multiple times — second call is a no-op
    notificationRepository.upsertConfirmationStatus(
        event.orderId(), "SENT");
    emailService.sendIfNotAlreadySent(event.orderId(), event.userId());
}

// IDEMPOTENT — use event orderId as idempotency key
@ApplicationModuleListener
void on(OrderPlacedEvent event) {
    // Pass orderId as idempotency key to external service
    paymentGateway.chargeWithIdempotencyKey(
        "order-" + event.orderId(),     // idempotency key
        event.userId(),
        event.total()
    );
    // Payment gateway ignores duplicate calls with same key
}
```

---

## 9. Event Externalization — Kafka, RabbitMQ, SQS

### 9.1 What Event Externalization Does

As your modular monolith grows, some modules may eventually be extracted into separate services. Event externalization bridges this transition:

```
Modular Monolith (today):
  Order module → publishes OrderPlacedEvent → Inventory module handles it
  (in-process, no network)

Extracting Inventory to a microservice (tomorrow):
  Order module → publishes OrderPlacedEvent → Kafka topic → Inventory Service
  (via message broker)

With @Externalized:
  The ORDER MODULE CODE DOESN'T CHANGE
  Spring Modulith automatically forwards the event to Kafka/RabbitMQ/SQS
  The same event is consumed by the in-process handler (if still in monolith)
  AND forwarded to the message broker for external consumers
```

### 9.2 Dependencies

```xml
<!-- Kafka externalization -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-kafka</artifactId>
</dependency>

<!-- RabbitMQ externalization -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-amqp</artifactId>
</dependency>

<!-- AWS SQS externalization -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-aws-sqs</artifactId>
</dependency>

<!-- AWS SNS externalization -->
<dependency>
    <groupId>org.springframework.modulith</groupId>
    <artifactId>spring-modulith-events-aws-sns</artifactId>
</dependency>
```

---

## 10. `@Externalized` — Automatic Event Forwarding

### 10.1 Basic Usage

```java
import org.springframework.modulith.events.Externalized;

// Annotate the event class — this event will be forwarded to the message broker
@Externalized("orders.placed")   // target: topic/queue/exchange name
public record OrderPlacedEvent(
    Long orderId,
    Long userId,
    List<Long> productIds,
    BigDecimal total,
    Instant occurredAt
) {}
```

**What happens when `@Externalized` is present:**
```
1. OrderService publishes OrderPlacedEvent via ApplicationEventPublisher

2. Event publication registry persists it to DB (same as always)

3. After publisher's TX commits:
   a. In-process @ApplicationModuleListener handlers run (same module behavior)
   b. Spring Modulith ALSO forwards the event to Kafka/RabbitMQ/SQS
      using the topic name from @Externalized

4. External services (or extracted microservices) consume from the topic
```

### 10.2 Kafka Externalization

```java
// Event annotated for Kafka externalization
@Externalized("orders.placed")     // Kafka topic name
public record OrderPlacedEvent(Long orderId, Long userId, BigDecimal total) {}

// Kafka configuration:
spring:
  kafka:
    bootstrap-servers: localhost:9092
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer

// Spring Modulith will:
// - Serialize OrderPlacedEvent to JSON
// - Send to Kafka topic "orders.placed"
// - Key: orderId.toString() (configurable via routing key)
// - After successful send: mark publication as complete in registry
```

### 10.3 Custom Topic/Routing Key

```java
// Static topic with dynamic routing key
@Externalized(
    target = "orders",              // Kafka topic / RabbitMQ exchange
    key = "#{#event.orderId}"       // SpEL expression for message key / routing key
)
public record OrderPlacedEvent(Long orderId, String region, BigDecimal total) {}
// Sends to Kafka topic "orders" with key = orderId (enables partition routing by order)

// Dynamic target (different topic per condition)
@Externalized("orders.#{#event.region}.placed")
// SpEL in the topic name: sends to "orders.US.placed" or "orders.EU.placed"
```

### 10.4 RabbitMQ Externalization

```java
// Event annotated for RabbitMQ externalization
@Externalized("order-events-exchange")
public record OrderPlacedEvent(Long orderId, Long userId, BigDecimal total) {}

// RabbitMQ configuration:
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest

# Spring Modulith will:
# - Serialize event to JSON
# - Publish to exchange "order-events-exchange"
# - Routing key: "com.myapp.order.OrderPlacedEvent" (fully qualified class name, configurable)
```

### 10.5 In-Process AND External — Hybrid Mode

```java
// Useful during the transition from monolith to microservices:
// Some modules still inside the monolith, some extracted

@Externalized("orders.placed")
public record OrderPlacedEvent(Long orderId, Long userId) {}

// In the SAME monolith:
@Component
class LoyaltyHandler {
    @ApplicationModuleListener
    void on(OrderPlacedEvent e) {
        // Still in the monolith — handles event IN-PROCESS
        loyaltyService.awardPoints(e.userId());
    }
}

// In an EXTRACTED microservice (separate JVM):
@Component
class ExternalInventoryHandler {
    @KafkaListener(topics = "orders.placed")
    void on(OrderPlacedEvent e) {
        // Now in a separate service — handles event from Kafka
        inventoryService.reserve(e.orderId());
    }
}

// Spring Modulith dispatches to BOTH:
// 1. LoyaltyHandler in-process (still in monolith)
// 2. Kafka topic "orders.placed" (for the extracted inventory service)
// Zero changes to OrderService
```

### 10.6 Externalization with Event Publication Registry

```
With @Externalized + event publication registry:

Guarantees:
  1. Event persisted to DB (with publisher's TX) — survives JVM crash
  2. Event forwarded to Kafka/RabbitMQ after commit (no lost events)
  3. If Kafka is down: publication stays INCOMPLETE
  4. On restart: incomplete publications are re-forwarded

This gives you:
  at-least-once delivery to the message broker
  + at-least-once delivery to in-process listeners
  = reliable cross-module AND cross-service communication

The event_publication table is the outbox:
  Publisher writes to DB (outbox) atomically
  Modulith reads from outbox and forwards to broker
  This is the "Transactional Outbox Pattern" — built in!
```

---

## 11. Quick Reference Cheat Sheet

### Why Events

```
Direct call: order → notification (coupling, harder to test, harder to extend)
Event:       order publishes OrderPlacedEvent
             notification subscribes (no dependency on order module)
             Adding new subscriber: zero changes to order module
```

### Annotations Summary

```java
// Publish
events.publishEvent(new OrderPlacedEvent(...));   // standard Spring

// Listen (cross-module — prefer this)
@ApplicationModuleListener
void on(OrderPlacedEvent e) { ... }
// = @Async + @TransactionalEventListener(AFTER_COMMIT) + @Transactional(REQUIRES_NEW)

// Listen (plain — synchronous, no transaction awareness)
@EventListener
void on(OrderPlacedEvent e) { ... }

// Listen (explicit transaction phase)
@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
void on(OrderPlacedEvent e) { ... }

// Externalize to message broker
@Externalized("topic-name")
public record OrderPlacedEvent(...) {}

// Externalize with routing key
@Externalized(target = "orders", key = "#{#event.orderId}")
public record OrderPlacedEvent(Long orderId, ...) {}
```

### Transaction Phases

```
BEFORE_COMMIT     → inside publisher's TX, just before commit
AFTER_COMMIT      → after publisher's TX commits (default, most common)
AFTER_ROLLBACK    → if publisher's TX rolls back
AFTER_COMPLETION  → after TX either commits or rolls back
```

### Event Publication Registry

```yaml
# Enable (auto-configured with spring-modulith-events-jpa on classpath)
spring:
  modulith:
    events:
      republication-enabled: true  # re-publish incomplete on startup

# Backends:
spring-modulith-events-jpa   → uses JPA entity, shares JPA datasource
spring-modulith-events-jdbc  → uses JDBC directly, lighter than JPA
spring-modulith-events-mongodb → MongoDB document store
```

### Externalization Backends

```
spring-modulith-events-kafka  → Apache Kafka
spring-modulith-events-amqp   → RabbitMQ
spring-modulith-events-aws-sqs → AWS SQS
spring-modulith-events-aws-sns → AWS SNS
```

### Key Rules to Remember

1. **Modules communicate via events for side effects** — direct calls are OK for reads, events for writes/side effects.
2. **`@ApplicationModuleListener` = AFTER_COMMIT + REQUIRES_NEW + Async** — don't compose these manually.
3. **AFTER_COMMIT prevents reacting to rolled-back transactions** — always use it for cross-module listeners.
4. **REQUIRES_NEW means listener failure doesn't roll back publisher** — they're independent transactions.
5. **Event publication registry = Transactional Outbox Pattern** — events are persisted atomically with domain changes.
6. **At-least-once delivery requires idempotent listeners** — check before acting, use upserts, use idempotency keys.
7. **Re-publishing is automatic on restart** — incomplete events from the last run are re-dispatched.
8. **`@Externalized` on the event record, not the listener** — the event itself declares it should go to a broker.
9. **Externalization + in-process coexist** — same event dispatched to both in-process listeners AND Kafka/RabbitMQ.
10. **Zero changes to publisher when extracting a module** — swap `@ApplicationModuleListener` for `@KafkaListener` in the extracted service; order module never changes.

---

*End of Application Events for Module Communication Study Guide — Module 4*
