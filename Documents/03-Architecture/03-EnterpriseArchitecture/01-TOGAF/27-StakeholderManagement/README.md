# Stakeholder Management — TOGAF Technique

> **A cross-cutting ADM technique for identifying, classifying, and engaging the people whose decisions affect — or are affected by — the architecture.**
> Architecture is a political activity as much as a technical one. Stakeholder management is what turns a "correct" architecture into an *adopted* architecture.

---

## 1. Why Stakeholder Management is a TOGAF Technique

In TOGAF, stakeholders are **anyone with a vested interest in the architecture** — not just management. Engineers, regulators, customers, ops teams, finance — all are potential stakeholders.

The architect's job is to:
- [ ] **Identify** every stakeholder
- [ ] **Understand** their concerns
- [ ] **Engage** them at the right level
- [ ] **Communicate** in a way they can absorb (their *viewpoints*)
- [ ] **Trace** their concerns into architecture decisions

### When in the ADM
- [ ] **Primary**: Phase A (Architecture Vision) — produce the Stakeholder Map
- [ ] **Continuous**: every phase of the ADM
- [ ] **Particularly intense in**: Phase G (Implementation Governance), where compliance reviews involve all stakeholders

### Outputs
- [ ] Stakeholder Map (matrix of stakeholders × concerns × viewpoints)
- [ ] Communications Plan
- [ ] Updated Architecture Vision incorporating stakeholder concerns
- [ ] Concerns → Requirements mapping

---

## 2. Core TOGAF Concepts

### Stakeholder
A person, team, or organization with **interests in or concerns about** the system.

### Concern
A specific interest of a stakeholder in the system — something they care about, want to influence, or be protected from.

### View
A representation of the architecture **from the perspective of one or more stakeholders**, addressing one or more concerns.

### Viewpoint
The **specification** for constructing a view — the rules, conventions, notations.

```
Stakeholder ──has──→ Concern
                       │
                       ↓
                    addressed by
                       │
                       ↓
                     View ←── built using ── Viewpoint
```

This concern → view → viewpoint chain is **directly from ISO 42010** (architecture description standard) — TOGAF aligns with it.

---

## 3. Stakeholder Identification

### Categories to consider
- [ ] **Corporate**: CEO, board, shareholders
- [ ] **Executive Management**: CIO, CTO, CFO, business unit heads
- [ ] **Line Management**: program managers, product managers
- [ ] **Architecture Function**: enterprise architects, solution architects, architecture board
- [ ] **Project / Delivery**: developers, QA, ops, SREs
- [ ] **External**: customers, partners, suppliers, regulators
- [ ] **End Users**: actual users of the systems
- [ ] **Operations**: support, NOC, security, compliance

### Discovery techniques
- [ ] Ask current stakeholders "who else cares about this?"
- [ ] Org chart walks
- [ ] Process maps — who participates at each step?
- [ ] Document review — who's named in policies, contracts, SOPs?
- [ ] "Who can kill this project?" — find the veto-holders early

### Common omissions (the "missing stakeholder" trap)
- [ ] Operations team (always involved, often not consulted in architecture)
- [ ] Security/Compliance (consulted late, find blockers late)
- [ ] Data privacy officer (especially under GDPR/CCPA)
- [ ] End users (in B2B, often invisible)
- [ ] Downstream consumers of data/APIs

---

## 4. Stakeholder Classification — Power/Interest Grid

The standard tool: a 2×2 matrix.

```
                  HIGH INTEREST
                       │
       Keep            │           Manage
       Informed        │           Closely
                       │
   ────────────────────┼──────────────────── HIGH
   LOW                 │                     POWER
   POWER               │
       Monitor         │           Keep
       (minimal        │           Satisfied
        effort)        │
                       │
                  LOW INTEREST
```

| Quadrant | Strategy | Examples |
|----------|----------|----------|
| **High Power, High Interest** | Manage Closely — frequent communication, deep involvement | Executive sponsor, architecture board chair |
| **High Power, Low Interest** | Keep Satisfied — periodic updates, no surprises | CFO, Legal |
| **Low Power, High Interest** | Keep Informed — regular detailed updates | Engineering teams, end users |
| **Low Power, Low Interest** | Monitor — minimal effort, watch for changes | Tangential teams |

