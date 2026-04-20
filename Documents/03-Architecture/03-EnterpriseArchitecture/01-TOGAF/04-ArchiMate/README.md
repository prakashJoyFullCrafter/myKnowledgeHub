# ArchiMate 3.1 — Enterprise Architecture Modeling Language

## What is ArchiMate?

ArchiMate is an open standard published and maintained by The Open Group for modeling enterprise architectures. The current version is **ArchiMate 3.1**. It provides a uniform visual language and notation for creating diagrams that describe the structure and behavior of enterprises across multiple abstraction levels.

ArchiMate solves a core problem in enterprise architecture practice: different stakeholders (business executives, application architects, infrastructure engineers, security officers) have different vocabulary, concerns, and mental models. Without a shared notation, every architect invents their own box-and-line diagrams, making communication across teams error-prone and ambiguous.

**Key relationships to other standards:**
- **TOGAF** provides the *process* — the Architecture Development Method (ADM) that guides how you discover, plan, and govern architecture work.
- **ArchiMate** provides the *notation* — how you visually represent the architecture that TOGAF helps you define.
- The two are designed to be used together. TOGAF deliverables (Architecture Vision, Business Architecture, etc.) are best expressed using ArchiMate diagrams and viewpoints.

---

## Core Framework: The Three-Layer, Three-Aspect Matrix

The ArchiMate metamodel is organized as a **3×3 matrix** of layers and aspects. Every core element in the language belongs to exactly one cell of this matrix.

```
             | Active Structure  |    Behavior      | Passive Structure |
-------------|-------------------|------------------|-------------------|
Business     | Business Actor    | Business Process | Business Object   |
             | Business Role     | Business Function| Contract          |
             | Business Collab.  | Business Interact| Representation    |
             | Business Interface| Business Event   | Product           |
             |                   | Business Service |                   |
-------------|-------------------|------------------|-------------------|
Application  | App Component     | App Function     | Data Object       |
             | App Collaboration | App Interaction  |                   |
             | App Interface     | App Process      |                   |
             |                   | App Event        |                   |
             |                   | App Service      |                   |
-------------|-------------------|------------------|-------------------|
Technology   | Node              | Tech Function    | Artifact          |
             | Device            | Tech Process     |                   |
             | System Software   | Tech Interaction |                   |
             | Tech Collaboration| Tech Event       |                   |
             | Tech Interface    | Tech Service     |                   |
             | Path              |                  |                   |
             | Communication Net |                  |                   |
```

**Layers** separate architecture concerns by abstraction:
- **Business Layer** — what the organization does and how it is organized from a business perspective.
- **Application Layer** — the software applications that support the business.
- **Technology Layer** — the physical and virtual infrastructure that runs the software.

**Aspects** separate concerns by structural vs. behavioral:
- **Active Structure** — things that *perform* behavior (actors, components, nodes).
- **Behavior** — actions and processes performed by active structure elements.
- **Passive Structure** — things that are *acted upon* (data, objects, artifacts).

---

## Business Layer

The Business Layer models the enterprise from an organizational and business-process perspective.

### Active Structure Elements

| Element | Description |
|---------|-------------|
| **Business Actor** | An organizational entity (person, team, organization) capable of performing behavior. Example: "Finance Department", "Customer". |
| **Business Role** | The responsibility for performing specific behavior. A Business Actor is *assigned* to a Business Role. Example: "Approver", "Account Manager". |
| **Business Collaboration** | An aggregate of two or more Business Roles that work together to perform a collaboration. |
| **Business Interface** | A point of access at which business services are made available to the environment. |

### Behavior Elements

| Element | Description |
|---------|-------------|
| **Business Process** | A sequence of behaviors that produces a defined result. Has a clear start and end. Example: "Invoice Approval Process". |
| **Business Function** | Groups behavior based on a chosen set of criteria. Not necessarily sequential. Example: "Accounts Payable Function". |
| **Business Interaction** | A behavior performed by two or more Business Roles or Actors in concert. |
| **Business Event** | Something that happens and triggers or results from behavior. Example: "Invoice Received". |
| **Business Service** | An explicitly defined exposed behavior, offered by one business entity to another. Example: "Customer Onboarding Service". |

### Passive Structure Elements

