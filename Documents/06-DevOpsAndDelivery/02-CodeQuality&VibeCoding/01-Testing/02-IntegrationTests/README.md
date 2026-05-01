# Integration Testing - Expert Curriculum

## Module 1: Integration Test Fundamentals
- [ ] What is an integration test? Testing multiple components together
- [ ] Unit vs integration vs E2E: different scope, different speed, different value
- [ ] Testing pyramid: many unit tests, fewer integration, fewest E2E
- [ ] Testing trophy (Kent C. Dodds): more integration tests for confidence
- [ ] When to write integration tests: boundaries, data flow, configuration

## Module 2: Spring Boot Test Annotations
- [ ] `@SpringBootTest` - loads full application context
- [ ] `@SpringBootTest(webEnvironment = RANDOM_PORT)` - real server
- [ ] `@SpringBootTest(webEnvironment = MOCK)` - mock servlet (default)
- [ ] Test slices (faster, smaller context):
  - [ ] `@WebMvcTest` - controller layer only
  - [ ] `@DataJpaTest` - JPA repositories only
  - [ ] `@JsonTest` - JSON serialization only
  - [ ] `@RestClientTest` - REST client only
  - [ ] `@WebFluxTest` - reactive controller only
- [ ] `@AutoConfigureMockMvc` - add MockMvc to `@SpringBootTest`
- [ ] `@Import` - add specific beans to slice test

## Module 3: MockMvc (Controller Testing)
- [ ] `MockMvc` - testing controllers without starting HTTP server
- [ ] `perform(get("/api/users"))` - simulating HTTP requests
- [ ] `andExpect(status().isOk())` - asserting status codes
- [ ] `andExpect(jsonPath("$.name").value("John"))` - asserting JSON response
- [ ] `andExpect(content().contentType(MediaType.APPLICATION_JSON))`
- [ ] Testing POST with body: `perform(post("/api/users").content(json).contentType(JSON))`
- [ ] Testing error responses: 400, 404, 500
- [ ] Testing with authentication: `@WithMockUser`, `with(csrf())`
- [ ] `@MockBean` - replacing beans in application context with mocks

## Module 4: Database Integration Tests
- [ ] `@DataJpaTest` - auto-configures embedded database + JPA
- [ ] H2 for fast in-memory tests vs Testcontainers for real database
- [ ] `@Sql("/test-data.sql")` - loading test data before test
- [ ] `@Transactional` - auto-rollback after each test (default in `@DataJpaTest`)
- [ ] `TestEntityManager` - JPA testing helper
- [ ] Testing custom `@Query` methods
- [ ] Testing Specification and Criteria queries
- [ ] Testing migrations with Flyway/Liquibase in test context

## Module 5: API Integration Tests (Full Stack)
- [ ] `TestRestTemplate` - for `@SpringBootTest(webEnvironment = RANDOM_PORT)`
- [ ] `WebTestClient` - for WebFlux or reactive tests
- [ ] Testing full request flow: controller → service → repository → database
- [ ] Testing error handling end-to-end
- [ ] Testing pagination and sorting
- [ ] Testing file upload/download
- [ ] Testing with multiple profiles: `@ActiveProfiles("test")`

## Module 6: External Service Testing
- [ ] WireMock: mock external HTTP services
- [ ] `@WireMockTest` or programmatic `WireMockServer`
- [ ] Stubbing responses: `stubFor(get("/api/external").willReturn(okJson("...")))`
- [ ] Verifying requests were made: `verify(getRequestedFor(urlEqualTo("/api/external")))`
- [ ] Simulating timeouts and errors
- [ ] Testing circuit breaker behavior with WireMock

## Module 7: Test Configuration
- [ ] `application-test.yml` - test-specific config
- [ ] `@ActiveProfiles("test")` - activating test profile
- [ ] `@TestConfiguration` - beans only for tests
- [ ] `@DynamicPropertySource` - dynamic properties (e.g., Testcontainers ports)
- [ ] `@TestPropertySource` - overriding specific properties
- [ ] Test ordering: `@TestMethodOrder(OrderAnnotation.class)` (rarely needed)

## Module 8: Performance & Best Practices
- [ ] Keep integration tests focused: test one integration point per test
- [ ] Use test slices over `@SpringBootTest` when possible (10x faster)
- [ ] Parallel test execution: `junit.jupiter.execution.parallel.enabled=true`
- [ ] Shared Testcontainers across test classes (singleton pattern)
- [ ] CI pipeline: separate unit and integration test stages
- [ ] Tagging: `@Tag("integration")` for selective execution
- [ ] Database cleanup strategies: rollback vs truncate vs fixtures

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Write slice tests for every controller and repository |
| Module 3 | Full MockMvc test suite for a REST API (all endpoints, all error cases) |
| Modules 4-5 | Database integration tests with Testcontainers PostgreSQL |
| Module 6 | Mock an external payment API with WireMock |
| Modules 7-8 | Optimize test suite: parallel execution, test slices, CI pipeline |

## Key Resources
- Spring Boot Testing Reference Documentation
- Testing Spring Boot Applications (Baeldung series)
- WireMock documentation (wiremock.org)
