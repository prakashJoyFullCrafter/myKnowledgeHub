# Kotlin Extension Functions - Curriculum

## Module 1: Extension Function Basics
- [ ] Syntax: `fun String.addExclamation() = "$this!"`
- [ ] How extensions are resolved (statically, not virtually)
- [ ] Extension functions vs member functions (member always wins)
- [ ] Extension functions on nullable types
- [ ] Scope of extensions (import required)

## Module 2: Extension Properties
- [ ] Syntax: `val String.lastChar: Char get() = this[length - 1]`
- [ ] No backing field - only computed properties
- [ ] When to use extension properties vs functions

## Module 3: Extensions on Collections
- [ ] Kotlin stdlib extensions: `first()`, `last()`, `single()`
- [ ] `takeIf`, `takeUnless`
- [ ] `ifEmpty`, `ifBlank`, `orEmpty()`
- [ ] Writing custom collection extensions

## Module 4: Extensions in Practice
- [ ] Organizing extensions: dedicated files vs alongside classes
- [ ] Extension functions on generic types
- [ ] Extensions with `companion object`
- [ ] Extensions for Spring/Android frameworks

## Module 5: DSL Building with Extensions
- [ ] Lambda with receiver (`fun StringBuilder.() -> Unit`)
- [ ] Type-safe builders
- [ ] `buildString`, `buildList`, `buildMap`
- [ ] Creating HTML/SQL-like DSLs
- [ ] `@DslMarker` to prevent scope leaking

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Write extensions for `String`, `Int`, `LocalDate` |
| Module 3 | Create a collection utility extensions file |
| Module 4 | Write domain-specific extensions for your project |
| Module 5 | Build a simple HTML DSL using lambdas with receivers |

## Key Resources
- Kotlin in Action - Chapter 3
- Kotlin official docs - Extensions
