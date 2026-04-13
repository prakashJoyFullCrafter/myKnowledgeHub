# IaC Alternatives (Pulumi, Crossplane, OpenTofu) - Curriculum

Beyond Terraform: other ways to manage infrastructure as code.

---

## Module 1: IaC Landscape
- [ ] **Terraform**: declarative HCL, multi-cloud, state-based — most popular
- [ ] **OpenTofu**: open-source fork of Terraform (after BSL license change)
- [ ] **Pulumi**: IaC in real programming languages (TS, Python, Go, .NET, Java)
- [ ] **Crossplane**: Kubernetes-native IaC via CRDs
- [ ] **CDK (AWS)**: TypeScript/Python/Java → CloudFormation
- [ ] **Ansible**: config management + infra (imperative mostly)
- [ ] **Bicep**: Azure DSL, compiles to ARM
- [ ] **CloudFormation**: AWS-only, JSON/YAML
- [ ] **Deployment Manager**: GCP-only
- [ ] **When to pick each**: depends on team skills, cloud, philosophy

## Module 2: OpenTofu
- [ ] **Background**: HashiCorp changed Terraform license to BSL (2023)
- [ ] **OpenTofu**: Linux Foundation hosted fork with full BSD/MPL license
- [ ] **Compatible**: drop-in replacement for most Terraform workflows
- [ ] **Benefits**:
  - [ ] Truly open source (no future license risk)
  - [ ] Community-driven roadmap
  - [ ] Backed by major vendors (Harness, Scalr, Spacelift)
- [ ] **CLI**: `tofu init`, `tofu plan`, `tofu apply` (mostly same as `terraform`)
- [ ] **Migration**: change `terraform` → `tofu`, done
- [ ] **New features**: state encryption, dynamic provider functions
- [ ] **Recommendation**: use OpenTofu for new projects unless you need specific Terraform Cloud features

## Module 3: Pulumi
- [ ] **Philosophy**: IaC in real programming languages
- [ ] **Supported languages**: TypeScript, Python, Go, C#/.NET, Java, YAML
- [ ] **Why languages over DSL**:
  - [ ] Loops, conditionals, functions are natural
  - [ ] Reuse via npm/pip/maven
  - [ ] IDE support (autocomplete, refactoring)
  - [ ] Testing with standard test frameworks
- [ ] **Example** (TypeScript):
  ```typescript
  import * as aws from "@pulumi/aws";
  const bucket = new aws.s3.Bucket("my-bucket", {
    tags: { Environment: "prod" }
  });
  export const bucketName = bucket.id;
  ```
- [ ] **State management**: Pulumi Cloud (free for individuals), self-hosted, or S3/GCS/Azure
- [ ] **Providers**: supports all major clouds + K8s + SaaS
- [ ] **Cross-language**: can import packages from any supported language

## Module 4: Pulumi Specifics
- [ ] **Projects**: logical unit (directory with `Pulumi.yaml`)
- [ ] **Stacks**: instances of a project (dev, staging, prod) with different config
- [ ] **Config**: `pulumi config set key value` — per-stack values
- [ ] **Outputs**: first-class, type-safe, can be referenced across stacks
- [ ] **Automation API**: run Pulumi programmatically (no CLI) — embed in apps
- [ ] **Policy as Code** (CrossGuard): enforce policies in TypeScript/Python
- [ ] **Comparison to Terraform**:
  - [ ] Pulumi: general-purpose languages, better for complex logic
  - [ ] Terraform: simpler for most infrastructure, larger community

## Module 5: Crossplane
- [ ] **Crossplane**: CNCF project, Kubernetes-native IaC
- [ ] **Concept**: manage cloud resources via K8s CRDs
  - [ ] `kind: Bucket` for S3 bucket (CRD)
  - [ ] Same API, gitops, RBAC as everything else in K8s
- [ ] **Control plane abstraction**: build your own "platform API" on top of cloud resources
- [ ] **Components**:
  - [ ] **Providers**: cloud-specific (AWS, GCP, Azure)
  - [ ] **Compositions**: bundle multiple resources as a higher-level abstraction
  - [ ] **Claims**: developer-facing API
- [ ] **Use case**: internal developer platforms where devs request infrastructure via K8s
- [ ] **Example**: define `kind: Database` that creates RDS + subnet + security group + secrets
- [ ] **Why Crossplane**: unified control plane, fit K8s workflows

