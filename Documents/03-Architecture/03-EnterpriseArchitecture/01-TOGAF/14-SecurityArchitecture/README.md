# TOGAF 10 — Security Architecture Series Guide

## What is Security Architecture in TOGAF 10?

- TOGAF 10 introduced a dedicated Security Architecture Series Guide (major addition over 9.2)
- Security is a cross-cutting concern — it spans ALL four BDAT domains, not just Technology
- Security Architecture = the practice of designing, building, and maintaining security into enterprise architecture from inception
- Key principle: Security by Design (not bolted-on after the fact)

---

## Security Architecture Across BDAT Domains

### Business Domain Security Concerns

- Business risk appetite and risk tolerance statements
- Regulatory and compliance obligations (GDPR, PCI-DSS, HIPAA, SOX, NIS2)
- Business continuity and disaster recovery policies
- Security governance — roles: CISO, DPO, Risk Committee
- Information classification policy (Public, Internal, Confidential, Restricted)
- Third-party risk management — vendor security assessments

### Data Domain Security Concerns

- Data classification enforcement at the data layer
- Encryption at rest: AES-256 standard; key management (HSM, KMS)
- Data masking and tokenization for sensitive fields (PAN, PII)
- Data loss prevention (DLP) policies
- Data lineage and audit trails — who accessed what, when
- Right to erasure (GDPR Article 17) — technical implementation
- Data residency constraints — where data can physically reside
- Backup encryption and secure deletion

### Application Domain Security Concerns

- OWASP Top 10 — mandatory baseline for all applications:
  1. Broken Access Control
  2. Cryptographic Failures
  3. Injection (SQL, LDAP, Command)
  4. Insecure Design
  5. Security Misconfiguration
  6. Vulnerable and Outdated Components
  7. Identification and Authentication Failures
  8. Software and Data Integrity Failures
  9. Security Logging and Monitoring Failures
  10. Server-Side Request Forgery (SSRF)
- Authentication: OAuth 2.0, OIDC, SAML 2.0 — federated identity
- Authorization: RBAC (Role-Based), ABAC (Attribute-Based), ReBAC (Relationship-Based)
- API security: rate limiting, API keys, JWT validation, mutual TLS
- Secrets management: HashiCorp Vault, AWS Secrets Manager — no hardcoded credentials
- Dependency scanning: OWASP Dependency-Check, Snyk, Dependabot
- SAST (Static Application Security Testing) in CI pipeline
- DAST (Dynamic Application Security Testing) before production

### Technology Domain Security Concerns

- Network segmentation: DMZ, internal zones, micro-segmentation
- Zero Trust Architecture: "never trust, always verify" — no implicit trust based on network location
- Firewall rules, WAF (Web Application Firewall), IDS/IPS
- Endpoint protection: EDR (Endpoint Detection and Response)
- PKI (Public Key Infrastructure): certificate management, CA hierarchy
- SIEM (Security Information and Event Management): centralized logging and alerting
- SOC (Security Operations Center): monitoring, incident response
- Vulnerability management: regular scanning, patching SLAs by severity
- Cloud security: CIS Benchmarks, AWS Security Hub, Azure Defender, GCP Security Command Center

---

## Zero Trust Architecture

### Principles (NIST SP 800-207)

1. All data sources and computing services are resources
2. All communication is secured regardless of network location
3. Access to individual enterprise resources is granted per-session
4. Access to resources is determined by dynamic policy
5. The enterprise monitors and measures the integrity and security posture of all owned assets
6. All resource authentication and authorization is dynamic and strictly enforced
7. The enterprise collects information about the current state of assets, network, and communications

### Zero Trust Components

| Component | Description | Example Products |
|---|---|---|
| **Identity Provider (IdP)** | SSO + MFA enforced for all users | Keycloak, Okta, Azure AD |
| **Device Trust** | Certificates on managed devices; MDM enforcement | Intune, Jamf, CrowdStrike |
| **Network micro-segmentation** | Service mesh for workload identity | Istio, Linkerd, Consul |
| **Continuous verification** | Access tokens expire; re-auth at privilege boundaries | Short-lived JWTs, OIDC |
| **Least privilege** | JIT (Just-in-Time) access; no standing privileged accounts | CyberArk, BeyondTrust PAM |

### Zero Trust in TOGAF ADM

| ADM Phase | Zero Trust Activity |
|---|---|
| Phase A | Define Zero Trust as an Architecture Principle |
| Phase B | Map identity and access requirements to business processes |
| Phase C (App) | Design applications with token-based auth, no session sharing |
| Phase D (Tech) | Design network zones, service mesh, PKI infrastructure |
| Phase G | Compliance checks verify zero trust implementation |

---

## Security Architecture Patterns

### Defense in Depth

Multiple security layers so that if one fails, others remain:

```
Layer 1: Perimeter     (WAF, DDoS protection, firewall)
Layer 2: Network       (segmentation, IDS/IPS, micro-segmentation)
Layer 3: Host          (hardened OS, EDR, patch management)
Layer 4: Application   (OWASP, input validation, auth/authz)
Layer 5: Data          (encryption, DLP, masking)
Layer 6: Identity      (MFA, PAM, least privilege)
```

### API Security Pattern

