# JDBC (Java Database Connectivity) - Curriculum

The foundation of all Java database access. JPA, Hibernate, Spring Data, and JdbcTemplate are all built on JDBC.

---

## Module 1: JDBC Fundamentals
- [ ] What is JDBC? Java API for relational database access
- [ ] JDBC architecture: Application → JDBC API → JDBC Driver → Database
- [ ] JDBC driver types: Type 1 (JDBC-ODBC), Type 2 (Native), Type 3 (Network), Type 4 (Thin/Pure Java)
- [ ] Type 4 is the standard today (PostgreSQL, MySQL, Oracle drivers are all Type 4)
- [ ] Adding JDBC driver dependency: `org.postgresql:postgresql`, `com.mysql:mysql-connector-j`
- [ ] JDBC URL format: `jdbc:postgresql://localhost:5432/mydb`, `jdbc:mysql://localhost:3306/mydb`

## Module 2: Connection Management
- [ ] `DriverManager.getConnection(url, user, password)` — basic connection
- [ ] `Connection` interface: the session with the database
- [ ] Always close connections: resource leak = connection exhaustion = app crash
- [ ] `try-with-resources` for auto-closing:
  ```java
  try (Connection conn = DriverManager.getConnection(url, user, pass)) {
      // use connection
  } // auto-closed here
  ```
- [ ] Connection properties: auto-commit, transaction isolation, read-only, catalog
- [ ] `conn.setAutoCommit(false)` — manual transaction control
- [ ] `DataSource` interface — preferred over `DriverManager` (poolable, configurable)
- [ ] Why `DriverManager` is only for learning — never use in production

## Module 3: Statements
- [ ] **Statement** — execute static SQL (no parameters)
  - [ ] `stmt.executeQuery("SELECT * FROM users")` — returns `ResultSet`
  - [ ] `stmt.executeUpdate("DELETE FROM users WHERE id = 1")` — returns affected rows
  - [ ] `stmt.execute("CREATE TABLE ...")` — returns boolean
  - [ ] **NEVER use Statement with user input** — SQL injection vulnerability
- [ ] **PreparedStatement** — parameterized queries (ALWAYS use this)
  - [ ] `conn.prepareStatement("SELECT * FROM users WHERE id = ?")` 
  - [ ] `pstmt.setLong(1, userId)` — set parameter by index (1-based)
  - [ ] `pstmt.setString(2, name)`, `pstmt.setInt()`, `pstmt.setTimestamp()`
  - [ ] `pstmt.setNull(1, Types.VARCHAR)` — setting NULL values
  - [ ] Why PreparedStatement? SQL injection prevention + query plan caching + type safety
  - [ ] Reusing PreparedStatement for batch operations
- [ ] **CallableStatement** — calling stored procedures
  - [ ] `conn.prepareCall("{call my_procedure(?, ?)}")`
  - [ ] IN parameters: `cstmt.setString(1, value)`
  - [ ] OUT parameters: `cstmt.registerOutParameter(2, Types.INTEGER)`
  - [ ] `cstmt.execute()` then `cstmt.getInt(2)` for OUT value
  - [ ] Functions: `{? = call my_function(?)}`

## Module 4: ResultSet Processing
- [ ] `ResultSet` — cursor-based iteration over query results
- [ ] `while (rs.next()) { ... }` — iterate rows
- [ ] Getting values by column name: `rs.getString("name")`, `rs.getLong("id")`
- [ ] Getting values by column index: `rs.getString(1)` (1-based, fragile — prefer name)
- [ ] Handling NULL: `rs.getInt("age")` returns 0 for NULL — use `rs.wasNull()` to check
- [ ] Data type mapping:
  | SQL Type | Java Type | Method |
  |----------|-----------|--------|
  | VARCHAR | String | getString() |
  | INTEGER | int | getInt() |
  | BIGINT | long | getLong() |
  | BOOLEAN | boolean | getBoolean() |
  | TIMESTAMP | Timestamp | getTimestamp() |
  | DATE | Date | getDate() |
  | DECIMAL | BigDecimal | getBigDecimal() |
  | BLOB | byte[] | getBytes() |
  | JSONB | String | getString() |
