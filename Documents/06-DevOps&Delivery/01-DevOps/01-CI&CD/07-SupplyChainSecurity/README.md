# Software Supply Chain Security - Curriculum

How to secure the path from source code to production: SLSA, SBOM, signing, provenance, and attestation.

---

## Module 1: Supply Chain Attacks
- [ ] **Supply chain attack**: compromise a dependency to reach downstream victims
- [ ] **Famous incidents**:
  - [ ] **SolarWinds (2020)**: compromised build system → backdoor in updates
  - [ ] **Codecov (2021)**: uploader script modified → secrets leaked
  - [ ] **Log4Shell (2021)**: vulnerable dependency in countless apps
  - [ ] **event-stream (2018)**: npm package ownership transfer → crypto wallet attack
  - [ ] **xz-utils (2024)**: long-con backdoor in a core Linux library
- [ ] **Why supply chain is the new battleground**: attack one, compromise thousands
- [ ] **Threat model levels**:
  - [ ] Source: malicious commits, typosquatting
  - [ ] Build: compromised CI, build reproducibility
  - [ ] Dependencies: transitive vulnerabilities, malicious packages
  - [ ] Distribution: compromised registries, MITM
  - [ ] Runtime: running known-vulnerable code

## Module 2: SLSA Framework
- [ ] **SLSA (Supply-chain Levels for Software Artifacts)**: pronounced "salsa"
- [ ] **Goal**: standardized framework for supply chain integrity
- [ ] **Led by Google + OpenSSF, CNCF**
- [ ] **Levels**:
  - [ ] **Build L1**: provenance exists
  - [ ] **Build L2**: provenance is authenticated and service-generated
  - [ ] **Build L3**: build platform prevents tampering (hermetic, isolated)
- [ ] **Requirements progress** across levels: source, build, provenance, common
- [ ] **Provenance**: cryptographically signed attestation of "how it was built"
- [ ] **Use case**: consumers verify SLSA level of dependencies before trusting them

## Module 3: SBOM (Software Bill of Materials)
- [ ] **SBOM**: list of all software components and dependencies in a product
- [ ] **Why**: know what you ship, respond fast to new vulns (Log4Shell, xz, etc.)
- [ ] **Formats**:
  - [ ] **SPDX** (Linux Foundation): ISO standard
  - [ ] **CycloneDX** (OWASP): focused on vulnerability management
- [ ] **Generation tools**:
  - [ ] `syft` (anchore): generate SBOM from images or filesystems
  - [ ] `cdxgen`: CycloneDX generator
  - [ ] Language-specific: `cyclonedx-node`, `cyclonedx-python`, etc.
- [ ] **Consuming SBOMs**:
  - [ ] Scan against CVE databases
  - [ ] Vulnerability scanners: `grype`, `osv-scanner`, `trivy`
- [ ] **Regulation**: EO 14028 (US executive order) requires SBOMs for federal suppliers
- [ ] **Best practice**: generate SBOM per build, store alongside artifact

## Module 4: Sigstore Ecosystem
- [ ] **Sigstore**: free, open-source signing service (Linux Foundation)
- [ ] **Components**:
  - [ ] **Cosign**: CLI for signing container images and artifacts
  - [ ] **Fulcio**: short-lived certificate authority (OIDC-based identity)
  - [ ] **Rekor**: transparency log (immutable record of signatures)
- [ ] **Keyless signing**: no long-lived key management
  - [ ] Sign with OIDC identity (GitHub Actions, GitLab, Google, etc.)
  - [ ] Fulcio issues short-lived cert
  - [ ] Signature recorded in Rekor for verifiability
- [ ] **`cosign sign` / `cosign verify`**: signing images
- [ ] **Why keyless wins**: no secrets to manage, auditable via Rekor

## Module 5: Provenance & Attestations
- [ ] **Provenance**: "who built what, how, and when"
  - [ ] Source repo + commit
  - [ ] Build system
  - [ ] Build parameters
  - [ ] Output digest
- [ ] **Attestation**: signed statement about an artifact
  - [ ] `in-toto` standard
  - [ ] Includes: predicate type, subject, predicate
- [ ] **`cosign attest`**: attach attestation to an image
- [ ] **Verification**: downstream consumers verify provenance before deployment
- [ ] **GitHub Actions + SLSA provenance**: `slsa-github-generator` builds provenance automatically

