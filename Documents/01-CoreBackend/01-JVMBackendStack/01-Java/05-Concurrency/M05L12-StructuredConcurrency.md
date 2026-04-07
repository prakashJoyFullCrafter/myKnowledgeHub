# Java Structured Concurrency — Complete Study Guide

> **Java 21 Preview → Java 24 Finalized | Brutally Detailed Reference**
> Covers `StructuredTaskScope`, `ShutdownOnFailure`, `ShutdownOnSuccess`, the full fork/join/throwIfFailed lifecycle, why structured concurrency exists, and every pattern it replaces. Every section includes full working examples.

---

## Table of Contents

1. [The Problem — Why Structured Concurrency Exists](#1-the-problem--why-structured-concurrency-exists)
2. [The Core Idea — Structure and Scope](#2-the-core-idea--structure-and-scope)
3. [`StructuredTaskScope` — The Base Class](#3-structuredtaskscope--the-base-class)
4. [`ShutdownOnFailure` — Cancel All on First Failure](#4-shutdownonfailure--cancel-all-on-first-failure)
5. [`ShutdownOnSuccess` — Cancel Remaining on First Success](#5-shutdownonsuccess--cancel-remaining-on-first-success)
6. [The Lifecycle — `fork()`, `join()`, `throwIfFailed()`](#6-the-lifecycle--fork-join-throwiffailed)
7. [Virtual Threads and Structured Concurrency](#7-virtual-threads-and-structured-concurrency)
8. [Replacing Manual `ExecutorService` + `Future` Patterns](#8-replacing-manual-executorservice--future-patterns)
9. [Nesting and Composition](#9-nesting-and-composition)
10. [Custom `StructuredTaskScope` Subclasses](#10-custom-structuredtaskscope-subclasses)
11. [Error Handling In Depth](#11-error-handling-in-depth)
12. [Cancellation and Interruption](#12-cancellation-and-interruption)
13. [Real-World Patterns](#13-real-world-patterns)
14. [Edge Cases and Gotchas](#14-edge-cases-and-gotchas)
15. [Quick Reference Cheat Sheet](#15-quick-reference-cheat-sheet)

---

## 1. The Problem — Why Structured Concurrency Exists

### 1.1 Unstructured Concurrency — The Status Quo (Pre-Java 21)

Traditional Java concurrency with `ExecutorService` and `Future` suffers from a fundamental problem: **the relationship between a spawned task and its parent is not enforced by the language or runtime**. Tasks can outlive their logical owner, errors can be silently lost, and cleanup is error-prone.

```java
// THE OLD WAY — a maze of failure modes
public UserProfile loadUserProfile(long userId) throws Exception {
    ExecutorService executor = Executors.newFixedThreadPool(2);

    Future<User>   userFuture   = executor.submit(() -> fetchUser(userId));
    Future<Orders> ordersFuture = executor.submit(() -> fetchOrders(userId));

    try {
        User   user   = userFuture.get();    // blocks here
        Orders orders = ordersF uture.get(); // blocks here
        return new UserProfile(user, orders);
    } finally {
        executor.shutdown();
    }
}
```

What goes wrong with this code?

**Problem 1 — Thread leak on first failure:**
If `userFuture.get()` throws (e.g. the DB is down), we immediately go to `finally`. But `ordersFuture` is still running in the background — there is nothing to cancel it. That thread runs until it finishes or times out, consuming resources for work whose results will never be used.

**Problem 2 — Errors lost across threads:**
If `fetchOrders()` throws, the exception is swallowed inside the `Future`. `ordersFuture.get()` would re-throw it, but since we already crashed on `userFuture.get()`, we never call `ordersF uture.get()`. The orders error is invisible.

**Problem 3 — No structural relationship:**
There is nothing in the code that expresses "these two tasks belong together and live and die together." The executor is a shared, global-ish resource. The tasks have no parent.

**Problem 4 — Interruption does not propagate:**
If the calling thread is interrupted (e.g. the HTTP request is cancelled), `userFuture.get()` throws `InterruptedException`, but the background tasks are not interrupted. They keep running.

**Problem 5 — Shutdown is fragile:**
`executor.shutdown()` is in `finally`, but what if the `ExecutorService` constructor itself threw? What if the code is refactored and `finally` is missed? Every usage requires manual plumbing.

### 1.2 The Fundamental Issue — Concurrency Without Structure

In normal sequential code, structure is guaranteed:

```java
// Sequential — structure enforced by the language
void process() {
    User user     = fetchUser();    // must complete before next line
    Orders orders = fetchOrders();  // must complete before return
    return new UserProfile(user, orders);
}
// When process() returns, ALL its work is done. Always. Guaranteed.
```

When we introduce threads, this guarantee vanishes:

```java
// Unstructured concurrent — structure is NOT enforced
void process() {
    executor.submit(() -> fetchUser());    // may still run after process() returns!
    executor.submit(() -> fetchOrders()); // may still run after process() returns!
    // ... process() returns here, but the tasks may be anywhere
}
```

### 1.3 Structured Concurrency — The Solution

Structured concurrency enforces the same structural guarantee for concurrent code that sequential code gets for free:

> **When a scope exits, ALL tasks forked inside it have either completed or been cancelled.**

No task can outlive its scope. No thread can leak. This mirrors how structured programming (loops, functions, try/catch) tamed sequential code in the 1970s.

---

## 2. The Core Idea — Structure and Scope

### 2.1 The Scope as a Unit of Work

A `StructuredTaskScope` is a **bounded container** for a group of related tasks. Think of it as a "team" — the team lead (the scope) tracks all team members (subtasks), and the team is not "done" until every member is accounted for.

```
Calling thread
     │
     │  try (var scope = new StructuredTaskScope<>()) {
     │       │
     │  fork─┼──► subtask 1 (runs on virtual thread)
     │       │
     │  fork─┼──► subtask 2 (runs on virtual thread)
     │       │
     │  fork─┼──► subtask 3 (runs on virtual thread)
     │       │
     │  scope.join() ◄── calling thread blocks here
     │       │
     │       ├── subtask 1 completes ✓
     │       ├── subtask 2 completes ✓
     │       ├── subtask 3 completes ✓
     │       │
     │  }  ◄── scope closes: ALL subtasks guaranteed done or cancelled
     │
     │  (continue with results)
```

### 2.2 The Invariant

The key invariant that `StructuredTaskScope` enforces:

1. Subtasks are forked **inside** the scope
2. `join()` **waits** for the shutdown policy condition to be met
3. On scope **close** (the `try-with-resources` exit), all forked subtasks that have not completed are **cancelled**
4. The calling thread **cannot escape the scope** while subtasks are running

This means the lifetime diagram is always:

```
Scope opens
  ├── fork subtask A  ──► A runs...
  ├── fork subtask B  ──► B runs...
  │   scope.join()
  │   (all policies satisfied)
Scope closes ── A and B are GUARANTEED done or cancelled
```

---

## 3. `StructuredTaskScope` — The Base Class

### 3.1 Class Overview

```java
// In java.util.concurrent (Java 24+)
public class StructuredTaskScope<T> implements AutoCloseable {

    // Create a scope (uses virtual threads by default)
    public StructuredTaskScope() { ... }
    public StructuredTaskScope(String name, ThreadFactory factory) { ... }

    // Fork a subtask — returns a Subtask handle
    public <U extends T> Subtask<U> fork(Callable<? extends U> task) { ... }

    // Wait for the shutdown policy condition
    public StructuredTaskScope<T> join() throws InterruptedException { ... }

    // Wait with a deadline
    public StructuredTaskScope<T> joinUntil(Instant deadline)
        throws InterruptedException, TimeoutException { ... }

    // Trigger shutdown (cancel remaining subtasks)
    protected void shutdown() { ... }

    // Called when a subtask completes — override in subclasses
    protected void handleComplete(Subtask<? extends T> subtask) { ... }

    // Must be called after join() — validates join was called
    @Override
    public void close() { ... }

    // Inner interface representing a forked task
    public sealed interface Subtask<T> extends Supplier<T> {
        enum State { UNAVAILABLE, SUCCESS, FAILED }
        State state();
        T get();                 // result — throws if not SUCCESS
        Throwable exception();   // cause — only if FAILED
    }
}
```

### 3.2 Basic Usage Pattern

```java
import java.util.concurrent.StructuredTaskScope;
import java.util.concurrent.StructuredTaskScope.Subtask;

try (var scope = new StructuredTaskScope<String>()) {

    // fork() submits a Callable and returns a Subtask handle immediately
    Subtask<String> task1 = scope.fork(() -> fetchDataFromServiceA());
    Subtask<String> task2 = scope.fork(() -> fetchDataFromServiceB());
    Subtask<String> task3 = scope.fork(() -> fetchDataFromServiceC());

    // join() blocks until ALL forked tasks have finished (in base class)
    scope.join();

    // After join(), examine results
    System.out.println("A: " + task1.get());
    System.out.println("B: " + task2.get());
    System.out.println("C: " + task3.get());

} // close() — cancels any still-running tasks, releases resources
```

### 3.3 `Subtask.State` — Lifecycle of a Forked Task

```java
// A Subtask passes through these states:
// UNAVAILABLE → (running) → SUCCESS or FAILED

Subtask.State state = subtask.state();

switch (state) {
    case UNAVAILABLE -> // task not yet done (only valid before join() returns,
                        // or if task was cancelled by shutdown)
    case SUCCESS     -> // task completed normally — subtask.get() returns result
    case FAILED      -> // task threw an exception — subtask.exception() returns cause
}
```

### 3.4 `Subtask.get()` After `join()`

After `join()` returns, each `Subtask` is in either `SUCCESS` or `FAILED` state (or `UNAVAILABLE` if shutdown was triggered before the task completed).

```java
try (var scope = new StructuredTaskScope<Integer>()) {
    Subtask<Integer> good = scope.fork(() -> 42);
    Subtask<Integer> bad  = scope.fork(() -> { throw new RuntimeException("oops"); });

    scope.join();

    System.out.println(good.state());      // SUCCESS
    System.out.println(good.get());        // 42

    System.out.println(bad.state());       // FAILED
    System.out.println(bad.exception());   // java.lang.RuntimeException: oops

    // Calling get() on a FAILED subtask throws the original exception wrapped
    try {
        bad.get(); // throws IllegalStateException wrapping RuntimeException
    } catch (IllegalStateException e) {
        System.out.println("get() on failed: " + e.getCause().getMessage()); // oops
    }
}
```

---

## 4. `ShutdownOnFailure` — Cancel All on First Failure

`ShutdownOnFailure` implements the **"all must succeed"** policy: if any subtask fails, the scope shuts down immediately, cancelling all remaining subtasks. This is the right choice when you need ALL results and one failure makes the whole operation pointless.

### 4.1 Class Overview

```java
public final class StructuredTaskScope.ShutdownOnFailure
        extends StructuredTaskScope<Object> {

    public ShutdownOnFailure() { ... }
    public ShutdownOnFailure(String name, ThreadFactory factory) { ... }

    // Re-throws the exception from the first failed subtask (if any)
    // Must be called after join()
    public void throwIfFailed() throws ExecutionException { ... }

    // Variant that maps the exception before throwing
    public <X extends Throwable> void throwIfFailed(
            Function<Throwable, ? extends X> esf) throws X { ... }

    // Returns the exception from the first failed subtask, if any
    public Optional<Throwable> exception() { ... }
}
```

### 4.2 The Standard Pattern

```java
import java.util.concurrent.StructuredTaskScope;
import java.util.concurrent.StructuredTaskScope.ShutdownOnFailure;
import java.util.concurrent.StructuredTaskScope.Subtask;
import java.util.concurrent.ExecutionException;

public UserProfile loadUserProfile(long userId)
        throws ExecutionException, InterruptedException {

    try (var scope = new ShutdownOnFailure()) {

        Subtask<User>   user   = scope.fork(() -> fetchUser(userId));
        Subtask<Orders> orders = scope.fork(() -> fetchOrders(userId));

        // join() waits until ALL tasks complete OR any task fails (triggers shutdown)
        scope.join()
             .throwIfFailed(); // throws ExecutionException wrapping the first failure

        // Reach here only if BOTH tasks succeeded
        return new UserProfile(user.get(), orders.get());
    }
}
```

**What happens on failure:**

```
fork(fetchUser)   ──────────────────────────────► completes (5ms)
fork(fetchOrders) ──────── THROWS RuntimeException (2ms)
                                   │
                           ShutdownOnFailure triggers shutdown()
                                   │
                           fetchUser thread receives interrupt
                           (if it's blocked on I/O, it will unblock)
                                   │
                  scope.join() returns
                  throwIfFailed() re-throws as ExecutionException
```

### 4.3 `throwIfFailed()` in Detail

`throwIfFailed()` does nothing if all tasks succeeded. If one or more failed, it throws an `ExecutionException` whose cause is the exception from the **first** task that failed (by time of detection):

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> t1 = scope.fork(() -> { Thread.sleep(100); return "ok"; });
    Subtask<String> t2 = scope.fork(() -> { throw new IOException("DB down"); });
    Subtask<String> t3 = scope.fork(() -> { throw new TimeoutException("slow"); });

    scope.join().throwIfFailed();
    // ExecutionException thrown; cause is whichever of t2/t3 failed first

} catch (ExecutionException e) {
    System.out.println("Failed: " + e.getCause().getClass().getSimpleName());
    // IOException or TimeoutException — whichever hit first
}
```

### 4.4 `throwIfFailed(Function)` — Custom Exception Mapping

```java
// Map to a domain-specific exception instead of ExecutionException
public UserProfile loadUserProfile(long userId) throws ServiceException {
    try (var scope = new ShutdownOnFailure()) {

        Subtask<User>   user   = scope.fork(() -> fetchUser(userId));
        Subtask<Orders> orders = scope.fork(() -> fetchOrders(userId));

        scope.join().throwIfFailed(
            cause -> new ServiceException("Profile load failed for user " + userId, cause)
        );

        return new UserProfile(user.get(), orders.get());

    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
        throw new ServiceException("Interrupted", e);
    }
}
```

### 4.5 Checking `exception()` Without Throwing

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> t1 = scope.fork(() -> "result");
    Subtask<String> t2 = scope.fork(() -> { throw new RuntimeException("fail"); });

    scope.join();

    Optional<Throwable> failure = scope.exception();
    if (failure.isPresent()) {
        System.out.println("Failed: " + failure.get().getMessage()); // fail
        // handle without throwing
    } else {
        System.out.println("All succeeded: " + t1.get());
    }
}
```

### 4.6 `ShutdownOnFailure` — Full Behaviour Diagram

```
                    ShutdownOnFailure scope

  fork(task1) ──► task1 running ──────────────── SUCCESS → task1.state() = SUCCESS
  fork(task2) ──► task2 running ─── FAIL ─► shutdown() triggered
                                              │
  fork(task3) ──► task3 running ─────────────┼── receives interrupt → UNAVAILABLE
                                              │
                                         join() returns
                                         throwIfFailed() → throws ExecutionException(task2's cause)
```

---

## 5. `ShutdownOnSuccess` — Cancel Remaining on First Success

`ShutdownOnSuccess` implements the **"first to succeed wins"** policy: as soon as any subtask succeeds, the scope shuts down, cancelling all remaining subtasks. This is the right choice for hedged requests, fallback patterns, and race-to-first-result scenarios.

### 5.1 Class Overview

```java
public final class StructuredTaskScope.ShutdownOnSuccess<T>
        extends StructuredTaskScope<T> {

    public ShutdownOnSuccess() { ... }
    public ShutdownOnSuccess(String name, ThreadFactory factory) { ... }

    // Returns the result of the first successful subtask
    // Must be called after join()
    // Throws if NO subtask succeeded:
    //   ExecutionException if at least one subtask failed
    //   IllegalStateException if all subtasks were cancelled (never ran)
    public T result() throws ExecutionException { ... }

    // Variant that maps exception before throwing
    public <X extends Throwable> T result(
            Function<Throwable, ? extends X> esf) throws X { ... }
}
```

### 5.2 The Standard Pattern — Hedged Request

```java
import java.util.concurrent.StructuredTaskScope.ShutdownOnSuccess;

// Try three mirrors simultaneously; use whichever responds first
public byte[] fetchFromFastestMirror(String path)
        throws ExecutionException, InterruptedException {

    try (var scope = new ShutdownOnSuccess<byte[]>()) {

        scope.fork(() -> fetchFrom("mirror1.cdn.com", path));
        scope.fork(() -> fetchFrom("mirror2.cdn.com", path));
        scope.fork(() -> fetchFrom("mirror3.cdn.com", path));

        // join() returns as soon as ANY task succeeds (or all fail)
        scope.join();

        // result() returns the first successful result
        // Remaining mirrors are cancelled
        return scope.result();
    }
}
```

**What happens when the first succeeds:**

```
fork(mirror1) ──────────────────────────────────► still running (150ms)
fork(mirror2) ─────────── SUCCESS (80ms)
                               │
                    ShutdownOnSuccess triggers shutdown()
                               │
fork(mirror3) ─────────────────┼── running (60ms) → receives interrupt → cancelled
fork(mirror1) ─────────────────┼────────────────── receives interrupt → cancelled
                               │
                          join() returns
                          scope.result() → mirror2's byte[]
```

### 5.3 When ALL Subtasks Fail

If every subtask fails and none succeed, `scope.result()` throws an `ExecutionException` whose cause is the **last** failure:

```java
try (var scope = new ShutdownOnSuccess<String>()) {
    scope.fork(() -> { throw new IOException("mirror1 down"); });
    scope.fork(() -> { throw new IOException("mirror2 down"); });
    scope.fork(() -> { throw new IOException("mirror3 down"); });

    scope.join();

    try {
        String result = scope.result(); // all failed
    } catch (ExecutionException e) {
        System.out.println("All mirrors failed: " + e.getCause().getMessage());
    }
}
```

### 5.4 `result(Function)` — Custom Exception

```java
public byte[] fetchWithFallback(String path) throws ContentUnavailableException {
    try (var scope = new ShutdownOnSuccess<byte[]>()) {
        scope.fork(() -> fetchPrimary(path));
        scope.fork(() -> fetchSecondary(path));
        scope.fork(() -> fetchCache(path));

        scope.join();

        return scope.result(
            cause -> new ContentUnavailableException("All sources failed for: " + path, cause)
        );

    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
        throw new ContentUnavailableException("Interrupted", e);
    }
}
```

### 5.5 ShutdownOnSuccess as a Fallback/Timeout Race

A powerful pattern: race a "real" implementation against a timeout fallback:

```java
// Return the real result if it arrives in 500ms, otherwise return cached
public String getDataWithFallback(String key)
        throws ExecutionException, InterruptedException {

    try (var scope = new ShutdownOnSuccess<String>()) {
        // Task 1: try the real service
        scope.fork(() -> realService.fetch(key));

        // Task 2: wait 500ms then return cached value (always succeeds)
        scope.fork(() -> {
            Thread.sleep(500);
            return cache.get(key); // stale but available
        });

        scope.join();
        return scope.result(); // whichever finished first
    }
}
```

---

## 6. The Lifecycle — `fork()`, `join()`, `throwIfFailed()`

### 6.1 `fork(Callable<U> task)` — Submit a Subtask

`fork()` submits a `Callable` to run concurrently. It returns a `Subtask<U>` handle immediately (non-blocking). The task starts executing on a new virtual thread.

```java
// fork() is non-blocking — returns immediately
Subtask<String> handle = scope.fork(() -> {
    Thread.sleep(1000);
    return "done";
});
// handle.state() == UNAVAILABLE — task is running

// You can fork inside loops
List<Subtask<String>> handles = new ArrayList<>();
for (String url : urls) {
    handles.add(scope.fork(() -> fetchUrl(url)));
}
```

**Rules for `fork()`:**
- Must be called **before** `join()`
- Must be called from **within** the scope's owner thread (or a thread that is a descendant of it)
- After `join()` returns or shutdown occurs, calling `fork()` throws `IllegalStateException`

### 6.2 `join()` — Await the Shutdown Policy

`join()` blocks the calling thread until the scope's shutdown policy is satisfied:

| Scope type | `join()` returns when... |
|---|---|
| `StructuredTaskScope` (base) | **All** forked tasks have completed |
| `ShutdownOnFailure` | All succeed, OR the first one fails (triggers shutdown) |
| `ShutdownOnSuccess` | The first one succeeds (triggers shutdown), OR all fail |

```java
// join() returns this scope — enables fluent chaining
scope.join();                    // basic — blocks
scope.join().throwIfFailed();    // fluent — join, then check for failure

// join() throws InterruptedException if the calling thread is interrupted
try {
    scope.join();
} catch (InterruptedException e) {
    Thread.currentThread().interrupt(); // ALWAYS restore interrupt status
    // scope will be closed by try-with-resources, cancelling subtasks
}
```

### 6.3 `joinUntil(Instant deadline)` — Bounded Wait

Adds a hard deadline to `join()`. Throws `TimeoutException` if the deadline is reached before the policy is satisfied:

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> result = scope.fork(() -> slowOperation());

    try {
        scope.joinUntil(Instant.now().plusSeconds(5)); // max 5 seconds
        scope.throwIfFailed();
        System.out.println(result.get());

    } catch (TimeoutException e) {
        System.out.println("Timed out — cancelling");
        // scope.close() will cancel the still-running task
    }
}
```

### 6.4 `throwIfFailed()` — Propagate Failures

`throwIfFailed()` is a method on `ShutdownOnFailure` specifically. After `join()`, call it to surface any failure:

```java
// Full lifecycle — the canonical pattern
try (var scope = new ShutdownOnFailure()) {      // 1. open scope

    Subtask<A> a = scope.fork(this::fetchA);     // 2. fork tasks
    Subtask<B> b = scope.fork(this::fetchB);
    Subtask<C> c = scope.fork(this::fetchC);

    scope.join()                                  // 3. wait for completion
         .throwIfFailed();                        // 4. propagate any failure

    return combine(a.get(), b.get(), c.get());   // 5. use results

}                                                 // 6. close — cancel any stragglers
```

### 6.5 `close()` — The Safety Net

`close()` is called automatically by `try-with-resources`. It:
1. Calls `shutdown()` to cancel any remaining running subtasks
2. Waits for all subtasks to finish (after cancellation)
3. Throws `IllegalStateException` if `join()` was never called (programmer error guard)

```java
// close() guarantees no task outlives the scope — ALWAYS use try-with-resources
try (var scope = new ShutdownOnFailure()) {
    scope.fork(() -> longRunningTask());
    scope.join().throwIfFailed();
    // ...
} // ← close() called here — any still-running tasks are cancelled and awaited
```

**What happens if you forget `join()`:**

```java
try (var scope = new ShutdownOnFailure()) {
    scope.fork(() -> doWork());
    // FORGOT scope.join()
} // close() throws IllegalStateException: "Owner did not join before closing"
```

---

## 7. Virtual Threads and Structured Concurrency

### 7.1 Why Virtual Threads Are the Perfect Fit

Structured concurrency is designed to be used with **virtual threads** (Project Loom, Java 21+). Virtual threads are:
- **Lightweight** — millions can exist simultaneously (vs. thousands for OS threads)
- **Cheap to create** — creating one is ~microseconds, not milliseconds
- **Blocking-friendly** — blocking a virtual thread (I/O wait) is cheap; the carrier OS thread is released to do other work

This means `fork()` can spin up a new virtual thread for every subtask without the overhead concerns of OS threads.

```java
// Default constructor uses virtual thread factory — optimal
try (var scope = new ShutdownOnFailure()) {
    // Each fork() creates a new virtual thread — essentially free
    for (String url : thousandsOfUrls) {
        scope.fork(() -> fetch(url)); // thousands of virtual threads, no problem
    }
    scope.join().throwIfFailed();
}
```

### 7.2 Custom Thread Factory

You can provide a custom `ThreadFactory` — useful for naming threads for observability:

```java
ThreadFactory factory = Thread.ofVirtual()
    .name("profile-loader-", 0) // threads named: profile-loader-0, profile-loader-1, ...
    .factory();

try (var scope = new ShutdownOnFailure("profile-scope", factory)) {
    scope.fork(() -> fetchUser(userId));
    scope.fork(() -> fetchOrders(userId));
    scope.join().throwIfFailed();
}
```

### 7.3 Thread Dumps and Observability

Because structured concurrency creates a formal parent-child relationship, thread dumps in Java 21+ show the scope hierarchy. All virtual threads forked inside a named scope appear as children of that scope in `jcmd <pid> Thread.dump_to_file` output.

---

## 8. Replacing Manual `ExecutorService` + `Future` Patterns

### 8.1 Fan-Out / Gather — All Must Succeed

```java
// ═══════════════════════════════════════════════════════════
// OLD WAY — manual ExecutorService + CompletableFuture
// ═══════════════════════════════════════════════════════════
public UserProfile loadProfileOld(long userId) throws Exception {
    ExecutorService exec = Executors.newVirtualThreadPerTaskExecutor();
    try {
        CompletableFuture<User>   userF   = CompletableFuture.supplyAsync(() -> {
            try { return fetchUser(userId); }
            catch (Exception e) { throw new RuntimeException(e); }
        }, exec);
        CompletableFuture<Orders> ordersF = CompletableFuture.supplyAsync(() -> {
            try { return fetchOrders(userId); }
            catch (Exception e) { throw new RuntimeException(e); }
        }, exec);

        // allOf blocks until both complete — but doesn't cancel on first failure!
        try {
            CompletableFuture.allOf(userF, ordersF).join();
        } catch (CompletionException e) {
            userF.cancel(true);    // manual cleanup
            ordersF.cancel(true);  // manual cleanup
            throw e.getCause() instanceof Exception ex ? ex : e;
        }

        return new UserProfile(userF.join(), ordersF.join());
    } finally {
        exec.shutdown(); // easy to forget
    }
}

// ═══════════════════════════════════════════════════════════
// NEW WAY — StructuredTaskScope.ShutdownOnFailure
// ═══════════════════════════════════════════════════════════
public UserProfile loadProfileNew(long userId)
        throws ExecutionException, InterruptedException {
    try (var scope = new ShutdownOnFailure()) {
        Subtask<User>   user   = scope.fork(() -> fetchUser(userId));
        Subtask<Orders> orders = scope.fork(() -> fetchOrders(userId));
        scope.join().throwIfFailed();
        return new UserProfile(user.get(), orders.get());
    }
}
```

**The new version:**
- Auto-cancels the other task on failure ✓
- No thread leak ✓
- No manual `executor.shutdown()` ✓
- No exception wrapping/unwrapping boilerplate ✓
- Half the lines ✓

### 8.2 Hedged Request — First to Succeed

```java
// ═══════════════════════════════════════════════════════════
// OLD WAY
// ═══════════════════════════════════════════════════════════
public String hedgedRequestOld(String query) throws Exception {
    ExecutorService exec = Executors.newFixedThreadPool(3);
    CompletionService<String> cs = new ExecutorCompletionService<>(exec);

    List<Future<String>> futures = new ArrayList<>();
    futures.add(cs.submit(() -> callService("A", query)));
    futures.add(cs.submit(() -> callService("B", query)));
    futures.add(cs.submit(() -> callService("C", query)));

    try {
        for (int i = 0; i < 3; i++) {
            Future<String> first = cs.take(); // blocks for next completion
            try {
                String result = first.get();
                // Cancel the rest — manual, easy to forget
                futures.forEach(f -> f.cancel(true));
                return result;
            } catch (ExecutionException e) {
                if (i == 2) throw e; // last one failed too
            }
        }
        throw new IllegalStateException("unreachable");
    } finally {
        exec.shutdown();
    }
}

// ═══════════════════════════════════════════════════════════
// NEW WAY
// ═══════════════════════════════════════════════════════════
public String hedgedRequestNew(String query)
        throws ExecutionException, InterruptedException {
    try (var scope = new ShutdownOnSuccess<String>()) {
        scope.fork(() -> callService("A", query));
        scope.fork(() -> callService("B", query));
        scope.fork(() -> callService("C", query));
        scope.join();
        return scope.result();
    }
}
```

### 8.3 Sequential-Looking Concurrent Code

One of structured concurrency's greatest UX benefits: concurrent code that reads like sequential code.

```java
// This function LOOKS sequential but ALL THREE calls run concurrently
public DashboardData buildDashboard(long userId) throws Exception {
    try (var scope = new ShutdownOnFailure()) {

        Subtask<UserInfo>    info    = scope.fork(() -> userService.getInfo(userId));
        Subtask<List<Order>> orders  = scope.fork(() -> orderService.getRecent(userId));
        Subtask<Inbox>       inbox   = scope.fork(() -> messageService.getInbox(userId));
        Subtask<Prefs>       prefs   = scope.fork(() -> prefService.getPrefs(userId));

        scope.join().throwIfFailed();

        // Reads exactly like sequential code — but was concurrent
        return DashboardData.builder()
            .userInfo(info.get())
            .recentOrders(orders.get())
            .inbox(inbox.get())
            .preferences(prefs.get())
            .build();
    }
}
```

---

## 9. Nesting and Composition

### 9.1 Nested Scopes

Scopes can be nested. Each scope forms its own unit of work. Inner scopes must complete before outer scopes.

```java
public ReportData generateReport(ReportRequest req)
        throws ExecutionException, InterruptedException {

    try (var outer = new ShutdownOnFailure()) {

        // These two heavy computations run concurrently in the outer scope
        Subtask<ChartData>  chart   = outer.fork(() -> buildChart(req));
        Subtask<TableData>  table   = outer.fork(() -> {

            // The table computation itself fans out internally — nested scope
            try (var inner = new ShutdownOnFailure()) {
                Subtask<RawData>    raw     = inner.fork(() -> queryDatabase(req));
                Subtask<Metadata>   meta    = inner.fork(() -> fetchMetadata(req));
                inner.join().throwIfFailed();
                return processTable(raw.get(), meta.get());
            }
            // inner scope is closed — raw and meta queries done before we return
        });

        outer.join().throwIfFailed();
        return new ReportData(chart.get(), table.get());
    }
}
```

### 9.2 Scope Hierarchy Maps to Call Graph

The nesting of scopes mirrors the logical task hierarchy:

```
generateReport()
├── buildChart()                    ← outer scope subtask
└── buildTable()                    ← outer scope subtask
    ├── queryDatabase()             ← inner scope subtask
    └── fetchMetadata()             ← inner scope subtask
```

Every level is bounded. `queryDatabase` and `fetchMetadata` cannot outlive `buildTable`. `buildChart` and `buildTable` cannot outlive `generateReport`.

### 9.3 Mixing Scopes — Different Policies at Different Levels

```java
// Outer: ALL must succeed (build full report)
try (var outerScope = new ShutdownOnFailure()) {

    // Each section: try multiple sources, use first that responds
    Subtask<Section> intro = outerScope.fork(() -> {
        try (var innerScope = new ShutdownOnSuccess<Section>()) {
            innerScope.fork(() -> fetchIntroFromPrimary());
            innerScope.fork(() -> fetchIntroFromCache()); // fallback
            innerScope.join();
            return innerScope.result();
        }
    });

    Subtask<Section> body = outerScope.fork(() -> {
        try (var innerScope = new ShutdownOnSuccess<Section>()) {
            innerScope.fork(() -> fetchBodyFromPrimary());
            innerScope.fork(() -> fetchBodyFromCache());
            innerScope.join();
            return innerScope.result();
        }
    });

    outerScope.join().throwIfFailed();
    return new Report(intro.get(), body.get());
}
```

---

## 10. Custom `StructuredTaskScope` Subclasses

### 10.1 Why Subclass

The base class and the two built-in policies cover many cases, but you may need custom policies:
- Collect ALL results (not just first success)
- Succeed if a majority succeed
- Succeed if at least N out of M succeed
- Collect partial results even on some failures

### 10.2 Override `handleComplete()`

`handleComplete()` is called on the scope's owner thread whenever a subtask completes (success or failure). Override it to implement custom policies and call `shutdown()` when your condition is met.

```java
// Custom scope: collect ALL results, fail only if more than half fail
public class MajoritySuccessScope<T> extends StructuredTaskScope<T> {

    private final List<T> results    = new CopyOnWriteArrayList<>();
    private final List<Throwable> errors = new CopyOnWriteArrayList<>();
    private final int totalTasks;

    public MajoritySuccessScope(int totalTasks) {
        this.totalTasks = totalTasks;
    }

    @Override
    protected void handleComplete(Subtask<? extends T> subtask) {
        switch (subtask.state()) {
            case SUCCESS -> {
                results.add(subtask.get());
                // If majority already succeeded, we can shutdown early
                if (results.size() > totalTasks / 2) {
                    shutdown(); // signal join() to return
                }
            }
            case FAILED -> {
                errors.add(subtask.exception());
                // If majority failed, shutdown with failure
                if (errors.size() > totalTasks / 2) {
                    shutdown();
                }
            }
            case UNAVAILABLE -> {} // was cancelled
        }
    }

    public List<T> results() {
        // Call after join()
        return Collections.unmodifiableList(results);
    }

    public boolean isMajoritySuccess() {
        return results.size() > totalTasks / 2;
    }
}

// Usage
try (var scope = new MajoritySuccessScope<String>(5)) {
    for (String endpoint : endpoints) {
        scope.fork(() -> callEndpoint(endpoint));
    }
    scope.join();

    if (scope.isMajoritySuccess()) {
        System.out.println("Majority succeeded: " + scope.results());
    }
}
```

### 10.3 Collect-All-Results Scope

A common custom scope: gather ALL successful results into a list:

```java
public class CollectingScope<T> extends StructuredTaskScope<T> {

    private final List<T> results = new CopyOnWriteArrayList<>();
    private final List<Throwable> errors = new CopyOnWriteArrayList<>();

    @Override
    protected void handleComplete(Subtask<? extends T> subtask) {
        if (subtask.state() == Subtask.State.SUCCESS) {
            results.add(subtask.get());
        } else if (subtask.state() == Subtask.State.FAILED) {
            errors.add(subtask.exception());
        }
    }

    /** All successful results after join() */
    public List<T> results() { return Collections.unmodifiableList(results); }

    /** All failures after join() */
    public List<Throwable> errors() { return Collections.unmodifiableList(errors); }

    /** Throws if ANY task failed */
    public void throwIfAnyFailed() throws AggregateException {
        if (!errors.isEmpty()) throw new AggregateException(errors);
    }
}

// Usage — fan-out to many endpoints, collect all results
try (var scope = new CollectingScope<Price>()) {
    for (String exchange : exchanges) {
        scope.fork(() -> getPrice(exchange)); // some may fail, some may succeed
    }
    scope.join();
    // Don't throw on partial failure — use what we have
    List<Price> prices = scope.results();
    System.out.println("Got " + prices.size() + "/" + exchanges.size() + " prices");
}
```

---

## 11. Error Handling In Depth

### 11.1 Exception Flow in `ShutdownOnFailure`

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> t = scope.fork(() -> { throw new IOException("network error"); });
    scope.join().throwIfFailed();

} catch (ExecutionException e) {
    // e.getCause() is the original IOException
    Throwable cause = e.getCause();
    System.out.println(cause.getClass()); // class java.io.IOException
    System.out.println(cause.getMessage()); // network error

} catch (InterruptedException e) {
    Thread.currentThread().interrupt(); // restore interrupt status
}
```

### 11.2 Multiple Failures — Only First Is Reported

`ShutdownOnFailure.throwIfFailed()` reports the FIRST failure detected. If multiple tasks fail simultaneously, one is chosen (non-deterministic). The others are lost unless you inspect each `Subtask` individually:

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> t1 = scope.fork(() -> { throw new IOException("err1"); });
    Subtask<String> t2 = scope.fork(() -> { throw new IOException("err2"); });
    Subtask<String> t3 = scope.fork(() -> { throw new IOException("err3"); });

    scope.join();
    // throwIfFailed() will report only ONE of err1/err2/err3

    // To get ALL failures, inspect each subtask:
    List<Throwable> allErrors = Stream.of(t1, t2, t3)
        .filter(t -> t.state() == Subtask.State.FAILED)
        .map(Subtask::exception)
        .toList();
    System.out.println("All errors: " + allErrors.size()); // 3
}
```

### 11.3 Checked vs Unchecked Exceptions

`Callable` (used by `fork()`) can throw checked exceptions. They are captured and re-thrown appropriately:

```java
// Checked exception in Callable — works fine
Subtask<String> t = scope.fork(() -> {
    throw new IOException("checked"); // Callable<String> throws IOException
});

// After join(), t.exception() is the IOException
// throwIfFailed() wraps it in ExecutionException — caller must handle both:
try {
    scope.join().throwIfFailed();
} catch (ExecutionException e) {
    if (e.getCause() instanceof IOException ioe) {
        // handle I/O specifically
    }
}
```

### 11.4 `InterruptedException` — Always Restore

`join()` and `joinUntil()` both declare `InterruptedException`. When caught, **always** restore the interrupt status:

```java
try {
    scope.join().throwIfFailed();
} catch (InterruptedException e) {
    Thread.currentThread().interrupt(); // ← REQUIRED — restore interrupt flag
    throw new RuntimeException("Interrupted while waiting for tasks", e);
}
```

---

## 12. Cancellation and Interruption

### 12.1 How Cancellation Works

When `shutdown()` is called (by a policy or manually):
1. All subtasks whose virtual threads are blocked on **interruptible operations** (I/O, `sleep`, `lock`, etc.) receive an interrupt
2. The virtual thread's interrupt flag is set
3. If the subtask is executing non-interruptible code, it runs to completion or the next interruptible point

```java
// A cancellation-aware subtask
Subtask<String> t = scope.fork(() -> {
    // Check interrupt flag periodically in long computations
    for (int i = 0; i < 1_000_000; i++) {
        if (Thread.currentThread().isInterrupted()) {
            throw new InterruptedException("Cancelled by scope shutdown");
        }
        doSomeWork(i);
    }
    return "done";
});
```

### 12.2 `shutdown()` Is Idempotent

Calling `shutdown()` multiple times is safe — only the first call has effect:

```java
scope.shutdown(); // triggers cancellation
scope.shutdown(); // no-op — already shut down
```

### 12.3 Scope Cancellation When Caller Is Interrupted

If the thread calling `join()` is interrupted:
1. `join()` throws `InterruptedException`
2. `try-with-resources` calls `close()`
3. `close()` calls `shutdown()` → all subtasks are cancelled
4. `close()` waits for all subtasks to complete/cancel

This means **an interrupted caller automatically cleans up all subtasks**. No leaks.

```java
// HTTP request handler — if the request is cancelled (client disconnect),
// the thread is interrupted, which propagates through structured concurrency
// and cancels ALL in-flight database/service calls automatically.
public Response handleRequest(Request req) throws InterruptedException {
    try (var scope = new ShutdownOnFailure()) {
        Subtask<Data> db      = scope.fork(() -> database.query(req));
        Subtask<Data> service = scope.fork(() -> microservice.call(req));
        scope.join().throwIfFailed();       // if caller interrupted, subtasks cancelled
        return Response.of(db.get(), service.get());
    } catch (ExecutionException e) {
        return Response.error(e.getCause());
    }
}
```

---

## 13. Real-World Patterns

### 13.1 Service Aggregator — Parallel API Calls

```java
public record ProductPage(
    Product product,
    List<Review> reviews,
    InventoryStatus inventory,
    List<Product> recommendations
) {}

public ProductPage getProductPage(String productId)
        throws ExecutionException, InterruptedException {

    try (var scope = new ShutdownOnFailure()) {

        Subtask<Product>          prod  = scope.fork(() -> productService.get(productId));
        Subtask<List<Review>>     revs  = scope.fork(() -> reviewService.get(productId));
        Subtask<InventoryStatus>  inv   = scope.fork(() -> inventoryService.get(productId));
        Subtask<List<Product>>    recs  = scope.fork(() -> recoService.get(productId));

        scope.join().throwIfFailed();

        return new ProductPage(prod.get(), revs.get(), inv.get(), recs.get());
    }
}
// Total latency = max(individual latencies), not sum — massive speedup
// If any service is down → all cancelled, exception propagated cleanly
```

### 13.2 Bulk Processing with Parallelism Limit

Use `ShutdownOnFailure` in batches to process a large list with controlled parallelism:

```java
public List<Result> processBatch(List<Input> inputs, int batchSize)
        throws ExecutionException, InterruptedException {

    List<Result> allResults = new ArrayList<>();

    // Process in batches to control max concurrency
    for (int i = 0; i < inputs.size(); i += batchSize) {
        List<Input> batch = inputs.subList(i, Math.min(i + batchSize, inputs.size()));

        try (var scope = new ShutdownOnFailure()) {
            List<Subtask<Result>> tasks = batch.stream()
                .map(input -> scope.fork(() -> process(input)))
                .toList();

            scope.join().throwIfFailed();

            tasks.stream().map(Subtask::get).forEach(allResults::add);
        }
    }
    return allResults;
}
```

### 13.3 Read-Your-Writes with Fallback Cache

```java
// Try live DB first (accurate), fall back to cache (stale but fast)
// If DB responds within 200ms, use it. Otherwise use cache.
public UserPrefs getPrefs(long userId) throws ExecutionException, InterruptedException {
    try (var scope = new ShutdownOnSuccess<UserPrefs>()) {

        // Race: live DB vs cache-after-delay
        scope.fork(() -> database.getPrefs(userId));
        scope.fork(() -> {
            Thread.sleep(200); // give DB 200ms head start
            return cache.getPrefs(userId); // stale fallback
        });

        scope.join();
        return scope.result();
    }
}
```

### 13.4 Health Check Aggregator

```java
public HealthStatus checkAllServices() throws InterruptedException {
    List<String> services = List.of("db", "cache", "queue", "storage");

    try (var scope = new StructuredTaskScope<ServiceHealth>()) {
        List<Subtask<ServiceHealth>> checks = services.stream()
            .map(svc -> scope.fork(() -> checkService(svc)))
            .toList();

        scope.joinUntil(Instant.now().plusSeconds(3)); // max 3s for all checks

        // Collect results — some may be UNAVAILABLE (timed out/cancelled)
        Map<String, ServiceHealth> results = new LinkedHashMap<>();
        for (int i = 0; i < services.size(); i++) {
            Subtask<ServiceHealth> task = checks.get(i);
            results.put(services.get(i),
                task.state() == Subtask.State.SUCCESS
                    ? task.get()
                    : ServiceHealth.UNKNOWN
            );
        }

        return HealthStatus.aggregate(results);

    } catch (TimeoutException e) {
        return HealthStatus.partial(); // some checks didn't complete
    }
}
```

### 13.5 Retry with Structured Concurrency

```java
// Retry a task up to N times with backoff, using virtual threads
public <T> T withRetry(Callable<T> task, int maxAttempts)
        throws ExecutionException, InterruptedException {

    Exception lastError = null;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        try (var scope = new ShutdownOnFailure()) {
            Subtask<T> t = scope.fork(task);
            scope.join().throwIfFailed();
            return t.get();
        } catch (ExecutionException e) {
            lastError = e;
            if (attempt < maxAttempts) {
                Thread.sleep(Duration.ofMillis(100L * attempt)); // simple backoff
            }
        }
    }
    throw new ExecutionException("All " + maxAttempts + " attempts failed", lastError);
}
```

---

## 14. Edge Cases and Gotchas

### 14.1 `fork()` After `join()` Throws

```java
try (var scope = new ShutdownOnFailure()) {
    scope.join(); // join before forking anything — valid but pointless
    scope.fork(() -> "too late"); // throws IllegalStateException!
}
```

Always `fork()` first, then `join()`.

### 14.2 `Subtask.get()` Before `join()` Returns

Reading a subtask result before `join()` completes is not safe and throws `IllegalStateException` if the task isn't done:

```java
try (var scope = new ShutdownOnFailure()) {
    Subtask<String> t = scope.fork(() -> { Thread.sleep(100); return "done"; });

    // DO NOT do this before join():
    // t.get() — throws IllegalStateException if task not yet complete

    scope.join().throwIfFailed();
    t.get(); // SAFE — after join()
}
```

### 14.3 Scope Must Be Used by Its Owner Thread

Only the thread that created the scope (the "owner") can call `fork()` and `join()`. Forked subtasks can create their own nested scopes, but cannot call `fork()` on the parent scope:

```java
try (var scope = new ShutdownOnFailure()) {
    scope.fork(() -> {
        // This subtask is on a different virtual thread
        scope.fork(() -> "nested"); // WRONG — only owner can fork on this scope
        // Instead: create a new nested scope here
    });
    scope.join().throwIfFailed();
}
```

### 14.4 `close()` Blocks If `join()` Not Called

If an exception is thrown before `join()`, `try-with-resources` calls `close()`. If subtasks are still running, `close()` waits for them (after cancelling). This is correct behavior — no leak — but can delay exception propagation:

```java
try (var scope = new ShutdownOnFailure()) {
    scope.fork(() -> { Thread.sleep(10_000); return "slow"; });

    throw new RuntimeException("early failure"); // thrown before join()
    // try-with-resources calls close()
    // close() cancels the slow task and WAITS for it to finish
    // The sleep is interruptible, so the task stops quickly
    // Then the RuntimeException propagates
}
```

### 14.5 Unchecked Exceptions in `fork()` — Wrapped in `ExecutionException`

All exceptions from subtasks (checked or unchecked) become the cause of `ExecutionException` when re-thrown via `throwIfFailed()`:

```java
scope.fork(() -> { throw new NullPointerException("oops"); }); // unchecked

try {
    scope.join().throwIfFailed();
} catch (ExecutionException e) {
    // e.getCause() is NullPointerException — it was wrapped
    assert e.getCause() instanceof NullPointerException;
}
```

---

## 15. Quick Reference Cheat Sheet

### The Three Scope Types

| Scope | `join()` returns when... | Use case |
|---|---|---|
| `StructuredTaskScope` (base) | ALL tasks done | Manual policy / custom subclass |
| `ShutdownOnFailure` | ALL succeed OR first fails | Must have all results |
| `ShutdownOnSuccess<T>` | First succeeds OR all fail | Race / hedged / fallback |

### The Canonical Patterns

```java
// ALL MUST SUCCEED pattern
try (var scope = new ShutdownOnFailure()) {
    Subtask<A> a = scope.fork(() -> fetchA());
    Subtask<B> b = scope.fork(() -> fetchB());
    scope.join().throwIfFailed();           // throws ExecutionException on first failure
    return combine(a.get(), b.get());
}

// FIRST TO SUCCEED pattern
try (var scope = new ShutdownOnSuccess<T>()) {
    scope.fork(() -> tryPrimary());
    scope.fork(() -> tryFallback());
    scope.join();
    return scope.result();                  // throws ExecutionException if all failed
}

// COLLECT ALL (base class, custom handleComplete)
try (var scope = new CollectingScope<T>()) {
    items.forEach(item -> scope.fork(() -> process(item)));
    scope.join();
    return scope.results();
}
```

### Method Summary

```java
// StructuredTaskScope
scope.fork(callable)           // submit subtask → Subtask<T> (non-blocking)
scope.join()                   // block until policy met → this scope (for chaining)
scope.joinUntil(instant)       // block with deadline → throws TimeoutException
scope.close()                  // cancel remaining, wait, validate join was called

// Subtask<T>
subtask.state()                // UNAVAILABLE | SUCCESS | FAILED
subtask.get()                  // result (call after join, only if SUCCESS)
subtask.exception()            // cause  (call after join, only if FAILED)

// ShutdownOnFailure (after join())
scope.throwIfFailed()                       // throws ExecutionException on first failure
scope.throwIfFailed(ex -> new MyEx(ex))     // custom exception mapping
scope.exception()                           // Optional<Throwable> — first failure if any

// ShutdownOnSuccess<T> (after join())
scope.result()                              // first success — throws ExecutionException if all failed
scope.result(ex -> new MyEx(ex))            // custom exception mapping
```

### Key Rules to Remember

1. **Always use `try-with-resources`** — `close()` is the safety net that prevents leaks.
2. **`fork()` before `join()`** — calling `fork()` after `join()` throws `IllegalStateException`.
3. **`Subtask.get()` only after `join()`** — before that it throws if the task isn't done.
4. **`throwIfFailed()` after `join()`** — calling it before `join()` gives meaningless results.
5. **Restore interrupt status** when catching `InterruptedException` from `join()`.
6. **Only the owner thread forks** — subtasks must create nested scopes to fan out further.
7. **Failures are wrapped in `ExecutionException`** — unwrap with `e.getCause()`.
8. **`ShutdownOnFailure.firstEntry()`/`lastEntry()` return null** — wait, wrong guide. **`shutdown()` is idempotent** — safe to call multiple times.
9. **Cancellation is best-effort** — non-interruptible code in a subtask runs to completion even after `shutdown()`.
10. **Virtual threads are the default** — `fork()` uses a virtual thread factory by default; changing this is rarely needed.

### Why Structured Concurrency Wins

| Problem | Old (`ExecutorService`) | New (Structured Concurrency) |
|---|---|---|
| Thread leak on failure | Manual cancel — easy to forget | Auto-cancelled on scope close |
| Cancellation propagation | Manual `future.cancel()` | Automatic via interrupt on `shutdown()` |
| Error visibility | Lost in `Future`, unchecked CE | Surfaced via `throwIfFailed()` |
| Parent-child relationship | None — tasks are orphans | Enforced by scope lifecycle |
| Caller interrupt | Does not cancel child tasks | Cancels all subtasks automatically |
| Resource cleanup | Manual `executor.shutdown()` | Automatic via `AutoCloseable` |
| Readability | Nested callbacks / future chains | Sequential-looking code |

---

*End of Java Structured Concurrency Study Guide — JEP 453 (Java 21 Preview) / JEP 480 (Java 24 Final)*
