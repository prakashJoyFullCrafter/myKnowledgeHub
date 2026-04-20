# TOGAF 10 — Architecture Capability Framework

## What is the Architecture Capability Framework?

The Architecture Capability Framework provides **guidance on how to establish and operate an enterprise architecture practice** within an organization. While the ADM (Architecture Development Method) defines *what* architects do — the process of creating architectures — the Architecture Capability Framework answers the question: **"How do we build and sustain an effective EA function?"**

It covers:
- Organizational structure for the EA function
- Governance bodies and their operation
- Roles, responsibilities, and reporting lines
- Skills requirements and proficiency levels
- Processes for managing architecture work
- Tools and repositories

**Key distinction:**
| ADM | Architecture Capability Framework |
|-----|----------------------------------|
| Process for creating architectures | Framework for running the EA practice |
| WHAT architects do | HOW the practice is organized |
| Phases A–H + Requirements Management | Maturity, skills, governance, org models |

---

## Establishing an Architecture Practice

### Starting the Architecture Function

Getting EA off the ground requires more than hiring architects. It requires organizational positioning and authority.

**Executive Sponsorship is essential.** The EA function must have a senior executive champion — typically the CIO, CTO, or a designated Chief Architect reporting to the C-suite. Without executive sponsorship, architecture becomes advisory noise.

**Mandate:** The EA function needs a formal, documented mandate defining:
- Scope of authority (which domains, which initiatives)
- Decision rights (advisory vs. approving vs. binding)
- Accountability (what the EA function is responsible for delivering)
- Budget and resourcing

**Positioning:** EA must be positioned at a level where it can **influence strategy and investment decisions** — not just document what's already been decided.

**Common Reporting Structures:**

| Structure | Description | Best For |
|-----------|-------------|----------|
| Under CIO | EA sits within IT leadership | IT-centric organizations |
| Under COO | Enterprise-wide mandate across business and IT | Organizations with strong business-IT integration goals |
| Under Strategy/Transformation Office | EA embedded in major change programs | Organizations undergoing large transformation |
| Independent / Board-level | EA reports directly to CEO or Board | Very mature EA practices with enterprise-wide authority |

---

### Architecture Organization Models

#### Centralized (Center of Excellence Model)
- Single central EA team owns all architecture work
- All architectural decisions flow through the center
- **Pros:** Strong consistency, clear standards, single point of governance
- **Cons:** Becomes a bottleneck; disconnected from business units; does not scale
- **Best for:** Small to medium organizations; early-stage EA practice

#### Federated (Distributed Model)
- Each business unit or domain has its own architecture team
- Central EA provides frameworks, standards, and principles only
- Business units execute their own architecture work
- **Pros:** Business-aligned, highly scalable, faster delivery cycles
- **Cons:** Inconsistency risk across units; fragmented governance; hard to enforce standards
- **Best for:** Large, complex organizations with diverse and autonomous business units

#### Hybrid (Hub and Spoke) — Recommended
- **Hub (Central EA):** Strategy, enterprise standards, governance, and cross-cutting concerns
- **Spokes (Domain/Unit Architects):** Execution within their domain, applying central standards
- **Pros:** Balances consistency with agility; enterprise coherence with domain speed
- **Cons:** Coordination overhead; potential role confusion between hub and spokes
- **Best for:** Most large enterprises — this is the recommended TOGAF model

---

### Architecture Roles and Responsibilities

| Role | Responsibility | Typical Reporting Line |
|------|---------------|------------------------|
| Chief Architect / EA Director | EA strategy, chairs Architecture Board, owns standards | CIO or CTO |
| Enterprise Architect | Cross-domain architecture, strategic initiatives, cross-cutting concerns | Chief Architect |
| Domain Architect (Business / Data / App / Tech) | Domain-specific architecture work; executes Phases B, C, D | EA Director or Domain Head |
| Solution Architect | Project-level architecture design; Phase G implementation governance | Program Manager + EA |
| Security Architect | Security architecture across all domains; threat modeling | CISO + Chief Architect |
| Data Architect | Data architecture, data models, data governance alignment | CDO + Chief Architect |
| Integration Architect | Integration patterns, API governance, middleware standards | Chief Architect |

