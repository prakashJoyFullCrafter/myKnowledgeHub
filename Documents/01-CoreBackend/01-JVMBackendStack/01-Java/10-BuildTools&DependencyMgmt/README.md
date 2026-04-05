# Build Tools & Dependency Management - Curriculum

## Module 1: Maven Fundamentals
- [ ] Maven project structure: `src/main/java`, `src/test/java`, `pom.xml`
- [ ] POM (Project Object Model): `groupId`, `artifactId`, `version`
- [ ] Maven coordinates and GAV (Group:Artifact:Version)
- [ ] Build lifecycle: `validate` → `compile` → `test` → `package` → `verify` → `install` → `deploy`
- [ ] Common commands: `mvn clean`, `mvn compile`, `mvn test`, `mvn package`, `mvn install`
- [ ] Packaging types: `jar`, `war`, `pom`
- [ ] `mvn dependency:tree` - visualize dependency graph

## Module 2: Maven Dependencies
- [ ] Dependency declaration: `<dependency>` with scope
- [ ] Scopes: `compile` (default), `provided`, `runtime`, `test`, `system`
- [ ] Transitive dependencies and how they resolve
- [ ] Dependency mediation (nearest-wins strategy)
- [ ] `<dependencyManagement>` - version control without adding dependency
- [ ] BOM (Bill of Materials): `<type>pom</type>` + `<scope>import</scope>`
- [ ] Spring Boot BOM: `spring-boot-dependencies`
- [ ] Excluding transitive dependencies: `<exclusions>`
- [ ] Dependency conflicts and resolution strategies

## Module 3: Maven Multi-Module
- [ ] Parent POM and `<modules>` section
- [ ] Inheritance: child POMs inherit from parent
- [ ] `<dependencyManagement>` in parent
- [ ] `<pluginManagement>` in parent
- [ ] Reactor build order
- [ ] Building specific modules: `mvn -pl module-name -am`

## Module 4: Maven Plugins & Profiles
- [ ] Plugin configuration in `<build><plugins>`
- [ ] Key plugins: `compiler`, `surefire`, `failsafe`, `jar`, `shade`, `spring-boot`
- [ ] `maven-compiler-plugin`: Java version, annotation processing
- [ ] `maven-surefire-plugin`: unit test execution
- [ ] `maven-failsafe-plugin`: integration test execution
- [ ] `spring-boot-maven-plugin`: fat JAR, buildpack, native image
- [ ] Profiles: `<profiles>` for environment-specific builds
- [ ] Activating profiles: `-P dev`, by property, by OS

![img.png](img.png)## Module 5: Gradle Fundamentals
- [ ] Gradle vs Maven: flexibility, performance, Kotlin DSL
- [ ] `build.gradle.kts` (Kotlin DSL) vs `build.gradle` (Groovy DSL)
- [ ] Project structure (same convention as Maven)
- [ ] Tasks: `gradle build`, `gradle test`, `gradle bootRun`
- [ ] `settings.gradle.kts`: project name, multi-module includes
- [ ] Gradle wrapper: `gradlew` (always use this)

## Module 6: Gradle Dependencies & Configuration
- [ ] Dependency configurations: `implementation`, `api`, `compileOnly`, `runtimeOnly`, `testImplementation`
- [ ] `implementation` vs `api` - compile classpath leaking
- [ ] Platform (BOM) dependencies: `platform("org.springframework.boot:spring-boot-dependencies:3.x")`
- [ ] Version catalogs: `libs.versions.toml` (Gradle 7.0+)
- [ ] Dependency constraints and conflict resolution
- [ ] `gradle dependencies` - dependency tree

## Module 7: Gradle Multi-Module & Plugins
- [ ] Multi-project builds: `include("module-a", "module-b")`
- [ ] Convention plugins for shared configuration
- [ ] `buildSrc` directory for custom build logic
- [ ] Key plugins: `java`, `application`, `org.springframework.boot`, `io.spring.dependency-management`
- [ ] Custom tasks: `tasks.register("myTask") { }`
- [ ] Build cache and incremental builds (Gradle's speed advantage)
- [ ] Gradle daemon

## Module 8: Maven vs Gradle Decision Guide
- [ ] Performance: Gradle incremental builds + cache >> Maven
- [ ] Flexibility: Gradle (programmable) vs Maven (declarative/rigid)
- [ ] Ecosystem: Maven (larger plugin ecosystem, more docs)
- [ ] Learning curve: Maven (simpler) vs Gradle (more powerful)
- [ ] Enterprise: Maven still dominant; Gradle growing in Spring ecosystem
- [ ] Spring Boot: both fully supported
- [ ] Migration: Maven to Gradle (`gradle init`)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up Maven project with Spring Boot BOM and dependency management |
| Modules 3-4 | Create multi-module Maven project: api, service, web |
| Modules 5-6 | Rebuild same project with Gradle Kotlin DSL + version catalogs |
| Module 7 | Multi-module Gradle project with convention plugins |
| Module 8 | Benchmark build time: Maven vs Gradle on same project |

## Key Resources
- Maven: The Definitive Guide - Sonatype
- Gradle User Manual (docs.gradle.org)
- Spring Boot Build Tool Plugins documentation
- Maven Central Repository (search.maven.org)
