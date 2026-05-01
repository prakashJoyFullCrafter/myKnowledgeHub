# Business Scenarios — TOGAF Technique

> **The standard TOGAF technique for capturing business requirements during Phase A (Architecture Vision).**
> A Business Scenario describes a business process, problem, or initiative in enough detail to drive architecture decisions — without prescribing technology.

---

## 1. What is a Business Scenario?

A Business Scenario is a complete, end-to-end description of a business situation that includes:
- The **business and technical environment**
- The **people and computing components** ("actors")
- Their **desired outcomes** (goals)
- Specific **pain points / problems** they face

It's a TOGAF-formal artifact, not a generic "use case" — it's used as the **bridge between vague stakeholder concerns and concrete architecture requirements**.

### When in the ADM
- [ ] **Primary use**: Phase A (Architecture Vision) — to validate that the architecture work addresses real business needs
- [ ] Refined throughout: Phase B (Business), Phase C (Information Systems), Phase E (Opportunities & Solutions)
- [ ] Feeds into: Architecture Vision, Statement of Architecture Work, Requirements Repository

### Why it matters
- [ ] Forces stakeholders to articulate concrete pain — not just buzzwords
- [ ] Surfaces hidden requirements (regulatory, operational, ops costs)
- [ ] Anchors trade-off discussions in *business value*, not technology preferences
- [ ] Creates a defensible record of "why this architecture"

---

## 2. The SMART Test

A Business Scenario must be **SMART**:

| Letter | Meaning | Question to ask |
|--------|---------|-----------------|
| **S** | Specific | Does it describe a specific business problem? |
| **M** | Measurable | Can success/failure be measured? |
| **A** | Actionable | Are the actions to take clear? |
| **R** | Realistic | Is it achievable with current/planned capabilities? |
| **T** | Time-bound | Is there a deadline / timeframe? |

If a scenario fails the SMART test, it's a wish list, not a scenario.

---

## 3. The Six Components

Every TOGAF Business Scenario has **six required components**:

### (1) Problem
- [ ] Concrete description of the business problem
- [ ] What's broken / missing / costing money?
- [ ] Quantified where possible (revenue lost, hours wasted, error rates)

### (2) Environment
- [ ] **Business environment**: industry context, market pressures, regulations, organizational structure
- [ ] **Technical environment**: existing systems, integration points, technology constraints
- [ ] Geographic, legal, cultural factors if relevant

### (3) Objectives
- [ ] What the business wants to achieve (the *goals*)
- [ ] Measurable: revenue +X%, latency <Y ms, error rate <Z%
- [ ] Linked to enterprise strategy / business drivers
- [ ] Often expressed as KPIs

### (4) Human Actors
- [ ] Who is involved? (roles, not individuals)
- [ ] Examples: Customer, Customer Service Rep, Operations Manager, Compliance Officer
- [ ] Their concerns, motivations, success criteria
- [ ] Distinct from "Computer Actors"

### (5) Computer Actors
- [ ] Existing IT components / systems involved
- [ ] APIs, databases, legacy mainframes, SaaS platforms
- [ ] What they do, their interfaces, their constraints
- [ ] Often where most pain lives in legacy organizations

### (6) Roles & Responsibilities
- [ ] Specific responsibilities of each Human Actor in this scenario
- [ ] Specific responsibilities of each Computer Actor
- [ ] Who initiates, who approves, who gets notified, who can override?
- [ ] RACI-like clarity (without being a full RACI matrix)

---

## 4. The Development Process (TOGAF-prescribed)

```
┌─────────────────┐
│  1. Identify,   │
│  Document &     │
│  Rank Problem   │
└────────┬────────┘
         ↓
┌─────────────────┐
│  2. Identify    │
│  Business &     │
│  Tech Environ.  │
└────────┬────────┘
         ↓
┌─────────────────┐
│  3. Document    │
│  Objectives     │
└────────┬────────┘
         ↓
┌─────────────────┐
│  4. Document    │
│  Actors         │
│  (Human + Comp) │
└────────┬────────┘
         ↓
┌─────────────────┐
│  5. Document    │
│  Roles &        │
│  Responsibilites│
└────────┬────────┘
         ↓
┌─────────────────┐
│  6. Refine to   │
│  SMART          │
└────────┬────────┘
         ↓
┌─────────────────┐
│  7. Review &    │
│  Sign-off       │
└─────────────────┘
```

### Step-by-step
- [ ] **Step 1 — Identify the problem**: gather symptoms; interview stakeholders; rank by business impact
- [ ] **Step 2 — Document environment**: inventory current systems, regulations, market constraints
- [ ] **Step 3 — Define objectives**: state measurable goals tied to the problem
- [ ] **Step 4 — Identify actors**: list both human and computer actors; understand their viewpoints
- [ ] **Step 5 — Map roles**: clarify who does what (today and in target state)
- [ ] **Step 6 — Test SMART-ness**: refine until the scenario is specific, measurable, actionable, realistic, time-bound
- [ ] **Step 7 — Review with stakeholders**: get formal sign-off before using as basis for architecture work

---

## 5. Standard Template

