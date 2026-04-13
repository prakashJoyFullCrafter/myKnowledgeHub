# Schema Registry - Curriculum

## Module 1: Why Schema Registry?
- [ ] **Problem without schemas**: producers send garbage → consumers break
- [ ] **Data contract**: producer and consumer must agree on message structure
- [ ] Schema Registry: centralized store for schemas, enforces compatibility rules
- [ ] Benefits: type safety, compact binary format, schema evolution, documentation
- [ ] Prevents "poison pills" at source — bad schemas rejected before write
- [ ] Critical for multi-team organizations with many producers/consumers
- [ ] **Alternatives**: Confluent Schema Registry, AWS Glue Schema Registry, Apicurio

## Module 2: Schema Formats
- [ ] **Avro** (most common):
  - [ ] JSON schema definition, binary wire format
  - [ ] Compact: no field names in wire format
  - [ ] Strong schema evolution support
  - [ ] Requires schema to deserialize (fetched from registry)
- [ ] **Protobuf**:
  - [ ] `.proto` files, binary wire format
  - [ ] Compact, fast, widely adopted (gRPC)
  - [ ] Numbered fields for evolution
- [ ] **JSON Schema**:
  - [ ] Human-readable, larger size
  - [ ] Easier debugging, wider tool support
- [ ] **Format choice**: Avro for Kafka-native, Protobuf for polyglot, JSON for debuggability

## Module 3: How It Works (Wire Protocol)
- [ ] Producer serializes → sends schema to registry → gets schema ID
- [ ] Message wire format: `[magic byte][schema ID: 4 bytes][payload: binary]`
- [ ] Consumer reads message → extracts schema ID → fetches schema from registry (cached)
- [ ] Deserializes payload using schema
- [ ] **First message**: registry lookup, then cached per producer/consumer
- [ ] Registry is eventually consistent — caching reduces load
- [ ] **Kafka serializer**: `KafkaAvroSerializer` (handles registration + wire format)

## Module 4: Compatibility Modes
- [ ] **BACKWARD** (default): new schema can READ data written with old schema
  - [ ] Safe changes: add optional field, remove field, widen type
  - [ ] Consumer upgraded first, then producer
- [ ] **BACKWARD_TRANSITIVE**: new schema compatible with ALL previous versions
- [ ] **FORWARD**: old schema can READ data written with new schema
  - [ ] Safe changes: delete optional field, add field (if ignored by old schema)
  - [ ] Producer upgraded first, then consumer
- [ ] **FORWARD_TRANSITIVE**: forward with all previous versions
- [ ] **FULL**: both backward AND forward (strictest)
- [ ] **FULL_TRANSITIVE**: full with all previous versions
- [ ] **NONE**: no compatibility check — use with extreme caution
- [ ] Compatibility set per subject or globally

## Module 5: Schema Evolution Rules
- [ ] **Avro rules for backward compatibility**:
  - [ ] Add field with default → OK
  - [ ] Remove field that had a default → OK
  - [ ] Rename field → NOT OK (use aliases)
  - [ ] Change type → only if widening (int → long)
  - [ ] Change field order → OK (positional)
- [ ] **Default values**: always provide defaults for new fields
- [ ] **Nullable fields**: use unions `["null", "string"]` for optional
- [ ] **Aliases**: `{"aliases": ["OldName"]}` for renames
- [ ] **Testing**: validate compatibility in CI before deploying

## Module 6: Subject Naming Strategies
- [ ] **TopicNameStrategy** (default): `<topic>-key`, `<topic>-value`
  - [ ] One schema per topic, simplest
- [ ] **RecordNameStrategy**: `<fully.qualified.record.name>`
  - [ ] Multiple event types per topic (union of schemas)
- [ ] **TopicRecordNameStrategy**: `<topic>-<record.name>`
  - [ ] Multiple event types per topic, scoped to topic
- [ ] **Choosing**: TopicName for single-schema topics, TopicRecordName for event envelope pattern
- [ ] `value.subject.name.strategy` config

## Module 7: Operations & Governance
- [ ] **REST API**:
  - [ ] `GET /subjects` — list all subjects
  - [ ] `GET /subjects/{name}/versions` — list versions
  - [ ] `GET /subjects/{name}/versions/{version}` — fetch schema
  - [ ] `POST /subjects/{name}/versions` — register new version
  - [ ] `GET /compatibility/subjects/{name}/versions/{version}` — check compatibility
- [ ] **Schema validation in CI**: test new schema against registry before merge
- [ ] **Breaking changes workflow**:
  - [ ] New topic with `.v2` suffix
  - [ ] Run parallel consumers during migration
  - [ ] Retire old topic once migrated
- [ ] **Security**: RBAC on registry, subject-level permissions
- [ ] **HA**: run multiple registry instances behind load balancer
- [ ] **Backup**: registry data stored in `_schemas` Kafka topic — backup that topic

## Module 8: Integration with Clients & Streams
- [ ] **Producer config**:
  - [ ] `schema.registry.url=http://registry:8081`
  - [ ] `key.serializer=KafkaAvroSerializer`, `value.serializer=KafkaAvroSerializer`
  - [ ] `auto.register.schemas=false` (production) — forces pre-registration
- [ ] **Consumer config**: similar deserializers, specific vs generic record
  - [ ] `specific.avro.reader=true` for generated classes
- [ ] **Kafka Streams**: `SpecificAvroSerde` / `GenericAvroSerde`
- [ ] **ksqlDB**: uses Schema Registry automatically
- [ ] **Kafka Connect**: `AvroConverter` with Schema Registry URL

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up Confluent Schema Registry, register Avro schema via REST API |
| Module 3 | Produce Avro message, inspect wire format (magic byte + schema ID + payload) |
| Module 4 | Test each compatibility mode with schema changes, observe pass/fail |
| Module 5 | Evolve schema: add field with default, remove field, try incompatible change |
| Module 6 | Use TopicRecordNameStrategy for multi-event-type topic |
| Module 7 | Validate schema compatibility in CI pipeline before merge |
| Module 8 | Build producer/consumer with generated Avro classes |

## Key Resources
- Confluent Schema Registry documentation
- "Schema Evolution in Avro, Protocol Buffers and Thrift" — Martin Kleppmann
- Apache Avro specification
- "Putting Apache Kafka to Use: A Practical Guide to Building a Stream Data Platform" — Confluent
