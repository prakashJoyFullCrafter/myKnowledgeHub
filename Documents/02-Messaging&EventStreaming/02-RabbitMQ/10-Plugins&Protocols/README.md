# RabbitMQ Plugins & Protocols - Curriculum

Extend RabbitMQ with plugins and use protocols beyond AMQP 0-9-1.

---

## Module 1: Plugin System Overview
- [ ] **RabbitMQ is extensible via plugins** — many features are plugins
- [ ] **Plugin management**:
  - [ ] `rabbitmq-plugins list` — see all available and enabled
  - [ ] `rabbitmq-plugins enable <plugin>` — enable at runtime
  - [ ] `rabbitmq-plugins disable <plugin>` — disable
  - [ ] Most plugins don't require restart
- [ ] **Plugin categories**:
  - [ ] Protocol plugins (STOMP, MQTT, AMQP 1.0, Web STOMP/MQTT)
  - [ ] Auth plugins (LDAP, HTTP, OAuth2)
  - [ ] Federation/Shovel (multi-broker)
  - [ ] Exchange type plugins (delayed message, consistent hash)
  - [ ] Management (web UI, REST API)
  - [ ] Monitoring (Prometheus exporter, top)
  - [ ] Queue type plugins (Streams)
- [ ] **Plugin directory**: `$RABBITMQ_HOME/plugins/`

## Module 2: Management Plugin
- [ ] **`rabbitmq_management`**: web UI + REST API
- [ ] **Web UI**: http://host:15672 (default)
- [ ] **Features**:
  - [ ] Cluster overview, node status
  - [ ] Queue browser, message rates
  - [ ] Create/delete exchanges, queues, bindings
  - [ ] User management
  - [ ] Policy editor
  - [ ] Connection/channel inspector
- [ ] **REST API**:
  - [ ] Automation and integration
  - [ ] Example: `curl -u user:pass http://host:15672/api/queues`
  - [ ] Use for scripted topology management
- [ ] **Security**:
  - [ ] Require management tag on users
  - [ ] TLS for HTTPS access
  - [ ] Never expose publicly without auth proxy
- [ ] **Rate of data collection**: high-frequency polling can load broker

## Module 3: Prometheus & Monitoring Plugins
- [ ] **`rabbitmq_prometheus`**: expose metrics in Prometheus format
- [ ] **Enabled by default** in modern RabbitMQ
- [ ] **Metrics endpoint**: `/metrics` on port 15692 by default
- [ ] **Key metrics exposed**:
  - [ ] Queue depth, message rates
  - [ ] Connection/channel counts
  - [ ] Memory and disk usage
  - [ ] Node health, Erlang processes
- [ ] **Grafana dashboards**: official dashboards available on grafana.com
- [ ] **Alertmanager integration**: alert on queue depth, memory, node down
- [ ] **`rabbitmq_top`**: live process view (like `top` command) in management UI
- [ ] **`rabbitmq_tracing`**: trace messages in/out of broker (debugging)

## Module 4: STOMP Protocol
- [ ] **STOMP**: Simple (or Streaming) Text Oriented Messaging Protocol
- [ ] **Text-based**: readable, simple to implement
- [ ] **Plugin**: `rabbitmq_stomp`
- [ ] **Port**: 61613 (default)
- [ ] **Use cases**:
  - [ ] Browser clients via WebSockets (`rabbitmq_web_stomp`)
  - [ ] Simple clients in any language
  - [ ] Real-time web apps
- [ ] **How it maps to AMQP**:
  - [ ] `/queue/name` → direct exchange + queue
  - [ ] `/topic/name` → topic exchange
  - [ ] `/exchange/name/routing-key` → direct exchange
- [ ] **Limitations**: fewer features than AMQP (no per-message TTL, no priority)
- [ ] **Web STOMP**: `rabbitmq_web_stomp` exposes STOMP over WebSockets

## Module 5: MQTT Protocol
- [ ] **MQTT**: lightweight pub/sub protocol, popular in IoT
- [ ] **Plugin**: `rabbitmq_mqtt`
- [ ] **Port**: 1883 (plain), 8883 (TLS)
- [ ] **Supports**: MQTT 3.1, 3.1.1, 5.0
- [ ] **RabbitMQ as MQTT broker**: use RabbitMQ to serve MQTT clients alongside AMQP
- [ ] **How it maps**:
  - [ ] MQTT topics → topic exchange with routing key conversion
  - [ ] Slash `/` in topic → dot `.` in routing key
- [ ] **QoS levels**:
  - [ ] QoS 0: at-most-once (fire and forget)
  - [ ] QoS 1: at-least-once (with ack)
  - [ ] QoS 2: exactly-once (handshake) — not always supported
- [ ] **Use cases**: IoT devices, mobile clients, constrained networks
- [ ] **Web MQTT**: `rabbitmq_web_mqtt` exposes MQTT over WebSockets

