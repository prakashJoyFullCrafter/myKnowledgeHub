# Python OOP - Curriculum

## Module 1: Classes & Objects
- [ ] Class definition, `__init__`, `self`
- [ ] Instance attributes vs class attributes
- [ ] Methods: instance, class (`@classmethod`), static (`@staticmethod`)
- [ ] `@property` for getters/setters
- [ ] `__str__` and `__repr__`

## Module 2: Inheritance & Polymorphism
- [ ] Single inheritance and `super()`
- [ ] Multiple inheritance and MRO (Method Resolution Order)
- [ ] Mixins
- [ ] Abstract classes: `abc.ABC`, `@abstractmethod`
- [ ] Duck typing ("if it walks like a duck...")
- [ ] Protocols (structural subtyping, Python 3.8+)

## Module 3: Magic Methods (Dunder Methods)
- [ ] `__eq__`, `__hash__`, `__lt__`, `__gt__` - comparison
- [ ] `__add__`, `__mul__`, `__len__` - operator overloading
- [ ] `__getitem__`, `__setitem__`, `__iter__` - container protocol
- [ ] `__enter__`, `__exit__` - context manager protocol
- [ ] `__call__` - callable objects

## Module 4: Modern Python OOP
- [ ] `dataclasses` (Python 3.7+): `@dataclass`, `field()`
- [ ] `__post_init__` for validation
- [ ] Frozen dataclasses (immutable)
- [ ] `attrs` library (third-party, more powerful)
- [ ] `Enum` class
- [ ] `NamedTuple` with type hints
- [ ] `pydantic` for data validation (used in FastAPI)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a shape hierarchy with abstract base class |
| Module 3 | Create a custom `Vector` class with operator overloading |
| Module 4 | Refactor to dataclasses, add pydantic validation |

## Key Resources
- Fluent Python - Part IV (Object-Oriented Idioms)
- Python official docs - Data Model
