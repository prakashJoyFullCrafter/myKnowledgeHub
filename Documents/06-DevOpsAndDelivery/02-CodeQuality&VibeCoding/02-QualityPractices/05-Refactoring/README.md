# Refactoring - Expert Curriculum

## Module 1: Refactoring Fundamentals
- [ ] Definition: changing code structure without changing behavior
- [ ] **Golden rule**: never refactor without tests (safety net)
- [ ] Refactoring vs rewriting: incremental improvement vs start over
- [ ] When to refactor: before adding features, after fixing bugs, during review
- [ ] Boy Scout Rule: always leave the code cleaner than you found it
- [ ] Refactoring budget: 15-20% of dev time is healthy

## Module 2: Refactoring Catalog - Method Level
- [ ] **Extract Method**: long method → smaller, named methods
- [ ] **Inline Method**: over-extracted one-liner → inline it back
- [ ] **Rename Method/Variable**: unclear name → intention-revealing name
- [ ] **Replace Temp with Query**: `double total = getTotal();` → call `getTotal()` directly
- [ ] **Introduce Explaining Variable**: complex expression → named variable
- [ ] **Split Temporary Variable**: one variable reused for different purposes → separate variables
- [ ] **Remove Assignments to Parameters**: don't modify input parameters

## Module 3: Refactoring Catalog - Class Level
- [ ] **Extract Class**: class with two responsibilities → two classes
- [ ] **Inline Class**: class that does almost nothing → merge into caller
- [ ] **Move Method/Field**: method belongs to another class → move it
- [ ] **Encapsulate Field**: public field → private + getter/setter
- [ ] **Replace Data Value with Object**: `String email` → `Email` value object
- [ ] **Extract Interface**: expose only what clients need
- [ ] **Pull Up / Push Down Method/Field**: move between parent and child class

## Module 4: Refactoring Catalog - Conditional Logic
- [ ] **Replace Conditional with Polymorphism**: `if/switch` on type → subclass + override
- [ ] **Replace Nested Conditional with Guard Clauses**: deep nesting → early returns
- [ ] **Decompose Conditional**: complex `if` condition → extracted method with clear name
- [ ] **Consolidate Conditional Expression**: multiple conditions with same result → combine
- [ ] **Replace Magic Number with Named Constant**: `86400` → `SECONDS_PER_DAY`
- [ ] **Introduce Null Object**: null checks → default behavior object
- [ ] **Replace Error Code with Exception**: `return -1` → `throw new NotFoundException()`

## Module 5: Refactoring Catalog - Architecture
- [ ] **Replace Inheritance with Delegation**: "is-a" that should be "has-a"
- [ ] **Replace Delegation with Inheritance**: when delegation is just forwarding
- [ ] **Introduce Parameter Object**: method with 5+ params → `SearchCriteria` object
- [ ] **Preserve Whole Object**: passing 3 fields from object → pass the object
- [ ] **Separate Query from Modifier**: method that reads AND writes → split into two
- [ ] **Hide Delegate**: `person.getDepartment().getManager()` → `person.getManager()`
- [ ] **Extract Superclass / Extract Subclass**: shared behavior → common parent

## Module 6: Refactoring Legacy Code
- [ ] Michael Feathers' approach: Working Effectively with Legacy Code
- [ ] **Characterization tests**: test current behavior (even if wrong) before changing
- [ ] **Seam**: a place where you can alter behavior without editing the code
- [ ] **Sprout Method**: add new functionality in a new, tested method
- [ ] **Wrap Method**: wrap old method with new behavior
- [ ] **Strangler Fig for code**: gradually replace old with new
- [ ] Breaking dependencies: extract interface, inject dependency
- [ ] IDE refactoring tools: IntelliJ automated refactoring (safe, one click)

## Module 7: Refactoring & IDE Tooling
- [ ] IntelliJ IDEA refactoring shortcuts:
  - [ ] `Ctrl+Alt+M` (Extract Method)
  - [ ] `Ctrl+Alt+V` (Extract Variable)
  - [ ] `Ctrl+Alt+F` (Extract Field)
  - [ ] `Ctrl+Alt+P` (Extract Parameter)
  - [ ] `Shift+F6` (Rename)
  - [ ] `F6` (Move)
  - [ ] `Ctrl+Alt+N` (Inline)
- [ ] Structural search and replace (IntelliJ)
- [ ] Automated refactoring safety: IDE preserves behavior
- [ ] OpenRewrite: automated large-scale refactoring (Java migrations)
- [ ] ArchUnit: enforce architecture rules as tests

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Take a 50+ line method, extract till each method is < 10 lines |
| Module 3 | Find a God Class, extract 2-3 focused classes from it |
| Module 4 | Find a switch/if chain, refactor to polymorphism |
| Module 5 | Find a method with 5+ params, introduce parameter object |
| Module 6 | Take untested legacy code, add characterization tests, then refactor |
| Module 7 | Learn all IntelliJ refactoring shortcuts, practice daily |

## Key Resources
- **Refactoring** (2nd Edition) - Martin Fowler (THE refactoring book)
- **Working Effectively with Legacy Code** - Michael Feathers
- **Refactoring to Patterns** - Joshua Kerievsky
- refactoring.guru (visual catalog of refactoring techniques)
- IntelliJ IDEA Refactoring documentation
