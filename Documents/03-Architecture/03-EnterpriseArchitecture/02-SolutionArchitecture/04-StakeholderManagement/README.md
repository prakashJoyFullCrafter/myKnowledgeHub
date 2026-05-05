# Stakeholder Management — Curriculum

How architects identify the people whose concerns the architecture must address, communicate with each audience appropriately, and build the consensus that turns a design into a delivered system.

> Architecture is a social activity as much as a technical one. The best diagram in the world fails if the stakeholders don't trust it. This module is the soft-skills counterpart to the rest of Solution Architecture.

---

## Module 1: Identifying Stakeholders
- [ ] **Stakeholder** — anyone whose interests are affected by the architecture (positively or negatively)
- [ ] Categories:
  - [ ] **Business**: product owners, sponsors, executives, finance, sales, marketing
  - [ ] **Technical**: developers, tech leads, other architects, DBAs
  - [ ] **Operations**: SRE, on-call, platform team, support
  - [ ] **Security & Compliance**: CISO, security engineers, auditors, legal, DPO
  - [ ] **External**: customers, partners, regulators, vendors
- [ ] **Stakeholder mapping**: power × interest grid (Mendelow's matrix) — who needs frequent contact, who needs reassurance, who can be informed
- [ ] **RACI**: Responsible, Accountable, Consulted, Informed — for each architectural decision
- [ ] Anti-pattern: optimising for the loudest stakeholder rather than the right ones

## Module 2: Stakeholder Concerns Mapping
- [ ] **Concern**: what a stakeholder cares about — business outcomes, quality attributes, constraints, risks
- [ ] Concerns differ wildly by audience:
  - [ ] CEO cares about revenue, time-to-market, regulatory exposure
  - [ ] CISO cares about attack surface, audit logging, breach blast radius
  - [ ] Developers care about cognitive load, build times, debuggability
  - [ ] SRE cares about MTTR, alert noise, runbook quality
  - [ ] Customers care about availability, latency, data privacy
- [ ] **Concern → quality attribute → NFR**: turn vague concerns into measurable targets
  - [ ] "I need it fast" → latency NFR with p95/p99 targets and load condition
- [ ] **Concern interview**: structured 30-min sessions per stakeholder group; record verbatim quotes
- [ ] **Concern register**: living document; revisited every release / incident

> Deep-dive: [02-NFRs/](../02-NFRs/) — translating concerns into measurable NFRs

## Module 3: Architecture Views & Viewpoints
- [ ] **Viewpoint** = recipe for a kind of view; **View** = the artefact addressing one or more concerns
- [ ] **4+1 model** (Kruchten): Logical, Process, Physical, Development, + Use Cases
- [ ] **C4 levels** as views: Context (business), Containers (technical management), Components (developers)
- [ ] **arc42 sections** as views: Building Blocks, Runtime, Deployment, Crosscutting Concepts
- [ ] **ISO/IEC/IEEE 42010**: standard vocabulary — stakeholder, concern, viewpoint, view, model
- [ ] **Audience-view matrix**: each stakeholder × each view → which views does each audience need?
- [ ] Don't show developers the executive Context diagram and call it documentation

## Module 4: Communicating to Different Audiences
- [ ] **Executive audience**:
  - [ ] Lead with business outcomes and risk; one diagram, one number
  - [ ] Avoid jargon; use analogies; concrete examples > abstract architecture
  - [ ] 5-minute attention span; preparation is "what's the one thing they need to remember?"
- [ ] **Developer audience**:
  - [ ] Lead with mental model; show the boundaries; explain the *why*
  - [ ] Make it interactive — questions reveal misalignment
  - [ ] Code samples and diagrams together; live demos beat slides
- [ ] **Operations audience**:
  - [ ] Lead with failure modes, runbooks, observability hooks
  - [ ] Deployment topology, scaling triggers, rollback story
  - [ ] "What pages me at 3am?" framing
- [ ] **Security & compliance audience**:
  - [ ] Lead with threat model, data flow, controls
  - [ ] Map controls to specific compliance clauses (HIPAA §, GDPR Art., PCI Req.)
- [ ] **External audience (customers, partners)**:
  - [ ] Public APIs, SLAs, data residency, integration models
  - [ ] No internal jargon; legally-reviewed claims about availability and security

## Module 5: Trade-off Negotiation with Stakeholders
- [ ] **Frame trade-offs as choices, not pre-decisions** — let stakeholders own the call when it's their concern
- [ ] **Show the menu**: present 2–3 options with quantified pros/cons rather than one recommendation
- [ ] **Quantify everything possible**: cost, time, risk reduction, performance numbers — vague claims lose
- [ ] **Acknowledge what's lost** in your recommendation — credibility comes from naming downsides
- [ ] **Time-bound the conversation**: long debates without deadlines kill momentum
- [ ] **Asynchronous review for high-stakes decisions**: written ADRs, time for reflection, structured comments
- [ ] **Walk-away point**: when the stakeholder's preferred path violates a hard constraint (regulatory, ethical, technical impossibility), say so explicitly and escalate

> Deep-dive: [01-TradeOffAnalysis/](../01-TradeOffAnalysis/) — ATAM, decision matrices, ADRs

## Module 6: Building Consensus
- [ ] **Consensus** ≠ unanimous agreement; it means "I can live with this and will support it"
- [ ] **Disagree-and-commit**: documented dissent followed by alignment in execution
- [ ] **Pre-meeting alignment**: 1:1s with key stakeholders before group meetings — surprises in groups poison consensus
- [ ] **Use facts, not opinions**: "the load test shows X" > "I think X"
- [ ] **Make the trade-off visible** in the room — whiteboard the alternatives and consequences
- [ ] **Reversibility framing**: "this is a 2-way door, we can revisit in 3 months" lowers stakes
- [ ] **Anti-patterns**: false consensus (silent disagreement), endless debate (no decision), HiPPO (highest-paid person's opinion wins by default)

## Module 7: Architecture Review Boards (ARBs)
- [ ] **Purpose**: gate high-impact decisions, share knowledge, enforce standards
- [ ] **Composition**: senior architects, platform/security/SRE leads, product representation
- [ ] **Cadence**: weekly or bi-weekly; decisions async between meetings
- [ ] **Inputs**: ADRs, C4 diagrams, NFR targets, risk register
- [ ] **Outputs**: approved / approved-with-conditions / rejected / send-back-with-feedback
- [ ] **Healthy ARB**: enables teams; **unhealthy ARB**: bottleneck and gatekeeper
- [ ] **Lightweight alternatives**: PR-driven ADR review, async architecture guild, RFC process (Rust / Python style)

> Deep-dive: [03-ProblemSolving/03-ArchitectureReviews/](../../03-ProblemSolving/03-ArchitectureReviews/)

## Module 8: Influence Without Authority
- [ ] Solution architects rarely have line authority over the teams they advise — influence is the job
- [ ] **Build credibility first**: deliver value to a team before asking them to change anything
- [ ] **Ask before telling**: "what's the constraint here?" beats "you should do X"
- [ ] **Coach, don't dictate**: help teams reach the right answer themselves; ownership matters more than correctness
- [ ] **Pick battles**: not every deviation from "best practice" is worth a fight; reserve disagreement for principles
- [ ] **Network capital**: relationships across teams compound; spend time outside your team
- [ ] **Make the right thing easy**: shared libraries, templates, golden paths beat documents and lectures
- [ ] **Acknowledge constraints you don't see**: every team has context you lack — humility wins

## Module 9: Documenting Stakeholder Engagement
- [ ] **Stakeholder register**: who's who, role, primary concerns, contact cadence
- [ ] **Concern log**: what was raised, by whom, how it was addressed
- [ ] **Decision audit trail**: ADRs link to stakeholder concerns they resolve
- [ ] **Communication plan**: per-stakeholder cadence, channel, content type
- [ ] **Change log**: stakeholder-facing summary of what changed and why
- [ ] **Onboarding doc for new stakeholders**: bring new joiners up to speed without re-litigating closed decisions

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | List all stakeholders for a system you've worked on; place them on a power × interest grid |
| Module 2 | Interview 3 stakeholders from different groups; map their concerns to NFRs |
| Module 3 | For one system, list which view each stakeholder needs and why |
| Module 4 | Take a technical decision and prepare three pitches: 5-min for execs, 30-min for developers, 15-min for SRE |
| Module 5 | Take a real trade-off you faced; reframe it as 3 options with quantified pros/cons |
| Module 6 | Recall a decision where consensus failed; what would disagree-and-commit have looked like? |
| Module 7 | Design a lightweight ARB process for a 50-person engineering org |
| Module 8 | Identify one team where you have no authority but want to influence; what's your credibility-building move? |

## Cross-References
- [02-NFRs/](../02-NFRs/) — NFRs are the formalised version of stakeholder concerns
- [01-TradeOffAnalysis/](../01-TradeOffAnalysis/) — quantified options for stakeholder choice
- [03-ArchitectureDocumentation/](../03-ArchitectureDocumentation/) — audience-driven views
- [05-C4Model/](../05-C4Model/) — Context diagrams as the primary stakeholder artefact
- [03-ProblemSolving/03-ArchitectureReviews/](../../03-ProblemSolving/03-ArchitectureReviews/) — ARB mechanics
- [01-TOGAF/](../../01-TOGAF/) — TOGAF stakeholder management activity in ADM Phase A

## Key Resources
- **Software Systems Architecture** — Rozanski & Woods (the standard reference for views, viewpoints, and stakeholders)
- **ISO/IEC/IEEE 42010** — Systems and software engineering — Architecture description
- **The Trusted Advisor** — David Maister (influence without authority, applied to consulting)
- **Crucial Conversations** — Patterson et al. (high-stakes communication)
- **Influence Without Authority** — Cohen & Bradford
- **Mendelow's Matrix** — power/interest stakeholder mapping
- **Communication Patterns** — Jacqui Read (architectural communication; recent and pragmatic)
- **The Software Architect Elevator** — Gregor Hohpe (the architect's role across audiences)
