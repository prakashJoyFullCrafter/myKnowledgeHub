# TOGAF 10 — Architecture Content Framework and Metamodel

## What is the Architecture Content Framework?

The **Architecture Content Framework** is a structural model for categorizing and organizing the outputs of architecture activity. It provides a consistent, repeatable structure for architecture deliverables across organizations, ensuring that architects produce comparable outputs regardless of the organization or domain in question.

The framework solves a common problem: without a standard structure, architecture teams produce ad hoc work products with inconsistent naming, scope, and content — making collaboration, governance, and reuse difficult.

**Core purpose:**
- Provides a common vocabulary for architecture work products
- Ensures completeness — architects know what to produce at each phase
- Enables reuse of architecture assets across projects and organizations
- Supports governance by defining what must be formally approved

The Content Framework is supported by the **Architecture Content Metamodel**, which defines the entity types and their relationships within architecture descriptions.

---

## Three Content Categories

The Architecture Content Framework organizes outputs into three categories:

| Category | Description | Formally Approved? |
|----------|-------------|-------------------|
| Deliverable | Work product contractually specified and reviewed | Yes |
| Artifact | Catalogs, matrices, diagrams produced during architecture work | No (contained in deliverables) |
| Building Block | Reusable packages of functionality | N/A |

---

## Architecture Deliverables

**Deliverables** are formally reviewed, agreed, and signed-off work products. They are produced at the end of ADM phases or as intermediate outputs and represent a commitment from the architecture team to stakeholders.

Each deliverable has a defined owner, audience, and sign-off process. Unlike artifacts (which are working documents), deliverables are the formal outputs that governance bodies review and approve.

### Key Deliverables by ADM Phase

| Deliverable | Phase | Description |
|-------------|-------|-------------|
| Request for Architecture Work | Input to Prelim / Phase A | Triggers the start of an architecture engagement |
| Statement of Architecture Work | Phase A | Defines the scope and approach for the architecture project |
| Architecture Vision | Phase A | High-level view of the target architecture and business value |
| Architecture Definition Document | Phase B, C, D | Detailed description of baseline and target architectures |
| Architecture Requirements Specification | All phases | Quantified requirements derived from architecture decisions |
| Transition Architecture | Phase E/F | Intermediate architectures between baseline and target |
| Architecture Roadmap | Phase E/F | Time-sequenced plan for implementing the target architecture |
| Implementation and Migration Plan | Phase F | Detailed plan for moving from baseline to target |
| Architecture Contract | Phase G | Agreement between development partners and sponsor on deliverables and quality |
| Architecture Compliance Report | Phase G | Assessment of a project's compliance with the defined architecture |
| Change Request | Phase H | Formal request to update an architecture due to change |

### Key Distinctions

- The **Architecture Vision** is a high-level summary; the **Architecture Definition Document** is the detailed elaboration.
- The **Architecture Roadmap** shows the sequence of work packages; the **Implementation and Migration Plan** provides the detailed execution steps.
- The **Architecture Contract** is the governance instrument for Phase G — it holds delivery partners accountable.

---

## Architecture Artifacts

**Artifacts** are catalogs, matrices, and diagrams created during the architecture process. They are more granular than deliverables — they are the constituent elements that get assembled into deliverables. An artifact is not formally approved on its own; it exists inside a deliverable.

### Three Types of Artifacts

#### 1. Catalogs
Lists of building blocks of a particular type. Catalogs provide an inventory of the components in scope.

Examples:
- Organization Catalog
- Driver/Goal/Objective Catalog
- Role Catalog
- Business Service/Function Catalog
- Application Portfolio Catalog
- Data Entity Catalog
- Technology Standards Catalog
- Technology Portfolio Catalog
- Requirements Catalog

#### 2. Matrices
Cross-mappings between two or more elements. Matrices show relationships and dependencies between architecture components.

Examples:
- Stakeholder Map Matrix
- Business Interaction Matrix
- Actor/Role Matrix
- Data Entity/Business Function Matrix
- Application/Function Matrix
- Application Interaction Matrix
- Application/Technology Matrix
- Solution vs Requirements Matrix
- Implementation Factor and Deduction Matrix

