# Java Records — Best Practices Complete Study Guide

> **Java 16+ Finalized | Brutally Detailed Reference**
> Covers records for DTOs, value objects, and projections; why records don't work for JPA entities; records vs Lombok `@Value`; compact constructors for validation; the `equals()`/`hashCode()` component contract; and every edge case. Full working examples throughout.

---

## Table of Contents

1. [What Records Are — Mechanics and Generated Members](#1-what-records-are--mechanics-and-generated-members)
2. [Records for DTOs, Value Objects, and Projections](#2-records-for-dtos-value-objects-and-projections)
3. [Why NOT for JPA Entities — Mutability and Proxying](#3-why-not-for-jpa-entities--mutability-and-proxying)
4. [Records vs Lombok `@Value`](#4-records-vs-lombok-value)
5. [Compact Constructors for Validation and Normalization](#5-compact-constructors-for-validation-and-normalization)
6. [`equals()`/`hashCode()` — Components Only](#6-equalshashcode--components-only)
7. [Records and Immutability — The Full Picture](#7-records-and-immutability--the-full-picture)
8. [Advanced Record Patterns](#8-advanced-record-patterns)
9. [Records in Java Ecosystem Frameworks](#9-records-in-java-ecosystem-frameworks)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. What Records Are — Mechanics and Generated Members

### 1.1 Declaration and What the Compiler Generates

A record declaration is a concise way to declare a **nominal tuple** — a class whose primary purpose is to carry data. The compiler generates everything:

```java
// This single line...
public record Point(int x, int y) {}

// ...generates ALL of this:
public final class Point {

    // 1. Private final fields for each component
    private final int x;
    private final int y;

    // 2. Canonical constructor (all components)
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // 3. Accessor methods (NOT getX — just x())
    public int x() { return x; }
    public int y() { return y; }

    // 4. equals() based on ALL components
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Point)) return false;
        Point p = (Point) o;
        return x == p.x && y == p.y;
    }

    // 5. hashCode() based on ALL components
    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }

    // 6. toString() showing all components
    @Override
    public String toString() {
        return "Point[x=" + x + ", y=" + y + "]";
    }
}
```

### 1.2 What Records Guarantee

```java
// Record invariants — enforced by the language:
// 1. final class  — cannot be subclassed
// 2. Components   — each component has a private final field and a public accessor
// 3. Canonical constructor — sets all component fields
// 4. equals/hashCode/toString — generated based on components
// 5. Cannot declare instance fields outside of components
// 6. Cannot extend another class (already extends Record implicitly)
// 7. CAN implement interfaces
// 8. CAN have static fields and methods
// 9. CAN have instance methods (non-accessor)
// 10. CAN override generated methods

// What you CANNOT do in a record:
record Bad(int x, int y) {
    private int z;        // COMPILE ERROR: non-component instance field
    public void setX(int x) { this.x = x; } // COMPILE ERROR: x is final
}
```

### 1.3 Accessor Naming Convention — `.x()` Not `.getX()`

```java
record Person(String firstName, String lastName, int age) {}

Person p = new Person("Alice", "Smith", 30);

// Accessors use the component name directly (no "get" prefix):
p.firstName()  // "Alice"    NOT p.getFirstName()
p.lastName()   // "Smith"    NOT p.getLastName()
p.age()        // 30         NOT p.getAge()

// This is a deliberate design decision — records are not JavaBeans
// Frameworks that rely on JavaBean conventions (getXxx) may not work
// Jackson, Spring, etc. have been updated to handle record accessors
```

---

## 2. Records for DTOs, Value Objects, and Projections

### 2.1 Data Transfer Objects (DTOs)

DTOs carry data between layers (controller → service → repository, or between microservices). Records are ideal:

```java
// REST API request/response DTOs
public record CreateUserRequest(
    String username,
    String email,
    String password,
    String displayName
) {}

public record UserResponse(
    long id,
    String username,
    String email,
    String displayName,
    Instant createdAt
) {}

// Service layer usage:
@PostMapping("/users")
public ResponseEntity<UserResponse> createUser(
        @RequestBody @Valid CreateUserRequest request) {

    UserResponse response = userService.create(request);
    return ResponseEntity.created(URI.create("/users/" + response.id()))
                         .body(response);
}
```

**Why records are perfect for DTOs:**
- Immutable — DTOs should never be modified after creation
- Compact — no boilerplate getters/setters/equals/hashCode
- Self-documenting — the record header is the schema
- Serialization-friendly — Jackson, JSON-B, etc. support records

### 2.2 Value Objects (Domain-Driven Design)

Value objects are domain concepts identified by their value, not identity (`equals()` based on fields, not reference):

```java
// Domain value objects — semantically rich primitives
public record Money(BigDecimal amount, Currency currency) {

    // Compact constructor: validate + normalize
    Money {
        Objects.requireNonNull(amount, "amount must not be null");
        Objects.requireNonNull(currency, "currency must not be null");
        if (amount.compareTo(BigDecimal.ZERO) < 0)
            throw new IllegalArgumentException("amount must not be negative: " + amount);
        // Normalize to 2 decimal places
        amount = amount.setScale(2, RoundingMode.HALF_UP);
    }

    // Domain operations return new instances (immutable)
    public Money add(Money other) {
        if (!this.currency.equals(other.currency))
            throw new IllegalArgumentException(
                "Cannot add " + currency + " and " + other.currency);
        return new Money(this.amount.add(other.amount), this.currency);
    }

    public Money multiply(int factor) {
        return new Money(this.amount.multiply(BigDecimal.valueOf(factor)), this.currency);
    }

    public boolean isZero() {
        return amount.compareTo(BigDecimal.ZERO) == 0;
    }

    @Override
    public String toString() {
        return amount + " " + currency.getCurrencyCode();
    }
}

// Usage: two Money instances with same amount+currency are equal
Money price = new Money(new BigDecimal("9.99"), Currency.getInstance("USD"));
Money same  = new Money(new BigDecimal("9.99"), Currency.getInstance("USD"));
System.out.println(price.equals(same)); // true — value equality, not reference

// More value objects
public record EmailAddress(String value) {
    EmailAddress {
        Objects.requireNonNull(value, "email must not be null");
        if (!value.matches("^[^@]+@[^@]+\\.[^@]+$"))
            throw new IllegalArgumentException("Invalid email: " + value);
        value = value.toLowerCase().strip(); // normalize
    }
}

public record UserId(long value) {
    UserId {
        if (value <= 0) throw new IllegalArgumentException("UserId must be positive: " + value);
    }
}

public record Percentage(double value) {
    Percentage {
        if (value < 0.0 || value > 100.0)
            throw new IllegalArgumentException("Percentage must be 0-100: " + value);
    }
}
```

### 2.3 Query Projections

Records are perfect for database query results that only need a subset of an entity's fields:

```java
// JPA projection — select only needed columns
public record UserSummary(long id, String username, String email) {}

// Spring Data JPA interface-based projection replacement:
// OLD way with interface:
// public interface UserSummary { long getId(); String getUsername(); String getEmail(); }

// NEW way with record — just as clean, more explicit:
@Query("SELECT new com.myapp.dto.UserSummary(u.id, u.username, u.email) FROM User u WHERE u.active = true")
List<UserSummary> findActiveSummaries();

// Spring Data also supports constructor expressions automatically:
@Query("SELECT u.id, u.username, u.email FROM User u")
List<UserSummary> findAllSummaries(); // Spring maps columns to record constructor
```

```java
// JDBC row mapper projection
public record ProductStats(
    String category,
    long productCount,
    BigDecimal avgPrice,
    BigDecimal maxPrice
) {}

// Using RowMapper
List<ProductStats> stats = jdbcTemplate.query(
    "SELECT category, COUNT(*) as count, AVG(price), MAX(price) FROM products GROUP BY category",
    (rs, rowNum) -> new ProductStats(
        rs.getString("category"),
        rs.getLong("count"),
        rs.getBigDecimal("avg"),
        rs.getBigDecimal("max")
    )
);
```

### 2.4 Event and Message Types

Records map naturally to domain events and messages:

```java
// Domain events
public record UserRegistered(
    UserId userId,
    EmailAddress email,
    Instant occurredAt
) implements DomainEvent {}

public record OrderPlaced(
    OrderId orderId,
    UserId userId,
    Money totalAmount,
    List<OrderLineItem> lineItems,
    Instant occurredAt
) implements DomainEvent {
    OrderPlaced {
        Objects.requireNonNull(orderId);
        Objects.requireNonNull(userId);
        Objects.requireNonNull(totalAmount);
        Objects.requireNonNull(occurredAt);
        lineItems = List.copyOf(lineItems); // defensive copy
    }
}

// Message/command objects
public record SendEmailCommand(
    EmailAddress to,
    String subject,
    String body
) {}
```

### 2.5 Tuple-Like Return Values

Replace ad-hoc `Pair<A,B>` or multi-element array returns with named records:

```java
// BAD — what does Pair(Integer, String) mean?
private Pair<Integer, String> parseVersion(String versionStr) { ... }

// GOOD — self-documenting named tuple
record ParsedVersion(int major, String qualifier) {}
private ParsedVersion parseVersion(String versionStr) {
    // ...
    return new ParsedVersion(major, qualifier);
}

// Usage is clear:
ParsedVersion v = parseVersion("3.1-SNAPSHOT");
System.out.println(v.major());     // 3
System.out.println(v.qualifier()); // SNAPSHOT
```

---

## 3. Why NOT for JPA Entities — Mutability and Proxying

### 3.1 JPA's Requirements That Records Cannot Meet

JPA (Hibernate, EclipseLink) entities have specific requirements that are fundamentally incompatible with records:

```java
// JPA ENTITY REQUIREMENTS:
// 1. No-arg constructor (protected or public) — JPA uses it to instantiate
// 2. Non-final class — JPA proxies subclass the entity for lazy loading
// 3. Mutable fields — JPA tracks changes and updates dirty fields
// 4. Setters (or field access) — JPA assigns field values after construction

// ALL OF THESE ARE VIOLATED BY RECORDS:
@Entity // WILL NOT WORK CORRECTLY
public record User(Long id, String username, String email) {}
// 1. No no-arg constructor — records only have the canonical constructor
// 2. Records are final — cannot be subclassed by JPA proxy
// 3. Fields are final — JPA cannot set them after construction
// 4. No setters — JPA cannot dirty-track changes
```

### 3.2 The Proxy Problem — Why `final` Breaks JPA

JPA providers (especially Hibernate) create **proxy subclasses** of your entity for lazy loading:

```java
// When you write:
@OneToMany(fetch = FetchType.LAZY)
private List<Order> orders;

// Hibernate generates at runtime (approximately):
class User_HibernateProxy_abc123 extends User {  // EXTENDS User!
    @Override
    public List<Order> getOrders() {
        if (!initialized) {
            loadFromDatabase(); // lazy loading trigger
        }
        return super.getOrders();
    }
}

// Records are final — cannot be extended — proxy generation fails
// Hibernate throws: "Cannot subclass a record class"
// Result: lazy loading is broken or an error is thrown at startup
```

### 3.3 The No-Arg Constructor Problem

JPA requires a no-arg constructor to instantiate entities after loading from the database:

```java
// JPA's workflow:
// 1. ResultSet rs = executeQuery("SELECT * FROM users WHERE id = 1")
// 2. User user = User.class.getDeclaredConstructor().newInstance()  // no-arg constructor!
// 3. user.setId(rs.getLong("id"))     // set fields
// 4. user.setUsername(rs.getString("username"))
// 5. user.setEmail(rs.getString("email"))

// Records only have the canonical constructor (all args):
public record User(Long id, String username, String email) {}
// User.class.getDeclaredConstructor().newInstance() → throws NoSuchMethodException
// JPA cannot instantiate a record after loading from DB
```

### 3.4 The Correct Separation — Entity vs Record DTO

```java
// ✅ ENTITY — mutable class, JPA annotations, for persistence layer
@Entity
@Table(name = "users")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String email;

    protected UserEntity() {} // no-arg constructor for JPA

    public UserEntity(String username, String email) {
        this.username = username;
        this.email    = email;
    }

    // Getters and setters for JPA dirty tracking
    public Long   getId()       { return id; }
    public String getUsername() { return username; }
    public String getEmail()    { return email; }
    public void   setEmail(String email) { this.email = email; }
    // ...
}

// ✅ RECORD — immutable DTO, for API layer and service boundaries
public record UserDto(long id, String username, String email) {}

// ✅ Mapper between entity and DTO
public class UserMapper {
    public static UserDto toDto(UserEntity entity) {
        return new UserDto(entity.getId(), entity.getUsername(), entity.getEmail());
    }
    // Note: no toEntity() — DTOs don't become entities; use separate creation logic
}
```

### 3.5 What Records CAN Be in the Persistence Layer

```java
// ✅ Embeddable value objects — only if the JPA provider supports it
// Hibernate 6.2+ supports record-based @Embeddable:
@Embeddable
public record Address(
    String street,
    String city,
    String postalCode,
    String country
) {}

// Use in entity:
@Entity
public class UserEntity {
    @Embedded
    private Address address; // works with Hibernate 6.2+ only
    // ...
}

// ✅ JPQL/HQL new-expression projections (read-only result sets):
@Query("SELECT new com.myapp.dto.UserSummary(u.id, u.username) FROM UserEntity u")
List<UserSummary> findSummaries();

// ✅ Spring Data interface projections replaced by records (read-only):
// In Spring Data, return type of repository method can be a record:
List<UserSummary> findByActiveTrue(); // Spring maps to record constructor
```

---

## 4. Records vs Lombok `@Value`

### 4.1 Side-by-Side Comparison

```java
// Lombok @Value — equivalent immutable class (Java 8+)
@Value
public class Point {
    int x;
    int y;
    // Generates: constructor, getters (getX/getY), equals, hashCode, toString
    // Fields are: private final
}

// Java Record — built into the language (Java 16+)
public record Point(int x, int y) {}
// Generates: canonical constructor, accessors (x()/y()), equals, hashCode, toString
// Fields are: private final
```

### 4.2 Key Differences

| Feature | Lombok `@Value` | Java `record` |
|---|---|---|
| **JDK requirement** | Java 8+ | Java 16+ |
| **Annotation processor** | Required (compile-time) | None — built into compiler |
| **Build tool setup** | Needs `lombok` dependency + IDE plugin | Nothing extra |
| **Accessor naming** | `getX()`, `getY()` (JavaBean style) | `x()`, `y()` (record style) |
| **Inheritance** | Class can extend others | Implicitly extends `Record`, cannot extend others |
| **Subclassing** | Can be subclassed (not final by default unless `@Value` marks final) | Always `final` |
| **Compact constructor** | Not available — use regular constructor | `ClassName { validation; }` |
| **With-copy pattern** | Need `@With` annotation | Need to implement manually |
| **Serialization** | Works with standard Java serialization | Works with standard Java serialization |
| **Jackson** | Works (needs `@JsonProperty` or jackson-databind module) | Works (needs `jackson-databind 2.12+`) |
| **Pattern matching** | No `instanceof` pattern support | Works with `instanceof Point(int x, int y)` (Java 21+) |
| **Deconstruction** | No | Yes — `switch` + deconstruction in Java 21+ |
| **Reflection visibility** | Fields hidden behind getters | `RecordComponent[]` via reflection |
| **`@Builder`** | Can combine with `@Value` | Need custom implementation or `@RecordBuilder` library |
| **Debugging** | Lombok-generated code is invisible in debugger | Record methods visible and debuggable |

### 4.3 When to Use Each

```java
// USE RECORD when:
// 1. Java 16+ project
// 2. Truly immutable data carrier
// 3. Pattern matching needed (Java 21+)
// 4. No Lombok in project / want to reduce dependencies
// 5. DTO/value object in API layer

public record UserDto(long id, String username, String email) {} // ← prefer this

// USE @Value when:
// 1. Java 8-15 (no records available)
// 2. Need @Builder pattern alongside immutability
// 3. Existing project heavily using Lombok (consistency)
// 4. Need @With (copy-with-modification) without manual code
// 5. Need JavaBean accessor convention (getX()) for framework compatibility

@Value
@Builder
@With
public class UserDto {
    long id;
    String username;
    String email;
    // Generates: UserDto.builder(), dto.withUsername("new") → new UserDto, etc.
}
```

### 4.4 Migration Pattern — `@Value` to `record`

```java
// BEFORE — Lombok @Value
@Value
public class OrderItem {
    String productId;
    int quantity;
    BigDecimal price;
}

// AFTER — record (Java 16+)
public record OrderItem(String productId, int quantity, BigDecimal price) {
    OrderItem {
        // Add any validation that was previously in Lombok @NonNull or custom constructor
        Objects.requireNonNull(productId, "productId must not be null");
        if (quantity <= 0)
            throw new IllegalArgumentException("quantity must be positive: " + quantity);
        Objects.requireNonNull(price, "price must not be null");
    }
}

// Accessor call sites: update getProductId() → productId(), etc.
// This is the only code change required in callers
```

### 4.5 The `@With` Equivalent for Records

Lombok `@With` generates `withXxx(newValue)` methods that return a new instance with one field changed. Records don't have this, but it's easy to implement:

```java
public record UserConfig(String host, int port, boolean ssl, Duration timeout) {

    // Manual "with" methods — one per component
    public UserConfig withHost(String host) {
        return new UserConfig(host, this.port, this.ssl, this.timeout);
    }

    public UserConfig withPort(int port) {
        return new UserConfig(this.host, port, this.ssl, this.timeout);
    }

    public UserConfig withSsl(boolean ssl) {
        return new UserConfig(this.host, this.port, ssl, this.timeout);
    }

    public UserConfig withTimeout(Duration timeout) {
        return new UserConfig(this.host, this.port, this.ssl, timeout);
    }
}

// Usage (same as Lombok @With):
UserConfig base    = new UserConfig("localhost", 5432, false, Duration.ofSeconds(30));
UserConfig withSsl = base.withSsl(true).withPort(5433);
```

---

## 5. Compact Constructors for Validation and Normalization

### 5.1 Compact Constructor Syntax

The compact constructor is a special constructor syntax in records that runs **before** the canonical constructor assigns fields. It does not list parameters and does not include `this.field = param` assignments — those happen automatically after the compact constructor body:

```java
public record Email(String value) {

    // Compact constructor: no parameter list, no explicit assignments
    Email {
        // 'value' here refers to the constructor parameter, not the field
        // After this block executes, 'this.value = value' happens automatically
        if (value == null)
            throw new NullPointerException("Email value must not be null");
        if (!value.contains("@"))
            throw new IllegalArgumentException("Invalid email address: " + value);
    }
}

// Equivalent full canonical constructor:
public record Email(String value) {
    public Email(String value) {
        if (value == null) throw new NullPointerException("...");
        if (!value.contains("@")) throw new IllegalArgumentException("...");
        this.value = value; // this assignment is explicit in full constructor
    }
}
```

### 5.2 Normalization in Compact Constructors

You can **reassign the constructor parameters** in the compact constructor to normalize inputs. The canonical constructor then assigns the normalized value to the field:

```java
public record Email(String value) {
    Email {
        Objects.requireNonNull(value, "email must not be null");
        // Normalize: trim whitespace and lowercase
        value = value.strip().toLowerCase();   // ← reassign the parameter
        // After this block: this.value = value (the normalized version)
        if (!value.matches("^[^@]+@[^@]+\\.[^@]+$"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
}

Email e1 = new Email("  Alice@Example.COM  ");
System.out.println(e1.value()); // alice@example.com — normalized

// More examples of normalization:
public record PhoneNumber(String digits) {
    PhoneNumber {
        Objects.requireNonNull(digits, "digits must not be null");
        digits = digits.replaceAll("[^0-9]", ""); // strip non-digits
        if (digits.length() < 7 || digits.length() > 15)
            throw new IllegalArgumentException("Invalid phone number: " + digits);
    }
}

PhoneNumber p = new PhoneNumber("+1 (555) 123-4567");
System.out.println(p.digits()); // 15551234567 — normalized

public record Temperature(double celsius) {
    Temperature {
        if (celsius < -273.15)
            throw new IllegalArgumentException(
                "Temperature below absolute zero: " + celsius);
        celsius = Math.round(celsius * 100.0) / 100.0; // round to 2 decimal places
    }
}
```

### 5.3 Validation Patterns

```java
// Pattern 1: Not null + format check
public record Isbn(String value) {
    Isbn {
        Objects.requireNonNull(value, "ISBN must not be null");
        value = value.replaceAll("-", ""); // normalize: remove hyphens
        if (!value.matches("\\d{10}|\\d{13}"))
            throw new IllegalArgumentException("Invalid ISBN: " + value);
    }
}

// Pattern 2: Range validation
public record Port(int number) {
    Port {
        if (number < 0 || number > 65535)
            throw new IllegalArgumentException("Invalid port number: " + number);
    }
}

// Pattern 3: Cross-component validation
public record DateRange(LocalDate start, LocalDate end) {
    DateRange {
        Objects.requireNonNull(start, "start must not be null");
        Objects.requireNonNull(end, "end must not be null");
        if (start.isAfter(end))
            throw new IllegalArgumentException(
                "start must not be after end: " + start + " > " + end);
    }

    public long days() {
        return ChronoUnit.DAYS.between(start, end);
    }

    public boolean contains(LocalDate date) {
        return !date.isBefore(start) && !date.isAfter(end);
    }
}

// Pattern 4: Defensive copy for mutable components (see Section 7)
public record Snapshot(LocalDate date, int[] values) {
    Snapshot {
        Objects.requireNonNull(date, "date must not be null");
        Objects.requireNonNull(values, "values must not be null");
        values = Arrays.copyOf(values, values.length); // defensive copy
    }

    @Override
    public int[] values() {
        return Arrays.copyOf(values, values.length); // copy on output
    }
}
```

### 5.4 Compact Constructor Ordering — Validate After Normalizing

Always normalize first, then validate — you want to validate the final stored value:

```java
public record Username(String value) {
    Username {
        Objects.requireNonNull(value, "username must not be null");

        // STEP 1: Normalize
        value = value.strip().toLowerCase();

        // STEP 2: Validate the normalized value
        if (value.isBlank())
            throw new IllegalArgumentException("username must not be blank");
        if (value.length() < 3)
            throw new IllegalArgumentException("username too short: " + value);
        if (value.length() > 30)
            throw new IllegalArgumentException("username too long: " + value);
        if (!value.matches("[a-z0-9_]+"))
            throw new IllegalArgumentException(
                "username must contain only lowercase letters, digits, underscores: " + value);
    }
}
```

### 5.5 Compact Constructor vs Explicit Canonical Constructor

You can also override the canonical constructor explicitly — useful when the compact constructor syntax is insufficient:

```java
// Explicit canonical constructor (full form)
public record Money(BigDecimal amount, Currency currency) {

    public Money(BigDecimal amount, Currency currency) {
        // Full canonical constructor: must assign ALL fields
        Objects.requireNonNull(amount);
        Objects.requireNonNull(currency);
        this.amount   = amount.setScale(2, RoundingMode.HALF_UP); // assign normalized value
        this.currency = currency;
    }
}

// When to use full vs compact:
// Compact: simpler — use when normalizing is just reassigning parameters
// Full: necessary when you need to compute different values to store
//       (e.g., store the normalized value under a different variable name)
```

---

## 6. `equals()`/`hashCode()` — Components Only

### 6.1 The Rule: Only Constructor Parameters Count

The generated `equals()` and `hashCode()` methods use **only the components** (the parameters listed in the record header). Any additional state computed or stored in the record body is **completely ignored**:

```java
public record Circle(double radius) {
    // This is a body field — NOT a component
    // DOES NOT affect equals() or hashCode()
    // Records CANNOT have instance fields outside components!
    // This would be a compile error:
    // private final double area;    // COMPILE ERROR: non-component instance field
}
```

Wait — records actually **cannot** have non-component instance fields at all. The rule about "body fields excluded" applies to **static fields** and **derived/computed state** in different contexts. Let's clarify:

```java
// Records CANNOT declare instance fields beyond components — compile error:
public record Person(String name, int age) {
    private final String cachedSummary; // COMPILE ERROR: non-component instance field
}

// They CAN have static fields (not part of equals/hashCode):
public record Person(String name, int age) {
    // Static fields — NOT part of equals()/hashCode()
    private static final int MAX_AGE = 150;
    public static final Person UNKNOWN = new Person("Unknown", 0);
}

// They CAN have methods that compute derived state:
public record Circle(double radius) {
    public double area() { return Math.PI * radius * radius; } // computed, not stored
    // area() result is not considered by equals()/hashCode() — only radius is
}
```

### 6.2 The Critical Gotcha — Inherited State Not Considered

Since records cannot extend other classes (except `Record`), and cannot have extra instance fields, the "only components" rule means: **exactly and only what is in the record header**.

```java
public record CachedComputation(int input) {
    // Can't store derived state as an instance field
    // The only field is 'input'
    // equals/hashCode use only 'input'

    // Two records with same input are EQUAL even if their computations differ
    // (but since there's no mutable state, this is fine)
}

// Practical implications:
record Point(double x, double y) {
    public double distanceFromOrigin() {
        return Math.sqrt(x * x + y * y); // computed — not in equals/hashCode
    }
}

Point p1 = new Point(3.0, 4.0);
Point p2 = new Point(3.0, 4.0);
System.out.println(p1.equals(p2));                  // true — same x and y
System.out.println(p1.distanceFromOrigin());         // 5.0
// distanceFromOrigin() output is NOT considered by equals — only x and y matter
```

### 6.3 The Static Field Exclusion

Static fields are genuinely excluded and understanding this matters for misuse patterns:

```java
public record ApiResponse(String data, int statusCode) {
    // This counter is NOT part of equals/hashCode — it's static
    private static final AtomicInteger instanceCount = new AtomicInteger();
    // (a bad pattern for production, but illustrates the exclusion)

    ApiResponse {
        instanceCount.incrementAndGet();
    }

    public static int getInstanceCount() {
        return instanceCount.get();
    }
}

ApiResponse r1 = new ApiResponse("data", 200);
ApiResponse r2 = new ApiResponse("data", 200);
System.out.println(r1.equals(r2));               // true — same data + statusCode
System.out.println(ApiResponse.getInstanceCount()); // 2 — static field, ignored by equals
```

### 6.4 Float and Double in `equals()`/`hashCode()`

The generated `equals()` uses `==` for primitive components. For `float` and `double`, this means `NaN != NaN` and `-0.0 == 0.0` — the same behavior as `==` for these types:

```java
record Measurement(double value) {}

Measurement m1 = new Measurement(Double.NaN);
Measurement m2 = new Measurement(Double.NaN);
System.out.println(m1.equals(m2)); // FALSE — NaN != NaN by IEEE 754
// But Double.compare(NaN, NaN) == 0 → they'd be "equal" if using Double.compare

// If you need NaN == NaN semantics, override equals():
public record Measurement(double value) {
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Measurement m)) return false;
        return Double.compare(value, m.value) == 0; // uses Double.compare for NaN safety
    }

    @Override
    public int hashCode() {
        return Double.hashCode(value); // consistent with Double.compare
    }
}
```

### 6.5 Array Components in `equals()`/`hashCode()`

Arrays use reference equality in the generated `equals()` — a critical gotcha:

```java
record ArrayHolder(int[] values) {}

ArrayHolder a1 = new ArrayHolder(new int[]{1, 2, 3});
ArrayHolder a2 = new ArrayHolder(new int[]{1, 2, 3});
System.out.println(a1.equals(a2)); // FALSE — different array instances!
// Generated equals() calls: Arrays.equals? NO — it calls Object.equals(int[], int[])
// which is reference equality

// Fix: override equals() and hashCode() for array components:
public record ArrayHolder(int[] values) {
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof ArrayHolder h)) return false;
        return Arrays.equals(values, h.values); // content equality
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(values); // content-based hash
    }

    @Override
    public String toString() {
        return "ArrayHolder[values=" + Arrays.toString(values) + "]";
    }
}

// Also: apply defensive copy for the array (see Section 7):
public record ArrayHolder(int[] values) {
    ArrayHolder {
        values = Arrays.copyOf(values, values.length); // defensive copy
    }

    @Override
    public int[] values() {
        return Arrays.copyOf(values, values.length);
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof ArrayHolder h)) return false;
        return Arrays.equals(values, h.values);
    }

    @Override
    public int hashCode() {
        return Arrays.hashCode(values);
    }
}
```

### 6.6 Overriding Generated Methods

You can override any generated method while keeping others:

```java
public record Product(String sku, String name, BigDecimal price) {

    // Override equals to be case-insensitive on SKU
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Product p)) return false;
        return sku.equalsIgnoreCase(p.sku); // only SKU matters for identity
    }

    @Override
    public int hashCode() {
        return sku.toLowerCase().hashCode(); // consistent with equals
    }

    // Keep generated toString() — or override for custom format:
    @Override
    public String toString() {
        return String.format("Product{sku='%s', name='%s', price=%s}", sku, name, price);
    }
}
```

---

## 7. Records and Immutability — The Full Picture

### 7.1 Records Are NOT Automatically Deep-Immutable

Records guarantee that the **component references** cannot be reassigned (`final` fields). But if a component is a mutable type, the object it points to can still be changed:

```java
// The record IS immutable — the references are final
// The OBJECTS the references point to may not be immutable
public record BreakableRecord(Date date, int[] numbers, List<String> names) {}

BreakableRecord r = new BreakableRecord(new Date(), new int[]{1,2,3}, new ArrayList<>(List.of("Alice")));

// These all WORK — record doesn't protect against this:
r.date().setTime(0L);         // modifies the Date inside the record
r.numbers()[0] = 999;         // modifies the array inside the record
r.names().add("Bob");         // modifies the list inside the record (if not unmodifiable)
```

### 7.2 Making Records Genuinely Immutable — Compact Constructor + Override Accessors

```java
public record SafeRecord(LocalDate date, int[] numbers, List<String> names) {

    SafeRecord {
        // Null checks
        Objects.requireNonNull(date, "date must not be null");
        Objects.requireNonNull(numbers, "numbers must not be null");
        Objects.requireNonNull(names, "names must not be null");

        // Defensive copies of mutable types
        numbers = Arrays.copyOf(numbers, numbers.length);   // copy array
        names   = List.copyOf(names);                       // copy + unmodifiable list
        // date is LocalDate — immutable, no copy needed
    }

    // Override accessor for array to return a copy
    @Override
    public int[] numbers() {
        return Arrays.copyOf(numbers, numbers.length);
    }

    // names() accessor returns the unmodifiable list — safe to expose directly
    // date() accessor returns immutable LocalDate — safe to expose directly
}
```

---

## 8. Advanced Record Patterns

### 8.1 Records Implementing Interfaces

```java
public interface Identifiable {
    long id();
}

public interface Auditable {
    Instant createdAt();
    Instant updatedAt();
}

// Record can implement multiple interfaces
public record UserDto(long id, String username, Instant createdAt, Instant updatedAt)
        implements Identifiable, Auditable {}

// The record accessor 'id()' satisfies the Identifiable.id() contract automatically
// since the accessor name matches the interface method name
```

### 8.2 Sealed Hierarchies with Records

Records work perfectly as sealed class case types:

```java
// Sealed hierarchy of shapes
public sealed interface Shape permits Circle, Rectangle, Triangle {}

public record Circle(double radius) implements Shape {
    Circle {
        if (radius <= 0) throw new IllegalArgumentException("radius must be positive");
    }
    public double area() { return Math.PI * radius * radius; }
}

public record Rectangle(double width, double height) implements Shape {
    Rectangle {
        if (width <= 0 || height <= 0)
            throw new IllegalArgumentException("dimensions must be positive");
    }
    public double area() { return width * height; }
}

public record Triangle(double base, double height) implements Shape {
    public double area() { return 0.5 * base * height; }
}

// Exhaustive pattern matching (Java 21+):
double area = switch (shape) {
    case Circle c           -> c.area();
    case Rectangle r        -> r.area();
    case Triangle t         -> t.area();
}; // no default needed — sealed hierarchy is exhaustive
```

### 8.3 Record Deconstruction Patterns (Java 21+)

```java
record Point(int x, int y) {}
record Line(Point start, Point end) {}

Line line = new Line(new Point(0, 0), new Point(3, 4));

// Deconstruction in instanceof:
if (line instanceof Line(Point(int x1, int y1), Point(int x2, int y2))) {
    System.out.println("From (" + x1 + "," + y1 + ") to (" + x2 + "," + y2 + ")");
}

// Deconstruction in switch:
String describe = switch (line) {
    case Line(Point(0, 0), var end) -> "Line from origin to " + end;
    case Line(var start, Point(0, 0)) -> "Line ending at origin from " + start;
    default -> "General line: " + line;
};
```

### 8.4 Records as Map Keys and in Collections

Records are well-suited as `Map` keys because `equals()` and `hashCode()` are correct by default for immutable component types:

```java
// Records as map keys — works correctly
Map<Point, String> labels = new HashMap<>();
labels.put(new Point(0, 0), "Origin");
labels.put(new Point(1, 0), "Unit X");

// Key lookup with a different instance (same values) works:
System.out.println(labels.get(new Point(0, 0))); // "Origin" — equals() works

// TreeMap requires Comparable or Comparator:
record Point(int x, int y) implements Comparable<Point> {
    @Override
    public int compareTo(Point other) {
        int cmp = Integer.compare(this.x, other.x);
        return cmp != 0 ? cmp : Integer.compare(this.y, other.y);
    }
}
TreeMap<Point, String> sortedLabels = new TreeMap<>();
```

### 8.5 Static Factory Methods on Records

```java
public record Color(int r, int g, int b) {

    Color {
        if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255)
            throw new IllegalArgumentException("RGB values must be 0-255");
    }

    // Static factory methods for named colors
    public static Color red()   { return new Color(255, 0, 0); }
    public static Color green() { return new Color(0, 255, 0); }
    public static Color blue()  { return new Color(0, 0, 255); }
    public static Color white() { return new Color(255, 255, 255); }
    public static Color black() { return new Color(0, 0, 0); }

    // Static factory from hex string
    public static Color fromHex(String hex) {
        String clean = hex.startsWith("#") ? hex.substring(1) : hex;
        return new Color(
            Integer.parseInt(clean.substring(0, 2), 16),
            Integer.parseInt(clean.substring(2, 4), 16),
            Integer.parseInt(clean.substring(4, 6), 16)
        );
    }

    public String toHex() {
        return String.format("#%02X%02X%02X", r, g, b);
    }
}
```

---

## 9. Records in Java Ecosystem Frameworks

### 9.1 Jackson Serialization

```java
// Jackson 2.12+ supports records natively
// No additional annotations needed for basic serialization

public record ProductDto(long id, String name, BigDecimal price) {}

// Serializes to: {"id":1,"name":"Widget","price":9.99}
// Deserializes back via the canonical constructor

// For custom field names:
public record ProductDto(
    @JsonProperty("product_id") long id,
    @JsonProperty("product_name") String name,
    @JsonProperty("unit_price") BigDecimal price
) {}

// For JSON flexibility:
public record ProductDto(long id, String name, BigDecimal price) {
    @JsonCreator
    public ProductDto(
        @JsonProperty("id") long id,
        @JsonProperty("name") String name,
        @JsonProperty("price") BigDecimal price
    ) {
        this(id, name, price); // delegate to canonical
    }
}
```

### 9.2 Spring Framework Integration

```java
// Spring MVC: records work as @RequestBody and @ResponseBody
@RestController
public class UserController {

    // @RequestBody deserialized via Jackson
    @PostMapping("/users")
    public UserResponse createUser(@RequestBody @Valid CreateUserRequest request) {
        return userService.create(request);
    }

    // Validation on record components with Bean Validation:
    public record CreateUserRequest(
        @NotBlank String username,
        @Email String email,
        @Size(min = 8) String password
    ) {}
}

// Spring Data: records as projections
public interface UserRepository extends JpaRepository<UserEntity, Long> {
    // Spring Data automatically maps query result to record via constructor
    List<UserSummary> findAllByActiveTrue();

    // With @Query:
    @Query("SELECT u.id, u.username FROM UserEntity u WHERE u.role = :role")
    List<UserSummary> findByRole(@Param("role") String role);
}

public record UserSummary(long id, String username) {}
```

### 9.3 Records and Java Serialization

Records work with Java object serialization. The deserialization uses the canonical constructor (not field setting), which means compact constructor validation also runs during deserialization:

```java
// Records are serializable — implement Serializable
public record Config(String host, int port) implements Serializable {}

// Importantly: deserialization calls the canonical constructor
// so compact constructor validation is NOT bypassed during deserialization
// (unlike regular classes where deserialization bypasses constructors)
public record PositiveInt(int value) implements Serializable {
    PositiveInt {
        if (value <= 0) throw new IllegalArgumentException("must be positive: " + value);
    }
}
// Deserializing a serialized PositiveInt(-1) would throw — validation runs
```

---

## 10. Quick Reference Cheat Sheet

### Record Declaration and Members

```java
// Basic record
public record Point(int x, int y) {}

// With compact constructor (validation + normalization)
public record Email(String value) {
    Email {
        Objects.requireNonNull(value);
        value = value.strip().toLowerCase(); // reassign param to normalize
        if (!value.contains("@"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
}

// With additional methods
public record Money(BigDecimal amount, Currency currency) {
    Money { /* compact constructor */ }
    public Money add(Money other) { return new Money(amount.add(other.amount), currency); }
    public static Money zero(Currency c) { return new Money(BigDecimal.ZERO, c); }
}

// With interface
public record UserId(long value) implements Comparable<UserId> {
    UserId { if (value <= 0) throw new IllegalArgumentException("must be positive"); }
    @Override
    public int compareTo(UserId o) { return Long.compare(value, o.value); }
}
```

### What Goes in equals()/hashCode()

```
Components (record header params)  → YES, always
Static fields                      → NO, never
Computed/derived values            → NO (not stored anyway — records can't have instance fields)
Overridden accessor return values  → NO — only the raw stored value

Special cases requiring override:
- Array components → use Arrays.equals() + Arrays.hashCode()
- float/double with NaN → use Double.compare()
- Only some components should define equality → override both methods
```

### Record vs JPA Entity

```
Record:                      JPA Entity:
✅ DTOs                      ✅ @Entity classes
✅ Value objects             ✅ @Embeddable (Hibernate 6.2+)
✅ Query projections         ✅ Spring Data projection return types
✅ Domain events             ❌ NOT records (need proxying + no-arg constructor)
✅ API request/response      ❌ NOT for lazy-loaded entities
```

### Records vs Lombok `@Value`

```
Use record when:             Use @Value when:
- Java 16+                   - Java 8-15
- Pattern matching needed    - Need @Builder with @Value
- No Lombok in project       - Need @With
- Want toolchain simplicity  - Need getX() JavaBean accessors
```

### Common Compact Constructor Patterns

```java
// Null check + format validation + normalization
record Email(String value) {
    Email { Objects.requireNonNull(value); value = value.strip().toLowerCase();
            if (!value.contains("@")) throw new IAE(...); }
}

// Range check
record Port(int number) {
    Port { if (number < 0 || number > 65535) throw new IAE(...); }
}

// Cross-component validation
record Range(int min, int max) {
    Range { if (min > max) throw new IAE("min > max: " + min + " > " + max); }
}

// Defensive copy for array
record Snapshot(int[] data) {
    Snapshot { Objects.requireNonNull(data); data = Arrays.copyOf(data, data.length); }
    @Override public int[] data() { return Arrays.copyOf(data, data.length); }
}

// Defensive copy for collection
record Team(List<String> members) {
    Team { Objects.requireNonNull(members); members = List.copyOf(members); }
}
```

### Key Rules to Remember

1. **Records are `final`** — cannot be subclassed; this is why JPA proxying fails.
2. **Records cannot have non-component instance fields** — only static fields and methods.
3. **Accessors are named `x()` not `getX()`** — not JavaBeans; some old frameworks may be incompatible.
4. **`equals()`/`hashCode()` use only components** — static fields and computed values are excluded.
5. **Array components break generated `equals()`** — override to use `Arrays.equals()`.
6. **Compact constructor runs before field assignment** — reassign params to normalize stored values.
7. **Compact constructor validation runs during deserialization** — unlike regular class constructors.
8. **Records are shallow-immutable by default** — mutable components (arrays, `Date`, `List`) need defensive copies in compact constructor and accessor overrides.
9. **`List.copyOf` in compact constructor** — makes list both copied and unmodifiable; no accessor override needed.
10. **Prefer records over Lombok `@Value` in Java 16+** — no annotation processor, works with pattern matching, better toolchain integration.

---

*End of Java Records Best Practices Study Guide*