## Module 6: Dependency Management
- [ ] **Pin dependencies**: lockfiles (`package-lock.json`, `poetry.lock`, `Gemfile.lock`, `go.sum`)
- [ ] **Reproducible builds**: same inputs → same output
- [ ] **Vulnerability scanning**:
  - [ ] **Dependabot** (GitHub): auto-PRs for updates
  - [ ] **Renovate**: more customizable
  - [ ] **Snyk**, **WhiteSource**, **Socket**: commercial/freemium
- [ ] **Dependency confusion attack**: mixing private + public packages
  - [ ] Mitigation: namespace prefixes, explicit registries
- [ ] **Typosquatting**: malicious packages with similar names (`reqeusts` vs `requests`)
- [ ] **Private package mirrors**: Nexus, Artifactory, Verdaccio
- [ ] **Approved package list**: allowlist vetted dependencies

## Module 7: Build Security
- [ ] **Hermetic builds**: no network access during build (prevents tampering)
- [ ] **Reproducible builds**: same source → same binary (byte-for-byte)
- [ ] **Ephemeral build environments**: fresh each time (no state)
- [ ] **Least privilege CI**: build jobs have only necessary permissions
  - [ ] GitHub Actions `permissions:` block
  - [ ] OIDC federation (no long-lived cloud credentials)
- [ ] **Protect build secrets**: never log, use masked outputs
- [ ] **Immutable build artifacts**: pushed to registry, never overwritten
- [ ] **Tools**: `bazel`, `nix`, `earthly` — reproducible build systems

## Module 8: Admission Control (Policy Enforcement)
- [ ] **Problem**: how to ensure only signed/verified artifacts reach production?
- [ ] **Kubernetes admission controllers**:
  - [ ] **Kyverno**: policy-as-code (YAML)
  - [ ] **OPA Gatekeeper**: Rego policies
  - [ ] **Connaisseur**: verifies signatures
- [ ] **Example policies**:
  - [ ] Deny images without Cosign signature
  - [ ] Require SBOM attachment
  - [ ] Block images with critical CVEs
  - [ ] Enforce approved registries only
- [ ] **Pre-deployment gates**: scan + verify before production

## Module 9: Organization Practices
- [ ] **Inventory**: know all your software, open-source + proprietary
- [ ] **SBOM for everything**: generate and store for every build
- [ ] **Vulnerability response process**:
  - [ ] Monitor CVE feeds
  - [ ] Emergency patching capability
  - [ ] Communication plan
- [ ] **Vendor assessment**: require SBOM + SLSA level from suppliers
- [ ] **Regular audits**: review dependencies, remove unused
- [ ] **Security champions**: embed security knowledge in dev teams
- [ ] **Training**: educate devs on supply chain risks

## Module 10: Standards & Frameworks
- [ ] **SLSA**: supply chain levels (covered)
- [ ] **OpenSSF Scorecard**: automated security score for projects
- [ ] **in-toto**: framework for supply chain attestations
- [ ] **Sigstore**: signing (covered)
- [ ] **S2C2F (Microsoft)**: Secure Software Supply Chain Framework
- [ ] **NIST SSDF**: Secure Software Development Framework
- [ ] **CIS Software Supply Chain Security Guide**
- [ ] **EU Cyber Resilience Act**: upcoming regulation for software products

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Study 3 famous supply chain attacks, identify prevention |
| Module 2 | Assess a project against SLSA requirements |
| Module 3 | Generate SBOM with `syft`, scan with `grype` |
| Module 4 | Sign a container image with Cosign (keyless, OIDC) |
| Module 5 | Generate SLSA provenance for a GitHub Actions build |
| Module 6 | Enable Dependabot, review PR, verify CVE fix |
| Module 7 | Configure GitHub Actions with least-privilege permissions |
| Module 8 | Install Kyverno, enforce image signature policy |
| Module 9 | Document supply chain security policy for a team |
| Module 10 | Use OpenSSF Scorecard on an open-source project |

## Key Resources
- slsa.dev (SLSA framework)
- sigstore.dev
- cncf.io/projects (SBOM tools, Cosign, in-toto, OPA)
- "Software Supply Chain Security" — Cassie Crossley
- openssf.org (OpenSSF)
- cyclonedx.org / spdx.dev (SBOM formats)
