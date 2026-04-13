# Redis Pub/Sub - Curriculum

## Module 1: Pub/Sub Fundamentals
- [ ] **Pub/Sub**: publish-subscribe messaging pattern
- [ ] **Publisher**: sends messages to a channel, doesn't know who receives
- [ ] **Subscriber**: listens to channels, receives messages from publishers
- [ ] **Channel**: named topic (string), created on first use
- [ ] **Decoupling**: publisher and subscribers don't know each other
- [ ] **Fire-and-forget**: no persistence, no acknowledgement
- [ ] **In-memory only**: messages are not stored — delivered to CURRENT subscribers only
- [ ] **Use cases**: real-time notifications, chat, cache invalidation, event broadcasting

## Module 2: Core Commands
- [ ] **Publishing**:
  - [ ] `PUBLISH channel message` — returns number of clients that received
- [ ] **Subscribing**:
  - [ ] `SUBSCRIBE channel1 channel2 ...` — subscribe to specific channels
  - [ ] `UNSUBSCRIBE [channel ...]` — unsubscribe
  - [ ] `PSUBSCRIBE pattern*` — pattern-based subscription (glob-style)
  - [ ] `PUNSUBSCRIBE pattern*`
- [ ] **Introspection**:
  - [ ] `PUBSUB CHANNELS [pattern]` — list active channels
  - [ ] `PUBSUB NUMSUB channel` — subscriber count per channel
  - [ ] `PUBSUB NUMPAT` — total pattern subscriptions
- [ ] **Subscriber mode**: once subscribed, connection is in "subscribe mode" — can only subscribe/unsubscribe/ping

## Module 3: Pattern Subscriptions (PSUBSCRIBE)
- [ ] **Glob-style patterns**: `*`, `?`, `[abc]`, `[a-z]`
- [ ] **Examples**:
  - [ ] `news.*` matches `news.sports`, `news.tech`
  - [ ] `user.*.login` matches `user.123.login`
  - [ ] `chat.room?` matches `chat.room1`, `chat.roomA`
- [ ] **Use case**: subscribe to categories without knowing exact channel names
- [ ] **Caveat**: pattern matching is O(N) in number of active channels — less efficient than exact
- [ ] **Result**: subscriber receives `pmessage` with pattern, channel, message

## Module 4: Delivery Guarantees (Or Lack Thereof)
- [ ] **At-most-once delivery**: subscriber connected at publish time receives, otherwise lost
- [ ] **No persistence**: messages NOT saved
- [ ] **No replay**: no way to get past messages
- [ ] **No ack**: publisher doesn't know if message was processed
- [ ] **Network disconnect = data loss**: subscriber reconnects → gaps
- [ ] **Slow subscriber**: messages buffered in output buffer; if buffer exceeds `client-output-buffer-limit pubsub`, subscriber is disconnected
- [ ] **Implication**: Redis Pub/Sub is NOT a reliable message queue — use Streams or an MQ for that

## Module 5: Pub/Sub vs Redis Streams
- [ ] **Redis Pub/Sub**:
  - [ ] Fire-and-forget, in-memory
  - [ ] No persistence, no replay
  - [ ] No consumer groups (all subscribers get all messages)
  - [ ] Simple, low overhead
  - [ ] Best for: transient notifications
- [ ] **Redis Streams**:
  - [ ] Persistent append-only log
  - [ ] Replay from any offset/timestamp
  - [ ] Consumer groups for load balancing
  - [ ] ACK, pending entries, auto-claim for stuck messages
  - [ ] Best for: event sourcing, reliable messaging, job queues
- [ ] **Choosing**:
  - [ ] Don't need durability, want lightweight → Pub/Sub
  - [ ] Need durability, ack, replay, consumer groups → Streams
  - [ ] Rule: Pub/Sub is OK for "fire and forget"; Streams for everything else

## Module 6: Pub/Sub vs Kafka/RabbitMQ
- [ ] **Redis Pub/Sub** is NOT a message broker — it's a thin pub/sub layer
- [ ] **Differences from Kafka**:
  - [ ] No persistence
  - [ ] No consumer groups
  - [ ] No replay
  - [ ] Much lower throughput at scale
  - [ ] No schema management
- [ ] **Differences from RabbitMQ**:
  - [ ] No exchanges/routing flexibility
  - [ ] No ack/redelivery
  - [ ] No DLQ
  - [ ] No priority queues
