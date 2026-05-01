# Gap Analysis — TOGAF Technique

> **Gap Analysis is the systematic comparison of Baseline (current) and Target (desired) architectures to surface what must change.**
> It's the engine that drives Phases B, C, D toward Phase E (Opportunities & Solutions). No gap analysis = no defensible roadmap.

---

## 1. Why Gap Analysis is Central to the ADM

The ADM is fundamentally a *transformation* method. Every transformation requires understanding **what changes** — and gap analysis is how TOGAF formalizes that.

### Where it appears in the ADM
- [ ] **Phase B** (Business Architecture) — gap between baseline and target business architecture
- [ ] **Phase C** (Information Systems Architecture) — gaps in data and application architectures
- [ ] **Phase D** (Technology Architecture) — gaps in technology architecture
- [ ] **Phase E** (Opportunities & Solutions) — gaps grouped into work packages
- [ ] **Phase F** (Migration Planning) — gaps prioritized into transition architectures

### What gap analysis produces
- [ ] **Gap Matrix** — formal artifact listing every gap
- [ ] **Work Package definitions** — gaps clustered into deliverable units
- [ ] **Roadmap input** — gaps sequenced over time
- [ ] **Risk register entries** — gaps that introduce risk
- [ ] **Cost/effort estimates** — to close each gap

---

## 2. Types of Gaps (TOGAF Classification)

TOGAF identifies **three operations** when comparing baseline → target:

| Operation | Meaning | Example |
|-----------|---------|---------|
| **Eliminate** | Baseline has it; Target does not | Decommission legacy CRM |
| **Retain** | Baseline has it; Target keeps it | Keep PostgreSQL platform |
| **New** | Target has it; Baseline does not | Introduce event streaming |

The combination of operations across all elements gives the complete change set.

### Domain dimensions
For each ADM phase, gap analysis covers different dimensions:

| Phase | Dimensions Compared |
|-------|---------------------|
| B — Business | Capabilities, processes, value streams, organization |
| C — Data | Entities, data flows, master data, data quality |
| C — Application | Applications, interfaces, services, components |
| D — Technology | Platforms, infrastructure, networks, security controls |

---

## 3. The Gap Matrix — Standard Format

### Two-axis matrix
- **Rows**: Baseline elements
- **Columns**: Target elements
- **Cells**: Match status

```
                          | TARGET ELEMENTS
                          | T1   T2   T3   T4   ELIMINATED
       ─────────────────  ┼─────────────────────────────────
       BASELINE           |
       B1  CRM-Legacy     |                          ✓
       B2  HR-System      |  ✓
       B3  ERP            |       ✓
       B4  Reporting-Old  |                          ✓
       NEW                |            ✓    ✓
```

| Cell | Meaning |
|------|---------|
| `✓` in matched cell | Element retained (B → T mapping) |
| `✓` in NEW row | New element to be introduced |
| `✓` in ELIMINATED column | Element to be removed |
| Empty | No mapping (often a gap to investigate) |

### Spreadsheet template

| ID | Baseline Element | Target Element | Operation | Gap Description | Effort | Risk | Owner | Phase |
|----|------------------|----------------|-----------|-----------------|--------|------|-------|-------|
| G1 | CRM-Legacy | — | Eliminate | Replace by Salesforce | 6mo | High | CRM PM | B |
| G2 | — | Event Bus | New | Kafka cluster needed | 3mo | Med | Platform | D |
| G3 | Reporting-Old | Reporting-New | Replace | Redesign on dbt + Looker | 4mo | Med | Data | C |
| G4 | HR-System | HR-System | Retain | None | — | — | — | — |

---

## 4. The 7-Step Gap Analysis Process

### Step 1 — Confirm baseline
- [ ] Inventory all elements in scope (business / data / application / technology)
- [ ] Validate accuracy with operational owners
- [ ] **Critical**: don't trust outdated documentation — verify

### Step 2 — Confirm target
- [ ] Document the target architecture for the same scope
- [ ] Sign-off by architecture board / business sponsor

### Step 3 — Map elements
- [ ] For each target element, identify its baseline counterpart (if any)
- [ ] For each baseline element, identify its target fate (retain / replace / eliminate)
- [ ] Use a matrix or list — be systematic

### Step 4 — Identify gaps
- [ ] **Missing-in-target**: baseline functionality dropped — is that intentional?
- [ ] **Missing-in-baseline**: net-new in target — confirm it's required
- [ ] **Modified**: same element exists, but with significant change

