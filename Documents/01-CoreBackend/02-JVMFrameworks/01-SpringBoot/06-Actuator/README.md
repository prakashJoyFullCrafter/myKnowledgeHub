# Spring Boot Actuator - Curriculum

## Module 1: Actuator Basics
- [ ] Adding `spring-boot-starter-actuator`
- [ ] Default endpoints: `/actuator/health`, `/actuator/info`
- [ ] Exposing endpoints (web vs JMX)
- [ ] `management.endpoints.web.exposure.include`
- [ ] Securing actuator endpoints

## Module 2: Health Checks
- [ ] Built-in health indicators (db, disk, redis, kafka)
- [ ] Custom `HealthIndicator` implementation
- [ ] Health groups (`liveness`, `readiness`)
- [ ] Kubernetes probes: `/actuator/health/liveness`, `/actuator/health/readiness`
- [ ] Health status mapping to HTTP codes

## Module 3: Metrics with Micrometer
- [ ] Micrometer as metrics facade
- [ ] Built-in metrics: JVM, HTTP, database, cache
- [ ] Custom metrics: `Counter`, `Gauge`, `Timer`, `DistributionSummary`
- [ ] `@Timed` annotation
- [ ] Metric tags and dimensions
- [ ] Exporting to Prometheus, Datadog, CloudWatch

## Module 4: Application Info & Environment
- [ ] `/actuator/info` - build info, git info
- [ ] `/actuator/env` - environment properties
- [ ] `/actuator/configprops` - configuration properties
- [ ] `/actuator/beans` - all beans in context
- [ ] `/actuator/mappings` - all request mappings
- [ ] `/actuator/loggers` - dynamic log level changes

## Module 5: Production Setup
- [ ] Running actuator on a separate port
- [ ] Custom endpoint creation (`@Endpoint`, `@ReadOperation`, `@WriteOperation`)
- [ ] Prometheus + Grafana dashboard setup
- [ ] Alerting based on metrics
- [ ] Distributed tracing with Micrometer Tracing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Add health checks for all dependencies |
| Module 3 | Add custom business metrics (orders/min, API latency) |
| Module 4 | Dynamic log level change in production |
| Module 5 | Set up Prometheus + Grafana dashboard for your app |

## Key Resources
- Spring Boot Actuator Reference
- Micrometer documentation
- Prometheus + Grafana guides
