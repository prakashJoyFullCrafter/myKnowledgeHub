# Kafka Connect - Curriculum

## Module 1: Kafka Connect Fundamentals
- [ ] What is Kafka Connect? Framework for streaming data between Kafka and external systems
- [ ] **Source connectors**: external system → Kafka (e.g., database → Kafka topic)
- [ ] **Sink connectors**: Kafka → external system (e.g., Kafka topic → Elasticsearch)
- [ ] No custom code: declarative configuration with JSON
- [ ] Connect workers: standalone mode vs distributed mode
- [ ] Distributed mode: fault-tolerant, scalable, auto-rebalancing across workers

## Module 2: Source Connectors
- [ ] **Debezium** (CDC): capture database changes as events
  - [ ] Debezium PostgreSQL: reads WAL (Write-Ahead Log) for real-time change capture
  - [ ] Debezium MySQL: reads binlog
  - [ ] Event format: before/after state, operation type (c/u/d), metadata
  - [ ] Outbox Event Router: transform outbox table changes into clean domain events
- [ ] **JDBC Source Connector**: poll database table for new/updated rows
  - [ ] Incrementing mode, timestamp mode, timestamp+incrementing mode
  - [ ] Simpler than Debezium but not real-time (polling interval)
- [ ] **FileStream Source**: file → Kafka (demo/testing only)
- [ ] Other sources: S3, MongoDB, MQTT, HTTP

## Module 3: Sink Connectors
- [ ] **JDBC Sink Connector**: Kafka → database (insert/upsert)
- [ ] **Elasticsearch Sink**: Kafka → Elasticsearch for search indexing
- [ ] **S3 Sink**: Kafka → S3 for data lake / archival
- [ ] **MongoDB Sink**: Kafka → MongoDB
- [ ] **BigQuery/Redshift Sink**: Kafka → data warehouse
- [ ] Error handling: `errors.tolerance=all`, dead letter queue for failed records
- [ ] Exactly-once sink delivery with idempotent writes

## Module 4: Transforms & Configuration
- [ ] **Single Message Transforms (SMTs)**: modify messages in-flight without code
  - [ ] `RenameField`, `InsertField`, `ReplaceField`, `TimestampRouter`
  - [ ] `ExtractField`, `MaskField`, `Filter`
  - [ ] Chaining multiple SMTs
- [ ] Converter configuration: `JsonConverter`, `AvroConverter`, `ProtobufConverter`
  - [ ] `key.converter` and `value.converter`
  - [ ] Schema Registry integration with Avro converter
- [ ] Connector configuration: `tasks.max`, `poll.interval.ms`, `batch.size`
- [ ] REST API: create, update, pause, resume, delete connectors
  - [ ] `POST /connectors`, `GET /connectors/{name}/status`, `PUT /connectors/{name}/pause`

## Module 5: Operations & Monitoring
- [ ] Deploying Connect cluster: Docker, Kubernetes, Confluent Cloud
- [ ] Connector plugins: install, plugin path configuration
- [ ] Monitoring: JMX metrics, Prometheus exporter, Confluent Control Center
- [ ] Key metrics: connector status, task status, offset lag, error rate
- [ ] Dead letter queue for sink failures: `errors.deadletterqueue.topic.name`
- [ ] Schema evolution with Connect: backward/forward compatibility
- [ ] Connect vs custom consumer/producer: when Connect is enough vs when you need code

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up Debezium PostgreSQL source: capture table changes into Kafka topic |
| Module 3 | JDBC Sink: replicate Kafka events into a read-optimized database |
| Module 4 | Chain SMTs: rename fields, add timestamp, route to different topics |
| Module 5 | Deploy Connect in Docker, monitor connector health with REST API |

## Key Resources
- Kafka Connect documentation (kafka.apache.org)
- Debezium documentation (debezium.io)
- Confluent Hub — connector marketplace
- "Kafka Connect Deep Dive" — Confluent blog
