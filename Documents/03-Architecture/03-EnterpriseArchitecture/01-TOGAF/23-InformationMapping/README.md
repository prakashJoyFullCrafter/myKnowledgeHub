# Information Mapping (TOGAF Series Guide) - Curriculum

> **TOGAF Series Guide on Information Mapping** — modern data architecture techniques: Information Map, business data semantics, MDM (Master Data Management), data ownership, and customer/product/employee golden records. Sits between the broad Data Architecture domain (BDAT) and concrete data-engineering implementation.

## Module 1: Why Information Mapping
- [ ] Most enterprises have **dozens of definitions** of basic concepts: "customer", "order", "revenue", "active account" — each system slightly different
- [ ] Symptoms of missing information mapping: reports that disagree, MDM projects that stall, regulatory reports that take weeks to compile, data lakes that nobody trusts
- [ ] **The TOGAF insight**: information IS architecture — equal in importance to applications and technology, often more strategic
- [ ] **Information vs Data**: Information = business meaning + context (Customer, Order); Data = the technical representation (rows in `customers`, JSON `{id, name}`)
- [ ] **Information Map**: structured representation of business information concepts, their relationships, ownership, and lifecycle — the "noun model" of the enterprise
- [ ] **Pairs with**: Business Architecture (capabilities consume information), Data Architecture (storage and movement)
- [ ] **Goal**: a shared, unambiguous business language for information — basis for governance, integration, MDM

## Module 2: The Information Map
- [ ] **Definition**: a structured catalogue of the information concepts the enterprise needs to operate
- [ ] **Three layers** typically:
  - [ ] **Conceptual** — business entities, their meanings, relationships (Customer, Order, Product)
  - [ ] **Logical** — attributes, identifiers, business rules (Customer has TaxId, Order has LineItems)
  - [ ] **Physical** — storage realisation (specific tables, columns, types, indexes)
- [ ] **Information Map elements**:
  - [ ] Information concept (the noun)
  - [ ] Definition (1-2 sentences in business language)
  - [ ] Authoritative source (which system owns it; the system of record)
  - [ ] Information owner (the business role accountable)
  - [ ] Information steward (the operational maintainer)
  - [ ] Lifecycle (created → updated → archived → deleted; events)
  - [ ] Sensitivity / classification (PII, financial, public, restricted)
  - [ ] Quality criteria (completeness, accuracy, timeliness)
  - [ ] Related concepts (relationships, dependencies)
- [ ] **Modelling notation**: ArchiMate (Information layer), ER diagrams, Anchor Modelling, or simple structured tables

## Module 3: Master Data Management (MDM)
- [ ] **Master data**: the high-value, slow-changing entities used across many processes — Customer, Product, Employee, Vendor, Location, Account
- [ ] **The MDM problem**: same Customer exists in 10 systems with 10 different IDs and 10 slightly different attribute values → reconciliation hell
- [ ] **Golden Record / Single Source of Truth**: one canonical representation per master entity, established via match-merge
- [ ] **MDM architecture styles**:
  - [ ] **Registry** — MDM hub stores keys + match rules; source systems retain data; queries federate
    - [ ] Pros: minimal disruption; Cons: queries are expensive, slow rollout
  - [ ] **Consolidation** — periodic ETL into MDM hub for read-only golden record (BI use)
    - [ ] Pros: simple; Cons: stale, no two-way sync
  - [ ] **Coexistence** — golden record in MDM hub, propagated back to source systems
    - [ ] Pros: golden record everywhere; Cons: complex sync, conflict resolution
  - [ ] **Centralised / Transactional** — all master data lives in MDM hub; source systems consume via API
    - [ ] Pros: cleanest; Cons: huge migration, vendor lock-in risk
- [ ] **Match-Merge logic**: rules to detect that "Acme Corp" and "Acme Corporation Ltd" with overlapping addresses are the same Customer
  - [ ] Deterministic (exact match on TaxId), probabilistic (fuzzy on name+address+phone), ML-based (modern)