- [ ] `ResultSetMetaData` — inspect column names, types, count at runtime
- [ ] ResultSet types: `TYPE_FORWARD_ONLY` (default), `TYPE_SCROLL_INSENSITIVE`, `TYPE_SCROLL_SENSITIVE`
- [ ] ResultSet concurrency: `CONCUR_READ_ONLY` (default), `CONCUR_UPDATABLE`

## Module 5: Transactions
- [ ] Auto-commit mode: `conn.setAutoCommit(true)` (default — every statement is a transaction)
- [ ] Manual transactions:
  ```java
  conn.setAutoCommit(false);
  try {
      // execute multiple statements
      stmt1.executeUpdate(...);
      stmt2.executeUpdate(...);
      conn.commit();  // all or nothing
  } catch (SQLException e) {
      conn.rollback();  // undo all changes
      throw e;
  }
  ```
- [ ] Savepoints: `Savepoint sp = conn.setSavepoint("step1")`
  - [ ] `conn.rollback(sp)` — partial rollback to savepoint
  - [ ] `conn.releaseSavepoint(sp)` — release savepoint resources
- [ ] Transaction isolation levels:
  - [ ] `TRANSACTION_READ_UNCOMMITTED` — dirty reads possible
  - [ ] `TRANSACTION_READ_COMMITTED` — default in PostgreSQL
  - [ ] `TRANSACTION_REPEATABLE_READ` — snapshot at first read
  - [ ] `TRANSACTION_SERIALIZABLE` — full isolation, slowest
  - [ ] `conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED)`
- [ ] Read-only transactions: `conn.setReadOnly(true)` — optimization hint to database

## Module 6: Batch Processing
- [ ] Why batch? Single insert = 1 network round-trip. 1000 inserts = 1000 round-trips. Batch = 1 round-trip
- [ ] PreparedStatement batch:
  ```java
  PreparedStatement pstmt = conn.prepareStatement("INSERT INTO users(name, email) VALUES(?, ?)");
  for (User user : users) {
      pstmt.setString(1, user.getName());
      pstmt.setString(2, user.getEmail());
      pstmt.addBatch();
  }
  int[] results = pstmt.executeBatch();
  ```
- [ ] Batch size tuning: commit every N rows (e.g., 1000) to avoid memory issues
- [ ] `conn.setAutoCommit(false)` for batch — commit once after all batches
- [ ] Error handling: `BatchUpdateException` — partial batch failures
- [ ] Performance: JDBC batch insert is 10-100x faster than JPA `saveAll()` for bulk data
- [ ] PostgreSQL `COPY` command for maximum throughput (even faster than batch)

## Module 7: Connection Pooling
- [ ] Why pooling? Creating a connection is expensive (~50-100ms). Reusing is ~0ms
- [ ] **HikariCP** — fastest JDBC connection pool (Spring Boot default)
  - [ ] Configuration:
    - [ ] `maximumPoolSize` — max connections (default 10)
    - [ ] `minimumIdle` — minimum idle connections
    - [ ] `connectionTimeout` — max wait for connection from pool (30s default)
    - [ ] `idleTimeout` — max idle time before connection is closed
    - [ ] `maxLifetime` — max connection lifetime (30 min default)
    - [ ] `leakDetectionThreshold` — log warning for connection leaks
  - [ ] Sizing formula: `connections = (core_count * 2) + spindle_count`
  - [ ] For most apps: 10-20 connections is sufficient (more is NOT better)
- [ ] **PgBouncer** — external connection pooler for PostgreSQL
  - [ ] Transaction mode vs session mode
  - [ ] When to use: many microservices sharing one database
- [ ] Connection leak detection: `leakDetectionThreshold = 60000` (warn after 60s)
- [ ] Monitoring: HikariCP exposes metrics via JMX and Micrometer
- [ ] Spring Boot auto-configuration: `spring.datasource.hikari.*` properties

