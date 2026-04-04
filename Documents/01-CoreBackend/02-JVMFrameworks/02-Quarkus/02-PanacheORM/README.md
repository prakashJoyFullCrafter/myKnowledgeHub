# Quarkus Panache ORM - Curriculum

## Module 1: Panache Basics
- [ ] Active Record pattern: `PanacheEntity`
- [ ] Repository pattern: `PanacheRepository<T>`
- [ ] Entity definition with Panache
- [ ] Auto-generated getters/setters (public fields)
- [ ] Active Record vs Repository - when to use each

## Module 2: CRUD Operations
- [ ] `persist()`, `delete()`, `findById()`
- [ ] `listAll()`, `find()`, `stream()`
- [ ] `count()`, `deleteById()`
- [ ] Simplified queries: `find("name", "John")`
- [ ] Named parameters: `find("name = :name", Parameters.with("name", "John"))`

## Module 3: Advanced Queries
- [ ] Panache Query Language (simplified HQL)
- [ ] Pagination: `page()`, `pageCount()`
- [ ] Sorting: `Sort.by("name").descending()`
- [ ] Projections with `@RegisterForReflection`
- [ ] Native queries with `#nativeQuery`

## Module 4: Transactions & Validation
- [ ] `@Transactional` in Quarkus
- [ ] Bean Validation with Panache
- [ ] Lifecycle callbacks (`@PrePersist`, `@PreUpdate`)
- [ ] Soft delete pattern with Panache
- [ ] Testing with `@QuarkusTest` and `@TestTransaction`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build CRUD API with both Active Record and Repository patterns |
| Module 3 | Advanced search with pagination and sorting |
| Module 4 | Transaction handling and validation |
