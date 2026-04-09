# Deployment Strategies - Curriculum

## Module 1: Why Deployment Strategy Matters
- [ ] Goal: deploy without downtime, with safety nets, with fast rollback
- [ ] Trade-offs: speed vs safety, complexity vs simplicity, infrastructure cost
- [ ] **Deployment ≠ release**: deploy = code on servers, release = users see it (decoupled by feature flags)
- [ ] Risks of bad deployments: outages, data corruption, customer trust loss
- [ ] Recovery time matters: MTTR (Mean Time To Recovery)

## Module 2: Rolling Deployment
- [ ] **Rolling update**: replace instances one at a time (or in batches)
- [ ] Old version + new version run simultaneously during rollout
- [ ] Pros: simple, no extra infrastructure, gradual traffic shift
- [ ] Cons: long rollout, mixed versions during deploy, hard to roll back partially
- [ ] **Kubernetes Deployment**: built-in rolling update via `strategy: RollingUpdate`
  - [ ] `maxUnavailable`, `maxSurge` — control rollout speed
- [ ] Compatibility requirement: new version must be compatible with old version (database, API)

## Module 3: Blue-Green Deployment
- [ ] **Blue (current production)** + **Green (new version)** — two complete environments
- [ ] Deploy new version to green, smoke test, switch traffic instantly (DNS/LB swap)
- [ ] **Rollback**: switch traffic back to blue (instant)
- [ ] Pros: instant cutover, zero downtime, easy rollback, test in prod-like env
- [ ] Cons: 2x infrastructure cost, database migrations are tricky (shared DB)
- [ ] **Database challenges**: schema must support both versions (expand-contract pattern)
- [ ] Tools: AWS Elastic Beanstalk, AWS CodeDeploy, Spinnaker, Kubernetes (with two Deployments + Service swap)

## Module 4: Canary Deployment
- [ ] **Canary**: deploy new version to small subset of users (e.g., 1%, 5%, 10%, 50%, 100%)
- [ ] Monitor metrics on canary: error rate, latency, business KPIs
- [ ] Gradual ramp-up if healthy, rollback if not
- [ ] Pros: limit blast radius, real production validation, gradual confidence
- [ ] Cons: requires good observability, more complex routing, slower full rollout
- [ ] **Tools**: Istio (traffic splitting), Argo Rollouts, Flagger, Spinnaker
- [ ] **Automated canary analysis**: tools compare canary vs baseline metrics, auto-rollback on regression
- [ ] **Header-based canary**: route based on user attribute (beta testers, internal users)

## Module 5: A/B Testing & Feature Flags
- [ ] **A/B testing**: route users to different versions based on experiment criteria
- [ ] Differs from canary: A/B is product experiment, canary is deployment safety
- [ ] **Feature flags / toggles**: deploy code disabled, enable in production gradually
- [ ] Decouples deploy from release: deploy daily, enable features when ready
- [ ] **Tools**: LaunchDarkly, Unleash, Flagsmith, ConfigCat, Togglz, Spring Cloud Config + `@RefreshScope`
- [ ] Flag types: release flags (temporary), experiment flags (A/B), permission flags (entitlements), ops flags (kill switches)
- [ ] **Flag debt**: remove flags after rollout — they accumulate technical debt
- [ ] **Trunk-based development**: small commits + feature flags = continuous deployment

## Module 6: Shadow / Dark Launch
- [ ] **Shadow deployment**: send copy of production traffic to new version, discard responses
- [ ] Pros: real traffic load testing without user impact
- [ ] Cons: complex routing, side effect concerns (don't double-write to DB)
- [ ] Use case: validate performance, find bugs at scale before real launch
- [ ] **Dark launch**: feature deployed but hidden from users, internal-only initially

## Module 7: Database Migrations During Deployment
- [ ] **Expand-Contract pattern** (the only safe way for zero-downtime):
  1. **Expand**: add new column/table (additive only, backward-compatible)
  2. **Migrate**: dual-write to old and new, backfill historical data
  3. **Switch**: read from new, stop writing old
  4. **Contract**: drop old column/table after all instances are on new version
- [ ] Never combine schema change + code change in single deployment
- [ ] Avoid: locking migrations on large tables (`ALTER TABLE` blocking)
- [ ] PostgreSQL: `CREATE INDEX CONCURRENTLY`, batched updates
- [ ] Tools: Flyway, Liquibase, Skeema, gh-ost (online schema change)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Configure Kubernetes Deployment with rolling update strategy |
| Module 3 | Set up blue-green with two K8s Deployments + Service swap |
| Module 4 | Use Argo Rollouts for canary with Prometheus metric analysis |
| Module 5 | Add feature flags to a Spring Boot app with Unleash or LaunchDarkly |
| Module 7 | Practice expand-contract migration: rename a column with zero downtime |

## Key Resources
- "Continuous Delivery" - Jez Humble & David Farley
- Argo Rollouts documentation
- LaunchDarkly blog — feature flag patterns
- "Database Refactoring" - Scott Ambler
- Flagger documentation (flagger.app)
