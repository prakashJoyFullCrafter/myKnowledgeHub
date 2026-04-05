# Spring Boot Internals - Curriculum

## Module 1: Auto-Configuration Deep Dive
- [ ] How `@SpringBootApplication` works (`@Configuration` + `@EnableAutoConfiguration` + `@ComponentScan`)
- [ ] `spring.factories` (Boot 2.x) vs `AutoConfiguration.imports` (Boot 3.x)
- [ ] `@Conditional` family: `@ConditionalOnClass`, `@ConditionalOnMissingBean`, `@ConditionalOnProperty`
- [ ] Auto-configuration ordering with `@AutoConfigureBefore`, `@AutoConfigureAfter`
- [ ] Viewing active auto-configs: `--debug` or `/actuator/conditions`
- [ ] Excluding auto-configuration: `@SpringBootApplication(exclude = ...)`

## Module 2: Creating Custom Starters
- [ ] Starter module structure: `autoconfigure` + `starter`
- [ ] Writing `@Configuration` classes for your library
- [ ] Registering in `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
- [ ] `@ConfigurationProperties` for starter configuration
- [ ] Conditional activation of your starter
- [ ] Testing your starter
- [ ] Publishing starter to Maven repository

## Module 3: Spring Boot Lifecycle
- [ ] `SpringApplication.run()` - what happens step by step
- [ ] `ApplicationContext` refresh lifecycle
- [ ] `ApplicationRunner` and `CommandLineRunner` - run on startup
- [ ] `SmartLifecycle` - fine-grained lifecycle control
- [ ] `ApplicationStartedEvent`, `ApplicationReadyEvent`, `ContextClosedEvent`
- [ ] Graceful shutdown: `server.shutdown=graceful`
- [ ] Startup time analysis: `ApplicationStartup` and startup actuator

## Module 4: Embedded Server
- [ ] Tomcat (default), Jetty, Undertow, Netty (WebFlux)
- [ ] Switching embedded server
- [ ] Server configuration: port, SSL, compression, access logs
- [ ] Thread pool tuning: `server.tomcat.threads.max`, `server.tomcat.threads.min-spare`
- [ ] Connection limits and timeouts
- [ ] Running behind a reverse proxy (forwarded headers)

## Module 5: Spring Boot DevTools
- [ ] Automatic restart on code changes
- [ ] LiveReload for browser refresh
- [ ] Remote DevTools for remote development
- [ ] Property defaults in dev mode
- [ ] H2 console access in dev

## Module 6: Production Readiness
- [ ] Building fat JAR: `spring-boot-maven-plugin` / `spring-boot-gradle-plugin`
- [ ] Building Docker images: Buildpacks, Jib, multi-stage Dockerfile
- [ ] JVM tuning: `-Xmx`, `-Xms`, G1GC/ZGC selection
- [ ] Container-aware JVM: `-XX:+UseContainerSupport`
- [ ] GraalVM native image with Spring Boot 3
- [ ] Startup optimization: lazy init, AOT processing
- [ ] Health checks, readiness/liveness probes for Kubernetes
- [ ] Structured logging (JSON) for production
- [ ] Security hardening: actuator endpoints, error details, HTTPS

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Run `--debug`, analyze active auto-configurations |
| Module 2 | Create a custom starter (e.g., common logging/audit library) |
| Module 3 | Add `ApplicationRunner` + graceful shutdown handling |
| Module 4 | Benchmark Tomcat vs Undertow, tune thread pool |
| Module 5 | Set up DevTools for fast development cycle |
| Module 6 | Production-ready checklist: native image, Docker, K8s probes |

## Key Resources
- Spring Boot Reference: Auto-configuration
- Spring Boot Reference: Production-ready Features
- Pro Spring Boot 3 - Felipe Gutierrez
- Spring Boot source code (best reference for internals)
