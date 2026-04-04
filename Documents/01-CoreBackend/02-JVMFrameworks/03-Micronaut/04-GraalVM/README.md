# Micronaut + GraalVM - Curriculum

## Module 1: GraalVM Setup
- [ ] Installing GraalVM and `native-image` tool
- [ ] Micronaut's reflection-free design advantage
- [ ] `mn create-app --features=graalvm`

## Module 2: Building Native Images
- [ ] `./gradlew nativeCompile` / `./mvnw package -Dpackaging=native-image`
- [ ] Docker native builds
- [ ] Multi-stage Dockerfile for native apps
- [ ] Debugging native image build failures

## Module 3: Optimization & Limitations
- [ ] Resource configuration for native images
- [ ] Serialization configuration
- [ ] `@ReflectiveAccess` for reflection needs
- [ ] Static initializers and build-time init

## Module 4: Deployment
- [ ] Deploying native images to Kubernetes
- [ ] AWS Lambda with GraalVM native
- [ ] Startup time and memory monitoring
- [ ] Production readiness checklist

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build and run a native Micronaut REST API |
| Module 3 | Fix native image issues with reflection |
| Module 4 | Deploy to K8s and compare with JVM version |