#### 3. Diagrams
Visual representations of architecture. Diagrams communicate architecture to stakeholders in an accessible form.

Examples:
- Architecture Vision diagram
- Business Footprint diagram
- Functional Decomposition diagram
- Business Process diagram
- Conceptual Data diagram
- Logical Data diagram
- Application Communication diagram
- Application Use-Case diagram
- Environments and Locations diagram
- Platform Decomposition diagram
- Project Context diagram
- Benefits Realization diagram
- Project Migration diagram

### Artifacts by ADM Phase

| Phase | Key Catalogs | Key Matrices | Key Diagrams |
|-------|-------------|--------------|--------------|
| Prelim | Principles Catalog | — | — |
| A — Architecture Vision | — | Stakeholder Map Matrix | Architecture Vision diagram |
| B — Business Architecture | Organization Catalog, Driver/Goal Catalog | Business Interaction Matrix, Actor/Role Matrix | Business Footprint, Functional Decomposition |
| C — Data Architecture | Data Entity Catalog | Data Entity/Business Function Matrix | Conceptual Data diagram, Logical Data diagram |
| C — Application Architecture | Application Portfolio Catalog | App/Function Matrix, App Interaction Matrix | App Communication diagram, App Use-Case diagram |
| D — Technology Architecture | Technology Standards Catalog, Technology Portfolio Catalog | App/Technology Matrix | Environments and Locations, Platform Decomposition |
| E — Opportunities and Solutions | Requirements Catalog | Solution vs Requirements Matrix | Project Context diagram, Benefits Realization diagram |
| F — Migration Planning | — | — | Project Migration diagram |
| G — Implementation Governance | — | Implementation Factor Matrix | — |

---

## Building Blocks

**Building Blocks** are packages of functionality defined to meet business needs. They are the reusable, composable components that architectures are assembled from.

### Characteristics of Building Blocks

A good building block must be:
- **Reusable** — can be used in multiple contexts
- **Replaceable** — can be swapped out without affecting the rest of the system
- **Well-specified** — has defined functionality, interfaces, and constraints
- **Composable** — can be assembled with other building blocks

Building blocks are defined at two levels of abstraction:

---

### Architecture Building Blocks (ABBs)

ABBs capture architecture requirements — they define **what is needed**, not how it will be provided.

Key characteristics:
- Technology agnostic — no vendor, product, or version assumptions
- Defined in terms of capability, functionality, and interfaces
- Specify the behavior and attributes required of any solution that satisfies this need
- Live in the **Architecture Continuum**
- Typically created during Phase B, C, and D (domain architectures)

**Example:** "Payment Processing Service"
- Must accept card payments
- Must support PCI-DSS compliance
- Must provide transaction confirmation within 3 seconds
- Must expose a REST API

---

### Solution Building Blocks (SBBs)

SBBs represent actual products and components used to implement an architecture — they define **how the need will be delivered**.

Key characteristics:
- Technology specific — tied to a vendor, product, or version
- May be Commercial Off The Shelf (COTS), open source, or custom built
- Conform to ABB specifications
- Live in the **Solutions Continuum**
- Typically identified and selected during Phase E (Opportunities and Solutions)

**Example:** "Stripe Payment Gateway v2024"
- Fulfills the Payment Processing Service ABB
- Specific API version and integration pattern documented
- Vendor SLA and support terms captured

---

### ABB vs SBB Comparison

| Aspect | ABB | SBB |
|--------|-----|-----|
| Purpose | Defines what is needed | Defines how it will be delivered |
| Technology stance | Agnostic | Specific (product/vendor/version) |
| Continuum | Architecture Continuum | Solutions Continuum |
| Created in ADM | Phase B/C/D (domain architectures) | Phase E (Opportunities and Solutions) |
| Example (identity) | Customer Identity Service | Keycloak 22.0 |
| Example (messaging) | Asynchronous Messaging Capability | Apache Kafka 3.6 |
| Stability | More stable — captures enduring need | Changes as technology evolves |
| Approved by | Architecture Board | Solution Review Board / procurement |

