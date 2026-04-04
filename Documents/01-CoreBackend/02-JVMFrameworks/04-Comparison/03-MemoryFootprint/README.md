# Memory Footprint Comparison - Curriculum

## Module 1: Measuring Memory
- [ ] RSS (Resident Set Size) vs heap vs metaspace
- [ ] Tools: `jcmd`, `VisualVM`, `async-profiler`, `pmap`
- [ ] JVM flags for memory tuning (`-Xmx`, `-Xms`, `-XX:MaxMetaspaceSize`)
- [ ] Native image memory measurement

## Module 2: Benchmarks
- [ ] Idle memory comparison (JVM mode)
- [ ] Idle memory comparison (native mode)
- [ ] Memory under load (concurrent requests)
- [ ] Memory scaling with bean count

## Module 3: Optimization
- [ ] JVM: G1GC, ZGC, Shenandoah tuning
- [ ] Container memory limits and JVM ergonomics
- [ ] `-XX:+UseContainerSupport` for Docker
- [ ] Native image: RSS reduction strategies
- [ ] Right-sizing containers for each framework
