# Container Registry - Curriculum

## Module 1: Container Registry Fundamentals
- [ ] **Registry**: service that stores and distributes container images
- [ ] **Image reference**: `[registry]/[namespace]/repository:tag` or `@sha256:...`
- [ ] **Default**: Docker Hub (`docker.io/library/nginx:latest`)
- [ ] **Public vs private**: public for open source, private for proprietary
- [ ] **Pull through cache / mirror**: proxy registry that caches upstream
- [ ] **Why it matters**: images are the deployable unit — registry is the supply chain

## Module 2: Image Naming & Tagging
- [ ] **Full reference**: `registry.example.com/team/app:v1.2.3`
- [ ] **Tag conventions**:
  - [ ] Semantic versions: `v1.2.3` (preferred)
  - [ ] Git SHA: `abc123d` (immutable, traceable)
  - [ ] `latest`: mutable, avoid in production
- [ ] **Digests**: `@sha256:abc...` — immutable content address
  - [ ] Use digests in production for exact image guarantee
- [ ] **Immutable tags**: registry-level protection against overwrites

## Module 3: Registry Options
- [ ] **Public registries**:
  - [ ] Docker Hub (rate-limited for free tier)
  - [ ] GHCR (ghcr.io) — free for public repos
  - [ ] Quay.io (Red Hat)
- [ ] **Cloud-hosted private**:
  - [ ] AWS ECR
  - [ ] GCP Artifact Registry
  - [ ] Azure Container Registry (ACR)
- [ ] **Self-hosted**:
  - [ ] **Harbor** (CNCF): enterprise features
  - [ ] Distribution (registry:2): minimal official
  - [ ] Nexus, JFrog Artifactory: general artifact repos
- [ ] **Choosing**: cloud for simplicity, Harbor for enterprise/multi-cloud

## Module 4: Harbor Deep Dive
- [ ] **Harbor**: open-source, CNCF graduated, enterprise-ready
- [ ] **Features**:
  - [ ] RBAC (projects, users, groups)
  - [ ] Image scanning (Trivy)
  - [ ] Replication between registries
  - [ ] Image signing (Cosign)
  - [ ] Immutable tags
  - [ ] Retention policies
  - [ ] Quota management
- [ ] **Projects**: top-level grouping, access control unit
- [ ] **Webhooks**: notifications on push/scan

## Module 5: Image Security
- [ ] **Vulnerability scanning**:
  - [ ] Scanners: Trivy, Grype, Clair, Snyk
  - [ ] Scan on push, scan periodically
  - [ ] Fail pipeline on critical CVEs
- [ ] **Image signing** (supply chain):
  - [ ] **Cosign** (sigstore): sign with keys or OIDC
  - [ ] Verify before deployment
- [ ] **Admission control**: block unsigned/unscanned images
  - [ ] Kyverno, OPA Gatekeeper, Connaisseur
- [ ] **Private base images**: rebuild regularly

## Module 6: Replication & HA
- [ ] **Replication**: sync between registries (multi-region, DR, air-gapped)
- [ ] **Pull-through cache**: proxy Docker Hub, cache locally (reduce egress, rate limits)
- [ ] **Registry HA**: multiple replicas behind load balancer
- [ ] **Storage**: S3, GCS, Azure Blob, NFS

## Module 7: Authentication & Authorization
- [ ] **Authentication**: username/password, token (JWT), OIDC, IAM roles
- [ ] **`docker login`**: stores credentials
- [ ] **Kubernetes**: `imagePullSecrets` for private registries
- [ ] **Service accounts**: workloads pull with SA credentials
- [ ] **RBAC**: push/pull/admin per repository

## Module 8: Lifecycle & Retention
- [ ] **Image retention**: delete old/unused images
- [ ] **Policies**:
  - [ ] Keep N most recent
  - [ ] Delete untagged (orphaned)
  - [ ] Keep images matching regex (`v*`)
- [ ] **Garbage collection**: reclaim storage from deleted manifests
- [ ] **Immutable tags**: prevent overwriting production tags
- [ ] **Cost**: registry storage adds up at scale

## Module 9: CI/CD Integration & Multi-Arch
- [ ] **Build-push pattern**:
  1. [ ] CI builds image
  2. [ ] Tags with Git SHA + version
  3. [ ] Pushes to registry
  4. [ ] Deployment references new tag/digest
- [ ] **Multi-platform builds**: `docker buildx` pushes amd64 + arm64 manifest
- [ ] **Build caching**: inline cache, cache mounts (faster CI)
- [ ] **OIDC authentication**: CI → registry without long-lived credentials
- [ ] **Registry webhooks**: trigger downstream on push

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Push image to Docker Hub with proper tagging |
| Module 3 | Compare ECR, GHCR, and Harbor for a team |
| Module 4 | Deploy Harbor with Docker Compose, create project |
| Module 5 | Scan image with Trivy, sign with Cosign |
| Module 6 | Set up Harbor replication |
| Module 7 | Configure K8s to pull from private registry |
| Module 8 | Configure retention policy |
| Module 9 | Build multi-arch image with buildx |

## Key Resources
- goharbor.io (Harbor)
- docs.docker.com/registry/
- sigstore.dev (Cosign)
- "Container Security" — Liz Rice
- CNCF supply chain best practices
