# Service Mesh - Curriculum

Deep dive into service mesh architecture, features, and when (not) to use one.

---

## Module 1: What Problem Does Service Mesh Solve?
- [ ] **Problem**: microservices need cross-cutting concerns (retries, timeouts, mTLS, observability, traffic management)
- [ ] **Pre-mesh approach**: libraries in each service (Resilience4j, Ribbon, etc.)
  - [ ] Problems: polyglot, duplication, upgrade friction
- [ ] **Service mesh**: move these concerns OUT of application code into a separate infrastructure layer
- [ ] **Mesh = data plane + control plane**
- [ ] **Key capabilities**:
  - [ ] mTLS (automatic encryption + identity)
  - [ ] Traffic management (canary, retries, timeouts, circuit breakers)
  - [ ] Observability (metrics, traces, access logs)
  - [ ] Policy enforcement (authorization, rate limiting)
- [ ] **Cost**: operational complexity, latency overhead, learning curve

## Module 2: Sidecar Pattern
- [ ] **Sidecar proxy**: runs alongside each service instance (pod)
- [ ] **Transparent**: intercepts all traffic (inbound + outbound)
- [ ] **Implementation**: `iptables` or eBPF to redirect traffic
- [ ] **Pros**:
  - [ ] Zero code changes in app
  - [ ] Language-agnostic
  - [ ] Consistent behavior
- [ ] **Cons**:
  - [ ] Resource overhead (memory, CPU per pod)
  - [ ] Latency overhead (extra hop)
  - [ ] Debugging complexity
- [ ] **Common sidecar**: Envoy (used by Istio, Consul, Kuma, Gloo Mesh)

## Module 3: Istio
- [ ] **Istio**: most popular service mesh, CNCF graduated
- [ ] **Components**:
  - [ ] **istiod** (control plane): configuration, cert management, service discovery
  - [ ] **Envoy sidecars** (data plane): per-pod proxies
  - [ ] **Ingress/egress gateways**: edge proxies
- [ ] **CRDs**:
  - [ ] `VirtualService`: routing rules
  - [ ] `DestinationRule`: subset definitions, traffic policy
  - [ ] `Gateway`: ingress/egress config
  - [ ] `ServiceEntry`: add external services to mesh
  - [ ] `PeerAuthentication`: mTLS settings
  - [ ] `AuthorizationPolicy`: access control
- [ ] **Injection**: automatic or manual sidecar injection
- [ ] **Installation**: istioctl, Helm, operator

## Module 4: Istio Traffic Management
- [ ] **VirtualService**: HTTP routing
  - [ ] Match on URI, headers, method
  - [ ] Weighted routing (canary: 90/10 split)
  - [ ] Retries: `retries: { attempts: 3, perTryTimeout: 2s }`
  - [ ] Timeouts: per-route
  - [ ] Fault injection: inject delays or errors for testing
- [ ] **DestinationRule**: per-destination policies
  - [ ] Subsets (versions)
  - [ ] Load balancing (round robin, least conn, consistent hash)
  - [ ] Circuit breaker: outlier detection
  - [ ] TLS settings
- [ ] **Traffic shifting**:
  - [ ] Canary: 95% v1, 5% v2, gradually increase
  - [ ] Blue-green: instant cutover
  - [ ] Mirroring: send duplicate traffic to v2 for testing (no impact)

## Module 5: Istio Security (mTLS & AuthZ)
- [ ] **Automatic mTLS**: all service-to-service traffic encrypted
  - [ ] Certificates managed by istiod
  - [ ] Identity: SPIFFE/SPIRE standard
- [ ] **Modes**:
  - [ ] `STRICT`: require mTLS
  - [ ] `PERMISSIVE`: accept both (migration)
  - [ ] `DISABLE`: no mTLS
- [ ] **AuthorizationPolicy**: who can call whom
  - [ ] Deny-by-default or allow-by-default
  - [ ] Match on source service, namespace, JWT claims, paths
  - [ ] Example: `frontend` can call `api`, but not directly `database`
- [ ] **RequestAuthentication**: JWT validation for end-user auth

