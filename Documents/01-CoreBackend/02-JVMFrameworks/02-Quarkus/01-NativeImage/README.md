# Quarkus Native Image - Curriculum

## Module 1: GraalVM & Native Compilation
- [ ] What is GraalVM? JIT vs AOT compilation
- [ ] Native image: compile Java to standalone binary
- [ ] Benefits: fast startup (<50ms), low memory (~20MB)
- [ ] Trade-offs: longer build time, reflection limitations

## Module 2: Building Native Images
- [ ] `./mvnw package -Dnative` and `./gradlew build -Dquarkus.native.enabled=true`
- [ ] Mandrel vs GraalVM CE vs GraalVM EE
- [ ] Container-based native builds (no local GraalVM needed)
- [ ] Multi-stage Docker builds for native images

## Module 3: Native Image Limitations
- [ ] Reflection - `@RegisterForReflection`
- [ ] Dynamic proxies and serialization
- [ ] `native-image.properties` and `reflect-config.json`
- [ ] Resources in native images (`@NativeImageResource`)
- [ ] Testing native images (`@NativeImageTest`)

## Module 4: Optimization
- [ ] Build-time initialization vs runtime initialization
- [ ] PGO (Profile-Guided Optimization)
- [ ] Monitoring native app with Prometheus
- [ ] Comparing JVM mode vs native mode performance

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build and run a Quarkus app as native binary |
| Module 3 | Fix reflection issues in a native build |
| Module 4 | Benchmark JVM vs native (startup, memory, throughput) |
