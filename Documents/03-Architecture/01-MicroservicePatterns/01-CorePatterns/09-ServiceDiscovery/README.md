# Service Discovery - Curriculum

## Module 1: The Problem
- [ ] Microservices have **dynamic** network locations: containers come and go, autoscaling, blue/green, rolling deploys, pod evictions
- [ ] Hardcoding hostnames/IPs in config is brittle — works for monoliths, breaks at microservice scale
- [ ] DNS alone is insufficient: TTL caching, no health awareness, no instance-level metadata, slow propagation
- [ ] Need a system to answer: "where can I reach service `payment-service` right now, and which instances are healthy?"
- [ ] Two responsibilities split: **registration** (services advertise themselves) + **discovery** (clients find them)
- [ ] Trade-off: **availability** of the registry vs **consistency** of the registry view (CAP applies to the registry itself)

## Module 2: Discovery Models
- [ ] **Client-Side Discovery**: client queries registry, gets list, picks one (often via load balancer in client)
  - [ ] Pros: client controls LB strategy (round-robin, weighted, latency-aware), no extra hop
  - [ ] Cons: client library per language, registry coupling in app code
  - [ ] Examples: Netflix Eureka + Ribbon, Spring Cloud LoadBalancer
- [ ] **Server-Side Discovery**: client calls a router/LB which queries the registry and forwards
  - [ ] Pros: language-agnostic, simpler client, central LB policy
  - [ ] Cons: extra hop, LB becomes critical infra
  - [ ] Examples: AWS ELB/ALB, Kubernetes Services + kube-proxy, Istio
- [ ] **DNS-Based Discovery**: registry exposes records via DNS (SRV records or A records)
  - [ ] Pros: every language already speaks DNS, zero client changes
  - [ ] Cons: DNS caching, no rich metadata, weak failure signaling
  - [ ] Examples: Consul DNS interface, K8s CoreDNS, AWS Cloud Map
- [ ] **Service Mesh as Discovery**: mesh control plane (Istiod) maintains service catalog, sidecar handles discovery transparently
- [ ] Decision matrix: client-side for fine LB control, server-side for polyglot, DNS for simplicity, mesh when already adopted

## Module 3: Registration Models
- [ ] **Self-Registration**: service registers itself on startup, sends heartbeats, deregisters on shutdown
  - [ ] Pros: simple, service owns its lifecycle
  - [ ] Cons: registration code in every service (per language), stale entries on crash without graceful shutdown
  - [ ] Examples: Eureka client, Consul agent SDK
- [ ] **Third-Party Registration**: a separate registrar watches the platform (orchestrator events, container starts/stops) and updates the registry
  - [ ] Pros: app code stays clean, language-agnostic
  - [ ] Cons: registrar becomes critical component
  - [ ] Examples: Kubernetes Endpoints controller (the canonical one), AWS ECS service discovery, Registrator (older Docker tool)
- [ ] **Heartbeating & Health**: registry must purge dead instances → TTL + heartbeat OR active health checks (HTTP/TCP/script)
  - [ ] Pull model: registry probes instances (Consul style)
  - [ ] Push model: instances heartbeat to registry (Eureka style — survives partitions better, can be stale)
- [ ] **Graceful Deregistration**: SIGTERM handler → mark as draining → registry removes → wait for in-flight → exit
  - [ ] Without this: 30-60s of routing to dead instances after every deploy

## Module 4: Implementations
- [ ] **Kubernetes Services + CoreDNS**: the de-facto modern default; Endpoints controller does third-party registration; ClusterIP/Headless/NodePort/LoadBalancer types
  - [ ] Headless services (`clusterIP: None`) for client-side LB scenarios (StatefulSets, gRPC)
  - [ ] EndpointSlices for scaling beyond ~1000 endpoints
