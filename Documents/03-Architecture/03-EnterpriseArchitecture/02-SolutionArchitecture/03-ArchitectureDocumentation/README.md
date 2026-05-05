# Architecture Documentation — Curriculum

How to capture an architecture so future readers — new hires, ops engineers, auditors, your future self — can understand *what* exists, *why* it was built that way, and *how* it works at runtime.

> Documentation is what makes architecture *transferable*. Code shows what is; documentation shows what was intended, and why. This module is the **index** — specific tools (C4, ADRs) have their own deep-dives.

---

## Module 1: The Documentation Problem
- [ ] Code answers *what*; documentation answers *why* and *what was rejected*
- [ ] Reasons docs go stale: written once, owned by no one, reviewed by no one, linked from nowhere
- [ ] **Living documentation principle**: docs that live next to code, render in CI, and break the build when out of sync
- [ ] **Audience-driven docs**: a Context diagram is not for developers, an OpenAPI spec is not for executives
- [ ] **Just-enough principle**: the cost of documentation is reading + maintaining; over-documentation is a real anti-pattern
- [ ] What gets documented: cross-cutting decisions, integration points, NFRs, runtime behaviour, deployment topology — not every utility class

## Module 2: The Three Layers — What / Why / How
- [ ] **What** the system is — structural views (C4, deployment diagrams, component lists)
- [ ] **Why** it is the way it is — ADRs, trade-off records, requirements traceability
- [ ] **How** it behaves — sequence diagrams, runtime views, API specs, runbooks
- [ ] All three are needed; teams that document only "what" produce diagrams nobody can defend
- [ ] **Stakeholder mapping**: which audience needs which layer? (execs need *what*, developers need *what + how*, architects need all three)

## Module 3: C4 Model — Structural Views
- [ ] Context → Containers → Components → Code as four hierarchical zoom levels
- [ ] When to draw which level (rule of thumb: Context + Containers cover 80% of needs)
- [ ] Notation discipline: legends, titles, verb-phrase relationship labels
- [ ] Tooling: Structurizr (DSL), C4-PlantUML, Mermaid, IcePanel, draw.io

> **Full curriculum**: [05-C4Model/](../05-C4Model/) — 5 modules covering levels, notation, tooling, and anti-patterns

## Module 4: Architecture Decision Records (ADRs)
- [ ] Short markdown documents — **Context, Decision, Consequences**
- [ ] One decision per ADR; numbered; immutable; superseded rather than edited
- [ ] Variants: Nygard ADR, MADR, Y-statement
- [ ] Live alongside code (`docs/adr/`); linked from README; rendered in CI
- [ ] Status workflow: proposed → accepted → deprecated → superseded
- [ ] Tools: `adr-tools` CLI, `log4brains`, IDE templates, GitHub PR-driven review
- [ ] What deserves an ADR: anything that would surprise a new team member six months from now

> Deep-dive: [01-TradeOffAnalysis (Module 6)](../01-TradeOffAnalysis/) and [03-ProblemSolving/02-DecisionFrameworks/](../../03-ProblemSolving/02-DecisionFrameworks/)

## Module 5: arc42 Template
- [ ] **arc42** — open-source architecture documentation template (Gernot Starke)
- [ ] 12 sections: goals, constraints, context, solution strategy, building blocks, runtime, deployment, concepts, decisions, quality, risks, glossary
- [ ] Designed to be **subsetted** — fill in only what your project needs
- [ ] Plays well with C4 (Section 5 = Building Blocks ↔ C4 Containers/Components)
- [ ] Plays well with ADRs (Section 9 = Decisions)
- [ ] Anti-pattern: filling in all 12 sections "for completeness" — produces unread documents
- [ ] Resources: arc42.org, arc42-by-example, golden rules

## Module 6: Diagrams as Code
- [ ] **Why diagrams as code**: text in git → diff-able, review-able, evolves with the system
- [ ] **PlantUML**: text-based UML/C4/sequence/deployment; broad IDE/Confluence support
- [ ] **Mermaid**: native rendering in GitHub, GitLab, Notion, modern docs platforms; lower-friction than PlantUML
- [ ] **Structurizr DSL**: model-once, render-many — all four C4 levels from one source of truth
- [ ] **Diagrams (Python)**: cloud-system diagrams as Python code; common for AWS/GCP/Azure architectures
- [ ] **D2** (Terrastruct): newer text-to-diagram language with strong layout
- [ ] CI rendering: pre-commit hook → render → commit images → embed in README
- [ ] Choose **one** tool per project — switching tools mid-project is a tax

## Module 7: API Documentation
- [ ] **OpenAPI (Swagger)**: REST API contracts — endpoints, schemas, auth, examples
  - [ ] Swagger UI for human readers; ReDoc for cleaner reference style
  - [ ] Code-first (springdoc-openapi, FastAPI) vs spec-first (Stoplight, OpenAPI Generator)
  - [ ] Spec-first preferred for cross-team APIs — the contract is the source of truth
