# Clean Architecture - Curriculum

Robert C. Martin's concentric-circle architecture: dependencies point inward toward business rules.

## Topics
- [ ] The Dependency Rule: source code dependencies point only inward
- [ ] The four concentric layers:
  - [ ] **Entities** (Enterprise Business Rules) - core domain objects
  - [ ] **Use Cases** (Application Business Rules) - app-specific orchestration
  - [ ] **Interface Adapters** - controllers, presenters, gateways
  - [ ] **Frameworks & Drivers** - DB, web, UI, external services
- [ ] Why concentric: framework independence, testability, UI/DB independence
- [ ] Boundary crossing via interfaces (DIP)
- [ ] Use Case Interactor + Input Boundary + Output Boundary
- [ ] Presenters and View Models (separating UI logic)
- [ ] Plugin architecture mindset
- [ ] Comparison with Hexagonal Architecture (similar core idea, different vocabulary)
- [ ] Comparison with Onion Architecture (Jeffrey Palermo)
- [ ] Screaming Architecture - structure should reveal intent, not framework
- [ ] Practical layout in Java/Spring: package-by-feature vs package-by-layer
- [ ] Common mistakes: leaking entities to controllers, anemic use cases
- [ ] When NOT to use Clean Architecture (CRUD apps, prototypes)
- [ ] Testing strategy: pure unit tests on use cases, no framework needed
