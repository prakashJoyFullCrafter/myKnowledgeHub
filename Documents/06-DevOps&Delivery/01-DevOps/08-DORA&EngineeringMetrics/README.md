# DORA & Engineering Metrics - Curriculum

Measuring software delivery performance and developer productivity — scientifically.

---

## Module 1: The DORA Research
- [ ] **DORA (DevOps Research and Assessment)**: research group at Google Cloud
- [ ] **"Accelerate"** book (2018) — Forsgren, Humble, Kim
- [ ] **Annual "State of DevOps" reports** since 2014
- [ ] **Scientific approach**: surveys + statistical analysis to identify predictive metrics
- [ ] **Core finding**: 4 metrics predict high-performing software teams
- [ ] **Performance correlates with business outcomes**: profit, market share, revenue, customer satisfaction
- [ ] **High performers**: deploy 200x more frequently, recover 2600x faster

## Module 2: The Four DORA Metrics
- [ ] **1. Deployment Frequency**: how often you release to production
  - [ ] Elite: on-demand (multiple per day)
  - [ ] High: daily-weekly
  - [ ] Medium: monthly
  - [ ] Low: fewer than monthly
- [ ] **2. Lead Time for Changes**: time from code commit to production
  - [ ] Elite: < 1 hour
  - [ ] High: < 1 day
  - [ ] Medium: 1 week - 1 month
  - [ ] Low: 1-6 months
- [ ] **3. Change Failure Rate**: % of deployments causing a failure
  - [ ] Elite / High: 0-15%
  - [ ] Medium: 16-30%
  - [ ] Low: 46-60%
- [ ] **4. Mean Time to Restore (MTTR)**: time to recover from failure
  - [ ] Elite: < 1 hour
  - [ ] High: < 1 day
  - [ ] Medium: 1 day - 1 week
  - [ ] Low: 1 week - 6 months

## Module 3: Throughput vs Stability
- [ ] **Two categories**:
  - [ ] **Throughput** (speed): Deployment Frequency + Lead Time
  - [ ] **Stability** (reliability): Change Failure Rate + MTTR
- [ ] **Key insight**: they're NOT a trade-off
  - [ ] High performers have HIGH throughput AND HIGH stability
  - [ ] Fast deploys + small changes → quick rollback → better stability
- [ ] **Trade-off myth**: "move slowly to be stable" is counter-productive
- [ ] **Explanation**: small changes are easier to debug and roll back

## Module 4: Fifth Metric — Reliability (DORA 2021+)
- [ ] **Added in 2021**: Operational performance / Reliability
- [ ] **Measures**: ability to meet reliability targets (SLOs)
- [ ] **Calculation**: based on SLO achievement, error budgets
- [ ] **Ties DORA to SRE**: reliability is an outcome, not just ops concern
- [ ] **Elite**: consistently meeting / exceeding reliability targets
- [ ] **Why added**: throughput without reliability isn't valuable

## Module 5: Measuring DORA
- [ ] **Sources of data**:
  - [ ] Deployment frequency: CI/CD system (GitHub Actions, Jenkins)
  - [ ] Lead time: Git commit time → deploy time
  - [ ] Change failure rate: failed deploys + incident count
  - [ ] MTTR: incident start/end from PagerDuty, Opsgenie
- [ ] **Tools**:
  - [ ] **Four Keys** (Google): open-source reference implementation
  - [ ] **Sleuth**, **LinearB**, **Swarmia**: commercial DORA dashboards
  - [ ] **GitLab DORA API**: built into GitLab Premium/Ultimate
  - [ ] **Jellyfish**, **Allstacks**: eng productivity tools
- [ ] **Manual measurement**: quarterly survey is acceptable to start

## Module 6: SPACE Framework
- [ ] **SPACE** (Microsoft Research, 2021): broader than DORA
- [ ] **Five dimensions**:
  - [ ] **Satisfaction**: developer happiness, fulfillment
  - [ ] **Performance**: quality, reliability, customer outcomes
  - [ ] **Activity**: number of commits, PRs, reviews (caveat: not a direct proxy for productivity)
  - [ ] **Communication & collaboration**: team dynamics
  - [ ] **Efficiency & flow**: interruptions, cycle time, focus time
- [ ] **Key principle**: use MULTIPLE metrics across multiple dimensions
  - [ ] No single metric tells the full story
  - [ ] Use metrics that represent OUTCOMES, not just activities
