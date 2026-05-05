# Non-Functional Requirements (NFRs) — Curriculum

How to identify, write, design for, test, and document the **quality attributes** of a system. NFRs describe *how well* the system works, in contrast to Functional Requirements which describe *what* it does.

> This module is the **index** for NFR knowledge across the repo. Detailed implementation lives in domain-specific folders (System Design, Microservice Patterns, SRE, Auth, etc.) — links provided per topic. Use this README as your map.

---

## Audience

- Software engineers writing architecture documents
- Solution architects defining quality attributes
- Tech leads negotiating SLAs with stakeholders
- Healthcare / ERP / SaaS designers handling compliance and multi-tenancy

---

## Functional vs Non-Functional

| Type | Question | Example |
|------|----------|---------|
| Functional | What does the system do? | "User can book an appointment" |
| Non-Functional | How well does it do it? | "Booking completes in < 2s for 95% of requests under 500 concurrent users" |

A weak NFR ("the system should be fast") is just an aspiration. A good NFR is **measurable, conditional, and testable**.

```text
The [system/API/page] must [quality target] within [measurement] under [condition].
```

---

## Module 1: Foundation of Requirements
- [ ] What is a requirement? — descriptive vs prescriptive
- [ ] Business / Functional / Non-Functional / Technical / Compliance requirements
- [ ] Where NFRs come from: stakeholders, regulation, SLAs, ops feedback
- [ ] NFRs as drivers of architecture decisions
- [ ] **Practice**: write FR + NFR pairs for: login, patient registration, invoice generation, report download

> See also: [TOGAF ADM Phase A — Architecture Vision](../../01-TOGAF/) and [Stakeholder Management](../04-StakeholderManagement/)

---

## Module 2: Core NFR Categories
- [ ] **Performance** — how fast (latency, throughput)
- [ ] **Scalability** — handles growth (vertical, horizontal, elastic)
- [ ] **Availability** — % uptime
- [ ] **Reliability** — works correctly and consistently
- [ ] **Security** — protects data and access
- [ ] **Maintainability** — easy to modify
- [ ] **Usability** — easy to use
- [ ] **Compatibility** — runs across browsers/OS/devices
- [ ] **Observability** — easy to monitor and debug
- [ ] **Compliance** — follows regulations
- [ ] **Backup & Recovery** — data is protected and restorable
- [ ] **Disaster Recovery** — recovers after major failure

---

## Module 3: Writing Measurable NFRs (SLA / SLO / SLI / RTO / RPO)
- [ ] **SLI** (Service Level Indicator) — what you measure (availability, latency, error rate)
- [ ] **SLO** (Service Level Objective) — internal target (99.9% over 30 days)
- [ ] **SLA** (Service Level Agreement) — contractual promise (refunds if breached)
- [ ] Hierarchy: SLI ⊂ SLO ⊂ SLA (SLO stricter than SLA for buffer)
- [ ] **Error budget** = 100% − SLO. Burn rate alerts.
- [ ] **RTO** (Recovery Time Objective) — how fast must recovery be?
- [ ] **RPO** (Recovery Point Objective) — how much data loss is acceptable?
- [ ] **Practice**: rewrite weak NFRs ("the system should be fast/secure") as measurable targets

> Deep-dive: [SRE & Reliability — SLI/SLO/SLA](../../../../06-DevOpsAndDelivery/01-DevOps/05-SRE&Reliability/) (Modules 2–3) and [Observability & Operations — SLO design](../../../02-SystemDesign/03-SystemDesign/17-Observability&Operations/) (Module 2)

---

## Module 4: Performance
- [ ] Response time, latency, throughput, TPS
- [ ] Percentiles: p50, p95, p99 (and why averages lie)
- [ ] CPU, memory, query time, GC pauses
- [ ] **Four Golden Signals**: Latency, Traffic, Errors, Saturation
- [ ] **RED method** for services: Rate, Errors, Duration
- [ ] **USE method** for resources: Utilization, Saturation, Errors
- [ ] Tools: JMeter, Gatling, k6, Prometheus, Grafana

