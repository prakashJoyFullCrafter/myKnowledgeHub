# GitOps - Curriculum

## Module 1: GitOps Principles
- [ ] **GitOps**: operational framework using Git as single source of truth
- [ ] **Four principles** (OpenGitOps):
  1. [ ] **Declarative**: system described declaratively
  2. [ ] **Versioned & immutable**: desired state versioned in Git
  3. [ ] **Pulled automatically**: agents pull desired state
  4. [ ] **Continuously reconciled**: agents detect drift, correct it
- [ ] **Benefits**: audit trail, rollback via revert, review via PR, DR (re-apply Git)
- [ ] **GitOps vs CIOps**:
  - [ ] CIOps: CI pushes to cluster (broad credentials, audit gap)
  - [ ] GitOps: cluster pulls from Git (least privilege, self-healing)

## Module 2: Push vs Pull Model
- [ ] **Push model** (traditional CI/CD):
  - [ ] CI pipeline has cluster credentials
  - [ ] CI runs `kubectl apply`
  - [ ] Issues: credentials in CI, manual drift
- [ ] **Pull model** (GitOps):
  - [ ] Agent runs inside cluster
  - [ ] Watches Git repo
  - [ ] Reconciles cluster to match Git
  - [ ] Benefits: credentials stay inside cluster, self-healing, no drift

## Module 3: Repository Strategies
- [ ] **Mono-repo**: all infra + all apps (single source of truth, large)
- [ ] **Separate app vs infra repos**:
  - [ ] `app-code` repo: source code
  - [ ] `app-config` repo: K8s manifests (GitOps watches this)
  - [ ] CI builds image → updates manifest repo → GitOps deploys
- [ ] **Environment layout**:
  - [ ] Branches per env (hard to promote)
  - [ ] **Folders per env** (recommended)
  - [ ] Separate repos per env (strongest isolation)
- [ ] **Promotion workflow**: dev folder → staging → prod via PR

## Module 4: Tools Comparison
- [ ] **ArgoCD**: feature-rich UI, ApplicationSets, most popular
- [ ] **Flux CD**: GitOps toolkit, CLI-first, lighter-weight
- [ ] **Jenkins X**: GitOps + Jenkins integration
- [ ] **Fleet** (Rancher): multi-cluster GitOps
- [ ] **Choosing**: ArgoCD for UI + features, Flux for Kubernetes-native simplicity

## Module 5: Image Updates & Promotion
- [ ] **Challenge**: when new image built, who updates the manifest?
- [ ] **Image Updater (ArgoCD)**: auto-updates manifest with new image tags
- [ ] **Flux Image Automation**: similar capability
- [ ] **CI-driven update**: CI pushes commit to manifest repo (recommended for production)
- [ ] **Promotion**: PR from dev → staging → prod (via review)
- [ ] **Rollback**: `git revert` → agent re-applies old version

## Module 6: Secrets in GitOps
- [ ] **Problem**: Git is plaintext — can't commit secrets
- [ ] **Solutions**:
  - [ ] **Sealed Secrets** (Bitnami): encrypt in Git, decrypt in cluster
  - [ ] **External Secrets Operator**: references in Git, values from Vault/AWS/Azure
  - [ ] **SOPS (Mozilla)**: encrypt files with KMS/PGP/age keys
  - [ ] **Vault Agent Injector**: Vault-side secrets, agent pulls into pods
- [ ] **Recommendation**: External Secrets Operator
- [ ] **Never commit**: plaintext secrets, even in private repos

## Module 7: Drift Detection & Self-Healing
- [ ] **Drift**: cluster state differs from Git
- [ ] **Detection**: ArgoCD/Flux compare at sync interval
- [ ] **Self-healing**: auto-reconcile back to Git state
- [ ] **Trade-off**: self-heal is safer but prevents emergency overrides
- [ ] **Break-glass**: disable sync temporarily, document the reason

## Module 8: Multi-Cluster & Progressive Delivery
- [ ] **Multi-cluster GitOps**: hub-spoke or federated
- [ ] **Progressive delivery**:
  - [ ] Argo Rollouts + ArgoCD
  - [ ] Flagger + Flux
- [ ] **Rollback via Git revert**: fast, auditable

## Module 9: Best Practices
- [ ] Separate app vs config repos
- [ ] Environment-per-folder structure
- [ ] PR-based promotion between environments
- [ ] Automated sync + self-heal for production
- [ ] External Secrets Operator for secrets
- [ ] Notifications on sync failures
- [ ] Backup Git (disaster recovery)
- [ ] Document break-glass procedures
- [ ] Monitor drift events

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Refactor a CIOps setup into GitOps |
| Module 2 | Compare push vs pull security for same pipeline |
| Module 3 | Design repo structure for 5 services × 3 environments |
| Module 4 | Deploy same app with ArgoCD and Flux, compare UX |
| Module 5 | Set up image auto-updater |
| Module 6 | Deploy app with External Secrets Operator + Vault |
| Module 7 | Simulate drift, observe self-healing |
| Module 8 | Set up canary deployment |
| Module 9 | Audit a GitOps setup against best practices |

## Key Resources
- opengitops.dev (OpenGitOps principles)
- "GitOps: Continuous Deployment for Cloud Native Applications" — Weaveworks
- argo-cd.readthedocs.io / fluxcd.io
- "GitOps and Kubernetes" — Manning
