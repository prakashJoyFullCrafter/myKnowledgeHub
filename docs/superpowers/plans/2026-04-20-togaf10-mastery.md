# TOGAF 10 Mastery Curriculum Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete TOGAF 10 mastery knowledge base covering every exam topic, practical artifact, and real-world application skill needed for TOGAF Foundation + Practitioner certification and on-the-job proficiency.

**Architecture:** Each section lives in its own numbered directory under `01-TOGAF/` with a comprehensive `README.md`. Content covers theory, key terms, exam tips, and practical templates. New directories are added for topics not covered in the original structure.

**Tech Stack:** Markdown files, structured knowledge base in `/home/prakash/CodeVault/pb/myKnowledgeHub/Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/`

---

## File Map

### Existing — rewrite with full content
| File | Responsibility |
|------|---------------|
| `README.md` | TOGAF 10 overview, structure, TOGAF vs 9.2 changes, how to use this KB |
| `01-ADMCycle/README.md` | All 9 phases + Req. Mgmt — inputs, steps, outputs, key deliverables, exam tips |
| `02-ArchitectureDomains/README.md` | BDAT deep dive — each domain's purpose, concerns, artifacts, stakeholders |
| `03-Governance/README.md` | Architecture Board, compliance, ADRs, ACMM, COBIT/ITIL integration |
| `04-ArchiMate/README.md` | Full ArchiMate 3.1 — layers, elements, relationships, viewpoints, examples |

### New — create with full content
| File | Responsibility |
|------|---------------|
| `05-EnterpriseContinuum/README.md` | Architecture & Solutions Continuum, Foundation→Org-Specific progression |
| `06-ContentFramework/README.md` | Content Metamodel, ABBs vs SBBs, architecture views/viewpoints |
| `07-ArchitectureRepository/README.md` | Repository structure: metamodel, landscape, SIB, reference library, governance log |
| `08-ReferenceModels/README.md` | TRM, III-RM — structure, components, usage in ADM |
| `09-CapabilityBasedPlanning/README.md` | Capability increments, transition architectures, roadmap construction |
| `10-ArchitectureCapabilityFramework/README.md` | Establishing EA practice, skills framework, maturity models |
| `11-TOGAF10Changes/README.md` | What changed from 9.2→10: modular structure, Series Guides, digital/agile/security |
| `12-PracticalArtifacts/README.md` | Templates: Architecture Vision, ADD, ARS, Roadmap, Gap Analysis, Stakeholder Map |
| `13-CertificationPrep/README.md` | Part 1 (40 MCQ) + Part 2 (8 scenario) prep, glossary, 60 practice questions |

---

## Task 1: Master README — TOGAF 10 Overview

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Rewrite README.md with full TOGAF 10 overview**

Content to include:
- What is TOGAF 10 (The Open Group Architecture Framework, 10th Edition, 2022)
- Purpose: common language, proven methodology, reduce risk, increase ROI
- TOGAF 10 modular structure vs 9.2 monolithic
- The 4 architecture domains (BDAT)
- ADM as the core engine
- Enterprise Continuum and Architecture Repository as supporting pillars
- How to use this knowledge base
- Certification path: Foundation (Level 1) → Practitioner (Level 2)

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/README.md
git commit -m "docs: TOGAF 10 master overview README"
```

---

## Task 2: ADM Cycle — Full Phase-by-Phase Content

**Files:**
- Modify: `01-ADMCycle/README.md`

- [ ] **Step 1: Write full ADM content**

For each phase write: Purpose | Key Steps | Inputs | Outputs/Deliverables | Key Techniques | Exam Tip

Phases:
1. Preliminary Phase
2. Phase A — Architecture Vision
3. Phase B — Business Architecture
4. Phase C — Information Systems Architecture (Data + Application)
5. Phase D — Technology Architecture
6. Phase E — Opportunities and Solutions
7. Phase F — Migration Planning
8. Phase G — Implementation Governance
9. Phase H — Architecture Change Management
10. Requirements Management (central)
11. ADM Iteration patterns

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/01-ADMCycle/README.md
git commit -m "docs: TOGAF 10 ADM cycle full phase content"
```

---

## Task 3: Architecture Domains (BDAT) — Deep Dive

