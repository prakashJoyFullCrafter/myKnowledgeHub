# TOGAF 10 Reference Models — TRM and III-RM

## What Are Reference Models in TOGAF?

Reference models are pre-built, reusable architecture patterns that live at the Foundation level of the Enterprise Continuum. Rather than starting from a blank page every time, architects can leverage proven, standardized structures that have already been validated across many organizations.

**Why use reference models?**

- **Reduce effort:** Start from a proven foundation, not scratch. Proven patterns save weeks of discovery work.
- **Promote interoperability:** Shared vocabulary and structure help teams, vendors, and systems align faster.
- **Standards compliance:** Reference models embed industry best practices and align with open standards.
- **Consistent taxonomy:** Everyone uses the same categories and terminology, reducing misunderstanding.

TOGAF 10 provides two built-in reference models:

| Reference Model | Level in Enterprise Continuum | Focus |
|---|---|---|
| TRM (Technical Reference Model) | Foundation Architecture | Generic technology service taxonomy |
| III-RM (Integrated Information Infrastructure Reference Model) | Common Systems Architecture | Information sharing and integration |

Organizations can also incorporate industry-specific models (BIAN, eTOM, HL7, etc.) at the Industry Architecture level of the Enterprise Continuum.

---

## Technical Reference Model (TRM)

### Overview

The TRM is a foundation architecture that provides a model and taxonomy of generic platform services. Its purpose is to enable the classification and positioning of technology components in a vendor-neutral, technology-neutral way.

Think of TRM as a **technology taxonomy** — a structured classification scheme for organizing all the services that an application platform must provide. It does NOT prescribe specific products. Instead it defines the categories of services, and then organizations fill those categories with selected products (which become Solution Building Blocks in their SIB).

Key characteristics:
- Most generic reference model — Foundation Architecture in the Enterprise Continuum
- Vendor-neutral and technology-neutral at the definition level
- Defines SERVICE CATEGORIES, not specific products
- Enables consistent communication about technology across domains

---

### TRM Structure

The TRM has two main structural components:

**1. Application Platform**
The platform that provides services to applications. This is the core of TRM — it defines all the service categories that a modern application platform must support.

**2. External Environment**
The environment in which the platform operates — including networks, external systems, and inter-enterprise connections. Applications interact with this external environment through the Application Platform.

The Application Platform sits in the middle, receiving requests from applications above and leveraging the external environment (networks, external services) below.

---

### TRM Application Platform Service Categories

The TRM defines the following service categories. Each category represents a class of technology that the platform must provide:

#### Data Management Services
- Database Management (DBMS) — relational, NoSQL, in-memory
- Data Warehousing — analytical stores, data lakes
- Data Distribution — replication, caching, CDN
- Text/Document Management — document stores, search indexes
- Image Management
- Video Management

#### Data Interchange Services
- Data Format and Description Services (EDI, XML, JSON, Avro, Protobuf)
- Electronic Data Interchange Services
- Graphics Data Interchange
- Fax (legacy; still appears in regulated industries)

#### Graphics and Imaging Services
- Computer-Aided Design (CAD)
- Raster/Vector Graphics
- Multimedia Services
- Animation

#### User Interface Services
- Graphical User Interface (GUI)
- Window Management
- Reporting and dashboards
- Web Browser Interface (SPA, PWA)

#### Document Processing Services
- Word Processing
- Desktop Publishing
- Email
- Forms Management

#### System Management Services
- Systems/Network Management
- Software Distribution and patching
- License Management
- Performance Management and observability
- Security Management

#### Network Services
- Data Communications
- Communication Platforms (TCP/IP, HTTP/S, gRPC, WebSocket)
- Distributed Data Services

#### Operating System Services
- Kernel Operations
- Process Management
- Memory Management
- File System Management
- Time Management (NTP, timezone handling)

#### Software Engineering Services
- Programming Language Support and runtimes
- Configuration Management
- Build Tools and CI/CD pipelines
- Testing Tools and frameworks

#### Transaction Processing Services
- Transaction Management (ACID, distributed transactions)
- Distributed Transaction (XA, Saga pattern)

#### Security Services
- Identification and Authentication (MFA, biometrics)
- Authorization and Access Control (RBAC, ABAC)
- Encryption (at rest and in transit)
- Audit Trail and non-repudiation
- Security Administration

#### Internationalization Services
- Multi-language support (i18n frameworks)
- Character Set Management (Unicode)
- Time Zone Management

---

### Using TRM in Phase D (Technology Architecture)

The TRM is most directly applied during Phase D of the ADM. The process:

1. **Use TRM taxonomy to categorize existing technology** — map all current technology services against TRM categories to create a structured inventory of the baseline architecture.
2. **Identify gaps** — which categories are missing, inadequately covered, or served by duplicated/overlapping tools?
3. **Select products and standards** — for each category, choose approved products or standards. These selections populate the Standards Information Base (SIB).
4. **Map to platform decomposition diagram** — the Technology Architecture deliverable shows how TRM categories are instantiated in the target architecture.
5. **Drive rationalization** — gaps and redundancies discovered in step 2 become inputs to the Migration Planning phase.

---

## Integrated Information Infrastructure Reference Model (III-RM)

### Overview

The III-RM is a Common Systems Architecture — one level more specific than the TRM in the Enterprise Continuum. While TRM provides a broad taxonomy of all technology services, III-RM focuses specifically on **how information moves and is shared across a distributed enterprise**.

It is particularly relevant for:
- Integration architecture design
- API platform design
- Enterprise Service Bus (ESB) and event-driven architecture
- Identity federation and cross-domain data sharing
- Inter-enterprise or cross-agency information sharing

III-RM answers the question: *What does the architecture of an information-sharing infrastructure look like?*

---

### III-RM Structure

The III-RM is composed of three main components:

#### 1. Brokerage Services

Brokerage services mediate between information producers and consumers. They sit in the middle of the information exchange, providing:

- **Message routing and transformation** — route messages between systems, translate data formats
- **Protocol translation** — bridge different communication protocols (REST to SOAP, HTTP to AMQP)
- **Service registry and discovery** — maintain a catalog of available services and their endpoints
- **Orchestration and choreography** — coordinate multi-step integration flows

Modern implementations of Brokerage Services:
- API Gateways (Kong, AWS API Gateway, Azure APIM)
- Enterprise Service Bus (MuleSoft, IBM MQ, WSO2)
- Event streaming platforms (Apache Kafka, AWS EventBridge)
- Integration platforms (Apache Camel, Azure Logic Apps)

#### 2. Managed Infrastructure Services

Provides the underlying infrastructure that makes information exchange reliable and secure:

- **Directory services** — LDAP, Active Directory, SCIM
- **Event management** — monitoring, alerting, log aggregation
- **System management** — infrastructure orchestration, configuration management
- **Security infrastructure** — PKI, certificate management, identity management

Modern implementations:
- Identity providers (Okta, Azure AD, Keycloak)
- Observability platforms (Datadog, Prometheus, OpenTelemetry)
- Certificate authorities and PKI platforms
- Configuration management tools (Ansible, Terraform, Kubernetes)

#### 3. Federated Infrastructure

Supports cross-organizational and cross-domain information sharing without requiring a single centralized authority:

- **Identity federation** — OAuth 2.0, SAML 2.0, OpenID Connect (OIDC) for cross-domain SSO
- **Data federation** — virtual data layer providing a unified view across distributed data sources
- **Cross-domain security** — trust frameworks, attribute-based access control across organizations

Modern implementations:
- Identity federation platforms (Azure AD B2B, Ping Federate)
- Data virtualization tools (Denodo, Dremio)
- Cross-organization API management with trust agreements

---

### III-RM Application Areas

| Application Area | III-RM Component | Modern Technology |
|---|---|---|
| API management | Brokerage Services | Kong, AWS API GW, Azure APIM |
| Event-driven integration | Brokerage Services | Apache Kafka, AWS EventBridge |
| Enterprise integration | Brokerage Services | MuleSoft, Apache Camel |
| Identity management | Managed Infrastructure | Okta, Keycloak, Azure AD |
| Cross-org SSO | Federated Infrastructure | SAML, OIDC, OAuth 2.0 |
| Federated data access | Federated Infrastructure | Denodo, Dremio, data mesh patterns |
| Observability | Managed Infrastructure | Datadog, Prometheus, Grafana |

---

## TOGAF Library (TOGAF 10 Addition)

TOGAF 10 introduced the **TOGAF Library** — an online, continuously updated collection of reference materials maintained by The Open Group. This extends the reference model concept beyond the core standard.

The TOGAF Library contains:
- **Series Guides** — detailed guidance on applying TOGAF in specific contexts (Agile, Security, Data, etc.)
- **White papers** — in-depth treatment of specific architectural topics
- **Templates** — reusable ADM deliverable templates
- **Patterns** — architectural patterns aligned with TOGAF concepts

Key distinction: TOGAF Library content is updated independently from the core TOGAF standard. This means organizations can access current guidance without waiting for a new standard edition.

---

## Industry-Specific Reference Models

Industry reference models operate at the **Industry Architecture** level of the Enterprise Continuum — more specific than TOGAF's Foundation/Common Systems architectures but still more generic than an organization's own architecture.

