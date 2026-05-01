# Microsoft Azure - Curriculum

## Module 1: Azure Core Concepts
- [ ] **Management hierarchy**: Management Group → Subscription → Resource Group → Resource
- [ ] **Subscription**: billing + isolation boundary
- [ ] **Resource Group**: logical container for related resources
- [ ] **Region**: geographic area, grouped into **geographies** for data residency
- [ ] **Availability Zones**: within a region
- [ ] **Azure AD / Microsoft Entra ID**: identity (now renamed)
- [ ] **CLI**: `az` command-line tool
- [ ] **Azure Portal**: web UI
- [ ] **ARM (Azure Resource Manager)**: underlying API for all resources
- [ ] **Tags**: metadata for organization and billing

## Module 2: Compute
- [ ] **Virtual Machines (VMs)**: IaaS (like EC2)
  - [ ] VM series: B (burstable), Dv5 (general), Ev5 (memory), F (compute)
  - [ ] Spot VMs (cheap, interruptible)
  - [ ] Reserved Instances, Savings Plans
- [ ] **Azure Kubernetes Service (AKS)**: managed Kubernetes
- [ ] **App Service**: PaaS for web apps (like Beanstalk)
- [ ] **Azure Functions**: serverless functions
- [ ] **Container Apps**: serverless containers (Knative-based)
- [ ] **Container Instances (ACI)**: single containers (simpler)
- [ ] **Service Fabric**: Microsoft's microservices platform (legacy)
- [ ] **Azure Batch**: HPC/batch workloads

## Module 3: Storage
- [ ] **Storage Accounts**: top-level container for multiple storage types
- [ ] **Blob Storage**: object storage (like S3)
  - [ ] Tiers: Hot, Cool, Cold, Archive
  - [ ] Lifecycle management
  - [ ] SAS (Shared Access Signatures) for temp access
- [ ] **Files**: managed file share (SMB, NFS)
- [ ] **Queue Storage**: simple message queue
- [ ] **Table Storage**: simple NoSQL (mostly superseded by Cosmos DB)
- [ ] **Managed Disks**: block storage for VMs
  - [ ] SKUs: Standard HDD, Standard SSD, Premium SSD, Ultra Disk
- [ ] **Data Lake Storage Gen2**: Blob + hierarchical namespace for analytics

## Module 4: Databases
- [ ] **Azure SQL Database**: managed SQL Server
  - [ ] Deployment: single, elastic pool, managed instance, hyperscale
- [ ] **Azure Database for PostgreSQL, MySQL, MariaDB**: managed open source
- [ ] **Cosmos DB**: globally distributed multi-model database
  - [ ] APIs: SQL, MongoDB, Cassandra, Gremlin, Table
  - [ ] 5 consistency levels
  - [ ] Multi-region writes
- [ ] **Azure Cache for Redis**: managed Redis
- [ ] **Azure Synapse Analytics**: data warehouse (formerly SQL DW)
- [ ] **Azure Database for PostgreSQL Hyperscale (Citus)**: sharded PostgreSQL

## Module 5: Networking
- [ ] **Virtual Network (VNet)**: isolated network
- [ ] **Subnets**: within VNet
- [ ] **Network Security Groups (NSGs)**: firewall rules on subnets and NICs
- [ ] **Application Security Groups (ASGs)**: grouping for NSG rules
- [ ] **Load Balancers**:
  - [ ] **Azure Load Balancer**: L4, regional
  - [ ] **Application Gateway**: L7, WAF capability
  - [ ] **Front Door**: global L7, CDN, WAF
  - [ ] **Traffic Manager**: DNS-based routing
- [ ] **CDN**: Azure CDN, Front Door
- [ ] **DNS**: Azure DNS
- [ ] **Private Link, Service Endpoints**: private access to PaaS
- [ ] **ExpressRoute, VPN Gateway**: hybrid connectivity

## Module 6: Identity & Security
- [ ] **Microsoft Entra ID (formerly Azure AD)**: identity provider
  - [ ] Users, groups, service principals
  - [ ] Tenant = Entra ID instance (not the same as subscription)
