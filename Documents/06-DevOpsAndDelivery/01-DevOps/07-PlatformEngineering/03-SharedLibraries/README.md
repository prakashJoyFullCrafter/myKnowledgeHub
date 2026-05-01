# Shared Libraries - Curriculum

Cross-cutting reusable code published as internal libraries - the "ABC" (auth, boilerplate, config) of every service.

## Topics
- [ ] Why shared libraries: consistency, leverage, security baseline
- [ ] What belongs in a shared library:
  - [ ] Common error/response types
  - [ ] Auth/authz client (JWT validation, principal resolution)
  - [ ] Logging conventions and log enrichment
  - [ ] Metrics emission helpers
  - [ ] Tracing/OpenTelemetry setup
  - [ ] Common HTTP/gRPC clients with retries, timeouts, circuit breakers
  - [ ] Feature-flag client wrapper
  - [ ] Config loading conventions
- [ ] What does NOT belong in a shared library (domain code, business logic)
- [ ] **BOM (Bill of Materials)** for transitive dependency alignment (Maven, Gradle platforms)
- [ ] **Spring Boot Starters** as a shared-lib pattern
- [ ] **Quarkus Extensions** as the Quarkus equivalent
- [ ] Versioning strategy: SemVer, deprecation, breaking-change policy
- [ ] Release cadence vs consumer adoption lag
- [ ] Avoiding "library trap": when shared libs become a coupling nightmare
- [ ] Diamond dependency problem
- [ ] Internal package registry: Artifactory, GitHub Packages, AWS CodeArtifact
- [ ] Security: signed artifacts, SBOM emission, vulnerability scanning
- [ ] Auto-upgrade tooling (Renovate, Dependabot) for consumers
- [ ] Ownership model: platform team vs federated maintainers
