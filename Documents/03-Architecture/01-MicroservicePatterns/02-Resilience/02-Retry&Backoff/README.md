# Retry & Backoff - Curriculum

## Module 1: Retry Fundamentals
- [ ] Problem: transient failures (network blip, temporary overload, DNS timeout) are recoverable
- [ ] Retry: automatically re-attempt failed operation
- [ ] Only retry **transient** errors — never retry **permanent** errors (400 Bad Request, 404 Not Found)
- [ ] Retryable: `503 Service Unavailable`, `429 Too Many Requests`, `TimeoutException`, `IOException`
- [ ] Not retryable: `400`, `401`, `403`, `404`, `422`, business validation errors

## Module 2: Backoff Strategies
- [ ] **No delay**: immediate retry — risk overwhelming the failing service
- [ ] **Fixed delay**: wait same duration between retries (e.g., 1s, 1s, 1s)
- [ ] **Exponential backoff**: double the wait each time (e.g., 1s, 2s, 4s, 8s)
- [ ] **Jitter**: add randomness to backoff — prevents thundering herd when many clients retry simultaneously
  - [ ] Full jitter: `delay = random(0, exponential_delay)`
  - [ ] Equal jitter: `delay = exponential_delay/2 + random(0, exponential_delay/2)`
- [ ] **Max retries**: cap the number of attempts (e.g., 3-5)
- [ ] **Max delay**: cap the backoff duration (e.g., max 30 seconds)

## Module 3: Idempotency & Safety
- [ ] **Idempotency requirement**: retrying must not cause duplicate side effects
- [ ] Safe to retry: GET, DELETE (usually), PUT (full replace)
- [ ] Dangerous to retry: POST (creates duplicates) — unless idempotent
- [ ] **Idempotency key**: client sends unique key, server deduplicates (Stripe pattern)
- [ ] **Retry budget**: limit total retry traffic to X% of normal traffic — prevents retry storms

## Module 4: Implementation
- [ ] **Resilience4j**: `@Retry(name = "paymentService", fallbackMethod = "fallback")`
  - [ ] Config: `maxAttempts`, `waitDuration`, `retryExceptions`, `ignoreExceptions`
- [ ] **Spring Retry**: `@Retryable(value = IOException.class, maxAttempts = 3, backoff = @Backoff(delay = 1000, multiplier = 2))`
  - [ ] `@Recover`: fallback method after all retries exhausted
- [ ] Retry + circuit breaker ordering: retry wraps the call, circuit breaker wraps the retry
- [ ] `Retry-After` header: server tells client when to retry (respect this!)
- [ ] Logging: log each retry attempt with attempt number for debugging

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Simulate transient failures, compare no-delay vs exponential backoff with jitter |
| Module 3 | Implement idempotency key for a payment API, verify no duplicate charges on retry |
| Module 4 | Configure Resilience4j retry + circuit breaker together on a Feign client |

## Key Resources
- Resilience4j documentation
- "Exponential Backoff And Jitter" - AWS Architecture Blog
- Spring Retry documentation
- Release It! - Michael Nygard
