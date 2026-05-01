# TOGAF 10 — Master Overview

> The Open Group Architecture Framework, 10th Edition (2022)
> This knowledge base targets full mastery: from foundational concepts to certification readiness and real-world application.

---

## 1. What is TOGAF 10?

TOGAF (The Open Group Architecture Framework) is the world's most widely adopted Enterprise Architecture (EA) framework. Published by The Open Group, TOGAF 10 (released April 2022) is the latest major edition and introduces a modular structure to keep content current without full-framework rewrites.

### Core Purpose

| Goal | Description |
|---|---|
| Common Language | Shared vocabulary for architects, business leaders, and IT stakeholders |
| Proven Methodology | Battle-tested ADM process for developing and managing enterprise architectures |
| Risk Reduction | Structured approach reduces transformation failure risk |
| ROI on EA | Provides measurable value through reuse, alignment, and traceability |
| Stakeholder Communication | Bridges the gap between business strategy and technology execution |

### Who Uses TOGAF?

- **Enterprise Architects** — design and govern the overall enterprise structure
- **Solution Architects** — apply ADM patterns within project/program boundaries
- **Business Analysts** — align business capability with operating model
- **CIOs / CTOs** — drive strategic transformation with a structured framework
- **Government and regulated industries** — compliance-aware EA governance

---

## 2. TOGAF 10 Modular Structure

TOGAF 10 introduced a two-part modular structure replacing the monolithic single-document approach of TOGAF 9.x.

### 2.1 TOGAF Fundamental Content (Stable Core)

The core is stable and versioned independently. It contains the foundational elements that all TOGAF implementations rely on:

| Component | Description |
|---|---|
| Architecture Development Method (ADM) | The iterative, phase-based process for developing EA |
| Architecture Content Framework | Taxonomy of deliverables, artifacts, and building blocks |
| Enterprise Continuum | Classification system for architecture and solution assets |
| Architecture Repository | Central store for all EA assets and deliverables |
| Architecture Capability Framework | How to set up, run, and mature an EA practice |

### 2.2 TOGAF Series Guides (Topic-Specific, Independently Updated)

Series Guides extend the framework for specific domains, technologies, and practices. They can be updated without touching the Fundamental Content:

| Guide | Focus Area |
|---|---|
| Business Architecture | Capabilities, value streams, organization maps |
| Security Architecture | Threat modeling, security controls integration into ADM |
| Digital Transformation | EA in cloud-native, platform, and digital contexts |
| Agile Architecture | Applying TOGAF in Agile/SAFe/DevOps environments |
| Architecture Skills Framework | Competency models for EA practitioners |
| EA Maturity Models | Assessing and improving EA practice maturity |
| Migration Planning | Roadmap development, transition architecture, gap analysis |

> **Key Insight**: The modular split allows The Open Group to publish new Series Guides or update existing ones annually without releasing "TOGAF 11." This keeps the framework relevant to emerging domains (e.g., AI governance, cloud architecture) without destabilizing the core.

---

## 3. The Four Architecture Domains (BDAT)

TOGAF organizes Enterprise Architecture into four interconnected domains. Together they form a complete picture of the enterprise from business intent down to infrastructure.

```
Business Architecture
        |
        v
Data Architecture
        |
        v
Application Architecture
        |
        v
Technology Architecture
```

### 3.1 Business Architecture

Describes how the enterprise operates to achieve its goals.

- **Business Strategy** — vision, goals, drivers, objectives
- **Business Capabilities** — what the business can do (capability map)
- **Value Streams** — end-to-end sequences that deliver stakeholder value
- **Organization Map** — actors, roles, responsibilities
- **Business Processes** — workflows and operational flows
- **Business Information** — key concepts and business rules

**Key Artifacts**: Business Capability Map, Value Stream Map, Organization Chart, Business Process Model, Business Use Cases

### 3.2 Data Architecture

Describes the structure, management, and governance of enterprise data assets.

- **Logical Data Model** — conceptual and logical representation of data entities
- **Physical Data Model** — how data is stored and managed
- **Data Flows** — movement of data between systems and actors
- **Data Governance** — ownership, quality, lineage, retention policies
- **Master Data Management** — single source of truth for key entities

