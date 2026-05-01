# Helm - Curriculum

## Module 1: Helm Fundamentals
- [ ] **Helm**: package manager for Kubernetes
- [ ] **Chart**: Helm package (templates + values + metadata)
- [ ] **Release**: instance of a chart installed in cluster
- [ ] **Repository**: collection of charts (Artifact Hub, private registries)
- [ ] **Helm 3** vs Helm 2: no Tiller (removed), client-side only
- [ ] **Commands**:
  - [ ] `helm install name chart`
  - [ ] `helm upgrade name chart`
  - [ ] `helm rollback name revision`
  - [ ] `helm uninstall name`
  - [ ] `helm list`, `helm history`, `helm status`

## Module 2: Chart Structure
- [ ] **Directory layout**:
  ```
  mychart/
    Chart.yaml         # metadata
    values.yaml        # default values
    charts/            # dependencies
    templates/         # K8s manifest templates
    templates/NOTES.txt
    templates/_helpers.tpl
  ```
- [ ] **`Chart.yaml`**: name, version, appVersion, description, dependencies
- [ ] **Templates**: Kubernetes manifests with Go template syntax
- [ ] **`_helpers.tpl`**: reusable template snippets
- [ ] **`NOTES.txt`**: post-install instructions

## Module 3: Templating
- [ ] **Go template syntax** with Sprig functions
- [ ] **Values**: `{{ .Values.image.repository }}`
- [ ] **Release info**: `{{ .Release.Name }}`, `{{ .Release.Namespace }}`
- [ ] **Chart info**: `{{ .Chart.Version }}`
- [ ] **Conditionals**: `{{- if .Values.ingress.enabled }} ... {{- end }}`
- [ ] **Loops**: `{{- range .Values.replicas }}`
- [ ] **Whitespace control**: `{{-` and `-}}` trim whitespace
- [ ] **Functions**: `default`, `quote`, `toYaml`, `required`, `include`
- [ ] **Template includes**: `{{ include "mychart.labels" . }}`

## Module 4: Values & Overrides
- [ ] **Override methods**:
  - [ ] `--set key=value` (CLI)
  - [ ] `-f custom-values.yaml` (file)
  - [ ] `-f values-prod.yaml -f values-override.yaml` (merged)
- [ ] **Precedence**: `--set` > later `-f` > earlier `-f` > `values.yaml`
- [ ] **Environment files**: `values-dev.yaml`, `values-prod.yaml`
- [ ] **Schema validation**: `values.schema.json`
- [ ] **Required values**: `{{ required "name is required" .Values.name }}`

## Module 5: Dependencies
- [ ] **Subcharts**: charts in `charts/` directory
- [ ] **`Chart.yaml` dependencies**:
  ```yaml
  dependencies:
    - name: postgresql
      version: 12.x
      repository: https://charts.bitnami.com/bitnami
  ```
- [ ] **`helm dependency update`**: fetch into `charts/`
- [ ] **Alias**: deploy same chart multiple times
- [ ] **Conditional dependencies**: `condition: postgresql.enabled`
- [ ] **Override subchart values**: nest under subchart name

## Module 6: Hooks
- [ ] **Hooks**: run jobs at lifecycle points
- [ ] **Hook types**:
  - [ ] `pre-install`, `post-install`
  - [ ] `pre-upgrade`, `post-upgrade`
  - [ ] `pre-delete`, `post-delete`
  - [ ] `test`
- [ ] **Annotation**: `helm.sh/hook: pre-install`
- [ ] **Use cases**: database migrations, CRD installation, smoke tests
- [ ] **Hook weight**: order hooks
- [ ] **Delete policy**: `helm.sh/hook-delete-policy: hook-succeeded`

## Module 7: Testing & Debugging
- [ ] **`helm lint`**: validate chart syntax
- [ ] **`helm template`**: render locally (great for debugging)
- [ ] **`helm install --dry-run --debug`**: simulate install
- [ ] **`helm get manifest release`**: see deployed manifests
- [ ] **`helm diff` plugin**: diff between revisions
- [ ] **`helm test release`**: run test hooks
- [ ] **`helm status release`**: current release state

## Module 8: Repositories & Distribution
- [ ] **`helm repo add name url`**: add repository
- [ ] **Public hubs**: Artifact Hub (artifacthub.io), Bitnami charts
- [ ] **Private repositories**:
  - [ ] ChartMuseum: self-hosted
  - [ ] OCI registries (Helm 3+): Docker Hub, Harbor, ECR
  - [ ] `helm push chart.tgz oci://registry.example.com/charts`
- [ ] **Chart signing**: provenance files, `helm verify`

## Module 9: Helmfile & Multi-Release Management
- [ ] **Helmfile**: manage multiple releases declaratively
- [ ] **Use case**: deploy 10+ charts with config per environment
- [ ] **Alternative**: ArgoCD ApplicationSets

## Module 10: Best Practices & Anti-Patterns
- [ ] **Do**:
  - [ ] Version charts semantically
  - [ ] Pin dependency versions
  - [ ] Use `values.schema.json`
  - [ ] Document values
  - [ ] Test charts with `helm lint` in CI
  - [ ] Use `required` for mandatory values
- [ ] **Don't**:
  - [ ] Hardcode values
  - [ ] Leave huge `values.yaml` undocumented
  - [ ] Complex templates beyond readability
  - [ ] Commit rendered manifests
- [ ] **Helm vs Kustomize**:
  - [ ] Helm: packaging, distribution, templating
  - [ ] Kustomize: overlays, patches, no templating
  - [ ] Combine: Helm chart + Kustomize overlay

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | `helm create mychart`, explore structure |
| Module 3 | Convert static YAML to templated chart |
| Module 4 | Set up values per environment (dev/prod) |
| Module 5 | Add PostgreSQL as dependency |
| Module 6 | Add pre-install hook for DB migration |
| Module 7 | Use `helm template` and `--dry-run` for debugging |
| Module 8 | Push chart to OCI registry |
| Module 9 | Deploy multiple releases with Helmfile |
| Module 10 | Audit a chart for anti-patterns |

## Key Resources
- helm.sh/docs (official)
- artifacthub.io (chart discovery)
- "Learning Helm" — Matt Butcher et al.
- helm-diff plugin
