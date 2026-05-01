# Enterprise Patterns (Fowler's PEAA) - Curriculum

Patterns from *Patterns of Enterprise Application Architecture* (Fowler) - sit above GoF, below microservice patterns.

## Topics
### Domain Logic Patterns
- [ ] **Transaction Script** - procedural per-use-case (simple apps)
- [ ] **Domain Model** - rich object graph with behavior
- [ ] **Table Module** - one class per table (anemic, .NET DataSet style)
- [ ] **Service Layer** - thin facade over domain, defines transaction boundary
- [ ] When to choose Transaction Script vs Domain Model

### Data Source Architectural Patterns
- [ ] **Table Data Gateway** - one gateway object per table
- [ ] **Row Data Gateway** - one gateway per row
- [ ] **Active Record** - entity contains its own DB access (Rails-style)
- [ ] **Data Mapper** - separate mapper layer (used by JPA/Hibernate)

### Object-Relational Patterns
- [ ] **Repository Pattern** - in-memory collection abstraction over data store
  - [ ] Generic vs aggregate-specific repositories
  - [ ] Spring Data Repository conventions
  - [ ] Repository in DDD vs Repository in CRUD apps
- [ ] **Unit of Work** - track changes, commit as one transaction
- [ ] **Identity Map** - one object per row in session
- [ ] **Lazy Load** - load on demand
- [ ] **Specification Pattern** - reusable query predicates

### Distribution / Web / Session Patterns
- [ ] **Data Transfer Object (DTO)** - flat data carrier across boundaries
- [ ] **Remote Facade** - coarse-grained interface for remote calls
- [ ] **Front Controller** - single entry point (Spring DispatcherServlet)
- [ ] **Page Controller** vs **Front Controller**
- [ ] **MVC** as a presentation pattern
- [ ] **Two Step View**, **Template View**

### Cross-Cutting
- [ ] **Abstract Base Class / Template Method** - shared skeleton with overridable steps (Java abstract class, Python ABC)
- [ ] **Plugin / Service Locator** vs Dependency Injection
- [ ] **Money pattern** - encapsulate currency + amount
- [ ] **Special Case / Null Object** - avoid null checks
