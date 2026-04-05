# Spring WebFlux (Reactive) - Curriculum

## Module 1: Reactive Programming Basics
- [ ] Reactive Manifesto: responsive, resilient, elastic, message-driven
- [ ] Imperative vs reactive programming model
- [ ] Backpressure concept
- [ ] Project Reactor: the reactive library behind WebFlux
- [ ] `Mono<T>` - 0 or 1 element
- [ ] `Flux<T>` - 0 to N elements

## Module 2: Reactor Operators
- [ ] Creation: `Mono.just()`, `Flux.fromIterable()`, `Flux.range()`, `Mono.empty()`, `Mono.error()`
- [ ] Transform: `map()`, `flatMap()`, `flatMapMany()`, `switchIfEmpty()`
- [ ] Filter: `filter()`, `take()`, `skip()`, `distinct()`
- [ ] Combine: `zip()`, `merge()`, `concat()`, `combineLatest()`
- [ ] Error handling: `onErrorReturn()`, `onErrorResume()`, `retry()`, `retryWhen()`
- [ ] Side effects: `doOnNext()`, `doOnError()`, `doOnComplete()`, `doFinally()`
- [ ] Blocking bridge: `block()`, `blockFirst()` (only for tests/migration)

## Module 3: WebFlux Controllers
- [ ] `@RestController` with reactive return types (`Mono`, `Flux`)
- [ ] Annotated controllers vs functional endpoints (RouterFunction)
- [ ] `ServerRequest` and `ServerResponse`
- [ ] `HandlerFunction` and `RouterFunction` DSL
- [ ] Streaming responses: `Flux<T>` with `text/event-stream`
- [ ] Server-Sent Events (SSE)

## Module 4: Reactive Data Access
- [ ] Spring Data R2DBC (reactive relational DB)
- [ ] `ReactiveCrudRepository`
- [ ] R2DBC vs JDBC: when to use which
- [ ] Reactive MongoDB: `ReactiveMongoRepository`
- [ ] Reactive Redis: `ReactiveRedisTemplate`
- [ ] Connection pooling with R2DBC Pool

## Module 5: WebClient
- [ ] `WebClient` - non-blocking HTTP client (replaces RestTemplate)
- [ ] `retrieve()` vs `exchangeToMono()`
- [ ] Request headers, body, query params
- [ ] Error handling: `onStatus()`
- [ ] Timeout and retry configuration
- [ ] `ExchangeFilterFunction` for logging/auth

## Module 6: Reactive Security
- [ ] `@EnableWebFluxSecurity`
- [ ] `SecurityWebFilterChain` (reactive equivalent)
- [ ] `ReactiveAuthenticationManager`
- [ ] `ReactiveUserDetailsService`
- [ ] JWT authentication in reactive stack
- [ ] CORS configuration for WebFlux

## Module 7: Testing Reactive
- [ ] `WebTestClient` for testing WebFlux endpoints
- [ ] `StepVerifier` for testing `Mono` and `Flux`
- [ ] `StepVerifier.create(flux).expectNext().verifyComplete()`
- [ ] Testing with virtual time (`StepVerifier.withVirtualTime()`)
- [ ] `@WebFluxTest` slice testing

## Module 8: When to Use WebFlux
- [ ] WebFlux vs Spring MVC decision guide
- [ ] Use cases: high-concurrency, streaming, gateway, real-time
- [ ] Anti-patterns: blocking calls inside reactive chain
- [ ] Thread model: event-loop (Netty) vs thread-per-request (Tomcat)
- [ ] Performance benchmarks: WebFlux vs MVC under load
- [ ] Migration strategy: MVC to WebFlux

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Reactor exercises: transform, combine, error handling |
| Modules 3-4 | Build a reactive REST API with R2DBC |
| Module 5 | Build a reactive API gateway aggregating multiple services |
| Modules 6-7 | Add JWT security and full test coverage |
| Module 8 | Benchmark MVC vs WebFlux for same API |

## Key Resources
- Spring WebFlux Reference Documentation
- Project Reactor Reference Guide
- Reactive Spring - Josh Long
