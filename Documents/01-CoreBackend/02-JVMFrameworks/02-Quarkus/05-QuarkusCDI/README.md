# Quarkus CDI (ArC) - Curriculum

## Module 1: ArC — Build-Time DI
- [ ] Quarkus uses **ArC**: CDI implementation that resolves injection at build time (not runtime)
- [ ] Why build-time? Faster startup, lower memory, GraalVM native compatible
- [ ] CDI (Contexts and Dependency Injection) — Jakarta EE standard
- [ ] ArC vs Spring DI: build-time resolution vs runtime reflection-based scanning
- [ ] Only a subset of full CDI spec is supported (no `@ConversationScoped`, no portable extensions)

## Module 2: Beans & Scopes
- [ ] `@ApplicationScoped` — one instance per application (most common, similar to Spring `@Singleton`)
- [ ] `@RequestScoped` — one instance per HTTP request
- [ ] `@SessionScoped` — one instance per HTTP session
- [ ] `@Singleton` — eager singleton (no proxy, unlike `@ApplicationScoped`)
- [ ] `@Dependent` — new instance per injection point (default scope)
- [ ] `@ApplicationScoped` vs `@Singleton`: proxy (lazy) vs no proxy (eager)
- [ ] Defining beans: any class with a scope annotation is automatically a bean

## Module 3: Injection & Qualifiers
- [ ] `@Inject` — constructor, field, or setter injection
- [ ] Constructor injection (recommended, same as Spring)
- [ ] `@Qualifier` — disambiguate multiple implementations of same interface
- [ ] `@Named("myBean")` — qualify by name
- [ ] Custom qualifiers: `@Qualifier @Retention(RUNTIME) @interface Premium {}`
- [ ] `@Default` — marks the default implementation
- [ ] `@Alternative` — override bean for testing or different environments
- [ ] `Instance<T>` — programmatic lookup (lazy resolution, similar to Spring `ObjectProvider<T>`)

## Module 4: Producers & Interceptors
- [ ] `@Produces` — factory method for beans you can't annotate (third-party classes)
- [ ] `@Disposes` — cleanup method for produced beans
- [ ] `@Interceptor` + `@InterceptorBinding` — cross-cutting concerns (logging, timing, auth)
  - [ ] `@AroundInvoke` — wrap method execution
  - [ ] `@Priority` — ordering interceptors
- [ ] `@Decorator` — type-safe alternative to interceptors (extends interface, delegates)
- [ ] `@Observes` — CDI events (similar to Spring `@EventListener`)
  - [ ] `@ObservesAsync` — async event handling
  - [ ] `Event<T>` — firing events

## Module 5: Lifecycle & Advanced
- [ ] `@Startup` — eagerly initialize bean at application start
- [ ] `@PostConstruct` / `@PreDestroy` — lifecycle callbacks
- [ ] `@IfBuildProfile("dev")` — conditional beans based on build profile
- [ ] `@UnlessBuildProfile("prod")` — exclude bean from profile
- [ ] `@LookupIfProperty` / `@LookupUnlessProperty` — conditional on config property
- [ ] `Arc.container()` — programmatic access to the CDI container
- [ ] Unremovable beans: `@Unremovable` to prevent ArC from removing "unused" beans
- [ ] Build-time vs runtime: what ArC resolves at build time vs what defers to runtime

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a service layer with `@ApplicationScoped` services, compare startup with Spring |
| Module 3 | Implement strategy pattern with `@Qualifier` for multiple payment providers |
| Module 4 | Build `@Timed` interceptor for method execution logging |
| Module 5 | Conditional beans: different implementations for dev vs prod profiles |

## Key Resources
- Quarkus CDI Reference Guide
- ArC documentation (Quarkus-specific CDI)
- Jakarta CDI specification
- "Quarkus DI Solution" - quarkus.io guides
