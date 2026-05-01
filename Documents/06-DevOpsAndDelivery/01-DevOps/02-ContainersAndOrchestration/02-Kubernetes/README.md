# Kubernetes - Curriculum

## Module 1: Architecture & Control Plane
- [ ] **Control plane components**:
  - [ ] **API Server (`kube-apiserver`)**: all interactions go here, RESTful API, validates/authz
  - [ ] **etcd**: distributed KV store, source of truth for cluster state (Raft consensus)
  - [ ] **Scheduler (`kube-scheduler`)**: assigns pods to nodes based on constraints
  - [ ] **Controller Manager**: runs controllers (deployment, replicaset, node, etc.)
  - [ ] **Cloud Controller Manager**: cloud-specific controllers (load balancer, nodes)
- [ ] **Worker node components**:
  - [ ] **kubelet**: agent that runs pods
  - [ ] **kube-proxy**: network rules for Services (iptables or IPVS)
  - [ ] **Container runtime**: containerd, CRI-O (Docker deprecated as runtime since 1.24)
- [ ] **Communication**: all through API Server, etcd never exposed directly
- [ ] **Declarative model**: you describe desired state, controllers reconcile
- [ ] **Control loops**: watch state, compare to desired, take action, repeat

## Module 2: Core Workloads
- [ ] **Pod**: smallest deployable unit, one or more containers sharing network/storage
  - [ ] Pods are ephemeral — never manage directly in production
  - [ ] Init containers: run before main containers (setup, migrations)
  - [ ] Sidecar containers: run alongside main (logging, proxy)
- [ ] **ReplicaSet**: maintains N replicas of a pod
  - [ ] Usually managed via Deployment, not directly
- [ ] **Deployment**: declarative pod management with rollouts
  - [ ] Strategies: RollingUpdate (default), Recreate
  - [ ] `kubectl rollout status/history/undo`
  - [ ] `maxSurge`, `maxUnavailable` tuning
- [ ] **StatefulSet**: stateful workloads with stable identity
  - [ ] Ordered creation/deletion, stable pod names, persistent storage per pod
  - [ ] Use cases: databases (Postgres, MySQL), Kafka, ZooKeeper
- [ ] **DaemonSet**: one pod per node
  - [ ] Use cases: log collectors (Fluent Bit), monitoring agents (node-exporter), CNI
- [ ] **Job / CronJob**: batch workloads, one-time or scheduled

## Module 3: Services & Networking
- [ ] **Service**: stable endpoint for a set of pods (selector-based)
- [ ] **Service types**:
  - [ ] **ClusterIP** (default): internal-only, virtual IP
  - [ ] **NodePort**: expose on each node's IP at static port (30000-32767)
  - [ ] **LoadBalancer**: cloud provider provisions external LB
  - [ ] **ExternalName**: CNAME to external DNS
  - [ ] **Headless Service** (`clusterIP: None`): DNS returns pod IPs directly
- [ ] **Service discovery**: DNS via CoreDNS (`service-name.namespace.svc.cluster.local`)
- [ ] **Endpoints / EndpointSlices**: actual pods backing a service
- [ ] **Ingress**: HTTP/S routing from outside cluster
  - [ ] Rules: host-based, path-based routing
  - [ ] TLS termination
  - [ ] Ingress controllers: NGINX, Traefik, HAProxy, cloud-provided
- [ ] **Gateway API**: modern replacement for Ingress (more expressive, CRD-based)
- [ ] **Network Policies**: pod-level firewall rules
  - [ ] Default: all pods can talk to all pods
  - [ ] Network policies restrict ingress/egress by pod label, namespace, IP block
  - [ ] Requires CNI that supports them (Calico, Cilium, not all)

## Module 4: Storage
- [ ] **Volume types**:
  - [ ] `emptyDir`: pod-lifetime temp storage
  - [ ] `hostPath`: mount from node filesystem (avoid in production)
  - [ ] `configMap`, `secret`: inject config as files
  - [ ] `persistentVolumeClaim`: request persistent storage
- [ ] **PersistentVolume (PV)**: cluster-provisioned storage
- [ ] **PersistentVolumeClaim (PVC)**: request for storage by pod
- [ ] **StorageClass**: dynamic provisioning template
  - [ ] Cloud providers: gp3, io2, Azure Disk, GCE PD
  - [ ] On-prem: Ceph, NFS, Longhorn, OpenEBS
- [ ] **Access modes**:
  - [ ] `ReadWriteOnce` (RWO): one node
  - [ ] `ReadOnlyMany` (ROX): many nodes read-only
  - [ ] `ReadWriteMany` (RWX): many nodes read-write (not all drivers support)
  - [ ] `ReadWriteOncePod` (RWOP): one pod (new)
- [ ] **Reclaim policy**: Retain, Delete, Recycle (deprecated)
- [ ] **CSI (Container Storage Interface)**: plugin architecture for storage drivers

