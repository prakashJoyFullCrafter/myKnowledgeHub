# JVM Internals - Curriculum

## Module 1: JVM Architecture Overview
- [ ] What is the JVM? Write once, run anywhere - how it works
- [ ] JVM vs JRE vs JDK - relationships and responsibilities
- [ ] JVM specification vs JVM implementations (HotSpot, GraalVM, OpenJ9, Azul Zing)
- [ ] High-level JVM components: Class Loader, Runtime Data Areas, Execution Engine, Native Interface
- [ ] How a `.class` file is structured (magic number, constant pool, bytecode)
- [ ] Bytecode basics - reading `javap -c` output
- [ ] How the JVM executes bytecode step by step

---

## Module 2: Class Loading Subsystem
- [ ] What is class loading? When does it happen?
- [ ] Class loading phases:
  - [ ] **Loading** - finding and reading `.class` file bytes
  - [ ] **Linking**:
    - [ ] Verification - bytecode correctness checks
    - [ ] Preparation - allocating memory for static fields
    - [ ] Resolution - symbolic references → direct references
  - [ ] **Initialization** - running static initializers and `<clinit>`
- [ ] ClassLoader hierarchy:
  - [ ] Bootstrap ClassLoader (loads `java.*`)
  - [ ] Platform/Extension ClassLoader
  - [ ] Application ClassLoader
  - [ ] Custom ClassLoaders
- [ ] **Parent Delegation Model** - how class loading requests propagate
- [ ] Breaking parent delegation - when and why (e.g., OSGi, plugin systems)
- [ ] `Class.forName()` vs `ClassLoader.loadClass()` - key differences
- [ ] ClassLoader isolation and memory leaks in application servers
- [ ] Dynamic class loading at runtime

---

## Module 3: Runtime Data Areas (JVM Memory)
- [ ] **Method Area (Metaspace in Java 8+)**:
  - [ ] Class metadata, method bytecode, constant pool
  - [ ] `PermGen` (pre-Java 8) vs `Metaspace` (Java 8+)
  - [ ] `MaxMetaspaceSize` tuning
- [ ] **Heap**:
  - [ ] Object allocation
  - [ ] Young Generation: Eden, Survivor S0, S1
  - [ ] Old Generation (Tenured)
  - [ ] Object promotion and tenuring threshold
- [ ] **JVM Stack (Thread Stack)**:
  - [ ] Stack frames: local variable table, operand stack, frame data
  - [ ] `StackOverflowError` - cause and prevention
  - [ ] `-Xss` tuning
- [ ] **Program Counter (PC) Register** - per-thread instruction pointer
- [ ] **Native Method Stack** - for JNI calls
- [ ] **Direct Memory (Off-Heap)**:
  - [ ] `ByteBuffer.allocateDirect()`
  - [ ] NIO and off-heap usage
  - [ ] `-XX:MaxDirectMemorySize` tuning
- [ ] Memory flags cheat sheet: `-Xms`, `-Xmx`, `-Xmn`, `-XX:MetaspaceSize`

---

## Module 4: Object Memory Layout & Allocation
- [ ] Object header structure: mark word + class pointer (+ array length)
- [ ] Mark word contents: identity hash code, GC age, lock state, GC flags
- [ ] Object alignment and padding (8-byte alignment by default)
- [ ] Compressed OOPs (`-XX:+UseCompressedOops`) - how 32-bit pointers work in 64-bit JVM
- [ ] **TLAB (Thread-Local Allocation Buffer)** - fast path object allocation
- [ ] Escape analysis and **stack allocation** of short-lived objects
- [ ] **Object elimination** - JIT removing allocations entirely
- [ ] `jol` (Java Object Layout) tool - inspecting object sizes

---

## Module 5: Execution Engine & JIT Compilation
- [ ] Interpreted execution vs compiled execution
- [ ] **Tiered Compilation** (Java 7+):
  - [ ] Tier 0: Interpreter
  - [ ] Tier 1: C1 compiler (client, light optimizations)
  - [ ] Tier 2: C1 with limited profiling
  - [ ] Tier 3: C1 with full profiling
  - [ ] Tier 4: C2 compiler (server, aggressive optimizations)
