# Redis Persistence - Curriculum

## Module 1: RDB Snapshots
- [ ] RDB (Redis Database): point-in-time snapshot of entire dataset to disk
- [ ] `SAVE` — blocking snapshot (blocks all clients)
- [ ] `BGSAVE` — background snapshot (fork child process)
- [ ] Auto-save rules: `save 900 1` (save if 1 key changed in 900 seconds)
- [ ] RDB file: compact binary format, fast to load on restart
- [ ] Trade-off: data loss between snapshots (last snapshot to crash)
- [ ] Use case: backups, disaster recovery, fast restarts

## Module 2: AOF (Append-Only File)
- [ ] AOF: logs every write operation to a file
- [ ] `appendonly yes` — enable AOF
- [ ] Fsync policies:
  - [ ] `always` — fsync after every write (safest, slowest)
  - [ ] `everysec` — fsync every second (recommended — max 1s data loss)
  - [ ] `no` — OS decides when to fsync (fastest, most data loss risk)
- [ ] AOF rewrite: compact the log by removing redundant operations (`BGREWRITEAOF`)
- [ ] Auto-rewrite: `auto-aof-rewrite-percentage 100`, `auto-aof-rewrite-min-size 64mb`
- [ ] Trade-off: larger file than RDB, slower restart (replay all operations)

## Module 3: RDB + AOF Combined
- [ ] **Best practice**: enable both RDB + AOF
- [ ] On restart: Redis loads AOF first (more complete), falls back to RDB
- [ ] RDB for backups + AOF for durability = best of both
- [ ] Redis 7+: `aof-use-rdb-preamble yes` — AOF starts with RDB snapshot, then appends operations
- [ ] No persistence: `save ""` + `appendonly no` — pure cache mode (data lost on restart)
- [ ] Decision guide:
  - [ ] Cache only → no persistence
  - [ ] Can tolerate minutes of data loss → RDB only
  - [ ] Can tolerate 1 second of data loss → AOF `everysec`
  - [ ] Zero data loss required → AOF `always` (rare, use a real database instead)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Configure RDB snapshots, kill Redis, observe data recovery |
| Module 2 | Enable AOF with `everysec`, write 10K keys, kill Redis, verify 1s data loss max |
| Module 3 | Configure RDB+AOF, benchmark write performance with each fsync policy |

## Key Resources
- Redis Persistence documentation (redis.io)
- "Redis Persistence Demystified" - Antirez (Redis creator blog)
