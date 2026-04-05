# Spring Profiles & Configuration - Curriculum

## Module 1: Externalized Configuration
- [ ] `application.properties` vs `application.yml`
- [ ] Property sources priority order (command line > env vars > file)
- [ ] `@Value("${property.name}")` injection
- [ ] `@Value` with defaults: `@Value("${port:8080}")`
- [ ] `@ConfigurationProperties` - type-safe config binding
- [ ] `@ConfigurationPropertiesScan`
- [ ] Nested properties and lists
- [ ] Validation with `@Validated` on config properties

## Module 2: Profiles
- [ ] `spring.profiles.active` - activating profiles
- [ ] `application-{profile}.yml` - profile-specific files
- [ ] `@Profile("dev")` on beans
- [ ] Multiple active profiles
- [ ] Profile groups (Spring Boot 2.4+)
- [ ] Default profile
- [ ] Profile-specific logging configuration

## Module 3: Advanced Configuration
- [ ] `spring.config.import` for additional config sources
- [ ] Config from environment variables: `SPRING_DATASOURCE_URL`
- [ ] Config from command line: `--server.port=9090`
- [ ] Placeholder resolution: `${app.base-url}/api`
- [ ] Random values: `${random.int}`, `${random.uuid}`
- [ ] `@PropertySource` for custom property files
- [ ] Encrypted properties (Jasypt, Spring Cloud Vault)

## Module 4: Feature Flags & Toggles
- [ ] Feature flags with profiles
- [ ] Feature flags with `@ConditionalOnProperty`
- [ ] Runtime toggles with Spring Cloud Config + `@RefreshScope`
- [ ] Feature flag libraries: Togglz, Unleash, LaunchDarkly
- [ ] A/B testing with feature flags
- [ ] Gradual rollout strategies

## Module 5: Multi-Environment Management
- [ ] Environment strategy: local, dev, staging, production
- [ ] Secrets management: never in source code
- [ ] Spring Cloud Vault for secrets
- [ ] Kubernetes ConfigMaps and Secrets
- [ ] Docker env vars and `.env` files
- [ ] Config validation on startup (fail-fast)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Multi-profile app: dev (H2), staging (Postgres), prod (Postgres + Redis) |
| Module 3 | Externalize all config, zero hardcoded values |
| Module 4 | Implement feature flag for new API endpoint |
| Module 5 | Deploy same artifact to 3 environments with different configs |

## Key Resources
- Spring Boot Externalized Configuration Reference
- 12-Factor App: Config
