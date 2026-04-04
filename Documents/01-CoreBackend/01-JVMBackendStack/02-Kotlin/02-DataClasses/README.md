# Kotlin Data Classes - Curriculum

## Module 1: Data Class Basics
- [ ] `data class` declaration
- [ ] Auto-generated: `equals()`, `hashCode()`, `toString()`, `copy()`, `componentN()`
- [ ] Properties in constructor vs body (only constructor props in generated methods)
- [ ] Data class requirements (at least one val/var in constructor)
- [ ] `copy()` with named parameters for partial modification

## Module 2: Destructuring Declarations
- [ ] Destructuring data classes: `val (name, age) = user`
- [ ] Destructuring in `for` loops: `for ((key, value) in map)`
- [ ] Destructuring in lambdas: `list.map { (name, age) -> ... }`
- [ ] `_` to skip unused components

## Module 3: Sealed Classes & Interfaces
- [ ] `sealed class` - restricted class hierarchies
- [ ] `sealed interface` (Kotlin 1.5+)
- [ ] Sealed classes + `when` - exhaustive matching (no `else` needed)
- [ ] Sealed vs enum: when to use each
- [ ] Modeling state machines and result types with sealed classes

## Module 4: Object & Companion Object
- [ ] `object` declaration - singleton pattern
- [ ] `object` expression - anonymous objects
- [ ] `companion object` - static-like members
- [ ] `companion object` with factory methods
- [ ] `@JvmStatic` for Java interop

## Module 5: Enum Classes
- [ ] Enum declaration with properties and methods
- [ ] Enum with abstract methods
- [ ] `values()`, `valueOf()`, `entries` (Kotlin 1.9+)
- [ ] Enum implementing interfaces

## Module 6: Value Classes (Inline Classes)
- [ ] `@JvmInline value class` - zero-overhead wrappers
- [ ] Type safety without runtime overhead
- [ ] Use cases: `UserId`, `Email`, `Password` wrapping primitives
- [ ] Limitations and when to use

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Model a domain: `User`, `Address`, `Order` with data classes |
| Module 3 | Build a `Result<T>` sealed class: `Success`, `Error`, `Loading` |
| Modules 4-5 | Model payment types with enum + companion factory |
| Module 6 | Create type-safe IDs (`UserId`, `OrderId`) with value classes |

## Key Resources
- Kotlin official docs - Classes and Objects
- Kotlin in Action - Chapter 4
