# Python Labs - Project Curriculum

Isolated exercises to master Python language fundamentals.

---

## Lab 01: Basics & Collections
- [ ] Build a CLI calculator with `+`, `-`, `*`, `/`, `%`, `**`
- [ ] Word frequency counter from user input
- [ ] Student grade tracker using dictionaries
- [ ] Contact book (CRUD) with nested dictionaries
- [ ] Matrix operations (add, multiply, transpose) using lists

## Lab 02: Functions & Decorators
- [ ] Build a `@timer` decorator that logs execution time
- [ ] Build a `@retry(max_retries=3)` decorator with configurable retries
- [ ] Build a `@cache` decorator (memoization from scratch)
- [ ] Build a `@validate_types` decorator using type hints
- [ ] Higher-order functions: implement custom `map`, `filter`, `reduce`

## Lab 03: OOP Projects
- [ ] **Bank Account System**: `Account`, `SavingsAccount`, `CurrentAccount` with inheritance
- [ ] **Library Management**: `Book`, `Member`, `Library` with CRUD and search
- [ ] **Shapes**: abstract `Shape` base class, `Circle`, `Rectangle`, `Triangle` with polymorphic area/perimeter
- [ ] **Deck of Cards**: `Card`, `Deck` with shuffle, deal, sort using magic methods
- [ ] Refactor all above using `dataclasses` and `pydantic`

## Lab 04: File I/O & Data Processing
- [ ] Log file parser: read log files, extract errors, generate summary report
- [ ] CSV to JSON converter (and vice versa)
- [ ] Config file manager: read/write YAML and `.env` files
- [ ] File organizer: sort files in a directory by extension
- [ ] Markdown to HTML converter (basic)

## Lab 05: Generators & Advanced
- [ ] Lazy CSV reader: process million-row CSV without loading into memory
- [ ] Fibonacci generator (infinite sequence)
- [ ] Pipeline processor: chain generators for ETL (extract, transform, load)
- [ ] Custom `range()` implementation using `__iter__` and `__next__`
- [ ] Context manager for database connection simulation (`with db_connect() as conn:`)
- [ ] Async web scraper using `asyncio` and `aiohttp`

## Lab 06: Mini Projects
- [ ] **Password Manager**: encrypt/decrypt with `cryptography` library
- [ ] **Web Scraper**: scrape product data from a website using `BeautifulSoup`
- [ ] **REST API Client**: consume a public API, parse JSON, display results
- [ ] **CLI Task Manager**: `argparse` based todo app with file persistence
- [ ] **Unit Test Suite**: write tests for all above labs using `pytest`

---

## Tech Stack
- Python 3.10+
- `pytest` for testing
- `pydantic` for validation
- `aiohttp` for async
- `beautifulsoup4` for scraping
- `cryptography` for encryption

## Project Structure
```
01-python-labs/
├── lab01_basics/
├── lab02_functions/
├── lab03_oop/
├── lab04_fileio/
├── lab05_generators/
├── lab06_mini_projects/
├── tests/
├── requirements.txt
└── README.md
```
