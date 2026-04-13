# RabbitMQ Routing Keys - Curriculum

## Module 1: Routing Key Fundamentals
- [ ] **Routing key**: string label attached to a message when published
- [ ] Set by publisher: `channel.basicPublish(exchange, routingKey, properties, body)`
- [ ] Exchange uses routing key + binding rules to decide which queues get the message
- [ ] Routing key has NO inherent meaning — it's just a label the exchange interprets
- [ ] Not all exchanges use routing key (fanout ignores it, headers uses headers instead)
- [ ] Max length: 255 bytes
- [ ] **Common pattern**: hierarchical dot-separated names (e.g., `order.created`, `user.profile.updated`)

## Module 2: Direct Exchange Routing
- [ ] **Direct exchange**: routes by EXACT routing key match
- [ ] Multiple queues can bind with same routing key → all receive the message
- [ ] Multiple routing keys can bind to same queue → queue receives all
- [ ] Use cases:
  - [ ] Unicast: one routing key per queue (task distribution)
  - [ ] Log severity routing: `error` → error queue, `info` → info queue
  - [ ] Command routing: `command.create-user` → create user handler
- [ ] **Performance**: O(1) lookup — very fast
- [ ] Example:
  ```
  Bind queue-errors to exchange-logs with routing key "error"
  Bind queue-warnings with routing key "warning"
  Publish with routing key "error" → only queue-errors receives
  ```

## Module 3: Topic Exchange Routing
- [ ] **Topic exchange**: routes by pattern matching with wildcards
- [ ] Routing keys are dot-separated words (e.g., `order.us.created`)
- [ ] **Wildcards**:
  - [ ] `*` (star): matches EXACTLY one word
  - [ ] `#` (hash): matches ZERO or MORE words
- [ ] **Pattern examples**:
  - [ ] `order.*.created` — matches `order.us.created`, `order.eu.created`, NOT `order.created`
  - [ ] `order.#` — matches `order.created`, `order.us.cancelled.refunded`, `order`
  - [ ] `*.critical.*` — matches `db.critical.error`, `api.critical.timeout`
  - [ ] `#` alone — matches everything (like fanout)
- [ ] Powerful for hierarchical event taxonomies
- [ ] **Performance**: O(N) in binding count, but optimized with trie structure

## Module 4: Routing Key Design Patterns
- [ ] **Entity.event pattern**: `order.created`, `order.updated`, `order.cancelled`
  - [ ] Clear hierarchy, easy filtering by entity or event type
- [ ] **Entity.event.detail pattern**: `order.created.international`, `order.cancelled.fraud`
  - [ ] More granular, supports finer filtering
- [ ] **Region.entity.event**: `us.order.created`, `eu.user.login`
  - [ ] Geographic routing, regional filtering
- [ ] **Environment.service.event**: `prod.payment.succeeded`
  - [ ] Multi-environment on same broker (usually better to use separate vhosts/brokers)
- [ ] **Command vs event**: separate prefixes
  - [ ] Events: `event.order.created` (fact, past tense)
  - [ ] Commands: `command.order.create` (instruction, imperative)
- [ ] **Avoid**: changing routing key meaning after adoption (breaks consumers)

## Module 5: Headers Exchange (Alternative to Routing Keys)
- [ ] **Headers exchange**: routes by message headers instead of routing key
- [ ] Binding specifies header key-value pairs to match
- [ ] **`x-match` argument**:
  - [ ] `x-match=all`: ALL specified headers must match
  - [ ] `x-match=any`: AT LEAST ONE header must match
- [ ] **Use cases**:
  - [ ] Non-string values (integers, booleans)
  - [ ] Multi-attribute matching (e.g., format=PDF AND size=large)
  - [ ] When routing key string is too restrictive
- [ ] **Rarely used in practice** — topic exchange is usually sufficient
- [ ] **Performance**: slower than direct/topic due to header inspection

## Module 6: Routing Key Anti-Patterns
- [ ] **Routing key as payload**: don't put data in routing key
  - [ ] BAD: `order.12345.created` (ID in routing key — unbounded keys)
  - [ ] GOOD: `order.created` + message body with ID
- [ ] **Routing key too short**: `created` — ambiguous, no entity context
  - [ ] Fix: `order.created`, `user.created`
- [ ] **Routing key too long/nested**: `prod.us-east.order.customer.vip.premium.gold.created`
  - [ ] Over-engineered, hard to evolve
- [ ] **Mixing formats**: `order_created` vs `order.created` vs `OrderCreated`
  - [ ] Fix: enforce convention across organization
- [ ] **Routing key versioning**: `order.created.v1`, `order.created.v2`
  - [ ] Can work, but consider versioning in payload schema instead
- [ ] **Unbounded binding count**: dynamic bindings per entity (binding per user ID)
  - [ ] Fix: use wildcards, or headers exchange

## Module 7: Performance Considerations
- [ ] **Direct exchange**: hash map lookup, O(1) — fastest
- [ ] **Fanout exchange**: broadcast to all bindings, O(N) bindings — fast
- [ ] **Topic exchange**: trie-based matching, O(N) worst case, usually fast
- [ ] **Headers exchange**: slowest, iterates all bindings checking headers
- [ ] **Binding count impact**:
  - [ ] Thousands of bindings on a topic exchange → still fast with good patterns
  - [ ] Millions of bindings → consider refactoring (fewer, broader patterns)
- [ ] **Benchmarking**: measure with `PerfTest` tool under realistic binding counts
- [ ] **Rule of thumb**: prefer direct or topic; use fanout for true broadcast; headers rarely

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build order processing with direct exchange, separate queues for create/update/delete |
| Module 3 | Build logging system with topic exchange: route by severity AND component |
| Module 4 | Design routing key schema for a multi-region e-commerce system |
| Module 5 | Implement headers exchange for multi-attribute routing (format + size + locale) |
| Module 6 | Identify anti-patterns in a sample topology, refactor |
| Module 7 | Benchmark direct vs topic exchange with 1K, 10K, 100K bindings |

## Key Resources
- RabbitMQ documentation — Topic Exchange
- RabbitMQ Tutorials 5 (Topics)
- "RabbitMQ in Depth" — Gavin Roy (Chapter 3)
