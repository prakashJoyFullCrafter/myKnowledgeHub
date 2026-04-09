# Sidecar Pattern - Curriculum

## Module 1: Fundamentals
- [ ] Sidecar: auxiliary container deployed alongside the main application container
- [ ] Shares network namespace and storage with the main container
- [ ] Extends/enhances the main app without modifying its code
- [ ] Principle: separation of concerns — app handles business logic, sidecar handles infrastructure

## Module 2: Use Cases
- [ ] **Proxy sidecar**: Envoy for traffic management, mTLS, load balancing (service mesh)
- [ ] **Logging sidecar**: Fluentd/Filebeat collects logs, ships to ELK/Splunk
- [ ] **Monitoring sidecar**: Prometheus exporter, metrics collection
- [ ] **Config sidecar**: Vault agent for secrets injection, config refresh
- [ ] **Security sidecar**: OAuth2 proxy, authentication before reaching app
- [ ] **Data sync sidecar**: git-sync for pulling config/data from repositories

## Module 3: Sidecar vs Library Approach
- [ ] **Sidecar** (infrastructure approach): language-agnostic, independent lifecycle, resource overhead per pod
- [ ] **Library** (code approach): tighter integration, no network hop, language-specific, coupled lifecycle
- [ ] When sidecar wins: polyglot services, separation of concern, ops team manages infra independently
- [ ] When library wins: performance-critical, simple stack (single language), smaller deployments
- [ ] Hybrid: use sidecar for mTLS/observability, library for business-level resilience (Resilience4j)

## Module 4: Related Patterns & Kubernetes
- [ ] **Ambassador pattern**: sidecar acts as proxy for outbound communication (external API gateway per pod)
- [ ] **Adapter pattern**: sidecar transforms output of main app to standard format (log format normalization)
- [ ] **Init container** (K8s): runs before main container — setup, migration, config fetch (not a sidecar, but related)
- [ ] **Kubernetes native sidecars** (K8s 1.28+): `restartPolicy: Always` in init containers — proper sidecar lifecycle
- [ ] Sidecar resource management: CPU/memory limits, impact on pod scheduling

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Deploy Spring Boot app with Envoy sidecar for mTLS + Fluentd sidecar for logging |
| Module 3 | Compare: Resilience4j in-code vs Envoy sidecar circuit breaker — measure performance difference |
| Module 4 | Build multi-container pod: app + log adapter + config init container |

## Key Resources
- Kubernetes multi-container pod patterns documentation
- Envoy Proxy documentation
- "Design Patterns for Container-Based Distributed Systems" - Brendan Burns (paper)
- Building Microservices - Sam Newman