- [ ] **When Redis Pub/Sub is appropriate**:
  - [ ] Already using Redis
  - [ ] Low-volume, non-critical notifications
  - [ ] Cache invalidation broadcast
  - [ ] Simple, lightweight signaling
- [ ] **When to use a real broker**: reliability, scale, routing complexity

## Module 7: Sharded Pub/Sub (Cluster Mode)
- [ ] **Problem**: in Redis Cluster, Pub/Sub messages are broadcast to ALL nodes
  - [ ] Doesn't scale for high-volume publishing
  - [ ] Wastes inter-node bandwidth
- [ ] **Sharded Pub/Sub** (Redis 7+):
  - [ ] `SPUBLISH`, `SSUBSCRIBE`, `SUNSUBSCRIBE`
  - [ ] Messages only routed to node owning the channel's hash slot
  - [ ] Scales linearly with cluster size
  - [ ] Subscribers must connect to correct node for their channel
- [ ] **Use case**: high-volume pub/sub on Redis Cluster
- [ ] **Trade-off**: can't subscribe to all channels from one node

## Module 8: Common Use Cases
- [ ] **Cache invalidation broadcast**:
  - [ ] Service updates DB → publishes `cache.invalidate.users`
  - [ ] All app instances subscribe → invalidate their L1 caches
- [ ] **Real-time notifications**:
  - [ ] User posts → publish `notifications.user.123`
  - [ ] WebSocket server subscribed → pushes to browser
- [ ] **Chat systems**:
  - [ ] One channel per room: `chat.room.42`
  - [ ] WebSocket server subscribes per room
- [ ] **Config hot reload**:
  - [ ] Admin updates config → publishes `config.updated`
  - [ ] Services re-fetch config
- [ ] **Cross-service events** (low-volume):
  - [ ] Microservice A publishes → Microservice B reacts
  - [ ] Only for non-critical events (no guarantees)
- [ ] **Server-Sent Events (SSE) backend**:
  - [ ] HTTP server subscribes, forwards to SSE stream

## Module 9: Spring Data Redis Integration
- [ ] **`RedisMessageListenerContainer`**: manages subscriptions
- [ ] **`MessageListener`** / **`MessageListenerAdapter`**: handle incoming messages
- [ ] **Publishing**: `redisTemplate.convertAndSend(channel, message)`
- [ ] **Example**:
  ```
  @Bean
  RedisMessageListenerContainer container(RedisConnectionFactory cf, MessageListener listener) {
      var container = new RedisMessageListenerContainer();
      container.setConnectionFactory(cf);
      container.addMessageListener(listener, new PatternTopic("news.*"));
      return container;
  }
  ```
- [ ] **Serialization**: configure message serializer (JSON) on listener
- [ ] **Threading**: messages processed on listener thread pool (configure for concurrency)

## Module 10: Pitfalls & Anti-Patterns
- [ ] **Using Pub/Sub for critical events**: messages lost on disconnect
  - [ ] Fix: use Streams with consumer groups
- [ ] **Slow subscriber**: output buffer overflow → disconnected
  - [ ] Fix: faster processing, or use Streams with pull model
- [ ] **Pattern subscriptions at scale**: O(N) matching per publish
  - [ ] Fix: prefer exact channels, or use sharded pub/sub
- [ ] **Treating Pub/Sub as a queue**: no ordering guarantees across channels, no durability
- [ ] **Not monitoring subscriber count**: silent failures when subscribers disconnect
- [ ] **Pub/Sub in Redis Cluster (pre-7)**: all nodes broadcast → network amplification
  - [ ] Fix: use sharded pub/sub (Redis 7+)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build publisher and subscriber with `redis-cli` |
| Module 3 | Use pattern subscription to receive categorized events |
| Module 4 | Disconnect subscriber mid-stream, observe message loss |
| Module 5 | Rebuild same feature with Pub/Sub vs Streams, compare reliability |
| Module 6 | Decide Pub/Sub vs RabbitMQ for 3 use cases |
| Module 7 | Enable sharded pub/sub in Redis 7 cluster, measure scalability |
| Module 8 | Build cache invalidation broadcast for multi-instance app |
| Module 9 | Implement pub/sub with Spring Data Redis and JSON messages |
| Module 10 | Identify Pub/Sub anti-patterns in a sample architecture |

## Key Resources
- redis.io/docs/interact/pubsub/
- redis.io/commands/subscribe/
- "Redis in Action" — Chapter 3 (Messaging)
- Spring Data Redis Pub/Sub documentation