- [ ] **HotSpot detection** - invocation counters and back-edge counters
- [ ] **OSR (On-Stack Replacement)** - replacing interpreted method mid-execution
- [ ] **Deoptimization** - why JIT-compiled code reverts to interpreter
- [ ] Key JIT optimizations:
  - [ ] Inlining (`-XX:MaxInlineSize`, `-XX:FreqInlineSize`)
  - [ ] Loop unrolling
  - [ ] Escape analysis & scalar replacement
  - [ ] Null check elimination
  - [ ] Dead code elimination
  - [ ] Intrinsics (`Arrays.copyOf`, `Math.sqrt`, etc.)
  - [ ] Vectorization (SIMD auto-vectorization)
- [ ] **Code Cache** - where compiled code lives (`-XX:ReservedCodeCacheSize`)
- [ ] `-XX:+PrintCompilation` - watching JIT in action
- [ ] `-XX:+UnlockDiagnosticVMOptions -XX:+PrintInlining` - inlining decisions
- [ ] **GraalVM JIT** - polyglot compiler, Truffle framework
- [ ] **AOT Compilation** - `native-image`, trade-offs vs JIT

---

## Module 6: Garbage Collection - Foundations
- [ ] Why GC? Manual memory management problems
- [ ] GC roots: local variables, static fields, JNI references, thread stacks
- [ ] **Reachability** - what makes an object collectible
- [ ] Reference types:
  - [ ] Strong references
  - [ ] `SoftReference` - cleared before OOM
  - [ ] `WeakReference` - cleared on next GC
  - [ ] `PhantomReference` - post-finalization cleanup
  - [ ] `ReferenceQueue` usage
- [ ] **Mark and Sweep** algorithm basics
- [ ] **Copying collector** - fragmentation-free allocation
- [ ] **Compaction** - defragmenting the heap
- [ ] **Generational hypothesis** - most objects die young
- [ ] **Minor GC** (Young Gen) vs **Major GC** (Old Gen) vs **Full GC**
- [ ] GC pause types: Stop-The-World (STW) vs concurrent phases
- [ ] `finalize()` - why it's deprecated and dangerous
- [ ] `java.lang.ref.Cleaner` (Java 9+) - safe alternative to finalize

---

## Module 7: Serial & Parallel GC
- [ ] **Serial GC** (`-XX:+UseSerialGC`):
  - [ ] Single-threaded, STW, low overhead
  - [ ] Use case: small heaps, embedded systems, single-core
- [ ] **Parallel GC** (`-XX:+UseParallelGC`) (default pre-Java 9):
  - [ ] Multi-threaded STW collection
  - [ ] `-XX:ParallelGCThreads`
  - [ ] Throughput-optimized
  - [ ] Use case: batch processing, CPU-bound apps
- [ ] Young gen collection: Eden + Survivor copy
- [ ] Old gen collection: mark-sweep-compact
- [ ] `-XX:MaxGCPauseMillis` vs `-XX:GCTimeRatio` tuning knobs
- [ ] Adaptive sizing policy

---

## Module 8: G1 GC (Garbage First)
- [ ] **G1 overview** - default since Java 9
- [ ] **Region-based heap** - equal-sized regions (not fixed Young/Old layout)
- [ ] Region types: Eden, Survivor, Old, Humongous, Free
- [ ] **Humongous objects** - objects > 50% of region size
- [ ] G1 collection cycle:
  - [ ] **Young-only phase**: Evacuation pauses (minor GC)
  - [ ] **Concurrent Marking**: Initial Mark → Root Region Scan → Concurrent Mark → Remark → Cleanup
  - [ ] **Mixed GC phase**: collecting Young + selected Old regions
- [ ] **IHOP (Initiating Heap Occupancy Percent)** - when marking starts
- [ ] **Remembered Sets (RSets)** - tracking cross-region references
- [ ] **Card Tables** - how RSets are implemented
- [ ] **Collection Sets (CSets)** - which regions to collect each pause
- [ ] Key G1 flags:
  - [ ] `-XX:MaxGCPauseMillis` (default 200ms)
  - [ ] `-XX:G1HeapRegionSize`
  - [ ] `-XX:G1NewSizePercent`, `-XX:G1MaxNewSizePercent`
  - [ ] `-XX:G1MixedGCLiveThresholdPercent`
  - [ ] `-XX:ConcGCThreads`
- [ ] G1 vs Parallel GC: throughput vs pause time trade-off
- [ ] When G1 falls back to Full GC and how to prevent it
- [ ] `GCViewer` and `GCEasy` tools for log analysis