**Key Artifacts**: Logical/Physical Data Model, Data Flow Diagram, Data Entity/Data Component Catalog, Data Governance Framework

### 3.3 Application Architecture

Describes the application landscape and its interaction with business processes and data.

- **Application Portfolio** — inventory of all applications and their capabilities
- **Application Interactions** — interface and integration map
- **Application-to-Function Mapping** — which app supports which business function
- **API Strategy** — how applications expose and consume services
- **Legacy vs. Target** — current state vs. desired state applications

**Key Artifacts**: Application Portfolio Catalog, Application Interaction Diagram, Application-Function Matrix, Interface Catalog

### 3.4 Technology Architecture

Describes the hardware, software infrastructure, and platform capabilities.

- **Infrastructure Inventory** — servers, networks, storage, cloud platforms
- **Platform Services** — middleware, integration platforms, runtime environments
- **Technology Standards** — approved technologies, versions, lifecycle status
- **Deployment Architecture** — how applications are deployed across infrastructure
- **Security & Compliance** — network security, access control, compliance requirements

**Key Artifacts**: Technology Standards Catalog, Technology Portfolio, Network Diagram, Deployment Diagram, Infrastructure Catalog

---

## 4. Core Components Deep Dive

### 4.1 Architecture Development Method (ADM) — The Process Engine

The ADM is TOGAF's heart — a repeatable, iterative process for developing, transitioning, and governing enterprise architectures. It consists of a Preliminary Phase and eight lettered phases organized in a cycle.

```
         [Preliminary Phase]
                 |
         [A: Architecture Vision]
        /                         \
[H: Architecture           [B: Business Architecture]
 Change Management]                |
        \                   [C: Information Systems Architecture]
         \                         |
          \                [D: Technology Architecture]
           \                       |
            \              [E: Opportunities & Solutions]
             \                     |
              \            [F: Migration Planning]
               \                   |
                \          [G: Implementation Governance]
                 \_________________/
                      (Cycle)
```

| Phase | Name | Key Outputs |
|---|---|---|
| Preliminary | Framework setup | Architecture Principles, Tailored ADM, EA Capability |
| A | Architecture Vision | Statement of Architecture Work, Architecture Vision, Stakeholder Map |
| B | Business Architecture | Baseline/Target Business Architecture, Gap Analysis |
| C | Information Systems | Baseline/Target Data & Application Architecture, Gap Analysis |
| D | Technology Architecture | Baseline/Target Technology Architecture, Gap Analysis |
| E | Opportunities & Solutions | Architecture Roadmap, Work Packages, Transition Architectures |
| F | Migration Planning | Prioritized project list, Cost/benefit analysis, Migration Plan |
| G | Implementation Governance | Architecture Contract, Compliance Assessments |
| H | Architecture Change Management | Change requests, Updated Architecture, Lessons Learned |
| Requirements Management | (Central) | Architecture Requirements Specifications (feeds all phases) |

### 4.2 Enterprise Continuum — Classification for Reuse

The Enterprise Continuum is a classification system and view of the Architecture Repository. It helps architects locate, select, and leverage existing architecture assets.

**Two sides of the Continuum:**

- **Architecture Continuum**: Ranges from Foundation Architectures (generic, broadly reusable) to Organization-Specific Architectures (tailored for one enterprise). In between: Common Systems Architectures and Industry Architectures.
- **Solutions Continuum**: The corresponding spectrum for solution implementations — from generic products and services to organization-specific deployed solutions.

```
Foundation Architecture  →  Common Systems  →  Industry  →  Organization-Specific
     (most generic)                                             (most specific)
```

**Why it matters**: Architects should always look "left" (toward generic) before building custom solutions. The Continuum promotes reuse and avoids reinventing the wheel.

### 4.3 Architecture Repository — Central Asset Store

The Architecture Repository is the organized storage for all EA assets. It has six classes of content:

| Class | Contents |
|---|---|
| Architecture Metamodel | The ADM process, Content Framework, governance rules |
| Architecture Landscape | Current, transition, and target architecture descriptions at strategic, segment, and capability levels |
| Standards Information Base (SIB) | External standards, industry standards, technology standards |
| Reference Library | Best practices, guidelines, patterns, templates |
| Governance Log | Compliance records, waivers, dispensations, decisions |
| Architecture Capability | Skills, processes, roles, tools of the EA practice |

### 4.4 Architecture Content Framework — Structure for Outputs

Defines a consistent taxonomy for architecture deliverables using three categories:

| Category | Definition | Examples |
|---|---|---|
| **Deliverables** | Contractually specified work products | Architecture Definition Document, Statement of Architecture Work |
| **Artifacts** | Granular architecture descriptions (within deliverables) | Capability Map, Application Portfolio, Network Diagram |
| **Building Blocks** | Reusable components of capability | Architecture Building Blocks (ABBs), Solution Building Blocks (SBBs) |

**Architecture Building Blocks (ABBs)** describe what is needed.
**Solution Building Blocks (SBBs)** describe how it is implemented.

### 4.5 Architecture Capability Framework — Running EA

Defines how to establish and operate an EA practice within an organization:

- **Architecture Board** — governance body reviewing and approving architectures
- **Architecture Compliance** — process for checking implementations against approved architectures
- **Architecture Contracts** — formal agreements between development partners on architecture
- **Architecture Governance** — policies, processes, roles for EA oversight
- **Architecture Maturity Models** — tools for assessing and growing EA practice maturity
- **Architecture Skills Framework** — competency definitions for EA roles

---

## 5. Why TOGAF?

### Key Benefits

| Benefit | Detail |
|---|---|
| Vendor-Neutral | Not tied to any product, platform, or technology stack |
| Globally Recognized | Used in 80%+ of Global 50 organizations; recognized credential worldwide |
| Adaptable | Can be tailored to size, industry, and methodology (Agile, SAFe, etc.) |
| Reduces EA Risk | Phased, validated approach catches misalignment early |
| Stakeholder Communication | Common language bridges business-IT divide |
| Accelerates Delivery | Reuse via Continuum and Repository reduces rework |
| Compliance Support | Governance structures support regulatory and audit requirements |
| Career Value | TOGAF certification is a top credential for Solution and Enterprise Architects |

### TOGAF vs. Other Frameworks

| Framework | Focus | Relationship to TOGAF |
|---|---|---|
| Zachman Framework | Classification taxonomy | Complements TOGAF (can use as a taxonomy within ADM artifacts) |
| FEAF (US Federal EA) | US government EA | Built on TOGAF principles |
| DoDAF | Defense architecture | Domain-specific; ADM principles apply |
| ArchiMate | Modeling language | Natural companion to TOGAF for visual notation |
| ITIL | IT service management | Operates at implementation level; TOGAF governs at architecture level |
| SAFe / Agile | Delivery methodology | TOGAF Series Guide covers integration |

---

## 6. TOGAF 10 vs. TOGAF 9.2 — Key Differences

| Aspect | TOGAF 9.2 | TOGAF 10 |
|---|---|---|
| Structure | Monolithic single document | Modular: Fundamental Content + Series Guides |
| Update Cadence | Full revision required | Series Guides updated independently |
| Business Architecture | Limited coverage | Expanded Series Guide with value streams, capabilities |
| Digital Transformation | Not addressed | Dedicated Series Guide |
| Security Architecture | Appendix-level | Full Series Guide |
| Agile Integration | Limited | Dedicated Agile Architecture Series Guide |
| Accessibility | Single PDF/HTML | Modular access; buy only what you need |
| Version Stability | Locked between releases | Core stable; guides continuously improved |

> **Bottom line**: TOGAF 10 did not radically change the ADM or core components. The architecture of the framework itself became modular — making it more maintainable, extensible, and relevant to modern domains.

---

## 7. Certification Path

### Level 1: TOGAF Foundation

