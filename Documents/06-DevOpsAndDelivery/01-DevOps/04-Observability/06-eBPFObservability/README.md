# eBPF Observability - Curriculum

eBPF (extended Berkeley Packet Filter) is revolutionizing observability — zero-instrumentation, kernel-level insight.

---

## Module 1: What is eBPF?
- [ ] **eBPF**: programmable kernel — run sandboxed programs in the Linux kernel without changing kernel source
- [ ] **Origin**: BPF (1992) for packet filtering → extended BPF (2014+) for general-purpose
- [ ] **Key capabilities**: hook into kernel functions, syscalls, tracepoints, perf events
- [ ] **Sandboxed**: verifier ensures safety (no infinite loops, bounded memory)
- [ ] **Performance**: near-zero overhead compared to kernel modules
- [ ] **Use cases**:
  - [ ] Networking (Cilium)
  - [ ] Observability (Pixie, Parca, Hubble)
  - [ ] Security (Falco, Tetragon)
  - [ ] Performance profiling
- [ ] **No app changes**: works with existing unmodified binaries

## Module 2: Why eBPF for Observability
- [ ] **Traditional instrumentation limitations**:
  - [ ] Requires SDK per language
  - [ ] Code changes per service
  - [ ] Upgrade friction
  - [ ] Missing low-level system data
- [ ] **eBPF advantages**:
  - [ ] Zero instrumentation (works on unmodified apps)
  - [ ] Language-agnostic
  - [ ] Kernel-level visibility (syscalls, network, DNS)
  - [ ] Low overhead
- [ ] **What you can see**:
  - [ ] HTTP/gRPC traffic (decoded)
  - [ ] TCP connections
  - [ ] DNS queries
  - [ ] Function calls (uprobes for user space)
  - [ ] Syscall latency
  - [ ] TLS traffic (via uprobes on OpenSSL)

## Module 3: eBPF Program Types
- [ ] **kprobes**: attach to kernel functions (enter/exit)
- [ ] **uprobes**: attach to user-space functions
- [ ] **tracepoints**: stable kernel instrumentation points
- [ ] **perf events**: CPU performance counters
- [ ] **XDP (eXpress Data Path)**: fastest packet processing (NIC driver level)
- [ ] **TC (Traffic Control)**: egress/ingress packet manipulation
- [ ] **Cgroup programs**: per-cgroup traffic control
- [ ] **LSM (Linux Security Module)**: security hooks

## Module 4: Cilium
- [ ] **Cilium**: CNI plugin using eBPF for Kubernetes networking
- [ ] **Capabilities**:
  - [ ] eBPF-based networking (faster than iptables)
  - [ ] Network policies (L3/L4/L7)
  - [ ] Transparent encryption (WireGuard, IPsec)
  - [ ] Service mesh without sidecars
- [ ] **Hubble**: observability component for Cilium
  - [ ] Flow visibility (who talks to whom)
  - [ ] HTTP, gRPC, Kafka-aware
  - [ ] Grafana integration
- [ ] **Cilium Service Mesh**: sidecar-less alternative to Istio
- [ ] **Adoption**: Google GKE Dataplane V2, AWS EKS, many production clusters

## Module 5: Pixie (Observability)
- [ ] **Pixie**: auto-observability for Kubernetes using eBPF
- [ ] **Zero instrumentation**: works on unmodified apps
- [ ] **What you get**:
  - [ ] HTTP/gRPC/MySQL/PostgreSQL/DNS trace
  - [ ] Continuous profiling
  - [ ] Service topology
  - [ ] Latency breakdowns
- [ ] **Scripts** in PxL (Python-like language) for custom analysis
- [ ] **Data locality**: data stored in-cluster (no egress)
- [ ] **Acquired by New Relic**, now CNCF sandbox

