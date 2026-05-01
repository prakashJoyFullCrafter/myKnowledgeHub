# Test-Driven Development (TDD) - Expert Curriculum

## Module 1: TDD Fundamentals
- [ ] Red-Green-Refactor cycle: the core of TDD
  1. **RED**: Write a failing test first
  2. **GREEN**: Write the minimum code to make it pass
  3. **REFACTOR**: Clean up without changing behavior
- [ ] Baby steps: smallest possible increment each cycle
- [ ] The three rules of TDD (Uncle Bob):
  1. Don't write production code until you have a failing test
  2. Don't write more test than necessary to fail
  3. Don't write more production code than necessary to pass

## Module 2: TDD in Practice
- [ ] Starting point: write the test for the simplest case first
- [ ] Triangulation: add more test cases to drive generic solutions
- [ ] Fake it till you make it: return hardcoded values, then generalize
- [ ] Obvious implementation: when the solution is clear, just write it
- [ ] Test list: write a list of tests you think you need before starting
- [ ] One failing test at a time: never two red tests simultaneously
- [ ] Commit on green: every green state is a commit point

## Module 3: TDD Schools
- [ ] **Inside-Out (Chicago School)**:
  - [ ] Start from domain objects, work outward to controllers
  - [ ] Minimal mocking, real objects preferred
  - [ ] Good for domain logic, algorithms
  - [ ] Risk: may not fit the API design well
- [ ] **Outside-In (London School)**:
  - [ ] Start from acceptance test / controller, work inward
  - [ ] Heavy use of mocks for undiscovered dependencies
  - [ ] Good for API-first design, request/response flow
  - [ ] Risk: over-mocking, brittle tests
- [ ] When to use which: domain logic (inside-out), web APIs (outside-in)

## Module 4: TDD for Different Layers
- [ ] TDD for domain logic / business rules
- [ ] TDD for services: mock dependencies, test behavior
- [ ] TDD for REST controllers: MockMvc-driven
- [ ] TDD for repositories: Testcontainers-driven
- [ ] TDD for validation: parameterized tests
- [ ] TDD for error handling: test failure paths

## Module 5: TDD with Spring Boot
- [ ] TDD a REST API from scratch:
  1. Write MockMvc test for GET /api/users → 200 + JSON
  2. Create controller to pass test
  3. Write service test with mocked repository
  4. Create service to pass test
  5. Write repository test with Testcontainers
  6. Create entity and repository to pass test
- [ ] `@WebMvcTest` + `@MockBean` for controller TDD
- [ ] `@DataJpaTest` for repository TDD
- [ ] Refactoring under green tests: safe restructuring

## Module 6: Advanced TDD
- [ ] Transformation Priority Premise (Uncle Bob): prioritize transformations
- [ ] TDD and legacy code: characterization tests first, then refactor
- [ ] TDD for concurrent code (difficult but possible)
- [ ] TDD with event-driven systems
- [ ] When NOT to use TDD: exploratory code, UI, trivial code
- [ ] TDD discipline: why it feels slow but is actually faster

## Module 7: TDD Kata Practice
- [ ] FizzBuzz kata (beginner)
- [ ] String Calculator kata (beginner)
- [ ] Roman Numerals kata (intermediate)
- [ ] Bowling Game kata (intermediate)
- [ ] Bank Account kata (intermediate - outside-in)
- [ ] Game of Life kata (advanced)
- [ ] Practice routine: one kata per week, 30 minutes

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Do FizzBuzz and String Calculator with strict Red-Green-Refactor |
| Module 3 | Do the same kata twice: once inside-out, once outside-in — compare |
| Modules 4-5 | TDD a complete Spring Boot CRUD API from scratch (no code before test) |
| Module 6 | Take legacy code, add characterization tests, refactor safely |
| Module 7 | One kata per week for 2 months — build TDD muscle memory |

## Key Resources
- **Test-Driven Development: By Example** - Kent Beck (THE TDD book)
- **Growing Object-Oriented Software, Guided by Tests** - Freeman & Pryce
- **Clean Craftsmanship** - Robert C. Martin (TDD discipline)
- Coding Dojo (codingdojo.org) - kata collection
- Cyber-Dojo (cyber-dojo.org) - online TDD practice
