# TOGAF 10 - Curriculum

## Module 1: TOGAF Fundamentals
- [ ] What is TOGAF and why it exists (purpose, target users)
- [ ] TOGAF version timeline: TAFIM (1990) → TOGAF 1 (1995) → TOGAF 9 (2009) → TOGAF 9.2 (2018) → TOGAF 10 (2022)
- [ ] The Open Group's role and how TOGAF is governed
- [ ] TOGAF 10 modular structure: Fundamental Content vs Series Guides
- [ ] What changed from TOGAF 9.2 to TOGAF 10 (modular split, Series Guides, certification rename)
- [ ] EA definitions: TOGAF, Gartner, IEEE 42010 — what they share
- [ ] Why EA exists: 6 failure patterns without it (fragmentation, duplication, drift, etc.)
- [ ] How TOGAF compares to Zachman, FEAF, DoDAF, Gartner EA
- [ ] The 5 core components: ADM, Content Framework, Continuum, Repository, Capability Framework

## Module 2: The Four Architecture Domains (BDAT)
- [ ] Business Architecture (Phase B): capabilities, value streams, processes, organisation
- [ ] Data Architecture (Phase C, first sub-phase): entities, models, flows, governance, MDM
- [ ] Application Architecture (Phase C, second sub-phase): portfolio, integrations, APIs, interfaces
- [ ] Technology Architecture (Phase D): infra, platforms, networks, cloud, security
- [ ] Cascade model (top-down requirements) vs Constraint propagation (bottom-up)
- [ ] Domain misalignment patterns and root causes
- [ ] Key artifacts per domain (3+ per domain)
- [ ] Stakeholder mapping per domain (CEO, CDO, CIO, CTO, CISO)

## Module 3: Architecture Views & Viewpoints (ISO 42010)
- [ ] Stakeholder → Concern → Viewpoint → View chain
- [ ] **Critical distinction: Viewpoint = template; View = instance**
- [ ] How to construct a stakeholder-specific view (5-step process)
- [ ] Viewpoints by domain (Organization, App Communication, Platform Decomposition, etc.)
- [ ] Anti-pattern: same diagram for all stakeholders (wall-of-rectangles)

## Module 4: ADM Overview & Iteration
- [ ] The 10 phases: Preliminary + A–H + central Requirements Management
- [ ] ADM as a cycle (Phase H triggers new SoAW → re-enters Phase A)
- [ ] **Requirements Management is at the centre, not in sequence**
- [ ] The 4 iteration patterns: Architecture Context, Architecture Definition, Transition Planning, Architecture Governance
- [ ] Architecture levels: Strategic (5+ years), Segment (1–3 years), Capability (sprint/quarter)
- [ ] Iteration decision matrix (which trigger → which phase to re-enter)
- [ ] Adapting ADM down (small org / Agile) vs up (large enterprise)

## Module 5: ADM Phases — Preliminary & A (Vision)
- [ ] **Preliminary Phase is NOT part of the ADM cycle** — it precedes
- [ ] Preliminary outputs: tailored ADM, Architecture Principles, Repository, Governance Framework
- [ ] Phase A purpose: define vision, secure formal mandate
- [ ] Phase A outputs: Architecture Vision, Statement of Architecture Work (SoAW), Stakeholder Map
- [ ] **Architecture Vision ≠ Architecture Definition Document** (Vision is high-level)
- [ ] Statement of Architecture Work — the project charter contents
- [ ] Phase A signature technique: Business Scenario

## Module 6: ADM Phases — B, C, D (Architecture Definition)
- [ ] Phase B: capability mapping, value streams, process modelling, business gap analysis
- [ ] Phase C(Data): conceptual/logical/physical models, data flows, governance, MDM
- [ ] Phase C(App): application portfolio, integration patterns, API strategy, the 6 Rs
- [ ] **Data sub-phase typically before Application** (need to know data before designing systems)
- [ ] Phase D: infrastructure, platforms, technology standards, TIME model
- [ ] Architecture Definition Document (ADD) — built incrementally across B, C, D
- [ ] Gap analysis as the recurring technique in B, C, D

