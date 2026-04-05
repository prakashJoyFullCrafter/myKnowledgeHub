# Python Functions & Decorators - Curriculum

## Module 1: Functions
- [ ] Function definition, parameters, return values
- [ ] Default arguments and keyword arguments
- [ ] `*args` and `**kwargs`
- [ ] First-class functions (functions as objects)
- [ ] Lambda functions
- [ ] Closures and nonlocal scope
- [ ] `map()`, `filter()`, `reduce()` (functional style)
- [ ] `sorted()` with `key` parameter

## Module 2: Decorators
- [ ] What is a decorator? Function wrapping another function
- [ ] `@decorator` syntax
- [ ] Decorators with arguments
- [ ] `functools.wraps` - preserving function metadata
- [ ] Class-based decorators
- [ ] Stacking multiple decorators
- [ ] Common decorators: `@staticmethod`, `@classmethod`, `@property`
- [ ] `@lru_cache` / `@cache` for memoization
- [ ] Real-world: logging, timing, authentication, retry decorators

## Module 3: Advanced Functions
- [ ] Type hints for functions (`typing` module)
- [ ] `Optional`, `Union`, `List`, `Dict`, `Tuple` type hints
- [ ] `Callable` type hint for function parameters
- [ ] `functools.partial` - partial function application
- [ ] `operator` module for functional programming
- [ ] Recursion and tail call optimization (Python doesn't have it)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build utility functions for data processing |
| Module 2 | Create `@timer`, `@retry`, `@validate` decorators |
| Module 3 | Add type hints to all previous code |

## Key Resources
- Fluent Python - Chapter 7 (Decorators and Closures)
- Python Cookbook - David Beazley