| Element | Description |
|---------|-------------|
| **Business Object** | A passive concept that has relevance from a business perspective. Example: "Invoice", "Customer Record". |
| **Contract** | A formal or informal specification of an agreement between parties. |
| **Representation** | A perceptible form of information carried by a Business Object. Example: "Invoice PDF", "Printed Report". |
| **Product** | A coherent collection of services and passive structure elements, with associated contracts and prices. |

---

## Application Layer

The Application Layer models software applications, their interactions, and the data they manage.

### Active Structure Elements

| Element | Description |
|---------|-------------|
| **Application Component** | An encapsulated unit of application functionality. Example: "ERP System", "Payment Gateway". |
| **Application Collaboration** | Aggregate of two or more Application Components cooperating together. |
| **Application Interface** | A point of access at which application services are made available. Example: "REST API Endpoint", "SOAP Interface". |

### Behavior Elements

| Element | Description |
|---------|-------------|
| **Application Function** | Automated behavior performed by an Application Component. Example: "Tax Calculation Function". |
| **Application Interaction** | Behavior performed by two or more Application Components in concert. |
| **Application Process** | A sequence of application behaviors producing a defined result. |
| **Application Event** | An application state change. Example: "Order Submitted Event". |
| **Application Service** | An explicitly defined exposed application behavior. Example: "Authentication Service", "Reporting Service". |

### Passive Structure Elements

| Element | Description |
|---------|-------------|
| **Data Object** | Data structured for automated processing. Example: "Customer Master Data", "Transaction Record". |

---

## Technology Layer

The Technology Layer models the hardware, software infrastructure, and communication networks.

### Active Structure Elements

| Element | Description |
|---------|-------------|
| **Node** | A computational or physical resource capable of hosting or executing elements. Example: "Application Server", "Virtual Machine". |
| **Device** | A physical IT resource with processing capability. Example: "Server Hardware", "Mobile Device". |
| **System Software** | Software that provides or supports an environment for other software. Example: "Operating System", "Database Management System", "Container Runtime". |
| **Technology Collaboration** | Aggregate of two or more Nodes cooperating together. |
| **Technology Interface** | Point of access at which technology services are made available. Example: "JDBC Interface", "TCP/IP Port". |
| **Path** | A link between two or more Nodes through which communication occurs. |
| **Communication Network** | A set of structures that connect Nodes for transmission. Example: "LAN", "Internet". |

### Behavior Elements

| Element | Description |
|---------|-------------|
| **Technology Function** | A collection of technology behavior performed by a Node. Example: "Load Balancing", "Data Replication". |
| **Technology Process** | A sequence of technology behaviors producing a defined result. |
| **Technology Interaction** | Behavior performed by two or more Nodes in concert. |
| **Technology Event** | A technology state change. Example: "Server Restart Event". |
| **Technology Service** | An explicitly defined exposed technology behavior. Example: "Storage Service", "Compute Service". |

### Passive Structure Elements

| Element | Description |
|---------|-------------|
| **Artifact** | A piece of data used or produced in a technology environment. Example: "JAR file", "Docker Image", "Configuration File", "Database Table". |

---

## Relationships

ArchiMate defines a precise set of relationships. Using the correct relationship — rather than defaulting to Association for everything — is what makes ArchiMate models precise and useful.

### Structural Relationships

These describe static connections between elements.

| Relationship | Notation | Description | Example |
|--------------|----------|-------------|---------|
| **Composition** | Solid line with filled diamond at whole end | A whole-part relationship where the part cannot exist without the whole. Lifecycle is shared. | An Application Component *composed of* sub-components. |
| **Aggregation** | Solid line with hollow diamond at whole end | A whole-part relationship where parts can exist independently. | A Business Process *aggregating* multiple Business Functions. |
| **Assignment** | Solid line with filled circle at active structure end | Links an active structure element to behavior it performs, or an active structure element to a node it runs on. | Business Role *assigned to* Business Process; Application Component *assigned to* Node. |
| **Realization** | Dashed line with hollow triangle arrowhead | An element realizes or implements another, more abstract element. | Application Service *realizes* Business Service; Technology Service *realizes* Application Service. |

### Dependency Relationships

These describe usage and influence between elements.

