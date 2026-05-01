# Grafana - Curriculum

## Module 1: Grafana Fundamentals
- [ ] **Grafana**: open-source visualization and observability platform
- [ ] **Multi-source**: unified view across metrics, logs, traces
- [ ] **Grafana vs Kibana**: Grafana is data-source agnostic (multi-backend)
- [ ] **Open Source vs Cloud vs Enterprise**: same core, different features
- [ ] **Installation**: Docker, Kubernetes (Helm), binary

## Module 2: Data Sources
- [ ] **Built-in data sources**:
  - [ ] Prometheus (metrics)
  - [ ] Loki (logs)
  - [ ] Tempo (traces)
  - [ ] Elasticsearch
  - [ ] InfluxDB, MySQL, PostgreSQL
  - [ ] CloudWatch, Azure Monitor, Google Cloud Monitoring
- [ ] **Each data source has its own query language**
- [ ] **Mixed data sources**: one panel can query multiple sources (experimental)
- [ ] **Provisioning**: data sources as code (YAML files)

## Module 3: Dashboards & Panels
- [ ] **Dashboard**: collection of panels with variables and time range
- [ ] **Panel types**:
  - [ ] Time series: line, bar, area charts
  - [ ] Stat: single value with color thresholds
  - [ ] Gauge: meter-style
  - [ ] Table: tabular data
  - [ ] Heatmap: density visualization
  - [ ] Bar gauge, state timeline, status history
  - [ ] Logs panel, node graph, trace view
- [ ] **Panel edit**: query, transform, visualize, override
- [ ] **Time range**: global, per-panel, relative (`now-1h`) or absolute
- [ ] **Shared tooltip and crosshair**: coordinate across panels

## Module 4: Variables & Templating
- [ ] **Variables**: dynamic values for dashboards
  - [ ] Query variable: values from data source
  - [ ] Custom variable: static list
  - [ ] Text box, constant, interval
- [ ] **Usage**: `$variable` in queries, titles, URL
- [ ] **Multi-value**: select multiple, use `=~` in PromQL
- [ ] **Repeated panels/rows**: render one panel per variable value
- [ ] **Dashboard links**: link to related dashboards with context

## Module 5: Alerting
- [ ] **Grafana alerting** (unified since v8):
  - [ ] Alert rules: query + condition + labels + annotations
  - [ ] Notification policies: routing by labels
  - [ ] Contact points: Slack, email, PagerDuty, webhook
- [ ] **Alert states**: Normal, Pending, Firing, NoData, Error
- [ ] **Silences**: mute during maintenance
- [ ] **Multi-dimensional alerts**: one rule generates multiple alerts based on labels
- [ ] **Alert rule evaluation**: polled at `evaluate every` interval
- [ ] **Grafana vs Alertmanager**: Grafana alerting can use Prometheus + others

## Module 6: Dashboard as Code
- [ ] **JSON model**: every dashboard is JSON
- [ ] **Version control**: commit dashboards to Git
- [ ] **Provisioning**: YAML files to deploy dashboards at startup
- [ ] **Grafonnet**: Jsonnet library for dashboards as code
- [ ] **Grafana Operator**: Kubernetes CRDs for dashboards
- [ ] **Terraform provider**: manage dashboards, data sources, alerts via Terraform
- [ ] **Benefits**: reproducibility, review via PR, environment promotion

## Module 7: Grafana Stack (LGTM)
- [ ] **L**oki: log aggregation (see dedicated module)
- [ ] **G**rafana: visualization
- [ ] **T**empo: distributed tracing
- [ ] **M**imir: long-term Prometheus metrics (Cortex evolution)
- [ ] **Why one stack**: unified UX, cross-signal correlation (metrics → logs → traces)
- [ ] **Cross-signal linking**: click metric spike → see logs → see traces
- [ ] **Exemplars**: link metrics to traces (Prometheus feature)
- [ ] **Derived fields**: auto-link fields in logs to traces

## Module 8: Useful Dashboards
- [ ] **Community dashboards**: grafana.com/grafana/dashboards
- [ ] **Popular ready-made dashboards**:
  - [ ] Node Exporter Full (host metrics)
  - [ ] Kubernetes cluster overview
  - [ ] JVM (Micrometer)
  - [ ] Spring Boot (Actuator)
  - [ ] PostgreSQL, MySQL, Redis
  - [ ] Kafka, RabbitMQ
  - [ ] cAdvisor (container metrics)
- [ ] **Importing**: paste dashboard ID
- [ ] **Customize**: fork and adjust to your needs

## Module 9: Best Practices
- [ ] **Hierarchy**: overview → service → instance (drill down)
- [ ] **Four golden signals** per service: latency, traffic, errors, saturation
- [ ] **RED method**: Rate, Errors, Duration
- [ ] **USE method**: Utilization, Saturation, Errors (for resources)
- [ ] **Short time ranges by default**: 1h–6h typical
- [ ] **Avoid cardinality explosion**: don't template over high-cardinality labels
- [ ] **Keep dashboards focused**: < 15 panels, clear purpose
- [ ] **Document in dashboard description**: link to runbooks

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Install Grafana, add Prometheus data source |
| Module 3 | Build first dashboard with time series + stat panels |
| Module 4 | Add service variable, repeat panels per service |
| Module 5 | Configure alert with Slack notification |
| Module 6 | Export dashboard to JSON, provision via YAML |
| Module 7 | Deploy full LGTM stack, correlate metric → log → trace |
| Module 8 | Import Node Exporter Full dashboard |
| Module 9 | Design 4-level dashboard hierarchy for a service |

## Key Resources
- grafana.com/docs
- grafana.com/grafana/dashboards (community dashboards)
- "Grafana Cookbook" (various)
- grafana.com/tutorials
