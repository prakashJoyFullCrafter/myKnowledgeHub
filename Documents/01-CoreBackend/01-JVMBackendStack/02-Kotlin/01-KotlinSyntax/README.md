# Kotlin Syntax - Curriculum

## Module 1: Basics
- [ ] `val` vs `var` - immutable vs mutable
- [ ] Type inference
- [ ] Basic types: `Int`, `Long`, `Double`, `Float`, `Boolean`, `Char`, `String`
- [ ] String templates (`"Hello $name, age is ${user.age}"`)
- [ ] Multi-line strings (triple quotes)
- [ ] Type conversions (`toInt()`, `toLong()`, `toString()`)

## Module 2: Control Flow
- [ ] `if` as an expression (returns value)
- [ ] `when` expression (replacement for switch)
- [ ] `when` with ranges, types, conditions
- [ ] `for` loops with ranges (`1..10`, `1 until 10`, `10 downTo 1`, `step`)
- [ ] `while` and `do-while`
- [ ] `repeat(n) { }` utility

## Module 3: Functions
- [ ] Function declaration (`fun`)
- [ ] Default parameters and named arguments
- [ ] Single-expression functions (`fun double(x: Int) = x * 2`)
- [ ] Varargs (`vararg`)
- [ ] Infix functions (`infix fun`)
- [ ] Local functions (functions inside functions)
- [ ] `Unit` return type (Kotlin's void)
- [ ] `Nothing` type - functions that never return

## Module 4: Collections & Functional Operations
- [ ] `listOf`, `mutableListOf`, `setOf`, `mapOf`
- [ ] Immutable vs mutable collections
- [ ] `map`, `filter`, `flatMap`, `reduce`, `fold`
- [ ] `groupBy`, `associate`, `partition`
- [ ] `any`, `all`, `none`, `first`, `last`, `find`
- [ ] `sortedBy`, `distinctBy`, `zip`, `chunked`, `windowed`
- [ ] Sequences (`asSequence()`) - lazy evaluation

## Module 5: Lambdas & Higher-Order Functions
- [ ] Lambda syntax `{ x: Int -> x * 2 }`
- [ ] `it` - implicit single parameter
- [ ] Higher-order functions (functions as parameters)
- [ ] Trailing lambda syntax
- [ ] Function references (`::functionName`)
- [ ] `inline` functions and why they matter
- [ ] `crossinline` and `noinline`

## Module 6: Scope Functions
- [ ] `let` - null checks, transformations
- [ ] `run` - object configuration + compute result
- [ ] `with` - grouping calls on an object
- [ ] `apply` - object configuration, returns object
- [ ] `also` - side effects, returns object
- [ ] Decision guide: which scope function to use when

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Rewrite Java basics in Kotlin - notice the conciseness |
| Modules 3-4 | Process a list of employees using functional operations |
| Module 5 | Build a DSL-style builder using higher-order functions |
| Module 6 | Refactor verbose code using scope functions |

## Key Resources
- Kotlin official documentation (kotlinlang.org)
- Kotlin Koans (online exercises)
- Kotlin in Action - Dmitry Jemerov & Svetlana Isakova
