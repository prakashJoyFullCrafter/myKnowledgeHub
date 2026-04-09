# Proxies & Reverse Proxies - Curriculum

## Module 1: Forward Proxy
- [ ] What is a forward proxy? Client → Proxy → Server (proxy acts on behalf of client)
- [ ] Use cases: content filtering, anonymity, caching, access control
- [ ] Corporate proxies: restrict employee internet access
- [ ] VPN vs proxy: VPN encrypts all traffic, proxy routes specific traffic
- [ ] SOCKS proxy vs HTTP proxy

## Module 2: Reverse Proxy
- [ ] What is a reverse proxy? Client → Reverse Proxy → Server (proxy acts on behalf of server)
- [ ] Client doesn't know about backend servers — reverse proxy is the entry point
- [ ] Use cases:
  - [ ] **Load balancing**: distribute traffic across backend servers
  - [ ] **SSL/TLS termination**: handle HTTPS at proxy, plain HTTP to backend
  - [ ] **Caching**: cache responses to reduce backend load
  - [ ] **Compression**: gzip/brotli responses before sending to client
  - [ ] **Security**: hide backend topology, rate limiting, WAF
  - [ ] **Static file serving**: serve assets without hitting application server

## Module 3: Reverse Proxy vs API Gateway vs Load Balancer
- [ ] **Reverse Proxy** (NGINX, HAProxy): traffic routing, SSL, caching, compression
- [ ] **Load Balancer** (AWS ALB, NLB): traffic distribution across servers, health checks
- [ ] **API Gateway** (Kong, Spring Cloud Gateway, AWS API Gateway): authentication, rate limiting, request transformation, API versioning, analytics
- [ ] Overlap: most reverse proxies CAN load balance; most API gateways ARE reverse proxies
- [ ] When to use what:
  - [ ] Simple routing + SSL → reverse proxy
  - [ ] Traffic distribution + health checks → load balancer
  - [ ] API management + auth + rate limiting → API gateway

## Module 4: Tools
- [ ] **NGINX**: most popular reverse proxy, config-driven, OpenResty for Lua scripting
- [ ] **HAProxy**: high-performance L4/L7 proxy, used at massive scale
- [ ] **Envoy**: modern, API-driven proxy, sidecar for service mesh (Istio)
- [ ] **Traefik**: container-native, auto-discovery with Docker/K8s labels
- [ ] **Caddy**: automatic HTTPS, simple config, Go-based
- [ ] Cloud-managed: AWS ALB/NLB, GCP Cloud Load Balancing, Azure Application Gateway

## Module 5: Sidecar Proxy Pattern
- [ ] Sidecar: proxy deployed alongside each service instance (not centralized)
- [ ] Service mesh: Istio (Envoy sidecar), Linkerd
- [ ] Responsibilities: mTLS, retries, circuit breaking, observability — without app code changes
- [ ] Sidecar vs library approach (Resilience4j in code vs Envoy sidecar)
- [ ] Trade-off: operational complexity vs clean separation of concerns

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Configure NGINX as reverse proxy with SSL termination for a Spring Boot app |
| Module 3 | Set up NGINX (reverse proxy) + Kong (API gateway) — understand the layering |
| Module 4 | Compare NGINX vs Envoy vs Traefik for a Docker Compose microservices setup |
| Module 5 | Deploy Istio with Envoy sidecars on Kubernetes, observe mTLS and tracing |

## Key Resources
- NGINX documentation (nginx.org)
- Envoy Proxy documentation (envoyproxy.io)
- "What is a Reverse Proxy?" - Cloudflare Learning Center
- System Design Interview - Alex Xu