## Module 6: AMQP 1.0
- [ ] **AMQP 1.0**: completely different from 0-9-1 (not backward compatible)
- [ ] **Standardized by OASIS**: interoperable across brokers (ActiveMQ, Azure Service Bus, Solace)
- [ ] **Features**:
  - [ ] More sophisticated flow control
  - [ ] Richer type system
  - [ ] Multi-transfer framing
- [ ] **Plugin**: `rabbitmq_amqp1_0` (bundled, since RabbitMQ 3.7)
- [ ] **RabbitMQ 4.0+**: NATIVE AMQP 1.0 support (no plugin needed)
  - [ ] First-class citizen alongside AMQP 0-9-1
- [ ] **When to use**:
  - [ ] Interoperability with other AMQP 1.0 brokers
  - [ ] Enterprise messaging integration
  - [ ] Standard compliance
- [ ] **Clients**: Apache Qpid Proton, Azure Service Bus SDK, Python proton
- [ ] **Mapping to RabbitMQ concepts**: nodes → exchanges/queues

## Module 7: Delayed Message Exchange
- [ ] **Plugin**: `rabbitmq_delayed_message_exchange` (community, not bundled)
- [ ] **Problem**: AMQP doesn't natively support message delays (only TTL + DLX workaround)
- [ ] **Delayed exchange**: messages held for N milliseconds before routing
- [ ] **Setup**:
  - [ ] Install plugin
  - [ ] Declare exchange with `x-delayed-type` argument (inner type: direct, topic, fanout)
  - [ ] `x-delayed-message` type
- [ ] **Publishing**: set `x-delay` header (milliseconds)
  ```
  headers: { "x-delay": 5000 }  // delay 5 seconds
  ```
- [ ] **Use cases**: scheduled tasks, retry with backoff, reminder systems
- [ ] **Limitations**:
  - [ ] Delay stored in mnesia (memory usage)
  - [ ] Not clustered-HA (message lives on one node)
  - [ ] Better to use Quartz or external scheduler for critical delays

## Module 8: Other Useful Plugins
- [ ] **`rabbitmq_consistent_hash_exchange`**: consistent-hash-based routing
  - [ ] Distribute messages across N queues by hash of routing key
  - [ ] Use case: partition messages for parallel processing with ordering per key
- [ ] **`rabbitmq_sharding`**: automatic queue sharding
- [ ] **`rabbitmq_event_exchange`**: broker events (connection created, policy changed) as messages
  - [ ] Use case: audit logs, real-time operational monitoring
- [ ] **`rabbitmq_auth_backend_ldap/http/oauth2`**: auth backends (covered in Security)
- [ ] **`rabbitmq_federation` / `rabbitmq_shovel`**: multi-broker replication (covered in Federation & Multi-DC)
- [ ] **`rabbitmq_stream`**: stream queue support (bundled)
- [ ] **`rabbitmq_random_exchange`**: randomly route to one bound queue
- [ ] **`rabbitmq_recent_history_exchange`**: replay last N messages to new subscribers
- [ ] **Community plugins**: github.com/rabbitmq/community-plugins

## Module 9: Stream Protocol Deep Dive
- [ ] **Stream protocol**: binary protocol (NOT AMQP) optimized for streams
- [ ] **Port**: 5552
- [ ] **Designed for**: high-throughput append-only log (Kafka-like)
- [ ] **Features**:
  - [ ] Server-side filtering (since 3.13)
  - [ ] Single Active Consumer (SAC) per partition
  - [ ] Offset-based consumption
  - [ ] Timestamp-based consumption
- [ ] **Super streams** (since 3.11):
  - [ ] Partitioned streams (multiple streams behind one logical stream)
  - [ ] Hash-based partition routing by key
  - [ ] Parallel consumption like Kafka partitions
- [ ] **Clients**:
  - [ ] `rabbitmq-stream-java-client`
  - [ ] `rabbitmq-stream-go-client`
  - [ ] `pika` does NOT support stream protocol (use AMQP fallback)
- [ ] **Use when**:
  - [ ] High throughput (> 100K msg/sec)
  - [ ] Long retention needed
  - [ ] Replay from offset/timestamp
  - [ ] Kafka-like semantics but RabbitMQ ecosystem

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Enumerate all enabled plugins on your broker, understand each |
| Module 2 | Use Management API to script topology creation |
| Module 3 | Set up Prometheus + Grafana with RabbitMQ dashboard |
| Module 4 | Enable STOMP, connect browser client via Web STOMP |
| Module 5 | Enable MQTT, publish from mobile/IoT client |
| Module 6 | Enable AMQP 1.0, connect with Qpid Proton client |
| Module 7 | Install delayed message plugin, schedule message 10s in future |
| Module 8 | Enable consistent hash exchange, route messages to 4 queues by key |
| Module 9 | Build stream consumer with offset replay |

## Key Resources
- rabbitmq.com/plugins.html (plugin system)
- rabbitmq.com/stomp.html
- rabbitmq.com/mqtt.html
- rabbitmq.com/amqp-0-8.html and amqp-1-0.html
- github.com/rabbitmq/rabbitmq-delayed-message-exchange
- rabbitmq.com/stream.html