**Files:**
- Modify: `02-ArchitectureDomains/README.md`

- [ ] **Step 1: Write full BDAT content**

For each domain: Purpose | Key Concerns | Typical Artifacts | Key Stakeholders | Domain Relationships | Common Interview/Exam Questions

Domains:
- Business Architecture: strategy, org structure, business capabilities, processes, governance
- Data Architecture: data models (conceptual/logical/physical), data flows, master data, data governance
- Application Architecture: application portfolio, integration patterns, APIs, microservices view
- Technology Architecture: infrastructure, platforms, middleware, cloud, networks, security
- How BDAT interrelates (influence flows)
- Architecture Views and Viewpoints per domain

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/02-ArchitectureDomains/README.md
git commit -m "docs: TOGAF 10 BDAT architecture domains deep dive"
```

---

## Task 4: Governance — Full Content

**Files:**
- Modify: `03-Governance/README.md`

- [ ] **Step 1: Write full governance content**

Topics:
- Architecture Board: charter, membership, responsibilities, escalation paths
- Architecture Compliance Reviews: proactive vs reactive, compliance levels (Irrelevant/Consistent/Compliant/Conformant/Fully Conformant/Non-Conformant)
- Dispensation process: when/how exceptions are granted
- Architecture Principles: characteristics, examples (Business, Data, Application, Technology)
- Architecture Repository: role in governance
- Architecture Maturity Models (ACMM): 6 levels
- Governance framework integration: COBIT 2019, ITIL 4
- Architecture Decision Records (ADRs): structure, lifecycle
- Architecture Contracts: definition, content, usage in Phase G

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/03-Governance/README.md
git commit -m "docs: TOGAF 10 architecture governance full content"
```

---

## Task 5: ArchiMate — Full Modeling Language Guide

**Files:**
- Modify: `04-ArchiMate/README.md`

- [ ] **Step 1: Write full ArchiMate 3.1 content**

Topics:
- ArchiMate 3.1 overview and relationship to TOGAF
- Core Framework: 3 layers (Business, Application, Technology) × 3 aspects (Active Structure, Behavior, Passive Structure)
- Full element catalog with notation for each layer
- Relationships: Composition, Aggregation, Assignment, Realization, Serving, Flow, Triggering, Association, Influence, Access
- Motivation aspect: Stakeholder, Driver, Assessment, Goal, Outcome, Principle, Requirement, Constraint, Value
- Strategy layer: Resource, Capability, Course of Action, Value Stream
- Implementation & Migration layer: Work Package, Deliverable, Implementation Event, Plateau, Gap
- Cross-layer relationships
- Key Viewpoints with purpose and example diagrams (text-based)
- Tools: Archi (free, recommended), Sparx EA, BiZZdesign
- Common mistakes

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/04-ArchiMate/README.md
git commit -m "docs: ArchiMate 3.1 full modeling language guide"
```

---

## Task 6: Enterprise Continuum (NEW)

**Files:**
- Create: `05-EnterpriseContinuum/README.md`

- [ ] **Step 1: Create directory and write content**

Topics:
- What is the Enterprise Continuum: a classification system for architecture assets
- Architecture Continuum: Foundation → Common Systems → Industry → Organization-Specific
- Solutions Continuum: parallel to Architecture Continuum but for solution assets
- How it supports re-use and avoids reinventing the wheel
- Relationship to Architecture Repository
- Usage in ADM phases (especially Phase E)
- Examples at each level
- Exam tips

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/05-EnterpriseContinuum/
git commit -m "docs: TOGAF 10 Enterprise Continuum"
```

---

## Task 7: Content Framework & Metamodel (NEW)

**Files:**
- Create: `06-ContentFramework/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- Purpose of the Content Framework: consistent structure for architecture outputs
- Architecture Building Blocks (ABBs): what they are, how defined, examples
- Solution Building Blocks (SBBs): what they are, relationship to ABBs, examples
- ABB vs SBB comparison table
- Content Metamodel: entities and relationships (Actor, Role, Function, Process, Service, etc.)
- Architecture Artifacts: catalogs, matrices, diagrams — examples per ADM phase
- Architecture Deliverables vs Artifacts: key distinction
- Views and Viewpoints: how to construct stakeholder-specific views
- ISO/IEC/IEEE 42010 alignment

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/06-ContentFramework/
git commit -m "docs: TOGAF 10 Content Framework and Metamodel"
```

