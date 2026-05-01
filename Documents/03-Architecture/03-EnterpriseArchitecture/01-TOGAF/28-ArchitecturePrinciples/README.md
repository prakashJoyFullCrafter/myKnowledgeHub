# Architecture Principles — TOGAF Foundational Asset

> **Architecture Principles are the enduring rules that guide architecture decisions.**
> They are *deliberately fewer than rules* and *more than slogans*. A well-formed principle constrains design without prescribing implementation.

---

## 1. What Architecture Principles Are (and Aren't)

### TOGAF Definition
> Architecture principles are general rules and guidelines, intended to be enduring and seldom amended, that inform and support the way in which an organization sets about fulfilling its mission.

### What they are
- [ ] **Strategic** — apply across the enterprise, not to one project
- [ ] **Enduring** — change rarely (years, not months)
- [ ] **Decisional** — invoked when making architecture trade-offs
- [ ] **Stakeholder-validated** — formally agreed by the architecture board
- [ ] **Few in number** — typically 15-30 total across all categories

### What they're NOT
- [ ] Standards (specific technology choices)
- [ ] Patterns (reusable design solutions)
- [ ] Goals (desired outcomes)
- [ ] Policies (compliance/regulatory rules)
- [ ] Vague platitudes ("we value innovation")

### Where in the ADM
- [ ] **Established in**: Preliminary Phase
- [ ] **Refined in**: Architecture Vision (Phase A)
- [ ] **Validated against**: every architecture decision
- [ ] **Updated via**: Architecture Change Management (Phase H)

---

## 2. The Four TOGAF Principle Categories

| Category | Scope | Example |
|----------|-------|---------|
| **Business** | Enterprise mission, business strategy | "Maximize benefit to the enterprise" |
| **Data** | Data assets, governance, quality | "Data is an asset" |
| **Application** | Application portfolio, software | "Common use applications" |
| **Technology** | Infrastructure, platforms | "Control technical diversity" |

A balanced principle set has principles in **all four categories** — covering the BDAT domains.

---

## 3. Principle Anatomy — The TOGAF Standard Format

Every principle has **four required parts**:

```markdown
## Principle: [Short, memorable name]

### Statement
[The actual rule — short, action-oriented, unambiguous]

### Rationale
[Why this principle exists — business benefit, risk mitigated, value created]

### Implications
[Consequences — what changes in design, process, or trade-offs]
- For development teams:
- For operations:
- For procurement:
- For governance:
```

### Test for a good principle (5 criteria)

| Criterion | Question |
|-----------|----------|
| **Understandable** | Can a non-technical stakeholder grasp it quickly? |
| **Robust** | Is it precise enough to support decisions and waivers? |
| **Complete** | Does it cover what it says it covers? |
| **Consistent** | Does it conflict with other principles? (some tension is fine; contradiction is not) |
| **Stable** | Will it still apply in 5 years? |

---

## 4. The Canonical TOGAF Principle Set

TOGAF provides 21 example principles (5 Business + 4 Data + 4 Application + 8 Technology). Use as a starting point; tailor to your enterprise.

### Business Principles (5)

| # | Name | Statement (summary) |
|---|------|--------------------|
| B1 | Primacy of Principles | All organizations apply these principles |
| B2 | Maximize Benefit to the Enterprise | Decisions optimize enterprise-wide value, not local |
| B3 | Information Management is Everybody's Business | All stakeholders accountable for info |
| B4 | Business Continuity | Operations must continue despite disruptions |
| B5 | Common Use Applications | Prefer enterprise-wide apps over project-specific |
| B6 | Compliance with Law | All activities comply with applicable laws |
| B7 | IT Responsibility | IT is responsible for service quality, cost, alignment |
| B8 | Protection of Intellectual Property | IP protection is integral |

### Data Principles (4)

| # | Name | Statement (summary) |
|---|------|--------------------|
| D1 | Data is an Asset | Treated with the same care as financial assets |
| D2 | Data is Shared | Shared across the enterprise wherever possible |
| D3 | Data is Accessible | Authorized users can access the data they need |
| D4 | Data Trustee | Each data element has an accountable owner |
| D5 | Common Vocabulary and Data Definitions | Shared terms across the organization |
| D6 | Data Security | Protected per classification |

### Application Principles (2-4)

| # | Name | Statement (summary) |
|---|------|--------------------|
| A1 | Technology Independence | Apps independent of specific tech where possible |
| A2 | Ease of Use | Apps designed for usability, not just function |

### Technology Principles (4-8)

| # | Name | Statement (summary) |
|---|------|--------------------|
| T1 | Requirements-Based Change | Changes driven by business need, not technology fads |
| T2 | Responsive Change Management | Changes implemented in time to satisfy business need |
| T3 | Control Technical Diversity | Limit number of platforms, languages, products |
| T4 | Interoperability | Standards-based interoperability of systems |

---

## 5. Worked Example — Full Principle

```markdown
## Principle B5: Common Use Applications

### Statement
Development of applications used across the enterprise is preferred over the development
of similar or duplicative applications which are only provided to a particular organization.

### Rationale
Duplicative capability is expensive and proliferates conflicting data. Common applications
reduce TCO, increase data consistency, and accelerate delivery for new business units.

### Implications
- **For business units**: must justify any project building functionality already available
- **For development teams**: design for multi-tenancy and configurability from inception
- **For governance**: project intake reviews check for existing common-use options
- **For procurement**: prefer enterprise licenses over per-team purchases
- **For ops**: common apps are operated centrally; SLAs must support all consumers
- **Trade-off accepted**: longer initial delivery for one consumer in exchange for reuse later
```

---

## 6. How to Develop Principles (in Preliminary Phase)

### The 6-step development process

