# TOGAF 10 — Architecture Repository

## Overview

The **Architecture Repository** is the persistent storage system that holds all architecture-related work products produced during enterprise architecture activities. It is the central holding area that enables an organization to manage, govern, and reuse its architecture assets across all ADM cycles.

### Core Purpose

- Provides a **persistent store** that spans across all architecture activities and ADM cycles
- Enables **re-use** of existing architecture work rather than starting from scratch each time
- Supports **traceability** from strategic goals down to implementation details
- Enforces **governance and consistency** by making approved standards and decisions visible
- Acts as the **storage system** for the Enterprise Continuum (the Continuum is the classification; the Repository is where the assets live)

### Architecture Repository vs. Enterprise Continuum

These two concepts are tightly coupled but distinct:

| Concept | Role |
|---|---|
| Enterprise Continuum | Classification system — organizes architectures from generic to specific |
| Architecture Repository | Storage system — the actual database/folder structure holding those architectures |

The Enterprise Continuum tells you *where* an architecture fits conceptually. The Architecture Repository is *where you store it physically*.

---

## Six Classes of Architecture Repository Information

The TOGAF standard defines exactly **six classes** of information stored in the Architecture Repository:

1. Architecture Metamodel
2. Architecture Capability
3. Architecture Landscape
4. Standards Information Base (SIB)
5. Reference Library
6. Governance Log

---

## 1. Architecture Metamodel

### What it is

The **Architecture Metamodel** contains the organization's **customized metamodel** — adapted from the TOGAF Content Metamodel to fit the specific needs, terminology, and context of the enterprise.

### What it defines

- **Entities**: the core building blocks used in architecture descriptions (e.g., Application Component, Business Service, Technology Platform)
- **Attributes**: the properties each entity carries (e.g., an Application Component has: name, owner, criticality, hosting platform, lifecycle status)
- **Relationships**: how entities relate to each other (e.g., Application Component *realizes* Business Service)

### Why it matters

The Metamodel acts as the **"schema"** for all architecture content in the repository. Without it, different architects would use different terminology, making it impossible to compare or govern architectures consistently.

### Example entries

- How "Application Component" is defined in this organization — distinct from "Application Service" and "Application Module"
- What attributes an "Information System" carries in this enterprise context
- The relationship between "Business Process" and "Business Function" in this organization's taxonomy
- Custom entity: "Platform Service" — a reusable technical capability exposed via API

---

## 2. Architecture Capability

### What it is

The **Architecture Capability** section stores information **about the architecture organization itself** — its operating model, governance structures, and processes. This is architecture about architecture.

### Contents

- **Architecture Board Charter** — mandate, composition, quorum rules, decision authority
- **Terms of Reference** — scope of the architecture function, what it governs, what it does not
- **Architecture Principles** — the approved set of principles guiding all architecture decisions (e.g., "Prefer reuse over build", "Design for cloud-native")
- **Skills Framework** — competency levels, roles, and responsibilities for architects
- **Governance Frameworks and Policies** — how governance works, escalation paths, compliance requirements
- **Architecture Process Definitions** — the organization's tailored ADM, including which phases are used, what deliverables are required, and which phases are combined
- **Architecture Tools and Licenses** — approved EA tools in use (e.g., Sparx EA Enterprise license, BiZZdesign Cloud subscription)
- **Architecture Repository Structure** — documentation of how this repository itself is organized and maintained

---

## 3. Architecture Landscape

### What it is

The **Architecture Landscape** is where the **actual architecture work products are stored**. It is organized into three levels that correspond to different time horizons and levels of abstraction.

### The Three Levels

#### Strategic Architecture

- **Time horizon**: 3–5+ years
- **Abstraction level**: High — direction and intent, not detailed design
- **Primary audience**: C-suite executives, board members, senior leadership
- **ADM link**: Phase A (Architecture Vision)
- **Typical format**: Architecture Vision document, capability heat maps, strategic roadmaps
- **Content**: Business vision, strategic goals, enterprise capability direction, high-level target operating model

**Example entry**: "Transform from a product-centric to a platform-centric business model by 2028 — Enterprise Architecture Vision v2.1 (approved by Architecture Board, Q1 2025)"

#### Segment Architecture

- **Time horizon**: 1–3 years
- **Abstraction level**: Medium — detailed enough for business planning and program management
- **Primary audience**: Business unit heads, program managers, domain architects
- **ADM link**: Phases B, C, D (Business, Information Systems, Technology Architecture)
- **Typical format**: Architecture Definition Document (ADD), domain architecture descriptions
- **Content**: Detailed architecture for specific business segments, functions, or organizational units