- [ ] **Survivorship rules**: when merging, which source's data wins per attribute? (last-updated, source-priority, business rule)
- [ ] **MDM tools**: Informatica MDM, Reltio, Profisee, Stibo Systems, IBM InfoSphere, Atlan (modern); cloud-native (AWS Lake Formation + governance, Snowflake's data clean rooms)

## Module 4: Information Ownership & Governance
- [ ] **The accountability gap**: data quality problems often stem from no one being accountable
- [ ] **Roles**:
  - [ ] **Information Owner** (often a senior business leader): accountable for the information's correctness and fitness for purpose
  - [ ] **Information Steward** (operational role): day-to-day maintenance, quality monitoring, issue resolution
  - [ ] **Information Custodian** (technical role): storage, security, backup, access control of the data
  - [ ] **Information Consumer**: anyone using the data; responsible for using it within its defined purpose
- [ ] **Data domains**: cluster information by domain (Customer, Finance, Product, HR) — each gets a domain owner
- [ ] **Data Governance Council**: cross-domain forum that resolves cross-domain issues
- [ ] **Policies that matter**:
  - [ ] **Definitions** policy (one definition per concept, owned and approved)
  - [ ] **Quality** policy (acceptable thresholds; SLAs)
  - [ ] **Access** policy (who can see what, for what purpose)
  - [ ] **Retention** policy (how long, on what basis)
  - [ ] **Privacy/Compliance** policy (GDPR, CCPA, HIPAA — region-specific)
- [ ] **Data Mesh** (Zhamak Dehghani) — modern federated take: domain teams own their data products; central platform provides governance — see also `02-SystemDesign/03-SystemDesign/20-DataInternals/`

## Module 5: Customer Master Data Management (Series Guide Focus)
- [ ] **Why Customer MDM is its own deep problem**:
  - [ ] Customer data lives in CRM, billing, support, marketing, e-commerce, partner systems, third parties
  - [ ] Privacy regulations (GDPR, CCPA) have strict requirements: right to access, right to erasure, consent management
  - [ ] Customer 360 view is a strategic differentiator (personalisation, retention)
  - [ ] Identity resolution is hard: nicknames, household relationships, B2B hierarchies, name changes
- [ ] **Customer 360 architecture**:
  - [ ] Customer Information Map (the canonical model)
  - [ ] Identity service (resolves to canonical CustomerID)
  - [ ] Customer profile store (golden record + attributes)
  - [ ] Consent & preferences store (regulatory compliance)
  - [ ] Activity history (interaction events; often event-sourced)
  - [ ] Real-time API + analytical lake for use cases
- [ ] **Privacy by design**:
  - [ ] Pseudonymisation (replace identifiers with tokens for analytics)
  - [ ] Purpose limitation (each access tied to a documented purpose)
  - [ ] Data minimisation (only collect what's needed)
  - [ ] Right to erasure: design for deletion across all systems
- [ ] **Common pitfalls**:
  - [ ] Building Customer 360 without consent infrastructure → regulatory risk
  - [ ] Treating MDM as a one-time project, not an ongoing capability
  - [ ] Excluding Marketing/Sales from the Customer Information governance → fragmentation persists

## Module 6: Modern Information Architecture Patterns
- [ ] **Data Mesh** (federated domain ownership):
  - [ ] Domain teams own data products as first-class deliverables
  - [ ] Central platform provides governance, discoverability, observability
  - [ ] Each data product has clear contracts, quality SLAs, owner
  - [ ] Counter to centralised data warehouse / data lake patterns
- [ ] **Data Fabric** (Gartner term):
  - [ ] Active metadata + AI-driven integration across distributed data
  - [ ] Vendor-pushed concept; technical underpinnings vary
- [ ] **Data Lakehouse** (Databricks term):
  - [ ] Combines lake (raw data, low cost) with warehouse (transactional, governed) properties
  - [ ] Apache Iceberg, Delta Lake, Apache Hudi as table formats
- [ ] **Semantic layer / Headless BI** (Looker LookML, dbt Semantic Layer, Cube):
  - [ ] Single definition of metrics, used by all consumer tools
  - [ ] Implements Information Map at the analytics layer
- [ ] **Data Catalog tools** (Alation, Atlan, Collibra, Apache Atlas, DataHub):
  - [ ] Searchable inventory of information assets
  - [ ] Lineage, quality, ownership, business glossary
  - [ ] Where the Information Map lives operationally
- [ ] **Knowledge Graphs**: information modelled as a graph of entities and relationships; growing in EA practice

## Module 7: Anti-Patterns
- [ ] **Information Map as a Visio diagram**: built once, never updated, ignored
- [ ] **MDM project that stalls at consolidation**: builds the hub but never propagates back; benefits never reach source systems
- [ ] **Defining concepts in IT only, no business sign-off**: definitions don't reflect business reality, ignored by users
- [ ] **One-size-fits-all data quality**: same SLA for marketing leads (loose) and regulatory reports (strict) → either overspend or fail audits
- [ ] **No information ownership** → data quality decays unowned
- [ ] **MDM tool first, governance second** → expensive tool, no organisational capability to use it
- [ ] **Ignoring upstream**: cleaning data downstream forever instead of fixing entry-point quality
- [ ] **Customer 360 without consent**: regulatory landmine
- [ ] **Treating Data Mesh / Lakehouse / Fabric as a silver bullet** without addressing core governance and ownership
- [ ] **Information Map disconnected from Capability Map**: each capability needs information; misalignment creates gaps and overlaps

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Pick one entity (Customer, Product) — count definitions across your enterprise; document the canonical definition; identify the system of record |
| Module 3 | Sketch the MDM architecture style for your top-3 master data entities; defend the choice (Registry vs Coexistence vs Centralised) |
| Module 4 | For one data domain, identify Owner / Steward / Custodian roles; check who actually has them today |
| Module 5 | Design a Customer Information Map: canonical attributes, sources, consent fields, lifecycle events |
| Module 6 | Compare your current data architecture to Data Mesh principles — which apply, which don't, why? |
| Module 7 | Audit your last failed MDM / data quality initiative against the anti-patterns list |

## Cross-References
- `01-TOGAF/02-ArchitectureDomains/` — Data Architecture (the parent domain)
- `01-TOGAF/15-BusinessArchitectureGuide/` — capabilities consume information
- `01-TOGAF/14-SecurityArchitecture/` — data classification, access, privacy
- `02-SolutionArchitecture/02-NFRs/` — data quality NFRs
- `02-SystemDesign/03-SystemDesign/08-SQLvsNoSQL/` — physical storage choices
- `02-SystemDesign/03-SystemDesign/20-DataInternals/` — internals + Data Mesh
- `02-SystemDesign/03-SystemDesign/22-Search&RankingSystems/` — search uses Information Map semantics
- `01-MicroservicePatterns/01-CorePatterns/06-DatabasePerService/` — distributed data ownership

## Key Resources
- **The Open Group: TOGAF Series Guide — Information Architecture: Customer Master Data Management**
- **The Open Group: TOGAF Series Guide — Information Mapping**
- **DAMA-DMBOK** (Data Management Body of Knowledge) — the canonical data management reference
- **Master Data Management** - David Loshin
- **Data Mesh** - Zhamak Dehghani (the canonical book)
- **Designing Data-Intensive Applications** - Martin Kleppmann
- **Data Management at Scale** - Piethein Strengholt
- **The Data Warehouse Toolkit** - Ralph Kimball (still relevant for dimensional modelling)
- **GDPR / CCPA / HIPAA** primary references for privacy compliance