---

## Module 9: ZGC (Z Garbage Collector)
- [ ] **ZGC goals**: pause times < 1ms, scalable to TB heaps (Java 15+ production-ready)
- [ ] **Colored pointers** - load barriers via pointer metadata bits
- [ ] **Load barriers** - how ZGC intercepts object access
- [ ] ZGC phases: Mark Start (STW) → Concurrent Mark → Mark End (STW) → Concurrent Relocate
- [ ] **Relocation** - moving objects concurrently without stopping threads
- [ ] **Forwarding tables** - tracking relocated objects
- [ ] Multi-generational ZGC (Java 21+)
- [ ] Key ZGC flags:
  - [ ] `-XX:+UseZGC`
  - [ ] `-XX:SoftMaxHeapSize`
  - [ ] `-XX:ZCollectionInterval`
  - [ ] `-XX:ZUncommitDelay`
- [ ] ZGC trade-offs: throughput cost vs pause time wins
- [ ] When to choose ZGC: latency-sensitive services, large heaps

---

## Module 10: Shenandoah GC
- [ ] **Shenandoah goals**: concurrent evacuation, pause times independent of heap size
- [ ] **Brooks pointers (forwarding pointers)** - indirection for concurrent moves
- [ ] **Read/write barriers** - Shenandoah's concurrency mechanism
- [ ] Shenandoah collection phases:
  - [ ] Init Mark (STW) → Concurrent Mark → Final Mark (STW) → Concurrent Cleanup
  - [ ] Concurrent Evacuation → Init Update Refs (STW) → Concurrent Update Refs → Final Update Refs (STW)
- [ ] **Heuristics**: adaptive, aggressive, compact, static
- [ ] Key Shenandoah flags:
  - [ ] `-XX:+UseShenandoahGC`
  - [ ] `-XX:ShenandoahGCHeuristics`
  - [ ] `-XX:ShenandoahUncommitDelay`
- [ ] Shenandoah vs ZGC:
  - [ ] Both: low pause, concurrent
  - [ ] Shenandoah: forwarding pointer per object (heap overhead)
  - [ ] ZGC: colored pointers (64-bit only)
- [ ] Shenandoah in OpenJDK vs Red Hat builds

---

## Module 11: GC Monitoring, Tuning & Troubleshooting
- [ ] Enabling GC logging:
  - [ ] Java 9+: `-Xlog:gc*:file=gc.log:time,uptime:filecount=5,filesize=20m`
  - [ ] Java 8: `-XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:gc.log`
- [ ] Reading GC logs: pause times, heap occupancy, collection frequency
- [ ] **GC tuning methodology**:
  1. Define SLOs (max pause, throughput %)
  2. Measure baseline
  3. Tune one knob at a time
  4. Validate with production-like load
- [ ] Common GC problems and fixes:
  - [ ] Frequent Full GCs → old gen too small or memory leak
  - [ ] Long pause times → switch to ZGC/Shenandoah
  - [ ] High allocation rate → object pooling, escape analysis
  - [ ] Humongous allocation pressure (G1) → increase region size
  - [ ] Metaspace OOM → class loader leak, increase MetaspaceSize
- [ ] **Memory leak detection**:
  - [ ] Heap dump: `-XX:+HeapDumpOnOutOfMemoryError`
  - [ ] Analysis with `Eclipse MAT`, `VisualVM`, `JProfiler`
- [ ] Key JVM monitoring tools:
  - [ ] `jstat -gcutil <pid> 1000` - live GC stats
  - [ ] `jmap -histo <pid>` - object histogram
  - [ ] `jcmd <pid> GC.run` - trigger GC on demand
  - [ ] `jconsole`, `VisualVM` - GUI monitoring
  - [ ] JFR (Java Flight Recorder) + JMC (Java Mission Control)

---

## Module 12: JVM Safepoints & Thread Management
- [ ] **What is a safepoint?** - a point where JVM can inspect/modify thread state
- [ ] Why safepoints are needed (GC, deoptimization, bias lock revocation, etc.)
- [ ] **Time to safepoint (TTSP)** - latency from request to all threads reaching safepoint
- [ ] Safepoint polling - how threads check for safepoint requests
- [ ] Long TTSP causes: counted loops, JNI calls, busy native threads
- [ ] `-XX:+PrintSafepointStatistics` (Java 8) / `-Xlog:safepoint` (Java 9+)
- [ ] **Bias locking** and its deprecation (Java 15+)
- [ ] Thread states from JVM perspective: RUNNABLE, BLOCKED, WAITING, IN_VM, IN_NATIVE
- [ ] `jstack <pid>` - thread dumps and deadlock detection
- [ ] Virtual threads and safepoints (Java 21+)

