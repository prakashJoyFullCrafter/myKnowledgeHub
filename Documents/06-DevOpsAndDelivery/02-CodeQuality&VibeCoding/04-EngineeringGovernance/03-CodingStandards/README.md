# Coding Standards - Curriculum

How an org enforces consistent, readable, defect-resistant code across many teams and languages.

## Topics
### Style & Format
- [ ] **EditorConfig** for editor-level basics
- [ ] **Prettier** (JS/TS) - opinionated, no debate
- [ ] **Black** / **Ruff** (Python)
- [ ] **gofmt** (Go) - format on save, no config
- [ ] **Spotless** / **google-java-format** (Java)
- [ ] **ktlint** / **detekt** (Kotlin)
- [ ] **rustfmt** (Rust)
- [ ] Format-on-save in editors as the org default

### Linting
- [ ] **ESLint** with shared config (`@org/eslint-config`)
- [ ] **Ruff** for Python (replaces flake8, isort, pylint)
- [ ] **Checkstyle** / **SpotBugs** / **PMD** (Java)
- [ ] **Detekt** (Kotlin)
- [ ] **golangci-lint** (Go)
- [ ] **clippy** (Rust)
- [ ] Treating lint errors as build failures

### Style Guides
- [ ] Internal style guide doc - short, opinionated, examples
- [ ] Naming conventions (variables, files, packages)
- [ ] File / module organization rules
- [ ] Comment policy (when to write, when not to)
- [ ] Effective Java / Effective Python / similar canon as references

### Code Review
- [ ] CODEOWNERS for routing
- [ ] PR template with checklist
- [ ] Review SLA and escalation
- [ ] Review checklist: tests, security, performance, observability, accessibility
- [ ] Avoiding nitpicks - that's the linter's job
- [ ] Conventional Comments (`praise:`, `nit:`, `issue:`, `question:`)
- [ ] Pair programming as alternative to async review
- [ ] Required approvals and branch protection

### Architecture-Level Standards
- [ ] **ADRs** (Architecture Decision Records) - lightweight markdown in repo
- [ ] **Fitness functions** - automated architecture tests (ArchUnit, NetArchTest)
- [ ] Module boundary enforcement (`@PackagePrivate`, JPMS)
- [ ] **API style guide** (REST conventions, error format, pagination, filtering)

### Cross-Cutting
- [ ] Pre-commit hooks (`husky`, `lefthook`, `pre-commit`)
- [ ] Centrally-maintained shared lint configs as packages
- [ ] Annual review and sunset of stale rules