---

## Task 8: Architecture Repository (NEW)

**Files:**
- Create: `07-ArchitectureRepository/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- Architecture Repository overview: central store for all architecture work
- 6 classes of information:
  1. Architecture Metamodel
  2. Architecture Capability
  3. Architecture Landscape (Strategic/Segment/Capability architectures)
  4. Standards Information Base (SIB)
  5. Reference Library (guidelines, templates, patterns, viewpoints)
  6. Governance Log (decision log, compliance assessments, ADRs)
- Relationship to Enterprise Continuum
- How to populate the repository during ADM
- Architecture Landscape: Strategic vs Segment vs Capability Architecture — differences
- Tooling considerations

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/07-ArchitectureRepository/
git commit -m "docs: TOGAF 10 Architecture Repository structure"
```

---

## Task 9: Reference Models — TRM & III-RM (NEW)

**Files:**
- Create: `08-ReferenceModels/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- Technical Reference Model (TRM): purpose, taxonomy, application platform, external environment
- TRM Service Categories: Data Interchange Services, Data Management Services, Graphics, User Interface, etc.
- Integrated Information Infrastructure Reference Model (III-RM): purpose, components
- III-RM: Brokerage, Federated, Managed Infrastructure
- How to use TRM/III-RM as Foundation Architecture in the Enterprise Continuum
- Applying reference models in Phase D (Technology Architecture)
- TOGAF Library as extended reference library in TOGAF 10
- Industry-specific reference models (BIAN for banking, ARTS for retail, etc.)

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/08-ReferenceModels/
git commit -m "docs: TOGAF 10 Reference Models TRM and III-RM"
```

---

## Task 10: Capability-Based Planning (NEW)

**Files:**
- Create: `09-CapabilityBasedPlanning/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- What is Capability-Based Planning: focus on business outcomes not IT projects
- Business Capability Map: definition, structure, heat mapping
- Capability Increments: how capabilities evolve in steps
- Transition Architectures: intermediate states between Baseline and Target
- Architecture Roadmap: structure, content, how to build one
- Work Packages: definition, relationship to capabilities
- Portfolio and Project Management integration
- Relationship to Phase E and F in ADM
- Example: Banking capability map with maturity levels

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/09-CapabilityBasedPlanning/
git commit -m "docs: TOGAF 10 Capability-Based Planning"
```

---

## Task 11: Architecture Capability Framework (NEW)

**Files:**
- Create: `10-ArchitectureCapabilityFramework/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- Purpose: how to establish and operate an EA practice
- Architecture Board establishment: charter template, governance model
- Architecture Contracts: types, content, lifecycle
- Architecture Compliance: review process, levels, outcomes
- TOGAF Architecture Maturity Model (ACMM): 6 levels (0-5), characteristics of each
- Architecture Skills Framework: 7 categories, proficiency levels
- Architecture Organization: centralized, federated, hybrid models
- Funding and resource models for EA
- Measuring EA value: KPIs, metrics
- Integration with IT governance (COBIT 2019)

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/10-ArchitectureCapabilityFramework/
git commit -m "docs: TOGAF 10 Architecture Capability Framework"
```

---

## Task 12: TOGAF 10 vs 9.2 — What Changed (NEW)

**Files:**
- Create: `11-TOGAF10Changes/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- Why TOGAF 10: The Open Group's rationale for the 10th Edition
- Modular structure: TOGAF Fundamental Content + TOGAF Series Guides
- What is TOGAF Fundamental Content (stable, core ADM + framework)
- TOGAF Series Guides list: Digital Transformation, Business Architecture, Security Architecture, etc.
- Changes to ADM: enhanced guidance, better agile integration
- New: Security Architecture guidance
- New: Digital Transformation and AI architecture guidance  
- New: Enhanced Business Architecture (Value Streams, Business Capabilities)
- Enhanced: Agile and DevOps integration with ADM iterations
- Removed/deprecated: what was cleaned up from 9.2
- Exam implications: what TOGAF 10 exams test differently
- Practical impact: how these changes affect real EA work

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/11-TOGAF10Changes/
git commit -m "docs: TOGAF 10 changes and new features vs 9.2"
```