| Relationship | Notation | Description | Example |
|--------------|----------|-------------|---------|
| **Serving** | Solid line with open arrowhead pointing to the served element | One element provides services to another element. The arrowhead points from server to client. | Application Component *serves* Business Process. |
| **Access** | Dashed line with open arrowhead | A behavior element reads or writes a passive structure element. Annotated: READ, WRITE, or READ/WRITE. | Application Function *accesses* Data Object (WRITE). |
| **Influence** | Dashed line with open arrowhead and a label | One element affects another without realizing or serving it. Used heavily in motivation modeling. | Driver *influences* Goal. |
| **Association** | Solid line, optionally with arrowhead | An unspecified relationship between elements. Use sparingly — only when no more specific relationship applies. | Stakeholder *associated with* Business Process. |

### Dynamic Relationships

These describe sequencing and data flow between behavior elements.

| Relationship | Notation | Description | Example |
|--------------|----------|-------------|---------|
| **Triggering** | Solid line with filled arrowhead | A causal, temporal relationship: one behavior triggers another. | Business Event *triggers* Business Process. |
| **Flow** | Dashed line with filled arrowhead | Transfer of information, goods, or money between elements. | Business Process *flows to* Business Process (passing a Document). |

### Other Relationships

| Relationship | Notation | Description | Example |
|--------------|----------|-------------|---------|
| **Specialization** | Solid line with hollow triangle arrowhead (like UML inheritance) | One element is a more specific form of another. | "Premium Customer" *specializes* "Customer" Business Role. |

---

## Motivation Aspect

The Motivation aspect is **cross-cutting** — it exists outside the three-layer matrix and captures the reasons and objectives behind architecture decisions. Motivation elements are especially important in Phase A (Architecture Vision) and throughout stakeholder communication.

| Element | Description |
|---------|-------------|
| **Stakeholder** | An individual, team, or organization with interests in the architecture. Maps directly to TOGAF stakeholders. |
| **Driver** | An external or internal condition motivating the organization to change. Example: "Regulatory Compliance Requirement", "Competitor Pressure". |
| **Assessment** | The result of analysis of a Driver — often a SWOT analysis (Strength, Weakness, Opportunity, Threat). |
| **Goal** | A high-level end state that the organization wants to achieve. Example: "Improve Customer Experience", "Reduce Operational Cost by 20%". |
| **Outcome** | A measurable, observable result produced by a capability or program. More concrete than a Goal. |
| **Principle** | A qualitative rule or guideline that should be satisfied by the architecture. Example: "Single Source of Truth for Customer Data". |
| **Requirement** | A statement of need that must be realized by the architecture. More specific than a Principle. |
| **Constraint** | A restriction on the way the architecture can be realized, outside the control of architects. Example: "System must run on existing datacenter hardware". |
| **Value** | The relative worth or importance of an element or outcome to a stakeholder. |

**Key Motivation relationships:**
- Stakeholder *has* Driver
- Driver *leads to* Assessment
- Assessment *produces* Goal / Outcome
- Goal *is realized by* Requirement
- Requirement *is constrained by* Constraint
- Principle *constrains* Requirement

---

## Strategy Layer

The Strategy Layer sits above the three core layers and models high-level intentions. It maps most closely to TOGAF Phase A (Architecture Vision) and the Preliminary Phase (Principles, Capabilities).

| Element | Description |
|---------|-------------|
| **Resource** | An asset owned or controlled by the organization to achieve its objectives. Example: "Data Analytics Platform", "Skilled Workforce". |
| **Capability** | An ability that the organization possesses, expressed in general terms. Example: "Real-time Fraud Detection Capability", "Multi-channel Customer Communication". |
| **Course of Action** | An approach or plan for configuring resources and capabilities to achieve a goal. Maps to strategic initiatives or programs. |
| **Value Stream** | A sequence of activities that creates an overall result for a customer, stakeholder, or end user. Example: "Order to Cash Value Stream". |

Strategy elements connect downward to Business Layer elements via Realization: a Capability is *realized by* Business Processes and Application Services.

---

## Implementation and Migration Layer

This layer supports planning and tracking the transition from a Baseline Architecture to a Target Architecture. It maps to TOGAF Phases E (Opportunities & Solutions) and F (Migration Planning).

