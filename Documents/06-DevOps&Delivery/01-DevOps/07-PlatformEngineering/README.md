# Platform Engineering - Curriculum

Building internal developer platforms (IDPs) — the discipline of building self-service infrastructure for developers.

---

## Module 1: Why Platform Engineering?
- [ ] **The problem**: cloud-native complexity is overwhelming for app developers
  - [ ] Kubernetes, Terraform, CI/CD, observability, security, networking
  - [ ] Each team reinventing wheels
- [ ] **Platform engineering**: discipline of designing and building self-service platforms for internal developers
- [ ] **Goal**: reduce cognitive load, improve developer experience, increase velocity
- [ ] **"You build it, you run it"** — but platform makes running it easier
- [ ] **DevOps evolution**: DevOps → SRE → Platform Engineering
- [ ] **Platform as a product**: platform team's customers are internal developers

## Module 2: Internal Developer Platform (IDP)
- [ ] **IDP**: unified self-service interface for developers to provision and operate their apps
- [ ] **Capabilities an IDP provides**:
  - [ ] Environment creation (dev, staging, prod)
  - [ ] App deployment
  - [ ] Observability dashboards
  - [ ] Secret management
  - [ ] Database provisioning
  - [ ] CI/CD pipelines
  - [ ] Infrastructure management
- [ ] **Developers get**: self-service, golden paths, abstraction over complexity
- [ ] **Platform team provides**: thinner abstractions, not wall of opinions

## Module 3: Developer Experience (DevEx)
- [ ] **DevEx**: how easy/pleasant it is for developers to do their job
- [ ] **SPACE framework**:
  - [ ] Satisfaction
  - [ ] Performance
  - [ ] Activity
  - [ ] Communication
  - [ ] Efficiency
- [ ] **Flow state**: minimize interruptions, friction, context switching
- [ ] **Toil reduction**: automate repetitive, manual work
- [ ] **Signals**: deployment frequency, lead time, PR cycle time, time-to-first-deploy
- [ ] **Research**: DORA reports, SPACE paper

## Module 4: Golden Paths
- [ ] **Golden path**: the opinionated, well-supported way to do something
- [ ] **Examples**:
  - [ ] "New service template": scaffold with CI, logging, tracing, Dockerfile
  - [ ] "Add database": automated provisioning of Postgres with backups
  - [ ] "Deploy to production": single pipeline with gates
- [ ] **Why opinionated**: simpler choice, fewer foot-guns, consistent operations
- [ ] **Not mandated**: teams can deviate with justification
- [ ] **Spotify model**: famous for golden paths concept
- [ ] **Templates**: service templates in Backstage, project templates in GitHub

## Module 5: Platform Components
- [ ] **Service catalog**: registry of all services with metadata
- [ ] **Self-service portal**: web UI for developer actions
- [ ] **API**: programmatic access to platform capabilities
- [ ] **Workload abstraction**: developers describe apps, platform handles K8s details
- [ ] **Environment management**: provision/destroy environments on demand
- [ ] **Observability integration**: metrics, logs, traces surfaced per service
- [ ] **Security integration**: secrets, scanning, policy
- [ ] **Cost visibility**: per-team, per-service cost attribution

## Module 6: Backstage
- [ ] **Backstage**: Spotify's open-source developer portal framework (CNCF incubating)
- [ ] **Core features**:
  - [ ] **Service catalog**: central index with metadata
  - [ ] **Software templates**: scaffolding for new services
  - [ ] **TechDocs**: documentation as code
  - [ ] **Plugins**: extensible (hundreds available)
- [ ] **`catalog-info.yaml`**: per-service metadata in the repo
- [ ] **Plugins**:
  - [ ] CI/CD dashboards (GitHub Actions, GitLab, Jenkins)
  - [ ] Kubernetes integration
  - [ ] Monitoring (Grafana, Datadog)
  - [ ] Security scanning results
  - [ ] Infrastructure (Terraform, Pulumi)
- [ ] **Deployment**: run as web app (Node.js), usually on K8s
- [ ] **Customization**: fork and tailor to your organization

## Module 7: Score (Workload Specification)
- [ ] **Score**: open-source workload specification (score.dev)
- [ ] **Problem**: developers describe their workload once, deploy to any platform
- [ ] **`score.yaml`**: abstract description (containers, resources, dependencies)
- [ ] **Score implementations**:
  - [ ] `score-compose`: generate docker-compose.yml
  - [ ] `score-k8s`: generate K8s manifests
  - [ ] `score-humanitec`: deploy via Humanitec
