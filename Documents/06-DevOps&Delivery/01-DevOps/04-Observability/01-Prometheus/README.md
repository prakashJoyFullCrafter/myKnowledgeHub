# Prometheus - Curriculum

## Module 1: Prometheus Fundamentals
- [ ] **Prometheus**: open-source monitoring and alerting toolkit
- [ ] **CNCF graduated project** — de facto standard for metrics
- [ ] **Core design**:
  - [ ] **Pull-based**: Prometheus scrapes metrics from targets
  - [ ] **Time-series database**: stores samples with timestamps
  - [ ] **Multi-dimensional data model**: metrics + labels
  - [ ] **PromQL**: powerful query language
  - [ ] **Service discovery**: dynamic target lookup
- [ ] **Pull vs push**:
  - [ ] Pull (Prometheus): central control, easy health checks, firewall-friendly
  - [ ] Push (StatsD): short-lived jobs, no inbound connections
  - [ ] Prometheus **Pushgateway** for short-lived jobs (use sparingly)

## Module 2: Data Model
- [ ] **Metric**: identified by name + labels
  - [ ] Example: `http_requests_total{method="GET", status="200", path="/api"}`
- [ ] **Metric name**: what's being measured (`http_requests_total`)
- [ ] **Labels**: key-value dimensions (`method=GET`)
- [ ] **Sample**: a value + timestamp
- [ ] **Time series**: unique combination of metric + labels
- [ ] **Naming conventions**:
  - [ ] `<namespace>_<subsystem>_<name>_<unit>_<type>`
  - [ ] Units: `_seconds`, `_bytes`, `_total` (for counters)
  - [ ] Example: `http_request_duration_seconds`
- [ ] **Cardinality**: unique time series count — high cardinality is a problem!

## Module 3: Metric Types
- [ ] **Counter**: monotonically increasing value (resets to 0 on restart)
  - [ ] Use for: requests, errors, bytes sent
  - [ ] Always query with `rate()` or `increase()`
  - [ ] Convention: end with `_total`
- [ ] **Gauge**: value that can go up or down
  - [ ] Use for: memory usage, queue depth, temperature, in-flight requests
- [ ] **Histogram**: samples observations into configurable buckets
  - [ ] Exposes: `<name>_count`, `<name>_sum`, `<name>_bucket{le="..."}`
  - [ ] Query: `histogram_quantile(0.99, rate(http_duration_seconds_bucket[5m]))`
  - [ ] Use for: request duration, response size
- [ ] **Summary**: similar to histogram but computes quantiles client-side
  - [ ] Pros: precise quantiles
  - [ ] Cons: cannot aggregate across instances
  - [ ] **Prefer histogram for most use cases**

## Module 4: Scrape Configuration
- [ ] **`prometheus.yml`**: main config file
- [ ] **`scrape_configs`**: list of jobs to scrape
- [ ] **Static targets**:
  ```yaml
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
  ```
- [ ] **Scrape interval**: how often to scrape (default 15s, common 30s-60s)
- [ ] **Scrape timeout**: max time per scrape
- [ ] **Metrics path**: `/metrics` by default
- [ ] **HTTPS**: `scheme: https` + TLS config
- [ ] **Basic auth / bearer token**: for protected endpoints
- [ ] **Relabeling**: transform labels before ingestion
  - [ ] `relabel_configs`: applied to scraped target
  - [ ] `metric_relabel_configs`: applied to individual metrics
  - [ ] Actions: `keep`, `drop`, `replace`, `labelmap`, `labeldrop`

## Module 5: Service Discovery
- [ ] **Why SD**: targets change dynamically (pods, VMs)
- [ ] **Supported SD mechanisms**:
  - [ ] **Kubernetes**: discover pods, services, endpoints
  - [ ] **Consul**: service registry
  - [ ] **EC2, Azure, GCE**: cloud instance discovery
  - [ ] **DNS**: SRV records
  - [ ] **File-based**: JSON/YAML files (dynamic reload)
  - [ ] **HTTP**: generic HTTP endpoint
- [ ] **Kubernetes SD example**:
  ```yaml
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
  ```