## Module 5: Configuration & Secrets
- [ ] **ConfigMap**: non-sensitive config as key-value pairs
  - [ ] Mount as files: `volumes` → `configMap`
  - [ ] Inject as env vars: `envFrom.configMapRef`
- [ ] **Secret**: sensitive data, base64 encoded (NOT encrypted by default)
  - [ ] Same mounting/injection options as ConfigMap
  - [ ] `type: Opaque | kubernetes.io/dockerconfigjson | kubernetes.io/tls | ...`
- [ ] **Secrets are NOT secure by default**:
  - [ ] Base64 is encoding, not encryption
  - [ ] Enable encryption at rest in etcd
  - [ ] Use **External Secrets Operator** for Vault/AWS Secrets Manager integration
  - [ ] **Sealed Secrets** (Bitnami) for GitOps
- [ ] **Projected volumes**: combine multiple sources into one mount
- [ ] **Immutable ConfigMap/Secret**: performance, prevents accidental changes

## Module 6: Scheduling & Resource Management
- [ ] **Resource requests and limits**:
  - [ ] Requests: guaranteed minimum (used for scheduling)
  - [ ] Limits: hard ceiling (OOM kill if memory exceeded)
  - [ ] CPU: millicores (`500m` = 0.5 core)
  - [ ] Memory: bytes (`512Mi`)
- [ ] **Quality of Service (QoS)**:
  - [ ] **Guaranteed**: requests == limits for all containers
  - [ ] **Burstable**: requests < limits
  - [ ] **BestEffort**: no requests/limits (evicted first)
- [ ] **Node selectors**: pod can only run on nodes with specific labels
- [ ] **Affinity/Anti-affinity**:
  - [ ] Node affinity: prefer/require certain nodes
  - [ ] Pod affinity: co-locate related pods
  - [ ] Pod anti-affinity: spread pods across nodes/zones
- [ ] **Taints and tolerations**: reserve nodes for specific workloads
- [ ] **Topology Spread Constraints**: spread pods across zones/nodes evenly

## Module 7: Autoscaling
- [ ] **HorizontalPodAutoscaler (HPA)**: scale replicas based on metrics
  - [ ] CPU/memory (default)
  - [ ] Custom metrics via metrics-server + Prometheus Adapter
  - [ ] External metrics (queue length, latency)
- [ ] **VerticalPodAutoscaler (VPA)**: adjust requests/limits automatically
  - [ ] Three modes: Off (recommend), Initial (apply at creation), Auto (recreate pods)
- [ ] **Cluster Autoscaler**: add/remove nodes when pods can't be scheduled
  - [ ] Works with cloud provider APIs
- [ ] **KEDA** (Kubernetes Event-Driven Autoscaling):
  - [ ] Scale based on events from 50+ sources (Kafka lag, SQS, Redis, cron)
  - [ ] Scale to zero
- [ ] **Karpenter** (AWS): faster, more flexible than Cluster Autoscaler

## Module 8: Security (PSA, RBAC, Secrets)
- [ ] **Pod Security Admission (PSA)**: replaces deprecated PSP
  - [ ] Levels: `privileged`, `baseline`, `restricted`
  - [ ] Modes: `enforce`, `audit`, `warn`
  - [ ] Namespace-level: `pod-security.kubernetes.io/enforce: restricted`
- [ ] **SecurityContext**: per-pod / per-container security settings
  - [ ] `runAsNonRoot: true`
  - [ ] `readOnlyRootFilesystem: true`
  - [ ] `allowPrivilegeEscalation: false`
  - [ ] `capabilities.drop: [ALL]`
  - [ ] `seccompProfile: RuntimeDefault`
- [ ] **RBAC (Role-Based Access Control)**:
  - [ ] **Role / ClusterRole**: set of permissions
  - [ ] **RoleBinding / ClusterRoleBinding**: grant role to user/group/serviceaccount
  - [ ] Principle: least privilege
  - [ ] Namespace-scoped (Role) vs cluster-scoped (ClusterRole)
- [ ] **ServiceAccounts**: pod identity for API access
- [ ] **Image pull secrets**: private registry credentials

## Module 9: Probes & Health Checks
- [ ] **Liveness probe**: is the container alive? (restart if fails)
  - [ ] Too aggressive → restart loops
  - [ ] Too lenient → stuck containers
- [ ] **Readiness probe**: is the container ready to receive traffic?
  - [ ] Controls Service endpoint inclusion
  - [ ] Use for: warmup, dependency check, backpressure signaling
- [ ] **Startup probe**: for slow-starting apps
  - [ ] Delays liveness/readiness until app has started
  - [ ] Use for Java apps, databases
- [ ] **Probe types**: `httpGet`, `tcpSocket`, `exec`, `grpc`
- [ ] **Common mistakes**:
  - [ ] Using same endpoint for liveness and readiness
  - [ ] Liveness probe that checks DB — causes restart loop on DB outage
  - [ ] No startup probe for slow apps

## Module 10: kubectl Mastery
- [ ] **Essential commands**:
  - [ ] `kubectl get/describe/logs/exec/delete/apply`
  - [ ] `-o yaml/json/wide/name/jsonpath/custom-columns`
  - [ ] `--all-namespaces` / `-A`
  - [ ] `-l key=value` label selector