### Derived strategies
- [ ] **Move stakeholders**: low → high power may need different engagement over time
- [ ] **Coalition building**: cluster supportive low-power stakeholders into a unified voice
- [ ] **De-risk vetoes**: identify high-power skeptics early, address concerns before formal review
- [ ] **Champion development**: identify high-interest evangelists, equip them with materials

---

## 5. Concern Elicitation

### Per-stakeholder questions
- [ ] What's your role in this initiative?
- [ ] What does success look like for you?
- [ ] What keeps you up at night about this work?
- [ ] What constraints (regulatory, budgetary, timeline) bind you?
- [ ] Who else should I be talking to?
- [ ] What's worked / failed in similar past efforts?
- [ ] How will you measure success?
- [ ] What's your decision authority? Veto power?

### Common concern categories

| Category | Example concerns |
|----------|------------------|
| Business | Revenue impact, customer experience, market positioning |
| Cost | TCO, OpEx vs CapEx, ROI timeline |
| Risk | Security, compliance, business continuity, vendor lock-in |
| Quality | Performance, reliability, maintainability |
| People | Skills, headcount, organizational change |
| Time | Time-to-market, deadlines, regulatory milestones |
| Data | Privacy, residency, ownership, integrity |
| Operations | Supportability, observability, on-call burden |

---

## 6. Stakeholder Map Template

```markdown
# Stakeholder Map: [Initiative Name]

| ID | Stakeholder | Role | Power | Interest | Strategy | Concerns | Viewpoint(s) Required | Owner |
|----|-------------|------|-------|----------|----------|----------|----------------------|-------|
| S1 | Jane Doe    | CFO  | High  | Med      | Keep Satisfied | Cost, ROI | Cost view | Architect lead |
| S2 | Ops Director| Ops Mgr | Med | High   | Keep Informed | Supportability, on-call | Operations view | Solution architect |
| S3 | DPO         | Compliance | High | High | Manage Closely | GDPR, data residency | Data privacy view | Compliance lead |

## Communication Plan
| Stakeholder Group | Frequency | Format | Owner |
|-------------------|-----------|--------|-------|
| Executive sponsor | Bi-weekly | 1-page summary | Architect lead |
| Engineering teams | Weekly    | Tech deep-dive | Solution architect |
| Compliance        | At gates  | Compliance pack | Compliance lead |

## Concern → Architecture Decision Trace
| Concern ID | Concern | Addressed By | Status |
|-----------|---------|--------------|--------|
| C1 | GDPR data residency | Multi-region data architecture (Phase D) | Designed |
| C2 | On-call burden | Auto-remediation runbooks (Phase G) | In progress |
```

---

## 7. Viewpoints — Communication by Audience

A common architecture mistake: showing the same diagram to everyone.

### Match viewpoint to stakeholder
| Stakeholder | Useful Viewpoints |
|-------------|-------------------|
| CEO/CFO | Business value view, cost view, roadmap |
| CIO/CTO | Architecture vision, technology landscape, capability map |
| Engineering | Component view, deployment view, sequence diagrams |
| Operations | Operations view, resilience view, capacity view |
| Security | Threat model, trust boundaries, data flow |
| Compliance | Data flow + retention, audit log, regulatory mapping |
| End User | User journey, capability scope |

ArchiMate provides a rich vocabulary of viewpoints — see `04-ArchiMate/`.

### Anti-pattern: the wall-of-rectangles
- [ ] Showing a 200-component logical diagram to a CFO
- [ ] Showing financial NPV to engineers
- [ ] Reusing "the architecture deck" for every audience
- [ ] No glossary in mixed-audience presentations

### Layered communication
- [ ] **Elevator pitch** (1 minute) — for chance encounters
- [ ] **One-pager** (5 minutes) — for executive readouts
- [ ] **Deck** (30 minutes) — for governance reviews
- [ ] **Reference document** (deep) — for engineering and compliance review

---

## 8. RACI for Architecture Decisions

A complement to the stakeholder map — clarifies decision authority:

| Role | Definition |
|------|-----------|
| **R**esponsible | Does the work |
| **A**ccountable | Owns the outcome (only one per decision) |
| **C**onsulted | Two-way input before decision |
| **I**nformed | One-way notification after decision |