- [ ] **Why**: local dev matches production, no platform coupling in app repo
- [ ] **Similar tools**: Radius (Microsoft), Acorn (no longer active)

## Module 8: Abstraction Over Kubernetes
- [ ] **K8s is too low-level** for many developers
- [ ] **Higher-level abstractions**:
  - [ ] **Crossplane Compositions**: opinionated bundles as CRDs
  - [ ] **KubeVela**: application-centric platform
  - [ ] **Cloud Foundry**: PaaS on Kubernetes
  - [ ] **Knative**: serverless on K8s
  - [ ] **OpenFunction**: functions on K8s
- [ ] **Shift right vs shift down**:
  - [ ] Shift right: devs handle more ops
  - [ ] Shift down: platform hides ops
- [ ] **Platform provides**: less YAML, more focus on app logic

## Module 9: Team Topologies
- [ ] **Team Topologies** (Skelton & Pais): 4 team types
  - [ ] **Stream-aligned**: build and operate products (most teams)
  - [ ] **Platform**: enable stream-aligned teams
  - [ ] **Enabling**: help teams acquire skills
  - [ ] **Complicated subsystem**: specialized (e.g., ML)
- [ ] **Interaction modes**:
  - [ ] **Collaboration**: work closely together (new problem space)
  - [ ] **X-as-a-Service**: consumed via API/UI (mature platform)
  - [ ] **Facilitating**: guidance and training
- [ ] **Platform team size**: small (5-15) reaching many customers
- [ ] **Platform team anti-patterns**:
  - [ ] Ivory tower: build without customer input
  - [ ] Gatekeeping: require platform team approval for everything
  - [ ] Ignoring DevEx

## Module 10: Building an IDP — Roadmap
- [ ] **Phase 1: Discover**
  - [ ] Talk to developers, find pain points
  - [ ] Measure current DevEx metrics
  - [ ] Identify quick wins
- [ ] **Phase 2: Define**
  - [ ] Define platform scope and golden paths
  - [ ] Choose tools (Backstage, Crossplane, etc.)
  - [ ] Set measurable goals
- [ ] **Phase 3: Build**
  - [ ] Start small: one golden path, one persona
  - [ ] Iterate based on feedback
  - [ ] Measure adoption
- [ ] **Phase 4: Scale**
  - [ ] Add more capabilities
  - [ ] Drive adoption
  - [ ] Deprecate alternatives (with support)
- [ ] **Phase 5: Mature**
  - [ ] Platform as product (roadmap, customer satisfaction)
  - [ ] Measure outcomes (DORA, DevEx)
  - [ ] Continuous improvement

## Module 11: Measuring Success
- [ ] **DORA metrics**:
  - [ ] Deployment frequency
  - [ ] Lead time for changes
  - [ ] Change failure rate
  - [ ] Mean time to restore (MTTR)
- [ ] **DevEx metrics**:
  - [ ] Time to first commit / deploy
  - [ ] Time to onboard a new dev
  - [ ] Developer satisfaction (surveys)
  - [ ] Platform adoption rate
- [ ] **Platform usage**:
  - [ ] Services in catalog
  - [ ] Self-service actions per week
  - [ ] Tickets to platform team (should decrease)
- [ ] **Business**: faster time to market, less downtime, happier engineers

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Interview 5 developers about their friction points |
| Module 2 | Sketch an IDP for your organization (capabilities) |
| Module 3 | Measure DORA and DevEx metrics baseline |
| Module 4 | Define 3 golden paths for common developer tasks |
| Module 5 | Map platform components needed to support them |
| Module 6 | Install Backstage locally, add a service to catalog |
| Module 7 | Try Score with a sample workload, deploy to K8s and Compose |
| Module 8 | Compare raw K8s vs KubeVela for deploying an app |
| Module 9 | Identify team topology for your current org |
| Module 10 | Write a 90-day roadmap for initial IDP |
| Module 11 | Define success metrics for a platform team |

## Key Resources
- "Team Topologies" — Matthew Skelton & Manuel Pais
- backstage.io
- score.dev
- "Platform Engineering" book — Jennifer Riggins et al.
- platformengineering.org (community)
- "The DevOps Handbook" — Kim, Humble, Debois, Willis