```markdown
# Business Scenario: [Concise Title]

## 1. Problem Statement
[Concrete description of the business problem, quantified where possible]

## 2. Environment
### 2.1 Business Environment
- Industry context:
- Regulatory:
- Organizational:
- Market drivers:

### 2.2 Technical Environment
- Existing systems:
- Integration points:
- Technology constraints:

## 3. Objectives
| ID | Objective | Measure | Target | Deadline |
|----|-----------|---------|--------|----------|
| O1 | ...       | ...     | ...    | ...      |

## 4. Human Actors
| Actor | Role | Concerns | Success Criteria |
|-------|------|----------|------------------|
| ...   | ...  | ...      | ...              |

## 5. Computer Actors
| System | Function | Interfaces | Constraints |
|--------|----------|------------|-------------|
| ...    | ...      | ...        | ...         |

## 6. Roles & Responsibilities
[Activity-level mapping of who does what]

## 7. SMART Validation
- Specific: [How]
- Measurable: [How]
- Actionable: [How]
- Realistic: [How]
- Time-bound: [Deadline]

## 8. Architecture Implications
[What does this scenario demand of the architecture?]
```

---

## 6. Worked Example (Abbreviated)

**Scenario**: "Reduce loan-application turnaround from 5 days to 24 hours"

| Component | Content |
|-----------|---------|
| Problem | 70% of customers abandon loan apps due to 5-day turnaround. Estimated $4M lost revenue/year. |
| Environment | EU retail bank; PSD2 + GDPR compliance; legacy core banking on mainframe; 12 manual hand-offs |
| Objectives | (a) ≤24h turnaround for 90% of apps; (b) Maintain ≤0.5% fraud rate; (c) Compliance with new Open Banking by Dec 2025 |
| Human Actors | Applicant, Loan Officer, Underwriter, Compliance Officer, Branch Manager |
| Computer Actors | Origination system, Credit bureau API, AML scoring engine, Core banking, Document mgmt |
| Roles | Applicant submits → Origination validates → Credit bureau check → AML scoring → Underwriter reviews → Decision → Booking in core banking |

**Architecture implications**:
- Need straight-through processing for 90% of cases
- API integration with credit bureau + AML engine
- Document automation (OCR + classification)
- Compliance audit trail end-to-end
- Failover for credit bureau outages

---

## 7. Common Mistakes

| Mistake | Why it fails | Fix |
|---------|--------------|-----|
| Skipping computer actors | Misses integration constraints | Inventory current systems early |
| Vague objectives ("better customer experience") | Not measurable | Replace with KPI: "NPS +15 points" |
| Solution baked into the problem | Locks architecture choices prematurely | State the problem in business terms only |
| Single stakeholder voice | Misses contradictions | Interview cross-functional stakeholders |
| No deadline | Not time-bound; loses urgency | Anchor to a regulatory or competitive milestone |
| One-shot artifact (write once, never revisit) | Becomes stale | Revisit each ADM cycle; refine in B/C/D |
| Confused with use cases | Use cases are system-level; scenarios are business-level | Keep scenarios above the system boundary |

---

## 8. Business Scenario vs Other Techniques

| Artifact | Scope | Granularity | Used in Phase |
|----------|-------|-------------|---------------|
| **Business Scenario** | Business situation end-to-end | High-level, end-to-end | A (primary), B/C/D (refinement) |
| **Use Case** | System interaction | Functional, system-level | C (Application Architecture) |
| **User Story** | Single feature | Granular | Implementation level |
| **Capability Map** | Static "what we can do" | Hierarchical taxonomy | B |
| **Value Stream** | End-to-end value delivery | Stage-based | B |

---

## 9. Certification Angle

### L1 (Foundation)
- [ ] Definition of Business Scenario (one of TOGAF's named techniques)
- [ ] SMART acronym
- [ ] Six components (Problem, Environment, Objectives, Human Actors, Computer Actors, Roles)
- [ ] Phase where it's used (Phase A)

### L2 (Practitioner) — scenario-based
- [ ] Identifying when a Business Scenario is appropriate vs other techniques
- [ ] Critiquing a flawed Business Scenario (missing components, not SMART)
- [ ] Mapping objectives to Architecture Vision deliverables
- [ ] Using Business Scenarios to scope Statement of Architecture Work

---

## 10. Practice Exercises

1. Write a Business Scenario for a real problem at your company — pass the SMART test
2. Take a vague business request ("improve customer experience") and convert it to a SMART Business Scenario
3. Critique a sample scenario: identify which of the 6 components are missing or weak
4. Map a Business Scenario's objectives → Architecture Requirements (per Phase A)
5. Take an existing scenario and refine it for Phase C (Information Systems Architecture)

---

## 11. Resources

- **TOGAF Standard, 10th Edition** — Business Scenarios technique (Part of the ADM Techniques)
- **TOGAF Series Guide: Business Scenarios** — official Open Group guide
- The Open Group white paper: *Business Scenarios — A Step-by-Step Guide*
- TOGAF practitioner exam practice questions on Phase A and Business Scenarios

🔗 Cross-refs:
- `01-ADMCycle/` — Phase A consumes Business Scenarios
- `27-StakeholderManagement/` — actors/concerns feed scenarios
- `12-PracticalArtifacts/` — templates for Business Scenarios live here
- `15-BusinessArchitectureGuide/` — Business Scenarios complement capability maps & value streams
