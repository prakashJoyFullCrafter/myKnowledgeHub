# Zachman Framework - Curriculum

> The original Enterprise Architecture framework — **John Zachman, 1987 (IBM)**. A taxonomy, not a methodology: a 6×6 matrix that organises everything an enterprise needs to describe itself. The vocabulary that influenced TOGAF, ArchiMate, FEAF, and DoDAF.

## Module 1: The Problem & What Zachman Actually Is
- [ ] Enterprises produce thousands of artefacts: requirements, models, schemas, processes, network diagrams, role definitions — most have no shared organising structure
- [ ] Symptoms of missing taxonomy: the same concept described differently by every team, gaps you discover at integration time, duplication nobody can untangle
- [ ] **Zachman's insight**: borrowed from architecture (the building kind) and engineering — every complex artefact (a building, a plane, an enterprise) can be described from the **same set of perspectives** asking the **same set of questions**
- [ ] **What Zachman IS**:
  - [ ] A **classification schema** — a 6×6 ontology for enterprise descriptions
  - [ ] A **taxonomy** — vocabulary and structure
  - [ ] **Implementation-neutral** — doesn't say HOW to build, just what aspects need description
- [ ] **What Zachman is NOT**:
  - [ ] **Not a methodology** — no process, no steps, no deliverable templates (TOGAF's ADM is the methodology Zachman lacks)
  - [ ] Not a tool — there's no "Zachman software"
  - [ ] Not a maturity model
  - [ ] Not optional cells — every cell is required for completeness, even if some are sparsely populated
- [ ] **Use case**: gap analysis — "where in the matrix do we have nothing? where do we have inconsistent answers?"
- [ ] **Pairs with TOGAF**: TOGAF's ADM tells you HOW to build; Zachman tells you WHAT to describe — many enterprises use both

## Module 2: The Six Interrogatives (Columns)
- [ ] The six universal questions about anything:
  - [ ] **What** — Data / Inventory (entities, things)
  - [ ] **How** — Function / Process (transformations, activities)
  - [ ] **Where** — Network / Distribution (locations, nodes)
  - [ ] **Who** — People / Organisation (roles, responsibilities)
  - [ ] **When** — Time / Timing (events, cycles, schedules)
  - [ ] **Why** — Motivation (goals, strategies, rules)
- [ ] **Rule**: each column is a single, independent abstraction — never mix (don't put process logic in the "What" column)
- [ ] **Each column has its own modelling discipline**:
  - [ ] What → ER models, ontologies, data dictionaries
  - [ ] How → process maps, BPMN, function decomposition
  - [ ] Where → network diagrams, deployment topologies
  - [ ] Who → org charts, RACI, role matrices
  - [ ] When → schedules, event sequences, timing diagrams
  - [ ] Why → goal models, business motivation, rule catalogues
- [ ] **The "Why" column is most often missed** — most architectures document the structure but not the rationale

## Module 3: The Six Perspectives (Rows)
- [ ] Each row = a different stakeholder's view of the same enterprise — same six questions, different abstraction:
  - [ ] **Row 1 — Executive Perspective (Scope/Contexts)** — "the planner's view"
    - [ ] Boundaries, scope, list of major things — context-level only
  - [ ] **Row 2 — Business Management Perspective (Concepts)** — "the owner's view"
    - [ ] Business model, processes, locations, organisation, schedule, business strategy
  - [ ] **Row 3 — Architect Perspective (Logical)** — "the designer's view"
    - [ ] System logical models — data models, process models, network logical, role logical, master schedule, business rule model
  - [ ] **Row 4 — Engineer Perspective (Physical)** — "the builder's view"
    - [ ] Technology models — physical data, system design, network physical, presentation, processing structure, rule design
  - [ ] **Row 5 — Technician Perspective (Detailed Representations)** — "the implementer's view"
    - [ ] Tool-specific configurations — DDL, source code, network configs, security configs, timing definitions, rule specifications
  - [ ] **Row 6 — Enterprise Perspective (Functioning Enterprise)** — "the operating reality"
    - [ ] The actual running enterprise — populated databases, executing processes, real org doing real work
- [ ] **Vertical alignment matters**: Row 4 "physical data" must be a refinement of Row 3 "logical data" must be a refinement of Row 2 "business entities"
- [ ] **Common confusion**: rows are NOT a development lifecycle — they're concurrent perspectives that should all be kept current

## Module 4: The 6×6 Matrix — Cells & Rules
- [ ] Each cell sits at the intersection of (Perspective × Interrogative) — 36 cells total
- [ ] Examples:
  - [ ] (Architect × What) = logical data model
  - [ ] (Engineer × Where) = network physical design
  - [ ] (Owner × Why) = business strategy & rules
  - [ ] (Technician × When) = scheduling specifications
- [ ] **Zachman's seven rules**:
  1. [ ] Don't add rows or columns to the framework (it's complete)
  2. [ ] Each column has a simple basic model (its own modelling notation)
  3. [ ] Each cell's basic model must be unique (no overlap with neighbours)
  4. [ ] Each row represents a distinct, unique perspective
  5. [ ] Each cell is unique (one cell, one type of artefact)
  6. [ ] Combining cells in a row produces a complete description from that perspective
  7. [ ] The logic is recursive — sub-systems can have their own Zachman matrix
- [ ] **Cells are NOT optional**: a complete enterprise architecture has artefacts for every cell — even if just "explicitly empty / not applicable"
- [ ] **Vertical reading**: shows refinement — same column from Row 1 to Row 6 = scope to running reality
- [ ] **Horizontal reading**: shows completeness — all six interrogatives at one perspective level
- [ ] **Diagonal reading**: not meaningful — no sequencing implied

## Module 5: Zachman vs TOGAF & Other Frameworks
- [ ] **Zachman vs TOGAF**:
  - [ ] Zachman = **what to describe** (taxonomy); TOGAF = **how to develop & govern** (process — the ADM)
  - [ ] Zachman = ontology of artefacts; TOGAF = phased methodology with deliverables
  - [ ] Zachman is older (1987) and influenced TOGAF (1995)
  - [ ] **Combined use**: Zachman for completeness checks, TOGAF for execution discipline — common in mature EA orgs
- [ ] **Zachman vs FEAF (Federal Enterprise Architecture Framework)**:
  - [ ] FEAF (US Federal Government) explicitly extends Zachman; uses the same matrix
- [ ] **Zachman vs DoDAF (US Department of Defense Architecture Framework)**:
  - [ ] DoDAF organised around "viewpoints" (Operational, Systems, Technical) — different organisation but conceptually maps onto Zachman cells
- [ ] **Zachman vs ArchiMate**:
  - [ ] ArchiMate = a modelling **language** (notation); Zachman = an **organising taxonomy**
  - [ ] ArchiMate diagrams populate Zachman cells (especially rows 2-4)
- [ ] **Zachman vs C4**:
  - [ ] Different scope: Zachman is enterprise-wide; C4 is one software system
  - [ ] C4 levels (Context/Container/Component/Code) loosely map to Zachman rows for a single system column
- [ ] **Zachman's strength**: completeness checking — "can we describe row N column M?"
- [ ] **Zachman's weakness**: heavy, abstract, easy to misuse as a documentation goal rather than a thinking tool

## Module 6: Practical Application & Anti-Patterns
- [ ] **When Zachman pays off**:
  - [ ] Large enterprises with multiple LOBs needing common vocabulary
  - [ ] M&A integration — gap analysis between two organisations' artefacts
  - [ ] Regulatory/compliance environments where completeness matters (financial, defence, healthcare)
  - [ ] When TOGAF artefacts feel disconnected — Zachman provides the organising frame
- [ ] **When Zachman is overkill**:
  - [ ] Small/medium organisations
  - [ ] Single-product startups
  - [ ] Project-level architecture (use C4 + ADRs instead)
- [ ] **Lightweight application** (the practical version):
  - [ ] Pick 3-4 high-priority cells — usually (Owner × What), (Owner × Why), (Designer × How), (Builder × Where)
  - [ ] Populate them well rather than all 36 poorly
  - [ ] Use the matrix as a checklist when reviewing architecture deliverables
- [ ] **Anti-patterns**:
  - [ ] **Filling cells for the sake of completeness** — Zachman as bureaucracy
  - [ ] **Treating it as a methodology** — Zachman won't tell you HOW to build; you still need ADM, Scrum, SAFe, or whatever
  - [ ] **Conflating row 6 with all other rows** — the running enterprise is not the same as the documentation
  - [ ] **Adding columns / rows** — rule violation; defeats the purpose of a fixed taxonomy
  - [ ] **Believing any one cell is "the architecture"** — architecture lives across cells; no single artefact is sufficient
  - [ ] **Static documentation** — cells must be kept current; stale Zachman is worse than no Zachman
- [ ] **Modern reality**: pure Zachman implementations are rare; the *vocabulary* and *gap-analysis discipline* are widely used inside TOGAF/FEAF practices

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Take a system you maintain; for each of the 6 interrogatives, list the artefacts you have and don't have |
| Module 3 | For one column (say "What"), trace it through all 6 rows for one of your systems — where do you have artefacts? where are you missing levels? |
| Module 4 | Print the 6×6 matrix; do a quick audit on a real architecture — colour cells: green (have it), yellow (partial), red (nothing) |
| Module 5 | If your org uses TOGAF: map TOGAF deliverables (Architecture Vision, Business Architecture, etc.) onto Zachman cells; identify gaps |
| Module 6 | Try a "lightweight Zachman" on one project: pick 4 priority cells, populate well; share with the team — useful or bureaucratic? |
| Module 6 | Find a real "Why" column for an architecture decision; capture as ADR; observe how often "Why" was missing before |

## Cross-References
- `03-EnterpriseArchitecture/01-TOGAF/` — sister framework; methodology to Zachman's taxonomy
- `03-EnterpriseArchitecture/01-TOGAF/04-ArchiMate/` — modelling language that populates Zachman cells
- `03-EnterpriseArchitecture/01-TOGAF/02-ArchitectureDomains/` — Business/Data/Application/Technology domains overlap with Zachman columns
- `03-EnterpriseArchitecture/02-SolutionArchitecture/05-C4Model/` — single-system equivalent at smaller scale
- `03-EnterpriseArchitecture/02-SolutionArchitecture/03-ArchitectureDocumentation/` — how Zachman artefacts are captured
- `03-EnterpriseArchitecture/03-ProblemSolving/04-ATAM/` — ATAM analyses populated cells; Zachman ensures cells exist
- `03-EnterpriseArchitecture/01-TOGAF/17-TOGAFHistory/` — the history of TOGAF includes Zachman's influence

## Key Resources
- **"A Framework for Information Systems Architecture"** - John Zachman, IBM Systems Journal, 1987 (the original paper, free online)
- **The Zachman Framework for Enterprise Architecture** - John Zachman (the canonical reference)
- **Zachman International** - zachman.com (official site, training, certification)
- **Enterprise Architecture as Strategy** - Ross, Weill, Robertson (MIT — broader context for EA frameworks)
- **A Comparison of the Top Four Enterprise-Architecture Methodologies** - Roger Sessions (TOGAF / Zachman / FEAF / Gartner side-by-side)
- **The TOGAF Standard** — references Zachman as a complementary classification framework
- **Open Group: "TOGAF and the Zachman Framework"** white paper