## Module 8: Spring JdbcTemplate
- [ ] Why JdbcTemplate? Eliminates JDBC boilerplate (connection, statement, resultset, close, exception handling)
- [ ] `JdbcTemplate` — core template class
  - [ ] `jdbcTemplate.queryForObject("SELECT name FROM users WHERE id = ?", String.class, id)`
  - [ ] `jdbcTemplate.queryForList("SELECT name FROM users", String.class)`
  - [ ] `jdbcTemplate.query("SELECT * FROM users", rowMapper)` — custom mapping
  - [ ] `jdbcTemplate.update("INSERT INTO users(name) VALUES(?)", name)` — insert/update/delete
  - [ ] `jdbcTemplate.batchUpdate(sql, batchArgs)` — batch operations
- [ ] **RowMapper** — map ResultSet row to object:
  ```java
  RowMapper<User> mapper = (rs, rowNum) -> new User(
      rs.getLong("id"),
      rs.getString("name"),
      rs.getString("email")
  );
  List<User> users = jdbcTemplate.query("SELECT * FROM users", mapper);
  ```
- [ ] **NamedParameterJdbcTemplate** — named parameters instead of `?`
  - [ ] `"SELECT * FROM users WHERE name = :name AND age > :age"`
  - [ ] `MapSqlParameterSource` or `BeanPropertySqlParameterSource`
- [ ] **SimpleJdbcInsert** — simplified inserts
  - [ ] `simpleJdbcInsert.withTableName("users").usingGeneratedKeyColumns("id")`
  - [ ] `Number key = simpleJdbcInsert.executeAndReturnKey(parameters)`
- [ ] **SimpleJdbcCall** — simplified stored procedure calls
- [ ] Exception translation: Spring converts `SQLException` → `DataAccessException` hierarchy

## Module 9: JDBC vs JPA — When to Use Which

| Criteria | JDBC / JdbcTemplate | JPA / Spring Data |
|----------|--------------------|--------------------|
| Bulk insert (10K+ rows) | JDBC batch (10-100x faster) | JPA saveAll() is slow |
| Complex queries | Write SQL directly | JPQL limited, native query needed |
| Simple CRUD | More boilerplate | Repository methods, zero SQL |
| Relationships | Manual joins | Automatic with @OneToMany etc. |
| Caching | Manual | First/second level cache built-in |
| Schema generation | Manual DDL | Auto from entities |
| Stored procedures | CallableStatement / SimpleJdbcCall | @Procedure (limited) |
| Read-heavy reporting | JdbcTemplate + custom SQL | Projections / DTO queries |
| Learning curve | Lower (SQL knowledge) | Higher (JPA concepts) |

- [ ] When to use JDBC: bulk operations, complex reporting, stored procedures, max performance
- [ ] When to use JPA: standard CRUD, entity relationships, rapid development
- [ ] Hybrid approach: JPA for CRUD, JdbcTemplate for reporting/bulk — same DataSource
- [ ] Spring Data JDBC: simpler alternative to JPA (no lazy loading, no session, DDD-friendly)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Raw JDBC CRUD: connect, insert, query, update, delete with PreparedStatement |
| Module 4 | Build a generic ResultSet-to-Object mapper |
| Module 5 | Money transfer with manual transaction: debit + credit with rollback on failure |
| Module 6 | Bulk import 100K rows: compare single insert vs batch vs COPY |
| Module 7 | Configure HikariCP, simulate connection leak, detect with leakDetectionThreshold |
| Module 8 | Rewrite raw JDBC code to JdbcTemplate — compare code volume |
| Module 9 | Same CRUD app: implement with JPA AND JdbcTemplate, benchmark both |

## Key Resources
- JDBC API documentation (Oracle)
- Spring JdbcTemplate Reference Documentation
- HikariCP documentation (GitHub)
- High-Performance Java Persistence - Vlad Mihalcea
- Java Database Best Practices (Baeldung)
