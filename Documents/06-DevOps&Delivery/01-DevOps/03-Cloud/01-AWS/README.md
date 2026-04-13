# AWS - Curriculum

## Module 1: AWS Core Concepts
- [ ] **Region**: isolated geographical area (us-east-1, eu-west-1)
- [ ] **Availability Zone (AZ)**: isolated data center within a region (3+ per region typical)
- [ ] **Edge locations**: CloudFront CDN points
- [ ] **Shared responsibility model**: AWS secures cloud; you secure in cloud
- [ ] **Pricing model**: pay-as-you-go, reserved, spot, savings plans
- [ ] **Account structure**: root → IAM users → AWS Organizations (multi-account)
- [ ] **Well-Architected Framework**: 6 pillars (operational excellence, security, reliability, performance, cost, sustainability)

## Module 2: Compute
- [ ] **EC2 (Elastic Compute Cloud)**: virtual machines
  - [ ] Instance types: general, compute-optimized, memory-optimized, GPU
  - [ ] AMI: machine image
  - [ ] User data: startup scripts
  - [ ] Spot instances: up to 90% discount, interruptible
  - [ ] Reserved Instances, Savings Plans: long-term commitment discounts
- [ ] **Lambda**: serverless functions
  - [ ] Cold start vs warm start
  - [ ] Triggers: API Gateway, S3, SQS, DynamoDB Streams, EventBridge
  - [ ] Concurrency limits, provisioned concurrency
- [ ] **ECS (Elastic Container Service)**: container orchestration (simpler than K8s)
- [ ] **EKS (Elastic Kubernetes Service)**: managed Kubernetes
- [ ] **Fargate**: serverless containers for ECS/EKS (no node management)
- [ ] **Elastic Beanstalk**: PaaS for traditional apps (easy but limiting)

## Module 3: Storage
- [ ] **S3 (Simple Storage Service)**: object storage
  - [ ] Buckets, objects, versioning, lifecycle policies
  - [ ] Storage classes: Standard, IA, Glacier, Deep Archive
  - [ ] Access: public, private, pre-signed URLs
  - [ ] Security: bucket policies, ACLs, block public access
  - [ ] Events: trigger Lambda/SQS/SNS on upload
- [ ] **EBS (Elastic Block Store)**: block storage for EC2
  - [ ] Volume types: gp3 (general), io2 (high IOPS), st1 (throughput), sc1 (cold)
  - [ ] Snapshots for backup
- [ ] **EFS (Elastic File System)**: NFS, shared across EC2 instances
- [ ] **FSx**: managed Windows File Server, Lustre, NetApp
- [ ] **Storage Gateway**: hybrid on-prem → cloud

## Module 4: Databases
- [ ] **RDS (Relational Database Service)**: managed SQL databases
  - [ ] Engines: PostgreSQL, MySQL, MariaDB, SQL Server, Oracle, Aurora
  - [ ] Multi-AZ for HA
  - [ ] Read replicas (up to 15)
  - [ ] Automated backups, point-in-time recovery
- [ ] **Aurora**: AWS's MySQL/PostgreSQL-compatible, cloud-native
  - [ ] Up to 128 TB, 15 replicas, auto-scaling storage
  - [ ] Aurora Serverless v2: auto-scale compute
- [ ] **DynamoDB**: managed NoSQL (key-value, document)
  - [ ] Single-digit ms latency, scales to millions of requests/sec
  - [ ] On-demand or provisioned capacity
  - [ ] DynamoDB Streams, Global Tables
- [ ] **ElastiCache**: managed Redis or Memcached
- [ ] **Neptune**: graph database
- [ ] **Timestream**: time-series database
- [ ] **DocumentDB**: MongoDB-compatible
- [ ] **Redshift**: data warehouse (OLAP)

## Module 5: Networking
- [ ] **VPC (Virtual Private Cloud)**: isolated network
  - [ ] CIDR blocks, subnets (public/private)
  - [ ] Internet Gateway, NAT Gateway, VPC Endpoints
  - [ ] Route tables, Network ACLs
  - [ ] VPC peering, Transit Gateway
- [ ] **Subnets**:
  - [ ] Public: has route to Internet Gateway
  - [ ] Private: no direct internet (NAT Gateway for egress)
- [ ] **Security Groups**: stateful firewall for instances (recommended)
- [ ] **NACLs**: stateless firewall for subnets
- [ ] **Load Balancers**:
  - [ ] ALB (Application, Layer 7, HTTP/S)
  - [ ] NLB (Network, Layer 4, TCP/UDP, low latency)
  - [ ] GWLB (Gateway, for security appliances)
  - [ ] CLB (Classic, legacy)
- [ ] **Route 53**: DNS with health checks, geo routing, latency routing
- [ ] **CloudFront**: CDN, integrates with S3, Lambda@Edge
- [ ] **PrivateLink**: private connectivity to AWS services / partner services
- [ ] **Direct Connect / VPN**: hybrid connectivity to on-prem

## Module 6: IAM & Security
- [ ] **IAM (Identity and Access Management)**:
  - [ ] Users, groups, roles
  - [ ] Policies: JSON documents granting permissions
  - [ ] Principle of least privilege
