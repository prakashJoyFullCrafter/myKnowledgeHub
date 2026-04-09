# Rate Limiting - Curriculum

## Module 1: Why Rate Limit?
- [ ] **Protect services** from overload (intentional or accidental)
- [ ] **Prevent abuse**: DDoS, scraping, brute force attacks
- [ ] **Fair usage**: ensure one client doesn't monopolize resources
- [ ] **Cost control**: limit expensive downstream API calls
- [ ] Rate limiting ≠ throttling: rate limiting rejects, throttling slows down

## Module 2: Algorithms
- [ ] **Token Bucket**: bucket holds N tokens, each request consumes one, tokens refill at fixed rate
  - [ ] Allows bursts (up to bucket size), smooths over time
  - [ ] Most commonly used (AWS, Stripe, GitHub)
- [ ] **Leaky Bucket**: requests queue, processed at fixed rate — excess dropped
  - [ ] Smooth output rate, no bursts
- [ ] **Fixed Window Counter**: count requests per time window (e.g., 100/minute)
  - [ ] Simple, but burst at window boundary (200 in 2 seconds across boundary)
- [ ] **Sliding Window Log**: track timestamp of each request, count in rolling window
  - [ ] Accurate, but memory-intensive
- [ ] **Sliding Window Counter**: hybrid — weighted count from current + previous window
  - [ ] Good accuracy, low memory

## Module 3: Implementation Layers
- [ ] **API Gateway** (Kong, Spring Cloud Gateway): first line of defense, per-client/per-route
- [ ] **Service level** (Resilience4j `@RateLimiter`): protect individual service
- [ ] **Database level**: connection pool limits, query timeouts
- [ ] **Distributed rate limiting**: Redis-based (shared counter across instances)
  - [ ] Redis `INCR` + `EXPIRE` for fixed window
  - [ ] Redis + Lua script for sliding window (atomic operations)
- [ ] **Client-side rate limiting**: respect `Retry-After`, client-side token bucket

## Module 4: HTTP & Best Practices
- [ ] **Response**: `429 Too Many Requests`
- [ ] **Headers**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`, `Retry-After`
- [ ] **Rate limit by**: API key, user ID, IP address, or combination
- [ ] **Tiered limits**: free tier (100/hr), pro (10K/hr), enterprise (unlimited)
- [ ] **Graceful degradation**: return cached/stale data instead of 429 for critical endpoints
- [ ] **Monitoring**: track rate limit hits, identify abusive clients, alert on unusual patterns
- [ ] **Anti-pattern**: rate limiting without informing clients (no headers, no docs)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 2 | Implement token bucket and sliding window — compare burst handling |
| Module 3 | Redis-based distributed rate limiter with Lua script for atomicity |
| Module 4 | Add rate limiting to REST API with proper headers, test with load tool |

## Key Resources
- "Rate Limiting" - Stripe engineering blog
- Resilience4j RateLimiter documentation
- System Design Interview - Alex Xu (Chapter: Rate Limiter)
- Kong Rate Limiting plugin documentation
