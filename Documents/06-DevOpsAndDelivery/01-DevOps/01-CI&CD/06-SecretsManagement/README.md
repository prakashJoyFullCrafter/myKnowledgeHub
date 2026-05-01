# Secrets Management - Curriculum

## Module 1: Why Secrets Management Matters
- [ ] **Never commit secrets to git** — once committed, assume compromised forever
- [ ] Risks: API keys, database passwords, encryption keys, OAuth client secrets
- [ ] **Anti-patterns**: hardcoded in code, plain env vars in YAML, base64 ≠ encryption
- [ ] Compliance: PCI-DSS, HIPAA, SOC2 require proper secrets management
- [ ] **Secret zero problem**: where to store the master key that decrypts everything else?

## Module 2: HashiCorp Vault
- [ ] Centralized secrets storage with fine-grained access control
- [ ] **Secret engines**: KV (key-value), Database (dynamic credentials), PKI, Transit (encryption as a service)
- [ ] **Dynamic secrets**: Vault generates short-lived database passwords on demand
- [ ] **Auth methods**: Token, Kubernetes, AWS IAM, OIDC, AppRole, LDAP
- [ ] **Policies**: HCL-based ACLs, path-based permissions
- [ ] **Audit logs**: every access logged for compliance
- [ ] **Vault Agent**: sidecar that auto-renews and templates secrets
- [ ] **Spring Cloud Vault**: `spring-cloud-starter-vault-config` for Spring Boot integration
- [ ] **High availability**: Raft storage backend, auto-unseal with cloud KMS

## Module 3: Cloud-Native Secrets
- [ ] **AWS Secrets Manager**: managed secrets store with auto-rotation
  - [ ] RDS rotation, Lambda rotation
  - [ ] Cross-region replication
  - [ ] Resource-based policies
- [ ] **AWS Systems Manager Parameter Store**: cheaper alternative for non-sensitive config
  - [ ] SecureString type with KMS encryption
  - [ ] Hierarchical naming: `/myapp/prod/db/password`
- [ ] **GCP Secret Manager**: GCP-native, IAM-based access
- [ ] **Azure Key Vault**: secrets, keys, certificates
- [ ] **AWS KMS / GCP KMS / Azure Key Vault**: encryption key management (the "key to the keys")

## Module 4: Kubernetes Secrets
- [ ] **Native K8s Secrets**: base64 encoded (NOT encrypted), stored in etcd
- [ ] **Encryption at rest**: enable etcd encryption with `EncryptionConfiguration`
- [ ] **Don't commit Secret manifests** — never push to git as-is
- [ ] **Sealed Secrets** (Bitnami): encrypts Secret manifests so they CAN be committed
  - [ ] Controller decrypts in cluster using private key
- [ ] **External Secrets Operator (ESO)**: sync secrets from external stores (Vault, AWS SM, GCP SM) into K8s Secrets
- [ ] **CSI Secret Store Driver**: mount secrets directly from external store as files
- [ ] **SOPS (Mozilla)**: encrypt secrets in YAML/JSON files with age, GPG, AWS KMS
- [ ] **Helm Secrets**: SOPS plugin for Helm

## Module 5: Secrets in CI/CD
- [ ] **GitHub Actions secrets**: `${{ secrets.MY_SECRET }}` — encrypted, masked in logs
- [ ] **GitLab CI variables**: protected, masked
- [ ] **Jenkins Credentials**: store in Jenkins, inject via `credentials()`
- [ ] **OIDC for cloud auth**: GitHub Actions → AWS IAM via OIDC (no long-lived keys!)
- [ ] **Secret scanning**: GitHub Secret Scanning, GitGuardian, TruffleHog — detect leaked secrets
- [ ] **Pre-commit hooks**: prevent committing secrets locally
- [ ] **Secret rotation**: automatic rotation reduces blast radius of compromise

## Module 6: Best Practices
- [ ] **Principle of least privilege**: each service gets only the secrets it needs
- [ ] **Short-lived credentials**: prefer dynamic secrets and IAM roles over static keys
- [ ] **Audit everything**: who accessed what secret when
- [ ] **Rotate regularly**: automated rotation > manual rotation
- [ ] **Separate secrets by environment**: dev, staging, prod — different Vault paths/namespaces
- [ ] **No secrets in logs**: scrub logs, never log auth headers, configure SLF4J converters
- [ ] **No secrets in error messages**: catch and sanitize before returning to clients
- [ ] **Emergency rotation**: have a runbook for "we leaked a secret, what now?"
- [ ] **Defense in depth**: even if a secret leaks, network policies + auth limit damage

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Set up Vault dev mode, store secrets, integrate with Spring Boot via Spring Cloud Vault |
| Module 3 | Use AWS Secrets Manager with rotation for an RDS database password |
| Module 4 | Compare Sealed Secrets vs External Secrets Operator for the same workflow |
| Module 5 | Configure GitHub Actions → AWS deployment using OIDC (no long-lived keys) |
| Module 6 | Audit a project for hardcoded secrets, set up TruffleHog pre-commit hook |

## Key Resources
- HashiCorp Vault documentation
- Bitnami Sealed Secrets (github.com/bitnami-labs/sealed-secrets)
- External Secrets Operator (external-secrets.io)
- "Secrets Management at Scale" - HashiCorp guide
- OWASP Secrets Management Cheat Sheet
