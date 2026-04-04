# Micronaut AOT Compilation - Curriculum

## Module 1: Compile-Time DI
- [ ] How Micronaut eliminates runtime reflection
- [ ] Annotation processing at compile time
- [ ] Bean definitions generated at build time
- [ ] Comparison with Spring's runtime reflection

## Module 2: Build-Time Optimizations
- [ ] Source code generation with annotation processors
- [ ] No classpath scanning at runtime
- [ ] Reduced startup time and memory footprint
- [ ] Introspection without reflection (`@Introspected`)

## Module 3: GraalVM Native Image
- [ ] Micronaut + GraalVM - natural fit (no reflection)
- [ ] Building native images with Micronaut
- [ ] `mn:dockerfileNative` and `mn:dockerBuildNative`
- [ ] Testing native images

## Module 4: Performance Comparison
- [ ] Startup time: Micronaut vs Spring Boot vs Quarkus
- [ ] Memory usage comparison
- [ ] Throughput benchmarks
- [ ] When AOT matters most (serverless, CLI tools, microservices)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a Micronaut app, inspect generated code |
| Module 3 | Create a native image and compare startup |
| Module 4 | Benchmark against equivalent Spring Boot app |
