# Modern Java (17-25+) - Curriculum

A consolidated reference for features introduced from Java 17 through Java 25+, organized by theme rather than version.

---

## Module 1: Pattern Matching Evolution
- [ ] Pattern matching for `instanceof` (Java 16) - `if (obj instanceof String s)`
- [ ] Pattern matching in `switch` (Java 21) - type patterns in switch cases
- [ ] Guarded patterns: `case String s when s.length() > 5`
- [ ] Record patterns (Java 21) - `if (obj instanceof Point(int x, int y))`
- [ ] Nested record patterns: `case Line(Point(var x1, var y1), Point p2)`
- [ ] Unnamed patterns `_` (Java 22) - `case Point(var x, _)` to discard components
- [ ] Unnamed variables `_` (Java 22) - `catch (Exception _)`, `for (var _ : list)`
- [ ] Primitive patterns in `instanceof` and `switch` (Java 23+)
- [ ] Exhaustive switch: compiler enforces all cases covered with sealed types
- [ ] `switch` as expression returning a value with `->` and `yield`

---

## Module 2: Records & Sealed Types
- [ ] Records (Java 16) - immutable data carriers: `record Point(int x, int y) {}`
- [ ] Canonical constructor - the default constructor matching all components
- [ ] Compact constructor - validation without reassigning fields
- [ ] Custom constructors: must delegate to canonical constructor
- [ ] Records with custom methods, static fields, and nested types
- [ ] Local records - records declared inside methods
- [ ] Records implementing interfaces
- [ ] Record limitations: no `extends`, no mutable fields, no `var`
- [ ] Records vs classes vs Lombok `@Value` - decision guide
- [ ] Records with JPA/Hibernate: use for projections/DTOs, NOT entities
- [ ] Records with Jackson: serialization/deserialization works out of the box
- [ ] Sealed classes (Java 17) - `sealed class Shape permits Circle, Rectangle`
- [ ] Sealed interfaces - `sealed interface Result<T>`
- [ ] `permits` clause: subclasses must be `final`, `sealed`, or `non-sealed`
- [ ] Sealed + records: `sealed interface Result` → `record Success(T data)`, `record Failure(String error)`
- [ ] Sealed + switch: exhaustive matching without `default`
- [ ] Sealed types for domain modeling: state machines, command patterns, ASTs

---

