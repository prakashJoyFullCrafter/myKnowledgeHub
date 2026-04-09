# Cloud & Container Security - Curriculum

## Module 1: Container Security
- [ ] **Container basics**: Linux namespaces (PID, NET, MNT, USER) + cgroups
- [ ] Containers ≠ VMs: shared kernel, weaker isolation
- [ ] **Image security**:
  - [ ] Use minimal base images: `distroless`, `alpine`, `scratch`
  - [ ] Scan images for vulnerabilities: Trivy, Grype, Snyk, Docker Scout
  - [ ] Sign images: Cosign, Notary, Sigstore
  - [ ] Pin image digests, not tags (`@sha256:...`)
- [ ] **Don't run as root**: `USER` directive, rootless containers
- [ ] **Read-only filesystem**: `--read-only`, write-only to specific volumes
- [ ] **Drop capabilities**: `--cap-drop=ALL --cap-add=NET_BIND_SERVICE`
- [ ] **No privileged mode**: `--privileged` is essentially root on host
- [ ] **Seccomp profiles**: restrict syscalls
- [ ] **AppArmor / SELinux**: mandatory access control
- [ ] **Secrets in images**: never bake secrets into images, use mounted secrets

## Module 2: Container Escape Risks
- [ ] **Privileged container escape**: full host access
- [ ] **Mounted Docker socket** (`/var/run/docker.sock`): can spawn containers as root on host
- [ ] **`hostPID`, `hostNetwork`, `hostIPC`**: shared with host = weakened isolation
- [ ] **Kernel exploits**: shared kernel means kernel bug = container escape
- [ ] **CVE awareness**: runc CVE-2019-5736, Dirty Pipe (CVE-2022-0847)
- [ ] **Runtime detection**: Falco, Sysdig, Aqua — detect anomalous container behavior
- [ ] **Defense**: gVisor, Kata Containers (lightweight VMs), Firecracker

## Module 3: Kubernetes Security
- [ ] **RBAC**: principle of least privilege, no `cluster-admin` for apps
- [ ] **Pod Security Standards**: Restricted, Baseline, Privileged
- [ ] **Network Policies**: default deny, allow specific pod-to-pod traffic
- [ ] **Service Account tokens**: don't auto-mount unless needed
- [ ] **Secrets**: K8s Secrets are base64, not encrypted by default — use sealed-secrets, External Secrets Operator
- [ ] **Admission controllers**: OPA Gatekeeper, Kyverno — policy enforcement
- [ ] **Image pull policy**: `Always` for tags, immutable digests preferred
- [ ] **Resource limits**: prevent DoS via resource exhaustion
- [ ] **Audit logging**: enable K8s audit logs, monitor sensitive actions
- [ ] **etcd encryption at rest**: encrypt secrets in etcd
- [ ] **kube-bench**: CIS Kubernetes Benchmark scanner

## Module 4: Cloud Security (AWS-focused)
- [ ] **IAM principles**:
  - [ ] Least privilege: only required permissions
  - [ ] No long-lived access keys — use IAM roles
  - [ ] MFA for all human users
  - [ ] Service roles with assume-role for app identity
- [ ] **IAM privilege escalation paths**: `iam:PassRole`, `iam:CreatePolicyVersion`, `lambda:UpdateFunctionCode`
- [ ] **S3 bucket misconfigurations**: public buckets, missing block-public-access
- [ ] **Security groups**: never `0.0.0.0/0` on management ports (22, 3389, 3306)
- [ ] **Secrets management**: AWS Secrets Manager, Parameter Store, HashiCorp Vault — never in env vars or code
- [ ] **CloudTrail**: audit all API calls, alert on suspicious activity
- [ ] **GuardDuty**: managed threat detection
- [ ] **Config**: compliance and configuration drift monitoring
- [ ] **VPC design**: public/private subnets, NAT gateways, no direct DB internet access

## Module 5: SSRF & Cloud Metadata Service Attack
- [ ] **Cloud metadata service**: `http://169.254.169.254/latest/meta-data/` (AWS EC2)
- [ ] **SSRF leading to credential theft**: vulnerable app → fetch metadata → IAM role credentials → AWS API access
- [ ] **IMDSv2**: requires session token in header — protects against many SSRF
- [ ] **Defense**: block 169.254.169.254 in egress, allowlist outbound URLs, IMDSv2 enforcement
- [ ] **Capital One breach**: classic SSRF → metadata service → S3 data exfiltration
- [ ] Other cloud metadata services: GCP `metadata.google.internal`, Azure `169.254.169.254`

## Module 6: Supply Chain Security
- [ ] **Dependency vulnerabilities**: scan with Snyk, Dependabot, OWASP Dependency-Check
- [ ] **Typosquatting**: malicious packages with similar names (`lodahs` vs `lodash`)
- [ ] **SBOM** (Software Bill of Materials): catalog of all dependencies
- [ ] **SLSA** (Supply-chain Levels for Software Artifacts): provenance framework
- [ ] **Reproducible builds**: same source = same binary, verifiable
- [ ] **Sign artifacts**: Sigstore, Cosign — verify build came from CI, not from attacker
- [ ] **Pin dependency versions**: never use `latest` in production
- [ ] **Recent attacks**: SolarWinds, Codecov, ua-parser-js, xz-utils backdoor

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a hardened Dockerfile: distroless, non-root, dropped caps, scan with Trivy |
| Module 3 | Deploy a K8s app with NetworkPolicy, RBAC, PodSecurityStandard restricted |
| Module 4 | IAM role audit: find over-permissive policies in a sample AWS account |
| Module 5 | Lab: vulnerable app → SSRF → IMDSv1 → AWS credentials (educational, on your own AWS) |
| Module 6 | Generate SBOM with syft, scan with Trivy, sign image with Cosign |

## Key Resources
- CIS Kubernetes Benchmark
- AWS Security Best Practices
- "Container Security" - Liz Rice
- OWASP Container Security Top 10
- Falco documentation (runtime security)
- HackTricks - Cloud & Container chapters
