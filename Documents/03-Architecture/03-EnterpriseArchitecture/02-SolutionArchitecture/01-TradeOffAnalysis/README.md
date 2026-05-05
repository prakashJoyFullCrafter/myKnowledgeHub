# Trade-Off Analysis — Curriculum

How architects navigate the reality that **every quality attribute trades against another** — and document those choices so the team can defend them six months later.

> Trade-off analysis is the daily work of solution architecture. NFRs ([`02-NFRs/`](../02-NFRs/)) define the targets; this module is about choosing between designs that satisfy targets differently and at different costs.

---

## Module 1: Why Trade-offs Are Inevitable
- [ ] **You cannot maximize all quality attributes simultaneously** — every architecture choice favours some at the cost of others
- [ ] Famous trade-off triangles: speed/quality/cost; consistency/availability/partition tolerance (CAP)
- [ ] Hidden trade-offs: throughput vs latency, simplicity vs flexibility, cost vs resilience, time-to-market vs maintainability
- [ ] Decisions deferred = decisions made — defaults are choices
- [ ] The architect's job is not to eliminate trade-offs but to make them **explicit, measurable, and reviewable**

## Module 2: Quality Attribute Scenarios
- [ ] **Quality attribute scenario** — concrete, measurable description of how a quality attribute manifests
- [ ] Six parts: source of stimulus → stimulus → environment → artifact → response → response measure
- [ ] Example (performance): "100 concurrent users (source/stimulus) under normal load (environment) submit a search request (artifact). The system responds (response) with results in < 2s p95 (response measure)."
- [ ] Why scenarios beat one-line NFRs: they capture *context* and become directly testable
- [ ] Scenario types: **use-case scenarios** (anticipated), **growth scenarios** (future), **exploratory scenarios** (stress edges)
- [ ] **Utility tree**: hierarchical breakdown of quality attributes → refinements → scenarios with priority + difficulty
- [ ] Source: SEI / Bass-Clements-Kazman, *Software Architecture in Practice*

## Module 3: Architecture Trade-off Analysis Method (ATAM)
- [ ] **ATAM** — structured, scenario-driven evaluation of an architecture against multiple quality attributes
- [ ] Developed at SEI (Software Engineering Institute / CMU)
- [ ] Phases: presentation → investigation → testing → reporting (typically a 2-day workshop)
- [ ] **Sensitivity points**: where a small architectural decision strongly affects one quality attribute
- [ ] **Trade-off points**: a sensitivity point that affects *multiple* quality attributes in *opposing* directions — these are the real architectural decisions
- [ ] **Risk themes**: clustering of risks across scenarios (e.g., "all DB-related scenarios show concurrency risks")
- [ ] Outputs: utility tree, trade-off points list, risk/non-risk catalog, sensitivity points

> Deep-dive: [ATAM (Problem Solving)](../../03-ProblemSolving/04-ATAM/) — full method walkthrough

## Module 4: Decision Matrices & Weighted Scoring
- [ ] **Decision matrix**: rows = options, columns = criteria, cells = scores
- [ ] **Weighted scoring**: assign weight to each criterion (must sum to 1.0); score × weight = contribution
- [ ] **Example — choosing a database**:
  - [ ] Criteria: write throughput (0.30), query flexibility (0.20), ops maturity (0.20), cost (0.15), team skill (0.15)
  - [ ] Options: Postgres, MongoDB, Cassandra, DynamoDB
- [ ] **Avoid score inflation**: use a 1–5 scale, force differentiation
- [ ] **Sensitivity analysis**: change weights ±10%, re-score — does the winner change? If yes, the decision is fragile
- [ ] **Pugh matrix** for comparing alternatives against a baseline option
- [ ] **Anti-pattern**: scoring to justify a pre-decided choice (the "decision laundry")

## Module 5: Cost-Benefit & Risk Analysis
- [ ] **Total Cost of Ownership (TCO)**: build + run + maintain + decommission, over 3–5 years
- [ ] **Hidden costs**: training, ops complexity, vendor lock-in, migration cost, reliability incidents
- [ ] **Benefit quantification**: revenue impact, cost savings, risk reduction, time-to-market, team capacity
- [ ] **NPV / IRR** for high-cost decisions involving multi-year investments
- [ ] **Risk register**: probability × impact = risk score; mitigations bring score down
- [ ] **Risk types**: technical, operational, organizational, vendor, security, compliance
- [ ] **Cost of delay**: what does each month of waiting cost? (often dominates one-time costs)
- [ ] **CBAM** (Cost Benefit Analysis Method) — SEI's economic extension of ATAM