### Step 5 — Categorize and prioritize
- [ ] By risk (technical, business, regulatory)
- [ ] By dependency (which gaps must close before others)
- [ ] By business value (which gaps unlock most value)
- [ ] By effort

### Step 6 — Cluster into work packages
- [ ] Group related gaps that share teams, dependencies, or release boundaries
- [ ] Each work package = a discrete piece of executable work
- [ ] Feeds Phase E (Opportunities & Solutions)

### Step 7 — Validate and document
- [ ] Walk through with target stakeholders
- [ ] Surface any "missed" elements
- [ ] Sign off and place in Architecture Repository

---

## 5. People-Process-Technology (PPT) Gaps

A common mistake: only analyzing **technology** gaps. TOGAF requires looking across PPT:

| Lens | Gap Examples |
|------|-------------|
| **People** | Skills not yet present; org structure misaligned with target ops model |
| **Process** | Current ITIL change process incompatible with continuous delivery target |
| **Technology** | Legacy mainframe doesn't expose APIs; need integration layer |

For each gap, ask: is there a **people** gap, a **process** gap, **and** a technology gap to close it?

### Example
**Gap**: Move from monthly releases to weekly releases
- People: hire/train SREs; reorganize ops team alongside dev
- Process: replace CAB-approval with risk-based auto-approval
- Technology: pipelines, feature flags, observability stack

A pure-tech analysis misses 2/3 of the work.

---

## 6. Worked Example (Abbreviated)

### Initiative: "Modernize Customer Onboarding Platform"

#### Baseline (Phase B/C/D summary)
- Business: 14-step manual onboarding, 7 days average
- Data: customer data fragmented across 5 systems
- Application: legacy onboarding portal (.NET WebForms), no APIs
- Technology: 1 datacenter, on-prem DB, Tomcat-based services

#### Target
- Business: digital-first onboarding, 30 minutes for 80% of cases
- Data: unified customer master in CDP
- Application: SPA portal + microservices, full API exposure
- Technology: AWS multi-region, managed Postgres, Kubernetes

#### Gap Matrix Excerpt
| ID | Domain | Baseline | Target | Operation | Effort | Risk |
|----|--------|----------|--------|-----------|--------|------|
| G1 | Business | 14-step manual flow | Digital flow | Replace | High | Med (change mgmt) |
| G2 | Data | 5 fragmented stores | Unified CDP | Replace + Migrate | High | High (data quality) |
| G3 | Application | .NET WebForms portal | SPA + microservices | Replace | High | Med |
| G4 | Application | — | API gateway | New | Med | Low |
| G5 | Technology | On-prem DC | AWS multi-region | Replace | Very High | High (skills + ops) |
| G6 | People | — | SRE team | New | Med | Med (hiring market) |
| G7 | Process | CAB-based change | DevOps + auto-approve | Replace | Med | Med (resistance) |

#### Work Packages (Phase E)
- WP1: Customer Data Platform (G2)
- WP2: API & Microservices Foundation (G3, G4)
- WP3: Cloud Migration (G5)
- WP4: Operating Model Change (G6, G7)
- WP5: Digital Onboarding UX (G1)

---

## 7. Gap Severity & Prioritization Matrix

```
                  HIGH BUSINESS VALUE
                          │
       Quick              │           Strategic
       Wins               │           Priorities
       (Do first)         │           (Plan + invest)
                          │
   ───────────────────────┼─────────────────────── HIGH
   LOW                    │                        EFFORT
   EFFORT                 │
       Maybe              │           Defer
       Later              │           or Reject
       (Backlog)          │           (Cost > value)
                          │
                  LOW BUSINESS VALUE
```

- **Quick Wins**: close fast, build momentum (governance support, demonstrate progress)
- **Strategic Priorities**: long-running but essential — these dominate the roadmap
- **Maybe Later**: backlog candidates if capacity opens up
- **Defer/Reject**: don't waste time

---

## 8. Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| Inaccurate baseline | Gap analysis built on a fiction | Verify with operations; use CMDB / discovery tools |
| Tech-only lens | Project ships but adoption fails | Force PPT analysis (People, Process, Technology) |
| Gaps without owners | Roadmap vague; nothing moves | Assign owner to every gap before sign-off |
| No effort estimates | Sequencing impossible | Even rough T-shirt sizing is better than nothing |
| Ignoring "retain" elements | Hidden integration constraints | Document retention explicitly |
| Mixing target horizons | Conflates 1-year and 5-year gaps | Use Transition Architectures (intermediate states) |
| One mega gap | "Replace mainframe" — too vague | Decompose into 10-20 atomic gaps |
| Static analysis | Becomes stale during delivery | Re-run gap analysis at each ADM iteration |
| Confused with risk register | Gaps and risks overlap but differ | Separate artifacts; cross-link |

