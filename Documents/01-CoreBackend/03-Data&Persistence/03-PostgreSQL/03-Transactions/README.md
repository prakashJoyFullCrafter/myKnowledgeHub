# PostgreSQL Transactions - Curriculum

## Module 1: ACID & Transaction Basics
- [ ] **Atomicity**: all or nothing — entire transaction succeeds or rolls back
- [ ] **Consistency**: database moves from one valid state to another (constraints enforced)
- [ ] **Isolation**: concurrent transactions don't interfere with each other
- [ ] **Durability**: committed data survives crashes (WAL — Write-Ahead Log)
- [ ] `BEGIN` / `START TRANSACTION` — start transaction
- [ ] `COMMIT` — make changes permanent
- [ ] `ROLLBACK` — undo all changes
- [ ] `SAVEPOINT name` / `ROLLBACK TO name` — partial rollback within transaction

## Module 2: Isolation Levels & Anomalies
- [ ] **READ UNCOMMITTED**: PostgreSQL treats as READ COMMITTED (no dirty reads possible due to MVCC)
- [ ] **READ COMMITTED** (PG default): each statement sees latest committed data
  - [ ] Non-repeatable reads possible: same query, different results within transaction
- [ ] **REPEATABLE READ**: snapshot at first query — consistent reads throughout transaction
  - [ ] Serialization failure if concurrent write conflict → retry needed
- [ ] **SERIALIZABLE**: transactions behave as if executed sequentially
  - [ ] Detects all anomalies including write skew
  - [ ] Higher abort rate — app must retry failed transactions
- [ ] Anomaly summary: dirty read, non-repeatable read, phantom read, write skew

## Module 3: MVCC (Multi-Version Concurrency Control)
- [ ] PostgreSQL never locks rows for reads — readers don't block writers, writers don't block readers
- [ ] Each row version has `xmin` (creating transaction) and `xmax` (deleting transaction)
- [ ] UPDATE creates a new row version (old version remains until VACUUM)
- [ ] DELETE marks row's `xmax` (not physically removed until VACUUM)
- [ ] **VACUUM**: reclaims space from dead row versions
  - [ ] `autovacuum` — automatic background process
  - [ ] Tuning: `autovacuum_vacuum_scale_factor`, `autovacuum_analyze_scale_factor`
- [ ] **Long-running transactions**: block VACUUM from cleaning up → table bloat
  - [ ] Monitor: `pg_stat_activity` for old transactions
  - [ ] Prevention: set `idle_in_transaction_session_timeout`

## Module 4: Locking
- [ ] **Row-level locks**:
  - [ ] `SELECT ... FOR UPDATE` — exclusive lock, block other writers
  - [ ] `SELECT ... FOR SHARE` — shared lock, allow other readers
  - [ ] `SELECT ... FOR UPDATE SKIP LOCKED` — skip locked rows (job queue pattern)
  - [ ] `SELECT ... FOR UPDATE NOWAIT` — fail immediately if row is locked
- [ ] **Advisory locks**: application-level locks stored in PostgreSQL
  - [ ] `pg_advisory_lock(key)`, `pg_try_advisory_lock(key)`
  - [ ] Use cases: distributed locking, singleton job execution
- [ ] **Deadlock detection**: PostgreSQL auto-detects and kills one transaction
  - [ ] Prevention: always lock rows in consistent order

## Module 5: Advanced Transaction Patterns
- [ ] **Optimistic locking**: version column, check on update, retry on conflict
- [ ] **Pessimistic locking**: `SELECT FOR UPDATE` — lock row before modifying
- [ ] **`SKIP LOCKED` job queue**: workers claim different jobs without blocking
- [ ] **Two-phase commit** (`PREPARE TRANSACTION`): distributed transactions (prefer Saga pattern)
- [ ] **Retry pattern**: REPEATABLE READ / SERIALIZABLE may abort — always retry

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Money transfer with SAVEPOINT: debit → check → credit or rollback |
| Module 2 | Reproduce non-repeatable read, then prevent with REPEATABLE READ |
| Module 3 | Monitor MVCC: create table bloat with updates, observe VACUUM |
| Module 4 | Build a job queue with `SKIP LOCKED` and multiple consumers |
| Module 5 | Implement optimistic locking with version column |

## Key Resources
- PostgreSQL documentation — Transaction Isolation
- PostgreSQL documentation — Explicit Locking
- PostgreSQL Internals (interdb.jp) — MVCC deep dive
