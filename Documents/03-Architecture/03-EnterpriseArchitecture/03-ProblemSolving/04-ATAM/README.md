# ATAM (Architecture Tradeoff Analysis Method) - Curriculum

> A structured, scenario-based method developed at the **SEI (Carnegie Mellon)** for evaluating an architecture against quality attributes — exposing risks, tradeoffs, and sensitivity points *before* commitment.

## Module 1: The Problem & Why ATAM Exists
- [ ] Architecture decisions made today set the cost ceiling for the next 5-10 years — yet most are made informally, with no structured review
- [ ] Symptoms of skipped review: production surprises (we didn't realise it wouldn't scale), team disagreements relitigated quarterly, NFRs treated as wishlist
- [ ] **The SEI insight** (1998): you can't evaluate an architecture against vague goals like "scalable, secure, maintainable" — you need **concrete scenarios** and a structured way to ask "does this architecture meet THIS scenario?"
- [ ] **ATAM's purpose**: surface **risks**, **non-risks**, **sensitivity points**, and **tradeoffs** — NOT to give a pass/fail verdict
- [ ] **What ATAM is not**:
  - [ ] Not a code review — works from architecture documents (C4, deployment diagrams, ADRs)
  - [ ] Not a prescriptive process improvement — analytical, not corrective
  - [ ] Not "the architect's review" — multi-stakeholder by design
- [ ] **Outputs are findings, not decisions**: ATAM exposes consequences; the team still decides
- [ ] **Sister methods**: SAAM (predecessor, simpler), CBAM (cost-benefit follow-up), QAW (Quality Attribute Workshop — feeds ATAM)

## Module 2: Core Concepts
- [ ] **Quality Attribute (QA)**: measurable -ility — performance, availability, security, modifiability, usability, testability, deployability, scalability, interoperability
- [ ] **Quality Attribute Scenario (QAS)**: a precise, six-part description of a stimulus and required response
  - [ ] Source of stimulus (who/what triggers it)
  - [ ] Stimulus (the event)
  - [ ] Environment (state of the system when it happens)
  - [ ] Artifact (the part of the system stimulated)
  - [ ] Response (what should happen)
  - [ ] Response measure (the testable threshold — "P99 < 200ms", "MTTR < 5 min")
- [ ] **Architectural Approach / Tactic**: the design strategy chosen to address a QA (e.g. caching → performance, redundancy → availability)
- [ ] **Risk**: an architecturally significant decision that may lead to undesirable consequences ("DB-per-service with no schema registry → data drift")
- [ ] **Non-Risk**: a decision that's been made and is justified — explicitly recorded so it's not relitigated
- [ ] **Sensitivity Point**: a decision where one attribute is highly sensitive to a parameter ("response time depends critically on cache hit ratio")
- [ ] **Tradeoff Point**: a sensitivity point where the parameter affects MULTIPLE attributes in opposing directions ("larger cache improves latency but increases stale-data risk")
- [ ] These four — Risk, Non-Risk, Sensitivity, Tradeoff — are the actual outputs of ATAM

## Module 3: The Nine Steps
- [ ] **Phase 1 — Presentation** (with stakeholders):
  - [ ] **Step 1**: Present the ATAM method (set expectations)
  - [ ] **Step 2**: Present business drivers (PM/sponsor — what the system must do for the business)
  - [ ] **Step 3**: Present the architecture (architect — current/proposed design)
- [ ] **Phase 2 — Investigation & Analysis**:
  - [ ] **Step 4**: Identify architectural approaches/tactics (catalogue what patterns the architect used)
  - [ ] **Step 5**: Generate Quality Attribute Utility Tree (QA → refinement → scenarios; prioritise by importance & difficulty, e.g. H/M/L for both)
  - [ ] **Step 6**: Analyse architectural approaches against high-priority scenarios — for each: tactic used, risks, non-risks, sensitivity points, tradeoff points
- [ ] **Phase 3 — Testing**:
  - [ ] **Step 7**: Brainstorm and prioritise scenarios (broader stakeholder set — not just the architect)
  - [ ] **Step 8**: Analyse the new scenarios (re-run Step 6 on them)
  - [ ] **Step 9**: Present results — risk themes, sensitivity/tradeoff points, recommendations
- [ ] Typical duration: 3 days on-site for the evaluation team; weeks of prep
- [ ] Typical participants: 4-5 person evaluation team + project decision-makers + 12-15 stakeholders

## Module 4: Utility Trees & Scenario Prioritisation
- [ ] **Utility Tree** = the central artefact; rooted at "Utility", branches into quality attributes, refines down to concrete scenarios
- [ ] Example branch:
  ```
  Utility
   └── Performance
        ├── Latency
        │    └── (H, M) "User search returns < 200ms at P99 under 10K concurrent users"
        └── Throughput
             └── (H, H) "System sustains 5K writes/sec for 1 hour during sale"
   └── Availability
        └── (H, L) "System recovers from single-AZ failure in < 60s with no data loss"
  ```
- [ ] **Two-axis prioritisation**: (Importance to business, Difficulty/risk to architecture) — both H/M/L
  - [ ] (H, H) scenarios get the most analytical attention — high stakes + high uncertainty
  - [ ] (H, L) becomes a "non-risk" if architecture clearly handles it
  - [ ] (L, *) gets minimal attention
- [ ] **Specifying scenarios well** is the hard part — the six-part template forces precision
- [ ] **Bad scenario**: "system should be fast"
- [ ] **Good scenario**: "Source: registered user; Stimulus: clicks search button; Environment: peak load (10K concurrent); Artifact: search service; Response: results displayed; Measure: P99 < 200ms"