## Module 6: Architecture Decision Records (ADRs)
- [ ] **ADR**: short markdown document capturing one architectural decision and its context
- [ ] Standard sections: **Context** (the forces), **Decision** (what we chose), **Consequences** (good and bad)
- [ ] Variants: MADR (Markdown Any Decision Records), Y-statement, Nygard's original ADR
- [ ] Numbered, immutable, append-only — superseded by new ADRs, not edited
- [ ] **Status**: proposed → accepted → deprecated → superseded
- [ ] Store **alongside code** (`docs/adr/`) — not in a wiki that drifts
- [ ] Tools: `adr-tools`, `log4brains`, IDE templates, PR-driven review
- [ ] **What deserves an ADR**: any decision that would surprise a new team member 6 months from now

> Deep-dive: [Decision Frameworks (Problem Solving)](../../03-ProblemSolving/02-DecisionFrameworks/) — ADR templates, examples, and complementary tools

## Module 7: Common Architectural Trade-offs
- [ ] **Consistency vs Availability** (CAP) — choose two during a partition
- [ ] **Latency vs Durability** — sync writes safe-but-slow vs async fast-but-loseable
- [ ] **Throughput vs Latency** — batching helps throughput, hurts per-request latency
- [ ] **Simplicity vs Flexibility** — every config option carries a maintenance tax
- [ ] **Build vs Buy** — control vs speed; vendor lock-in vs in-house complexity
- [ ] **Monolith vs Microservices** — local complexity vs distributed complexity (you can't escape it, only relocate)
- [ ] **Sync vs Async** — easier to reason about vs more resilient under failure
- [ ] **Strong typing vs Flexibility** (schema-on-read vs schema-on-write)
- [ ] **Caching vs Freshness** — speed vs staleness; cache invalidation is famously hard
- [ ] **Cost vs Resilience** — multi-region active-active is the gold standard, and expensive
- [ ] **Time-to-market vs Maintainability** — both real, both quantifiable, neither absolute

## Module 8: Documenting & Reviewing Trade-offs
- [ ] **The trade-off must be visible** in the ADR's Consequences section — not buried in the Decision
- [ ] **List options not chosen** — and why they were rejected; future readers will ask
- [ ] **Re-visit triggers**: scale changes, new tech, regulation, team turnover
- [ ] **Architecture review boards (ARBs)**: where high-impact trade-offs get socialized
- [ ] **Pre-mortem**: "imagine this decision failed in 18 months — what went wrong?" — surfaces hidden risks
- [ ] **Decision log** at the team level: lighter weight than ADRs, faster cadence

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Write 5 quality attribute scenarios for a system you've worked on (one per attribute) |
| Module 3 | Run a mini-ATAM on a personal project — produce a utility tree and identify trade-off points |
| Module 4 | Build a weighted decision matrix for a real choice (DB, message broker, frontend framework) |
| Module 5 | Compute 3-year TCO for a "build vs buy" decision, including hidden costs |
| Module 6 | Write 3 ADRs for past decisions — context, decision, consequences |
| Module 7 | Pick a system you know; identify which side of each common trade-off it landed on, and why |
| Module 8 | Take a recent ADR; conduct a pre-mortem — what could go wrong in 18 months? |

## Cross-References
- [02-NFRs/](../02-NFRs/) — quality attribute targets that feed into utility trees
- [03-ProblemSolving/04-ATAM/](../../03-ProblemSolving/04-ATAM/) — full ATAM workshop method
- [03-ProblemSolving/02-DecisionFrameworks/](../../03-ProblemSolving/02-DecisionFrameworks/) — ADR templates and frameworks
- [03-ProblemSolving/03-ArchitectureReviews/](../../03-ProblemSolving/03-ArchitectureReviews/) — review board mechanics
- [02-SystemDesign/03-SystemDesign/01-CAPTheorem/](../../../02-SystemDesign/03-SystemDesign/01-CAPTheorem/) — the canonical distributed-systems trade-off
- [03-ArchitectureDocumentation/](../03-ArchitectureDocumentation/) — where ADRs live
- [05-C4Model/](../05-C4Model/) — the structural counterpart to ADRs (what vs why)

## Key Resources
- **Software Architecture in Practice** — Bass, Clements, Kazman (ATAM and quality-attribute-scenario source)
- **Documenting Software Architectures: Views and Beyond** — Clements et al.
- **Fundamentals of Software Architecture** — Mark Richards, Neal Ford
- **Architecture Decision Records** — adr.github.io
- **MADR** — github.com/adr/madr (template)
- Michael Nygard, *Documenting Architecture Decisions* (2011) — the original ADR post
- SEI ATAM technical reports — sei.cmu.edu
