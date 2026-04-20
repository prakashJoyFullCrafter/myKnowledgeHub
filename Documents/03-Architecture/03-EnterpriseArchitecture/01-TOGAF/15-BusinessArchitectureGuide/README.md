# TOGAF 10 — Business Architecture Series Guide

> **Domain**: Enterprise Architecture | **Standard**: TOGAF 10 | **Series Guide**: Business Architecture
> **Alignment**: BIZBOK (Business Architecture Guild) | **ADM Phase**: Primarily Phase B (with inputs to all phases)

---

## What is the Business Architecture Series Guide?

- TOGAF 10 elevated Business Architecture from a single ADM phase (Phase B) into a full **Series Guide**
- Reason: Business Architecture is the **most critical domain** — it drives all other domains
- The **Business Architecture Guild (BIZBOK)** principles are aligned with this guide
- Focus: translating **business strategy into architectural models** that drive Data, Application, and Technology decisions
- Without a solid Business Architecture, the downstream domains (Data, Application, Technology) lack grounding in business intent

---

## Business Motivation Model (BMM)

The BMM provides a framework for understanding **WHY** an organization does what it does.

### BMM Structure (Object Management Group standard)

```
ENDS (what we want)              MEANS (how we get there)
├── Vision                       ├── Mission
├── Goals                        ├── Strategy
├── Objectives (measurable)      ├── Tactics (specific actions)
└── Desired Results              └── Business Policies
                                     └── Business Rules
```

### BMM Elements Defined

**Ends — what the organization wants to achieve:**

- **Vision**: An overall image of what the organization wants to be (not measurable) — "Be the most customer-centric bank in the region"
- **Goal**: A statement of long-term purpose (not directly measurable) — "Achieve market leadership in digital banking"
- **Objective**: A measurable target supporting a goal — "Achieve 40% digital sales penetration by Q4 2025"
- **Desired Result**: An outcome or achievement that fulfills goals

**Means — how the organization will achieve its ends:**

- **Mission**: What the organization does every day — "Provide financial services to individuals and SMEs in the UAE"
- **Strategy**: A component of a plan; an approach to achieve goals — "Invest in mobile-first platform to capture digital-native customers"
- **Tactic**: A specific action that implements a strategy — "Launch redesigned mobile app with instant account opening by Q2 2025"
- **Business Policy**: A non-actionable rule that guides decisions — "Customer data must not leave UAE jurisdiction"
- **Business Rule**: A specific actionable statement — "Loan applications above AED 500,000 require senior credit officer approval"

### BMM in TOGAF ADM

| ADM Phase | BMM Role |
|---|---|
| Preliminary Phase | Establish BMM as the motivation framework for the enterprise |
| Phase A (Architecture Vision) | Architecture goals trace directly to business goals in BMM |
| Phase B (Business Architecture) | Business capabilities trace to BMM objectives |
| Phase E/F (Implementation Planning) | Tactics and business rules inform migration planning |

**Traceability chain:**
- Business Rule → Business Policy → Strategy → Goal → Vision (upward — justification)
- Vision → Goal → Objective → Strategy → Tactic → Business Rule (downward — decomposition into architecture)

### Example BMM — Digital Banking Transformation

```
Vision:    "Be the digital bank of choice for UAE residents"
  └─ Goal: "Grow retail customer base by 25% in 2 years"
       └─ Objective: "Onboard 50,000 new digital-only customers by Dec 2025"
            └─ Strategy: "Launch fully digital, no-branch account opening"
                  └─ Tactic: "Deploy eKYC with UAE Pass integration by Q1 2025"
                        └─ Business Rule: "eKYC must comply with CBUAE Open Finance guidelines"
```

---

## Value Streams

### What is a Value Stream?

- An **end-to-end set of activities** that an enterprise performs to deliver value to a stakeholder (customer, partner, regulator)
- Borrowed from **Lean manufacturing** (Toyota Production System); adapted for EA
- Value streams are **STABLE** like capabilities — they describe *what* value is delivered, not *how* processes work
- Every value stream has a **triggering event** (what initiates it) and a **value item** (what the stakeholder receives)

### Value Stream vs. Business Process

