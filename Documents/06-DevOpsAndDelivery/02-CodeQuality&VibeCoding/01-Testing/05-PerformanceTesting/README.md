# Performance Testing - Curriculum

## Module 1: Types of Performance Testing
- [ ] **Load testing**: expected traffic — does the system meet SLOs under normal load?
- [ ] **Stress testing**: push beyond limits — find the breaking point
- [ ] **Spike testing**: sudden traffic burst — does the system recover?
- [ ] **Soak testing (endurance)**: sustained load over hours/days — find memory leaks, resource exhaustion
- [ ] **Capacity testing**: how much hardware/instances are needed for X users?
- [ ] **Scalability testing**: does adding resources actually help (linear vs sub-linear scaling)?
- [ ] **Benchmark testing**: micro-level — JMH for code, isolated component benchmarks

## Module 2: Key Metrics
- [ ] **Latency**: response time (p50, p95, p99, p99.9 — percentiles, not averages!)
- [ ] **Throughput**: requests per second (RPS), transactions per second (TPS)
- [ ] **Error rate**: % of failed requests
- [ ] **Saturation**: CPU, memory, disk I/O, network utilization
- [ ] **Concurrency**: simultaneous users / connections
- [ ] **Why averages lie**: bimodal distributions, long tail — always use percentiles
- [ ] **Coordinated omission**: tools waiting for slow responses miss real latency spikes
- [ ] **Apdex score**: user satisfaction metric

## Module 3: JMeter
- [ ] Apache JMeter: GUI-based load testing tool, Java-based
- [ ] **Test plan structure**: Thread Group → Samplers → Listeners
- [ ] **Thread Group**: virtual users (threads), ramp-up time, loop count
- [ ] **Samplers**: HTTP Request, JDBC Request, FTP Request
- [ ] **Listeners**: View Results Tree, Aggregate Report, Summary Report
- [ ] **Assertions**: response time, response code, response body
- [ ] **CSV Data Set Config**: parameterized testing with test data
- [ ] **Distributed testing**: master + slaves for high load
- [ ] **JMeter + Jenkins** for CI integration
- [ ] Pros: mature, GUI, plugins. Cons: heavy, not scriptable like code

## Module 4: Gatling
- [ ] Gatling: code-first load testing tool, Scala/Kotlin/Java DSL
- [ ] **Simulation**: extends `Simulation`, defines scenarios
- [ ] **HTTP DSL**: `http("name").get("/api/users").check(status.is(200))`
- [ ] **Injection profiles**: `atOnceUsers(100)`, `rampUsers(100).during(60.seconds)`, `constantUsersPerSec(50).during(5.minutes)`
- [ ] **Feeders**: data sources for parameterization (CSV, JSON, JDBC)
- [ ] **Checks**: response validation
- [ ] **HTML reports**: built-in detailed reports with percentiles
- [ ] **Gatling vs JMeter**: Gatling is faster, lower memory, code-first; JMeter is GUI-driven, mature ecosystem

## Module 5: k6 (Modern Load Testing)
- [ ] k6: developer-friendly load testing tool, JavaScript scripting
- [ ] Modern, lightweight, designed for CI/CD
- [ ] **Test script**: ES6 JavaScript with `import http from 'k6/http'`
- [ ] **VUs (Virtual Users)** and **iterations**: control concurrency
- [ ] **Stages**: ramp-up, sustain, ramp-down
- [ ] **Thresholds**: pass/fail criteria — fail build if p95 > 500ms
- [ ] **Checks**: assertions on responses
- [ ] **Output**: console, JSON, InfluxDB, Prometheus, Datadog
- [ ] **k6 Cloud**: managed load generation
- [ ] **Best for**: CI integration, modern dev workflows, simple scripts

## Module 6: Java Microbenchmark Harness (JMH)
- [ ] JMH: micro-benchmarking framework for Java code
- [ ] **Why not just System.nanoTime()?**: JIT warmup, dead code elimination, instruction reordering — manual benchmarks LIE
- [ ] **`@Benchmark`** — marks a method as benchmark
- [ ] **`@Warmup(iterations = 5)`** — JIT warmup before measurement
- [ ] **`@Measurement(iterations = 10)`** — actual measurement runs
- [ ] **`@BenchmarkMode`**: Throughput, AverageTime, SampleTime, SingleShotTime
- [ ] **`@OutputTimeUnit`** — control output unit
- [ ] **`Blackhole`**: prevent dead code elimination, consume results
- [ ] **`@State(Scope.Benchmark)`** — shared state across iterations
- [ ] Use case: measure micro-optimizations, compare algorithms, JVM tuning experiments

## Module 7: Performance Testing in CI/CD
- [ ] **Pre-deploy gate**: fail build if perf regression detected
- [ ] **Baseline tracking**: store previous run results, compare
- [ ] **Threshold-based pass/fail**: e.g., p95 < 500ms or fail
- [ ] **Test environments**: prod-like infrastructure, prod-like data volume
- [ ] **GitHub Actions / Jenkins integration**: run k6/Gatling in pipeline
- [ ] **Continuous performance testing**: scheduled tests against staging
- [ ] **Alerting on regression**: notify team on perf degradation
- [ ] **Avoid testing in prod**: use staging or dedicated perf env (load can affect real users)

## Module 8: Performance Testing Best Practices
- [ ] **Test realistic scenarios**: real user flows, not just single endpoints
- [ ] **Use realistic data**: production-like data volume and distribution
- [ ] **Warm up the system**: JIT, caches, connection pools before measuring
- [ ] **Run tests multiple times**: average results, look for variance
- [ ] **Isolate the test**: no other workloads on test environment
- [ ] **Monitor everything**: app metrics, JVM metrics, OS metrics, DB metrics
- [ ] **Profile during load**: async-profiler, JFR — find bottlenecks
- [ ] **Correlate metrics**: latency spike + GC pause + CPU spike = JVM issue
- [ ] **Test what matters**: critical user journeys, not every endpoint
- [ ] **Performance budget**: define acceptable limits before testing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Define performance budget (SLOs) for an API: latency, throughput, error rate |
| Module 3 | Build JMeter test plan for a checkout flow, run with 100 VUs |
| Module 4 | Same scenario in Gatling — compare DSL ergonomics and report quality |
| Module 5 | Add k6 load test to GitHub Actions, fail build on p95 > 500ms |
| Module 6 | Benchmark `ArrayList` vs `LinkedList` insertion with JMH |
| Module 7 | Set up nightly performance test against staging, alert on regression |
| Module 8 | Run load test, identify bottleneck with async-profiler flame graph |

## Key Resources
- "Java Performance" - Scott Oaks
- Gatling documentation (gatling.io)
- k6 documentation (k6.io)
- JMH documentation (openjdk.org/projects/code-tools/jmh)
- "The Art of Application Performance Testing" - Ian Molyneaux
- Brendan Gregg's blog (brendangregg.com) — performance analysis
