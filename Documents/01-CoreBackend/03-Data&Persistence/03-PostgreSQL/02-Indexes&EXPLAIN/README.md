# PostgreSQL Indexes & EXPLAIN - Curriculum

## Module 1: Index Types
- [ ] B-tree (default) - equality and range queries
- [ ] Hash index - equality only
- [ ] GIN (Generalized Inverted Index) - JSONB, arrays, full-text
- [ ] GiST (Generalized Search Tree) - geometric, range types
- [ ] BRIN (Block Range Index) - large sorted tables
- [ ] Partial indexes (`WHERE` clause)
- [ ] Expression indexes (`CREATE INDEX ON ... (lower(email))`)
- [ ] Multi-column indexes and column order

## Module 2: EXPLAIN & Query Planning
- [ ] `EXPLAIN` vs `EXPLAIN ANALYZE` vs `EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)`
- [ ] Reading execution plans: Seq Scan, Index Scan, Bitmap Scan
- [ ] Nested Loop, Hash Join, Merge Join
- [ ] Cost estimation and row estimates
- [ ] Identifying slow queries: `pg_stat_statements`
- [ ] `auto_explain` for automatic plan logging

## Module 3: Index Optimization
- [ ] When indexes help vs when they don't
- [ ] Covering indexes (`INCLUDE` clause)
- [ ] Index-only scans
- [ ] Bloated indexes and `REINDEX`
- [ ] `pg_stat_user_indexes` - unused index detection
- [ ] Composite index vs multiple single-column indexes