---

## Architecture Content Metamodel

The **Architecture Content Metamodel** defines the entity types and their relationships within architecture descriptions. It is the formal structure that governs what entities can exist in an architecture and how they relate to each other.

The metamodel ensures consistent use of terminology and prevents architects from inventing ad hoc entity types. It also enables automated tooling to validate architecture completeness and consistency.

### Core Entity Categories

#### 1. Motivation
Captures why the architecture exists and what it must achieve.

| Entity | Description |
|--------|-------------|
| Driver | Internal or external factor influencing the organization |
| Goal | High-level statement of intent |
| Objective | Measurable outcome supporting a goal |
| Principle | General rule guiding architecture decisions |
| Requirement | Specific need the architecture must satisfy |
| Constraint | Restriction on architecture choices |
| Assumption | Statement taken as true without proof |

#### 2. Actor
Represents parties that perform or are affected by architecture activities.

| Entity | Description |
|--------|-------------|
| Organization Unit | Formal grouping within an organization |
| Actor | Individual, group, or system that performs a role |
| Role | Set of responsibilities performed by an actor |

#### 3. Capability
Represents the abilities the organization needs.

| Entity | Description |
|--------|-------------|
| Business Capability | What the business must be able to do |
| Application Capability | What an application must be able to do |
| Technology Capability | What the technology infrastructure must support |

#### 4. Process
Defines how work is performed.

| Entity | Description |
|--------|-------------|
| Business Process | Sequence of activities producing a business outcome |
| Business Function | Ongoing activity performed by an organization |
| Business Service | Service the business provides to stakeholders |

#### 5. Information
Describes data and information assets.

| Entity | Description |
|--------|-------------|
| Data Entity | A meaningful subject area for data |
| Information System Service | Service provided by an information system |
| Logical Data Component | Logical grouping of data in a system |
| Physical Data Component | Physical storage or data structure |

#### 6. Application
Describes application components.

| Entity | Description |
|--------|-------------|
| Application | A deployable software unit |
| Logical Application Component | Technology-agnostic application component |
| Physical Application Component | A specific product or custom application |

#### 7. Technology
Describes technology infrastructure.

| Entity | Description |
|--------|-------------|
| Technology Service | Service provided by technology infrastructure |
| Logical Technology Component | Technology-agnostic infrastructure component |
| Physical Technology Component | Specific technology product or platform |

#### 8. Location
- **Location:** A place where actors, activities, or components are situated. Used to show geographic or logical distribution.

#### 9. Gap
- **Gap:** Difference between the Baseline Architecture and the Target Architecture in a specific area. Gaps drive the work in Phase E and the roadmap in Phase F.

#### 10. Contract
- **Architecture Contract:** Formal agreement between sponsoring organization and development partners on deliverables, quality measures, and compliance requirements.

---

### Key Relationships in the Metamodel

The metamodel is not just a list of entities — the relationships between entities are equally important.

**Motivation chain:**
```
Driver → motivates → Goal → supports → Objective → realized by → Requirement
```

**Business layer chain:**
```
Organization Unit → performs → Business Process → uses → Role
Business Process → accesses → Data Entity
Business Process → supported by → Application Service
```

**Application layer chain:**
```
Application → realizes → Application Service
Application → uses → Technology Service
```

**Technology layer chain:**
```
Technology Service → provided by → Logical/Physical Technology Component
```

**Cross-layer traceability:**
```
Goal → realized by → Business Capability → supported by → Application → hosted on → Technology
```

This traceability from motivation through to technology is a core value of TOGAF — it allows architects to answer "why does this technology component exist?" by tracing back to business drivers.

---

## Architecture Views and Viewpoints

TOGAF adopts the **ISO/IEC/IEEE 42010** standard for architecture descriptions, which defines a formal vocabulary for expressing architectures to different stakeholders.

### ISO/IEC/IEEE 42010 Key Definitions

