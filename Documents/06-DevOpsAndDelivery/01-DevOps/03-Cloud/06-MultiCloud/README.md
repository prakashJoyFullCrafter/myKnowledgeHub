# Multi-Cloud Strategies - Curriculum

When, why, and how to use multiple cloud providers.

---

## Module 1: Multi-Cloud Motivations
- [ ] **Avoid vendor lock-in**: ability to move if prices or terms change
- [ ] **Risk mitigation**: survive a region/provider outage
- [ ] **Regulatory**: data residency in specific clouds
- [ ] **Best-of-breed**: use BigQuery (GCP) + ML services (Azure) + S3 (AWS)
- [ ] **Cost arbitrage**: exploit price differences
- [ ] **Legacy acquisition**: mergers/acquisitions inherit different clouds
- [ ] **Negotiating leverage**: play vendors against each other
- [ ] **Geographic coverage**: use provider strongest in a region

## Module 2: The Cost of Multi-Cloud
- [ ] **Complexity multiplier**:
  - [ ] Two+ sets of IAM, networking, observability, deployment tooling
  - [ ] Different skill requirements
  - [ ] Different billing, support channels
- [ ] **Engineering cost**: 2-3x more effort for common tasks
- [ ] **Data transfer**: cross-cloud egress is expensive
- [ ] **Network latency**: cross-cloud is slower than intra-cloud
- [ ] **Tool abstraction risk**: lowest-common-denominator loses provider advantages
- [ ] **Rule**: don't go multi-cloud unless you have a clear, strong reason

## Module 3: Multi-Cloud Patterns
- [ ] **Active-active**: workload runs in multiple clouds simultaneously
  - [ ] Global traffic distribution
  - [ ] Most expensive, most resilient
- [ ] **Active-passive (DR)**: primary cloud + failover
  - [ ] Standby capacity in second cloud
  - [ ] Cheaper, slower failover
- [ ] **Workload distribution**: different apps on different clouds
  - [ ] Analytics on GCP, web app on AWS
  - [ ] Each workload benefits from one cloud's strengths
- [ ] **Hybrid cloud**: on-prem + cloud(s)
- [ ] **Cloud-agnostic apps**: portable workloads via Kubernetes
- [ ] **Cloud-bursting**: overflow to another cloud at peak

## Module 4: Cloud-Agnostic Abstractions
- [ ] **Kubernetes**: the most common cloud abstraction layer
  - [ ] Same manifests run on EKS, GKE, AKS
  - [ ] Still need cloud-specific integrations (LB, storage, IAM)
- [ ] **Terraform**: IaC supports all clouds (but still cloud-specific resources)
- [ ] **Crossplane**: K8s-native IaC for multi-cloud
- [ ] **Managed databases**: PostgreSQL/MySQL is portable, DynamoDB/Spanner is not
- [ ] **Message brokers**: Kafka is portable, SQS/Pub-Sub are not
- [ ] **Object storage**: S3 API is widely compatible (Minio, GCS interop, Azure compat)
- [ ] **Reality**: some lock-in is unavoidable; pick your battles

## Module 5: Networking Across Clouds
- [ ] **Cross-cloud VPN**:
  - [ ] Site-to-site VPN between VPCs
  - [ ] Managed offerings: AWS VPN, Azure VPN Gateway, GCP Cloud VPN
- [ ] **Direct peering**:
  - [ ] AWS Direct Connect + Azure ExpressRoute + GCP Interconnect
  - [ ] Dedicated connections via Equinix, Megaport
- [ ] **Transit hubs**: Megaport, Equinix Fabric, Cloudflare Magic Transit
- [ ] **Mesh networking**: Cilium Cluster Mesh, Istio multi-cluster
- [ ] **DNS**: external-dns, multi-provider DNS (Route 53 + Cloudflare)
- [ ] **CDN**: Cloudflare, Fastly, Akamai — neutral CDN on top

