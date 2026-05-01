# Kubernetes Operators & CRDs - Curriculum

How to extend Kubernetes with custom resources and automation — the building block of cloud-native platforms.

---

## Module 1: CRDs Fundamentals
- [ ] **CRD (Custom Resource Definition)**: define your own resource types
- [ ] **Why**: Kubernetes API is extensible — add domain-specific resources
- [ ] **Example**: `kind: Database`, `kind: KafkaTopic`, `kind: Certificate`
- [ ] **CRD structure**:
  - [ ] `apiVersion`: e.g., `apiextensions.k8s.io/v1`
  - [ ] `group`, `version`, `kind`, `plural`
  - [ ] `scope`: Namespaced or Cluster
  - [ ] OpenAPI schema for validation
- [ ] **Once installed**: use `kubectl` like built-in resources
  - [ ] `kubectl get databases`
  - [ ] `kubectl apply -f mydb.yaml`
- [ ] **Kubernetes API without a controller**: CRDs alone store data, don't do anything

## Module 2: Operators
- [ ] **Operator**: CRD + controller that automates operations for a specific application
- [ ] **Pattern**: encode operational knowledge as software
- [ ] **Operator capability levels** (Red Hat):
  - [ ] L1: Basic install (Deployment)
  - [ ] L2: Seamless upgrades
  - [ ] L3: Full lifecycle (backup, restore)
  - [ ] L4: Deep insights (metrics, alerts)
  - [ ] L5: Auto pilot (auto-tuning, remediation)
- [ ] **Famous operators**:
  - [ ] Prometheus Operator
  - [ ] Cert-Manager
  - [ ] Postgres Operator (Zalando, CrunchyData, CloudNativePG)
  - [ ] Strimzi (Kafka)
  - [ ] Elastic Cloud on Kubernetes (ECK)
- [ ] **Where to find**: OperatorHub.io, ArtifactHub

## Module 3: Controllers & Reconciliation
- [ ] **Controller**: runs a control loop, reconciles actual state with desired state
- [ ] **Desired state** (spec) vs **Actual state** (status)
- [ ] **Reconciliation loop**:
  1. [ ] Observe: watch API server for changes
  2. [ ] Diff: compare desired vs actual
  3. [ ] Act: take action to converge
  4. [ ] Update status
  5. [ ] Repeat
- [ ] **Level-triggered**, not edge-triggered: reacts to current state, not events
- [ ] **Idempotent**: safe to run the same reconcile multiple times
- [ ] **Eventually consistent**: may take multiple reconciles

## Module 4: Building Operators — Operator SDK
- [ ] **Operator SDK** (Red Hat): scaffold and build operators
- [ ] **Three flavors**:
  - [ ] **Go**: full power, best performance (controller-runtime)
  - [ ] **Ansible**: use Ansible playbooks (no Go needed)
  - [ ] **Helm**: Helm charts as operator (simplest)
- [ ] **Commands**:
  - [ ] `operator-sdk init --plugins=go/v4 --domain=example.com`
  - [ ] `operator-sdk create api --group=apps --version=v1 --kind=MyApp`
- [ ] **Generated**: CRD schema, controller scaffolding, Makefile

## Module 5: Kubebuilder
- [ ] **Kubebuilder**: Kubernetes SIG project for building operators in Go
- [ ] **Uses `controller-runtime`**: same as Operator SDK
- [ ] **Project structure**:
  - [ ] `api/v1/`: CRD types (Go structs)
  - [ ] `controllers/`: reconciliation logic
  - [ ] `config/`: manifests
- [ ] **Reconcile function**: the core logic you implement
- [ ] **Commands**:
  - [ ] `kubebuilder init --domain=example.com`
  - [ ] `kubebuilder create api --group=apps --version=v1 --kind=MyApp`
  - [ ] `make install run` — local development
  - [ ] `make deploy` — deploy to cluster

## Module 6: Controller Runtime Patterns
- [ ] **Watch resources**: primary (your CRD) and secondary (Deployments, Services you create)
- [ ] **Owner references**: automatic cleanup of child resources
- [ ] **Finalizers**: run cleanup before deletion
  - [ ] Add finalizer → object can't be deleted until finalizer removed
  - [ ] Controller detects deletion, does cleanup, removes finalizer
- [ ] **Events**: record events visible via `kubectl describe`
- [ ] **Conditions**: standard status pattern (Ready, Progressing, Degraded)
- [ ] **Requeue**: `RequeueAfter` to re-reconcile later
- [ ] **Retries and backoff**: handled by runtime

## Module 7: Validating & Mutating Webhooks
- [ ] **Admission webhooks**: run during object creation/update
- [ ] **Validating webhook**: accept or reject (e.g., enforce naming conventions)
- [ ] **Mutating webhook**: modify object (e.g., inject sidecar container)
- [ ] **Use cases**:
  - [ ] Enforce policies (OPA Gatekeeper, Kyverno)
  - [ ] Inject sidecars (Istio, Linkerd, Vault Agent)
  - [ ] Set defaults
  - [ ] Validate custom resources
- [ ] **Kubebuilder scaffolding**: `kubebuilder create webhook`
- [ ] **TLS**: webhooks must be HTTPS, cert managed by cert-manager often

## Module 8: OLM (Operator Lifecycle Manager)
- [ ] **OLM**: Kubernetes-native operator installer and upgrader
- [ ] **Catalog**: collection of operators with metadata
- [ ] **Subscription**: install and track updates
- [ ] **InstallPlan**: the execution plan
- [ ] **OperatorHub.io**: public catalog
- [ ] **Used by**: OpenShift, vanilla Kubernetes with OLM installed
- [ ] **Benefits**: automated updates, dependency resolution

## Module 9: Common Operator Patterns
- [ ] **State reconciliation**: converge actual to desired
- [ ] **Resource creation**: create child Deployments, Services
- [ ] **Status updates**: reflect real state back to CR
- [ ] **Secret management**: generate and rotate credentials
- [ ] **Day-2 operations**: backup, restore, upgrade, scale
- [ ] **Anti-patterns**:
  - [ ] Don't store state in external DB (use K8s etcd via CRs)
  - [ ] Don't bypass reconcile (use events + watches)
  - [ ] Don't block in reconcile (use goroutines + requeue)

## Module 10: Testing Operators
- [ ] **Unit tests**: test reconcile logic with fake client
- [ ] **Envtest**: run a real API server + etcd for integration tests
- [ ] **End-to-end**: `kind` cluster + apply manifests + assert state
- [ ] **Chaos testing**: kill operator pod, verify recovery
- [ ] **Ginkgo + Gomega**: BDD test framework popular in operator world

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Create a simple CRD and apply instances |
| Module 2 | Install Prometheus Operator, observe custom resources |
| Module 3 | Write pseudocode for a reconcile loop |
| Module 4 | Scaffold a Helm-based operator with Operator SDK |
| Module 5 | Build a Go operator for a simple app with Kubebuilder |
| Module 6 | Add finalizer and owner references to your operator |
| Module 7 | Create a validating webhook to enforce name prefix |
| Module 8 | Install OLM on a cluster, subscribe to an operator from OperatorHub |
| Module 9 | Study the Cert-Manager reconcile loop as a reference |
| Module 10 | Write unit tests with envtest |

## Key Resources
- kubebuilder.io (Kubebuilder book — the definitive guide)
- sdk.operatorframework.io (Operator SDK)
- operatorhub.io (catalog)
- "Programming Kubernetes" — Hausenblas & Schimanski
- "Kubernetes Operators" — Jason Dobies & Joshua Wood
- controller-runtime docs
