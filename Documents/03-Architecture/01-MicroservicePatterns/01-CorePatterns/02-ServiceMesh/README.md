# Service Mesh - Curriculum

## Module 1: What is a Service Mesh?
- [ ] Infrastructure layer for managing service-to-service (east-west) communication
- [ ] Moves networking concerns OUT of application code INTO infrastructure
- [ ] Features without code changes: mTLS, retries, circuit breaking, observability, traffic shaping
- [ ] **Data plane**: sidecar proxies handling actual traffic (Envoy)
- [ ] **Control plane**: configuration, policy, certificate management (Istiod, Linkerd control plane)

## Module 2: Core Features
- [ ] **Mutual TLS (mTLS)**: automatic encryption + identity between all services — zero-trust networking
- [ ] **Traffic management**: canary deployments, A/B testing, traffic splitting (90/10)
- [ ] **Retries & timeouts**: configurable per-route, without app code changes
- [ ] **Circuit breaking**: connection limits, outlier detection at proxy level
- [ ] **Observability**: automatic metrics (latency, error rate, throughput), distributed tracing, access logs
- [ ] **Authorization policies**: who can call whom, at the mesh level
- [ ] **Rate limiting**: per-service or global rate limits
- [ ] **Fault injection**: inject delays/errors for chaos testing

## Module 3: Implementations
- [ ] **Istio**: most popular, feature-rich, Envoy sidecar, `VirtualService`, `DestinationRule`, `Gateway`
- [ ] **Linkerd**: lightweight, Rust-based proxy, simpler than Istio, lower resource overhead
- [ ] **Consul Connect**: HashiCorp, service mesh + service discovery + config, multi-platform
- [ ] **AWS App Mesh**: managed, integrates with ECS/EKS/EC2
- [ ] **Cilium**: eBPF-based (no sidecar), high performance, lower overhead

## Module 4: When to Use (and When Not To)
- [ ] **Service mesh vs API Gateway**: gateway = north-south (external→internal), mesh = east-west (internal→internal)
- [ ] **Service mesh vs library** (Resilience4j): mesh = language-agnostic infrastructure, library = in-code control
- [ ] **When to adopt**: >10 services, polyglot services, need mTLS everywhere, complex traffic management
- [ ] **When to skip**: <5 services, single language, team can manage with libraries, operational complexity too high
- [ ] Operational cost: learning curve, resource overhead (sidecar per pod), debugging complexity
- [ ] Progressive adoption: start with observability, then mTLS, then traffic management

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Deploy Istio on K8s, observe automatic mTLS and metrics without code changes |
| Module 3 | Compare Istio vs Linkerd: resource usage, setup complexity, features |
| Module 4 | Design: "Do we need a service mesh?" decision matrix for your system |

## Key Resources
- Istio documentation (istio.io)
- Linkerd documentation (linkerd.io)
- "The Service Mesh" - William Morgan (Linkerd creator)
- Building Microservices (2nd ed.) - Sam Newman
