# TOGAF 10 — Practical Artifacts & Templates

> Real, usable templates for all major TOGAF architecture deliverables.
> Each template includes: Purpose, When to use, Structure, and a partially-filled example.

---

## Table of Contents

1. [Architecture Vision Document (Phase A)](#1-architecture-vision-document-phase-a)
2. [Statement of Architecture Work (Phase A)](#2-statement-of-architecture-work-phase-a)
3. [Architecture Definition Document (ADD)](#3-architecture-definition-document-add)
4. [Architecture Requirements Specification (ARS)](#4-architecture-requirements-specification-ars)
5. [Gap Analysis Table](#5-gap-analysis-table)
6. [Stakeholder Map / Matrix](#6-stakeholder-map--matrix)
7. [Architecture Principles Catalog](#7-architecture-principles-catalog)
8. [Architecture Decision Record (ADR)](#8-architecture-decision-record-adr)
9. [Architecture Roadmap](#9-architecture-roadmap)
10. [Capability Assessment Heat Map](#10-capability-assessment-heat-map)
11. [Architecture Contract](#11-architecture-contract)

---

## 1. Architecture Vision Document (Phase A)

**Purpose:** Describes the desired outcome of the architecture engagement; secures stakeholder buy-in before detailed work begins. It communicates the "why" and "what" at executive level — not the technical detail.

**When to use:** Output of Phase A; presented to Architecture Board for approval before any architecture domain work (Phases B–D) begins. Without an approved Architecture Vision, you have no mandate to proceed.

**Key inputs:** Business strategy documents, existing architecture repository, stakeholder interviews, relevant Architecture Principles.

**Key outputs:** Approved Architecture Vision, updated Stakeholder Map, refined Statement of Architecture Work.

---

### Template

```
ARCHITECTURE VISION
═══════════════════════════════════════════════════════════════

Project:        [Name of the architecture engagement]
Reference:      ARCH-VISION-[YYYY]-[NNN]
Version:        1.0
Date:           [YYYY-MM-DD]
Status:         Draft | Under Review | Approved
Author:         [Lead Architect Name]
Owner:          [Architecture Board / Sponsor]

───────────────────────────────────────────────────────────────
1. PROBLEM DESCRIPTION
───────────────────────────────────────────────────────────────

Business challenge:
  [What specific problem are we solving? Use data where possible.
   E.g., "73% of customers use mobile but app NPS is -12 due to
   slow performance and missing features."]

Impact of not solving:
  [Risk / cost / competitive impact of inaction.
   E.g., "Projected 15% customer attrition to digital-native
   competitors within 24 months. Estimated revenue loss: $4.2M/yr."]

───────────────────────────────────────────────────────────────
2. BUSINESS GOALS AND DRIVERS
───────────────────────────────────────────────────────────────

Goal 1: [Strategic goal — must be specific and measurable]
Goal 2: [...]
Goal 3: [...]

Strategic drivers:
  Driver 1: [e.g., Regulatory mandate — PSD2 Open Banking compliance by Q3]
  Driver 2: [e.g., Competitive pressure — 3 neo-bank competitors launched in 12 months]
  Driver 3: [e.g., Operational efficiency — reduce manual reconciliation cost by 40%]

───────────────────────────────────────────────────────────────
3. ARCHITECTURE SCOPE
───────────────────────────────────────────────────────────────

Time horizon:               [e.g., 18 months, FY2025–FY2026]
Business domains IN scope:  [e.g., Customer Experience, Product Management, Payments]
Business domains OUT of scope: [e.g., Back-office HR, ERP financials]
Geographies in scope:       [e.g., UAE, KSA; excludes rest of MENA in this phase]
ADM phases to execute:      [e.g., A, B, C, D, E, F — G and H ongoing governance]

───────────────────────────────────────────────────────────────
4. CONSTRAINTS AND ASSUMPTIONS
───────────────────────────────────────────────────────────────

Constraints (things we CANNOT change):
  C-001: Must integrate with existing SAP S/4HANA (ERP not in scope for replacement)
  C-002: Budget ceiling of AED 8M for this architecture engagement
  C-003: On-premise data residency required for customer PII (regulatory)
  C-004: Go-live must not coincide with Ramadan period

Assumptions (things we BELIEVE to be true — must be validated):
  A-001: Cloud-first strategy has board approval and is funded
  A-002: Existing development team of 45 engineers will be available
  A-003: API management platform (Apigee) licence will be renewed for 3 years
  A-004: Business stakeholders will commit 20% of time to architecture workshops

───────────────────────────────────────────────────────────────
5. STAKEHOLDERS
───────────────────────────────────────────────────────────────

Executive Sponsor:    [Name, Title, Contact]
Architecture Owner:   [Name, Title — typically CIO or Chief Architect]
Business Lead:        [Name, Title — typically Head of relevant business unit]

Key Stakeholder Summary:
  Name            | Role                | Key Concern                   | Engagement
  ────────────────|─────────────────────|───────────────────────────────|──────────────
  [Name]          | CEO / Sponsor       | ROI, competitive position     | Monthly brief
  [Name]          | CIO                 | Technical feasibility, cost   | Weekly update
  [Name]          | Head of Digital     | Customer experience, TTM      | Working group
  [Name]          | CISO                | Security compliance, risk     | Security review
  [Name]          | CFO                 | Budget, financial risk        | Monthly report

(Full stakeholder map: see Section 6 of this document or separate Stakeholder Matrix)

───────────────────────────────────────────────────────────────
6. HIGH-LEVEL TARGET ARCHITECTURE
───────────────────────────────────────────────────────────────

[2–3 paragraph narrative describing the future state. This is NOT
 a technical spec — it is an executive-readable description of
 what the architecture will look like when done and what it enables.]

Target state summary:
  [e.g., "The target architecture establishes a cloud-native, API-first
   platform on Azure, replacing the legacy monolithic banking core with
   a set of loosely coupled microservices. A unified event streaming
   backbone (Kafka) enables real-time data flows across domains. Customer
   experience is delivered through a modern mobile-first PWA, supported
   by an AI-powered personalization engine."]

───────────────────────────────────────────────────────────────
7. KEY CAPABILITY CHANGES
───────────────────────────────────────────────────────────────

Capability Domain   | Current State                     | Target State
────────────────────|───────────────────────────────────|─────────────────────────────
Customer Onboarding | Manual, paper-based, 3–5 days     | Digital, eKYC, < 10 minutes
Product Management  | Hard-coded, 6-week change cycle   | Config-driven, same-day change
Payments            | Batch overnight processing        | Real-time ISO 20022 rails
Analytics           | Monthly reports, BI team          | Self-serve, real-time dashboards
Integration         | Point-to-point SOAP, 47 interfaces| API gateway + event streaming

───────────────────────────────────────────────────────────────
8. RISKS
───────────────────────────────────────────────────────────────

Risk                          | Likelihood | Impact | Mitigation
──────────────────────────────|────────────|────────|─────────────────────────────────
Business change fatigue       | H          | H      | Phased rollout; change management plan
Key architect availability    | M          | H      | Identify backup resources; knowledge transfer
Legacy integration complexity | H          | M      | Technical spike in Phase B; contingency buffer
Regulatory approval delays    | M          | H      | Early engagement with regulator; legal review

───────────────────────────────────────────────────────────────
9. APPROVAL
───────────────────────────────────────────────────────────────

Presented to Architecture Board: [Date]
Approved by:
  [Name, Role, Signature, Date]
  [Name, Role, Signature, Date]

Next review date: [Date — typically at end of Phase B or major milestone]
```

---

### Example (Banking Digital Platform)

| Field | Value |
|---|---|
| Project | Digital Banking Platform Modernisation |
| Problem | 73% of customers use mobile but app NPS is -12 due to slow performance and missing features |
| Goal 1 | Achieve mobile NPS of +30 by Q4 2025 |
| Goal 2 | 40% of new product sales via digital channels by end of 2025 |
| Goal 3 | Reduce time-to-market for new products from 6 weeks to 3 days |
| Scope | Customer Experience, Product, Payments domains; 18-month horizon |
| Key constraint | SAP S/4HANA not in scope; data residency on-premise (CBUAE regulation) |
| Top risk | Legacy core banking integration complexity (Temenos T24, 15 years of customisation) |

---

## 2. Statement of Architecture Work (Phase A)

**Purpose:** Defines the scope, approach, deliverables, and acceptance criteria for an architecture engagement. This is the formal "contract to proceed" — it gives the architecture team its mandate and defines what done looks like.

**When to use:** Produced at the end of Phase A alongside the Architecture Vision. Must be approved before Phases B–D begin. Updated whenever scope changes materially.

**Relationship to Architecture Vision:** The Vision says "here is where we want to go." The Statement of Architecture Work says "here is how we will produce the architecture to get there, and by when."

---

### Template

```
STATEMENT OF ARCHITECTURE WORK
═══════════════════════════════════════════════════════════════

Reference:   SAW-[YYYY]-[NNN]
Date:        [YYYY-MM-DD]
Version:     1.0
Status:      Draft | Approved

Related Architecture Vision: ARCH-VISION-[YYYY]-[NNN]

───────────────────────────────────────────────────────────────
1. TITLE AND PROJECT DESCRIPTION
───────────────────────────────────────────────────────────────

Title: [Short descriptive name, e.g., "Digital Banking Platform Architecture — Phase 1"]

Description:
  [2–3 sentences: what is the architecture engagement, what business
   initiative does it support, and what is the overall goal?]

───────────────────────────────────────────────────────────────
2. ARCHITECTURE VISION SUMMARY
───────────────────────────────────────────────────────────────

(Reference to approved Architecture Vision document: ARCH-VISION-[YYYY]-[NNN])

Problem being solved:   [1 sentence summary]
Target outcome:         [1 sentence summary]
Business value:         [Quantified benefit or strategic objective]

───────────────────────────────────────────────────────────────
3. SCOPE OF ARCHITECTURE WORK
───────────────────────────────────────────────────────────────

Organizations impacted:       [Business units, geographies]
Time period covered:          [Start date to end date]

ADM phases to be executed:
  [ ] Phase A — Architecture Vision
  [ ] Phase B — Business Architecture
  [ ] Phase C — Information Systems Architecture
      [ ] Data Architecture
      [ ] Application Architecture
  [ ] Phase D — Technology Architecture
  [ ] Phase E — Opportunities and Solutions
  [ ] Phase F — Migration Planning
  [ ] Phase G — Implementation Governance
  [ ] Phase H — Architecture Change Management

Architecture domains in scope:
  [ ] Business Architecture
  [ ] Data Architecture
  [ ] Application Architecture
  [ ] Technology Architecture

───────────────────────────────────────────────────────────────
4. WORK PLAN
───────────────────────────────────────────────────────────────

Phase   | Start        | End          | Key Deliverables                          | Lead
────────|──────────────|──────────────|───────────────────────────────────────────|────────
A       | [Date]       | [Date]       | Architecture Vision, SAW                 | [Name]
B       | [Date]       | [Date]       | Business Capability Map, Process Models  | [Name]
C-Data  | [Date]       | [Date]       | Data Architecture ADD, Data Catalog       | [Name]
C-App   | [Date]       | [Date]       | Application Architecture ADD, App Map     | [Name]
D       | [Date]       | [Date]       | Technology Architecture ADD, SIB update   | [Name]
E       | [Date]       | [Date]       | Solutions Catalog, Work Packages          | [Name]
F       | [Date]       | [Date]       | Architecture Roadmap, Migration Plan      | [Name]

Architecture Board reviews: [Dates for each gate review]

───────────────────────────────────────────────────────────────
5. ACCEPTANCE CRITERIA
───────────────────────────────────────────────────────────────

Deliverable                      | Acceptance Criteria                              | Reviewer
─────────────────────────────────|──────────────────────────────────────────────────|──────────────
Architecture Vision              | Approved by Architecture Board                   | Arch Board
Business Architecture ADD        | Business Lead sign-off on capability model       | Head of Digital
Data Architecture ADD            | Data Governance team + CISO sign-off             | CDO, CISO
Application Architecture ADD     | CIO and Dev Lead review — no blocking issues     | CIO, Dev Lead
Technology Architecture ADD      | Infrastructure team review — compliant with SIB  | CTO, Platform
Architecture Roadmap             | CFO sign-off on financial model; Board approval  | Arch Board, CFO
Gap Analysis                     | All gaps categorised and work packages assigned  | Arch Board

───────────────────────────────────────────────────────────────
6. RESOURCE REQUIREMENTS
───────────────────────────────────────────────────────────────

Role                    | Name/Team         | Commitment       | Phase
────────────────────────|───────────────────|──────────────────|──────
Lead Enterprise Architect| [Name]           | 100% throughout  | A–F
Business Architect       | [Name]           | 80% Phases B, E  | B, E
Data Architect           | [Name]           | 80% Phase C      | C
Application Architect    | [Name]           | 80% Phases C, D  | C, D
Technology Architect     | [Name]           | 80% Phase D      | D
Business Analyst         | [Name/Team]      | 50% Phases B, C  | B, C
Security Architect       | [Name]           | 20% review gates | B–D

───────────────────────────────────────────────────────────────
7. BUDGET
───────────────────────────────────────────────────────────────

Architecture team cost:       [AED / USD X,XXX,XXX]
External consultancy:         [AED / USD X,XXX,XXX]
Tools and licenses:           [AED / USD XXX,XXX]
Total budget:                 [AED / USD X,XXX,XXX]
Budget owner:                 [Name, Title]

───────────────────────────────────────────────────────────────
8. CHANGE CONTROL PROCEDURE
───────────────────────────────────────────────────────────────

Minor changes (< 5% scope impact):   Lead Architect approval
Moderate changes (5–20% scope impact): Architecture Board notification + approval
Major changes (> 20% scope or budget): Full re-submission to Architecture Board + Sponsor

All changes tracked in Architecture Repository change log.

───────────────────────────────────────────────────────────────
9. SIGN-OFF
───────────────────────────────────────────────────────────────

Requestor (Business Sponsor): _________________ Date: ________
Lead Architect:                _________________ Date: ________
Architecture Board Chair:      _________________ Date: ________
```

---

## 3. Architecture Definition Document (ADD)

**Purpose:** Documents the Baseline (current state) and Target architectures for each domain; the main substantive output of Phases B, C, and D. One ADD per domain (Business, Data, Application, Technology) — or one combined ADD with domain sections.

**When to use:** Produced during Phases B, C, D. Updated iteratively. Reviewed at Architecture Board gates. The ADD is the primary reference document used by implementation teams.

**Relationship to other artifacts:** The ADD is informed by the Architecture Vision (goals) and Architecture Requirements Specification (measurable criteria). The Gap Analysis and Architecture Roadmap flow from it.

---

### Template Structure

```
ARCHITECTURE DEFINITION DOCUMENT
═══════════════════════════════════════════════════════════════

Document ID:    ADD-[DOMAIN]-[YYYY]-[NNN]
Version:        [x.x]
Date:           [YYYY-MM-DD]
Status:         Draft | Under Review | Approved
Domain:         Business | Data | Application | Technology
Related phases: B | C | D (circle applicable)
Author:         [Domain Architect name]
Approved by:    [Architecture Board, date]

Related documents:
  Architecture Vision:           ARCH-VISION-[YYYY]-[NNN]
  Statement of Architecture Work: SAW-[YYYY]-[NNN]
  Architecture Requirements Spec: ARS-[YYYY]-[NNN]

═══════════════════════════════════════════════════════════════
SECTION 1: BASELINE ARCHITECTURE (CURRENT STATE)
═══════════════════════════════════════════════════════════════

1.1 Business Context
  [Brief description of the business context and why this domain
   matters to the organisation. 1–2 paragraphs.]

1.2 Current Architecture Overview
  [Narrative description of the current state. Describe how things
   work today, not what you wish they were. Include key problems
   and pain points. Reference architecture diagrams here.]

  Diagram reference: [Baseline Architecture Diagram — Appendix A]

1.3 Baseline Catalog
  [List current components. For Business: capabilities/processes.
   For Data: data entities/stores. For Application: application
   components. For Technology: infrastructure components.]

  Component / Entity     | Version / State       | Owner         | Notes
  ───────────────────────|───────────────────────|───────────────|────────────
  [Component name]       | [e.g., v2.3, 2018]    | [Team/person] | [Pain points]
  [...]                  | [...]                 | [...]         | [...]

1.4 Known Issues and Pain Points
  Issue ID | Description                    | Business Impact        | Severity
  ─────────|────────────────────────────────|────────────────────────|──────────
  ISSUE-001 | [Clear problem statement]     | [Cost / risk / delay]  | High/Med/Low
  ISSUE-002 | [...]                         | [...]                  | [...]

═══════════════════════════════════════════════════════════════
SECTION 2: TARGET ARCHITECTURE
═══════════════════════════════════════════════════════════════

2.1 Architecture Goals (from Architecture Vision)
  [List the goals from the Architecture Vision that this domain
   architecture directly supports. Trace requirements to goals.]

  Goal | How this domain contributes
  ─────|────────────────────────────────────────────────
  [G1] | [Domain-specific contribution]
  [G2] | [...]

2.2 Target Architecture Overview
  [Narrative description of the target state. Describe what
   the architecture will look like and how it works.
   Reference target architecture diagrams here.]

  Diagram reference: [Target Architecture Diagram — Appendix B]

2.3 Architecture Principles Applied
  Principle ID | Principle Name      | How Applied in This Architecture
  ─────────────|─────────────────────|────────────────────────────────────────
  T01          | Cloud First         | [All new infrastructure on Azure; on-prem exception for PII data (regulatory)]
  T02          | API First           | [All domain services expose REST APIs before any UI built]
  T03          | Min Tech Diversity  | [Approved SIB technologies used; Kafka selected from approved list]

2.4 Target Catalog
  Component / Entity     | Description                   | Replaces          | Owner
  ───────────────────────|───────────────────────────────|───────────────────|──────────
  [Component name]       | [What it does]                | [Baseline item]   | [Team]
  [...]                  | [...]                         | [...]             | [...]

2.5 Key Architecture Decisions
  ADR ID  | Decision Summary                              | Date Decided
  ────────|───────────────────────────────────────────────|─────────────
  ADR-042 | Apache Kafka for all async inter-service comms| 2024-03-15
  ADR-051 | React Native for cross-platform mobile        | 2024-04-02
  ADR-063 | PostgreSQL as primary OLTP database           | 2024-04-10

  (Full ADR details: see Architecture Repository / Section 8 of this document)

═══════════════════════════════════════════════════════════════
SECTION 3: GAP ANALYSIS
═══════════════════════════════════════════════════════════════

(Full gap analysis: see dedicated Gap Analysis artifact — Section 5)

Area             | Baseline                    | Target                       | Gap                        | Action Required
─────────────────|─────────────────────────────|──────────────────────────────|────────────────────────────|─────────────────────
[Area 1]         | [Current state]             | [Target state]               | [What is missing/needed]   | [Work package ref]
[Area 2]         | [...]                       | [...]                        | [...]                      | [...]

═══════════════════════════════════════════════════════════════
SECTION 4: ARCHITECTURE REQUIREMENTS
═══════════════════════════════════════════════════════════════

(Full requirements: see Architecture Requirements Specification — Section 4)

Key requirements applicable to this domain:
  ARS-ID  | Requirement Summary                        | Priority
  ────────|────────────────────────────────────────────|──────────
  ARS-001 | API response time < 200ms P99              | MUST
  ARS-002 | 99.95% platform uptime SLA                 | MUST
  ARS-003 | All PII encrypted at rest and in transit   | MUST

═══════════════════════════════════════════════════════════════
SECTION 5: ARCHITECTURE VIEWS
═══════════════════════════════════════════════════════════════

Viewpoint               | Audience              | View Description              | Diagram
────────────────────────|───────────────────────|───────────────────────────────|──────────────────
Context view            | All stakeholders      | System in its environment     | Appendix C-1
Functional view         | Business Lead         | Capabilities and interactions | Appendix C-2
Information flow view   | Data Architect, CISO  | Data flows between systems    | Appendix C-3
Deployment view         | Technology Architect  | Where things run              | Appendix C-4
Security view           | CISO, Compliance      | Security controls and zones   | Appendix C-5

═══════════════════════════════════════════════════════════════
APPENDICES
═══════════════════════════════════════════════════════════════

Appendix A: Baseline Architecture Diagram
Appendix B: Target Architecture Diagram
Appendix C: Stakeholder Views (C-1 through C-5)
Appendix D: Glossary of Terms
Appendix E: Reference Documents
```

---

## 4. Architecture Requirements Specification (ARS)

**Purpose:** Quantified, testable requirements that the architecture must meet. Bridges the gap between high-level goals in the Architecture Vision and the measurable criteria that implementation must satisfy. This is what "done" looks like — provably.

**When to use:** Developed iteratively across Phases B, C, D as requirements become clearer. Referenced by Architecture Contracts (Phase G) to verify compliance before go-live.

**Requirement categories:** Performance, Availability, Security, Scalability, Compliance, Interoperability, Maintainability, Cost.

---

### Template

```
ARCHITECTURE REQUIREMENTS SPECIFICATION
═══════════════════════════════════════════════════════════════

Document ID:    ARS-[YYYY]-[NNN]
Version:        1.0
Date:           [YYYY-MM-DD]
Status:         Draft | Approved
Related to:     ADD-[DOMAIN]-[YYYY]-[NNN]
Author:         [Name]

─────────────────────────────────────────────────────────────────────────────────────────────────────────
ID      | Category        | Requirement                                                   | Priority | Source                    | Acceptance Criterion
─────────|─────────────────|───────────────────────────────────────────────────────────────|──────────|───────────────────────────|────────────────────────────────────────────────────
PERFORMANCE
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-001 | Performance     | API response time < 200ms at 99th percentile under normal load | MUST     | Business stakeholder       | Load test report showing P99 < 200ms at 500 RPS
ARS-002 | Performance     | Page load time < 2 seconds on 4G mobile connection            | MUST     | UX research / Head Digital | Lighthouse score ≥ 90; measured on mid-range Android
ARS-003 | Performance     | Batch processing of 1M transactions completed within 2 hours  | MUST     | Operations Lead            | End-of-day batch test results < 2 hours for 1M records
─────────────────────────────────────────────────────────────────────────────────────────────────────────
AVAILABILITY
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-004 | Availability    | Platform SLA of 99.95% monthly uptime for core services       | MUST     | SLA agreement / Board      | Monthly uptime reports; < 22 minutes downtime/month
ARS-005 | Availability    | RTO (Recovery Time Objective) ≤ 4 hours for P1 incidents      | MUST     | Business Continuity Plan   | DR test results showing recovery < 4 hours
ARS-006 | Availability    | RPO (Recovery Point Objective) ≤ 1 hour for all data          | MUST     | Business Continuity Plan   | Backup restoration test showing ≤ 1 hour data loss
─────────────────────────────────────────────────────────────────────────────────────────────────────────
SECURITY
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-007 | Security        | All PII data encrypted at rest (AES-256) and in transit (TLS 1.3+) | MUST | Legal / Compliance       | Security audit report; penetration test passing
ARS-008 | Security        | Multi-factor authentication for all customer-facing access     | MUST     | CISO directive             | Authentication log analysis; no single-factor sessions
ARS-009 | Security        | All secrets managed via approved vault (e.g., HashiCorp Vault) | MUST     | Security Architecture      | Code scan shows zero hard-coded credentials
ARS-010 | Security        | OWASP Top 10 addressed for all web/API components             | MUST     | CISO                       | DAST scan report with no critical/high findings
─────────────────────────────────────────────────────────────────────────────────────────────────────────
SCALABILITY
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-011 | Scalability     | Support 10x current transaction volume without architecture change | SHOULD | CTO direction            | Load test at 10x baseline showing linear cost growth
ARS-012 | Scalability     | Auto-scaling responds to 3x traffic spike within 90 seconds   | MUST     | Platform Architecture      | Chaos engineering test — spike test results
─────────────────────────────────────────────────────────────────────────────────────────────────────────
COMPLIANCE
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-013 | Compliance      | GDPR / data protection compliance for all EU customer data    | MUST     | Legal / DPO                | DPO sign-off; data flow mapping complete
ARS-014 | Compliance      | CBUAE Open Finance compliance (UAE Central Bank)              | MUST     | Regulatory Affairs         | Regulator sign-off; API compliance certificate
ARS-015 | Compliance      | Full audit trail for all financial transactions (7 years)     | MUST     | Audit / Legal              | Audit log review; data retention policy implemented
─────────────────────────────────────────────────────────────────────────────────────────────────────────
INTEROPERABILITY
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-016 | Interoperability| All new APIs must follow OpenAPI 3.0 specification            | MUST     | Architecture Principle T02 | API gateway validation; spec file in repository
ARS-017 | Interoperability| Event schemas follow AsyncAPI 2.x for Kafka topics           | SHOULD   | Integration Architecture   | Schema registry entries; AsyncAPI spec published
─────────────────────────────────────────────────────────────────────────────────────────────────────────
MAINTAINABILITY
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-018 | Maintainability | All production services deployable via CI/CD pipeline         | MUST     | DevOps Lead                | Pipeline exists; zero manual deployments to prod
ARS-019 | Maintainability | Centralised logging and observability for all services        | MUST     | Platform Architecture      | All services visible in observability platform
─────────────────────────────────────────────────────────────────────────────────────────────────────────
COST
─────────────────────────────────────────────────────────────────────────────────────────────────────────
ARS-020 | Cost            | Total cloud infrastructure cost ≤ AED 180K/month at steady state | SHOULD | CFO / Architecture        | Monthly cloud billing dashboard review
─────────────────────────────────────────────────────────────────────────────────────────────────────────

Priority definitions:
  MUST   — Mandatory. Non-compliance = architecture rejection
  SHOULD — Highly desirable. Non-compliance requires Architecture Board dispensation
  MAY    — Optional. Recommended but at project team discretion
```

---

## 5. Gap Analysis Table

**Purpose:** Identifies what needs to change between Baseline and Target architecture. Provides the input for work package definition and the Architecture Roadmap. Every gap becomes something you either build, buy, modify, or accept.

**When to use:** Produced at the end of each domain architecture phase (B, C, D). Drives Phase E (Opportunities and Solutions) and Phase F (Migration Planning).

**Status definitions:**
- **Retained** — Component stays as-is; no change needed
- **Modified** — Component kept but changed (enhanced, upgraded, reconfigured)
- **New** — Component does not exist today; must be built or acquired
- **Decommissioned** — Component removed; function absorbed elsewhere or no longer needed
- **Consolidated** — Multiple components merged into one

---

### Template

```
GAP ANALYSIS
═══════════════════════════════════════════════════════════════

Domain:         [e.g., Application Architecture]
Related ADD:    ADD-APP-[YYYY]-[NNN]
Baseline date:  [Date of baseline assessment]
Target date:    [Target architecture achievement date]
Author:         [Domain Architect]
Reviewed by:    [Architecture Board, date]

═══════════════════════════════════════════════════════════════
COMPONENT INVENTORY & GAP REGISTER
═══════════════════════════════════════════════════════════════

Component           | Current State                          | Target State                         | Gap Description                        | Status         | Work Package | Priority | Owner
────────────────────|────────────────────────────────────────|──────────────────────────────────────|────────────────────────────────────────|────────────────|──────────────|──────────|──────────
Customer Portal     | v2.1 React app; poor mobile UX;        | v3.0 mobile-first PWA; NPS target +30 | Full UX rewrite; performance           | Modified       | WP-003       | HIGH     | [Name]
                    | NPS -12; no offline support            |                                      | optimisation; offline capability       |                |              |          |
Legacy CRM (Siebel) | Siebel 8.1 on-prem; 2009 vintage;     | Salesforce Sales + Service Cloud       | Full replacement; data migration;      | Decommissioned | WP-007       | HIGH     | [Name]
                    | £240K/yr licence; 8-wk change cycle    |                                      | integration rebuild                    |                |              |          |
Payment Gateway     | Custom SOAP integration to             | Stripe REST API; PCI DSS compliant     | Integration layer rewrite; new         | Modified       | WP-004       | MEDIUM   | [Name]
                    | payment processor; PCI issues          |                                      | PCI scope reduction                    |                |              |          |
Data Warehouse      | Oracle EDW on-prem; nightly batch;     | Azure Synapse cloud-native platform;  | Full platform migration; ETL rewrite;  | Replaced       | WP-009       | HIGH     | [Name]
                    | 12-hour data latency                   | real-time streaming                  | near-real-time pipelines               |                |              |          |
Legacy ESB          | IBM MQ + DataPower; 47 SOAP interfaces | Apache Kafka + Azure API Management   | Event-driven re-architecture;          | Decommissioned | WP-005       | MEDIUM   | [Name]
                    | $180K/yr; ops complexity               |                                      | API-ify all interfaces                 |                |              |          |
Mobile App          | iOS native (Swift) + Android (Kotlin)  | Cross-platform React Native           | Full rebuild; feature parity +         | New            | WP-003       | HIGH     | [Name]
                    | separate codebases; 2x dev cost        |                                      | new digital features                   |                |              |          |
Fraud Detection     | Rules-based batch engine; 18h lag      | Real-time ML model; <500ms decisioning| New ML platform; model training;       | New            | WP-011       | CRITICAL | [Name]
                    | D+1 detection; high false positives    |                                      | operational process change             |                |              |          |
Identity & Access   | LDAP on-prem; no SSO; per-app logins  | Azure AD B2C with SSO + MFA           | IAM platform migration; all apps       | Replaced       | WP-002       | HIGH     | [Name]
                    |                                        |                                      | re-integrated                          |                |              |          |
Core Banking        | Temenos T24; 15 years customisation;   | Temenos T24 (retained); API wrapper   | API facade layer; reduce direct        | Retained       | WP-001       | MEDIUM   | [Name]
                    | tightly coupled to many systems        | to decouple downstream                | coupling from 23 to 3 touchpoints      |                |              |          |
Notification Svc    | Does not exist; baked into each app   | Centralised notification microservice | Build new; migrate all notification    | New            | WP-006       | LOW      | [Name]
                    |                                        | (email, SMS, push, in-app)            | logic from 7 existing apps             |                |              |          |

═══════════════════════════════════════════════════════════════
GAP SUMMARY
═══════════════════════════════════════════════════════════════

Status              | Count | Work Packages    | Notes
────────────────────|───────|──────────────────|──────────────────────────────────────────────
Retained            | 1     | WP-001 (partial) | Core Banking retained with API wrapper
Modified            | 2     | WP-003, WP-004   | Customer Portal + Payment Gateway
New                 | 3     | WP-003, WP-006, WP-011 | Mobile App, Notification Svc, Fraud ML
Decommissioned      | 2     | WP-005, WP-007   | Legacy ESB, Siebel CRM
Replaced            | 2     | WP-009, WP-002   | Oracle EDW → Azure Synapse; LDAP → Azure AD
────────────────────|───────|──────────────────|──────────────────────────────────────────────
TOTAL               | 10    | 9 work packages  |

Estimated effort:       [X person-months]
Estimated duration:     [18 months across 3 transition architectures]
Total work packages:    9

High / Critical priority items:
  - WP-011 (Fraud Detection): CRITICAL — regulatory and financial risk
  - WP-007 (CRM replacement): HIGH — $240K/yr cost + 8-week change cycle blocking business
  - WP-003 (Mobile/Portal): HIGH — directly drives NPS improvement (primary goal)
```

---

## 6. Stakeholder Map / Matrix

**Purpose:** Identifies all stakeholders, their concerns, influence levels, and required engagement strategy. Determines which architecture views need to be created (each stakeholder viewpoint requires a view). Guides communication planning throughout the ADM cycle.

**When to use:** First created in Phase A; updated continuously. The power/interest grid guides how much attention each stakeholder receives.

---

### Template

```
STAKEHOLDER MAP
═══════════════════════════════════════════════════════════════

Project:        [Architecture engagement name]
Version:        [x.x]
Date:           [YYYY-MM-DD]
Owner:          [Lead Architect]

═══════════════════════════════════════════════════════════════
STAKEHOLDER REGISTER
═══════════════════════════════════════════════════════════════

Stakeholder     | Organisation / Role       | Key Concerns                              | Power | Interest | Engagement Strategy               | Required Architecture Views
────────────────|───────────────────────────|───────────────────────────────────────────|───────|──────────|───────────────────────────────────|───────────────────────────────────────────
CEO             | Executive Sponsor         | ROI, competitive position, strategic risk  | H     | M        | Monthly executive brief (1 page)  | Architecture Vision, Value Roadmap
CIO             | Architecture Owner        | Technical feasibility, cost, team impact   | H     | H        | Steering committee; weekly 1:1    | Full ADD; all architecture views
Chief Architect | Architecture Authority    | Quality, standards, principles compliance  | H     | H        | Working sessions throughout       | All artifacts — author/reviewer
Head of Digital | Business Lead             | Customer experience, speed to market, NPS  | M     | H        | Working groups; sprint demos       | Business capability map, App portfolio
CISO            | Security Owner            | Security compliance, data protection, risk | H     | M        | Security review gates (per phase) | Security view, Data architecture
CFO             | Budget Approver           | Cost, financial risk, ROI                  | H     | L        | Monthly financial summary          | Business case, cost model, roadmap
CDO             | Data Owner                | Data quality, governance, privacy          | M     | H        | Data architecture workshops        | Data architecture ADD, data catalog
Head of Ops     | Operational Lead          | Operational impact, SLAs, change mgmt     | M     | M        | Change impact assessments          | Technology architecture, runbooks
Dev Lead(s)     | Implementation Teams      | Technical clarity, standards, feasibility  | L     | H        | Architecture review sessions       | Application ADD, Technology ADD, ADRs
Compliance      | Regulatory compliance     | Regulatory adherence, audit trail          | M     | H        | Compliance review at each gate     | Security view, Data architecture
Legal / DPO     | Data Protection Officer   | GDPR/data law compliance, PII handling     | M     | M        | DPO sign-off on data architecture  | Data architecture, privacy by design view
Customers       | End users                 | Usability, performance, reliability        | L     | H        | User research; UX testing; NPS     | N/A (indirect — inform UX requirements)
Architecture Bd | Governance body           | Standards compliance, architectural quality| H     | H        | Formal review gates at each phase  | All artifacts — approval authority
Regulators      | CBUAE / External          | Regulatory compliance, consumer protection | H     | L        | Proactive engagement; legal review | Compliance view, regulatory mapping

═══════════════════════════════════════════════════════════════
POWER / INTEREST GRID
═══════════════════════════════════════════════════════════════

                     LOW INTEREST          HIGH INTEREST
                   ┌──────────────────────┬──────────────────────────┐
          HIGH     │  KEEP SATISFIED      │  MANAGE CLOSELY          │
          POWER    │                      │                          │
                   │  CEO (strategic)     │  CIO                     │
                   │  CFO                 │  Chief Architect         │
                   │  CISO                │  Architecture Board      │
                   │  Regulators          │                          │
                   ├──────────────────────┼──────────────────────────┤
          LOW      │  MONITOR             │  KEEP INFORMED           │
          POWER    │                      │                          │
                   │  (none identified)   │  Head of Digital         │
                   │                      │  CDO                     │
                   │                      │  Dev Leads               │
                   │                      │  Compliance              │
                   │                      │  Head of Ops             │
                   │                      │  Customers               │
                   └──────────────────────┴──────────────────────────┘

Engagement actions by quadrant:
  Manage Closely:   Involve in all decisions; regular touchpoints; review gates
  Keep Satisfied:   Regular updates; escalate risks early; no surprises
  Keep Informed:    Working group access; automated status updates; Q&A sessions
  Monitor:          Distribution list; periodic awareness; escalate if interest changes

═══════════════════════════════════════════════════════════════
CONCERNS → VIEWS MAPPING
═══════════════════════════════════════════════════════════════

Each unique stakeholder concern requires at least one architecture view.
If you cannot produce a view for a concern, it is a gap in the architecture work.

Stakeholder Concern                    | Architecture View Required               | Owner
───────────────────────────────────────|──────────────────────────────────────────|──────────────
"Will this cost more than planned?"    | Cost model / financial architecture view | CFO, CFO
"Is customer data protected?"          | Security and privacy view                | CISO, DPO
"Can we deliver this in 18 months?"    | Architecture Roadmap                     | CIO
"What changes for my operations team?" | Operational architecture / RACI          | Head of Ops
"How does this meet PSD2 requirements?"| Regulatory compliance view               | Compliance
"How do I build to this design?"       | Detailed Application + Tech ADD          | Dev Leads
```

---

## 7. Architecture Principles Catalog

**Purpose:** Documented principles that guide all architecture decisions. Principles are not rules — they are normative statements that require judgement in application. They provide consistency and a framework for decision-making across all projects and time.

**When to use:** Maintained as part of the Architecture Repository. Referenced in every ADD, every ADR, and every Architecture Contract. Updated when the strategic context changes.

**Principle structure:** Name + Statement + Rationale + Business implications + IT implications.

---

### Catalog Template (per principle)

```
PRINCIPLE: [Short Name]

Statement:
  [One clear, unambiguous sentence. Active voice. "We will..." or "All systems..."]

Rationale:
  [Why this principle exists — the business or technical reasoning.
   What problem does it prevent? What value does it create?]

Implications for Business:
  [What business units / stakeholders must accept or do differently because of this principle.
   Be honest about trade-offs — principles have costs.]

Implications for IT:
  [What this means for IT decisions, design choices, and constraints.
   What processes or standards does this drive?]

Exceptions:
  [Under what circumstances may this principle be overridden? Who approves exceptions?]
```

---

### 12 Example Principles — Enterprise Technology & Architecture

---

**T01: Cloud First**

- **Statement:** New systems and infrastructure are deployed on approved cloud platforms unless there is a documented and approved business reason not to.
- **Rationale:** Cloud reduces capital expenditure, improves scalability and time-to-market, enables pay-as-you-grow cost models, and provides access to managed services that reduce operational toil. Capital investment in on-premise infrastructure ties up funds that could fund innovation.
- **Business implications:** Cloud hosting costs replace capital expenditure and appear as OpEx. Procurement processes must include cloud-native options in evaluations. Business cases must not assume capital ownership of infrastructure.
- **IT implications:** All new designs must evaluate cloud-native options first. On-premise deployments require Architecture Board approval and documented justification. Migration plans for existing on-prem workloads should be included in Architecture Roadmaps.
- **Exceptions:** Regulatory data residency requirements (e.g., CBUAE PII rules), legacy systems with defined decommission plans, specific security constraints approved by CISO.

---

**T02: API First**

- **Statement:** All new system capabilities are exposed as versioned APIs before building any user interface or integration.
- **Rationale:** APIs enable reuse, partner integration, and future channel flexibility at no additional cost. UI-first development creates capabilities that are difficult to reuse. API-first thinking forces better domain modelling and separation of concerns.
- **Business implications:** API strategy requires investment and governance. External API monetisation opportunities should be evaluated. Partner integration timelines become shorter once API-first practice is established.
- **IT implications:** All new services designed with API contracts first (OpenAPI 3.0 specification). Consumer-driven contract testing required before API publication. APIs must be versioned from day one. No direct database access from consuming systems.
- **Exceptions:** Pure batch processing systems with no consumer integration requirements (approved by Lead Architect).

---

**T03: Minimise Technical Diversity**

- **Statement:** Technology choices are made from the approved Standards Information Base (SIB); new technologies require Architecture Board approval before adoption.
- **Rationale:** Proliferation of technologies increases support cost, security surface area, skill requirements, and onboarding time. A smaller, well-supported technology portfolio is cheaper to run and easier to secure. Each unique technology requires trained staff, tooling, and operational runbooks.
- **Business implications:** Business unit preferences for specific vendors or technologies must be evaluated against enterprise standards. Technology decisions have enterprise-wide cost implications beyond the individual project.
- **IT implications:** Technology selection must start from the SIB. New technology proposals submitted to Architecture Board with evaluation criteria documented. Technology radar maintained and reviewed annually. Sunset plans required for technologies removed from SIB.
- **Exceptions:** Time-limited proof-of-concept (PoC) work in sandbox environments; exceptions expire if technology not added to SIB within 6 months.

---

**T04: Design for Failure**

- **Statement:** All production systems are designed to continue operating in a degraded but functional state when components fail.
- **Rationale:** Modern distributed systems have many failure points across network, hardware, software, and external dependencies. Cascading failures are more damaging than isolated ones. Designing for graceful degradation is less costly than designing for perfection and paying for outages.
- **Business implications:** Agreed degraded service levels must be defined for each system (what is acceptable when a component is down?). Business processes must be designed to accommodate graceful degradation modes.
- **IT implications:** Circuit breakers, retry with exponential backoff, bulkhead patterns, and fallback mechanisms are mandatory for all inter-service calls. Chaos engineering tests required before production launch. SLOs for each service component defined and monitored.
- **Exceptions:** Truly stateless, idempotent, non-critical batch jobs where total failure and retry is acceptable.

---

**T05: Security by Design**

- **Statement:** Security controls are embedded in architecture and design from inception, not added as a post-implementation concern.
- **Rationale:** Post-hoc security is expensive, incomplete, and creates ongoing technical debt. Security vulnerabilities discovered in production cost 30x more to fix than in design. Regulatory penalties and reputational damage from breaches are existential risks for financial services.
- **Business implications:** Security requirements are included in project scope from day one as non-negotiable items. Security is not a separate project phase — it is integrated throughout. Security review gates are mandatory, not optional.
- **IT implications:** Threat modelling (STRIDE) required for all new system designs. OWASP Top 10 must be explicitly addressed in design documentation. CISO review required at design gate before build commences. Zero-trust network architecture for all new deployments.
- **Exceptions:** None. Security is not optional. Waivers for specific controls possible only with CISO written approval and compensating controls documented.

---

**T06: Prefer Managed Services Over Custom-Built**

- **Statement:** When selecting between a managed service and a custom-built solution for infrastructure or platform capabilities, the managed service is chosen unless total cost of ownership or strategic control requirements justify custom development.
- **Rationale:** Custom-built platform components create perpetual maintenance obligations, require specialist skills, and distract engineering talent from business-differentiating work. Managed services transfer operational risk to providers with greater scale and expertise.
- **Business implications:** Build-vs-buy decisions must include full TCO analysis (not just initial licence cost). Custom development of commodity capabilities is not a competitive advantage.
- **IT implications:** Managed databases, queues, caches, identity providers preferred over self-managed equivalents. Engineering investment directed to business logic, not platform plumbing.
- **Exceptions:** Where managed service cannot meet regulatory requirements; where vendor lock-in risk is unacceptable for strategic components; where total cost is demonstrably lower for self-managed (with 5-year TCO evidence).

---

**T07: Data is an Asset — Govern It as Such**

- **Statement:** Data has defined ownership, quality standards, and lifecycle management. Data is shared through authoritative sources, not copied ad hoc.
- **Rationale:** Unmanaged data proliferates into inconsistent copies, creates reconciliation overhead, introduces compliance exposure, and degrades trust in analytics. Data governance reduces operational cost and increases the strategic value of data assets.
- **Business implications:** Every dataset has a named business owner accountable for quality and access decisions. Data cannot be replicated between systems without data governance approval and documentation.
- **IT implications:** Single authoritative source for each data entity. Data lineage documented in data catalog. No system creates its own copy of data it does not own. Master data management processes required for shared entities (customer, product, etc.).
- **Exceptions:** Caching for performance (with documented TTL and invalidation strategy); analytical copies in data platform with documented lineage.

---

**T08: Design for Observability**

- **Statement:** All production services emit structured logs, metrics, and traces to the centralised observability platform from day one of deployment.
- **Rationale:** Systems that cannot be observed cannot be reliably operated or improved. Debugging production issues without instrumentation costs dramatically more in time and outage duration. Observability enables proactive problem detection before user impact.
- **Business implications:** Observability tooling costs are non-negotiable operational infrastructure costs. Mean Time to Detect (MTTD) and Mean Time to Resolve (MTTR) are business metrics with direct customer and financial impact.
- **IT implications:** Structured JSON logging mandatory. Distributed tracing (OpenTelemetry) required for all inter-service calls. Service Level Indicators (SLIs) and SLOs defined for each service before production launch. Dashboards and runbooks required as launch criteria.
- **Exceptions:** Batch jobs with simple success/fail outcomes (still require structured completion logs and alerting on failure).

---

**B01: Business Capability over System Ownership**

- **Statement:** Architecture decisions are made to optimise business capabilities, not to preserve the footprint of existing IT systems.
- **Rationale:** IT systems exist to serve business capabilities, not the reverse. Optimising for system preservation leads to architectures that protect technical investments at the cost of business agility and value delivery.
- **Business implications:** Business capability definitions drive IT portfolio decisions. IT decommissioning must be supported when capabilities are served better by alternative systems.
- **IT implications:** All systems evaluated by the business capability they serve. Sunset plans created for systems whose capabilities are superseded. Resistance to decommissioning must be escalated with business case justification.
- **Exceptions:** Regulatory retention requirements for specific systems; contractual obligations.

---

**B02: Interoperability Over Integration**

- **Statement:** Systems are designed to be interoperable through standard interfaces; proprietary point-to-point integrations are only created when no standard interface exists.
- **Rationale:** Proprietary integrations create tight coupling, increase maintenance burden, and make system replacement expensive. Standard interfaces (APIs, events, standard data formats) reduce integration cost over time and enable ecosystem participation.
- **Business implications:** Vendor selection criteria must include support for open standards. Proprietary integrations require Architecture Board approval with documented migration path.
- **IT implications:** API-first design (see T02). Event-driven integration where possible. Integration patterns documented and standardised. Point-to-point integrations inventoried with sunset plans.
- **Exceptions:** Legacy system integration where no alternative exists; time-boxed with a migration plan.

---

**D01: Privacy by Design**

- **Statement:** Privacy protections are embedded in system design from the start; personal data is minimised, purpose-limited, and subject to automated lifecycle controls.
- **Rationale:** Regulatory requirements (GDPR, UAE PDPL) mandate privacy by design. Post-hoc privacy controls are more expensive, less effective, and create regulatory exposure. Privacy-aware architecture builds customer trust.
- **Business implications:** Data minimisation may mean collecting less information than currently gathered. Consent management and data subject rights (access, erasure) require operational processes.
- **IT implications:** Data classification required for all data stores. PII tagged in data catalog. Automated data retention and deletion processes. Consent management platform required. Privacy Impact Assessment required for new data processing activities.
- **Exceptions:** Legal holds override retention limits; regulatory reporting requirements override minimisation in specific cases.

---

**D02: Single Source of Truth**

- **Statement:** Each data entity (customer, product, transaction) has one authoritative system of record; all other systems read from or subscribe to this source.
- **Rationale:** Multiple copies of the same data diverge, requiring expensive reconciliation, creating regulatory risk from inconsistency, and degrading analytical quality. A single source of truth reduces reconciliation cost and increases trust.
- **Business implications:** Business processes must be designed around the authoritative system, not around locally-held copies. Reporting that uses non-authoritative data must be flagged and remediated.
- **IT implications:** System of record designated for each data entity in data catalog. Event-driven distribution (not batch replication) for consuming systems. Conflict resolution policies required where data enters from multiple sources.
- **Exceptions:** Analytical/reporting copies in data platforms (with lineage documentation and no write-back to source).

---

## 8. Architecture Decision Record (ADR)

**Purpose:** Documents significant architecture decisions with context, rationale, alternatives considered, and consequences. Prevents "why did we do this?" conversations from recurring. Creates organisational memory. Enables better future decisions by learning from past ones.

**When to use:** For any decision that: (a) is difficult to reverse, (b) affects multiple teams or systems, (c) involves significant trade-offs, or (d) deviates from architecture principles or standards. A decision about which database to use for a new service — yes. A decision about variable naming — no.

**Naming convention:** ADR-NNN where NNN is a sequential three-digit number within the project or organisation. Keep a numbered index.

---

### Template

```
ADR-[NNN]: [Short, descriptive title — e.g., "Use PostgreSQL as primary OLTP database"]
═══════════════════════════════════════════════════════════════

Date:      [YYYY-MM-DD]
Status:    Proposed | Accepted | Deprecated | Superseded by ADR-[NNN]
Deciders:  [Name (Role), Name (Role), ...]
Tags:      [domain: application | data | technology | security] [pattern: database | messaging | auth | ...]

───────────────────────────────────────────────────────────────
CONTEXT
───────────────────────────────────────────────────────────────
[Describe the situation and forces at play. What is the problem
 we need to make a decision about? What constraints exist?
 What are the competing concerns? Be specific — future readers
 need to understand why this was a decision worth documenting.

 Include: what is the current situation, what triggered the
 decision, what requirements or principles are relevant.]

───────────────────────────────────────────────────────────────
DECISION
───────────────────────────────────────────────────────────────
[State the decision clearly and specifically.
 "We will use X for Y, implemented as Z."
 One paragraph. No ambiguity.]

───────────────────────────────────────────────────────────────
RATIONALE
───────────────────────────────────────────────────────────────
[Why was this option chosen over alternatives?
 What criteria mattered most? Which architecture principles
 does this decision support?

 Be specific about the weighting of criteria — e.g.,
 "throughput was the primary criterion (must handle 2M events/sec);
  operational simplicity was secondary."]

───────────────────────────────────────────────────────────────
ALTERNATIVES CONSIDERED
───────────────────────────────────────────────────────────────
Option A: [Name]
  Description: [Brief description of the alternative]
  Why rejected: [Specific reason(s) — not vague]

Option B: [Name]
  Description: [Brief description]
  Why rejected: [Specific reason(s)]

Option C: [Name — the "do nothing" option is always an alternative]
  Description: Continue with current approach
  Why rejected: [Specific reason(s)]

───────────────────────────────────────────────────────────────
CONSEQUENCES
───────────────────────────────────────────────────────────────
Positive:
  - [Benefit 1]
  - [Benefit 2]
  - [Benefit 3]

Negative / Trade-offs (be honest — every decision has costs):
  - [Drawback 1]
  - [Drawback 2]

Risks and mitigations:
  Risk 1: [Specific risk] — Mitigation: [Specific action]
  Risk 2: [Specific risk] — Mitigation: [Specific action]

───────────────────────────────────────────────────────────────
REVIEW TRIGGER
───────────────────────────────────────────────────────────────
This decision should be reviewed if:
  - [Condition 1 — e.g., event volume exceeds 5M/sec]
  - [Condition 2 — e.g., cloud provider exits market]
  - [Time-based — e.g., 2 years after adoption]

Next review date: [Date or "On trigger"]
```

---

### Full Example ADR

```
ADR-042: Use Apache Kafka for all asynchronous inter-service communication
═══════════════════════════════════════════════════════════════

Date:      2024-03-15
Status:    Accepted
Deciders:  Rania Al-Hassan (Chief Architect), David Osei (Integration Architect), 
           Priya Sharma (CTO)
Tags:      domain: application | pattern: messaging | phase: C

───────────────────────────────────────────────────────────────
CONTEXT
───────────────────────────────────────────────────────────────
The digital banking platform has 23 microservices that need to communicate
asynchronously. A recent audit found 8 different messaging approaches currently
in use across these services:
  - 3 services use RabbitMQ (versions 3.8 and 3.11, incompatible)
  - 4 services use AWS SQS
  - 8 services use direct synchronous HTTP (anti-pattern for async use cases)
  - 2 services use a home-built queue using PostgreSQL
  - 1 service uses Azure Service Bus
  - 5 services use custom file-based integration

This fragmentation creates: (a) inconsistent error handling — 6 P1 incidents in
12 months due to failed message delivery with no dead-letter handling; (b) no
replay capability — 3 regulatory audit findings about inability to reconstruct
event history; (c) inconsistent monitoring — different alerting per system;
(d) 4 different teams with 4 different operational runbooks.

Architecture Principle T03 (Minimise Technical Diversity) requires standardisation.
ARS-015 requires full audit trail for financial transactions. The platform must
handle 200K events/second at peak with a growth path to 2M events/second.

───────────────────────────────────────────────────────────────
DECISION
───────────────────────────────────────────────────────────────
All asynchronous inter-service communication will use Apache Kafka, deployed on
Confluent Cloud (managed Kafka). All existing alternative messaging solutions will
be migrated to Kafka within 12 months per the migration plan in WP-005. A
centrally-operated schema registry (Confluent Schema Registry with Avro) will
enforce event schema governance.

───────────────────────────────────────────────────────────────
RATIONALE
───────────────────────────────────────────────────────────────
Primary criteria: throughput, event replay, and standardisation.

Kafka was selected because:
  1. Throughput: Handles 2M+ events/sec — headroom for 10x growth (ARS-011)
  2. Event replay: Native log retention satisfies ARS-015 (audit trail requirement)
     without additional investment in separate event store
  3. Team expertise: 6 of 8 platform engineers have Kafka experience; 2 others
     completed Confluent certification in Q4 2023
  4. Confluent Cloud: Managed service reduces operational burden vs self-managed;
     aligns with Principle T06 (Managed Services preferred)
  5. Open standard: Confluent uses open Kafka API — migration path exists to
     self-managed or alternative provider (mitigates vendor lock-in concern)

Secondary: Confluent's Schema Registry provides the governance framework required
for our AsyncAPI spec requirement (ARS-017).

───────────────────────────────────────────────────────────────
ALTERNATIVES CONSIDERED
───────────────────────────────────────────────────────────────
Option A: Standardise on RabbitMQ
  Description: Use RabbitMQ across all services; upgrade existing deployments to 3.11.
  Why rejected: Lower throughput ceiling (100K msg/sec vs 2M+ for Kafka). No native
  event replay — would require separate event sourcing solution to meet ARS-015.
  Operational cluster management remains with platform team.

Option B: AWS SQS/SNS
  Description: Standardise on AWS managed messaging services.
  Why rejected: Creates hard AWS vendor lock-in, conflicting with multi-cloud principle
  (T03 SIB — multi-cloud is a strategic requirement). Limited replay capability
  (14-day max retention). Fan-out patterns are more complex to implement correctly.

Option C: Azure Service Bus
  Description: Use Azure Service Bus as enterprise messaging platform.
  Why rejected: Azure is our secondary cloud platform. Primary workloads are on AWS.
  Cross-cloud messaging adds latency and egress cost. Single existing use case does
  not justify platform-level adoption.

Option D: Do nothing — allow existing heterogeneity
  Description: Continue with multiple messaging approaches; document them.
  Why rejected: Directly causes the problems described in Context. 6 P1 incidents
  and 3 regulatory findings in 12 months are unacceptable costs of inaction.

───────────────────────────────────────────────────────────────
CONSEQUENCES
───────────────────────────────────────────────────────────────
Positive:
  - Single operational runbook for all async messaging
  - Event replay capability satisfies regulatory audit finding (ARS-015)
  - Throughput headroom for 10x growth (ARS-011)
  - Standardised schema governance via Schema Registry
  - Reduced monitoring complexity — single Confluent observability dashboard

Negative / Trade-offs:
  - Confluent Cloud cost: approximately AED 8,800/month at steady state
    (vs. current ~AED 3,200/month for disparate solutions — AED 5,600/month increase)
  - Migration effort: 12 services using non-Kafka solutions; estimated 4 months
    of integration team time (included in WP-005)
  - 2 engineers require Kafka training (2-day course; budgeted in WP-005)
  - Kafka adds operational complexity vs. simpler queue solutions for low-volume use cases

Risks and mitigations:
  Risk 1: Confluent vendor lock-in — Mitigation: Using open Kafka API throughout;
    all consumers use standard Kafka client libraries (not Confluent SDK extensions).
    Migration to self-managed Kafka tested in sandbox; estimated 3-week effort.
  Risk 2: Migration disruption to existing services — Mitigation: Dual-write
    migration pattern (old + new) for each service; no big-bang cutover.
    Service-by-service migration with rollback plan per service.
  Risk 3: Schema evolution breaking consumers — Mitigation: Schema Registry with
    backward-compatible evolution policy. Consumer-driven contract tests required.

───────────────────────────────────────────────────────────────
REVIEW TRIGGER
───────────────────────────────────────────────────────────────
This decision should be reviewed if:
  - Confluent Cloud costs exceed AED 25,000/month (pricing model review)
  - Event volume exceeds 1.5M events/sec sustained (capacity planning)
  - A significantly better alternative emerges in the market
  - Multi-cloud strategy changes to single-cloud

Next review date: 2026-03-15 (2-year review) or on trigger above
```

---

## 9. Architecture Roadmap

**Purpose:** Visualises the journey from Baseline to Target architecture through a series of Transition Architectures. Makes the abstract architecture concrete and deliverable. Connects architecture to project delivery and business value realisation.

**When to use:** Produced in Phase E (Opportunities and Solutions) and detailed in Phase F (Migration Planning). Updated during Phase H (Architecture Change Management) as delivery progresses.

**Key concepts:**
- **Transition Architecture (TA):** An intermediate, stable, valuable architecture state on the path to the Target. Each TA delivers real business value — not just a stepping stone.
- **Work Package (WP):** A bounded unit of implementation work that delivers one or more capability gaps.
- **Milestone:** A point in time when a Transition Architecture is achieved — measurable and demonstrable.

---

### Template

```
ARCHITECTURE ROADMAP
═══════════════════════════════════════════════════════════════

Program:        [Architecture engagement name]
Owner:          [Chief Architect name]
Version:        [x.x]
Last Updated:   [YYYY-MM-DD]
Target horizon: [e.g., 18 months — Q1 2025 to Q2 2026]

═══════════════════════════════════════════════════════════════
TIMELINE OVERVIEW
═══════════════════════════════════════════════════════════════

       Q1 2025          Q2 2025         Q3 2025         Q4 2025         Q1 2026         Q2 2026
         │                │               │               │               │               │
 ────────┼────────────────┼───────────────┼───────────────┼───────────────┼───────────────┼────────
         │                │               │               │               │               │
BASELINE │                ◆ TA-1          │               ◆ TA-2          │               ◆ TARGET
         │                │               │               │               │               │
         │   WP-001 ────────────────►     │               │               │               │
         │   WP-002 ────────────────►     │               │               │               │
         │   WP-003        │  ──────────────────────────► │               │               │
         │   WP-004        │              │  ────────────► │               │               │
         │                 │   WP-005     │       ─────────────────────►  │               │
         │                 │   WP-007     │  ──────────────────────────────────────────►  │
         │                 │              │  WP-009 ───────────────────────────────────►  │
         │                 │              │               │  WP-011 ──────────────────►   │
         │                 │              │               │               │               │
 ────────┴────────────────┴───────────────┴───────────────┴───────────────┴───────────────┴────────

═══════════════════════════════════════════════════════════════
TRANSITION ARCHITECTURES
═══════════════════════════════════════════════════════════════

TA-1: "API-Enabled Foundation" — Target: Q2 2025
  Description: API gateway deployed and operational. Core banking, product, and
    customer services accessible via well-governed APIs. Identity platform modernised
    to Azure AD B2C with SSO and MFA.
  Business value delivered: Partner integrations possible (3 signed partners waiting);
    customer login experience improved; developer velocity increased.
  Completed work packages: WP-001 (API Gateway), WP-002 (Identity Platform)
  Acceptance criteria: API gateway live; all core services have published API specs;
    customer SSO operational; 0 known security findings from penetration test.

TA-2: "Decoupled Event-Driven Platform" — Target: Q4 2025
  Description: 8 highest-priority microservices extracted from monolith. Kafka event
    streaming operational and all async communication migrated to it. Legacy ESB
    decommissioned. New mobile app (React Native) in production replacing native apps.
  Business value delivered: Mobile NPS improvement (target: +20 vs. baseline -12);
    $180K/year ESB licensing cost eliminated; feature delivery cycle 6 weeks → 2 weeks.
  Completed work packages: WP-003 (Mobile App), WP-004 (Payment Gateway),
    WP-005 (Kafka + ESB decommission)
  Acceptance criteria: Mobile NPS ≥ +10 (survey); ESB decommissioned; Kafka operational;
    all 23 services using standardised messaging.

TARGET: "Cloud-Native Digital Banking Platform" — Target: Q2 2026
  Description: Full target architecture achieved. All legacy systems decommissioned or
    migrated. Cloud-native data platform operational. Real-time fraud detection live.
    CRM replaced with Salesforce. Oracle EDW migrated to Azure Synapse.
  Business value delivered: All goals from Architecture Vision achieved. NPS +30. 40%
    digital sales. Cost savings of $420K/yr from decommissioned systems.

═══════════════════════════════════════════════════════════════
WORK PACKAGES
═══════════════════════════════════════════════════════════════

WP-ID  | Name                          | TA   | Start   | End     | Owner          | Depends On        | Business Benefit                        | Effort
────────|───────────────────────────────|──────|─────────|─────────|────────────────|───────────────────|-----------------------------------------|───────
WP-001  | API Gateway Deployment        | TA-1 | Q1 2025 | Q2 2025 | Integration    | —                 | Enables partner integrations; +AED 7M rev | 3 months
WP-002  | Identity Platform (Azure AD)  | TA-1 | Q1 2025 | Q2 2025 | Platform Team  | —                 | SSO; MFA; reduced support calls -30%    | 2 months
WP-003  | Mobile App (React Native)     | TA-2 | Q2 2025 | Q4 2025 | Digital Squad  | WP-001            | NPS +30; 40% digital sales target       | 6 months
WP-004  | Payment Gateway Migration     | TA-2 | Q3 2025 | Q4 2025 | Payments Team  | WP-001            | PCI scope reduction; reduced fraud loss  | 3 months
WP-005  | Kafka Platform + ESB Decomm   | TA-2 | Q2 2025 | Q4 2025 | Platform Team  | WP-001            | -$180K/yr ESB licensing; event capability| 4 months
WP-006  | Notification Service          | TA-2 | Q3 2025 | Q4 2025 | Dev Lead B     | WP-005            | Unified comms; reduce duplicate code    | 2 months
WP-007  | CRM Replacement (Salesforce)  | TAR  | Q3 2025 | Q2 2026 | CRM Team       | WP-001, WP-005    | -$240K/yr Siebel; 6wk→same-day config   | 8 months
WP-008  | Customer Microservice Extract | TA-2 | Q3 2025 | Q4 2025 | Squad A        | WP-001, WP-005    | Decouple from monolith; faster TTM      | 3 months
WP-009  | Data Platform (Azure Synapse) | TAR  | Q4 2025 | Q2 2026 | Data Team      | WP-005            | Real-time analytics; -12h data latency  | 6 months
WP-010  | Product Microservice Extract  | TAR  | Q1 2026 | Q2 2026 | Squad B        | WP-005, WP-008    | Product config from 6wk to same-day     | 3 months
WP-011  | Real-Time Fraud Detection ML  | TAR  | Q4 2025 | Q2 2026 | Data Science   | WP-005, WP-009    | Fraud loss -40%; regulatory compliance  | 5 months

═══════════════════════════════════════════════════════════════
DEPENDENCIES AND CRITICAL PATH
═══════════════════════════════════════════════════════════════

Critical path: WP-001 → WP-005 → WP-009 → WP-011
  - WP-001 (API Gateway) is the foundation — all other WPs depend on it
  - WP-005 (Kafka) unblocks the majority of TA-2 work
  - WP-009 (Data Platform) enables WP-011 (Fraud ML)
  - Any delay in WP-001 delays the entire roadmap

Parallel execution opportunities:
  - WP-001 and WP-002 can run in parallel (Q1 2025)
  - WP-003, WP-004, WP-005, WP-008 can run in parallel once WP-001 completes

═══════════════════════════════════════════════════════════════
TOTAL INVESTMENT AND VALUE SUMMARY
═══════════════════════════════════════════════════════════════

Total investment:          AED [X,XXX,XXX] (across 18 months)
Annual savings (steady state): AED [X,XXX,XXX]/yr (system decommissions + efficiency)
Revenue opportunity:        AED [X,XXX,XXX]/yr (new digital + partner channels)
Payback period:            [X] months from completion
```

---

## 10. Capability Assessment Heat Map

**Purpose:** Visual assessment of current business capability maturity to identify investment priorities. Connects business strategy to architecture work — the red/yellow areas become the scope of the architecture engagement. The heat map tells the "so what" of capability gaps in business language.

**When to use:** Phase B (Business Architecture). Also used in Phase A to justify the scope of the architecture engagement to the Architecture Board and Sponsor. Revisited at programme completion to demonstrate capability improvement.

**Maturity scale (CMMI-inspired):**
| Level | Name | Description |
|---|---|---|
| 1 | Initial | Ad hoc, unpredictable, reactive — depends on heroics |
| 2 | Developing | Some processes defined, inconsistently applied |
| 3 | Defined | Standardised processes, consistently applied across teams |
| 4 | Managed | Measured, managed with data, predictable outcomes |
| 5 | Optimising | Continuous improvement, innovation, industry-leading |

---

### Template

```
CAPABILITY HEAT MAP
═══════════════════════════════════════════════════════════════

Programme:        [Name]
Assessment Date:  [YYYY-MM-DD]
Assessor:         [Name, Role]
Next assessment:  [Date — recommend 6-month cycle]

Maturity Scale: 1=Initial  2=Developing  3=Defined  4=Managed  5=Optimising
Status: 🔴 Red = below target (requires investment)
        🟡 Yellow = within 1 level of target (monitor)
        🟢 Green = at or above target (maintain)

═══════════════════════════════════════════════════════════════
CAPABILITY ASSESSMENT REGISTER
═══════════════════════════════════════════════════════════════

Capability Domain     | Capability                  | Current | Target | Status | Priority | Investment Required
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
CUSTOMER MANAGEMENT
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
Customer Management   | Customer Onboarding          | 2       | 4      | 🔴     | HIGH     | Digital KYC; automated workflows; eSignature
Customer Management   | Customer Analytics           | 1       | 4      | 🔴     | HIGH     | Analytics platform; data science capability
Customer Management   | Customer Engagement          | 3       | 4      | 🟡     | MEDIUM   | Personalisation engine; journey orchestration
Customer Management   | Customer Service (Digital)   | 2       | 4      | 🔴     | HIGH     | Chatbot; self-service portal; case management
Customer Management   | Customer Lifecycle Mgmt      | 2       | 3      | 🔴     | MEDIUM   | Retention models; automated lifecycle triggers
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
PRODUCT MANAGEMENT
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
Product Management    | Product Design & Innovation  | 2       | 3      | 🔴     | MEDIUM   | Design sprints; rapid prototyping; customer testing
Product Management    | Product Configuration        | 2       | 4      | 🔴     | HIGH     | Config-driven product engine; pricing rules engine
Product Management    | Product Pricing              | 4       | 4      | 🟢     | LOW      | At target — maintain
Product Management    | Product Performance Mgmt     | 3       | 4      | 🟡     | MEDIUM   | Product P&L dashboards; real-time reporting
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
RISK MANAGEMENT
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
Risk Management       | Credit Risk Assessment       | 4       | 4      | 🟢     | LOW      | At target — maintain
Risk Management       | Fraud Detection              | 2       | 5      | 🔴     | CRITICAL | Real-time ML fraud models; behavioural analytics
Risk Management       | Regulatory Reporting         | 3       | 4      | 🟡     | MEDIUM   | Automated regulatory report generation
Risk Management       | Operational Risk             | 3       | 3      | 🟢     | LOW      | At target — maintain
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
PAYMENTS & OPERATIONS
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
Payments & Ops        | Payment Processing           | 5       | 5      | 🟢     | LOW      | Industry-leading — protect
Payments & Ops        | Reconciliation               | 2       | 4      | 🔴     | HIGH     | Automated reconciliation engine; real-time matching
Payments & Ops        | Settlement                   | 3       | 4      | 🟡     | MEDIUM   | Same-day settlement capability; ISO 20022 adoption
Payments & Ops        | Treasury Operations          | 3       | 3      | 🟢     | LOW      | At target — maintain
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
TECHNOLOGY CAPABILITIES
──────────────────────|─────────────────────────────|─────────|────────|────────|──────────|─────────────────────────────────────────
Technology            | API Management               | 2       | 4      | 🔴     | HIGH     | API gateway; developer portal; API governance
Technology            | Cloud Operations             | 2       | 4      | 🔴     | HIGH     | Cloud platform; FinOps; IaC; GitOps
Technology            | Data Platform & Analytics    | 1       | 4      | 🔴     | HIGH     | Cloud data platform; data catalog; BI self-serve
Technology            | DevOps / CICD                | 2       | 4      | 🔴     | HIGH     | Pipeline standardisation; automated testing; DORA
Technology            | Security Operations          | 3       | 4      | 🟡     | MEDIUM   | SIEM; automated threat response; zero trust
Technology            | Observability                | 2       | 4      | 🔴     | HIGH     | Centralised logging; distributed tracing; APM

═══════════════════════════════════════════════════════════════
HEAT MAP SUMMARY
═══════════════════════════════════════════════════════════════

Status          | Count | % of capabilities
────────────────|───────|──────────────────
🔴 Below target | 12    | 52%
🟡 Near target  | 5     | 22%
🟢 At target    | 6     | 26%
────────────────|───────|──────────────────
TOTAL           | 23    | 100%

CRITICAL priority (must fix — regulatory/existential risk):
  - Fraud Detection (gap: 3 levels; regulatory finding; financial loss)

HIGH priority (significant business impact or architectural foundation):
  - Customer Analytics, Customer Onboarding, Customer Service (Digital)
  - Product Configuration, Reconciliation
  - API Management, Cloud Operations, Data Platform, DevOps, Observability

Investment prioritisation recommendation:
  1. Fraud Detection (regulatory mandate — non-negotiable)
  2. API Management (architectural foundation — enables all other capabilities)
  3. Data Platform (enables analytics, fraud detection, and product insights)
  4. Customer Onboarding + Customer Analytics (directly drives NPS and digital sales goals)
```

---

## 11. Architecture Contract

**Purpose:** The formal agreement between the Architecture Authority (the architects who defined the architecture) and the implementation team (who must deliver to that architecture). Specifies what compliance means, how it will be verified, and what governance checkpoints exist. Prevents "we didn't know" conversations at go-live.

**When to use:** Phase G (Implementation Governance). One Architecture Contract per project or delivery workstream. Signed before build commences.

**Why it matters:** Without an Architecture Contract, architecture becomes aspirational. With it, architecture becomes a delivery requirement with clear acceptance criteria and a governance structure to verify compliance.

---

### Template

```
ARCHITECTURE CONTRACT
═══════════════════════════════════════════════════════════════

Contract Reference:  ARCH-CONTRACT-[YYYY]-[NNN]
Date:                [YYYY-MM-DD]
Version:             1.0
Status:              Draft | Active | Closed | Dispensation Granted

═══════════════════════════════════════════════════════════════
PARTIES
═══════════════════════════════════════════════════════════════

Architecture Authority:
  Name:            [Chief Architect / Domain Architect name]
  Organisation:    [Architecture function / team]
  Contact:         [Email]

Development Partner:
  Name:            [Project Manager / Technical Lead name]
  Project:         [Project name and reference]
  Contact:         [Email]

Business Sponsor:
  Name:            [Business sponsor name]
  Role:            [Title]
  Contact:         [Email]

═══════════════════════════════════════════════════════════════
ARCHITECTURE SCOPE
═══════════════════════════════════════════════════════════════

This contract governs the following project deliverables:
  Project name:    [e.g., Digital Banking Platform — Mobile App (WP-003)]
  Project scope:   [Brief description of what is being built]

Architecture definition documents in scope:
  - ADD-APP-2024-003: Application Architecture — Digital Platform (v2.1)
  - ADD-TECH-2024-002: Technology Architecture — Digital Platform (v1.8)
  - ADD-DATA-2024-001: Data Architecture — Customer Domain (v1.5)

Applicable standards and principles:
  - Architecture Principles Catalog v3.2 (all principles apply)
  - Standards Information Base v4.1 (technology choices governed by SIB)
  - Security Architecture Standards v2.0 (CISO-approved)
  - API Design Standards v1.4 (OpenAPI 3.0, naming conventions, versioning)

═══════════════════════════════════════════════════════════════
MANDATORY ARCHITECTURE REQUIREMENTS
═══════════════════════════════════════════════════════════════

The following requirements from the Architecture Requirements Specification
are MANDATORY for this project. Non-compliance at go-live = deployment blocked.

ARS-ID  | Requirement                                              | Acceptance Criterion
────────|──────────────────────────────────────────────────────────|────────────────────────────────────────────────
ARS-001 | API response time < 200ms P99                           | Load test report showing P99 < 200ms at 500 RPS
ARS-004 | 99.95% uptime SLA                                       | Architecture review of HA design; DR test results
ARS-007 | All PII encrypted at rest and in transit                | Security scan; penetration test passing
ARS-008 | MFA for all customer-facing authentication              | Auth flow review; no single-factor paths found
ARS-009 | No hard-coded secrets; vault integration required       | SAST scan showing zero credential findings
ARS-010 | OWASP Top 10 addressed                                  | DAST scan report; no critical/high findings
ARS-016 | All APIs follow OpenAPI 3.0 specification               | API gateway validation; spec in source repository
ARS-018 | All deployments via CI/CD pipeline                      | Pipeline demonstrated; no manual deployment steps
ARS-019 | Centralised logging and observability                   | All services visible in observability platform

═══════════════════════════════════════════════════════════════
DELIVERABLES FROM DEVELOPMENT TEAM
═══════════════════════════════════════════════════════════════

Deliverable                        | Description                                       | Acceptance Criteria                    | Due Date
───────────────────────────────────|───────────────────────────────────────────────────|────────────────────────────────────────|──────────────
Architecture Compliance Review Pkg | Design docs demonstrating compliance with ADD     | Domain architect sign-off              | Before build
API Contract Specification         | OpenAPI 3.0 specs for all new/changed APIs        | Peer-reviewed; merged to API repository| Before build
Security Threat Model              | STRIDE threat analysis for new components         | CISO or security architect approved    | Before build
Data Flow Diagram                  | All PII data flows documented                     | DPO review; no undocumented PII flows  | Before build
Architecture Compliance Report     | Self-assessed compliance against this contract    | All MUST requirements compliant        | Pre-go-live
Go-Live Architecture Sign-Off      | Final architecture review + compliance statement  | Architecture Authority signed off      | Before deploy

═══════════════════════════════════════════════════════════════
GOVERNANCE CHECKPOINTS
═══════════════════════════════════════════════════════════════

Checkpoint           | Timing                          | Reviewer                    | Pass Criteria                          | Fail Action
─────────────────────|─────────────────────────────────|-----------------------------|────────────────────────────────────────|───────────────────────────────────────
Design Review        | After technical design complete | Domain Architect            | Compliant assessment; no blocking issues| Blocking issues resolved before build
Pre-Build Review     | Before development commences    | Architecture Board (monthly) | All design review issues closed        | Build does not commence
Security Gate        | After security threat model     | CISO / Security Architect   | Threat model reviewed; no P0 findings  | P0 findings resolved before build
Pre-Deploy Review    | Before production deployment    | Chief Architect             | All mandatory requirements met         | Deployment blocked; dispensation required
Post-Deployment Audit| 30 days after go-live           | Domain Architect            | Runtime compliance confirmed           | Remediation plan agreed within 2 weeks

═══════════════════════════════════════════════════════════════
DISPENSATION PROCESS
═══════════════════════════════════════════════════════════════

If the development team cannot meet a mandatory requirement, a dispensation may
be requested using the following process:

1. Complete Architecture Dispensation Request form (ADR-DISP-template)
2. Document: (a) which requirement; (b) why compliance is not possible;
   (c) proposed compensating controls; (d) plan to achieve compliance
3. Submit to Domain Architect for initial review (5 business days)
4. If approved by Domain Architect, escalate to Architecture Board for ratification
5. Architecture Board decision within 10 business days
6. Dispensation is time-limited (maximum 12 months); includes remediation plan

Dispensations do not remove the requirement — they grant time-limited variance
with compensating controls and a committed remediation date.

═══════════════════════════════════════════════════════════════
CHANGE CONTROL
═══════════════════════════════════════════════════════════════

Changes to this contract:           Both parties must agree in writing
Changes to architecture ADD:        Architecture Board approval; 2-week notice to team
Emergency architecture changes:     Chief Architect approval within 24 hours; retrospective Board review

Architecture change log: Maintained in Architecture Repository [location/URL]

═══════════════════════════════════════════════════════════════
SIGNATURES
═══════════════════════════════════════════════════════════════

Architecture Authority:
  Name:   _________________________________
  Role:   Chief Architect / Domain Architect
  Date:   _____________
  Sign:   _________________________________

Development Partner:
  Name:   _________________________________
  Role:   Project Manager / Technical Lead
  Date:   _____________
  Sign:   _________________________________

Business Sponsor:
  Name:   _________________________________
  Role:   [Title]
  Date:   _____________
  Sign:   _________________________________

Architecture Board (Chair):
  Name:   _________________________________
  Role:   Architecture Board Chair
  Date:   _____________
  Sign:   _________________________________
```

---

## Quick Reference: Which Artifact for Which Question?

| If you need to answer... | Use this artifact |
|---|---|
| "What problem are we solving and why?" | Architecture Vision |
| "What are we contracted to deliver and when?" | Statement of Architecture Work |
| "What does the current and future architecture look like?" | Architecture Definition Document |
| "What must the architecture actually achieve, measurably?" | Architecture Requirements Specification |
| "What needs to change between now and the target?" | Gap Analysis Table |
| "Who cares about this and what do they care about?" | Stakeholder Map |
| "What principles guide our decisions?" | Architecture Principles Catalog |
| "Why did we make this specific technology choice?" | Architecture Decision Record |
| "How do we get from here to there, and when?" | Architecture Roadmap |
| "Which capabilities need investment?" | Capability Heat Map |
| "How do we enforce architecture during implementation?" | Architecture Contract |

---

## ADM Phase → Artifact Mapping

| ADM Phase | Primary Artifacts Produced |
|---|---|
| Phase A — Architecture Vision | Architecture Vision, Statement of Architecture Work, Stakeholder Map |
| Phase B — Business Architecture | Business Architecture ADD, Capability Heat Map, Business Gap Analysis |
| Phase C — Information Systems | Data Architecture ADD, Application Architecture ADD, Data/App Gap Analysis |
| Phase D — Technology Architecture | Technology Architecture ADD, SIB updates, Technology Gap Analysis |
| Phase E — Opportunities & Solutions | Solutions Catalog, Work Packages, initial Architecture Roadmap |
| Phase F — Migration Planning | Architecture Roadmap (detailed), Migration Plan, Transition Architecture definitions |
| Phase G — Implementation Governance | Architecture Contracts, Compliance Assessments, Dispensation Records |
| Phase H — Change Management | Architecture Change Requests, Updated ADDs, Architecture Board decisions |
| Requirements Management | Architecture Requirements Specification (feeds all phases) |
| All phases | Architecture Decision Records (ongoing), Principles Catalog (maintained) |

---

*Part of the TOGAF 10 Mastery Knowledge Base — see parent directory for ADM Cycle, Governance, and Reference Models.*
