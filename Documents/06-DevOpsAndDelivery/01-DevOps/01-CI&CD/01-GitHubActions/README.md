# GitHub Actions - Curriculum

## Module 1: Fundamentals
- [ ] **GitHub Actions**: CI/CD built into GitHub
- [ ] **Workflow**: YAML file in `.github/workflows/`
- [ ] **Components**:
  - [ ] **Event**: triggers workflow (push, PR, schedule, manual)
  - [ ] **Job**: group of steps that run on a runner
  - [ ] **Step**: command or action (reusable unit)
  - [ ] **Action**: reusable piece of code (marketplace or custom)
  - [ ] **Runner**: machine executing the job
- [ ] **Workflow skeleton**:
  ```yaml
  name: CI
  on: [push, pull_request]
  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - run: npm test
  ```

## Module 2: Events & Triggers
- [ ] **Push/PR triggers**:
  - [ ] `on: push` — all branches
  - [ ] `on: pull_request` — PR events
  - [ ] `branches`, `branches-ignore`, `paths`, `paths-ignore` filters
- [ ] **Schedule**: `on: schedule` with cron syntax
- [ ] **Manual**: `on: workflow_dispatch` (with inputs)
- [ ] **External**: `on: repository_dispatch` — triggered via API
- [ ] **Workflow chaining**: `on: workflow_run` — run after another workflow
- [ ] **Release events**: `on: release`
- [ ] **Common filters**: tags, paths, branches
- [ ] **Concurrency**: `concurrency: group` to cancel in-progress runs

## Module 3: Jobs, Steps & Runners
- [ ] **Jobs run in parallel by default**
- [ ] **Job dependencies**: `needs: [job1, job2]`
- [ ] **Conditional jobs**: `if: github.event_name == 'push'`
- [ ] **Runners**:
  - [ ] **GitHub-hosted**: `ubuntu-latest`, `windows-latest`, `macos-latest`
  - [ ] **Self-hosted**: your own machines (labels)
  - [ ] **Larger runners**: paid, more CPU/RAM
- [ ] **Matrix builds**: run job with multiple configurations
  ```yaml
  strategy:
    matrix:
      java: [11, 17, 21]
      os: [ubuntu-latest, windows-latest]
  ```
- [ ] **Fail-fast**: cancel matrix on first failure (default true)
- [ ] **Step outputs**: pass data between steps

## Module 4: Actions Marketplace
- [ ] **Using actions**: `uses: owner/repo@version`
- [ ] **Version pinning**:
  - [ ] Tag: `@v4` (mutable)
  - [ ] Commit SHA: `@a1b2c3d` (immutable, recommended for security)
- [ ] **Essential actions**:
  - [ ] `actions/checkout@v4` — clone repo
  - [ ] `actions/setup-node@v4`, `setup-java@v4`, `setup-python@v5`
  - [ ] `actions/cache@v4` — dependency caching
  - [ ] `actions/upload-artifact@v4`, `download-artifact@v4`
  - [ ] `docker/build-push-action@v5`
- [ ] **Security**: pin to SHA to prevent supply chain attacks
- [ ] **Marketplace**: marketplace.github.com/actions

## Module 5: Secrets & Environment Variables
- [ ] **Secrets storage**:
  - [ ] Repository secrets
  - [ ] Environment secrets (per env)
  - [ ] Organization secrets
- [ ] **Usage**: `${{ secrets.DB_PASSWORD }}`
- [ ] **Environment variables**: `env:` at workflow, job, or step level
- [ ] **Context**: `${{ github.* }}`, `${{ runner.* }}`, `${{ env.* }}`
- [ ] **Masking**: secrets automatically masked in logs
- [ ] **Never print secrets** to logs — use `add-mask` if manipulated

## Module 6: Caching & Artifacts
- [ ] **Cache dependencies** (speed up builds):
  ```yaml
  - uses: actions/cache@v4
    with:
      path: ~/.m2
      key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
  ```
- [ ] **Language-specific caches**: `setup-java` with `cache: maven` (simpler)
- [ ] **Artifacts**: share files between jobs
  - [ ] `actions/upload-artifact`: save files
  - [ ] `actions/download-artifact`: retrieve in another job
- [ ] **Retention**: artifacts expire (default 90 days)

## Module 7: Reusable Workflows & Composite Actions
- [ ] **Reusable workflow**: callable from other workflows
  - [ ] `on: workflow_call` + inputs + secrets
  - [ ] Call: `uses: org/repo/.github/workflows/build.yml@main`
- [ ] **Composite action**: multiple steps as one action
  - [ ] `action.yml` with `runs.using: composite`
  - [ ] Package and reuse across repos
- [ ] **DRY across repos**: centralize shared CI logic
- [ ] **Versioning**: tag or branch for stable consumers

## Module 8: Security & Best Practices
- [ ] **GITHUB_TOKEN permissions**:
  - [ ] Default: read/write (too much)
  - [ ] Set per workflow: `permissions: { contents: read, pull-requests: write }`
  - [ ] Principle of least privilege
- [ ] **OIDC for cloud**: federated auth (no long-lived secrets)
  - [ ] `permissions: id-token: write`
  - [ ] `aws-actions/configure-aws-credentials@v4` with `role-to-assume`
- [ ] **Third-party actions**: pin to SHA, audit before use
- [ ] **Environment protection**: require approvals for production
- [ ] **Branch protection**: require passing CI to merge
- [ ] **Secret scanning**: GitHub Advanced Security

## Module 9: CI/CD Patterns
- [ ] **CI workflow**: build, test, lint, security scan on every PR
- [ ] **CD workflow**: deploy on merge to main
- [ ] **Environment stages**: dev → staging → production
- [ ] **Manual approvals**: environment protection rules
- [ ] **Rollback**: `workflow_dispatch` with version input
- [ ] **Monorepo strategies**: path filters, affected projects only
- [ ] **Docker build + push + deploy**: common pipeline

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build first workflow with push trigger |
| Module 3 | Add matrix build for multiple Java versions |
| Module 4 | Pin third-party actions to SHA |
| Module 5 | Store and use a secret securely |
| Module 6 | Add caching, measure build time improvement |
| Module 7 | Extract reusable workflow, call from multiple repos |
| Module 8 | Configure OIDC to AWS, deploy without AWS keys |
| Module 9 | Build full CI/CD: test → build → deploy to staging → prod approval |

## Key Resources
- docs.github.com/actions
- GitHub Actions marketplace
- "Automating DevOps with GitLab CI/CD Pipelines" (concepts translate)
- awesome-actions GitHub repo
