# Contract Testing - Expert Curriculum

## Module 1: Why Contract Testing?
- [ ] The problem: service A depends on service B's API — how to ensure compatibility?
- [ ] Integration tests don't scale: N services = N^2 integration points
- [ ] Contract testing: lightweight verification of API agreements
- [ ] Consumer-Driven Contracts (CDC): consumer defines what it needs
- [ ] Provider verification: producer verifies it meets all consumer contracts
- [ ] Contract tests vs integration tests: complementary, not replacement

## Module 2: Spring Cloud Contract (Producer-Side)
- [ ] `spring-cloud-starter-contract-verifier` dependency
- [ ] Writing contracts in Groovy DSL or YAML
- [ ] Contract structure: request (method, url, headers, body) → response (status, body)
- [ ] `mvn spring-cloud-contract:generateTests` - auto-generated tests from contracts
- [ ] Base test class: extend `@SpringBootTest` for generated tests
- [ ] Stub generation: `mvn install` produces stub JARs
- [ ] Publishing stubs to Maven repository / Artifactory
- [ ] Contract for messaging: Kafka/RabbitMQ message contracts

## Module 3: Pact (Consumer-Side)
- [ ] Pact philosophy: consumer writes the contract
- [ ] `@ExtendWith(PactConsumerTestExt.class)` - JUnit 5 integration
- [ ] `@Pact` method: defining expected interactions
- [ ] `@PactTestFor` - running consumer test against mock provider
- [ ] Pact file generation: `target/pacts/*.json`
- [ ] Provider verification: `@Provider`, `@PactBroker`, `@State`
- [ ] State management: `@State("user exists")` for provider setup

## Module 4: Pact Broker
- [ ] Central registry for sharing contracts between teams
- [ ] Publishing consumer pacts to broker
- [ ] Provider fetching and verifying contracts from broker
- [ ] Verification results publishing
- [ ] `can-i-deploy`: check compatibility before deploying
- [ ] Webhooks: trigger provider verification on new pact
- [ ] Tagging pacts with environment/branch

## Module 5: Contract Testing for REST APIs
- [ ] Request/response contract: exact match vs regex matchers
- [ ] Matchers: `anyString()`, `integer()`, `date()`, `regex()`
- [ ] Partial body matching (don't over-specify)
- [ ] Header contracts
- [ ] Query parameter contracts
- [ ] Error response contracts (400, 404, 500)
- [ ] Versioning: handling breaking changes in contracts

## Module 6: Contract Testing for Messaging
- [ ] Spring Cloud Contract: message contracts
- [ ] Pact: async message contract support
- [ ] Kafka message schema contracts
- [ ] Avro schema as contract (Schema Registry)
- [ ] Event contract: header + payload structure
- [ ] Contract for event versioning

## Module 7: CI/CD Integration
- [ ] Contract test in CI pipeline: when to run
- [ ] `can-i-deploy` gate before production deployment
- [ ] Pact Broker + CI: automated verification flow
- [ ] Contract test failure: who fixes it? (consumer vs provider)
- [ ] Breaking change detection and rollback

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Write Spring Cloud Contract for a REST API, generate tests |
| Modules 3-4 | Write Pact consumer test, set up Pact Broker, verify on provider side |
| Module 5 | Full contract suite for a microservice API (happy + error paths) |
| Module 6 | Contract test for Kafka event between two services |
| Module 7 | Add `can-i-deploy` check in CI pipeline |

## Key Resources
- Spring Cloud Contract Reference Documentation
- Pact documentation (docs.pact.io)
- Contract Testing in Practice (martinfowler.com)
- Consumer-Driven Contracts - Ian Robinson
