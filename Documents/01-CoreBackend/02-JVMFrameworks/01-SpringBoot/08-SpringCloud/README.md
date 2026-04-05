# Spring Cloud - Curriculum

## Module 1: Service Discovery
- [ ] Why service discovery? Dynamic service registration
- [ ] Eureka Server: `@EnableEurekaServer`
- [ ] Eureka Client: `@EnableDiscoveryClient`
- [ ] Service registration and heartbeat
- [ ] Client-side load balancing with Spring Cloud LoadBalancer
- [ ] Alternatives: Consul, Kubernetes service discovery

## Module 2: API Gateway
- [ ] Spring Cloud Gateway (reactive, non-blocking)
- [ ] Route configuration: predicates and filters
- [ ] Path-based routing, header-based routing
- [ ] Rate limiting filter (`RequestRateLimiter`)
- [ ] Circuit breaker filter (Resilience4j integration)
- [ ] Global filters: logging, authentication, CORS
- [ ] Load balancing through gateway (`lb://service-name`)

## Module 3: Configuration Management
- [ ] Spring Cloud Config Server: centralized config
- [ ] Config Client: `bootstrap.yml` / `spring.config.import`
- [ ] Git-backed configuration repository
- [ ] Config refresh: `@RefreshScope`, `/actuator/refresh`
- [ ] Spring Cloud Bus for broadcasting config changes
- [ ] Vault integration for secrets
- [ ] Alternatives: Consul KV, Kubernetes ConfigMaps

## Module 4: Inter-Service Communication
- [ ] OpenFeign: declarative HTTP client (`@FeignClient`)
- [ ] Feign interceptors for auth propagation
- [ ] Feign error handling and fallbacks
- [ ] RestClient / WebClient as alternatives
- [ ] Service-to-service authentication (JWT propagation, mTLS)

## Module 5: Resilience Patterns (Spring Cloud Circuit Breaker)
- [ ] Resilience4j integration with Spring Cloud
- [ ] `@CircuitBreaker` on Feign clients
- [ ] Fallback methods
- [ ] Bulkhead and rate limiter
- [ ] Retry with backoff
- [ ] Monitoring circuit breaker state via Actuator

## Module 6: Distributed Tracing
- [ ] Micrometer Tracing (formerly Spring Cloud Sleuth)
- [ ] Trace ID and Span ID propagation
- [ ] Integration with Zipkin / Jaeger
- [ ] Correlation across microservices
- [ ] Trace IDs in logs (`[traceId, spanId]`)

## Module 7: Event-Driven with Spring Cloud Stream
- [ ] Spring Cloud Stream: abstraction over Kafka/RabbitMQ
- [ ] Binder concept: Kafka binder, RabbitMQ binder
- [ ] `Function`, `Consumer`, `Supplier` programming model
- [ ] Message channels: input/output bindings
- [ ] Error handling and DLQ in Stream
- [ ] Partitioning and consumer groups

## Module 8: Deployment Patterns
- [ ] Spring Cloud Kubernetes: ConfigMap/Secret integration
- [ ] Service mesh vs Spring Cloud - when to use which
- [ ] Sidecar pattern with Spring Cloud
- [ ] Spring Cloud + Docker Compose for local dev
- [ ] Production checklist: health checks, graceful shutdown

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build 3 microservices + Eureka + Gateway |
| Module 3 | Centralized config with Git-backed Config Server |
| Modules 4-5 | Inter-service calls with Feign + circuit breaker |
| Module 6 | Distributed tracing across all services |
| Module 7 | Event-driven communication with Spring Cloud Stream |
| Module 8 | Deploy full stack to Docker Compose / Kubernetes |

## Key Resources
- Spring Cloud Reference Documentation
- Microservices with Spring Boot and Spring Cloud - Magnus Larsson
- Spring Cloud samples on GitHub
