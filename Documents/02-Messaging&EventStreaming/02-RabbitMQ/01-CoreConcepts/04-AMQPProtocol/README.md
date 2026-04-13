# AMQP Protocol - Curriculum

## Module 1: AMQP 0-9-1 Overview
- [ ] **AMQP (Advanced Message Queuing Protocol)**: open standard for message-oriented middleware
- [ ] **AMQP 0-9-1**: the version RabbitMQ implements natively (most common)
- [ ] **AMQP 1.0**: completely different protocol (more recent, supported via plugin/RabbitMQ 4.0+)
- [ ] Binary protocol over TCP — efficient, type-safe
- [ ] **Core concepts**: Connection, Channel, Exchange, Queue, Binding, Message
- [ ] Published by OASIS, royalty-free, multi-vendor
- [ ] RabbitMQ's native protocol = AMQP 0-9-1 (until 4.0 native AMQP 1.0)

## Module 2: Connection
- [ ] **TCP connection** from client to broker, typically on port 5672 (or 5671 for TLS)
- [ ] **Handshake**: protocol negotiation, authentication, tuning parameters
- [ ] **Connection lifecycle**: open → tune → open vhost → use → close
- [ ] **Heartbeats**: bidirectional keep-alive (default 60s, disable with 0)
- [ ] **Connection recovery**: clients should auto-reconnect on failure
  - [ ] Java/Spring AMQP: built-in via `CachingConnectionFactory`
- [ ] **Connection count**: 1 connection per app typically, NOT per thread
- [ ] **Per-connection cost**: memory, file descriptor, TCP — minimize count
- [ ] **Properties**: `connection_name`, `client_properties` for identification in management UI

## Module 3: Channel
- [ ] **Channel**: lightweight virtual connection multiplexed over one TCP connection
- [ ] Allows concurrent operations without opening multiple TCP connections
- [ ] **One thread per channel** — channels are NOT thread-safe
- [ ] **Channel pool**: reuse channels instead of creating per operation
- [ ] **Channel max**: limited per connection (default 2047)
- [ ] **Channel lifecycle**: open → use → close
- [ ] **Channel errors**: protocol violations close the channel (can reopen)
- [ ] **Connection errors**: closing errors kill the whole connection
- [ ] **Why channels exist**: TCP connections are expensive; channels are cheap

## Module 4: Virtual Hosts (vhosts)
- [ ] **Vhost**: logical grouping of exchanges, queues, bindings, users, policies
- [ ] **Multi-tenancy**: separate vhosts for different apps/teams on the same cluster
- [ ] Default vhost: `/` — used if not specified
- [ ] **Vhost isolation**: exchanges and queues in different vhosts cannot interact
- [ ] **Per-vhost permissions**: users have configure/write/read permissions per vhost
- [ ] **Per-vhost policies**: HA, TTL, max-length applied at vhost level
- [ ] **URL encoding**: `/` must be encoded as `%2F` in management API URLs
- [ ] **Vhost limits**: connection count, queue count, message rate (since 3.11)

## Module 5: Message Structure
- [ ] **Message parts**:
  - [ ] **Body**: binary payload (just bytes to AMQP)
  - [ ] **Properties**: structured metadata (standard AMQP fields)
  - [ ] **Headers**: custom key-value map
- [ ] **Standard properties**:
  - [ ] `content-type` (e.g., `application/json`)
  - [ ] `content-encoding` (e.g., `gzip`)
  - [ ] `delivery-mode` (1=transient, 2=persistent)
  - [ ] `priority` (0-255, for priority queues)
  - [ ] `correlation-id` (for request-reply patterns)
  - [ ] `reply-to` (reply queue name)
  - [ ] `expiration` (per-message TTL in ms)
  - [ ] `message-id` (unique ID for deduplication)
  - [ ] `timestamp` (message creation time)
  - [ ] `type` (application-specific type label)
  - [ ] `user-id` (authenticated user, validated by broker)
  - [ ] `app-id` (application that sent the message)
- [ ] **Custom headers**: any app-specific metadata (routing, tracing, tenancy)

