# Terraform (Infrastructure as Code) - Curriculum

## Module 1: IaC Fundamentals
- [ ] **Infrastructure as Code**: define infrastructure in version-controlled code
- [ ] **Benefits**: reproducibility, auditability, collaboration, automation
- [ ] **Imperative vs declarative**:
  - [ ] Imperative (scripts): how to get there
  - [ ] Declarative (Terraform): desired state
- [ ] **IaC tools landscape**:
  - [ ] **Terraform** (HashiCorp): declarative, multi-cloud, most popular
  - [ ] **OpenTofu**: open-source fork after Terraform license change (BSL)
  - [ ] **Pulumi**: IaC in real programming languages (TS, Python, Go)
  - [ ] **Crossplane**: Kubernetes-native IaC
  - [ ] **CloudFormation**: AWS-only
  - [ ] **Ansible**: config management (imperative, focused on configuration)
- [ ] **Terraform vs OpenTofu**: OpenTofu recommended for new projects (license freedom)

## Module 2: Core Concepts
- [ ] **Providers**: plugins for cloud APIs (aws, azurerm, google, kubernetes, random, tls)
- [ ] **Resources**: infrastructure objects (`aws_instance`, `aws_s3_bucket`)
- [ ] **Data sources**: read existing infrastructure (`data "aws_vpc" "default"`)
- [ ] **Variables**: input parameters
- [ ] **Outputs**: return values from module
- [ ] **Locals**: intermediate named values
- [ ] **Expressions**: conditionals, loops, string interpolation
- [ ] **Functions**: built-in (concat, lookup, file, format, etc.)
- [ ] **Meta-arguments**:
  - [ ] `count`: create N copies
  - [ ] `for_each`: create per-element from map/set
  - [ ] `depends_on`: explicit dependency
  - [ ] `lifecycle`: prevent_destroy, create_before_destroy, ignore_changes

## Module 3: HCL Language Basics
- [ ] **Block syntax**:
  ```hcl
  resource "aws_instance" "web" {
    ami           = "ami-123"
    instance_type = "t3.micro"
    tags = { Name = "web-server" }
  }
  ```
- [ ] **Variable definition and usage**:
  ```hcl
  variable "region" {
    type    = string
    default = "us-east-1"
  }
  provider "aws" { region = var.region }
  ```
- [ ] **Interpolation**: `"${var.name}-${var.env}"`
- [ ] **For expressions**: `[for s in var.list : upper(s)]`
- [ ] **Conditional**: `var.enabled ? 1 : 0`
- [ ] **Splat expressions**: `aws_instance.web[*].id`

## Module 4: Terraform Workflow
- [ ] **`terraform init`**: download providers, initialize backend
- [ ] **`terraform plan`**: preview changes (diff)
- [ ] **`terraform apply`**: execute plan (prompts for approval)
- [ ] **`terraform destroy`**: tear down all managed resources
- [ ] **`terraform validate`**: syntax check
- [ ] **`terraform fmt`**: format code
- [ ] **`terraform show`**: current state
- [ ] **`terraform import`**: bring existing resource under management
- [ ] **Plan files**: `terraform plan -out=plan.tfplan` then `terraform apply plan.tfplan`
  - [ ] Predictable, auditable, safer in CI

## Module 5: State Management
- [ ] **What is state?**: JSON file mapping Terraform resources to real infrastructure IDs
- [ ] **Why state matters**: tracks managed resources, performance cache, dependency resolution
- [ ] **Default**: local `terraform.tfstate` file (NOT for teams)
- [ ] **Remote state backends**:
  - [ ] **S3** + DynamoDB for locking (AWS)
  - [ ] **GCS** (Google Cloud Storage)
  - [ ] **Azure Blob Storage**
  - [ ] **Terraform Cloud / Enterprise**
- [ ] **State locking**: prevents concurrent writes
- [ ] **State sensitivity**: contains secrets in plaintext — encrypt at rest, restrict access
- [ ] **`terraform state` commands**: list, show, mv, rm, pull, push
- [ ] **State manipulation** (advanced, dangerous):
  - [ ] `terraform state mv` — rename resources without recreation
  - [ ] `terraform state rm` — stop managing without destroying
  - [ ] `terraform import` — bring existing under management

## Module 6: Modules
- [ ] **Module**: reusable bundle of Terraform code
- [ ] **Module structure**: `main.tf`, `variables.tf`, `outputs.tf`, `README.md`
- [ ] **Calling a module**:
  ```hcl
  module "vpc" {
    source = "./modules/vpc"
    cidr   = "10.0.0.0/16"
  }
  ```
- [ ] **Module sources**:
  - [ ] Local path: `"./modules/vpc"`
  - [ ] Terraform Registry: `"terraform-aws-modules/vpc/aws"`
  - [ ] Git: `"git::https://github.com/org/repo.git//modules/vpc?ref=v1.0.0"`
