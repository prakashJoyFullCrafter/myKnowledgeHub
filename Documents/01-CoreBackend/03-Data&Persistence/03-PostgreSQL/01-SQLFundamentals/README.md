# PostgreSQL SQL Fundamentals - Curriculum

## Module 1: PostgreSQL-Specific Data Types
- [ ] `SERIAL` / `BIGSERIAL` — auto-increment (legacy, prefer `GENERATED ALWAYS AS IDENTITY`)
- [ ] `UUID` — universally unique identifier, `gen_random_uuid()` (PG 13+)
- [ ] `JSONB` — binary JSON storage, indexable, queryable
- [ ] `ARRAY` — native array type: `INTEGER[]`, `TEXT[]`
- [ ] `INET` / `CIDR` — IP address and network types
- [ ] `TSRANGE`, `DATERANGE`, `INT4RANGE` — range types with containment/overlap operators
- [ ] `ENUM` — custom enum types: `CREATE TYPE status AS ENUM ('active', 'inactive')`
- [ ] `INTERVAL` — time duration: `INTERVAL '2 hours 30 minutes'`
- [ ] `BYTEA` — binary data storage

## Module 2: JSONB Operations
- [ ] `->` — get JSON object by key (returns JSON): `data->'address'`
- [ ] `->>` — get JSON value as text: `data->>'name'`
- [ ] `#>` / `#>>` — nested path access: `data#>'{address,city}'`
- [ ] `@>` — containment: `data @> '{"status": "active"}'`
- [ ] `?` — key exists: `data ? 'email'`
- [ ] `?|` / `?&` — any/all keys exist
- [ ] `jsonb_set()` — update nested value
- [ ] `jsonb_agg()`, `jsonb_object_agg()` — aggregate to JSON
- [ ] `jsonb_array_elements()` — unnest JSON array
- [ ] GIN index on JSONB for fast containment queries
- [ ] When to use JSONB vs relational columns — decision guide

## Module 3: Arrays & Full-Text Search
### Arrays
- [ ] `ANY()` — match any element: `WHERE 'admin' = ANY(roles)`
- [ ] `ALL()` — match all elements
- [ ] `array_agg()` — aggregate rows into array
- [ ] `unnest()` — expand array to rows
- [ ] `@>` — array containment: `roles @> ARRAY['admin', 'user']`
- [ ] GIN index on array columns

### Full-Text Search
- [ ] `tsvector` — text broken into searchable tokens
- [ ] `tsquery` — search query: `to_tsquery('english', 'java & spring')`
- [ ] `@@` — match operator: `to_tsvector(body) @@ to_tsquery('java')`
- [ ] `ts_rank()` — relevance scoring
- [ ] GIN index on `tsvector` for fast search
- [ ] `tsvector` column + trigger for pre-computed search vectors
- [ ] When to use PG full-text vs Elasticsearch — decision guide

## Module 4: Advanced Query Features
- [ ] `RETURNING` clause: `INSERT INTO users(name) VALUES('Alice') RETURNING id`
- [ ] `ON CONFLICT DO UPDATE` (UPSERT): atomic insert-or-update
- [ ] **Lateral joins** (`LATERAL`): subquery that references preceding table
  - [ ] `SELECT u.*, o.* FROM users u, LATERAL (SELECT * FROM orders WHERE user_id = u.id ORDER BY created_at DESC LIMIT 3) o`
  - [ ] Use case: top-N per group without window functions
- [ ] `COPY` for bulk import/export: `COPY users FROM '/path/data.csv' CSV HEADER`
  - [ ] 10-100x faster than INSERT for bulk loading
  - [ ] `\copy` in psql for client-side files
- [ ] `GENERATE_SERIES()` — generate rows: `SELECT generate_series(1, 100)`
- [ ] `TABLESAMPLE` — sample random rows without full scan
- [ ] Regular expressions: `~` (match), `~*` (case-insensitive), `regexp_matches()`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Create a table using UUID, JSONB, ARRAY, and range types |
| Module 2 | Build a product catalog with JSONB attributes, query with containment and path operators |
| Module 3 | Implement full-text search on a blog posts table, compare with LIKE queries |
| Module 4 | Use lateral join for "top 3 orders per user", bulk import 1M rows with COPY |

## Key Resources
- PostgreSQL official documentation (postgresql.org/docs)
- "The Art of PostgreSQL" - Dimitri Fontaine
- PostgreSQL JSONB documentation