| Aspect | Value Stream | Business Process |
|---|---|---|
| Purpose | Describes value delivered to a stakeholder | Describes how work is performed |
| Stability | Stable — changes slowly | Volatile — changes with operational improvements |
| Perspective | Outside-in (stakeholder perspective) | Inside-out (organizational perspective) |
| Level | Strategic/conceptual | Operational/tactical |
| Used for | Architecture scoping, capability alignment | Process improvement, system design |
| Example | "Customer Lending Value Stream" | "Credit application intake process" |

### Value Stream Stages

Each value stream has **stages** — discrete activities that collectively deliver the value.

**Example: Customer Lending Value Stream**

```
Stage 1: Loan Discovery    → Customer finds and understands loan options
Stage 2: Application       → Customer submits application and documents
Stage 3: Assessment        → Bank assesses creditworthiness and risk
Stage 4: Approval/Decline  → Decision communicated to customer
Stage 5: Disbursement      → Funds released to customer
Stage 6: Servicing         → Ongoing repayment management
Stage 7: Closure           → Loan fully repaid; relationship maintained
```

Each stage has:
- **Value Item**: What the stakeholder receives from this stage
- **Triggering Event**: What starts this stage
- **Entry Criteria**: What must be true before this stage begins
- **Exit Criteria**: What must be true before moving to next stage
- **Participating Capabilities**: Which business capabilities execute this stage

### Value Stream Mapping to Capabilities

A key Business Architecture deliverable is linking value stream stages to capabilities and identifying maturity gaps:

| Value Stream Stage | Participating Capabilities | Gap / Maturity Issue |
|---|---|---|
| Application | Digital Onboarding, Document Collection | RED — Manual, paper-based — major gap |
| Assessment | Credit Scoring, Fraud Detection | YELLOW — Batch only — needs real-time |
| Approval | Decision Management | GREEN — Automated rules engine in place |
| Disbursement | Payment Processing | GREEN — Strong capability |
| Servicing | Customer Self-Service | RED — No self-service portal exists |

---

## Business Capability Mapping (Deep Dive)

### Capability Definition (BIZBOK)

> "A particular ability or capacity that a business may possess or exchange to achieve a specific purpose or outcome."

### Characteristics of a Business Capability

| Characteristic | Explanation |
|---|---|
| Stable | Capabilities don't change when processes or systems change |
| Outcome-focused | Defined by what it delivers, not how it is executed |
| Technology-agnostic | The same capability can be delivered by different technologies |
| Hierarchical | Decomposes into sub-capabilities for increasing detail |
| Assessable | Can be rated for current and target maturity |
| Business-owned | A business person is accountable for each capability |

### Building a Business Capability Map — Step by Step

1. **Scope**: Define enterprise boundaries (which business units are in scope)
2. **Level 1 domains**: Identify 6–12 top-level capability domains (Customer Management, Product Management, Risk, Operations, Finance, etc.)
3. **Level 2 capabilities**: For each domain, identify 4–8 capabilities
4. **Level 3 sub-capabilities**: Decompose only where needed for project-level work
5. **Validate**: Workshop with business leads to confirm accuracy and completeness
6. **Heat map**: Rate current maturity (1–5) and flag gaps vs strategic requirements

### Capability Attributes (what to capture per capability)

| Attribute | Description | Example |
|---|---|---|
| Name | Short noun phrase | "Real-Time Fraud Detection" |
| Description | What outcome this capability delivers | "Detect and prevent fraudulent transactions in real-time using ML models" |
| Current Maturity | 1–5 rating | 2 (Developing) |
| Target Maturity | Required maturity level | 5 (Optimizing) |
| Strategic Importance | High / Medium / Low | High |
| Owner | Business owner of this capability | Head of Fraud and Risk |
| Enabling Applications | Systems that support this capability | Fraud detection platform, transaction monitoring |
| Enabling Data | Data required | Transaction data, device fingerprints, behavioral biometrics |

### Capability Maturity Scale (CMM-aligned)

| Level | Label | Description |
|---|---|---|
| 1 | Initial | Ad hoc; unpredictable; no defined process |
| 2 | Developing | Basic processes exist but inconsistently applied |
| 3 | Defined | Standardized and documented processes |
| 4 | Managed | Measured and controlled; data-driven management |
| 5 | Optimizing | Continuous improvement; innovation embedded |

### Capability Levels and Decomposition

```
Level 1 (Domain):    Risk Management
Level 2 (Capability): Credit Risk | Fraud Detection | Operational Risk | Compliance Reporting
Level 3 (Sub-cap):    Fraud Detection →
                         Real-Time Transaction Scoring
                         Device Fingerprinting
                         Behavioral Analytics
                         Case Management
```

