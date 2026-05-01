# Release Standards - Curriculum

How releases are cut, communicated, rolled out, and rolled back consistently across the org.

## Topics
### Release Mechanics
- [ ] Trunk-based development as the default branching model
- [ ] Release-from-`main` vs release branches - trade-offs
- [ ] Tagging convention: `v1.2.3`, signed tags
- [ ] Conventional Commits → automated CHANGELOG (`semantic-release`, `release-please`, **Changesets**)
- [ ] Release artifacts: container image, Helm chart, SBOM, signature - all linked

### Release Notes & Changelog
- [ ] **Keep a Changelog** format (`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`)
- [ ] Audience: internal CHANGELOG vs customer-facing release notes
- [ ] Highlighting breaking changes prominently
- [ ] Migration guides for breaking changes

### Rollout Strategy
- [ ] **Progressive delivery**: dev → staging → canary → prod
- [ ] **Canary deployment**: small % traffic, watch SLOs
- [ ] **Blue/green** vs **rolling** - choose per workload
- [ ] **Feature flags** for decoupling deploy from release
- [ ] **Argo Rollouts**, **Flagger** for automated canary analysis
- [ ] Auto-rollback on SLO violation

### Feature Flag Governance
- [ ] Flag taxonomy: release toggles, ops toggles, experiments, permission toggles
- [ ] Flag lifecycle: create → roll out → clean up (every flag is tech debt)
- [ ] Flag cleanup SLA (e.g., release-toggle removed within 30 days of 100% rollout)
- [ ] Centralized flag platform (LaunchDarkly, Unleash, Flipt, GrowthBook, OpenFeature)
- [ ] Auditing flag changes (who flipped what when)
- [ ] Stale-flag detection tooling

### Release Cadence & Communication
- [ ] Release calendar / freeze windows (e.g., no Friday deploys, end-of-quarter freeze)
- [ ] Pre-release checklist (tests pass, runbook updated, dashboards ready)
- [ ] Stakeholder notifications: Slack channel, status page, email
- [ ] Release captain / on-call coordination

### Post-Release
- [ ] Deploy monitoring window (watch dashboards N minutes post-deploy)
- [ ] Rollback runbook - tested, not just written
- [ ] Postmortem template for failed releases (blameless)
- [ ] Tracking **change failure rate** (DORA metric)
- [ ] Tracking **time-to-restore** when rollbacks happen

### Hotfixes
- [ ] Hotfix branching policy
- [ ] Cherry-pick to release branch + forward-merge to `main`
- [ ] Communication and approval requirements for out-of-cycle releases
