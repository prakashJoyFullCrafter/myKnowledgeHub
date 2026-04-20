# TOGAF 10: What Changed from TOGAF 9.2

---

## Why TOGAF 10? The Rationale

**TOGAF 9.2** was released in 2018 as a monolithic document — a single large standard containing everything from introduction to reference models. This structure served the community well for years, but created a fundamental maintenance problem:

- Technology landscapes shifted rapidly (Agile, Cloud, DevOps, AI, Digital Transformation)
- The monolithic standard could not keep pace without full re-releases
- Practitioners in specialist domains (security, business architecture) needed deeper, current guidance
- Organizations adopting TOGAF partially had to work around sections irrelevant to them

**TOGAF 10** (released April 2022 by The Open Group) solved this by introducing a **modular architecture** for the standard itself. The core stays stable; specialist content evolves independently through Series Guides.

TOGAF 10 also incorporates 20+ years of lessons learned from global TOGAF adoption — feedback from practitioners, certification candidates, and enterprise architecture teams worldwide.

---

## Structural Change: Monolithic to Modular

### TOGAF 9.2: Monolithic Structure

```
TOGAF 9.2 Standard
├── Part I:   Introduction
├── Part II:  ADM (Architecture Development Method)
├── Part III: ADM Guidelines & Techniques
├── Part IV:  Architecture Content Framework
├── Part V:   Enterprise Continuum & Tools
├── Part VI:  Architecture Capability Framework
└── Part VII: Architecture Reference Models (TRM, III-RM)
```

One document. Updated as a whole. Every revision required re-publishing the entire standard.

---

### TOGAF 10: Modular Structure

```
TOGAF Standard, 10th Edition
│
├── TOGAF Fundamental Content (stable, core, exam-tested)
│   ├── Introduction & Core Concepts
│   ├── ADM (Architecture Development Method) — Phase Prelim through H
│   ├── ADM Techniques
│   ├── Architecture Content Framework
│   ├── Enterprise Continuum & Architecture Repository
│   └── Architecture Capability Framework
│
└── TOGAF Series Guides (topic-specific, independently updated)
    ├── TOGAF Series Guide: Business Architecture
    ├── TOGAF Series Guide: Security Architecture
    ├── TOGAF Series Guide: Digital Transformation
    ├── TOGAF Series Guide: Agile Architecture
    ├── TOGAF Series Guide: Architecture Principles
    ├── TOGAF Series Guide: Stakeholder Management
    └── (additional guides released over time)
```

---

### What This Means in Practice

| Dimension | Fundamental Content | Series Guides |
|-----------|-------------------|---------------|
| Stability | High — changes slowly | Evolving — updated as topics mature |
| Scope | Universal EA process | Domain-specific depth |
| Adoption | Must adopt as a whole | Can be adopted selectively |
| Exam coverage | Core exam content | Specified guides included in exam scope |
| Maintenance | Full standard revision | Individual guide updates |

- Organizations can adopt **specific Series Guides** without adopting all of TOGAF
- The Open Group can publish a new Series Guide (e.g., AI Architecture) without revising the Fundamental Content
- Certification exams focus on Fundamental Content plus specified Series Guides

---

## Key Content Changes in TOGAF 10

### 1. Enhanced Business Architecture (Series Guide)

**TOGAF 9.2:** Business Architecture was covered in Phase B with limited guidance — mostly artifact lists and generic techniques.

**TOGAF 10:** Full dedicated Series Guide introducing:

- **Value Stream Mapping** — core tool for identifying how value flows through the enterprise; maps to capability and information flows
- **Business Capability Mapping** — formalized methodology with maturity levels (1–5); capabilities as stable units independent of organizational structure
- **Business Model Canvas integration** — formal connection between Osterwalder's BMC and enterprise architecture
- **Stakeholder value analysis** — structured analysis of who receives value, how, and in what form
- **Business Motivation Model (BMM) alignment** — linking ends (mission/goals/objectives) to means (strategies/tactics) within the architecture

The Series Guide elevates Business Architecture from a secondary concern to a primary architectural domain with its own toolset and vocabulary.

---

### 2. Security Architecture (New Series Guide — Major Addition)

**TOGAF 9.2:** Security was mentioned briefly in a few sections; no systematic guidance existed for integrating security into architecture development.

**TOGAF 10:** Full dedicated Series Guide covering:

