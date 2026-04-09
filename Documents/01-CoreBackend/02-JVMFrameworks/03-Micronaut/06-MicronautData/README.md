# Micronaut Data - Curriculum

## Module 1: Micronaut Data Fundamentals
- [ ] Micronaut Data: compile-time data access layer (no runtime proxies or reflection)
- [ ] Query methods generated at build time (vs Spring Data runtime generation)
- [ ] Supports: JDBC, R2DBC, JPA (Hibernate), MongoDB
- [ ] `@MappedEntity` — entity annotation (Micronaut's own, or use JPA `@Entity`)
- [ ] `@Id` and `@GeneratedValue` — primary key
- [ ] `@MappedProperty` — column mapping

## Module 2: Repositories
- [ ] `@Repository` — marks a data access interface
- [ ] `CrudRepository<T, ID>` — standard CRUD operations
- [ ] `PageableRepository<T, ID>` — adds pagination and sorting
- [ ] Derived query methods: `findByName(String name)`, `findByAgeGreaterThan(int age)`
- [ ] `@Query("SELECT u FROM User u WHERE u.email = :email")` — custom JPQL/SQL
- [ ] `@Query(nativeQuery = true)` — native SQL queries
- [ ] Async repositories: `@Repository` returning `CompletableFuture<T>`

## Module 3: JDBC vs JPA vs R2DBC
- [ ] **Micronaut Data JDBC**: lightweight, no ORM overhead, compile-time SQL
  - [ ] `micronaut-data-jdbc` — direct SQL, no lazy loading, no session cache
  - [ ] Best for: simple CRUD, microservices, performance-sensitive apps
- [ ] **Micronaut Data JPA** (Hibernate): full ORM, lazy loading, second-level cache
  - [ ] `micronaut-data-hibernate-jpa` — familiar to Spring Data JPA users
  - [ ] Best for: complex domain models, existing Hibernate expertise
- [ ] **Micronaut Data R2DBC**: reactive data access
  - [ ] `micronaut-data-r2dbc` — non-blocking database operations
  - [ ] Best for: reactive applications, high-concurrency
- [ ] **Micronaut Data MongoDB**: document database support
  - [ ] `micronaut-data-mongodb` — compile-time query generation for MongoDB

## Module 4: Transactions & Advanced
- [ ] `@Transactional` — declarative transactions (same as Spring/Jakarta)
- [ ] `@ReadOnly` — read-only transaction optimization
- [ ] Programmatic transactions: `TransactionOperations`
- [ ] `@Join` — fetch joins for eager loading (avoid N+1)
- [ ] `@Where` — default filter on entity
- [ ] Projections: DTO projections with compile-time validation
- [ ] Database migrations: Flyway (`micronaut-flyway`) / Liquibase (`micronaut-liquibase`)
- [ ] Multi-datasource support: `@Repository("secondary")`

## Module 5: Testing & Comparison
- [ ] `@MicronautTest` with embedded database (H2)
- [ ] Testcontainers integration for real database testing
- [ ] `@Property(name = "datasources.default.url", value = "...")` — override in tests
- [ ] Micronaut Data vs Spring Data JPA:
  - [ ] Both: repository interfaces, derived queries, `@Query`
  - [ ] Micronaut: compile-time query generation, no runtime proxies
  - [ ] Spring: runtime generation, larger ecosystem, more features
- [ ] Micronaut Data vs Quarkus Panache:
  - [ ] Micronaut: repository pattern (familiar to Spring devs)
  - [ ] Panache: active record pattern (Rails-style)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build CRUD repository for User entity with derived queries |
| Module 3 | Same app with JDBC vs JPA — compare generated SQL and performance |
| Module 4 | Add transactions, Flyway migrations, DTO projections |
| Module 5 | Integration test with Testcontainers PostgreSQL |

## Key Resources
- Micronaut Data documentation
- Micronaut Data JDBC guide
- Micronaut Guides — "Access a Database" tutorials
