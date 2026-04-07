# Multi-Tenancy — Complete Study Guide

> **Module 9 | Brutally Detailed Reference**
> Covers all three multi-tenancy strategies (separate database, separate schema, shared schema), Hibernate's `CurrentTenantIdentifierResolver` and `MultiTenantConnectionProvider`, Hibernate 6's `@TenantId`, tenant-aware Flyway migrations, Spring Security integration, and testing patterns. Full working examples for each strategy.

---

## Table of Contents

1. [Multi-Tenancy Overview — Three Strategies](#1-multi-tenancy-overview--three-strategies)
2. [Separate Database Per Tenant](#2-separate-database-per-tenant)
3. [Separate Schema Per Tenant](#3-separate-schema-per-tenant)
4. [Shared Schema with Discriminator Column](#4-shared-schema-with-discriminator-column)
5. [`CurrentTenantIdentifierResolver` — Resolving the Tenant](#5-currenttenantidentifierresolver--resolving-the-tenant)
6. [`MultiTenantConnectionProvider` — Routing Connections](#6-multitenantconnectionprovider--routing-connections)
7. [Hibernate 6 `@TenantId` Annotation](#7-hibernate-6-tenantid-annotation)
8. [Tenant-Aware Flyway Migrations](#8-tenant-aware-flyway-migrations)
9. [Spring Security + Multi-Tenancy](#9-spring-security--multi-tenancy)
10. [Testing Multi-Tenant Applications](#10-testing-multi-tenant-applications)
11. [Choosing a Strategy](#11-choosing-a-strategy)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. Multi-Tenancy Overview — Three Strategies

### 1.1 What Is Multi-Tenancy?

Multi-tenancy means a single application instance serves **multiple independent customers (tenants)**, with each tenant's data isolated from others. The key challenges are:
- **Data isolation** — tenant A must never see tenant B's data
- **Performance** — one tenant's heavy load shouldn't impact others
- **Operations** — migrations, backups, scaling per tenant
- **Cost** — infrastructure cost per tenant

### 1.2 The Three Strategies

```
Strategy 1: Separate Database
─────────────────────────────
  App ──► tenant_a DB (all tables)
      ──► tenant_b DB (all tables)
      ──► tenant_c DB (all tables)

  Isolation:    Strongest — different DBs, different credentials, different backups
  Cost:         Highest — N databases for N tenants
  Migration:    Run Flyway/Liquibase per database
  GDPR/Legal:   Easiest compliance — data physically separate
  Use case:     Healthcare, finance, enterprise SaaS with few large tenants


Strategy 2: Separate Schema
────────────────────────────
  Single DB ──► public.tenants table (tenant registry)
           ──► tenant_a schema (users, orders, products, ...)
           ──► tenant_b schema (users, orders, products, ...)
           ──► tenant_c schema (users, orders, products, ...)

  Isolation:    Strong — DB-level schema separation, separate connections
  Cost:         Moderate — one DB, but N schemas
  Migration:    Run Flyway/Liquibase per schema
  Use case:     Mid-size SaaS, hundreds of tenants, PostgreSQL-based apps


Strategy 3: Shared Schema with Discriminator
─────────────────────────────────────────────
  Single DB, Single Schema:
  users table:   | tenant_id | id | username | email |
  orders table:  | tenant_id | id | total    | status|
  products table:| tenant_id | id | name     | price |

  Isolation:    Weakest — application-enforced only (SQL WHERE clause)
  Cost:         Lowest — one schema, simpler operations
  Migration:    One migration for all tenants simultaneously
  Risk:         Missing WHERE tenant_id = ? → data breach
  Use case:     B2C SaaS, thousands/millions of tenants, simple data model
```

### 1.3 Comparison Matrix

| Aspect | Separate DB | Separate Schema | Shared Schema |
|---|---|---|---|
| **Data isolation** | Physical (OS level) | Logical (DB level) | Application level |
| **Max tenants** | 10s–100s | 100s–1000s | Millions |
| **DB cost** | High (N databases) | Medium (N schemas) | Low (1 schema) |
| **Cross-tenant queries** | Impossible | Difficult | Easy (remove filter) |
| **Per-tenant customization** | Full (different schema) | Per-schema | Hard (shared schema) |
| **Backup granularity** | Per tenant | Per schema | All or nothing |
| **Compliance** | Easiest | Easy | Requires care |
| **Schema migration complexity** | Per-DB | Per-schema | Single migration |
| **Noisy neighbor risk** | None | Low | High |

---

## 2. Separate Database Per Tenant

### 2.1 Architecture

```
Incoming request:  POST /api/orders
   Header: X-Tenant-ID: acme-corp

Application:
  1. Read tenant ID: "acme-corp"
  2. Look up DataSource for "acme-corp"  → DataSource pointing to acme_db
  3. Get connection from acme_db pool
  4. Execute query against acme_db
  5. Return result
```

### 2.2 Tenant DataSource Registry

```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Component
public class TenantDataSourceRegistry {

    private final Map<String, DataSource> dataSources = new ConcurrentHashMap<>();

    // Load all tenant DataSources at startup from configuration
    @PostConstruct
    public void init() {
        tenantRepository.findAllActive().forEach(tenant -> {
            dataSources.put(tenant.getId(), buildDataSource(tenant));
        });
    }

    private DataSource buildDataSource(TenantConfig tenant) {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(tenant.getDbUrl());         // jdbc:postgresql://host/tenant_db
        config.setUsername(tenant.getDbUser());
        config.setPassword(tenant.getDbPassword());
        config.setPoolName("pool-" + tenant.getId());
        config.setMaximumPoolSize(5);                  // smaller pool per tenant
        config.setMinimumIdle(1);
        return new HikariDataSource(config);
    }

    public DataSource getDataSource(String tenantId) {
        DataSource ds = dataSources.get(tenantId);
        if (ds == null) throw new TenantNotFoundException("Unknown tenant: " + tenantId);
        return ds;
    }

    // Dynamic tenant provisioning at runtime
    public void registerTenant(TenantConfig tenant) {
        dataSources.put(tenant.getId(), buildDataSource(tenant));
    }

    public void removeTenant(String tenantId) {
        DataSource ds = dataSources.remove(tenantId);
        if (ds instanceof HikariDataSource hds) {
            hds.close(); // release connection pool
        }
    }
}
```

### 2.3 `MultiTenantConnectionProvider` for Separate Database

```java
import org.hibernate.engine.jdbc.connections.spi.MultiTenantConnectionProvider;

@Component
public class DatabasePerTenantConnectionProvider
        implements MultiTenantConnectionProvider<String> {

    private final TenantDataSourceRegistry registry;

    public DatabasePerTenantConnectionProvider(TenantDataSourceRegistry registry) {
        this.registry = registry;
    }

    @Override
    public Connection getAnyConnection() throws SQLException {
        // Used for schema validation at startup — use a "default" datasource
        return registry.getDataSource("default").getConnection();
    }

    @Override
    public void releaseAnyConnection(Connection connection) throws SQLException {
        connection.close();
    }

    @Override
    public Connection getConnection(String tenantIdentifier) throws SQLException {
        return registry.getDataSource(tenantIdentifier).getConnection();
    }

    @Override
    public void releaseConnection(String tenantIdentifier, Connection connection)
            throws SQLException {
        connection.close(); // returns to HikariCP pool
    }

    @Override
    public boolean supportsAggressiveRelease() {
        return false; // no XA transactions
    }

    @Override
    public boolean isUnwrappableAs(Class<?> unwrapType) {
        return false;
    }

    @Override
    public <T> T unwrap(Class<T> unwrapType) {
        return null;
    }
}
```

---

## 3. Separate Schema Per Tenant

### 3.1 Architecture

```
PostgreSQL database: saas_platform
  Schema: public         — tenant registry, shared config
  Schema: tenant_acme    — acme corp's data
  Schema: tenant_globex  — globex corp's data
  Schema: tenant_initech — initech's data

All schemas have identical table structure.
Tenant isolation enforced by PostgreSQL search_path.
```

### 3.2 `MultiTenantConnectionProvider` for Separate Schema

```java
@Component
public class SchemaPerTenantConnectionProvider
        implements MultiTenantConnectionProvider<String> {

    private final DataSource dataSource; // single DataSource to the shared DB

    public SchemaPerTenantConnectionProvider(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Connection getAnyConnection() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    public void releaseAnyConnection(Connection connection) throws SQLException {
        connection.close();
    }

    @Override
    public Connection getConnection(String tenantIdentifier) throws SQLException {
        Connection connection = dataSource.getConnection();
        // Set schema for this connection — PostgreSQL approach
        setSchema(connection, tenantIdentifier);
        return connection;
    }

    private void setSchema(Connection connection, String tenantId) throws SQLException {
        // Validate tenant ID to prevent SQL injection — CRITICAL
        if (!tenantId.matches("[a-zA-Z0-9_]+")) {
            throw new IllegalArgumentException("Invalid tenant ID: " + tenantId);
        }

        // PostgreSQL: set search_path for this connection
        try (Statement stmt = connection.createStatement()) {
            stmt.execute("SET search_path TO tenant_" + tenantId + ", public");
        }

        // MySQL/MariaDB approach:
        // stmt.execute("USE tenant_" + tenantId);

        // Oracle approach:
        // stmt.execute("ALTER SESSION SET CURRENT_SCHEMA = TENANT_" + tenantId.toUpperCase());
    }

    @Override
    public void releaseConnection(String tenantIdentifier, Connection connection)
            throws SQLException {
        // IMPORTANT: reset schema before returning to pool
        // so the connection doesn't leak the tenant context
        try (Statement stmt = connection.createStatement()) {
            stmt.execute("SET search_path TO public");
        }
        connection.close();
    }

    @Override
    public boolean supportsAggressiveRelease() {
        return true; // connection can be released aggressively (returned to pool sooner)
    }

    // ...
}
```

### 3.3 Hibernate Configuration for Schema-Based Multi-Tenancy

```java
@Configuration
public class HibernateMultiTenantConfig {

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(
            DataSource dataSource,
            SchemaPerTenantConnectionProvider connectionProvider,
            TenantIdentifierResolver tenantResolver) {

        LocalContainerEntityManagerFactoryBean em =
            new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.myapp.entity");

        HibernateJpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(adapter);

        Properties jpaProperties = new Properties();
        jpaProperties.put("hibernate.multiTenancy", "SCHEMA");       // or DATABASE
        jpaProperties.put("hibernate.multi_tenant_connection_provider", connectionProvider);
        jpaProperties.put("hibernate.tenant_identifier_resolver", tenantResolver);
        jpaProperties.put("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
        jpaProperties.put("hibernate.hbm2ddl.auto", "validate");     // no auto-DDL
        em.setJpaProperties(jpaProperties);

        return em;
    }
}
```

```yaml
# application.yml equivalent
spring:
  jpa:
    properties:
      hibernate:
        multiTenancy: SCHEMA
        # hibernate.multi_tenant_connection_provider and
        # hibernate.tenant_identifier_resolver are set as @Bean
```

---

## 4. Shared Schema with Discriminator Column

### 4.1 Architecture

```sql
-- Single schema, all tenants in every table
CREATE TABLE orders (
    id          BIGSERIAL PRIMARY KEY,
    tenant_id   VARCHAR(50) NOT NULL,   -- discriminator column
    user_id     BIGINT NOT NULL,
    total       DECIMAL(10,2),
    status      VARCHAR(20),
    created_at  TIMESTAMP,
    INDEX idx_orders_tenant_id (tenant_id)  -- CRITICAL for performance
);

-- Application MUST add WHERE tenant_id = ? to every query
-- Missing this clause = data breach
```

### 4.2 Filter-Based Approach (Pre-Hibernate 6)

```java
// Define filter at entity level
@FilterDef(
    name = "tenantFilter",
    parameters = @ParamDef(name = "tenantId", type = String.class)
)
@Entity
@Table(name = "orders")
@Filter(name = "tenantFilter", condition = "tenant_id = :tenantId")
public class Order {

    @Id @GeneratedValue
    private Long id;

    @Column(name = "tenant_id", nullable = false)
    private String tenantId;

    private BigDecimal total;
    private String status;
}

// Interceptor: enable filter on every persistence operation
@Component
@Aspect
public class TenantFilterAspect {

    @PersistenceContext
    private EntityManager em;

    @Before("@within(org.springframework.stereotype.Repository) || " +
            "@within(org.springframework.stereotype.Service)")
    public void enableTenantFilter() {
        String tenantId = TenantContext.getCurrentTenantId();
        if (tenantId != null) {
            em.unwrap(Session.class)
              .enableFilter("tenantFilter")
              .setParameter("tenantId", tenantId);
        }
    }
}
```

---

## 5. `CurrentTenantIdentifierResolver` — Resolving the Tenant

The `CurrentTenantIdentifierResolver` answers: **"What tenant is the current thread working on?"** It is called by Hibernate whenever it needs to route a database operation.

### 5.1 The Interface

```java
// Hibernate's interface
public interface CurrentTenantIdentifierResolver<TenantIdType> {
    TenantIdType resolveCurrentTenantIdentifier();
    boolean validateExistingCurrentSessions();
}
```

### 5.2 Tenant Context Holder

First, set up a thread-local context to hold the current tenant ID:

```java
public final class TenantContext {

    private static final ThreadLocal<String> CURRENT_TENANT =
        new InheritableThreadLocal<>();   // InheritableThreadLocal so child threads inherit

    private TenantContext() {}

    public static void setCurrentTenantId(String tenantId) {
        CURRENT_TENANT.set(tenantId);
    }

    public static String getCurrentTenantId() {
        return CURRENT_TENANT.get();
    }

    public static void clear() {
        CURRENT_TENANT.remove();   // CRITICAL: clean up after each request
    }
}
```

### 5.3 Resolving Tenant from HTTP Header

```java
@Component
public class TenantIdentifierResolver
        implements CurrentTenantIdentifierResolver<String> {

    @Override
    public String resolveCurrentTenantIdentifier() {
        String tenantId = TenantContext.getCurrentTenantId();
        // IMPORTANT: never return null — Hibernate will fail
        return tenantId != null ? tenantId : "default";
    }

    @Override
    public boolean validateExistingCurrentSessions() {
        // true = Hibernate validates that existing sessions are for the current tenant
        // Use true for stronger isolation; false for performance
        return true;
    }
}

// Set the tenant in a filter/interceptor
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class TenantResolutionFilter extends OncePerRequestFilter {

    private static final String TENANT_HEADER = "X-Tenant-ID";

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain)
            throws ServletException, IOException {
        try {
            String tenantId = extractTenantId(request);
            validateTenantId(tenantId);
            TenantContext.setCurrentTenantId(tenantId);
            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();  // ALWAYS clear — prevent context leak between requests
        }
    }

    private String extractTenantId(HttpServletRequest request) {
        // Strategy 1: HTTP header
        String tenantId = request.getHeader(TENANT_HEADER);
        if (tenantId != null) return tenantId;

        // Strategy 2: Subdomain (acme.myapp.com → "acme")
        String host = request.getServerName(); // e.g., "acme.myapp.com"
        if (host.contains(".")) {
            return host.split("\\.")[0];  // "acme"
        }

        // Strategy 3: Path prefix (/api/tenant/acme/orders)
        String path = request.getRequestURI();
        if (path.startsWith("/api/tenant/")) {
            return path.split("/")[3];  // "acme"
        }

        throw new TenantNotResolvedException("Cannot resolve tenant from request");
    }

    private void validateTenantId(String tenantId) {
        // Prevent SQL injection — critical for schema/db-per-tenant strategies
        if (tenantId == null || !tenantId.matches("[a-zA-Z0-9_-]{1,50}")) {
            throw new InvalidTenantIdentifierException("Invalid tenant: " + tenantId);
        }
    }
}
```

### 5.4 Resolving Tenant from JWT

```java
@Component
public class JwtTenantIdentifierResolver
        implements CurrentTenantIdentifierResolver<String> {

    @Override
    public String resolveCurrentTenantIdentifier() {
        // Get from Spring Security context (JWT claims)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "anonymous"; // or throw exception
        }

        if (auth instanceof JwtAuthenticationToken jwtAuth) {
            Jwt jwt = jwtAuth.getToken();
            String tenantId = jwt.getClaimAsString("tenant_id");
            return tenantId != null ? tenantId : "default";
        }

        // Custom UserDetails with tenant
        if (auth.getPrincipal() instanceof TenantAwareUserDetails userDetails) {
            return userDetails.getTenantId();
        }

        throw new TenantNotResolvedException("Cannot determine tenant from authentication");
    }

    @Override
    public boolean validateExistingCurrentSessions() {
        return true;
    }
}
```

### 5.5 Resolving Tenant from Subdomain

```java
@Component
public class SubdomainTenantResolver
        implements CurrentTenantIdentifierResolver<String> {

    @Override
    public String resolveCurrentTenantIdentifier() {
        return TenantContext.getCurrentTenantId();
    }

    @Override
    public boolean validateExistingCurrentSessions() {
        return true;
    }
}

// In a RequestContextListener or Filter:
// Extract subdomain → set in TenantContext → cleared after request
```

---

## 6. `MultiTenantConnectionProvider` — Routing Connections

### 6.1 Unified Connection Provider (Schema Strategy in Spring Boot)

A complete, production-ready implementation:

```java
@Component
public class SchemaMultiTenantConnectionProvider
        implements MultiTenantConnectionProvider<String>, Serializable {

    private final DataSource dataSource;
    private final TenantSchemaValidator schemaValidator;

    public SchemaMultiTenantConnectionProvider(DataSource dataSource,
                                                TenantSchemaValidator schemaValidator) {
        this.dataSource = dataSource;
        this.schemaValidator = schemaValidator;
    }

    @Override
    public Connection getAnyConnection() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    public void releaseAnyConnection(Connection connection) throws SQLException {
        connection.close();
    }

    @Override
    public Connection getConnection(String tenantId) throws SQLException {
        // 1. Validate the tenant exists and is active
        schemaValidator.validate(tenantId);

        // 2. Get connection from pool
        Connection connection = dataSource.getConnection();

        try {
            // 3. Route to tenant schema
            switchSchema(connection, tenantId);
            return connection;
        } catch (SQLException e) {
            // Release connection on schema switch failure
            connection.close();
            throw e;
        }
    }

    private void switchSchema(Connection connection, String tenantId)
            throws SQLException {
        // SQL injection prevention already done in resolver
        String schema = "tenant_" + tenantId;
        try (PreparedStatement ps = connection.prepareStatement(
                "SET search_path TO ?, public")) {
            ps.setString(1, schema);
            ps.execute();
        }
    }

    @Override
    public void releaseConnection(String tenantId, Connection connection)
            throws SQLException {
        try {
            // Reset to public schema before returning to pool
            try (Statement stmt = connection.createStatement()) {
                stmt.execute("SET search_path TO public");
            }
        } finally {
            connection.close();
        }
    }

    @Override
    public boolean supportsAggressiveRelease() {
        return true;
    }

    @Override
    public boolean isUnwrappableAs(Class<?> cls) { return false; }

    @Override
    public <T> T unwrap(Class<T> cls) { return null; }
}
```

### 6.2 Connection Provider for Database-Per-Tenant

```java
@Component
public class DatabasePerTenantConnectionProvider
        implements MultiTenantConnectionProvider<String> {

    private final Map<String, HikariDataSource> pools = new ConcurrentHashMap<>();
    private final TenantConfigRepository tenantConfigRepository;

    @PostConstruct
    public void initializePools() {
        tenantConfigRepository.findAllActive()
            .forEach(config -> pools.put(config.getTenantId(), createPool(config)));
    }

    private HikariDataSource createPool(TenantConfig config) {
        HikariConfig hikari = new HikariConfig();
        hikari.setJdbcUrl(config.getJdbcUrl());
        hikari.setUsername(config.getDbUsername());
        hikari.setPassword(config.getDbPassword());
        hikari.setPoolName("pool-" + config.getTenantId());
        hikari.setMaximumPoolSize(5);
        hikari.setMinimumIdle(1);
        hikari.setConnectionTimeout(5_000);
        return new HikariDataSource(hikari);
    }

    @Override
    public Connection getConnection(String tenantId) throws SQLException {
        HikariDataSource pool = pools.get(tenantId);
        if (pool == null) {
            // Lazy initialization for dynamically added tenants
            TenantConfig config = tenantConfigRepository
                .findById(tenantId)
                .orElseThrow(() -> new TenantNotFoundException(tenantId));
            pool = createPool(config);
            pools.put(tenantId, pool);
        }
        return pool.getConnection();
    }

    @Override
    public void releaseConnection(String tenantId, Connection connection)
            throws SQLException {
        connection.close(); // returns to HikariCP pool
    }

    // Implement getAnyConnection(), releaseAnyConnection(), supportsAggressiveRelease()...

    @PreDestroy
    public void closePools() {
        pools.values().forEach(HikariDataSource::close);
    }
}
```

---

## 7. Hibernate 6 `@TenantId` Annotation

### 7.1 What `@TenantId` Does

Hibernate 6 introduced `@TenantId` for the **shared schema (discriminator column)** strategy. It automatically:
- Inserts the current tenant ID on `persist()`
- Adds `WHERE tenant_id = ?` to every query
- Validates that the tenant ID matches on load

```java
import org.hibernate.annotations.TenantId;

@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @TenantId                           // Hibernate 6: auto-filter + auto-populate
    @Column(name = "tenant_id", nullable = false)
    private String tenantId;            // populated automatically from CurrentTenantIdentifierResolver

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private BigDecimal total;
    private String status;
    private Instant createdAt;
}
```

### 7.2 How `@TenantId` Works Automatically

```java
// 1. ON PERSIST — tenant ID is automatically set
Order order = new Order();
order.setTotal(new BigDecimal("99.99"));
order.setStatus("PENDING");
// order.tenantId is NOT set by the application — Hibernate sets it
entityManager.persist(order);
// Hibernate automatically sets order.tenantId = TenantContext.getCurrentTenantId()
// INSERT INTO orders (tenant_id, total, status) VALUES ('acme', 99.99, 'PENDING')

// 2. ON FIND — tenant ID is validated
Order o = entityManager.find(Order.class, orderId);
// SELECT * FROM orders WHERE id = ? AND tenant_id = 'acme'
// If id belongs to a different tenant: returns null (not found, not an exception)

// 3. ON QUERY — filter automatically added
List<Order> orders = entityManager.createQuery(
    "FROM Order o WHERE o.status = 'PENDING'", Order.class)
    .getResultList();
// SELECT * FROM orders WHERE status = 'PENDING' AND tenant_id = 'acme'
```

### 7.3 `@TenantId` vs `@Filter`

```java
// @Filter approach (pre-Hibernate 6, still works):
@FilterDef(name = "tenantFilter",
           parameters = @ParamDef(name = "tenantId", type = String.class))
@Filter(name = "tenantFilter", condition = "tenant_id = :tenantId")
@Entity
public class Order {
    @Column(name = "tenant_id") private String tenantId;
    // Must enable filter manually in each session
    // Must set tenantId manually on persist
}

// @TenantId approach (Hibernate 6):
@Entity
public class Order {
    @TenantId
    @Column(name = "tenant_id") private String tenantId;
    // Automatically populated on persist
    // Automatically filtered on all queries
    // No manual filter activation needed
    // Integrated with CurrentTenantIdentifierResolver
}
```

### 7.4 Required Configuration for `@TenantId`

```java
@Configuration
public class TenantIdConfig {

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(
            DataSource dataSource,
            TenantIdentifierResolver resolver) {

        LocalContainerEntityManagerFactoryBean em =
            new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.myapp.entity");

        Properties properties = new Properties();
        // For @TenantId, use DISCRIMINATOR (not SCHEMA or DATABASE)
        properties.put("hibernate.multiTenancy", "DISCRIMINATOR");
        // Only resolver needed for discriminator — no connection provider
        properties.put("hibernate.tenant_identifier_resolver", resolver);
        em.setJpaProperties(properties);

        return em;
    }
}
```

---

## 8. Tenant-Aware Flyway Migrations

### 8.1 The Challenge

Different multi-tenancy strategies require different migration approaches:

```
Separate Database:  Run Flyway against each tenant's database separately
Separate Schema:    Run Flyway against each schema in the shared database
Shared Schema:      Run Flyway once — migrations apply to all tenants
```

### 8.2 Flyway for Separate Schema Strategy

```java
@Component
public class MultiTenantFlywayMigrator {

    private final DataSource dataSource;
    private final TenantRepository tenantRepository;

    @PostConstruct
    public void migrateAllTenants() {
        // Migrate shared tables in public schema first
        migratePublicSchema();

        // Then migrate each tenant's schema
        tenantRepository.findAllActive()
            .forEach(tenant -> migrateTenantSchema(tenant.getId()));
    }

    private void migratePublicSchema() {
        Flyway flyway = Flyway.configure()
            .dataSource(dataSource)
            .schemas("public")
            .locations("classpath:db/migration/shared")  // shared tables: tenants, plans, etc.
            .load();
        flyway.migrate();
    }

    public void migrateTenantSchema(String tenantId) {
        String schema = "tenant_" + tenantId;

        // Create schema if it doesn't exist (for new tenants)
        createSchemaIfNotExists(schema);

        Flyway flyway = Flyway.configure()
            .dataSource(dataSource)
            .schemas(schema)                           // migrate this specific schema
            .locations("classpath:db/migration/tenant") // tenant-specific tables
            .defaultSchema(schema)
            .table("flyway_schema_history")            // metadata table per schema
            .baselineOnMigrate(true)
            .load();

        flyway.migrate();
    }

    private void createSchemaIfNotExists(String schema) {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("CREATE SCHEMA IF NOT EXISTS " + schema);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create schema: " + schema, e);
        }
    }

    // Called when a new tenant is onboarded
    public void provisionNewTenant(String tenantId) {
        migrateTenantSchema(tenantId);
        log.info("Provisioned new tenant schema: tenant_{}", tenantId);
    }
}
```

### 8.3 Migration File Structure

```
src/main/resources/db/migration/
  ├── shared/                    — runs once for the shared schema
  │   ├── V1__create_tenants.sql
  │   ├── V2__create_plans.sql
  │   └── V3__create_audit_log.sql
  │
  └── tenant/                    — runs for EACH tenant schema
      ├── V1__create_users.sql
      ├── V2__create_orders.sql
      ├── V3__create_products.sql
      └── V4__add_indexes.sql
```

```sql
-- db/migration/shared/V1__create_tenants.sql
CREATE TABLE IF NOT EXISTS tenants (
    id          VARCHAR(50)  PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    plan        VARCHAR(50)  NOT NULL DEFAULT 'basic',
    active      BOOLEAN      NOT NULL DEFAULT true,
    schema_name VARCHAR(100) GENERATED ALWAYS AS ('tenant_' || id) STORED,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- db/migration/tenant/V1__create_users.sql
-- Note: no tenant_id column needed — each tenant has its own schema!
CREATE TABLE users (
    id          BIGSERIAL    PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id          BIGSERIAL    PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users(id),
    total       DECIMAL(10,2) NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    placed_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);
```

### 8.4 Flyway for Separate Database Strategy

```java
@Component
public class MultiDatabaseFlywayMigrator {

    private final TenantDataSourceRegistry registry;

    @PostConstruct
    public void migrateAllDatabases() {
        registry.getAllTenants().parallelStream()   // migrate in parallel
            .forEach(this::migrateTenantDatabase);
    }

    private void migrateTenantDatabase(String tenantId) {
        DataSource tenantDs = registry.getDataSource(tenantId);

        Flyway flyway = Flyway.configure()
            .dataSource(tenantDs)
            .locations("classpath:db/migration/tenant")
            .table("flyway_schema_history")
            .load();

        MigrateResult result = flyway.migrate();
        log.info("Migrated tenant {}: {} migrations applied",
            tenantId, result.migrationsExecuted);
    }
}
```

### 8.5 Tenant Onboarding API

```java
@Service
@Transactional
public class TenantProvisioningService {

    private final TenantRepository tenantRepository;
    private final MultiTenantFlywayMigrator migrator;
    private final TenantDataSourceRegistry registry;

    public TenantDto provisionTenant(CreateTenantRequest request) {
        // 1. Validate tenant ID is unique and valid
        String tenantId = sanitizeTenantId(request.getName());
        if (tenantRepository.existsById(tenantId)) {
            throw new TenantAlreadyExistsException(tenantId);
        }

        // 2. Create tenant record in public schema
        Tenant tenant = new Tenant(tenantId, request.getName(), request.getPlan());
        tenantRepository.save(tenant);

        // 3. Provision database/schema and run migrations
        migrator.provisionNewTenant(tenantId);

        // 4. Register DataSource (for database-per-tenant)
        // registry.registerTenant(new TenantConfig(tenantId, buildDbUrl(tenantId)));

        log.info("Provisioned tenant: {}", tenantId);
        return TenantDto.from(tenant);
    }

    private String sanitizeTenantId(String name) {
        return name.toLowerCase()
                   .replaceAll("[^a-z0-9_]", "_")
                   .substring(0, Math.min(name.length(), 30));
    }
}
```

---

## 9. Spring Security + Multi-Tenancy

### 9.1 JWT with Tenant Claim

```java
// JWT payload example:
// {
//   "sub": "user-123",
//   "tenant_id": "acme-corp",
//   "roles": ["ROLE_ADMIN"],
//   "exp": 1704067200
// }

@Component
public class JwtAuthenticationConverter
        implements Converter<Jwt, AbstractAuthenticationToken> {

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        Collection<GrantedAuthority> authorities = extractAuthorities(jwt);
        String tenantId = jwt.getClaimAsString("tenant_id");

        // Create authentication token with tenant context
        TenantAwareJwtAuthenticationToken auth =
            new TenantAwareJwtAuthenticationToken(jwt, authorities, tenantId);

        return auth;
    }
}

// Custom token that carries tenant ID
public class TenantAwareJwtAuthenticationToken extends JwtAuthenticationToken {

    private final String tenantId;

    public TenantAwareJwtAuthenticationToken(Jwt jwt,
                                              Collection<? extends GrantedAuthority> authorities,
                                              String tenantId) {
        super(jwt, authorities);
        this.tenantId = tenantId;
    }

    public String getTenantId() {
        return tenantId;
    }
}
```

### 9.2 Security Filter Chain with Tenant Resolution

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .oauth2ResourceServer(oauth2 ->
                oauth2.jwt(jwt -> jwt
                    .jwtAuthenticationConverter(jwtAuthenticationConverter())))
            // Add our tenant resolution filter AFTER authentication
            .addFilterAfter(tenantExtractionFilter(), BearerTokenAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .build();
    }

    @Bean
    public TenantExtractionFilter tenantExtractionFilter() {
        return new TenantExtractionFilter();
    }
}

// Filter that sets TenantContext from the authenticated JWT
@Component
public class TenantExtractionFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain) throws ServletException, IOException {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth instanceof TenantAwareJwtAuthenticationToken tenantAuth) {
                TenantContext.setCurrentTenantId(tenantAuth.getTenantId());
            }
            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}
```

### 9.3 Tenant Isolation in Security Rules

```java
@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    // Method security: verify the order belongs to the current tenant
    public Order getOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new OrderNotFoundException(orderId));

        // Extra guard: verify tenant matches (defense in depth)
        // With @TenantId: Hibernate already filtered — this is belt-and-suspenders
        String currentTenant = TenantContext.getCurrentTenantId();
        if (!currentTenant.equals(order.getTenantId())) {
            // This should never happen if Hibernate filtering is correct
            // Log it as a security event
            log.error("SECURITY: Tenant {} attempted to access order {} of tenant {}",
                currentTenant, orderId, order.getTenantId());
            throw new OrderNotFoundException(orderId); // don't reveal the order exists
        }

        return order;
    }
}
```

### 9.4 Admin Operations — Bypassing Tenant Filter

```java
// For admin operations that need cross-tenant access:
@Component
public class AdminTenantService {

    @PersistenceContext
    private EntityManager entityManager;

    // Admin: get stats for ALL tenants
    @Transactional(readOnly = true)
    public List<TenantStats> getAllTenantStats() {
        // Use NATIVE SQL to bypass Hibernate's tenant filter
        return entityManager.createNativeQuery(
            "SELECT tenant_id, COUNT(*) as order_count, SUM(total) as revenue " +
            "FROM orders GROUP BY tenant_id", TenantStats.class)
            .getResultList();
    }

    // Admin: switch tenant context for targeted operations
    public void runAsAdmin(String tenantId, Runnable operation) {
        String previousTenant = TenantContext.getCurrentTenantId();
        try {
            TenantContext.setCurrentTenantId(tenantId);
            operation.run();
        } finally {
            TenantContext.setCurrentTenantId(previousTenant);
        }
    }
}
```

---

## 10. Testing Multi-Tenant Applications

### 10.1 Unit Tests — Mocking TenantContext

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @InjectMocks
    private OrderService orderService;

    @Mock
    private OrderRepository orderRepository;

    @BeforeEach
    void setUp() {
        TenantContext.setCurrentTenantId("test-tenant");
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear(); // CRITICAL: clean up after each test
    }

    @Test
    void createOrder_shouldSetTenantId() {
        Order order = orderService.createOrder(new CreateOrderRequest(...));
        assertThat(order.getTenantId()).isEqualTo("test-tenant");
    }

    @Test
    void getOrder_wrongTenant_shouldThrow() {
        Order order = new Order();
        order.setTenantId("other-tenant"); // different tenant
        when(orderRepository.findById(1L)).thenReturn(Optional.of(order));

        assertThatThrownBy(() -> orderService.getOrder(1L))
            .isInstanceOf(OrderNotFoundException.class);
    }
}
```

### 10.2 Integration Tests with Testcontainers

```java
@SpringBootTest
@Testcontainers
class MultiTenantIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:15")
            .withDatabaseName("saas_platform");

    @DynamicPropertySource
    static void configure(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private MultiTenantFlywayMigrator migrator;

    @Autowired
    private OrderService orderService;

    @BeforeEach
    void setUpTenants() {
        migrator.migrateTenantSchema("tenant-a");
        migrator.migrateTenantSchema("tenant-b");
    }

    @Test
    void tenantIsolation_tenantACannotSeeTenanBData() {
        // Create order for tenant A
        TenantContext.setCurrentTenantId("tenant-a");
        Order orderA = orderService.createOrder(new CreateOrderRequest(new BigDecimal("100")));

        // Switch to tenant B
        TenantContext.setCurrentTenantId("tenant-b");
        List<Order> tenantBOrders = orderService.findAll();

        // Tenant B should not see tenant A's order
        assertThat(tenantBOrders)
            .extracting(Order::getId)
            .doesNotContain(orderA.getId());
    }

    @AfterEach
    void cleanUp() {
        TenantContext.clear();
    }
}
```

### 10.3 Testing Filter Activation

```java
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class TenantFilterTest {

    @PersistenceContext
    private EntityManager entityManager;

    @Test
    @Transactional
    void filterShouldIsolateTenantData() {
        // Insert data for two tenants directly (bypassing filter)
        entityManager.createNativeQuery(
            "INSERT INTO orders (tenant_id, total, status) VALUES ('tenant-a', 100, 'PENDING'), " +
            "('tenant-b', 200, 'PENDING')").executeUpdate();

        // Activate filter for tenant-a
        Session session = entityManager.unwrap(Session.class);
        session.enableFilter("tenantFilter").setParameter("tenantId", "tenant-a");

        List<Order> results = entityManager
            .createQuery("FROM Order", Order.class)
            .getResultList();

        assertThat(results).hasSize(1);
        assertThat(results.get(0).getTenantId()).isEqualTo("tenant-a");
    }
}
```

### 10.4 MockMvc Tests with Tenant Headers

```java
@SpringBootTest
@AutoConfigureMockMvc
class OrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void createOrder_withTenantHeader_shouldSucceed() throws Exception {
        mockMvc.perform(post("/api/orders")
                .header("X-Tenant-ID", "test-tenant")
                .header("Authorization", "Bearer " + validJwt)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"total\": 99.99}"))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.tenantId").value("test-tenant"));
    }

    @Test
    void getOrder_withWrongTenant_shouldReturn404() throws Exception {
        // Create order for tenant A, try to access with tenant B
        Long orderIdFromTenantA = createOrderForTenant("tenant-a");

        mockMvc.perform(get("/api/orders/" + orderIdFromTenantA)
                .header("X-Tenant-ID", "tenant-b")
                .header("Authorization", "Bearer " + validJwt))
            .andExpect(status().isNotFound()); // order invisible to tenant B
    }
}
```

---

## 11. Choosing a Strategy

### 11.1 Decision Guide

```
Question 1: How many tenants do you have (or expect)?
  < 100 tenants          → Separate Database is viable
  100s of tenants        → Separate Schema is better
  1000+ or millions      → Shared Schema only practical option

Question 2: What are your compliance requirements?
  HIPAA, GDPR, financial → Separate Database (physical isolation)
  Standard SaaS          → Separate Schema or Shared Schema

Question 3: Do tenants need schema customization?
  Yes (different columns, tables per tenant) → Separate Database or Schema
  No (all tenants same structure)            → All strategies viable

Question 4: What's your operational capacity?
  Small team, startup    → Shared Schema (one migration, one DB to operate)
  Platform team          → Any strategy viable

Question 5: What's your cost constraint?
  Minimizing DB cost     → Shared Schema
  Per-tenant billing OK  → Separate Database

Question 6: What DB are you using?
  PostgreSQL             → All strategies, Separate Schema is very clean
  MySQL                  → Shared Schema or Separate Database (schema ≈ database)
  Oracle                 → Separate Schema common (expensive DB licenses)
```

### 11.2 Strategy Migration Path

```
Start with Shared Schema (easiest):
  → Suitable for early-stage SaaS
  → Add tenant_id to every table
  → Use @TenantId (Hibernate 6) or @Filter

Later, migrate to Separate Schema (when needed):
  → Create tenant schemas from shared tables
  → Run Flyway per schema
  → Update connection provider

Final step, Separate Database (for enterprise):
  → Provision dedicated DB per large enterprise tenant
  → Can run both strategies simultaneously
  → Large tenants: own DB; small tenants: shared schema
```

---

## 12. Quick Reference Cheat Sheet

### Strategy Selection

```
Separate Database:  Strongest isolation. N connection pools. Per-tenant migrations.
Separate Schema:    Good isolation. 1 DB, N schemas. Per-schema migrations.
Shared Schema:      Application-level isolation. 1 schema. tenant_id on every row.
```

### Key Interfaces

```java
// Hibernate: resolve current tenant
implements CurrentTenantIdentifierResolver<String> {
    String resolveCurrentTenantIdentifier();  // called by Hibernate on every DB op
    boolean validateExistingCurrentSessions();
}

// Hibernate: route to correct DB/schema
implements MultiTenantConnectionProvider<String> {
    Connection getConnection(String tenantId);    // get tenant-specific connection
    void releaseConnection(String tenantId, Connection conn);
    Connection getAnyConnection();               // for schema validation
}
```

### Thread-Local Context (Must Clean Up!)

```java
TenantContext.setCurrentTenantId("acme");
try {
    // ... database operations ...
} finally {
    TenantContext.clear(); // ALWAYS clear to prevent request context leak
}
```

### Hibernate 6 `@TenantId` (Shared Schema)

```java
@Entity
public class Order {
    @TenantId
    @Column(name = "tenant_id", nullable = false)
    private String tenantId; // auto-populated on persist, auto-filtered on queries
}

// Config: hibernate.multiTenancy=DISCRIMINATOR + CurrentTenantIdentifierResolver
```

### Hibernate Config for Schema/Database Strategy

```properties
hibernate.multiTenancy=SCHEMA  (or DATABASE)
hibernate.multi_tenant_connection_provider=<bean>
hibernate.tenant_identifier_resolver=<bean>
```

### Flyway Per-Tenant Migration

```java
Flyway.configure()
    .dataSource(dataSource)
    .schemas("tenant_" + tenantId)
    .locations("classpath:db/migration/tenant")
    .load()
    .migrate();
```

### Key Rules to Remember

1. **ALWAYS clean TenantContext** — use `try-finally`; missing `clear()` leaks tenant context across requests.
2. **Validate tenant IDs before use as schema/DB names** — SQL injection via `SET search_path TO` is real.
3. **`@TenantId` needs `DISCRIMINATOR` mode** — not `SCHEMA` or `DATABASE` in Hibernate config.
4. **`@TenantId` auto-populates and auto-filters** — no manual `WHERE tenant_id = ?` needed.
5. **Reset search_path before returning connection to pool** — or the next request inherits the wrong schema.
6. **Native SQL bypasses Hibernate filters** — use with care in admin operations, test explicitly.
7. **`validateExistingCurrentSessions=true`** — causes Hibernate to validate session's tenant matches current.
8. **Index `tenant_id` on every shared-schema table** — unindexed tenant_id → full table scans.
9. **Separate migrations for shared and tenant schemas** — `classpath:db/migration/shared` vs `tenant`.
10. **Run `@TenantId` entity operations within tenant context** — Hibernate reads resolver synchronously.

---

*End of Multi-Tenancy Study Guide — Module 9*
