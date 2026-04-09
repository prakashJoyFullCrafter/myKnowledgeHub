# SQL Fundamentals - Curriculum

## Module 1: Core SQL
- [ ] `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- [ ] `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`
- [ ] `DISTINCT`, `LIMIT`, `OFFSET`
- [ ] Aggregate functions: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- [ ] `CASE WHEN` expressions
- [ ] `COALESCE`, `NULLIF`, `CAST`

## Module 2: Joins
- [ ] `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`
- [ ] `CROSS JOIN` and self-joins
- [ ] Join vs subquery performance
- [ ] Multiple table joins

## Module 3: Subqueries & CTEs
- [ ] Scalar, row, and table subqueries
- [ ] Correlated subqueries
- [ ] `EXISTS` vs `IN`
- [ ] Common Table Expressions (`WITH` / CTE)
- [ ] Recursive CTEs

## Module 4: Window Functions
- [ ] `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`
- [ ] `PARTITION BY` and `ORDER BY` in windows
- [ ] `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()`
- [ ] Running totals and moving averages
- [ ] `NTILE()` for bucketing

## Module 5: DDL & Constraints
- [ ] `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`
- [ ] Data types (numeric, string, date, boolean, JSON)
- [ ] Constraints: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`
- [ ] `DEFAULT` values and `GENERATED` columns
- [ ] Normalization: 1NF, 2NF, 3NF, BCNF

## Module 6: SET Operations & Built-in Functions

### SET Operations
- [ ] `UNION` — combine results from two queries, remove duplicates
- [ ] `UNION ALL` — combine results, keep duplicates (faster — no dedup)
- [ ] `INTERSECT` — rows present in both queries
- [ ] `EXCEPT` / `MINUS` — rows in first query but not in second
- [ ] Rules: same number of columns, compatible types, ORDER BY applies to final result
- [ ] When to use: combining data from different tables/conditions, finding common/missing records

### String Functions
- [ ] `CONCAT(a, b)` / `||` operator — string concatenation
- [ ] `SUBSTRING(str, start, length)` — extract part of string
- [ ] `TRIM()`, `LTRIM()`, `RTRIM()` — remove whitespace
- [ ] `UPPER()`, `LOWER()`, `INITCAP()` — case conversion
- [ ] `LENGTH()` / `CHAR_LENGTH()` — string length
- [ ] `REPLACE(str, from, to)` — substitute text
- [ ] `POSITION(substr IN str)` — find substring location
- [ ] `LEFT(str, n)`, `RIGHT(str, n)` — extract from start/end
- [ ] `LIKE` and `ILIKE` — pattern matching (`%` = any chars, `_` = one char)
- [ ] `SIMILAR TO` / regex — advanced pattern matching

### Date & Time Functions
- [ ] `NOW()` / `CURRENT_TIMESTAMP` — current date and time
- [ ] `CURRENT_DATE`, `CURRENT_TIME` — date or time only
- [ ] `EXTRACT(YEAR FROM date)` — extract part (year, month, day, hour, minute)
- [ ] `DATE_TRUNC('month', timestamp)` — truncate to precision
- [ ] `AGE(timestamp1, timestamp2)` — interval between dates
- [ ] `INTERVAL '30 days'` — date arithmetic: `NOW() - INTERVAL '1 hour'`
- [ ] `TO_CHAR(date, 'YYYY-MM-DD')` — format date as string
- [ ] `TO_DATE(str, 'YYYY-MM-DD')` — parse string to date

### Math Functions
- [ ] `ROUND(value, decimals)`, `CEIL()`, `FLOOR()` — rounding
- [ ] `ABS()` — absolute value
- [ ] `MOD(a, b)` — modulo
- [ ] `POWER(base, exp)`, `SQRT()` — exponents
- [ ] `GREATEST(a, b, c)`, `LEAST(a, b, c)` — max/min from list

