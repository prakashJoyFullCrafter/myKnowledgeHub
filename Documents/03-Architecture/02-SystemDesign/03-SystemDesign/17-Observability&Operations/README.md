# Observability & Operations (System Design Perspective) - Curriculum

How to design systems that are observable, debuggable, and operable at scale.

> Tool-specific setup (Prometheus, Grafana, ELK, Jaeger) is in DevOps/Observability. This module is about **designing observability into your architecture**.

---

## Module 1: Three Pillars of Observability
- [ ] **Metrics**: numeric measurements over time (counters, gauges, histograms)
  - [ ] System metrics: CPU, memory, disk, network
  - [ ] Application metrics: request rate, error rate, latency (p50, p95, p99)
  - [ ] Business metrics: orders/min, signups/day, revenue/hour
- [ ] **Logs**: discrete events with context (structured JSON > unstructured text)
  - [ ] Structured logging: `{"level":"ERROR", "service":"order", "trace_id":"abc", "msg":"payment failed"}`
  - [ ] Correlation IDs: trace requests across services via shared ID in every log
  - [ ] Log levels: ERROR (action needed), WARN (investigate), INFO (audit), DEBUG (development)
- [ ] **Traces**: end-to-end request path across services
  - [ ] Span: single operation (DB query, HTTP call) with timing
  - [ ] Trace: tree of spans showing full request journey
  - [ ] Distributed tracing: propagate trace context across service boundaries
- [ ] **The gap**: metrics tell you WHAT is wrong, logs tell you WHY, traces tell you WHERE

## Module 2: SLI, SLO, SLA
- [ ] **SLI (Service Level Indicator)**: the metric you measure
  - [ ] Availability: % of successful requests
  - [ ] Latency: p99 response time
  - [ ] Throughput: requests per second
  - [ ] Correctness: % of correct responses
- [ ] **SLO (Service Level Objective)**: the target for that metric
  - [ ] Example: "99.9% of requests complete in < 200ms"
  - [ ] Set per user-facing journey, not per service
- [ ] **SLA (Service Level Agreement)**: contractual promise with consequences
  - [ ] SLA < SLO always (internal target stricter than external promise)
- [ ] **Error budget**: 100% - SLO = budget for failures/experimentation
  - [ ] Error budget policy: if budget exhausted → freeze features, focus on reliability
- [ ] **Burn rate alerts**: alert when consuming error budget too fast (not just on threshold)
- [ ] Design decision: define SLOs BEFORE designing the system — they drive architecture choices

## Module 3: Alerting Design
- [ ] **Alert on symptoms, not causes**: "high error rate" not "CPU at 80%"
- [ ] **Alert fatigue**: too many alerts = all ignored → page only for actionable, urgent issues
- [ ] **Severity levels**:
  - [ ] P1/Critical: customer-impacting, page immediately
  - [ ] P2/Warning: degraded, needs attention within hours
  - [ ] P3/Info: notification, review next business day
- [ ] **Multi-window, multi-burn-rate alerts**: SLO-based alerting (Google SRE approach)
- [ ] **Runbook links**: every alert should link to a runbook with diagnosis + remediation steps
- [ ] **Alert routing**: PagerDuty/OpsGenie for paging, Slack for warnings
- [ ] Anti-patterns: alerting on every exception, alerting without context, duplicate alerts

## Module 4: Dashboard Design
- [ ] **The Four Golden Signals** (Google SRE): latency, traffic, errors, saturation
- [ ] **RED method** (for request-driven services): Rate, Errors, Duration
- [ ] **USE method** (for resources): Utilization, Saturation, Errors
- [ ] **Dashboard hierarchy**:
  - [ ] L0: Executive/business dashboard (orders/min, revenue, error rate)
  - [ ] L1: Service overview (all services, SLO status, health)
  - [ ] L2: Per-service deep dive (latency breakdown, dependency health, resource usage)
  - [ ] L3: Infrastructure (nodes, pods, network, storage)
- [ ] Design principle: dashboards answer "is the system healthy?" in 5 seconds

## Module 5: Debugging Distributed Systems
- [ ] **The debugging flow**: alert → dashboard → traces → logs → root cause
- [ ] **Distributed tracing for debugging**: find the slow/failing span in the trace
- [ ] **Common failure patterns**:
  - [ ] Cascading timeout: downstream slow → upstream queues up → everything slow
  - [ ] Connection pool exhaustion: one slow dependency hogs all connections
  - [ ] Memory leak: gradual degradation, eventual OOM
  - [ ] Hot partition: one shard/partition gets disproportionate traffic
  - [ ] Clock skew: distributed timestamps don't agree
- [ ] **Profiling in production**: async-profiler, flame graphs, thread dumps
- [ ] **Correlation**: join metrics + logs + traces by trace_id for full picture

## Module 6: Incident Response & On-Call
- [ ] **Incident lifecycle**: detect → triage → mitigate → resolve → postmortem
- [ ] **Incident commander**: one person coordinates response, communication, decisions
- [ ] **Mitigation first**: restore service BEFORE finding root cause
  - [ ] Common mitigations: rollback, restart, scale up, feature flag off, redirect traffic
- [ ] **Communication**: status page updates, stakeholder comms, customer notification
- [ ] **Blameless postmortem**: what happened, timeline, root cause, action items
  - [ ] Focus on systems/processes, not individuals
  - [ ] "What can we change so this can't happen again?"
- [ ] **On-call best practices**: rotation, escalation path, handoff notes, compensation
- [ ] **Toil reduction**: automate repetitive operational work

## Module 7: Capacity Planning
- [ ] **Capacity planning cycle**: measure current → forecast growth → provision ahead
- [ ] **Load testing**: establish baseline capacity of each service
  - [ ] Tools: k6, Gatling, JMeter, Locust
  - [ ] Test types: load test, stress test, soak test, spike test
- [ ] **Forecasting**: project growth from historical trends + business plans
- [ ] **Headroom**: provision 2-3x current peak for safety margin
- [ ] **Autoscaling**: reactive scaling based on metrics (HPA in K8s, AWS Auto Scaling)
  - [ ] Scale-out latency: time to spin up new instances matters
  - [ ] Pre-scaling for known events (Black Friday, product launch)
- [ ] **Cost optimization**: right-sizing instances, reserved capacity, spot instances
- [ ] Design decision: capacity plan should be part of every system design

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design observability strategy for a 5-service e-commerce system — what metrics, logs, traces for each? |
| Module 2 | Define SLIs and SLOs for a payment service (availability, latency, correctness) |
| Module 3 | Design alerting for a chat application — what pages, what warns, what's noise? |
| Module 4 | Design a 4-level dashboard hierarchy for a food delivery platform |
| Module 5 | Given a trace showing 5-second latency, walk through debugging to find root cause |
| Module 6 | Write a postmortem for a fictional database failover incident |
| Module 7 | Capacity plan for a system expecting 10x growth in 6 months |

## Key Resources
- **Site Reliability Engineering** - Google (free online: sre.google/books)
- **Observability Engineering** - Charity Majors, Liz Fong-Jones
- **The SRE Workbook** - Google
- Grafana Labs blog on dashboard best practices
- PagerDuty Incident Response guide (free)