**Example entry**: "Customer Experience Platform — Retail Banking Segment Architecture v1.4 (Architecture Definition Document, covering Business, Application, and Technology layers for the CX transformation program)"

#### Capability Architecture

- **Time horizon**: Sprint / quarter / project level
- **Abstraction level**: Low — detailed enough to build from
- **Primary audience**: Development teams, project architects, technical leads
- **ADM link**: Phases E, F, G (Opportunities & Solutions, Migration Planning, Implementation Governance)
- **Typical format**: Detailed design specifications, component diagrams, interface contracts
- **Content**: Architecture for a specific capability or project, directly consumed by delivery teams

**Example entry**: "Identity and Access Management (IAM) Capability Architecture v2.0 — detailed component design, API specifications, and deployment topology for the IAM modernization project"

### Strategic → Segment → Capability Decomposition

```
Strategic Architecture
  └── Segment Architecture (Retail Banking)
        └── Capability Architecture (IAM)
        └── Capability Architecture (Payments)
        └── Capability Architecture (Digital Onboarding)
  └── Segment Architecture (Corporate Banking)
        └── Capability Architecture (Trade Finance)
        └── Capability Architecture (Treasury)
```

### Strategic vs Segment vs Capability — Key Distinctions

| Dimension | Strategic | Segment | Capability |
|---|---|---|---|
| Time horizon | 3–5+ years | 1–3 years | Sprint/quarter |
| Abstraction level | High (direction) | Medium (design) | Low (build) |
| Primary audience | C-suite, board | BU heads, program managers | Dev teams, project architects |
| TOGAF ADM link | Phase A | Phase B/C/D | Phase E/F/G |
| Typical format | Architecture Vision doc | Architecture Definition Document | Detailed design specs |
| Level of detail | Strategic intent | Business and system design | Implementation-ready specs |

### Transition Architectures in the Landscape

The Architecture Landscape also stores **Transition Architectures** — snapshots of the enterprise architecture at specific points in time during a transformation:

- **Baseline Architecture (as-is)**: The current state of the architecture
- **Transition Architecture 1**: Intermediate state after the first major increment/release
- **Transition Architecture 2**: Intermediate state after the second major increment
- **Target Architecture (to-be)**: The desired future state

All transition architectures are stored alongside each other in the Landscape, enabling governance teams to track progress and verify that projects are moving toward the agreed target.

---

## 4. Standards Information Base (SIB)

### What it is

The **Standards Information Base** is the repository of **all approved standards** for use in architecture and delivery work across the enterprise. It tells architects and developers what technologies, protocols, and patterns they must, should, or may use.

### Three Categories of Standards

| Category | Meaning | Example |
|---|---|---|
| **Mandatory** | Must be used — no exceptions without a dispensation | TLS 1.3 for all external APIs |
| **Recommended** | Preferred choice — alternatives require justification | PostgreSQL for relational databases |
| **Emerging** | Under evaluation for future adoption — not yet approved | WebAssembly for portable computation |

### Deprecated Standards

The SIB also tracks **deprecated standards** with sunset dates, giving teams time to migrate away from technologies the organization is phasing out.

### Governance

- Maintained and approved by the **Architecture Board**
- Reviewed at minimum **annually** (more frequently in fast-moving technology areas)
- Updates trigger Architecture Change Requests if they affect existing architectures

### Example SIB Entries

**API & Integration Standards**
- RESTful APIs using OpenAPI 3.0 specification — Mandatory
- JSON as wire format for all REST APIs — Mandatory
- GraphQL for client-driven data queries — Recommended
- Apache Kafka for asynchronous event streaming — Mandatory (for event-driven scenarios)
- SOAP/XML — Deprecated (sunset: Q4 2026)

**Security Standards**
- OAuth 2.0 / OIDC for authentication and authorization — Mandatory
- AES-256 for data encryption at rest — Mandatory
- TLS 1.3 for data in transit — Mandatory
- TLS 1.2 — Deprecated (sunset: Q2 2025)

**Cloud and Infrastructure**
- AWS as primary cloud platform — Mandatory
- Azure as secondary/hybrid cloud platform — Recommended
- Kubernetes for container orchestration — Mandatory (for containerized workloads)
- Docker for container packaging — Mandatory

**Development Standards**
- Java 21 LTS as primary JVM language — Mandatory
- Spring Boot 3.x as application framework — Recommended
- React 18 for frontend SPAs — Recommended
- Kotlin for new JVM microservices — Emerging (evaluation in progress)

**Data Standards**
- PostgreSQL for relational databases — Recommended
- Redis for distributed caching — Recommended
- Apache Parquet for analytical data storage — Mandatory (data lake)

