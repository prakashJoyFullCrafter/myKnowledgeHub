# Solution Architecture

The discipline of translating **business needs into runnable systems** — defining what to build, why, how it must behave under load, how it's documented, and how stakeholders agree on it.

> Solution Architecture sits between **Enterprise Architecture** (TOGAF, Zachman — "what should the org look like?") and **System Design** ("how do we build this service?"). The Solution Architect owns the bridge: requirements → trade-offs → design → documentation → buy-in.

---

## Sections

| # | Topic | Description |
|---|-------|-------------|
| 01 | [TradeOffAnalysis](./01-TradeOffAnalysis/) | ATAM, quality attribute scenarios, decision matrices, ADRs, common architectural trade-offs |
| 02 | [NFRs](./02-NFRs/) | Non-Functional Requirements: 18 modules covering performance, scalability, availability, security, observability, compliance, multi-tenancy |
| 03 | [ArchitectureDocumentation](./03-ArchitectureDocumentation/) | C4, ADRs, arc42, diagrams-as-code, OpenAPI/AsyncAPI, sequence and deployment diagrams, anti-patterns |
| 04 | [StakeholderManagement](./04-StakeholderManagement/) | Identifying stakeholders, mapping concerns, multi-audience communication, ARBs, influence without authority |
| 05 | [C4Model](./05-C4Model/) | Context → Containers → Components → Code: visual architecture as a 4-level zoomable map |

---

## How They Fit Together

```text
Stakeholders (04) ──► Concerns ──► NFRs (02) ──► Trade-offs (01) ──► Design ──► Documentation (03 + 05)
```

1. **Stakeholders** (04) tell you who has what concerns
2. **NFRs** (02) translate those concerns into measurable quality targets
3. **Trade-off analysis** (01) chooses between architectures that satisfy NFRs differently
4. **Documentation** (03 + 05) captures the resulting design, the *why*, and the runtime behaviour — for builders, ops, auditors, and future readers

---

## Learning Path

| Phase | Order | Why |
|-------|-------|-----|
| Foundations | 04 → 02 | Understand who you're serving and what they need |
| Decision-making | 01 | Learn to pick between options with quantified rigour |
| Communication | 03 → 05 | Capture and share the result so it survives team turnover |

---

## Cross-References

- [01-TOGAF/](../01-TOGAF/) — enterprise context: ADM phases, requirements management, principles, governance
- [03-ProblemSolving/](../03-ProblemSolving/) — ATAM, ADRs, architecture reviews, decision frameworks
- [04-ZachmanFramework/](../04-ZachmanFramework/) — alternative enterprise architecture viewpoint matrix
- [02-SystemDesign/](../../02-SystemDesign/) — implementation patterns the solution architect picks from
- [01-MicroservicePatterns/](../../01-MicroservicePatterns/) — concrete patterns referenced in design
- [04-DomainDrivenDesign/](../../04-DomainDrivenDesign/) — strategic design language for bounded contexts

---

## Key Resources

- **Software Architecture in Practice** — Bass, Clements, Kazman (ATAM, quality attribute scenarios)
- **Documenting Software Architectures: Views and Beyond** — Clements et al.
- **Software Systems Architecture** — Rozanski & Woods (views and stakeholders)
- **Fundamentals of Software Architecture** — Mark Richards, Neal Ford
- **The Software Architect Elevator** — Gregor Hohpe (the architect's role across abstraction layers)
- **The C4 Model** — c4model.com (Simon Brown)
- **arc42** — arc42.org
- **ISO/IEC/IEEE 42010** — Architecture description standard