- [ ] **RBAC**: role-based access control on resources
  - [ ] Owner, Contributor, Reader, custom roles
  - [ ] Scope: management group / subscription / resource group / resource
- [ ] **Managed Identities**: workload identities (no credentials in code)
  - [ ] System-assigned or user-assigned
- [ ] **Service principals**: app identities for non-managed-identity scenarios
- [ ] **Key Vault**: secrets, keys, certificates
  - [ ] Integrates with Managed Identities
- [ ] **Defender for Cloud**: security posture, recommendations
- [ ] **Sentinel**: SIEM / SOAR
- [ ] **Azure Firewall**: managed firewall service
- [ ] **DDoS Protection**: standard tier available

## Module 7: Messaging & Integration
- [ ] **Service Bus**: enterprise messaging (queues, topics)
- [ ] **Event Hubs**: big data event ingestion (Kafka-compatible protocol)
- [ ] **Event Grid**: event routing (like EventBridge)
- [ ] **Storage Queues**: simple queues
- [ ] **Logic Apps**: workflow orchestration (visual designer, low-code)
- [ ] **Durable Functions**: stateful workflows in Functions

## Module 8: DevOps & Deployment
- [ ] **Azure DevOps**: full suite
  - [ ] Boards (issue tracking)
  - [ ] Repos (Git)
  - [ ] Pipelines (CI/CD)
  - [ ] Test Plans
  - [ ] Artifacts
- [ ] **GitHub Actions**: also widely used on Azure (Microsoft owns GitHub)
- [ ] **ARM templates**: native IaC (JSON)
- [ ] **Bicep**: modern DSL for ARM (simpler than raw JSON)
- [ ] **Terraform**: widely used on Azure
- [ ] **Deployment Slots**: blue-green for App Service

## Module 9: Observability
- [ ] **Azure Monitor**: umbrella for metrics, logs, alerts
- [ ] **Log Analytics**: query logs (KQL - Kusto Query Language)
- [ ] **Application Insights**: APM (part of Azure Monitor)
  - [ ] Auto-instrumentation for .NET, Java, Node, Python
  - [ ] Distributed tracing, dependency map
- [ ] **Workbooks**: custom dashboards
- [ ] **Alerts**: metric, log, activity log
- [ ] **Action Groups**: notification targets (email, SMS, webhook, Logic App)

## Module 10: Cost Management
- [ ] **Cost Management + Billing**: analysis and reports
- [ ] **Budgets and alerts**
- [ ] **Azure Advisor**: cost optimization recommendations
- [ ] **Reservations**: 1 or 3 year commit, up to 72% savings
- [ ] **Spot VMs**: up to 90% off
- [ ] **Dev/Test pricing**: discounted for non-prod subscriptions
- [ ] **Hybrid Benefit**: use existing Windows Server / SQL Server licenses

## Module 11: Unique to Azure
- [ ] **Enterprise integration**: deep AD/Office 365 integration
- [ ] **Hybrid cloud**: Azure Arc (manage on-prem K8s, servers, SQL as Azure resources)
- [ ] **Stack**: Azure Stack (on-prem Azure)
- [ ] **GPU support**: wide selection including NDv5 (H100)
- [ ] **Data sovereignty**: Azure Government, Azure China (separate clouds)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Deploy VM to Azure, configure NSG |
| Module 3 | Set up Blob Storage with lifecycle policy |
| Module 4 | Migrate SQL Server to Azure SQL Database |
| Module 5 | Deploy app behind Application Gateway with WAF |
| Module 6 | Use Managed Identity to access Key Vault from VM |
| Module 7 | Build event-driven flow: Event Grid → Function |
| Module 8 | Build CI/CD pipeline with Azure DevOps |
| Module 9 | Instrument app with Application Insights, explore in portal |
| Module 10 | Set up budget with alert, find 3 cost optimizations |

## Key Resources
- learn.microsoft.com/azure
- Microsoft Learn (free training paths)
- "Azure for Architects" — Ritesh Modi
- "Cloud Adoption Framework" (Microsoft)
