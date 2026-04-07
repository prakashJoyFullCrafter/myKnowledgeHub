# Java Scoped Values — Complete Study Guide

> **Java 20 Preview → Java 24 Finalized | Brutally Detailed Reference**
> Covers `ScopedValue<T>`, the `where().run()/call()/get()` lifecycle, immutability, child thread inheritance, why `ThreadLocal` fails in the virtual thread era, and full migration patterns. Every section includes full working examples.

---

## Table of Contents

1. [The Problem — Why `ThreadLocal` Fails in the Virtual Thread Era](#1-the-problem--why-threadlocal-fails-in-the-virtual-thread-era)
2. [The Solution — `ScopedValue<T>`](#2-the-solution--scopedvaluet)
3. [Core API — `where()`, `run()`, `call()`, `get()`](#3-core-api--where-run-call-get)
4. [Immutability Within a Scope](#4-immutability-within-a-scope)
5. [Automatic Inheritance by Child Virtual Threads](#5-automatic-inheritance-by-child-virtual-threads)
6. [Rebinding — Nested Scopes with Different Values](#6-rebinding--nested-scopes-with-different-values)
7. [Multiple Scoped Values — `ScopedValue.where().where()`](#7-multiple-scoped-values--scopedvaluewherewhere)
8. [Migration: `ThreadLocal` → `ScopedValue`](#8-migration-threadlocal--scopedvalue)
9. [Real-World Patterns](#9-real-world-patterns)
10. [Integration with Structured Concurrency](#10-integration-with-structured-concurrency)
11. [Edge Cases and Gotchas](#11-edge-cases-and-gotchas)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. The Problem — Why `ThreadLocal` Fails in the Virtual Thread Era

### 1.1 What `ThreadLocal` Does

`ThreadLocal<T>` attaches a value to a **thread**. Each thread has its own independent copy. It is used to pass context (user identity, trace IDs, database transactions, locale) implicitly through a call stack without explicit method parameters.

```java
// The classic ThreadLocal pattern
public class SecurityContext {
    // One instance, but each thread gets its own value
    private static final ThreadLocal<User> CURRENT_USER = new ThreadLocal<>();

    public static void setUser(User user) { CURRENT_USER.set(user); }
    public static User getUser()          { return CURRENT_USER.get(); }
    public static void clear()            { CURRENT_USER.remove(); }
}

// In a servlet/filter:
SecurityContext.setUser(authenticatedUser);
try {
    handleRequest(); // anywhere in the call stack can call SecurityContext.getUser()
} finally {
    SecurityContext.clear(); // MUST remember to clean up
}
```

This worked acceptably when threads were expensive and few (one thread per request). But the model has five deep problems.

### 1.2 Problem 1 — Unbounded Lifetime

A `ThreadLocal` value lives as long as the **thread** lives. With thread pools, threads live for the entire application lifetime. If you forget `remove()`, the value persists across requests:

```java
// Thread pool: thread is reused across many requests
ExecutorService pool = Executors.newFixedThreadPool(10);

pool.submit(() -> {
    threadLocalUser.set(adminUser); // set for request 1
    handleRequest();
    // FORGOT threadLocalUser.remove()
});

// Thread is returned to pool and reused for request 2!
pool.submit(() -> {
    // threadLocalUser.get() returns adminUser — WRONG! Security bug.
    handleRequest();
});
```

This is not theoretical — it causes real security and correctness bugs in production.

### 1.3 Problem 2 — Mutable State, Invisible Data Flow

`ThreadLocal` is mutable — any code anywhere in the call stack can `set()` a new value. This creates **invisible, action-at-a-distance state mutations** that are impossible to reason about:

```java
// In some deep library call...
public void processPayment() {
    // This silently changes the current user for all subsequent code in this thread!
    SecurityContext.setUser(PAYMENT_SERVICE_ACCOUNT);
    // ... do payment processing ...
    // Forgets to restore original user
}

// Back in the caller, getUser() now returns PAYMENT_SERVICE_ACCOUNT
// The caller has no idea this happened
```

With `ThreadLocal`, you can never be sure what value you'll get — any callee may have changed it.

### 1.4 Problem 3 — Memory Leaks

`ThreadLocal` values are stored in a map on the `Thread` object itself (`Thread.threadLocals`). If you use a `ThreadLocal` with a class loader (common in application servers), a reference chain can form:

```
ThreadLocal key → ClassLoader → Class → ThreadLocal value
```

Because the `Thread` (in the pool) holds this map, the entire class loader — and everything it loaded — stays in memory even after application undeploy. This is the root cause of the famous "PermGen space" / metaspace memory leaks in application servers.

### 1.5 Problem 4 — Costly with Virtual Threads

Java 21+ enables **millions of virtual threads**. `ThreadLocal` is catastrophically expensive in this world:

```java
// Imagine a server using one virtual thread per request
// Each virtual thread gets its OWN COPY of every ThreadLocal variable
// A typical framework might have 50+ ThreadLocal variables

// 1,000,000 virtual threads × 50 ThreadLocals × overhead per entry
// = enormous memory pressure just for the ThreadLocal maps
```

Each `ThreadLocal` entry in the thread's map costs memory regardless of whether the thread ever uses it. With millions of virtual threads, the aggregate cost becomes unacceptable.

### 1.6 Problem 5 — No Automatic Inheritance

`ThreadLocal` values are **not** inherited by child threads unless you use `InheritableThreadLocal`. And `InheritableThreadLocal` copies the value at thread creation time — not automatically kept in sync, and still suffers from all the other problems:

```java
// Parent thread
threadLocalTraceId.set("trace-abc-123");

// Child thread spawned from parent
Thread child = new Thread(() -> {
    threadLocalTraceId.get(); // null — not inherited!
    // With InheritableThreadLocal: gets a COPY of "trace-abc-123" at creation time
    // but it's a separate copy, not the same binding
});
child.start();
```

### 1.7 Summary of `ThreadLocal` Problems

| Problem | Description | Impact |
|---|---|---|
| Unbounded lifetime | Lives as long as the thread (pool threads = forever) | Security bugs, stale data |
| Mutable | Any code can `set()` silently | Invisible state changes, hard to debug |
| Memory leaks | Thread holds references even after logical scope ends | PermGen/metaspace leaks in app servers |
| Virtual thread cost | Each vthread gets its own copy of every TL variable | Unacceptable memory with millions of threads |
| No clean inheritance | Not inherited by child threads automatically | Breaks distributed tracing, auth context |

---

## 2. The Solution — `ScopedValue<T>`

### 2.1 Core Concept

A `ScopedValue<T>` is a **carrier that binds a value to a scope of execution**. The binding is:
- **Immutable** — once bound in a scope, it cannot be changed (only rebound in a nested scope)
- **Bounded** — the binding exists only for the duration of the `run()`/`call()` lambda
- **Automatically inherited** — child virtual threads see the same binding
- **Efficiently shared** — all threads in the scope share the same value (not copies)

```
┌──────────────────────────────────────────────┐
│  ScopedValue.where(USER, alice).run(() -> {  │
│      USER.get()  → alice                     │  ← binding is active
│      callSomeMethod();                        │
│          USER.get()  → alice                 │  ← same binding deep in stack
│      spawnChildThread();                      │
│          USER.get()  → alice                 │  ← inherited by child
│  });                                          │
│  USER.isBound()  → false                     │  ← binding gone after run()
└──────────────────────────────────────────────┘
```

### 2.2 Declaration

`ScopedValue` instances are declared as `public static final` — they are **keys**, not value containers. The value is carried by the execution scope, not the `ScopedValue` object itself:

```java
import java.lang.ScopedValue; // java.lang package — Java 24+

public class RequestContext {
    // The ScopedValue is just a key — no value stored here
    public static final ScopedValue<User>    CURRENT_USER   = ScopedValue.newInstance();
    public static final ScopedValue<String>  TRACE_ID       = ScopedValue.newInstance();
    public static final ScopedValue<Locale>  USER_LOCALE    = ScopedValue.newInstance();
}
```

---

## 3. Core API — `where()`, `run()`, `call()`, `get()`

### 3.1 Full API Overview

```java
// In java.lang — Java 24+
public final class ScopedValue<T> {

    // Factory — create a new ScopedValue key
    public static <T> ScopedValue<T> newInstance() { ... }

    // Read the current binding
    public T get() { ... }                          // throws NoSuchElementException if unbound
    public boolean isBound() { ... }               // false if no binding in scope
    public T orElse(T other) { ... }               // get or default if unbound
    public T orElseThrow(Supplier<X> exSupplier) { ... } // get or throw custom exception

    // Create a Carrier (binding specification)
    public static <T> Carrier where(ScopedValue<T> key, T value) { ... }

    // Carrier — holds the binding(s) and launches the scoped execution
    public static final class Carrier {
        public <T> Carrier where(ScopedValue<T> key, T value) { ... } // chain more bindings
        public void    run(Runnable op) { ... }             // run with bindings, no result
        public <R> R   call(Callable<R> op) throws Exception { ... } // run with result
        public <R> R   get(Supplier<R> op) { ... }         // run with result, no checked exception
    }
}
```

### 3.2 `ScopedValue.where(key, value)` — Building a Carrier

`where()` is a static factory that creates a `Carrier` — a specification of "bind this key to this value when executing this scope." It does not execute anything yet.

```java
// Just builds the binding specification — nothing runs yet
ScopedValue.Carrier binding = ScopedValue.where(RequestContext.CURRENT_USER, alice);

// Can chain multiple bindings (see Section 7)
ScopedValue.Carrier multi = ScopedValue
    .where(RequestContext.CURRENT_USER, alice)
    .where(RequestContext.TRACE_ID, "trace-abc-123");
```

### 3.3 `.run(Runnable)` — Execute Without Returning a Value

```java
static final ScopedValue<String> TRACE_ID = ScopedValue.newInstance();

public void handleRequest(String traceId, Runnable handler) {
    ScopedValue.where(TRACE_ID, traceId).run(() -> {
        // TRACE_ID is bound to traceId for the entire duration of handler.run()
        System.out.println("Trace: " + TRACE_ID.get()); // traceId value

        handler.run(); // all code called from here can read TRACE_ID

        logCompletion(); // also has access to TRACE_ID
    }); // binding removed here — TRACE_ID is unbound after run()
}
```

### 3.4 `.call(Callable<R>)` — Execute and Return a Value, Allow Checked Exceptions

```java
static final ScopedValue<User> CURRENT_USER = ScopedValue.newInstance();

public String getUserDisplayName(User user) throws Exception {
    return ScopedValue.where(CURRENT_USER, user).call(() -> {
        // Can throw checked exceptions
        User resolved = CURRENT_USER.get();
        return profileService.getDisplayName(resolved.id()); // may throw IOException
    });
}
```

### 3.5 `.get(Supplier<R>)` — Execute and Return a Value, No Checked Exceptions

```java
public String formatUserGreeting(User user) {
    return ScopedValue.where(CURRENT_USER, user).get(() -> {
        // No checked exceptions allowed — use Supplier
        User u = CURRENT_USER.get();
        return "Hello, " + u.displayName() + "!";
    });
}
```

### 3.6 Reading the Value — `get()`, `isBound()`, `orElse()`

```java
static final ScopedValue<String> TRACE_ID = ScopedValue.newInstance();

// --- Inside a scope (binding active) ---
ScopedValue.where(TRACE_ID, "trace-xyz").run(() -> {
    String id = TRACE_ID.get();       // "trace-xyz"
    boolean bound = TRACE_ID.isBound(); // true
    String safe = TRACE_ID.orElse("no-trace"); // "trace-xyz"
});

// --- Outside any scope (unbound) ---
TRACE_ID.isBound();          // false
TRACE_ID.orElse("no-trace"); // "no-trace" — safe default
try {
    TRACE_ID.get();          // throws NoSuchElementException
} catch (NoSuchElementException e) {
    System.out.println("Not bound outside scope");
}
```

### 3.7 Full Lifecycle Example

```java
public class Application {

    static final ScopedValue<User>   CURRENT_USER = ScopedValue.newInstance();
    static final ScopedValue<String> TRACE_ID     = ScopedValue.newInstance();

    // Entry point — establish scope from HTTP request
    public Response handleHttpRequest(HttpRequest req) throws Exception {
        User   user    = authenticate(req);
        String traceId = req.header("X-Trace-Id");

        // Establish both bindings and call the handler
        return ScopedValue
            .where(CURRENT_USER, user)
            .where(TRACE_ID, traceId)
            .call(() -> processRequest(req));
        // After .call() returns, BOTH bindings are gone
    }

    // Somewhere deep in the call stack — no parameters needed
    private static void auditLog(String action) {
        // Reads the binding established by handleHttpRequest
        String user  = CURRENT_USER.isBound()
            ? CURRENT_USER.get().username()
            : "anonymous";
        String trace = TRACE_ID.orElse("no-trace");

        System.out.printf("[%s] user=%s action=%s%n", trace, user, action);
    }
}
```

---

## 4. Immutability Within a Scope

### 4.1 The Immutability Guarantee

Once a `ScopedValue` is bound in a scope, **no code within that scope can change the binding**. There is no `set()` method. There is no `remove()` method. The value you bind at the start is the value for the entire scope.

```java
static final ScopedValue<String> ROLE = ScopedValue.newInstance();

ScopedValue.where(ROLE, "ADMIN").run(() -> {
    System.out.println(ROLE.get()); // ADMIN

    // THERE IS NO WAY to do this:
    // ROLE.set("USER");    ← compile error — method does not exist
    // ROLE.remove();       ← compile error — method does not exist

    System.out.println(ROLE.get()); // still ADMIN — guaranteed
    callAnyMethod();
    System.out.println(ROLE.get()); // still ADMIN — no code anywhere can change it
});
```

### 4.2 Why Immutability Is Essential

Immutability solves the `ThreadLocal` "action at a distance" problem completely. When you call a method, you know it cannot secretly change the scoped value you're relying on:

```java
// With ThreadLocal — this is possible and dangerous:
SecurityContext.setUser(adminUser); // set
processPayment();                   // might call SecurityContext.setUser(serviceAccount) inside!
SecurityContext.getUser();          // might return serviceAccount — WRONG

// With ScopedValue — this is structurally impossible:
ScopedValue.where(CURRENT_USER, adminUser).run(() -> {
    processPayment(); // CAN NEVER change CURRENT_USER — no API exists to do so
    CURRENT_USER.get(); // always adminUser — guaranteed by the type system
});
```

### 4.3 Rebinding (Not Mutation)

You can establish a **nested scope** with a different value for the same key. This is not mutation — the outer scope's binding is unchanged; you're just creating a new inner scope that shadows it:

```java
static final ScopedValue<String> ROLE = ScopedValue.newInstance();

ScopedValue.where(ROLE, "USER").run(() -> {
    System.out.println(ROLE.get()); // USER — outer scope

    // Create inner scope with different value
    ScopedValue.where(ROLE, "ADMIN").run(() -> {
        System.out.println(ROLE.get()); // ADMIN — inner scope shadows outer
    });

    System.out.println(ROLE.get()); // USER — outer scope UNCHANGED after inner exits
});
```

This is covered in depth in Section 6.

---

## 5. Automatic Inheritance by Child Virtual Threads

### 5.1 The Inheritance Model

When a child virtual thread is created inside a scoped value binding, the child automatically inherits the **same binding** — not a copy, the same immutable value. This works with both manually created virtual threads and `StructuredTaskScope.fork()`:

```java
static final ScopedValue<String> TRACE_ID = ScopedValue.newInstance();

ScopedValue.where(TRACE_ID, "trace-abc").run(() -> {

    System.out.println("Parent: " + TRACE_ID.get()); // trace-abc

    // Child virtual thread — inherits parent's binding automatically
    Thread child = Thread.ofVirtual().start(() -> {
        System.out.println("Child:  " + TRACE_ID.get()); // trace-abc — inherited!
    });

    child.join();
});
```

### 5.2 Why "Same Value, Not a Copy" Matters

With `InheritableThreadLocal`, the child gets a **copy** of the parent's value at creation time. With `ScopedValue`, the child shares the **same binding**. For immutable objects (strings, records, etc.), this distinction is mostly academic. But it matters for:
- **Memory efficiency** — no copying, no per-thread storage overhead
- **Large values** — a large config object is not duplicated for every child thread
- **The contract** — child threads in a structured scope are logically part of the same operation and should see the same context

```java
static final ScopedValue<Map<String, String>> CONFIG = ScopedValue.newInstance();

Map<String, String> config = loadConfig(); // potentially large map

ScopedValue.where(CONFIG, config).run(() -> {
    // Fork 10,000 worker virtual threads
    for (int i = 0; i < 10_000; i++) {
        Thread.ofVirtual().start(() -> {
            // All 10,000 threads share the SAME config object reference
            // InheritableThreadLocal would make 10,000 copies!
            CONFIG.get().get("timeout"); // reads from shared reference
        });
    }
});
```

### 5.3 Inheritance with `StructuredTaskScope`

The most important use of inheritance: structured concurrency scoped values flow into subtasks automatically:

```java
static final ScopedValue<RequestContext> CTX = ScopedValue.newInstance();

public Response handleRequest(Request req) throws Exception {
    RequestContext ctx = RequestContext.from(req);

    return ScopedValue.where(CTX, ctx).call(() -> {
        try (var scope = new ShutdownOnFailure()) {
            // Both subtasks automatically inherit CTX binding
            Subtask<UserData>    userData = scope.fork(() -> {
                CTX.get(); // RequestContext — inherited from parent!
                return userService.getData(CTX.get().userId());
            });
            Subtask<OrderData> orderData = scope.fork(() -> {
                CTX.get(); // RequestContext — same binding
                return orderService.getData(CTX.get().userId());
            });

            scope.join().throwIfFailed();
            return Response.of(userData.get(), orderData.get());
        }
    });
}
```

### 5.4 Inheritance Is Lexically Scoped

The binding propagates to threads created **within** the scope. Threads created outside the scope, or after the scope exits, do not see the binding:

```java
static final ScopedValue<String> TRACE = ScopedValue.newInstance();

// Thread created OUTSIDE scope — does not inherit
Thread outsider = Thread.ofVirtual().unstarted(() -> {
    System.out.println(TRACE.isBound()); // false — not inside scope
});

ScopedValue.where(TRACE, "trace-1").run(() -> {
    System.out.println(TRACE.get()); // trace-1

    // Thread created INSIDE scope — inherits
    Thread insider = Thread.ofVirtual().start(() -> {
        System.out.println(TRACE.get()); // trace-1 — inherited
    });
    insider.join();

    outsider.start(); // started inside scope but CREATED outside — does NOT inherit
    outsider.join();  // false
});
```

---

## 6. Rebinding — Nested Scopes with Different Values

### 6.1 What Rebinding Is

Rebinding creates a nested scope where a `ScopedValue` is temporarily bound to a different value. The outer binding is not mutated — it is **shadowed** for the duration of the inner scope. When the inner scope exits, the outer value is restored automatically.

```java
static final ScopedValue<String> USER = ScopedValue.newInstance();

ScopedValue.where(USER, "alice").run(() -> {
    System.out.println(USER.get()); // alice

    // Inner scope: rebind USER to "system"
    ScopedValue.where(USER, "system").run(() -> {
        System.out.println(USER.get()); // system — rebinding active
        performSystemOperation();
    }); // inner scope exits — rebinding removed

    System.out.println(USER.get()); // alice — outer binding restored
});
```

### 6.2 Rebinding Stack — Multiple Levels

```java
static final ScopedValue<Integer> LEVEL = ScopedValue.newInstance();

ScopedValue.where(LEVEL, 1).run(() -> {
    System.out.println(LEVEL.get()); // 1

    ScopedValue.where(LEVEL, 2).run(() -> {
        System.out.println(LEVEL.get()); // 2

        ScopedValue.where(LEVEL, 3).run(() -> {
            System.out.println(LEVEL.get()); // 3
        });

        System.out.println(LEVEL.get()); // 2 — restored
    });

    System.out.println(LEVEL.get()); // 1 — restored
});

System.out.println(LEVEL.isBound()); // false — all scopes exited
```

### 6.3 Practical Use of Rebinding — Privilege Escalation

A common pattern: temporarily elevate permissions for a specific operation:

```java
static final ScopedValue<Set<Permission>> PERMISSIONS = ScopedValue.newInstance();

// Regular user request
ScopedValue.where(PERMISSIONS, userPermissions).run(() -> {
    renderDashboard(); // reads PERMISSIONS — user sees their dashboard

    // For a specific internal operation, escalate temporarily
    ScopedValue.where(PERMISSIONS, adminPermissions).run(() -> {
        auditLog.write(event); // needs admin permissions to write audit log
    }); // admin permissions gone after this

    renderDashboard(); // back to user permissions
});
```

### 6.4 Practical Use — Locale Override

```java
static final ScopedValue<Locale> LOCALE = ScopedValue.newInstance();

// Default: user's locale
ScopedValue.where(LOCALE, userLocale).run(() -> {
    renderPage(); // uses userLocale

    // But email content must be in English for audit trail
    ScopedValue.where(LOCALE, Locale.ENGLISH).run(() -> {
        emailService.sendAuditEmail(event); // uses Locale.ENGLISH
    });

    renderPage(); // back to userLocale
});
```

---

## 7. Multiple Scoped Values — `ScopedValue.where().where()`

### 7.1 Chaining `where()` Calls

You can bind multiple `ScopedValue` instances atomically by chaining `where()` calls on the `Carrier`:

```java
static final ScopedValue<User>   CURRENT_USER = ScopedValue.newInstance();
static final ScopedValue<String> TRACE_ID     = ScopedValue.newInstance();
static final ScopedValue<Locale> LOCALE       = ScopedValue.newInstance();

// All three are bound simultaneously — atomic, all-or-nothing
ScopedValue
    .where(CURRENT_USER, authenticatedUser)
    .where(TRACE_ID,     "trace-abc-123")
    .where(LOCALE,       Locale.FRANCE)
    .run(() -> {
        CURRENT_USER.get(); // authenticatedUser
        TRACE_ID.get();     // trace-abc-123
        LOCALE.get();       // fr_FR
    });
// All three bindings removed when run() exits
```

### 7.2 Centralized Context Object Pattern

A clean architecture pattern: bundle all request-scoped values into a single context class:

```java
// All request-scoped keys in one place
public final class RequestScope {
    private RequestScope() {}

    public static final ScopedValue<Principal>    PRINCIPAL  = ScopedValue.newInstance();
    public static final ScopedValue<String>       TRACE_ID   = ScopedValue.newInstance();
    public static final ScopedValue<Locale>       LOCALE     = ScopedValue.newInstance();
    public static final ScopedValue<DataSource>   DATASOURCE = ScopedValue.newInstance();

    /**
     * Execute a task with all request-scoped values bound.
     * Used in request entry points (servlet filters, gRPC interceptors, etc.)
     */
    public static <R> R runRequest(
            Principal principal,
            String traceId,
            Locale locale,
            DataSource ds,
            Callable<R> task) throws Exception {

        return ScopedValue
            .where(PRINCIPAL,  principal)
            .where(TRACE_ID,   traceId)
            .where(LOCALE,     locale)
            .where(DATASOURCE, ds)
            .call(task);
    }

    /** Convenience: get trace ID or "no-trace" if not in a request scope */
    public static String currentTraceId() {
        return TRACE_ID.orElse("no-trace");
    }

    /** Convenience: get locale or JVM default if not in a request scope */
    public static Locale currentLocale() {
        return LOCALE.orElse(Locale.getDefault());
    }
}

// Usage in a filter/interceptor:
public Response handle(Request req) throws Exception {
    return RequestScope.runRequest(
        authenticate(req),
        req.header("X-Trace-Id"),
        parseLocale(req),
        getDataSource(req.tenant()),
        () -> router.dispatch(req)
    );
}

// Usage anywhere deep in the call stack:
public void saveOrder(Order order) {
    String trace = RequestScope.currentTraceId();
    log.info("[{}] Saving order {}", trace, order.id());

    DataSource ds = RequestScope.DATASOURCE.get();
    // use datasource...
}
```

---

## 8. Migration: `ThreadLocal` → `ScopedValue`

### 8.1 The Migration Mental Model

| `ThreadLocal` concept | `ScopedValue` equivalent |
|---|---|
| `static final ThreadLocal<T> TL = new ThreadLocal<>()` | `static final ScopedValue<T> SV = ScopedValue.newInstance()` |
| `TL.set(value)` at request start | `ScopedValue.where(SV, value).run(handler)` |
| `TL.get()` anywhere in call stack | `SV.get()` anywhere in scope |
| `TL.remove()` at request end | Automatic — scope exits, binding gone |
| `TL.set(newValue)` mid-scope | `ScopedValue.where(SV, newValue).run(...)` (rebind in nested scope) |
| Per-thread independent values | Shared immutable binding — same value for all threads in scope |

### 8.2 Simple Trace ID Migration

```java
// ═══════════════════════════════════════════════════════════════
// OLD WAY — ThreadLocal
// ═══════════════════════════════════════════════════════════════
public class TraceContext {
    private static final ThreadLocal<String> TRACE_ID = new ThreadLocal<>();

    public static void set(String id)  { TRACE_ID.set(id); }
    public static String get()         { return TRACE_ID.get(); }
    public static void clear()         { TRACE_ID.remove(); } // easy to forget!

    public static String getOrDefault() {
        String id = TRACE_ID.get();
        return id != null ? id : "no-trace";
    }
}

// In a servlet filter:
public void doFilter(Request req, Response res, FilterChain chain) {
    TraceContext.set(req.getHeader("X-Trace-Id"));
    try {
        chain.doFilter(req, res); // TraceContext.get() works throughout
    } finally {
        TraceContext.clear(); // MUST NOT forget this
    }
}

// ═══════════════════════════════════════════════════════════════
// NEW WAY — ScopedValue
// ═══════════════════════════════════════════════════════════════
public class TraceContext {
    public static final ScopedValue<String> TRACE_ID = ScopedValue.newInstance();

    // No set(), no clear() — not needed
    public static String getOrDefault() {
        return TRACE_ID.orElse("no-trace");
    }
}

// In a filter/interceptor:
public void doFilter(Request req, Response res, FilterChain chain) throws Exception {
    ScopedValue
        .where(TraceContext.TRACE_ID, req.getHeader("X-Trace-Id"))
        .run(() -> chain.doFilter(req, res)); // binding automatically removed when run() exits
    // No try/finally. No clear(). No leaks possible.
}
```

### 8.3 Auth Context Migration

```java
// ═══════════════════════════════════════════════════════════════
// OLD WAY
// ═══════════════════════════════════════════════════════════════
public class SecurityContext {
    private static final ThreadLocal<Authentication> AUTH = new ThreadLocal<>();

    public static void setAuthentication(Authentication auth) { AUTH.set(auth); }
    public static Authentication getAuthentication()          { return AUTH.get(); }
    public static boolean isAuthenticated()                   { return AUTH.get() != null; }
    public static void clearAuthentication()                  { AUTH.remove(); }

    public static boolean hasRole(String role) {
        Authentication auth = AUTH.get();
        return auth != null && auth.roles().contains(role);
    }
}

// ═══════════════════════════════════════════════════════════════
// NEW WAY
// ═══════════════════════════════════════════════════════════════
public class SecurityContext {
    public static final ScopedValue<Authentication> AUTH = ScopedValue.newInstance();

    public static boolean isAuthenticated() {
        return AUTH.isBound();
    }

    public static boolean hasRole(String role) {
        return AUTH.isBound() && AUTH.get().roles().contains(role);
    }

    public static Authentication current() {
        return AUTH.orElseThrow(() -> new SecurityException("Not authenticated"));
    }

    // No set(), no clear() — the scope enforces cleanup
    // Caller establishes scope:
    // ScopedValue.where(AUTH, authentication).call(() -> handleRequest(req));
}
```

### 8.4 Cases Where `ThreadLocal` Still Makes Sense

`ScopedValue` does **not** replace every `ThreadLocal` use case. `ThreadLocal` is still appropriate for:

| Use case | Why `ThreadLocal` is still fine |
|---|---|
| Per-thread caching (e.g., `SimpleDateFormat`) | No scope needed — it's a thread-local resource, not request-scoped context |
| Accumulating data within a single thread | Mutable accumulation is the point |
| Non-scoped per-thread state (random seeds, connection-per-thread) | No logical "scope" to bind to |
| True per-thread independent mutable state | `ScopedValue` is explicitly immutable |

```java
// STILL OK with ThreadLocal — formatter is a thread-local resource, not request context
private static final ThreadLocal<SimpleDateFormat> DATE_FORMAT =
    ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd"));

// MIGRATE to ScopedValue — trace ID is request-scoped context
// OLD: ThreadLocal<String> TRACE_ID
// NEW: ScopedValue<String> TRACE_ID
```

### 8.5 The Mutability Shift

The hardest migration challenge is code that mutates the `ThreadLocal` mid-scope. You must refactor to either:
1. **Compute the final value upfront** and bind it once
2. **Use rebinding** (nested scope) for the portion that needs a different value
3. **Pass the value as a method parameter** (explicit) instead of implicit context

```java
// OLD — mutable ThreadLocal modified throughout request processing
threadLocalUser.set(anonymousUser);
if (hasSession(req)) {
    threadLocalUser.set(sessionUser);     // mutates mid-processing
}
if (isAdmin(sessionUser)) {
    threadLocalUser.set(escalatedUser);   // mutates again
}
processRequest(); // uses whatever threadLocalUser is now

// NEW — determine the right value BEFORE binding
User user = determineUser(req); // all logic upfront
ScopedValue.where(CURRENT_USER, user).run(() -> {
    processRequest(); // binding is fixed — predictable
});

// OR use rebinding for the admin escalation portion only
User baseUser = getSessionUser(req);
ScopedValue.where(CURRENT_USER, baseUser).run(() -> {
    processRequest();
    if (needsAudit()) {
        ScopedValue.where(CURRENT_USER, AUDIT_PRINCIPAL).run(() -> {
            auditLog.write(event); // only this code sees AUDIT_PRINCIPAL
        });
    }
});
```

---

## 9. Real-World Patterns

### 9.1 Request-Scoped Logging (MDC Replacement)

Many logging frameworks use `MDC` (Mapped Diagnostic Context) — a `ThreadLocal`-backed map of contextual data. `ScopedValue` is a cleaner alternative:

```java
public final class LogContext {
    public static final ScopedValue<Map<String, String>> MDC = ScopedValue.newInstance();

    public static String get(String key) {
        return MDC.isBound()
            ? MDC.get().getOrDefault(key, "")
            : "";
    }

    // Create a new MDC scope with additional fields
    public static ScopedValue.Carrier withFields(Map<String, String> fields) {
        Map<String, String> combined = new HashMap<>();
        if (MDC.isBound()) combined.putAll(MDC.get()); // inherit parent fields
        combined.putAll(fields);
        return ScopedValue.where(MDC, Collections.unmodifiableMap(combined));
    }
}

// In an HTTP filter:
public void handle(Request req) throws Exception {
    LogContext.withFields(Map.of(
        "traceId",   req.traceId(),
        "userId",    req.userId(),
        "requestId", UUID.randomUUID().toString()
    )).run(() -> processRequest(req));
}

// In a logger:
public static void log(String message) {
    System.out.printf("[%s] [user:%s] %s%n",
        LogContext.get("traceId"),
        LogContext.get("userId"),
        message
    );
}
```

### 9.2 Database Transaction Context

```java
public final class TxContext {
    public static final ScopedValue<Connection> CONNECTION = ScopedValue.newInstance();

    public static <T> T inTransaction(DataSource ds, Callable<T> work) throws Exception {
        try (Connection conn = ds.getConnection()) {
            conn.setAutoCommit(false);
            try {
                T result = ScopedValue.where(CONNECTION, conn).call(work);
                conn.commit();
                return result;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // Anywhere in the call stack — get the current transaction's connection
    public static Connection current() {
        return CONNECTION.orElseThrow(
            () -> new IllegalStateException("No active transaction")
        );
    }
}

// Usage — any depth in call stack participates in same transaction
public Order createOrder(OrderRequest req) throws Exception {
    return TxContext.inTransaction(dataSource, () -> {
        Order order = orderRepo.save(req.toOrder());   // uses TxContext.current()
        inventoryService.reserve(req.items());          // uses TxContext.current()
        notificationService.enqueue(order);             // uses TxContext.current()
        return order;
    });
}

// In orderRepo.save():
public Order save(Order order) throws Exception {
    Connection conn = TxContext.current(); // participates in the caller's transaction
    try (PreparedStatement ps = conn.prepareStatement("INSERT INTO orders ...")) {
        // ...
    }
    return order;
}
```

### 9.3 Distributed Tracing — Span Propagation

```java
public final class TracingContext {
    public static final ScopedValue<Span> CURRENT_SPAN = ScopedValue.newInstance();

    /** Start a child span and run work within it */
    public static <T> T withChildSpan(String operationName, Callable<T> work) throws Exception {
        Span parent = CURRENT_SPAN.orElse(null);
        Span child = tracer.startSpan(operationName, parent);

        try {
            return ScopedValue.where(CURRENT_SPAN, child).call(work);
        } catch (Exception e) {
            child.setError(e);
            throw e;
        } finally {
            child.finish();
        }
    }

    public static void addTag(String key, String value) {
        if (CURRENT_SPAN.isBound()) {
            CURRENT_SPAN.get().setTag(key, value);
        }
    }
}

// Usage — tracing flows through the entire call stack automatically
public UserProfile loadProfile(long userId) throws Exception {
    return TracingContext.withChildSpan("loadProfile", () -> {
        TracingContext.addTag("userId", String.valueOf(userId));

        try (var scope = new ShutdownOnFailure()) {
            // Both subtasks INHERIT the current span
            var user   = scope.fork(() ->
                TracingContext.withChildSpan("fetchUser", () -> fetchUser(userId)));
            var orders = scope.fork(() ->
                TracingContext.withChildSpan("fetchOrders", () -> fetchOrders(userId)));

            scope.join().throwIfFailed();
            return new UserProfile(user.get(), orders.get());
        }
    });
}
```

### 9.4 Multi-Tenancy — Per-Request Tenant Isolation

```java
public final class TenantContext {
    public static final ScopedValue<TenantConfig> TENANT = ScopedValue.newInstance();

    public static TenantConfig current() {
        return TENANT.orElseThrow(
            () -> new IllegalStateException("No tenant context — call from outside request scope?")
        );
    }

    public static String currentTenantId() {
        return current().tenantId();
    }

    public static DataSource currentDataSource() {
        return current().dataSource(); // tenant-specific DB connection pool
    }
}

// Filter extracts tenant from JWT/subdomain and establishes scope
public void handle(Request req, FilterChain chain) throws Exception {
    TenantConfig tenant = tenantResolver.resolve(req);
    ScopedValue.where(TenantContext.TENANT, tenant)
               .run(() -> chain.doFilter(req, res));
}

// All data access automatically uses the right tenant's database
public List<Order> getOrders() {
    DataSource ds = TenantContext.currentDataSource(); // right tenant's DB
    // query...
}
```

---

## 10. Integration with Structured Concurrency

### 10.1 The Natural Pairing

`ScopedValue` and `StructuredTaskScope` are designed to work together. The bounded lifetime of `ScopedValue` maps perfectly to the bounded lifetime of a structured scope. Both follow the same "scope = bounded unit of work" mental model.

```java
public record RequestContext(String traceId, User user, Locale locale) {}

static final ScopedValue<RequestContext> CTX = ScopedValue.newInstance();

public DashboardData buildDashboard(RequestContext ctx) throws Exception {
    return ScopedValue.where(CTX, ctx).call(() -> {
        try (var scope = new ShutdownOnFailure()) {
            // All subtasks inherit CTX — no need to pass ctx as a parameter
            var profile  = scope.fork(() -> fetchProfile(CTX.get().user().id()));
            var orders   = scope.fork(() -> fetchOrders(CTX.get().user().id()));
            var messages = scope.fork(() -> fetchMessages(CTX.get().user().id()));

            scope.join().throwIfFailed();
            return new DashboardData(profile.get(), orders.get(), messages.get());
        }
    });
}
```

### 10.2 Layered Scopes — Context + Subtask Structure

```java
// Layer 1: Request scope — user, trace, locale
// Layer 2: Structured task scope — parallel subtasks
// Layer 3: Each subtask may rebind for its specific work

ScopedValue.where(USER, authenticatedUser)
           .where(TRACE, traceId)
           .call(() -> {
    try (var scope = new ShutdownOnFailure()) {

        scope.fork(() -> {
            // This subtask needs a different role for system audit
            return ScopedValue.where(ROLE, "SYSTEM_AUDITOR").call(() -> {
                return auditService.check(USER.get()); // USER still inherited
            });
        });

        scope.fork(() -> {
            // This subtask uses the original role
            return dataService.load(USER.get(), ROLE.get());
        });

        scope.join().throwIfFailed();
    }
    return result;
});
```

### 10.3 `ScopedValue` Lifetime vs `StructuredTaskScope` Lifetime

The `ScopedValue` binding must outlive all threads that use it. Since `StructuredTaskScope` guarantees all child threads complete before the scope exits, and `ScopedValue` binding covers the entire `run()`/`call()` body (which includes the structured scope), this invariant holds automatically:

```java
ScopedValue.where(CTX, context).call(() -> {      // ← ScopedValue scope starts
    try (var taskScope = new ShutdownOnFailure()) { // ← task scope starts
        taskScope.fork(() -> CTX.get());            // CTX available to child
        taskScope.join().throwIfFailed();
    }                                               // ← ALL tasks done before here
    return result;
});                                                 // ← ScopedValue scope ends AFTER tasks
// Children can never outlive the ScopedValue binding — guaranteed by structure
```

---

## 11. Edge Cases and Gotchas

### 11.1 Accessing `ScopedValue` Outside Its Scope Throws

```java
static final ScopedValue<String> KEY = ScopedValue.newInstance();

Subtask<?>[] leak = new Subtask[1];

ScopedValue.where(KEY, "value").run(() -> {
    // Fine inside scope
    System.out.println(KEY.get()); // "value"
});

// OUTSIDE scope — throws
try {
    KEY.get(); // NoSuchElementException: ScopedValue not bound
} catch (NoSuchElementException e) {
    System.out.println("Not bound: " + e.getMessage());
}

// Use orElse() for safe access in mixed contexts:
String safe = KEY.orElse("default"); // "default" — no exception
```

### 11.2 Threads Created OUTSIDE the Scope Don't Inherit

This is the most common gotcha. Only threads **created inside** the scope inherit the binding:

```java
static final ScopedValue<String> TENANT = ScopedValue.newInstance();

// Thread created BEFORE the scope — does NOT inherit
Thread preScopeThread = Thread.ofVirtual().unstarted(() ->
    System.out.println(TENANT.isBound())); // false

// Thread pool created BEFORE the scope — threads don't inherit either
ExecutorService pool = Executors.newVirtualThreadPerTaskExecutor();

ScopedValue.where(TENANT, "acme-corp").run(() -> {
    System.out.println(TENANT.get()); // acme-corp

    // Thread started INSIDE scope — inherits
    Thread.ofVirtual().start(() ->
        System.out.println(TENANT.get())); // acme-corp ✓

    // Task submitted to pool created INSIDE scope — inherits
    ExecutorService innerPool = Executors.newVirtualThreadPerTaskExecutor();
    innerPool.submit(() ->
        System.out.println(TENANT.get())); // acme-corp ✓

    // Pre-scope thread started INSIDE scope body — does NOT inherit
    // (thread was created before scope, so it has no binding)
    preScopeThread.start(); // false — doesn't inherit even though started inside scope

    // Pre-scope pool task — does NOT inherit
    pool.submit(() ->
        System.out.println(TENANT.isBound())); // false
});
```

### 11.3 `ScopedValue` Is Not Serializable

`ScopedValue` and its bindings are in-memory, JVM-local. They cannot be passed to other processes, serialized, or stored. For distributed tracing, serialize the trace ID to a string and propagate it via HTTP headers; rebind it from the incoming request header on the receiving side.

### 11.4 `run()` vs `call()` vs `get()` — Exception Handling Difference

```java
// run() — no return value, wraps checked exceptions in RuntimeException
ScopedValue.where(KEY, val).run(() -> {
    // Can throw unchecked only — checked exceptions must be wrapped
    throw new RuntimeException("ok");
    // throw new IOException("err"); // compile error — run() takes Runnable
});

// call() — returns value, propagates checked exceptions
try {
    String result = ScopedValue.where(KEY, val).call(() -> {
        throw new IOException("checked ok"); // compiles — Callable
    });
} catch (Exception e) { /* IOException */ }

// get() — returns value, no checked exceptions (wraps in RuntimeException)
String result = ScopedValue.where(KEY, val).get(() -> {
    // throw new IOException("err"); // compile error — Supplier
    return "value";
});
```

### 11.5 Rebinding in a Loop — Each Iteration Gets Its Own Scope

```java
static final ScopedValue<Integer> IDX = ScopedValue.newInstance();

for (int i = 0; i < 3; i++) {
    final int captured = i;
    ScopedValue.where(IDX, captured).run(() -> {
        System.out.println(IDX.get()); // 0, then 1, then 2
        // Each iteration has its own scope — no sharing between iterations
    });
    // IDX unbound between iterations
}
```

### 11.6 Performance — `ScopedValue` vs `ThreadLocal`

`ScopedValue` is significantly more memory-efficient than `ThreadLocal` with virtual threads:

- `ThreadLocal`: each virtual thread has its own `ThreadLocalMap` — O(ThreadLocals × threads) memory
- `ScopedValue`: bindings are stored on the call stack (as part of the scope frame) — O(bindings in current scope) per thread, not per-thread copies

For millions of virtual threads, this difference is enormous. For a small fixed number of OS threads, the difference is negligible.

---

## 12. Quick Reference Cheat Sheet

### Declaration

```java
// Always: public static final, declared in a class, not as a local variable
public static final ScopedValue<User>   CURRENT_USER = ScopedValue.newInstance();
public static final ScopedValue<String> TRACE_ID     = ScopedValue.newInstance();
```

### Binding and Execution

```java
// Single binding, no return value
ScopedValue.where(KEY, value).run(() -> { ... });

// Single binding, return value (checked exceptions)
R result = ScopedValue.where(KEY, value).call(() -> { return ...; });

// Single binding, return value (no checked exceptions)
R result = ScopedValue.where(KEY, value).get(() -> { return ...; });

// Multiple bindings, chained
ScopedValue.where(KEY1, v1)
           .where(KEY2, v2)
           .where(KEY3, v3)
           .run(() -> { ... });

// Rebinding (nested scope)
ScopedValue.where(KEY, outer).run(() -> {
    KEY.get(); // outer
    ScopedValue.where(KEY, inner).run(() -> {
        KEY.get(); // inner
    });
    KEY.get(); // outer — restored
});
```

### Reading Values

```java
KEY.get()                    // T — throws NoSuchElementException if unbound
KEY.isBound()                // boolean — false if no binding active
KEY.orElse(defaultValue)     // T — returns default if unbound (no exception)
KEY.orElseThrow(exSupplier)  // T — throws custom exception if unbound
```

### Key Rules to Remember

1. **Declare as `public static final`** — the `ScopedValue` is a key, not a value container.
2. **Binding is immutable** — there is no `set()` or `remove()`. Use rebinding (nested scope) to change values.
3. **Binding is automatically removed** when `run()`/`call()`/`get()` exits — no cleanup needed.
4. **Child virtual threads inherit** bindings from the thread that spawned them, if created inside the scope.
5. **Threads created OUTSIDE the scope** do not inherit, even if started inside the scope body.
6. **Use `orElse()`** for code that may run both inside and outside a scope.
7. **Use `call()` for checked exceptions** — `run()` takes `Runnable` (unchecked only).
8. **`ScopedValue` + `StructuredTaskScope` are designed to work together** — bindings naturally cover the task scope lifetime.
9. **Don't migrate all `ThreadLocal` uses** — per-thread caching and mutable per-thread state still belong in `ThreadLocal`.
10. **Memory model**: shared value reference, not per-thread copies — efficient for millions of virtual threads.

### `ThreadLocal` vs `ScopedValue` at a Glance

| Property | `ThreadLocal` | `ScopedValue` |
|---|---|---|
| Mutability | Mutable — `set()` anytime | Immutable within scope |
| Lifetime | Thread lifetime (leaks with pools) | Scope lifetime (automatic) |
| Cleanup | Manual `remove()` required | Automatic on scope exit |
| Memory model | Per-thread copy | Shared reference |
| Child threads | Not inherited (unless `Inheritable`) | Automatically inherited |
| Virtual thread cost | High — per-thread storage | Low — on-stack binding |
| Rebinding | `set()` mutates the same thread | Nested `where()` creates new scope |
| Debugging | Hard — invisible mutations | Easy — immutable, lexically scoped |

---

*End of Java Scoped Values Study Guide — JEP 446 (Preview) / JEP 481 (Java 24 Final)*
