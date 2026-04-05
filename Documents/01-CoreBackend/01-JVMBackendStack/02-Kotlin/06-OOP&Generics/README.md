# Kotlin OOP & Generics - Curriculum

## Module 1: Interfaces & Abstract Classes
- [ ] Interface with default methods (no state limitation like Java 8)
- [ ] Interfaces with properties (abstract and with backing field)
- [ ] Abstract classes vs interfaces in Kotlin
- [ ] Multiple interface implementation and conflict resolution (`super<InterfaceName>`)
- [ ] SAM (Single Abstract Method) conversions - `fun interface`
- [ ] Functional interfaces in Kotlin vs Java

## Module 2: Delegation
- [ ] Class delegation with `by` keyword: `class MyList(list: List<T>) : List<T> by list`
- [ ] Delegated properties: `by lazy`, `by observable`, `by vetoable`
- [ ] `by map` - storing properties in a map
- [ ] Custom property delegates: `ReadOnlyProperty`, `ReadWriteProperty`
- [ ] `provideDelegate` operator
- [ ] Delegation vs inheritance - why Kotlin favors delegation
- [ ] Real-world: delegation in Spring configuration, caching

## Module 3: Generics Basics
- [ ] Generic classes and functions (same syntax as Java)
- [ ] Type constraints: `<T : Comparable<T>>`
- [ ] Multiple constraints: `where T : Comparable<T>, T : Serializable`
- [ ] Star projection `<*>` (Kotlin's equivalent of `<?>`)
- [ ] Nullable type parameters: `<T>` vs `<T : Any>`

## Module 4: Variance (in/out)
- [ ] **Declaration-site variance** (Kotlin's biggest generics difference from Java)
- [ ] `out` = covariance (producer): `interface Source<out T>` (like `? extends T`)
- [ ] `in` = contravariance (consumer): `interface Comparable<in T>` (like `? super T`)
- [ ] Why `List<out E>` is immutable and `MutableList<E>` is invariant
- [ ] Use-site variance (same as Java wildcards, but rarely needed)
- [ ] `out` in return position, `in` in parameter position - the rule
- [ ] Type projections: `Array<out Any>`, `Array<in String>`

## Module 5: Reified Type Parameters
- [ ] Type erasure in Kotlin (same as Java)
- [ ] `inline` + `reified` - keeping type info at runtime
- [ ] `inline fun <reified T> parse(json: String): T`
- [ ] `is T` checks and `T::class` with reified
- [ ] Use cases: JSON deserialization, service locator, factory methods
- [ ] Why `reified` only works with `inline` functions
- [ ] Reified in Spring: `inline fun <reified T> RestTemplate.getForObject(url: String): T`

## Module 6: Advanced OOP
- [ ] Type aliases: `typealias UserMap = Map<String, User>`
- [ ] Operator overloading: `operator fun plus()`, `operator fun get()`, `operator fun invoke()`
- [ ] Infix functions in OOP: `infix fun Int.shl(x: Int): Int`
- [ ] Destructuring in custom classes: `operator fun componentN()`
- [ ] Generic type reification patterns
- [ ] Kotlin contracts (`@ExperimentalContracts`) - smart cast hints to compiler

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a plugin system using interfaces with defaults |
| Module 2 | Build a caching property delegate and a `by database` delegate |
| Modules 3-4 | Build a type-safe event bus: `EventBus<out Event>` with variance |
| Module 5 | Build a generic JSON parser using reified types |
| Module 6 | Build a DSL with operator overloading for building queries |

## Key Resources
- Kotlin in Action - Chapter 9 (Generics)
- Kotlin official docs - Generics: in, out, where
- Effective Kotlin - Marcin Moskala
