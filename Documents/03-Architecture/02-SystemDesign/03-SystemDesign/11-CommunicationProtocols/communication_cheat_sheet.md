# COMMUNICATION PROTOCOLS — ONE PAGE CHEAT SHEET

## Definition
Communication protocols define how services exchange data across networks, including transport, API style, messaging pattern, and serialization. They determine performance, scalability, and failure behavior in distributed systems.

---

## Core Components
| Component | Role | Key Property |
|----------|------|-------------|
| Transport (HTTP/1.1, HTTP/2, QUIC) | Moves data | Latency + HOL blocking |
| API Style (REST, GraphQL, gRPC) | Defines interface | Data shape control |
| Pattern (Sync/Async) | Controls flow | Coupling vs decoupling |
| Serialization (JSON, Protobuf, Avro) | Encodes data | Size + speed |

---

## Key Protocols / Concepts
- HTTP/1.1: sequential requests, HOL blocking  
- HTTP/2: multiplexing over TCP  
- HTTP/3 (QUIC): eliminates transport HOL  
- REST: resource-based APIs  
- GraphQL: client-defined queries  
- gRPC: binary RPC over HTTP/2  
- Sync: blocking request-response  
- Async: queue-based decoupling  

---

## Performance Numbers
- HTTP/1.1 latency: ~3 RTT  
- HTTP/2 latency: ~2 RTT  
- HTTP/3 latency: ~1 RTT (0-RTT resume)  
- JSON vs Protobuf: 3–10× larger  
- JSON parse: ~5× slower than protobuf  
- WebSocket overhead: 2–14 bytes vs 200–800 bytes HTTP  
- Async queue publish: ~1ms  

---

## Configuration Knobs
| Knob | Default | Guidance |
|------|--------|----------|
| Timeout | 30s | Set < downstream SLA |
| Retries | 3 | Use exponential backoff |
| Circuit breaker | off | Enable for unstable deps |
| Connection pool | small | Tune for throughput |
| Batch size | 1 | Increase for efficiency |
| Queue retention | hours | Match recovery window |
| Compression | off | Enable for large payloads |

---

## Failure Modes
| Failure | Mitigation |
|--------|-----------|
| HOL blocking | Use HTTP/2 or HTTP/3 |
| Cascading failure | Circuit breaker + bulkhead |
| Thread exhaustion | Timeouts + async |
| Message loss | Durable queue + retries |
| Schema break | Compatibility rules |

---

## When to Use / NOT Use
| Use When | Avoid When |
|---------|-----------|
| REST: public APIs | High-performance internal |
| GraphQL: complex UI | Simple APIs |
| gRPC: microservices | Browser-only clients |
| Sync: critical path | Long tasks |
| Async: side effects | Strong consistency needed |

---

## Comparison
| Feature | REST | GraphQL | gRPC |
|--------|------|---------|------|
| Data | Fixed | Flexible | Strict |
| Calls | Multiple | Single | RPC |
| Speed | Medium | Medium | Fast |
| Caching | Easy | Hard | Hard |

---

## Common Pitfalls
- Over-fetching in REST  
- N+1 queries in GraphQL  
- Ignoring retries/backoff  
- Missing schema compatibility  
- Blocking on non-critical tasks  
