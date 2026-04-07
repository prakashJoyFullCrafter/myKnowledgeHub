# Java Concurrency - Curriculum

## Module 1: Threads Fundamentals
- [ ] What is a thread? Process vs thread
- [ ] Creating threads: `Thread` class vs `Runnable` interface
- [ ] `Callable<V>` and `Future<V>` - returning results from threads
- [ ] Thread lifecycle: NEW -> RUNNABLE -> BLOCKED -> WAITING -> TIMED_WAITING -> TERMINATED
- [ ] `start()` vs `run()` - why `run()` doesn't create a new thread
- [ ] `sleep()`, `join()`, `yield()`
- [ ] Daemon threads vs user threads
- [ ] Thread priority and why not to rely on it

## Module 2: Synchronization & Thread Safety
- [ ] Race conditions and critical sections
- [ ] `synchronized` keyword (method-level and block-level)
- [ ] Intrinsic locks (monitor locks)
- [ ] `volatile` keyword - visibility guarantee, no atomicity
- [ ] Happens-before relationship
- [ ] Double-checked locking (and why it's tricky)
- [ ] Thread-safe singleton patterns
- [ ] Deadlock: causes, detection, prevention
- [ ] Livelock and starvation

## Module 3: Java Memory Model (JMM)
- [ ] Main memory vs thread-local cache
- [ ] Visibility problem
- [ ] Reordering and instruction-level parallelism
- [ ] `happens-before` guarantees
- [ ] `final` fields and safe publication
- [ ] Why `volatile` alone is not enough for compound operations

## Module 4: java.util.concurrent - Locks
- [ ] `ReentrantLock` - explicit locking, `lock()`, `unlock()`, `tryLock()`
- [ ] `ReadWriteLock` / `ReentrantReadWriteLock` - multiple readers, single writer
- [ ] `StampedLock` (Java 8+) - optimistic reads
- [ ] `Condition` - `await()`, `signal()` (replacement for `wait()`/`notify()`)
- [ ] Lock vs synchronized - when to use which

## Module 5: Atomic Classes
- [ ] `AtomicInteger`, `AtomicLong`, `AtomicBoolean`
- [ ] `AtomicReference`, `AtomicStampedReference`
- [ ] Compare-and-Swap (CAS) operation
- [ ] `LongAdder`, `LongAccumulator` - high-contention counters (Java 8+)
- [ ] When atomics are enough vs when you need locks

![img.png](img.png)## Module 6: Concurrent Collections
- [ ] `ConcurrentHashMap` - segment locking, `compute()`, `merge()`
- [ ] `CopyOnWriteArrayList` / `CopyOnWriteArraySet` - read-heavy workloads
- [ ] `ConcurrentLinkedQueue` / `ConcurrentLinkedDeque`
- [ ] `BlockingQueue` implementations:
  - [ ] `ArrayBlockingQueue` - bounded
  - [ ] `LinkedBlockingQueue` - optionally bounded
  - [ ] `PriorityBlockingQueue` - priority-based
  - [ ] `SynchronousQueue` - zero-capacity handoff
- [ ] `BlockingDeque` and `LinkedBlockingDeque`
- [ ] `ConcurrentSkipListMap` / `ConcurrentSkipListSet`

## Module 7: Executor Framework
- [ ] Why not to create threads manually
- [ ] `ExecutorService` interface
- [ ] `Executors` factory methods:
  - [ ] `newFixedThreadPool(n)` - fixed size
  - [ ] `newCachedThreadPool()` - elastic
  - [ ] `newSingleThreadExecutor()` - sequential
  - [ ] `newScheduledThreadPool(n)` - delayed/periodic tasks
- [ ] `ThreadPoolExecutor` - custom configuration (core size, max size, queue, rejection policy)
- [ ] `submit()` vs `execute()`
- [ ] `Future`, `get()`, `cancel()`, `isDone()`
- [ ] `invokeAll()` and `invokeAny()`
- [ ] Proper shutdown: `shutdown()` vs `shutdownNow()`

## Module 8: CompletableFuture (Java 8+)
- [ ] Creating: `supplyAsync()`, `runAsync()`
- [ ] Chaining: `thenApply()`, `thenAccept()`, `thenRun()`
- [ ] Composing: `thenCompose()` (flatMap), `thenCombine()` (zip)
- [ ] Error handling: `exceptionally()`, `handle()`, `whenComplete()`
- [ ] Combining multiple: `allOf()`, `anyOf()`
- [ ] Custom executor with `CompletableFuture`
- [ ] `CompletableFuture` vs `Future` - why it's a game-changer
- [ ] Real-world: parallel API calls, async pipelines

## Module 9: Fork/Join Framework
- [ ] Divide-and-conquer parallelism
- [ ] `ForkJoinPool` and work-stealing algorithm
- [ ] `RecursiveTask<V>` (returns result) and `RecursiveAction` (void)
- [ ] `fork()`, `join()`, `compute()`
- [ ] Common pool: `ForkJoinPool.commonPool()`
- [ ] Parallel streams use Fork/Join under the hood

## Module 10: Synchronization Utilities
- [ ] `CountDownLatch` - wait for N events
- [ ] `CyclicBarrier` - threads wait for each other
- [ ] `Semaphore` - limit concurrent access
- [ ] `Phaser` - flexible barrier (Java 7+)
- [ ] `Exchanger` - two threads swap data
- [ ] Real-world use cases for each

## Module 11: Virtual Threads (Java 21+)
- [ ] Platform threads vs virtual threads
- [ ] Creating virtual threads: `Thread.ofVirtual()`, `Executors.newVirtualThreadPerTaskExecutor()`
- [ ] Why virtual threads change the game (millions of threads)
- [ ] Pinning: `synchronized` blocks pin virtual thread to carrier → prefer `ReentrantLock`
- [ ] Virtual threads + I/O: blocking calls no longer waste OS threads
- [ ] Migration strategy: replace `newFixedThreadPool` with `newVirtualThreadPerTaskExecutor` for I/O-bound

### Module 12: Structured Concurrency (Java 24+)
- [ ] `StructuredTaskScope` - subtasks have bounded lifecycle tied to parent
- [ ] `ShutdownOnFailure` - cancel all subtasks on first failure
- [ ] `ShutdownOnSuccess` - cancel remaining on first success
- [ ] `fork()` to submit subtasks, `join()` to await, `throwIfFailed()` to propagate
- [ ] Why: prevents thread leaks, auto-cancellation, clear parent-child relationship
- [ ] Replaces manual `ExecutorService` + `Future` + `try-finally` patterns

### Module 13: Scoped Values (Java 24+)
- [ ] `ScopedValue<T>` - replacement for `ThreadLocal` in virtual thread era
- [ ] `ScopedValue.where(KEY, value).run(() -> ...)` - bounded scope
- [ ] Immutable within scope (unlike `ThreadLocal`)
- [ ] Automatic inheritance by child virtual threads
- [ ] Why `ThreadLocal` is problematic: unbounded lifetime, mutable, memory leaks, costly with virtual threads
- [ ] Migration: `ThreadLocal` → `ScopedValue` for request-scoped data (trace IDs, auth context)

## Module 14: Common Patterns & Best Practices
- [ ] Producer-Consumer pattern
- [ ] Thread pool sizing: CPU-bound vs I/O-bound formula
- [ ] Immutability as a concurrency strategy
- [ ] ThreadLocal and when to use it
- [ ] Avoid: `Thread.stop()`, `Thread.suspend()`, `Thread.resume()`
- [ ] Testing concurrent code: race condition detection
- [ ] Common pitfalls checklist

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a multi-threaded counter - observe race conditions, fix with synchronization |
| Modules 3-5 | Build a thread-safe bounded buffer using locks and atomics |
| Module 6 | Build a concurrent word frequency counter from multiple files |
| Modules 7-8 | Build an async web scraper using `ExecutorService` + `CompletableFuture` |
| Module 9 | Implement parallel merge sort using Fork/Join |
| Modules 10-11 | Build a rate limiter using `Semaphore`, then migrate to virtual threads |
| Module 12 | Refactor all previous projects applying best practices |

## Key Resources
- Java Concurrency in Practice - Brian Goetz (the bible)
- Effective Java - Joshua Bloch (Chapter 11: Concurrency)
- JEP 444: Virtual Threads
- Doug Lea's concurrency utilities documentation
