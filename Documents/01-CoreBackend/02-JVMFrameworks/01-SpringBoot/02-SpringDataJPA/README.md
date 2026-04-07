# Spring Data JPA - Curriculum

## Module 1: JPA Fundamentals
- [ ] What is JPA? ORM concept
- [ ] `@Entity`, `@Table`, `@Id`, `@GeneratedValue`
- [ ] Generation strategies: `IDENTITY`, `SEQUENCE`, `TABLE`, `AUTO`
- [ ] Column mappings: `@Column`, `@Transient`, `@Enumerated`, `@Temporal`
- [ ] Embeddable types: `@Embeddable`, `@Embedded`

## Module 2: Relationships
- [ ] `@OneToOne` (unidirectional and bidirectional)
- [ ] `@OneToMany` / `@ManyToOne`
- [ ] `@ManyToMany` with `@JoinTable`
- [ ] `mappedBy` - owning side vs inverse side
- [ ] Cascade types: `PERSIST`, `MERGE`, `REMOVE`, `ALL`
- [ ] `orphanRemoval = true`
- [ ] Fetch types: `LAZY` vs `EAGER` (always prefer LAZY)

## Module 3: Spring Data Repositories
- [ ] `JpaRepository<T, ID>` - CRUD + paging + sorting
- [ ] Derived query methods (`findByNameAndAge`, `findByStatusIn`)
- [ ] `@Query` with JPQL and native SQL
- [ ] `@Modifying` for UPDATE/DELETE queries
- [ ] Projections: interface-based, class-based, dynamic
- [ ] `Pageable` and `Sort` parameters
- [ ] `Specification` for dynamic queries
- [ ] `@EntityGraph` - fetch plan control

## Module 4: Transactions
- [ ] `@Transactional` - propagation, isolation, rollback rules
- [ ] Propagation types: `REQUIRED`, `REQUIRES_NEW`, `NESTED`, `SUPPORTS`
- [ ] Isolation levels and dirty reads / phantom reads
- [ ] Read-only transactions (`@Transactional(readOnly = true)`)
- [ ] Transaction boundaries - service layer best practice
- [ ] Programmatic transactions with `TransactionTemplate`

## Module 5: Performance & N+1 Problem
- [ ] N+1 select problem - detection and solutions
- [ ] `JOIN FETCH` in JPQL
- [ ] `@BatchSize` and `@Fetch(FetchMode.SUBSELECT)`
- [ ] `@EntityGraph` for query-specific fetch plans
- [ ] Second-level cache (Hibernate)
- [ ] `spring.jpa.show-sql` and `spring.jpa.properties.hibernate.format_sql`

## Module 6: Auditing & Soft Deletes
- [ ] `@CreatedDate`, `@LastModifiedDate`, `@CreatedBy`, `@LastModifiedBy`
- [ ] `@EnableJpaAuditing` and `AuditorAware<T>`
- [ ] `@SQLDelete` and `@Where` for soft deletes
- [ ] `@Filter` for conditional filtering

## Module 7: Database Migrations (Flyway & Liquibase)
- [ ] Why migrations? Version-controlled schema changes
- [ ] **Flyway**:
  - [ ] `spring-boot-starter-flyway` auto-configuration
  - [ ] Migration naming: `V1__create_users_table.sql`, `V2__add_email_column.sql`
  - [ ] Repeatable migrations: `R__refresh_views.sql`
  - [ ] Migration locations: `classpath:db/migration`
  - [ ] Flyway commands: `migrate`, `validate`, `info`, `repair`, `clean`
  - [ ] Baseline: `spring.flyway.baseline-on-migrate=true` for existing databases
  - [ ] Callbacks: `beforeMigrate`, `afterMigrate` hooks
- [ ] **Liquibase**:
  - [ ] Changelog formats: XML, YAML, SQL
  - [ ] Changesets: `id`, `author`, `runAlways`, `runOnChange`
  - [ ] Rollback support (Liquibase advantage over Flyway)
  - [ ] Preconditions and contexts
- [ ] **Best practices**:
  - [ ] Never modify an already-applied migration — always add new ones
  - [ ] Always test migrations against production-like data
  - [ ] Backward-compatible migrations for zero-downtime deployments
  - [ ] Separate DDL and DML migrations
  - [ ] Flyway vs Liquibase decision guide
- [ ] **Spring Boot integration**:
  - [ ] Auto-runs on startup before JPA entity validation
  - [ ] `spring.flyway.*` / `spring.liquibase.*` configuration properties
  - [ ] Testcontainers + Flyway for integration tests with real schema

## Module 8: Hibernate-Specific Features (Beyond JPA)
- [ ] `@NaturalId` - business key lookups with second-level cache support
- [ ] `@Formula` - computed column using SQL expression
- [ ] `@Where` - default filter on entity (e.g., soft delete: `@Where(clause = "deleted = false")`)
- [ ] `@Filter` and `@FilterDef` - dynamic, toggleable filters
- [ ] `@Type` and custom `UserType` for non-standard column types
- [ ] `@BatchSize` - batch fetching for collections (N+1 mitigation)
- [ ] `@Fetch(FetchMode.SUBSELECT)` - subselect fetching strategy
- [ ] Hibernate Envers for entity auditing/versioning
- [ ] Hibernate statistics: `hibernate.generate_statistics=true`
- [ ] Hibernate 6 features: `@TimeZoneStorage`, improved `@Array` support, Jakarta namespace

## Module 9: Multi-Tenancy
- [ ] Multi-tenancy strategies:
  - [ ] **Separate database** per tenant - strongest isolation, highest cost
  - [ ] **Separate schema** per tenant - moderate isolation, moderate cost
  - [ ] **Shared schema with discriminator** - lowest isolation, lowest cost
- [ ] `CurrentTenantIdentifierResolver` - resolve tenant from request (header, JWT, subdomain)
- [ ] `MultiTenantConnectionProvider` - route to correct database/schema
- [ ] Hibernate 6 `@TenantId` annotation - discriminator column approach
- [ ] Tenant-aware Flyway migrations: per-tenant schema setup
- [ ] Spring Security + multi-tenancy: tenant context from authentication
- [ ] Testing multi-tenant applications

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Model a blog: `User` -> `Post` -> `Comment` with relationships |
| Module 3 | Build a search API with dynamic filtering using Specifications |
| Module 4 | Implement a money transfer with proper transaction handling |
| Module 5 | Detect and fix N+1 queries in the blog project |
| Module 6 | Add auditing and soft delete to all entities |
| Module 7 | Set up Flyway migrations for the blog project, practice adding columns safely |
| Module 8 | Add `@NaturalId` for email lookup, `@Filter` for soft delete, enable Hibernate statistics |
| Module 9 | Add tenant-aware data isolation using discriminator column approach |

## Key Resources
- Spring Data JPA Reference Documentation
- Java Persistence with Hibernate - Bauer, King, Gregory
- Vlad Mihalcea's blog (hibernate tips)
- Flyway documentation (flywaydb.org)
- Liquibase documentation (liquibase.org)
- Hibernate 6 User Guide
