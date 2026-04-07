# Java Core - Curriculum

## Module 1: Java Fundamentals
- [ ] JDK, JRE, JVM - What they are and how they relate
- [ ] How Java code compiles and runs (`.java` -> `.class` -> JVM)
- [ ] `main()` method and program entry point
- [ ] Primitive data types (`int`, `long`, `double`, `float`, `char`, `boolean`, `byte`, `short`)
- [ ] Reference types vs primitives
- [ ] Type casting (widening & narrowing)
- [ ] Wrapper classes (`Integer`, `Double`, `Boolean`, etc.) and autoboxing/unboxing
- [ ] Variables: local, instance, static
- [ ] Constants (`final` keyword)

## Module 2: Operators & Control Flow
- [ ] Arithmetic, relational, logical, bitwise operators
- [ ] Ternary operator
- [ ] `if-else`, `switch` (traditional & enhanced switch in Java 14+)
- [ ] `for`, `while`, `do-while` loops
- [ ] `break`, `continue`, labeled statements
- [ ] Pattern matching in `switch` (Java 17+)

## Module 3: Strings
- [ ] `String` immutability and the String pool
- [ ] `String` vs `StringBuilder` vs `StringBuffer`
- [ ] Common `String` methods (`substring`, `charAt`, `indexOf`, `split`, `replace`, etc.)
- [ ] String formatting (`String.format()`, `formatted()` in Java 15+)
- [ ] Text blocks (Java 13+)
- [ ] String comparison: `==` vs `.equals()`

## Module 4: Arrays
- [ ] Single & multi-dimensional arrays
- [ ] Array declaration, initialization, traversal
- [ ] `Arrays` utility class (`sort`, `binarySearch`, `copyOf`, `fill`)
- [ ] Common pitfalls: `ArrayIndexOutOfBoundsException`
- [ ] Varargs (`int... args`)

## Module 5: Methods & Memory Model
- [ ] Method declaration, parameters, return types
- [ ] Method overloading
- [ ] Pass-by-value (why Java is always pass-by-value)
- [ ] Stack vs Heap memory
- [ ] Garbage collection basics
- [ ] `static` methods and fields
- [ ] Recursion

## Module 6: Exception Handling
- [ ] Checked vs unchecked exceptions
- [ ] `try-catch-finally`
- [ ] `try-with-resources` (AutoCloseable)
- [ ] `throw` vs `throws`
- [ ] Custom exceptions
- [ ] Exception hierarchy (`Throwable` -> `Error` / `Exception` -> `RuntimeException`)
- [ ] Best practices: don't catch `Exception`, don't swallow exceptions

## Module 7: Enums & Annotations
- [ ] Enum basics, fields, methods, constructors
- [ ] Enum with abstract methods
- [ ] `EnumSet` and `EnumMap`
- [ ] Built-in annotations (`@Override`, `@Deprecated`, `@SuppressWarnings`, `@FunctionalInterface`)
- [ ] Custom annotations
- [ ] Retention policies (`SOURCE`, `CLASS`, `RUNTIME`)

## Module 8: Java I/O
- [ ] `File` class and file operations
- [ ] Byte streams (`InputStream`, `OutputStream`)
- [ ] Character streams (`Reader`, `Writer`)
- [ ] Buffered streams (`BufferedReader`, `BufferedWriter`)
- [ ] Serialization & deserialization (`Serializable`, `transient`)
- [ ] NIO.2: `Path`, `Files`, `Paths` (Java 7+)
- [ ] Reading/writing files with `Files.readString()`, `Files.writeString()` (Java 11+)

## Module 9: Functional Programming (Java 8+)
- [ ] Lambda expressions
- [ ] Functional interfaces (`Predicate`, `Function`, `Consumer`, `Supplier`, `BiFunction`)
- [ ] Method references (`::`)
- [ ] `Optional` class - avoiding `NullPointerException`
- [ ] Streams API: `filter`, `map`, `flatMap`, `reduce`, `collect`
- [ ] Stream operations: intermediate vs terminal
- [ ] Collectors: `toList`, `toMap`, `groupingBy`, `joining`, `partitioningBy`
- [ ] Parallel streams and when (not) to use them

## Module 10: Date & Time API (Java 8+)
- [ ] `LocalDate`, `LocalTime`, `LocalDateTime`
- [ ] `ZonedDateTime`, `Instant`, `Duration`, `Period`
- [ ] `DateTimeFormatter` - parsing and formatting
- [ ] Why `java.util.Date` and `Calendar` are legacy