**Key principle:** Solution architects work at project level and are accountable to both the delivery team and the EA governance function. Enterprise architects work at portfolio/enterprise level with cross-domain accountability.

---

## Architecture Maturity Model (ACMM)

TOGAF defines a **6-level maturity model** (Levels 0–5) for assessing the capability and maturity of an organization's EA practice. Organizations use this to baseline their current state, set targets, and plan capability improvement.

### Level 0 — None
- No identifiable enterprise architecture process exists
- Individual heroics; no repeatability or consistency
- Architecture documentation: essentially none
- Governance: none — investment and IT decisions are entirely ad hoc
- Architecture work is invisible or absent as a formal activity

### Level 1 — Initial (Ad Hoc)
- Architecture processes are unpredictable, poorly controlled, and reactive
- Some documentation exists but is inconsistent and person-dependent
- Architecture work happens informally on some projects
- Governance: informal, varies project-by-project
- Risk: architecture decisions vary by person; no institutional knowledge
- Key symptom: architecture lives in someone's head or on a whiteboard

### Level 2 — Under Development
- EA program has been formally initiated; a framework has been selected (e.g., TOGAF)
- Architecture processes are defined on paper but inconsistently applied in practice
- Governance is emerging — an Architecture Board may exist on paper but rarely meets or has no real authority
- Repository: basic, perhaps just a SharePoint folder or wiki
- Skills: one or two EA champions driving the work; no formal career path
- Key symptom: lots of planning, inconsistent execution

### Level 3 — Defined
- EA process is documented, standardized, and consistently applied across the organization
- Architecture Board is active, meets regularly, and has real decision-making authority
- Architecture Repository is in active use with meaningful, current content
- ADM is followed for major initiatives
- Standards Information Base (SIB) exists and is maintained
- Skills: formal architecture roles exist; some training program in place
- Key symptom: architects follow the process; stakeholders know how to engage EA

### Level 4 — Managed
- EA processes are measured, monitored, and controlled
- Architecture value is quantified: compliance rates, portfolio coverage, cost avoidance tracked
- Architecture decisions are data-driven, not opinion-based
- Governance: compliance rates are tracked; dispensations are formally monitored and reviewed
- Repository: comprehensive, searchable, actively maintained with regular quality reviews
- Skills: certified architects, defined career path, formal skills development
- Key symptom: EA can report its value in numbers to the executive team

### Level 5 — Optimizing
- Continuous improvement of EA processes — the capability itself evolves proactively
- Innovation: EA actively drives business model innovation, not just IT rationalization
- Architecture is embedded in business strategy processes — not a downstream consumer of strategy
- EA Community of Practice is active and influential
- Skills: recognized thought leaders; architects mentor across the industry
- Key symptom: EA shapes the organization's future, not just its current state

---

### ACMM Assessment Dimensions

For each level, the assessment is conducted across eight dimensions:

| # | Dimension | What Is Assessed |
|---|-----------|-----------------|
| 1 | Architecture Process | ADM usage, process consistency, repeatability |
| 2 | Architecture Development | Quality of architecture outputs and deliverables |
| 3 | Business Linkage | Alignment of architecture with business strategy |
| 4 | Senior Management Involvement | Executive engagement and sponsorship quality |
| 5 | Operating Unit Participation | Degree to which business units engage with EA |
| 6 | Architecture Communication | How architecture is shared, explained, and consumed |
| 7 | IT Security | Maturity of security architecture practice |
| 8 | Architecture Governance | Board effectiveness, compliance, dispensation management |

---

## Architecture Skills Framework