### Sample Business Capability Map — Banking Enterprise

```
+--------------------+--------------------+--------------------+--------------------+
| CUSTOMER MGMT      | PRODUCT MGMT       | RISK MGMT          | FINANCE            |
|--------------------|--------------------|--------------------|--------------------+
| Customer Acq.      | Product Design     | Credit Risk        | Financial Planning  |
| KYC / Onboarding   | Product Pricing    | Fraud Detection    | Revenue Management  |
| Relationship Mgmt  | Portfolio Mgmt     | Operational Risk   | Regulatory Finance  |
| Customer Analytics | Product Compliance | Compliance Rptg    | Cost Management     |
+--------------------+--------------------+--------------------+--------------------+
| OPERATIONS         | TECHNOLOGY         | CHANNELS           | HR & WORKFORCE     |
|--------------------|--------------------|--------------------|--------------------+
| Loan Origination   | IT Infrastructure  | Digital Channels   | Talent Acquisition  |
| Payment Processing | Application Mgmt   | Branch Network     | Learning & Dev      |
| Trade Finance      | Data Management    | Call Centre        | Workforce Planning  |
| Reconciliation     | Cybersecurity      | Partner / API      | Performance Mgmt    |
+--------------------+--------------------+--------------------+--------------------+
```

---

## Organization Map

### Business Architecture Organization Models

- **Organization Chart**: Legal and reporting structure (who reports to whom)
- **Business Capability Owner Map**: Who is accountable for each capability (not the same as org chart — one person may own capabilities across multiple org units)
- **RACI Matrix**: Responsible, Accountable, Consulted, Informed for key business processes
- **Actor/Role Catalog**: All roles that interact with or perform business functions

### Actor vs. Role in TOGAF

| Concept | Definition | Example |
|---|---|---|
| Actor | A business entity (person, org, system) that performs a role | "Branch Manager", "Mobile Banking App" |
| Role | A named behavior context assigned to an actor in a given situation | "Loan Approver", "Customer Authenticator" |

- One actor can play **multiple roles** (a Branch Manager may be both a Loan Approver and a KYC Reviewer)
- One role can be played by **multiple actors** (any authorized officer can play the Loan Approver role)

---

## Information Concepts (Business Layer Data)

Business Architecture identifies key **Business Objects** — the information the business cares about at a conceptual level, before Data Architecture formalizes them.

### Common Business Objects — Banking Example

- Customer, Account, Product, Transaction, Policy, Claim, Employee, Contract, Asset, Party, Event, Channel, Limit

### Business Object vs. Data Entity

| Dimension | Business Object | Data Entity |
|---|---|---|
| Definition | Business concept | Technical realization |
| Example | "Customer" | CUSTOMER table |
| Named by | Business stakeholders | Data architects |
| Technology | Technology-agnostic | Technology-specific |
| Architecture layer | Business Architecture | Data Architecture |
| ADM Phase | Defined in Phase B | Formalized in Phase C (Data) |

---

## Business Architecture Deliverables (Phase B)

| Deliverable | Description | Format |
|---|---|---|
| Business Capability Map | Full hierarchy with maturity ratings | Heat map table / diagram |
| Value Stream Catalog | List of value streams with stages | Structured catalog |
| Value Stream / Capability Matrix | Which capabilities enable which value stream stages | Matrix |
| Business Motivation Model | Vision → Goal → Objective → Strategy chain | Diagram / table |
| Organization Map | Business units, actors, roles, accountability | Diagram |
| Business Principles | Agreed principles guiding business decisions | Principles catalog |
| Business Requirements Specification | Measurable business requirements | Structured catalog |
| Business Architecture Gap Analysis | Baseline vs. target capabilities | Gap analysis table |
| Business Object / Concept Catalog | Key business information entities | Catalog |
| RACI Matrix | Accountability for key capabilities and processes | Matrix |

---

## Connecting Business Architecture to Other Domains

The flow of architecture requirements downstream:

```
BMM (Vision / Goals / Strategy)
        |
        v
Business Capabilities (what the business needs to do)
        |
        v
Value Streams (how value is delivered end-to-end)
        |
        v
Data Requirements (what information is needed per capability / value stream stage)
        |      [Phase C — Data Architecture]
        v
Application Requirements (what systems support the capabilities)
        |      [Phase C — Application Architecture]
        v
Technology Requirements (what infrastructure runs the applications)
               [Phase D — Technology Architecture]
```