| Item | Detail |
|---|---|
| Objective | Demonstrate understanding of TOGAF fundamentals |
| Exam Format | 40 multiple-choice questions (MCQ) |
| Duration | 60 minutes |
| Pass Mark | 55% (22/40 correct) |
| Open Book | No |
| Key Topics | ADM phases, terminology, four domains, Content Framework, Enterprise Continuum, Repository classes |

**Preparation tips**: Know all ADM phases and their key inputs/outputs. Understand all terminology (ABB vs SBB, artifact vs deliverable, etc.). The Preliminary Phase and Requirements Management are commonly tested.

### Level 2: TOGAF Practitioner

| Item | Detail |
|---|---|
| Objective | Apply TOGAF in scenarios; demonstrate practitioner-level judgment |
| Exam Format | 8 scenario-based questions (complex MCQ / gradient scoring) |
| Duration | 90 minutes |
| Pass Mark | 60% |
| Open Book | Yes (TOGAF standard document allowed) |
| Prerequisite | Must hold Level 1 (Foundation) |
| Key Topics | ADM application to scenarios, governance decisions, gap analysis, stakeholder management, iteration use |

**Preparation tips**: Focus on *why* and *when*, not just *what*. Scenarios test judgment — know when to iterate the ADM, when to invoke governance, how to handle architectural change requests. Practice with mock scenario questions.

### Combined Exam Option

Both Level 1 and Level 2 can be taken as a single combined exam (80 questions, 150 minutes, split scoring).

### Maintaining Certification

The Open Group periodically requires credential holders to validate for new versions. TOGAF 10 credentials are valid; holders of TOGAF 9.2 are encouraged to bridge-certify.

---

## 8. Knowledge Base Structure

This knowledge base is organized into **29 topic directories**, grouped into four logical categories. Directory numbers are preserved (not strictly sequential within groups) to keep cross-references stable.

### A. Fundamental Content & Core (the stable TOGAF core)
| Directory | Topic | Focus |
|---|---|---|
| `01-ADMCycle` | Architecture Development Method | Phase-by-phase deep dive, inputs/outputs, iteration patterns |
| `02-ArchitectureDomains` | BDAT Domains | Business, Data, Application, Technology architecture detail |
| `03-Governance` | Architecture Governance | Boards, contracts, compliance, change management |
| `04-ArchiMate` | ArchiMate Modeling Language | Notation, layers, aspects, viewpoints for TOGAF artifacts |
| `05-EnterpriseContinuum` | Enterprise Continuum | Classification system, reuse strategy, continuum spectrum |
| `06-ContentFramework` | Architecture Content Framework | Deliverables, artifacts, building blocks taxonomy |
| `07-ArchitectureRepository` | Architecture Repository | Six classes, governance log, SIB, reference library |
| `08-ReferenceModels` | TOGAF Reference Models | TRM (Technical Reference Model), III-RM (Integrated Information Infrastructure) |
| `10-ArchitectureCapabilityFramework` | Architecture Capability | EA roles, board setup, governance practice |

### B. ADM Techniques (TOGAF-formal techniques used inside the ADM)
| Directory | Topic | Focus | ADM Phase |
|---|---|---|---|
| `26-BusinessScenarios` | Business Scenarios | SMART scenarios; 6 components; requirements gathering | Phase A |
| `27-StakeholderManagement` | Stakeholder Management | Power/Interest grid; concerns; viewpoints; communications plan | All phases |
| `28-ArchitecturePrinciples` | Architecture Principles | Format (Name/Statement/Rationale/Implications); 4 categories; quality criteria | Preliminary, A |
| `29-GapAnalysis` | Gap Analysis | Baseline vs Target; Eliminate/Retain/New; PPT lens; transition architectures | B, C, D |
| `09-CapabilityBasedPlanning` | Capability-Based Planning | Capability increments, roadmaps, transition architecture | E, F |
| `20-MigrationPlanning` | Migration Planning | Roadmap, transition architectures, work packages | E, F |

