# Agile Architecture (TOGAF Series Guide) - Curriculum

> **The TOGAF Series Guide on Agile Architecture** — how to apply ADM in iterative, fast-cadence delivery contexts (Scrum, SAFe, LeSS, DevOps). The most-cited gap in TOGAF practice; this Series Guide formalises what mature EA teams already do.

## Module 1: The Tension & Why It Matters
- [ ] Classical TOGAF feels heavyweight: long phases, big upfront artifacts, multi-month gates
- [ ] Agile delivery is short-cycle, emergent, decentralised, learning-driven
- [ ] **The conflict**: traditional EA looks like it slows Agile teams; Agile teams view EA as ivory-tower governance
- [ ] **The reality** (per the Series Guide): the ADM does NOT prescribe waterfall — it prescribes a process that can be tailored, iterated, and decentralised
- [ ] **Goal of Agile Architecture**: keep architectural integrity (cross-team alignment, NFRs, reusable assets) while supporting frequent delivery and learning
- [ ] **The architect's role shifts**: from "approver of artifacts" to "embedded enabler" — design for emergence, not specification
- [ ] Symptoms of bad fit: governance theatre (rubber-stamping), shadow architecture (teams ignoring EA), or paralysis (Agile teams blocked on EA decisions)

## Module 2: Iteration in the ADM (the Core Move)
- [ ] **TOGAF was always iterative** — the Series Guide makes this explicit
- [ ] Three iteration patterns the ADM supports natively:
  - [ ] **Within-phase iteration**: work in a phase iterates as understanding grows
  - [ ] **Phase-to-phase iteration**: jump back to earlier phases when new info surfaces
  - [ ] **Cycle iteration**: full ADM cycles at different scopes (Strategic / Segment / Capability) — each cycle is shorter
- [ ] **Architecture levels**: Strategic (years) → Segment (quarters) → Capability (sprints)
  - [ ] Apply ADM at each level with appropriate cadence and detail
- [ ] **Just-enough, just-in-time architecture**: produce the minimum viable architecture artifacts to unblock the next decision — defer the rest
- [ ] **Architecture as a flow of decisions, not a binder of documents** (Mark Richards / Neal Ford framing)
- [ ] **MVP architecture**: deliver minimum architectural foundations that enable the next 3 months of feature work, then iterate

## Module 3: Mapping ADM Phases to Agile Cadences
- [ ] **Preliminary Phase** → done once per organisation (or per major reset); rarely revisited
- [ ] **Phase A (Architecture Vision)** → align to product/portfolio quarterly planning (PI Planning in SAFe)
- [ ] **Phases B/C/D (Business / IS / Technology)** → continuous; updated each iteration as targets evolve
- [ ] **Phase E (Opportunities & Solutions)** → backlog refinement / portfolio epics
- [ ] **Phase F (Migration Planning)** → release planning; transition architectures = MVP releases
- [ ] **Phase G (Implementation Governance)** → embedded in CI/CD pipelines as **automated fitness functions** (Neal Ford)
- [ ] **Phase H (Architecture Change Management)** → continuous via metrics, not annual reviews
- [ ] **Requirements Management** → product backlog (the central, ever-flowing input)
- [ ] **Practical mapping table**:

| ADM Phase | Agile/SAFe Equivalent | Cadence |
|---|---|---|
| Preliminary | EA charter setup | Once / major reset |
| A — Vision | PI Planning, Portfolio Vision | Quarterly |
| B-D — Architectures | Architectural runway, ARTs | Continuous |
| E — Opportunities | Portfolio Kanban epics | Continuous |
| F — Migration | Release Train Planning | Per PI / per release |
| G — Governance | CI/CD fitness functions | Per commit |
| H — Change | DevOps feedback loops | Continuous |

## Module 4: Practical Practices (Series Guide Recommendations)
- [ ] **Architectural Runway** (SAFe term, applies broadly): foundational technical infrastructure built ahead of business demand — enables fast feature delivery
- [ ] **Intentional vs Emergent Architecture**:
  - [ ] **Intentional**: planned, designed, documented (the EA function)
  - [ ] **Emergent**: arises from team-level decisions
  - [ ] Both are needed; balance shifts toward emergent for innovation, intentional for stability
- [ ] **Lightweight architecture documentation**:
  - [ ] **ADRs (Architecture Decision Records)** — Michael Nygard's lightweight format
  - [ ] **C4 Model diagrams** (see `02-SolutionArchitecture/05-C4Model/`)
  - [ ] **arc42 sections** — adapt the most-relevant 5-8 sections, not all 12
- [ ] **Architecture Kanban**: visualise architecture work-in-progress as a Kanban board (Vision → Defining → Refining → Done)
- [ ] **Architecture as a service**: EA team offers consultations, reviews, design pairing — not a gate
- [ ] **Embedded architects**: senior architect joins delivery team for the first 1-2 sprints of a new initiative; transitions out as patterns stabilise
- [ ] **Communities of practice**: cross-team architects gather to align patterns, share learnings (replaces top-down standards-setting)

## Module 5: Governance in an Agile Context
- [ ] **The shift**: from gates to guardrails
- [ ] **Fitness functions** (Building Evolutionary Architectures — Neal Ford):
  - [ ] Automated tests for architectural characteristics (latency budgets, dependency rules, security policies)
  - [ ] Run in CI; failure = build broken; same as functional tests
  - [ ] Examples: ArchUnit (layer rules), Spectral (API style), Open Policy Agent (deployment policies), load tests for SLOs
