# Object Storage (S3) — One-Page Cheat Sheet

## Definition
Object storage stores data as objects (data + metadata + key) in a flat namespace, optimized for scalability, durability, and HTTP-based access. It is ideal for unstructured data like media, backups, and logs.

---

## Core Components
| Component | Role | Key Property |
|----------|------|-------------|
| Bucket | Container for objects | Globally unique name |
| Object | Data + metadata | Immutable (overwrite only) |
| Key | Object identifier | Flat namespace |
| Metadata | Descriptive info | User/system-defined |
| Versioning | Keeps object history | Enables recovery |

---

## Key Protocols / Patterns
- Presigned URL → secure direct client access
- Multipart Upload → parallel large uploads
- Byte-range requests → partial download
- S3 Select → query without full download
- Lifecycle policies → cost optimization

---

## Performance Numbers
- Max object size: ~5 TB
- Single PUT limit: 5 GB
- Multipart min part: 5 MB
- Max parts: 10,000
- Latency: ~10–100 ms (regional)
- Throughput: virtually unlimited (horizontal scaling)

---

## Configuration Knobs
| Setting | Default | Guidance |
|--------|--------|----------|
| Versioning | Off | Enable for critical data |
| Encryption | SSE-S3 | Use SSE-KMS for sensitive |
| Lifecycle | None | Add from day 1 |
| Block Public Access | On | Keep ON unless needed |
| Multipart threshold | Manual | Use >100 MB |
| CDN (CloudFront) | Off | Enable for global users |
| Logging | Off | Enable for audit |

---

## Failure Modes & Mitigation
| Failure | Mitigation |
|--------|-----------|
| Accidental delete | Enable versioning |
| Partial uploads | Multipart + retry |
| Data breach | Block public access |
| Region outage | Cross-region replication |
| Cost explosion | Lifecycle policies |

---

## When to Use vs NOT Use
| Use | Avoid |
|-----|------|
| Media storage | Low-latency DB workloads |
| Backups | Frequent small updates |
| Data lakes | Transactions |
| Logs/archives | Strong consistency needs |

---

## Comparison
| Feature | Object Storage | File Storage | Block Storage |
|--------|--------------|-------------|--------------|
| Structure | Flat | Hierarchical | Raw blocks |
| Scalability | Massive | Medium | Limited |
| Performance | High throughput | Medium | Low latency |
| Use case | Media, logs | Shared files | Databases |

---

## Common Pitfalls
- Making bucket public accidentally
- Storing secrets in S3
- No lifecycle policy → high cost
- Using single PUT for large files
- Not using CDN for delivery