> Deep-dive: [Performance Testing](../../../../06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/01-Testing/05-PerformanceTesting/) · [Frontend Web Vitals](../../../../04-Frontend&Fullstack/05-Performance&WebVitals/) · [Caching](../../../02-SystemDesign/03-SystemDesign/06-Caching/) · [CDN](../../../02-SystemDesign/03-SystemDesign/04-CDN/)

---

## Module 5: Scalability
- [ ] **Vertical** scaling — bigger box (limit: hardware ceiling)
- [ ] **Horizontal** scaling — more boxes (limit: state, coordination)
- [ ] Stateless services scale horizontally; state goes in DB/cache/queue
- [ ] Database scaling: read replicas, partitioning, sharding
- [ ] Queue/worker scaling: Kafka consumer groups, RabbitMQ competing consumers
- [ ] Autoscaling triggers: CPU, RPS, queue depth, custom metrics (HPA, KEDA)
- [ ] **Practice**: design scalability for a SaaS with 100 tenants × 10K users × 1M patients

> Deep-dive: [Load Balancing](../../../02-SystemDesign/03-SystemDesign/02-LoadBalancing/) · [Sharding](../../../02-SystemDesign/03-SystemDesign/03-Sharding/) · [Consistent Hashing](../../../02-SystemDesign/03-SystemDesign/05-ConsistentHashing/) · [Database Replication](../../../02-SystemDesign/03-SystemDesign/07-DatabaseReplication/) · [API Gateway](../../../01-MicroservicePatterns/01-CorePatterns/01-APIGateway/) · [Service Mesh](../../../01-MicroservicePatterns/01-CorePatterns/02-ServiceMesh/)

---

## Module 6: Availability & Reliability
- [ ] Availability table: 99% (7.2h/mo), 99.9% (43m/mo), 99.99% (4.3m/mo)
- [ ] Reliability ≠ availability — a system can be available but wrong
- [ ] Failure modes: partial, cascading, metastable, gray failures
- [ ] Defense stack: timeout + retry + backoff + jitter + circuit breaker + bulkhead + load shed
- [ ] Graceful degradation: read-only mode, cached fallbacks, feature flags off
- [ ] Failover: active-passive, active-active, DNS, DB promotion, split-brain prevention

> Deep-dive: [Reliability & Resilience (System Design)](../../../02-SystemDesign/03-SystemDesign/16-Reliability&Resilience/) · [Microservice Resilience Patterns](../../../01-MicroservicePatterns/02-Resilience/) (CircuitBreaker, Retry&Backoff, Bulkhead, RateLimiting, Idempotency, DistributedLock, Backpressure) · [SRE Reliability Patterns](../../../../06-DevOpsAndDelivery/01-DevOps/05-SRE&Reliability/) (Module 8)

---

## Module 7: Security
- [ ] Authentication architecture (session vs JWT; gateway vs per-service vs sidecar)
- [ ] OAuth 2.0 / OIDC / SSO / MFA
- [ ] Authorization: RBAC, ABAC, tenant-aware checks
- [ ] Encryption: TLS in transit, at-rest, mTLS, field-level for PII
- [ ] Secrets management: Vault, AWS Secrets Manager, dynamic secrets, rotation
- [ ] Rate limiting, abuse prevention, WAF, DDoS mitigation
- [ ] Audit logging: immutable, separate from app logs

> Deep-dive: [Security in System Design](../../../02-SystemDesign/03-SystemDesign/18-SecurityInSystemDesign/) (7 modules) · [Auth (Frontend)](../../../../04-Frontend&Fullstack/08-Auth/) (NextAuth, JWT, OAuth/OIDC, RBAC) · [Cloud Native Security](../../../../06-DevOpsAndDelivery/01-DevOps/06-CloudNativeSecurity/) · [OWASP Top 10](../../../../05-ComputerScience&Security/02-EthicalHacking/01-Foundations/03-OWASPTop10/) · [Cryptography](../../../../05-ComputerScience&Security/02-EthicalHacking/01-Foundations/04-Cryptography/) · [Secrets Management (CI/CD)](../../../../06-DevOpsAndDelivery/01-DevOps/01-CI&CD/06-SecretsManagement/)

---

