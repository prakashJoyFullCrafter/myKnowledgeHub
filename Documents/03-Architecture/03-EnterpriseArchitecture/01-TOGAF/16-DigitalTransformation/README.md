# TOGAF 10 — Digital Transformation and Cloud Architecture

## What is Digital Transformation in TOGAF 10?

- TOGAF 10 introduced a dedicated **Digital Transformation Series Guide**
- Digital transformation = fundamental change in **HOW** an enterprise creates and delivers value using digital technology
- Not just "moving to cloud" — it's changing business models, customer experiences, and operational processes through digital capabilities
- TOGAF provides the architectural framework for **GOVERNING** and **PLANNING** digital transformation, not executing it

---

## Digital Capabilities Framework

### Core Digital Capabilities an Enterprise Needs

1. **Customer Experience**: omnichannel, personalization, real-time responsiveness
2. **Data and Analytics**: real-time data, ML/AI-driven insights, data products
3. **Platform Architecture**: API economy, ecosystems, marketplaces
4. **Cloud Infrastructure**: elastic compute, IaaS/PaaS/SaaS orchestration
5. **DevOps and Automation**: CI/CD, Infrastructure as Code, AIOps
6. **Cybersecurity**: zero trust, cloud-native security, DevSecOps
7. **Digital Innovation**: rapid experimentation, MVP delivery, product thinking

---

## Cloud Architecture with TOGAF

### Cloud Service Models and TOGAF Mapping

| Cloud Model | Description | TOGAF Domain | Examples |
|---|---|---|---|
| IaaS (Infrastructure as a Service) | Virtual compute, storage, networking | Technology Architecture | AWS EC2, Azure VMs, GCP Compute Engine |
| PaaS (Platform as a Service) | Managed runtime, databases, middleware | Technology + Application Architecture | AWS RDS, Azure App Service, GCP Cloud Run |
| SaaS (Software as a Service) | Fully managed applications | Application Architecture | Salesforce, ServiceNow, Microsoft 365 |
| FaaS (Function as a Service) | Event-driven serverless functions | Application Architecture | AWS Lambda, Azure Functions, GCP Cloud Functions |
| CaaS (Container as a Service) | Managed container orchestration | Technology Architecture | AWS EKS, Azure AKS, GCP GKE |

### Cloud Deployment Models in Enterprise Continuum

- **Public Cloud**: Foundation/Common Systems level — AWS, Azure, GCP reference architectures
- **Private Cloud**: Organization-Specific — on-premises cloud stack (OpenStack, VMware)
- **Hybrid Cloud**: Mix — workloads split between private and public based on data residency, latency, cost
- **Multi-Cloud**: Multiple public providers — avoid lock-in, leverage best-of-breed services

### Cloud-First Architecture Principle (Example)

- **Statement**: "New systems and infrastructure use approved cloud platforms; on-premises requires documented justification"
- **Why this is an Architecture Principle (not just a policy)**: drives decisions at every ADM phase
- **In Phase D**: technology architecture defaults to cloud-native patterns (managed services, serverless, containers)
- **In Phase G**: compliance reviews check cloud adoption; non-cloud deployments trigger Architecture Board review

---

## Platform Architecture Thinking

### What is Platform Architecture?

- A platform = a foundation that enables others to build on top of it
- **Business platforms**: two-sided markets (Amazon Marketplace, App Store, API banking platforms)
- **Technical platforms**: internal developer platforms that reduce time-to-market for product teams

### Internal Developer Platform (IDP)

A key digital transformation architecture pattern:

```
Product Teams (consumers)
        |  self-serve via
        v
Internal Developer Platform
├── CI/CD pipelines (GitHub Actions, Jenkins)
├── Container platform (Kubernetes)
├── Observability (Prometheus + Grafana + Jaeger)
├── Service Mesh (Istio)
├── API Gateway (Kong)
├── Secret Management (Vault)
└── Infrastructure as Code (Terraform modules)
        |  deploys to
        v
Cloud Infrastructure (AWS / Azure / GCP)
```