---

## Module 13: JVM Performance Profiling
- [ ] **Profiling types**:
  - [ ] CPU profiling: sampling vs instrumentation
  - [ ] Memory profiling: allocation tracking, heap analysis
  - [ ] I/O and lock profiling
- [ ] **Java Flight Recorder (JFR)**:
  - [ ] Continuous, low-overhead production profiling
  - [ ] `jcmd <pid> JFR.start`, `JFR.dump`, `JFR.stop`
  - [ ] Events: GC, JIT, threads, I/O, locks, exceptions
  - [ ] JFR API for custom events
- [ ] **Async Profiler**:
  - [ ] Flame graphs for CPU and allocation
  - [ ] AsyncGetCallTrace API - safepoint-free sampling
  - [ ] Wall clock vs CPU mode
- [ ] **VisualVM** - all-in-one profiling GUI
- [ ] **JProfiler / YourKit** - commercial profilers
- [ ] **JMH (Java Microbenchmark Harness)**:
  - [ ] Why System.nanoTime() benchmarks lie
  - [ ] JIT warmup, dead code elimination traps
  - [ ] `@Benchmark`, `@Warmup`, `@Measurement`, `@BenchmarkMode`
  - [ ] Blackhole - preventing dead code elimination
- [ ] **Perf / perf-map-agent** - kernel-level CPU profiling with JIT symbol resolution

---

## Module 14: Advanced JVM Topics
- [ ] **Intrinsics** - hand-optimized native implementations of Java methods
- [ ] **Unsafe (`sun.misc.Unsafe`)** - direct memory access, CAS operations
- [ ] **VarHandles** (Java 9+) - safe alternative to Unsafe for atomics
- [ ] **Panama Project** (Java 22+) - Foreign Function & Memory API
- [ ] **GraalVM Native Image**:
  - [ ] AOT compilation to native binary
  - [ ] Closed-world assumption
  - [ ] Reflection configuration
  - [ ] Trade-offs: fast startup vs peak throughput
- [ ] **Project Leyden** (Java 24+) - ahead-of-time class loading and JIT caching
- [ ] **CRaC (Coordinated Restore at Checkpoint)** - JVM snapshot and restore
- [ ] **JVMTI (JVM Tool Interface)** - how profilers and debuggers attach to JVM
- [ ] **JNI (Java Native Interface)** basics - calling C/C++ from Java

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Write a custom ClassLoader that loads `.class` files from a JAR or URL |
| Module 3 | Use `jmap` and `jstat` to observe heap regions live on a running app |
| Module 4 | Use `jol-core` to print object layouts; observe compressed OOPs effect |
| Module 5 | Enable `-XX:+PrintCompilation` on a hot loop; observe JIT tier transitions |
| Modules 6-7 | Run same app with Serial, Parallel, G1 — compare GC logs |
| Modules 8-10 | Benchmark G1 vs ZGC vs Shenandoah with `GCEasy` log analysis |
| Module 11 | Introduce a memory leak; detect and fix using MAT + heap dump |
| Module 12 | Observe safepoint statistics; find and fix a long TTSP caused by a counted loop |
| Module 13 | Profile an allocation-heavy app with Async Profiler; generate flame graph |
| Module 14 | Compile a Spring Boot app to GraalVM native-image; compare startup time |

---

## Key Resources
- **JVM Specification** - docs.oracle.com/javase/specs
- **Java Performance: The Definitive Guide** - Scott Oaks
- **Optimizing Java** - Ben Evans, James Gough, Chris Newland
- **GC Handbook** - gchandbook.org
- **Aleksey Shipilev's blog** - shipilev.net (deep JIT/GC internals)
- **Monica Beckwith's talks** - G1/ZGC tuning
- **JEPs to read**: JEP 333 (ZGC), JEP 189 (Shenandoah), JEP 444 (Virtual Threads), JEP 483 (Leyden)
- **Tools**: Async Profiler, JMC, GCEasy, Eclipse MAT, `jol-core`
