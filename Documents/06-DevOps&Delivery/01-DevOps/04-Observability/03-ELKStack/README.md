# ELK Stack (Elasticsearch, Logstash, Kibana) - Curriculum

## Module 1: ELK / Elastic Stack Overview
- [ ] **ELK Stack**: Elasticsearch + Logstash + Kibana
- [ ] **Elastic Stack**: ELK + Beats (data shippers) — the modern name
- [ ] **Primary use case**: log aggregation, search, analysis
- [ ] **Also used for**: application search, APM, security analytics (SIEM)
- [ ] **License**: Elastic changed to non-OSI licenses (ELv2, SSPL) in 2021
- [ ] **Fork**: OpenSearch (AWS fork) — open source alternative

## Module 2: Elasticsearch Fundamentals
- [ ] **Elasticsearch**: distributed search and analytics engine built on Lucene
- [ ] **Document**: JSON unit of data
- [ ] **Index**: collection of documents (like a table)
- [ ] **Shard**: subset of an index, distributed across nodes
- [ ] **Replica**: copy of a primary shard for HA and read scaling
- [ ] **Node**: single Elasticsearch instance
- [ ] **Cluster**: set of nodes working together
- [ ] **REST API**: all interactions are HTTP JSON
- [ ] **Inverted index**: internal data structure for fast text search
- [ ] **Scoring**: BM25 (default) for relevance ranking

## Module 3: Index Management & Mappings
- [ ] **Mapping**: schema for an index (field types, analyzers)
- [ ] **Dynamic mapping**: inferred from first document (convenient, can mislead)
- [ ] **Explicit mapping**: define before use (recommended for production)
- [ ] **Field types**: `text` (analyzed), `keyword` (exact), `date`, `long`, `nested`, `geo_point`
- [ ] **Analyzers**: tokenizer + filters for text fields
- [ ] **Index templates**: auto-apply mapping to matching indices
- [ ] **Index Lifecycle Management (ILM)**: automate rollover, retention
  - [ ] Hot → Warm → Cold → Delete phases
  - [ ] Rollover on size/age/doc count

## Module 4: Logstash
- [ ] **Logstash**: data processing pipeline
- [ ] **Three stages**: Input → Filter → Output
- [ ] **Inputs**: file, syslog, Kafka, Beats, HTTP, S3, TCP, UDP
- [ ] **Filters**: parse and transform
  - [ ] `grok`: pattern matching for unstructured text
  - [ ] `mutate`: rename, convert, strip fields
  - [ ] `date`: parse timestamps
  - [ ] `json`: parse JSON payloads
  - [ ] `geoip`: enrich IPs with geo data
- [ ] **Outputs**: Elasticsearch, Kafka, S3, file
- [ ] **Pipeline config**: `.conf` files in Logstash config dir
- [ ] **Heavy**: Logstash is resource-intensive (JVM); consider lightweight alternatives

## Module 5: Beats (Lightweight Shippers)
- [ ] **Beats**: small, single-purpose shippers
- [ ] **Filebeat**: ship log files
- [ ] **Metricbeat**: ship system/service metrics
- [ ] **Packetbeat**: network traffic analysis
- [ ] **Heartbeat**: uptime monitoring
- [ ] **Auditbeat**: audit logs from Linux
- [ ] **Winlogbeat**: Windows event logs
- [ ] **Why Beats over Logstash**: lightweight, per-host, less resource use
- [ ] **Pattern**: Beats → Logstash (optional) → Elasticsearch

## Module 6: Kibana
- [ ] **Kibana**: UI for Elastic Stack
- [ ] **Features**:
  - [ ] Discover: search and filter documents
  - [ ] Visualizations: graphs, charts, maps
  - [ ] Dashboards: collections of visualizations
  - [ ] Dev Tools: console for raw Elasticsearch queries
  - [ ] Machine Learning (paid)
  - [ ] APM UI (for Elastic APM)
- [ ] **KQL (Kibana Query Language)**: simple search syntax
  - [ ] `level:error`, `status:>=500`, `service:api and method:POST`
- [ ] **Lucene syntax**: more powerful alternative (`status:[500 TO 599]`)
- [ ] **Index patterns**: tell Kibana which indices to search

## Module 7: Structured Logging
- [ ] **Why structured**: JSON logs are queryable, not just searchable
- [ ] **Bad**: `2024-01-15 ERROR Failed to process order 123`
- [ ] **Good**: `{"level":"ERROR","timestamp":"...","msg":"Failed to process order","order_id":123}`
- [ ] **Spring Boot**: Logback with `LogstashEncoder`
- [ ] **Key fields**:
  - [ ] `timestamp`, `level`, `service`, `trace_id`, `span_id`
  - [ ] `user_id`, `request_id`, relevant business fields
- [ ] **Correlation**: `trace_id` links logs to distributed traces
- [ ] **Avoid**: multi-line logs (stack traces) — configure shipper to combine

## Module 8: Performance & Scaling
- [ ] **Shard sizing**: 10-50 GB per shard as guideline
- [ ] **Number of shards**: set at index creation, can't change later (except with rollover)
- [ ] **Replica count**: adjustable, default 1
- [ ] **Heap size**: 50% of RAM, max 31 GB (JVM compressed oops)
- [ ] **Hot-warm-cold architecture**:
  - [ ] Hot nodes: SSDs, recent data
  - [ ] Warm/cold nodes: cheaper disks, older data
- [ ] **Bulk API**: batch indexing for throughput
- [ ] **Search optimization**: request caching, query optimization

## Module 9: ELK vs Loki vs Alternatives
- [ ] **ELK pros**: mature, powerful search, SIEM features, Kibana UX
- [ ] **ELK cons**: expensive (hardware), complex ops, license concerns
- [ ] **Loki** (Grafana): lightweight, label-based indexing (like Prometheus for logs)
  - [ ] Much cheaper, simpler ops
  - [ ] Less powerful full-text search
- [ ] **OpenSearch**: Apache 2.0 fork of Elasticsearch (AWS-led)
- [ ] **ClickHouse**: columnar DB, increasingly used for logs
- [ ] **Cloud-native**: CloudWatch Logs, Google Cloud Logging, Datadog
- [ ] **Choosing**: ELK for powerful search, Loki for simplicity + cost

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Install ELK via Docker Compose, index first documents |
| Module 3 | Create explicit mapping, configure ILM |
| Module 4 | Write Logstash config to parse Apache logs with grok |
| Module 5 | Deploy Filebeat to ship container logs |
| Module 6 | Build Kibana dashboard with logs visualization |
| Module 7 | Convert a Spring Boot app to JSON logging |
| Module 8 | Size Elasticsearch cluster for 500 GB/day ingest |
| Module 9 | Compare ELK vs Loki for your workload |

## Key Resources
- elastic.co/guide (official)
- OpenSearch documentation (opensearch.org)
- "Elasticsearch: The Definitive Guide" (older but still useful)
- grafana.com/loki (Loki)
- Elastic Stack tutorials