- [ ] **Module versioning**: pin versions for stability
- [ ] **Composition over inheritance**: compose small, focused modules
- [ ] **Registry modules**: community-maintained (terraform-aws-modules/*)

## Module 7: Workspaces & Multi-Environment
- [ ] **Terraform workspaces**: multiple state files for same config
- [ ] **Limitation**: same code, may need env-specific variations
- [ ] **Alternative: directory-per-environment**:
  ```
  environments/
    dev/
      main.tf
      terraform.tfvars
    prod/
      main.tf
      terraform.tfvars
  modules/
  ```
- [ ] **Most teams prefer directory-per-environment** — clearer, more flexible
- [ ] **Variable files**: `-var-file=prod.tfvars`
- [ ] **Auto-loaded**: `terraform.tfvars`, `*.auto.tfvars`

## Module 8: Providers Deep Dive
- [ ] **Provider versioning** (critical for stability):
  ```hcl
  terraform {
    required_providers {
      aws = { source = "hashicorp/aws", version = "~> 5.0" }
    }
    required_version = ">= 1.5.0"
  }
  ```
- [ ] **Multiple provider instances** (alias): multi-region deployments
- [ ] **Provider authentication**:
  - [ ] Env vars: `AWS_ACCESS_KEY_ID`, `AWS_REGION`
  - [ ] Shared credentials file
  - [ ] IAM roles (preferred for EC2, CI/CD)
  - [ ] OIDC federation (GitHub Actions, GitLab)

## Module 9: Secrets & Sensitive Data
- [ ] **`sensitive = true`**: hides value in plan/apply output
- [ ] **NEVER commit**: `*.tfstate`, `*.tfvars` with secrets, `.terraform/`
- [ ] **Secrets management integration**:
  - [ ] AWS Secrets Manager / Parameter Store via data source
  - [ ] Vault provider: `data "vault_generic_secret"`
  - [ ] Environment variables: `TF_VAR_db_password`
- [ ] **State encryption**: enable at backend level (S3 SSE, KMS)

## Module 10: Testing Terraform
- [ ] **Validation**: `terraform validate`, `terraform fmt -check`
- [ ] **Static analysis**:
  - [ ] `tflint`: lint for AWS, Azure, GCP
  - [ ] `tfsec`: security scanner
  - [ ] `checkov`: policy-as-code scanner
  - [ ] `terrascan`: compliance checks
- [ ] **Unit tests**: `terraform test` (since 1.6) — `.tftest.hcl` files
- [ ] **Integration tests**: `terratest` (Go), `kitchen-terraform`
- [ ] **Cost estimation**: `infracost`
- [ ] **Drift detection**: `terraform plan` shows drift from real state

## Module 11: CI/CD for Terraform
- [ ] **Pipeline stages**:
  1. [ ] `fmt` and `validate`
  2. [ ] `tflint`, `tfsec`, `checkov`
  3. [ ] `terraform plan` (save plan artifact)
  4. [ ] Manual approval (for production)
  5. [ ] `terraform apply` with saved plan
- [ ] **Plan on PR**: post plan output as PR comment
- [ ] **Tools**: GitHub Actions, GitLab CI, Atlantis, Spacelift
- [ ] **Terraform Cloud**: managed CI/CD with policy enforcement
- [ ] **Best practices**:
  - [ ] Separate state per environment
  - [ ] Use OIDC for cloud credentials (no long-lived secrets)
  - [ ] Require PR approval for production applies

## Module 12: Advanced Patterns
- [ ] **Lifecycle rules**:
  - [ ] `create_before_destroy = true` — avoid downtime on replacement
  - [ ] `prevent_destroy = true` — safety net for critical resources
  - [ ] `ignore_changes = [tags]` — allow external management
  - [ ] `replace_triggered_by` — force replacement on upstream change
- [ ] **Dynamic blocks**: generate nested blocks from data
- [ ] **Null resource**: trigger provisioners without a real resource
- [ ] **Provisioners**: `local-exec`, `remote-exec` — use sparingly
- [ ] **`moved` block** (1.1+): rename resources without state surgery
- [ ] **`check` block** (1.5+): post-deploy validation assertions

## Module 13: Best Practices & Anti-Patterns
- [ ] **Do**: version pin, remote state with locking, separate state per env, small modules, validate in CI, OIDC credentials, cost estimation
- [ ] **Don't**: edit state manually, commit state/secrets, local state in teams, apply without reviewing plan, massive monolithic configs, hardcode credentials, auto-apply to production without review

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare Terraform, Pulumi, CloudFormation for a simple setup |
| Modules 2-3 | Write Terraform for a VPC + EC2 + S3 bucket |
| Module 4 | Full workflow: init → plan → apply → destroy |
| Module 5 | Migrate local state to S3 backend with DynamoDB locking |
| Module 6 | Extract VPC into a reusable module |
| Module 7 | Set up directory-per-environment structure |
| Module 8 | Configure multi-region provider aliases |
| Module 9 | Integrate Vault for DB password injection |
| Module 10 | Run `tfsec` and `checkov`, fix findings |
| Module 11 | Set up GitHub Actions CI/CD with plan-on-PR |
| Module 12 | Use dynamic blocks for security group rules |
| Module 13 | Audit a Terraform codebase against best practices |

## Key Resources
- terraform.io/docs (official)
- "Terraform: Up & Running" — Yevgeniy Brikman
- Terraform Registry (registry.terraform.io)
- terraform-aws-modules GitHub organization
- OpenTofu project (opentofu.org)
- HashiCorp Learn Terraform