## Module 6: Parca (Continuous Profiling)
- [ ] **Parca**: continuous profiling via eBPF
- [ ] **Profiling**: understand where CPU time is spent (vs metrics showing aggregate)
- [ ] **Always-on**: low overhead (~1%), runs constantly
- [ ] **Flame graphs**: visualize CPU hotspots
- [ ] **Historical comparison**: before/after deploy, find regressions
- [ ] **Alternatives**: Pyroscope (Grafana), Datadog Continuous Profiler
- [ ] **Use cases**: CPU optimization, memory allocation analysis, latency investigation

## Module 7: Falco (Runtime Security)
- [ ] **Falco**: CNCF graduated, runtime security via eBPF
- [ ] **Monitors**:
  - [ ] Syscall activity
  - [ ] File access
  - [ ] Network connections
  - [ ] Process spawning
- [ ] **Rules**: YAML rules for detecting suspicious behavior
  - [ ] "Write to `/etc`"
  - [ ] "Shell in container"
  - [ ] "Privileged container started"
  - [ ] "Unusual outbound connection"
- [ ] **Integration**: Slack, PagerDuty, webhooks, SIEM
- [ ] **Use case**: intrusion detection, compliance

## Module 8: Tetragon (Security & Observability)
- [ ] **Tetragon** (Cilium project): eBPF-based security observability and runtime enforcement
- [ ] **Capabilities**:
  - [ ] Process lineage (parent/child)
  - [ ] File access
  - [ ] Network events
  - [ ] Real-time policy enforcement (kill processes, block syscalls)
- [ ] **Differences from Falco**:
  - [ ] Can enforce in kernel (block at syscall level)
  - [ ] Less rule-based, more programmable
- [ ] **Use case**: defense in depth, zero trust runtime

## Module 9: Limitations & Considerations
- [ ] **Kernel version requirement**: eBPF features depend on kernel (5.x+ recommended)
- [ ] **Privilege**: eBPF programs need privileges (CAP_BPF, CAP_PERFMON)
- [ ] **Observability gaps**:
  - [ ] Some userspace data hard to get (TLS without uprobes, custom protocols)
  - [ ] Language-specific info (GC pauses, JVM internals)
- [ ] **Correlation**: eBPF data can be hard to correlate with app-level traces
- [ ] **Learning curve**: verifier errors, CO-RE (Compile Once, Run Everywhere)
- [ ] **Not a replacement**: complements OpenTelemetry, doesn't replace

## Module 10: Ecosystem & Future
- [ ] **Tools landscape**:
  - [ ] Networking: Cilium, Calico eBPF dataplane
  - [ ] Observability: Pixie, Parca, Hubble, Grafana Beyla
  - [ ] Security: Falco, Tetragon, Tracee
  - [ ] Profiling: Parca, Pyroscope, bpftrace
- [ ] **Grafana Beyla**: zero-code instrumentation via eBPF (Grafana stack)
- [ ] **bpftrace**: high-level tracing language (like awk for eBPF)
- [ ] **bpftool**: manage and debug eBPF programs
- [ ] **Why the excitement**: eBPF is becoming the foundation for next-gen infra tools
- [ ] **eBPF Foundation**: Linux Foundation group governing eBPF

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Read eBPF primer, understand kernel interaction |
| Module 3 | Use `bpftrace` to trace syscalls |
| Module 4 | Deploy Cilium in kind cluster, inspect Hubble flows |
| Module 5 | Install Pixie, explore auto-captured HTTP/DB data |
| Module 6 | Install Parca, generate flame graph |
| Module 7 | Install Falco, trigger a rule via shell-in-container |
| Module 8 | Experiment with Tetragon policy enforcement |
| Module 9 | Identify what eBPF can't observe in your app |
| Module 10 | Explore Grafana Beyla for zero-instrumentation |

## Key Resources
- ebpf.io
- "Learning eBPF" — Liz Rice
- cilium.io / isovalent.com
- pixielabs.ai
- falco.org
- "BPF Performance Tools" — Brendan Gregg
