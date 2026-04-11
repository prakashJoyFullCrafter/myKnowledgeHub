# Reliability & Resilience (System Design Perspective) - Curriculum

How to design systems that stay up, recover fast, and degrade gracefully under failure.

> Implementation details (Resilience4j, Spring Cloud) are in Microservice Patterns. This module is about **architectural decisions**.

---

## Module 1: Failure Modes in Distributed Systems
- [ ] Everything fails: networks, disks, processes, entire datacenters
- [ ] **Partial failure**: some nodes work, some don't — hardest to handle
- [ ] **Cascading failure**: one service fails → overloads upstream → chain reaction
- [ ] **Metastable failure**: system appears stable but is one spike away from collapse
- [ ] **Gray failures**: not fully down, but degraded (slow responses, intermittent errors)
- [ ] Blast radius: how much of the system is affected by a single failure?
- [ ] Designing for failure: assume everything WILL fail, design around it

## Module 2: Timeouts, Retries, Backoff & Jitter
- [ ] **Timeouts**: every network call MUST have a timeout — no exceptions
  - [ ] Connect timeout vs read timeout vs overall timeout
  - [ ] Too short: false failures; too long: thread/connection exhaustion
  - [ ] Timeout budgets: propagate remaining time through call chain
- [ ] **Retries**: retry transient failures, NOT permanent ones
  - [ ] Retry budget: cap total retries across the system (e.g., 20% of requests)
  - [ ] Retry amplification: retries at each layer multiply (3 layers x 3 retries = 27 calls)
- [ ] **Exponential backoff**: 1s → 2s → 4s → 8s — prevent thundering herd on recovery
- [ ] **Jitter**: add randomness to backoff — prevent synchronized retry storms
  - [ ] Full jitter vs equal jitter vs decorrelated jitter
- [ ] Design decision: where in the architecture do retries live? (client, gateway, service mesh)

## Module 3: Circuit Breakers & Bulkheads
- [ ] **Circuit breaker** in system design:
  - [ ] When to put one: between any two services with network calls
  - [ ] Where to place: caller-side, API gateway, or service mesh sidecar
  - [ ] States: closed (normal) → open (failing, fast-fail) → half-open (testing recovery)
  - [ ] Architecture impact: what does the caller DO when circuit is open? (fallback, cache, degrade)
- [ ] **Bulkhead** in system design:
  - [ ] Isolate resources so one slow dependency doesn't consume all threads/connections
  - [ ] Per-service thread pools, per-tenant resource limits
  - [ ] Connection pool isolation: separate pools for critical vs non-critical paths
- [ ] **Load shedding**: intentionally reject requests when overloaded (HTTP 503)
  - [ ] Priority-based shedding: serve paid users, shed free-tier traffic
- [ ] Combining patterns: timeout + retry + circuit breaker + bulkhead as a defense stack

## Module 4: Graceful Degradation
- [ ] **Graceful degradation**: serve reduced functionality rather than total failure
- [ ] Examples:
  - [ ] Recommendation service down → show trending instead of personalized
  - [ ] Search down → show cached results or category browse
  - [ ] Payment service slow → queue order, confirm async
- [ ] **Feature flags for degradation**: disable non-critical features under load
- [ ] **Static fallbacks**: pre-computed responses served when backends fail
- [ ] **Read-only mode**: disable writes, keep reads working during incidents
- [ ] Design decision: identify critical path vs nice-to-have for every system you design

## Module 5: Failover Patterns
- [ ] **Active-passive failover**: standby takes over when primary fails
  - [ ] Cold standby (slow) vs warm standby (faster) vs hot standby (instant)
- [ ] **Active-active failover**: all nodes serve traffic, redistribute on failure
- [ ] **DNS failover**: Route 53 health checks → route away from unhealthy region
- [ ] **Database failover**: automatic promotion (Patroni, RDS Multi-AZ)
- [ ] **Split-brain**: two nodes think they're primary → fencing, STONITH
- [ ] Failover testing: if you haven't tested failover, you don't have failover

## Module 6: Disaster Recovery (DR)
- [ ] **RPO (Recovery Point Objective)**: how much data can you lose? (0 = no loss, 1h = up to 1 hour)
- [ ] **RTO (Recovery Time Objective)**: how fast must you recover? (minutes vs hours)
- [ ] **DR strategies** (cost vs speed):
  - [ ] Backup & restore: cheapest, slowest (RTO: hours)
  - [ ] Pilot light: minimal core running, scale up on disaster (RTO: 10-30 min)
  - [ ] Warm standby: scaled-down copy always running (RTO: minutes)
  - [ ] Multi-site active-active: zero downtime, most expensive (RTO: seconds)
- [ ] **Backup strategy**: full vs incremental vs differential, offsite copies, encryption
- [ ] **Runbooks**: documented step-by-step recovery procedures
- [ ] DR drills: scheduled practice runs — measure actual RTO/RPO vs targets

## Module 7: Chaos Engineering
- [ ] **Philosophy**: proactively inject failures to find weaknesses before production does
- [ ] **Chaos experiment cycle**: hypothesis → inject failure → observe → learn → fix
- [ ] **Types of chaos**:
  - [ ] Kill a service/pod/container
  - [ ] Inject latency or packet loss
  - [ ] Exhaust CPU/memory/disk
  - [ ] Simulate network partition between services
  - [ ] Fail an entire availability zone
- [ ] **Tools**: Chaos Monkey (Netflix), Litmus (K8s), Gremlin, Chaos Mesh, Toxiproxy
- [ ] **Steady-state hypothesis**: define normal behavior metrics BEFORE injecting chaos
- [ ] **Game days**: scheduled chaos experiments with the whole team
- [ ] Start small: chaos in staging first, then controlled production experiments
- [ ] Design for chaos: systems that survive chaos experiments are truly resilient

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Map all failure modes for a 3-service e-commerce system (order, payment, inventory) |
| Module 2 | Design retry strategy for a payment flow — where do retries go? What are the budgets? |
| Module 3 | Draw architecture with circuit breakers and bulkheads for a microservices system |
| Module 4 | Define degradation strategy for a social media feed (what degrades first, last?) |
| Modules 5-6 | Design DR strategy for a fintech app: define RPO/RTO, choose DR approach |
| Module 7 | Design a chaos experiment: hypothesis, injection, metrics to watch, success criteria |

## Key Resources
- **Release It!** - Michael Nygard (the bible of resilience patterns)
- **Designing Data-Intensive Applications** - Martin Kleppmann
- Netflix Chaos Engineering blog posts
- AWS Well-Architected Framework - Reliability pillar
- "Timeouts, retries, and backoff with jitter" - AWS Architecture Blog