- [ ] **IAM Roles**: preferred for workloads (no long-lived credentials)
  - [ ] EC2 instance profile
  - [ ] EKS IRSA (IAM Roles for Service Accounts)
  - [ ] Lambda execution role
  - [ ] OIDC federation (GitHub Actions without long-lived keys)
- [ ] **Policy types**: managed, customer-managed, inline
- [ ] **Permissions boundaries**: limit max permissions
- [ ] **SCPs (Service Control Policies)**: org-level restrictions
- [ ] **KMS**: key management for encryption
- [ ] **Secrets Manager**: store secrets, auto-rotate
- [ ] **Parameter Store**: config + secrets, free tier
- [ ] **Security Hub**: central security posture
- [ ] **GuardDuty**: threat detection
- [ ] **WAF**: web application firewall
- [ ] **Shield**: DDoS protection

## Module 7: Messaging & Integration
- [ ] **SQS (Simple Queue Service)**: managed message queue
  - [ ] Standard (at-least-once) vs FIFO (exactly-once, ordered)
  - [ ] Dead letter queue support
- [ ] **SNS (Simple Notification Service)**: pub/sub
  - [ ] Fan-out to SQS, Lambda, HTTP, email, SMS
- [ ] **EventBridge**: event bus, rules, cross-account
  - [ ] Integration with SaaS, schema registry
- [ ] **Kinesis**: streaming data (alternatives to Kafka)
  - [ ] Kinesis Data Streams, Firehose, Analytics
- [ ] **MQ**: managed ActiveMQ / RabbitMQ
- [ ] **Step Functions**: workflow orchestration (state machine)

## Module 8: Observability & Operations
- [ ] **CloudWatch**:
  - [ ] Metrics: infrastructure and custom
  - [ ] Logs: log groups, log streams, insights queries
  - [ ] Alarms: trigger on metric thresholds
  - [ ] Dashboards
  - [ ] Synthetics: canary monitoring
- [ ] **X-Ray**: distributed tracing
- [ ] **CloudTrail**: audit log of API calls (critical for compliance)
- [ ] **Config**: resource configuration history and compliance
- [ ] **Systems Manager (SSM)**: patch management, run commands, parameter store
- [ ] **Trusted Advisor**: cost, security, performance recommendations

## Module 9: DevOps & Deployment
- [ ] **CodeCommit**: managed Git
- [ ] **CodeBuild**: build service
- [ ] **CodeDeploy**: deployment automation (EC2, Lambda, ECS)
- [ ] **CodePipeline**: CI/CD orchestration
- [ ] **CloudFormation**: IaC (AWS-native, vs Terraform)
- [ ] **CDK (Cloud Development Kit)**: IaC in real code (TypeScript, Python, Java)
- [ ] **Beanstalk, Amplify**: opinionated platforms

## Module 10: Cost Optimization
- [ ] **Cost Explorer**: analyze spending
- [ ] **Budgets**: set alerts on cost thresholds
- [ ] **Savings Plans / RIs**: commit for 1-3 years, save up to 72%
- [ ] **Spot instances**: up to 90% off for interruptible workloads
- [ ] **Right-sizing**: Compute Optimizer recommendations
- [ ] **S3 Intelligent-Tiering**: auto-move to cheaper storage
- [ ] **Shut down non-prod**: stop EC2/RDS nights and weekends
- [ ] **Tagging**: cost allocation by project/team
- [ ] **Trusted Advisor**: cost optimization checks

## Module 11: Well-Architected Framework
- [ ] **Six pillars**:
  - [ ] **Operational Excellence**: operations as code, frequent small changes, learn from failure
  - [ ] **Security**: least privilege, encryption, defense in depth
  - [ ] **Reliability**: horizontal scaling, test recovery, automate
  - [ ] **Performance Efficiency**: use right resources, monitor
  - [ ] **Cost Optimization**: measure, right-size, managed services
  - [ ] **Sustainability**: minimize environmental impact
- [ ] **Review tool**: AWS Well-Architected Tool in console
- [ ] **Lenses**: specialized guidance (serverless, SaaS, ML)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Launch EC2 instance, deploy a simple app |
| Module 3 | Build S3 + CloudFront static site |
| Module 4 | Migrate app from RDS MySQL to Aurora |
| Module 5 | Design VPC with public + private subnets, NAT Gateway |
| Module 6 | Set up IAM roles for a multi-service app with least privilege |
| Module 7 | Build event-driven flow: API → SQS → Lambda → DynamoDB |
| Module 8 | Set up CloudWatch dashboard + alarms for an app |
| Module 9 | Build CodePipeline: GitHub → Build → ECS deploy |
| Module 10 | Analyze current spend, identify 3 cost optimizations |
| Module 11 | Run Well-Architected review against an existing workload |

## Key Resources
- aws.amazon.com/documentation
- "AWS Well-Architected" (free whitepapers)
- A Cloud Guru / Cloud Academy training
- aws.amazon.com/training/
- aws.github.io/aws-sdk-go-v2/ (SDK docs)