| Element | Description |
|---------|-------------|
| **Work Package** | A set of actions identified to achieve one or more results as part of a program. Maps to a project or sprint. |
| **Deliverable** | A precisely defined work product that is contractually specified. Example: "Architecture Definition Document v1.0". |
| **Implementation Event** | A state change related to implementation. Example: "System Go-Live", "Data Migration Complete". |
| **Plateau** | A relatively stable state of the architecture at a point in time. Equivalent to TOGAF's Architecture State — Baseline (As-Is), Transition, or Target (To-Be). |
| **Gap** | A statement of difference between two Plateaus. Used in gap analysis between Baseline and Target. |

**Modeling pattern:** Gap *exists between* Plateau (Baseline) and Plateau (Target). Work Packages *resolve* Gaps.

---

## Key Viewpoints

A **viewpoint** is a specification of the conventions for a particular kind of view. A **view** is a representation of the architecture from the perspective of a given set of stakeholders. Every view should be based on a named viewpoint with a defined audience and purpose.

### Core Viewpoints

| Viewpoint | Primary Audience | Purpose |
|-----------|-----------------|---------|
| **Organization Viewpoint** | Business executives, HR, process owners | Shows organizational structure, actors, roles, and responsibilities. Equivalent to an org chart with richer semantics. |
| **Business Process Cooperation Viewpoint** | Business analysts, process owners | Shows relationships between business processes, the roles and actors that perform them, and the services they use and produce. |
| **Product Viewpoint** | Product managers, business architects | Shows the products offered to customers, the business services and processes that support them, and associated contracts. |
| **Application Cooperation Viewpoint** | Application architects, integration architects | Shows how applications interact with each other through interfaces and data exchange. Used to document integration landscape. |
| **Application Usage Viewpoint** | Business analysts, application architects | Shows which applications support which business processes and functions. The bridge between Business and Application layers. |
| **Technology Viewpoint** | Infrastructure architects, operations | Shows nodes, devices, system software, networks, and how they are connected. The physical/virtual infrastructure diagram. |
| **Technology Usage Viewpoint** | Application architects, infrastructure architects | Shows how applications are deployed and supported by technology infrastructure. Bridge between Application and Technology layers. |
| **Migration Viewpoint** | Program managers, solution architects | Shows the transition from Baseline to Target architecture using Plateaus and Gaps, with Work Packages that bridge them. |
| **Motivation Viewpoint** | All stakeholders, senior management | Shows goals, requirements, principles, and their relationships to architecture elements. Communicates the *why* of decisions. |
| **Stakeholder Viewpoint** | Architecture review board, senior management | Shows concerns and goals of key stakeholders and how architecture elements address those concerns. |

### Additional Viewpoints

| Viewpoint | Purpose |
|-----------|---------|
| **Information Structure Viewpoint** | Shows Business Objects and Data Objects and their relationships. Relevant to Phase C (Data Architecture). |
| **Service Realization Viewpoint** | Shows how Business Services are realized by Business Processes and Application Services. Cross-layer traceability. |
| **Layered Viewpoint** | A full-stack view showing all three layers and their relationships in one diagram. Good for executive overviews. |
| **Implementation and Deployment Viewpoint** | Shows how application components are deployed on technology nodes. DevOps-relevant view. |

---

## ArchiMate and TOGAF ADM Mapping

One of ArchiMate's greatest strengths is the direct mapping between its element types, layers, and viewpoints to TOGAF ADM phases. Use this table to know what to model at each phase.

| TOGAF ADM Phase | ArchiMate Elements and Viewpoints to Use |
|-----------------|------------------------------------------|
| **Preliminary** | Principles (Motivation), Capabilities (Strategy), existing architectural landscape overview |
| **Phase A — Architecture Vision** | Motivation Viewpoint, Stakeholder Viewpoint, Strategy Layer (Capabilities, Value Streams), high-level Layered Viewpoint |
| **Phase B — Business Architecture** | Organization Viewpoint, Business Process Cooperation Viewpoint, Product Viewpoint, full Business Layer |
| **Phase C — Data Architecture** | Information Structure Viewpoint, Data Objects, Business Object relationships |
| **Phase C — Application Architecture** | Application Usage Viewpoint, Application Cooperation Viewpoint, Application Component inventory |
| **Phase D — Technology Architecture** | Technology Viewpoint, Technology Usage Viewpoint, Infrastructure Deployment |
| **Phase E — Opportunities & Solutions** | Migration Viewpoint (initial), Work Packages, Gaps, Plateaus |
| **Phase F — Migration Planning** | Migration Viewpoint (detailed), Implementation & Migration Layer, roadmap sequencing |
| **Phase G — Implementation Governance** | Governance-oriented Motivation elements (Constraints, Requirements), traceability to deliverables |
| **Phase H — Architecture Change Management** | Updated Motivation Viewpoint, new Drivers, revised Goals and Requirements |
| **Requirements Management** | Requirements, Constraints, Drivers — maintained throughout all phases |

