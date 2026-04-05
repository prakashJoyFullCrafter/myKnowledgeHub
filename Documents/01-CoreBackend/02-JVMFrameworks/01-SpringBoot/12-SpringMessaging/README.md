# Spring Messaging - Curriculum

## Module 1: Spring Kafka
- [ ] `spring-kafka` dependency and auto-configuration
- [ ] `KafkaTemplate` - producing messages
- [ ] `@KafkaListener` - consuming messages
- [ ] Serialization: `StringSerializer`, `JsonSerializer`, Avro
- [ ] Consumer groups and concurrency
- [ ] Error handling: `DefaultErrorHandler`, `DeadLetterPublishingRecoverer`
- [ ] `@RetryableTopic` for automatic retry with backoff
- [ ] Batch listener mode
- [ ] Transactional Kafka (`@Transactional` with Kafka)
- [ ] Testing with `@EmbeddedKafka`

## Module 2: Spring AMQP (RabbitMQ)
- [ ] `spring-boot-starter-amqp` dependency
- [ ] `RabbitTemplate` - producing messages
- [ ] `@RabbitListener` - consuming messages
- [ ] Exchange, Queue, Binding declarations with `@Bean`
- [ ] Direct, Fanout, Topic exchange configuration
- [ ] Message conversion: `Jackson2JsonMessageConverter`
- [ ] Retry and DLQ configuration
- [ ] Publisher confirms and consumer acknowledgements
- [ ] Testing with `@RabbitListenerTest`

## Module 3: Spring JMS
- [ ] `JmsTemplate` for producing
- [ ] `@JmsListener` for consuming
- [ ] ActiveMQ / Artemis integration
- [ ] JMS vs AMQP vs Kafka comparison

## Module 4: Spring Events (Internal Messaging)
- [ ] `ApplicationEvent` and `ApplicationEventPublisher`
- [ ] `@EventListener` annotation
- [ ] `@Async` event listeners (non-blocking)
- [ ] `@TransactionalEventListener` - fire after commit
- [ ] Event ordering with `@Order`
- [ ] When to use events vs messaging brokers

## Module 5: Patterns & Best Practices
- [ ] Outbox pattern with Spring (transactional messaging)
- [ ] Idempotent consumers (deduplication)
- [ ] Message ordering guarantees
- [ ] Poison message handling
- [ ] Monitoring messaging with Micrometer
- [ ] Saga orchestration with messaging

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Order service producing events, notification service consuming |
| Module 2 | Task queue with RabbitMQ: producer -> worker -> result |
| Module 3 | Internal event system: order created -> email + inventory events |
| Module 5 | Implement outbox pattern for reliable messaging |

## Key Resources
- Spring for Apache Kafka Reference
- Spring AMQP Reference
- Enterprise Integration Patterns - Hohpe & Woolf
