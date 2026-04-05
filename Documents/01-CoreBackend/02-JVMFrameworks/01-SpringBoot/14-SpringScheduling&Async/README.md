# Spring Scheduling & Async - Curriculum

## Module 1: Task Scheduling
- [ ] `@EnableScheduling`
- [ ] `@Scheduled(fixedRate = 5000)` - fixed rate execution
- [ ] `@Scheduled(fixedDelay = 5000)` - fixed delay after completion
- [ ] `@Scheduled(cron = "0 0 * * * *")` - cron expressions
- [ ] Cron syntax: second, minute, hour, day, month, weekday
- [ ] `@Scheduled(initialDelay = 10000)` - delay first execution
- [ ] Dynamic scheduling with `SchedulingConfigurer` and `TaskScheduler`
- [ ] Distributed scheduling problem (multiple instances)
- [ ] ShedLock: distributed lock for scheduled tasks
- [ ] Quartz Scheduler integration for advanced needs

## Module 2: Async Processing
- [ ] `@EnableAsync`
- [ ] `@Async` on methods - run in separate thread
- [ ] `@Async` with return: `CompletableFuture<T>`
- [ ] Custom `TaskExecutor` configuration (pool size, queue capacity)
- [ ] Named executors: `@Async("emailExecutor")`
- [ ] Exception handling in async methods (`AsyncUncaughtExceptionHandler`)
- [ ] `@Async` + `@Transactional` gotchas (proxy issues)

## Module 3: Thread Pool Configuration
- [ ] `ThreadPoolTaskExecutor`: core size, max size, queue capacity
- [ ] Rejection policies: `AbortPolicy`, `CallerRunsPolicy`, `DiscardPolicy`
- [ ] Virtual threads executor (Spring Boot 3.2+ / Java 21)
- [ ] `spring.threads.virtual.enabled=true`
- [ ] Monitoring thread pools with Micrometer
- [ ] Sizing: CPU-bound vs I/O-bound workloads

## Module 4: Best Practices
- [ ] Never use `@Scheduled` and `@Async` on same method
- [ ] Self-invocation problem with `@Async` (same as AOP)
- [ ] Graceful shutdown: `setWaitForTasksToCompleteOnShutdown(true)`
- [ ] Idempotency for scheduled tasks
- [ ] Health checks for scheduled jobs
- [ ] Logging and monitoring scheduled task execution

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a data sync job running every 5 minutes |
| Module 2 | Async email sender with CompletableFuture |
| Module 3 | Configure separate executors for different task types |
| Module 4 | Add ShedLock for distributed scheduled tasks |

## Key Resources
- Spring Task Execution and Scheduling Reference
- ShedLock documentation
- Quartz Scheduler with Spring Boot
