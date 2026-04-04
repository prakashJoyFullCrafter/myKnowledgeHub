# Quarkus Dev Services - Curriculum

## Module 1: Dev Services Overview
- [ ] What are Dev Services? Auto-provisioned containers
- [ ] Zero-config development with Testcontainers
- [ ] Supported services: PostgreSQL, MySQL, Kafka, Redis, MongoDB, Keycloak
- [ ] Dev Services lifecycle (start with app, stop on shutdown)

## Module 2: Continuous Testing
- [ ] `quarkus dev` - live coding mode
- [ ] Continuous testing (`r` to re-run tests)
- [ ] Dev UI (`/q/dev-ui`)
- [ ] Hot reload and live config changes

## Module 3: Dev Services Configuration
- [ ] Overriding Dev Services defaults
- [ ] Sharing Dev Services across modules
- [ ] Custom Testcontainer images
- [ ] Disabling specific Dev Services
- [ ] Dev Services for custom services

## Module 4: Testing with Dev Services
- [ ] `@QuarkusTest` - full integration test
- [ ] `@QuarkusIntegrationTest` - tests against packaged app
- [ ] `@TestProfile` for different configurations
- [ ] `@InjectMock` for selective mocking
- [ ] Testing with real databases (no mocks)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Start a Quarkus app with PostgreSQL + Kafka Dev Services |
| Module 3 | Customize Dev Services for your tech stack |
| Module 4 | Write integration tests using real databases |