### C. Series Guides (topic-specific, independently updated)
| Directory | Topic | Focus |
|---|---|---|
| `14-SecurityArchitecture` | Security Architecture | Threat modeling, controls integration, SABSA-TOGAF mapping |
| `15-BusinessArchitectureGuide` | Business Architecture | Capabilities, value streams, organization maps, business motivation |
| `16-DigitalTransformation` | Digital Transformation | EA in cloud-native, platform, and digital contexts |
| `19-AgileArchitecture` | Agile Architecture | Continuous architecture, ADM in Agile/SAFe/DevOps, MVPs, fitness functions |
| `21-EAMaturityModels` | EA Maturity Models | ACMM, OMG EA Maturity, NASCIO; assess and grow EA practice |
| `22-ArchitectureSkillsFramework` | Skills & Competencies | Role definitions, competency levels, career paths for architects |
| `23-InformationMapping` | Information Mapping | Data architecture techniques, MDM, information mapping |
| `24-LeadersGuide` | Leader's Guide | EA for senior architects, CIOs; sponsorship, value articulation |
| `25-Sustainability` | Sustainability | Green IT, ESG considerations in architecture decisions |

### D. Adoption, Application & Context
| Directory | Topic | Focus |
|---|---|---|
| `11-TOGAF10Changes` | TOGAF 10 Changes | Modular structure, new Series Guides, delta from 9.2 |
| `12-PracticalArtifacts` | Practical Artifacts | Templates, worked examples, gap analysis, roadmaps |
| `13-CertificationPrep` | Certification Preparation | L1 and L2 exam prep, practice questions, mnemonics |
| `17-TOGAFHistory` | TOGAF History | Origins, version evolution, influence on FEAF/DoDAF |
| `18-TOGAFLimitations` | TOGAF Limitations | Critique, common misuses, where TOGAF doesn't fit |

> **Note on directory numbering**: numbers reflect *creation order*, not category. The four logical groups above are the recommended reading order. Modules `09` (Capability-Based Planning) and `20` (Migration Planning) are listed under "ADM Techniques" because they are technique-modules, not Series Guides.

---

## 9. TOGAF in Practice — Key Patterns

### Iteration in the ADM

The ADM is not strictly sequential. Architects regularly iterate:

- **Phase-level iteration**: Revisit earlier phases when new information emerges
- **ADM cycle iteration**: Run multiple ADM cycles at different architecture levels (Strategic, Segment, Capability)
- **Spiral model**: Each iteration increases architecture detail and commitment

### Architecture Levels

| Level | Scope | Example |
|---|---|---|
| Strategic Architecture | Whole enterprise or major division | 5-year technology strategy |
| Segment Architecture | Line of business or domain | Customer-facing digital platform |
| Capability Architecture | Specific capability or initiative | API management platform |

### Gap Analysis

A core ADM technique used in Phases B, C, D:

1. Document Baseline Architecture (current state)
2. Define Target Architecture (desired state)
3. Identify gaps (what is missing, what needs to change, what must be eliminated)
4. Map gaps to work packages in Phase E

---

## 10. Quick Reference — ADM Phase Mnemonics

| Mnemonic | Phases |
|---|---|
| **P**lease **A**lways **B**uild **C**lean **D**ata **E**nabling **F**ast **G**rowth **H**ere | Preliminary, A, B, C, D, E, F, G, H |

**Phase A outputs to remember**: Statement of Architecture Work, Architecture Vision, Stakeholder Map, Approved Architecture Vision, Architecture Definition Document (initial)

**Requirements Management** sits at the center of all phases — it is not a phase you pass through but a continuous process feeding and receiving from all phases.

---

## References and Standards

- **The Open Group TOGAF Standard, 10th Edition** — https://www.opengroup.org/togaf
- **ArchiMate 3.2 Specification** — https://www.opengroup.org/archimate-forum
- **TOGAF Certification Program** — https://www.opengroup.org/certifications/togaf
- **Business Architecture Guild (BIZBOK)** — complementary to TOGAF Business Architecture guide
- **SABSA** — security architecture framework compatible with TOGAF ADM

---

*This knowledge base is maintained as part of the myKnowledgeHub structured learning repository. Target audience: Solution Architects progressing toward Enterprise Architecture certification and practice.*
