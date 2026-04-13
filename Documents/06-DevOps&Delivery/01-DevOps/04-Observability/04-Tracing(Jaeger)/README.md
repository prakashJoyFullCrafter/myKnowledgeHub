# Distributed Tracing (Jaeger & Friends) - Curriculum

## Module 1: Distributed Tracing Fundamentals
- [ ] **Distributed tracing**: follow a request across multiple services
- [ ] **Problem it solves**: "my request took 5 seconds — which service was slow?"
- [ ] **Essential for microservices**: metrics and logs don't reveal cross-service latency
- [ ] **Core concepts**:
  - [ ] **Trace**: the full journey of a request
  - [ ] **Span**: single operation (HTTP call, DB query, etc.)
  - [ ] **Parent-child**: spans form a tree
  - [ ] **Context propagation**: trace ID passed via HTTP headers, messages
- [ ] **Correlation with logs and metrics**: trace ID in logs → click through

## Module 2: Spans & Context Propagation
- [ ] **Span fields**:
  - [ ] `trace_id`: unique per request
  - [ ] `span_id`: unique per operation
  - [ ] `parent_span_id`: parent (null for root)
  - [ ] `name`: operation name (HTTP GET, SELECT)
  - [ ] `start_time`, `end_time` (duration)
  - [ ] `attributes` / `tags`: key-value metadata (http.method, db.statement)
  - [ ] `events` / `logs`: time-stamped events within a span
  - [ ] `status`: OK, ERROR, UNSET
- [ ] **W3C Trace Context**: standard HTTP headers (`traceparent`, `tracestate`)
- [ ] **B3 headers** (Zipkin): older standard (`X-B3-TraceId`, `X-B3-SpanId`)
- [ ] **Baggage**: propagate key-value pairs across services (business context)

## Module 3: Jaeger Architecture
- [ ] **Jaeger**: CNCF graduated distributed tracing system (from Uber)
- [ ] **Components**:
  - [ ] **Client libraries / OpenTelemetry SDK**: instrument apps
  - [ ] **Agent** (deprecated, use collector directly): receives spans locally
  - [ ] **Collector**: receives, processes, writes to storage
  - [ ] **Query Service**: retrieves traces
  - [ ] **UI**: web interface
- [ ] **Storage backends**:
  - [ ] Cassandra (original)
  - [ ] Elasticsearch (common)
  - [ ] Kafka (for buffering)
  - [ ] Badger (single-node, dev)
  - [ ] ClickHouse (community)
- [ ] **All-in-one**: single binary for development

## Module 4: OpenTelemetry
- [ ] **OpenTelemetry (OTel)**: CNCF incubating, merger of OpenTracing + OpenCensus
- [ ] **Vendor-neutral standard** for metrics, logs, and traces
- [ ] **Why it matters**: instrument once, send to any backend (Jaeger, Zipkin, Datadog, New Relic)
- [ ] **Components**:
  - [ ] **API**: instrumentation interface
  - [ ] **SDK**: implementation with batching, sampling
  - [ ] **Collector**: receive, process, export telemetry
  - [ ] **Auto-instrumentation**: agents that attach without code changes
- [ ] **Recommendation**: use OpenTelemetry, not vendor-specific SDKs (future-proof)
- [ ] **See OpenTelemetry dedicated module** for deep dive

## Module 5: Zipkin (Alternative)
- [ ] **Zipkin**: the original distributed tracing system (Twitter)
- [ ] **Simpler than Jaeger**: easier to run, less features
- [ ] **Supported by Spring Cloud Sleuth** (pre-Micrometer Tracing)
- [ ] **Wire format**: Zipkin v2 JSON
- [ ] **When to choose**: simpler needs, existing Spring Cloud Sleuth
- [ ] **Jaeger and Zipkin converging**: OpenTelemetry replaces both

## Module 6: Instrumentation — Spring Boot
- [ ] **Spring Boot 3 + Micrometer Tracing** (replaces Spring Cloud Sleuth)
  - [ ] `micrometer-tracing-bridge-otel` or `-bridge-brave`
  - [ ] Auto-instruments HTTP, DB, messaging
- [ ] **OpenTelemetry Java Agent**: zero-code instrumentation
  - [ ] Attach as JVM agent: `-javaagent:opentelemetry-javaagent.jar`
  - [ ] Auto-instruments 100+ libraries
- [ ] **Manual instrumentation**: create custom spans with SDK
- [ ] **Trace ID in logs**: configure log pattern to include `%X{traceId}` `%X{spanId}`
- [ ] **Propagation**: Spring automatically propagates trace context in HTTP clients, RabbitMQ/Kafka messages

## Module 7: Sampling Strategies
- [ ] **Why sample**: 100% tracing is expensive at scale
- [ ] **Head-based sampling**: decision at start of trace
  - [ ] Probabilistic: 1% of traces
  - [ ] Rate-limiting: N traces per second
  - [ ] Pros: simple, predictable cost
  - [ ] Cons: may miss interesting traces (errors, slow ones)
- [ ] **Tail-based sampling**: decide after seeing whole trace
  - [ ] Always keep errors, slow traces, rare paths
  - [ ] Requires holding traces in memory until complete
  - [ ] Done at collector level (OpenTelemetry Collector)
- [ ] **Parent-based sampling**: inherit decision from parent
- [ ] **Recommendation**: 10% head-based + 100% errors via tail sampling

## Module 8: Analyzing Traces
- [ ] **Trace waterfall view**: see each span timing
- [ ] **Critical path**: longest path from root to leaf
- [ ] **Bottlenecks**: spans with high self-time (not waiting on child)
- [ ] **Error traces**: filter for status=error
- [ ] **Span attributes**: filter by `http.status_code=500`, `db.statement`, user
- [ ] **Comparing traces**: slow vs fast traces to find regressions
- [ ] **Service dependency graph**: auto-generated from traces

## Module 9: Correlation (Metrics + Logs + Traces)
- [ ] **The three pillars**:
  - [ ] Metrics tell you WHAT is wrong (error rate spike)
  - [ ] Logs tell you WHY (exception details)
  - [ ] Traces tell you WHERE (slow service in a chain)
- [ ] **Correlation mechanisms**:
  - [ ] Include `trace_id` in all logs
  - [ ] **Exemplars**: Prometheus links histograms to trace samples
  - [ ] Grafana: click metric → logs → traces
- [ ] **Unified observability**: one tool (Datadog, Grafana stack) with cross-links

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Trace a request through 3 services using browser devtools |
| Module 3 | Install Jaeger all-in-one, view demo traces |
| Module 4 | Instrument Spring Boot with OpenTelemetry Java Agent |
| Module 5 | Compare Jaeger and Zipkin UIs with same traces |
| Module 6 | Add `traceId` to Spring Boot log pattern, verify correlation |
| Module 7 | Configure 10% sampling, test with load generator |
| Module 8 | Find a slow endpoint by analyzing trace waterfall |
| Module 9 | Set up Grafana + Loki + Tempo, click through metrics → logs → traces |

## Key Resources
- jaegertracing.io/docs
- opentelemetry.io
- "Distributed Tracing in Practice" — Austin Parker et al.
- grafana.com/oss/tempo (Tempo)
- W3C Trace Context spec
