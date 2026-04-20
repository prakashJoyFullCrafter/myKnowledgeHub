# TOGAF 10 — Architecture Development Method (ADM)

The ADM is the core of TOGAF — a repeatable, iterative process for developing and managing enterprise architectures. It provides a tested, repeatable process for developing architectures within an enterprise, and defines phases A through H plus the central Requirements Management process. The cycle can be adapted, iterated, and partitioned to suit any organizational context.

---

## Table of Contents

1. [ADM Overview](#adm-overview)
2. [Preliminary Phase](#preliminary-phase)
3. [Phase A — Architecture Vision](#phase-a--architecture-vision)
4. [Phase B — Business Architecture](#phase-b--business-architecture)
5. [Phase C — Information Systems Architecture](#phase-c--information-systems-architecture)
6. [Phase D — Technology Architecture](#phase-d--technology-architecture)
7. [Phase E — Opportunities and Solutions](#phase-e--opportunities-and-solutions)
8. [Phase F — Migration Planning](#phase-f--migration-planning)
9. [Phase G — Implementation Governance](#phase-g--implementation-governance)
10. [Phase H — Architecture Change Management](#phase-h--architecture-change-management)
11. [Requirements Management (Central Hub)](#requirements-management-central-hub)
12. [ADM Iteration Patterns](#adm-iteration-patterns)
13. [Adapting the ADM](#adapting-the-adm)
14. [Quick-Reference Summary Table](#quick-reference-summary-table)

---

## ADM Overview

The ADM is structured as a cycle with a central Requirements Management process feeding into and receiving from every phase. The outer ring of phases (Preliminary through H) represents the sequential development cycle, while the inner hub (Requirements Management) handles dynamic change throughout.

```
          PRELIMINARY
              |
    H ---- [ A ] ---- B
    |      [R.M.]      |
    G      [Hub]       C
    |                  |
    F ---- [ E ] ---- D
```

**Core Principle:** Architecture is not a one-time event. The ADM supports iteration at multiple levels — within a single phase, across phases, and across entire ADM cycles.

**TOGAF 10 updates over TOGAF 9:**
- Strengthened integration with Agile and DevOps delivery
- Enhanced Business Architecture guidance
- Clearer linkage between ADM phases and Architecture Content Framework
- Improved support for digital transformation use cases

---

## Preliminary Phase

### Purpose

Prepare the organization for successful enterprise architecture activity. The Preliminary Phase defines the "where, what, why, who, and how" of the architecture practice before any formal architecture project begins.

### Objectives

- Define the organizational scope and the entities impacted by the architecture practice
- Confirm governance and support frameworks that will underpin architecture work
- Define the Architecture Team, roles, and responsibilities
- Establish Architecture Principles that guide all subsequent architecture decisions
- Select and tailor the architecture framework (TOGAF or a hybrid) appropriate for the organization
- Implement Architecture Tools and repository infrastructure

### Key Steps

1. **Scope the enterprise organizations impacted** — Identify which business units, geographies, and functions fall within or are affected by the architecture practice.
2. **Confirm governance frameworks** — Align with existing IT governance (e.g., COBIT), project management frameworks (PRINCE2, PMI), and enterprise risk models.
3. **Define the Architecture Team** — Identify Chief Architect, domain architects (Business, Data, Application, Technology), and supporting roles.
4. **Establish Architecture Principles** — Develop a set of qualitative statements that guide architecture decisions. Principles have: Name, Statement, Rationale, and Implications.
5. **Tailor the ADM** — Decide which phases are applicable, sequence variations, and how the ADM connects to other methodologies in use.
6. **Implement Architecture Tools** — Select repository tools, modelling tools (ArchiMate, UML), and collaboration platforms.
7. **Define Architecture Governance** — Establish Architecture Review Boards (ARBs), Architecture Compliance procedures, and escalation paths.

### Inputs

| Input | Description |
|-------|-------------|
| Board/executive strategies | Business direction and strategic intent |
| Business principles, goals, drivers | What the organization values and where it is heading |
| Existing frameworks | IT governance models, risk frameworks in use |
| Existing architecture documentation | Current-state architecture artifacts if any |
| Existing organization models | Org charts, operating models |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Tailored Architecture Framework | TOGAF adapted to organizational context |
| Architecture Principles | Governing statements for all architecture work |
| Architecture Repository (baseline) | Initial structure for storing architecture artifacts |
| Governance Framework | ARB charter, compliance procedures |
| Architecture Capability definition | Roles, skills, tooling, processes |
| Initial Architecture Vision | High-level organizational context (feeds Phase A) |

### Key Techniques

- **Architecture Principles workshop** — Facilitated sessions with executives and key stakeholders to elicit and validate principles.
- **Framework tailoring analysis** — Gap analysis between TOGAF standard and organizational needs.
- **Stakeholder power/interest mapping** — Identify key sponsors and governance bodies.

### Exam Tip

The Preliminary Phase is NOT part of the ADM cycle itself — it precedes the cycle. It answers "Are we ready to do architecture?" before Phase A asks "What architecture do we want?" Outputs of the Preliminary Phase (especially Architecture Principles) become inputs to every subsequent phase. The Architecture Capability is defined here.

---

## Phase A — Architecture Vision

### Purpose

Develop a high-level aspirational vision of the capabilities and business value to be delivered through the enterprise architecture engagement. Phase A scopes the work, secures stakeholder agreement, and produces the formal mandate (Statement of Architecture Work) to proceed.

### Objectives

- Develop a vision of the capabilities and business value to be delivered
- Validate the business context, problem definition, and key requirements
- Identify all key stakeholders and their concerns
- Obtain approval to proceed (Statement of Architecture Work)
- Define the scope and constraints of the architecture work

### Key Steps

1. **Establish the Architecture Project** — Set up the project team, confirm scope, timeline, and resource allocation.
2. **Identify Stakeholders, Concerns, and Requirements** — Use stakeholder management techniques to catalogue who cares about what.
3. **Confirm and elaborate business goals, drivers, and constraints** — Engage executives to validate strategic intent.
4. **Evaluate business capabilities** — Assess current capability level and identify capability gaps to be addressed.
5. **Assess readiness for business transformation** — Understand appetite for change, organizational readiness risks.
6. **Define the scope** — Clarify what is IN scope and what is explicitly OUT of scope for this ADM cycle.
7. **Define significant Architecture Requirements** — High-level functional and non-functional requirements that will shape the architecture.
8. **Confirm Architecture Principles** — Re-validate that the principles from the Preliminary Phase are still applicable.
9. **Develop Architecture Vision** — High-level description of target state covering all four architecture domains.
10. **Define the Target Architecture KPIs and measures** — What does "done" look like?
11. **Identify transformation risks and mitigation approaches** — At a high level.
12. **Develop the Statement of Architecture Work** — The formal contract to proceed; get sign-off from sponsor.

### Inputs

| Input | Description |
|-------|-------------|
| Request for Architecture Work | Trigger from sponsor or business unit |
| Business principles, goals, drivers | Strategic direction |
| Architecture Principles | From Preliminary Phase |
| Existing architecture documentation | Current-state artifacts |
| Governance and legal frameworks | Regulatory constraints |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture Vision document | High-level target state across all domains |
| Statement of Architecture Work (SoAW) | Formal agreement to proceed; scopes and authorizes the project |
| Refined Architecture Principles | Updated if business context warrants |
| Architecture Repository updates | Baseline architecture recorded |
| Stakeholder Map | Who has interest/power in the architecture |
| Communication Plan | How architecture outputs will be communicated |
| Draft Architecture Requirements Spec | High-level requirements captured |

### Key Techniques

- **Business Scenario technique** — A structured method for identifying business requirements that the architecture must address. Scenario defines the business process, actors (people and systems), and the desired outcomes.
- **Stakeholder Analysis** — Power/interest grid; stakeholder management matrix.
- **Value Chain Analysis** — Identify primary and support activities where the architecture creates value.
- **SWOT Analysis** — Understand organizational strengths, weaknesses, opportunities, threats.

### Statement of Architecture Work (SoAW)

The SoAW is a critical TOGAF artifact. It is essentially the project charter for the architecture engagement. Key elements:

| Element | Content |
|---------|---------|
| Title and project request | What triggered this work |
| Architecture project description | Scope and objectives |
| Architecture vision summary | High-level target state |
| Scope | What domains, time horizon, business units |
| Approach | How the ADM will be applied |
| Roles and responsibilities | Architecture Team structure |
| Work plan | Phases, milestones, deliverables schedule |
| Acceptance criteria | How success is measured |
| Signatures | Sponsor and architecture lead sign-off |

### Exam Tip

Phase A produces the SoAW — this is the "contract" that authorizes the architecture project. The Architecture Vision is not the same as the full Architecture Definition Document (ADD); it is a high-level summary. The Business Scenario technique is specifically associated with Phase A. Requirements Management feeds Phase A but Phase A does NOT produce detailed requirements — those emerge in B, C, D.

---

## Phase B — Business Architecture

### Purpose

Develop the Target Business Architecture that describes how the enterprise needs to operate to achieve the business goals, and identify the gap between Baseline and Target.

### Objectives

- Develop the Baseline Business Architecture description (as-is)
- Develop the Target Business Architecture description (to-be)
- Perform a Gap Analysis between Baseline and Target
- Identify candidate Architecture Roadmap components
- Resolve impacts across the Architecture Landscape

### Key Steps

1. **Select reference models, viewpoints, and tools** — Choose appropriate Business Architecture patterns and frameworks (e.g., value chain, capability model).
2. **Develop Baseline Business Architecture** — Document current business capabilities, processes, organizational structure, and information flows.
3. **Develop Target Business Architecture** — Model the desired future state aligned to the Architecture Vision.
4. **Perform Gap Analysis** — Identify what must be added, eliminated, or transformed to move from Baseline to Target.
5. **Define candidate Architecture Roadmap components** — High-level work packages representing the transformation steps.
6. **Resolve impacts with other Architecture Landscape architectures** — Check for conflicts with other architecture projects in flight.
7. **Conduct formal stakeholder reviews** — Validate business architecture with business owners and process owners.
8. **Finalize the Business Architecture** — Produce the formally reviewed and accepted Business Architecture.
9. **Create the Architecture Definition Document (Business section)** — Document baseline and target business architecture.

### Inputs

| Input | Description |
|-------|-------------|
| Architecture Vision | From Phase A |
| Architecture Principles | Preliminary Phase |
| Business strategy and plans | Corporate and business unit plans |
| Organization model | Structure, roles, responsibilities |
| Business process documentation | Existing process maps |
| Architecture Repository | Existing reusable architecture assets |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture Definition Document — Business | Baseline + Target business architecture |
| Architecture Requirements Specification (ARS) | Quantified business requirements |
| Updated Architecture Roadmap components | Initial work packages from gap analysis |
| Stakeholder Review feedback | Documented approvals and concerns |
| Business Architecture domain catalog | Capabilities, processes, roles, locations |

### Key Techniques

| Technique | Description |
|-----------|-------------|
| Business Capability Mapping | Map capabilities to business outcomes; assess maturity |
| Value Chain Analysis | Porter's primary/support activities to identify value creation |
| Value Stream Mapping | End-to-end flow of value from trigger to delivery |
| Business Process Modeling (BPMN) | Detailed process flows for key business scenarios |
| RACI Matrix | Responsibility/accountability mapping for processes and decisions |
| Organization Map | Structure of business units and roles |
| Actor/Role Catalog | Define business actors and their roles in the architecture |
| Business Service/Function Catalog | Comprehensive list of business services |

### Exam Tip

Phase B produces the first section of the Architecture Definition Document (ADD). The ADD is built incrementally across B, C, and D. Gap Analysis in Phase B focuses on business capabilities and processes — not IT systems. The candidate Architecture Roadmap components identified in Phase B feed Phase E. Business Capability Mapping is a core TOGAF 10 technique.

---

## Phase C — Information Systems Architecture

### Purpose

Develop the Target Information Systems Architecture, encompassing both Data Architecture and Application Architecture, to support the Target Business Architecture.

### Overview

Phase C has two major sub-phases that can be done in either order:
- **Data Architecture** — What data is needed, how it is structured, and how it flows
- **Application Architecture** — What applications are needed and how they interact

---

### Phase C.1 — Data Architecture

#### Purpose
Define the types and sources of data required to support the business, and identify the data management capabilities needed.

#### Key Steps

1. **Develop Baseline Data Architecture** — Inventory existing data stores, databases, data flows, and data governance practices.
2. **Develop Target Data Architecture** — Define conceptual, logical, and physical data models for the target state.
3. **Model data flows** — Show how data moves across organizational and system boundaries.
4. **Define data governance** — Data ownership, stewardship, quality rules, and retention policies.
5. **Address master data management** — Identify authoritative sources for key business entities (Customer, Product, etc.).
6. **Perform Gap Analysis** — Identify data gaps, redundant data stores, and data quality issues.

#### Key Artifacts

| Artifact | Description |
|----------|-------------|
| Data Entity/Data Component Catalog | All data entities and their attributes |
| Data Entity/Business Function Matrix | Maps data entities to the business functions that use them |
| Application/Data Matrix | Maps applications to the data they create, read, update, delete |
| Conceptual Data Diagram | High-level data relationships |
| Logical Data Diagram | Detailed entity-relationship model |
| Data Dissemination Diagram | How data flows between systems |
| Data Security Diagram | Data classification and access controls |
| Data Migration Diagram | How data will be moved during transition |

---

### Phase C.2 — Application Architecture

#### Purpose
Define the kinds of application systems needed, their interactions, and their relationships to the core business processes.

#### Key Steps

1. **Develop Baseline Application Architecture** — Inventory existing application portfolio with capabilities and interdependencies.
2. **Develop Target Application Architecture** — Design the target application landscape to deliver business capabilities.
3. **Define integration patterns** — Event-driven, API-based, batch, point-to-point; select appropriate patterns.
4. **Define API strategy** — API governance, API catalog, external/internal boundaries.
5. **Address application migration strategy** — Retire, retain, rehost, replatform, refactor, replace (the 6 R's).
6. **Perform Gap Analysis** — Identify application gaps, redundancy, and fitness-for-purpose issues.
7. **Identify candidate Architecture Roadmap components** — Application-level work packages.

#### Key Artifacts

| Artifact | Description |
|----------|-------------|
| Application Portfolio Catalog | All applications with status, owner, and capability supported |
| Interface Catalog | All application-to-application interfaces |
| Application/Organization Matrix | Maps applications to business units |
| Role/Application Matrix | Maps user roles to applications |
| Application/Function Matrix | Maps application components to business functions |
| Application Communication Diagram | System interaction diagram |
| Application and User Location Diagram | Where applications are deployed and accessed |
| Enterprise Manageability Diagram | How applications are monitored and managed |
| Process/Application Realization Diagram | How business processes are realized by applications |
| Software Engineering Diagram | Application component breakdown |

### Inputs (Phase C)

| Input | Description |
|-------|-------------|
| Architecture Vision | From Phase A |
| Business Architecture | From Phase B |
| Architecture Principles | Including data and application principles |
| Existing data and application documentation | Current-state assets |

### Outputs / Deliverables (Phase C)

| Deliverable | Description |
|-------------|-------------|
| Architecture Definition Document — Data | Baseline + Target data architecture |
| Architecture Definition Document — Application | Baseline + Target application architecture |
| Architecture Requirements Spec updates | Data and application requirements |
| Updated Architecture Roadmap components | From data and application gap analyses |

### Exam Tip

Phase C covers both Data and Application. TOGAF allows them to be done in either order — Data first or Application first — depending on whether the initiative is data-driven or application-driven. The Application Architecture does NOT design individual applications; it defines the portfolio and interactions. Data Architecture establishes master data and data governance, not just database schemas.

---

## Phase D — Technology Architecture

### Purpose

Map the software and hardware capabilities required to support the deployment of Business, Data, and Application services. Define the technology standards, platforms, and infrastructure needed to realize the target architecture.

### Objectives

- Develop the Baseline Technology Architecture (current IT infrastructure)
- Develop the Target Technology Architecture (future infrastructure)
- Identify technology standards and the technology portfolio
- Perform Gap Analysis
- Identify candidate Architecture Roadmap components

### Key Steps

1. **Select reference models, viewpoints, and tools** — Choose technology architecture patterns, cloud models, platform frameworks.
2. **Develop Baseline Technology Architecture** — Document current hardware, software platforms, network topology, hosting models.
3. **Develop Target Technology Architecture** — Design future infrastructure, platforms, and deployment models (cloud, hybrid, on-prem).
4. **Define technology standards** — Approved technologies, versions, and vendor standards.
5. **Perform platform decomposition** — Break down platforms into components: compute, storage, network, middleware, security.
6. **Perform Gap Analysis** — Technology capabilities that are missing, obsolete, or require upgrade.
7. **Identify candidate Architecture Roadmap components** — Infrastructure work packages.
8. **Conduct formal stakeholder reviews** — Validate with infrastructure, security, and operations teams.

### Inputs

| Input | Description |
|-------|-------------|
| Architecture Vision | Phase A |
| Business Architecture | Phase B |
| Data + Application Architecture | Phase C |
| Technology strategy | IT strategy, technology roadmaps |
| Industry technology trends | Cloud, edge computing, AI/ML platforms |
| Architecture Repository | Technology standards catalog |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture Definition Document — Technology | Baseline + Target technology architecture |
| Technology Portfolio Catalog | All technology components with lifecycle status |
| Technology Standards Catalog | Approved standards per category |
| Updated Architecture Roadmap components | Technology-level work packages |
| Architecture Requirements Spec updates | Non-functional requirements (performance, security, HA) |

### Key Artifacts

| Artifact | Description |
|----------|-------------|
| Technology Standards Catalog | Lists approved technologies by category |
| Technology Portfolio Catalog | Inventory of all technology assets |
| Application/Technology Matrix | Maps applications to the technology components they use |
| Environments and Locations Diagram | Where technology components are physically/logically located |
| Platform Decomposition Diagram | Breakdown of platform layers |
| Networked Computing/Hardware Diagram | Network topology and hardware layout |
| Communications Engineering Diagram | Network and communications infrastructure |

### Key Techniques

| Technique | Description |
|-----------|-------------|
| Technology Portfolio Analysis | Assess technologies for lifecycle: emerging, strategic, contained, retirement |
| Gap Analysis | Compare baseline vs target technology capabilities |
| Technology Lifecycle Management | TIME model: Tolerate, Invest, Migrate, Eliminate |
| Cloud Strategy Assessment | IaaS/PaaS/SaaS decisions, multi-cloud strategy |
| Reference Architecture alignment | Map to industry reference architectures (e.g., NIST cloud, TM Forum) |

### Exam Tip

Phase D is the last of the three "architecture definition" phases (B, C, D). After D, all four Architecture Definition Documents (Business, Data, Application, Technology) are complete in draft form. Technology Architecture maps to the other three domains — it is NOT independent. The Technology Architecture must explicitly trace back to the applications it supports, which trace back to the business capabilities.

---

## Phase E — Opportunities and Solutions

### Purpose

Generate the initial complete version of the Architecture Roadmap, based on a gap analysis of the full set of architectures (B, C, D). Identify delivery vehicles (projects, programs, portfolios) and Transition Architectures that allow the organization to move incrementally from Baseline to Target.

### Objectives

- Review and confirm gap analyses from Phases B, C, D
- Consolidate gaps into work packages
- Group work packages into projects and define the initial Architecture Roadmap
- Identify Transition Architectures (intermediate states)
- Assess make/buy/outsource/reuse options for each component
- Identify strategic migration targets

### Key Steps

1. **Determine key corporate change attributes** — Risk appetite, change capacity, investment constraints, political considerations.
2. **Review and consolidate gap analysis results** — Combine gaps from Business, Data, Application, and Technology analyses.
3. **Review consolidated requirements** — Confirm that all Architecture Requirements are captured.
4. **Consolidate and reconcile interoperability requirements** — Identify integration points that span work packages.
5. **Refine and validate dependencies** — Sequence work packages based on logical and technical dependencies.
6. **Confirm readiness and risk for business transformation** — Assess organizational change capacity.
7. **Formulate Implementation and Migration Strategy** — Big Bang vs. incremental; parallel run vs. phased cutover.
8. **Identify and group work packages** — Cluster related changes into manageable delivery units.
9. **Identify Transition Architectures** — Define coherent intermediate architecture states, each of which delivers business value.
10. **Create Architecture Roadmap (initial)** — Sequence work packages and Transition Architectures on a timeline.

### Inputs

| Input | Description |
|-------|-------------|
| Architecture Vision | Phase A |
| Draft Architecture Definition Documents | Phases B, C, D |
| Gap analyses | From B, C, D |
| Architecture Requirements Spec | Consolidated from B, C, D |
| Change requests | From Requirements Management |
| Existing programs and projects | Currently in-flight work |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture Roadmap (initial) | Sequenced work packages and Transition Architectures |
| Transition Architecture documentation | Definitions of each intermediate state |
| Work Package definitions | Scope, dependencies, rough costs, benefits |
| Implementation and Migration Strategy | High-level approach to transition |
| Updated Architecture Definition Documents | Refined based on E-phase analysis |
| Updated Architecture Requirements Spec | Additional requirements surfaced |

### Transition Architectures

A Transition Architecture is a formally defined intermediate state of the enterprise architecture. Each Transition Architecture:

- Delivers tangible business value in its own right
- Is self-consistent (coherent across Business, Data, Application, Technology domains)
- Represents a stable platform for further development
- Has defined entry and exit criteria

Typical sequencing: Baseline → TA1 → TA2 → Target Architecture

### Exam Tip

Phase E is the bridge between "define the architecture" (B, C, D) and "plan the implementation" (F, G, H). The initial Architecture Roadmap is produced here, but it is FINALIZED in Phase F. Transition Architectures are also first defined in Phase E. The make/buy/reuse decision happens in Phase E. Work packages in Phase E are organized into Implementation Projects.

---

## Phase F — Migration Planning

### Purpose

Finalize the Architecture Roadmap and Implementation and Migration Plan. Prioritize projects, perform cost/benefit and risk analysis, and ensure the plan is realistic and agreed upon by all stakeholders.

### Objectives

- Finalize the Architecture Roadmap and Implementation and Migration Plan
- Ensure the plan is aligned with the enterprise's approach to portfolio management
- Confirm transition costs and benefits
- Complete stakeholder buy-in for the migration approach
- Establish formal architecture governance for delivery

### Key Steps

1. **Confirm management framework interactions** — Align with PMO, portfolio management, program management frameworks.
2. **Assign business value to each work package** — Quantify benefits (financial, strategic, risk reduction).
3. **Estimate resource requirements, project timings, and availability** — Realistic resourcing for each work package.
4. **Prioritize migration projects** — Use value/risk/cost analysis to sequence projects.
5. **Confirm architecture roadmap and update Architecture Vision** — Final pass to ensure internal consistency.
6. **Complete the Implementation and Migration Plan** — Detailed plan linking work packages to delivery projects.
7. **Complete the Architecture Development Cycle** — Finalize all Phase A–D deliverables and close the architecture definition cycle.

### Prioritization Factors

| Factor | Description |
|--------|-------------|
| Business value | Direct benefit to business capabilities |
| Risk reduction | How much risk the work package eliminates |
| Strategic alignment | Alignment with corporate strategy |
| Dependencies | Must-do-first items that unblock others |
| Cost and effort | Investment required |
| Quick wins | High value, low effort — build momentum |
| Change capacity | What the organization can absorb |

### Inputs

| Input | Description |
|-------|-------------|
| Architecture Roadmap (initial) | From Phase E |
| Transition Architecture documentation | From Phase E |
| Architecture Vision | Phase A |
| Draft Implementation and Migration Strategy | Phase E |
| Organizational change readiness assessments | Change management inputs |
| Financial planning information | Budget cycles, investment constraints |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Finalized Architecture Roadmap | Agreed, sequenced project list |
| Implementation and Migration Plan | Detailed delivery schedule |
| Finalized Transition Architecture descriptions | Each intermediate state fully defined |
| Architecture contract (draft) | Initial contracts for implementation teams |
| Updated Architecture Definition Documents | Fully finalized versions of all ADDs |
| Updated Business Value Assessment | Benefits realization tracking baseline |

### Exam Tip

Phase F finalizes what Phase E started. The key distinction: Phase E identifies and creates the roadmap; Phase F prioritizes, validates, and finalizes it. The Implementation and Migration Plan (a key Phase F output) is different from the Architecture Roadmap — the Plan is an actionable delivery document with timelines, resources, and budgets. The Architecture Roadmap is the strategic view; the Migration Plan is the operational view.

---

## Phase G — Implementation Governance

### Purpose

Ensure that the implementation and deployment projects align to the agreed architecture. Phase G provides architectural oversight during the delivery of the work packages defined in the Architecture Roadmap.

### Objectives

- Ensure conformance of implementation projects with the defined architecture
- Perform architecture governance of the solution building process
- Handle architectural exceptions and dispensations
- Update the architecture to accommodate approved changes
- Ensure architecture contracts are in place for all projects

### Key Steps

1. **Confirm scope and priorities** — Confirm which projects are in scope for this governance cycle.
2. **Identify deployment resources** — Confirm that implementation teams have the right skills and understanding.
3. **Guide development of solutions deployment** — Provide architectural guidance and oversight to project teams.
4. **Perform enterprise architecture compliance reviews** — Review project deliverables at key milestones against the architecture.
5. **Implement Business and IT operations** — Confirm that operational handover procedures are in place.
6. **Perform post-implementation review** — Assess whether the delivered solution conforms to the architecture.
7. **Close the implementation** — Archive implementation documentation into the Architecture Repository.

### Architecture Contracts

An Architecture Contract is a joint agreement between development partners and sponsors on the deliverables, quality, and fitness-for-purpose of an architecture. Key elements:

| Element | Description |
|---------|-------------|
| Introduction and background | Context for the contract |
| Nature of the agreement | What is being agreed |
| Scope and deliverables | What will be delivered |
| Architecture standards | Standards that must be met |
| Implementation standards | Development, testing, deployment standards |
| Business requirements | Traced business requirements |
| Milestones and dates | Key checkpoints |
| Sign-off | Sponsor, Architecture Lead, Project Lead |

### Compliance Reviews

TOGAF defines a compliance review spectrum:

| Level | Description |
|-------|-------------|
| Irrelevant | The architecture requirement does not apply to this project |
| Consistent | The project is in harmony with the architecture |
| Compliant | The project fully meets the architecture requirements |
| Conformant | The project conforms to the letter of the architecture |
| Fully Conformant | The project conforms to the letter AND spirit |
| Non-Conformant | The project does NOT meet architecture requirements |

Non-conformance triggers an architectural dispensation process.

### Inputs

| Input | Description |
|-------|-------------|
| Finalized Architecture Roadmap | From Phase F |
| Implementation and Migration Plan | From Phase F |
| Architecture Contracts (draft) | Initial from Phase F |
| Architecture Definition Documents | Full set from B, C, D |
| Architecture Requirements Spec | Final version |
| Deployment plans | From implementation projects |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture Contracts (signed) | Formal agreements with implementation teams |
| Compliance Assessments | Results of milestone compliance reviews |
| Change Requests | Issues/changes requiring architecture update |
| Architecture Vision updates | If implementation reveals architecture gaps |
| Architecture Repository updates | New baseline documentation as systems are deployed |
| Business and IT system implemented | The delivered solutions |

### Exam Tip

Phase G is about governance DURING implementation — it is not a passive monitoring role. The Architecture Review Board (ARB) plays a key role here. Compliance reviews are proactive checkpoints, not post-mortems. Architecture Contracts are the mechanism by which the architecture team engages with delivery teams. Dispensations (approved non-conformance) must be formally approved by the ARB.

---

## Phase H — Architecture Change Management

### Purpose

Ensure that the architecture continues to deliver value and remains fit-for-purpose throughout its operational life. Phase H monitors the implemented architecture, manages change requests, and determines when a new ADM cycle is warranted.

### Objectives

- Ensure the architecture lifecycle is maintained
- Monitor technology changes that may trigger architecture updates
- Monitor business changes that may require architecture adjustments
- Manage change requests and assess their architectural impact
- Determine whether changes require a new ADM cycle (major change) or an architecture update (minor change)

### Key Steps

1. **Establish value realization process** — Track whether the implemented architecture is delivering the expected business value.
2. **Deploy monitoring tools** — Establish mechanisms to monitor architecture compliance in the operational environment.
3. **Manage risks** — Ongoing identification and management of residual risks.
4. **Provide analysis for architecture change management** — Evaluate incoming change requests.
5. **Develop change requirements to meet performance targets** — If the architecture is not delivering expected value, define corrective changes.
6. **Manage governance process** — Ensure ongoing architecture governance practices are effective.
7. **Activate process to implement change** — Route approved changes back into the appropriate ADM phase.

### Change Classification

| Change Type | Description | Response |
|-------------|-------------|----------|
| Simplification change | Minor — reduce complexity, no strategic change | Architecture update, no new cycle |
| Incremental change | Moderate — within existing envelope | Update ADD, may re-enter Phase B/C/D |
| Re-architecting change | Significant strategic change | New ADM cycle from Phase A |

### Triggers for a New ADM Cycle

- Significant new business strategy
- Merger, acquisition, or divestiture
- Major technology disruption (new platform, cloud migration at scale)
- Regulatory change requiring fundamental architecture redesign
- Business model transformation

### Inputs

| Input | Description |
|-------|-------------|
| Deployed systems | The current implemented architecture |
| Architecture Repository | Current-state architecture documentation |
| Change requests | From business, IT, or external triggers |
| Performance metrics | Business and IT KPIs |
| Technology change alerts | Vendor roadmaps, product end-of-life notices |
| Governance logs | Compliance review outcomes |

### Outputs / Deliverables

| Deliverable | Description |
|-------------|-------------|
| Architecture updates | Updated ADDs reflecting approved changes |
| Change Requests (new) | Formally logged change requests |
| New Statement of Architecture Work | If a major change triggers a new ADM cycle |
| Revised Architecture Roadmap | Updated roadmap reflecting new priorities |
| Updated Architecture Repository | Reflecting the current-state after changes |

### Exam Tip

Phase H is NOT a one-time activity at the "end" of the ADM — it is an ongoing process that runs in parallel with the operational life of the architecture. The key decision in Phase H is: Is this change minor (update in place) or major (trigger a new cycle)? Phase H outputs a new SoAW when a major change is determined — this re-enters Phase A and starts a new cycle.

---

## Requirements Management (Central Hub)

### Purpose

Requirements Management is the central process of the ADM. It is NOT a sequential phase — it operates continuously throughout the entire ADM cycle, providing a repository for requirements that are identified in any phase.

### Role in the ADM

```
         [Requirements Management]
               /    |    \
          Phase A   |   Phase B
          Phase C   |   Phase D
          Phase E   |   Phase F
          Phase G       Phase H
```

Every phase BOTH:
1. **Feeds requirements INTO** Requirements Management (newly discovered requirements)
2. **Draws requirements FROM** Requirements Management (existing requirements to address)

### Objectives

- Store and manage all architecture requirements throughout the ADM
- Assess the impact of requirements changes
- Ensure that requirements changes are fed back into the appropriate phases
- Maintain traceability between requirements and architecture decisions
- Provide a single source of truth for requirements

### Requirements Impact Assessment

When a requirement changes, a formal Requirements Impact Assessment is performed:

| Step | Action |
|------|--------|
| 1 | Identify the changed/new requirement |
| 2 | Assess which ADM phases are impacted |
| 3. | Assess which architecture artifacts must be updated |
| 4 | Assess downstream impacts on Roadmap and Migration Plan |
| 5 | Seek approval to implement the change |
| 6 | Update all affected artifacts |
| 7 | Re-enter ADM at appropriate phase |

### Change Management for Requirements

Requirements changes are categorized:

| Category | Impact | Action |
|----------|--------|--------|
| Low | Minor clarification, no architectural change | Update ARS, no phase re-entry |
| Medium | Affects one architecture domain | Re-enter relevant B/C/D phase |
| High | Affects multiple domains or strategy | Re-enter Phase A or trigger new cycle |
| Critical | Fundamental strategic change | New SoAW, new ADM cycle |

### Exam Tip

Requirements Management appears at the CENTER of the ADM diagram — this placement is intentional. It is the mechanism that makes the ADM iterative and responsive. Many candidates overlook it as "just a process" but it has equal architectural significance to any named phase. Requirements do not flow in one direction; they cycle continuously.

---

## ADM Iteration Patterns

### Why Iterate?

No organization can develop an enterprise architecture in a single linear pass. Iteration supports:

- Large scope that must be broken into manageable pieces
- Evolving understanding of the target state
- Agile delivery where implementation feedback informs architecture
- Organizational complexity (multiple business units, geographies)
- Long timeframes where business context changes during development

### Iteration Types

TOGAF defines four major iteration categories:

#### 1. Architecture Context Iterations (Preliminary + Phase A)

| Activity | Purpose |
|----------|---------|
| Re-run Preliminary | When organizational context changes fundamentally |
| Re-run Phase A | When a new major project request arrives |
| Typical trigger | New business strategy, new sponsor, new scope |

#### 2. Architecture Definition Iterations (Phases B, C, D)

| Activity | Purpose |
|----------|---------|
| Iterate within B, C, or D | Refine architecture in a single domain |
| Iterate across B → C → D | Discover cross-domain impacts require a domain re-visit |
| Typical trigger | Gap analysis reveals missed requirements; stakeholder feedback |

Multiple passes through B → C → D are common in complex programs. Each pass deepens detail from conceptual → logical → physical.

**Architecture levels within B/C/D:**

| Level | Detail | Purpose |
|-------|--------|---------|
| Conceptual | High-level concepts and relationships | Strategic communication |
| Logical | Abstract model independent of technology | Vendor-neutral design |
| Physical | Specific products, configurations, topology | Implementation guide |

#### 3. Transition Planning Iterations (Phases E, F)

| Activity | Purpose |
|----------|---------|
| Re-run E and F | Adjust roadmap when priorities change |
| Typical trigger | Budget cuts, new acquisitions, technology changes |

#### 4. Architecture Governance Iterations (Phases G, H)

| Activity | Purpose |
|----------|---------|
| Re-run G | New implementation project enters delivery |
| Re-run H | Ongoing monitoring detects change requiring response |
| Typical trigger | New project starts; technology change alert; compliance failure |

### Iteration Decision Matrix

| Trigger | Re-enter at |
|---------|-------------|
| Minor business process change | Phase B |
| New application required | Phase C |
| New technology platform | Phase D |
| Priority change in roadmap | Phase F |
| New implementation project | Phase G |
| Technology product end-of-life | Phase H → D |
| New corporate strategy | Phase A |
| Merger/acquisition | Preliminary |

---

## Adapting the ADM

### Scaling for Small Organizations

Small organizations (< 500 people, single business unit) may:

- **Combine phases** — Merge B, C, D into a single "Architecture Definition" phase
- **Simplify artifacts** — Use lightweight artifacts instead of full TOGAF catalogs/matrices/diagrams
- **Reduce formality** — Informal stakeholder reviews instead of formal ARB sessions
- **Use fewer iterations** — Single pass through B → C → D may be sufficient
- **Lightweight governance** — Architecture Review as part of existing IT governance, not a separate ARB

Key principle: TOGAF is a framework, not a prescription. Use what adds value; omit what doesn't.

### Scaling for Large/Complex Enterprises

Large organizations (multi-divisional, multi-geography, regulated) need additional structure:

#### Architecture Partitioning

| Partition Type | Description |
|----------------|-------------|
| Enterprise Architecture | Top-level, covers entire enterprise; sets direction and standards |
| Segment Architecture | Covers a specific business segment or domain |
| Capability Architecture | Covers a specific capability (e.g., Customer Management) |

**Partitioning relationships:**
- Enterprise Architecture sets constraints and principles
- Segment Architectures elaborate within those constraints
- Capability Architectures implement within segment bounds
- Each level can run its own ADM cycle, coordinated through governance

#### Architecture Landscape

| Landscape | Description |
|-----------|-------------|
| Strategic Architecture | Long-term (3–10 years), transformational direction |
| Segment Architecture | Medium-term (1–3 years), specific domains |
| Capability Architecture | Short-term (< 1 year), specific implementations |

### ADM with Agile Delivery

Agile delivery and TOGAF are not mutually exclusive. The recommended approach:

| Architecture Activity | Agile Equivalent |
|----------------------|-----------------|
| Architecture Vision (Phase A) | Epic/Program Vision |
| Business/Data/App Architecture (B/C/D) | Feature definition across sprints |
| Transition Architecture (Phase E) | Release planning; program increments |
| Implementation Governance (Phase G) | Sprint reviews; definition of done includes architecture compliance |
| Architecture Change Management (H) | Continuous backlog refinement |

**Sprint-based architecture model:**

1. Run Phases A–D at the start of a program to establish the architecture envelope
2. Each sprint/PI delivers within the architecture envelope
3. Sprint review includes architecture compliance check (lightweight Phase G)
4. Architecture backlog items are raised as the program progresses
5. Significant deviations trigger a formal architecture update (re-enter appropriate phase)

**Key principle:** The architecture defines the guardrails; Agile teams have freedom to innovate within those guardrails. Architecture is NOT a bottleneck — it is an enabler.

---

## Quick-Reference Summary Table

| Phase | Purpose | Key Input | Key Output | Key Technique |
|-------|---------|-----------|------------|---------------|
| Preliminary | Prepare the org for architecture | Board strategies, existing frameworks | Architecture Principles, Governance framework | Principles workshop |
| A — Vision | Define scope; get mandate to proceed | Request for Architecture Work | Architecture Vision, SoAW | Business Scenario technique |
| B — Business | Develop target business architecture | Architecture Vision, business strategy | ADD (Business), ARS | Capability Mapping, Value Chain |
| C — IS | Develop data + application architecture | Architecture Vision, Business Architecture | ADD (Data + App), ARS updates | Application Portfolio, Data Modeling |
| D — Technology | Map software/hardware capabilities | IS Architecture, technology strategy | ADD (Technology), Technology Portfolio | Technology Portfolio Analysis |
| E — Opps & Solutions | Initial roadmap; identify Transition Architectures | All ADDs, gap analyses | Architecture Roadmap (initial), Transition Architectures | Dependency analysis, make/buy/reuse |
| F — Migration | Finalize roadmap and migration plan | Roadmap (initial), Transition Architectures | Finalized Roadmap, Implementation & Migration Plan | Cost/benefit, prioritization |
| G — Implementation Governance | Govern delivery; ensure conformance | Finalized Roadmap, deployment plans | Architecture Contracts, Compliance Assessments | Compliance reviews, ARB |
| H — Change Management | Keep architecture fit-for-purpose | Deployed systems, change requests | Architecture updates, new SoAW (if major) | Change classification, impact assessment |
| Requirements Management | Central requirements store and change hub | All phases | Updated requirements flowing to all phases | Requirements Impact Assessment |

---

## ADM Key Artifacts Cross-Reference

| Artifact | Produced In | Used In |
|----------|------------|---------|
| Architecture Principles | Preliminary | All phases |
| Statement of Architecture Work | Phase A | All phases (authorization) |
| Architecture Vision | Phase A | B, C, D, E, F |
| Architecture Definition Document | B (Business), C (Data+App), D (Technology) | E, F, G |
| Architecture Requirements Spec | B, C, D | E, F, G |
| Architecture Roadmap | E (initial), F (final) | G, H |
| Transition Architecture | E, F | G |
| Implementation and Migration Plan | F | G |
| Architecture Contract | F (draft), G (signed) | G |
| Compliance Assessment | G | H |
| Change Request | H, G | H → re-entry |

---

*Reference: TOGAF Standard 10th Edition — The Open Group. ADM phases and deliverables align with the Architecture Content Framework and the Architecture Repository structure.*