- [ ] **Architecture Compliance** (TOGAF concept) realised as fitness functions instead of formal review meetings
- [ ] **Lightweight Architecture Decision Records (ADRs)**:
  - [ ] Capture context, decision, consequences (3-5 paragraphs max)
  - [ ] Stored alongside code in `docs/adr/`
  - [ ] Numbered, immutable; superseded by new ADRs (not edited)
- [ ] **Architecture Review Boards** (ARBs):
  - [ ] Traditional weekly ARB → asynchronous ADR review on PRs
  - [ ] Time-boxed standups for cross-team alignment, not approvals
  - [ ] Reserve formal ARBs for genuinely cross-cutting / high-stakes decisions
- [ ] **Risk-driven governance**: invest review effort proportional to architectural impact (not every change deserves a board meeting)

## Module 6: Anti-Patterns
- [ ] **"BDUF (Big Design Up Front) in Agile clothing"**: long ADM cycles repackaged as "Sprint 0 architecture" → defeats the purpose
- [ ] **"No architecture, just sprints"**: pure emergent architecture in a complex domain → distributed monolith + integration spaghetti within 12 months
- [ ] **"Architects own the architecture, teams own the code"**: false separation — architects must build, build teams must architect
- [ ] **"PowerPoint architecture"**: slides instead of working models, ADRs, or diagrams-as-code
- [ ] **"Governance theatre"**: ARBs that rubber-stamp because no one has time to actually review
- [ ] **"Standards graveyard"**: published standards no one follows, no one enforces
- [ ] **"The runway is too long / too short"**: building infra for use cases that never come, or being constantly blocked by missing infra
- [ ] **Treating Series Guide as prescriptive** — it's adaptive guidance; tailor it to your scale and maturity

## Module 7: SAFe, LeSS, and DevOps Specifics
- [ ] **SAFe (Scaled Agile Framework)**:
  - [ ] **System Architect/Engineer** role aligns to TOGAF Solution Architect
  - [ ] **Enterprise Architect** role at portfolio level aligns to TOGAF EA
  - [ ] **PI Planning** = ADM Phase A iteration cadence
  - [ ] **Architectural Runway** is a SAFe core concept; consistent with TOGAF Reference Architecture
- [ ] **LeSS (Large-Scale Scrum)**:
  - [ ] No formal architect role; architecture is a team responsibility
  - [ ] Better fit for product organisations with strong technical teams
- [ ] **DevOps**:
  - [ ] Infrastructure-as-code, GitOps, CI/CD pipelines = ADM Phase G executed continuously
  - [ ] Observability and SLOs = ADM Phase H feedback loops
  - [ ] Platform Engineering teams provide the architectural runway as self-service
- [ ] **Spotify Model** (cautionary): tribes/squads/chapters became famous, but Spotify themselves moved past it — beware blindly adopting any framework

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Take a quarterly EA cycle and re-plan it as 3 iterations at Capability level instead of one big cycle |
| Module 3 | Map your team's last quarter to the ADM Phase mapping table — where did EA show up, where did it lag behind, where did it block? |
| Module 4 | Try the Embedded Architect pattern: pair a senior architect with a delivery team for 4 weeks; observe what changes |
| Module 4 | Replace the next "architecture document" with: 5 ADRs + C4 container diagram + arc42 sections 5 & 7 only |
| Module 5 | Pick one architectural rule (e.g. "domain modules must not import infra") — encode as ArchUnit fitness function in CI |
| Module 5 | Convert a weekly ARB meeting to async ADR review on PRs for one quarter; measure decision throughput |
| Module 7 | If on SAFe: audit Architectural Runway maturity — what's foundational and built? What's missing and blocking PIs? |

## Cross-References
- `01-TOGAF/01-ADMCycle/` — the underlying ADM that gets tailored
- `01-TOGAF/03-Governance/` — formal governance recast as guardrails
- `01-TOGAF/10-ArchitectureCapabilityFramework/` — EA practice operating in Agile
- `01-TOGAF/12-PracticalArtifacts/` — lightweight artifact templates
- `02-SolutionArchitecture/05-C4Model/` — the modern lightweight architecture diagram
- `02-SolutionArchitecture/03-ArchitectureDocumentation/` — ADRs, arc42, living docs
- `06-DevOps&Delivery/01-DevOps/01-CI&CD/` — the pipelines that execute Phase G & H
- `06-DevOps&Delivery/01-DevOps/05-SRE&Reliability/` — SLOs as architectural fitness measures

## Key Resources
- **The Open Group: TOGAF Series Guide — Applying the TOGAF ADM with Agile Sprints** (the canonical guide)
- **The Open Group: TOGAF Series Guide — Agile Architecture** (companion)
- **Building Evolutionary Architectures** - Neal Ford, Rebecca Parsons, Patrick Kua (fitness functions)
- **Continuous Architecture in Practice** - Murat Erder, Pierre Pureur, Eoin Woods
- **Lean Enterprise** - Jez Humble, Joanne Molesky, Barry O'Reilly
- **SAFe documentation** - scaledagileframework.com (Architectural Runway, System Architect role)
- **"Lightweight Architecture Decision Records"** - Michael Nygard
- **arc42 documentation** - arc42.org (lightweight architecture template)
- **C4 Model** - c4model.com (Simon Brown)
