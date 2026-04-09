# Load Balancing - Curriculum

## Module 1: Fundamentals
- [ ] Why load balancing? Distribute traffic, increase availability, enable scaling
- [ ] **L4 (Transport layer)**: routes based on IP/port, no request inspection, faster
- [ ] **L7 (Application layer)**: routes based on URL/headers/cookies, content-aware, more flexible
- [ ] L4 vs L7: performance vs intelligence trade-off

## Module 2: Algorithms
- [ ] **Round Robin**: equal rotation, simple, no server awareness
- [ ] **Weighted Round Robin**: assign weights based on server capacity
- [ ] **Least Connections**: route to server with fewest active connections
- [ ] **Weighted Least Connections**: combines weight + connection count
- [ ] **IP Hash**: same client IP always goes to same server (sticky)
- [ ] **Consistent Hashing**: minimal disruption when servers added/removed
- [ ] **Random**: simple, surprisingly effective at scale
- [ ] **Least Response Time**: route to fastest-responding server

## Module 3: Health Checks & Failover
- [ ] **Active health checks**: LB periodically pings servers (HTTP, TCP, custom)
- [ ] **Passive health checks**: detect failures from real traffic (error rates, timeouts)
- [ ] Unhealthy server removal and re-addition
- [ ] Graceful draining: stop sending new requests, wait for in-flight to complete
- [ ] Connection draining timeout configuration

## Module 4: Tools & Implementations
- [ ] **NGINX**: reverse proxy + L7 load balancer, most popular
- [ ] **HAProxy**: high-performance L4/L7, used by GitHub/Stack Overflow
- [ ] **AWS ALB** (Application LB): L7, path/host routing, WebSocket support
- [ ] **AWS NLB** (Network LB): L4, ultra-low latency, static IP
- [ ] **Envoy**: modern L7 proxy, service mesh sidecar (Istio)
- [ ] **Traefik**: container-native, auto-discovery with Docker/K8s

## Module 5: Advanced Patterns
- [ ] **DNS-based load balancing**: Route 53, GeoDNS for regional routing
- [ ] **Global Server Load Balancing (GSLB)**: multi-region, geo-based routing
- [ ] **Session affinity (sticky sessions)**: when needed (stateful apps), why to avoid (limits scaling)
- [ ] **Kubernetes load balancing**: ClusterIP Service, NodePort, Ingress Controller
- [ ] **Client-side load balancing**: gRPC, Spring Cloud LoadBalancer, Ribbon (deprecated)
- [ ] **Multi-tier load balancing**: DNS → Global LB → Regional LB → Application LB
- [ ] **Connection pooling** at the load balancer level
- [ ] **Rate limiting** at the load balancer (NGINX `limit_req`)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Configure NGINX as L7 load balancer with weighted round robin |
| Module 3 | Set up health checks with graceful draining |
| Module 4 | Compare NGINX vs HAProxy vs Envoy for a microservices setup |
| Module 5 | Design multi-tier load balancing for a global e-commerce platform |

## Key Resources
- NGINX documentation (nginx.org)
- HAProxy documentation
- AWS Elastic Load Balancing documentation
- System Design Interview - Alex Xu (Chapter: Load Balancer)
