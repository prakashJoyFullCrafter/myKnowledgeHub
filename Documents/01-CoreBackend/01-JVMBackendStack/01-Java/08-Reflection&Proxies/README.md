# Java Reflection & Proxies - Curriculum

## Module 1: Reflection Basics
- [ ] What is reflection? Runtime inspection and modification
- [ ] `Class<T>` object: `getClass()`, `Class.forName()`, `.class`
- [ ] Inspecting class metadata: name, modifiers, superclass, interfaces
- [ ] `getFields()` vs `getDeclaredFields()` (public vs all including private)
- [ ] `getMethods()` vs `getDeclaredMethods()`
- [ ] `getConstructors()` vs `getDeclaredConstructors()`

## Module 2: Field & Method Access
- [ ] `Field.get()` and `Field.set()` - reading/writing field values
- [ ] `Method.invoke()` - calling methods dynamically
- [ ] `Constructor.newInstance()` - creating objects without `new`
- [ ] `setAccessible(true)` - bypassing access control (private fields/methods)
- [ ] Performance cost of reflection vs direct access
- [ ] Security implications and `SecurityManager`

## Module 3: Annotations at Runtime
- [ ] Reading annotations: `getAnnotation()`, `getAnnotations()`, `isAnnotationPresent()`
- [ ] `@Retention(RUNTIME)` - annotations available via reflection
- [ ] Custom annotation + reflection processor
- [ ] Building a simple validation framework with annotations
- [ ] Building a simple DI container with annotations (`@Inject`)
- [ ] How Spring uses reflection for `@Autowired`, `@Value`, `@Component`

## Module 4: Dynamic Proxies
- [ ] `java.lang.reflect.Proxy` - JDK dynamic proxy
- [ ] `InvocationHandler` interface
- [ ] Creating proxy instances: `Proxy.newProxyInstance()`
- [ ] Limitations: only works with interfaces (not classes)
- [ ] Use cases: logging proxy, caching proxy, transaction proxy
- [ ] How Spring AOP uses JDK dynamic proxies

## Module 5: CGLIB & Byte Buddy
- [ ] CGLIB: class-based proxies (subclassing)
- [ ] `Enhancer` and `MethodInterceptor`
- [ ] How Spring creates proxies for classes (not just interfaces)
- [ ] Byte Buddy: modern bytecode generation library
- [ ] Byte Buddy vs CGLIB vs Javassist comparison
- [ ] Runtime class generation and modification

## Module 6: Annotation Processing (Compile-Time)
- [ ] `javax.annotation.processing.AbstractProcessor`
- [ ] `@SupportedAnnotationTypes` and `@SupportedSourceVersion`
- [ ] Processing rounds and `RoundEnvironment`
- [ ] Generating source code at compile time
- [ ] Use cases: Lombok, MapStruct, Dagger, Micronaut
- [ ] Compile-time vs runtime: why annotation processors are faster

## Module 7: MethodHandles & VarHandles (Modern Alternatives)
- [ ] `MethodHandle` (Java 7+) - faster than reflection
- [ ] `MethodHandles.Lookup` - access control
- [ ] `MethodHandle.invoke()` and `invokeExact()`
- [ ] `VarHandle` (Java 9+) - safe alternative to `Unsafe` for atomics
- [ ] Performance: MethodHandle vs Reflection benchmarks
- [ ] `invokedynamic` instruction and lambda implementation

## Module 8: Java Agents & Instrumentation
- [ ] What is a Java agent? Code that runs before/alongside your application
- [ ] **`premain()` agent** - load-time instrumentation
  - [ ] `public static void premain(String args, Instrumentation inst)`
  - [ ] Activated via `-javaagent:myagent.jar` on JVM startup
  - [ ] Agent JAR: `MANIFEST.MF` with `Premain-Class` attribute
- [ ] **`agentmain()` agent** - runtime attach (hot-patching)
  - [ ] `public static void agentmain(String args, Instrumentation inst)`
  - [ ] `MANIFEST.MF` with `Agent-Class` attribute
  - [ ] Attach API: `VirtualMachine.attach(pid)` → `vm.loadAgent("agent.jar")`
  - [ ] Use case: attach profiler or diagnostic tool to running production JVM
- [ ] **`Instrumentation` API**:
  - [ ] `addTransformer(ClassFileTransformer, canRetransform)` - register bytecode transformer
  - [ ] `retransformClasses(Class<?>...)` - re-trigger transformation on already loaded classes
  - [ ] `redefineClasses(ClassDefinition...)` - replace class bytecode entirely
  - [ ] `getAllLoadedClasses()` - inspect what's loaded in the JVM
  - [ ] `getObjectSize(Object)` - approximate memory size of an object
- [ ] **`ClassFileTransformer`** interface:
  - [ ] `transform(ClassLoader, className, classBeingRedefined, protectionDomain, classfileBuffer)` → modified `byte[]`
  - [ ] Intercept class loading, modify bytecode before class is defined
  - [ ] Filtering: only transform target classes, pass through others unchanged
- [ ] **Bytecode manipulation in agents**:
  - [ ] ASM - low-level visitor API for reading/writing bytecode
  - [ ] Byte Buddy Agent - `AgentBuilder` DSL for clean agent development
  - [ ] Byte Buddy `@Advice` - inject code at method entry/exit without rewriting entire method
- [ ] **`MANIFEST.MF` attributes**:
  - [ ] `Premain-Class` - agent entry point for `-javaagent`
  - [ ] `Agent-Class` - agent entry point for runtime attach
  - [ ] `Can-Retransform-Classes: true` - allow retransformation
  - [ ] `Can-Redefine-Classes: true` - allow redefinition
  - [ ] `Boot-Class-Path` - additional JARs on bootstrap classloader
- [ ] **Real-world agent use cases**:
  - [ ] APM tools: Datadog, New Relic, Elastic APM - auto-instrument HTTP, JDBC, messaging
  - [ ] Code coverage: JaCoCo - injects counters into bytecode at load time
  - [ ] Mocking: Mockito inline - redefines final classes for mocking
  - [ ] Profiling: Async Profiler attaches via Attach API
  - [ ] Hot reload: JRebel, Spring DevTools - redefine classes on change
  - [ ] Security: runtime security policies and sandboxing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a generic `ObjectMapper` that converts Map to Object using reflection |
| Module 3 | Build `@NotNull`, `@Size` validation framework using custom annotations |
| Module 4 | Build a logging proxy that wraps any interface |
| Module 5 | Compare JDK proxy vs CGLIB proxy performance |
| Module 6 | Create a `@Builder` annotation processor that generates builder code |
| Module 7 | Benchmark MethodHandle vs reflection for method invocation |
| Module 8 | Build a Java agent that logs method entry/exit times using Byte Buddy `@Advice` |

## Key Resources
- Java Reflection API documentation (Oracle)
- Effective Java - Joshua Bloch (Item 65: Prefer interfaces to reflection)
- Byte Buddy documentation
- Understanding Spring Framework internals
- `java.lang.instrument` package documentation (Oracle)
- Byte Buddy Agent tutorial (bytebuddy.net)
- Rafael Winterhalter - "The definitive guide to Java agents" (talks & blog)
