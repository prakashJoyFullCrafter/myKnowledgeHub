# Sustainability in Enterprise Architecture - Curriculum

> **TOGAF Series Guide on Sustainability** — green IT, ESG considerations, carbon-aware architecture, sustainable software engineering. The newest TOGAF Series Guide; reflects the elevation of sustainability from "nice to have" to a stakeholder-required architectural concern.

## Module 1: Why Sustainability Belongs in EA
- [ ] Software has a measurable carbon footprint: data centres consume ~1-2% of global electricity (and growing), per IEA estimates
- [ ] Stakeholder pressure: investors (ESG mandates), regulators (CSRD in EU, SEC climate disclosure rules in US), employees, customers
- [ ] **Architecture decisions have multi-year carbon consequences**: choice of cloud region, instance family, data retention policy, scheduling pattern — all set sustained emissions for the system's lifetime
- [ ] **TOGAF's framing**: sustainability is a **non-functional requirement** with the same first-class status as performance, security, or cost
- [ ] **Three levels of impact**:
  - [ ] **Embodied carbon** — emissions from manufacturing the hardware (devices, data centre equipment)
  - [ ] **Operational carbon** — emissions from running the workload (compute, storage, network)
  - [ ] **Indirect / induced** — emissions enabled or avoided by the system (e.g. e-commerce avoids retail trips, but enables overconsumption)
- [ ] **Why architects, not just operators**: the cheapest carbon is the watt you don't compute — operational tweaks help, but architecture decisions dominate

