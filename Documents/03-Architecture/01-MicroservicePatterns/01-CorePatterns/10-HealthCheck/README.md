# Health Check & Heartbeat - Curriculum

## Module 1: The Problem
- [ ] In a multi-replica system, **someone needs to know if an instance is healthy** — load balancer, orchestrator, service registry, on-call engineer
- [ ] Naive "is the process running?" check is insufficient: process can be alive but DB pool exhausted, deadlocked, or unable to serve traffic
- [ ] Two distinct questions, often conflated:
  - [ ] **Liveness**: "is this instance alive, or should it be killed and replaced?"
  - [ ] **Readiness**: "is this instance currently able to handle traffic, or should it be temporarily removed from the LB pool?"
- [ ] Conflating them is the #1 health-check bug: **liveness probe checks the database** → DB blip kills all your pods → cascading failure
- [ ] **Health Check API pattern** (Chris Richardson): every service exposes endpoints (`/health`, `/health/live`, `/health/ready`) so external systems can probe
- [ ] **Heartbeat pattern**: instance actively notifies a registry/coordinator on a schedule — registry purges instances that miss heartbeats
- [ ] These are duals: probe (pull) vs heartbeat (push)

## Module 2: Liveness vs Readiness vs Startup
- [ ] **Liveness probe** answers: "is the process unrecoverably broken?"
  - [ ] Failing → orchestrator **kills and restarts** the instance
  - [ ] Should check ONLY in-process state: deadlocks, GC death spiral, OOM-bound, internal queue stuck
  - [ ] **Must NOT check downstream dependencies** (DB, Redis, downstream services) — a DB outage shouldn't trigger restart loops on every replica
- [ ] **Readiness probe** answers: "should I send traffic right now?"
  - [ ] Failing → orchestrator **removes from load balancer pool** (no kill)
  - [ ] Can check downstream: DB connectivity, cache availability, dependent services
  - [ ] Recovers automatically when probe passes again
- [ ] **Startup probe** answers: "has the app finished initialising?"
  - [ ] Used for slow-starting apps (JVM warm-up, large cache hydration, classpath scanning)
  - [ ] Disables liveness/readiness until startup probe succeeds — prevents "kill before init" loops
  - [ ] Kubernetes-specific (added in 1.16) but the concept exists everywhere
- [ ] **Decision tree** when designing a check:
  - [ ] Will killing the pod fix this? → Liveness
  - [ ] Will removing from LB pool fix this? → Readiness
  - [ ] Is this just slow first-time setup? → Startup
- [ ] **Probe configuration**: initialDelaySeconds, periodSeconds, timeoutSeconds, failureThreshold, successThreshold — every parameter has a wrong default for someone

## Module 3: Shallow vs Deep Health Checks
- [ ] **Shallow check**: "is the HTTP server responding?" — just returns 200 OK
  - [ ] Fastest, no false positives from dependency issues
  - [ ] Good for liveness probes
- [ ] **Deep check**: "can I actually serve a request end-to-end?" — pings DB, checks cache, calls a critical downstream
  - [ ] Catches more real problems but introduces failure correlation across services
  - [ ] Good for readiness probes — sparingly
- [ ] **Synthetic transaction check**: actually executes a representative read/write — closest to user reality, most expensive
- [ ] **The cascading failure trap**: deep readiness checks across many services → one slow dependency → all readiness probes fail → all instances removed from LB → outage
  - [ ] Mitigation: timeouts on health-check dependencies (faster than user-facing timeouts), circuit-breaker in the health check itself, fail-open after threshold
- [ ] **Spring Boot Actuator** convention:
  - [ ] `/actuator/health` — aggregate, with composite indicators
  - [ ] `/actuator/health/liveness` and `/actuator/health/readiness` — explicit probe endpoints (Spring Boot 2.3+)
  - [ ] `HealthIndicator` interface for custom checks; `HealthContributor` for grouping
  - [ ] **Important**: by default, the health endpoint may aggregate everything — explicitly configure which indicators are part of liveness vs readiness
- [ ] **Standards**: 
  - [ ] **MicroProfile Health** (Java) — `@Liveness`, `@Readiness`, `@Startup` annotations
  - [ ] **draft-inadarei-api-health-check** (informal RFC) — JSON `health+json` format with `status`, `checks`, `output`

## Module 4: Heartbeat Patterns
- [ ] Direction is reversed: instance **pushes** liveness signal to a coordinator
- [ ] **Use cases**:
  - [ ] Service registry liveness (Eureka — instance heartbeats every 30s, deregistered if missed for 90s)
  - [ ] Leader election leases (Kubernetes Lease, etcd lease, ZK ephemeral nodes)
  - [ ] Worker check-in (Celery, Sidekiq workers)
  - [ ] Connection-keepalive (gRPC keepalive, WebSocket ping/pong, MQTT keep-alive)
- [ ] **TTL + heartbeat** is the standard pattern: instance promises to renew before TTL expires; on miss, coordinator assumes dead
- [ ] **Trade-offs**:
  - [ ] Short TTL + frequent heartbeat → fast failure detection, more chatter
  - [ ] Long TTL + sparse heartbeat → low overhead, slow detection
  - [ ] Typical: heartbeat interval = TTL / 3 (so 2 misses still survive)
