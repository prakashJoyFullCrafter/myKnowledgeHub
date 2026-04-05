# Spring Batch - Curriculum

## Module 1: Batch Concepts
- [ ] Batch processing vs real-time processing
- [ ] Spring Batch architecture: Job -> Step -> (Reader, Processor, Writer)
- [ ] `JobRepository` and metadata tables
- [ ] `JobLauncher` and execution
- [ ] `JobParameters` for parameterized execution

## Module 2: Chunk-Based Processing
- [ ] Chunk-oriented step: read -> process -> write in chunks
- [ ] `ItemReader`: `FlatFileItemReader`, `JdbcCursorItemReader`, `JpaPagingItemReader`
- [ ] `ItemProcessor`: transformation and filtering
- [ ] `ItemWriter`: `FlatFileItemWriter`, `JdbcBatchItemWriter`, `JpaItemWriter`
- [ ] Chunk size tuning for performance
- [ ] Custom readers, processors, writers

## Module 3: Tasklet-Based Processing
- [ ] `Tasklet` interface for simple tasks
- [ ] File cleanup, API calls, notifications
- [ ] Tasklet vs chunk: when to use each

## Module 4: Flow Control
- [ ] Sequential steps
- [ ] Conditional flow: `on("COMPLETED").to(step2).on("FAILED").to(errorStep)`
- [ ] Parallel steps with split/flow
- [ ] Decider: `JobExecutionDecider`
- [ ] Nested jobs (job within a job)

## Module 5: Error Handling & Restart
- [ ] Skip policy: skip N errors and continue
- [ ] Retry policy: retry on specific exceptions
- [ ] `@Retryable` and `@Recover`
- [ ] Restart from last failed chunk (restart capability)
- [ ] Listeners: `JobExecutionListener`, `StepExecutionListener`, `ItemReadListener`

## Module 6: Scaling
- [ ] Multi-threaded step (`TaskExecutor`)
- [ ] Parallel steps (split)
- [ ] Partitioning: divide data across threads/nodes
- [ ] Remote chunking: distribute processing across JVMs
- [ ] Async item processor and writer

## Module 7: Spring Batch with Spring Boot
- [ ] Auto-configuration and `@EnableBatchProcessing`
- [ ] Scheduling batch jobs with `@Scheduled`
- [ ] Monitoring with Actuator
- [ ] Testing batch jobs: `JobLauncherTestUtils`
- [ ] Spring Batch + Kubernetes CronJob

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | CSV to database ETL job |
| Module 4 | Multi-step job with conditional flow |
| Module 5 | Batch job with skip, retry, and restart |
| Modules 6-7 | Partitioned batch processing for large dataset |

## Key Resources
- Spring Batch Reference Documentation
- The Definitive Guide to Spring Batch - Michael Minella
