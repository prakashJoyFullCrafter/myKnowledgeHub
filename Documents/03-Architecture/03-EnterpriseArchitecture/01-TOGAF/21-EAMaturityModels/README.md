# EA Maturity Models (TOGAF Series Guide) - Curriculum

> Frameworks for **assessing and growing the maturity of an EA practice** — where you are, where you should be, and how to close the gap. Promoted from a sub-bullet inside `10-ArchitectureCapabilityFramework` to its own discipline.

## Module 1: Why Measure EA Maturity
- [ ] Without maturity assessment, EA initiatives drift: "we did some EA" vs "we operate at level 4 of capability X"
- [ ] **Maturity models** (origin: CMM/CMMI from SEI, 1991) provide:
  - [ ] **Common vocabulary** for discussing capability across orgs
  - [ ] **Diagnostic tool** — where are we strong/weak?
  - [ ] **Aspirational target** — what does "good" look like?
  - [ ] **Roadmap input** — close the gap between current and desired
  - [ ] **Benchmarking** — compare against peers / industry
- [ ] **Misuses to avoid**:
  - [ ] Maturity = score; gaming the scoring
  - [ ] Aspiring to highest level always (level 5 may not be cost-justified)
  - [ ] Annual assessment ritual with no follow-through
  - [ ] Comparing across orgs ignoring context
- [ ] **The right framing**: maturity is **fitness for purpose** — what level do you NEED for your business outcomes?

## Module 2: ACMM (Architecture Capability Maturity Model)
- [ ] **Origin**: US Department of Commerce; widely used; foundation for TOGAF's maturity guidance
- [ ] **Six maturity levels** (0-5):
  - [ ] **Level 0 — None**: no EA practice exists
  - [ ] **Level 1 — Initial**: ad-hoc; informal; depends on individual heroes
  - [ ] **Level 2 — Under Development**: basic process emerging; selective adoption
  - [ ] **Level 3 — Defined**: documented EA process; consistently applied
  - [ ] **Level 4 — Managed**: measured, reviewed, refined
  - [ ] **Level 5 — Measured**: continuous improvement; metrics-driven; integrated with business strategy
- [ ] **Nine assessment characteristics** scored independently:
  - [ ] Architecture process
  - [ ] Architecture development
  - [ ] Business linkage
  - [ ] Senior management involvement
  - [ ] Operating unit participation
  - [ ] Architecture communication
  - [ ] IT security
  - [ ] Architecture governance
  - [ ] IT investment & acquisition strategy
- [ ] **Scoring**: each characteristic gets 0-5 → typical "spider chart" visualisation showing balance/imbalance
- [ ] **Common pattern**: orgs often score high on documentation/process (3-4) but low on senior management involvement and business linkage (1-2)

## Module 3: Other Major EA Maturity Models
- [ ] **OMG EA Maturity Model**:
  - [ ] Object Management Group framework
  - [ ] Five levels (Initial → Optimising), aligned to CMMI vocabulary
  - [ ] Strong on tooling and automation maturity
- [ ] **NASCIO EA Maturity Model** (US National Association of State CIOs):
  - [ ] Government-focused; aligned to public-sector accountability
  - [ ] Five levels with criteria for governance, communication, IT investment
- [ ] **Gartner EA Maturity Assessment**:
  - [ ] Four levels: Reactive → Proactive → Service-Oriented → Value-Driven
  - [ ] Strong on business value framing (not just process)
- [ ] **Forrester EA Maturity Assessment**:
  - [ ] Five-level framework focused on business outcomes
- [ ] **TOGAF Architecture Capability Framework**:
  - [ ] Doesn't define a strict 5-level scale; provides constituent capabilities (governance, board, contracts, compliance) to assess
  - [ ] Often combined with ACMM or Gartner for the level structure
- [ ] **CMMI for Services / DEV**:
  - [ ] Not EA-specific but widely adopted for related practices (PMO, software dev) — useful for cross-functional alignment
- [ ] **Choosing a model**: pick one and stick with it for trend analysis; mixing models breaks comparability

## Module 4: Conducting a Maturity Assessment
- [ ] **Preparation**:
  - [ ] Select model (ACMM is the safe default for TOGAF orgs)
  - [ ] Identify scope (entire EA practice, or specific domain like Application Architecture)
  - [ ] Identify stakeholders to interview (architects, business leads, IT leadership, delivery teams)
- [ ] **Data collection**:
  - [ ] Structured interviews (1-1.5 hr per stakeholder; 8-15 stakeholders typical)
  - [ ] Document review (architecture artifacts, governance records, policies)
  - [ ] Survey for breadth (Likert-scale per capability)
