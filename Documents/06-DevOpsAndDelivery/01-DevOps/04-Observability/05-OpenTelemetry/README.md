# OpenTelemetry - Curriculum

The vendor-neutral standard for observability instrumentation.

---

## Module 1: What is OpenTelemetry?
- [ ] **OpenTelemetry (OTel)**: CNCF incubating project, merger of OpenTracing + OpenCensus
- [ ] **Goal**: one standard for metrics, logs, and traces — vendor-neutral
- [ ] **Why it matters**: instrument once, send to any backend
- [ ] **Three signals**:
  - [ ] **Traces**: distributed request flows
  - [ ] **Metrics**: numerical measurements
  - [ ] **Logs**: structured events
- [ ] **Status**:
  - [ ] Traces: stable
  - [ ] Metrics: stable
  - [ ] Logs: stable (recently)
- [ ] **Not a backend**: OTel is instrumentation + collection; store with Jaeger, Prometheus, Tempo, Elastic, Datadog, etc.

## Module 2: Core Concepts
- [ ] **API**: the interface your code uses (stable contract)
- [ ] **SDK**: implementation with batching, sampling, exporters
- [ ] **Exporter**: sends telemetry to a backend (OTLP, Jaeger, Zipkin, Prometheus)
- [ ] **Instrumentation**: automatic (agents) or manual (code)
- [ ] **OTLP (OpenTelemetry Protocol)**: gRPC/HTTP wire format for telemetry
- [ ] **Resource**: attributes describing the entity producing telemetry (service.name, host, region)
- [ ] **Context**: carries trace context across boundaries
- [ ] **Propagator**: serializes context to headers (W3C Trace Context default)

## Module 3: Traces
- [ ] **Trace**: a tree of spans representing a request
- [ ] **Span**: single unit of work
  - [ ] Name, start time, end time, status
  - [ ] Attributes (key-value metadata)
  - [ ] Events (time-stamped)
  - [ ] Links (to other spans)
  - [ ] Status: OK, ERROR, UNSET
- [ ] **Parent-child**: `SpanContext` passed to child
- [ ] **Span kind**: SERVER, CLIENT, PRODUCER, CONSUMER, INTERNAL
- [ ] **Semantic conventions**: standard attribute names (`http.method`, `db.system`, `messaging.system`)

## Module 4: Metrics
- [ ] **Instrument types**:
  - [ ] **Counter**: monotonically increasing
  - [ ] **UpDownCounter**: can go up or down
  - [ ] **Gauge**: current value (observable)
  - [ ] **Histogram**: distributions (durations, sizes)
- [ ] **Synchronous vs asynchronous**:
  - [ ] Sync: called from user code (counter.add(1))
  - [ ] Async: callback invoked on collection (gauge observation)
- [ ] **Attributes**: dimensions for slicing (similar to Prometheus labels)
- [ ] **Aggregation**: sum, last value, histogram buckets
- [ ] **Export**: push to OTLP backend or pull (Prometheus-compatible endpoint)

## Module 5: Logs
- [ ] **Log bridge**: OTel doesn't replace log frameworks, bridges them
- [ ] **Structured logs**: key-value pairs, not just strings
- [ ] **Correlation**: automatically include `trace_id`, `span_id`
- [ ] **Log records**: timestamp, severity, body, attributes, trace context
- [ ] **Transport**: OTLP to collector
- [ ] **Integration**: Logback/Log4j/SLF4J (Java), structlog (Python), pino (Node)

## Module 6: OpenTelemetry Collector
- [ ] **Collector**: standalone agent/daemon that receives, processes, and exports telemetry
- [ ] **Why**:
  - [ ] Decouple applications from backends
  - [ ] Centralized batching, sampling
  - [ ] Protocol translation (receive from X, export to Y)
  - [ ] Data enrichment
- [ ] **Architecture**: receivers → processors → exporters
- [ ] **Deployments**:
  - [ ] **Agent mode**: sidecar or daemonset per host
  - [ ] **Gateway mode**: cluster-level, receives from agents
- [ ] **Receivers**: OTLP, Jaeger, Zipkin, Prometheus, Fluent, host metrics
- [ ] **Processors**: batch, memory limiter, attributes, tail sampling, transform
- [ ] **Exporters**: OTLP, Jaeger, Prometheus, Loki, Elastic, Datadog, cloud providers
- [ ] **Two distributions**:
  - [ ] `otelcol` (core): minimal components
  - [ ] `otelcol-contrib` (contrib): everything