- [ ] **Annotations-based**: pods opt-in via `prometheus.io/scrape: "true"`

## Module 6: PromQL (Prometheus Query Language)
- [ ] **Instant vector**: set of samples at one point in time
  - [ ] `http_requests_total` — all series with that metric
  - [ ] `http_requests_total{status="200"}` — filtered
- [ ] **Range vector**: samples over a time window
  - [ ] `http_requests_total[5m]` — last 5 minutes of samples
- [ ] **Key functions**:
  - [ ] `rate(metric[5m])` — per-second rate over window
  - [ ] `increase(metric[5m])` — total increase over window
  - [ ] `irate(metric[5m])` — instantaneous rate (last 2 samples)
  - [ ] `histogram_quantile(0.99, ...)` — compute percentile from histogram
  - [ ] `sum`, `avg`, `max`, `min`, `count` — aggregation
  - [ ] `topk(10, ...)`, `bottomk(10, ...)`
- [ ] **Aggregation**: `sum by (label) (metric)`, `avg without (pod) (metric)`
- [ ] **Arithmetic**: `(metric_a / metric_b) * 100`
- [ ] **Comparison**: `metric > 100`, `metric == 0`
- [ ] **`rate` vs `irate`**: rate is smoother, irate is more responsive
- [ ] **Common pattern**: `sum by (service) (rate(http_requests_total[5m]))`

## Module 7: Alertmanager
- [ ] **Alertmanager**: handles alerts fired by Prometheus
- [ ] **Responsibilities**:
  - [ ] **Deduplication**: same alert from multiple Prometheus instances
  - [ ] **Grouping**: combine related alerts
  - [ ] **Routing**: send to correct team/channel
  - [ ] **Silencing**: mute during maintenance
  - [ ] **Inhibition**: suppress lower-priority alerts if higher fires
- [ ] **Receivers**: Slack, PagerDuty, email, webhook, OpsGenie
- [ ] **Alert rules in Prometheus**:
  ```yaml
  groups:
    - name: example
      rules:
        - alert: HighErrorRate
          expr: rate(http_errors_total[5m]) > 0.1
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: "High error rate on {{ $labels.service }}"
  ```
- [ ] **`for` duration**: alert fires after condition holds for N time
- [ ] **Routing tree**: match on labels, route to receiver

## Module 8: Recording Rules
- [ ] **Recording rule**: precompute frequently-used PromQL, save result as new metric
- [ ] **Why**: expensive queries, dashboard speed, consistent metrics
- [ ] **Example**:
  ```yaml
  groups:
    - name: example
      interval: 30s
      rules:
        - record: job:http_requests:rate5m
          expr: sum by (job) (rate(http_requests_total[5m]))
  ```
- [ ] **Naming convention**: `level:metric:operation` (e.g., `job:http_requests:rate5m`)
- [ ] **Used by**: Alerting, dashboards, SLO calculations

## Module 9: SLO Monitoring with Prometheus
- [ ] **SLI (indicator)** → **SLO (objective)** → **SLA (agreement)**
- [ ] **Availability SLO example**:
  ```promql
  sum(rate(http_requests_total{status=~"2..|3.."}[5m]))
  /
  sum(rate(http_requests_total[5m]))
  ```
- [ ] **Latency SLO**: use histogram quantile
- [ ] **Error budget**: `1 - SLO_target`
- [ ] **Burn rate alerts** (Google SRE workbook):
  - [ ] Fast burn: short window, high rate → immediate page
  - [ ] Slow burn: long window, low rate → warning
- [ ] **Multi-window burn rate**: balance signal-to-noise
- [ ] **SLO tools**: Pyrra, Sloth (generate Prometheus rules from SLO definitions)

## Module 10: Cardinality & Scaling
- [ ] **High cardinality**: too many unique label combinations
- [ ] **Impact**: memory usage, query slowness, ingestion overhead
- [ ] **Examples of bad labels**: user IDs, request IDs, timestamps, URLs with params
- [ ] **Rule**: keep total active series < 1-2M per Prometheus instance
- [ ] **Detection**:
  - [ ] `prometheus_tsdb_head_series` — current series count
  - [ ] `topk(10, count by (__name__) ({__name__=~".+"}))` — top metrics by cardinality