- [ ] **Scoring**:
  - [ ] Per characteristic, per stakeholder → consolidated score
  - [ ] Triangulate interviews vs documents vs surveys; investigate divergences
  - [ ] Resist temptation to inflate
- [ ] **Output deliverables**:
  - [ ] Spider chart: current vs target vs industry benchmark
  - [ ] Gap narrative per characteristic
  - [ ] Strengths to leverage / weaknesses to address
  - [ ] Recommended improvement roadmap (sequenced)
- [ ] **Cadence**: annual or 18-month cycle; not more frequent (no time to actually improve)

## Module 5: Improvement Roadmap from Assessment
- [ ] **Per-characteristic improvement actions**:
  - [ ] **Architecture Process** (low → high): document ADM tailoring → publish → train → enforce → measure
  - [ ] **Business Linkage** (low → high): start with one strategic initiative → demonstrate value → embed EA in portfolio planning
  - [ ] **Senior Management Involvement** (low → high): quarterly EA dashboard for execs → CIO sponsorship → board-level architecture committee
  - [ ] **Operating Unit Participation** (low → high): embed architects in delivery teams → architecture community of practice → business-architect partnership
  - [ ] **Communication** (low → high): EA portal/wiki → newsletters → roadshows → embedded coaching
  - [ ] **Governance** (low → high): document compliance criteria → ARB → automated fitness functions → continuous compliance
- [ ] **Investment principle**: improvements compound — invest in foundations (process, governance) before sophisticated practices (predictive analytics, ML-driven architecture)
- [ ] **Realistic targets**:
  - [ ] Most non-EA-focused orgs: target Level 3 (Defined) — achievable, valuable, sustainable
  - [ ] EA-mature orgs (financial services, regulated industries): target Level 4
  - [ ] Level 5 is rare; usually only worth it if EA is a strategic differentiator
- [ ] **Multi-year roadmap**: don't plan to jump 2 levels in one year — typically 1 level per 18-24 months

## Module 6: Anti-Patterns
- [ ] **Maturity theatre**: assessment for show; results don't inform any actual change
- [ ] **Score inflation**: stakeholders rate themselves high to look good
- [ ] **One-size-fits-all aspiration**: pushing every characteristic to Level 5 — most aren't worth it for the cost
- [ ] **Maturity envy**: copying another company's maturity score without understanding their context
- [ ] **Process over outcomes**: scoring high on documentation but low on actual business impact
- [ ] **Annual assessment with no follow-through**: results filed, not actioned; demoralises participants
- [ ] **Mixing models**: switching from ACMM to Gartner mid-cycle → no trend data
- [ ] **Treating maturity as a checklist**: "we have an architecture board → Level 4" without checking if the board functions
- [ ] **Wrong stakeholder pool**: only architects assessed → echo chamber; missing business view
- [ ] **No ownership**: assessment done by external consultants; no internal EA leader owns the improvement plan

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Run a self-assessment using ACMM 9 characteristics on your current EA practice — be brutally honest |
| Module 3 | Compare ACMM vs Gartner vs NASCIO for one characteristic (e.g. Business Linkage) — note the framing differences |
| Module 4 | Conduct a 5-stakeholder mini-assessment (60 min each); compare your perception with theirs |
| Module 5 | Pick the lowest-scoring characteristic; design a 12-month improvement plan with measurable milestones |
| Module 6 | Audit your org's last EA assessment (if any): how many recommendations were actually implemented? Why not? |

## Cross-References
- `01-TOGAF/10-ArchitectureCapabilityFramework/` — broader EA capability context
- `01-TOGAF/03-Governance/` — governance maturity is a key dimension
- `01-TOGAF/22-ArchitectureSkillsFramework/` — people maturity feeds practice maturity
- `01-TOGAF/24-LeadersGuide/` — senior leadership engagement is a maturity dimension
- `02-SolutionArchitecture/04-StakeholderManagement/` — communication maturity
- `03-ProblemSolving/04-ATAM/` — review process as a maturity indicator

## Key Resources
- **The Open Group: TOGAF Series Guide — Architecture Maturity Models**
- **US Department of Commerce ACMM** (free, the canonical reference)
- **CMMI for Services** - SEI / CMMI Institute
- **Gartner EA Maturity Assessment** methodology
- **NASCIO EA Maturity Model** (free, government-focused)
- **OMG Enterprise Architecture Maturity** specification
- **"Strategic Enterprise Architecture Management"** - Ahlemann, Stettiner, Messerschmidt, Legner
- **"Enterprise Architecture as Strategy"** - Ross, Weill, Robertson (MIT — operating model maturity)