They can be formally incorporated into an organization's Architecture Repository alongside TRM and III-RM.

| Industry | Reference Model | Organization | Key Use |
|---|---|---|---|
| Banking | BIAN (Banking Industry Architecture Network) | BIAN | Core banking service domains and API standards |
| Insurance | ACORD | ACORD | Insurance data standards and process models |
| Telecoms | eTOM / Frameworx | TM Forum | Telecoms operations process framework |
| Healthcare | HL7 FHIR | HL7 | Healthcare data exchange and interoperability |
| Retail | ARTS | NRF | Retail technology standards and data models |
| Manufacturing | ISA-95 | ISA | Enterprise-to-control integration architecture |
| Government | NIEM | US Federal | Cross-agency information sharing |
| Cloud | CSA CCM | Cloud Security Alliance | Cloud security controls |

**Note:** These are optional, not mandatory. An organization adopts industry reference models when they are relevant to their sector and provide value. They do not replace TRM or III-RM — they complement and extend them at a more specific level.

---

## How Reference Models Fit in the Enterprise Architecture Practice

### Positioning in the Enterprise Continuum

```
Enterprise Continuum (Generic → Specific)
├── Foundation Architectures
│   └── TRM — technology service taxonomy (most generic)
├── Common Systems Architectures
│   └── III-RM — information infrastructure patterns
├── Industry Architectures
│   └── BIAN, eTOM, HL7, BIAN, etc. (sector-specific)
└── Organization-Specific Architectures
    └── Your enterprise's own architectures (most specific)
```

### Step-by-Step Process for Using TRM

1. **Inventory current state** — map all existing technology against TRM service categories to produce a structured baseline
2. **Identify gaps** — determine which categories are missing, duplicated, or underserved in the baseline
3. **Define standards** — select approved products per category; these selections are documented in the Standards Information Base (SIB)
4. **Design target state** — produce a platform decomposition diagram aligned to TRM structure
5. **Plan migration** — gaps and duplicates discovered in step 2 drive the technology rationalization roadmap

### Step-by-Step Process for Using III-RM

1. **Identify integration requirements** — which systems need to exchange information? What are the exchange patterns (sync/async, push/pull)?
2. **Map to III-RM components** — classify required capabilities as Brokerage, Managed Infrastructure, or Federated Infrastructure
3. **Select integration technologies** — choose products/platforms for each III-RM component
4. **Design integration architecture** — use III-RM structure as the organizing framework for the integration layer design
5. **Address federation requirements** — for cross-organizational sharing, design the federated identity and data layer

### Relationship to Other TOGAF Concepts

| Concept | Relationship to Reference Models |
|---|---|
| Enterprise Continuum | TRM is Foundation Architecture; III-RM is Common Systems Architecture |
| Architecture Repository | Both TRM and III-RM are stored in the Reference Library |
| Phase C (App Architecture) | III-RM informs the Application Integration architecture |
| Phase D (Tech Architecture) | TRM directly drives technology categorization and gap analysis |
| SIB (Standards Information Base) | Products selected to fulfill TRM services become SBB entries in the SIB |
| Solution Building Blocks (SBB) | Specific products chosen to implement TRM service categories |

---

## Key Exam Points

- **TRM = Foundation Architecture** — most generic, defines SERVICE CATEGORIES, not specific products
- **III-RM = Common Systems Architecture** — one level more specific, focuses on information infrastructure integration
- **TRM is NOT a product catalog** — it is a taxonomy; product selections go in the SIB
- **III-RM is NOT Foundation Architecture** — it is a Common Systems Architecture
- **Both are starting points** — organizations specialize and extend them, not use them as-is
- **Industry models (BIAN, eTOM) are at the Industry Architecture level** — optional, not mandatory TOGAF content
- **TRM is applied in Phase D** — Technology Architecture phase of the ADM
- **III-RM is particularly relevant for integration design** — API platforms, middleware, ESB, identity federation
- **TOGAF Library** (new in TOGAF 10) extends reference content independently of the core standard

---

## Common Mistakes

- Confusing TRM with a product standard — TRM is a taxonomy; products fill TRM categories but are not part of TRM itself
- Ignoring III-RM when designing integration architecture — it provides directly applicable structure for integration and API platforms
- Skipping TRM mapping during Phase D — failing to map current technology against TRM means missing gaps and redundancies
- Treating industry reference models (BIAN, eTOM) as mandatory TOGAF content — they are optional additions at the Industry level
- Treating TRM and III-RM as mutually exclusive — they operate at different levels and are complementary
- Assuming TRM is outdated because it lists "fax" — TRM service categories are abstractions; some are irrelevant in modern contexts but the taxonomy structure remains valid
