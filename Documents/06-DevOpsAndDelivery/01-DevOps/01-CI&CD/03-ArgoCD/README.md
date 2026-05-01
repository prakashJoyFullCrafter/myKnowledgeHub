# ArgoCD - Curriculum

## Module 1: GitOps Fundamentals with ArgoCD
- [ ] **ArgoCD**: declarative GitOps continuous delivery for Kubernetes
- [ ] **CNCF graduated project** — most popular GitOps tool
- [ ] **Core principle**: Git is the source of truth for cluster state
- [ ] **Flow**:
  1. [ ] Developer pushes manifest changes to Git
  2. [ ] ArgoCD detects change, compares Git vs cluster
  3. [ ] ArgoCD syncs cluster to match Git state
- [ ] **Pull vs push**: ArgoCD pulls from Git → cluster (safer)
- [ ] **Alternatives**: Flux CD, Jenkins X, Spinnaker

## Module 2: Architecture
- [ ] **Components**:
  - [ ] **API Server**: UI, CLI, API
  - [ ] **Repository Server**: clones Git repos, generates manifests
  - [ ] **Application Controller**: reconciliation loop
  - [ ] **Redis**: cache
  - [ ] **Dex** (optional): SSO integration
- [ ] **Runs in cluster**: deploys other apps to same or other clusters
- [ ] **Multi-cluster support**: one ArgoCD can manage many clusters

## Module 3: Applications
- [ ] **Application**: the unit of deployment (CRD-based)
- [ ] **Example**:
  ```yaml
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  metadata:
    name: my-app
  spec:
    source:
      repoURL: https://github.com/org/repo
      path: k8s/prod
      targetRevision: main
    destination:
      server: https://kubernetes.default.svc
      namespace: my-app
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
  ```
- [ ] **Source types**: Helm, Kustomize, plain YAML, Jsonnet
- [ ] **Destination**: target cluster and namespace

## Module 4: Sync Strategies
- [ ] **Manual sync**: click "Sync" in UI or CLI
- [ ] **Automated sync**: detect drift and auto-correct
- [ ] **`prune: true`**: delete resources not in Git
- [ ] **`selfHeal: true`**: revert manual cluster changes
- [ ] **Sync waves**: order resource creation (`argocd.argoproj.io/sync-wave: "1"`)
- [ ] **Hooks**: pre/post/sync hooks for migrations, smoke tests
- [ ] **Sync options**: `Replace=true`, `CreateNamespace=true`

## Module 5: App of Apps & ApplicationSets
- [ ] **App of Apps**: one Application deploys others (bootstrapping)
- [ ] **ApplicationSet** (preferred):
  - [ ] Template + generators (list, cluster, git, matrix)
  - [ ] Scale to many apps, clusters, environments
- [ ] **Multi-cluster deploys**: one ApplicationSet across 10 clusters

## Module 6: Helm & Kustomize Integration
- [ ] **Helm**: ArgoCD renders charts, applies output (no `helm install`)
- [ ] **Kustomize**: native support, apply overlays
- [ ] **Hybrid**: Helm chart + Kustomize overlay
- [ ] **Choosing**: Helm for packaging, Kustomize for environment diffs

## Module 7: RBAC & Multi-Tenancy
- [ ] **Projects**: groupings of Applications with policies
  - [ ] Restrict source Git repos
  - [ ] Restrict destination clusters/namespaces
  - [ ] Restrict resource types
- [ ] **RBAC**: define roles for Projects
- [ ] **SSO integration**: SAML, OIDC, Dex
- [ ] **Audit log**: who deployed what, when

## Module 8: Progressive Delivery with Argo Rollouts
- [ ] **Argo Rollouts**: canary/blue-green deployment controller
- [ ] **Canary**: 10% → 30% → 60% → 100% with analysis
- [ ] **Blue-green**: deploy new, preview, cutover
- [ ] **Analysis runs**: Prometheus queries to auto-pause/promote/abort
- [ ] **Integrations**: Istio, NGINX, ALB, SMI for traffic splitting

## Module 9: Best Practices
- [ ] **Separate repos**: app code vs Kubernetes manifests
- [ ] **Automated sync + selfHeal** for production
- [ ] **Use Projects** for team isolation
- [ ] **Secrets**: External Secrets Operator or Sealed Secrets
- [ ] **Notifications**: Slack/PagerDuty on sync failures
- [ ] **Backup ArgoCD state**
- [ ] **Disaster recovery**: ArgoCD is self-hosting — bootstrap concern

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Install ArgoCD in kind cluster |
| Module 3 | Deploy first Application from a Git repo |
| Module 4 | Enable automated sync with self-heal, test drift correction |
| Module 5 | Build ApplicationSet for multi-env deployment |
| Module 6 | Deploy a Helm chart via ArgoCD |
| Module 7 | Create a Project with RBAC for a team |
| Module 8 | Set up Argo Rollouts canary with Prometheus analysis |
| Module 9 | Configure Slack notifications for sync failures |

## Key Resources
- argo-cd.readthedocs.io
- "GitOps and Kubernetes" — Billy Yuen et al.
- Argo Rollouts documentation
- OpenGitOps principles (opengitops.dev)
