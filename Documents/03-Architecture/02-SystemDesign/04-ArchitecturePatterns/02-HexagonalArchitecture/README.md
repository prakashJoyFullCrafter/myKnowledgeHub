# Hexagonal Architecture (Ports & Adapters) - Curriculum

Alistair Cockburn's pattern: isolate business logic from external concerns through ports and adapters.

## Topics
- [ ] Origin: Cockburn's 2005 article, motivation - testability and isolation
- [ ] Why "hexagonal"? - symbolic, not literal six sides
- [ ] **Application Core** (the inside) - domain + application services
- [ ] **Ports** - interfaces defining what the core needs/offers
  - [ ] Driving (primary/inbound) ports - API the core exposes
  - [ ] Driven (secondary/outbound) ports - what the core requires
- [ ] **Adapters** - implementations of ports
  - [ ] Driving adapters: REST controllers, CLI, message consumers
  - [ ] Driven adapters: DB repositories, REST clients, message publishers
- [ ] Dependency direction: adapters depend on ports, never the reverse
- [ ] Inversion of Control / Dependency Inversion as the enabling principle
- [ ] Testing: replace adapters with test doubles, test core in isolation
- [ ] Comparison with Clean Architecture (very similar, different terminology)
- [ ] Comparison with Onion Architecture
- [ ] Practical implementation in Spring Boot: package structure, bean wiring
- [ ] DDD pairing: Hexagonal is the structural shell for DDD tactical patterns
- [ ] Multi-adapter scenarios: same port, multiple adapters (REST + gRPC)
- [ ] Anti-patterns: leaky adapters, adapter logic that should be in core
- [ ] When to use: complex domain logic, multiple delivery mechanisms, long-lived systems