## Module 7: ADM Phases — E, F (Opportunities & Migration)
- [ ] Phase E: **identifies and creates** initial Architecture Roadmap
- [ ] Transition Architecture: intermediate, stable, valuable, achievable state
- [ ] Each TA must deliver standalone business value (justify itself)
- [ ] Capability Increments — discrete, measurable, time-boxed improvements
- [ ] Work Packages — bounded units of implementation work
- [ ] Phase F: **finalises** roadmap and produces Implementation & Migration Plan
- [ ] **Architecture Roadmap ≠ Migration Plan** (strategic vs detailed delivery)
- [ ] Prioritisation tools: Value vs Effort, WSJF, MoSCoW, Weighted Scoring

## Module 8: ADM Phases — G, H (Governance & Change)
- [ ] Phase G: govern delivery; Architecture Contracts; Compliance Reviews
- [ ] **6 compliance levels**: Irrelevant → Consistent → Compliant → Conformant → Fully Conformant → Non-Conformant
- [ ] Dispensation = formal, **time-bounded** exception with expiry and remediation owner
- [ ] Architecture Contracts — binding agreement between EA and delivery teams
- [ ] **Phase H is continuous, NOT one-time** (runs in parallel with operations)
- [ ] Change classification: Simplification → Incremental → Re-architecting
- [ ] When Phase H produces a new SoAW (major change → new ADM cycle)
- [ ] Requirements Impact Assessment process (7 steps)

## Module 9: Architecture Content Framework
- [ ] **Three categories**: Deliverable (signed off), Artifact (component within deliverable), Building Block (reusable)
- [ ] **Three artifact types**: Catalog (list), Matrix (cross-mapping), Diagram (visual)
- [ ] **ABB vs SBB**: ABB defines WHAT (tech-agnostic); SBB defines HOW (product-specific)
- [ ] ABBs live in Architecture Continuum; SBBs live in Solutions Continuum
- [ ] Architecture Content Metamodel — entity types and relationships
- [ ] Traceability chain: Goal → Capability → Application → Technology

## Module 10: Enterprise Continuum
- [ ] **4 levels (generic → specific)**: Foundation → Common Systems → Industry → Organization-Specific
- [ ] Mnemonic: "Four Companies Invest Organically"
- [ ] Architecture Continuum (patterns) vs Solutions Continuum (products)
- [ ] **Specialise** (left → right): add constraints, tailor to context
- [ ] **Generalise** (right → left): contribute novel patterns back
- [ ] **Continuum classifies; Repository stores** — they are not the same
- [ ] TRM at Foundation level; III-RM at Common Systems level

## Module 11: Architecture Repository
- [ ] **6 classes**: Metamodel, Capability, Landscape, SIB, Reference Library, Governance Log
- [ ] Mnemonic: "My Careful Librarian Stores Reference Guides"
- [ ] Architecture Landscape **3 levels**: Strategic, Segment, Capability
- [ ] Standards Information Base (SIB) — Mandatory / Recommended / Emerging / Deprecated
- [ ] Reference Library — guidelines, templates, patterns, viewpoints
- [ ] Governance Log — Decisions, Compliance, Dispensations, Contracts, Waivers, Change Requests
- [ ] **SIB vs Reference Library**: SIB = standards (what to use); Reference Library = patterns (how to design)

## Module 12: Architecture Capability Framework
- [ ] Capability Framework answers HOW to run EA (vs ADM = WHAT to do)
- [ ] Architecture Board: composition, charter, decision authority (NOT advisory only)
- [ ] Organisation models: Centralised, Federated, **Hybrid (Hub & Spoke) — recommended**
- [ ] Architecture roles: Chief Architect, EA, Domain Architect, Solution Architect, etc.
- [ ] Architecture Decision Records (ADRs) — context, decision, rationale, consequences
- [ ] EA value: vanity metrics (avoid) vs outcome metrics (use)
- [ ] Funding models: project-based, centralised, **capability-based**, platform funding

