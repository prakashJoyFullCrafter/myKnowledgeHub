# Kotlin-Java Interop - Curriculum

## Module 1: Calling Java from Kotlin
- [ ] Java types in Kotlin: platform types (`Type!`)
- [ ] Nullability annotations: `@Nullable`, `@NotNull` (JSR-305, JetBrains, Android)
- [ ] SAM conversions: passing Kotlin lambdas to Java functional interfaces
- [ ] Java getters/setters as Kotlin properties
- [ ] Java `void` → Kotlin `Unit`
- [ ] Java checked exceptions in Kotlin (no checked exceptions in Kotlin)
- [ ] Using Java collections in Kotlin (mutable by default from Java)
- [ ] Java static members access: `JavaClass.staticMethod()`

## Module 2: Calling Kotlin from Java
- [ ] `@JvmStatic` - expose companion object functions as Java static methods
- [ ] `@JvmField` - expose property as Java field (no getter/setter)
- [ ] `@JvmOverloads` - generate Java overloads for default parameters
- [ ] `@JvmName` - rename for Java callers (resolve name clashes)
- [ ] `@Throws` - declare checked exceptions for Java callers
- [ ] `@JvmWildcard` and `@JvmSuppressWildcards` - control wildcard generation
- [ ] Kotlin `object` from Java: `MyObject.INSTANCE.method()`
- [ ] Kotlin file-level functions from Java: `MyFileKt.function()`
- [ ] `@file:JvmName("Utils")` - rename generated class

## Module 3: Mixed Codebases
- [ ] Gradle/Maven setup for mixed Java + Kotlin source sets
- [ ] Compilation order: Kotlin compiler sees Java, Java compiler sees Kotlin stubs
- [ ] `kapt` (Kotlin Annotation Processing Tool) for Java annotation processors
- [ ] KSP (Kotlin Symbol Processing) - faster alternative to kapt
- [ ] Lombok + Kotlin: compatibility issues and workarounds
- [ ] Converting Java to Kotlin: IntelliJ auto-converter + manual cleanup

## Module 4: Spring Boot Interop Specifics
- [ ] Spring annotations on Kotlin classes: `@Component`, `@Service`, `@RestController`
- [ ] `open` classes and `all-open` compiler plugin (Spring requires open classes for proxying)
- [ ] `no-arg` compiler plugin (JPA entities need no-arg constructor)
- [ ] `kotlin-spring` plugin = `all-open` for Spring annotations
- [ ] `kotlin-jpa` plugin = `no-arg` for JPA annotations
- [ ] Jackson Kotlin module for JSON serialization of data classes
- [ ] `@ConfigurationProperties` with Kotlin data classes

## Module 5: Coroutines & Java Interop
- [ ] Calling suspend functions from Java (`Continuation` parameter)
- [ ] `runBlocking` bridge for Java callers
- [ ] Converting `CompletableFuture` ↔ coroutines: `future.await()`, `coroutineScope.future { }`
- [ ] Reactive types ↔ coroutines: `Mono.awaitSingle()`, `Flow.asFlux()`
- [ ] Java `ExecutorService` as coroutine dispatcher: `executor.asCoroutineDispatcher()`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Consume a Java library (e.g., Apache Commons) from Kotlin safely |
| Module 2 | Write a Kotlin utility library that's pleasant to use from Java |
| Module 3 | Set up a mixed Java + Kotlin Spring Boot project |
| Module 4 | Configure all-open, no-arg, Jackson Kotlin module in a Spring project |
| Module 5 | Bridge between CompletableFuture Java code and Kotlin coroutines |

## Key Resources
- Kotlin official docs - Java Interop
- Kotlin official docs - Calling Kotlin from Java
- Spring Boot Kotlin support documentation