```
1. Define enterprise context
        ↓
2. Identify principle candidates (workshops, drivers, strategy)
        ↓
3. Draft principles using the 4-part format
        ↓
4. Review for the 5 quality criteria
        ↓
5. Validate with stakeholders (architecture board, executive)
        ↓
6. Approve & publish in Architecture Repository
```

### Sources of principle content
- [ ] Enterprise mission, vision, strategy documents
- [ ] Existing IT strategy / governance policies
- [ ] Industry standards relevant to the sector (regulated industries)
- [ ] Lessons learned from past failures (some principles exist to prevent recurrence)
- [ ] External standards (e.g., ISO 27001 informs security principles)

### Workshops format
- [ ] 2-3 sessions over 4-6 weeks
- [ ] Cross-functional: business, IT, operations, security, data
- [ ] Output: candidate list → refined set → approved principles

---

## 7. Using Principles — Decision Support

### Principle invocation in design reviews
For any major architecture decision, document:
1. Which principles apply?
2. How does each candidate option score against each principle?
3. Where is there tension between principles? (e.g., interoperability vs control of diversity)
4. Which option best honors the principle set?

### Principle waivers (formal exceptions)
- [ ] Sometimes a principle conflicts with a specific need
- [ ] Don't ignore — request a **formal waiver** through governance
- [ ] Waiver = documented exception with: rationale, scope, time-bound, mitigation plan
- [ ] Tracked in Architecture Governance Log
- [ ] If waivers pile up against the same principle → revisit the principle

### Trade-off mediation
When two principles tension (e.g., Common Use Apps vs Innovation Speed):
- [ ] Architecture Board mediates
- [ ] Decision recorded with rationale (which principle was prioritized and why)
- [ ] Sets precedent for similar future cases

---

## 8. Common Pitfalls

| Pitfall | Why it fails | Fix |
|---------|--------------|-----|
| Too many principles | Architects can't remember; loses force | Cap at ~20-25 total |
| Principles disguised as standards | "We use Java" isn't a principle | Promote to standard, demote from principle list |
| Vague statements | "Be agile" — meaningless | Force the 4-part structure; reject vague drafts |
| No implications | Sounds good, no impact on decisions | Implications are mandatory; reject without them |
| Never invoked | Principles ignored in real decisions | Make principle citation part of design review template |
| Principles never updated | Become stale as org evolves | Annual review (lightweight) |
| No board approval | Lacks legitimacy | Formal approval in governance forum |
| Conflicts unmanaged | Same conflict re-litigated each time | Document precedent decisions |

---

## 9. Principles vs Other Constructs

| Construct | Definition | Typical Lifespan | Specificity |
|-----------|-----------|------------------|-------------|
| **Principle** | Enduring rule guiding decisions | Years | Strategic |
| **Standard** | Specific tech / approach mandated | 1-3 years | Tactical |
| **Pattern** | Reusable design solution | Long | Design-level |
| **Guideline** | Recommended practice | Variable | Advisory |
| **Policy** | Compliance-driven mandate | Long | Governance |
| **Goal** | Desired outcome | Project/horizon | Variable |

Example chain: *Principle T3 "Control Technical Diversity"* → *Standard "Approved languages: Java, Kotlin, Python"* → *Pattern "Hexagonal architecture for microservices"*

---

## 10. Real-World Principle Sets to Study

- **US Federal CIO Council** — Enterprise Architecture principles
- **AWS Well-Architected Framework** — pillars (operationally framed as principles)
- **GOV.UK Service Manual** — Design Principles (gov.uk/guidance/government-design-principles)
- **NHS Digital** — Architecture Principles (public reference)
- **TOGAF Standard Appendix** — example principles

---

## 11. Certification Angle

### L1 (Foundation)
- [ ] Definition of Architecture Principle
- [ ] Four categories (Business, Data, Application, Technology)
- [ ] Four required parts (Name, Statement, Rationale, Implications)
- [ ] Five quality criteria (Understandable, Robust, Complete, Consistent, Stable)
- [ ] Established in Preliminary Phase

### L2 (Practitioner)
- [ ] Identifying gaps in a principle set (missing categories, missing parts)
- [ ] Critiquing draft principles using the 5 quality criteria
- [ ] Resolving principle tensions in a scenario
- [ ] Recommending waiver vs revision when conflicts arise
- [ ] Distinguishing principles from standards/patterns/policies

---

## 12. Practice Exercises

1. Take your team's current implicit "rules" — convert 3 into properly formatted principles
2. Audit a published principle set (NHS, GOV.UK, AWS) — apply the 5 quality criteria
3. Resolve a tension: "Maximize benefit to enterprise" vs "Speed to market for one BU" — write a board decision
4. Draft a principle waiver request for a real exception you've made or seen
5. Compare TOGAF's example principles to your enterprise's principles — what's missing?

---

## 13. Resources

- **TOGAF Standard, 10th Edition** — Architecture Principles (full chapter)
- **TOGAF Series Guide: Architecture Principles** — Open Group publication
- *Enterprise Architecture as Strategy* — Ross, Weill, Robertson (operating model principles)
- *The Open Group Architecture Forum* — community principle examples
- US OMB Circular A-130 — federal EA principles
- AWS Well-Architected Framework
- GOV.UK Government Design Principles

🔗 Cross-refs:
- `01-ADMCycle/` — Preliminary Phase establishes principles; Phase A refines them
- `03-Governance/` — Architecture Board approves and waives principles
- `07-ArchitectureRepository/` — Reference Library stores principles
- `27-StakeholderManagement/` — principles are validated with stakeholders
- `26-BusinessScenarios/` — scenarios test whether principles still hold
- `29-GapAnalysis/` — gaps may surface principle violations
