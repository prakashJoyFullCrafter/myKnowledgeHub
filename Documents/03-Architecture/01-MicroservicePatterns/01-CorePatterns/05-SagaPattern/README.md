# Saga Pattern - Curriculum

## Module 1: The Problem
- [ ] Microservices = database per service → no distributed ACID transactions
- [ ] **2PC (Two-Phase Commit)**: coordinator asks all to prepare, then commit — doesn't scale (locks, blocking, coordinator SPOF)
- [ ] Need: maintain data consistency across services without distributed locks
- [ ] Saga: sequence of local transactions, each with a compensating action for rollback

## Module 2: Choreography-Based Saga
- [ ] Services communicate via events — no central coordinator
- [ ] Flow: Service A commits → publishes event → Service B listens → commits → publishes event → ...
- [ ] Compensation: Service B fails → publishes failure event → Service A runs compensating transaction
- [ ] Pros: simple, decoupled, no single point of failure
- [ ] Cons: hard to track overall flow, complex with many steps, cyclic dependencies risk
- [ ] Best for: simple sagas (2-4 steps), teams comfortable with event-driven design

## Module 3: Orchestration-Based Saga
- [ ] Central **Saga Orchestrator** tells each service what to do and when
- [ ] Orchestrator tracks state, handles retries, triggers compensations
- [ ] Flow: Orchestrator → command to Service A → response → command to Service B → ...
- [ ] Pros: clear flow, easy to understand/debug, centralized error handling
- [ ] Cons: orchestrator is a single point of logic (not failure if designed well), coupling to orchestrator
- [ ] Best for: complex sagas (5+ steps), clear business process, need visibility

## Module 4: Compensation & Error Handling
- [ ] **Compensating transactions**: undo the effect of a committed local transaction
  - [ ] Cancel order, refund payment, release inventory reservation
- [ ] Compensations must be **idempotent** — may be called multiple times
- [ ] **Forward recovery**: retry failed step until it succeeds (for transient errors)
- [ ] **Backward recovery**: run compensations for all completed steps (for business errors)
- [ ] **Pivot transaction**: the point of no return — after this, only forward recovery
- [ ] Handling: what if compensation itself fails? → retry with backoff, manual intervention queue

## Module 5: Implementation & Tools
- [ ] **Temporal**: workflow engine, durable execution, built-in retry/timeout, polyglot
- [ ] **Axon Framework**: Java, CQRS + Event Sourcing + Saga built-in, `@SagaEventHandler`
- [ ] **Camunda**: BPMN workflow engine, visual process designer, Java/REST API
- [ ] **Spring State Machine**: lightweight saga state management
- [ ] **Custom implementation**: state table in DB, event-driven with Kafka/RabbitMQ
- [ ] Choreography vs orchestration decision guide:
  - [ ] 2-4 simple steps → choreography
  - [ ] 5+ steps or complex error handling → orchestration
  - [ ] Need process visibility → orchestration
  - [ ] Want loose coupling → choreography

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build choreography saga: order → payment → inventory with Kafka events |
| Module 3 | Rebuild same flow with orchestrator using Temporal or custom state machine |
| Module 4 | Simulate payment failure mid-saga, verify compensations execute correctly |
| Module 5 | Compare Temporal vs Axon vs custom for the same saga |

## Key Resources
- Microservices Patterns - Chris Richardson (Chapter 4: Sagas)
- Temporal documentation (temporal.io)
- "Saga Pattern" - microservices.io (Chris Richardson)
- Designing Data-Intensive Applications - Martin Kleppmann
