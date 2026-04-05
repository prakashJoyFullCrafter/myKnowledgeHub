# Kotlin for Spring Boot - Curriculum

## Module 1: Project Setup
- [ ] Spring Initializr with Kotlin
- [ ] Gradle Kotlin DSL (`build.gradle.kts`) setup
- [ ] Essential plugins: `kotlin-spring` (all-open), `kotlin-jpa` (no-arg)
- [ ] Jackson Kotlin module: `jackson-module-kotlin`
- [ ] Kotlin compiler options: `-Xjsr305=strict` for null safety
- [ ] `@SpringBootApplication` and `main()` as top-level function

## Module 2: Idiomatic Spring + Kotlin
- [ ] Constructor injection (no `@Autowired` needed - Kotlin single constructor)
- [ ] `val` properties for injected dependencies (immutable by default)
- [ ] Data classes as DTOs and request/response bodies
- [ ] Nullable types for optional dependencies and request params
- [ ] `lateinit var` for `@Autowired` field injection (when needed)
- [ ] Extension functions for adding utilities to Spring classes
- [ ] `when` expression for request routing logic

## Module 3: REST Controllers in Kotlin
- [ ] `@RestController` with Kotlin
- [ ] Nullable `@RequestParam`: `fun search(@RequestParam query: String?)`
- [ ] Data class request/response: automatic Jackson serialization
- [ ] `ResponseEntity` with Kotlin: `ResponseEntity.ok(body)`, `ResponseEntity.notFound().build()`
- [ ] Validation: `@field:NotBlank` (annotation use-site targets for data class)
- [ ] Exception handling with `@RestControllerAdvice`
- [ ] Sealed classes for API responses: `sealed class ApiResponse`

## Module 4: Spring Data JPA with Kotlin
- [ ] Entity classes: `@Entity class User(...)` with `kotlin-jpa` plugin
- [ ] `val` vs `var` in entities (JPA requires mutable for proxying)
- [ ] ID strategies with nullable `val id: Long? = null`
- [ ] Kotlin-friendly repositories: `fun findByEmail(email: String): User?`
- [ ] Null-safe return types from repositories
- [ ] Projection with data classes
- [ ] `@Embeddable` value objects with Kotlin

## Module 5: Coroutine Controllers (WebFlux)
- [ ] `suspend fun` controller endpoints
- [ ] `Flow<T>` return type for streaming
- [ ] `spring-boot-starter-webflux` with Kotlin coroutines
- [ ] `coRouter { }` - Kotlin DSL for functional endpoints
- [ ] Reactive data access with `R2DBC` + coroutines
- [ ] `awaitSingle()`, `awaitFirstOrNull()` - converting reactive types
- [ ] Structured concurrency in Spring controllers

## Module 6: Kotlin Bean Definition DSL
- [ ] `beans { }` DSL: `bean<MyService>()`, `bean { MyService(ref()) }`
- [ ] Router DSL: `router { GET("/api/users") { ... } }`
- [ ] Registering beans programmatically
- [ ] When to use DSL vs annotations
- [ ] Combining DSL with annotation-based config

## Module 7: Configuration & Profiles
- [ ] `@ConfigurationProperties` with data classes (immutable config)
- [ ] `@ConstructorBinding` (default in Boot 3 with Kotlin)
- [ ] Nullable config properties for optional values
- [ ] `@Value` with Kotlin: `@Value("\${app.name}") val appName: String`
- [ ] Profile-specific config with Kotlin

## Module 8: Kotlin + Spring Ecosystem
- [ ] Spring Security with Kotlin DSL: `http { authorizeHttpRequests { ... } }`
- [ ] Spring Kafka with Kotlin: `@KafkaListener` + data class payloads
- [ ] Spring Cache with Kotlin: `@Cacheable` on suspend functions (caveats)
- [ ] Spring AOP with Kotlin: open classes requirement
- [ ] Kotlin scripting for Spring Shell
- [ ] Kotlin + Flyway/Liquibase migrations

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up Spring Boot + Kotlin project with proper plugins |
| Module 3 | Build REST API with data class DTOs, sealed class responses |
| Module 4 | JPA CRUD with Kotlin entities and null-safe repositories |
| Module 5 | Convert REST API to coroutine-based with WebFlux |
| Module 6 | Rewrite bean config using Kotlin DSL |
| Modules 7-8 | Full app: config, security, caching, messaging in Kotlin |

## Key Resources
- Spring Boot Kotlin support documentation
- Spring Framework Kotlin extensions reference
- Kotlin + Spring Boot tutorials (spring.io/guides)
- Programming Spring Boot with Kotlin (Baeldung)
