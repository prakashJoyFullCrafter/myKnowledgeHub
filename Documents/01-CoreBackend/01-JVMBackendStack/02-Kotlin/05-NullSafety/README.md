# Kotlin Null Safety - Curriculum

## Module 1: Nullable Types
- [ ] Non-null types by default (`String` vs `String?`)
- [ ] Kotlin's approach: null safety at compile time
- [ ] Why `NullPointerException` is rare in Kotlin

## Module 2: Safe Operations
- [ ] Safe call operator `?.`
- [ ] Chaining safe calls (`user?.address?.city`)
- [ ] Elvis operator `?:` with defaults, throw, return
- [ ] Safe casts `as?` (returns null instead of throwing)

## Module 3: Not-Null Assertion & Smart Casts
- [ ] Not-null assertion `!!` - when and why to avoid
- [ ] Smart casts after null checks
- [ ] Smart casts with `when` and `is` checks
- [ ] Limitations of smart casts (mutable properties)

## Module 4: Platform Types (Java Interop)
- [ ] What are platform types (`Type!`)
- [ ] Danger zones: Java code returning null
- [ ] `@Nullable` and `@NotNull` annotations in Java
- [ ] Best practices when calling Java from Kotlin

## Module 5: Advanced Null Handling
- [ ] `let` for null-safe operations
- [ ] `requireNotNull()` and `checkNotNull()` - fail fast
- [ ] `filterNotNull()` and `mapNotNull()` on collections
- [ ] Nullable types in generics (`List<T?>` vs `List<T>?`)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Refactor Java null-check code to Kotlin |
| Module 3 | Eliminate all `!!` usage in a codebase |
| Module 4 | Write Kotlin wrappers for a Java library |
| Module 5 | Process a list of nullable objects without null checks |

## Key Resources
- Kotlin official docs - Null Safety
- Kotlin in Action - Chapter 6
