# Java Generics - Curriculum

## Module 1: Generics Basics
- [ ] Why generics? (type safety, eliminate casting)
- [ ] Generic classes (`Box<T>`, `Pair<K, V>`)
- [ ] Generic methods (`<T> T doSomething(T input)`)
- [ ] Type parameter naming conventions (`T`, `E`, `K`, `V`, `N`, `S`)
- [ ] Generic constructors
- [ ] Diamond operator `<>` (Java 7+)

## Module 2: Bounded Type Parameters
- [ ] Upper bounded: `<T extends Number>`
- [ ] Multiple bounds: `<T extends Comparable<T> & Serializable>`
- [ ] Why `extends` is used for both classes and interfaces in bounds
- [ ] Recursive type bounds: `<T extends Comparable<T>>`

## Module 3: Wildcards
- [ ] Unbounded wildcard: `<?>`
- [ ] Upper bounded wildcard: `<? extends Number>` (covariance)
- [ ] Lower bounded wildcard: `<? super Integer>` (contravariance)
- [ ] **PECS principle**: Producer Extends, Consumer Super
- [ ] When to use `T` vs `?`
- [ ] Wildcard capture and helper methods

## Module 4: Type Erasure
- [ ] What is type erasure and why Java uses it
- [ ] How generics compile to bytecode
- [ ] Bridge methods
- [ ] Limitations caused by erasure:
  - [ ] Cannot use `new T()`
  - [ ] Cannot use `instanceof` with generic types
  - [ ] Cannot create generic arrays (`new T[]`)
  - [ ] Cannot use primitives as type arguments
- [ ] Workarounds: `Class<T>` token, `Array.newInstance()`

![img.png](img.png)## Module 5: Generic Interfaces & Inheritance
- [ ] Implementing a generic interface (`Comparable<T>`, `Iterable<T>`)
- [ ] Generic class extending another generic class
- [ ] Raw types and why to avoid them
- [ ] Generic type relationships: `List<Integer>` is NOT a subtype of `List<Number>`
- [ ] Covariance with arrays vs invariance with generics

## Module 6: Advanced Generics
- [ ] Self-referential generics (Curiously Recurring Template Pattern)
- [ ] Type tokens and super type tokens
- [ ] Generic singletons (e.g., `Collections.emptyList()`)
- [ ] Intersection types in bounds
- [ ] Generics with reflection (`TypeReference`, `ParameterizedType`)
- [ ] Generics in functional interfaces (`Function<T, R>`, `Comparator<T>`)

## Module 7: Real-World Usage
- [ ] Generics in Collections framework (`List<E>`, `Map<K,V>`)
- [ ] Writing a generic DAO/Repository layer
- [ ] Generic utility methods (`Collections.sort()`, `Optional<T>`)
- [ ] Generics in Spring: `ResponseEntity<T>`, `JpaRepository<T, ID>`
- [ ] Common mistakes and anti-patterns

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a generic `Stack<T>` and `Pair<K,V>` class |
| Modules 2-3 | Write a generic `max()` method with bounded types, use PECS in a utility method |
| Module 4 | Experiment with type erasure - observe compiled bytecode with `javap -c` |
| Modules 5-6 | Build a generic `Result<T, E>` type (like Rust's Result) |
| Module 7 | Build a generic `Repository<T, ID>` interface with CRUD operations |

## Key Resources
- Effective Java - Joshua Bloch (Chapter 5: Generics)
- Java Generics and Collections - Maurice Naftalin & Philip Wadler
- Angelika Langer's Java Generics FAQ
