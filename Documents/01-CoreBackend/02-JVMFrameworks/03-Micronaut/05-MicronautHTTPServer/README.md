# Micronaut HTTP Server - Curriculum

## Module 1: Controllers & Routing
- [ ] `@Controller("/api/users")` — define a controller with base path
- [ ] `@Get("/{id}")`, `@Post`, `@Put("/{id}")`, `@Delete("/{id}")`, `@Patch`
- [ ] `@PathVariable`, `@QueryValue`, `@Header`, `@CookieValue`
- [ ] `@Body` — request body binding (JSON by default with Jackson)
- [ ] `@Status(HttpStatus.CREATED)` — set response status
- [ ] `@Produces` / `@Consumes` — content type negotiation
- [ ] `HttpResponse<T>` — full control over status, headers, body

## Module 2: Request/Response Handling
- [ ] JSON serialization with Jackson (default) or Micronaut Serialization (`@Serdeable`)
- [ ] **Micronaut Serialization**: compile-time, reflection-free, GraalVM-friendly
  - [ ] `@Serdeable` on DTOs (replaces Jackson annotations for native builds)
  - [ ] `@SerdeImport` for third-party classes
- [ ] `@RequestBean` — aggregate multiple parameters into a POJO
- [ ] File upload: `CompletedFileUpload`, `StreamingFileUpload`
- [ ] File download: `StreamedFile`, `SystemFile`
- [ ] Server-Sent Events: `@Get("/stream") Flux<Event<T>>`

## Module 3: Validation & Error Handling
- [ ] Bean Validation: `@Valid` on `@Body`, `@NotNull`, `@Size`, `@Email`, `@Pattern`
- [ ] Custom constraint validators
- [ ] `@Error` annotation — local exception handler on controller
- [ ] Global `ExceptionHandler<T, HttpResponse>` — handle specific exception types
- [ ] `@Error(global = true)` — global error handler
- [ ] Problem Details (RFC 7807) with custom error response body
- [ ] Validation error response format customization

## Module 4: Filters & Interceptors
- [ ] `@Filter("/api/**")` — HTTP server filter (before/after request processing)
- [ ] `HttpServerFilter` interface: `doFilter(request, chain)`
- [ ] Filter ordering with `@Order`
- [ ] CORS configuration: `micronaut.server.cors`
- [ ] Request logging filter
- [ ] Authentication/authorization filter

## Module 5: Reactive & Server Configuration
- [ ] Reactive return types: `Mono<T>`, `Flux<T>`, `Publisher<T>`, `CompletableFuture<T>`
- [ ] Blocking vs non-blocking: Micronaut uses Netty (non-blocking by default)
- [ ] `@ExecuteOn(TaskExecutors.IO)` — offload blocking work to I/O thread pool
- [ ] Server configuration: `micronaut.server.port`, `micronaut.server.host`
- [ ] SSL/TLS configuration
- [ ] Static resource serving: `micronaut.router.static-resources`
- [ ] Embedded server for testing: `@MicronautTest` auto-starts server

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a CRUD REST API with DTOs and Micronaut Serialization |
| Module 3 | Add validation on all endpoints, global error handler with RFC 7807 |
| Module 4 | Add request logging filter and CORS configuration |
| Module 5 | Convert blocking DB calls to reactive with `@ExecuteOn`, configure SSL |

## Key Resources
- Micronaut HTTP Server documentation
- Micronaut Serialization guide
- Micronaut Guides (guides.micronaut.io)
