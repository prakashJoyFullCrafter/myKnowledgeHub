# Dependency Management - Curriculum

Keeping third-party and internal dependencies up-to-date, secure, and consistent across services.

## Topics
### Reproducibility
- [ ] Lockfiles: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, `Cargo.lock`
- [ ] Maven `dependencyManagement` and Gradle `platforms` for version pinning
- [ ] **BOMs (Bill of Materials)** for transitive alignment (Spring Boot BOM, Quarkus BOM)
- [ ] Why "works on my machine" is a dependency-management failure

### Dependency Hygiene
- [ ] Direct vs transitive dependencies
- [ ] Diamond dependency / version conflict resolution
- [ ] Removing unused dependencies (`depcheck`, `unused-deps`)
- [ ] Pinning vs floating ranges - trade-offs
- [ ] License compliance scanning (FOSSA, ScanCode, license-checker)

### Vulnerability Management
- [ ] **Snyk**, **Dependabot**, **GitHub Advanced Security**, **OWASP Dependency-Check**
- [ ] CVE feeds and severity scoring (CVSS)
- [ ] Vulnerability SLAs by severity (e.g., critical: 7 days, high: 30 days)
- [ ] False positive triage workflow
- [ ] **SBOM** (Software Bill of Materials) - SPDX, CycloneDX
- [ ] Generating SBOMs in CI (Syft, Trivy)
- [ ] Sigstore / Cosign for supply-chain integrity

### Automated Updates
- [ ] **Renovate** vs **Dependabot** comparison
- [ ] Auto-merge policy for patch versions
- [ ] Grouping related updates (e.g., all `@types/*` together)
- [ ] Custom rules per dependency (e.g., never auto-bump major)
- [ ] Test-pass gating before auto-merge

### Internal Dependencies
- [ ] Internal artifact registry (Artifactory, Nexus, GitHub Packages)
- [ ] Mirroring upstream registries for resilience
- [ ] Detecting and preventing **dependency confusion** attacks
- [ ] Internal package naming conventions (`@org/...`)

### Governance
- [ ] Allow/deny lists for licenses and sources
- [ ] "New dependency" review process (when to add vs build)
- [ ] Periodic deprecation of unused internal libs
