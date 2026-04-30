# Distributed ID Generation — One-Page Cheat Sheet

## Definition
Distributed ID generation is the process of creating globally unique identifiers across multiple systems without collisions. Modern approaches balance uniqueness, scalability, sortability, and performance without centralized bottlenecks.

---

## Core Components

| Component        | Role                                  | Key Property |
|------------------|---------------------------------------|-------------|
| Timestamp        | Orders IDs chronologically            | Enables sorting |
| Machine/Node ID  | Differentiates generators             | Prevents cross-node collision |
| Sequence Counter | Ensures uniqueness within same time   | Handles high throughput |
| Random Bits      | Adds unpredictability                 | Prevents guessing/enumeration |

---

## Key Algorithms / Protocols

- **UUID v4** — Fully random (122 bits), no coordination  
- **UUID v7** — Timestamp + random, sortable (modern default)  
- **ULID** — Base32 encoded, lexicographically sortable  
- **Snowflake** — Timestamp + machine + sequence (64-bit)  
- **Redis INCR** — Central atomic counter  
- **Sequence Ranges** — Batch allocation from DB  

---

## Performance Numbers

| Strategy        | Latency        | Throughput              | Notes |
|----------------|---------------|------------------------|------|
| UUID v4/v7     | ~0µs (local)  | Unlimited              | CPU-bound |
| Snowflake      | ~1µs          | ~4M IDs/sec/node       | 4096 IDs/ms |
| Redis INCR     | <1ms          | ~100K–500K/sec         | Network bound |
| Ticket Server  | ~1–5ms        | ~10K–30K/sec           | DB bottleneck |
| Sequence Range | Near-zero     | Near-local speed       | 1000× fewer DB calls |

---

## Configuration Knobs

| Knob | Default | Guidance |
|------|--------|----------|
| Epoch (Snowflake) | Custom | Set near system launch |
| Worker ID bits | 10 bits | Increase if more nodes |
| Sequence bits | 12 bits | Increase for higher per-node throughput |
| UUID storage | 16 bytes | Use binary, NOT VARCHAR |
| Redis persistence | AOF everysec | Use `always` for strict durability |
| Batch size (range) | 1000 | Increase to reduce DB load |
| Clock sync (NTP) | Enabled | Monitor drift carefully |

---

## Failure Modes

| Failure | Impact | Mitigation |
|--------|--------|-----------|
| Clock drift (Snowflake) | Duplicate / unordered IDs | Wait or fail on backward time |
| Redis replication lag | Duplicate IDs | Use WAIT or offsets |
| Ticket server down | System halt | Use dual servers |
| Range allocation crash | ID gaps | Accept gaps |
| UUID misuse (v4 in DB) | Slow inserts | Use UUID v7 |

---

## When to Use vs NOT Use

### Use
- UUID v7 → default distributed systems  
- Snowflake → high-scale internal DB  
- Auto-increment → single DB apps  
- Dual-ID → secure APIs  

### Avoid
- Sequential IDs in public APIs  
- UUID v4 for large indexed tables  
- Redis without persistence  
- Step-based auto-increment for dynamic scaling  

---

## Comparison vs Alternatives

| Strategy   | Sortable | Coordination | Size | Unguessable |
|------------|----------|-------------|------|-------------|
| UUID v4    | No       | None        | 16B  | Yes |
| UUID v7    | Yes      | None        | 16B  | Yes |
| ULID       | Yes      | None        | 16B  | Yes |
| Snowflake  | Yes      | Worker ID   | 8B   | No |
| Redis INCR | Yes      | Central     | 8B   | No |

---

## Common Pitfalls

- Using sequential IDs in public APIs (enumeration attack)
- Storing UUID as VARCHAR(36)
- Ignoring B-tree fragmentation with UUID v4
- Not handling clock rollback in Snowflake
- Using Redis without durability guarantees
