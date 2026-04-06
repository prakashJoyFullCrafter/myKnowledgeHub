# Connection Pooling - Curriculum

## Topics
- [ ] Why connection pooling? (TCP overhead, PostgreSQL process-per-connection)
- [ ] HikariCP: configuration, sizing, monitoring
- [ ] `maximumPoolSize` formula: connections = (core_count * 2) + spindle_count
- [ ] `minimumIdle`, `connectionTimeout`, `maxLifetime`, `idleTimeout`
- [ ] PgBouncer: external pooling (transaction vs session mode)
- [ ] `pgpool-II` vs PgBouncer
- [ ] Connection leak detection (`leakDetectionThreshold`)
- [ ] Monitoring: `HikariPoolMXBean`, Micrometer metrics
- [ ] Spring Boot HikariCP auto-configuration