```
Client → WAF → API Gateway (rate limit, auth) → Service Mesh (mTLS) → Microservice
                    ↓
              Identity Provider (OAuth 2.0 token validation)
```

### Data Protection Pattern

```
Sensitive Data → Classification Tag → Encryption (AES-256 at rest, TLS 1.3 in transit)
                                              ↓
                                     Key Management Service (KMS)
                                              ↓
                                     Audit Log → SIEM
```

---

## Integrating Security into ADM Phases

| ADM Phase | Security Activity | Security Deliverable |
|---|---|---|
| Preliminary | Establish security principles; identify regulatory obligations | Security Architecture Principles |
| Phase A | Identify security risks and constraints; include CISO as stakeholder | Security requirements in Architecture Vision |
| Phase B | Map information classification to business processes; define security governance roles | Business Security Architecture (information classification policy, risk appetite) |
| Phase C (Data) | Define data encryption, masking, residency requirements | Data Security Architecture, DLP policy |
| Phase C (App) | Threat model all new applications (STRIDE); define auth/authz patterns | Application Security Architecture, API security standards |
| Phase D (Tech) | Design network security zones, PKI, SIEM, endpoint protection | Technology Security Architecture, security standards |
| Phase E | Identify security work packages (IdP implementation, SIEM deployment) | Security work packages in Architecture Roadmap |
| Phase G | Security compliance reviews; penetration test results gate | Security compliance assessment |
| Phase H | Monitor for new CVEs, threat intelligence; update security architecture | Security architecture updates |

---

## Threat Modeling — STRIDE

STRIDE is the primary threat modeling framework used in Security Architecture:

| Threat | Description | Example | Control |
|---|---|---|---|
| **S**poofing | Pretending to be something/someone else | Fake API client presenting stolen token | Strong authentication, token binding |
| **T**ampering | Modifying data or code | Man-in-the-middle modifying API payload | TLS everywhere, message signing, checksums |
| **R**epudiation | Denying an action occurred | User claims they didn't make a transaction | Audit logs, digital signatures, non-repudiation |
| **I**nformation Disclosure | Exposing data to unauthorized parties | Error messages revealing stack traces | Error handling, data masking, access controls |
| **D**enial of Service | Making a system unavailable | API flooding, resource exhaustion | Rate limiting, autoscaling, circuit breakers |
| **E**levation of Privilege | Gaining higher permissions than authorized | IDOR vulnerability giving admin access | Least privilege, authorization checks at every layer |

---

## Security Building Blocks

### Architecture Building Blocks (ABBs) — Security

ABBs define *what capability is needed* — they are technology-neutral:

- Identity and Access Management Service
- Cryptographic Services (encryption, signing, key management)
- Audit and Logging Service
- Threat Detection Service
- Network Security Service
- Certificate Management Service

### Solution Building Blocks (SBBs) — Security Examples

SBBs define *specific products or implementations* that realize ABBs:

| ABB | SBB Option A | SBB Option B |
|---|---|---|
| Identity and Access Management | Keycloak (open source) | Okta (SaaS) |
| Key Management | HashiCorp Vault | AWS KMS |
| SIEM | Elastic SIEM | Splunk Enterprise Security |
| WAF | AWS WAF | Cloudflare |
| Secrets Management | HashiCorp Vault | Azure Key Vault |
| Certificate Management | Let's Encrypt + cert-manager | DigiCert |

---

## Security Governance in TOGAF

### Security Compliance Levels (applied to security architecture)

| Level | Definition |
|---|---|
| **Fully Conformant** | All security controls implemented, pen-tested, CISO-approved |
| **Conformant** | All mandatory controls present; some recommended not yet implemented |
| **Compliant** | Meets minimum security requirements |
| **Non-Conformant** | Has unresolved critical vulnerabilities or missing mandatory controls |

### Security Architecture Review Checklist

- [ ] Threat model completed (STRIDE or similar)
- [ ] OWASP Top 10 addressed for each application
- [ ] Authentication mechanism: MFA enforced for privileged access
- [ ] Authorization: least privilege, no standing admin accounts
- [ ] Data classified and encryption applied per classification
- [ ] Secrets management: no hardcoded credentials
- [ ] Logging: sufficient audit trail for incident investigation
- [ ] Network: segmentation reviewed; no unnecessary open ports
- [ ] Dependencies: vulnerability scan clean (no Critical/High unaddressed)
- [ ] CISO sign-off obtained

---

## Key Exam Points

- Security is cross-cutting — it applies to ALL 4 BDAT domains in TOGAF 10
- Zero Trust replaces perimeter-based "castle and moat" security thinking
- STRIDE = 6 threat categories used in threat modeling (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege)
- Security Architecture is a TOGAF 10 Series Guide — not just in Phase D (Technology)
- CISO should be a stakeholder from Phase A — not introduced late
- Security Building Blocks are ABBs (what is needed) and SBBs (specific products)
- Defense in Depth = 6 layers from Perimeter to Identity
- NIST SP 800-207 is the normative reference for Zero Trust Architecture
- Threat modeling (STRIDE) occurs in Phase C (Application Architecture) for each application in scope
- Security Compliance levels align with TOGAF Architecture Compliance categories (Fully Conformant → Non-Conformant)