---

## Element Notation and Visual Conventions

Since ArchiMate diagrams use specific shapes and colors, here is how to recognize and use them correctly.

### Color Coding by Layer

| Layer / Aspect | Background Color | Usage |
|----------------|-----------------|-------|
| Business Layer | Yellow | Business Actors, Processes, Objects |
| Application Layer | Light blue | Application Components, Services, Data |
| Technology Layer | Green / light grey | Nodes, Devices, System Software, Artifacts |
| Motivation Aspect | Light purple / lavender | Stakeholders, Goals, Requirements, Principles |
| Strategy Layer | Light yellow / pale gold | Capabilities, Resources, Value Streams |
| Implementation Layer | Light grey | Work Packages, Plateaus, Gaps |

### Shape Conventions

Each element type has:
1. A **rectangular box** as the base shape (with some exceptions like junctions).
2. A **small icon in the top-right corner** indicating the specific element type (e.g., a person silhouette for Business Actor, a gear for Function, a cylinder for Data Object).
3. The **element name** inside the box.

Key shape rules:
- **Interface elements** have a slightly different visual marker (a small square on the border of their parent component), indicating they are access points.
- **Collaboration elements** are shown as two overlapping circles.
- **Junctions** (AND/OR) are small circles used to split or merge relationship flows.

### Relationship Line Styles Summary

| Relationship | Line Style |
|-------------|------------|
| Composition | Solid, filled diamond at source |
| Aggregation | Solid, hollow diamond at source |
| Assignment | Solid, filled circle at active structure end |
| Realization | Dashed, hollow triangle arrowhead |
| Serving | Solid, open arrowhead at served end |
| Access | Dashed, open arrowhead (+ R/W/RW label) |
| Influence | Dashed, open arrowhead + text label |
| Triggering | Solid, filled arrowhead |
| Flow | Dashed, filled arrowhead |
| Association | Solid, no arrowhead (or optional open arrowhead) |
| Specialization | Solid, hollow triangle arrowhead (like UML extends) |

---

## Common Modeling Mistakes

These are the errors most frequently made by architects learning ArchiMate. Avoiding them is the difference between a precise, communicable model and an uninterpretable box diagram.

### 1. Wrong Layer for a Concept
**Mistake:** Placing a database server (e.g., Oracle RAC) in the Application Layer as an Application Component.
**Correct:** A database server is a **Node** or **Device** in the Technology Layer. Oracle Database software running on it is **System Software**. The schema and tables are **Artifacts**. The application accesses them via a **Technology Service**.