## Module 8: Maintainability & Modifiability
- [ ] Modular architecture, clear bounded contexts
- [ ] **SOLID**, **DRY**, **KISS**, **YAGNI**
- [ ] Clean Architecture, Hexagonal/Ports & Adapters
- [ ] API versioning (URI, header, content negotiation)
- [ ] DB migrations: Flyway, Liquibase
- [ ] Code review, automated testing, refactoring discipline
- [ ] Service ownership and code ownership

> Deep-dive: [Design Principles](../../../02-SystemDesign/01-DesignPrinciples/) (SOLID, DRY-KISS-YAGNI, 12-Factor, Hexagonal) · [Architecture Patterns](../../../02-SystemDesign/04-ArchitecturePatterns/) (Clean, Hexagonal) · [Domain-Driven Design](../../../04-DomainDrivenDesign/) · [Quality Practices](../../../../06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/02-QualityPractices/) (CleanCode, TDD, BDD, Refactoring) · [Versioning Standards](../../../../06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/04-EngineeringGovernance/01-Versioning/)

---

## Module 9: Usability & Accessibility *(curriculum gap — to be expanded)*
- [ ] Task efficiency: time-to-complete for primary flows
- [ ] Step minimization (e.g., booking ≤ 3 steps)
- [ ] Error messages: clear, actionable, recovery-oriented
- [ ] Mobile responsiveness, viewport breakpoints
- [ ] Keyboard navigation and focus management
- [ ] **Accessibility**: WCAG 2.1 AA, screen readers, color contrast, ARIA
- [ ] Internationalization (i18n) and localization (l10n)

> Partial coverage: [Core Web Vitals](../../../../04-Frontend&Fullstack/05-Performance&WebVitals/01-CoreWebVitals/) (LCP, INP, CLS) · [Design Systems](../../../../04-Frontend&Fullstack/09-FrontendArchitecture/04-DesignSystems/)
> **Gap**: no dedicated WCAG / accessibility curriculum — recommend new folder under `04-Frontend&Fullstack`.

---

## Module 10: Compatibility & Portability
- [ ] Browser matrix (Chrome, Firefox, Edge, Safari — latest N versions)
- [ ] OS compatibility (Linux, macOS, Windows)
- [ ] API compatibility: JSON over HTTPS, OpenAPI contracts, semantic versioning
- [ ] Container portability: 12-factor, OCI images, no host-coupling
- [ ] Healthcare integration: HL7 v2, FHIR, USCDI

> Deep-dive: [Containers & Orchestration](../../../../06-DevOpsAndDelivery/01-DevOps/02-ContainersAndOrchestration/) · [12-Factor App](../../../02-SystemDesign/01-DesignPrinciples/03-12FactorApp/) · [API Design](../../../02-SystemDesign/03-SystemDesign/26-APIDesign/) · [Healthcare Integration Architect](../../../../08-Domain/01-healthcare/IntegrationArchitect/) (HL7, FHIR, USCDI)

---

## Module 11: Observability
- [ ] **Three pillars**: metrics, logs, traces
- [ ] Structured logging with correlation/trace IDs
- [ ] Distributed tracing (W3C Trace Context, OpenTelemetry)
- [ ] Dashboard hierarchy: L0 business → L1 service → L2 deep-dive → L3 infra
- [ ] Alerting: symptoms not causes, multi-window burn rate, runbook links
- [ ] Incident response: detect → triage → mitigate → resolve → postmortem

> Deep-dive: [Observability & Operations (System Design)](../../../02-SystemDesign/03-SystemDesign/17-Observability&Operations/) (7 modules) · [DevOps Observability](../../../../06-DevOpsAndDelivery/01-DevOps/04-Observability/) (Prometheus, Grafana, ELK, Jaeger, OpenTelemetry, eBPF) · [Observability Standards (Platform)](../../../../06-DevOpsAndDelivery/01-DevOps/07-PlatformEngineering/05-ObservabilityStandards/)

---

## Module 12: Backup, Recovery & Disaster Recovery
- [ ] Backup strategy: full / incremental / differential, encrypted, offsite
- [ ] Point-in-time recovery (PITR) for transactional databases
- [ ] **RTO** and **RPO** targets per data class
- [ ] DR strategies (cost vs speed): backup-restore → pilot light → warm standby → multi-site active-active
- [ ] Restore drills — untested backups don't exist
- [ ] Multi-region geo-distribution and failover

