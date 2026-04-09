# RabbitMQ Spring Integration - Curriculum

## Module 1: Setup & RabbitTemplate
- [ ] `spring-boot-starter-amqp` dependency
- [ ] Auto-configuration: `spring.rabbitmq.host`, `port`, `username`, `password`
- [ ] **`RabbitTemplate`** — primary API for sending messages
  - [ ] `convertAndSend(exchange, routingKey, message)` — send with routing
  - [ ] `convertAndSend(queueName, message)` — send to default exchange
  - [ ] `convertSendAndReceive()` — synchronous RPC (request-reply)
- [ ] **`MessageConverter`**: Jackson2JsonMessageConverter (recommended over Java serialization)
- [ ] Connection factory: `CachingConnectionFactory`, channel caching, connection pooling

## Module 2: @RabbitListener
- [ ] `@RabbitListener(queues = "orders")` — consume from queue
- [ ] Message deserialization: automatic JSON → POJO with Jackson converter
- [ ] `@RabbitListener` with multiple queues: `queues = {"queue1", "queue2"}`
- [ ] `@RabbitHandler` — method-level routing by payload type
- [ ] Concurrency: `concurrency = "3-10"` — min-max consumer threads
- [ ] `@Payload` and `@Header` — access message body and headers separately
- [ ] Manual acknowledgment: `Channel channel`, `@Header(AmqpHeaders.DELIVERY_TAG) long tag`
  - [ ] `channel.basicAck(tag, false)` — acknowledge
  - [ ] `channel.basicNack(tag, false, true)` — reject and requeue

## Module 3: Exchange, Queue & Binding Declaration
- [ ] Declare with `@Bean`:
  - [ ] `new DirectExchange("orders")`, `new TopicExchange("events")`, `new FanoutExchange("notifications")`
  - [ ] `new Queue("order-queue", true)` — durable queue
  - [ ] `BindingBuilder.bind(queue).to(exchange).with("order.created")`
- [ ] `@RabbitListener` auto-declares: `@QueueBinding(value = @Queue("myQueue"), exchange = @Exchange("myExchange"), key = "routing.key")`
- [ ] Declarative vs programmatic binding — when to use each

## Module 4: Error Handling & Retry
- [ ] `SimpleRabbitListenerContainerFactory` — configure retry, concurrency, acknowledgment
- [ ] **Retry**: `RetryTemplate` with backoff policy
  - [ ] `spring.rabbitmq.listener.simple.retry.enabled=true`
  - [ ] `max-attempts`, `initial-interval`, `multiplier`, `max-interval`
- [ ] **Dead Letter Queue**: configure DLX on queue, failed messages routed automatically
  - [ ] `@Bean Queue("orders") { ... args.put("x-dead-letter-exchange", "dlx"); }`
- [ ] `RepublishMessageRecoverer` — send to error queue after retry exhaustion
- [ ] Error handling: `@RabbitListener` `errorHandler` attribute
- [ ] Idempotent consumers: deduplication with message ID header

## Module 5: Advanced Patterns
- [ ] **Publisher confirms**: `rabbitTemplate.setConfirmCallback()` — guarantee broker received message
- [ ] **Publisher returns**: `rabbitTemplate.setReturnsCallback()` — unroutable message notification
- [ ] **Request-reply (RPC)**: `convertSendAndReceive()` with `replyTo` queue
- [ ] **Delayed messages**: `x-delayed-message` exchange plugin
- [ ] **Priority queues**: `x-max-priority` queue argument
- [ ] **Spring Cloud Stream** with RabbitMQ binder: `Function`/`Consumer`/`Supplier` programming model
- [ ] Monitoring: RabbitMQ Management Plugin, Spring Boot Actuator health indicator

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build order producer + notification consumer with JSON messages |
| Module 3 | Declare topic exchange with multiple queues bound by routing key pattern |
| Module 4 | Configure retry with DLQ: simulate processing failure, verify DLQ routing |
| Module 5 | Implement publisher confirms + request-reply RPC pattern |

## Key Resources
- Spring AMQP Reference Documentation
- RabbitMQ Tutorials (rabbitmq.com/getstarted)
- Spring Boot RabbitMQ auto-configuration reference
