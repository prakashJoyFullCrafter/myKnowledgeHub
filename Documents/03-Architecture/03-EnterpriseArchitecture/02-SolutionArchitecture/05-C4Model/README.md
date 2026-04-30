# C4 Model - Curriculum

## Module 1: The Problem with "Boxes and Lines"
- [ ] Most architecture diagrams are ambiguous: what is a "box"? a service? a class? a server? a team?
- [ ] No shared notation across teams → diagrams that confuse rather than clarify
- [ ] UML is too heavy for daily use; ad-hoc diagrams lack discipline
- [ ] **Simon Brown's insight**: software architecture diagrams should work like maps — multiple zoom levels, each with a clear scope and audience
- [ ] **C4** = Context → Containers → Components → Code, four hierarchical levels
- [ ] Goal: diagrams that are **abstraction-first, notation-second**; tooling-independent; readable without a legend
- [ ] Pairs naturally with **ADRs** (decisions) and **arc42** (sections) — C4 is *what*, ADRs are *why*

## Module 2: The Four Levels
- [ ] **Level 1 — System Context**: the big picture
  - [ ] One software system in the middle, surrounded by users and external systems
  - [ ] Audience: everyone (technical and non-technical)
  - [ ] Question answered: "what are we building, and what does it interact with?"
- [ ] **Level 2 — Containers**: applications and data stores
  - [ ] "Container" ≠ Docker; means a separately deployable/runnable unit (web app, mobile app, API service, database, message broker, file system)
  - [ ] Shows tech choices (Spring Boot, Postgres, React)
  - [ ] Audience: technical staff inside and outside the team
  - [ ] Question answered: "what are the high-level moving parts and how do they communicate?"
- [ ] **Level 3 — Components**: inside a single container
  - [ ] Logical components / modules within one container; shows responsibilities and key interfaces
  - [ ] Maps to packages, modules, or major classes — not 1:1 with classes
  - [ ] Audience: software architects and developers
  - [ ] Question answered: "how is this container structured internally?"
- [ ] **Level 4 — Code** (optional): UML class / sequence diagrams for one component
  - [ ] Often skipped — IDE + code itself is the source of truth; only diagram non-obvious structures
- [ ] Supplementary diagrams: System Landscape (multiple systems), Dynamic (runtime sequence), Deployment (infrastructure mapping)

## Module 3: Notation & Diagram Conventions
- [ ] **Boxes**: software systems, containers, components — distinguished by colour/shading
- [ ] **People**: stick figures for users / roles
- [ ] **Lines**: relationships, with verb-phrase labels (`Reads from`, `Sends notifications via`) and protocol/tech (`HTTPS/JSON`, `gRPC`, `SQL/JDBC`)
- [ ] **Direction**: arrows show direction of dependency or data flow — pick one convention per diagram
- [ ] **Title every diagram**: "[System Name] — System Context" — never leave a diagram untitled
- [ ] **Always include a legend / key**: don't assume the reader knows what colours/shapes mean
- [ ] **Acronyms**: spell out on first use; no insider jargon in Context diagrams
- [ ] Anti-patterns: "lasagna" diagrams (everything connected to everything), inconsistent abstraction levels in one diagram, mystery boxes

## Module 4: Tooling
- [ ] **Structurizr** (Simon Brown's tool): defines architecture as code in a DSL; auto-generates all four C4 levels from one model — single source of truth
  - [ ] `workspace.dsl` defines the model once → renders Context + Containers + Components without duplication
  - [ ] Structurizr Lite (free, self-hosted), Structurizr Cloud (paid hosted)
- [ ] **PlantUML + C4-PlantUML library**: text-based diagrams; widely supported in IDEs, GitHub, Confluence; less DRY than Structurizr (each level redefines elements)
- [ ] **Mermaid + c4 syntax**: native rendering in GitHub READMEs, GitLab, modern docs platforms; weakest C4 support of the three but lowest friction
- [ ] **Diagrams.net (draw.io)**: visual editor with C4 shape libraries; good for one-off, bad for evolution
- [ ] **Excalidraw / Whimsical / Miro**: workshop tools; convert to "real" tooling once stable
- [ ] **IcePanel, Multiplayer, Lucidscale**: commercial C4-aware modelling tools
- [ ] Choose based on workflow: code-first (Structurizr/PlantUML) vs visual-first (draw.io/IcePanel) — pick one per project, not per diagram

## Module 5: Practice & Anti-Patterns
- [ ] **Diagrams should evolve with code** — store DSL/PlantUML alongside source, render in CI, embed in README
- [ ] **Don't draw all four levels for everything** — Context + Containers cover 80% of needs; Components only for genuinely complex containers
- [ ] **Pair with ADRs**: C4 shows the structure, ADRs explain *why* (why Postgres not Mongo, why split into two services)
- [ ] **Pair with arc42**: arc42 sections 5 (Building Block View) and 7 (Deployment View) map directly onto C4 Containers/Components
- [ ] **Don't conflate logical and physical** — C4 is logical; deployment diagrams show *where* containers run
- [ ] **Workshop pattern**: start with Context on a whiteboard with stakeholders → refine to Containers with the team → develop Components only for the parts being built
- [ ] **Anti-patterns**:
  - [ ] Mixing levels in one diagram (a class next to a service next to a user)
  - [ ] Components diagram with no Container parent named
  - [ ] Diagrams generated once, never updated — stale C4 is worse than no diagram
  - [ ] Reaching for Level 4 (Code) when the code itself is more readable
  - [ ] Using C4 to document everything — apply it to system-shaping decisions, not every utility

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Pick a real system you've built; draw Context + Containers on paper; share with a non-technical colleague — do they get it? |
| Module 3 | Audit your current architecture diagrams against C4 conventions; fix the worst offender |
| Module 4 | Set up Structurizr Lite locally; model the same system in DSL; commit `workspace.dsl` to git |
| Module 4 | Compare: same Container diagram in Structurizr vs PlantUML vs Mermaid — which fits your workflow? |
| Module 5 | Add a `docs/architecture/` folder to a project: C4 DSL + 3-5 ADRs + arc42 skeleton; render in CI |
| Module 5 | 6 months later, revisit: did the diagrams stay in sync? If not, what's the fix — better tooling or better discipline? |

## Cross-References
- `03-EnterpriseArchitecture/02-SolutionArchitecture/03-ArchitectureDocumentation/` — the parent topic; C4 is one tool in the toolbox
- `03-EnterpriseArchitecture/02-SolutionArchitecture/04-StakeholderManagement/` — Context diagrams are the primary stakeholder artifact
- `03-EnterpriseArchitecture/01-TOGAF/04-ArchiMate/` — ArchiMate is C4's enterprise-scale cousin; C4 is closer to the team / system level
- `03-EnterpriseArchitecture/03-ProblemSolving/03-ArchitectureReviews/` — reviews use C4 diagrams as input

## Key Resources
- **The C4 Model for Software Architecture** — c4model.com (Simon Brown — the canonical reference)
- **Software Architecture for Developers** - Simon Brown (the book)
- **Structurizr** — structurizr.com (DSL + tooling)
- **C4-PlantUML** — github.com/plantuml-stdlib/C4-PlantUML
- **arc42** — arc42.org (companion documentation template)
- **Documenting Software Architectures: Views and Beyond** - Clements et al. (foundational; predates and influenced C4)
- **"The Art of Visualising Software Architecture"** - Simon Brown (free Leanpub book)
