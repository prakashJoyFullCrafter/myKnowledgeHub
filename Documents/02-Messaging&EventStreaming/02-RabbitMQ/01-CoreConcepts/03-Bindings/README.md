# RabbitMQ Bindings - Curriculum

## Module 1: Binding Fundamentals
- [ ] **Binding**: a rule connecting an exchange to a queue (or another exchange)
- [ ] Bindings determine HOW exchanges route messages to queues
- [ ] Without a binding, a queue receives nothing — even if exchange type matches
- [ ] Bindings are created by the consumer side (usually) — declared on startup
- [ ] **Binding key**: the pattern used to match messages (same format as routing key)
- [ ] Many-to-many: one exchange can have many bindings, one queue can have bindings from many exchanges
- [ ] Stored in broker metadata — survives restart if queues/exchanges are durable

## Module 2: Binding Key vs Routing Key
- [ ] **Routing key**: label attached to a message by the PUBLISHER
- [ ] **Binding key**: pattern specified when binding a queue to an exchange
- [ ] **Matching logic**: depends on exchange type
  - [ ] Direct: binding key === routing key (exact match)
  - [ ] Topic: binding key is a pattern, routing key is the full string
  - [ ] Fanout: binding key is ignored (all bound queues get all messages)
  - [ ] Headers: binding specifies header match rules, not binding key
- [ ] **Binding arguments**: used by headers exchange instead of binding key
- [ ] Don't confuse the two: routing key is per-message, binding key is per-binding

## Module 3: Binding Operations
- [ ] **Create binding**:
  - [ ] AMQP: `channel.queueBind(queueName, exchangeName, bindingKey)`
  - [ ] Spring AMQP: `BindingBuilder.bind(queue).to(exchange).with(bindingKey)`
  - [ ] Management API: `PUT /api/bindings/{vhost}/e/{exchange}/q/{queue}`
- [ ] **Delete binding**:
  - [ ] `channel.queueUnbind(queueName, exchangeName, bindingKey)`
  - [ ] Rarely needed in practice — usually destroy the queue instead
- [ ] **List bindings**:
  - [ ] `rabbitmqctl list_bindings`
  - [ ] Management UI → Exchange → Bindings tab
- [ ] **Idempotent**: binding with same parameters is a no-op

## Module 4: Multiple Bindings Patterns
- [ ] **Multiple bindings on same queue**: queue receives messages matching ANY binding
  - [ ] Use case: one queue listens to multiple event types
  - [ ] Example: `audit-queue` bound with `*.created`, `*.updated`, `*.deleted`
- [ ] **Multiple queues bound to same exchange with same key**: broadcast to all
  - [ ] Each queue gets its own copy of the message
  - [ ] Use case: fan-out pattern (notification, cache invalidation)
- [ ] **Overlapping patterns**: message matching multiple patterns → delivered once per queue
  - [ ] Topic `order.*.created` and `order.us.*` both match `order.us.created`
  - [ ] Queue receives ONE copy (not duplicated)
- [ ] **Binding-level dispatch**: RabbitMQ deduplicates per queue, but copies to each queue

## Module 5: Exchange-to-Exchange Bindings
- [ ] **Exchange-to-exchange (E2E) binding**: bind one exchange to another
  - [ ] Extension to AMQP 0-9-1 (RabbitMQ-specific)
  - [ ] `channel.exchangeBind(destination, source, routingKey)`
- [ ] **Use cases**:
  - [ ] Aggregator: multiple source exchanges → aggregator exchange → many queues
  - [ ] Routing layers: hierarchical routing topologies
  - [ ] Fan-out optimization: fanout → topic for further filtering
- [ ] **Example**:
  ```
  direct-exchange → (bind with "error") → topic-exchange → queues
  ```
- [ ] **Caution**: complex topologies are hard to reason about — keep it simple when possible
- [ ] **Alternate exchange** is a form of E2E binding (fallback routing)

## Module 6: Dynamic Bindings
- [ ] **Static bindings**: declared on startup, rarely change
- [ ] **Dynamic bindings**: added/removed at runtime (per-user subscriptions, feature flags)
- [ ] **Management API for dynamic bindings**:
  - [ ] Admin or automation service creates bindings via REST API
  - [ ] Useful for multi-tenant or per-user event subscriptions
- [ ] **Caveats**:
  - [ ] Bindings are stored in Mnesia — excessive bindings hurt broker performance
  - [ ] Target: < 10K bindings per exchange for healthy performance
  - [ ] Dynamic bindings can complicate replication and upgrades
- [ ] **Alternative**: use topic exchange with wildcard patterns instead of per-user bindings
  - [ ] Example: instead of `user.123.notifications`, use `notifications.#` + consumer filtering

## Module 7: Binding Governance
- [ ] **Declare bindings as code**: version-control the topology
  - [ ] Spring AMQP: `@Bean Binding`
  - [ ] `definitions.json` for broker bootstrap
  - [ ] Terraform RabbitMQ provider (for infra-as-code)
- [ ] **Ownership**: who owns the binding — producer side or consumer side?
  - [ ] Usually consumer: producer publishes, consumer decides what to subscribe to
  - [ ] Consumer declares queue + binding on startup (idempotent)
- [ ] **Environment parity**: same topology across dev, staging, prod
- [ ] **Documentation**: maintain a topology diagram (exchanges, queues, bindings)
- [ ] **Testing**: integration tests verify bindings route correctly

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Create binding with topic exchange and wildcard pattern, test message flow |
| Module 3 | Create and inspect bindings via `rabbitmqctl list_bindings` and Management UI |
| Module 4 | Design an audit queue bound to multiple event patterns with multiple bindings |
| Module 5 | Build exchange-to-exchange topology: aggregator pattern |
| Module 6 | Build per-user dynamic bindings via management API (measure performance cost) |
| Module 7 | Declare bindings as code via Spring `@Bean` with version control |

## Key Resources
- RabbitMQ documentation — Bindings
- "Exchange-to-Exchange Bindings" — rabbitmq.com/e2e.html
- RabbitMQ Management API documentation
