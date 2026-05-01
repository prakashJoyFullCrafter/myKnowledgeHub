# Testcontainers - Expert Curriculum

## Module 1: Testcontainers Basics
- [ ] What is Testcontainers? Docker containers for integration tests
- [ ] Why? Real dependencies (no mocks, no H2 pretending to be PostgreSQL)
- [ ] Prerequisites: Docker running on machine / CI
- [ ] `@Testcontainers` and `@Container` annotations (JUnit 5)
- [ ] Container lifecycle: starts before tests, stops after
- [ ] First test: `PostgreSQLContainer` with `@DataJpaTest`

## Module 2: Database Containers
- [ ] `PostgreSQLContainer` - real PostgreSQL for JPA tests
- [ ] `MySQLContainer` - MySQL integration
- [ ] `MongoDBContainer` - MongoDB integration
- [ ] `@DynamicPropertySource` - injecting container URL/port into Spring config
- [ ] `@ServiceConnection` (Spring Boot 3.1+) - zero-config container wiring
- [ ] Testing migrations against real database engine
- [ ] Testing database-specific features (JSONB, full-text search)

## Module 3: Messaging Containers
- [ ] `KafkaContainer` - Apache Kafka
- [ ] `RabbitMQContainer` - RabbitMQ
- [ ] `LocalStackContainer` - AWS services (SQS, SNS, S3)
- [ ] Testing producer/consumer flows with real broker
- [ ] Waiting for container readiness: `waitingFor(Wait.forLogMessage(...))`
- [ ] Testing dead letter queues with real broker

## Module 4: Cache & Other Containers
- [ ] `GenericContainer` for Redis: `new GenericContainer<>("redis:7")`
- [ ] Elasticsearch container
- [ ] Keycloak container for OAuth2 testing
- [ ] SMTP container (GreenMail) for email testing
- [ ] Selenium container for browser testing
- [ ] Custom containers with `GenericContainer` and Dockerfiles

## Module 5: Advanced Patterns
- [ ] **Singleton container pattern** - share one container across all test classes
  ```java
  abstract class AbstractIntegrationTest {
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");
    static { postgres.start(); }
  }
  ```
- [ ] Reusable containers: `withReuse(true)` - keep container between test runs
- [ ] Container networking: multiple containers communicating via `Network`
- [ ] `DockerComposeContainer` - start entire docker-compose stack
- [ ] Init scripts: `withInitScript("init.sql")` for database seeding
- [ ] Custom `WaitStrategy` for slow-starting containers
- [ ] Resource mapping: `withCopyFileToContainer()`

## Module 6: Spring Boot Integration
- [ ] `@ServiceConnection` with Testcontainers (Spring Boot 3.1+)
- [ ] `@ImportTestcontainers` for cleaner configuration
- [ ] Spring Boot `DynamicPropertyRegistry` for container properties
- [ ] Test configuration class for container beans
- [ ] Testcontainers + Spring profiles
- [ ] Testcontainers in `@DataJpaTest`, `@SpringBootTest`, `@WebMvcTest`

## Module 7: CI/CD with Testcontainers
- [ ] Docker-in-Docker (DinD) in CI runners
- [ ] GitHub Actions: `services` for Docker, or Testcontainers directly
- [ ] Jenkins: Docker agent with Docker socket mount
- [ ] Testcontainers Cloud: remote container execution (no local Docker needed)
- [ ] Optimizing CI: parallel tests, reusable containers, caching images
- [ ] Handling CI environments without Docker (skip or use Testcontainers Cloud)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Replace H2 tests with Testcontainers PostgreSQL |
| Module 3 | Integration test Kafka producer/consumer with real broker |
| Module 4 | Test Redis caching with real Redis container |
| Module 5 | Implement singleton container + compose for multi-service test |
| Modules 6-7 | Full Spring Boot test suite with `@ServiceConnection` + CI pipeline |

## Key Resources
- Testcontainers documentation (testcontainers.com)
- Testcontainers Java library (GitHub)
- Spring Boot Testcontainers support documentation