- [ ] **Apply vs create vs replace**:
  - [ ] `apply`: declarative, idempotent (preferred)
  - [ ] `create`: imperative, fails if exists
  - [ ] `replace`: delete + create (loses annotations)
- [ ] **Useful tricks**:
  - [ ] `kubectl diff -f file.yaml` — preview changes
  - [ ] `kubectl explain pod.spec.containers` — field docs
  - [ ] `kubectl port-forward svc/myservice 8080:80`
  - [ ] `kubectl debug node/nodename -it --image=busybox`
  - [ ] `kubectl rollout restart deployment/myapp`
- [ ] **kubeconfig**: `~/.kube/config` — contexts, users, clusters
- [ ] **Tools**: `k9s` (TUI), `stern` (multi-pod logs), `kubectx/kubens` (context switching)

## Module 11: Troubleshooting
- [ ] **Pod issues**:
  - [ ] `Pending`: scheduling issue (no resources, taints, affinity)
  - [ ] `ImagePullBackOff`: registry auth or image name wrong
  - [ ] `CrashLoopBackOff`: container crashing, check logs
  - [ ] `OOMKilled`: exceeded memory limit
  - [ ] `Evicted`: resource pressure on node
- [ ] **Debugging flow**:
  1. [ ] `kubectl get pods` — status
  2. [ ] `kubectl describe pod <name>` — events, conditions
  3. [ ] `kubectl logs <name> [-p] [--previous]` — logs
  4. [ ] `kubectl exec -it <name> -- sh` — shell
  5. [ ] `kubectl debug` — ephemeral debug container
- [ ] **Node issues**: `kubectl describe node`, check kubelet logs
- [ ] **Networking issues**: network policies, DNS, Service endpoints
- [ ] **Resource issues**: `kubectl top`, metrics-server
- [ ] **etcd health**: critical — if etcd down, cluster down

## Module 12: Upgrades & Multi-Cluster
- [ ] **Cluster upgrades**:
  - [ ] Upgrade control plane first, then nodes
  - [ ] One minor version at a time
  - [ ] Test in staging
  - [ ] Tool: `kubeadm upgrade` (for kubeadm clusters), managed K8s handles for you
- [ ] **Node draining**: `kubectl drain <node> --ignore-daemonsets`
  - [ ] Cordon → drain → upgrade → uncordon
- [ ] **Multi-cluster strategies**:
  - [ ] Fleet management: Rancher, Karmada, Kubefed
  - [ ] Multi-cluster service discovery
  - [ ] GitOps across clusters: ArgoCD, Flux
- [ ] **Managed Kubernetes**: EKS (AWS), GKE (GCP), AKS (Azure)
  - [ ] Pros: less ops burden, automated upgrades
  - [ ] Cons: less control, cloud lock-in, cost

## Module 13: Platform & Ecosystem
- [ ] **CRDs & Operators**: extend K8s with custom resources (see dedicated module)
- [ ] **Service Mesh**: Istio, Linkerd (see dedicated module)
- [ ] **GitOps**: ArgoCD, Flux (see CI/CD section)
- [ ] **Observability**: Prometheus, Grafana, Loki, Tempo, Jaeger
- [ ] **Policy**: OPA, Kyverno (Gatekeeper, Admission webhooks)
- [ ] **Backup**: Velero for cluster backup/restore
- [ ] **Certificates**: cert-manager for automated TLS
- [ ] **Secrets**: External Secrets Operator, Sealed Secrets, Vault Agent Injector

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Draw the control plane architecture for your own reference |
| Module 2 | Deploy a Deployment + StatefulSet, observe pod naming and ordering |
| Module 3 | Expose a service via ClusterIP, NodePort, LoadBalancer, Ingress — compare |
| Module 4 | Create dynamic PVC, observe PV provisioning |
| Module 5 | Inject config via ConfigMap (env and file), try Sealed Secrets |
| Module 6 | Set requests/limits, observe QoS assignment, test eviction |
| Module 7 | Deploy HPA on CPU, generate load, observe scaling |
| Module 8 | Enable PSA restricted, fix failing pods with SecurityContext |
| Module 9 | Add liveness/readiness/startup probes to a Spring Boot app |
| Module 10 | Build a cheat sheet of your 20 most-used kubectl commands |
| Module 11 | Troubleshoot 5 common pod issues (CrashLoop, ImagePull, OOMKilled, etc.) |
| Module 12 | Perform a control plane upgrade on test cluster (kind/minikube) |
| Module 13 | Install cert-manager + Ingress + TLS cert automation |

## Key Resources
- kubernetes.io/docs (official)
- "Kubernetes in Action" — Marko Luksa
- "Kubernetes: Up and Running" — Hightower, Burns, Beda
- "The Kubernetes Book" — Nigel Poulton
- CNCF landscape (cncf.io)
- k8s.io "tutorials" and "concepts" sections
