# TOGAF Leader's Guide - Curriculum

> **The Open Group: TOGAF Leader's Guide** — for senior architects, Chief Architects, CIOs/CTOs, and EA sponsors. The "what should leadership know about EA, what should they DO about it, and how do they make it stick?" companion to the practitioner-focused TOGAF content.

## Module 1: Why a Separate Leader's Guide
- [ ] TOGAF's depth is overwhelming for executives — they need the **decisions**, not the **deliverables**
- [ ] Leaders fail with EA in distinct ways from practitioners:
  - [ ] Funding mismatch (annual project funding vs multi-year EA)
  - [ ] Sponsorship vacuum (EA reports too low; no executive teeth)
  - [ ] Vanity metrics (artifact counts) instead of value metrics (cost, speed, risk)
  - [ ] Treating EA as an IT cost center rather than a strategic capability
- [ ] **The Leader's Guide premise**: EA succeeds or fails based on **leadership decisions**, not framework choice
- [ ] **Audience**: CIO/CTO, Chief Architect, business executives sponsoring transformation, board members overseeing IT investments
- [ ] **Output of using it well**: EA practice that's funded, sponsored, measured, and visibly drives business outcomes

## Module 2: Articulating EA Value
- [ ] **The hardest leadership question**: "What does EA actually deliver?"
- [ ] **Wrong answers** (vanity metrics):
  - [ ] Number of architecture documents produced
  - [ ] Number of compliance reviews completed
  - [ ] TOGAF certifications held
- [ ] **Right answers** (outcome metrics):
  - [ ] Time-to-market for new initiatives (faster delivery via reusable architecture)
  - [ ] Application portfolio cost reduction (rationalisation, modernisation)
  - [ ] Risk reduction (security, regulatory, vendor concentration)
  - [ ] Strategic agility (ability to pivot — measured via decision speed and rollout cadence)
  - [ ] Talent attraction & retention (modern, well-architected systems → engineers want to work there)
- [ ] **Per-initiative value tracking**: every architecture decision should map to one or more measurable business outcomes
- [ ] **EA scorecard / dashboard**: monthly or quarterly view of value metrics — given to the CEO/board, not just the IT department
- [ ] **The pivot moment**: when leadership starts asking for the EA dashboard before the project status, EA has crossed from cost to strategic capability

## Module 3: Sponsorship & Reporting Structure
- [ ] **EA reporting line matters enormously**:
  - [ ] **CIO direct report** — common; risk of EA seen as IT-internal
  - [ ] **CTO direct report** — better for tech-strategy alignment
  - [ ] **CEO/COO direct report** — rare but powerful; signals enterprise scope
  - [ ] **Buried 3 levels deep in IT** — the reason most EA practices fail
- [ ] **Chief Enterprise Architect** role profile:
  - [ ] Senior leader (VP+); peer to CIO direct reports, not subordinate
  - [ ] Combination of business strategy + tech depth + influence skills
  - [ ] Owns the architecture practice + roadmap + governance + community
  - [ ] Career path: Solution Architect → EA → Chief Architect → CIO/CTO common path
- [ ] **Architecture Board** (governance forum) sponsorship:
  - [ ] Chaired by CIO or Chief Architect
  - [ ] Includes business representation (not just IT)
  - [ ] Has actual decision power (not advisory only)
  - [ ] Meets monthly or quarterly; clear escalation path
- [ ] **The "executive air cover" requirement**: EA cannot push through tough decisions (kill a project, retire a vendor, mandate a standard) without explicit, public exec backing
- [ ] **Anti-pattern**: Chief Architect role created with no authority — symbolic only, soon vacated

## Module 4: Funding Models for EA
- [ ] **Project-based funding** (most common, often broken):
  - [ ] EA work funded as a line item in major projects
  - [ ] Pros: clear ROI per project; Cons: cross-cutting EA work has no funding; long-term roadmap underfunded
- [ ] **Centralised EA budget**:
  - [ ] EA team funded as a function (like Finance, HR)
  - [ ] Pros: independence; can do cross-cutting work; Cons: easily cut in budget cycles; ROI harder to defend
- [ ] **Capability-based funding** (modern, recommended):
  - [ ] Funding aligned to business capabilities (Customer Onboarding, Risk Management, Order Fulfilment)
  - [ ] Each capability has a multi-year investment plan; EA is part of capability investment
  - [ ] Aligns with TOGAF Capability-Based Planning
- [ ] **Platform funding** (modern, complementary):
  - [ ] Internal developer platforms, data platforms, identity platforms funded as products
  - [ ] EA architects platforms; product teams operate them; engineering teams consume them
  - [ ] Spreads EA value across all delivery
- [ ] **Charge-back vs show-back**:
  - [ ] Charge-back: business units pay for EA services (creates customer relationship)
  - [ ] Show-back: visibility without billing (less friction, less accountability)
- [ ] **Multi-year commitment**: EA roadmaps are 18-36 months; annual funding cycles destroy continuity

## Module 5: Communicating with the Board / C-Suite
- [ ] **Translation skills are core**:
  - [ ] Architecture diagram → business outcome
  - [ ] Technical risk → financial risk
  - [ ] Roadmap → investment decision
  - [ ] Compliance issue → regulatory exposure in dollars
- [ ] **Communication artifacts that work for executives**:
  - [ ] **One-page roadmap** — heatmap by business capability, time on x-axis, investment areas highlighted
  - [ ] **Application portfolio heatmap** — health × strategic value, sized by cost
  - [ ] **Capability maturity radar** — current vs target maturity per capability
  - [ ] **Risk register** — top 10 architectural risks, business impact, mitigation status
  - [ ] **Investment scorecard** — EA-driven savings + agility wins per quarter