## Module 7: Views
- [ ] **View**: named stored query — acts like a virtual table
- [ ] `CREATE VIEW active_users AS SELECT * FROM users WHERE active = true`
- [ ] Querying views: `SELECT * FROM active_users` — like a table
- [ ] Views for: access control (expose subset of columns), simplification, abstraction
- [ ] `CREATE OR REPLACE VIEW` — update view definition
- [ ] **Updatable views**: simple views allow INSERT/UPDATE/DELETE through the view
- [ ] **Materialized View**: query result stored on disk (not computed on every query)
  - [ ] `CREATE MATERIALIZED VIEW monthly_stats AS SELECT ...`
  - [ ] `REFRESH MATERIALIZED VIEW monthly_stats` — manually refresh
  - [ ] `REFRESH MATERIALIZED VIEW CONCURRENTLY` — no read lock during refresh (requires unique index)
  - [ ] Use cases: dashboards, reporting, CQRS read models, expensive aggregations
  - [ ] Trade-off: stale data between refreshes vs fast query performance

## Module 8: UPSERT & Data Modification
- [ ] **UPSERT** (`INSERT ... ON CONFLICT`):
  - [ ] `INSERT INTO users(email, name) VALUES('a@b.com', 'Alice') ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name`
  - [ ] `ON CONFLICT DO NOTHING` — skip if exists
  - [ ] Conflict target: unique column or constraint name
  - [ ] `EXCLUDED` — refers to the row that was proposed for insertion
- [ ] **MERGE** (SQL standard, PostgreSQL 15+):
  - [ ] `MERGE INTO target USING source ON condition WHEN MATCHED THEN UPDATE ... WHEN NOT MATCHED THEN INSERT ...`
  - [ ] More powerful than upsert for complex sync operations
- [ ] **INSERT ... RETURNING**: get inserted/updated row back
  - [ ] `INSERT INTO users(name) VALUES('Alice') RETURNING id, name`
  - [ ] Works with UPDATE and DELETE too
- [ ] **UPDATE ... FROM**: update with join
  - [ ] `UPDATE orders SET status = 'shipped' FROM shipments WHERE orders.id = shipments.order_id`
- [ ] **DELETE with USING**: delete with join
  - [ ] `DELETE FROM orders USING users WHERE orders.user_id = users.id AND users.banned = true`
- [ ] **TRUNCATE**: fast delete all rows (no row-level logging, resets sequences)
  - [ ] `TRUNCATE TABLE orders RESTART IDENTITY CASCADE`

## Module 9: Query Performance & Effective SQL

### Anti-Patterns (Never Do This)
- [ ] **`SELECT *`** — fetches all columns, wastes bandwidth, breaks covering indexes
  - [ ] Always select only needed columns: `SELECT id, name, email FROM users`
- [ ] **Functions on indexed columns in WHERE** — prevents index usage
  - [ ] ❌ `WHERE LOWER(email) = 'a@b.com'` → ✅ create expression index OR store lowercase
  - [ ] ❌ `WHERE YEAR(created_at) = 2024` → ✅ `WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'`
- [ ] **Implicit type casting** — `WHERE id = '123'` forces cast on every row
  - [ ] ✅ Use correct type: `WHERE id = 123`
- [ ] **`OR` on different columns** — often prevents index usage
  - [ ] ✅ Rewrite as `UNION ALL` of two indexed queries
- [ ] **`NOT IN` with NULLs** — `NOT IN (1, 2, NULL)` always returns empty! Use `NOT EXISTS` instead
- [ ] **Cartesian products by accident** — forgetting JOIN condition
- [ ] **`DISTINCT` to hide bad joins** — fix the join, don't mask duplicates

### Optimization Patterns
- [ ] **Filter early**: push WHERE conditions as deep as possible (reduce rows before joins)
- [ ] **`EXISTS` vs `IN`**: prefer `EXISTS` for large subquery results (short-circuits on first match)
- [ ] **`EXISTS` vs `JOIN`**: use `EXISTS` when you only need to check existence, JOIN when you need the data
- [ ] **Avoid correlated subqueries**: run once per row — rewrite as JOIN or CTE
  - [ ] ❌ `SELECT name, (SELECT COUNT(*) FROM orders WHERE orders.user_id = u.id) FROM users u`
  - [ ] ✅ `SELECT u.name, COUNT(o.id) FROM users u LEFT JOIN orders o ON u.id = o.user_id GROUP BY u.name`