## Module 6: Identity Across Clouds
- [ ] **Centralized identity provider**:
  - [ ] Okta, Auth0, Azure AD / Entra ID
  - [ ] Federate to each cloud
- [ ] **Workload identity**:
  - [ ] OIDC federation from GitHub Actions to any cloud
  - [ ] SPIFFE/SPIRE for service-to-service
- [ ] **Cross-cloud RBAC**: complex — usually separate per cloud
- [ ] **Secrets management**:
  - [ ] HashiCorp Vault (cloud-agnostic)
  - [ ] External Secrets Operator (sync from various backends)

## Module 7: Observability in Multi-Cloud
- [ ] **Cloud-native tools** (CloudWatch, Cloud Monitoring, Azure Monitor) lock you in
- [ ] **Neutral observability**:
  - [ ] **Grafana stack** (Prometheus + Loki + Tempo + Mimir)
  - [ ] **OpenTelemetry** for instrumentation
  - [ ] **Datadog, New Relic, Dynatrace** — commercial multi-cloud APM
- [ ] **Aggregation**: central observability backend ingests from all clouds
- [ ] **Challenges**: different metadata formats, different APIs, log volume

## Module 8: Cost Management Across Clouds
- [ ] **Challenge**: each cloud has its own billing format and tools
- [ ] **Unified tools**:
  - [ ] CloudHealth (VMware)
  - [ ] Flexera (RightScale)
  - [ ] Cloudability
  - [ ] ProsperOps
- [ ] **Tagging consistency**: same tag schema across clouds
- [ ] **Allocation**: per-team/project across all clouds
- [ ] **Commit strategies**: reserved capacity per cloud (don't over-commit in one)
- [ ] **FinOps discipline**: critical when spending across clouds

## Module 9: Common Multi-Cloud Architectures
- [ ] **Multi-cloud Kubernetes**: K8s across clouds, ArgoCD for deployment
- [ ] **Multi-cloud data lake**: data in cheapest cloud, compute elsewhere
- [ ] **Multi-cloud CDN**: global edge network on top of origin cloud
- [ ] **Multi-cloud ML**: train on one cloud, serve on another
- [ ] **Anti-pattern**: same workload active-active in 2 clouds for imagined resilience
  - [ ] Real cost rarely justifies it
  - [ ] Multi-region within one cloud is usually enough

## Module 10: Decision Framework
- [ ] **Questions to answer**:
  - [ ] Do you have a specific, concrete driver? (regulation, supplier demand, cost)
  - [ ] Do you have the engineering capacity to operate multi-cloud?
  - [ ] Is your workload cloud-portable?
  - [ ] What's the cost of lock-in vs cost of portability?
- [ ] **Rule of thumb**:
  - [ ] **Start single-cloud**: master one before adding another
  - [ ] **Multi-region first**: solves most resilience needs within one cloud
  - [ ] **Add second cloud when**: clear business driver, resourced team
- [ ] **Most "multi-cloud" is really**: one cloud for most workloads + SaaS on others

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | List drivers for multi-cloud in your org (if any) |
| Module 2 | Estimate engineering cost of adding a second cloud |
| Module 3 | Design an active-passive DR across AWS and GCP |
| Module 4 | Build a cloud-agnostic app with Kubernetes + Terraform |
| Module 5 | Set up cross-cloud VPN between VPCs |
| Module 6 | Federate GitHub Actions to both AWS and GCP via OIDC |
| Module 7 | Deploy Grafana stack to aggregate metrics from 2 clouds |
| Module 8 | Build unified cost dashboard across clouds |
| Module 9 | Design K8s-based multi-cloud architecture for a scenario |
| Module 10 | Write a decision doc: should we go multi-cloud? Why/why not? |

## Key Resources
- "Multi-Cloud Architecture and Governance" — Jeroen Mulder
- CNCF multi-cloud landscape
- Crossplane documentation
- FinOps Foundation guides