## Module 11: Records, Sealed Classes & Modern Java
- [ ] Records (Java 16+) - immutable data carriers
- [ ] Sealed classes and interfaces (Java 17+)
- [ ] Pattern matching for `instanceof` (Java 16+)
- [ ] `var` keyword - local variable type inference (Java 10+)
- [ ] Helpful `NullPointerException` messages (Java 14+)
- [ ] Virtual threads preview (Java 21+)

## Module 12: Regular Expressions
- [ ] `Pattern` class - compiling regex patterns
- [ ] `Matcher` class - `find()`, `matches()`, `group()`, `start()`, `end()`
- [ ] Character classes: `[abc]`, `[a-z]`, `[^0-9]`, `\d`, `\w`, `\s`
- [ ] Quantifiers: `*`, `+`, `?`, `{n}`, `{n,m}`, greedy vs reluctant vs possessive
- [ ] Anchors: `^`, `$`, `\b` (word boundary)
- [ ] Groups and capturing: `(abc)`, backreferences `\1`
- [ ] Named groups: `(?<name>pattern)` and `matcher.group("name")`
- [ ] Non-capturing groups: `(?:abc)`
- [ ] Lookahead `(?=...)` and lookbehind `(?<=...)` (positive and negative)
- [ ] `String` regex methods: `matches()`, `split()`, `replaceAll()`, `replaceFirst()`
- [ ] `Pattern.compile()` flags: `CASE_INSENSITIVE`, `MULTILINE`, `DOTALL`, `COMMENTS`
- [ ] **Pre-compile patterns**: `private static final Pattern PATTERN = Pattern.compile(...)` - avoid recompiling
- [ ] **Catastrophic backtracking** (ReDoS) - how nested quantifiers cause exponential time
- [ ] Performance: `Pattern` + `Matcher` vs `String.matches()` (avoid in loops)

## Module 13: Process API
- [ ] `ProcessBuilder` - creating and configuring OS processes
- [ ] Setting command, arguments, working directory, environment variables
- [ ] Redirecting stdin, stdout, stderr: `redirectInput()`, `redirectOutput()`, `redirectErrorStream()`
- [ ] `Process.getInputStream()` / `getErrorStream()` - reading process output
- [ ] `process.waitFor()` and `process.waitFor(timeout, unit)`
- [ ] `process.destroyForcibly()` - killing processes
- [ ] **`ProcessHandle`** (Java 9+) - inspecting running processes
  - [ ] `ProcessHandle.current()` - current JVM process
  - [ ] `ProcessHandle.allProcesses()` - stream of all OS processes
  - [ ] `ProcessHandle.Info` - command, arguments, user, start time, CPU duration
  - [ ] `process.toHandle().onExit()` - `CompletableFuture` for process completion
- [ ] Piping processes: `ProcessBuilder.startPipeline()`
- [ ] Security: never pass user input directly to `ProcessBuilder` - command injection risk

## Module 14: Internationalization (i18n)
- [ ] `Locale` class - language, country, variant: `Locale.US`, `new Locale("en", "GB")`
- [ ] `Locale.getDefault()` and `Locale.setDefault()`
- [ ] `ResourceBundle` - locale-specific property files (`messages_en.properties`, `messages_fr.properties`)
- [ ] `ResourceBundle.getBundle("messages", locale)` - loading bundles
- [ ] `MessageFormat` - parameterized messages: `MessageFormat.format("Hello {0}", name)`
- [ ] `NumberFormat` - locale-aware number formatting: `NumberFormat.getCurrencyInstance(locale)`
- [ ] `DecimalFormat` - custom number patterns
- [ ] `DateTimeFormatter` with locales: `DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL).withLocale(locale)`
- [ ] `Collator` - locale-sensitive string comparison and sorting
- [ ] Unicode in Java: UTF-16 encoding, surrogate pairs, `Character.isLetter()` vs ASCII checks
- [ ] Best practice: externalize all user-facing strings for localization

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-4 | HackerRank Java basics |
| Modules 5-6 | Build a CLI calculator with error handling |
| Modules 7-8 | Build a file-based todo app |
| Modules 9-10 | Process a CSV dataset using Streams |
| Module 11 | Refactor previous projects using modern Java features |

## Key Resources
- Oracle Java Tutorials
- Effective Java - Joshua Bloch
- Java Language Specification (JLS)