## Module 13: ACMM (Architecture Capability Maturity Model)
- [ ] **6 levels (0–5)**: None → Initial → Under Development → **Defined** → Managed → Optimizing
- [ ] Mnemonic: "Nobody Invites Under-Developed Managers Over"
- [ ] **Level 3 (Defined) is minimum viable** governance state
- [ ] 9 assessment characteristics (Process, Development, Business Linkage, etc.)
- [ ] Realistic targets: most orgs Level 3; financial services Level 4; Level 5 rare
- [ ] Multi-year roadmap: 1 level per 18–24 months typically
- [ ] Spider chart visualisation across characteristics
- [ ] Anti-patterns: maturity theatre, score inflation, mixing models mid-cycle

## Module 14: Architecture Skills Framework
- [ ] **8 architect role categories**: ARB Member, Sponsor, Manager, EA, Business, Data, Application, Technology Architect
- [ ] **7 skill categories**: Generic, Business, EA Skills, PM, IT General, Technical IT, Legal & Regulatory
- [ ] **4 proficiency levels**: Background → Awareness → Detailed → Expert
- [ ] Role × Skill × Proficiency matrix per role
- [ ] Career paths: Vertical (depth), Horizontal (breadth), T-shaped (hybrid)
- [ ] Modern competencies under-emphasised: cloud-native, DevOps, ML/AI, sustainability, zero-trust
- [ ] SFIA as alternative skills framework

## Module 15: ADM Techniques
- [ ] **Architecture Principles**: 4-part format (Name, Statement, Rationale, Implications)
- [ ] 5 quality criteria: Understandable, Robust, Complete, Consistent, Stable
- [ ] 4 categories: Business, Data, Application, Technology
- [ ] **Stakeholder Management**: Power/Interest grid (Manage Closely / Keep Satisfied / Keep Informed / Monitor)
- [ ] RACI for architecture decisions (Responsible, Accountable, Consulted, Informed)
- [ ] **Business Scenarios**: SMART test + 6 components (Problem, Environment, Objectives, Human Actors, Computer Actors, Roles)
- [ ] Used in Phase A primarily; refined through B/C/D
- [ ] **Gap Analysis**: 3 operations (Eliminate / Retain / New)
- [ ] Gap Matrix structure (baseline rows × target columns)
- [ ] **PPT lens** (People / Process / Technology) — not just tech gaps
- [ ] Capability-Based Planning: Capability Map + Heat Map + Increments

## Module 16: Reference Models (TRM & III-RM)
- [ ] **TRM = Technical Reference Model = Foundation Architecture** (most generic)
- [ ] **TRM is a TAXONOMY, not a product catalog** — service categories, not vendors
- [ ] TRM service categories: Data Management, Data Interchange, UI, System Mgmt, Network, OS, Security, etc.
- [ ] **III-RM = Common Systems Architecture** (one level more specific than TRM)
- [ ] III-RM 3 components: Brokerage Services, Managed Infrastructure, Federated Infrastructure
- [ ] Industry reference models: BIAN (banking), eTOM (telco), HL7 (healthcare), ARTS (retail)
- [ ] Process: inventory baseline → identify gaps → select products → populate SIB → drive rationalisation

## Module 17: ArchiMate Modeling Language
- [ ] ArchiMate 3.2 — TOGAF's natural visual notation companion
- [ ] **3×3 metamodel**: Business / Application / Technology layers × Active Structure / Behavior / Passive Structure
- [ ] Cross-cutting layers: Motivation, Strategy, Implementation & Migration
- [ ] Key elements per layer (Actor, Component, Node, Service, Object, Artifact, etc.)
- [ ] **Key relationships**: Composition, Aggregation, Assignment, Realization, Serving, Access, Triggering, Flow
- [ ] **Realization direction: concrete → abstract** (App Service realizes Business Service)
- [ ] Color conventions per layer (Business=yellow, App=blue, Tech=green, Motivation=purple)
- [ ] Key viewpoints: Layered, Motivation, Migration, Application Cooperation, Technology Usage
- [ ] ArchiMate ↔ TOGAF ADM phase mapping
- [ ] Tools: Archi (free), Sparx EA, BiZZdesign HoriZZon