- [ ] **Failure detector accuracy**:
  - [ ] **Strong failure detector**: never reports a live instance as dead (impossible in async networks — FLP impossibility)
  - [ ] **Eventually perfect (φ-accrual)** failure detector: adapts threshold based on observed heartbeat distribution (Cassandra, Akka use this) — better than fixed timeouts on noisy networks
- [ ] **Self-heartbeat**: instance writes "alive" to its own DB row → external monitor checks the row — works around firewalled environments
- [ ] **Anti-pattern**: silent heartbeat failures (instance can't reach coordinator but is otherwise fine) → flapping registration

## Module 5: Operational Concerns & Anti-Patterns
- [ ] **Health-check storms**: 10,000 LBs probing 1000 instances every second = 10M req/s of pure overhead
  - [ ] Mitigation: longer probe intervals, sampling, hierarchical checks (LB checks one "zone leader")
- [ ] **The "/health that lies" problem**: `/health` returns 200 even when the app is broken because it only checks the HTTP server
  - [ ] Mitigation: include critical-path indicators; test the health check itself
- [ ] **The "/health that flaps" problem**: deep checks marginal under load → readiness toggles → traffic ping-pongs
  - [ ] Mitigation: hysteresis (`successThreshold > 1`), exponential smoothing, separate user-traffic SLO from health-check SLO
- [ ] **Authentication on health endpoints**: should `/health` be authenticated?
  - [ ] Liveness/readiness — usually unauthenticated (probes can't carry creds easily)
  - [ ] Detailed health with internal info (DB versions, queue depths) — authenticated, internal-only
  - [ ] **Never expose** stack traces, secrets, or detailed dependency info on a public endpoint
- [ ] **Graceful shutdown integration**:
  - [ ] On SIGTERM: flip readiness to "not ready" → wait for LB to notice → drain in-flight → exit
  - [ ] Without this: 30-60s of 502s on every deploy
  - [ ] Spring Boot: `server.shutdown=graceful` + `spring.lifecycle.timeout-per-shutdown-phase`
- [ ] **Synthetic monitoring**: external probes (Pingdom, Datadog Synthetics, blackbox_exporter) hit health endpoints from outside — independent of your monitoring stack
- [ ] **Health checks vs metrics vs traces**: health = boolean / state; metrics = numeric / aggregate; traces = causal — three pillars, don't conflate
- [ ] **Anti-pattern: liveness depending on downstream** — caused half the world's outages once popularised by misconfigured K8s manifests

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Configure proper liveness/readiness/startup probes for a Spring Boot service in Kubernetes; intentionally break each and observe orchestrator behaviour |
| Module 3 | Implement a deep readiness check with a 1-second timeout + circuit breaker; simulate a slow DB; verify cascading failure does NOT happen |
| Module 3 | Read `/actuator/health/liveness` vs `/actuator/health/readiness` configs; verify only readiness checks downstream |
| Module 4 | Build a worker that heartbeats to Redis with TTL; kill it ungracefully; observe coordinator failover after TTL expiry |
| Module 4 | Implement a φ-accrual failure detector for variable-latency networks; compare with fixed-timeout detection |
| Module 5 | Add graceful shutdown to a service: SIGTERM → readiness flips → drain → exit — measure 0 errors during rolling deploy |
| Module 5 | Audit your team's services: how many have liveness checking the DB? Fix them. |

## Cross-References
- `01-MicroservicePatterns/01-CorePatterns/09-ServiceDiscovery/` — registries depend on heartbeat / health-check
- `01-MicroservicePatterns/01-CorePatterns/08-LeaderElection/` — leader leases are heartbeat-based
- `01-MicroservicePatterns/01-CorePatterns/02-ServiceMesh/` — mesh sidecars do health checks transparently
- `01-MicroservicePatterns/02-Resilience/01-CircuitBreaker/` — circuit breaker state often informs readiness
- `02-SystemDesign/03-SystemDesign/02-LoadBalancing/` — LBs use health checks to choose targets
- `02-SystemDesign/03-SystemDesign/17-Observability&Operations/` — health is the boolean tier of the observability stack
- `06-DevOps&Delivery/04-Observability/` — tooling: probes, blackbox exporter, synthetics

## Key Resources
- **"Health Check API"** - microservices.io (Chris Richardson)
- **Kubernetes documentation** — Configure Liveness, Readiness and Startup Probes
- **Spring Boot Actuator** documentation — Health Indicators, Probes
- **MicroProfile Health** specification — `@Liveness`, `@Readiness`, `@Startup`
- **"Health checks and graceful degradation in distributed systems"** - Cindy Sridharan
- **"Avoiding Cascading Failures"** - Google SRE book (Chapter 22)
- **"The Phi Accrual Failure Detector"** - Hayashibara et al. (used by Cassandra, Akka)
- **draft-inadarei-api-health-check** - IETF draft for `application/health+json`
