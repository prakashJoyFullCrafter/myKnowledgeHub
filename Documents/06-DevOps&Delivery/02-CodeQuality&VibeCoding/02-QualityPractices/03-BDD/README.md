# Behavior-Driven Development (BDD) - Expert Curriculum

## Module 1: BDD Fundamentals
- [ ] BDD = TDD + ubiquitous language + collaboration
- [ ] Bridging the communication gap between business and technical teams
- [ ] Specification by Example: concrete examples as requirements
- [ ] Living documentation: specs that are always up-to-date because they run as tests
- [ ] BDD is a discovery process, not just a testing tool

## Module 2: Three Amigos
- [ ] Three Amigos session: Business Analyst + Developer + Tester
- [ ] Purpose: shared understanding before coding starts
- [ ] Discover requirements through concrete examples
- [ ] Identify edge cases, alternative flows, error scenarios
- [ ] Output: feature files with scenarios
- [ ] Frequency: before each user story implementation

## Module 3: Gherkin Syntax
- [ ] `Feature:` - business capability being described
- [ ] `Scenario:` - one specific example
- [ ] `Given` - preconditions (arrange)
- [ ] `When` - action (act)
- [ ] `Then` - expected outcome (assert)
- [ ] `And` / `But` - additional steps
- [ ] `Scenario Outline:` + `Examples:` - data-driven scenarios
- [ ] `Background:` - shared Given steps for all scenarios in a feature
- [ ] Tags: `@smoke`, `@regression`, `@wip` for filtering
- [ ] Rule keyword (Gherkin 6): grouping scenarios under business rules

## Module 4: Cucumber for Java
- [ ] `cucumber-java` and `cucumber-junit-platform-engine` dependencies
- [ ] Feature files: `src/test/resources/features/*.feature`
- [ ] Step definitions: Java/Kotlin methods matching Gherkin steps
- [ ] `@Given`, `@When`, `@Then` annotations with regex or Cucumber expressions
- [ ] Cucumber expressions: `{int}`, `{string}`, `{float}`, custom parameter types
- [ ] Sharing state between steps: dependency injection (PicoContainer, Spring)
- [ ] Hooks: `@Before`, `@After`, `@BeforeStep`, `@AfterStep`
- [ ] Running: `@Suite`, `@ConfigurationParameter`, `@SelectClasspathResource`

## Module 5: BDD with Spring Boot
- [ ] `@CucumberContextConfiguration` + `@SpringBootTest`
- [ ] Cucumber Spring integration: inject Spring beans into step definitions
- [ ] Testing REST APIs with BDD: Given (setup data) → When (HTTP call) → Then (assert response)
- [ ] Database setup in Given steps (test data)
- [ ] Cleanup with `@After` hooks or `@Transactional`
- [ ] BDD for API acceptance tests

## Module 6: Writing Good Scenarios
- [ ] ✅ Declarative style: "Given a logged-in user" (what, not how)
- [ ] ❌ Imperative style: "Given I enter username, Given I enter password, Given I click login"
- [ ] One scenario, one behavior
- [ ] Keep scenarios short: 3-5 lines ideal
- [ ] Avoid UI details in scenarios (test behavior, not clicks)
- [ ] Use domain language, not technical language
- [ ] Scenario anti-patterns: too many Given steps, too broad, too technical

## Module 7: Living Documentation
- [ ] Cucumber reports: HTML, JSON
- [ ] Serenity BDD: rich living documentation with screenshots
- [ ] Publishing feature docs to wiki/confluence automatically
- [ ] Feature files as source of truth for business requirements
- [ ] Tracking coverage: which business rules have scenarios?
- [ ] Maintaining scenarios: update when requirements change

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Run a Three Amigos session for a real user story |
| Modules 3-4 | Write 10 feature scenarios with Cucumber, implement step definitions |
| Module 5 | BDD test a Spring Boot REST API: user registration flow |
| Module 6 | Rewrite imperative scenarios to declarative style |
| Module 7 | Generate living documentation report, share with team |

## Key Resources
- **BDD in Action** (2nd Edition) - John Ferguson Smart
- **The Cucumber Book** - Matt Wynne & Aslak Hellesoy
- **Specification by Example** - Gojko Adzic
- Cucumber documentation (cucumber.io)
- Serenity BDD documentation (serenity-bdd.info)
