# Python Syntax & Data Types - Curriculum

## Module 1: Basics
- [ ] Variables and dynamic typing
- [ ] Primitive types: `int`, `float`, `str`, `bool`, `None`
- [ ] Type hints and annotations (`def greet(name: str) -> str`)
- [ ] String formatting: f-strings, `.format()`, `%`
- [ ] Multi-line strings and raw strings
- [ ] Operators: arithmetic, comparison, logical, walrus (`:=`)
- [ ] Control flow: `if/elif/else`, `for`, `while`, `match/case` (3.10+)

## Module 2: Collections
- [ ] Lists: mutable, ordered, `append`, `extend`, slicing
- [ ] Tuples: immutable, packing/unpacking
- [ ] Dictionaries: key-value, `get()`, `setdefault()`, `dict comprehension`
- [ ] Sets: unique elements, `union`, `intersection`, `difference`
- [ ] `frozenset` - immutable set
- [ ] Named tuples (`collections.namedtuple`)
- [ ] `defaultdict`, `Counter`, `OrderedDict` from `collections`

## Module 3: Comprehensions
- [ ] List comprehension: `[x*2 for x in range(10)]`
- [ ] Dict comprehension: `{k: v for k, v in items}`
- [ ] Set comprehension: `{x for x in range(10)}`
- [ ] Generator expression: `(x*2 for x in range(10))`
- [ ] Nested comprehensions
- [ ] Conditional comprehensions with `if` / `if-else`

## Module 4: String Operations
- [ ] String methods: `split`, `join`, `strip`, `replace`, `find`
- [ ] Regular expressions: `re` module, `match`, `search`, `findall`, `sub`
- [ ] String slicing and indexing
- [ ] `textwrap`, `string` module utilities

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Python Koans, basic scripting exercises |
| Module 3 | Rewrite all `for` loops as comprehensions where appropriate |
| Module 4 | Text processing: parse log files, CSV data |

## Key Resources
- Python official tutorial (docs.python.org)
- Automate the Boring Stuff with Python
- Fluent Python - Luciano Ramalho