## Module 7: Auto-Instrumentation
- [ ] **Goal**: observability without code changes
- [ ] **Java Agent**:
  - [ ] `-javaagent:opentelemetry-javaagent.jar`
  - [ ] Instruments 100+ libraries automatically
  - [ ] JDBC, HTTP clients, Servlet, gRPC, messaging, etc.
- [ ] **Operator for Kubernetes**: inject agents into pods via annotation
- [ ] **Node.js, Python**: auto-instrumentation packages
- [ ] **Go**: manual instrumentation only (no agent possible)
- [ ] **When auto isn't enough**: custom spans for business logic

## Module 8: Manual Instrumentation (Java)
- [ ] **Dependencies**: `opentelemetry-api`, `opentelemetry-sdk`, exporter
- [ ] **Get tracer**:
  ```java
  Tracer tracer = GlobalOpenTelemetry.getTracer("my.instrumentation");
  Span span = tracer.spanBuilder("processOrder").startSpan();
  try (Scope scope = span.makeCurrent()) {
      span.setAttribute("order.id", orderId);
      // work...
  } finally {
      span.end();
  }
  ```
- [ ] **Metrics**:
  ```java
  Meter meter = GlobalOpenTelemetry.getMeter("my.metrics");
  LongCounter counter = meter.counterBuilder("orders_total").build();
  counter.add(1);
  ```
- [ ] **Context propagation**: `TextMapPropagator` for HTTP headers

## Module 9: Sampling Strategies
- [ ] **Head-based sampling**: decision at start of trace
  - [ ] Probabilistic (1%), rate-limiting
  - [ ] Simple, predictable cost
- [ ] **Tail-based sampling**: decision after full trace seen
  - [ ] Keep errors, slow traces, rare patterns
  - [ ] Done at Collector (needs buffering)
- [ ] **Parent-based**: inherit from parent decision (recommended for distributed)
- [ ] **Always on** for errors: custom sampler that always samples on error
- [ ] **Budget**: pair with head-based sampling for cost control

## Module 10: Backend Choices
- [ ] **Traces**: Jaeger, Tempo, Zipkin, Datadog, New Relic, Honeycomb
- [ ] **Metrics**: Prometheus (via OTLP gateway), Mimir, InfluxDB, commercial APMs
- [ ] **Logs**: Loki, Elasticsearch, commercial APMs
- [ ] **Unified**: Grafana stack (Tempo + Mimir + Loki), Datadog, New Relic
- [ ] **Vendor lock-in avoidance**: OTel is your escape hatch — swap backends without re-instrumenting

## Module 11: Migration from Vendor SDKs
- [ ] **Legacy SDKs**:
  - [ ] Jaeger client libraries (deprecated in favor of OTel)
  - [ ] Zipkin clients
  - [ ] Datadog APM agent
- [ ] **Migration strategy**:
  - [ ] Run both in parallel initially
  - [ ] Replace library calls gradually
  - [ ] Use OTel Collector to bridge (receive Jaeger, export to OTLP)
- [ ] **Benefits**:
  - [ ] Multi-backend support
  - [ ] Active development (Jaeger/Zipkin clients frozen)
  - [ ] Broader instrumentation coverage

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Read OTel spec overview, understand components |
| Module 3 | Create manual trace with 3 nested spans in Java |
| Module 4 | Add counter, histogram to Spring Boot app |
| Module 5 | Configure Logback to include trace context |
| Module 6 | Deploy OpenTelemetry Collector with batch processor |
| Module 7 | Instrument Spring Boot with Java Agent, observe traces |
| Module 8 | Add custom spans around business logic |
| Module 9 | Configure tail-based sampling in Collector (keep errors) |
| Module 10 | Send same traces to Jaeger and Tempo, compare |
| Module 11 | Migrate a Jaeger-instrumented app to OTel |

## Key Resources
- opentelemetry.io (official)
- OpenTelemetry specification (github.com/open-telemetry/opentelemetry-specification)
- "OpenTelemetry Cookbook" — various
- opentelemetry.io/docs/languages/ (per-language docs)
- CNCF observability landscape
