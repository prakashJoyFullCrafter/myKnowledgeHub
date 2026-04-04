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

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Model a blog: `User` -> `Post` -> `Comment` with relationships |
| Module 3 | Build a search API with dynamic filtering using Specifications |
| Module 4 | Implement a money transfer with proper transaction handling |
| Module 5 | Detect and fix N+1 queries in the blog project |
| Module 6 | Add auditing and soft delete to all entities |

## Key Resources
- Spring Data JPA Reference Documentation
- Java Persistence with Hibernate - Bauer, King, Gregory
- Vlad Mihalcea's blog (hibernate tips)
