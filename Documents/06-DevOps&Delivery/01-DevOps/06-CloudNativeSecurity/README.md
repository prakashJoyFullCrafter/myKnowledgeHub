# Cloud Native Security - Curriculum

Securing Kubernetes-based platforms: policy-as-code, runtime security, zero trust, and the CNCF security layers.

---

## Module 1: Cloud Native Threat Model
- [ ] **CNCF Cloud Native Security Whitepaper** — the 4 C's:
  - [ ] **Code**: application security (dependencies, secrets, encryption)
  - [ ] **Container**: image security, runtime, least privilege
  - [ ] **Cluster**: RBAC, network policies, admission control
  - [ ] **Cloud**: provider security, IAM, infrastructure
- [ ] **Defense in depth**: multiple overlapping layers
- [ ] **Shift left**: catch issues early in the SDLC
- [ ] **Zero trust**: never trust, always verify
- [ ] **Threats**: supply chain, privilege escalation, data exfiltration, lateral movement, cryptomining

## Module 2: Kubernetes Security Essentials
- [ ] **RBAC**: least privilege for users, service accounts, pods
- [ ] **Network Policies**: default deny all, explicit allow
- [ ] **Pod Security Admission (PSA)**: enforce `restricted` profile
- [ ] **SecurityContext** on every pod: `runAsNonRoot`, `readOnlyRootFilesystem`, `drop ALL capabilities`
- [ ] **Secrets encryption at rest**: enable for etcd
- [ ] **Audit logs**: enable API server audit logging
- [ ] **Node security**: harden host OS, SELinux/AppArmor, kernel updates
- [ ] **API server**: authentication (OIDC), anonymous access disabled
- [ ] **Admission controllers**: enable recommended ones

## Module 3: Policy as Code — OPA & Gatekeeper
- [ ] **OPA (Open Policy Agent)**: general-purpose policy engine
- [ ] **Rego**: policy language (declarative, logic-based)
- [ ] **OPA Gatekeeper**: Kubernetes admission controller using OPA
- [ ] **Two types**:
  - [ ] **ConstraintTemplate**: the policy logic (Rego)
  - [ ] **Constraint**: instance of a template with parameters
- [ ] **Example policies**:
  - [ ] Require resource limits on all containers
  - [ ] Allow only images from approved registries
  - [ ] Require specific labels on all pods
  - [ ] Disallow privileged containers
- [ ] **Audit mode**: find violations without blocking
- [ ] **Enforce mode**: block violating resources
- [ ] **Alternatives**: Kyverno (simpler, YAML-based)

## Module 4: Kyverno
- [ ] **Kyverno**: Kubernetes-native policy engine, CNCF graduated
- [ ] **Differences from OPA**:
  - [ ] YAML policies (no Rego DSL)
  - [ ] K8s-native (not general-purpose)
  - [ ] Supports mutation (not just validation)
  - [ ] Image verification with Cosign
- [ ] **Policy types**:
  - [ ] Validate: accept/reject
  - [ ] Mutate: modify resources
  - [ ] Generate: create resources
  - [ ] Verify Images: signature verification
- [ ] **Example**: require all pods to have `app.kubernetes.io/name` label
- [ ] **Best practices library**: community policies in kyverno-policies repo
- [ ] **Easier learning curve** than OPA for K8s-specific use cases

## Module 5: Runtime Security — Falco
- [ ] **Falco**: CNCF graduated, runtime security tool
- [ ] **How it works**: hooks syscalls (traditionally via kernel module, now eBPF)
- [ ] **Rules**: YAML, match on syscall patterns
- [ ] **Example alerts**:
  - [ ] Shell opened inside container
  - [ ] Write to `/etc` in container
  - [ ] Privileged container started
  - [ ] Unusual network connection
  - [ ] Sensitive file read
- [ ] **Integrations**: Slack, PagerDuty, webhooks, SIEM
- [ ] **Custom rules**: define your own based on specific threats

## Module 6: Image Security Pipeline
- [ ] **Build-time**:
  - [ ] Use trusted base images (distroless, chainguard)
  - [ ] Scan with Trivy, Grype, Snyk
  - [ ] Sign with Cosign (keyless)
  - [ ] Generate SBOM (syft)
  - [ ] SLSA provenance
- [ ] **Registry**:
  - [ ] Private registry with access control
  - [ ] Scanning on push
  - [ ] Immutable tags
- [ ] **Deploy-time**:
  - [ ] Admission control: only signed, scanned images
  - [ ] Image verification (Cosign, Kyverno)
  - [ ] Block critical CVEs