> Deep-dive: [Reliability & Resilience — DR module](../../../02-SystemDesign/03-SystemDesign/16-Reliability&Resilience/) (Module 6) · [Multi-Region & Geo-Distribution](../../../02-SystemDesign/03-SystemDesign/25-MultiRegion&GeoDistribution/) · [Kafka Multi-DC & DR](../../../../02-Messaging&EventStreaming/01-ApacheKafka/08-MultiDC&DisasterRecovery/) · [RabbitMQ Federation & Multi-DC](../../../../02-Messaging&EventStreaming/02-RabbitMQ/09-Federation&MultiDC/)

---

## Module 13: Compliance *(curriculum gap — to be expanded)*
- [ ] **HIPAA** — health data: encryption, audit, access control, breach notification
- [ ] **GDPR** — right to deletion, portability, consent, DPO, breach notification
- [ ] **PCI DSS** — cardholder data, network segmentation, key management
- [ ] **SOC 2** — security controls audit (Trust Services Criteria)
- [ ] Regional regulations: UAE healthcare, India DPDP, etc.
- [ ] Data retention, masking, consent management
- [ ] Audit logging as a compliance artifact (not just app log)
- [ ] Data residency and cross-border transfer

> Partial coverage: [Security in System Design — Audit & Compliance](../../../02-SystemDesign/03-SystemDesign/18-SecurityInSystemDesign/) (Module 7) · [Security Standards (Governance)](../../../../06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/04-EngineeringGovernance/04-SecurityStandards/) · [Healthcare Regulatory Compliance](../../../../08-Domain/01-healthcare/Domainmastery/)
> **Gap**: no dedicated compliance curriculum with regulation-by-regulation control mapping.

---

## Module 14: Multi-Tenant SaaS NFRs *(curriculum gap — to be expanded)*
- [ ] **Tier 1**: shared DB, shared schema, `tenant_id` column (cheapest, weakest isolation)
- [ ] **Tier 2**: shared DB, dedicated schema (stronger isolation, more ops)
- [ ] **Tier 3**: dedicated DB per tenant (strong isolation, highest cost)
- [ ] **Tier 4**: on-premises / single-tenant deployment
- [ ] Tenant resolution: subdomain, JWT claim, header — validate all three on every request
- [ ] Dynamic datasource / schema routing
- [ ] Row-Level Security (RLS) in PostgreSQL
- [ ] Noisy neighbor: per-tenant rate limits, resource quotas
- [ ] Tenant-specific config: email/SMS provider, branding, feature flags
- [ ] Tenant onboarding SLA (e.g., < 5 min after subscription)
- [ ] Per-tenant backup, restore, and data export

> Partial coverage: [Security in System Design — Multi-Tenant Isolation](../../../02-SystemDesign/03-SystemDesign/18-SecurityInSystemDesign/) (Module 6) · [RBAC & Authorization](../../../../04-Frontend&Fullstack/08-Auth/04-RBAC&Authorization/)
> **Gap**: no dedicated multi-tenancy curriculum with tier-based design and routing patterns. Recommend new module under `01-MicroservicePatterns/04-MultiTenancy/`.

---

## Module 15: Architecture Trade-Offs from NFRs
- [ ] NFRs **drive** architecture, not the other way around
- [ ] Common trade-offs:
  - [ ] Consistency vs Availability (CAP)
  - [ ] Latency vs Durability (sync vs async writes)
  - [ ] Simplicity vs Flexibility
  - [ ] Cost vs Resilience (active-active is expensive)
- [ ] **ATAM** (Architecture Trade-off Analysis Method)
- [ ] Sensitivity points and trade-off points
- [ ] Decision matrices, ADRs (Architecture Decision Records)
- [ ] Mapping NFR → architecture decision (e.g., "100K msgs/hr" → Kafka + workers + DLQ + retry)