## Module 6: Linkerd (Simpler Alternative)
- [ ] **Linkerd**: CNCF graduated, simpler than Istio
- [ ] **Written in Rust**: the micro-proxy (linkerd2-proxy) is smaller than Envoy
- [ ] **Philosophy**: simplicity, operational friendliness, no YAML soup
- [ ] **Core features**:
  - [ ] Automatic mTLS
  - [ ] Retries, timeouts
  - [ ] Traffic splitting (SMI)
  - [ ] Golden metrics: success rate, RPS, latency
- [ ] **Missing features (vs Istio)**: less traffic management, simpler policy model
- [ ] **When to choose Linkerd**: simpler needs, lower overhead, better operational experience
- [ ] **When to choose Istio**: more features, more complex routing

## Module 7: Ambient Mesh (Istio Ambient)
- [ ] **Problem with sidecars**: resource overhead per pod, upgrade friction
- [ ] **Ambient mesh** (Istio, preview/GA):
  - [ ] No sidecars
  - [ ] **ztunnel** (L4): per-node shared proxy for mTLS + identity
  - [ ] **waypoint proxies** (L7): opt-in shared proxy for advanced features
- [ ] **Benefits**:
  - [ ] Lower resource overhead
  - [ ] No sidecar injection / upgrades
  - [ ] Tiered cost: L4 is cheap, opt into L7 only where needed
- [ ] **Trade-off**: less isolation per pod, newer/less battle-tested
- [ ] **Future direction**: many meshes exploring ambient-style architectures

## Module 8: Observability in Service Mesh
- [ ] **Metrics** (automatic): request rate, error rate, duration, traffic split
- [ ] **Distributed tracing**: headers propagated automatically (you still need to propagate in app!)
- [ ] **Access logs**: per-request logs from Envoy
- [ ] **Integration**:
  - [ ] Prometheus for metrics
  - [ ] Jaeger / Tempo for traces
  - [ ] Kiali (Istio): visualization of mesh topology
- [ ] **Golden signals**: L7 mesh gives you rate/errors/duration for free

## Module 9: Alternatives & Comparison
- [ ] **Consul Connect** (HashiCorp): Vault/Consul integration
- [ ] **Kuma** (Kong): simpler, multi-cluster focused
- [ ] **Cilium Service Mesh**: eBPF-based, no sidecars, uses Cilium CNI
- [ ] **AWS App Mesh**: AWS-managed (EKS, ECS)
- [ ] **Gloo Mesh**: multi-cluster management of Istio
- [ ] **Comparison axes**:
  - [ ] Feature set
  - [ ] Operational complexity
  - [ ] Resource overhead
  - [ ] Cluster support (multi-cluster, multi-cloud)
  - [ ] Learning curve

## Module 10: Do You Actually Need a Service Mesh?
- [ ] **Good reasons**:
  - [ ] Mandatory mTLS across services (compliance)
  - [ ] Polyglot microservices need consistent behavior
  - [ ] Advanced traffic management (canary, A/B, fault injection)
  - [ ] Unified observability
- [ ] **Bad reasons**:
  - [ ] "Because it's cool"
  - [ ] Don't have microservices yet
  - [ ] Can't operate it (understaffed)
- [ ] **Alternatives**:
  - [ ] API Gateway (Kong, Traefik) for north-south
  - [ ] Library-based (Spring Cloud, Resilience4j) for simpler needs
  - [ ] Just use TLS certificates directly
- [ ] **Rule**: start without mesh, adopt when you have clear, painful needs

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Deploy app without mesh, identify cross-cutting concerns |
| Module 3 | Install Istio on a kind cluster |
| Module 4 | Set up canary routing: 90/10 with VirtualService |
| Module 5 | Enable strict mTLS, write AuthorizationPolicy |
| Module 6 | Deploy Linkerd on a separate cluster, compare UX |
| Module 7 | Try Istio ambient mode (preview) |
| Module 8 | Set up Kiali dashboard for mesh visualization |
| Module 9 | Compare Istio vs Linkerd vs Cilium for a scenario |
| Module 10 | Write justification for adopting/not adopting mesh in your org |

## Key Resources
- istio.io (official)
- linkerd.io (official)
- "Istio: Up and Running" — Calcote & Butcher
- "Mastering Service Mesh" — Anjali Khatri
- cilium.io/service-mesh
- "The Service Mesh: What Every Software Engineer Needs to Know" — Buoyant