## Module 6: AWS CDK (Cloud Development Kit)
- [ ] **CDK**: write infra in TypeScript/Python/Java/.NET/Go, compile to CloudFormation
- [ ] **High-level constructs**: L1 (raw), L2 (opinionated), L3 (patterns)
- [ ] **Example** (TypeScript):
  ```typescript
  new ec2.Vpc(this, 'MyVpc', { maxAzs: 3 });
  ```
- [ ] **Benefits**:
  - [ ] AWS-official, deep integration
  - [ ] Good defaults (L2 constructs)
  - [ ] Fast iteration vs raw CloudFormation
- [ ] **Limitations**: AWS-only, coupled to CloudFormation (inherits its limits)
- [ ] **CDKTF**: CDK for Terraform (CDK syntax, Terraform state)
- [ ] **CDK8s**: CDK for Kubernetes (write K8s manifests in TS/Python)

## Module 7: Bicep (Azure)
- [ ] **Bicep**: Azure DSL that compiles to ARM templates
- [ ] **Why Bicep over raw ARM**: much cleaner syntax
- [ ] **Example**:
  ```bicep
  resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: 'mystorage'
    location: 'eastus'
    sku: { name: 'Standard_LRS' }
    kind: 'StorageV2'
  }
  ```
- [ ] **Modules**: reusable Bicep templates
- [ ] **Type safety**: IDE support, validation
- [ ] **Deployed via ARM**: inherits all ARM capabilities
- [ ] **Use case**: Azure-only shops preferring native tools over Terraform

## Module 8: Ansible
- [ ] **Ansible**: configuration management + orchestration + some infra
- [ ] **Imperative/procedural** (not purely declarative)
- [ ] **Agentless**: SSH-based, no daemon
- [ ] **Use cases**:
  - [ ] Server configuration (install packages, configure services)
  - [ ] Application deployment
  - [ ] Orchestration of multi-step operations
- [ ] **Cloud modules**: can provision AWS/GCP/Azure resources, but less common than Terraform
- [ ] **Better for**: config management of existing servers, not greenfield cloud infra
- [ ] **Complementary**: Terraform provisions, Ansible configures

## Module 9: Decision Framework
- [ ] **Team prefers real languages** → Pulumi or CDK
- [ ] **Multi-cloud** → OpenTofu / Terraform / Pulumi
- [ ] **Single cloud (AWS/Azure)** → CDK or Bicep, or Terraform
- [ ] **Kubernetes-centric platform** → Crossplane
- [ ] **Existing Terraform investment** → stay with OpenTofu
- [ ] **Internal Developer Platform** → Crossplane with Compositions
- [ ] **Config management** → Ansible (alongside IaC tool)
- [ ] **License concerns** → OpenTofu over Terraform
- [ ] **Integration**: different teams can use different tools; keep boundaries clean

## Module 10: IaC Best Practices (Tool-Agnostic)
- [ ] **Version control everything**: commit code, not state files
- [ ] **Remote state**: never local for teams
- [ ] **State encryption**
- [ ] **PR-based workflow**: plan → review → apply
- [ ] **Policy as code**: OPA, Sentinel, CrossGuard, Checkov
- [ ] **Small blast radius**: environment/workload isolation
- [ ] **Reproducibility**: pin provider versions
- [ ] **Documentation**: README per module
- [ ] **Cost estimation**: infracost or similar
- [ ] **Drift detection**: alert on out-of-band changes

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare Terraform, Pulumi, Crossplane for same simple setup |
| Module 2 | Migrate a Terraform project to OpenTofu |
| Module 3 | Write a Pulumi program in TypeScript deploying S3 + Lambda |
| Module 4 | Use Pulumi Automation API to programmatically deploy |
| Module 5 | Install Crossplane + AWS provider, define a Composition |
| Module 6 | Build a CDK app for an API (Lambda + API Gateway + DynamoDB) |
| Module 7 | Write Bicep for a simple Azure web app |
| Module 8 | Use Ansible to configure 3 EC2 instances after Terraform provisioning |
| Module 9 | Decide which IaC tool fits your project, justify |
| Module 10 | Apply 5 best practices to an existing IaC codebase |

## Key Resources
- opentofu.org
- pulumi.com/docs
- crossplane.io
- aws.amazon.com/cdk
- learn.microsoft.com/azure/bicep
- ansible.com/documentation
