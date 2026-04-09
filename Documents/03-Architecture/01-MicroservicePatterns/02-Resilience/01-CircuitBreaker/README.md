# Circuit Breaker - Curriculum

## Module 1: Concept
- [ ] Problem: downstream service is failing/slow → caller threads pile up → cascading failure
- [ ] Circuit breaker: automatically stop calling a failing service, fail fast instead of waiting
- [ ] Analogy: electrical circuit breaker — trips on overload, prevents damage

## Module 2: States & Transitions
- [ ] **CLOSED** (normal): requests flow through, failures are counted
- [ ] **OPEN** (tripped): requests fail immediately without calling downstream — returns fallback
- [ ] **HALF_OPEN** (testing): allow limited requests through to test if downstream recovered
- [ ] Transition: CLOSED → OPEN when failure rate exceeds threshold (e.g., 50% of last 100 calls)
- [ ] Transition: OPEN → HALF_OPEN after wait duration (e.g., 60 seconds)
- [ ] Transition: HALF_OPEN → CLOSED if test requests succeed, → OPEN if they fail

## Module 3: Configuration & Fallbacks
- [ ] **Failure rate threshold**: percentage of failures to trip (e.g., 50%)
- [ ] **Slow call threshold**: percentage of slow calls to trip (e.g., 100ms = slow)
- [ ] **Sliding window**: count-based (last N calls) or time-based (last N seconds)
- [ ] **Wait duration in OPEN**: how long before trying HALF_OPEN (e.g., 60s)
- [ ] **Permitted calls in HALF_OPEN**: how many test calls to allow (e.g., 10)
- [ ] **Fallback methods**: return cached data, default value, degraded response, error message
- [ ] **Ignored exceptions**: don't count business exceptions (e.g., `NotFoundException`) as failures

## Module 4: Implementation & Monitoring
- [ ] **Resilience4j**: `@CircuitBreaker(name = "userService", fallbackMethod = "fallback")`
- [ ] Configuration in `application.yml`: thresholds, window size, wait duration
- [ ] **Monitoring**: Actuator + Micrometer metrics — state changes, failure rate, call count
- [ ] **Alerting**: alert when circuit opens (downstream is unhealthy)
- [ ] Circuit breaker + retry: retry first (transient errors), circuit breaker wraps retry (sustained failure)
- [ ] Circuit breaker + bulkhead: isolate resources per downstream service
- [ ] Netflix Hystrix (deprecated) → Resilience4j migration path

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Simulate downstream failure, observe CLOSED → OPEN → HALF_OPEN transitions |
| Module 3 | Configure fallback that returns cached data when circuit is open |
| Module 4 | Dashboard: visualize circuit breaker state changes in Grafana |

## Key Resources
- Resilience4j documentation (resilience4j.readme.io)
- "Circuit Breaker" - Martin Fowler (blog)
- Release It! - Michael Nygard (the original circuit breaker for software)