## Module 3: Text & String Enhancements
- [ ] Text blocks (Java 15) - multi-line strings with `"""`
- [ ] Text block indentation: trailing `"""` position controls base indent
- [ ] Text block escapes: `\s` (space), `\` (line continuation)
- [ ] `String.strip()`, `stripLeading()`, `stripTrailing()` (Java 11) - Unicode-aware trim
- [ ] `String.isBlank()` (Java 11) - checks whitespace/empty
- [ ] `String.lines()` (Java 11) - splits into `Stream<String>` by line breaks
- [ ] `String.repeat(n)` (Java 11)
- [ ] `String.indent(n)` (Java 12) - adjusts indentation
- [ ] `String.transform(Function)` (Java 12) - apply function to string
- [ ] `String.formatted(args)` (Java 15) - instance method version of `String.format()`
- [ ] `String.stripIndent()` (Java 15) - remove incidental whitespace
- [ ] `String.translateEscapes()` (Java 15) - process escape sequences
- [ ] String Templates (preview/incubator) - `STR."Hello \{name}"` template processor
- [ ] Template processor API: `StringTemplate`, custom processors

---

## Module 4: Stream & Collection Enhancements
### Collections
- [ ] Immutable collection factories (Java 9): `List.of()`, `Set.of()`, `Map.of()`, `Map.ofEntries()`
- [ ] `List.copyOf()`, `Set.copyOf()`, `Map.copyOf()` (Java 10)
- [ ] `Collectors.toUnmodifiableList()`, `toUnmodifiableSet()`, `toUnmodifiableMap()` (Java 10)
- [ ] **`SequencedCollection`** (Java 21) - new interface: `getFirst()`, `getLast()`, `reversed()`
- [ ] **`SequencedSet`** (Java 21) - `LinkedHashSet` now implements it
- [ ] **`SequencedMap`** (Java 21) - `firstEntry()`, `lastEntry()`, `putFirst()`, `putLast()`, `reversed()`
- [ ] Collection hierarchy change: `List`, `SortedSet`, `LinkedHashSet` → `SequencedCollection`

### Streams
- [ ] `Stream.toList()` (Java 16) - shortcut for `collect(Collectors.toList())`, returns unmodifiable list
- [ ] `Stream.mapMulti()` (Java 16) - imperative alternative to `flatMap`
- [ ] `Stream.toList()` vs `collect(toList())` vs `collect(toUnmodifiableList())` - subtle differences
- [ ] `Collectors.teeing()` (Java 12) - combine two collectors into one result
- [ ] **Stream Gatherers** (Java 24+) - `stream.gather(Gatherer)` for custom intermediate operations
  - [ ] Built-in gatherers: `Gatherers.fold()`, `Gatherers.scan()`, `Gatherers.windowFixed()`, `Gatherers.windowSliding()`, `Gatherers.mapConcurrent()`
  - [ ] Writing custom `Gatherer<T, A, R>` implementations
  - [ ] Gatherers vs custom `Collector` - when to use which

### Other Utility Enhancements
- [ ] `Optional.isEmpty()` (Java 11)
- [ ] `Optional.stream()` (Java 9) - convert to 0-or-1 element stream
- [ ] `Optional.or()` (Java 9) - lazy alternative `Optional`
- [ ] `Optional.ifPresentOrElse()` (Java 9)
- [ ] `Map.entry()` (Java 9) - immutable `Map.Entry`
- [ ] `Predicate.not()` (Java 11) - `filter(Predicate.not(String::isBlank))`

---

## Module 5: Concurrency Evolution
- [ ] **Virtual Threads** (Java 21) - lightweight threads managed by JVM
  - [ ] `Thread.ofVirtual().start(() -> ...)` and `Thread.startVirtualThread()`
  - [ ] `Executors.newVirtualThreadPerTaskExecutor()` - one virtual thread per task
  - [ ] Why virtual threads change the game: millions of concurrent tasks
  - [ ] Pinning: `synchronized` blocks pin virtual thread to carrier thread → prefer `ReentrantLock`
  - [ ] Virtual threads + I/O: blocking calls no longer waste OS threads
  - [ ] Migration: replace `newFixedThreadPool` with `newVirtualThreadPerTaskExecutor` for I/O-bound work
- [ ] **Structured Concurrency** (Java 24+)
  - [ ] `StructuredTaskScope` - tasks have bounded lifecycle
  - [ ] `ShutdownOnFailure` - cancel all on first failure
  - [ ] `ShutdownOnSuccess` - cancel remaining on first success
  - [ ] `fork()` to submit subtasks, `join()` to await, `throwIfFailed()` to propagate
  - [ ] Why: prevents thread leaks, auto-cancellation, clear parent-child relationship
  - [ ] Replaces manual `ExecutorService` + `Future` + `try-finally` patterns
- [ ] **Scoped Values** (Java 24+)
  - [ ] `ScopedValue<T>` - replacement for `ThreadLocal` in virtual thread era
  - [ ] `ScopedValue.where(KEY, value).run(() -> ...)` - bounded scope
  - [ ] Immutable within scope (unlike `ThreadLocal`)
  - [ ] Automatic inheritance by child virtual threads
  - [ ] Why `ThreadLocal` is problematic: unbounded lifetime, mutable, memory leaks, costly with virtual threads
  - [ ] Migration: `ThreadLocal` → `ScopedValue` for request-scoped data

---

## Module 6: Foreign Function & Memory API (Panama)
- [ ] **Problem**: JNI is painful, unsafe, and verbose for calling native code
- [ ] **Foreign Function & Memory API** (Java 22+ finalized)
- [ ] `MemorySegment` - safe, bounded native memory access
  - [ ] `Arena.ofConfined()`, `Arena.ofShared()`, `Arena.global()` - lifecycle management
  - [ ] Allocating native memory: `arena.allocate(ValueLayout.JAVA_INT)`
  - [ ] Reading/writing: `segment.get(ValueLayout.JAVA_INT, offset)`
- [ ] `Linker` - calling native functions without JNI
  - [ ] `Linker.nativeLinker()` - default system linker
  - [ ] `FunctionDescriptor` - describing native function signatures
  - [ ] `SymbolLookup` - finding native functions in shared libraries
  - [ ] Calling C functions from Java: `strlen`, `printf`, custom libraries
- [ ] `MemoryLayout` - describing complex native data structures (structs)
- [ ] `jextract` tool - auto-generate Java bindings from C header files
- [ ] Panama vs JNI: safety, performance, boilerplate comparison
- [ ] Use cases: calling OS APIs, database drivers, crypto libraries, ML inference (TensorFlow C API)

---

## Module 7: Other Notable Features
### Switch Enhancements (consolidated)
- [ ] Arrow labels `->` (Java 14) - no fall-through
- [ ] `yield` keyword (Java 14) - return value from switch block
- [ ] Switch expressions returning values (Java 14)
- [ ] Pattern matching in switch (Java 21) - type, record, guarded patterns
- [ ] `null` case in switch (Java 21) - `case null ->` instead of NPE

### Miscellaneous
- [ ] `var` keyword (Java 10) - local variable type inference
  - [ ] Where allowed: local variables, `for` loops, `try-with-resources`
  - [ ] Where NOT allowed: fields, method params, return types
  - [ ] Best practice: use when type is obvious from RHS, avoid when it hurts readability
- [ ] Helpful `NullPointerException` (Java 14) - pinpoints which reference was null
- [ ] `instanceof` without cast (Java 16) - binding variable after check
- [ ] Implicitly declared classes (Java 21+ preview) - `void main()` without class declaration
- [ ] Statements before `super()` (Java 22) - validation before calling super constructor
- [ ] **Class-File API** (Java 24+) - standard API for reading/writing `.class` files
  - [ ] Replaces ASM/Byte Buddy for class transformation tools
  - [ ] `ClassFile.of().parse()`, `ClassFile.of().build()`
- [ ] **Compact Object Headers** (Project Lilliput, experimental) - reducing 12-byte header to 8 bytes
- [ ] **Markdown in Javadoc** (Java 23+) - `///` doc comments with Markdown syntax

