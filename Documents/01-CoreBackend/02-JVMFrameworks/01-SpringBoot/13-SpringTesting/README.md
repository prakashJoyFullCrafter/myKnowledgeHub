# Spring Testing - Curriculum

## Module 1: Unit Testing Spring Components
- [ ] Testing services with Mockito (`@Mock`, `@InjectMocks`)
- [ ] `@ExtendWith(MockitoExtension.class)`
- [ ] Testing without Spring context (plain JUnit 5)
- [ ] Testing utility classes and mappers
- [ ] When to mock vs when to use real dependencies

## Module 2: Spring Boot Test Slices
- [ ] `@SpringBootTest` - full application context
- [ ] `@WebMvcTest` - controller layer only (MockMvc)
- [ ] `@DataJpaTest` - JPA repositories only (embedded DB)
- [ ] `@JsonTest` - JSON serialization/deserialization
- [ ] `@RestClientTest` - REST client testing
- [ ] `@WebFluxTest` - reactive controller testing
- [ ] Why slices? Faster tests, smaller context

## Module 3: MockMvc & WebTestClient
- [ ] `MockMvc` - test MVC controllers without starting server
- [ ] `perform()`, `andExpect()`, `andReturn()`
- [ ] Testing status codes, headers, JSON response body
- [ ] `jsonPath()` for response assertions
- [ ] Testing with authentication (`@WithMockUser`, `SecurityMockMvcRequestPostProcessors`)
- [ ] `WebTestClient` for WebFlux endpoints

## Module 4: Integration Testing with Testcontainers
- [ ] `@Testcontainers` + `@Container` for real dependencies
- [ ] PostgreSQL, MySQL, MongoDB containers
- [ ] Kafka, Redis, RabbitMQ containers
- [ ] `@ServiceConnection` (Spring Boot 3.1+) - auto-config from container
- [ ] `@DynamicPropertySource` for injecting container URLs
- [ ] Reusable containers for test suite speed

## Module 5: Testing Data Layer
- [ ] `@DataJpaTest` with embedded H2 / Testcontainers PostgreSQL
- [ ] `@Sql` for test data setup
- [ ] `@Transactional` in tests (auto-rollback)
- [ ] Testing custom queries (`@Query`)
- [ ] Testing Specifications and projections
- [ ] `TestEntityManager` for JPA testing

## Module 6: Testing Security
- [ ] `@WithMockUser(roles = "ADMIN")` for role testing
- [ ] `@WithAnonymousUser`
- [ ] Custom `@WithMockUser` annotations
- [ ] Testing JWT authentication end-to-end
- [ ] Testing OAuth2 protected endpoints
- [ ] Security test for unauthorized access

## Module 7: Testing Messaging
- [ ] `@EmbeddedKafka` for Kafka integration tests
- [ ] `OutputDestination` / `InputDestination` for Spring Cloud Stream
- [ ] Testing RabbitMQ with Testcontainers
- [ ] Testing event listeners with `ApplicationEvents` (Spring 5.3+)
- [ ] Verifying message content and headers

## Module 8: Test Architecture & Best Practices
- [ ] Testing pyramid: unit > integration > E2E
- [ ] Test naming: `should_ReturnUser_When_ValidId`
- [ ] Test fixtures and builders (Object Mother pattern)
- [ ] `@TestConfiguration` for test-specific beans
- [ ] Test profiles: `application-test.yml`
- [ ] Parallel test execution
- [ ] CI pipeline integration: fail-fast, coverage gates
- [ ] Flaky test detection and prevention

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Unit test all service classes with Mockito |
| Modules 2-3 | Slice test all controllers with MockMvc |
| Modules 4-5 | Integration test repositories with Testcontainers |
| Module 6 | Security tests for all protected endpoints |
| Module 7 | Test Kafka producer/consumer flow |
| Module 8 | Achieve >80% coverage with pyramid-balanced tests |

## Key Resources
- Spring Boot Testing Reference
- JUnit 5 User Guide
- Testcontainers documentation
- Spring Security Testing Reference
