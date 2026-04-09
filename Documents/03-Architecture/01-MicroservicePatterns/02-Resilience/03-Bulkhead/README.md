# Bulkhead Pattern - Curriculum

## Module 1: Concept
- [ ] Analogy: ship bulkheads — watertight compartments prevent one breach from sinking the whole ship
- [ ] Problem: one slow downstream service consumes all threads → entire app becomes unresponsive
- [ ] Solution: isolate resources per downstream dependency — failure in one doesn't exhaust resources for others

## Module 2: Bulkhead Types
- [ ] **Thread pool bulkhead**: dedicate separate thread pool per downstream service
  - [ ] Service A gets 10 threads, Service B gets 10 threads — if A is slow, B still has threads
  - [ ] Pros: true isolation, queuing support
  - [ ] Cons: thread overhead, context switching cost
- [ ] **Semaphore bulkhead**: limit concurrent calls per downstream (no separate threads)
  - [ ] Lighter than thread pools, uses caller's thread
  - [ ] Pros: low overhead, good for non-blocking/reactive code
  - [ ] Cons: no queuing, caller thread still blocked during call

## Module 3: Sizing & Configuration
- [ ] Sizing: based on downstream's throughput × latency + safety margin
- [ ] Too small: unnecessary rejections under normal load
- [ ] Too large: doesn't protect effectively
- [ ] **Resilience4j**: `@Bulkhead(name = "inventoryService", type = Bulkhead.Type.THREADPOOL)`
  - [ ] Thread pool: `maxThreadPoolSize`, `coreThreadPoolSize`, `queueCapacity`
  - [ ] Semaphore: `maxConcurrentCalls`, `maxWaitDuration`
- [ ] When bulkhead is full: reject immediately or queue (thread pool only)

## Module 4: Bulkhead in Practice
- [ ] **Bulkhead + circuit breaker**: bulkhead limits concurrent calls, circuit breaker trips on sustained failure
- [ ] **Kubernetes resource limits**: CPU/memory limits per pod = infrastructure-level bulkhead
- [ ] **Separate connection pools**: database connection pool per service/tenant
- [ ] **Separate thread pools**: `@Async("emailExecutor")`, `@Async("paymentExecutor")` in Spring
- [ ] Anti-pattern: shared thread pool for all external calls — one slow service blocks everything

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Simulate slow service, observe thread exhaustion without bulkhead vs isolation with bulkhead |
| Module 3 | Configure thread pool bulkhead for 3 downstream services, test under load |
| Module 4 | Combine bulkhead + circuit breaker + retry on same service call |

## Key Resources
- Resilience4j Bulkhead documentation
- Release It! - Michael Nygard (Chapter: Stability Patterns)
- "Bulkhead Pattern" - Microsoft Azure Architecture Center