> Deep-dive: [Trade-Off Analysis](../01-TradeOffAnalysis/) · [ATAM](../../03-ProblemSolving/04-ATAM/) · [Decision Frameworks](../../03-ProblemSolving/02-DecisionFrameworks/) · [CAP Theorem](../../../02-SystemDesign/03-SystemDesign/01-CAPTheorem/)

---

## Module 16: Testing NFRs
| NFR | Test type | Tools |
|-----|-----------|-------|
| Performance | Load, stress, soak, spike | JMeter, Gatling, k6, Locust |
| Scalability | Stress + autoscaling validation | k6, Gatling |
| Reliability | Chaos engineering | Chaos Mesh, Litmus, Gremlin, AWS FIS, Toxiproxy |
| Availability | Failover testing, game days | Manual + chaos tools |
| Security | SAST, DAST, pen test | OWASP ZAP, Burp Suite, Snyk, Trivy, SonarQube |
| Compatibility | Browser/device matrix | Playwright, BrowserStack |
| Backup | Restore drills | Custom scripts + scheduled tests |
| Observability | Log/metric/trace assertions | Synthetic monitoring, Prometheus alert tests |

> Deep-dive: [Performance Testing](../../../../06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/01-Testing/05-PerformanceTesting/) · [Chaos Engineering (System Design)](../../../02-SystemDesign/03-SystemDesign/16-Reliability&Resilience/) (Module 7) · [Chaos Engineering (SRE)](../../../../06-DevOpsAndDelivery/01-DevOps/05-SRE&Reliability/) (Module 7) · [Ethical Hacking & Pen Testing](../../../../05-ComputerScience&Security/02-EthicalHacking/) · [Frontend Testing](../../../../04-Frontend&Fullstack/06-Testing/)

---

## Module 17: Documenting NFRs
- [ ] NFR catalog format with stable IDs (e.g., `NFR-PERF-001`)
- [ ] Required fields: ID, category, description, measurement, target, condition, priority, owner, validation method, status
- [ ] **Architecture Decision Records (ADRs)** capture trade-off rationale
- [ ] Track NFR status: Draft → Approved → Implemented → Validated
- [ ] Treat NFRs as living documents — review per release

### Suggested NFR Document Format

| Field | Description |
|-------|-------------|
| Requirement ID | `NFR-{CATEGORY}-{NNN}` |
| Category | Performance, Security, Availability, etc. |
| Description | What is required |
| Measurement | How it is measured (metric + tool) |
| Target Value | Numeric target (e.g., p95 < 200ms) |
| Condition | Under what load / scenario |
| Priority | High / Medium / Low |
| Owner | Team responsible |
| Validation Method | How it is tested |
| Status | Draft / Approved / Implemented / Validated |

### Example

```text
ID:           NFR-PERF-001
Category:     Performance
Description:  Patient search API must return results quickly
Measurement:  Response time (p95) via k6
Target:       < 2 seconds
Condition:    Under 500 concurrent users, dataset of 1M patients
Priority:     High
Owner:        Patient Platform team
Validation:   k6 load test in staging, Prometheus SLO in prod
Status:       Approved
```

> Deep-dive: [Architecture Documentation](../03-ArchitectureDocumentation/) · [Decision Frameworks (ADRs)](../../03-ProblemSolving/02-DecisionFrameworks/)

---

## Module 18: Case Study — Multi-Tenant Healthcare SaaS
Design end-to-end NFRs for a SaaS healthcare platform with these modules:

```text
Tenant management · Identity/RBAC · Patient registration · Appointment ·
Encounter · Billing · Inventory · Notification · Reporting · Audit logging
```

For **each module**, define:
- [ ] Performance NFR (latency, throughput)
- [ ] Scalability NFR (load profile, growth assumptions)
- [ ] Availability NFR (SLO, error budget)
- [ ] Security NFR (auth, encryption, tenant isolation)
- [ ] Observability NFR (SLIs, alerts, dashboards)
- [ ] Backup/Recovery NFR (RTO, RPO)
- [ ] Compliance NFR (HIPAA / GDPR / regional)

