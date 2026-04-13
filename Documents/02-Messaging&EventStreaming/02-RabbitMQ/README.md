# RabbitMQ

Traditional message broker with flexible routing — mastery-level curriculum.

## Sections

### Foundations
1. **Core Concepts** (4 topics) — Exchanges & Queues, Routing Keys, Bindings, AMQP Protocol — full module breakdown
2. **Patterns** (4 topics) — Work Queues, Fanout, Topic Exchange, Dead Letter Queues
3. **Kafka vs RabbitMQ** (2 topics) — Use Case Selection, Throughput Comparison
4. **Spring Integration** (5 modules) — RabbitTemplate, @RabbitListener, declarations, retry/DLQ, publisher confirms
5. **Clustering & HA** (5 modules) — Clustering, quorum queues, streams, federation, monitoring

### Mastery Deep Dives
6. **Internals & Architecture** — Erlang VM, queue process model, Mnesia, message store, delivery process, flow control, GC & memory
7. **Performance & Capacity Planning** — Performance factors, queue type characteristics, sizing formulas, tuning, PerfTest, OS/hardware tuning
8. **Security Deep Dive** — Threat model, SASL (PLAIN/EXTERNAL/LDAP/HTTP/OAuth2), users/tags/permissions, TLS/mTLS, vhost isolation, inter-node security, audit
9. **Federation & Multi-DC** — Federation plugin, exchange/queue federation, Shovel, multi-DC topologies, hub-spoke/mesh/active-active
10. **Plugins & Protocols** — Management, Prometheus, STOMP, MQTT, AMQP 1.0, delayed message, consistent hash, stream protocol, super streams
11. **Operations & Troubleshooting** — CLI tools, alarms & flow control, memory issues, network partition handling, upgrades, classic→quorum migration, common issues, runbooks