TOGAF role: Technology Architecture defines the IDP; Phase G governance ensures teams use it

### API Economy Architecture

- APIs are products, not just technical interfaces
- API-first architecture enables: partner integrations, mobile channels, ecosystem monetization
- Architecture layers:

```
External Partners / Third Parties
        |  HTTPS/OAuth 2.0
        v
API Gateway (Kong, Apigee, AWS API Gateway)
        |  JWT validation, rate limiting, analytics
        v
Internal Microservices (REST/gRPC)
        |  event streaming
        v
Apache Kafka / Event Bus
        |
        v
Data Platform
```

---

## Microservices Architecture in TOGAF Context

### From Monolith to Microservices — Architecture Patterns

1. **Strangler Fig Pattern**: gradually replace a monolith by routing specific functions to new microservices
2. **Anti-Corruption Layer**: create a translation layer between old and new systems during migration
3. **Domain-Driven Design (DDD) Bounded Contexts**: each microservice owns a single bounded context

### TOGAF ADM for Microservices Migration

| ADM Phase | Microservices Activity |
|---|---|
| Phase B | Map business capabilities — each capability may become one or more bounded contexts |
| Phase C (App) | Current state = monolith; Target = microservices portfolio; Gap = decomposition work |
| Phase E | Work packages = one per bounded context extraction |
| Phase F | Sequence: extract least-coupled services first; core services last |
| Phase G | Architecture contracts with teams for each service boundary |

### Microservices Architecture Principles

- **Single Responsibility**: each service owns one business capability
- **Design for Failure**: circuit breakers, retries, bulkheads (Resilience4J, Hystrix patterns)
- **API Contract First**: OpenAPI 3.0 specification before implementation
- **Event-Driven Communication**: prefer async (Kafka) over sync (REST) for resilience
- **Independent Deployability**: each service has its own CI/CD pipeline

---

## Data Architecture for Digital Transformation

### Modern Data Platform Architecture

```
Sources: Microservices, SaaS apps, IoT devices, external feeds
         |
         v
Ingestion: Apache Kafka (streaming), AWS DMS (batch/CDC)
         |
         v
Storage:   Data Lake (AWS S3 / Azure ADLS) — raw and processed
           Data Warehouse (Snowflake / BigQuery / Redshift) — structured analytics
         |
         v
Processing: Apache Spark (batch), Apache Flink (streaming), dbt (transformations)
         |
         v
Serving:   BI tools (Tableau, Power BI), APIs (for product teams), ML Feature Store
```

### Data Mesh Architecture (emerging pattern)

- **Decentralized data ownership**: each domain owns its data as a "data product"
- **Self-serve data infrastructure**: platform team provides tooling; domain teams use it
- **Federated governance**: enterprise-wide standards, domain-specific implementation
- **TOGAF alignment**: Data Architecture domain defines the data mesh operating model; governance in Phase G

### AI/ML Architecture with TOGAF

AI capabilities require architectural planning across all BDAT domains:

**Business Architecture:**
- Which business decisions can/should be automated with ML?
- AI governance: model oversight, explainability requirements, bias monitoring
- Ethics policy: what AI decisions require human-in-the-loop?

**Data Architecture:**
- Feature Store: centralized repository of ML features for training and serving
- Training data management: versioning, lineage, quality
- Model registry: track model versions, performance metrics, deployment status

**Application Architecture:**
- ML Model serving: REST APIs (FastAPI + MLflow), batch prediction jobs
- A/B testing infrastructure: canary deployments for model updates
- Feedback loops: capture prediction outcomes to retrain models

**Technology Architecture:**
- GPU/TPU compute for model training (AWS SageMaker, Azure ML, GCP Vertex AI)
- MLOps pipeline: automated retraining, drift detection, model monitoring
- Vector databases for LLM/RAG architectures (Pinecone, Weaviate, pgvector)

---

## Digital Transformation and the ADM

### How ADM Supports a Digital Transformation Program

