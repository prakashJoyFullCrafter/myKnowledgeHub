# TOGAF 10 — Architecture Governance

## Table of Contents
1. [Architecture Governance Overview](#1-architecture-governance-overview)
2. [Architecture Board](#2-architecture-board)
3. [Architecture Compliance Reviews](#3-architecture-compliance-reviews)
4. [Dispensation Process](#4-dispensation-process)
5. [Architecture Principles](#5-architecture-principles)
6. [Architecture Repository](#6-architecture-repository)
7. [Architecture Maturity Models (ACMM)](#7-architecture-maturity-models-acmm)
8. [Governance Framework Integration](#8-governance-framework-integration)
9. [Architecture Decision Records (ADRs)](#9-architecture-decision-records-adrs)
10. [Architecture Contracts](#10-architecture-contracts)

---

## 1. Architecture Governance Overview

### Definition

Architecture Governance is **the practice and orientation by which enterprise architectures and other architectures are managed and controlled at an enterprise-wide level**. It encompasses the processes, roles, responsibilities, and structures that ensure architecture decisions are made consistently, transparently, and in alignment with the organization's strategic intent.

### Purpose

| Purpose                     | Description                                                                                |
|-----------------------------|--------------------------------------------------------------------------------------------|
| Strategic alignment         | Ensure every architecture decision supports business strategy, not just technical taste    |
| Standards enforcement       | Mandate adherence to approved technology, data, and design standards                      |
| Value delivery              | Confirm that investments in architecture translate to measurable business outcomes         |
| Risk management             | Identify architectural risks before they become implementation failures                    |
| Consistency                 | Prevent fragmentation: common patterns, platforms, and interfaces across business units    |
| Decision transparency       | Create an auditable record of why architectural decisions were made and by whom            |

### Governance vs Management

These are often conflated but represent distinct disciplines:

| Dimension         | Governance                                          | Management                                          |
|-------------------|-----------------------------------------------------|-----------------------------------------------------|
| Core activity     | Sets direction, policy, and standards               | Executes within those policies to deliver outcomes  |
| Decision type     | What will be done and why (strategic)               | How it will be done (operational/tactical)          |
| Accountability    | Architecture Board, CIO/CTO sponsors                | Architecture team, project managers, delivery leads |
| Output            | Principles, policies, frameworks, compliance gates  | Architecture artifacts, project deliverables        |
| TOGAF analogy     | Phase H (Architecture Change Management) + Phase G  | Phases A–F of the ADM                               |

### Key Governance Bodies

- **Architecture Board** — primary decision-making body for all architectural matters enterprise-wide
- **Project Architecture Review Board (PARB)** — project-scoped body that reviews individual project architectures against enterprise standards before milestone sign-off
- **Enterprise Architecture (EA) Team** — produces and maintains architectures, supports projects, populates the Architecture Repository
- **Executive Sponsors (CIO/CTO)** — provide the mandate and escalation path for the Architecture Board

---

## 2. Architecture Board

### Role

The Architecture Board is the **primary governance body responsible for architecture oversight**. It provides the authoritative basis for all architectural decision-making at the enterprise level. Its existence transforms architecture from an advisory function into one with real institutional authority.

### Responsibilities

| Responsibility                          | Detail                                                                                                        |
|-----------------------------------------|---------------------------------------------------------------------------------------------------------------|
| Decision authority on architecture      | Final say on enterprise architecture direction, standards adoption, and cross-cutting design decisions        |
| Consistency and principle enforcement   | Ensures all projects and domains adhere to approved architecture principles                                   |
| Dispensation management                 | Grants or denies formal exceptions to architecture standards with defined conditions and expiry dates         |
| Building block approval                 | Reviews and approves new Architecture Building Blocks (ABBs) and Solution Building Blocks (SBBs)             |
| Cross-project conflict resolution       | Adjudicates architectural conflicts between projects or business units                                        |
| Architecture Repository stewardship    | Owns the governance of what enters the Architecture Repository (standards, approved patterns, reference models) |
| Maturity progression                    | Tracks the organization's architecture maturity level and approves improvement roadmaps                       |

### Membership

| Member Type                         | Rationale                                                                 |
|-------------------------------------|---------------------------------------------------------------------------|
| CIO or CTO (sponsor/chair)          | Provides executive mandate; escalation endpoint                           |
| Enterprise Architect (secretary)    | Provides technical depth; prepares agenda and decision papers             |
| Business unit representatives       | Ensure architectural decisions reflect business context and priorities    |
| IT domain leads (infra, security, data, apps) | Bring domain-specific technical expertise                        |
| External advisors (optional)        | Provide independent challenge and industry benchmark perspective          |
| Risk / Compliance (optional)        | Ensure regulatory and risk factors are considered in architecture decisions |

### Architecture Board Charter — Template Outline

A well-formed charter contains the following sections:

```
1. Purpose and Mandate
   - Mission statement of the Architecture Board
   - Organizational authority (who empowers this body)
   - Scope (which architectures, programs, and geographies are covered)

2. Membership and Roles
   - List of named roles (not individuals)
   - Chair, Deputy Chair, Secretary definitions
   - Appointment and rotation process

3. Decision Rights
   - What the Board can decide unilaterally
   - What requires escalation to CIO/CTO or Board of Directors
   - Delegated authority thresholds (e.g., dispensations below a certain risk score)

4. Quorum and Voting
   - Minimum attendance for valid decisions
   - Voting rules (majority, supermajority, consensus)
   - Tie-breaking mechanism

5. Meeting Cadence and Process
   - Regular meeting frequency (e.g., monthly)
   - Process for emergency out-of-cycle decisions
   - Agenda management and submission deadlines

6. Dispensation Process
   - Criteria for dispensation eligibility
   - Assessment process and timelines
   - Conditions and expiry requirements

7. Escalation Path
   - Path for decisions the Board cannot resolve
   - Process for appealing Board decisions

8. Reporting
   - What the Board reports to executive sponsors
   - Frequency and format of board reports
   - Metrics and KPIs tracked

9. Review and Amendment
   - Charter review schedule
   - Process for amending the charter
```

### Reporting Line

The Architecture Board reports to CxO-level sponsorship — typically the CIO or CTO. This reporting relationship is not ceremonial: it provides the Board with the authority to override project decisions and enforce standards even when individual project sponsors resist.

---

## 3. Architecture Compliance Reviews

### Purpose

Architecture Compliance Reviews ensure that **implementation projects conform to approved Target Architectures and architecture standards**. They are the mechanism through which governance transforms from policy into practice.

### When Reviews Occur

Compliance reviews are conducted at defined project milestones:

| Milestone                  | Review Focus                                                                        |
|----------------------------|-------------------------------------------------------------------------------------|
| Design review              | Verify the design aligns with approved patterns, technology standards, and data models |
| Build / development review | Check that implementation choices (libraries, frameworks, APIs) match approved SBBs  |
| Pre-deployment review      | Final compliance assessment before production sign-off                             |
| Post-implementation review | Confirm what was built matches what was approved; identify any drift                |

### Compliance Levels (TOGAF 10)

TOGAF 10 defines six compliance levels:

| Level                | Definition                                                                                        |
|----------------------|---------------------------------------------------------------------------------------------------|
| **Irrelevant**       | Architecture has no bearing on this specific implementation area                                  |
| **Consistent**       | No conflict with approved architecture, but does not actively implement or support it             |
| **Compliant**        | Meets all mandatory architecture requirements                                                     |
| **Conformant**       | Meets all mandatory requirements AND all recommended requirements; actively supports architecture  |
| **Fully Conformant** | Exemplary architecture conformance; demonstrates best practice implementation of architecture     |
| **Non-Conformant**   | Violates one or more mandatory architecture requirements; requires dispensation or remediation     |

Achieving "Conformant" is the standard goal. "Fully Conformant" is aspirational and may be cited as an exemplar pattern for other projects.

### Review Process

```
1. Request submission
   - Project team submits architecture review request to EA team
   - Include: design documents, technology choices, data model, security design

2. Checklist review
   - EA team maps project artifacts against Architecture Principles, SIB standards, and Target Architecture

3. Compliance assessment
   - EA team produces a compliance assessment assigning one of the six levels per area
   - Areas: application design, data, integration, security, infrastructure, technology choices

4. Review meeting
   - Project team presents; EA team and Architecture Board members challenge

5. Compliance report
   - Formal report issued with compliance level per dimension
   - Non-compliant areas listed with specific standard violated

6. Outcome
   - Compliant/Conformant: approval to proceed
   - Non-Conformant: either remediate or submit dispensation request
```

### Artifacts Reviewed

- High-level and low-level design documents
- Technology stack choices (languages, frameworks, databases, message brokers)
- Data models and entity definitions
- Integration patterns and API contracts
- Security design (authentication, authorization, encryption, network zones)
- Infrastructure and deployment topology

---

## 4. Dispensation Process

### Definition

A dispensation is a **formal exception to architecture standards**, granted by the Architecture Board, that permits a project to deviate from mandatory requirements for a defined period and under specific conditions. A dispensation is not a free pass — it is a controlled, time-bounded, recorded exception.

### When to Seek a Dispensation

| Scenario                            | Example                                                                          |
|-------------------------------------|----------------------------------------------------------------------------------|
| Technical impracticality            | Approved integration standard cannot support required throughput within timeline |
| Excessive cost                      | Migrating to standard database platform would cost 3x more than project budget   |
| Time constraint                     | Compliance requires 6 months refactor; product launch is in 8 weeks             |
| Acquired system                     | M&A brings in a platform that does not meet current enterprise standards        |
| Vendor lock-in necessity            | Only viable vendor solution uses a non-standard technology                       |

### Dispensation Request Contents

A dispensation request must include:

| Field                        | Description                                                                         |
|------------------------------|-------------------------------------------------------------------------------------|
| Project details              | Name, sponsor, scope, timeline, business impact                                     |
| Standard(s) being deviated   | Exact reference to the architecture principle, standard, or SIB entry being waived |
| Deviation description        | Precisely what will differ from the approved standard                               |
| Business justification       | Why compliance is impractical or disproportionate in this case                      |
| Risk assessment              | Technical and business risks introduced by the deviation                            |
| Mitigating controls          | Compensating measures to reduce the identified risks                                |
| Remediation plan             | How and when full compliance will be achieved (with target date)                    |

### Board Assessment Criteria

The Architecture Board evaluates each dispensation request against:

- **Architecture integrity risk** — does this deviation set a precedent that undermines the architecture's coherence?
- **Business impact** — what is the cost of not granting the dispensation?
- **Precedent risk** — if granted, will many other projects cite this as justification for similar deviations?
- **Remediation credibility** — is the remediation plan realistic, funded, and accountable?

### Possible Outcomes

| Outcome                | Description                                                                             |
|------------------------|-----------------------------------------------------------------------------------------|
| Granted unconditionally| Rare; only when risk is negligible                                                      |
| Granted with conditions| Most common; conditions may include monitoring, reporting, mandatory remediation date   |
| Denied                 | Project must achieve compliance or be descoped                                          |
| Deferred               | Board needs more information before deciding                                            |

### Critical Rule: Dispensations are NOT Permanent

Every dispensation must have:
- A defined **expiry date** or **review date**
- A named **owner** within the project team accountable for remediation
- An entry in the **Dispensation Register** in the Architecture Repository

When the expiry date arrives, the project must either demonstrate compliance or submit a renewal with updated justification.

---

## 5. Architecture Principles

### Definition

Architecture Principles are **general rules and guidelines that inform and support how an organization fulfills its mission**. They represent fundamental beliefs about how the organization wants to use and manage IT. They are normative: they tell decision-makers what they should do, not just what they can do.

### Five Qualities of Good Principles (TOGAF)

| Quality           | Description                                                                               |
|-------------------|-------------------------------------------------------------------------------------------|
| **Understandable**| The principle is expressed in plain language; all stakeholders grasp the intent           |
| **Robust**        | The principle enables unambiguous decisions when applied to specific situations            |
| **Complete**      | The set of principles covers all situations that may arise in governing the architecture  |
| **Consistent**    | Principles do not contradict each other                                                   |
| **Stable**        | Principles are durable; they can accommodate change through interpretation, not rewriting |

### Structure of a Principle

Each principle is documented with four components:

| Component       | Description                                                                                 |
|-----------------|---------------------------------------------------------------------------------------------|
| **Name**        | A short, memorable noun phrase (e.g., "Data is an Asset")                                  |
| **Statement**   | One or two sentences clearly stating the rule                                               |
| **Rationale**   | Why this principle is important to the organization; business context                       |
| **Implications**| What must change in behavior, process, or technology to honor this principle               |

### Example Principles by Domain

#### Business Principles

| Name                              | Statement                                                                                         |
|-----------------------------------|---------------------------------------------------------------------------------------------------|
| Primacy of Principles             | Architecture principles take precedence over project-specific decisions when conflicts arise      |
| Maximize Benefit to the Enterprise| Architecture decisions are made to maximize benefit at the enterprise level, not the unit level   |
| Business Continuity               | Enterprise operations are maintained in spite of system interruptions                             |
| Common Use Applications           | Development of applications used across the enterprise is preferred over duplicated capability    |

#### Data Principles

| Name                  | Statement                                                                                              |
|-----------------------|--------------------------------------------------------------------------------------------------------|
| Data is an Asset      | Data is a valued enterprise resource; it is managed, has an owner, and is the basis for decisions     |
| Data is Shared        | Users of data share data via single authoritative sources rather than holding local copies            |
| Data Trustee          | Each data element has a designated trustee accountable for data quality and access control            |
| Data Accessibility    | Data is accessible to authorized users and applications without barriers                             |

#### Application Principles

| Name                      | Statement                                                                                           |
|---------------------------|-----------------------------------------------------------------------------------------------------|
| Technology Independence   | Applications are independent of specific hardware and OS choices wherever practical                 |
| Ease-of-Use               | Applications are designed to be easy to use, hiding underlying technology complexity from end users  |
| Responsive to Change      | Applications are designed to accommodate change to business processes without wholesale replacement  |

#### Technology Principles

| Name                          | Statement                                                                                                |
|-------------------------------|----------------------------------------------------------------------------------------------------------|
| Requirements-Based Change     | Technology changes are made only when they meet an identified and approved business or technical need   |
| Responsive Change Management  | Changes to the technology environment are implemented in a timely manner                               |
| Control Technical Diversity   | Proliferation of different technologies is minimized to reduce complexity and support costs            |
| Interoperability              | Software and hardware should conform to defined standards that promote interoperability                 |

---

## 6. Architecture Repository

### Role in Governance

The Architecture Repository is the **single source of truth for all approved architecture assets**. In the context of governance, it is not just a document store — it is the operational backbone of the governance process: every governance decision, dispensation, compliance assessment, and approved standard has a home in the repository.

### Governance Log

The Governance Log is the section of the Architecture Repository that records governance activity:

| Register                  | Contents                                                                                              |
|---------------------------|-------------------------------------------------------------------------------------------------------|
| **Decision Log**          | All Architecture Board decisions with date, attendees, rationale, and outcome                        |
| **Compliance Assessments**| Results of all compliance reviews with compliance level assigned per dimension                        |
| **Dispensation Register** | All active dispensations: project, deviation, conditions, expiry date, remediation owner             |
| **Architecture Contracts**| Signed contracts between architecture team and delivery teams/sponsors                               |
| **Waiver Register**       | Minor waivers below dispensation threshold, tracked separately for pattern analysis                   |

### Standards Information Base (SIB)

The SIB is the authoritative catalog of:
- Approved technology products, versions, and end-of-life dates
- Approved integration standards (e.g., REST over HTTP/2, OAuth 2.0 for auth)
- Prohibited technologies (products no longer approved for new development)
- Strategic (invest), tactical (tolerate), and sunset (eliminate) classifications per product

Projects must demonstrate alignment with the SIB during compliance reviews. Any deviation from the SIB requires a dispensation.

### Repository Structure (Governance Perspective)

```
Architecture Repository
├── Architecture Landscape
│   ├── Strategic Architecture
│   ├── Segment Architecture
│   └── Capability Architecture
├── Standards Information Base (SIB)
├── Reference Library
│   ├── Architecture Patterns
│   ├── Reference Models
│   └── Industry Standards
├── Governance Log
│   ├── Decision Log
│   ├── Compliance Assessment Register
│   ├── Dispensation Register
│   ├── Architecture Contracts Register
│   └── Waiver Register
└── Architecture Capability
    ├── Maturity Assessments
    └── Improvement Roadmaps
```

---

## 7. Architecture Maturity Models (ACMM)

### Overview

The Architecture Capability Maturity Model (ACMM) provides a structured way to assess how mature an organization's architecture practice is. TOGAF defines six maturity levels. Knowing your current level enables a targeted improvement roadmap rather than generic best-practice adoption.

### Six Maturity Levels

| Level | Name                  | Description                                                                                                  |
|-------|-----------------------|--------------------------------------------------------------------------------------------------------------|
| **0** | None                  | No architecture practice exists. Technology decisions are made ad hoc without any architectural consideration |
| **1** | Initial               | Ad hoc, unpredictable process. Some architecture activity occurs but it is informal, undocumented, and individual-dependent |
| **2** | Under Development     | Architecture process is being defined. Inconsistently applied across projects. Governance is emerging but not yet enforced |
| **3** | Defined               | Architecture process is documented and standardized. Governance in place. Architecture Board exists and functions. Principles are published |
| **4** | Managed               | Architecture process is measured and controlled. Quantitative management: metrics tracked, compliance rates measured, maturity reviewed periodically |
| **5** | Optimizing            | Continuous improvement of architecture processes. Innovation is embedded. Architecture proactively drives business change rather than reacting to it |

### Key Insight: Most Organizations Are at Level 2-3

Level 3 is the minimum viable governance state. Level 4 and 5 require sustained investment, executive commitment, and cultural change. Organizations that skip from Level 1 to attempting Level 4 typically fail because governance without foundational process is theater.

### Assessment Dimensions

A complete ACMM assessment evaluates maturity across five dimensions:

| Dimension                    | What is Assessed                                                                      |
|------------------------------|---------------------------------------------------------------------------------------|
| Architecture Process         | Is the ADM or equivalent process formally defined and followed?                       |
| Architecture Development     | Are architecture artifacts (business, data, application, technology) produced consistently? |
| Architecture Linkage         | Are architectures linked to strategy, projects, and operations?                       |
| Architecture Governance      | Does the Architecture Board function? Are compliance reviews conducted?               |
| IT Security                  | Is security embedded in architecture practice, not bolted on?                         |

### How to Use the ACMM

```
Step 1 — Baseline Assessment
  Score each dimension at the current maturity level.
  Use evidence: artifacts, meeting minutes, compliance reports, not self-assessment alone.

Step 2 — Target State Definition
  Determine the appropriate target maturity level for the organization's strategic context.
  Not every organization needs Level 5. Level 3-4 is often the right target.

Step 3 — Gap Analysis
  Identify specific capability gaps between baseline and target.
  Example: "Architecture Board exists (Level 3) but no metrics tracked (gap to Level 4)"

Step 4 — Improvement Roadmap
  Prioritized initiatives to close identified gaps.
  Each initiative: owner, timeline, success criteria, dependencies.

Step 5 — Reassessment
  Periodically reassess (annually or after major organizational change).
  Track progression through the roadmap.
```

---

## 8. Governance Framework Integration

### COBIT 2019 Integration

**COBIT** (Control Objectives for Information and Related Technologies) is the business-focused IT governance framework published by ISACA. While TOGAF focuses on architecture, COBIT addresses the broader governance and management of enterprise IT.

| TOGAF Element                    | COBIT 2019 Equivalent / Integration Point                                            |
|----------------------------------|--------------------------------------------------------------------------------------|
| Architecture Board               | COBIT governance bodies (Board-level IT governance structures)                       |
| Architecture Principles          | COBIT policies and procedures                                                        |
| ADM Phase A (Architecture Vision)| APO02 — Managed Strategy                                                             |
| Architecture Compliance Reviews  | APO03 — Managed Enterprise Architecture (direct alignment)                           |
| Architecture Repository          | APO03 artifacts; BAI03 managed solutions identification                              |
| Dispensation Register            | MEA01 — Managed Performance and Conformance Monitoring                               |

**APO03 (Managed Enterprise Architecture)** is the COBIT process that most directly mirrors TOGAF governance. APO03 defines the IT management objective: maintain a common enterprise architecture to realize cross-domain synergies and enable agile, reliable, and efficient IT delivery.

**Integration approach:**
- Use COBIT to answer "are we governing IT well?" at an executive level
- Use TOGAF to answer "are we building the right architecture?" at the practitioner level
- The Architecture Board satisfies both frameworks' requirements for a governance decision-making body

### ITIL 4 Integration

**ITIL 4** is the IT service management (ITSM) framework. It governs how IT services are designed, delivered, and supported. TOGAF and ITIL 4 complement each other across the architecture-to-operations lifecycle.

| TOGAF Element                        | ITIL 4 Integration Point                                                              |
|--------------------------------------|---------------------------------------------------------------------------------------|
| Technology Architecture (Phase D)    | ITIL service design: infrastructure and platform services                             |
| Phase G (Implementation Governance)  | ITIL change enablement and release management practices                               |
| Architecture Repository              | ITIL Configuration Management Database (CMDB) — architecture artifacts inform CI records |
| Architecture Contracts               | ITIL service level agreements and underpinning contracts                             |
| SIB (Standards Information Base)     | ITIL service catalog and technology lifecycle management                              |

**Key integration principle:** TOGAF creates the architectural blueprint; ITIL 4 operationalizes it. An architecture that is designed without ITIL considerations is likely to be unmanageable in production. An ITSM practice that operates without architectural guidance will accumulate technical debt.

---

## 9. Architecture Decision Records (ADRs)

### Purpose

ADRs capture **significant architectural decisions with the context that led to them and the consequences of making them**. They are the institutional memory of the architecture. Without ADRs, organizations repeat past mistakes, lose the rationale behind design choices, and struggle to onboard new architects.

ADRs are stored in the Architecture Repository (Governance Log) and form part of the auditable record of the Architecture Board's work.

### Standard ADR Structure

| Field                     | Description                                                                              |
|---------------------------|------------------------------------------------------------------------------------------|
| **Title**                 | Short noun phrase identifying the decision (e.g., "API Gateway pattern for external integrations") |
| **Status**                | Proposed / Accepted / Deprecated / Superseded                                            |
| **Context**               | The situation, constraint, or requirement that forced this decision to be made           |
| **Decision**              | A clear statement of what was decided                                                    |
| **Rationale**             | Why this option was chosen over the alternatives                                         |
| **Consequences**          | What happens as a result: positive outcomes, negative trade-offs, and follow-on decisions triggered |
| **Alternatives Considered**| Options evaluated and the reason each was rejected                                     |

### ADR Lifecycle

```
Proposed
  → Reviewed by Architecture Board (or delegated architect)
  → Accepted (becomes binding for the architecture)
  → [Time passes, context changes]
  → Deprecated (decision no longer applies) OR
  → Superseded (replaced by a newer ADR that references this one)
```

When an ADR is superseded, the new ADR must reference the original to preserve the decision history chain.

### Example ADR: Microservices vs Monolith for Customer Platform

```
Title: Customer Platform — Microservices vs Modular Monolith

Status: Accepted

Context:
  The customer platform requires independent scaling of the product search, 
  checkout, and account management capabilities. The team has 8 developers. 
  The existing monolith has 500K lines of code with no service boundaries.

Decision:
  Adopt a Modular Monolith architecture for the initial platform, with 
  well-defined module boundaries designed for future extraction to services.

Rationale:
  - Team size (8 developers) is below the threshold at which microservices 
    operational overhead provides net positive returns.
  - We cannot justify the Kubernetes, service mesh, distributed tracing, 
    and inter-service communication overhead at current scale.
  - Modular Monolith with clearly defined bounded contexts preserves the 
    option to extract services when team and traffic scale warrants.

Consequences:
  Positive: lower operational complexity, faster initial delivery, 
            reduced infrastructure cost.
  Negative: horizontal scaling requires scaling the whole application; 
            module boundary discipline must be actively enforced.
  Follow-on: ADR required for module boundary enforcement tooling.

Alternatives Considered:
  1. Full microservices from Day 1 — rejected due to operational overhead 
     disproportionate to team and traffic scale.
  2. Retain existing monolith — rejected as existing codebase lacks module 
     boundaries and cannot be safely evolved.
```

---

## 10. Architecture Contracts

### Definition

An Architecture Contract is a **joint agreement between development partners and sponsors on the deliverables, quality, and fitness-for-purpose of the architecture**. It makes architects formally accountable — not just advisory — in the delivery lifecycle.

TOGAF uses Architecture Contracts in **Phase G (Implementation Governance)** as the primary mechanism for ensuring that what gets built matches what was architected.

### Types of Architecture Contracts

| Type                            | Parties                                   | Focus                                                        |
|---------------------------------|-------------------------------------------|--------------------------------------------------------------|
| Architecture Contract           | Architecture team ↔ Development team      | Architectural deliverables, compliance checkpoints, sign-off |
| Business Footprint Contract     | Business stakeholders ↔ IT               | Business outcomes, capability delivery, fitness criteria     |
| Partner/Supplier Contract       | Architecture team ↔ External supplier     | Third-party compliance with enterprise architecture standards |

### Contract Content

A well-formed Architecture Contract includes:

| Section                   | Content                                                                                         |
|---------------------------|-------------------------------------------------------------------------------------------------|
| Parties                   | Named signatories and their roles                                                               |
| Scope                     | Architectural scope covered by this contract (domains, systems, boundaries)                    |
| Architecture Deliverables | List of architecture artifacts the architecture team will produce                              |
| Acceptance Criteria       | Measurable criteria the delivered solution must meet (compliance level, performance, security) |
| Governance Checkpoints    | Defined review milestones with pass/fail criteria                                              |
| Non-Conformance Procedure | What happens when a checkpoint is not met: escalation, dispensation, remediation             |
| Change Procedure          | How changes to the contract are proposed, assessed, and approved                               |
| Sign-Off Process          | Who signs off at each milestone; who has authority to close the contract                       |

### Why Architecture Contracts Matter

Without contracts, architects issue recommendations that delivery teams are free to ignore. The contract transforms the architecture function:

- **Before contracts**: Architecture is advisory. Projects comply when convenient.
- **After contracts**: Architecture has formal accountability. Non-compliance has defined consequences.

This shift is fundamental to operating at ACMM Level 3 and above. A governance program without Architecture Contracts is governance by persuasion, not governance by structure.

### Phase G and Architecture Contracts

In the TOGAF ADM, Phase G (Implementation Governance) is where Architecture Contracts are activated and monitored:

```
Phase G Activities:
  1. Confirm the Architecture Contract for each project in the implementation program
  2. Monitor compliance at each defined checkpoint
  3. Issue compliance assessments (the six compliance levels)
  4. Manage dispensation requests from non-compliant projects
  5. Update the Architecture Repository with all governance records
  6. Report to the Architecture Board on program-wide compliance status
```

---

## Quick Reference: Governance Artifacts Summary

| Artifact                       | Produced By              | Stored In             | Purpose                                            |
|--------------------------------|--------------------------|-----------------------|----------------------------------------------------|
| Architecture Principles        | EA Team + Board          | Architecture Repository | Normative rules for all architectural decisions  |
| Compliance Assessment Report   | EA Team                  | Governance Log        | Documents compliance level of a project at a milestone |
| Dispensation Request           | Project Team             | Dispensation Register | Formal request for exception to a standard        |
| Architecture Decision Record   | Architect                | Governance Log        | Captures context, decision, and rationale         |
| Architecture Contract          | Architecture Team + PM   | Contracts Register    | Binding agreement on architecture deliverables    |
| Standards Information Base     | EA Team + Board          | Architecture Repository | Approved products, technologies, and standards   |
| Architecture Board Minutes     | Board Secretary          | Decision Log          | Auditable record of board decisions               |

---

## Key Exam Concepts (TOGAF 10)

- The Architecture Board is the **primary governance body** — it has decision authority, not just advisory authority.
- Compliance levels go from Irrelevant → Consistent → Compliant → Conformant → Fully Conformant, with Non-Conformant as the failure state.
- Dispensations are **time-bounded** — they always have an expiry date and a remediation obligation.
- Architecture Principles must satisfy five TOGAF qualities: Understandable, Robust, Complete, Consistent, Stable.
- Each principle has four parts: Name, Statement, Rationale, Implications.
- ACMM Level 3 (Defined) is the minimum for a functioning governance program; Level 4 adds quantitative measurement.
- Phase G (Implementation Governance) is where Architecture Contracts are activated and compliance is monitored.
- The Architecture Repository is the single source of truth: it contains both architecture content and the governance record (decisions, dispensations, compliance reports, contracts).
