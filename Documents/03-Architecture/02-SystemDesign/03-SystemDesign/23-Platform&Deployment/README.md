# Platform & Deployment (System Design Perspective) - Curriculum

How deployment, infrastructure, and platform choices affect your system design — designing for operability.

> Tool-specific details (K8s manifests, Terraform configs, CI/CD pipelines) are in DevOps section. This module covers **platform as architecture decisions**.

---

## Module 1: Containers & Kubernetes in System Design
- [ ] **Why containers matter for design**: consistent environment, fast scaling, resource isolation
- [ ] **Kubernetes as the deployment target**: how it affects your design decisions
  - [ ] Pod: smallest deployable unit (one or more containers)
  - [ ] Service: stable network endpoint for a set of pods
  - [ ] Deployment: declarative desired state, rolling updates
  - [ ] StatefulSet: for stateful workloads (databases, Kafka) — stable identity, ordered scaling
- [ ] **Resource requests & limits**: CPU/memory guarantees — design services with predictable resource usage
- [ ] **Readiness & liveness probes**: K8s needs to know if your service is healthy
  - [ ] Design implication: every service needs health check endpoints
- [ ] **Pod disruption budgets**: guarantee minimum available pods during updates/maintenance
- [ ] Design decision: stateless services scale easily in K8s; stateful services need careful design

## Module 2: Service Discovery & Communication
- [ ] **The problem**: in dynamic environments (K8s, cloud), service IPs change constantly
- [ ] **DNS-based discovery**: Kubernetes Service DNS (service-name.namespace.svc.cluster.local)
- [ ] **Service registry**: Eureka, Consul — services register themselves, clients look up
- [ ] **Client-side vs server-side discovery**:
  - [ ] Client-side: client queries registry, picks instance (Spring Cloud, gRPC)
  - [ ] Server-side: load balancer queries registry, routes request (K8s Service, AWS ALB)
- [ ] **Service mesh**: sidecar proxies handle discovery + routing + mTLS (Istio, Linkerd)
  - [ ] Pros: zero application code changes, consistent policies
  - [ ] Cons: operational complexity, latency overhead, debugging difficulty
- [ ] **API versioning**: how to evolve APIs without breaking consumers
  - [ ] URL versioning: `/v1/users`, `/v2/users`
  - [ ] Header versioning: `Accept: application/vnd.api.v2+json`
- [ ] Design decision: K8s DNS for simple setups, service mesh for complex microservices

## Module 3: Configuration Management
- [ ] **The principle**: separate config from code — same artifact in dev/staging/prod
- [ ] **Configuration sources** (layered):
  - [ ] Defaults in code → config files → environment variables → config service → feature flags
- [ ] **Kubernetes ConfigMaps & Secrets**: inject config into pods as env vars or mounted files
- [ ] **Centralized config service**: Spring Cloud Config, Consul KV, AWS AppConfig
  - [ ] Dynamic config reload without restart
- [ ] **Feature flags**: toggle features at runtime without deploying
  - [ ] Tools: LaunchDarkly, Unleash, Flagsmith, ConfigCat
  - [ ] Use for: gradual rollouts, A/B tests, kill switches, operational toggles
  - [ ] Anti-pattern: permanent feature flags that never get cleaned up
- [ ] Design decision: use feature flags for anything you might need to turn off in production

## Module 4: Deployment Strategies
- [ ] **Rolling update**: replace instances one at a time — K8s default
  - [ ] Pros: zero downtime, simple; Cons: two versions running simultaneously
- [ ] **Blue-Green**: two identical environments, switch traffic atomically
  - [ ] Pros: instant rollback (switch back); Cons: 2x infrastructure cost
- [ ] **Canary**: route small % of traffic to new version, gradually increase
  - [ ] Pros: catch issues early, limit blast radius; Cons: requires traffic splitting
  - [ ] Tools: Argo Rollouts, Flagger, Istio traffic splitting
- [ ] **A/B testing**: route specific users to different versions (not just random %)
- [ ] **Shadow/dark launch**: send copy of production traffic to new version, compare (no user impact)
- [ ] **Database migrations**: deploy migration BEFORE code that uses it (expand-contract pattern)
  - [ ] Never deploy migration + code change simultaneously