- [ ] **Runtime**: continuously scan running images for new CVEs

## Module 7: Secrets Management in K8s
- [ ] **K8s Secret default**: base64, not encrypted by default
- [ ] **Enable encryption at rest**: etcd encryption config
- [ ] **External Secrets Operator**: sync secrets from Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager
- [ ] **Sealed Secrets**: encrypt in Git, decrypt in cluster (GitOps-friendly)
- [ ] **Vault Agent Injector**: sidecar injects secrets into pod filesystem
- [ ] **Workload Identity**: pod gets cloud IAM identity, no static credentials
- [ ] **SPIFFE/SPIRE**: workload identity standard
- [ ] **Never**: commit plaintext secrets, even in private repos

## Module 8: Zero Trust Architecture
- [ ] **Zero trust**: never trust, always verify
- [ ] **Principles**:
  - [ ] Verify identity (user + device + context) for every request
  - [ ] Least privilege access
  - [ ] Assume breach
  - [ ] Microsegmentation
- [ ] **Implementation in K8s**:
  - [ ] mTLS everywhere (service mesh)
  - [ ] Network policies default-deny
  - [ ] No static credentials (workload identity)
  - [ ] Strong identity (OIDC + short-lived tokens)
  - [ ] Continuous verification (audit, anomaly detection)
- [ ] **BeyondCorp** (Google): pioneered zero trust
- [ ] **SPIFFE/SPIRE**: universal workload identity

## Module 9: Compliance & Auditing
- [ ] **Compliance frameworks**:
  - [ ] **SOC 2**: security controls audit
  - [ ] **PCI DSS**: payment card data
  - [ ] **HIPAA**: healthcare
  - [ ] **GDPR**: data protection (EU)
  - [ ] **CIS Benchmarks**: hardening standards
- [ ] **Tools**:
  - [ ] **kube-bench**: CIS Benchmark scanner for K8s
  - [ ] **kubesec**: security scoring for K8s manifests
  - [ ] **Starboard / Trivy Operator**: unified security scanning
- [ ] **Audit trails**: K8s audit log, cloud provider audit (CloudTrail, Cloud Audit Logs)
- [ ] **Report generation**: periodic reports for auditors

## Module 10: Incident Response
- [ ] **Playbooks**: prepared runbooks for common incidents
- [ ] **Isolation**:
  - [ ] Network policy to isolate compromised pod
  - [ ] Cordon node, evict pods
  - [ ] Revoke compromised credentials
- [ ] **Forensics**:
  - [ ] Snapshot pod state
  - [ ] Collect logs (audit, container, host)
  - [ ] Analyze container image
- [ ] **Recovery**:
  - [ ] Rotate secrets
  - [ ] Rebuild from known-good images
  - [ ] Post-incident review
- [ ] **Tools**: Sysdig, Aqua, Prisma Cloud (commercial K8s security platforms)

## Module 11: CNCF Security Projects
- [ ] **Graduated / Incubating**:
  - [ ] **Falco**: runtime security
  - [ ] **OPA**: policy engine
  - [ ] **Kyverno**: K8s policy
  - [ ] **in-toto**: supply chain
  - [ ] **Sigstore**: signing (Cosign)
  - [ ] **SPIFFE/SPIRE**: workload identity
  - [ ] **Notary**: image signing (older)
  - [ ] **TUF**: update framework
- [ ] **Sandbox**:
  - [ ] **Tetragon**: eBPF-based security observability
  - [ ] **Confidential Containers**: hardware isolation
- [ ] **Explore cncf.io/projects**: security category

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Map threats for a K8s cluster using 4 C's framework |
| Module 2 | Apply Pod Security Admission 'restricted' to a namespace |
| Module 3 | Install OPA Gatekeeper, create a constraint |
| Module 4 | Install Kyverno, migrate one policy from Gatekeeper |
| Module 5 | Deploy Falco, trigger alert via unexpected shell |
| Module 6 | Build image pipeline: scan → sign → verify → deploy |
| Module 7 | Set up External Secrets Operator with Vault |
| Module 8 | Implement mTLS everywhere via service mesh |
| Module 9 | Run kube-bench, fix 5 CIS findings |
| Module 10 | Write runbook for "compromised pod" incident |
| Module 11 | Review CNCF security landscape, pick tools for your stack |

## Key Resources
- CNCF Cloud Native Security Whitepaper
- "Container Security" — Liz Rice
- "Kubernetes Security" — Liz Rice & Michael Hausenblas
- openpolicyagent.org
- kyverno.io
- falco.org
- CIS Kubernetes Benchmark