---

## 5. Reference Library

### What it is

The **Reference Library** stores **pre-built architectures, patterns, templates, and guidelines** that architects can reference and reuse when creating new architecture work. It prevents reinventing the wheel and promotes consistency.

### Sources

- **TOGAF Foundation Architecture**: Technical Reference Model (TRM), Integrated Information Infrastructure Reference Model (III-RM)
- **Industry Reference Models**: eTOM (telecom), BIAN (banking), ARTS (retail)
- **Vendor Reference Architectures**: AWS Well-Architected Framework, Azure Architecture Center patterns
- **Proven Internal Patterns**: architecture solutions that have been successfully implemented in the enterprise and documented for reuse

### Categories

| Category | Description | Example |
|---|---|---|
| **Guidelines** | How-to guidance for architecture activities | "How to conduct a stakeholder analysis", "How to create an Architecture Vision" |
| **Templates** | Blank templates for architecture deliverables | Architecture Vision template, ADD template, Architecture Contract template |
| **Patterns** | Proven, reusable architecture solutions | Microservices pattern, CQRS, Saga pattern, Strangler Fig, Event Sourcing |
| **Viewpoints** | Standard viewpoints for creating architecture views | Business Capability Viewpoint, Application Communication Viewpoint, Deployment Viewpoint |

### Relationship to Enterprise Continuum

In the Enterprise Continuum classification:
- Foundation Architectures (TOGAF TRM, III-RM) → stored in the Reference Library
- Common Systems Architectures (industry patterns) → stored in the Reference Library
- Organization-Specific Architectures → stored in the Architecture Landscape

### SIB vs. Reference Library — Key Distinction

| Standards Information Base | Reference Library |
|---|---|
| Contains approved **standards** (what to use) | Contains reusable **patterns and templates** (how to design) |
| "Use OAuth 2.0 for authentication" | "Here is the OAuth 2.0 integration pattern with sequence diagrams" |
| Technology choices and protocols | Architectural solutions and design guidance |
| Governed by Architecture Board approval | Contributed by architects, reviewed for quality |

---

## 6. Governance Log

### What it is

The **Governance Log** is the **complete audit trail** of all architecture governance activities. It makes governance decisions transparent, traceable, and defensible.

### Sub-components

#### Decision Log
- All Architecture Board decisions
- Each entry includes: decision date, decision text, rationale, decision-makers present, references to affected architectures or projects
- Example: "Decision 2025-047: Approve adoption of Kafka as mandatory standard for event-driven integration (replaces point-to-point messaging)"

#### Compliance Assessments
- Results of all compliance reviews conducted against architecture standards
- Each entry includes: project name, review date, reviewer, findings (compliant / partially compliant / non-compliant), outcome and required actions
- Used to track whether projects are building in accordance with the approved architecture

#### Dispensation Register
- Active dispensations granted to projects — time-limited exceptions to mandatory standards
- Each entry includes: dispensation ID, project, standard being dispensed from, scope, business justification, expiry date, review dates, conditions attached
- Example: "Dispensation 2025-012: Project Phoenix permitted to use MySQL instead of PostgreSQL until migration to PostgreSQL is complete (expiry: Q3 2026)"

#### Architecture Contracts Register
- All active Architecture Contracts with their status
- Each entry includes: contract ID, parties (architecture function + project), deliverables committed, acceptance criteria, current status
- Architecture Contracts are the formal agreements between the architecture function and implementation projects

#### Waiver Register
- Permanent waivers from standards (as opposed to time-limited dispensations)
- Each entry requires documented business justification and Architecture Board approval
- Example: "Legacy Core Banking System — permanent waiver from Kubernetes orchestration requirement (system cannot be containerized without full replacement)"

#### Change Request Log
- All Architecture Change Requests (from Phase H) with status and resolution
- Each entry includes: change request ID, submitter, date, description of proposed change, impact assessment, status (submitted / under review / approved / rejected), resolution date

---

## Architecture Landscape Deep Dive

### Transition Architectures — Managing the Journey

Enterprise transformations rarely move directly from baseline to target. The Architecture Landscape captures the intermediate states:

```
Time →

Baseline          Transition 1        Transition 2         Target
(as-is)    →    (end of Phase 1)  →  (end of Phase 2)  →  (to-be)

Q1 2025          Q3 2025              Q2 2026              Q4 2026
```

Each transition architecture is:
- A fully described, governed architecture (not just a plan)
- The baseline for the next increment of work
- Stored in the Architecture Landscape alongside the baseline and target
- Referenced in Architecture Contracts for the projects delivering that increment

---

## Populating the Repository During the ADM