| Term | Definition |
|------|-----------|
| Architecture Description | Formal work product that documents an architecture |
| Stakeholder | Individual, team, or organization with interests in the system |
| Concern | An interest in the architecture relevant to one or more stakeholders |
| Viewpoint | Convention for constructing and using a view — a template or specification |
| View | Work product expressing the architecture from the perspective of a viewpoint |

### Viewpoint vs View

The distinction is critical:
- A **Viewpoint** is the template — it defines what a view should contain and how to construct it.
- A **View** is an instance — it applies the viewpoint template to a specific system.

**Analogy:** A viewpoint is like a form template; a view is a completed form for a specific system.

### What a Viewpoint Defines

| Element | Description |
|---------|-------------|
| Purpose | Why this view exists and what decisions it supports |
| Stakeholders | Who uses this view |
| Concerns | What questions this view answers |
| Model kinds | What types of models are included (e.g., diagrams, tables) |
| Modeling conventions | Notation, rules, and guidelines for the view |

### Creating a Stakeholder-Specific View

1. Identify the stakeholder (e.g., Chief Financial Officer)
2. Identify the stakeholder's concerns (e.g., cost, business value, risk)
3. Select the appropriate viewpoint from the TOGAF viewpoint library (e.g., Business Footprint viewpoint)
4. Create the view using the conventions defined in the viewpoint
5. Validate that the view adequately addresses the stakeholder's concerns

### Example: Common TOGAF Viewpoints

| Viewpoint | Target Stakeholders | Primary Concern |
|-----------|--------------------|----|
| Business Footprint | Business executives | Which business units, locations, functions, and services are in scope |
| Functional Decomposition | Business analysts | How business functions break down |
| Application Communication | Integration architects | How applications exchange data |
| Platform Decomposition | Infrastructure architects | How the technology platform is structured |
| Benefits Realization | Portfolio managers | How architecture investments deliver measurable business value |

---

## Key Exam Distinctions

These are the distinctions most commonly tested in TOGAF certification exams:

| Concept Pair | Key Distinction |
|-------------|-----------------|
| Artifact vs Deliverable | Artifacts are contained **inside** deliverables. A deliverable is formally approved; an artifact is not. |
| ABB vs SBB | ABB defines **what** is needed (capability, technology-agnostic). SBB defines **how** it is delivered (product, technology-specific). |
| Architecture vs Architecture Description | The architecture is the fundamental concepts and relationships. The description is the formal documentation of those concepts. |
| View vs Viewpoint | A **viewpoint** is the template/convention. A **view** is the instance/work product created using the viewpoint. |
| Catalog vs Matrix vs Diagram | Three types of artifacts: catalog = list; matrix = cross-mapping; diagram = visual representation. |
| Architecture Continuum vs Solutions Continuum | ABBs live in the Architecture Continuum. SBBs live in the Solutions Continuum. |
| Architecture Vision vs Architecture Definition Document | Vision is high-level (Phase A); Definition Document is detailed (Phase B/C/D). |
| Architecture Roadmap vs Implementation and Migration Plan | Roadmap shows sequence; Migration Plan shows detailed execution steps. |

---

## Summary: Content Framework at a Glance

```
Architecture Content Framework
├── Deliverables (formally approved)
│   ├── Architecture Vision
│   ├── Architecture Definition Document
│   ├── Architecture Requirements Specification
│   ├── Architecture Roadmap
│   ├── Architecture Contract
│   └── Implementation and Migration Plan
│
├── Artifacts (inside deliverables)
│   ├── Catalogs (lists of building blocks)
│   ├── Matrices (cross-mappings)
│   └── Diagrams (visual representations)
│
└── Building Blocks (reusable components)
    ├── ABBs — what is needed (Architecture Continuum)
    └── SBBs — how it is delivered (Solutions Continuum)
```

The Content Framework, combined with the Metamodel and the ADM, forms the complete TOGAF method: the **ADM** tells you the process, the **Content Framework** tells you what to produce, and the **Metamodel** tells you what entities to describe and how they relate.
