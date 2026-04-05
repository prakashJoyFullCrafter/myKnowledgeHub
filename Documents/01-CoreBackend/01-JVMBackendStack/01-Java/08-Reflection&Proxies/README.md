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

## Key Resources
- Java Reflection API documentation (Oracle)
- Effective Java - Joshua Bloch (Item 65: Prefer interfaces to reflection)
- Byte Buddy documentation
- Understanding Spring Framework internals