- [ ] Design decision: canary is the gold standard for critical services; rolling for everything else

## Module 5: Autoscaling
- [ ] **Horizontal Pod Autoscaler (HPA)**: scale pods based on CPU, memory, or custom metrics
  - [ ] Custom metrics: queue depth, request rate, consumer lag
- [ ] **Vertical Pod Autoscaler (VPA)**: adjust resource requests/limits per pod
- [ ] **Cluster Autoscaler**: add/remove nodes when pods can't be scheduled
- [ ] **Scale-to-zero**: serverless pattern — no instances when no traffic (Knative, Lambda)
- [ ] **Scaling challenges**:
  - [ ] Cold start: new instances take time to be ready (JVM warmup, connection pools)
  - [ ] Scaling lag: time between metric spike and new pods ready (30s-5min)
  - [ ] Thrashing: scaling up and down repeatedly — use stabilization windows
  - [ ] Stateful services: can't scale like stateless — need partition rebalancing
- [ ] **Pre-scaling**: for known events (launches, sales) — scale up BEFORE traffic arrives
- [ ] Design decision: autoscaling is not optional for production — define scaling strategy for every service

## Module 6: Infrastructure as Code (IaC)
- [ ] **The principle**: infrastructure defined in code, version-controlled, reproducible
- [ ] **Terraform**: declarative, multi-cloud, state management
  - [ ] State file: tracks what's deployed — remote state in S3/GCS for team use
  - [ ] Plan → Apply: preview changes before applying
  - [ ] Modules: reusable infrastructure components
- [ ] **Pulumi**: IaC in real programming languages (TypeScript, Python, Go)
- [ ] **GitOps**: infrastructure changes via pull requests
  - [ ] ArgoCD: watches Git repo, syncs K8s cluster to match
  - [ ] Flux: alternative to ArgoCD, same concept
- [ ] **Immutable infrastructure**: never update servers in place — replace with new ones
  - [ ] Container images are immutable by nature
- [ ] Design decision: every piece of infrastructure should be reproducible from code

## Module 7: CI/CD in System Design
- [ ] **CI (Continuous Integration)**: every commit → build → test → feedback
  - [ ] Fast feedback: CI should complete in < 10 minutes
  - [ ] Test pyramid: many unit tests, fewer integration tests, minimal E2E tests
- [ ] **CD (Continuous Delivery/Deployment)**:
  - [ ] Continuous Delivery: every commit is deployable, manual push to production
  - [ ] Continuous Deployment: every commit auto-deploys to production (requires confidence)
- [ ] **Pipeline stages**: build → unit test → integration test → security scan → deploy staging → deploy prod
- [ ] **Artifact management**: build once, deploy the same artifact everywhere
  - [ ] Container registry: Docker Hub, ECR, GCR, GitHub Container Registry
- [ ] **Rollback strategy**: automated rollback on health check failure
- [ ] **Database in CI/CD**: schema migrations as part of deployment pipeline
- [ ] Design implication: system design should consider deployment frequency and rollback capabilities

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design K8s deployment for a 3-service system — define resources, probes, disruption budgets |
| Module 2 | Compare: K8s DNS vs Consul vs Istio for service discovery in a 10-service system |
| Module 3 | Design configuration strategy: what goes in ConfigMap, what in Vault, what in feature flags? |
| Module 4 | Design canary deployment for a payment service — what metrics trigger rollback? |
| Module 5 | Design autoscaling for an event-driven system — what metric drives scaling? What's the cold start plan? |
| Module 6 | Design GitOps workflow: developer pushes code → CI builds image → ArgoCD deploys to K8s |
| Module 7 | Design CI/CD pipeline for a microservices monorepo — build only changed services |

## Key Resources
- **Kubernetes in Action** - Marko Luksa
- **Continuous Delivery** - Jez Humble & David Farley
- Argo Rollouts documentation (canary/blue-green)
- Terraform documentation (terraform.io)
- AWS Well-Architected Framework - Operational Excellence pillar
- "How we deploy code at Shopify" - Shopify engineering blog