TOGAF defines **seven categories of architecture skills** that architects need to develop. Each skill is assessed at one of three proficiency levels.

### Proficiency Levels
- **Level 1 — Awareness:** Knows what it is; understands concepts
- **Level 2 — Practitioner:** Can apply with guidance; working knowledge
- **Level 3 — Specialist:** Can apply independently; can teach and mentor others

---

### 1. Generic Skills
Foundational skills required of all architects regardless of specialization:
- Business skills: negotiation, facilitation, leadership, team building
- IT skills: broad knowledge across IT domains (not deep specialist knowledge)
- Legal environment awareness: basic understanding of contract law, privacy, IP
- Soft skills: communication, stakeholder presentation, structured writing

### 2. Business Skills and Methods
Skills for understanding and engaging with the business:
- Business case development and financial justification
- Business process modeling (BPMN, value chains)
- Organization design and operating model analysis
- Strategic planning techniques (SWOT, capability mapping, scenario planning)

### 3. Enterprise Architecture Skills
Core professional skills of the architect:
- Architecture framework knowledge (TOGAF, Zachman, FEAF, etc.)
- Architecture modeling languages (ArchiMate, UML, BPMN)
- ADM proficiency — applying the right phases and outputs
- Architecture governance — review boards, compliance, dispensations

### 4. Program / Project Management Skills
Skills for navigating delivery environments:
- Portfolio management and prioritization
- Program governance and milestone management
- Benefit realization management and tracking

### 5. IT General Knowledge Skills
Broad IT domain awareness:
- Infrastructure and operations (networks, compute, storage)
- Application development lifecycle and patterns
- Data management, analytics, and information management
- Security principles and risk management

### 6. Technical IT Skills
Specific technical depth in relevant areas:
- Platform knowledge: cloud (AWS, Azure, GCP), on-premises, hybrid architectures
- Integration technologies: APIs, messaging, event streaming, ESB/API gateway patterns
- DevOps and CI/CD: pipelines, infrastructure-as-code, release management
- Security technologies: IAM, encryption, zero trust, SIEM

### 7. Legal Environment
Understanding of legal and compliance context:
- Contracts and procurement: understanding what architects sign up to
- Regulatory compliance: GDPR, industry-specific regulations (PCI-DSS, HIPAA, etc.)
- Intellectual property: licensing, open source, vendor lock-in considerations

---

## Architecture Governance (from Capability Perspective)

Architecture governance at the capability level is about **how the governance function is structured and chartered** — not just how it operates on individual projects.

### Architecture Board Charter Template

| Element | Content |
|---------|---------|
| **Name** | [Organization] Architecture Review Board (ARB) |
| **Purpose** | Ensure architecture quality, consistency, and strategic alignment across the portfolio |
| **Scope** | All major IT investments and transformations above a defined threshold (e.g., $500K or significant architectural impact) |
| **Membership** | Chief Architect (chair), domain architect representatives, CISO, CDO, Head of Infrastructure, business unit representatives |
| **Quorum** | Minimum 5 members including the Chair |
| **Meeting Cadence** | Bi-weekly for project reviews; monthly for strategic sessions |
| **Decision Rights** | Approve/reject architecture proposals; grant dispensations; set and retire standards |
| **Escalation Path** | Board decisions can be escalated to CxO steering committee |

**Key governance principle:** The Architecture Board is a **governance body**, not a delivery body. It does not do the architecture work — it reviews, approves, and oversees it.

---

### Architecture Contracts

Architecture contracts formalize the agreement between the architecture function and the delivery team.

**Purpose:** Ensure delivery teams build what was architecturally agreed and remain accountable to architecture governance throughout implementation.

**Contents of an Architecture Contract:**
- Parties involved (architecture team + delivery team/supplier)
- Architecture deliverables expected from the delivery team
- Quality criteria and conformance requirements
- Architecture governance checkpoints during delivery (Phase G)
- Change control process: how deviations must be submitted and approved
- Dispensation process if standards cannot be met

