# Outbox Pattern - Curriculum

## Topics
- [ ] Problem: dual writes (database + message broker) inconsistency
- [ ] Solution: write event to outbox table in same DB transaction
- [ ] Polling publisher: poll outbox table, publish to broker, mark as sent
- [ ] Transaction log tailing: CDC (Change Data Capture) with Debezium
- [ ] Outbox table schema: id, aggregate_type, event_type, payload, created_at, sent_at
- [ ] Idempotent consumers (handle duplicate events)
- [ ] Debezium + Kafka Connect for outbox
- [ ] Spring-native outbox implementations