- [ ] **Batch operations**: `WHERE id IN (1,2,3)` instead of 3 separate queries
- [ ] **Use `UNION ALL` over `UNION`** when duplicates are impossible — avoids sort/dedup
- [ ] **Move computation to the database**: aggregate in SQL, not in Java — reduce data transfer

### Pagination Strategies
- [ ] **OFFSET pagination** (simple, bad at scale):
  - [ ] `SELECT * FROM orders ORDER BY id LIMIT 20 OFFSET 1000`
  - [ ] Problem: DB still scans and discards 1000 rows. Page 50000 is very slow
- [ ] **Keyset / Cursor pagination** (fast at any page):
  - [ ] `SELECT * FROM orders WHERE id > :last_seen_id ORDER BY id LIMIT 20`
  - [ ] Uses index, constant performance regardless of page number
  - [ ] Limitation: can't jump to arbitrary page (no "go to page 500")
- [ ] **Seek method with multiple columns**:
  - [ ] `WHERE (created_at, id) > (:last_date, :last_id) ORDER BY created_at, id LIMIT 20`
- [ ] When to use OFFSET: admin UIs, small datasets, simple implementation needed
- [ ] When to use keyset: APIs, infinite scroll, large datasets, performance-critical

### Efficient Counting & Aggregation
- [ ] `COUNT(*)` vs `COUNT(column)` — `COUNT(*)` counts rows, `COUNT(col)` skips NULLs
- [ ] **Approximate count** for large tables: `SELECT reltuples FROM pg_class WHERE relname = 'orders'`
- [ ] **Pre-aggregate**: store daily/hourly counts in summary table, update via trigger or batch job
- [ ] **Materialized views** for expensive aggregations — refresh periodically
- [ ] **Conditional aggregation**: `SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END)` — one query instead of multiple

### Schema Design for Performance
- [ ] **Choose correct data types**: `INT` not `BIGINT` when range allows, `VARCHAR(n)` not `TEXT` for validated fields
- [ ] **Avoid over-normalization**: 7 JOINs to show a product page = too normalized
- [ ] **Strategic denormalization**: store `order_total` on order row instead of computing `SUM(items)` every time
- [ ] **Computed/generated columns**: `GENERATED ALWAYS AS (price * quantity) STORED` — pre-computed
- [ ] **Proper foreign keys**: with indexes on FK columns (PostgreSQL doesn't auto-index FKs!)
- [ ] **Soft delete trade-off**: `WHERE deleted = false` on every query — consider partial index

### Query Checklist
- [ ] ✅ Select only needed columns
- [ ] ✅ WHERE clause uses indexed columns without functions
- [ ] ✅ JOINs on indexed columns (usually PKs/FKs)
- [ ] ✅ LIMIT for pagination, never unbounded queries
- [ ] ✅ EXISTS over IN for large sets
- [ ] ✅ EXPLAIN ANALYZE before deploying new queries
- [ ] ✅ Parameterized queries (PreparedStatement) — plan caching + security
- [ ] ✅ Avoid N+1: batch fetch or JOIN instead of loop + query

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | SQLZoo and LeetCode SQL problems |
| Module 3 | Rewrite complex subqueries as CTEs |
| Module 4 | Analytics queries: top-N per group, running totals |
| Module 5 | Design a normalized schema for an e-commerce app |
| Module 6 | Write queries using all string/date/math functions, UNION two tables |
| Module 7 | Create a materialized view for a dashboard report, set up periodic refresh |
| Module 8 | Implement upsert for a sync job, use INSERT RETURNING for API responses |
| Module 9 | Take 5 slow queries, apply anti-pattern fixes, compare EXPLAIN before/after |

## Key Resources
- SQL Performance Explained - Markus Winand (use-the-index-luke.com)
- High-Performance Java Persistence - Vlad Mihalcea
- pgMustard (pgmustard.com) — EXPLAIN plan visualizer
- "Use The Index, Luke" (use-the-index-luke.com) — free online SQL tuning guide
