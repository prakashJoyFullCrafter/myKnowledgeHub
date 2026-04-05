# Kotlin Testing - Curriculum

## Module 1: Testing Basics with JUnit 5
- [ ] JUnit 5 with Kotlin: `@Test`, `@BeforeEach`, `@AfterEach`
- [ ] Backtick test names: `` `should return user when valid id` ``
- [ ] `@Nested` inner classes for test organization
- [ ] Kotlin-specific assertions: `assertEquals`, `assertThrows`
- [ ] Testing data classes: `equals()` auto-generated

## Module 2: MockK (Kotlin-Native Mocking)
- [ ] Why MockK over Mockito? (Kotlin final classes, coroutines, DSL syntax)
- [ ] `mockk<MyService>()` - creating mocks
- [ ] `every { service.findById(1) } returns user` - stubbing
- [ ] `verify { service.save(any()) }` - verification
- [ ] `slot<T>()` and `capture()` - argument capture
- [ ] `coEvery` and `coVerify` - mocking suspend functions
- [ ] `spyk()` - partial mocking (spy)
- [ ] `relaxed = true` - auto-stub all methods
- [ ] `mockkStatic()` - mocking static/top-level functions
- [ ] `mockkObject()` - mocking Kotlin objects (singletons)
- [ ] `confirmVerified()` and `clearMocks()`

## Module 3: Kotest Framework
- [ ] Kotest vs JUnit 5: DSL-style specs
- [ ] Spec styles: `FunSpec`, `StringSpec`, `BehaviorSpec`, `DescribeSpec`, `ShouldSpec`
- [ ] `StringSpec` example: `"should return user" { ... }`
- [ ] `BehaviorSpec` example: `Given / When / Then`
- [ ] Matchers: `shouldBe`, `shouldNotBe`, `shouldContain`, `shouldThrow`
- [ ] Collection matchers: `shouldContainExactly`, `shouldHaveSize`
- [ ] String matchers: `shouldStartWith`, `shouldMatch`
- [ ] Custom matchers
- [ ] Property-based testing: `forAll`, `checkAll`
- [ ] Data-driven testing: `withData`
- [ ] Test lifecycle: `beforeTest`, `afterTest`, `beforeSpec`, `afterSpec`

## Module 4: Coroutine Testing
- [ ] `runTest` from `kotlinx-coroutines-test`
- [ ] `TestDispatcher` and `StandardTestDispatcher`
- [ ] `advanceUntilIdle()`, `advanceTimeBy()` - controlling virtual time
- [ ] Testing `Flow`: `Turbine` library
- [ ] `flow.test { awaitItem() shouldBe expected; awaitComplete() }`
- [ ] Testing `StateFlow` and `SharedFlow`
- [ ] MockK `coEvery` / `coVerify` for suspend functions
- [ ] Testing timeouts and cancellation

## Module 5: Spring Boot + Kotlin Testing
- [ ] `@SpringBootTest` with Kotlin
- [ ] MockK Spring integration: `@MockkBean`, `@SpykBean`
- [ ] `springmockk` library (MockK replacement for `@MockBean`)
- [ ] Testing coroutine controllers with `WebTestClient`
- [ ] Testcontainers with Kotlin DSL
- [ ] `@DynamicPropertySource` in Kotlin
- [ ] Kotest Spring extension

## Module 6: Testing Best Practices for Kotlin
- [ ] Use backtick test names for readability
- [ ] Prefer MockK over Mockito in Kotlin projects
- [ ] Test data builders with `copy()` on data classes
- [ ] Object Mother pattern with Kotlin: `fun aUser(name: String = "John") = User(name)`
- [ ] Kotest `Arb` for random test data generation
- [ ] Avoid testing implementation details - test behavior
- [ ] Kotlin test fixtures and shared test utilities

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Write JUnit 5 tests with backtick names |
| Module 2 | Replace all Mockito mocks with MockK |
| Module 3 | Rewrite test suite using Kotest BehaviorSpec |
| Module 4 | Test coroutine service with Turbine for Flow |
| Module 5 | Integration test Spring Boot + Kotlin with MockkBean + Testcontainers |
| Module 6 | Build test data factory using data class `copy()` |

## Key Resources
- MockK documentation (mockk.io)
- Kotest documentation (kotest.io)
- kotlinx-coroutines-test documentation
- Turbine documentation (cashapp/turbine)
