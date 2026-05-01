# Migration Planning (TOGAF Series Guide) - Curriculum

> Deepens **ADM Phase F (Migration Planning)** — how to turn a Target Architecture into a sequenced, financed, governed roadmap with **Transition Architectures** as intermediate states. The "how do we actually get there from here?" of TOGAF.

## Module 1: Why Migration Planning Deserves Its Own Discipline
- [ ] Most EA failures are not bad target architectures — they're **bad transitions** to those targets
- [ ] Symptoms: 3-year roadmaps with no funding model, big-bang migrations that miss every deadline, transitions that increase complexity instead of reducing it
- [ ] **The Series Guide's premise**: Migration Planning is a craft (sequencing, financing, risk, dependencies), not an afterthought to architecture design
- [ ] **Two failure modes**:
  - [ ] **Big-bang migration** — too much risk; a single failure is catastrophic
  - [ ] **Death by 1000 cuts** — endless transitions, never reaching target; "perma-legacy" persists
- [ ] **The right pattern**: a sequence of small, valuable, reversible transitions, each delivering business value AND moving toward the target
- [ ] **Pairs with Strangler Fig** (`03-DataPatterns/04-StranglerFig/`) at the system level — Migration Planning is the enterprise-scale equivalent

## Module 2: Transition Architectures — The Core Concept
- [ ] **Transition Architecture (TA)**: an intermediate, deployable, valuable state on the path from baseline to target
- [ ] Each TA must:
  - [ ] **Deliver standalone business value** — must justify itself even if the next TA is delayed/cancelled
  - [ ] **Be operationally stable** — production-ready, supportable
  - [ ] **Reduce risk for the next TA** — each step makes the next easier
  - [ ] **Have a measurable success criterion** — how do we know the TA is achieved?
- [ ] **TA sequencing principles**:
  - [ ] Start with quick wins (visible value, low risk) to build credibility
  - [ ] Address foundational dependencies early (data model, identity, networking)
  - [ ] Defer high-risk transitions until earlier wins de-risk them
  - [ ] Keep each TA short (3-9 months typically)
- [ ] **Architecture Roadmap**: ordered list of work packages mapped to Transition Architectures and timeline
- [ ] **Difference from a "release plan"**: TA is architectural state, not feature delivery; release plan is what gets shipped at each TA

## Module 3: Gap Analysis & Work Package Identification
- [ ] **Gap analysis** (a recurring ADM technique used heavily in Phase F):
  - [ ] Document Baseline Architecture (current state — by domain BDAT)
  - [ ] Document Target Architecture (desired state)
  - [ ] Identify gaps in 3 categories: **Eliminate** (legacy to retire), **Add** (new capabilities), **Retain** (carry forward as-is)
- [ ] **Per-domain gap matrices**:
  - [ ] Business gaps (capabilities, processes, organisation)
  - [ ] Data gaps (entities, MDM, data flows)
  - [ ] Application gaps (apps to retire, build, buy, modernise)
  - [ ] Technology gaps (platforms, infrastructure, standards)
- [ ] **Work Package**: a logical group of changes that can be planned, funded, executed together
- [ ] **Work Package attributes**: name, scope, dependencies, business value, cost, risk, target TA
- [ ] **Granularity**: small enough to be tractable, large enough to be meaningful — typically 3-9 months of work, single funding line, single accountable owner

## Module 4: Prioritisation & Sequencing
- [ ] **Multiple criteria** balanced together:
  - [ ] **Business value** (revenue, cost saving, risk reduction, regulatory)
  - [ ] **Cost** (capex + opex + opportunity cost)
  - [ ] **Risk** (technical, operational, organisational)
  - [ ] **Dependencies** (what must complete before this can start)
  - [ ] **Stakeholder readiness** (who's bought in, who's resisting)
