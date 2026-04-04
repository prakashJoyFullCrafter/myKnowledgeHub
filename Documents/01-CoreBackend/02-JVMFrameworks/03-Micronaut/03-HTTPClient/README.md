# Micronaut HTTP Client - Curriculum

## Module 1: Declarative HTTP Client
- [ ] `@Client` annotation - interface-based client
- [ ] `@Get`, `@Post`, `@Put`, `@Delete` on interface methods
- [ ] Path variables and query parameters
- [ ] Request/response body handling
- [ ] Low-level `HttpClient` for manual control

## Module 2: Configuration & Customization
- [ ] Client configuration (timeouts, connection pool)
- [ ] Service discovery integration
- [ ] Client filters (`@ClientFilter`)
- [ ] Error handling and custom exceptions
- [ ] Retry and circuit breaker on client calls

## Module 3: Reactive HTTP Client
- [ ] Reactive return types (`Mono`, `Flux`, `Publisher`)
- [ ] Streaming responses
- [ ] Server-Sent Events consumption
- [ ] Blocking vs non-blocking clients

## Module 4: Testing
- [ ] `@MicronautTest` with embedded server
- [ ] `@Client("/")` for test client
- [ ] Mocking external services with `@MockBean`
- [ ] WireMock for HTTP client testing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a declarative client for a public API |
| Module 3 | Stream large responses reactively |
| Module 4 | Test all client interactions |
