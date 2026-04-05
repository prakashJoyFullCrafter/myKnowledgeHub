# Unit Testing - Expert Curriculum

## Module 1: Unit Test Fundamentals
- [ ] What is a unit test? Testing the smallest testable part in isolation
- [ ] Unit vs integration vs E2E tests (testing pyramid)
- [ ] Test independence: each test must run in isolation, no shared state
- [ ] Deterministic tests: same input = same output, no randomness
- [ ] Fast feedback: unit tests should run in milliseconds
- [ ] Test as documentation: tests describe expected behavior

## Module 2: JUnit 5 Core
- [ ] `@Test` - marking test methods
- [ ] `@DisplayName` - human-readable test names
- [ ] `@BeforeEach` / `@AfterEach` - setup/teardown per test
- [ ] `@BeforeAll` / `@AfterAll` - setup/teardown per class (static)
- [ ] `@Nested` - grouping related tests in inner classes
- [ ] `@Disabled` - temporarily skipping tests (with reason)
- [ ] `@Tag` - categorizing tests for selective execution
- [ ] `@RepeatedTest` - running test multiple times
- [ ] `@Timeout` - failing slow tests

## Module 3: Assertions
- [ ] `assertEquals`, `assertNotEquals` - value comparison
- [ ] `assertTrue`, `assertFalse` - boolean checks
- [ ] `assertNull`, `assertNotNull` - null checks
- [ ] `assertThrows` - verifying exceptions: `assertThrows(NotFoundException.class, () -> service.findById(999))`
- [ ] `assertDoesNotThrow` - verifying no exception
- [ ] `assertAll` - grouped assertions (all execute even if one fails)
- [ ] `assertIterableEquals` - collection comparison
- [ ] `assertTimeout` - verifying execution time
- [ ] AssertJ library: fluent assertions (`assertThat(result).isNotNull().hasSize(3).contains("item")`)
- [ ] AssertJ: collection assertions, exception assertions, soft assertions

## Module 4: Parameterized Tests
- [ ] `@ParameterizedTest` - data-driven testing
- [ ] `@ValueSource` - inline values: `@ValueSource(strings = {"a", "b", "c"})`
- [ ] `@NullSource`, `@EmptySource`, `@NullAndEmptySource`
- [ ] `@EnumSource` - test all enum values
- [ ] `@CsvSource` - inline CSV: `@CsvSource({"1, John", "2, Jane"})`
- [ ] `@CsvFileSource` - external CSV file
- [ ] `@MethodSource` - factory method for complex test data
- [ ] `@ArgumentsSource` - custom `ArgumentsProvider`
- [ ] Custom display names for parameterized tests

## Module 5: Mocking with Mockito
- [ ] Why mock? Isolating the unit under test
- [ ] `@Mock` - creating mock objects
- [ ] `@InjectMocks` - auto-injecting mocks into class under test
- [ ] `@ExtendWith(MockitoExtension.class)` - JUnit 5 integration
- [ ] Stubbing: `when(mock.method()).thenReturn(value)`
- [ ] Stubbing exceptions: `when(mock.method()).thenThrow(new RuntimeException())`
- [ ] `thenAnswer` - dynamic stubbing with lambda
- [ ] Argument matchers: `any()`, `anyString()`, `anyLong()`, `eq()`, `argThat()`
- [ ] Verification: `verify(mock).method()`, `verify(mock, times(2))`, `verify(mock, never())`
- [ ] `verifyNoMoreInteractions(mock)` - no unexpected calls
- [ ] Argument capture: `@Captor ArgumentCaptor<User> captor`
- [ ] `@Spy` - partial mocking (real object with selective stubbing)
- [ ] `doReturn().when()` vs `when().thenReturn()` - spy-safe stubbing
- [ ] Mocking static methods: `try (var mocked = mockStatic(MyUtil.class)) { ... }`
- [ ] Mocking `void` methods: `doNothing().when(mock).method()`

## Module 6: Test Naming & Structure
- [ ] AAA pattern: **Arrange** (setup) → **Act** (execute) → **Assert** (verify)
- [ ] Naming: `should_ReturnUser_When_ValidId()` or `givenValidId_whenFindById_thenReturnUser()`
- [ ] Backtick names in Kotlin: `` `should return user when valid id` ``
- [ ] One assertion per concept (not strictly one assertion per test)
- [ ] Test one behavior per test method
- [ ] No logic in tests: no `if`, `for`, `switch` in test code
- [ ] Avoid test interdependence: each test is self-contained

## Module 7: Test Data & Fixtures
- [ ] Object Mother pattern: `UserTestFactory.createValidUser()`
- [ ] Builder pattern for test data: `User.builder().name("John").build()`
- [ ] Data class `copy()` in Kotlin for test variations
- [ ] `@TempDir` for temporary file system in tests
- [ ] Test resource files: `src/test/resources/`
- [ ] Avoid magic numbers: use named constants in tests
- [ ] Random test data: `UUID.randomUUID()`, Instancio, JavaFaker

## Module 8: Code Coverage
- [ ] JaCoCo: Java Code Coverage tool
- [ ] Line coverage vs branch coverage vs mutation coverage
- [ ] Coverage report: `mvn jacoco:report` / `gradle jacocoTestReport`
- [ ] Enforcing minimum coverage: `jacoco:check` with thresholds
- [ ] What % to target? 80%+ for services, 90%+ for critical domain logic
- [ ] Coverage anti-patterns: testing getters/setters, chasing 100%
- [ ] Mutation testing with PIT: tests that kill mutants = effective tests
- [ ] Integrating coverage in CI pipeline (fail build if below threshold)

## Module 9: Test Anti-Patterns & Best Practices
- [ ] ❌ Testing implementation, not behavior
- [ ] ❌ Brittle tests that break on refactor
- [ ] ❌ Slow tests (network calls, file I/O, database)
- [ ] ❌ Test interdependence (order-dependent tests)
- [ ] ❌ Over-mocking (mocking everything, testing nothing)
- [ ] ❌ Ignoring failing tests (`@Disabled` without reason)
- [ ] ✅ Test behavior, not implementation
- [ ] ✅ Prefer real objects over mocks when feasible
- [ ] ✅ Keep tests fast, deterministic, independent
- [ ] ✅ Treat test code with the same quality as production code
- [ ] ✅ Refactor tests when refactoring production code

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Write 20 JUnit 5 tests for a service class using AssertJ |
| Modules 4 | Convert repetitive tests to `@ParameterizedTest` |
| Module 5 | Mock all dependencies of a Spring service, test all paths |
| Modules 6-7 | Refactor test names to follow naming convention, create test factories |
| Module 8 | Set up JaCoCo, achieve 80% coverage, run PIT mutation testing |
| Module 9 | Audit existing tests for anti-patterns, fix them |

## Key Resources
- JUnit 5 User Guide (junit.org)
- Mockito documentation (site.mockito.org)
- AssertJ documentation (assertj.github.io)
- Growing Object-Oriented Software, Guided by Tests - Freeman & Pryce
- Unit Testing Principles, Practices, and Patterns - Vladimir Khorikov