- [ ] **Common prioritisation tools**:
  - [ ] **Value vs Effort matrix** — quick wins vs strategic bets vs avoid
  - [ ] **Weighted Scoring Model** — multi-criteria with weights per criterion
  - [ ] **WSJF (Weighted Shortest Job First)** from SAFe — `(Business value + Time criticality + RR/OE) / Job size`
  - [ ] **MoSCoW** (Must / Should / Could / Won't) — for stakeholder alignment
- [ ] **Dependency-driven sequencing**:
  - [ ] Build a dependency DAG of work packages
  - [ ] Foundational packages (identity, integration platform) come first
  - [ ] Parallel where possible; serial only where unavoidable
- [ ] **Risk-driven adjustments**:
  - [ ] High-uncertainty packages → spike/PoC before commitment
  - [ ] High-organisational-impact packages → change management runway
  - [ ] High-vendor-risk → vendor evaluation early

## Module 5: Migration Strategies (The "Six Rs" + TOGAF Patterns)
- [ ] Standard application disposition framework (originated by Gartner, refined by AWS):
  - [ ] **Retain** — keep as-is (not yet worth changing)
  - [ ] **Retire** — decommission (replaced by something else, or no longer needed)
  - [ ] **Rehost** ("Lift and shift") — move with no change
  - [ ] **Replatform** — minor adjustments (containerise, change DB engine)
  - [ ] **Refactor** ("Re-architect") — significant code changes for cloud-native / microservices
  - [ ] **Repurchase** — replace with SaaS / COTS
- [ ] **TOGAF complementary patterns**:
  - [ ] **Strangler Fig** — incremental replacement; new system grows, old shrinks (also see `03-DataPatterns/04-StranglerFig/`)
  - [ ] **Parallel running** — both systems live; reconcile outputs; flip when confident
  - [ ] **Branch-by-abstraction** — refactor behind an abstraction layer; swap implementation
  - [ ] **Big bang** — only when other options fail; high risk
- [ ] **Per-application disposition decision**:
  - [ ] Strategic + healthy → **Refactor / Replatform**
  - [ ] Strategic + ailing → **Refactor or Repurchase**
  - [ ] Non-strategic + healthy → **Retain or Replatform**
  - [ ] Non-strategic + ailing → **Retire or Repurchase**
- [ ] **Data migration strategies**: dual-write / shadow read / point-in-time cutover (also see Architecture Patterns / Database Replication modules)

## Module 6: Roadmap, Financing, Governance
- [ ] **Architecture Roadmap document** — the Phase F deliverable:
  - [ ] Sequenced Transition Architectures with timeline
  - [ ] Work packages mapped to each TA
  - [ ] Dependencies, risks, mitigations
  - [ ] Cost estimates per work package
  - [ ] Resource requirements (people, vendor, infra)
  - [ ] Success metrics per TA
- [ ] **Financing model**:
  - [ ] **Project-based** — each work package funded as a project (traditional)
  - [ ] **Product/value-stream funded** — long-lived teams, capacity-based funding (modern)
  - [ ] **Capability-based budgeting** — funding aligned to business capabilities (TOGAF + Capability-Based Planning)
- [ ] **Governance during migration**:
  - [ ] Architecture Compliance reviews at each TA gate
  - [ ] Variance from plan: who decides? what threshold triggers escalation?
  - [ ] Mid-flight target adjustments — when does the target change vs when does the plan change?
- [ ] **Tracking**:
  - [ ] TA achievement vs plan
  - [ ] Capability maturity vs target
  - [ ] Legacy decommissioning vs schedule
  - [ ] Cost actual vs forecast

## Module 7: Anti-Patterns
- [ ] **3-year roadmap nobody owns** — published, never updated, ignored within 6 months
- [ ] **Transitions that don't converge**: each TA adds complexity instead of reducing it; legacy never retires
- [ ] **Financing mismatch**: ambitious roadmap with project-based annual funding → starves multi-year initiatives
- [ ] **No business case per work package** → first budget cut kills the work package; whole roadmap collapses
- [ ] **Hidden migration costs**: data migration, training, parallel running, dual-licensing — always under-estimated
- [ ] **"Big bang for political reasons"** — leadership wants a launch event; engineering knows it's wrong
- [ ] **Architecture-only roadmap, no people/process**: 80% of migration cost is org change, not tech
- [ ] **No sunset plan for legacy**: new system goes live, old system runs forever in parallel
- [ ] **Skipping spike/PoC for high-risk packages** → discover viability after committing budget
- [ ] **Ignoring opportunity cost**: not migrating ALSO has a cost — usually grows over time

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Take a Target Architecture you've defined; sketch 3-4 Transition Architectures between baseline and target — does each deliver standalone value? |
| Module 3 | For one application portfolio, run a gap analysis matrix: per BDAT domain, list eliminate/add/retain |
| Module 4 | Apply WSJF or weighted scoring to a backlog of 10 work packages; defend the resulting order to a stakeholder |
| Module 5 | Apply the Six Rs to your top 20 applications; sketch which become Strangler Fig vs Repurchase vs Retire |
| Module 6 | Draft an Architecture Roadmap for a real initiative: TAs, work packages, dependencies, costs — share with finance and engineering leads |
| Module 7 | Audit your last completed migration: which anti-patterns showed up? What governance/finance changes would have helped? |

## Cross-References
- `01-TOGAF/01-ADMCycle/` — Phase F is the broader context
- `01-TOGAF/09-CapabilityBasedPlanning/` — capability roadmaps feed TAs
- `01-TOGAF/02-ArchitectureDomains/` — gap analysis runs per BDAT domain
- `01-TOGAF/03-Governance/` — TA gates and compliance reviews
- `03-DataPatterns/04-StranglerFig/` — system-level transition pattern
- `02-SolutionArchitecture/01-TradeOffAnalysis/` — work-package decision support
- `02-SolutionArchitecture/04-StakeholderManagement/` — alignment for funding
- `06-DevOps&Delivery/01-DevOps/01-CI&CD/05-DeploymentStrategies/` — execution patterns for individual cutovers

## Key Resources
- **The Open Group: TOGAF Series Guide — Migration Planning**
- **The Open Group: TOGAF Series Guide — Architecture Roadmap & Architecture Vision Templates**
- **AWS Migration Strategy** — "The 6 R's" (canonical reference for application disposition)
- **Strategic Enterprise Architecture Management** - Frederik Ahlemann
- **Enterprise Architecture as Strategy** - Ross, Weill, Robertson (MIT) — operating model alignment
- **Chris Britton: IT Architectures and Middleware** (older but excellent on transition planning)
- **The Phoenix Project** & **The Unicorn Project** - Gene Kim (organisational change in IT)
- **An Elegant Puzzle** - Will Larson (organisational design alongside architecture migrations)
