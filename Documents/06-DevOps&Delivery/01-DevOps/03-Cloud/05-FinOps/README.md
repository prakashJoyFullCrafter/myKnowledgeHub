# FinOps & Cost Optimization - Curriculum

Cloud cost is now an engineering responsibility, not just a finance one.

---

## Module 1: FinOps Fundamentals
- [ ] **FinOps**: Financial Operations — bringing financial accountability to cloud spending
- [ ] **Three phases**: Inform → Optimize → Operate (continuous cycle)
- [ ] **Cloud cost is variable**: pay-as-you-go means engineering decisions = financial decisions
- [ ] **Distributed accountability**: every team owns its cloud spend
- [ ] **FinOps Foundation**: industry org, FinOps Framework, certifications
- [ ] Engineering culture shift: "is this expensive?" alongside "is this fast?"

## Module 2: Cost Visibility & Tagging
- [ ] **Resource tagging strategy**: every resource tagged with owner, environment, project, cost-center
- [ ] **Mandatory tags**: enforce via IaC + policies (AWS Service Control Policies, GCP Org Policy)
- [ ] **Cost allocation**: split shared resource costs across teams via tags
- [ ] **Untagged resources report**: catch resources without ownership
- [ ] **AWS Cost Explorer**: visualize spend, group by tag, filter by service
- [ ] **AWS Budgets**: set thresholds, alert when exceeded
- [ ] **GCP Cost Management**: similar capabilities for GCP
- [ ] **Azure Cost Management**: Azure native
- [ ] **Multi-cloud tools**: CloudHealth, Cloudability, Vantage, OpenCost

## Module 3: Compute Cost Optimization
- [ ] **Right-sizing**: match instance size to actual usage
  - [ ] Look at CPU/memory utilization metrics, downsize if low
  - [ ] AWS Compute Optimizer, GCP Recommender — automated recommendations
- [ ] **Spot / Preemptible instances**: 70-90% cheaper, but can be terminated anytime
  - [ ] Use for: batch jobs, CI runners, stateless workloads, fault-tolerant systems
  - [ ] Don't use for: stateful databases, single-instance services
- [ ] **Reserved Instances / Savings Plans**: commit 1-3 years for 30-70% discount
  - [ ] Standard RIs vs Convertible RIs
  - [ ] Compute Savings Plans (more flexible than RIs)
  - [ ] Reservations as financial instruments — analyze utilization
- [ ] **Auto-scaling**: scale down at night, weekends, low traffic
- [ ] **Serverless** (Lambda, Cloud Run): pay per invocation, no idle cost
  - [ ] Cold start trade-off vs always-on cost
- [ ] **Graviton (ARM) instances**: 20-40% cheaper for compatible workloads (AWS)

## Module 4: Storage Cost Optimization
- [ ] **S3 storage classes**: Standard, Infrequent Access, Glacier, Glacier Deep Archive
  - [ ] Lifecycle policies: auto-transition to cheaper tier after N days
  - [ ] Intelligent-Tiering: automatic optimization
- [ ] **EBS optimization**: gp3 vs gp2 (gp3 is cheaper + faster), delete unused volumes
- [ ] **Snapshots cleanup**: automate retention policy, don't keep forever
- [ ] **Database storage**: archive old data, use partitioning to drop old partitions
- [ ] **Log retention**: don't keep all logs forever — define policies (hot, warm, cold, delete)
- [ ] **Compression**: gzip/zstd before storing — reduces storage and transfer costs

## Module 5: Network & Data Transfer Costs
- [ ] **Data transfer is expensive**: cross-region, cross-AZ, cross-internet all cost
- [ ] **Same-region, same-AZ**: free (mostly)
- [ ] **Cross-AZ data transfer**: $0.01/GB each way — adds up at scale
- [ ] **Egress to internet**: $0.05-0.09/GB — biggest hidden cost
- [ ] **NAT Gateway**: $0.045/hr + $0.045/GB processed — surprisingly expensive
- [ ] **VPC Endpoints**: avoid NAT Gateway costs for AWS services
- [ ] **CloudFront / CDN**: cheaper egress + cached requests
- [ ] **Direct Connect**: dedicated connection for predictable, high-volume traffic
- [ ] **Audit data transfer**: VPC Flow Logs, identify unexpected egress

## Module 6: Architectural Cost Patterns
- [ ] **Cache aggressively**: every cache hit avoids backend cost
- [ ] **Async over sync**: SQS for buffering vs always-on workers
- [ ] **Multi-tenant SaaS**: shared infrastructure vs per-tenant — depends on scale
- [ ] **Containers over VMs**: better resource utilization
- [ ] **K8s bin packing**: schedule pods efficiently to minimize node count
- [ ] **Avoid over-engineering**: don't multi-region until you need it
- [ ] **Delete unused resources**: forgotten dev/staging environments are major waste
- [ ] **Cleanup automation**: stop dev environments at night, scheduled lambda for cleanup

## Module 7: FinOps in Practice
- [ ] **Showback vs Chargeback**: showback (visibility) → chargeback (actual cost allocation to teams)
- [ ] **Cost as a metric**: track in dashboards alongside performance/reliability
- [ ] **Budget alerts**: notify when spend approaches or exceeds threshold
- [ ] **Anomaly detection**: AWS Cost Anomaly Detection, alerts on unusual spikes
- [ ] **FinOps reviews**: monthly cost review meeting with engineering teams
- [ ] **Cost in PR reviews**: estimate cost impact of new infrastructure changes
- [ ] **Infracost**: estimates cost from Terraform plan in PRs
- [ ] **Engineer training**: every engineer should understand basic cost drivers

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Audit AWS account: untagged resources, top 10 cost drivers |
| Module 3 | Right-size 5 over-provisioned EC2 instances using Compute Optimizer |
| Module 4 | Set up S3 lifecycle policy: Standard → IA after 30 days → Glacier after 90 days |
| Module 5 | Replace NAT Gateway with VPC Endpoints for S3/DynamoDB |
| Module 6 | Add scheduled stop/start for dev environments outside business hours |
| Module 7 | Set up Infracost in PR pipeline to show cost impact of changes |

## Key Resources
- **FinOps Foundation** (finops.org) — framework, training, certification
- **"Cloud FinOps"** - J.R. Storment & Mike Fuller (the book)
- AWS Well-Architected Cost Optimization Pillar
- GCP Cost Optimization documentation
- Infracost (infracost.io)
- OpenCost (opencost.io) — Kubernetes cost monitoring
