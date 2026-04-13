# Google Cloud Platform (GCP) - Curriculum

## Module 1: GCP Core Concepts
- [ ] **Organization → Folders → Projects**: hierarchy for billing, IAM, policies
- [ ] **Project**: base unit of resource isolation and billing
- [ ] **Region**: geographic area (us-central1, europe-west1)
- [ ] **Zone**: isolated data center within a region (us-central1-a)
- [ ] **Multi-region**: replicated services (us, eu, asia)
- [ ] **Shared responsibility**: Google secures infra; you secure your apps/data
- [ ] **`gcloud` CLI**: primary interface
- [ ] **Cloud Console**: web UI
- [ ] **Labels**: metadata for organization and cost allocation

## Module 2: Compute
- [ ] **Compute Engine**: VMs (equivalent to EC2)
  - [ ] Machine types: e2, n2, c3, m1 (memory)
  - [ ] Custom machine types
  - [ ] Preemptible VMs / Spot VMs (cheap, interruptible)
  - [ ] Sustained use discounts (automatic)
  - [ ] Committed use discounts (1 or 3 year)
- [ ] **GKE (Google Kubernetes Engine)**: managed Kubernetes
  - [ ] Standard mode: manage nodes
  - [ ] **Autopilot**: fully managed, pay per pod
  - [ ] Native integration with GCP services
- [ ] **Cloud Run**: serverless containers (much simpler than EKS/GKE)
  - [ ] Scale to zero, HTTP-triggered, container-based
  - [ ] Cloud Run Jobs for batch workloads
- [ ] **Cloud Functions**: serverless functions
- [ ] **App Engine**: PaaS (Standard or Flexible)

## Module 3: Storage
- [ ] **Cloud Storage**: object storage (equivalent to S3)
  - [ ] Storage classes: Standard, Nearline, Coldline, Archive
  - [ ] Lifecycle management, versioning
  - [ ] Multi-region and dual-region buckets
  - [ ] Signed URLs for temporary access
- [ ] **Persistent Disks**: block storage for Compute Engine
  - [ ] Standard (HDD), Balanced (gp2 equivalent), SSD, Extreme
- [ ] **Filestore**: managed NFS
- [ ] **Cloud Storage FUSE**: mount buckets as filesystems

## Module 4: Databases
- [ ] **Cloud SQL**: managed MySQL, PostgreSQL, SQL Server
- [ ] **Spanner**: globally distributed, strongly consistent SQL (unique to Google)
  - [ ] Horizontal scaling + relational + ACID
  - [ ] Used by Google Ads, etc.
- [ ] **Firestore**: document database (successor to Datastore)
  - [ ] Serverless, auto-scales
  - [ ] Realtime listeners
- [ ] **Bigtable**: wide-column NoSQL (HBase API)
  - [ ] PB-scale, low latency
  - [ ] Used for analytics, time-series
- [ ] **Memorystore**: managed Redis, Memcached
- [ ] **BigQuery**: serverless data warehouse (see Module 7)
- [ ] **AlloyDB**: PostgreSQL-compatible, cloud-native

## Module 5: Networking
- [ ] **VPC**: global by default (unique to GCP — subnets are regional, VPC is global)
- [ ] **Subnets**: auto or custom mode
- [ ] **Firewall rules**: apply at VPC level by tags/targets
- [ ] **Cloud Load Balancing**:
  - [ ] **Global external HTTP(S) LB**: anycast IP, Global
  - [ ] **Regional external HTTP(S) LB**
  - [ ] **Internal HTTP(S) LB**
  - [ ] **Network LB**: TCP/UDP, regional
- [ ] **Cloud CDN**: integrates with HTTP(S) LB
- [ ] **Cloud DNS**: managed DNS
- [ ] **Cloud Interconnect / VPN**: hybrid connectivity
- [ ] **Private Service Connect**: private access to Google services

## Module 6: IAM & Security
- [ ] **IAM**: roles at organization/folder/project/resource level
  - [ ] Predefined roles, custom roles
  - [ ] Service accounts for workloads
- [ ] **Workload Identity**: GKE pods assume Google service accounts (no long-lived keys)
- [ ] **OIDC federation**: GitHub Actions, etc. without service account keys
- [ ] **Secret Manager**: store secrets, versioning, rotation
- [ ] **KMS**: customer-managed encryption keys
- [ ] **VPC Service Controls**: perimeter for sensitive data
- [ ] **Identity-Aware Proxy (IAP)**: zero-trust access to apps and SSH
- [ ] **Cloud Armor**: WAF and DDoS protection

## Module 7: Data & Analytics
- [ ] **BigQuery**: serverless data warehouse
  - [ ] SQL interface, petabyte scale
  - [ ] Pay per query (scanned data)
  - [ ] Streaming inserts, BigQuery ML
- [ ] **Dataflow**: managed Apache Beam (batch + stream processing)
- [ ] **Pub/Sub**: messaging (see Module 8)
- [ ] **Dataproc**: managed Hadoop/Spark
- [ ] **Composer**: managed Apache Airflow
- [ ] **Looker**: BI tool (acquired)

## Module 8: Messaging
- [ ] **Pub/Sub**: global messaging service
  - [ ] Unique: globally available topics
  - [ ] At-least-once delivery, exactly-once supported
  - [ ] Push or pull subscribers
- [ ] **Eventarc**: event-driven routing (triggers Cloud Run, Cloud Functions, Workflows)
- [ ] **Tasks**: managed task queue
- [ ] **Workflows**: orchestration

## Module 9: Operations (Cloud Operations Suite)
- [ ] **Cloud Monitoring** (Stackdriver): metrics, dashboards, alerts
- [ ] **Cloud Logging**: log aggregation, queries
- [ ] **Cloud Trace**: distributed tracing
- [ ] **Cloud Profiler**: continuous profiler
- [ ] **Error Reporting**: aggregates errors
- [ ] **Cloud Debugger** (deprecated)

## Module 10: Cost Optimization
- [ ] **Sustained use discounts**: automatic for Compute Engine
- [ ] **Committed use discounts**: 1 or 3 year commits
- [ ] **Preemptible VMs**: up to 80% off, 24-hour max lifetime
- [ ] **Autopilot GKE**: pay per pod, no idle nodes
- [ ] **Cloud Run**: scale to zero
- [ ] **BigQuery**: pay per query — optimize queries, partitioning
- [ ] **Recommender API**: cost, security, performance suggestions
- [ ] **Budgets and alerts**

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Launch GKE Autopilot cluster, deploy app |
| Module 3 | Build static site on Cloud Storage + Cloud CDN |
| Module 4 | Migrate PostgreSQL to Cloud SQL |
| Module 5 | Deploy global external HTTP(S) LB for multi-region app |
| Module 6 | Set up Workload Identity for a GKE workload |
| Module 7 | Query BigQuery public datasets |
| Module 8 | Build Pub/Sub → Cloud Run event flow |
| Module 9 | Set up Cloud Monitoring dashboard |
| Module 10 | Find 3 cost optimizations in a real project |

## Key Resources
- cloud.google.com/docs
- Google Cloud Skills Boost (training)
- "Google Cloud Platform for Architects"
- cloud.google.com/architecture (reference architectures)