Use RACI for:
- [ ] Architecture principles approval
- [ ] Vendor selection
- [ ] Standard adoption (e.g., picking a cloud provider)
- [ ] Variance approvals / waivers
- [ ] Major architecture change requests

---

## 9. Stakeholder Engagement Through the ADM

| Phase | Stakeholder Activity |
|-------|---------------------|
| Preliminary | Identify EA sponsor; baseline org understanding |
| A — Vision | Build initial stakeholder map; elicit concerns; produce vision |
| B — Business | Validate business architecture with business stakeholders |
| C — Information Systems | Validate with data owners, application owners |
| D — Technology | Validate with infra, ops, security |
| E — Opportunities & Solutions | Engage delivery / project leadership for feasibility |
| F — Migration Planning | Engage program management, finance |
| G — Implementation Governance | Compliance reviews with all stakeholder groups |
| H — Architecture Change Management | Stakeholder feedback loop, change requests |

---

## 10. Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Missing stakeholders | Late-stage objections kill the project | Discovery sweep early; ask current stakeholders "who else?" |
| Treating all stakeholders equally | Wasted effort on low-power, key people under-engaged | Use Power/Interest grid |
| Only formal meetings | Real concerns surface in hallway conversations | Mix formal + informal channels |
| One viewpoint for all audiences | Loses non-technical stakeholders | Tailor viewpoints |
| Concerns not traced to decisions | Stakeholders feel unheard, withdraw support | Maintain concern→decision trace matrix |
| Static stakeholder map | Org changes, but doc doesn't | Refresh map at start of each ADM cycle |
| Sponsor lost mid-flight | New sponsor doesn't share vision | Re-engage every leadership change |

---

## 11. Stakeholder Resistance — Patterns and Responses

| Resistance Pattern | Likely Cause | Response |
|--------------------|--------------|----------|
| "We tried this before" | Past failure, scarred | Acknowledge history; show what's different |
| Veto without explanation | Hidden concern (often political) | 1:1 conversation, low-stakes |
| Endless detail requests | Insecurity / risk aversion | Provide structured doc, set scope of input |
| Pocket veto (delays) | Misaligned incentives | Re-align incentives; escalate to sponsor |
| "Not invented here" | Identity attached to existing system | Position as evolution, not replacement |
| Compliance as blocker | Late involvement | Engage compliance from Phase A |

---

## 12. Certification Angle

### L1 (Foundation)
- [ ] Definitions: Stakeholder, Concern, View, Viewpoint
- [ ] ISO 42010 alignment
- [ ] Stakeholder Map as Phase A output
- [ ] Power/Interest classification

### L2 (Practitioner)
- [ ] Choosing the right stakeholder management strategy in a scenario
- [ ] Recommending which viewpoint to produce for which stakeholder
- [ ] Recognizing missing stakeholders in a scenario
- [ ] Mapping concerns to ADM phases and architecture decisions
- [ ] Communications planning judgments

---

## 13. Practice Exercises

1. Build a Stakeholder Map for a real initiative — include at least 10 stakeholders with concerns
2. Take a list of 20 stakeholders and place each on a Power/Interest grid; explain placement
3. Pick 3 of those stakeholders; design a 1-page communication tailored to each
4. Map 5 concerns from your stakeholder map to specific ADM phase outputs
5. Critique a sample stakeholder map: who's missing? what concerns are unaddressed?

---

## 14. Resources

- **TOGAF Standard, 10th Edition** — Stakeholder Management technique (in ADM Techniques chapter)
- **ISO/IEC/IEEE 42010** — Systems and software engineering — Architecture description
- **ArchiMate Specification** — Stakeholder, Driver, Goal, Concern in Motivation aspect
- *Influence: The Psychology of Persuasion* — Robert Cialdini (for resistance handling)
- *Crucial Conversations* — Patterson, Grenny et al.
- The Open Group: *Stakeholder Management Best Practices*

🔗 Cross-refs:
- `01-ADMCycle/` — Phase A produces the Stakeholder Map
- `04-ArchiMate/` — Motivation viewpoint (Stakeholder, Driver, Goal, Concern)
- `26-BusinessScenarios/` — actors in scenarios are stakeholders
- `28-ArchitecturePrinciples/` — principles are validated against stakeholder concerns
- `03-Governance/` — stakeholder engagement during compliance reviews
