





















































































































































































































































































































































































































































































































































































































































































































































# Hibernate-Specific Features (Beyond JPA) — Complete Study Guide

> **Module 8 | Brutally Detailed Reference**
> Covers every Hibernate-specific annotation and feature beyond the JPA spec: natural IDs, computed columns, soft delete filters, custom types, batch fetching, Envers auditing, statistics, and Hibernate 6 additions. Every section includes full working examples with SQL output.

---

## Table of Contents

1. [`@NaturalId` — Business Key Lookups](#1-naturalid--business-key-lookups)
2. [`@Formula` — Computed Columns](#2-formula--computed-columns)
3. [`@Where` — Default Entity Filter (Soft Delete)](#3-where--default-entity-filter-soft-delete)
4. [`@Filter` and `@FilterDef` — Dynamic Toggleable Filters](#4-filter-and-filterdef--dynamic-toggleable-filters)
5. [`@Type` and Custom `UserType`](#5-type-and-custom-usertype)
6. [`@BatchSize` — Batch Fetching](#6-batchsize--batch-fetching)
7. [`@Fetch(FetchMode.SUBSELECT)` — Subselect Fetching](#7-fetchfetchmodesubselect--subselect-fetching)
8. [Hibernate Envers — Entity Auditing](#8-hibernate-envers--entity-auditing)
9. [Hibernate Statistics](#9-hibernate-statistics)
10. [Hibernate 6 Features](#10-hibernate-6-features)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. `@NaturalId` — Business Key Lookups

### 1.1 What Is a Natural ID?

Every entity has a **surrogate primary key** (a generated `@Id`, typically a `Long`). But many entities also have a **natural business key** — a value that uniquely identifies the entity in the real world:

```
Entity          | Surrogate PK | Natural ID
User            | id (Long)    | username (String) or email (String)
Product         | id (Long)    | sku (String)
Country         | id (Long)    | isoCode (String)  e.g., "US", "GB"
BankAccount     | id (Long)    | accountNumber (String)
Employee        | id (Long)    | employeeNumber (String)
```

`@NaturalId` marks the natural key field(s). Hibernate then provides optimized lookups through the second-level cache and dedicated `byNaturalId()` API.

### 1.2 Basic Usage

```java
import org.hibernate.annotations.NaturalId;

@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NaturalId                           // marks this as the natural/business key
    @Column(nullable = false, unique = true)
    private String sku;

    @Column(nullable = false)
    private String name;

    private BigDecimal price;

    // constructors, getters, setters...
}
```

### 1.3 Mutable vs Immutable Natural IDs

```java
// Immutable (default) — natural ID never changes after creation
// Best for: ISO codes, SSNs, SKUs, account numbers
@NaturalId
private String sku;

// Mutable — natural ID can be changed (but this is rare and suspicious)
// The mutable=true flag removes the generated unique constraint assumption
@NaturalId(mutable = true)
private String email; // emails can change
```

### 1.4 Composite Natural ID

```java
@Entity
@Table(name = "translations")
public class Translation {

    @Id
    @GeneratedValue
    private Long id;

    @NaturalId
    @Column(name = "locale_code", nullable = false)
    private String localeCode;    // "en_US", "fr_FR"

    @NaturalId
    @Column(name = "message_key", nullable = false)
    private String messageKey;    // "user.greeting", "error.notfound"

    @Column(nullable = false)
    private String value;

    // The combination (localeCode, messageKey) is the natural ID
}
```

### 1.5 The `byNaturalId()` Query API

Without `@NaturalId`, looking up by business key requires a JPQL query. With it, Hibernate provides a dedicated, cache-aware API:

```java
import org.hibernate.Session;

// Method 1: byNaturalId() — cache-aware, preferred
Session session = entityManager.unwrap(Session.class);

Product product = session.byNaturalId(Product.class)
    .using("sku", "WIDGET-001")
    .load();
// Hibernate first checks second-level cache before hitting the DB

// Method 2: bySimpleNaturalId() — shorthand when there's exactly one @NaturalId field
Product product = session.bySimpleNaturalId(Product.class)
    .load("WIDGET-001");

// Method 3: Composite natural ID
Translation t = session.byNaturalId(Translation.class)
    .using("localeCode", "en_US")
    .using("messageKey", "user.greeting")
    .load();

// Method 4: getReference() — returns proxy without DB hit (like getReference())
Product proxy = session.bySimpleNaturalId(Product.class)
    .getReference("WIDGET-001");
```

### 1.6 Second-Level Cache Integration

The key advantage of `@NaturalId` over a plain `@Column(unique=true)` is **second-level cache integration**:

```
Without @NaturalId lookup:
  Cache: product#12345 (cached by PK=12345)
  Query: SELECT * FROM products WHERE sku = 'WIDGET-001'
  → Always hits the database (cache is PK-keyed, not SKU-keyed)

With @NaturalId lookup:
  Cache: naturalId(Product, sku='WIDGET-001') → PK=12345
         product#12345 (the entity itself)
  Query: bySimpleNaturalId("WIDGET-001").load()
  → First checks naturalId cache: finds PK=12345
  → Then checks entity cache: finds Product#12345
  → Zero database hits!
```

```java
// Enable second-level cache for natural ID
@Entity
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)  // entity cache
@NaturalIdCache                                         // natural ID resolution cache
public class Product {

    @Id
    @GeneratedValue
    private Long id;

    @NaturalId
    private String sku;
}
```

---

## 2. `@Formula` — Computed Columns

### 2.1 What `@Formula` Does

`@Formula` maps a field to a SQL expression rather than a column. The expression is embedded directly into SELECT queries — it's evaluated by the database on every fetch.

```java
@Entity
@Table(name = "employees")
public class Employee {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "salary")
    private BigDecimal salary;

    // Computed field — not a real column
    @Formula("concat(first_name, ' ', last_name)")
    private String fullName;

    // Another computed field using SQL aggregate
    @Formula("(SELECT COUNT(*) FROM orders o WHERE o.employee_id = id)")
    private int orderCount;

    // Conditional computation
    @Formula("CASE WHEN salary > 100000 THEN 'senior' ELSE 'junior' END")
    private String tier;
}
```

### 2.2 Generated SQL

When you load an Employee, Hibernate generates:

```sql
SELECT
    e.id,
    e.first_name,
    e.last_name,
    e.salary,
    concat(e.first_name, ' ', e.last_name) AS full_name,      -- @Formula
    (SELECT COUNT(*) FROM orders o WHERE o.employee_id = e.id) AS order_count,  -- @Formula
    CASE WHEN e.salary > 100000 THEN 'senior' ELSE 'junior' END AS tier         -- @Formula
FROM employees e
WHERE e.id = ?
```

### 2.3 Important Limitations

```java
// 1. READ-ONLY: @Formula fields cannot be written to the database
employee.setFullName("Alice Smith"); // silently ignored on persist/update

// 2. Not available in JPQL WHERE clauses directly
// WRONG:
entityManager.createQuery("FROM Employee e WHERE e.fullName = :name", Employee.class)
    .setParameter("name", "Alice Smith")
    .getResultList();
// Error: fullName is not a persistent property (it's virtual)

// CORRECT: use the original columns in JPQL
entityManager.createQuery(
    "FROM Employee e WHERE concat(e.firstName, ' ', e.lastName) = :name",
    Employee.class)
    .setParameter("name", "Alice Smith")
    .getResultList();

// 3. SQL is vendor-specific — use portable SQL or profile per DB
// PostgreSQL: concat(), string_agg(), etc.
// MySQL: CONCAT(), GROUP_CONCAT()
// Oracle: ||, LISTAGG()
```

### 2.4 Practical Use Cases

```java
@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue
    private Long id;

    private String name;
    private BigDecimal basePrice;
    private BigDecimal taxRate;

    // Total price computed in DB — always consistent
    @Formula("base_price * (1 + tax_rate)")
    private BigDecimal totalPrice;

    // Whether product is in stock (based on related inventory table)
    @Formula("(SELECT COALESCE(SUM(i.quantity), 0) FROM inventory i WHERE i.product_id = id) > 0")
    private boolean inStock;

    // Days since last sale
    @Formula("(SELECT EXTRACT(day FROM NOW() - MAX(o.created_at)) " +
              "FROM order_items oi JOIN orders o ON o.id = oi.order_id " +
              "WHERE oi.product_id = id)")
    private Integer daysSinceLastSale;
}
```

---

## 3. `@Where` — Default Entity Filter (Soft Delete)

### 3.1 What `@Where` Does

`@Where` adds a SQL condition that is **automatically appended to every query** involving the entity. The clause is invisible to the application code — Hibernate always adds it.

### 3.2 Soft Delete Pattern

```java
@Entity
@Table(name = "users")
@Where(clause = "deleted = false")      // always appended — "deleted users" are invisible
public class User {

    @Id
    @GeneratedValue
    private Long id;

    private String username;
    private String email;

    @Column(nullable = false)
    private boolean deleted = false;    // soft delete flag

    @Column
    private Instant deletedAt;

    // "delete" a user: just set the flag
    public void softDelete() {
        this.deleted = true;
        this.deletedAt = Instant.now();
    }
}
```

### 3.3 What SQL Hibernate Generates

```sql
-- Regular find — @Where clause is automatically added
SELECT u.* FROM users u WHERE u.id = ?
-- becomes:
SELECT u.* FROM users u WHERE u.id = ? AND u.deleted = false

-- JPQL query — @Where clause still added
SELECT u FROM User u WHERE u.username = :username
-- becomes:
SELECT u.* FROM users u WHERE u.username = ? AND u.deleted = false

-- findAll() — @Where clause still added
SELECT u.* FROM users u WHERE u.deleted = false

-- Spring Data repository methods — @Where clause still added
userRepository.findAll()
-- SELECT u.* FROM users u WHERE u.deleted = false
```

### 3.4 Relationships and `@Where`

`@Where` on a collection prevents loading deleted items:

```java
@Entity
@Table(name = "departments")
public class Department {

    @Id
    @GeneratedValue
    private Long id;

    private String name;

    @OneToMany(mappedBy = "department")
    @Where(clause = "deleted = false")    // @Where on the collection
    private List<Employee> activeEmployees;
}

// The @Where on Employee class also applies — double protection
// But the collection @Where is independent of the entity @Where
```

### 3.5 Bypassing `@Where` When Needed

`@Where` is always applied — there is no built-in "bypass" for the entity level:

```java
// To find ALL users including deleted: use native SQL
@Query(value = "SELECT * FROM users", nativeQuery = true)
List<User> findAllIncludingDeleted();  // @Where is NOT applied to native queries

// Or use a separate entity class for "full access":
@Entity
@Table(name = "users")
// No @Where annotation
public class UserAdmin {
    // same fields...
    // Use this entity class only in admin operations
}

// Or: use Hibernate @Filter (toggleable — see Section 4)
// @Where is static — @Filter can be turned on/off per session
```

### 3.6 `@WhereJoinTable` — for Join Tables

```java
@Entity
public class User {

    @ManyToMany
    @JoinTable(name = "user_roles",
               joinColumns = @JoinColumn(name = "user_id"),
               inverseJoinColumns = @JoinColumn(name = "role_id"))
    @WhereJoinTable(clause = "active = true")  // filter on the join table itself
    private Set<Role> roles;
}
```

---

## 4. `@Filter` and `@FilterDef` — Dynamic Toggleable Filters

### 4.1 `@Filter` vs `@Where`

| Feature | `@Where` | `@Filter` |
|---|---|---|
| **Toggle** | Always on, no toggle | Enable/disable per session |
| **Parameters** | No — static SQL | Yes — parameterized |
| **Use case** | Permanent soft delete | Multi-tenancy, date ranges, user-visible filters |
| **Activation** | Automatic | Manual: `session.enableFilter()` |

### 4.2 Defining a Filter

```java
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;

// Step 1: Define the filter at the entity level (or package-level)
// @FilterDef declares the filter name and parameters
@FilterDef(
    name = "tenantFilter",
    parameters = @ParamDef(name = "tenantId", type = Long.class),
    defaultCondition = "tenant_id = :tenantId"  // Hibernate 6
)
@FilterDef(
    name = "activeFilter"
    // no parameters — simple boolean filter
)
@Entity
@Table(name = "orders")
@Filter(name = "tenantFilter")    // Step 2: apply filter to entity
@Filter(name = "activeFilter", condition = "status != 'CANCELLED'")
public class Order {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "tenant_id")
    private Long tenantId;

    private String status;
    private BigDecimal total;
}
```

### 4.3 Enabling Filters Per Session

```java
import org.hibernate.Filter;
import org.hibernate.Session;

// Enable filter for the current session
Session session = entityManager.unwrap(Session.class);

// Enable tenant filter with parameter
Filter tenantFilter = session.enableFilter("tenantFilter");
tenantFilter.setParameter("tenantId", currentTenantId);  // parameter binding

// Enable simple filter (no params)
session.enableFilter("activeFilter");

// Now queries are filtered:
List<Order> orders = entityManager.createQuery("FROM Order", Order.class)
    .getResultList();
// SELECT o.* FROM orders o
// WHERE o.tenant_id = ?        ← tenantFilter
// AND o.status != 'CANCELLED'  ← activeFilter

// Disable filter for this session
session.disableFilter("tenantFilter");
```

### 4.4 Multi-Tenancy with `@Filter`

```java
// Complete multi-tenancy example

@FilterDef(
    name = "tenantFilter",
    parameters = @ParamDef(name = "tenantId", type = Long.class)
)
@Entity
@Filter(name = "tenantFilter", condition = "tenant_id = :tenantId")
public class Product {
    @Id @GeneratedValue private Long id;
    @Column(name = "tenant_id") private Long tenantId;
    private String name;
    private BigDecimal price;
}

// Spring interceptor: enable filter on every request
@Component
public class TenantFilterInterceptor {

    @PersistenceContext
    private EntityManager entityManager;

    @Before("execution(* com.myapp.service.*.*(..))")
    public void enableTenantFilter() {
        Long tenantId = TenantContext.getCurrentTenantId();
        if (tenantId != null) {
            Session session = entityManager.unwrap(Session.class);
            session.enableFilter("tenantFilter")
                   .setParameter("tenantId", tenantId);
        }
    }
}
```

### 4.5 Filtering Collections

```java
@Entity
public class Category {
    @Id @GeneratedValue private Long id;
    private String name;

    @OneToMany(mappedBy = "category")
    @Filter(name = "activeFilter", condition = "status != 'CANCELLED'")
    private List<Order> orders;
}
// When filter is enabled: loading category.getOrders() only returns active orders
// When filter is disabled: all orders returned
```

---

## 5. `@Type` and Custom `UserType`

### 5.1 What `@Type` Does

`@Type` tells Hibernate how to map a Java type to a database column type. Hibernate has built-in types for standard mappings. For custom types, you implement `UserType`.

### 5.2 Built-in Type Override Examples

```java
@Entity
public class Settings {

    @Id @GeneratedValue
    private Long id;

    // Store a Duration as a BIGINT (seconds)
    @Column(name = "timeout_seconds")
    @Type(DurationType.class)  // custom or use org.hibernate.type.descriptor.java.DurationJavaType
    private Duration timeout;

    // Store a JSON blob as TEXT
    @Column(name = "metadata", columnDefinition = "jsonb")
    @Type(io.hypersistence.utils.hibernate.type.json.JsonBinaryType.class)
    private Map<String, Object> metadata;
}
```

### 5.3 Implementing a Custom `UserType` (Hibernate 6)

In Hibernate 6, `UserType` is a generic interface. Example: mapping a `MonetaryAmount` (amount + currency) to two DB columns:

```java
import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.usertype.UserType;
import java.io.Serializable;
import java.sql.*;

public class MonetaryAmountType implements UserType<MonetaryAmount> {

    @Override
    public int getSqlType() {
        return Types.NUMERIC; // primary type hint (we override further below)
    }

    @Override
    public Class<MonetaryAmount> returnedClass() {
        return MonetaryAmount.class;
    }

    @Override
    public boolean equals(MonetaryAmount x, MonetaryAmount y) {
        if (x == y) return true;
        if (x == null || y == null) return false;
        return x.equals(y);
    }

    @Override
    public int hashCode(MonetaryAmount x) {
        return x == null ? 0 : x.hashCode();
    }

    @Override
    public MonetaryAmount nullSafeGet(ResultSet rs, int position,
            SharedSessionContractImplementor session, Object owner)
            throws SQLException {
        BigDecimal amount   = rs.getBigDecimal(position);      // column 1: amount
        String currencyCode = rs.getString(position + 1);      // column 2: currency
        if (rs.wasNull() || amount == null || currencyCode == null) return null;
        return new MonetaryAmount(amount, Currency.getInstance(currencyCode));
    }

    @Override
    public void nullSafeSet(PreparedStatement st, MonetaryAmount value,
            int index, SharedSessionContractImplementor session)
            throws SQLException {
        if (value == null) {
            st.setNull(index,     Types.NUMERIC);
            st.setNull(index + 1, Types.VARCHAR);
        } else {
            st.setBigDecimal(index,     value.getAmount());
            st.setString(index + 1, value.getCurrency().getCurrencyCode());
        }
    }

    @Override
    public MonetaryAmount deepCopy(MonetaryAmount value) {
        return value; // MonetaryAmount is immutable — return same instance
    }

    @Override
    public boolean isMutable() {
        return false; // immutable — no need to copy
    }

    @Override
    public Serializable disassemble(MonetaryAmount value) {
        return value; // for second-level cache serialization
    }

    @Override
    public MonetaryAmount assemble(Serializable cached, Object owner) {
        return (MonetaryAmount) cached;
    }
}
```

```java
// Using the custom type
@Entity
public class Invoice {
    @Id @GeneratedValue private Long id;

    @Type(MonetaryAmountType.class)
    @Columns(columns = {
        @Column(name = "total_amount"),
        @Column(name = "currency_code")
    })
    private MonetaryAmount total;
}
```

### 5.4 Hypersistence Utils — JSON, Arrays, etc.

For common custom types, the **Hypersistence Utils** library (by Vlad Mihalcea) provides ready-made solutions:

```xml
<dependency>
    <groupId>io.hypersistence</groupId>
    <artifactId>hypersistence-utils-hibernate-62</artifactId>
    <version>3.7.3</version>
</dependency>
```

```java
import io.hypersistence.utils.hibernate.type.json.JsonType;

@Entity
@TypeDef(name = "json", typeClass = JsonType.class)  // Hibernate 5 style
public class UserProfile {

    @Id @GeneratedValue private Long id;

    // Hibernate 6 style: @Type directly
    @Type(JsonType.class)
    @Column(name = "preferences", columnDefinition = "jsonb")
    private Map<String, Object> preferences;

    @Type(JsonType.class)
    @Column(name = "tags", columnDefinition = "jsonb")
    private List<String> tags;

    @Type(JsonType.class)
    @Column(name = "address", columnDefinition = "jsonb")
    private Address address; // POJO stored as JSON
}
```

---

## 6. `@BatchSize` — Batch Fetching

### 6.1 The N+1 Problem

Without batch fetching, loading a collection for multiple entities causes N+1 queries:

```java
// Loading 100 departments with their employees:
List<Department> departments = departmentRepo.findAll(); // 1 query
// Then accessing employees triggers N queries:
for (Department dept : departments) {
    System.out.println(dept.getEmployees().size()); // 1 query per department
}
// Total: 1 + 100 = 101 queries — N+1 problem!
```

### 6.2 `@BatchSize` on Collections

```java
@Entity
public class Department {

    @Id @GeneratedValue
    private Long id;
    private String name;

    @OneToMany(mappedBy = "department", fetch = FetchType.LAZY)
    @BatchSize(size = 20)    // load employees in batches of 20 departments
    private List<Employee> employees;
}
```

**What Hibernate does:**

```sql
-- Step 1: Load all departments
SELECT d.* FROM departments d;
-- Returns 100 departments

-- Step 2: First access to employees triggers a batch load
-- (not 1 query per dept, but 1 query per 20 depts)
SELECT e.* FROM employees e WHERE e.department_id IN (1,2,3,4,5,...,20); -- batch 1
SELECT e.* FROM employees e WHERE e.department_id IN (21,22,...,40);       -- batch 2
...
SELECT e.* FROM employees e WHERE e.department_id IN (81,82,...,100);      -- batch 5

-- Total: 1 + 5 = 6 queries instead of 101 queries!
```

### 6.3 `@BatchSize` on Entity Class

When `@BatchSize` is placed on the entity class itself, it controls how many entities of that type are loaded when initializing proxies:

```java
@Entity
@BatchSize(size = 50)   // on the entity class: batch-load proxies
public class Employee {
    @Id @GeneratedValue private Long id;
    private String name;
    // ...
}

// Scenario: Order has a @ManyToOne Employee (manager)
// Loading 100 orders with lazy manager proxies:
List<Order> orders = orderRepo.findAll(); // 1 query
for (Order o : orders) {
    o.getManager().getName(); // triggers proxy initialization
}
// Without @BatchSize: 100 queries (one per manager)
// With @BatchSize(50): 2 queries
// SELECT e.* FROM employees e WHERE e.id IN (id1, id2, ..., id50)
// SELECT e.* FROM employees e WHERE e.id IN (id51, id52, ..., id100)
```

### 6.4 Global Batch Size Configuration

```yaml
# application.yml — set default batch size for all collections
spring:
  jpa:
    properties:
      hibernate:
        default_batch_fetch_size: 20   # applied to all lazy collections
        # This is often the best first step to reduce N+1 queries
```

```java
// @BatchSize overrides the global default for that specific collection
@OneToMany(mappedBy = "department")
@BatchSize(size = 5)  // override global default of 20 for this collection
private List<Employee> employees;
```

### 6.5 Choosing the Right Batch Size

```
Rule of thumb:
  - Default: 20-50 for most applications
  - Small collections (< 5 elements average): 10-25
  - Large collections: 50-100
  - Very hot collection: consider JOIN FETCH instead

Trade-offs:
  Large batch size:  fewer queries, more data per query, more memory
  Small batch size:  more queries, less data per query, less memory

SQL IN clause limit:
  Oracle: 1000 items max in IN clause
  PostgreSQL/MySQL: very large limits (effectively unlimited)
  Hibernate honors the limit for Oracle automatically
```

---

## 7. `@Fetch(FetchMode.SUBSELECT)` — Subselect Fetching

### 7.1 How SUBSELECT Differs from BATCH

- **BATCH**: Loads collections using `WHERE id IN (batch_of_ids)` — multiple queries
- **SUBSELECT**: Loads all collections using a single subquery — one query

```java
@Entity
public class Department {
    @Id @GeneratedValue private Long id;
    private String name;

    @OneToMany(mappedBy = "department", fetch = FetchType.LAZY)
    @Fetch(FetchMode.SUBSELECT)    // load ALL employee collections in ONE query
    private List<Employee> employees;
}
```

**Generated SQL:**

```sql
-- Step 1: Load departments
SELECT d.* FROM departments d WHERE d.region = 'WEST';
-- Returns: department IDs [1, 4, 7, 12, 15]

-- Step 2: First access to ANY department's employees triggers ONE query for ALL:
SELECT e.*
FROM employees e
WHERE e.department_id IN (
    SELECT d.id FROM departments d WHERE d.region = 'WEST'
    -- ↑ The ORIGINAL query is embedded as a subselect!
);
-- All employees for all 5 departments loaded in one round-trip
```

### 7.2 SUBSELECT vs BATCH Comparison

| Aspect | BATCH | SUBSELECT |
|---|---|---|
| **Queries** | Ceil(N / batch_size) | Always exactly 2 |
| **Memory** | Load in increments | Load all at once |
| **Flexibility** | Can partial-load | All-or-nothing |
| **Original query used** | No — uses IN list | Yes — embedded as subselect |
| **Best for** | When you access some, not all | When you access all collections |

```java
// When to use SUBSELECT:
// - You consistently access ALL entities' collections
// - Collection is relatively small
// - You want the guaranteed "2 queries total" behavior

// When to use BATCH:
// - You access a subset of entities' collections
// - Collections are potentially large (batch limits memory per query)
// - You want configurable batching granularity
```

### 7.3 FetchMode Options Summary

```java
// FetchMode.SELECT (default for lazy): separate SELECT per collection access
@Fetch(FetchMode.SELECT)    // N+1 if no @BatchSize

// FetchMode.JOIN: use JOIN in the parent query (makes it EAGER effectively)
@Fetch(FetchMode.JOIN)      // use with care — can cause massive result set

// FetchMode.SUBSELECT: single query using the parent query as subselect
@Fetch(FetchMode.SUBSELECT) // 2 queries total regardless of parent result size
```

---

## 8. Hibernate Envers — Entity Auditing

### 8.1 What Envers Does

Hibernate Envers automatically tracks every **create, update, and delete** of an entity by maintaining a separate audit table. It records the state of the entity at each revision.

```xml
<!-- Maven -->
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-envers</artifactId>
</dependency>

<!-- Spring Boot -->
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-envers</artifactId>
</dependency>
```

### 8.2 Basic Auditing

```java
import org.hibernate.envers.Audited;

@Entity
@Table(name = "products")
@Audited                              // enable auditing for this entity
public class Product {

    @Id @GeneratedValue
    private Long id;

    @Audited                          // individual field (if not all class)
    private String name;

    @Audited
    private BigDecimal price;

    @NotAudited                       // exclude this field from audit trail
    private int viewCount;            // view count changes too frequently

    private boolean active;           // @Audited on class means this is also audited
}
```

### 8.3 What Envers Creates in the Database

```sql
-- Envers creates these tables automatically:

-- Revision information table (one row per transaction that changed audited entities)
CREATE TABLE revinfo (
    rev     INTEGER NOT NULL PRIMARY KEY,
    revtstmp BIGINT                       -- timestamp of the revision
);

-- Audit table for Product (named: {entity_table}_aud)
CREATE TABLE products_aud (
    id      BIGINT  NOT NULL,
    rev     INTEGER NOT NULL REFERENCES revinfo(rev),
    revtype SMALLINT,                     -- 0=ADD, 1=MOD, 2=DEL
    name    VARCHAR(255),
    price   DECIMAL(10,2),
    active  BOOLEAN,
    PRIMARY KEY (id, rev)
);
```

### 8.4 Querying Audit History

```java
import org.hibernate.envers.AuditReader;
import org.hibernate.envers.AuditReaderFactory;
import org.hibernate.envers.query.AuditEntity;

AuditReader reader = AuditReaderFactory.get(entityManager);

// Get all revisions of a specific product
List<Number> revisions = reader.getRevisions(Product.class, productId);
// Returns: [1, 3, 7] — revision numbers where product was changed

// Get the product state AT a specific revision
Product at_revision_3 = reader.find(Product.class, productId, 3);
System.out.println(at_revision_3.getPrice()); // price at revision 3

// Get all states of a product across all revisions
List<Object[]> history = reader.createQuery()
    .forRevisionsOfEntity(Product.class, false, true)
    .add(AuditEntity.id().eq(productId))
    .getResultList();

for (Object[] entry : history) {
    Product state        = (Product) entry[0];        // entity state
    DefaultRevisionEntity revision = (DefaultRevisionEntity) entry[1]; // revision info
    RevisionType revType = (RevisionType) entry[2];   // ADD, MOD, or DEL

    System.out.printf("Rev %d at %s: %s - price=%s%n",
        revision.getId(),
        new Date(revision.getTimestamp()),
        revType,
        state.getPrice()
    );
}

// Find all products modified in a specific revision range
List<Product> changedBetween = reader.createQuery()
    .forEntitiesModifiedAtRevision(Product.class, 5)
    .getResultList();

// Find when a specific field changed
List<Object[]> priceChanges = reader.createQuery()
    .forRevisionsOfEntity(Product.class, false, true)
    .add(AuditEntity.id().eq(productId))
    .add(AuditEntity.property("price").hasChanged())
    .getResultList();
```

### 8.5 Custom Revision Entity

```java
// Add extra info to revision records (who made the change)
@Entity
@RevisionEntity(CustomRevisionListener.class)
@Table(name = "revinfo")
public class CustomRevisionEntity extends DefaultRevisionEntity {

    @Column(name = "changed_by")
    private String changedBy;

    @Column(name = "ip_address")
    private String ipAddress;

    // getters, setters
}

public class CustomRevisionListener implements RevisionListener {

    @Override
    public void newRevision(Object revisionEntity) {
        CustomRevisionEntity rev = (CustomRevisionEntity) revisionEntity;
        // Get current user from security context
        rev.setChangedBy(SecurityContextHolder.getContext()
            .getAuthentication().getName());
        rev.setIpAddress(RequestContextHolder.currentRequestAttributes()
            .getAttribute("remoteAddr", 0).toString());
    }
}
```

### 8.6 Spring Data Envers

```java
// Spring Data repository with audit query support
import org.springframework.data.repository.history.RevisionRepository;

public interface ProductRepository
        extends JpaRepository<Product, Long>,
                RevisionRepository<Product, Long, Integer> {
    // RevisionRepository adds:
    // findLastChangeRevision(id)
    // findRevisions(id)
    // findRevision(id, revisionNumber)
    // findRevisions(id, pageable)
}

// Usage:
Optional<Revision<Integer, Product>> lastChange =
    productRepository.findLastChangeRevision(productId);

lastChange.ifPresent(rev -> {
    System.out.println("Last changed at: " + rev.getRequiredRevisionInstant());
    System.out.println("By revision: " + rev.getRevisionNumber());
    System.out.println("Product name: " + rev.getEntity().getName());
});

Page<Revision<Integer, Product>> allRevisions =
    productRepository.findRevisions(productId, PageRequest.of(0, 10));
```

---

## 9. Hibernate Statistics

### 9.1 Enabling Statistics

```yaml
# application.yml
spring:
  jpa:
    properties:
      hibernate:
        generate_statistics: true          # enable statistics collection
        session.events.log.LOG_QUERIES_SLOWER_THAN_MS: 25  # log slow queries
```

```java
// Or programmatically:
SessionFactory sessionFactory = entityManager.getEntityManagerFactory()
    .unwrap(SessionFactory.class);
sessionFactory.getStatistics().setStatisticsEnabled(true);
```

### 9.2 Key Statistics Metrics

```java
Statistics stats = sessionFactory.getStatistics();

// Query statistics
System.out.println("Total queries executed: "        + stats.getQueryExecutionCount());
System.out.println("Slowest query (ms): "            + stats.getQueryExecutionMaxTime());
System.out.println("Slowest query string: "          + stats.getQueryExecutionMaxTimeQueryString());

// Entity statistics
System.out.println("Entities loaded: "               + stats.getEntityLoadCount());
System.out.println("Entities fetched (proxy init): " + stats.getEntityFetchCount());
System.out.println("Entities inserted: "             + stats.getEntityInsertCount());
System.out.println("Entities updated: "              + stats.getEntityUpdateCount());
System.out.println("Entities deleted: "              + stats.getEntityDeleteCount());

// Collection statistics
System.out.println("Collections loaded: "            + stats.getCollectionLoadCount());
System.out.println("Collections fetched: "           + stats.getCollectionFetchCount());

// Second-level cache
System.out.println("L2 cache hit rate: "             + stats.getSecondLevelCacheHitCount()
    + "/" + (stats.getSecondLevelCacheHitCount() + stats.getSecondLevelCacheMissCount()));
System.out.println("L2 cache puts: "                 + stats.getSecondLevelCachePutCount());

// Query cache
System.out.println("Query cache hits: "              + stats.getQueryCacheHitCount());
System.out.println("Query cache misses: "            + stats.getQueryCacheMissCount());

// Connection statistics
System.out.println("Database connections obtained: " + stats.getConnectCount());
System.out.println("Transactions completed: "        + stats.getTransactionCount());

// Reset statistics
stats.clear();
```

### 9.3 Per-Entity and Per-Query Statistics

```java
// Statistics for a specific entity type
EntityStatistics entityStats = stats.getEntityStatistics(Product.class.getName());
System.out.println("Product loads: " + entityStats.getLoadCount());
System.out.println("Product fetches: " + entityStats.getFetchCount());

// Statistics for a specific query
QueryStatistics queryStats = stats.getQueryStatistics(
    "select p from Product p where p.category = :cat");
System.out.println("Execution count: " + queryStats.getExecutionCount());
System.out.println("Avg execution time: " + queryStats.getExecutionAvgTime() + "ms");
System.out.println("Max execution time: " + queryStats.getExecutionMaxTime() + "ms");
System.out.println("Rows processed: " + queryStats.getExecutionRowCount());

// Per-region L2 cache stats
SecondLevelCacheStatistics l2 = stats.getSecondLevelCacheStatistics(
    "com.myapp.entity.Product");
System.out.println("Cache size (entries): " + l2.getElementCountInMemory());
System.out.println("Cache hit ratio: " + l2.getHitCount() + "/" + l2.getMissCount());
```

### 9.4 Statistics in Tests — Detecting N+1 Problems

```java
// In tests: assert no N+1 queries occur
@SpringBootTest
class ProductServiceTest {

    @Autowired
    private SessionFactory sessionFactory;

    @Test
    void loadProductsWithCategories_shouldNotCauseNPlusOneQueries() {
        Statistics stats = sessionFactory.getStatistics();
        stats.clear();

        // Execute the operation under test
        productService.getAllProductsWithCategories();

        // Assert query count
        long queryCount = stats.getQueryExecutionCount();
        assertThat(queryCount)
            .as("Should load products and categories in at most 2 queries")
            .isLessThanOrEqualTo(2);

        // Detailed diagnostics on failure
        if (queryCount > 2) {
            System.err.println("Slowest query: " + stats.getQueryExecutionMaxTimeQueryString());
        }
    }
}
```

### 9.5 Exposing Statistics via JMX / Actuator

```java
// Statistics are automatically exposed via JMX as Hibernate MBeans
// In VisualVM/JConsole: Hibernate > Statistics > SessionFactory

// Spring Boot Actuator endpoint:
@Component
public class HibernateStatsEndpoint {

    @Autowired
    private EntityManagerFactory emf;

    @ReadOperation
    public Map<String, Object> hibernateStats() {
        Statistics stats = emf.unwrap(SessionFactory.class).getStatistics();
        return Map.of(
            "queryCount",           stats.getQueryExecutionCount(),
            "entityLoadCount",      stats.getEntityLoadCount(),
            "collectionFetchCount", stats.getCollectionFetchCount(),
            "l2CacheHitCount",      stats.getSecondLevelCacheHitCount(),
            "l2CacheMissCount",     stats.getSecondLevelCacheMissCount()
        );
    }
}
```

---

## 10. Hibernate 6 Features

### 10.1 Jakarta Namespace Migration

Hibernate 6 migrated from `javax.*` to `jakarta.*` namespace (Jakarta EE 9+):

```java
// Hibernate 5 / Java EE:
import javax.persistence.*;
import javax.persistence.EntityManager;
import javax.persistence.Query;

// Hibernate 6 / Jakarta EE 10:
import jakarta.persistence.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;

// Hibernate-specific annotations: namespace unchanged
import org.hibernate.annotations.*;  // still org.hibernate, not javax/jakarta
```

```xml
<!-- Spring Boot 3.x uses Hibernate 6 + Jakarta automatically -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.0</version>  <!-- Uses Hibernate 6 + Jakarta EE 10 -->
</parent>
```

### 10.2 `@TimeZoneStorage` — Time Zone Handling

Hibernate 6 adds explicit control over how time zone information is stored:

```java
import org.hibernate.annotations.TimeZoneStorage;
import org.hibernate.annotations.TimeZoneStorageType;

@Entity
public class Event {
    @Id @GeneratedValue private Long id;

    // NATIVE (Hibernate 6 default): use DB-native type (TIMESTAMP WITH TIME ZONE)
    // Best for PostgreSQL, Oracle 21c+, SQL Server 2016+
    @TimeZoneStorage(TimeZoneStorageType.NATIVE)
    @Column(name = "event_time")
    private OffsetDateTime eventTime;

    // NORMALIZE: store as UTC, discard time zone info
    // Best for DBs without native TZ support (MySQL 5.7, older SQLite)
    @TimeZoneStorage(TimeZoneStorageType.NORMALIZE)
    @Column(name = "created_at")
    private OffsetDateTime createdAt;

    // COLUMN: store the offset as a separate column
    // Preserves the original time zone without DB native support
    @TimeZoneStorage(TimeZoneStorageType.COLUMN)
    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;
    // Generates TWO columns: updated_at (TIMESTAMP) + updated_at_tz (VARCHAR/INT for offset)

    // AUTO (Hibernate 6): automatically select best strategy per dialect
    @TimeZoneStorage(TimeZoneStorageType.AUTO)
    private ZonedDateTime scheduledAt;
}
```

```yaml
# Global default timezone storage strategy
spring:
  jpa:
    properties:
      hibernate:
        timezone:
          default_storage: NATIVE   # or NORMALIZE, COLUMN, AUTO
```

### 10.3 Improved `@Array` Support (Hibernate 6.1+)

```java
import org.hibernate.annotations.Array;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
public class UserProfile {
    @Id @GeneratedValue private Long id;

    // PostgreSQL ARRAY type mapping (Hibernate 6.1+)
    @Array(length = 10)   // max array length for DDL generation
    @Column(name = "phone_numbers", columnDefinition = "varchar(20)[]")
    private String[] phoneNumbers;

    // JSON array stored as JSONB
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "tags", columnDefinition = "jsonb")
    private List<String> tags;

    // Integer array
    @Array(length = 100)
    @Column(name = "score_history", columnDefinition = "integer[]")
    private int[] scoreHistory;
}
```

```sql
-- Generated DDL for PostgreSQL
CREATE TABLE user_profiles (
    id              BIGSERIAL    PRIMARY KEY,
    phone_numbers   varchar(20)[] ,
    tags            jsonb        ,
    score_history   integer[]
);

-- Query using array contains operator
SELECT * FROM user_profiles WHERE 'mobile' = ANY(phone_numbers);
```

### 10.4 Improved HQL/JPQL — `where()` Method in Criteria API

```java
// Hibernate 6: new Criteria API improvements
CriteriaBuilder cb = entityManager.getCriteriaBuilder();
CriteriaQuery<Product> cq = cb.createQuery(Product.class);
Root<Product> root = cq.from(Product.class);

// New: .where() with multiple predicates (Hibernate 6)
cq.where(
    cb.greaterThan(root.get("price"), 100),
    cb.equal(root.get("active"), true),
    cb.like(root.get("name"), "%Widget%")
);

// New HQL: EXTRACT, FORMAT, CAST improvements
List<Product> products = entityManager.createQuery(
    "FROM Product p WHERE EXTRACT(YEAR FROM p.createdAt) = :year", Product.class)
    .setParameter("year", 2024)
    .getResultList();

// New HQL: CAST
entityManager.createQuery(
    "SELECT CAST(p.price AS string) FROM Product p", String.class)
    .getResultList();
```

### 10.5 Other Hibernate 6 Improvements

```java
// 1. SQM (Semantic Query Model) — new internal query model
//    Better type-safety, more SQL function support, improved HQL
//    Most changes are internal — no API change required

// 2. @PartitionKey — for DB partitioning support
@Entity
@Table(name = "events")
public class EventRecord {
    @Id @GeneratedValue private Long id;

    @PartitionKey
    @Column(name = "partition_key")
    private String partitionKey;  // included in WHERE clauses for partition pruning
}

// 3. @Struct — for structured (composite) SQL types (Hibernate 6.2+)
// Maps a Java record to a SQL structured type
@Embeddable
@Struct(name = "address_type")  // SQL STRUCT type name
public record AddressStruct(
    String street,
    String city,
    String postalCode
) {}

// 4. @TenantId — built-in multi-tenancy support (Hibernate 6.2+)
@Entity
public class Order {
    @Id @GeneratedValue private Long id;

    @TenantId
    private String tenantId;  // automatically filtered based on current tenant
}

// 5. Improved dirty tracking — bytecode enhancement for change detection
// No longer needs reflection for state comparison
// Enabled via: hibernate.enhancer.enableDirtyTracking=true

// 6. Stateless sessions — for bulk operations without session cache
StatelessSession stateless = sessionFactory.openStatelessSession();
try {
    Transaction tx = stateless.beginTransaction();
    // Bulk insert without session cache overhead
    for (int i = 0; i < 1_000_000; i++) {
        stateless.insert(new LogEntry("event-" + i));
    }
    tx.commit();
} finally {
    stateless.close();
}
```

---

## 11. Quick Reference Cheat Sheet

### Annotation Summary

```java
// Business key with cache support
@NaturalId                       // on field: immutable natural key
@NaturalId(mutable = true)       // on field: changeable natural key
@NaturalIdCache                  // on class: enable L2 cache for natural IDs

// Computed field from SQL expression
@Formula("SQL EXPRESSION")       // on field: read-only DB-computed value

// Static filter (always applied)
@Where(clause = "SQL CONDITION") // on class or collection

// Dynamic filter (toggle per session)
@FilterDef(name = "name", parameters = @ParamDef(name = "p", type = Long.class))
@Filter(name = "name", condition = "col = :p")  // on class or collection

// Custom type mapping
@Type(MyUserType.class)          // on field

// N+1 mitigation
@BatchSize(size = 20)            // on collection or entity class
@Fetch(FetchMode.SUBSELECT)      // on collection: all collections in one subquery
@Fetch(FetchMode.JOIN)           // on collection: JOIN in parent query (eager-like)

// Auditing
@Audited                         // on class or field: track all changes
@NotAudited                      // on field: exclude from audit trail
@RevisionEntity                  // on revision info class

// Hibernate 6
@TimeZoneStorage(TimeZoneStorageType.NATIVE)  // on OffsetDateTime/ZonedDateTime field
@Array(length = N)               // on array field: DB ARRAY type
```

### Natural ID Lookup API

```java
session.bySimpleNaturalId(Product.class).load("SKU-001");
session.byNaturalId(Translation.class)
       .using("locale", "en").using("key", "msg").load();
```

### Filter Toggle

```java
session.enableFilter("filterName").setParameter("param", value);
session.disableFilter("filterName");
```

### Statistics Checks

```java
stats.getQueryExecutionCount()   // total SQL queries
stats.getEntityFetchCount()      // proxy initializations (N+1 indicator)
stats.getCollectionFetchCount()  // collection loads
stats.getSecondLevelCacheHitCount()  // L2 cache hits
```

### Key Rules to Remember

1. **`@NaturalId` + `@NaturalIdCache`** — always pair them for L2 cache benefit.
2. **`@Formula` is read-only** — never appears in INSERT/UPDATE; can't be used in JPQL WHERE.
3. **`@Where` is invisible and permanent** — native queries bypass it; use `@Filter` when you need a toggle.
4. **`@Filter` must be enabled per session** — forgetting to enable it means no filtering.
5. **`@BatchSize(20)` on everything** — set `default_batch_fetch_size` globally as the simplest N+1 fix.
6. **SUBSELECT uses the original query** — if the parent query changes, the subselect adapts automatically.
7. **Envers `id` is (entity_id, revision)** — the audit table PK; find entity at revision with `reader.find()`.
8. **Statistics are disabled by default** — enable only in dev/staging; overhead in production.
9. **Hibernate 6 = Jakarta namespace** — update all `javax.persistence.*` to `jakarta.persistence.*`.
10. **`@TimeZoneStorage(NATIVE)`** — use for PostgreSQL; avoid for MySQL 5.7 which lacks native TZ support.

---

*End of Hibernate-Specific Features Study Guide — Module 8*
