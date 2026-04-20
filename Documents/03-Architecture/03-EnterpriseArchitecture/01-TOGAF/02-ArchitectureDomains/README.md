# TOGAF 10 Architecture Domains — BDAT Deep Dive

> **TOGAF 10** organizes enterprise architecture into four interlocking domains, collectively known as **BDAT**:
> **B**usiness · **D**ata · **A**pplication · **T**echnology.
> Each domain produces a distinct layer of the architecture. Together they form a coherent, end-to-end description of the enterprise — from strategic intent all the way down to physical infrastructure.

---

## Table of Contents

1. [Business Architecture](#1-business-architecture)
2. [Data Architecture](#2-data-architecture)
3. [Application Architecture](#3-application-architecture)
4. [Technology Architecture](#4-technology-architecture)
5. [How BDAT Domains Interrelate](#5-how-bdat-domains-interrelate)
6. [Architecture Views and Viewpoints](#6-architecture-views-and-viewpoints)
7. [Stakeholder Mapping per Domain](#7-stakeholder-mapping-per-domain)
8. [Exam Tips](#8-exam-tips)

---

## 1. Business Architecture

### Purpose

Business Architecture describes the **strategy, governance, organization, and key business processes** of the enterprise. It is the topmost layer of BDAT and the starting point for all downstream architecture work. It translates executive intent and strategic goals into structured, actionable models that the rest of the architecture can be derived from.

Without a solid Business Architecture, Data, Application, and Technology domains lack grounding — they become technology-driven rather than business-driven.

### ADM Phase

Phase B — Business Architecture (immediately after Preliminary and Phase A: Architecture Vision)

### Key Concerns

| Concern | Description |
|---|---|
| Business Capabilities | What the enterprise must be able to do (independent of how) |
| Value Streams | End-to-end sequences of activities that deliver value to a stakeholder |
| Organizational Structure | Legal entities, business units, roles, reporting lines |
| Business Processes | Step-by-step flows of activities that produce outcomes |
| Strategic Goals & Drivers | Objectives, KPIs, motivations, and external forces |
| Governance Model | Decision rights, accountability frameworks, policy enforcement |
| Business Functions | Stable groupings of business behavior that support capabilities |

### Key Artifacts

| Artifact | Description |
|---|---|
| **Organization Structure diagram** | Depicts legal entities, business units, teams, and reporting lines |
| **Business Capability Map** | Two-dimensional heat map of what the business does, typically colored by maturity or investment priority |
| **Value Stream Map** | End-to-end flow of activities from trigger to value delivery, identifying stages and enabling capabilities |
| **Business Process diagrams (BPMN)** | Detailed swim-lane diagrams of how business processes execute, using Business Process Model and Notation |
| **Business Function catalog** | Flat or hierarchical list of all business functions and their descriptions |
| **Actor/Role catalog** | Enumeration of all human roles, system actors, and their responsibilities |
| **Business Interaction Matrix** | Grid showing which business functions or units interact with each other |
| **Business Footprint diagram** | Shows the linkage between drivers, goals, objectives, organizational units, and their supporting functions |

### Key Stakeholders

- **CEO / Board**: Strategic goals, competitive positioning, risk appetite
- **COO**: Operational efficiency, process optimization, organizational design
- **Business Unit Heads**: Capability ownership, process ownership, resource allocation
- **Strategy Team**: Goal decomposition, initiative prioritization, roadmap alignment
- **Change Management / PMO**: Organizational impact, transformation sequencing

### Common Techniques

**Business Capability Mapping**
- Identifies WHAT the enterprise does, not HOW or WHO
- Organized in a 2–3 level hierarchy (L1: top-level, L2: decomposed, L3: granular)
- Heat maps show maturity: Red (underdeveloped), Amber (developing), Green (target state achieved)
- Used to identify capability gaps between baseline and target architectures

**Value Stream Mapping**
- End-to-end view across business units — cuts across organizational silos
- Each stage in a value stream is enabled by one or more business capabilities
- Maps information flow and material/work flow in parallel
- Used for identifying waste, handoffs, and automation opportunities

**Business Motivation Model (BMM)**
- Formal OMG standard for capturing business intent
- Components: Ends (Vision, Goals, Objectives) + Means (Mission, Strategy, Tactics, Business Rules)
- Connects strategic drivers to actionable policies
- Excellent input to Architecture Vision (Phase A)

### Relationship to Other Domains

```
Business Architecture
    │
    ├─► Data Architecture      (Business objects become data entities)
    ├─► Application Architecture  (Business processes require application support)
    └─► Technology Architecture   (Indirectly — through Application requirements)
```

Business capabilities define WHAT must exist. Data, Application, and Technology define HOW it is realized. Changes in business strategy must cascade down through all three domains.

---

## 2. Data Architecture

### Purpose

Data Architecture describes the **structure of an organization's logical and physical data assets and data management resources**. It defines how data is created, stored, governed, transformed, and consumed across the enterprise. Good Data Architecture ensures that the right data is available to the right processes and systems, with the right quality, at the right time.

### ADM Phase

Phase C — Information Systems Architecture (Data sub-phase, typically done before Application)

### Key Concerns

| Concern | Description |
|---|---|
| Data Models | Conceptual, logical, and physical representations of data entities and relationships |
| Data Flows | How data moves between systems, processes, and stakeholders |
| Data Quality | Accuracy, completeness, consistency, timeliness of data |
| Master Data Management | Single authoritative source for key business entities (customer, product, location) |
| Data Governance | Policies, stewardship, ownership, and accountability for data assets |
| Data Lifecycle | Creation, storage, use, archiving, and disposal of data |
| Data Security | Classification, access controls, encryption, privacy (GDPR, etc.) |

### Key Artifacts

| Artifact | Description |
|---|---|
| **Data Entity/Data Component catalog** | Comprehensive list of all data entities, their attributes, ownership, and classification |
| **Conceptual Data Model** | High-level view of business entities and their relationships; technology-agnostic |
| **Logical Data Model** | Normalized model of entities, attributes, and relationships; implementation-independent but precise |
| **Physical Data Model** | Database-specific design including tables, columns, data types, indexes, constraints |
| **Data Flow diagram** | Shows how data moves between systems, processes, and external parties |
| **Data Security diagram** | Maps data classification levels to systems and enforces access control boundaries |
| **Data Migration diagram** | Documents data movement from source to target systems during transitions |
| **Data Lifecycle diagram** | Shows the states data passes through from creation to archiving/deletion |

### Key Stakeholders

- **CDO (Chief Data Officer)**: Data strategy, governance, quality standards, monetization
- **Data Architects**: Modeling, standards, integration patterns
- **Data Governance Team**: Policy definition, stewardship programs, compliance
- **DBAs (Database Administrators)**: Physical design, performance, availability
- **Business Data Stewards**: Ownership of specific data domains (HR data, financial data, etc.)
- **Compliance / Legal**: Data residency, retention, privacy regulations

### Common Techniques

**Entity-Relationship (ER) Modeling**
- Identifies business entities (Customer, Order, Product) and their relationships
- Cardinality notation: one-to-one, one-to-many, many-to-many
- Moves through conceptual → logical → physical progression

**UML Class Diagrams**
- Used for object-oriented data modeling
- Shows classes, attributes, operations, and associations
- Particularly useful when data models are tightly coupled to application domain models

**Data Flow Diagrams (DFD)**
- Four elements: processes, data stores, external entities, data flows
- Level 0 (Context): single process showing all external entities
- Level 1+: decomposed views of internal processes and data movement

**Data Lineage Analysis**
- Traces the origin, transformation, and destination of data across the pipeline
- Critical for regulatory compliance, impact analysis, and debugging data quality issues

### Relationship to Other Domains

```
Business Architecture
    │  (Business objects → Data entities)
    ▼
Data Architecture
    │  (Data stores consumed by application services)
    ▼
Application Architecture
    │  (Storage infrastructure required)
    ▼
Technology Architecture
    (Database platforms, storage tiers, backup infrastructure)
```

Business objects like "Customer" or "Invoice" become formal data entities in the Data Architecture. Applications create and consume those data entities. Technology provides the platforms that store and process them.

---

## 3. Application Architecture

### Purpose

Application Architecture describes the **individual application systems deployed, their interactions with each other, and their relationship to core business processes**. It maps the application portfolio to business capabilities and identifies integration requirements, redundancies, and rationalization opportunities.

### ADM Phase

Phase C — Information Systems Architecture (Application sub-phase, typically done after Data)

### Key Concerns

| Concern | Description |
|---|---|
| Application Portfolio | Inventory of all application systems, their purpose, ownership, and lifecycle status |
| Application Capabilities | What each application enables from a functional perspective |
| Integration Patterns | How applications exchange data and coordinate behavior |
| APIs | External and internal interfaces; REST, SOAP, event-based |
| Legacy Rationalization | Identifying systems to retire, consolidate, replace, or modernize |
| System Boundaries | What belongs inside vs. outside each application boundary |
| User Access Patterns | Which users interact with which applications, and from where |

### Key Artifacts

| Artifact | Description |
|---|---|
| **Application Portfolio catalog** | Complete inventory: name, purpose, technology stack, owner, lifecycle status (current/strategic/phased-out) |
| **Application Communication diagram** | Shows runtime communication between applications — synchronous calls, async messaging, file transfers |
| **Application and User Location diagram** | Maps applications and user populations to physical/logical locations |
| **Application Use-Case diagram** | Shows which actors interact with which application functions |
| **Enterprise Manageability diagram** | Depicts system management capabilities: monitoring, alerting, patching, logging |
| **Process/Application Realization diagram** | Traces business processes to the applications that support each step |
| **Software Engineering diagram** | Component-level view of how an application is structured internally |
| **Application Migration diagram** | Shows the transition from baseline to target application portfolio |
| **Software Distribution diagram** | Maps software components to their deployment locations |

### Key Stakeholders

- **Application Architects**: System design, integration standards, API governance
- **Development Leads / Engineering Managers**: Build vs. buy decisions, technical feasibility
- **Integration Architects**: Middleware, ESB/API gateway design, event streaming
- **Business Analysts**: Functional requirements traceability to applications
- **Security Architects**: Application security controls, authentication, authorization
- **Operations / SRE Teams**: Operational complexity, deployment, observability

### Integration Patterns

| Pattern | Description | When to Use |
|---|---|---|
| **Point-to-Point** | Direct connection between two applications | Small ecosystems, simple integrations |
| **ESB / SOA** | Centralized enterprise service bus mediating all messages | Large enterprises with many integrations, standardization needed |
| **Event-Driven (EDA)** | Applications publish and subscribe to events via a broker (Kafka, RabbitMQ) | Real-time processing, decoupling producers from consumers |
| **API-First** | All capabilities exposed as versioned APIs; consumers integrate via contracts | Modern ecosystems, partner/third-party integration, mobile frontends |
| **Microservices** | Fine-grained independently deployable services communicating via APIs/events | High-velocity engineering teams, domain-driven decomposition |

### Common Techniques

**Application Portfolio Rationalization (Gartner TIME Model)**
- **T**olerate: Keep but do not invest further
- **I**nvest: Strategically important, increase investment
- **M**igrate: Move to a better platform or solution
- **E**liminate: Decommission — no longer needed or duplicated

**Capability Gap Mapping**
- List target business capabilities (from Business Architecture)
- Map each capability to current applications (baseline)
- Identify: gaps (no application supports this capability), overlaps (multiple apps duplicate), and misalignments
- Gap analysis drives the Application Architecture roadmap

**Domain-Driven Design (DDD) Bounded Contexts**
- Aligns application boundaries to business domain boundaries
- Prevents tight coupling between domains
- Supports microservices decomposition when applicable

### Relationship to Other Domains

```
Business Architecture
    │  (Business processes require application support)
    ▼
Data Architecture
    │  (Applications consume and produce data entities)
    ▼
Application Architecture
    │  (Applications require compute, network, storage)
    ▼
Technology Architecture
```

---

## 4. Technology Architecture

### Purpose

Technology Architecture describes the **hardware, software, and network infrastructure needed to support deployment of the application portfolio and its data stores**. It is the lowest layer of BDAT and is entirely in service of the layers above it. It covers platforms, middleware, networking, security infrastructure, and DevOps toolchains.

### ADM Phase

Phase D — Technology Architecture (last of the four domain phases in the ADM)

### Key Concerns

| Concern | Description |
|---|---|
| Infrastructure | Compute (physical, virtual, container), storage, networking hardware |
| Platforms | Operating systems, container orchestration (Kubernetes), PaaS offerings |
| Middleware | Message brokers, API gateways, integration platforms, caching layers |
| Networks | LAN/WAN topology, DNS, load balancers, firewalls, CDN |
| Cloud | IaaS/PaaS/SaaS selection, cloud regions, multi-cloud, hybrid connectivity |
| Security Infrastructure | IAM, PKI, SIEM, WAF, DLP, network segmentation |
| DevOps Platforms | CI/CD pipelines, artifact registries, infrastructure-as-code, observability stacks |
| Standards and Compliance | Technology standards catalog, approved product list, lifecycle management |

### Key Artifacts

| Artifact | Description |
|---|---|
| **Technology Standards catalog** | Approved technologies, versions, vendors — the enterprise's "golden stack" |
| **Technology Portfolio catalog** | Inventory of all technology components currently in use, with lifecycle status |
| **Environments and Locations diagram** | Maps deployment environments (dev/test/staging/prod) to physical/cloud locations |
| **Platform Decomposition diagram** | Hierarchical breakdown of technology platforms into their constituent components |
| **Networked Computing/Hardware diagram** | Physical or logical network topology: servers, switches, firewalls, load balancers |
| **Communications Engineering diagram** | Network protocol details, bandwidth, latency requirements, WAN links |
| **Processing diagram** | Shows how workloads are distributed across processors, nodes, and clusters |

### Key Stakeholders

- **CTO (Chief Technology Officer)**: Technology strategy, platform choices, build vs. buy
- **Infrastructure Architects**: On-premises datacenter design, capacity planning
- **Cloud Architects**: Cloud-native design patterns, landing zones, FinOps
- **Network Engineers**: Network topology, routing, security zones, bandwidth
- **Security Team / CISO**: Security controls, threat modeling, compliance (ISO 27001, SOC 2)
- **DevOps / Platform Engineering**: CI/CD, infrastructure-as-code, developer productivity

### Common Deployment Models

| Model | Description | Typical Use Case |
|---|---|---|
| **On-Premises** | Enterprise-owned datacenters, full control, high CapEx | Regulated industries, latency-sensitive, legacy systems |
| **IaaS** | Rented compute/storage/network (AWS EC2, Azure VMs) | Lift-and-shift migrations, flexible scaling |
| **PaaS** | Managed platform for app deployment (Azure App Service, GKE) | Developer productivity, reduced ops burden |
| **SaaS** | Fully managed software (Salesforce, ServiceNow, Microsoft 365) | Commodity functions, rapid deployment |
| **Hybrid Cloud** | Mix of on-premises + cloud, connected via private links | Data sovereignty + cloud elasticity |
| **Multi-Cloud** | Multiple cloud providers to avoid lock-in or for best-of-breed | Resilience, geographic coverage, vendor negotiation leverage |

### Relationship to Other Domains

Technology Architecture is governed by standards and principles established at the enterprise level. It implements the Application Architecture — every application deployment decision results in technology requirements.

```
Application Architecture
    │  (Deployment requirements: compute, storage, network, security)
    ▼
Technology Architecture
    │  (Constraints flow upward: tech limitations shape application design)
    └─► Feeds back constraints to Application and Data Architects
```

---

## 5. How BDAT Domains Interrelate

### The Cascade Model (Top-Down Requirements)

```
┌─────────────────────────────────────────────────────────────┐
│                    BUSINESS ARCHITECTURE                      │
│   Strategic goals → Capabilities → Value Streams → Processes │
└───────────────────────────┬─────────────────────────────────┘
                            │  "What data do we need?"
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA ARCHITECTURE                        │
│   Entities → Models → Flows → Governance → Lifecycle         │
└───────────────────────────┬─────────────────────────────────┘
                            │  "What systems manage this data?"
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  APPLICATION ARCHITECTURE                     │
│   Portfolio → Integrations → APIs → Capabilities → Migration │
└───────────────────────────┬─────────────────────────────────┘
                            │  "What infrastructure runs these apps?"
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  TECHNOLOGY ARCHITECTURE                      │
│   Platforms → Networks → Cloud → Security → DevOps           │
└─────────────────────────────────────────────────────────────┘
```

### The Constraint Propagation (Bottom-Up Feedback)

Changes do not only flow top-down. Constraints and capabilities of lower layers feed back upward:

- **Technology constraints** (e.g., cloud provider limits, latency, data residency laws) constrain Application design choices
- **Application constraints** (e.g., a legacy ERP cannot be easily integrated) constrain how business processes can be automated
- **Data constraints** (e.g., data quality issues, missing master data) constrain what business analytics are feasible

### Alignment is Non-Negotiable

Misalignment between domains is the single most cited cause of failed enterprise transformations:

| Misalignment | Symptom | Root Cause |
|---|---|---|
| Business ↔ Data | Reports don't match business definitions | Business terms not formalized in data models |
| Data ↔ Application | Data silos, inconsistent records | Applications built without reference to enterprise data model |
| Application ↔ Technology | Application outages, poor performance | Apps designed without understanding infrastructure limits |
| Business ↔ Technology | Technology investments don't move the business forward | No traceability from tech spend to capability improvement |

### The TOGAF Content Framework

TOGAF's Architecture Content Framework provides a formal metamodel for how artifacts in each domain relate to each other. Key relationships:

- **Business Function** → realized by → **Application Service**
- **Application Service** → uses → **Data Entity**
- **Application Component** → deployed on → **Technology Component**
- **Business Actor** → assigned to → **Business Role** → performs → **Business Process**

---

## 6. Architecture Views and Viewpoints

### IEEE 42010 Foundation

TOGAF 10 aligns to **ISO/IEC/IEEE 42010:2011** (formerly IEEE 1471):

| Term | Definition |
|---|---|
| **Concern** | An interest of a stakeholder in the architecture (e.g., "How does data flow between systems?") |
| **Viewpoint** | A template or specification that defines how to construct a view for a particular concern |
| **View** | The actual artifact produced by applying a viewpoint to the architecture description |
| **Stakeholder** | Any person or organization with an interest in the system |

The relationship: **Stakeholders have concerns → Concerns are addressed by Viewpoints → Viewpoints produce Views**

### Constructing Stakeholder-Specific Views

Step-by-step process:
1. **Identify stakeholders** — who has an interest in this architecture?
2. **Identify concerns** — what questions does each stakeholder need answered?
3. **Select viewpoint** — which TOGAF viewpoint addresses those concerns?
4. **Create view** — produce the artifact using the selected viewpoint's conventions
5. **Validate view** — confirm with the stakeholder that their concerns are addressed

### Key Viewpoints by Domain

#### Business Architecture Viewpoints

| Viewpoint | Addresses | Typical View Produced |
|---|---|---|
| **Organization** | Structure, reporting lines, roles | Org chart, RACI matrix |
| **Goal/Objective** | Strategic intent, KPIs, drivers | BMM diagram, balanced scorecard |
| **Business Process** | How work gets done, automation opportunities | BPMN process diagrams, swim-lane charts |
| **Business Function** | Stable capabilities, function hierarchy | Business capability map |

#### Data Architecture Viewpoints

| Viewpoint | Addresses | Typical View Produced |
|---|---|---|
| **Information Systems (Conceptual)** | What data exists, key relationships | Conceptual data model |
| **Data Flow** | How data moves between processes/systems | Data flow diagram (DFD) |
| **Data Security** | Data classification, access, privacy | Data security diagram, classification matrix |

#### Application Architecture Viewpoints

| Viewpoint | Addresses | Typical View Produced |
|---|---|---|
| **Application Portfolio** | What applications exist, their status | Portfolio catalog, heat map |
| **Application Communication** | Runtime interactions between applications | Communication diagram, sequence diagram |
| **System Use-Case** | Actor-system interactions, functional scope | UML use-case diagram |

#### Technology Architecture Viewpoints

| Viewpoint | Addresses | Typical View Produced |
|---|---|---|
| **Infrastructure** | Physical and virtual compute resources | Deployment diagram, infrastructure map |
| **Networked Computing** | Network topology, hardware placement | Network diagram, rack diagrams |
| **Platform Decomposition** | Platform structure and component hierarchy | Platform decomposition diagram |

---

## 7. Stakeholder Mapping per Domain

| Stakeholder | Primary Domain | Key Concerns | Required Views |
|---|---|---|---|
| **CEO** | Business | Strategic direction, competitive capability, transformation risk | Business capability map, architecture roadmap, value stream map |
| **COO** | Business | Operational efficiency, process automation, cost reduction | Business process diagrams, capability heat map, gap analysis |
| **CDO** | Data | Data quality, master data governance, analytics readiness | Data entity catalog, data flow diagram, data lineage |
| **CIO** | Application | Application portfolio health, integration costs, modernization | Application portfolio catalog, comms diagram, migration roadmap |
| **CTO** | Technology | Platform strategy, cloud adoption, security posture, CapEx/OpEx | Platform decomposition, network diagram, tech standards catalog |
| **CISO** | Technology + Data | Security controls, data privacy, threat surface | Data security diagram, network security zones, access control matrix |
| **Business Unit Head** | Business + Application | Process support, system usability, capability gaps | Business process diagrams, process/application realization diagram |
| **PMO** | All domains | Cost, schedule, dependencies, risk | Architecture roadmap, transition architectures, gap analysis |
| **Data Steward** | Data | Data quality rules, ownership, definitions | Data entity catalog, data quality scorecard, lifecycle diagram |
| **Integration Architect** | Application + Technology | Integration patterns, API standards, middleware | Application communication diagram, ESB/API topology |

---

## 8. Exam Tips

### Critical Domain Boundaries

- The TOGAF exam tests precise knowledge of which artifacts belong to which domain. Common traps:
  - **Business Footprint diagram** → Business Architecture (not Application)
  - **Application Communication diagram** → Application Architecture (not Technology)
  - **Platform Decomposition diagram** → Technology Architecture (not Application)
  - **Conceptual Data Model** → Data Architecture (though it may reference business objects)

### "Information Systems Architecture" = Data + Application Combined

- **Phase C** in the ADM covers both Data and Application as the "Information Systems Architecture"
- Within Phase C, Data Architecture is typically done **before** Application Architecture
- Rationale: you need to know what data exists before designing the systems that manage it

### ADM Phase Order for BDAT

```
Phase A: Architecture Vision
Phase B: Business Architecture          ← FIRST domain
Phase C: Information Systems            ← Data (first), then Application
    Phase C(Data): Data Architecture
    Phase C(App):  Application Architecture
Phase D: Technology Architecture        ← LAST domain
```

- **Business Architecture** is always done first — it drives all other domains
- **Technology Architecture** is always last — it implements all other domains
- This order is not arbitrary: it reflects top-down derivation of requirements

### Key Distinctions for Exam Scenarios

| Question Pattern | Answer |
|---|---|
| "Which domain addresses business capabilities?" | Business Architecture |
| "Which domain covers data governance and master data?" | Data Architecture |
| "Which domain covers the application portfolio and API strategy?" | Application Architecture |
| "Which domain covers cloud platforms and network topology?" | Technology Architecture |
| "Which phase covers Data Architecture?" | Phase C |
| "Which phase covers Technology Architecture?" | Phase D |
| "What is a viewpoint?" | A template/specification for creating a view (not the view itself) |
| "What does Information Systems Architecture encompass?" | Both Data and Application Architecture (Phase C) |

### Common Exam Scenarios

- An architect needs to show the CEO how IT investments relate to strategic goals → **Business Footprint diagram** (Business Architecture)
- A CDO needs to understand data flows between systems for GDPR compliance → **Data Flow diagram** + **Data Security diagram** (Data Architecture)
- An Integration Architect needs to show which applications communicate → **Application Communication diagram** (Application Architecture)
- A Cloud Architect needs to show how workloads are distributed across cloud regions → **Environments and Locations diagram** (Technology Architecture)
- A CIO wants to rationalize the application portfolio → **Application Portfolio catalog** + **Gartner TIME model** analysis (Application Architecture)

---

## Quick Reference Card

| Domain | ADM Phase | Key Question Answered | First Artifact to Build |
|---|---|---|---|
| Business | B | What must the enterprise be able to do? | Business Capability Map |
| Data | C (first) | What data does the enterprise need to manage? | Conceptual Data Model |
| Application | C (second) | What systems manage the data and support processes? | Application Portfolio Catalog |
| Technology | D | What infrastructure runs the systems? | Technology Standards Catalog |

---

*Part of the TOGAF 10 Mastery Knowledge Base — Architecture Domains (BDAT)*