## Module 2: Sustainability NFRs & Architectural Characteristics
- [ ] **Carbon intensity**: gCO2e per request, per transaction, per active user
- [ ] **Energy proportionality**: does the system scale energy use down with load? (most don't — idle ≈ 50% of peak power on many platforms)
- [ ] **Resource utilisation**: average CPU/memory utilisation across the fleet (low utilisation = wasted power)
- [ ] **Data lifecycle efficiency**: storage tier appropriateness, retention discipline, archival cadence
- [ ] **Hardware efficiency**: instance family choice (e.g. ARM-based AWS Graviton uses ~30% less power than x86 for many workloads)
- [ ] **Demand shifting capability**: can workloads run when grid is greenest? (off-peak, in greener regions)
- [ ] **Lifecycle assessment**: full-stack carbon view from provisioning to decommissioning
- [ ] **Targets to set**: per-service carbon budget; intensity reduction year-over-year; absolute emissions cap

## Module 3: Cloud Region & Provider Decisions
- [ ] **Region matters most**: same workload, different regions can vary 10-50× in carbon per kWh
  - [ ] AWS / GCP / Azure publish per-region carbon intensity (sometimes hourly, sometimes annually)
  - [ ] Tools: **Electricity Maps** (electricitymaps.com), **Cloud Carbon Footprint** (cloudcarbonfootprint.org), AWS Customer Carbon Footprint Tool, GCP Carbon Footprint dashboard, Azure Emissions Impact Dashboard
- [ ] **Provider sustainability commitments**:
  - [ ] AWS: 100% renewable by 2025 (ahead of schedule for many regions)
  - [ ] GCP: 24/7 carbon-free energy by 2030 (most ambitious)
  - [ ] Azure: 100% renewable by 2025; carbon-negative by 2030
  - [ ] Differences in PPAs vs RECs vs 24/7 matched energy — read the fine print
- [ ] **Region selection trade-offs**:
  - [ ] Carbon ↔ latency (greener region may be far from users)
  - [ ] Carbon ↔ cost (greener regions sometimes more expensive)
  - [ ] Carbon ↔ data residency (regulatory constraints may pin location)
- [ ] **Multi-region strategies**: serve users from nearest *acceptable* region; concentrate batch in greenest region
- [ ] **Edge computing trade-off**: edge reduces network carbon but may underutilise compute → analyse carefully

## Module 4: Sustainable Software Engineering Patterns
- [ ] **Principles** (from Green Software Foundation):
  - [ ] **Carbon efficiency**: emit less per unit of work
  - [ ] **Energy efficiency**: use less energy per unit of work
  - [ ] **Carbon awareness**: do more when grid is greener; less when dirtier
  - [ ] **Hardware efficiency**: use less hardware for same work
  - [ ] **Measurement & continuous improvement**: you can't improve what you don't measure
- [ ] **Patterns**:
  - [ ] **Right-sizing**: match instance size to actual usage (most workloads are 2-4× over-provisioned)
  - [ ] **Autoscaling that scales DOWN as well as up** (many don't, leading to constant peak-provisioning)
  - [ ] **Spot/preemptible instances** for fault-tolerant workloads — uses excess capacity, lower carbon overhead
  - [ ] **Demand shifting**: schedule batch jobs during low-carbon-intensity windows (e.g. when wind/solar peaks)
  - [ ] **Demand shaping**: degrade non-essential features under high carbon intensity (lower-quality video, fewer recommendations)
  - [ ] **Lazy loading + edge caching**: don't compute or transfer what no user actually needs
  - [ ] **Cold storage tiers**: move infrequently-accessed data to S3 Glacier / GCS Coldline / Azure Archive — both cheaper and lower-carbon
  - [ ] **Container packing**: higher density → lower per-workload overhead
  - [ ] **Serverless**: scale-to-zero between requests; no idle power waste (though cold-start carbon trade-off exists)
- [ ] **Anti-patterns**:
  - [ ] Continuous polling where webhooks would do
  - [ ] Persistent connections idle for hours
  - [ ] Re-encoding the same media on every request (cache instead)
  - [ ] Logging every event at DEBUG to disk forever
  - [ ] Cron jobs that run pointlessly when there's nothing to do

## Module 5: Measurement & Reporting
- [ ] **Metrics to instrument**:
  - [ ] Compute hours by instance type + region
  - [ ] Storage GB-months by tier + region
  - [ ] Network egress GB by direction
  - [ ] Per-service carbon estimate (compute + storage + network × per-region intensity)
- [ ] **Tooling**:
  - [ ] **Cloud Carbon Footprint** (CNCF, open source) — multi-cloud carbon estimation from billing data
  - [ ] **AWS Customer Carbon Footprint Tool** / **GCP Carbon Footprint** / **Azure Emissions Impact Dashboard**
  - [ ] **Cloud Carbon Calculator** — Google's open-source per-region estimator
  - [ ] **Kepler** (Kubernetes Efficient Power Level Exporter) — pod-level energy attribution via eBPF
  - [ ] **Carbon-Aware SDK** (Green Software Foundation) — schedule based on real-time grid intensity
- [ ] **Reporting frameworks**:
  - [ ] **GHG Protocol** — Scope 1/2/3 (cloud workloads usually fall under Scope 3)
  - [ ] **CSRD (Corporate Sustainability Reporting Directive)** — EU regulation; large companies must disclose
  - [ ] **SEC Climate Disclosure Rules** — US public companies (in flux as of 2026)
  - [ ] **Science-Based Targets initiative (SBTi)** — voluntary but increasingly expected
- [ ] **Internal dashboards**: per-team carbon scorecards drive engineer behaviour change (best change agent: visibility)
- [ ] **Carbon budgets in CI/CD**: emerging practice — CI fails if a deployment increases per-request carbon beyond a threshold

## Module 6: Sustainability Across BDAT Domains
- [ ] **Business Architecture**:
  - [ ] Capability decisions: insource vs outsource carbon implications
  - [ ] Process redesign: paper to digital savings; but also rebound effects
  - [ ] Product strategy: sustainability as a product attribute (transparency, repairability, longevity)
- [ ] **Data Architecture**:
  - [ ] Data minimisation = fewer storage/compute carbon costs
  - [ ] Retention policies: don't keep data forever "just in case"
  - [ ] Pre-aggregation: process once, query many — better than re-processing per query
  - [ ] Storage tiering: hot vs warm vs cold vs archive
- [ ] **Application Architecture**:
  - [ ] Synchronous vs async (async often allows demand shifting)
  - [ ] Stateful vs stateless (stateless allows aggressive scale-down)
  - [ ] Polling vs event-driven (event-driven uses less CPU when idle)
  - [ ] Algorithm efficiency: O(n log n) vs O(n²) is also a carbon argument
- [ ] **Technology Architecture**:
  - [ ] Energy-efficient hardware (ARM, custom silicon)
  - [ ] Region selection
  - [ ] Container density / serverless
  - [ ] Network architecture (CDN reduces backbone traffic)

## Module 7: Anti-Patterns & Greenwashing
- [ ] **Carbon offset reliance**: paying for offsets without reducing actual emissions; many offsets are ineffective
- [ ] **REC-only "100% renewable"**: buying renewable energy certificates without time-matching to actual usage — accounting trick, not real green
- [ ] **Optimising for cost, claiming carbon win**: not always aligned (cheapest region may not be greenest)
- [ ] **Single-metric obsession**: only counting Scope 2 (electricity) while ignoring Scope 3 (cloud-provider supply chain, hardware embodied carbon)
- [ ] **One-time measurement**: report carbon once for compliance, never measure again
- [ ] **Jevons paradox**: efficiency improvements increase total demand (cheaper to compute → more total compute → more total emissions). Architecture decisions should consider absolute emissions, not just intensity.
- [ ] **Greenwashing in architecture documents**: claiming sustainability as a principle without operationalising it
- [ ] **Ignoring rebound effects**: digital replacements (e-commerce, video calls) sometimes induce more total consumption
- [ ] **No carbon owner**: like data without a steward, sustainability without an owner decays
- [ ] **Sustainability as veneer**: marketing-led initiative with no operational reality
- [ ] **Treating it as standalone**: sustainability is interconnected with cost, performance, reliability — analyse together

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Add a sustainability NFR to a real architecture document; specify a measurable target (e.g. "gCO2e per transaction reduces 20% YoY") |
| Module 3 | For one workload, compare carbon intensity across 3 cloud regions using public tools; identify the trade-offs |
| Module 4 | Audit one service for energy-proportionality: what's CPU at 0% load vs 100% load? Identify the biggest waste |
| Module 4 | Implement a carbon-aware scheduler for one batch job using Carbon-Aware SDK + a real grid API |
| Module 5 | Set up Cloud Carbon Footprint against your cloud billing data; produce a per-team carbon report |
| Module 6 | Pick one BDAT domain; identify 3 sustainability levers your architecture can pull |
| Module 7 | Audit a sustainability claim in your org or product against the greenwashing patterns — is it real? |

## Cross-References
- `01-TOGAF/02-ArchitectureDomains/` — sustainability lens applied to BDAT
- `01-TOGAF/14-SecurityArchitecture/` — security and sustainability often share infra concerns
- `01-TOGAF/16-DigitalTransformation/` — modernisation creates sustainability opportunities
- `02-SolutionArchitecture/02-NFRs/` — sustainability is now a first-class NFR
- `02-SystemDesign/03-SystemDesign/16-Reliability&Resilience/` — over-provisioning for reliability also wastes carbon
- `02-SystemDesign/03-SystemDesign/25-MultiRegion&GeoDistribution/` — region selection
- `06-DevOps&Delivery/01-DevOps/03-Cloud/05-FinOps/` — closely related discipline (cost + carbon)
- `06-DevOps&Delivery/01-DevOps/05-SRE&Reliability/` — efficient operations are sustainable operations

## Key Resources
- **The Open Group: TOGAF Series Guide — Sustainability**
- **Green Software Foundation** - greensoftware.foundation (principles, patterns, tools)
- **"Building Green Software"** - Anne Currie, Sara Bergman, Sarah Hsu (O'Reilly)
- **Cloud Carbon Footprint** - cloudcarbonfootprint.org (CNCF tool)
- **Electricity Maps** - electricitymaps.com (real-time grid carbon intensity)
- **Carbon-Aware SDK** - carbon-aware-sdk.greensoftware.foundation
- **GHG Protocol** - ghgprotocol.org (the carbon accounting standard)
- **Kepler** (eBPF energy attribution) - sustainable-computing.io
- **AWS Customer Carbon Footprint Tool** / **GCP Carbon Footprint** / **Azure Emissions Impact Dashboard** docs
- **Energy Efficiency across Programming Languages** - Pereira et al. (research paper — surprising results)
- **"How Bad Are Bananas? The Carbon Footprint of Everything"** - Mike Berners-Lee (intuition for carbon scale)