### Traceability Matrix (Example)

| BMM Element | Capability | Value Stream Stage | Data Object | Application | Technology |
|---|---|---|---|---|---|
| Objective: Onboard 50K digital customers | Digital Onboarding | Application Stage | Customer, KYC Document | Digital Onboarding Platform | Cloud (AWS / Azure) |
| Strategy: Mobile-first platform | Mobile Channel Delivery | Loan Discovery | Product, Rate | Mobile Banking App | API Gateway, CDN |
| Business Rule: eKYC CBUAE compliance | KYC / Identity Verification | Application Stage | Identity, Biometric | eKYC Provider API | Secure Enclave, HSM |

---

## Business Architecture Tools and Techniques Summary

| Technique | Purpose | When Used in ADM |
|---|---|---|
| Business Motivation Model (BMM) | Trace strategy to architecture | Phase A, Phase B |
| Business Capability Map | Inventory of what the business needs to do | Phase B |
| Capability Heat Map | Maturity assessment and prioritization | Phase B |
| Value Stream Mapping | End-to-end value delivery analysis | Phase B |
| Business Process Modeling (BPMN) | How specific processes work | Phase B (operational detail) |
| RACI Matrix | Accountability assignment | Phase B |
| Stakeholder Map | Who cares about what | Phase A, Phase B |
| Business Scenario | Describe problem and proposed solution | Phase A |
| SWOT Analysis | Internal / external assessment | Preliminary, Phase A |
| Business Object Catalog | Identify key information concepts | Phase B |
| Gap Analysis | Baseline vs. target state | Phase B, Phase E |

---

## Relationship Between TOGAF ADM and BIZBOK

| TOGAF Component | BIZBOK Alignment |
|---|---|
| Phase B — Business Architecture | Core domain of BIZBOK practice |
| Business Capability Map | Primary BIZBOK deliverable |
| Value Stream | BIZBOK fundamental concept |
| Business Motivation Model | OMG BMM — referenced by both TOGAF and BIZBOK |
| Architecture Principles | BIZBOK Guiding Principles |
| Architecture Repository | BIZBOK knowledge base / knowledgeware |

BIZBOK provides **complementary depth** to the TOGAF Series Guide — practitioners use both together for enterprise-grade Business Architecture delivery.

---

## Key Exam Points

| Point | Detail |
|---|---|
| BMM motivation layer | Vision → Goal → Objective → Strategy → Tactic → Business Rule |
| Value Stream vs. Process | Value stream is stable and stakeholder-facing; process is operational and inside-out |
| Capability vs. Process | Business Capability is WHAT; Business Process is HOW |
| Business Objects scope | Defined in Phase B (Business Architecture); formalized as Data Entities in Phase C |
| Domain ordering | Business Architecture (Phase B) drives ALL other domains — it is always done first |
| BIZBOK role | Provides complementary guidance to the TOGAF Business Architecture Series Guide |
| Capability characteristics | Stable, outcome-focused, technology-agnostic, hierarchical, assessable |
| Value stream ownership | Always defined from the STAKEHOLDER perspective (outside-in) |
| Heat map purpose | Visualize current maturity vs. target maturity to identify investment priorities |
| Traceability | BMM → Capabilities → Value Streams → Data → Applications → Technology |

---

## Quick Reference — BMM vs Value Stream vs Capability

```
+------------------+------------------------------------------+------------------+
| Concept          | Question it Answers                      | Phase            |
+------------------+------------------------------------------+------------------+
| Vision           | Where do we want to be?                  | Prelim / Phase A |
| Goal             | What must we achieve long-term?           | Phase A          |
| Objective        | What measurable outcome by when?          | Phase A / B      |
| Strategy         | How will we approach achieving the goal?  | Phase A / B      |
| Business Rule    | What specific constraint governs action?  | Phase B          |
| Value Stream     | How does value flow to the stakeholder?   | Phase B          |
| Capability       | What ability does the business need?      | Phase B          |
| Business Object  | What information does the business use?   | Phase B          |
| Data Entity      | How is that information stored/managed?   | Phase C          |
+------------------+------------------------------------------+------------------+
```

---

*Series Guide Reference: TOGAF 10 Business Architecture Series Guide | OMG BMM Specification v1.3 | BIZBOK Guide v10*
