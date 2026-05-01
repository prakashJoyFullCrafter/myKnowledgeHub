# Observability Standards - Curriculum

Org-wide conventions so logs, metrics, and traces from every service are consistent and queryable together.

## Topics
### Logging Standards
- [ ] Structured logging (JSON) - mandatory across the org
- [ ] Standard fields: `timestamp`, `level`, `service`, `traceId`, `spanId`, `userId`, `tenantId`, `requestId`
- [ ] Severity levels and when to use each
- [ ] PII / secret redaction at the logger
- [ ] Log sampling for high-volume paths
- [ ] Centralized log shipping (Fluent Bit, Vector, OTel Collector)
- [ ] Log retention tiering (hot/warm/cold)

### Metrics Standards
- [ ] **RED** method (Rate, Errors, Duration) for services
- [ ] **USE** method (Utilization, Saturation, Errors) for resources
- [ ] **Four Golden Signals** (latency, traffic, errors, saturation)
- [ ] Metric naming convention: `<domain>_<action>_<unit>` (Prometheus style)
- [ ] Standard labels: `service`, `version`, `env`, `region` - cardinality discipline
- [ ] SLI definitions and SLO targets per service
- [ ] Error budget policy

### Tracing Standards
- [ ] **OpenTelemetry** as the org-wide standard (vendor-neutral)
- [ ] Required spans: incoming request, outgoing call, DB query, queue publish/consume
- [ ] Standard span attributes (semantic conventions)
- [ ] Trace context propagation (W3C Trace Context)
- [ ] Sampling strategy (head-based vs tail-based)
- [ ] Trace-log-metric correlation via `traceId`

### Dashboards & Alerts
- [ ] **Dashboards-as-code** (Grafana JSON in Git, Terraform, Grafonnet)
- [ ] Per-service dashboard template (auto-generated from service catalog)
- [ ] Alert routing convention (PagerDuty / Opsgenie team mapping)
- [ ] Alert hygiene: no alert without runbook, no flap-prone alerts
- [ ] Synthetic monitoring standards

### Cost & Governance
- [ ] Telemetry cost monitoring (cardinality explosions are expensive)
- [ ] Standard exporters and platform-provided collectors (no DIY agents per team)
- [ ] Compliance: audit logs separate from app logs