- [ ] **Mitigation**:
  - [ ] Drop high-cardinality labels with `metric_relabel_configs`
  - [ ] Aggregate at client side (e.g., bucket user IDs)
  - [ ] Use histograms instead of per-value gauges
- [ ] **Scale limits**: single Prometheus: 1-2M series, ~500k samples/sec

## Module 11: Long-Term Storage & Federation
- [ ] **Problem**: local storage is short-term (weeks), no cluster-wide view
- [ ] **Federation**: higher-level Prometheus scrapes from lower-level
  - [ ] `/federate` endpoint
  - [ ] Limited scalability, lossy
- [ ] **Remote write**: stream all samples to remote storage
  - [ ] More modern, unlimited retention
- [ ] **Long-term storage options**:
  - [ ] **Thanos**: sidecar + object storage (S3/GCS), global query view
  - [ ] **Cortex**: horizontally scalable, multi-tenant
  - [ ] **Mimir** (Grafana): evolution of Cortex
  - [ ] **VictoriaMetrics**: high-performance, simpler than Thanos/Cortex
  - [ ] **M3DB** (Uber)
- [ ] **Trade-off**: operational complexity vs query scale

## Module 12: Instrumentation
- [ ] **Client libraries** (official + community):
  - [ ] Go: `prometheus/client_golang`
  - [ ] Java: `micrometer` (Spring Boot Actuator), `prometheus/simpleclient`
  - [ ] Python: `prometheus_client`
  - [ ] Node.js: `prom-client`
  - [ ] Rust: `prometheus`
- [ ] **Spring Boot + Micrometer**:
  - [ ] Add `micrometer-registry-prometheus`
  - [ ] Expose `/actuator/prometheus`
  - [ ] Auto-exposes JVM, HTTP, JDBC, etc.
- [ ] **Custom metrics**:
  ```java
  Counter orders = Counter.builder("orders_total").register(registry);
  orders.increment();
  ```
- [ ] **Labels as dimensions**: enable slicing by method, status, customer
- [ ] **Exemplars**: link metrics to traces (new feature)

## Module 13: Exporters
- [ ] **Exporter**: translates third-party metrics to Prometheus format
- [ ] **Popular exporters**:
  - [ ] `node_exporter`: Linux/Unix host metrics (CPU, memory, disk, network)
  - [ ] `cadvisor`: container metrics
  - [ ] `blackbox_exporter`: HTTP/TCP/ICMP probes
  - [ ] `postgres_exporter`, `mysqld_exporter`
  - [ ] `redis_exporter`
  - [ ] `kafka_exporter`, `rabbitmq_exporter`
  - [ ] `nginx-prometheus-exporter`
  - [ ] `jmx_exporter`: JMX → Prometheus
- [ ] **Kubernetes ecosystem**:
  - [ ] `kube-state-metrics`: K8s object state
  - [ ] `metrics-server`: resource metrics for HPA
- [ ] **Write your own**: simple HTTP server exposing `/metrics`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Install Prometheus, scrape `node_exporter` |
| Modules 2-3 | Create all 4 metric types in a Spring Boot app |
| Module 4 | Configure scrape with relabeling to drop unused labels |
| Module 5 | Set up Kubernetes SD with annotation-based scraping |
| Module 6 | Write 10 PromQL queries for common dashboards |
| Module 7 | Configure Alertmanager with Slack receiver |
| Module 8 | Create recording rules for SLO dashboards |
| Module 9 | Define SLO for an API, set up burn rate alerts |
| Module 10 | Find high-cardinality metrics, reduce cardinality |
| Module 11 | Deploy Thanos for long-term storage |
| Module 12 | Instrument Spring Boot app with custom Micrometer metrics |
| Module 13 | Deploy `postgres_exporter`, `node_exporter`, `kube-state-metrics` |

## Key Resources
- prometheus.io/docs (official)
- "Prometheus: Up & Running" — Brian Brazil
- "Monitoring with Prometheus" — James Turnbull
- promlabs.com (training)
- Grafana tutorials (for PromQL + visualization)
- Google SRE Workbook (free, SLO chapter)
