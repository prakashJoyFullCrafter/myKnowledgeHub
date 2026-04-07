# Java Best Practices & Rules - Curriculum

A reference guide of rules and conventions for writing clean, safe, and performant Java code.

---

## Module 1: Null Handling Rules
- [ ] **Never return `null` from collections** - return `Collections.emptyList()`, `Map.of()`, `Set.of()`
- [ ] **Use `Optional<T>` for method returns** that may have no value
- [ ] **Never use `Optional` as a field, parameter, or collection element** - it's for return types only
- [ ] **Prefer `Optional.ofNullable()` over `Optional.of()`** when value might be null
- [ ] **Chain Optional**: `.map()`, `.flatMap()`, `.orElse()`, `.orElseThrow()` instead of `.isPresent()` + `.get()`
- [ ] **Never call `Optional.get()` without checking** - use `orElseThrow()` instead
- [ ] **Use `@Nullable` and `@NonNull` annotations** (JSR-305 or JetBrains) on public APIs
- [ ] **Validate non-null parameters early**: `Objects.requireNonNull(param, "param must not be null")`
- [ ] **Prefer `"constant".equals(variable)`** over `variable.equals("constant")` to avoid NPE
- [ ] **Use `Objects.equals(a, b)`** for null-safe comparison
- [ ] **Database results**: always handle `null` from database columns
- [ ] **Spring**: use `Optional<T>` in `@RequestParam` for optional query params

### Anti-Patterns
- [ ] ❌ `if (x != null) { if (x.getY() != null) { ... } }` → ✅ Use `Optional` chain
- [ ] ❌ `return null;` from a `List` method → ✅ `return Collections.emptyList();`
- [ ] ❌ `Optional.of(possiblyNull)` → ✅ `Optional.ofNullable(possiblyNull)`
- [ ] ❌ `if (opt.isPresent()) { return opt.get(); }` → ✅ `return opt.orElseThrow()`

---

## Module 2: Exception Handling Rules
- [ ] **Throw early, catch late** - validate inputs early, handle exceptions at appropriate layer
- [ ] **Never catch `Exception` or `Throwable`** broadly - catch specific exceptions
- [ ] **Never swallow exceptions** - always log or rethrow: `catch (IOException e) { log.error("...", e); }`
- [ ] **Always include the cause**: `throw new ServiceException("message", e)` - never lose the stack trace
- [ ] **Use `try-with-resources`** for all `AutoCloseable` resources (streams, connections, readers)
- [ ] **Custom exceptions should extend `RuntimeException`** for business logic (unchecked)
- [ ] **Use checked exceptions only for recoverable conditions** the caller can realistically handle
- [ ] **Create a domain exception hierarchy**: `BaseException` → `NotFoundException`, `ValidationException`, `ConflictException`
- [ ] **Include context in exception messages**: `"User not found: id=" + id` not just `"Not found"`
- [ ] **Never use exceptions for control flow** - exceptions are for exceptional situations
- [ ] **Never throw from `finally`** blocks - it swallows the original exception
- [ ] **Log at the right level**: `ERROR` for failures, `WARN` for recoverable, `DEBUG` for context

### Exception Hierarchy Template
```
AppException (RuntimeException)
├── NotFoundException          → 404
├── ValidationException        → 400
├── ConflictException          → 409
├── ForbiddenException         → 403
├── ExternalServiceException   → 502
└── InternalException          → 500
```

### Anti-Patterns
- [ ] ❌ `catch (Exception e) { }` (swallowed)
- [ ] ❌ `catch (Exception e) { throw new RuntimeException(e.getMessage()); }` (lost stack trace)
- [ ] ❌ `if (user == null) throw new Exception("not found")` → ✅ `throw new UserNotFoundException(id)`
- [ ] ❌ Using exceptions for `if-else` logic (e.g., checking if element exists)

---

## Module 3: Immutability Rules
- [ ] **Make classes immutable by default** - use `final` class, `final` fields, no setters
- [ ] **Use Records (Java 16+)** for data carriers: `record User(String name, int age) {}`
- [ ] **Defensive copies** for mutable fields: copy collections in constructor and getter
- [ ] **Return unmodifiable views**: `Collections.unmodifiableList()`, `List.copyOf()`
- [ ] **Use `List.of()`, `Set.of()`, `Map.of()`** for immutable collections (Java 9+)
- [ ] **Prefer `StringBuilder` over `String` concatenation** in loops
- [ ] **Mark all fields `final`** unless there's a specific reason for mutability
- [ ] **Mark all method parameters `final`** (optional but signals intent)
- [ ] **Make utility classes non-instantiable**: `private` constructor + `final` class
- [ ] **Thread safety for free** - immutable objects are inherently thread-safe
- [ ] **Defensive copies for mutable types**: copy `Date`, `Calendar`, arrays in constructors and getters
- [ ] **Never expose mutable internal arrays**: `return Arrays.copyOf(this.items, items.length)`
- [ ] **`Date`/`Calendar` fields**: copy on input and output, or replace with `java.time` immutables

