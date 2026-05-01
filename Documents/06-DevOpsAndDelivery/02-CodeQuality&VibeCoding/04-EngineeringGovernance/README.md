# Engineering Governance

Org-wide standards that keep a polyglot, multi-team codebase coherent, secure, and releasable.

## Sections
- **01. Versioning** - SemVer, CalVer, API versioning, deprecation policy
- **02. Dependency Management** - BOMs, lockfiles, vulnerability scanning, automated updates
- **03. Coding Standards** - linters, formatters, style guides, review checklists
- **04. Security Standards** - OWASP, secrets, SAST/DAST, supply chain, secure-by-default
- **05. Release Standards** - changelogs, release notes, feature flag governance, rollout policy

## Why governance matters
- Consistency across services lets a single engineer move between teams quickly
- Standards encode hard-won security and reliability lessons
- Without governance, every team relearns the same lessons - expensively

## Governance principles
- **Paved road, not gates**: make the right thing the easy thing
- **Codify, don't lecture**: standards live in linters, templates, CI - not wikis
- **Fail closed**: violations break the build, not just emit warnings
- **Sunset old standards**: standards rot; review annually
