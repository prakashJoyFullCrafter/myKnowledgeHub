# Service Templates (Golden Paths) - Curriculum

Opinionated, batteries-included scaffolds that get a new service to production with sane defaults.

## Topics
- [ ] What "golden path" means - the supported, easy way (vs forbidden)
- [ ] What a golden-path service template provides:
  - [ ] Source layout and naming conventions
  - [ ] Build tool config (Maven/Gradle/pnpm)
  - [ ] Dockerfile + base image
  - [ ] CI pipeline (test, scan, build, publish)
  - [ ] CD config (Helm chart, Argo Application, K8s manifests)
  - [ ] Logging, metrics, tracing instrumentation pre-wired
  - [ ] Health/readiness endpoints
  - [ ] Auth/authz boilerplate
  - [ ] README, ADR template, docs scaffold
- [ ] **Backstage Software Templates** - cookiecutter-style with PR creation
- [ ] **Cookiecutter**, **Yeoman**, **Plop** as engines
- [ ] Spring Boot Initializr / Quarkus CLI / start.spring.io as inspiration
- [ ] Per-language templates vs polyglot template variants
- [ ] "Paved road" vs "guard rails" mindset
- [ ] Template versioning - how to evolve templates without breaking existing services
- [ ] Template-update tools (renovate-style for scaffold updates)
- [ ] Measuring template adoption rate
- [ ] Anti-patterns: too many templates, frozen templates, template-per-team
