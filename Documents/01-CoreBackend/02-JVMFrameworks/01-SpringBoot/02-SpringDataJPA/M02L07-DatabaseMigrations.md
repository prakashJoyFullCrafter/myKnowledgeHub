# Database Migrations: Flyway & Liquibase — Complete Study Guide

> **Module 7 | Brutally Detailed Reference**
> Covers why migrations exist, Flyway naming conventions, commands, callbacks, Liquibase changesets and rollbacks, zero-downtime migration patterns, Spring Boot auto-configuration, and the Flyway vs Liquibase decision guide. Every section includes full working examples.

---

## Table of Contents

1. [Why Database Migrations?](#1-why-database-migrations)
2. [Flyway — Core Concepts](#2-flyway--core-concepts)
3. [Flyway Migration Naming Conventions](#3-flyway-migration-naming-conventions)
4. [Flyway Commands](#4-flyway-commands)
5. [Flyway Baseline — Existing Databases](#5-flyway-baseline--existing-databases)
6. [Flyway Callbacks](#6-flyway-callbacks)
7. [Liquibase — Core Concepts](#7-liquibase--core-concepts)
8. [Liquibase Changesets In Depth](#8-liquibase-changesets-in-depth)
9. [Liquibase Rollbacks](#9-liquibase-rollbacks)
10. [Liquibase Preconditions and Contexts](#10-liquibase-preconditions-and-contexts)
11. [Spring Boot Integration](#11-spring-boot-integration)
12. [Best Practices](#12-best-practices)
13. [Flyway vs Liquibase Decision Guide](#13-flyway-vs-liquibase-decision-guide)
14. [Quick Reference Cheat Sheet](#14-quick-reference-cheat-sheet)

---

## 1. Why Database Migrations?

### 1.1 The Problem Without Migrations

Without a migration tool, schema changes are applied manually and inconsistently:

```
Developer A: "I ran ALTER TABLE users ADD COLUMN last_login TIMESTAMP on my laptop"
Developer B: "I never got that change — my dev DB doesn't have last_login"
QA:          "The staging DB is 3 versions behind — which SQLs apply?"
Production:  "What is the exact state of production right now?"

Result:
- Database state diverges between environments
- "Works on my machine" bugs from schema differences
- Deployments fail because app code expects columns that don't exist
- No audit trail of who changed what and when
- No rollback path when something goes wrong
- Onboarding new developers requires manual DB setup steps
```

### 1.2 What Migration Tools Provide

```
Version-controlled schema:    Every change is a tracked file in Git
Reproducible environments:    Any environment can be built from scratch
Audit trail:                  Who applied what migration, when
Automation:                   Migrations run automatically on deploy
Safe collaboration:           Concurrent schema changes are detected (checksum validation)
Self-documenting:             Migration files ARE the schema history
Rollback path:                (Liquibase) revert to known state
```

### 1.3 How Migration Tools Work

Both Flyway and Liquibase use a **metadata table** in the database to track which migrations have been applied:

```
Flyway:    flyway_schema_history  table
Liquibase: databasechangelog      table

On startup:
1. Tool reads the metadata table → knows what's already applied
2. Tool scans migration files → finds new ones not yet applied
3. Tool applies pending migrations in order
4. Tool records each applied migration in the metadata table

If migration already applied → skip it
If migration checksum changed → error (someone modified an applied migration)
If new migration found → apply it
```

---

## 2. Flyway — Core Concepts

### 2.1 Spring Boot Auto-Configuration

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-flyway</artifactId>
</dependency>
```

With this on the classpath, Spring Boot:
1. Creates a `Flyway` bean automatically
2. Runs `flyway.migrate()` **before** Hibernate validates/creates the schema
3. Uses the configured `DataSource` automatically
4. Looks for migrations in `classpath:db/migration` by default

```
Startup order (critical):
  DataSource configured
       ↓
  Flyway.migrate() runs  ← schema changes applied HERE
       ↓
  JPA/Hibernate EntityManagerFactory created
       ↓  (Hibernate validates schema against @Entity definitions)
  Application ready
```

### 2.2 Project Structure

```
src/
  main/
    resources/
      db/
        migration/
          V1__create_users_table.sql
          V2__add_email_column.sql
          V3__create_orders_table.sql
          V4__add_indexes.sql
          R__refresh_materialized_views.sql
      application.properties
```

### 2.3 The `flyway_schema_history` Table

Flyway maintains this table automatically. Understanding it is essential for debugging:

```sql
-- Example flyway_schema_history contents after 3 migrations
SELECT installed_rank, version, description, type, script, checksum, installed_on, success
FROM flyway_schema_history
ORDER BY installed_rank;

-- installed_rank | version | description          | type | script                        | checksum   | installed_on        | success
-- 1              | 1       | create users table   | SQL  | V1__create_users_table.sql    | 1234567890 | 2024-01-10 09:00:00 | true
-- 2              | 2       | add email column     | SQL  | V2__add_email_column.sql      | 0987654321 | 2024-01-15 14:30:00 | true
-- 3              | 3       | create orders table  | SQL  | V3__create_orders_table.sql   | 1122334455 | 2024-01-20 10:00:00 | true
```

---

## 3. Flyway Migration Naming Conventions

### 3.1 Naming Pattern

```
{Prefix}{Version}__{Description}.{extension}
   │        │           │              │
   │        │           │              └── sql, java
   │        │           └── Words separated by underscores or spaces
   │        └── Major.minor.patch or just integer
   └── V = versioned, U = undo, R = repeatable
```

### 3.2 Versioned Migrations — `V{version}__{description}.sql`

Standard migrations that run once, in order, never again:

```sql
-- V1__create_users_table.sql
CREATE TABLE users (
    id         BIGSERIAL PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- V2__add_email_column.sql  (bad example name — already in V1, but shows the concept)
ALTER TABLE users ADD COLUMN last_login TIMESTAMP;
ALTER TABLE users ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

-- V3__create_orders_table.sql
CREATE TABLE orders (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users(id),
    total       DECIMAL(10,2) NOT NULL,
    placed_at   TIMESTAMP    NOT NULL DEFAULT NOW(),
    status      VARCHAR(20)  NOT NULL DEFAULT 'PENDING'
);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status  ON orders(status);

-- V4__add_audit_columns.sql
ALTER TABLE users   ADD COLUMN updated_at TIMESTAMP;
ALTER TABLE orders  ADD COLUMN updated_at TIMESTAMP;

-- V2_1__backfill_display_names.sql  ← decimal versioning for hotfix between V2 and V3
UPDATE users SET display_name = username WHERE display_name IS NULL;
```

**Versioning strategies:**
```
Integer:      V1, V2, V3           — simple, most common
Decimal:      V1.1, V1.2, V2.0    — allows inserting between versions
Date-based:   V20240115_1430__...  — good for teams, avoids number conflicts
Timestamp:    V1705320600__...     — Unix epoch, globally unique
```

### 3.3 Repeatable Migrations — `R__{description}.sql`

Run whenever their checksum changes. No version number. Used for things that should be re-applied when they change (views, stored procedures, functions):

```sql
-- R__create_user_search_view.sql
-- This view is re-created every time this file changes
CREATE OR REPLACE VIEW user_search_view AS
SELECT
    u.id,
    u.username,
    u.email,
    u.display_name,
    COUNT(o.id) AS order_count,
    MAX(o.placed_at) AS last_order_date
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.is_active = true
GROUP BY u.id, u.username, u.email, u.display_name;

-- R__stored_procedures.sql
CREATE OR REPLACE FUNCTION calculate_user_discount(user_id BIGINT)
RETURNS DECIMAL AS $$
DECLARE
    order_count INT;
BEGIN
    SELECT COUNT(*) INTO order_count FROM orders WHERE user_id = $1;
    RETURN CASE
        WHEN order_count >= 100 THEN 0.20
        WHEN order_count >= 50  THEN 0.10
        WHEN order_count >= 10  THEN 0.05
        ELSE 0.0
    END;
END;
$$ LANGUAGE plpgsql;
```

**How repeatable migrations are ordered:**
- All versioned migrations run first, then repeatable ones
- Repeatable migrations run in alphabetical order by description
- A repeatable migration only re-runs if its checksum changed since last run

### 3.4 Java-Based Migrations

For complex migrations that can't be expressed in SQL:

```java
// db/migration/V5__migrate_user_data.java
// Must be in db.migration package and on the classpath
package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;
import java.sql.*;

public class V5__migrate_user_data extends BaseJavaMigration {

    @Override
    public void migrate(Context context) throws Exception {
        Connection connection = context.getConnection();

        // Read all users
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id, first_name, last_name FROM users_old")) {

            try (PreparedStatement insert = connection.prepareStatement(
                    "INSERT INTO users (id, display_name) VALUES (?, ?)")) {

                while (rs.next()) {
                    insert.setLong(1, rs.getLong("id"));
                    insert.setString(2, rs.getString("first_name")
                        + " " + rs.getString("last_name"));
                    insert.addBatch();
                }
                insert.executeBatch();
            }
        }
    }
}
```

---

## 4. Flyway Commands

### 4.1 Command Overview

```bash
# Maven plugin (mvn flyway:<command>)
mvn flyway:migrate   # Apply pending migrations
mvn flyway:validate  # Verify applied migrations match files
mvn flyway:info      # Print migration status
mvn flyway:repair    # Fix metadata table
mvn flyway:clean     # DROP everything — DANGEROUS
mvn flyway:baseline  # Mark existing schema as version N
mvn flyway:undo      # Undo last migration (requires Flyway Teams)

# Programmatic (in Java code)
Flyway flyway = Flyway.configure().dataSource(url, user, pass).load();
flyway.migrate();
flyway.validate();
flyway.info();
flyway.repair();
flyway.clean(); // NEVER in production
```

### 4.2 `migrate` — Apply Pending Migrations

```
migrate:
1. Reads flyway_schema_history to see what's applied
2. Scans migration locations for .sql/.java files
3. For each unapplied migration (in version order):
   a. Begin transaction
   b. Execute SQL
   c. Record in flyway_schema_history
   d. Commit
4. Report success/failure

Output:
  Successfully applied 3 migrations to schema "public",
  now at version v4 (execution time 00:00.234s)
```

### 4.3 `validate` — Detect Tampering

```
validate checks:
- All applied migrations still have the same checksum
- No applied migration files are missing
- No pending migrations exist that weren't expected

Common validate failures:
  ERROR: Validate failed: Migration checksum mismatch for migration version 2
         -> Applied to database : 1234567890
         -> Resolved locally    : 9876543210
  
  Cause: Someone modified V2__add_email_column.sql after it was applied

Fix options:
  1. Revert the file change (preserve original SQL)
  2. If intentional: flyway repair to update checksum (only safe if you KNOW what changed)
  3. Write a new migration V5__fix_email_column.sql instead
```

### 4.4 `info` — Migration Status

```
info output:
+-----------+---------+---------------------+------+---------------------+---------+
| Category  | Version | Description         | Type | Installed On        | State   |
+-----------+---------+---------------------+------+---------------------+---------+
| Versioned | 1       | create users table  | SQL  | 2024-01-10 09:00:00 | Success |
| Versioned | 2       | add email column    | SQL  | 2024-01-15 14:30:00 | Success |
| Versioned | 3       | create orders table | SQL  | 2024-01-20 10:00:00 | Success |
| Versioned | 4       | add audit columns   | SQL  |                     | Pending | ← not applied yet
| Repeatable|         | create user view    | SQL  | 2024-01-10 09:00:01 | Success |
+-----------+---------+---------------------+------+---------------------+---------+
```

### 4.5 `repair` — Fix Metadata Issues

```
repair use cases:

1. Failed migration left a partial record:
   A migration failed halfway — Flyway recorded it as failed in schema_history
   flyway repair: removes the failed record so it can be retried

2. Migration file was accidentally modified:
   flyway repair: recalculates checksums to match current files
   (WARNING: only do this if you UNDERSTAND what changed and why)

3. Migration file was deleted:
   flyway repair: removes the deleted migration's record from history
   (WARNING: the schema changes are still applied — repair just removes the tracking record)

When to use repair safely:
  ✓ Dev environment — cleaning up after failed experiments
  ✓ Failed migration with NO partial data changes (DDL auto-rolled back)
  ✗ Production — understand the exact issue before using repair
```

### 4.6 `clean` — Nuclear Option

```sql
-- clean drops EVERYTHING in the schema:
-- All tables, views, sequences, indexes, stored procedures, triggers

-- NEVER run clean in production:
-- spring.flyway.clean-disabled=true  ← set this in production!

-- Safe use: dev environment, test setup/teardown
// In tests:
@BeforeEach
void resetDatabase() {
    flyway.clean();
    flyway.migrate();
}
```

---

## 5. Flyway Baseline — Existing Databases

### 5.1 The Problem

When adopting Flyway on a database that already exists (pre-Flyway schema), you can't run V1 migration because the tables it creates already exist:

```
Production database: already has users, orders, products tables
                     but no flyway_schema_history table

Flyway first run: tries to run V1__create_users_table.sql
                  → ERROR: table "users" already exists
```

### 5.2 Baseline Solution

Baseline marks the current database state as a known version WITHOUT running any migrations:

```properties
# application.properties
spring.flyway.baseline-on-migrate=true
spring.flyway.baseline-version=1   # Mark current state as version 1
# (or: spring.flyway.baseline-version=0 to run V1 and above)
```

```
baseline behavior:
1. If flyway_schema_history doesn't exist: create it
2. Insert a baseline record: version=1, type=BASELINE
3. Skip all migrations up to and including baseline-version
4. Apply migrations AFTER baseline-version (V2, V3, etc.)

flyway_schema_history after baseline:
version | description  | type     | success
1       | << Flyway Baseline >> | BASELINE | true     ← baseline marker
2       | add feature  | SQL      | true               ← applied as normal
```

### 5.3 Baseline Strategy for Migration Adoption

```
Step 1: Generate a V1 migration from current production schema
        mysqldump --no-data prod_db > src/main/resources/db/migration/V1__initial_schema.sql
        (or use a schema dump tool)

Step 2: Set baseline-version=0 so V1 runs in dev but is skipped in production
        spring.flyway.baseline-on-migrate=true
        spring.flyway.baseline-version=0

Step 3: Apply baseline to production (creates flyway_schema_history with version=0)
        flyway baseline -baselineVersion=0

Step 4: Future runs on production will apply V1, V2, etc. normally
        But V1 is skipped because it's "at or before" the baseline
```

---

## 6. Flyway Callbacks

### 6.1 Available Callback Events

Callbacks let you hook into the Flyway lifecycle:

```
Before events:
  beforeMigrate        — before any migration runs
  beforeEachMigrate    — before each individual migration
  beforeValidate       — before validation starts
  beforeClean          — before clean runs
  beforeInfo           — before info runs
  beforeRepair         — before repair runs
  beforeBaseline       — before baseline runs

After events:
  afterMigrate         — after all migrations complete successfully
  afterMigrateError    — after migration fails
  afterEachMigrate     — after each individual migration
  afterEachMigrateError — after each individual migration fails
  afterValidate
  afterClean
  afterInfo
  afterRepair
```

### 6.2 SQL Callbacks

Create SQL files named after the callback event in your migration location:

```sql
-- db/migration/beforeMigrate.sql
-- Runs before every migration batch
-- Common use: disable constraints during migration

SET session_replication_role = replica;  -- PostgreSQL: disable FK checks

-- db/migration/afterMigrate.sql
-- Runs after all migrations complete successfully
-- Common use: re-enable constraints, refresh caches, notify systems

SET session_replication_role = DEFAULT; -- re-enable FK checks

-- Notify monitoring system
INSERT INTO system_events (event_type, occurred_at, details)
VALUES ('SCHEMA_MIGRATION', NOW(), 'Flyway migration completed');
```

### 6.3 Java Callbacks

For complex logic that can't be expressed in SQL:

```java
import org.flywaydb.core.api.callback.*;

@Component  // Spring component — Flyway auto-discovers it
public class MigrationAuditCallback implements Callback {

    private final AuditService auditService;

    public MigrationAuditCallback(AuditService auditService) {
        this.auditService = auditService;
    }

    @Override
    public boolean supports(Event event, Context context) {
        // Only handle these specific events
        return event == Event.AFTER_EACH_MIGRATE
            || event == Event.AFTER_EACH_MIGRATE_ERROR;
    }

    @Override
    public boolean canHandleInTransaction(Event event, Context context) {
        return true;
    }

    @Override
    public void handle(Event event, Context context) {
        MigrationInfo info = context.getMigrationInfo();

        if (event == Event.AFTER_EACH_MIGRATE) {
            auditService.log(
                "Migration applied: " + info.getScript()
                + " (version: " + info.getVersion() + ")"
            );
        } else {
            auditService.logError(
                "Migration FAILED: " + info.getScript()
                + " - " + context.getStatement()
            );
        }
    }
}
```

---

## 7. Liquibase — Core Concepts

### 7.1 Spring Boot Auto-Configuration

```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-liquibase</artifactId>
</dependency>
```

```yaml
# application.yml
spring:
  liquibase:
    change-log: classpath:db/changelog/db.changelog-master.yaml
    enabled: true
    default-schema: public
    contexts: production  # run only changesets with context=production
    labels: "feature-x"  # run only changesets with label feature-x
```

### 7.2 Changelog Formats

Liquibase supports four formats. All are equivalent in capability:

```
XML (most complete, best tooling support):
  db/changelog/db.changelog-master.xml

YAML (readable, popular in Spring Boot projects):
  db/changelog/db.changelog-master.yaml

JSON (least common):
  db/changelog/db.changelog-master.json

SQL (closest to Flyway, familiar to DBAs):
  db/changelog/db.changelog-master.sql
  (requires special -- liquibase formatted sql comment at top)
```

### 7.3 Master Changelog — The Entry Point

The master changelog includes other changelogs. This enables splitting the history into multiple files:

```yaml
# db/changelog/db.changelog-master.yaml
databaseChangeLog:
  - includeAll:
      path: db/changelog/changes/    # include all files in directory (in filename order)
      relativeToChangelogFile: false

# OR include individual files:
databaseChangeLog:
  - include:
      file: db/changelog/changes/001-create-users.yaml
  - include:
      file: db/changelog/changes/002-create-orders.yaml
  - include:
      file: db/changelog/changes/003-add-indexes.yaml
```

```xml
<!-- db/changelog/db.changelog-master.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
    xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <includeAll path="db/changelog/changes/" relativeToChangelogFile="false"/>
</databaseChangeLog>
```

---

## 8. Liquibase Changesets In Depth

### 8.1 YAML Changeset Format

```yaml
# db/changelog/changes/001-create-users.yaml
databaseChangeLog:
  - changeSet:
      id: 001-create-users-table
      author: alice
      comment: "Initial users table creation"
      changes:
        - createTable:
            tableName: users
            columns:
              - column:
                  name: id
                  type: BIGINT
                  autoIncrement: true
                  constraints:
                    primaryKey: true
                    nullable: false
              - column:
                  name: username
                  type: VARCHAR(50)
                  constraints:
                    nullable: false
                    unique: true
              - column:
                  name: email
                  type: VARCHAR(255)
                  constraints:
                    nullable: false
                    unique: true
              - column:
                  name: created_at
                  type: TIMESTAMP
                  defaultValueComputed: NOW()
                  constraints:
                    nullable: false
      rollback:
        - dropTable:
            tableName: users
```

### 8.2 XML Changeset Format

```xml
<!-- db/changelog/changes/002-create-orders.xml -->
<databaseChangeLog ...>

    <changeSet id="002-create-orders-table" author="bob">
        <comment>Create orders table with FK to users</comment>

        <createTable tableName="orders">
            <column name="id" type="BIGINT" autoIncrement="true">
                <constraints primaryKey="true" nullable="false"/>
            </column>
            <column name="user_id" type="BIGINT">
                <constraints nullable="false"
                             foreignKeyName="fk_orders_user_id"
                             references="users(id)"/>
            </column>
            <column name="total" type="DECIMAL(10,2)">
                <constraints nullable="false"/>
            </column>
            <column name="status" type="VARCHAR(20)" defaultValue="PENDING">
                <constraints nullable="false"/>
            </column>
            <column name="placed_at" type="TIMESTAMP" defaultValueComputed="NOW()">
                <constraints nullable="false"/>
            </column>
        </createTable>

        <createIndex tableName="orders" indexName="idx_orders_user_id">
            <column name="user_id"/>
        </createIndex>

        <rollback>
            <dropTable tableName="orders"/>
        </rollback>
    </changeSet>

    <changeSet id="003-add-order-index-status" author="bob">
        <createIndex tableName="orders" indexName="idx_orders_status">
            <column name="status"/>
        </createIndex>

        <rollback>
            <dropIndex tableName="orders" indexName="idx_orders_status"/>
        </rollback>
    </changeSet>
</databaseChangeLog>
```

### 8.3 SQL Format Changeset

```sql
-- db/changelog/changes/004-add-audit-columns.sql
-- liquibase formatted sql     ← REQUIRED: this comment must be first line

-- changeset alice:004-add-audit-columns
ALTER TABLE users   ADD COLUMN updated_at TIMESTAMP;
ALTER TABLE orders  ADD COLUMN updated_at TIMESTAMP;

-- rollback ALTER TABLE users  DROP COLUMN updated_at;
-- rollback ALTER TABLE orders DROP COLUMN updated_at;
```

### 8.4 Changeset Attributes — `id`, `author`, `runAlways`, `runOnChange`

```yaml
# Standard changeset (runs once, tracked by id+author):
- changeSet:
    id: 001-create-users
    author: alice
    # runs once — never again once applied

# runAlways: true — runs on EVERY Liquibase execution
# Use for: health checks, data corrections that must always apply
- changeSet:
    id: refresh-user-stats
    author: alice
    runAlways: true
    changes:
      - sql:
          sql: REFRESH MATERIALIZED VIEW user_stats;

# runOnChange: true — re-runs when the changeset content changes
# Use for: stored procedures, views (similar to Flyway's R__ migrations)
- changeSet:
    id: create-search-view
    author: alice
    runOnChange: true
    changes:
      - createView:
          viewName: user_search_view
          replaceIfExists: true
          selectQuery: >
            SELECT u.id, u.username, u.email, COUNT(o.id) AS order_count
            FROM users u LEFT JOIN orders o ON o.user_id = u.id
            GROUP BY u.id, u.username, u.email

# failOnError: false — continue if changeset fails
# Use for: optional features, non-critical migrations
- changeSet:
    id: create-optional-stats-table
    author: alice
    failOnError: false
    changes:
      - sql:
          sql: "CREATE TABLE optional_stats IF NOT EXISTS (id BIGSERIAL PRIMARY KEY);"
```

### 8.5 The `databasechangelog` Tracking Table

```sql
-- Liquibase's equivalent of Flyway's flyway_schema_history
SELECT id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description
FROM databasechangelog
ORDER BY orderexecuted;

-- id                           | author | filename                | dateexecuted        | exectype
-- 001-create-users-table       | alice  | changes/001-users.yaml  | 2024-01-10 09:00:00 | EXECUTED
-- 002-create-orders-table      | bob    | changes/002-orders.xml  | 2024-01-10 09:00:01 | EXECUTED
-- refresh-user-stats           | alice  | changes/views.yaml      | 2024-01-10 09:00:02 | EXECUTED
-- (and re-executed every run because runAlways=true)
```

---

## 9. Liquibase Rollbacks

### 9.1 The Key Advantage Over Flyway

Liquibase supports **declarative rollbacks** — you define the rollback SQL alongside each changeset. Flyway does not support rollback in the community edition (requires Flyway Teams/Enterprise).

### 9.2 Explicit Rollback Blocks

```yaml
databaseChangeLog:
  - changeSet:
      id: 005-add-phone-column
      author: carol
      changes:
        - addColumn:
            tableName: users
            columns:
              - column:
                  name: phone
                  type: VARCHAR(20)
      # Explicit rollback: what to do when rolling back
      rollback:
        - dropColumn:
            tableName: users
            columnName: phone

  - changeSet:
      id: 006-create-product-table
      author: carol
      changes:
        - createTable:
            tableName: products
            columns:
              - column:
                  name: id
                  type: BIGINT
                  autoIncrement: true
                  constraints:
                    primaryKey: true
              - column:
                  name: name
                  type: VARCHAR(200)
                  constraints:
                    nullable: false
      rollback:
        - dropTable:
            tableName: products
```

### 9.3 Auto-Rollback (for Standard Changes)

Many Liquibase change types have **auto-generated rollbacks** — you don't need to write them:

```yaml
# These changeset types auto-generate their rollback:
- createTable → rollback: dropTable
- addColumn   → rollback: dropColumn
- createIndex → rollback: dropIndex
- addForeignKeyConstraint → rollback: dropForeignKeyConstraint
- createSequence → rollback: dropSequence
- renameColumn → rollback: renameColumn (back to original name)

# These do NOT auto-generate rollback (must specify explicitly):
- dropTable    → you must write: createTable (full schema)
- dropColumn   → you must write: addColumn
- insert       → you must write: delete (matching the inserted data)
- sql          → always write rollback manually
```

### 9.4 Rollback Markers

```bash
# Rollback to a specific tag
liquibase --changeLogFile=db.changelog-master.yaml tag release-1.5
# (run this after a known-good deployment to mark it)

# Later, if release-1.6 has problems:
liquibase --changeLogFile=db.changelog-master.yaml rollback release-1.5
# Rolls back all changesets applied since the release-1.5 tag

# Rollback a specific number of changesets
liquibase --changeLogFile=db.changelog-master.yaml rollbackCount 3
# Reverts the last 3 applied changesets

# Rollback to a specific date
liquibase --changeLogFile=db.changelog-master.yaml rollbackToDate 2024-01-15T00:00:00
```

### 9.5 Rollback SQL Generation (Dry Run)

```bash
# Generate the rollback SQL without executing it — useful for review
liquibase --changeLogFile=db.changelog-master.yaml rollbackSQL release-1.5

# Output:
-- *********************************************************************
-- Rollback to 'release-1.5' Script
-- *********************************************************************
ALTER TABLE users DROP COLUMN phone;
DROP TABLE products;
-- Liquibase: Update Failed!
```

---

## 10. Liquibase Preconditions and Contexts

### 10.1 Preconditions — Guard Conditions

Preconditions verify database state before running a changeset. If the precondition fails, the changeset is skipped or the migration fails:

```yaml
databaseChangeLog:
  - changeSet:
      id: 007-add-column-if-not-exists
      author: dave
      preConditions:
        - onFail: MARK_RAN   # if precondition fails: skip this changeset
          onError: WARN       # if precondition errors: warn but continue
          not:
            columnExists:
              tableName: users
              columnName: phone
      changes:
        - addColumn:
            tableName: users
            columns:
              - column:
                  name: phone
                  type: VARCHAR(20)

  # onFail options:
  # HALT      — stop all processing (default), throw error
  # CONTINUE  — skip this changeset, continue with next
  # MARK_RAN  — skip AND record as executed in databasechangelog
  # WARN      — log warning, continue

  - changeSet:
      id: 008-postgres-specific
      author: dave
      preConditions:
        - onFail: MARK_RAN
          dbms:
            type: postgresql    # only run on PostgreSQL
      changes:
        - sql:
            sql: "CREATE INDEX CONCURRENTLY idx_users_email ON users(email);"
```

**Available precondition checks:**

```yaml
# Table/column/index existence
- tableExists:    { tableName: users }
- columnExists:   { tableName: users, columnName: email }
- indexExists:    { tableName: users, indexName: idx_email }
- sequenceExists: { sequenceName: users_id_seq }
- viewExists:     { viewName: user_view }

# Row count
- rowCount:
    tableName: users
    expectedRows: 0     # changeset only runs if table is empty

# SQL check (arbitrary SQL returning a boolean-ish result)
- sqlCheck:
    expectedResult: 0
    sql: "SELECT COUNT(*) FROM users WHERE email IS NULL"

# Database type
- dbms:
    type: postgresql  # postgresql, mysql, oracle, sqlserver, h2

# Logical operators
- and:
    - tableExists: { tableName: users }
    - columnExists: { tableName: users, columnName: email }

- or:
    - dbms: { type: postgresql }
    - dbms: { type: mysql }

- not:
    - tableExists: { tableName: users }
```

### 10.2 Contexts — Environment-Specific Migrations

Contexts let you run changesets only in specific environments:

```yaml
databaseChangeLog:
  # This changeset runs in ALL environments (no context specified)
  - changeSet:
      id: 001-create-users
      author: alice
      changes: [...]

  # Only runs in dev and test environments
  - changeSet:
      id: 002-insert-test-data
      author: alice
      context: dev, test
      changes:
        - insert:
            tableName: users
            columns:
              - column: { name: username, value: "testuser" }
              - column: { name: email,    value: "test@example.com" }

  # Only runs in production
  - changeSet:
      id: 003-create-production-index
      author: alice
      context: production
      changes:
        - sql:
            sql: "CREATE INDEX CONCURRENTLY idx_users_email_prod ON users(email);"
```

```yaml
# application.yml — set active contexts
spring:
  liquibase:
    contexts: dev      # only run changesets with no context OR context=dev
    # contexts: production  # in production: production-only changesets run
```

### 10.3 Labels — Feature Flags for Migrations

Labels are similar to contexts but more flexible — they use a logical expression language:

```yaml
  - changeSet:
      id: 004-feature-x
      author: alice
      labels: feature-x
      changes: [...]

  - changeSet:
      id: 005-feature-y-or-z
      author: alice
      labels: "feature-y or feature-z"
      changes: [...]
```

```yaml
# application.yml
spring:
  liquibase:
    labels: "feature-x"    # run changesets labeled feature-x
    # labels: "!feature-y" # skip feature-y changesets
```

---

## 11. Spring Boot Integration

### 11.1 Flyway Spring Boot Configuration

```yaml
# application.yml — Flyway configuration
spring:
  flyway:
    enabled: true                        # default: true
    locations:                           # where to find migrations
      - classpath:db/migration           # default
      - classpath:db/migration/vendor    # multiple locations supported
      - filesystem:/opt/app/migrations   # absolute filesystem path
    url: jdbc:postgresql://localhost/mydb  # override DataSource URL
    user: flyway_user                    # dedicated migration user (recommended)
    password: ${FLYWAY_PASSWORD}         # from environment
    schemas:                             # schemas to manage
      - public
    table: flyway_schema_history         # metadata table name (default)
    baseline-on-migrate: false           # set true for existing databases
    baseline-version: 1                  # baseline version number
    baseline-description: "Flyway Baseline"
    validate-on-migrate: true            # default: true — validate checksums
    validate-migration-naming: true      # validate naming convention
    clean-disabled: true                 # IMPORTANT: disable clean in production
    clean-on-validation-error: false     # never auto-clean on error
    out-of-order: false                  # disallow out-of-order migrations
    mixed: false                         # disallow mixed DDL+DML in same migration
    placeholder-replacement: true        # enable ${placeholder} in SQL
    placeholders:
      tablespace: pg_default             # ${tablespace} in SQL files
      schema: public
    encoding: UTF-8
    connect-retries: 3                   # retry DB connection attempts
    connect-retries-interval: 5          # seconds between retries
    default-schema: public
    installed-by: ${spring.application.name}  # who applied this migration
```

### 11.2 Liquibase Spring Boot Configuration

```yaml
# application.yml — Liquibase configuration
spring:
  liquibase:
    enabled: true                        # default: true
    change-log: classpath:db/changelog/db.changelog-master.yaml
    url: jdbc:postgresql://localhost/mydb
    user: liquibase_user
    password: ${LIQUIBASE_PASSWORD}
    default-schema: public
    liquibase-schema: public             # schema for databasechangelog tables
    contexts: ${SPRING_PROFILES_ACTIVE:dev}  # match active profile
    labels: ""
    database-change-log-table: DATABASECHANGELOG
    database-change-log-lock-table: DATABASECHANGELOGLOCK
    drop-first: false                    # DROP schema before running — NEVER in production
    rollback-file:                       # write rollback SQL to file
    test-rollback-on-update: false       # test rollback then reapply
    parameters:
      tablespace: pg_default
      environment: ${SPRING_PROFILES_ACTIVE:dev}
```

### 11.3 Multiple Datasource Configuration

```java
// When you have multiple DataSources, configure migrations explicitly
@Configuration
public class DatabaseConfig {

    @Bean
    @ConfigurationProperties("spring.datasource.primary")
    public DataSource primaryDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    @ConfigurationProperties("spring.datasource.audit")
    public DataSource auditDataSource() {
        return DataSourceBuilder.create().build();
    }

    // Flyway for primary datasource
    @Bean
    public Flyway primaryFlyway(@Qualifier("primaryDataSource") DataSource ds) {
        return Flyway.configure()
            .dataSource(ds)
            .locations("classpath:db/migration/primary")
            .load();
    }

    // Flyway for audit datasource
    @Bean
    public Flyway auditFlyway(@Qualifier("auditDataSource") DataSource ds) {
        return Flyway.configure()
            .dataSource(ds)
            .locations("classpath:db/migration/audit")
            .table("flyway_audit_schema_history")
            .load();
    }

    // Run both migrations at startup
    @Bean
    @DependsOn({"primaryFlyway", "auditFlyway"})
    public FlywayMigrationInitializer flywayInitializer(Flyway primaryFlyway) {
        primaryFlyway.migrate();
        return new FlywayMigrationInitializer(primaryFlyway);
    }
}
```

### 11.4 Test Configuration

```java
// For integration tests: clean DB, run migrations, run test, clean DB
@SpringBootTest
@TestPropertySource(properties = {
    "spring.flyway.clean-disabled=false"  // allow clean in tests
})
class UserRepositoryTest {

    @Autowired
    private Flyway flyway;

    @BeforeEach
    void resetDatabase() {
        flyway.clean();    // drop all tables
        flyway.migrate();  // re-apply all migrations
    }
}

// Better: use @Sql annotation or Testcontainers for isolated test databases
@SpringBootTest
@Testcontainers
class UserRepositoryTest {

    @Container
    static PostgreSQLContainer<?> postgres =
        new PostgreSQLContainer<>("postgres:15")
            .withDatabaseName("testdb");

    @DynamicPropertySource
    static void configureDatabase(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    // Flyway auto-runs against the Testcontainer — fresh DB per test class
}
```

---

## 12. Best Practices

### 12.1 Never Modify an Already-Applied Migration

```sql
-- WRONG: modifying V3__create_orders_table.sql after it's been applied to any environment
-- Flyway will throw: Validate failed: Migration checksum mismatch for migration version 3

-- CORRECT: add a new migration for any changes
-- V5__add_orders_notes_column.sql
ALTER TABLE orders ADD COLUMN notes TEXT;
```

**Why this rule is absolute:**
- The checksum of the original file is stored in `flyway_schema_history`
- Any modification changes the checksum → Flyway throws on validate
- Other environments that already applied V3 will also throw
- Database state has diverged — one environment has the modified version, others don't

### 12.2 Backward-Compatible Migrations for Zero-Downtime Deployments

Zero-downtime (blue-green, rolling) deployments require that the **new schema version works with both the old AND new application code** simultaneously:

```
Expand-Contract Pattern (also called: Parallel Change):

Phase 1 - Expand: Add new column (nullable or with default)
  Deploy: V10__add_display_name_column.sql
  Old app: ignores display_name (column exists but app doesn't use it)
  New app: reads and writes display_name

Phase 2 - Migrate: Backfill data
  Deploy: V11__backfill_display_name.sql
  UPDATE users SET display_name = username WHERE display_name IS NULL;

Phase 3 - Contract: Remove old column (after all app instances updated)
  Deploy: V12__remove_old_name_column.sql (weeks/months later)
  DROP COLUMN old_name;
```

**Patterns to avoid in zero-downtime migrations:**

```sql
-- DANGEROUS: rename a column (old app breaks immediately)
ALTER TABLE users RENAME COLUMN username TO user_name;
-- Fix: add new column, backfill, update app, drop old column

-- DANGEROUS: change column type incompatibly
ALTER TABLE users ALTER COLUMN status TYPE INTEGER USING status::INTEGER;
-- Fix: add new column, backfill, update app, drop old column

-- DANGEROUS: add NOT NULL without default
ALTER TABLE users ADD COLUMN required_field VARCHAR(50) NOT NULL;
-- Old app doesn't know about required_field → insert fails
-- Fix: add with DEFAULT first, then remove default after backfill
ALTER TABLE users ADD COLUMN required_field VARCHAR(50) NOT NULL DEFAULT 'unknown';
-- Later: ALTER TABLE users ALTER COLUMN required_field DROP DEFAULT;

-- DANGEROUS: drop a table or column (old app still uses it)
DROP TABLE legacy_sessions;
-- Fix: ensure all app instances are updated first
```

### 12.3 Separate DDL and DML Migrations

```
DDL (Data Definition Language): CREATE TABLE, ALTER TABLE, CREATE INDEX
DML (Data Manipulation Language): INSERT, UPDATE, DELETE

Keep them separate because:
1. DDL in most DBs auto-commits (can't be rolled back in same transaction)
2. DML migrations on large tables can take minutes (separate from schema changes)
3. Easier to review: "this migration only changes structure"
4. Retry safety: DDL-only migration failed? Just retry from scratch

GOOD:
  V10__add_display_name_column.sql  (DDL: ALTER TABLE ADD COLUMN)
  V11__backfill_display_name.sql    (DML: UPDATE users SET ...)
  V12__add_display_name_index.sql   (DDL: CREATE INDEX)

BAD:
  V10__add_and_backfill_display_name.sql (mixes DDL and DML)
```

### 12.4 Always Test Against Production-Like Data

```
Migration tested only on empty dev DB:
  - Works fine with 100 rows
  - Runs for 4 hours on production's 50 million rows
  - Locks the table, causing downtime

Best practices:
  1. Use CONCURRENTLY for PostgreSQL index creation (non-locking):
     CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
     (cannot be used inside a transaction — Flyway uses transactions by default)
     To disable transaction: @Transactional(false) on Java migration or
     -- Flyway pragma: -- nontransactional

  2. Batch large DML updates:
     UPDATE users SET display_name = username
     WHERE id BETWEEN 1 AND 10000;  -- run in batches to avoid lock escalation

  3. Test with production data volume:
     Use pg_dump --schema-only + generate synthetic data, or
     Use a staging environment with production-scale data
```

### 12.5 Migration Checklist

```
Before writing a migration:
  □ What is the smallest change that gets us to the desired state?
  □ Is this backward-compatible with the current application version?
  □ Will this lock tables? For how long?
  □ What's the rollback plan?

Migration file:
  □ Descriptive name: V5__add_user_display_name_column.sql (not V5__changes.sql)
  □ Single responsibility: one conceptual change per migration
  □ Idempotent where possible: CREATE TABLE IF NOT EXISTS
  □ Comments explaining non-obvious decisions

After applying to production:
  □ Run flyway validate / liquibase status to confirm applied state
  □ Verify application startup with new schema
  □ Monitor error logs for schema-related errors
```

---

## 13. Flyway vs Liquibase Decision Guide

### 13.1 Feature Comparison

| Feature | Flyway | Liquibase |
|---|---|---|
| **Learning curve** | Low | Medium |
| **SQL format** | Primary format | One of four formats |
| **Java migration** | ✅ | ✅ |
| **XML/YAML changelog** | ❌ | ✅ |
| **Rollback** | ❌ (Teams/Enterprise) | ✅ built-in |
| **Dry run (SQL generation)** | ❌ (Teams) | ✅ updateSQL command |
| **Contexts/environments** | Limited (via config) | ✅ contexts + labels |
| **Preconditions** | ❌ | ✅ |
| **Database-agnostic DDL** | ❌ (SQL only) | ✅ (change types) |
| **Repeatable migrations** | ✅ R__ prefix | ✅ runOnChange |
| **Baseline existing DB** | ✅ | ✅ |
| **Spring Boot support** | ✅ excellent | ✅ excellent |
| **IDE support** | Good | Good |
| **Community size** | Large | Large |

### 13.2 Choose Flyway When

```
✓ Your team knows SQL and prefers writing raw SQL migrations
✓ Simple, linear migration history is sufficient
✓ You don't need rollback automation (use expand-contract pattern instead)
✓ DBA-friendly: all changes visible as plain SQL files
✓ You want the simplest possible migration setup
✓ Startup/scale-up company where simplicity is paramount

Typical stack:
  Spring Boot + PostgreSQL/MySQL + Flyway
  → V1.sql, V2.sql... always know exactly what ran
```

### 13.3 Choose Liquibase When

```
✓ You need automated rollback support
✓ You want database-agnostic DDL (generates SQL for target DB)
✓ You need fine-grained context/environment control
✓ Your DBAs work with Oracle/SQLServer and need preconditions
✓ You need diff-based changelog generation
✓ Complex enterprise requirements: audit trails, structured changesets
✓ Multiple database vendors in your fleet

Typical stack:
  Spring Boot + Oracle/SQLServer/PostgreSQL + Liquibase XML
  → Formal changeset history with ids, authors, rollbacks
```

### 13.4 Neither Is Clearly Better

```
Both tools:
  - Are mature, well-maintained, widely used
  - Have excellent Spring Boot integration
  - Handle the 95% case equally well
  - Have the same fundamental constraint:
    never modify an applied migration

The choice often comes down to:
  Team preference for SQL vs YAML/XML
  Whether rollback is a hard requirement
  Existing team experience with one tool
```

---

## 14. Quick Reference Cheat Sheet

### Flyway Naming

```
V{version}__{description}.sql       — runs once, in order
R__{description}.sql                — re-runs when file changes
{version}: 1, 2, 1.1, 20240115_1430
{description}: words_separated_by_underscores
DOUBLE underscore between version and description

Examples:
V1__create_schema.sql
V2__add_user_table.sql
V2_1__hotfix_user_constraint.sql
V20240115__add_audit_columns.sql
R__refresh_materialized_views.sql
```

### Flyway Commands

```bash
mvn flyway:migrate    # apply pending migrations
mvn flyway:validate   # check checksums match
mvn flyway:info       # show status of all migrations
mvn flyway:repair     # fix failed/corrupted records
mvn flyway:clean      # drop everything (NEVER in production)
mvn flyway:baseline   # mark existing DB as version N
```

### Flyway Key Properties

```properties
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true         # for existing databases
spring.flyway.baseline-version=1
spring.flyway.validate-on-migrate=true
spring.flyway.clean-disabled=true              # PRODUCTION SAFETY
spring.flyway.out-of-order=false
```

### Liquibase Changeset Structure

```yaml
- changeSet:
    id: unique-id-never-change-this
    author: your-name
    context: dev,test           # optional: environment filter
    labels: feature-x           # optional: feature flag
    runAlways: false            # re-run every time?
    runOnChange: false          # re-run when content changes?
    failOnError: true           # halt on failure?
    changes:
      - createTable:
          tableName: foo
          columns: [...]
    rollback:
      - dropTable:
          tableName: foo
```

### Liquibase Key Properties

```yaml
spring:
  liquibase:
    change-log: classpath:db/changelog/db.changelog-master.yaml
    contexts: ${SPRING_PROFILES_ACTIVE:dev}
    drop-first: false          # NEVER true in production
    enabled: true
```

### Zero-Downtime Pattern (Expand-Contract)

```
Step 1: Add new column (nullable)          — deploy, both old+new app work
Step 2: Backfill data (DML migration)      — data populated
Step 3: Remove old column                  — deploy after all instances updated
```

### Key Rules to Remember

1. **Never modify an already-applied migration** — always add new ones.
2. **Flyway naming requires DOUBLE underscore** — `V1__name.sql` not `V1_name.sql`.
3. **`spring.flyway.clean-disabled=true`** in production — clean drops everything.
4. **`baseline-on-migrate=true`** for existing databases adopting Flyway.
5. **Copy-before-validate** — Flyway validates checksums at startup; any change = error.
6. **Separate DDL and DML** — don't mix structural and data changes.
7. **Liquibase changeset `id` is permanent** — never change it after it's applied.
8. **Liquibase rollbacks require planning** — define `rollback` block when writing changeset.
9. **Zero-downtime = expand-contract** — new column first (nullable), backfill, then remove old.
10. **Test with production-scale data** — a migration that takes 1s on dev may take 1 hour in production.

---

*End of Database Migrations: Flyway & Liquibase Study Guide — Module 7*
