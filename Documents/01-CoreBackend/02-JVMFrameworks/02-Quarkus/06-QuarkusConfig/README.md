# Quarkus Configuration - Curriculum

## Module 1: MicroProfile Config Basics
- [ ] Quarkus uses **MicroProfile Config** (not Spring-style `@Value`)
- [ ] `application.properties` — primary config file (YAML supported with `quarkus-config-yaml`)
- [ ] `@ConfigProperty(name = "app.greeting")` — inject config values
- [ ] Default values: `@ConfigProperty(name = "app.port", defaultValue = "8080")`
- [ ] Optional config: `Optional<String>` type
- [ ] Config sources priority: system props > env vars > `.env` > `application.properties`

## Module 2: Type-Safe Config with @ConfigMapping
- [ ] `@ConfigMapping(prefix = "app")` — type-safe config interface (Quarkus-native, replaces `@ConfigProperties`)
- [ ] Nested config: interface hierarchy maps to property hierarchy
- [ ] List and Map support: `List<String>`, `Map<String, String>`
- [ ] Validation: Bean Validation on config (`@Size`, `@Min`, `@NotBlank`)
- [ ] `@WithDefault("value")` — defaults on interface methods
- [ ] `@WithName("custom-key")` — custom property name mapping

## Module 3: Profiles & Environment
- [ ] **Build-time profiles**: `%dev.`, `%test.`, `%prod.` prefix in properties
  - [ ] `%dev.quarkus.datasource.db-kind=h2`
  - [ ] `%prod.quarkus.datasource.db-kind=postgresql`
- [ ] Active profile: `quarkus.profile=staging` or `-Dquarkus.profile=staging`
- [ ] Custom profiles: `%staging.quarkus.datasource.jdbc.url=...`
- [ ] Environment variables: `QUARKUS_DATASOURCE_JDBC_URL` (auto-mapped)
- [ ] `.env` file support for local development
- [ ] **Build-time vs runtime** config: some Quarkus config is fixed at build time (cannot change at runtime)
  - [ ] `quarkus.package.type=native` — build-time only
  - [ ] `quarkus.datasource.jdbc.url` — runtime overridable

## Module 4: Advanced Config Sources
- [ ] Config from Kubernetes ConfigMaps/Secrets: `quarkus-kubernetes-config`
- [ ] Config from Vault: `quarkus-vault` extension
- [ ] Config from Consul: `quarkus-consul-config`
- [ ] Custom `ConfigSource`: implement `org.eclipse.microprofile.config.spi.ConfigSource`
- [ ] Config ordinal: priority ordering of config sources
- [ ] Hot reload in dev mode: config changes applied instantly with `quarkus dev`

## Module 5: Quarkus vs Spring Config Comparison
- [ ] `@ConfigProperty` (Quarkus) vs `@Value` (Spring)
- [ ] `@ConfigMapping` (Quarkus) vs `@ConfigurationProperties` (Spring)
- [ ] `%dev.` profile prefix (Quarkus) vs `application-dev.properties` (Spring)
- [ ] Build-time fixed config (Quarkus-specific, no Spring equivalent)
- [ ] MicroProfile Config (standard) vs Spring Environment (proprietary)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build app with type-safe config: database, app settings, feature flags |
| Module 3 | Configure dev (H2), test (Testcontainers), prod (PostgreSQL) profiles |
| Module 4 | Load secrets from Vault or Kubernetes Secrets in a deployed app |
| Module 5 | Port a Spring Boot `@ConfigurationProperties` class to Quarkus `@ConfigMapping` |

## Key Resources
- Quarkus Configuration Reference Guide
- MicroProfile Config specification
- Quarkus "All Config" reference (quarkus.io/guides/all-config)
