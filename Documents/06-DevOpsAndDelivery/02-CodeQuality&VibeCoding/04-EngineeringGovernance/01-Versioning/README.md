# Versioning - Curriculum

How to assign version numbers to artifacts, APIs, schemas, and contracts so consumers can rely on them.

## Topics
### Version Schemes
- [ ] **SemVer 2.0** - `MAJOR.MINOR.PATCH` semantics
- [ ] **CalVer** - date-based versioning (`YYYY.MM.PATCH`) - good for apps
- [ ] **Romantic versioning** (anti-pattern)
- [ ] Pre-release identifiers: `1.2.3-rc.1`, `1.2.3-alpha.5`
- [ ] Build metadata: `1.2.3+build.42`
- [ ] Choosing scheme per artifact type (libraries vs apps vs APIs)

### Library Versioning
- [ ] What counts as a breaking change in SemVer
- [ ] Java/Maven version ranges - why to avoid them
- [ ] npm caret/tilde semantics (`^`, `~`)
- [ ] Lockfile-driven reproducibility
- [ ] Automated version bumps via Conventional Commits + semantic-release

### API Versioning
- [ ] URI versioning (`/v1/...`) vs header versioning vs media-type versioning
- [ ] Backward-compatible vs breaking API changes
- [ ] Field-level deprecation in REST (`Deprecation` header, RFC 8594)
- [ ] gRPC: `reserved` fields, proto3 forward/backward compat rules
- [ ] GraphQL: nullable additions OK, removals breaking
- [ ] **Tolerant Reader pattern**

### Database Schema Versioning
- [ ] Flyway / Liquibase migration files
- [ ] Expand-then-contract pattern for online migrations
- [ ] Backwards-compatible schema changes only (deploy-safe)
- [ ] Versioning event schemas (Avro, Protobuf, JSON Schema)
- [ ] Schema Registry compatibility modes (BACKWARD, FORWARD, FULL)

### Deprecation Policy
- [ ] Public deprecation timeline (e.g., 6 months minimum)
- [ ] Deprecation announcements channels (changelog, headers, dashboards)
- [ ] Telemetry on deprecated-feature usage to drive sunset decisions
- [ ] Removing dead code only after telemetry shows zero usage