- [ ] **Consul**: agent on every node, gossip protocol, Raft for KV, multi-DC, DNS + HTTP API, health checks built-in
- [ ] **etcd**: KV store; not a discovery system per se, but the storage layer behind K8s and many discovery systems
- [ ] **ZooKeeper**: ephemeral znodes for self-registration; older but still used (Kafka, HBase metadata)
- [ ] **Netflix Eureka**: AP system (favors availability over consistency during partitions), self-preservation mode; pairs with Ribbon/Spring Cloud LoadBalancer
  - [ ] Note: Eureka 2.x cancelled; Eureka 1.x in maintenance — most JVM teams have moved to K8s or Consul
- [ ] **AWS Cloud Map / ECS Service Discovery**: managed, integrates with Route53 + API
- [ ] **Spring Cloud abstractions**: `DiscoveryClient` interface — same code works against Eureka, Consul, ZK, K8s
  - [ ] `@LoadBalanced RestTemplate` / `WebClient` — Spring Cloud LoadBalancer

## Module 5: Failure Modes & Operational Concerns
- [ ] **Registry as SPOF**: registry goes down → discovery breaks → cascading failures
  - [ ] Solutions: replicate registry (Eureka cluster, Consul Raft, K8s control plane HA), client-side caching with stale-on-error
- [ ] **Stale entries**: instance crashed without deregistering → traffic goes to dead address until TTL expires
  - [ ] Solutions: short TTL + heartbeat, active health checks, fast failover at LB
- [ ] **Thundering herd on registry**: 1000s of clients polling registry at once
  - [ ] Solutions: long-poll / watch APIs, client-side caching with jittered refresh
- [ ] **Network partitions (CAP)**:
  - [ ] **AP** (Eureka): keeps serving stale data, eventually consistent — better for traffic continuity
  - [ ] **CP** (ZK, etcd): refuses reads on minority side — safer for primary election, riskier for plain discovery
- [ ] **Registry vs Service Mesh**: mesh sidecar already does service discovery — running both is redundant
- [ ] **Multi-cluster / multi-region discovery**: federation, mesh expansion (Istio multi-cluster), Consul WAN gossip
- [ ] **Security**: registry write access = ability to redirect traffic → mTLS to registry, ACLs, signed registrations
- [ ] **Anti-pattern**: hardcoded IPs "for performance" — defeats discovery, fails on every redeploy

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a 3-service Spring Boot app with Eureka, observe self-registration and `@LoadBalanced WebClient` resolving by service name |
| Module 2 | Switch the same app to Consul, then to Kubernetes Services — compare what changes in app code |
| Module 3 | Add a `SIGTERM` handler that gracefully deregisters; verify zero error during rolling restart |
| Module 4 | Deploy a headless K8s service; use it from a gRPC client doing client-side LB |
| Module 5 | Kill the registry mid-traffic: observe Eureka (AP) keeps routing vs etcd (CP) failing fast |
| Module 5 | Run `kubectl get endpointslices` while scaling a Deployment 1→50→1; trace endpoint propagation latency |

## Cross-References
- `01-MicroservicePatterns/01-CorePatterns/01-APIGateway/` — gateway uses discovery to route
- `01-MicroservicePatterns/01-CorePatterns/02-ServiceMesh/` — mesh subsumes service discovery
- `01-MicroservicePatterns/01-CorePatterns/08-LeaderElection/` — registries (ZK/etcd/Consul) underpin both
- `02-SystemDesign/03-SystemDesign/02-LoadBalancing/` — discovery feeds the LB
- `02-SystemDesign/03-SystemDesign/23-Platform&Deployment/` — K8s service primitives

## Key Resources
- **Microservices Patterns** - Chris Richardson (Chapter 3: Inter-process communication)
- **Building Microservices (2nd ed.)** - Sam Newman (Chapter 5)
- **Kubernetes documentation** — Services, Endpoints, EndpointSlices, CoreDNS
- **Consul documentation** — Service Discovery, Health Checks
- **Spring Cloud Netflix / Spring Cloud Consul / Spring Cloud Kubernetes** docs
- **"Pattern: Service registry"** & **"Pattern: Self registration"** — microservices.io (Chris Richardson)
