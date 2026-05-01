# Security Standards - Curriculum

Org-wide security baseline that every service must meet - secure-by-default, paved-road tooling, audit-ready.

## Topics
### Secure Coding Baseline
- [ ] **OWASP Top 10** (Web) - covered by linters and review checklists
- [ ] **OWASP API Security Top 10**
- [ ] **OWASP ASVS** as the requirements framework
- [ ] Input validation at boundaries; output encoding context-aware
- [ ] Parameterized queries only - no string concatenation SQL
- [ ] Authn / authz checked on every mutation path (no IDOR)
- [ ] CSRF, XSS, SSRF, deserialization - language-specific defenses
- [ ] Cryptography: use platform primitives, never roll your own

### Secret Management
- [ ] No secrets in code or `.env` committed to Git
- [ ] **Vault** / **AWS Secrets Manager** / **GCP Secret Manager** as the source of truth
- [ ] Workload identity (IRSA, GKE Workload Identity, Azure Managed Identity) - no static keys
- [ ] **OIDC federation** for CI → cloud (GitHub Actions OIDC)
- [ ] Secret rotation policy
- [ ] **gitleaks**, **trufflehog** in pre-commit and CI
- [ ] Secret incident response runbook

### Static & Dynamic Analysis
- [ ] **SAST** in CI: CodeQL, Semgrep, Snyk Code
- [ ] **DAST**: OWASP ZAP, Burp, Stackhawk in pipeline or staging
- [ ] **IAST** for runtime instrumentation
- [ ] Container image scanning: Trivy, Grype, Clair
- [ ] IaC scanning: Checkov, tfsec, KICS
- [ ] Findings triage SLAs

### Supply Chain Security
- [ ] **SLSA** (Supply chain Levels for Software Artifacts) levels
- [ ] **SBOM** generation and storage per artifact
- [ ] **Sigstore / Cosign** for artifact signing
- [ ] Verification policies in admission controllers (Kyverno, Gatekeeper)
- [ ] Reproducible builds where feasible
- [ ] Pinned base images, minimal images (distroless, Chainguard)

### Network & Runtime
- [ ] mTLS by default (service mesh: Istio, Linkerd)
- [ ] Default-deny network policies in K8s
- [ ] Pod Security Standards / Restricted profile
- [ ] Runtime threat detection (Falco, GuardDuty)

### Compliance & Audit
- [ ] Audit logging standards (separate stream, tamper-evident)
- [ ] **SOC2 / ISO27001 / PCI-DSS / HIPAA** controls inventory (where relevant)
- [ ] Access reviews quarterly
- [ ] Threat modeling (STRIDE) for new services
- [ ] Penetration testing cadence