- [ ] **DORA + SPACE**: complementary — DORA for delivery, SPACE for overall DevEx

## Module 7: DX Framework & DevEx Metrics
- [ ] **DX framework** (Abi Noda et al., 2024): developer experience as an input, productivity as an output
- [ ] **Core DevEx metrics**:
  - [ ] **Feedback loops**: how fast devs get feedback (build, test, deploy)
  - [ ] **Cognitive load**: how much you have to remember / understand
  - [ ] **Flow state**: uninterrupted productive time
- [ ] **Survey + system metrics**: combine perception and measurement
- [ ] **DevEx as a strategic investment**: better DevEx → productivity → business outcomes

## Module 8: Anti-Patterns in Metrics
- [ ] **Goodhart's Law**: "When a measure becomes a target, it ceases to be a good measure"
- [ ] **Anti-patterns**:
  - [ ] **Lines of code**: rewards verbosity
  - [ ] **Commits per day**: rewards fragmentation
  - [ ] **PR count**: rewards small PRs regardless of value
  - [ ] **Story points velocity**: rewards inflation
  - [ ] **Individual productivity scores**: rewards optimization over collaboration
- [ ] **Gaming risk**: any metric tied to performance reviews will be gamed
- [ ] **Use metrics for**: team-level improvement, trend analysis, NOT individual evaluation
- [ ] **Trust the team**: metrics are conversation starters, not verdicts

## Module 9: Using Metrics Effectively
- [ ] **Team-level**: compare against past self, not other teams
- [ ] **Trends over time**: are things getting better or worse?
- [ ] **Context matters**: a dashboard team has different metrics than a payment team
- [ ] **Actionable**: metrics should drive specific improvements
- [ ] **Qualitative complement**: surveys, retros, interviews
- [ ] **Outcomes over outputs**: customer satisfaction > commit count
- [ ] **Avoid**: management-only metrics, ignore the team
- [ ] **Culture**: psychological safety to discuss metrics honestly

## Module 10: Improving Each DORA Metric
- [ ] **Deployment Frequency**:
  - [ ] Continuous integration, trunk-based development
  - [ ] Feature flags for in-progress features
  - [ ] Automated deployment pipelines
  - [ ] Smaller batch sizes
- [ ] **Lead Time**:
  - [ ] Fast CI/CD (< 10 min target)
  - [ ] Smaller PRs
  - [ ] Reduce review delays
  - [ ] Automated testing
- [ ] **Change Failure Rate**:
  - [ ] Better testing (unit, integration, contract)
  - [ ] Canary deployments
  - [ ] Automated rollback
  - [ ] Review quality, not just speed
- [ ] **MTTR**:
  - [ ] Observability (fast detection)
  - [ ] Runbooks for common issues
  - [ ] Easy rollback (feature flags, blue-green)
  - [ ] Incident response training

## Module 11: Building a Measurement Culture
- [ ] **Start with curiosity, not control**: measure to learn
- [ ] **Share data openly**: dashboards for everyone
- [ ] **Regular review**: include metrics in retros
- [ ] **Action-oriented**: "what will we do about this?"
- [ ] **Celebrate improvement**: recognize progress
- [ ] **Accept tradeoffs**: some bad quarters are OK
- [ ] **Protect from misuse**: leadership buy-in on metric norms
- [ ] **Evolving metrics**: adjust as team matures

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Measure baseline DORA metrics for your team (or estimate) |
| Module 3 | Explain throughput vs stability interplay with examples |
| Module 4 | Add reliability/SLO achievement to your measurement |
| Module 5 | Deploy Four Keys or build a simple DORA dashboard |
| Module 6 | Design a SPACE-based DevEx survey for your team |
| Module 7 | Measure feedback loop times (CI, deploy, feedback) |
| Module 8 | Identify 3 anti-patterns in how metrics are used in your org |
| Module 9 | Define 3 improvement actions based on metrics data |
| Module 10 | Pick one DORA metric, implement one improvement |
| Module 11 | Present metrics data in a retro, drive an action item |

## Key Resources
- "Accelerate" — Forsgren, Humble, Kim (the DORA book)
- State of DevOps reports (annual)
- "Software Engineering at Google" — free book
- SPACE paper (queue.acm.org)
- dora.dev
- DX framework (getdx.com)