| ADM Phase | Digital Transformation Activity |
|---|---|
| Preliminary | Establish digital principles (Cloud First, API First, Data-Driven); set up Architecture Board with digital expertise |
| Phase A | Define digital transformation vision: target digital capabilities, customer experience goals, revenue model changes |
| Phase B | Map current vs target digital capabilities; value stream mapping for customer journeys; digital business model canvas |
| Phase C (Data) | Design data platform architecture; AI/ML data requirements; data product strategy |
| Phase C (App) | Application rationalization (cloud-native vs lift-and-shift vs retire); API strategy; microservices decomposition |
| Phase D (Tech) | Cloud landing zone design; Kubernetes platform; CI/CD pipeline standards; IDP design |
| Phase E | Work packages: cloud migration waves, service decomposition, data platform build |
| Phase F | Migration sequencing: which apps to cloud first (strangler fig), which to retire |
| Phase G | Governance: cloud cost management, security posture, architectural drift detection |
| Phase H | Monitor: new digital capabilities emerging (GenAI, edge computing), update roadmap |

---

## Cloud Landing Zone Architecture

A Cloud Landing Zone is the foundational architecture for cloud adoption — a pre-configured, governance-ready cloud environment.

### Landing Zone Components (AWS example)

```
Management Account
├── Security Account (centralized CloudTrail, GuardDuty, Security Hub)
├── Logging Account (centralized logs from all accounts)
├── Network Account (Transit Gateway, VPNs, Direct Connect)
└── Workload Accounts
    ├── Production Account
    ├── Staging Account
    └── Development Account
```

### TOGAF and Landing Zone Design

- Phase D (Technology Architecture) produces the Landing Zone design
- Architecture Principles drive landing zone decisions:
  - "All workloads in isolated accounts" — prevents blast radius
  - "Central security logging" — supports audit and compliance
  - "Infrastructure as Code only" — prevents configuration drift
- SIB entry: "AWS Control Tower is the approved landing zone framework"

---

## Event-Driven Architecture (EDA)

### What is EDA?

- Systems communicate through **events** (things that happened) rather than direct API calls
- **Publisher/subscriber model**: producers emit events; consumers react independently
- Benefits: loose coupling, scalability, resilience, auditability

### EDA Patterns

| Pattern | Description | Use Case |
|---|---|---|
| Event Notification | Lightweight signal that something happened | "OrderPlaced" event triggers inventory check |
| Event-Carried State Transfer | Event contains all data needed by consumer | Replaces synchronous GET calls |
| Event Sourcing | State derived from complete history of events | Audit trail, point-in-time reconstruction |
| CQRS | Separate read and write models | High-read workloads, reporting |
| Saga Pattern | Manages distributed transactions via events | Microservices transaction coordination |

### TOGAF Mapping for EDA

- **Phase C (App)**: EDA as Application Architecture pattern
- **Phase D (Tech)**: Kafka cluster, schema registry in Technology Architecture
- **ADR-042** (from 12-PracticalArtifacts): "Use Apache Kafka for all async communication"

---

## Key Exam Points

| Topic | Key Point |
|---|---|
| Digital Transformation Series Guide | TOGAF 10 addition — not part of core ADM, a separate guide |
| Cloud-First Principle | Architecture Principle — defined in Preliminary Phase, governs all subsequent phases |
| API-First Principle | Architecture Principle — drives Phase C Application Architecture decisions |
| Microservices decomposition | Maps to Phase C (Application Architecture) gap analysis |
| Data Mesh and AI/ML | Require cross-domain architecture — all BDAT domains involved |
| Landing Zone | Foundational cloud architecture — Technology Architecture output from Phase D |
| EDA patterns | Application Architecture patterns — documented in Phase C |
| Strangler Fig | Migration pattern for monolith-to-microservices — sequenced in Phase F |
| IDP (Internal Developer Platform) | Technology Architecture concern — defined in Phase D, governed in Phase G |
| Data-Driven Principle | Architecture Principle — data decisions backed by analytics, not intuition |