## Module 5: Outputs, Risk Themes & Practical Use
- [ ] **Per-scenario analysis output** (filled in for each high-priority scenario):
  - [ ] Architectural approaches/tactics in play
  - [ ] Risks (numbered: R1, R2, ...)
  - [ ] Non-risks (numbered: NR1, NR2, ...)
  - [ ] Sensitivity points (S1, S2, ...)
  - [ ] Tradeoff points (T1, T2, ...)
- [ ] **Risk Themes**: clusters of related risks across scenarios — the highest-leverage findings
  - [ ] Example: "Multiple risks point to lack of distributed tracing → blocker for diagnosing perf scenarios"
- [ ] **Final report** structure: business drivers → architecture summary → utility tree → scenario analyses → risks/sensitivity/tradeoffs → risk themes → recommendations
- [ ] **What to do with results**:
  - [ ] Risks → backlog items, ADRs, mitigations
  - [ ] Non-risks → documented and put aside (don't relitigate)
  - [ ] Sensitivity points → monitor in production (e.g. cache hit ratio dashboards)
  - [ ] Tradeoffs → explicit decisions with ADRs
- [ ] **Lightweight ATAM** for smaller orgs:
  - [ ] 1-day workshop, 6-8 stakeholders, 5-10 prioritised scenarios
  - [ ] Same outputs (R/NR/S/T), shorter cycle
  - [ ] Often the realistic version vs the textbook 3-day SEI model
- [ ] **Pairs with**:
  - [ ] **C4 Model** — diagrams that ATAM analyses
  - [ ] **ADRs** — captures the decisions before/during/after
  - [ ] **arc42** — section 10 (Quality Requirements) feeds the utility tree directly
  - [ ] **Fitness functions** — scenarios become automated tests post-ATAM

## Module 6: Anti-Patterns & Practical Reality
- [ ] **Treating ATAM as a pass/fail gate** — it surfaces consequences, the team still decides
- [ ] **Architects evaluating their own architecture** — bias eliminates value; bring outside reviewers
- [ ] **No business stakeholders** — utility tree becomes "what the architect cares about", not "what the system must do"
- [ ] **Skipping scenario specification** — vague NFRs ("must be scalable") are unanalysable
- [ ] **Running ATAM too late** — after build is mostly done; insights have minimal influence
- [ ] **Running ATAM too early** — no architecture to analyse; becomes a wishlist exercise (mitigation: run it iteratively at major milestones)
- [ ] **One-shot review with no follow-through** — risks captured, never tracked → method discredited
- [ ] **Ceremony for its own sake** — full SEI 9-step ATAM is overkill for a 3-team project; lightweight variants exist for a reason
- [ ] **Confusing risk with bug** — ATAM risks are about architectural decisions and their consequences, not specific defects
- [ ] **Treating tradeoff points as failures** — every architecture has tradeoffs; the value is making them *explicit and decided*

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Pick a system you've built; write 5 quality attribute scenarios using the six-part template; show them to a colleague — would they understand without you there? |
| Module 3 | Run a lightweight 1-day ATAM with your team on a current architecture; produce a real R/NR/S/T table |
| Module 4 | Build a utility tree for a system you're proposing; prioritise scenarios; identify which (H, H) scenarios scare you most |
| Module 5 | For one (H, H) scenario, write the per-scenario analysis: architectural tactics used, R/NR/S/T — share with the architect |
| Module 5 | Convert your top 3 sensitivity points into production dashboards; convert top 3 risks into backlog items with ADRs |
| Module 6 | Compare: a vague "the system should be scalable" NFR vs a properly specified scenario — which one can you actually evaluate? |

## Cross-References
- `03-EnterpriseArchitecture/03-ProblemSolving/03-ArchitectureReviews/` — ATAM is one specific review method
- `03-EnterpriseArchitecture/03-ProblemSolving/02-DecisionFrameworks/` — ATAM informs decision-making
- `03-EnterpriseArchitecture/02-SolutionArchitecture/01-TradeOffAnalysis/` — direct conceptual overlap
- `03-EnterpriseArchitecture/02-SolutionArchitecture/02-NFRs/` — quality attributes ARE NFRs, properly specified
- `03-EnterpriseArchitecture/02-SolutionArchitecture/03-ArchitectureDocumentation/` — ADRs capture ATAM outcomes
- `03-EnterpriseArchitecture/02-SolutionArchitecture/05-C4Model/` — diagrams that feed ATAM input
- `02-SystemDesign/04-ArchitecturePatterns/` — characteristics ratings (Mark Richards) is a lightweight cousin of ATAM

## Key Resources
- **Evaluating Software Architectures: Methods and Case Studies** - Clements, Kazman, Klein (the canonical ATAM book)
- **Software Architecture in Practice** (3rd/4th ed.) - Bass, Clements, Kazman
- **SEI Technical Report CMU/SEI-2000-TR-004** — "ATAM: Method for Architecture Evaluation" (free PDF, the original)
- **Documenting Software Architectures: Views and Beyond** - Clements et al.
- **arc42** - arc42.org (Section 10: Quality Requirements feeds ATAM)
- **"Lightweight Architecture Decision Records"** - Michael Nygard (companion artefact)
- **"Building Evolutionary Architectures"** - Neal Ford et al. (fitness functions = automated successor to ATAM scenarios)