### Anti-Patterns
- [ ] ❌ `public List<User> getUsers() { return this.users; }` → ✅ `return List.copyOf(this.users);`
- [ ] ❌ Mutable DTO with 20 setters → ✅ Record or Builder pattern
- [ ] ❌ `public static` mutable fields → ✅ `private static final` + unmodifiable
- [ ] ❌ `this.dates = dates;` (mutable `Date[]`) → ✅ `this.dates = Arrays.copyOf(dates, dates.length);`

---

## Module 4: API Design Rules
- [ ] **Method naming**: verbs for actions (`findById`, `createUser`), nouns for getters (`getName`)
- [ ] **Boolean methods**: use `is`/`has`/`can` prefix (`isActive`, `hasPermission`, `canExecute`)
- [ ] **Avoid method overloading with same param count** - confusing to callers
- [ ] **Use static factory methods** over constructors: `User.of(name)`, `User.fromDto(dto)`
- [ ] **Return `this`** from builder/setter methods for fluent API
- [ ] **Limit parameters to 3-4 max** - use a parameter object or builder beyond that
- [ ] **Don't return `void`** if you can return something useful (fluent, the object itself)
- [ ] **Design for inheritance or prohibit it**: `final` class by default, `open` only when designed for extension
- [ ] **Minimize accessibility**: `private` → `package-private` → `protected` → `public`
- [ ] **Interface-based API**: return `List` not `ArrayList`, accept `Collection` not `List` when possible
- [ ] **Use enums instead of `int` constants or `String` flags**
- [ ] **Avoid boolean parameters** - they make call sites unreadable: `createUser(true, false)` → use enums or builder
- [ ] **Records**: use for DTOs, value objects, projections; NOT for JPA entities (need mutability for proxying)
- [ ] **Records**: prefer records over Lombok `@Value` in Java 16+ projects
- [ ] **Records**: use compact constructors for validation: `record Email(String value) { Email { if (!value.contains("@")) throw new IllegalArgumentException(); } }`
- [ ] **Records**: remember only constructor params are in `equals()`/`hashCode()` - body fields are excluded

### Naming Conventions
```
Classes      → PascalCase: UserService, OrderRepository
Methods      → camelCase: findById, calculateTotal
Constants    → UPPER_SNAKE: MAX_RETRIES, DEFAULT_TIMEOUT
Packages     → lowercase: com.myapp.user.service
Type Params  → Single uppercase: T (type), E (element), K (key), V (value)
```

---

## Module 5: Collections & Streams Rules
- [ ] **Choose the right collection**: ArrayList (default), LinkedHashMap (order), TreeMap (sorted), ArrayDeque (stack/queue)
- [ ] **Never use `Vector`, `Stack`, `Hashtable`** - use `ArrayList`, `ArrayDeque`, `HashMap`
- [ ] **Program to interfaces**: `List<User> users = new ArrayList<>()` not `ArrayList<User>`
- [ ] **Pre-size collections** when size is known: `new ArrayList<>(expectedSize)`
- [ ] **Use `Map.computeIfAbsent()`** instead of check-then-put pattern
- [ ] **Use `getOrDefault()`** instead of null check after `get()`
- [ ] **Streams: don't overuse** - a simple `for` loop is fine for simple operations
- [ ] **Streams: never modify external state** in `forEach()` - streams should be side-effect free
- [ ] **Streams: prefer `toList()` (Java 16+)** over `collect(Collectors.toList())`
- [ ] **Streams: use `flatMap` to avoid nested collections**: `users.stream().flatMap(u -> u.getOrders().stream())`
- [ ] **Never use parallel streams** unless you've profiled and confirmed it helps
- [ ] **Override `equals()` AND `hashCode()` together** - never one without the other
- [ ] **Implement `Comparable`** for natural ordering, `Comparator` for custom ordering

### Anti-Patterns
- [ ] ❌ `list.stream().forEach(x -> result.add(x))` → ✅ `list.stream().collect(toList())`
- [ ] ❌ `if (map.containsKey(k)) { map.get(k) }` → ✅ `map.getOrDefault(k, default)`
- [ ] ❌ `map.get(k) != null ? map.get(k) : new V()` → ✅ `map.computeIfAbsent(k, key -> new V())`

