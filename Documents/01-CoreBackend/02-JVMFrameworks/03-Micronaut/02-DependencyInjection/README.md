# Micronaut Dependency Injection - Curriculum

## Module 1: Bean Definition
- [ ] `@Singleton`, `@Prototype`, `@RequestScope`
- [ ] `@Factory` and `@Bean` for third-party classes
- [ ] Constructor injection (default, no annotation needed)
- [ ] `@Inject` for field/setter injection

## Module 2: Qualifiers & Conditional Beans
- [ ] `@Named` qualifier
- [ ] `@Primary` for default beans
- [ ] `@Requires` - conditional bean loading
- [ ] `@EachProperty` and `@EachBean` for dynamic beans
- [ ] Bean replacements: `@Replaces`

## Module 3: Configuration
- [ ] `application.yml` configuration
- [ ] `@ConfigurationProperties` - type-safe config
- [ ] `@Value` and `@Property`
- [ ] Environment-specific config (dev, test, prod)
- [ ] Distributed configuration (Consul, Vault)

## Module 4: AOP in Micronaut
- [ ] Compile-time AOP (no runtime proxies)
- [ ] `@Around` advice
- [ ] `@Cacheable`, `@Retryable`, `@CircuitBreaker`
- [ ] Custom AOP annotations
- [ ] Introduction advice (`@Introduction`)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a service layer with multiple implementations |
| Module 3 | Multi-environment config with profiles |
| Module 4 | Add caching and retry with AOP |