- [ ] **AsyncAPI**: messaging API contracts (Kafka topics, RabbitMQ exchanges, WebSocket)
- [ ] **gRPC**: `.proto` files are themselves the contract; documentation generated from them
- [ ] **GraphQL**: SDL is the contract; introspection enables auto-documentation
- [ ] **API documentation portals**: Backstage, Stoplight, Redocly — central catalogue across services
- [ ] **API versioning** strategy must be documented — URI vs header vs content negotiation

> Deep-dive: [API Design (System Design)](../../../02-SystemDesign/03-SystemDesign/26-APIDesign/)

## Module 8: Runtime & Behaviour Documentation
- [ ] **Sequence diagrams** for non-obvious flows — auth, distributed transactions, saga compensations
  - [ ] Mermaid `sequenceDiagram`, PlantUML `@startuml`, Structurizr dynamic views
  - [ ] One diagram per critical flow; not every flow needs a diagram
- [ ] **State diagrams** for stateful entities (order lifecycle, account status)
- [ ] **Activity / flowcharts** for business processes that cross system boundaries
- [ ] **Deployment diagrams**: physical / cloud topology — where do containers run, how do they connect
- [ ] **Runbooks**: step-by-step operational procedures — incident response, common tasks, escalation
- [ ] **Postmortems**: blameless retros of incidents — institutional memory

## Module 9: Living Documentation Practices
- [ ] **Docs in the repo**: `docs/`, `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md` — versioned with code
- [ ] **PR review for docs**: doc changes go through the same review as code
- [ ] **CI gates**: link checking, spell check, schema validation for OpenAPI / AsyncAPI
- [ ] **Generated docs**: from code (Javadoc, KDoc, TSDoc), from specs (OpenAPI), from infrastructure (terraform-docs)
- [ ] **Architecture portals**: Backstage TechDocs, Read the Docs, Confluence (last resort)
- [ ] **Decision audit trail**: ADRs + git history = full reasoning over time
- [ ] **Onboarding test**: can a new hire get to "first PR" using docs alone?

## Module 10: Anti-Patterns
- [ ] **Stale docs** — written once, never updated; worse than no docs (actively misleads)
- [ ] **Diagram-driven design** — pretty pictures with no decisions behind them
- [ ] **Wiki sprawl** — 200 Confluence pages, no index, conflicting versions
- [ ] **Over-documentation** — documenting every utility class; readers stop reading
- [ ] **Insider jargon** without a glossary — onboarding tax
- [ ] **One-author docs** — single point of failure; gets stale when author leaves
- [ ] **No update trigger** — docs only update during incidents (too late)
- [ ] **Boilerplate filler** — sections present because the template said so, not because the project needs them

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Audit your current architecture docs: who updates them? when last updated? are they linked? |
| Module 3 | Pick a project and produce Context + Container diagrams using Structurizr or PlantUML |
| Module 4 | Write 3 ADRs for past decisions; commit them to `docs/adr/` |
| Module 5 | Take an arc42 template; fill in sections 1, 3, 5, 9 for one of your projects |
| Module 6 | Convert a hand-drawn diagram to PlantUML or Mermaid; render in CI |
| Module 7 | Generate an OpenAPI spec from a Spring Boot app using springdoc-openapi |
| Module 8 | Draw a sequence diagram for the most complex runtime flow you've built |
| Module 9 | Add a `docs/architecture/` section to a repo: C4 + ADRs + arc42 skeleton + runbook |

## Cross-References
- [05-C4Model/](../05-C4Model/) — full C4 curriculum
- [01-TradeOffAnalysis/](../01-TradeOffAnalysis/) — ADRs in the trade-off context
- [04-StakeholderManagement/](../04-StakeholderManagement/) — audience-driven view selection
- [02-NFRs/](../02-NFRs/) — Module 17 covers NFR-specific document templates
- [03-ProblemSolving/02-DecisionFrameworks/](../../03-ProblemSolving/02-DecisionFrameworks/) — ADR templates and tooling
- [02-SystemDesign/03-SystemDesign/26-APIDesign/](../../../02-SystemDesign/03-SystemDesign/26-APIDesign/) — API design and documentation
- [04-DomainDrivenDesign/](../../../04-DomainDrivenDesign/) — context maps as a documentation artefact

## Key Resources
- **Documenting Software Architectures: Views and Beyond** — Clements et al. (the foundational text)
- **The C4 Model for Software Architecture** — c4model.com (Simon Brown)
- **arc42** — arc42.org (template + golden rules)
- **Architecture Decision Records** — adr.github.io
- **MADR** — github.com/adr/madr
- **OpenAPI Specification** — openapis.org
- **AsyncAPI** — asyncapi.com
- **Structurizr** — structurizr.com
- **Backstage TechDocs** — backstage.io
- *Living Documentation* — Cyrille Martraire (book on docs that evolve with code)
