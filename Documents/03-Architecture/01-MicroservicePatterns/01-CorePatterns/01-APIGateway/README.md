# API Gateway - Curriculum

## Module 1: Fundamentals
- [ ] What is an API Gateway? Single entry point for all client requests
- [ ] Why? Clients shouldn't call microservices directly — gateway provides abstraction
- [ ] Gateway responsibilities: routing, authentication, rate limiting, load balancing, logging
- [ ] API Gateway vs reverse proxy vs load balancer (overlap and differences)
- [ ] Gateway as cross-cutting concern aggregator

## Module 2: Core Features
- [ ] **Request routing**: path-based, header-based, query-param-based routing to backend services
- [ ] **Authentication & authorization**: validate JWT/API key before forwarding to services
- [ ] **Rate limiting**: per-client, per-API, per-tier throttling at the edge
- [ ] **Request/response transformation**: modify headers, body, format before forwarding
- [ ] **Request aggregation**: combine multiple backend calls into single client response
- [ ] **Load balancing**: distribute across service instances
- [ ] **Circuit breaker**: prevent cascading failure at gateway level
- [ ] **Caching**: cache frequent responses at gateway
- [ ] **SSL termination**: handle HTTPS at gateway, plain HTTP to backends
- [ ] **Logging & observability**: centralized request logging, trace ID injection

## Module 3: Tools & Implementations
- [ ] **Spring Cloud Gateway**: reactive, Java/Kotlin, predicates + filters, Resilience4j integration
- [ ] **Kong**: plugin-based, Lua/Go plugins, declarative config, enterprise features
- [ ] **AWS API Gateway**: managed, Lambda integration, usage plans, WebSocket support
- [ ] **NGINX**: reverse proxy + API gateway, config-driven, OpenResty for scripting
- [ ] **Envoy**: modern L7 proxy, xDS API for dynamic config, service mesh data plane
- [ ] **Traefik**: container-native, auto-discovery with Docker/K8s labels
- [ ] **KrakenD**: high-performance, stateless, declarative configuration

## Module 4: Patterns & Anti-Patterns
- [ ] **BFF pattern**: separate gateway per frontend type (web, mobile, IoT)
- [ ] **Gateway offloading**: move cross-cutting concerns out of services into gateway
- [ ] **API versioning at gateway**: route `/v1/` and `/v2/` to different service versions
- [ ] **Anti-pattern: gateway as business logic layer** — keep it thin, routing + cross-cutting only
- [ ] **Anti-pattern: single point of failure** — deploy gateway as cluster, multiple instances
- [ ] **Anti-pattern: gateway monolith** — one massive gateway config → split by domain/team
- [ ] Gateway vs service mesh: gateway for north-south (client→service), mesh for east-west (service→service)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build Spring Cloud Gateway with JWT auth, rate limiting, circuit breaker |
| Module 3 | Compare Spring Cloud Gateway vs Kong for same routing scenario |
| Module 4 | Design gateway strategy for e-commerce: web BFF, mobile BFF, partner API gateway |

## Key Resources
- Spring Cloud Gateway Reference Documentation
- Kong documentation (konghq.com)
- Building Microservices - Sam Newman (Chapter: API Gateway)
- Microservices Patterns - Chris Richardson (Chapter 8)