---

## Version Quick Reference

| Version | Key Features |
|---------|-------------|
| Java 9 | Modules (JPMS), `List.of()`, `Optional.or/ifPresentOrElse/stream`, JShell |
| Java 10 | `var`, `List.copyOf()`, `Collectors.toUnmodifiable*` |
| Java 11 | `String` methods (strip, isBlank, lines, repeat), `HttpClient`, single-file `java` execution |
| Java 12 | `String.indent/transform`, `Collectors.teeing()` |
| Java 14 | Switch expressions, helpful NPE, `record` preview |
| Java 15 | Text blocks, `String.formatted()`, sealed classes preview |
| Java 16 | Records, `instanceof` pattern matching, `Stream.toList()`, `Stream.mapMulti()` |
| Java 17 | **LTS** - Sealed classes, pattern matching for switch preview |
| Java 21 | **LTS** - Virtual threads, sequenced collections, record patterns, pattern matching in switch |
| Java 22 | Unnamed variables `_`, statements before `super()`, FFM API finalized, stream gatherers preview |
| Java 23 | Markdown javadoc, primitive patterns preview |
| Java 24 | Stream Gatherers, structured concurrency, scoped values, Class-File API |
| Java 25 | **LTS (expected)** - stabilization of 22-24 features |

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Refactor `if-instanceof` chains and complex `switch` to pattern matching |
| Module 2 | Model a domain with records + sealed interfaces + exhaustive switch |
| Module 3 | Refactor string concatenation and multi-line SQL to text blocks |
| Module 4 | Rewrite collection code with `SequencedCollection`, replace `collect(toList())` with `toList()`, try stream gatherers |
| Module 5 | Migrate a thread-pool-based HTTP client to virtual threads + structured concurrency |
| Module 6 | Call a C library (e.g., `libcurl` or system `strlen`) from Java using Panama API |
| Module 7 | Refactor an old codebase (Java 8 style) to modern Java 21+ idioms |

## Key Resources
- **JEPs to read**: 394 (Pattern Matching instanceof), 409 (Sealed), 440 (Record Patterns), 444 (Virtual Threads), 453 (Structured Concurrency), 446 (Scoped Values), 454 (FFM API), 473 (Stream Gatherers), 461 (String Templates)
- **Inside Java** (inside.java) - Oracle's Java team blog
- **JEP Cafe** (YouTube) - Jose Paumard's JEP walkthroughs
- **Nicolai Parlog** (nipafx.dev) - modern Java deep dives
- **Dev.java** - official tutorials for modern Java
- **Java Almanac** (javaalmanac.io) - version-by-version API diff
