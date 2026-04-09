# SRE & Reliability - Curriculum

Site Reliability Engineering principles for running production systems at scale.

---

## Module 1: SRE Fundamentals
- [ ] **SRE = DevOps + reliability engineering** with measurable goals
- [ ] Coined by Google, formalized in "Site Reliability Engineering" book
- [ ] Core principles: embrace risk, eliminate toil, automate everything
- [ ] **Toil**: manual, repetitive, automatable, tactical, no enduring value — minimize it
- [ ] **50% rule**: SREs spend max 50% time on toil, 50% on engineering
- [ ] SRE vs DevOps vs Platform Engineering — overlap and differences

## Module 2: SLI, SLO, SLA
- [ ] **SLI (Service Level Indicator)**: a measurement (e.g., "99.5% of requests succeed")
- [ ] **SLO (Service Level Objective)**: a target for an SLI (e.g., "99.9% over 30 days")
- [ ] **SLA (Service Level Agreement)**: contractual commitment with consequences (refunds, etc.)
- [ ] **Hierarchy**: SLI ⊂ SLO ⊂ SLA (SLO < SLA so you have buffer)
- [ ] Choosing good SLIs:
  - [ ] **Availability**: % of successful requests
  - [ ] **Latency**: % of requests faster than threshold (p50, p95, p99)
  - [ ] **Throughput**: requests per second
  - [ ] **Quality**: degraded responses count
  - [ ] **Correctness**: data accuracy
- [ ] **The Four Golden Signals** (Google SRE): Latency, Traffic, Errors, Saturation
- [ ] **RED method**: Rate, Errors, Duration (for services)
- [ ] **USE method**: Utilization, Saturation, Errors (for resources)

## Module 3: Error Budgets
- [ ] **Error budget**: 100% - SLO = allowed failure (e.g., 99.9% SLO → 0.1% budget = 43 min/month)
- [ ] **Budget burn rate**: how fast you're consuming the error budget
- [ ] **Policy**: when budget is healthy → ship features. When exhausted → freeze, focus on reliability
- [ ] Aligns dev (ship features) and ops (don't break things) on shared metric
- [ ] **Multi-window burn rate alerts**: short window (immediate) + long window (slow burn)
- [ ] Error budget vs uptime: forces explicit reliability conversations

## Module 4: Incident Response
- [ ] **Incident severity levels**: SEV-1 (outage) → SEV-4 (minor)
- [ ] **Incident commander (IC)** role: coordinates response, makes decisions
- [ ] **Communication channels**: Slack incident channel, status page, customer comms
- [ ] **Mitigation first, root cause second**: stop the bleeding, then investigate
- [ ] **Common mitigations**: rollback, scale up, failover, feature flag off, traffic shed
- [ ] **Incident response phases**: detection → triage → mitigation → resolution → postmortem
- [ ] **Tools**: PagerDuty, Opsgenie, FireHydrant, Incident.io
- [ ] **War rooms / video calls** for SEV-1 incidents

## Module 5: Postmortems
- [ ] **Blameless postmortems**: focus on systems, not people — no individual blame
- [ ] **Timeline**: minute-by-minute chronology of detection, escalation, mitigation
- [ ] **Root cause analysis**: 5 Whys, fishbone diagram
- [ ] **Action items**: prevent recurrence, improve detection, improve response
- [ ] **Postmortem template**:
  - [ ] Summary, impact, timeline, root cause, mitigation, action items, lessons learned
- [ ] **Share widely**: postmortems are learning opportunities for the whole org
- [ ] Examples: Google SRE postmortem template, Atlassian postmortem template

## Module 6: On-Call & Toil Reduction
- [ ] **On-call rotation**: 1 week shifts, primary + secondary, backup escalation
- [ ] **Healthy on-call**: < 2 incidents per shift average, manageable load
- [ ] **Compensation**: time off, monetary, both — never "just part of the job"
- [ ] **Runbooks**: documented response steps for known scenarios
- [ ] **Alert hygiene**: every alert must be actionable, urgent, real
- [ ] **Alert fatigue**: too many alerts → ignored alerts → real alerts missed
- [ ] **Toil tracking**: measure time spent on toil, set reduction goals
- [ ] **Automation**: every manual task done twice → automate it

## Module 7: Chaos Engineering
- [ ] **Chaos engineering**: intentionally inject failures to verify system resilience
- [ ] Coined by Netflix with **Chaos Monkey** (random instance termination)
- [ ] **Hypothesis-driven**: "if X fails, system should still serve Y"
- [ ] **Game days**: scheduled chaos experiments with team participation
- [ ] **Tools**: Gremlin, Chaos Mesh, Litmus, AWS Fault Injection Simulator, Chaos Toolkit
- [ ] **Failure types**: instance termination, latency injection, network partition, resource exhaustion, dependency failures
- [ ] **Production chaos**: only when confident, with kill switch ready
- [ ] **Chaos in CI**: automated resilience tests in deployment pipeline

## Module 8: Reliability Patterns
- [ ] **Graceful degradation**: when dependency fails, return cached/default response, don't crash
- [ ] **Circuit breaker**: stop calling failing dependency, fail fast (covered in Microservices Patterns)
- [ ] **Retry with backoff + jitter**: avoid thundering herd
- [ ] **Bulkhead**: isolate failures (covered in Microservices Patterns)
- [ ] **Load shedding**: reject requests when overloaded, prioritize critical traffic
- [ ] **Timeouts everywhere**: never call external service without timeout
- [ ] **Idempotency**: safe retries, exactly-once semantics
- [ ] **Backups & disaster recovery**: RPO (Recovery Point Objective), RTO (Recovery Time Objective)
- [ ] **Multi-region**: active-active, active-passive, failover testing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Define SLOs for an API: availability, latency p99, error rate |
| Module 3 | Calculate error budget for 99.9% SLO, set up burn rate alerts in Prometheus |
| Module 4 | Run a tabletop incident response exercise with team |
| Module 5 | Write a postmortem for a real (or simulated) incident using a template |
| Module 6 | Audit current alerts: which are noise? Which are missing? |
| Module 7 | Run a chaos experiment: kill a pod, observe self-healing |
| Module 8 | Add timeouts and circuit breakers to all external calls in a Spring Boot app |

## Key Resources
- **"Site Reliability Engineering"** - Google (free at sre.google/books)
- **"The Site Reliability Workbook"** - Google
- **"Seeking SRE"** - David Blank-Edelman
- **"Chaos Engineering"** - Casey Rosenthal & Nora Jones
- Google SRE postmortem template
- PagerDuty Incident Response (response.pagerduty.com)
- Atlassian Incident Management Handbook