- [ ] **Anti-artifact: a 70-slide architecture deck for a 30-minute exec meeting** — get to one page or get cut
- [ ] **Cadence**:
  - [ ] Quarterly: portfolio health + roadmap progress
  - [ ] Annual: strategy refresh, capability investment review
  - [ ] Ad-hoc: major risk/opportunity escalation
- [ ] **Frame EA in business language**: "we are reducing our AWS bill by 15% by Q3" — not "we are migrating to ECS Fargate from EC2"

## Module 6: Governance from a Leadership Perspective
- [ ] **Governance ≠ control**: it's about creating predictable outcomes, not slowing things down
- [ ] **Three governance levers leaders own**:
  - [ ] **Approve / fund** — major architecture decisions
  - [ ] **Override** — escalations from the Architecture Board
  - [ ] **Enforce / unblock** — apply executive authority when teams resist or are stuck
- [ ] **Light-touch vs heavy-touch governance**:
  - [ ] Light-touch: principles, fitness functions, coaching, exception-based review
  - [ ] Heavy-touch: gates, sign-offs, mandatory documentation, formal reviews
  - [ ] Wrong choice cripples either innovation (heavy) or reliability (light)
  - [ ] Match weight to risk: heavy for regulated/high-blast-radius; light for product/innovation
- [ ] **Architecture Compliance**: what happens when teams violate?
  - [ ] **Waiver process**: documented exceptions with expiry dates
  - [ ] **Escalation path**: clear, fast, predictable
  - [ ] **Consequences**: real but proportional (not "I'll never approve your project again")
- [ ] **Governance debt**: like technical debt — slow accumulation of compromised decisions; requires periodic clean-up
- [ ] **Continuous architecture compliance via automation**: fitness functions in CI/CD = governance without meetings (see `19-AgileArchitecture/`)

## Module 7: Leading Through Transformation
- [ ] EA leaders are often inherited transformation leaders too — modernisation, M&A, divestiture, regulatory response
- [ ] **Transformation principles**:
  - [ ] **Value first, technology second**: justify every initiative by business outcome
  - [ ] **People + process + technology**: 70% of transformation effort is org change, not tech
  - [ ] **Sequence matters**: foundational changes first (identity, integration); business-visible changes layered on
  - [ ] **Visible early wins**: 90-day deliverables that change the conversation
  - [ ] **Communicate continuously**: monthly all-hands during transformation; weekly sponsor updates
- [ ] **Common transformation traps**:
  - [ ] Underestimating change resistance (people protect what they know)
  - [ ] Big-bang thinking (multi-year mega-programmes that miss every milestone)
  - [ ] No sunset plan for old systems (parallel costs forever)
  - [ ] Vendor capture (locked into a transformation partner who keeps selling more)
  - [ ] Confusing activity with progress (lots of motion, little outcome)
- [ ] **The Chief Architect's role in transformation**:
  - [ ] Define the target architecture and transition states
  - [ ] Identify foundational dependencies and sequence
  - [ ] Champion the unsexy foundational work that makes flashy work possible
  - [ ] Defend the architecture against tactical compromises that destroy long-term value
  - [ ] Decide when to pivot vs persevere — based on evidence, not sunk cost
- [ ] **Decision authority during transformation**: pre-define what decisions go to whom; mid-transformation is the wrong time to negotiate

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Draft a 1-page EA value scorecard with 5 outcome metrics; if you can't measure them today, design how you would |
| Module 3 | Map your org's EA reporting line; identify the highest-leverage change that would strengthen sponsorship |
| Module 4 | Compare project-based vs capability-based funding for one initiative; defend your recommendation |
| Module 5 | Take a 70-slide architecture deck and reduce to a 1-page exec summary; verify nothing essential is lost |
| Module 6 | Audit your last 5 architecture waivers: what they were, why granted, whether expiry dates were met |
| Module 7 | If currently in transformation: identify the 3 unsexy foundational items most at risk of being deprioritised — what would you say to leadership? |

## Cross-References
- `01-TOGAF/03-Governance/` — governance mechanics
- `01-TOGAF/10-ArchitectureCapabilityFramework/` — Architecture Board, roles
- `01-TOGAF/16-DigitalTransformation/` — transformation context
- `01-TOGAF/20-MigrationPlanning/` — multi-year roadmap foundation
- `01-TOGAF/21-EAMaturityModels/` — sponsorship is a top maturity dimension
- `02-SolutionArchitecture/01-TradeOffAnalysis/` — leadership-grade decision framing
- `02-SolutionArchitecture/04-StakeholderManagement/` — translating across audiences
- `03-ProblemSolving/02-DecisionFrameworks/` — leadership decisions

## Key Resources
- **The Open Group: TOGAF Leader's Guide** (the canonical reference)
- **The Open Group: TOGAF Leader's Guide — A Practitioners' Approach to Developing Enterprise Architecture**
- **The Software Architect Elevator** - Gregor Hohpe (foundational on architect-leadership communication)
- **Enterprise Architecture as Strategy** - Ross, Weill, Robertson (operating model + leadership)
- **The Phoenix Project** - Gene Kim (executive view of IT transformation)
- **An Elegant Puzzle** - Will Larson (engineering leadership)
- **Crossing the Chasm** - Geoffrey Moore (technology adoption — relevant for transformation)
- **High Output Management** - Andy Grove (foundational management; applies to EA practice management)
- **The Hard Thing About Hard Things** - Ben Horowitz (executive decision-making)