## Module 18: Series Guide — Business Architecture
- [ ] Business Motivation Model (BMM): Vision → Goal → Objective → Strategy → Tactic → Business Rule
- [ ] **Capability** = WHAT (stable); **Process** = HOW (volatile); **Function** = WHO
- [ ] Capability characteristics: stable, outcome-focused, technology-agnostic, hierarchical, assessable
- [ ] Capability hierarchy: Domain (L1) → Capability (L2) → Sub-Capability (L3)
- [ ] Capability Maturity Scale (1–5): Initial → Developing → Defined → Managed → Optimizing
- [ ] Value Stream characteristics: stable, outside-in, stakeholder-perspective
- [ ] Value Stream stages: Value Item, Triggering Event, Entry/Exit Criteria, Participating Capabilities
- [ ] **Business Object (Phase B)** vs **Data Entity (Phase C)** — concept vs technical
- [ ] BIZBOK alignment with TOGAF Business Architecture

## Module 19: Series Guide — Security Architecture
- [ ] **Security is cross-cutting across ALL 4 BDAT domains**, not just Technology
- [ ] **STRIDE** threat modeling: Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation
- [ ] **Zero Trust Architecture (NIST SP 800-207)**: never trust, always verify
- [ ] Zero Trust components: IdP + MFA, Device Trust, Micro-segmentation, JIT access
- [ ] **OWASP Top 10** as mandatory app baseline
- [ ] **Defense in Depth (6 layers)**: Perimeter → Network → Host → Application → Data → Identity
- [ ] Security activities in each ADM phase (Preliminary through H)
- [ ] Security ABBs (IAM, Crypto, Audit, Threat Detection, Network Security, Cert Management)
- [ ] **SABSA** as security-depth complement to TOGAF

## Module 20: Series Guide — Digital Transformation & Cloud
- [ ] Cloud service models: IaaS, PaaS, SaaS, FaaS, CaaS — and TOGAF domain mapping
  - [ ] Cloud deployment models: Public, Private, Hybrid, Multi-Cloud
  - [ ] **Cloud-First as Architecture Principle** (drives Phase D defaults)
  - [ ] Internal Developer Platform (IDP) pattern as Phase D output
  - [ ] Cloud Landing Zone components (Management, Security, Logging, Network, Workload accounts)
  - [ ] API economy architecture: API Gateway → Microservices → Event Bus → Data Platform
  - [ ] Microservices migration: **Strangler Fig**, Anti-Corruption Layer, DDD bounded contexts
  - [ ] **The 6 Rs**: Retain, Retire, Rehost, Replatform, Refactor, Repurchase
  - [ ] Modern data platform: Ingestion → Storage (lake + warehouse) → Processing → Serving
  - [ ] Data Mesh principles: decentralized ownership, data products, federated governance
  - [ ] Event-Driven Architecture patterns: Event Notification, Event-Carried State, Event Sourcing, CQRS, Saga
  - [ ] AI/ML across BDAT: feature store, model registry, MLOps, vector databases

## Module 21: Series Guide — Agile Architecture
- [ ] TOGAF was always iterative — Series Guide makes it explicit
- [ ] **3 native iteration patterns**: within-phase, phase-to-phase, cycle (Strategic/Segment/Capability)
- [ ] Just-enough, just-in-time architecture
- [ ] ADM-to-Agile/SAFe mapping table (Phase A ↔ PI Planning, Phase G ↔ CI fitness functions)
- [ ] **Architectural Runway** (SAFe) — foundational tech ahead of business demand
- [ ] **Intentional vs Emergent architecture** balance
- [ ] Lightweight artifacts: ADRs, C4 model, arc42 sections, Architecture Kanban
- [ ] **Fitness Functions** (Neal Ford) — Phase G compliance as automated tests in CI
- [ ] Practices: embedded architects, async ADR review on PRs, communities of practice
- [ ] Anti-patterns: BDUF in Agile clothing, governance theatre, standards graveyard