**Lifecycle:**
1. **Created in Phase G** (Implementation Governance) when delivery begins
2. **Monitored** throughout implementation — compliance reviews at checkpoints
3. **Closed** when the project delivers and architecture compliance is confirmed

---

## Measuring EA Value

A mature EA practice must demonstrate its value in terms the business understands: cost, speed, risk, and strategic enablement.

### EA KPIs and Metrics

| Category | Metric | Target |
|----------|--------|--------|
| Coverage | % of major initiatives with architecture engagement | >90% |
| Compliance | Architecture compliance rate (compliant / fully conformant) | >85% |
| Speed | Time from architecture request to approved architecture | <3 weeks |
| Reuse | % of new solutions leveraging existing Architecture Building Blocks | >40% |
| Governance | % of active dispensations reviewed on schedule | 100% |
| Standards | % of deployed technology on the approved Technology Standards list | >80% |
| Value | Architecture-driven cost avoidance ($) reported quarterly | Track and trend |
| Stakeholder | EA satisfaction score (stakeholder survey, annual) | >7/10 |

### Communicating EA Value

Architecture value must be translated into language that resonates with different audiences:

| Audience | EA Value Message |
|----------|-----------------|
| CFO | Cost avoidance from prevented duplication; decommission savings from rationalization |
| CIO | Reduced integration failures; faster delivery through reuse; reduced technical debt |
| CISO | Fewer security incidents; security-by-design embedded in all initiatives |
| Business Leaders | Strategy goals are traceable to funded architecture decisions; faster time-to-market |
| Board | Risk reduction; investment portfolio is coherent and aligned to strategy |

**Value communication best practice:** Use a quarterly Architecture Value Report that covers coverage metrics, compliance rates, cost avoidance, and strategic decisions enabled by architecture.

---

## Funding and Resourcing EA

### Funding Models

**1. Central Funding**
- EA is funded directly by the CIO/CTO budget as a central function
- No chargebacks to business units
- Pros: architects are free to prioritize based on enterprise need, not who is paying
- Cons: perceived as IT overhead; hard to justify in cost-cutting environments

**2. Chargeback / Shared Services Model**
- EA services are charged back to consuming business units or programs
- Pros: makes EA value visible; business units become customers
- Cons: architects may be pressured to serve paying customers over enterprise priorities

### Staffing Guidelines

Rough industry benchmarks (TOGAF guidance and industry surveys):
- **1 enterprise architect per 50–100 IT professionals**
- Domain architects scale with portfolio complexity in their domain
- Solution architects: typically embedded in major programs (1 per major program)

### Tooling Investment

EA tooling should match the maturity and complexity of the portfolio:
- **Levels 1–2:** Basic wiki, SharePoint, Confluence — low cost, low capability
- **Level 3:** Dedicated EA tools (e.g., Archi, Sparx EA, LeanIX, MEGA Hopex)
- **Levels 4–5:** Integrated EA platform with repository, reporting, and portfolio linkage

---

## Key Exam Points

- The **Architecture Capability Framework** answers **HOW to run EA** — not WHAT to do (that is the ADM)
- The **ACMM has 6 levels (0–5):** None → Initial → Under Development → Defined → Managed → Optimizing
- The **Skills Framework has 7 categories** — know them by name
- **Architecture Board** = governance body; **Architecture Team** = operational delivery body
- The **Chief Architect chairs** the Architecture Board
- A **Dispensation** is a formal exception to an architecture standard; it must have an expiry date and a documented business justification
- Architecture contracts are created in **Phase G** and govern the delivery team's compliance obligations
- The **Hub and Spoke model** (Hybrid) is the recommended organization model for large enterprises
- Maturity assessment covers **8 dimensions** including business linkage, governance, and communications
- EA is most effective when positioned to **influence strategy** — not just document it