---

## 9. Transition Architectures — Bridging Big Gaps

When the gap from baseline to target is too big for a single jump:

```
Baseline ──→ Transition 1 ──→ Transition 2 ──→ Target
   (Now)        (Year 1)        (Year 2)       (Year 3)
```

- [ ] Each transition is an architecturally meaningful intermediate state
- [ ] Each must be operable, valuable, and stable on its own
- [ ] Avoids "big bang" risk
- [ ] Allows learning and course-correction

Defined in Phase E, planned in Phase F, governed in Phase G.

---

## 10. Tooling Support

### Lightweight
- [ ] Spreadsheets (Excel, Google Sheets) — fine for small efforts
- [ ] Confluence + Jira tickets per gap
- [ ] Markdown files in version control

### EA Tools
- [ ] **LeanIX** — gap analysis + capability heatmaps
- [ ] **BiZZdesign** — TOGAF-aware modeling + gap analysis
- [ ] **Sparx EA** — UML/ArchiMate-based with gap reports
- [ ] **Ardoq** — graph-model EA tool with delta views
- [ ] **MEGA HOPEX** — enterprise-scale EA tool

### Automation
- [ ] CMDB / discovery tools (Device42, ServiceNow CMDB) for baseline
- [ ] APIs from cloud providers for tech inventory
- [ ] CI/CD pipelines that publish architecture facts

---

## 11. Gap Analysis vs Other Techniques

| Technique | Purpose | Output |
|-----------|---------|--------|
| **Gap Analysis** | What must change between baseline and target | Gap Matrix |
| **Capability Assessment** | How mature each capability is | Capability heatmap |
| **Risk Assessment** | What threats / vulnerabilities exist | Risk register |
| **Trade-off Analysis** | Comparing alternative target options | Decision matrix |
| **SWOT** | Strategic positioning | SWOT grid |
| **Business Impact Analysis** | Consequences of disruption | BIA report |

Gap analysis is *complementary* — combine with capability heatmaps, risk assessment, and trade-off analysis for complete decision support.

---

## 12. Certification Angle

### L1 (Foundation)
- [ ] Definition: comparison of baseline vs target to identify what must change
- [ ] Used in Phases B, C, D
- [ ] Three operations: Eliminate, Retain, New
- [ ] Output: Gap Matrix

### L2 (Practitioner)
- [ ] Identifying missing dimensions in a sample gap analysis (people/process gaps overlooked)
- [ ] Sequencing gaps into work packages and transition architectures
- [ ] Recommending tooling/approach for an enterprise's scale
- [ ] Spotting flawed gap analyses (no baseline verification, no owners, etc.)
- [ ] Linking gaps to Phase E work packages

---

## 13. Practice Exercises

1. Run a gap analysis on a real change at your company (process, app, platform). Use the matrix template
2. Take a poorly-done gap analysis and audit it: find missing dimensions, missing owners, unclear scope
3. Decompose a "mega gap" (e.g., "modernize platform") into 10-15 atomic gaps with effort estimates
4. Define 3 transition architectures bridging baseline to target for a multi-year initiative
5. Cluster a gap list into work packages — defend the clustering choices

---

## 14. Resources

- **TOGAF Standard, 10th Edition** — Gap Analysis (in ADM Techniques)
- **TOGAF Series Guide: Migration Planning** — work package definition
- *Enterprise Architecture as Strategy* — Ross, Weill, Robertson
- LeanIX, BiZZdesign documentation on gap analysis automation
- *The Lean Enterprise* — Humble, Molesky, O'Reilly (transition architectures in practice)

🔗 Cross-refs:
- `01-ADMCycle/` — Phases B, C, D consume gap analysis
- `09-CapabilityBasedPlanning/` — capability gaps drive work packages
- `20-MigrationPlanning/` — gap analysis feeds the migration plan
- `12-PracticalArtifacts/` — gap matrix templates
- `26-BusinessScenarios/` — scenarios surface gaps during refinement
- `28-ArchitecturePrinciples/` — gaps may signal principle violations