## Module 22: Series Guide — Information Mapping & MDM
- [ ] **Information vs Data**: Information = business meaning; Data = technical representation
- [ ] Information Map 3 layers: Conceptual, Logical, Physical
- [ ] Per element: definition, system of record, owner, steward, lifecycle, sensitivity, quality
- [ ] **4 MDM architecture styles**: Registry, Consolidation, Coexistence, Centralised
- [ ] Match-Merge logic: deterministic, probabilistic, ML-based
- [ ] Survivorship rules (which source wins per attribute)
- [ ] **Information ownership roles**: Owner, Steward, Custodian, Consumer
- [ ] Customer 360 architecture (incl. **consent infrastructure** — non-negotiable)
- [ ] Privacy by design: pseudonymisation, purpose limitation, data minimisation, right to erasure
- [ ] Modern patterns: Data Mesh, Data Fabric, Data Lakehouse, Semantic Layer

## Module 23: Series Guide — Sustainability
- [ ] **3 levels of impact**: Embodied, Operational, Indirect/induced carbon
- [ ] Sustainability NFRs: gCO2e/request, energy proportionality, resource utilisation, demand shifting
- [ ] **Cloud region selection** dominates carbon outcomes (10–50× variance per kWh)
- [ ] Trade-offs: Carbon ↔ Latency, Carbon ↔ Cost, Carbon ↔ Residency
- [ ] **Green Software Foundation 5 principles**
- [ ] Architectural patterns: right-sizing, scale-to-zero, demand shifting/shaping, cold tiers
- [ ] Greenwashing red flags: offsets-only, REC-only "renewable", one-time measurement
- [ ] Tools: Cloud Carbon Footprint, Electricity Maps, Carbon-Aware SDK, Kepler
- [ ] Reporting frameworks: GHG Protocol, CSRD (EU), SEC Climate Disclosure (US), SBTi

## Module 24: Practical Artifacts & Templates
- [ ] **The 11 standard TOGAF deliverable templates**:
  - [ ] Architecture Vision (Phase A)
  - [ ] Statement of Architecture Work (Phase A)
  - [ ] Architecture Definition Document (B/C/D, per domain)
  - [ ] Architecture Requirements Specification (cross-phase)
  - [ ] Gap Analysis Table
  - [ ] Stakeholder Map / Matrix
  - [ ] Architecture Principles Catalog
  - [ ] Architecture Decision Record (ADR)
  - [ ] Architecture Roadmap
  - [ ] Capability Heat Map
  - [ ] Architecture Contract (Phase G)
- [ ] Quick reference: which artifact answers which question
- [ ] ADM phase → primary artifacts mapping

## Module 25: TOGAF Limitations & When NOT to Use It
- [ ] **6 common criticisms**: heavyweight, process-heavy, vague techniques, learning curve, slow tech adaptation, weak for small change
- [ ] When NOT to use full TOGAF (startups, single-team products, pure agile, emergencies, PoCs)
- [ ] **Selective TOGAF** patterns (Phase A only, Architecture Board only, Principles only, ADRs only)
- [ ] Lightweight alternatives: C4 Model, ADRs, SAFe Architecture Runway, Team Topologies, SABSA, DAMA-DMBOK
- [ ] The Pragmatic Architecture Manifesto (right-size, conversation > document, principles > processes)
- [ ] Senior Architect mental models (TOGAF is a MAP not the TERRITORY)
- [ ] When TOGAF IS valuable (500+ IT staff, regulated, $10M+ transformation, exec mandate needed)

## Module 26: Adjacent Frameworks Integration
- [ ] **TOGAF + ArchiMate**: Process + Notation
- [ ] **TOGAF + Zachman**: Process + Classification (complement, not compete)
- [ ] Zachman 6×6 matrix (perspectives × aspects: What/How/Where/Who/When/Why)
- [ ] **TOGAF + ITIL 4**: Architecture + Operations
- [ ] **TOGAF + COBIT 2019**: Architecture + IT Governance (APO03 alignment)
- [ ] **TOGAF + SAFe**: Enterprise Architecture + Agile Delivery (System Architect, PI Planning)
- [ ] **TOGAF + SABSA**: EA + Security depth
- [ ] **TOGAF + DAMA-DMBOK / BIZBOK**: domain-deep practitioner references
- [ ] Integration principle: TOGAF is the organising framework, others fill gaps