The Architecture Repository is populated incrementally as the ADM progresses:

| ADM Phase | Repository Update |
|---|---|
| **Preliminary** | Establish the Architecture Capability section; define and agree the metamodel; set up repository structure |
| **Phase A** — Architecture Vision | Add Architecture Vision to Architecture Landscape at Strategic level; initiate Governance Log with new ADM cycle entry |
| **Phase B/C/D** — Domain Architectures | Add Business, Information Systems, and Technology architectures to Landscape at Segment/Capability level; update Architecture Landscape with domain-specific content |
| **Phase E** — Opportunities & Solutions | Add Architecture Roadmap and Work Package definitions to Architecture Landscape; record solution options considered in Governance Log |
| **Phase F** — Migration Planning | Update Architecture Landscape with finalized Migration Plan; add Transition Architectures for each increment; update Architecture Roadmap |
| **Phase G** — Implementation Governance | Update Governance Log with Architecture Contracts; record Compliance Assessments as projects deliver; record dispensations granted |
| **Phase H** — Architecture Change Management | Update all relevant sections when approved changes occur; update Decision Log with change decisions; update Architecture Landscape with revised architectures |
| **Requirements Management** | Maintain traceability from requirements to architecture elements across all phases |

---

## Repository Tooling Considerations

### Minimum Viable Repository

An organization does not need expensive tooling to maintain an Architecture Repository. A minimum viable implementation can use:
- Structured folder system (SharePoint, Confluence, or shared drive) following the six class structure
- Document management with metadata (version, status, owner, date)
- Manual cross-referencing between sections

### Commercial EA Tool Support

Dedicated EA tools typically provide built-in repository support:

| Tool | Repository Approach |
|---|---|
| **Sparx Enterprise Architect** | Built-in model repository with version control and access control |
| **BiZZdesign HoriZZon** | Cloud-based repository with TOGAF-aligned metamodel out of the box |
| **Mega HOPEX** | Integrated repository with governance workflow support |
| **Avolution ABACUS** | Repository with metamodel customization and reporting |

### Key Technical Requirements

Any tool or system used to implement the Architecture Repository should support:
- **Version control**: ability to maintain multiple versions of architectures (baseline, transition, target)
- **Access control**: role-based access so that different stakeholders see appropriate content
- **Search**: ability to search across all six classes to find relevant content quickly
- **Cross-referencing**: links between related elements across sections (e.g., from a Compliance Assessment in the Governance Log to the architecture in the Landscape it was assessed against)
- **Audit trail**: change history for governance entries

---

## Key Exam Points

| Topic | Key Fact |
|---|---|
| Number of classes | Repository has exactly **6 classes** |
| Class names | Metamodel, Capability, Landscape, SIB, Reference Library, Governance Log |
| Architecture Landscape levels | **3 levels**: Strategic, Segment, Capability |
| SIB vs Reference Library | SIB = approved standards (what to use); Reference Library = reusable patterns and templates (how to design) |
| Governance Log scope | Governance Log CONTAINS the Decision Log — it is not the same thing as the Decision Log |
| Enterprise Continuum relationship | Enterprise Continuum = classification system; Architecture Repository = storage system |
| Transition Architectures | Stored in the Architecture Landscape alongside baseline and target |
| Who maintains the SIB | Architecture Board — reviewed at minimum annually |
| Dispensation vs Waiver | Dispensation = time-limited exception; Waiver = permanent exception with business justification |
| Preliminary Phase repository task | Establish Architecture Capability section and define the metamodel |

---

## Summary Diagram

```
Architecture Repository
├── 1. Architecture Metamodel
│   └── Entity definitions, attributes, relationships (the "schema")
│
├── 2. Architecture Capability
│   └── Architecture Board, principles, processes, tools, skills
│
├── 3. Architecture Landscape
│   ├── Strategic Architecture (3-5+ years, Phase A)
│   ├── Segment Architecture (1-3 years, Phase B/C/D)
│   ├── Capability Architecture (sprint/quarter, Phase E/F/G)
│   └── Transition Architectures (baseline → T1 → T2 → target)
│
├── 4. Standards Information Base (SIB)
│   ├── Mandatory standards
│   ├── Recommended standards
│   ├── Emerging standards
│   └── Deprecated standards (with sunset dates)
│
├── 5. Reference Library
│   ├── Guidelines
│   ├── Templates
│   ├── Patterns (microservices, CQRS, saga, etc.)
│   └── Viewpoints
│
└── 6. Governance Log
    ├── Decision Log
    ├── Compliance Assessments
    ├── Dispensation Register
    ├── Architecture Contracts Register
    ├── Waiver Register
    └── Change Request Log
```