### 2. Confusing Business Service with Application Service
**Mistake:** Modeling "Customer Portal" as both a Business Service and an Application Service, using them interchangeably.
**Correct:** A **Business Service** is what the business offers (e.g., "Account Inquiry Service" from the customer's perspective). An **Application Service** is the software-level capability that *realizes* it (e.g., "Account Balance API"). They are connected via a Realization relationship.

### 3. Overusing Association
**Mistake:** Connecting all elements with plain Association lines when more specific relationships (Serving, Access, Realization, Assignment) are available.
**Correct:** Reserve Association only for relationships that genuinely cannot be classified. Every other relationship has a more specific counterpart that conveys more meaning.

### 4. Mixing Notations
**Mistake:** Placing UML class diagrams or BPMN swim lanes inside an ArchiMate viewpoint.
**Correct:** ArchiMate diagrams should use only ArchiMate notation. Use BPMN separately for detailed process specification and ArchiMate for architecture-level process modeling. You can reference a BPMN artifact from an ArchiMate element, but do not mix notations in the same diagram.

### 5. Missing the Assignment Relationship
**Mistake:** Drawing a Business Role and a Business Process in the same diagram without connecting them.
**Correct:** A Business Role must be *assigned to* the Business Process or Business Function it performs. Without this relationship, the diagram does not convey who is responsible for what behavior.

### 6. Creating Views Without Defined Viewpoints
**Mistake:** Drawing a diagram without specifying the viewpoint — no defined audience, no stated purpose.
**Correct:** Every view should be based on a named viewpoint. Ask: who is the audience? What decision or concern does this diagram address? This discipline ensures diagrams are useful communication tools, not just pretty pictures.

### 7. Modeling at the Wrong Level of Abstraction
**Mistake:** Drawing 200 Application Components with every microservice, sub-service, and module in an executive Architecture Vision diagram.
**Correct:** Match the level of detail to the audience and phase. A Phase A viewpoint for the CIO should show 5-10 major capability areas. A Phase C viewpoint for the integration team can show individual Application Components and interfaces. Use nesting and aggregation to manage detail.

### 8. Confusing Node and Device
**Mistake:** Using Node and Device interchangeably.
**Correct:** A **Device** is a *physical* hardware resource. A **Node** is more abstract — it can be physical or virtual, and is a general computational host. A virtual machine is best modeled as a Node. A physical rack server is a Device. A Node can be deployed on a Device.

### 9. Incorrect Realization Direction
**Mistake:** Drawing Realization arrows pointing from abstract to concrete (e.g., Business Service → Application Service).
**Correct:** Realization points *from the concrete to the abstract*: Application Service *realizes* Business Service. The arrow means "this element makes the other one real."

---

## Tools for ArchiMate Modeling

| Tool | Cost | Highlights | Best For |
|------|------|------------|----------|
| **Archi** | Free (open source) | Full ArchiMate 3.1 support, HTML export, model exchange (Open Exchange Format), Sketch views | Learning ArchiMate, individual architects, small teams |
| **Sparx Enterprise Architect** | Commercial | Full modeling suite — UML, ArchiMate, BPMN, SysML in one tool. Strong code engineering features. | Organizations needing multi-notation modeling |
| **BiZZdesign HoriZZon** | Enterprise | Cloud-based, collaboration, TOGAF-aligned templates, built-in viewpoint frameworks | Enterprise-scale teams, TOGAF program offices |
| **Avolution ABACUS** | Enterprise | Analytics + modeling, impact analysis, roadmap visualization | Architecture analytics and portfolio management |
| **ADOIT (BOC Group)** | Commercial | EA suite with ArchiMate support, strong TOGAF alignment | Mid-to-large enterprise programs |
| **Modelio** | Free/Commercial | Open-source base with ArchiMate module, UML-primary | Teams familiar with Modelio already |

**Recommendation for learning:** Start with **Archi**. It is free, fully ArchiMate 3.1 compliant, actively maintained, and produces the Open Exchange Format (`.archimate` files) that can be imported into commercial tools later.

---

## Quick Reference: ArchiMate Cheat Sheet

### Which layer does this element belong to?

| You are modeling... | Layer |
|---------------------|-------|
| A business department, team, or person | Business |
| A business process, function, or service | Business |
| A business document, contract, or product | Business |
| A software application or system | Application |
| An API, web service, or application module | Application |
| Stored data, a database schema | Application (Data Object) |
| A server, VM, container | Technology |
| An OS, middleware, database engine (software) | Technology |
| A network, firewall, load balancer | Technology |
| A compiled file, config file, backup | Technology (Artifact) |
| An executive goal or business driver | Motivation |
| A compliance requirement or constraint | Motivation |
| An organizational capability | Strategy |
| A migration project or work package | Implementation |

### Which relationship should I use?

| Situation | Use |
|-----------|-----|
| Component A is made of Component B | Composition |
| Process A uses Service B | Serving |
| Application A reads/writes Data Object B | Access |
| Role A performs Process B | Assignment |
| App Service realizes Business Service | Realization |
| Process A triggers Process B | Triggering |
| Information flows from Process A to Process B | Flow |
| Goal A influences Requirement B | Influence |
| None of the above clearly applies | Association (sparingly) |

---

## Further Reading

- **ArchiMate 3.1 Specification** — The Open Group (free download at opengroup.org)
- **TOGAF and ArchiMate: Using ArchiMate with TOGAF** — The Open Group White Paper
- **Mastering ArchiMate** by Gerben Wierda — comprehensive practitioner reference (3rd edition recommended)
- **The Open Group ArchiMate Forum** — community resources, examples, and certified tools list
- **Archi User Guide** — built into the Archi tool, covers all 3.1 elements with examples
