# Circuit Breaker — One-Page Cheat Sheet

## Definition
A circuit breaker is a resilience pattern that monitors calls to a downstream service and stops calls when failures exceed a threshold. It prevents cascading failures by failing fast and allowing automatic recovery through controlled probing.

---

## Core Components

| Component | Role | Key Property |
|----------|------|-------------|
| CLOSED State | Normal operation, forwards calls | Tracks failure rate |
| OPEN State | Blocks calls, fails fast | Wait timer |
| HALF_OPEN State | Tests recovery | Probe requests |
| Sliding Window | Observes recent calls | Count-based or time-based |
| Failure Threshold | Triggers OPEN | % failures |
| Slow Call Threshold | Detects latency issues | Duration + rate |
| Fallback | Response when OPEN | Preserves functionality |

---

## Key Algorithms / Protocols

- Failure rate calculation → failures / total calls in window  
- Sliding window (count/time-based) → rolling observation  
- Threshold-based state transition → CLOSED → OPEN  
- Timer-based recovery → OPEN → HALF_OPEN  
- Probe evaluation → HALF_OPEN → CLOSED/OPEN  
- Fail-fast principle → immediate rejection in OPEN  

---

## Performance Numbers (Typical)

- Fail-fast latency: < 1 ms  
- Normal call latency: downstream dependent (e.g., 50–200 ms)  
- Timeout thresholds: 2–5 seconds typical  
- Sliding window size: 50–100 calls  
- Failure threshold: ~50%  
- Probe count (HALF_OPEN): 5–10  
- Wait duration: 30–120 seconds  

---

## Configuration Knobs

| Parameter | Default | Tuning Guidance |
|----------|--------|----------------|
| failureRateThreshold | 50% | Lower for critical services |
| slowCallDurationThreshold | 2–5s | Align with SLA |
| slowCallRateThreshold | 80% | Enable for latency issues |
| slidingWindowSize | 100 | Smaller = faster detection |
| minimumNumberOfCalls | 20 | Prevent false trips |
| waitDurationInOpenState | 60s | Match recovery time |
| permittedCallsInHalfOpen | 10 | 5–10 typical |
| slidingWindowType | COUNT | TIME for variable traffic |

---

## Failure Modes & Mitigation

| Failure Mode | Mitigation |
|-------------|-----------|
| Cascading failure | Circuit breaker OPEN |
| Slow service (high latency) | Slow call threshold |
| False trips | Increase window/threshold |
| Missed trips | Lower threshold / enable slow call |
| Oscillation | Increase wait duration |

---

## When to Use vs NOT Use

| Use When | Avoid When |
|---------|-----------|
| Remote service calls | Local in-memory calls |
| Unreliable dependencies | Deterministic operations |
| Microservices | Simple monoliths |
| Network/IO heavy systems | CPU-bound logic |
| External APIs | Internal pure functions |

---

## Comparison vs Alternatives

| Pattern | Purpose | Difference |
|--------|--------|-----------|
| Retry | Handles transient errors | CB handles sustained failures |
| Timeout | Limits wait time | CB tracks patterns |
| Bulkhead | Limits concurrency | CB stops calls entirely |
| Rate Limiter | Controls traffic | CB reacts to failure |
| Fallback | Provides alternative | Used WITH CB |

---

## Common Pitfalls

- Counting business errors (4xx) as failures  
- Wrong ordering (Retry outside Circuit Breaker)  
- Too small sliding window → false trips  
- Too short wait duration → oscillation  
- Missing fallback handling (exceptions leak)  