## Module 6: Acknowledgements (Consumer Side)
- [ ] **Ack (`basic.ack`)**: successful processing — broker removes message from queue
- [ ] **Nack (`basic.nack`)**: failure — with `requeue=true` or `false`
- [ ] **Reject (`basic.reject`)**: similar to nack but single message only
- [ ] **Auto-ack** (`basicConsume` with `autoAck=true`): broker acks on delivery — UNSAFE
  - [ ] Message lost if consumer crashes before processing
  - [ ] Only for: metrics, logs, acceptable loss
- [ ] **Manual ack**: consumer explicitly acks after processing — SAFE default
- [ ] **Requeue semantics**:
  - [ ] `requeue=true`: put back at head of queue (can cause infinite loops)
  - [ ] `requeue=false`: discard (or route to DLX if configured)
- [ ] **Multi-ack**: `basic.ack(deliveryTag, multiple=true)` acks all up to that tag
- [ ] **Delivery tag**: per-channel ID, opaque to consumer, monotonic

## Module 7: Publisher Confirms
- [ ] **Problem**: publisher doesn't know if broker received the message
- [ ] **Publisher confirms** (RabbitMQ extension to AMQP):
  - [ ] `channel.confirmSelect()` — enable confirms on channel
  - [ ] Broker sends `basic.ack` (received) or `basic.nack` (failed) per published message
  - [ ] Asynchronous: client receives confirms via callback or waitForConfirms
- [ ] **Modes**:
  - [ ] Sync: `channel.waitForConfirmsOrDie()` — blocks, slow
  - [ ] Async batch: add listener, track pending messages (fast, reliable)
  - [ ] Fire and forget: no confirms (fastest, risky)
- [ ] **Confirm + persistent + durable queue + mirrored/quorum = no data loss**
- [ ] **Transactions** (`tx.select`) — older mechanism, much slower, avoid

## Module 8: Prefetch (QoS)
- [ ] **Problem**: broker sends as many messages as possible to consumer → overload
- [ ] **Prefetch count** (`basic.qos`): max unacked messages a consumer can have at once
  - [ ] `channel.basicQos(prefetchCount)`
  - [ ] Default: unlimited (bad default — causes memory issues)
- [ ] **Recommended**: start with 10-50 for typical workloads, tune based on processing time
- [ ] **Tuning rule**:
  - [ ] Short processing (ms): higher prefetch (100-300)
  - [ ] Long processing (seconds): lower prefetch (1-10)
  - [ ] Mixed: prefetch that balances throughput and fairness
- [ ] **Global prefetch**: applies to all channels on connection (rarely used)
- [ ] **Too high**: one slow consumer hoards messages, others idle
- [ ] **Too low**: underutilized consumers, poor throughput

## Module 9: Heartbeats & Connection Recovery
- [ ] **Heartbeats**: periodic keep-alive to detect dead TCP connections
- [ ] **Default**: 60 seconds (negotiated between client and broker)
- [ ] **Too aggressive**: false timeouts on slow networks
- [ ] **Too lax**: slow detection of broken connections
- [ ] **Automatic recovery** (Java client, Spring AMQP):
  - [ ] Reconnect to broker automatically
  - [ ] Re-declare exchanges, queues, bindings
  - [ ] Recover consumers (resubscribe)
  - [ ] Messages in-flight during disconnect may be lost or redelivered
- [ ] **Topology recovery**: client tracks declared resources, recreates on reconnect
- [ ] **Consumer recovery**: automatic in Java client
- [ ] **Testing**: kill broker connection during test, verify client recovers

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Read AMQP 0-9-1 spec overview (rabbitmq.com/amqp-0-9-1-reference.html) |
| Module 2 | Open connection, inspect in Management UI, close cleanly |
| Module 3 | Create channel pool, use from multiple threads safely |
| Module 4 | Create 2 vhosts, test isolation between them |
| Module 5 | Publish message with properties + custom headers, inspect in consumer |
| Module 6 | Build consumer with manual ack + DLQ for failures |
| Module 7 | Enable publisher confirms with async batch tracking |
| Module 8 | Benchmark throughput with prefetch=1 vs 50 vs 500 |
| Module 9 | Kill broker during consumer operation, observe auto-recovery |

## Key Resources
- AMQP 0-9-1 Reference — rabbitmq.com/amqp-0-9-1-reference.html
- RabbitMQ documentation — Connections, Channels, Consumers
- "RabbitMQ in Depth" — Gavin Roy (Chapters 1, 5)
- Spring AMQP Reference (for Java)
