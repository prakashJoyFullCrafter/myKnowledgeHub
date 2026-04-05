# Java Modules (JPMS) - Curriculum

## Module 1: Module System Basics
- [ ] Why JPMS? (Java 9+) - strong encapsulation, reliable configuration
- [ ] `module-info.java` - module descriptor
- [ ] Module declaration: `module com.myapp { }`
- [ ] Module path vs classpath
- [ ] Named modules vs unnamed modules vs automatic modules

## Module 2: Module Directives
- [ ] `requires` - declare module dependency
- [ ] `requires transitive` - transitive dependency
- [ ] `requires static` - compile-time only dependency
- [ ] `exports` - make packages visible to other modules
- [ ] `exports ... to` - qualified exports (specific modules)
- [ ] `opens` - allow reflection access (for frameworks like Spring, Hibernate)
- [ ] `opens ... to` - qualified opens
- [ ] `uses` and `provides ... with` - service loader pattern

## Module 3: Service Provider Interface (SPI)
- [ ] `ServiceLoader` - discovering implementations at runtime
- [ ] `provides com.api.MyService with com.impl.MyServiceImpl`
- [ ] `uses com.api.MyService` - declaring service consumption
- [ ] SPI pattern for plugin architectures
- [ ] SPI in JDBC driver loading

## Module 4: Migration & Compatibility
- [ ] Migrating from classpath to module path
- [ ] Automatic modules: JAR on module path without `module-info.java`
- [ ] Unnamed module: everything on classpath
- [ ] `--add-exports`, `--add-opens`, `--add-reads` - command-line overrides
- [ ] Split packages problem and resolution
- [ ] Dealing with reflection-heavy frameworks (Spring, Hibernate)
- [ ] Why many projects still use classpath mode

## Module 5: Multi-Module Projects
- [ ] Project structure for multi-module apps
- [ ] Maven multi-module with JPMS
- [ ] Gradle multi-module with JPMS
- [ ] `jlink` - creating custom JRE with only needed modules
- [ ] `jdeps` - analyzing module dependencies
- [ ] Minimizing Docker image size with `jlink`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Create a 3-module project: api, impl, app |
| Module 3 | Build a plugin system with ServiceLoader |
| Module 4 | Migrate a classpath project to modules |
| Module 5 | Use `jlink` to create minimal JRE for your app |

## Key Resources
- Java Platform Module System specification
- The Java Module System - Nicolai Parlog
- JEP 261: Module System
