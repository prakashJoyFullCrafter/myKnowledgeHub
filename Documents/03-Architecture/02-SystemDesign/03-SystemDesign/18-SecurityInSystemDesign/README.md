# Security in System Design - Curriculum

How to design secure systems from the architecture level — authentication, authorization, encryption, and threat mitigation as design decisions.

> Implementation details (Spring Security, OAuth code, pen testing) are in other sections. This module is about **security as architecture**.

---

## Module 1: Authentication Architecture
- [ ] **AuthN vs AuthZ**: who are you (authentication) vs what can you do (authorization)
- [ ] **Session-based auth**: server stores session, client sends cookie
  - [ ] Sticky sessions or shared session store (Redis)
  - [ ] Pros: simple revocation; Cons: stateful, scaling challenges
- [ ] **Token-based auth (JWT)**: stateless, client sends token in header
  - [ ] JWT structure: header.payload.signature
  - [ ] Pros: stateless, microservice-friendly; Cons: can't revoke easily, token size
  - [ ] Short-lived access token + long-lived refresh token pattern
- [ ] **Design decision**: where does auth happen?
  - [ ] API Gateway (centralized) vs each service (decentralized) vs service mesh (sidecar)
  - [ ] Gateway auth: simpler, single enforcement point, but gateway becomes bottleneck
  - [ ] Per-service auth: independent, but duplicated logic
- [ ] **Single Sign-On (SSO)**: one login for multiple services (enterprise pattern)

## Module 2: OAuth 2.0 & OIDC in Architecture
- [ ] **OAuth 2.0**: authorization framework — delegate access without sharing credentials
  - [ ] Authorization Code + PKCE: standard for web/mobile apps
  - [ ] Client Credentials: service-to-service (no user involved)
  - [ ] Resource Owner Password: legacy, avoid in new designs
- [ ] **OpenID Connect (OIDC)**: identity layer on top of OAuth — adds ID token (who the user is)
- [ ] **Architecture components**:
  - [ ] Identity Provider (IdP): Keycloak, Auth0, Okta, AWS Cognito
  - [ ] Resource Server: validates access tokens
  - [ ] Token introspection vs local JWT validation (network call vs CPU)
- [ ] **Token exchange**: service A calls service B on behalf of user (token relay, token exchange RFC)
- [ ] **API key vs OAuth**: API keys for server-to-server, OAuth for user-delegated access

## Module 3: Encryption & Data Protection
- [ ] **Encryption in transit**: TLS everywhere — no exceptions
  - [ ] TLS termination: at load balancer, at API gateway, or end-to-end
  - [ ] **mTLS (mutual TLS)**: both client and server present certificates
  - [ ] mTLS in microservices: service mesh handles automatically (Istio, Linkerd)
- [ ] **Encryption at rest**: encrypt stored data
  - [ ] Database-level encryption (PostgreSQL pgcrypto, RDS encryption)
  - [ ] Application-level encryption: encrypt before storing (field-level for PII)
  - [ ] Object storage encryption: SSE-S3, SSE-KMS, client-side
- [ ] **Key management**:
  - [ ] AWS KMS, GCP Cloud KMS, HashiCorp Vault
  - [ ] Key rotation: automatic rotation schedules
  - [ ] Envelope encryption: data key encrypts data, master key encrypts data key
- [ ] **Design decision**: what level of encryption does your system need? (compliance-driven)

## Module 4: Secrets Management
- [ ] **Secrets**: API keys, database passwords, certificates, tokens
- [ ] **Never** hardcode secrets, commit to git, or pass in environment variables at build time
- [ ] **Secrets management systems**:
  - [ ] HashiCorp Vault: dynamic secrets, leasing, rotation, audit
  - [ ] AWS Secrets Manager: auto-rotation, RDS integration
  - [ ] Kubernetes: Sealed Secrets, External Secrets Operator
