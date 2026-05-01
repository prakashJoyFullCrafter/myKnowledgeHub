# CI/CD Templates - Curriculum

Reusable, centrally-maintained pipeline definitions that every service inherits - golden path for build & deploy.

## Topics
- [ ] Problem: every team copying YAML, drifting, missing security steps
- [ ] **GitHub Actions reusable workflows** (`workflow_call`)
- [ ] **GitHub Actions composite actions** for shared steps
- [ ] **GitLab CI `include:` and `extends:`** for shared pipelines
- [ ] **Azure DevOps templates** (`extends`, `template`)
- [ ] **Jenkins shared libraries** (Groovy)
- [ ] **Tekton** task & pipeline catalog
- [ ] **Argo Workflows** templates
- [ ] What a standard CI template includes:
  - [ ] Lint
  - [ ] Build
  - [ ] Unit tests with coverage gates
  - [ ] SAST (CodeQL, Semgrep, Snyk Code)
  - [ ] Dependency scan (Snyk, Dependabot, OWASP DC)
  - [ ] Container build with multi-stage
  - [ ] Container scan (Trivy, Grype)
  - [ ] SBOM generation (Syft, Trivy)
  - [ ] Artifact signing (Cosign / Sigstore)
  - [ ] Publish to registry
- [ ] What a standard CD template includes:
  - [ ] Promote across envs (dev → staging → prod)
  - [ ] Manual approval gates
  - [ ] Progressive delivery (canary, blue/green)
  - [ ] Auto-rollback on SLO violation
- [ ] **GitOps integration** (Argo CD, Flux) - CI builds + commits manifests, CD pulls
- [ ] Versioning templates: pinning vs `@main`
- [ ] Secrets in pipelines: OIDC federation (no long-lived keys)
- [ ] Test environments / ephemeral preview environments per PR
- [ ] Measuring lead time and DORA metrics from pipeline data
