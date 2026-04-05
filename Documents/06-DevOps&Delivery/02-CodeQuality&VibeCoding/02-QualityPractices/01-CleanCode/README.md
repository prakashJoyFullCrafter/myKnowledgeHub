# Clean Code - Expert Curriculum

## Module 1: Meaningful Names
- [ ] Intention-revealing names: `daysSinceCreation` not `d`
- [ ] Avoid disinformation: don't use `accountList` if it's not a `List`
- [ ] Make meaningful distinctions: `source` vs `destination` not `a1` vs `a2`
- [ ] Pronounceable names: `generationTimestamp` not `genymdhms`
- [ ] Searchable names: no single-letter variables except loop counters
- [ ] Class names = nouns: `UserService`, `OrderProcessor`
- [ ] Method names = verbs: `calculateTotal()`, `findById()`
- [ ] Don't encode types: `phoneString` → `phone`, `IUserService` → `UserService`
- [ ] One word per concept: don't mix `fetch`, `retrieve`, `get` for same meaning

## Module 2: Functions
- [ ] Small: 5-20 lines max, one screen
- [ ] Do one thing: if you can extract another function, the original does too much
- [ ] One level of abstraction per function
- [ ] Reading code top-down: each function leads to the next
- [ ] Arguments: 0 (niladic) is best, 1 (monadic), 2 (dyadic), 3+ (polyadic) use parameter object
- [ ] No flag arguments (`boolean isAdmin`) → two separate methods
- [ ] No side effects: `checkPassword()` shouldn't also initialize session
- [ ] Command-Query Separation: commands change state, queries return data — never both
- [ ] DRY: extract duplication, but wrong abstraction is worse than duplication
- [ ] Extract till you drop: when in doubt, extract smaller functions

## Module 3: Comments
- [ ] Good comments: legal (copyright), informative (regex explanation), warning, TODO
- [ ] `// TODO` with ticket reference: `// TODO(JIRA-123): refactor after migration`
- [ ] Javadoc for public APIs
- [ ] **Bad comments**: redundant, misleading, mandated, journal, noise
- [ ] Don't comment out code: version control remembers it
- [ ] Don't use comments to explain bad code — rewrite the code
- [ ] Code should be self-documenting: `isEligibleForDiscount()` needs no comment

## Module 4: Formatting & Readability
- [ ] Vertical openness: blank lines between concepts
- [ ] Vertical density: related code stays together
- [ ] Variable declaration close to usage
- [ ] Dependent functions: caller above callee
- [ ] Horizontal: avoid long lines (120 chars max)
- [ ] Consistent indentation and braces
- [ ] Team conventions: agree once, automate with formatter (Checkstyle, Spotless)
- [ ] IDE formatting on save

## Module 5: Error Handling
- [ ] Use exceptions, not error codes
- [ ] Write `try-catch` first (TDD approach to error handling)
- [ ] Use unchecked exceptions (runtime) for most cases
- [ ] Provide context in exception messages
- [ ] Don't return `null`: return `Optional`, empty collection, or throw
- [ ] Don't pass `null`: validate early with `Objects.requireNonNull()`
- [ ] Define exception classes by the caller's needs (not the thrower's)
- [ ] Special case pattern: return default object instead of null check

## Module 6: Code Smells & Detection
- [ ] **Bloaters**: Long Method, Large Class, Long Parameter List, Primitive Obsession
- [ ] **Object-Orientation Abusers**: Switch Statements, Refused Bequest, Parallel Inheritance
- [ ] **Change Preventers**: Divergent Change, Shotgun Surgery
- [ ] **Dispensables**: Dead Code, Speculative Generality, Lazy Class, Duplicate Code
- [ ] **Couplers**: Feature Envy, Inappropriate Intimacy, Message Chains
- [ ] Tools: SonarQube, PMD, SpotBugs, Error Prone
- [ ] Setting up SonarQube quality gates in CI

## Module 7: Clean Architecture Concepts
- [ ] Dependency rule: dependencies point inward (domain has no dependencies)
- [ ] Layers: Entities → Use Cases → Interface Adapters → Frameworks
- [ ] Hexagonal architecture (Ports & Adapters)
- [ ] Package structure: by feature vs by layer
- [ ] Keeping frameworks at the edges
- [ ] Clean Code in Spring Boot: domain layer independent of Spring

## Module 8: Metrics & Continuous Quality
- [ ] Cyclomatic complexity: keep methods < 10
- [ ] Cognitive complexity (SonarQube): how hard code is to understand
- [ ] Technical debt measurement
- [ ] SonarQube quality profiles and quality gates
- [ ] Code coverage as one metric (not the only one)
- [ ] Code review as quality gate
- [ ] Boy Scout Rule: leave code cleaner than you found it

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Take a 100-line method, refactor to clean functions with clear names |
| Modules 3-4 | Remove all unnecessary comments, fix formatting in a file |
| Module 5 | Refactor null-returning methods to Optional/exceptions |
| Module 6 | Run SonarQube on a project, fix top 10 code smells |
| Modules 7-8 | Restructure a Spring Boot project to hexagonal architecture |

## Key Resources
- **Clean Code** - Robert C. Martin (THE book)
- **Clean Architecture** - Robert C. Martin
- **Refactoring** - Martin Fowler
- SonarQube documentation
- Google Java Style Guide