---

## Module 6: Concurrency Rules
- [ ] **Prefer `ExecutorService` over manual `Thread` creation** - always
- [ ] **Prefer `CompletableFuture` over `Future`** for async operations
- [ ] **Use `ConcurrentHashMap` not `synchronized HashMap`**
- [ ] **Use `AtomicInteger/Long` for counters** instead of `synchronized` blocks
- [ ] **Make shared data immutable** whenever possible
- [ ] **Use `volatile` for flags** that are read by one thread, written by another
- [ ] **Never call `Thread.stop()`** - use interruption: `thread.interrupt()` + `isInterrupted()` check
- [ ] **Always handle `InterruptedException`**: restore interrupt flag `Thread.currentThread().interrupt()`
- [ ] **Use `try-finally` or `try-with-resources` for lock release**: never assume lock will be released
- [ ] **Size thread pools correctly**: CPU-bound = cores, I/O-bound = cores * (1 + wait/compute)
- [ ] **Prefer Virtual Threads (Java 21+)** for I/O-bound workloads
- [ ] **Never hold a lock while calling external services** - deadlock risk

### Anti-Patterns
- [ ] ❌ `new Thread(() -> { ... }).start()` → ✅ `executorService.submit(() -> { ... })`
- [ ] ❌ `synchronized (this)` on public method → ✅ `private final Object lock = new Object();`
- [ ] ❌ Catching and ignoring `InterruptedException` → ✅ Restore interrupt flag

---

## Module 7: Performance Rules
- [ ] **Avoid string concatenation in loops**: use `StringBuilder`
- [ ] **Avoid autoboxing in tight loops**: `int` not `Integer`, `long` not `Long`
- [ ] **Use primitive arrays over `List<Integer>`** for large numeric datasets
- [ ] **Avoid creating unnecessary objects**: reuse `DateTimeFormatter`, `Pattern`, `ObjectMapper`
- [ ] **Make `ObjectMapper` a shared singleton** - creation is expensive
- [ ] **Use `StringBuilder` capacity hint**: `new StringBuilder(expectedLength)`
- [ ] **Avoid `String.format()` in hot paths** - it's slow; use concatenation or `StringBuilder`
- [ ] **Use `EnumMap`/`EnumSet`** when keys are enums - faster than `HashMap`/`HashSet`
- [ ] **Lazy initialization** for expensive objects: `Supplier<T>` or double-checked locking
- [ ] **Close resources promptly** - unclosed connections/streams cause leaks
- [ ] **Use `Arrays.copyOf()` over manual array copying**
- [ ] **Profile before optimizing** - don't guess, measure with JMH or async-profiler

### Anti-Patterns
- [ ] ❌ `String result = ""; for (...) { result += item; }` → ✅ `StringBuilder`
- [ ] ❌ `new ObjectMapper()` in every method call → ✅ Shared instance
- [ ] ❌ `Pattern.compile(regex)` in a loop → ✅ `private static final Pattern PATTERN = ...`
- [ ] ❌ Premature optimization without profiling

---

## Module 8: Security Rules
- [ ] **Never trust user input** - validate and sanitize everything
- [ ] **Use parameterized queries** - never concatenate SQL strings
- [ ] **Use `PreparedStatement`** not `Statement` for SQL queries
- [ ] **Encode output** for the context: HTML encoding, URL encoding, JSON encoding
- [ ] **Never log sensitive data**: passwords, tokens, credit cards, PII
- [ ] **Use `char[]` for passwords** not `String` (Strings are immutable in string pool)
- [ ] **Validate `@RequestParam`, `@PathVariable`** with Bean Validation constraints
- [ ] **Use `BCrypt` or `Argon2`** for password hashing - never MD5/SHA for passwords
- [ ] **Limit deserialization** - don't deserialize untrusted data without type filtering
- [ ] **Mark sensitive classes as `non-Serializable`** when possible
- [ ] **Avoid `Runtime.exec()`** with user input - command injection risk
- [ ] **Use `SecureRandom`** not `Random` for security-sensitive operations
- [ ] **Keep dependencies updated** - `mvn versions:display-dependency-updates`

---

## Module 9: Logging Rules
- [ ] **Use SLF4J** as logging facade, never `System.out.println`
- [ ] **Use parameterized logging**: `log.info("User {} logged in", userId)` not string concatenation
- [ ] **Log levels**: `ERROR` (action needed), `WARN` (unexpected), `INFO` (business events), `DEBUG` (diagnostics), `TRACE` (verbose)
- [ ] **Include context**: request ID, user ID, entity ID in log messages
- [ ] **Use MDC (Mapped Diagnostic Context)** for request-scoped context (trace ID, user ID)
- [ ] **Never log and throw** - do one or the other, not both
- [ ] **Never log sensitive data** - mask PII, tokens, passwords
- [ ] **Use structured logging (JSON)** in production for log aggregation
- [ ] **Guard expensive log computations**: `if (log.isDebugEnabled()) { log.debug(...) }`
- [ ] **Log at boundaries**: incoming requests, outgoing calls, errors, business events