- **Security as a cross-cutting concern** — security requirements span all BDAT domains (Business, Data, Application, Technology), not confined to Technology
- **Integrating security requirements into every ADM phase** — security considerations in Phase A through H, not just technology phases
- **Zero Trust Architecture principles** — never trust, always verify; explicit verification; least privilege access
- **Security architecture patterns:**
  - Defense in depth — layered security controls
  - Least privilege — minimum necessary access
  - Micro-segmentation — network and workload isolation
- **Cloud security architecture considerations** — shared responsibility model, cloud-native security patterns
- **Security compliance architecture** — mapping regulatory requirements (GDPR, PCI-DSS, HIPAA) to architecture decisions
- **Security Architecture Building Blocks** — reusable security components for the Architecture Repository

Security Architecture is now a first-class citizen in TOGAF 10 — not an afterthought.

---

### 3. Digital Transformation (New Series Guide)

**TOGAF 9.2:** "Digital" was referenced in passing but not systematically addressed. The standard pre-dated the mainstream digital transformation discourse.

**TOGAF 10:** Dedicated Series Guide covering:

- **Digital transformation in EA terms** — what "digital" means from an architecture perspective vs. business transformation rhetoric
- **Digital capabilities framework** — identifying, assessing, and building digital capabilities
- **Platform architecture thinking** — multi-sided platforms, ecosystem enablement, API-first architecture
- **Data-driven architecture** — data as a strategic asset; analytics, real-time processing, data mesh concepts
- **API economy and ecosystem architecture** — open APIs, partner integrations, marketplace architecture
- **AI/ML capabilities within enterprise architecture** — positioning AI/ML capabilities in the architecture landscape
- **Digital twin concepts** — digital representations of physical entities and their role in architecture planning

---

### 4. Agile Architecture (New Series Guide)

**TOGAF 9.2:** The ADM was often criticized as heavyweight and waterfall-oriented. Agile practitioners struggled to apply TOGAF in iterative delivery environments.

**TOGAF 10:** Agile integration is formally addressed:

- **ADM iteration patterns for Agile delivery** — how to run ADM phases in sprints; iterative scoping; incremental architecture definition
- **Architecture Runway concept** — maintaining just-enough architecture ahead of development teams; architectural enablers in the backlog
- **Lightweight architecture deliverables** — right-sizing outputs for Agile teams; Architecture Decision Records (ADRs) as lean alternatives to full Architecture Definitions
- **Architecture in SAFe (Scaled Agile Framework)** — how TOGAF roles and artifacts map to SAFe's Architecture roles (System Architect, Enterprise Architect, Solution Architect)
- **Just-in-time architecture decisions** — deferring decisions to the last responsible moment; avoiding over-specification
- **Architecture backlogs and prioritization** — architecture work as backlog items; stakeholder-driven prioritization of architectural concerns

---

### 5. Stakeholder Management (Enhanced Series Guide)

Building on TOGAF 9.2's stakeholder concepts, TOGAF 10 provides:

- Formal **stakeholder identification and classification** frameworks
- **Stakeholder engagement strategy** — tailoring communication and involvement by stakeholder type
- **Architecture communication planning** — structured approach to architecture viewpoints for different audiences
- **Concerns-to-viewpoints mapping** — formalized process linking stakeholder concerns to architecture viewpoints and views
- Guidance on managing **stakeholder conflicts** during architecture development

---

### 6. Architecture Principles (Dedicated Series Guide)

TOGAF 9.2 discussed principles but offered limited guidance on their lifecycle management. TOGAF 10 provides:

- Formal guidance on **defining, maintaining, and applying principles**
- **Principles management lifecycle** — creation, approval, monitoring, revision, retirement
- **Conflict resolution between principles** — structured approaches when principles conflict in a given situation
- **Principles library with examples** — reusable principles organized by domain (Business, Data, Application, Technology)
- Linking principles to **governance mechanisms** — how principles become enforceable constraints

---

## ADM Changes in TOGAF 10

### Core ADM Structure: Largely Unchanged

The fundamental ADM structure is preserved in TOGAF 10:

```
Preliminary Phase
    ↓
Phase A: Architecture Vision
    ↓
Phase B: Business Architecture
    ↓
Phase C: Information Systems Architecture (Data + Applications)
    ↓
Phase D: Technology Architecture
    ↓
Phase E: Opportunities & Solutions
    ↓
Phase F: Migration Planning
    ↓
Phase G: Implementation Governance
    ↓
Phase H: Architecture Change Management
    ↓
Requirements Management (central, ongoing)
```

Phase sequence unchanged. Requirements Management still central. The ADM cycle concept intact.

---

### Enhancements to ADM Guidance

| Phase | TOGAF 9.2 | TOGAF 10 Enhancement |
|-------|-----------|---------------------|
| Phase B | Standard business architecture techniques | New tools from Business Architecture Series Guide (Value Streams, Capability Maps) |
| Phase C | Data and application architecture | Enhanced data architecture guidance; modern data patterns referenced |
| Phase D | Technology architecture | More current technology reference examples |
| Phase G | Implementation governance | Strengthened governance guidance incorporating security architecture review |
| All Phases | Linear guidance | Clearer iteration patterns; Agile ADM patterns from Series Guide |

### Iteration and Time-Boxing

TOGAF 10 explicitly addresses ADM iteration:
- Each phase **can be time-boxed** to fit Agile sprint cadences
- ADM can be run at **multiple levels simultaneously** (Strategic, Segment, Capability architectures)
- **Architecture sprints** concept: short, focused architecture cycles preceding development sprints

---

## What Was Removed or Deprecated

TOGAF 10 is primarily **additive**, not subtractive. Key adjustments:

- Some **redundant ADM guidelines consolidated** — duplicate guidance removed; cleaner single-source references
- **Outdated technology references removed from TRM** — Technology Reference Model updated to reflect post-2010 technology landscape
- **Simplified language** in several sections — more accessible prose, reduced jargon in introductory sections
- **Some TOGAF 9.2 examples replaced** with more current, relevant scenarios
- The **monolithic structure** itself was the primary thing "removed" — replaced by modular architecture

**Nothing strategically important was removed.** The transition from 9.2 to 10 is low-friction for practitioners.

---

## Certification Changes

### TOGAF 9.x Certification (Previous)

| Level | Name | Format |
|-------|------|--------|
| Level 1 | TOGAF 9 Foundation | 40 MCQ, closed book, 60 min |
| Level 2 | TOGAF 9 Certified | 8 scenario questions, open book, 90 min |

Passing both levels = awarded "TOGAF 9 Certified" designation.

---

### TOGAF 10 Certification (New)

| Level | Name | Format |
|-------|------|--------|
| Level 1 | TOGAF Foundation | 40 MCQ, closed book, 60 min |
| Level 2 | TOGAF Practitioner | 8 scenario questions, open book, 90 min |

Key changes:
- **"Certified" renamed to "Practitioner"** — reflects the emphasis on applying TOGAF, not just knowing it
- **Badge-based digital credentials** — The Open Group uses Credly for digital badge issuance
- **TOGAF 9.x certifications remain valid** — existing holders are NOT required to re-certify
- Organizations migrating: recommended path is achieving TOGAF 10 Foundation + Practitioner

---

### What TOGAF 10 Exams Test Differently

Topics that gained exam coverage in TOGAF 10:

1. **Modular structure of TOGAF 10** — understanding Fundamental Content vs. Series Guides
2. **Business Architecture concepts** — Value Streams, Capability Mapping (from Series Guide)
3. **Security integration in ADM phases** — where security considerations appear in each phase
4. **Agile ADM patterns** — Architecture Runway, lightweight deliverables, iteration approaches
5. **Digital architecture concepts** — platform thinking, API economy (where Series Guides are in exam scope)

The **exam format is identical** to TOGAF 9 — only content scope expanded.

---

## Practical Impact for Architects

### If You Know TOGAF 9.2

| Knowledge Area | Transfer Status |
|---------------|----------------|
| Core ADM (all 9 phases) | 100% transfers |
| Requirements Management | 100% transfers |
| Enterprise Continuum | Unchanged |
| Architecture Repository | Unchanged |
| Architecture Content Framework | Unchanged |
| Architecture Capability Framework | Unchanged |
| Business Architecture | Partially transfers; deepen with Series Guide |
| Security Architecture | New — requires Series Guide study |
| Digital Architecture | New — requires Series Guide study |
| Agile ADM | Partially; significantly enhanced in Series Guide |

