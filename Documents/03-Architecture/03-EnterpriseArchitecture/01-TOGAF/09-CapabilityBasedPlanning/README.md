# TOGAF 10 — Capability-Based Planning

> **Module:** 09 — Capability-Based Planning
> **Standard:** TOGAF 10 (The Open Group Architecture Framework)
> **Audience:** Enterprise Architects, Solution Architects, Architecture Reviewers

---

## Table of Contents

1. [What is Capability-Based Planning?](#1-what-is-capability-based-planning)
2. [Business Capabilities](#2-business-capabilities)
3. [Business Capability Map](#3-business-capability-map)
4. [Capability Heat Map](#4-capability-heat-map)
5. [Capability Increments](#5-capability-increments)
6. [Transition Architectures](#6-transition-architectures)
7. [Architecture Roadmap](#7-architecture-roadmap)
8. [Work Packages](#8-work-packages)
9. [Integration with Portfolio and Project Management](#9-integration-with-portfolio-and-project-management)
10. [Practical: Running a Capability Planning Workshop](#10-practical-running-a-capability-planning-workshop)
11. [Key Exam Points](#11-key-exam-points)

---

## 1. What is Capability-Based Planning?

Capability-Based Planning (CBP) is a **business-focused planning technique** that centers architecture work on the capabilities an enterprise needs to achieve its strategic goals — rather than on systems, projects, or technology components.

### Core Idea

Instead of asking "what IT projects do we need to deliver?", Capability-Based Planning asks:
- "What **abilities** does the enterprise need to compete and win?"
- "Which of those abilities are we missing or underperforming in today?"
- "How do we close those gaps in an incremental, value-delivering way?"

### Why It Matters

| Traditional IT Planning | Capability-Based Planning |
|-------------------------|--------------------------|
| Focused on systems and technology | Focused on business outcomes |
| IT-driven conversations | Business-driven conversations |
| Projects defined by IT capacity | Projects defined by capability gaps |
| Value realized only at project end | Value delivered at each increment |
| Hard to explain to business leaders | Business leaders can own it directly |

### The Fundamental Shift

A **capability** is described as something the business **needs to be able to do** — for example, "Real-Time Customer Analytics" — rather than a technology project like "Deploy Kafka + Flink pipeline."

This distinction ensures:
- Business leaders remain active participants in architecture decisions
- Architecture work is always traceable to strategic value
- Investment decisions are grounded in capability maturity, not technology preference

---

## 2. Business Capabilities

### Definition

> A **business capability** is a particular ability or capacity that a business may possess or exchange to achieve a specific purpose or outcome.

Business capabilities have three defining characteristics:

1. **Stability** — capabilities change slowly even as processes, people, and technology change
2. **Outcome-focused** — they define *what* the business does, not *how* it does it
3. **Business-language** — they are expressed in terms meaningful to business leaders

### Capability vs. Process vs. Function

```
Capability    =  WHAT the business must be able to do
Process       =  HOW the business does it (step-by-step)
Function      =  WHO does it (organizational unit)
Application   =  WHAT technology supports it
```

**Example:**

| Concept | Example |
|---------|---------|
| Capability | Customer Credit Risk Assessment |
| Process | Receive application → Pull credit score → Run scorecard → Decision |
| Function | Credit Risk Department |
| Application | CreditIQ platform, Core Banking System |

The **capability** "Customer Credit Risk Assessment" remains constant even if the process is redesigned or the technology is replaced. This stability is what makes capabilities powerful for long-term planning.

### Why Capabilities Are Stable

Organizations reorganize, re-platform, and re-engineer frequently. But the fundamental things a bank needs to do — lend money, manage risk, onboard customers, process payments — change only with major strategic pivots.

This stability makes capabilities the ideal "anchor" for enterprise architecture work. Architecture artifacts linked to capabilities remain relevant longer than those linked to processes or systems.

---

## 3. Business Capability Map

### What is a Business Capability Map?

A **Business Capability Map** is a complete inventory of all capabilities the organization needs (not necessarily what it currently has) to execute its strategy.

Key properties:
- **Comprehensive** — covers all domains of the business
- **Hierarchical** — organized from high-level domains down to fine-grained sub-capabilities
- **Technology-agnostic** — describes what is needed, not how it is delivered
- **Owned by the business** — approved and maintained by business leaders

### Hierarchy Structure

```
Level 1: Capability Domain      (e.g., Customer Management)
  Level 2: Capability           (e.g., Customer Onboarding)
    Level 3: Sub-Capability     (e.g., KYC/AML Verification)
      Level 4: Capability Unit  (optional, fine-grained atomic capability)
```

Most organizations work effectively at Level 1-3. Level 4 is used when detailed gap analysis is needed for a specific domain.

### Example: Business Capability Map (Retail Banking)

```
LEVEL 1                     LEVEL 2                        LEVEL 3
─────────────────────────────────────────────────────────────────────
Customer Management       ├── Customer Onboarding          ├── KYC/AML Verification
                          │                                ├── Digital Identity
                          │                                └── Document Collection
                          │
                          ├── Customer Engagement          ├── Personalization
                          │                                ├── Multi-channel Experience
                          │                                └── Loyalty Management
                          │
                          └── Customer Analytics           ├── Behavioral Analytics
                                                           ├── Predictive Modeling
                                                           └── Real-time Insights

Product Management        ├── Product Design               ├── Market Research
                          │                                ├── Product Specification
                          │                                └── Regulatory Assessment
                          │
                          ├── Product Pricing              ├── Competitive Pricing
                          │                                └── Dynamic Pricing
                          │
                          └── Product Lifecycle Mgmt       ├── Launch Management
                                                           └── Retirement Management

Risk Management           ├── Credit Risk                  ├── Application Scoring
                          │                                ├── Portfolio Monitoring
                          │                                └── Collections
                          │
                          ├── Operational Risk             ├── Process Risk Assessment
                          │                                └── Incident Management
                          │
                          └── Compliance & Reporting       ├── Regulatory Reporting
                                                           ├── AML/Fraud Detection
                                                           └── Audit Trail Management

Payment Processing        ├── Domestic Payments            ├── Real-time Payments
                          ├── International Payments       ├── SWIFT/Correspondent
                          └── Payment Operations           └── Reconciliation
```

### Uses of the Capability Map

| Use Case | Description |
|----------|-------------|
| Strategic Planning | Identify which capabilities will differentiate the business |
| Gap Analysis | Compare current state to target capability map |
| Investment Decisions | Prioritize where to invest based on strategic importance |
| Architecture Scoping | Define what an architecture engagement should cover |
| Portfolio Alignment | Map projects to capability improvements |
| Vendor Assessment | Evaluate vendors by capabilities they enable |

---

## 4. Capability Heat Map

### What is a Capability Heat Map?

A **Capability Heat Map** overlays the Business Capability Map with **color-coded maturity or performance ratings** for each capability. It provides an instant visual of where the enterprise is performing well and where it is underperforming or missing capabilities entirely.

### Rating Scale

| Color | Status | Meaning | Action |
|-------|--------|---------|--------|
| Green | Performing well | Meets or exceeds strategic needs | Monitor; no immediate investment |
| Yellow | Adequate | Functional but improvement warranted | Watch; targeted enhancements |
| Red | Underperforming | Falls short of strategic need | Invest; architecture work needed |
| White/Gray | Not implemented | Capability gap; does not exist today | Build or acquire |

### Example Heat Map (Customer Domain)

```
┌─────────────────────────────────────────────────────────────┐
│           CUSTOMER MANAGEMENT HEAT MAP                      │
├──────────────────────────┬───────────────────────┬──────────┤
│ Capability               │ Sub-Capability        │ Status   │
├──────────────────────────┼───────────────────────┼──────────┤
│ Customer Onboarding      │ KYC/AML Verification  │  RED     │
│                          │ Digital Identity      │  YELLOW  │
│                          │ Document Collection   │  GREEN   │
├──────────────────────────┼───────────────────────┼──────────┤
│ Customer Engagement      │ Personalization       │  RED     │
│                          │ Multi-channel         │  YELLOW  │
│                          │ Loyalty Management    │  WHITE   │
├──────────────────────────┼───────────────────────┼──────────┤
│ Customer Analytics       │ Behavioral Analytics  │  YELLOW  │
│                          │ Predictive Modeling   │  RED     │
│                          │ Real-time Insights    │  WHITE   │
└──────────────────────────┴───────────────────────┴──────────┘
```

### Reading the Heat Map

From the example above, the enterprise should prioritize:
1. **KYC/AML Verification** (Red) — underperforming in a compliance-critical area
2. **Predictive Modeling** (Red) — competitive disadvantage in analytics
3. **Personalization** (Red) — customer experience gap
4. **Loyalty Management** (White) — capability does not exist; strategic gap
5. **Real-time Insights** (White) — capability does not exist; analytics gap

### How Heat Maps Drive Architecture Work

The heat map translates strategic assessment into concrete architecture priorities. Red and White capabilities become the **inputs** to:
- Gap Analysis (Phase B/C/D)
- Capability Increment planning
- Work Package definition
- Architecture Roadmap sequencing

---

## 5. Capability Increments

### What are Capability Increments?

**Capability Increments** are discrete, measurable improvements to a capability that can be delivered within a defined time period. Each increment delivers tangible business value independently — it does not require the next increment to be useful.

This approach replaces the "big bang" delivery model (deliver everything at once after 2 years) with an incremental model (deliver value every quarter).

### Why Increments?

```
BIG BANG APPROACH                    INCREMENTAL APPROACH
──────────────────                   ────────────────────
Year 1: Planning...                  Q1: Basic segmentation → 5 segments live
Year 2: Building...                  Q2: Behavior tracking → clickstream live
Year 3: Testing...                   Q3: Churn model → risk scores via API
Year 3 Q4: GO LIVE                   Q4: Offer engine → ML offers in mobile
         ↓                                    ↓
  All value at the end           Value at every milestone
  High risk of overrun           Risk contained per increment
  Stakeholders lose interest     Stakeholders see progress
  Hard to course-correct         Easy to adjust direction
```

### Characteristics of Good Capability Increments

A well-defined capability increment must:

- Deliver a **measurable business outcome** (not just technical completion)
- Have clear **entry criteria** (prerequisites that must be true before starting)
- Have clear **exit criteria** (what "done" means for the increment)
- Fit within a **defined time box** (quarter, program increment, sprint)
- **Build on** prior increments without breaking them
- Be **independently testable** and demonstrable to business stakeholders

### Example: Customer Analytics Capability Increments

**Target Capability:** Real-Time Customer Analytics (currently White/not implemented)

| Increment | Time Box | Deliverable | Measurable Outcome |
|-----------|----------|-------------|-------------------|
| Increment 1 | Q1 2025 | Basic customer segmentation using existing data | 5 customer segments defined and active in CRM |
| Increment 2 | Q2 2025 | Real-time behavior tracking | Clickstream data captured, stored, queryable within 60 seconds |
| Increment 3 | Q3 2025 | Predictive churn model | 30-day churn probability score available via REST API |
| Increment 4 | Q4 2025 | Personalized offer engine | ML-driven offers integrated into mobile app; CTR improvement measurable |

**Exit Criteria Example (Increment 3):**
- Churn model trained on 12 months of data
- Model accuracy > 75% AUC on holdout set
- REST API deployed to production with <200ms p99 latency
- Business validation: Credit team reviews top 100 churn predictions and confirms accuracy
- Monitoring dashboard operational

### Increment Entry/Exit Criteria Template

```
Capability:     [Name]
Increment:      [Number and name]
Time Box:       [Start date] — [End date]

Entry Criteria:
  - [ ] Prerequisite 1
  - [ ] Prerequisite 2

Scope:
  - [What is included]
  - [What is explicitly excluded]

Exit Criteria:
  - [ ] Business outcome: [measurable statement]
  - [ ] Technical: [what is deployed/operational]
  - [ ] Validated by: [who signs off]

Business Value:
  - [Quantified or qualified value delivered]
```

---

## 6. Transition Architectures

### What are Transition Architectures?

A **Transition Architecture** describes an intermediate state of the enterprise — between the Baseline Architecture (where we are today) and the Target Architecture (where we want to be) — that is:
- **Stable** — a coherent, functional architecture in its own right
- **Valuable** — delivers measurable business value
- **Achievable** — realistic to reach within the planned time box

Each transition architecture represents a major milestone in the transformation journey. It answers the question: "What does the enterprise architecture look like after this wave of changes is complete?"

### Why Transition Architectures Are Essential

The target architecture for a large transformation may be 2-4 years away. Without transition architectures:

- The business cannot realize value until the very end
- Course corrections are expensive and late
- Stakeholder support erodes without visible progress
- Dependencies and risks compound

Transition architectures provide natural "checkpoints" where:
- Business value is assessed
- Course corrections are made
- Commitments for the next phase are renewed

### Transition Architecture vs. Target Architecture

| Aspect | Transition Architecture | Target Architecture |
|--------|------------------------|---------------------|
| Time horizon | Near-term (3-12 months) | Medium-to-long term (1-4 years) |
| Stability | Stable and operational | Aspirational |
| Purpose | Deliver incremental value | Define the end state |
| Detail level | High (actionable) | May be conceptual |
| Change frequency | Superseded when next TA is reached | Evolves with strategy |

### Transition Architecture Example: Core Banking Modernization

```
═══════════════════════════════════════════════════════════════
BASELINE ARCHITECTURE (2024 Q1)
═══════════════════════════════════════════════════════════════
  ┌─────────────────────────────────────────────────┐
  │            MONOLITHIC CORE BANKING              │
  │  - All business logic embedded                  │
  │  - Nightly batch reporting only                 │
  │  - No external API layer                        │
  │  - 3 siloed operational databases               │
  └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════
TRANSITION ARCHITECTURE 1 (2024 Q2)
  "Strangler Fig — API Facade Layer"
═══════════════════════════════════════════════════════════════
  ┌──────────────┐    ┌──────────────────────────────┐
  │  API GATEWAY │───▶│  3 New Microservices          │
  │  (NEW)       │    │  - Customer API               │
  └──────┬───────┘    │  - Account API                │
         │            │  - Transaction API             │
         ▼            └──────────────┬───────────────┘
  ┌─────────────────────────────┐    │
  │  CORE BANKING (unchanged)   │◀───┘ (passthrough for now)
  │  + Near-real-time events    │
  │    via event stream         │
  └─────────────────────────────┘

  Value delivered: External integrations can use APIs; event
  stream enables near-real-time dashboards

═══════════════════════════════════════════════════════════════
TRANSITION ARCHITECTURE 2 (2024 Q4)
  "Domain Extraction + Central Data Platform"
═══════════════════════════════════════════════════════════════
  ┌──────────────┐    ┌──────────────────────────────┐
  │  API GATEWAY │───▶│  9 Microservices (6 new)      │
  └──────┬───────┘    │  - Onboarding, Notifications  │
         │            │  - Limits, Fees, Statements   │
         ▼            │  + original 3                 │
  ┌─────────────┐     └──────────────────────────────┘
  │ CORE BANKING│           │
  │ (reduced)   │           ▼
  │ Payments +  │    ┌──────────────────────────────┐
  │ Ledger only │    │  CENTRAL DATA PLATFORM (NEW) │
  └─────────────┘    │  - Unified event bus          │
                     │  - Real-time analytics        │
                     │  Legacy reporting retired     │
                     └──────────────────────────────┘

  Value delivered: Real-time reporting operational; 6 domains
  extracted and independently deployable

═══════════════════════════════════════════════════════════════
TARGET ARCHITECTURE (2025 Q4)
  "Full API-First Microservices Platform"
═══════════════════════════════════════════════════════════════
  ┌──────────────┐    ┌──────────────────────────────┐
  │  API GATEWAY │───▶│  Full Microservices Platform  │
  │  + Security  │    │  All domains extracted        │
  │  + Rate Limit│    │  Independent deployability    │
  └──────────────┘    └──────────────────────────────┘
                               │
                      ┌────────▼────────┐
                      │ "Payment Engine"│  ← Core banking
                      │  (plug-in only) │    reduced to this
                      └─────────────────┘
                               │
                      ┌────────▼────────┐
                      │ UNIFIED DATA    │
                      │ PLATFORM        │
                      │ Real-time       │
                      │ analytics +     │
                      │ AI/ML           │
                      └─────────────────┘

  Value delivered: Full business agility; independent scaling;
  real-time analytics across all domains; API-first ecosystem
```

---

## 7. Architecture Roadmap

### What is the Architecture Roadmap?

The **Architecture Roadmap** is a schedule of the work packages (projects and programs) needed to move the enterprise from its Baseline Architecture to its Target Architecture, organized by Transition Architectures.

It is the primary output connecting enterprise architecture to investment planning and program delivery.

### Architecture Roadmap vs. Project Plan

```
ARCHITECTURE ROADMAP                  PROJECT PLAN
────────────────────                  ────────────
Business-outcome focused              Task-completion focused
Organized by capability               Organized by deliverable
Shows strategic value at each stage   Shows milestones and tasks
Owned by Enterprise Architect         Owned by Project Manager
Input to portfolio decisions          Input to project execution
Changes when strategy changes         Changes when scope changes
```

### Architecture Roadmap Contents

| Section | Content |
|---------|---------|
| Architecture Vision Summary | Where are we going? What is the strategic destination? |
| Baseline Architecture Summary | Where are we now? Key constraints and pain points |
| Gap Analysis Summary | What needs to change? Which capabilities are missing/underperforming? |
| Transition Architectures | Intermediate milestones; what the architecture looks like at each |
| Work Package List | The projects/programs delivering each transition |
| Timeline | When each work package is scheduled; dependencies shown |
| Dependencies | What must be done before what |
| Risks and Assumptions | What could go wrong; what we're assuming to be true |
| Benefits Realization Plan | Business value delivered at each transition milestone |

### How to Build an Architecture Roadmap

```
Step 1: Define Target Architecture
        (Output of Phase B, C, D — business, information, technology)
         │
         ▼
Step 2: Document Baseline Architecture
        (Current state — systems, processes, capabilities, gaps)
         │
         ▼
Step 3: Perform Gap Analysis
        (Baseline vs Target — what is missing, what needs to change, what to retire)
         │
         ▼
Step 4: Identify Work Items
        (Each gap becomes a potential work item)
         │
         ▼
Step 5: Group into Work Packages
        (Related changes grouped into cohesive projects/programs)
         │
         ▼
Step 6: Sequence Work Packages
        (Consider: dependencies, business priority, risk, resource constraints)
         │
         ▼
Step 7: Define Transition Architectures
        (Major milestones where coherent value is delivered)
         │
         ▼
Step 8: Create Timeline
        (Schedule each work package under its transition architecture)
         │
         ▼
Step 9: Validate with Stakeholders
        (Business leaders confirm value at each milestone; sponsors commit)
```

### Sample Architecture Roadmap Layout

```
TIMELINE ──────────────────────────────────────────────────────────▶
         │  2025 Q1-Q2         │  2025 Q3-Q4          │  2026       │
─────────┼─────────────────────┼──────────────────────┼─────────────┤
TA1      │  [API Gateway]      │                      │             │
         │  [Customer API]     │                      │             │
         │  [Event Streaming]  │                      │             │
─────────┼─────────────────────┼──────────────────────┼─────────────┤
TA2      │                     │  [Data Platform]     │             │
         │                     │  [Domain Extraction] │             │
         │                     │  [Legacy Retire]     │             │
─────────┼─────────────────────┼──────────────────────┼─────────────┤
Target   │                     │                      │  [Full MS]  │
         │                     │                      │  [AI/ML]    │
─────────┴─────────────────────┴──────────────────────┴─────────────┘
Business │  APIs live          │  Real-time reporting │  Full agility
Value    │  Int. partners      │  Analytics ops       │  AI-driven   
         │  enabled            │  Domains independent │  personalized
```

---

## 8. Work Packages

### Definition

A **Work Package** is a set of actions, tasks, and activities required to implement a specific architecture change. It represents the unit of planning that bridges enterprise architecture and project delivery.

Each Work Package:
- Maps directly to one or more capability improvements
- Corresponds to a project or program in the organization's portfolio
- Has a clear scope, set of deliverables, resource requirements, and business justification

### Work Package Definition

| Field | Description |
|-------|-------------|
| ID | Unique identifier |
| Name | Descriptive name |
| Description | What this package delivers |
| Capabilities Addressed | Which capabilities it improves (Level 2 or 3) |
| Transition Architecture | Which TA it contributes to |
| Scope | What is in/out of scope |
| Deliverables | Specific outputs |
| Dependencies | What must precede this work package |
| Resources Required | Teams, budget, tools |
| Schedule | Start/end dates |
| Business Benefits | Measurable value on completion |
| Risks | Key risks to delivery |

### Work Package to Capability Traceability

```
Business Strategy
      │
      ▼
Strategic Capability Gap
(e.g., "Real-Time Customer Analytics" is Red on heat map)
      │
      ▼
Capability Increments
(Increment 3: Predictive churn model — 30-day probability via API)
      │
      ▼
Work Packages
(WP-047: Build and deploy churn prediction ML service)
(WP-048: Integrate churn scores into CRM decisioning)
      │
      ▼
Projects / Programs
(Project: CX Analytics Platform Phase 3)
```

This traceability chain ensures that every project investment can be justified in terms of business capability improvement, and every capability gap has at least one work package addressing it.

### Work Package Example

```
Work Package: WP-047 — Churn Prediction Service

Capability:         Customer Analytics > Predictive Modeling
Capability Status:  Red (currently batch, 14-day lag, 60% accuracy)
Target Increment:   Increment 3 — 30-day churn probability via API

Scope:
  IN:  ML model training, API service, monitoring dashboard
  OUT: CRM integration (covered by WP-048), mobile app changes

Deliverables:
  1. Trained churn model (>75% AUC)
  2. REST API deployed to production
  3. Monitoring dashboard in DataDog
  4. Model retraining pipeline (weekly)

Dependencies:
  - WP-045 (event streaming infrastructure) must be complete
  - WP-046 (feature store) must be operational

Resources:
  - 2 x Data Scientists (16 weeks)
  - 1 x ML Engineer (12 weeks)
  - 1 x API Developer (8 weeks)
  - Cloud infrastructure budget: $45k/year

Business Benefits:
  - Proactive retention offers to at-risk customers
  - Estimated 15% reduction in voluntary churn
  - ~$2.4M annual revenue protection

Risks:
  - Data quality issues in historical event log
  - Regulatory approval required for automated decisioning
```

---

## 9. Integration with Portfolio and Project Management

### How Architecture Feeds Portfolio Management

```
Enterprise Architecture                    Portfolio Management
──────────────────────                     ────────────────────
Capability Heat Map ──────────────────▶   Investment priorities
Architecture Roadmap ─────────────────▶   Portfolio of programs
Work Packages ────────────────────────▶   Individual projects
Benefits Realization Plan ────────────▶   Business case
Transition Architectures ─────────────▶   Program milestones
Gap Analysis ─────────────────────────▶   Strategic gap funding
```

The Architecture Roadmap is the single most important document connecting enterprise architecture decisions to the organization's investment portfolio. Without it, projects are funded based on departmental requests rather than strategic capability needs.

### ADM Phase Integration

| ADM Phase | Capability Planning Activity |
|-----------|------------------------------|
| Phase A: Architecture Vision | Identify strategic capability objectives; agree on capability scope |
| Phase B: Business Architecture | Build or update Business Capability Map; create heat map |
| Phase C: Information/Application Architecture | Map applications and data to capabilities |
| Phase D: Technology Architecture | Map technology to capability support |
| Phase E: Opportunities & Solutions | Define capability increments; create initial Architecture Roadmap; identify Work Packages |
| Phase F: Migration Planning | Finalize work package sequencing, costs, benefits, priorities |
| Phase G: Implementation Governance | Monitor work package delivery; ensure transition architectures are achieved |
| Phase H: Change Management | Update roadmap and capability map when strategy changes |

### Phase E and F in Detail

**Phase E — Opportunities and Solutions** is where Capability-Based Planning comes alive:

1. Consolidate gap analysis from Phases B, C, D
2. Review and prioritize gaps against strategic goals
3. Group gaps into initial Work Packages
4. Define Capability Increments
5. Propose Transition Architectures
6. Create the initial Architecture Roadmap

**Phase F — Migration Planning** refines the roadmap:

1. Assign costs and resource estimates to Work Packages
2. Perform formal sequencing (dependencies, constraints)
3. Validate with business sponsors
4. Finalize benefits at each transition milestone
5. Obtain approval to proceed

---

## 10. Practical: Running a Capability Planning Workshop

A Capability Planning Workshop typically runs as a half-day or full-day facilitated session. It is the fastest way to build stakeholder alignment on architecture priorities.

### Workshop Agenda (Full Day)

| Time | Activity | Participants |
|------|----------|-------------|
| 09:00-09:30 | Introduction — strategy and goals review | All |
| 09:30-10:30 | Build/validate capability map (Level 1-2) | All |
| 10:30-11:00 | Break | |
| 11:00-12:00 | Heat map exercise — rate each capability | All (voting) |
| 12:00-13:00 | Lunch | |
| 13:00-13:30 | Identify strategic gaps — which red/white capabilities matter most? | All |
| 13:30-14:30 | Define capability increments for top 3-4 gaps | Small groups |
| 14:30-15:00 | Break | |
| 15:00-15:45 | Map increments to Work Packages | EA + Tech leads |
| 15:45-16:15 | Draft roadmap sequence | EA facilitates |
| 16:15-16:30 | Wrap-up, next steps, owners | All |

### Step-by-Step Facilitation Guide

**Step 1 — Assemble stakeholders**
Bring business leads (not just IT): product owners, COO, CFO representative, risk, operations. Enterprise Architect facilitates; does not dictate.

**Step 2 — Build or validate the capability map**
Use a pre-populated map as a starting point. Ask business leads to challenge, add, or remove capabilities. Focus on Level 1-2 first; drill into Level 3 for strategic domains only.

**Step 3 — Heat map exercise**
For each capability, have attendees vote on current performance (Red/Yellow/Green/White) using dot stickers or digital tools. Use 5 minutes per capability domain, not per individual capability. Discuss disagreements — they reveal misalignment.

**Step 4 — Identify strategic capability gaps**
Filter to capabilities that are Red or White AND strategically important. Use a 2x2:
```
                 LOW Strategic Importance | HIGH Strategic Importance
                 ─────────────────────────────────────────────────────
  RED/WHITE      Watch & defer            | INVEST NOW
  GREEN/YELLOW   Maintain                 | Monitor & sustain
```

**Step 5 — Define capability increments**
For each high-priority gap, facilitate a discussion: "If we could improve this capability in 4 quarterly steps, what would each step look like?" Document as: what is delivered, how we measure it, what it enables for the business.

**Step 6 — Map to Work Packages**
Ask: "What systems, processes, and data need to change to deliver each increment?" Each answer becomes a potential Work Package. Group related items.

**Step 7 — Sequence and schedule**
Draw the dependency graph on a whiteboard. Identify which Work Packages are blockers for others. Assign to quarters on a simple timeline. Identify transition architecture milestones.

### Workshop Output

By end of workshop you should have:
- A validated Business Capability Map (Level 1-2, with Level 3 for key domains)
- A capability heat map with business-agreed ratings
- 3-5 prioritized capability gaps with defined increments
- A draft Architecture Roadmap (first version, high-level)
- Identified owners for follow-up Work Package definition

---

## 11. Key Exam Points

### Critical Distinctions

| Concept | Remember |
|---------|---------|
| Capability vs Process | Capability = WHAT; Process = HOW |
| Capability vs Application | Capability is technology-agnostic; many apps may support one capability |
| Capability Map vs Process Model | Map is stable and business-owned; process models change frequently |
| Transition Architecture vs Target Architecture | TA = intermediate stable state; Target = end destination |
| Architecture Roadmap vs Project Plan | Roadmap = business value schedule; Project Plan = task schedule |
| Work Package vs Project | Work Package is the architecture artifact; it becomes a project in execution |

### Phase Mapping

```
Phase E (Opportunities & Solutions) ──▶  Creates initial Architecture Roadmap
                                         Identifies and defines Work Packages
                                         Proposes Transition Architectures

Phase F (Migration Planning)        ──▶  Finalizes Work Package sequencing
                                         Adds costs and resource plans
                                         Confirms benefits at each stage
                                         Roadmap becomes approved baseline

Phase G (Implementation Governance) ──▶  Monitors delivery against the Roadmap
                                         Validates that Transition Architectures
                                         are achieved as planned

Phase H (Change Management)         ──▶  Updates Roadmap when business strategy
                                         or priorities change
```

### Common Exam Traps

1. **"Architecture Roadmap is a project plan"** — FALSE. The roadmap is business-value-focused and owned by Enterprise Architecture. It feeds project plans but is not one.

2. **"Capability Maps change frequently"** — FALSE. Capabilities are stable. Process models and application portfolios change; capability maps should be revisited annually at most.

3. **"Transition Architectures are optional"** — FALSE. For any significant transformation, transition architectures are essential to deliver incremental value and manage risk.

4. **"Work Packages are defined in Phase F"** — PARTIALLY TRUE. Work Packages are *identified and defined* in Phase E; they are *finalized and sequenced* in Phase F.

5. **"Capability-Based Planning is an IT discipline"** — FALSE. It is a *business* discipline. Business leaders build and own the capability map and heat map. Enterprise Architecture facilitates but business drives.

### Benefits Summary

| Benefit | Description |
|---------|-------------|
| Business alignment | Architecture work is always traceable to strategic capability |
| Stakeholder engagement | Business leaders can own capability conversations |
| Incremental value | Benefits delivered at each capability increment, not just at end |
| Investment justification | Every project justified by capability improvement |
| Risk reduction | Problems caught earlier; course correction at each transition |
| Portfolio coherence | All projects trace to a strategic capability gap |
| Communication | Capability language bridges business-IT divide |

---

## Quick Reference

```
CAPABILITY-BASED PLANNING FLOW
───────────────────────────────

Business Strategy
      │
      ▼
Business Capability Map
(What the business needs to do)
      │
      ▼
Capability Heat Map
(How well are we doing it today?)
      │
      ▼
Strategic Capability Gaps
(Where must we invest?)
      │
      ▼
Capability Increments
(How do we get there in stages?)
      │
      ▼
Work Packages
(What projects deliver each increment?)
      │
      ▼
Architecture Roadmap
(When, in what order, for what value?)
      │
      ▼
Transition Architectures
(What does the enterprise look like at each milestone?)
      │
      ▼
Target Architecture
(The destination)
```

---

*TOGAF is a registered trademark of The Open Group. This material is for educational study purposes.*