## Module 27: Capstone — Design Your EA Practice
- [ ] Org context profile (size, industry, regulatory, maturity)
- [ ] Tailored ADM (which phases full / partial / skipped)
- [ ] Architecture Board charter and reporting line
- [ ] Top-15 Architecture Principles across BDAT
- [ ] ACMM target level + 18-month improvement plan
- [ ] Funding model recommendation
- [ ] Integration plan with adjacent frameworks
- [ ] Anti-pattern guard list (10 behaviours to prevent)
- [ ] First 90-day plan with visible early wins
- [ ] EA value scorecard with 5 outcome metrics

## Module 28: Certification Preparation
- [ ] **Foundation (L1)**: 40 MCQ, 60 min, 55% pass, closed book
- [ ] Foundation topic weights (Basic 15%, Core 25%, ADM 25%, Techniques 10%, Content 10%, Capability 15%)
- [ ] **Practitioner (L2)**: 8 scenarios, 90 min, 60% pass, open book, gradient scoring
- [ ] Combined exam option (80 questions, 150 min)
- [ ] Mnemonics: ADM phase order, Repository 6 classes, Continuum 4 levels, ACMM 6 levels
- [ ] Common exam traps (TRM as taxonomy, Continuum vs Repository, View vs Viewpoint, etc.)
- [ ] 40-term must-know glossary
- [ ] Practice 60+ MCQs to 85%+ before booking Foundation
- [ ] Tab the open-book TOGAF Standard for Practitioner (ADM phases, 6 Repository classes, compliance levels, ACMM)
- [ ] TOGAF 9.x certifications remain valid; not invalidated by TOGAF 10
- [ ] Digital badge via Credly

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Write a 2-page TOGAF cheat sheet from memory; explain BDAT to a non-technical colleague |
| Module 4 | Draw the ADM cycle from memory with all phases and central RM hub |
| Modules 5-8 | Run a paper-ADM cycle on a real or invented enterprise transformation |
| Modules 9-11 | Map 10 real architecture documents to Repository class and Continuum level |
| Modules 12-14 | Self-assess your org's ACMM (8 dims) and your skills (7 categories × 4 levels) |
| Module 15 | Author 8 principles (4-part format), build a 12-stakeholder Power/Interest grid, write a SMART Business Scenario, run a Gap Matrix with PPT lens |
| Module 16 | Map your enterprise's tech to TRM service categories; flag one gap and one duplicate |
| Module 17 | Build 3 ArchiMate views in Archi: Layered, Motivation, Migration |
| Modules 18-23 | Pick one Series Guide; write 2-3 pages on applying it to your industry context |
| Module 24 | Pick one initiative; produce 8+ of the 11 standard artifacts as your portfolio |
| Modules 25-26 | List 3 places at your org where you would NOT use TOGAF + adjacent framework integration map |
| Module 27 | Complete the 10-part capstone for a real or imagined organisation |
| Module 28 | Take Foundation + Practitioner exams |

## Key Resources
- The Open Group TOGAF Standard, 10th Edition (canonical reference)
- TOGAF Library — Series Guides + supplementary content
- ArchiMate 3.2 Specification — companion modeling language
- *The Software Architect Elevator* — Gregor Hohpe
- *Building Evolutionary Architectures* — Ford, Parsons, Kua (fitness functions)
- *Continuous Architecture in Practice* — Erder, Pureur, Woods
- *Enterprise Architecture as Strategy* — Ross, Weill, Robertson (operating model)
- *Designing Data-Intensive Applications* — Martin Kleppmann (Phase C Data depth)
- *Team Topologies* — Skelton, Pais (org design alongside architecture)
- *Master Data Management* — David Loshin
- *Data Mesh* — Zhamak Dehghani
- BIZBOK (Business Architecture Guild), DAMA-DMBOK, SABSA — domain-deep companions
- Archi (archimatetool.com) — free ArchiMate modeling tool
- Cloud Carbon Footprint (CNCF) — sustainability measurement