### Anti-Patterns
- [ ] ❌ `log.error("Error: " + e.getMessage())` → ✅ `log.error("Failed to process order: {}", orderId, e)`
- [ ] ❌ `catch (Exception e) { log.error(e); throw e; }` (logged twice) → ✅ Log OR throw
- [ ] ❌ `System.out.println("debug: " + value)` → ✅ `log.debug("Value: {}", value)`

---

## Module 10: Effective Java - Essential Items (Joshua Bloch)

### Object Creation & Destruction
- [ ] Item 1: Use static factory methods instead of constructors
- [ ] Item 2: Use builders when faced with many constructor parameters
- [ ] Item 3: Enforce singleton with private constructor or enum
- [ ] Item 5: Prefer dependency injection over hardwired resources
- [ ] Item 7: Eliminate obsolete object references (memory leaks)
- [ ] Item 9: Prefer try-with-resources to try-finally

### Methods Common to All Objects
- [ ] Item 10: Obey the general contract of `equals()`
- [ ] Item 11: Always override `hashCode()` when you override `equals()`
- [ ] Item 12: Always override `toString()` for debugging
- [ ] Item 13: Override `clone()` judiciously (prefer copy constructors)
- [ ] Item 14: Consider implementing `Comparable`

### Classes & Interfaces
- [ ] Item 15: Minimize accessibility of classes and members
- [ ] Item 16: Use accessor methods in public classes, not public fields
- [ ] Item 17: Minimize mutability
- [ ] Item 18: Favor composition over inheritance
- [ ] Item 20: Prefer interfaces to abstract classes

### Generics
- [ ] Item 26: Don't use raw types
- [ ] Item 28: Prefer lists to arrays (generics invariance)
- [ ] Item 30: Favor generic methods
- [ ] Item 31: Use bounded wildcards (PECS)

### Enums & Annotations
- [ ] Item 34: Use enums instead of int constants
- [ ] Item 36: Use `EnumSet` instead of bit fields
- [ ] Item 39: Prefer annotations to naming patterns

### Lambdas & Streams
- [ ] Item 42: Prefer lambdas to anonymous classes
- [ ] Item 43: Prefer method references to lambdas
- [ ] Item 45: Use streams judiciously (don't overuse)
- [ ] Item 46: Prefer side-effect-free functions in streams

### Concurrency
- [ ] Item 78: Synchronize access to shared mutable data
- [ ] Item 79: Avoid excessive synchronization
- [ ] Item 80: Prefer executors, tasks, streams to threads
- [ ] Item 81: Prefer concurrency utilities to `wait()` and `notify()`

---

## Quick Reference Cheat Sheet

| Situation | ❌ Don't | ✅ Do |
|-----------|---------|-------|
| Might be null | Return `null` | Return `Optional<T>` |
| Empty collection | Return `null` | Return `List.of()` |
| Exception | `catch (Exception e) {}` | Catch specific, log with stack trace |
| Resource | `try-finally` | `try-with-resources` |
| Data carrier | Mutable class + getters/setters | `record` or immutable class |
| String in loop | `result += item` | `StringBuilder` |
| Thread creation | `new Thread()` | `ExecutorService` |
| SQL | String concatenation | `PreparedStatement` |
| Password | `String` | `char[]` |
| Logging | `System.out.println` | SLF4J with parameterized messages |
| Collection type | `ArrayList<User> users` | `List<User> users` |
| Null check | `if (x != null && x.getY() != null)` | `Optional.map().orElse()` |

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Audit an existing project for null/exception/immutability violations |
| Modules 4-5 | Refactor a class following API design and collection rules |
| Modules 6-7 | Code review checklist: apply concurrency and performance rules |
| Modules 8-9 | Security and logging audit on a Spring Boot project |
| Module 10 | Read Effective Java, implement one item per day |

## Key Resources
- **Effective Java** (3rd Edition) - Joshua Bloch — the #1 Java rules book
- **Clean Code** - Robert C. Martin
- **Java Coding Guidelines** - CERT/Oracle
- **SonarQube Java Rules** - automated rule checking
- **Google Java Style Guide**
- **Error Prone** - compile-time bug detection (Google)
- **SpotBugs** - static analysis for Java bugs