**Upgrade effort is low.** Existing practitioners need to add Series Guide knowledge, not re-learn the foundation.

---

### For New TOGAF Learners (Starting with TOGAF 10)

Recommended learning path:

1. **Start with Fundamental Content** — master the ADM, Architecture Content Framework, and Capability Framework
2. **Add Series Guides relevant to your context:**
   - Doing Business Architecture work? Add Business Architecture Series Guide
   - Working in security or compliance? Add Security Architecture Series Guide
   - In an Agile organization? Add Agile Architecture Series Guide
   - Digital transformation program? Add Digital Transformation Series Guide
3. The modular approach means **incremental learning is supported by design**

---

### For Organizations Adopting TOGAF 10

**Phased adoption is explicitly supported:**

1. **Phase 1:** Adopt Fundamental Content — establish ADM-based architecture practice
2. **Phase 2:** Identify relevant Series Guides — assess which specialist domains need deeper guidance
3. **Phase 3:** Incrementally adopt Series Guides — add Business Architecture, Security, or Agile as needed
4. **Architecture Repository updates:** Add new artifact categories for Series Guide deliverables (Value Stream Maps, Capability Models, Security Building Blocks)
5. **Governance updates:** Update Architecture Board charter to include security architecture review gate; add digital architecture review criteria

---

## TOGAF 10 Quick Reference Summary

| Aspect | TOGAF 9.2 | TOGAF 10 |
|--------|-----------|----------|
| Structure | Monolithic PDF standard | Fundamental Content + Series Guides |
| Business Architecture | Phase B guidance only | Full dedicated Series Guide |
| Security Architecture | Briefly mentioned | Full dedicated Series Guide |
| Digital/AI Architecture | Not systematically addressed | Dedicated Series Guide |
| Agile integration | Limited guidance | Full Series Guide with patterns |
| ADM core phases | Prelim + Phases A–H + ReqMgmt | Same — unchanged |
| ADM iteration guidance | Basic | Enhanced; Agile patterns added |
| Certification Level 1 name | TOGAF 9 Foundation | TOGAF Foundation |
| Certification Level 2 name | TOGAF 9 Certified | TOGAF Practitioner |
| Credential format | Paper/PDF certificate | Digital badges via Credly |
| Standard delivery format | Monolithic PDF | Modular HTML + PDF |
| Update mechanism | Full standard re-release | Individual Series Guide updates |
| Existing certifications | — | TOGAF 9.x remains valid |

---

## Key Exam Points (High Priority)

- **TOGAF 10 = TOGAF Fundamental Content + TOGAF Series Guides** — this structure is a tested concept
- **Fundamental Content is STABLE** — changes slowly; core ADM unchanged from 9.2
- **Series Guides are INDEPENDENTLY UPDATED** — The Open Group can update guides without revising the full standard
- **Security Architecture is a NEW first-class area** in TOGAF 10 — dedicated Series Guide, expected in all architectures
- **ADM core phases are unchanged** between TOGAF 9.2 and TOGAF 10 — same phase sequence, same purpose
- **"Practitioner" is the new name** for what was called "Certified" in TOGAF 9 — same format, new name
- **TOGAF 9.x certifications remain valid** — not invalidated by TOGAF 10 release
- **Organizations can adopt selectively** — specific Series Guides without adopting all TOGAF 10 content
- **Value Streams and Capability Maps** from Business Architecture Series Guide are now exam-relevant concepts
- **Architecture Runway** (Agile Series Guide) — key concept for Agile ADM application

---

## Relationship Between TOGAF 10 and Other Frameworks

TOGAF 10 Series Guides were designed with integration in mind:

| Framework | Integration Point in TOGAF 10 |
|-----------|-------------------------------|
| SAFe (Scaled Agile) | Agile Architecture Series Guide — role mapping and runway concept |
| ITIL 4 | Phase G (Implementation Governance) — service management alignment |
| SABSA | Security Architecture Series Guide — security domain alignment |
| ArchiMate 3 | Architecture Content Framework — modeling language alignment |
| COBIT | Governance Framework — Architecture Capability Framework alignment |
| Business Motivation Model (BMM) | Business Architecture Series Guide — strategy-to-architecture linkage |

TOGAF 10's modular structure makes it **easier to integrate** with other standards — each Series Guide can reference the relevant external framework without forcing the entire TOGAF standard to adopt it.