---

## Task 13: Practical Artifacts & Templates (NEW)

**Files:**
- Create: `12-PracticalArtifacts/README.md`

- [ ] **Step 1: Create and write content**

Templates and examples for:
1. **Architecture Vision** (Phase A): scope, stakeholders, constraints, high-level target
2. **Statement of Architecture Work** (Phase A): scope, schedule, acceptance criteria
3. **Architecture Definition Document (ADD)**: baseline and target for each domain
4. **Architecture Requirements Specification (ARS)**: quantified requirements, constraints
5. **Architecture Roadmap**: milestones, work packages, transition states timeline
6. **Gap Analysis Table**: baseline vs target, gaps, remediation actions
7. **Stakeholder Map**: stakeholder matrix with concerns and required views
8. **Architecture Principles Catalog**: 5 example principles per domain with rationale and implications
9. **Architecture Decision Record (ADR)**: standard template with status/context/decision/consequences
10. **Architecture Contract**: parties, deliverables, acceptance criteria, governance
11. **Capability Assessment Heat Map**: example with maturity scoring
12. **Risk Register for Architecture**: architecture-level risk tracking

Each template includes: purpose, when to use, structure, filled example.

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/12-PracticalArtifacts/
git commit -m "docs: TOGAF 10 practical artifacts and templates"
```

---

## Task 14: Certification Prep — Foundation + Practitioner (NEW)

**Files:**
- Create: `13-CertificationPrep/README.md`

- [ ] **Step 1: Create and write content**

Topics:
- **Exam Overview**:
  - TOGAF Foundation (Level 1): 40 MCQ, 60 min, 55% pass, closed book
  - TOGAF Practitioner (Level 2): 8 complex scenario-based, 90 min, 60% pass, open book
- **Part 1 — Foundation topics by weight**: ADM phases (25%), Content Framework (15%), Enterprise Continuum (10%), Architecture Repository (10%), Governance (15%), etc.
- **Part 2 — Practitioner scenario types**: ADM application, stakeholder management, governance decisions
- **Key Definitions to Memorize**: 40+ critical terms
- **60 Practice Questions** covering all domains with answers and explanations
- **Mnemonics and Memory Aids**: ADM phase order, key outputs per phase
- **Common Exam Traps**: wording traps in MCQs, TOGAF-specific terminology vs common usage
- **Study Plan**: 4-week structured plan
- **Resources**: The Open Group official study guide, TOGAF Library, recommended books

- [ ] **Step 2: Commit**
```bash
git add Documents/03-Architecture/03-EnterpriseArchitecture/01-TOGAF/13-CertificationPrep/
git commit -m "docs: TOGAF 10 certification prep Foundation and Practitioner"
```

---

## Self-Review Checklist

- [x] All existing sections covered with full content tasks (Tasks 1-5)
- [x] Enterprise Continuum added (Task 6)
- [x] Content Framework & Metamodel added (Task 7)
- [x] Architecture Repository added (Task 8)
- [x] Reference Models TRM/III-RM added (Task 9)
- [x] Capability-Based Planning added (Task 10)
- [x] Architecture Capability Framework added (Task 11)
- [x] TOGAF 10 changes from 9.2 added (Task 12)
- [x] Practical Artifacts & Templates added (Task 13)
- [x] Certification Prep added (Task 14)
- [x] No placeholders — each task specifies exact content
- [x] File paths are exact and consistent

---

## Coverage Summary

| TOGAF 10 Exam Area | Covered In |
|---|---|
| ADM Phases & Deliverables | Task 2 |
| Architecture Domains (BDAT) | Task 3 |
| Governance | Task 4 |
| ArchiMate | Task 5 |
| Enterprise Continuum | Task 6 |
| Content Framework, ABBs/SBBs | Task 7 |
| Architecture Repository | Task 8 |
| Reference Models (TRM, III-RM) | Task 9 |
| Capability-Based Planning | Task 10 |
| Architecture Capability Framework | Task 11 |
| TOGAF 10 specifics | Task 12 |
| Practical Application | Task 13 |
| Exam Preparation | Task 14 |