- [ ] **Dynamic secrets**: Vault generates short-lived DB credentials per request
- [ ] **Secret rotation**: automated, zero-downtime rotation
- [ ] **Audit trail**: log every secret access — who accessed what, when
- [ ] Design decision: centralized vault vs cloud-native secrets vs sidecar injection

## Module 5: Rate Limiting & Abuse Prevention
- [ ] **Rate limiting** as a system design component:
  - [ ] Where: API gateway, load balancer, per-service, or all layers
  - [ ] Algorithms: token bucket, sliding window, fixed window, leaky bucket
  - [ ] Distributed rate limiting: Redis-based counters across instances
- [ ] **Abuse prevention**:
  - [ ] Bot detection: CAPTCHA, device fingerprinting, behavioral analysis
  - [ ] Account takeover protection: brute force detection, credential stuffing defense
  - [ ] Enumeration attacks: don't reveal whether user/resource exists
- [ ] **DDoS mitigation**:
  - [ ] CDN absorption (Cloudflare, CloudFront)
  - [ ] WAF (Web Application Firewall): block known attack patterns
  - [ ] Auto-scaling + rate limiting as last resort
- [ ] **API throttling**: per-client rate limits, tiered limits (free vs paid)
- [ ] HTTP 429 Too Many Requests + `Retry-After` header

## Module 6: Multi-Tenant Security & Isolation
- [ ] **Multi-tenancy models**:
  - [ ] Shared everything: same DB, same schema, tenant_id column
  - [ ] Shared DB, separate schema: one schema per tenant
  - [ ] Separate DB per tenant: strongest isolation, highest cost
- [ ] **Data isolation**: every query MUST filter by tenant_id — enforce at ORM/framework level
- [ ] **Row-Level Security (RLS)**: PostgreSQL RLS policies enforce isolation at DB level
- [ ] **Noisy neighbor**: one tenant's load affecting others
  - [ ] Solutions: per-tenant rate limits, resource quotas, separate compute for large tenants
- [ ] **Tenant-aware auth**: tokens carry tenant context, validate tenant access on every request
- [ ] **Compliance**: some tenants require data residency (EU data stays in EU)
- [ ] Design decision: isolation level depends on compliance needs, tenant size, cost tolerance

## Module 7: Audit Logging & Compliance
- [ ] **Audit logging**: immutable log of who did what, when, to which resource
  - [ ] Separate from application logs — audit logs are a compliance requirement
  - [ ] What to log: auth events, data access, data changes, admin actions, API calls
  - [ ] What NOT to log: passwords, full credit card numbers, PII in plain text
- [ ] **Immutability**: write-once storage (S3 Object Lock, append-only DB)
- [ ] **Compliance basics**:
  - [ ] GDPR: right to deletion, data portability, consent tracking, breach notification
  - [ ] PCI DSS: cardholder data protection, network segmentation, key management
  - [ ] SOC 2: security controls audit for SaaS providers
  - [ ] HIPAA: health data protection, encryption requirements
- [ ] **Zero Trust Architecture**: never trust, always verify — even inside the network
  - [ ] Verify identity, validate device, enforce least privilege, assume breach
- [ ] Design decision: compliance requirements should be gathered in requirements phase

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design auth architecture for a microservices e-commerce system — where does auth live? |
| Module 2 | Draw OAuth 2.0 flow for: mobile app → API gateway → 3 backend services |
| Module 3 | Design encryption strategy for a healthcare app (HIPAA) — transit, rest, field-level |
| Module 4 | Design secrets management for a K8s-deployed system with 10 services and 3 databases |
| Module 5 | Design rate limiting for a public API with free/paid tiers |
| Module 6 | Design multi-tenant SaaS — choose isolation model, justify trade-offs |
| Module 7 | Define audit logging strategy for a fintech system — what to log, where to store, retention |

## Key Resources
- **OWASP Top 10** (owasp.org)
- **Zero Trust Architecture** - NIST SP 800-207
- OAuth 2.0 specification (RFC 6749) and OIDC spec
- AWS Well-Architected Framework - Security pillar
- "How Netflix Handles Authentication" - Netflix Tech Blog