### Deliverables
1. NFR catalog (CSV/Markdown table)
2. Performance targets per critical journey
3. Security requirements + threat model
4. Availability targets + error budgets
5. Backup & DR plan with RTO/RPO per data class
6. Observability plan: SLIs, SLOs, dashboards, alert routing
7. Multi-tenant isolation architecture
8. Test plan mapping each NFR to validation approach

---

## 4-Week Study Plan

| Week | Focus | Modules |
|------|-------|---------|
| **1** | Basics | FR vs NFR · NFR categories · Measurable NFRs · Performance · Scalability · Availability/Reliability |
| **2** | Enterprise quality attributes | Security · Maintainability · Usability · Compatibility · Observability · Backup/DR |
| **3** | SaaS & healthcare | Compliance · Multi-tenancy · Tenant isolation · SaaS tiers · Trade-offs |
| **4** | Testing & documentation | Perf testing · Security testing · DR drills · NFR docs · Case study · Final review |

---

## Final Checklist

You understand NFRs well when you can answer:

- [ ] Difference between FR and NFR — and why both matter
- [ ] How to write a measurable NFR (formula, anti-patterns)
- [ ] Difference between availability and reliability
- [ ] Difference between SLA, SLO, SLI — and how error budgets work
- [ ] What RTO and RPO mean — and how they drive DR strategy choice
- [ ] How NFRs drive architecture (give 3 examples)
- [ ] How to test performance, security, and reliability NFRs
- [ ] How to design NFRs for a multi-tenant SaaS
- [ ] How to document NFRs with stable IDs and ADRs
- [ ] How to monitor NFRs in production (SLOs, burn-rate alerts)

---

## Coverage Map (this repo)

| NFR Domain | Primary location |
|------------|------------------|
| Performance | `06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/01-Testing/05-PerformanceTesting/` · `04-Frontend&Fullstack/05-Performance&WebVitals/` |
| Scalability | `03-Architecture/02-SystemDesign/03-SystemDesign/` (LoadBalancing, Sharding, Caching) |
| Reliability | `03-Architecture/02-SystemDesign/03-SystemDesign/16-Reliability&Resilience/` · `03-Architecture/01-MicroservicePatterns/02-Resilience/` |
| Availability / SRE | `06-DevOpsAndDelivery/01-DevOps/05-SRE&Reliability/` |
| Security | `03-Architecture/02-SystemDesign/03-SystemDesign/18-SecurityInSystemDesign/` · `04-Frontend&Fullstack/08-Auth/` · `06-DevOpsAndDelivery/01-DevOps/06-CloudNativeSecurity/` |
| Observability | `03-Architecture/02-SystemDesign/03-SystemDesign/17-Observability&Operations/` · `06-DevOpsAndDelivery/01-DevOps/04-Observability/` |
| Maintainability | `03-Architecture/02-SystemDesign/01-DesignPrinciples/` · `06-DevOpsAndDelivery/02-CodeQuality&VibeCoding/02-QualityPractices/` |
| Trade-off analysis | `03-Architecture/03-EnterpriseArchitecture/02-SolutionArchitecture/01-TradeOffAnalysis/` · `…/03-ProblemSolving/04-ATAM/` |
| Backup / DR | `…/16-Reliability&Resilience/` (Module 6) · `…/25-MultiRegion&GeoDistribution/` |
| Compliance | `…/18-SecurityInSystemDesign/` (Module 7) · `08-Domain/01-healthcare/Domainmastery/` ⚠️ *gap* |
| Multi-tenancy | `…/18-SecurityInSystemDesign/` (Module 6) ⚠️ *gap* |
| Usability / a11y | `04-Frontend&Fullstack/05-Performance&WebVitals/01-CoreWebVitals/` ⚠️ *gap* |

⚠️ = needs a dedicated curriculum module; this README is the index until that lands.

---

## Key Resources

- **Site Reliability Engineering** — Google (free at sre.google/books)
- **The Site Reliability Workbook** — Google
- **Release It!** — Michael Nygard
- **Designing Data-Intensive Applications** — Martin Kleppmann
- **Software Architecture in Practice** — Bass, Clements, Kazman (ATAM source)
- **AWS Well-Architected Framework** — all six pillars
- **NIST SP 800-207** — Zero Trust Architecture
- **OWASP Top 10** — owasp.org
