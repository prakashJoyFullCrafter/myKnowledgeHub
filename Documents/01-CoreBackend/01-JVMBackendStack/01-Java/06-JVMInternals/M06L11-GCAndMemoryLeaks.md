# JVM GC Problems, Memory Leak Detection & Monitoring Tools — Complete Study Guide

> **Brutally Detailed Reference**
> Covers every common GC problem and its fix, the full memory leak detection workflow from heap dump to root cause, Eclipse MAT analysis, and every JVM monitoring tool from `jstat` to Java Flight Recorder. Every section includes commands, flags, and real diagnostic examples.

---

## Table of Contents

1. [GC Fundamentals — Quick Orientation](#1-gc-fundamentals--quick-orientation)
2. [Common GC Problems and Fixes](#2-common-gc-problems-and-fixes)
3. [Memory Leak Detection — Full Workflow](#3-memory-leak-detection--full-workflow)
4. [Eclipse MAT — Deep Analysis](#4-eclipse-mat--deep-analysis)
5. [VisualVM — Live Monitoring](#5-visualvm--live-monitoring)
6. [Commercial Profilers — JProfiler and YourKit](#6-commercial-profilers--jprofiler-and-yourkit)
7. [Common Memory Leak Patterns](#7-common-memory-leak-patterns)
8. [Key JVM Monitoring Tools](#8-key-jvm-monitoring-tools)
9. [Java Flight Recorder and Java Mission Control](#9-java-flight-recorder-and-java-mission-control)
10. [Production Diagnostic Runbook](#10-production-diagnostic-runbook)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. GC Fundamentals — Quick Orientation

### 1.1 Heap Layout (G1 — Default Since Java 9)

```
┌────────────────────────────────────────────────────────────┐
│                         JVM Heap                           │
│  ┌──────────────────────────────┐  ┌─────────────────────┐ │
│  │          Young Gen           │  │      Old Gen        │ │
│  │  ┌────────┐  ┌────┐ ┌────┐  │  │  (tenured objects)  │ │
│  │  │  Eden  │  │ S0 │ │ S1 │  │  │                     │ │
│  │  └────────┘  └────┘ └────┘  │  └─────────────────────┘ │
│  └──────────────────────────────┘                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Metaspace (off-heap)              │   │
│  │         (class metadata, method bytecode)           │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────┘
```

### 1.2 GC Types at a Glance

| GC Collector | Best For | Max Pause Target | Java Version |
|---|---|---|---|
| **Serial** | Single-core, tiny heaps | N/A | All |
| **Parallel (Throughput)** | Batch jobs | Configurable | All |
| **G1 (Garbage First)** | General-purpose, balanced | ~200ms default | Java 9+ default |
| **ZGC** | Ultra-low latency | <1ms | Java 15+ stable |
| **Shenandoah** | Low-pause, medium heaps | <10ms | Java 12+ (Red Hat) |

### 1.3 Key GC Events

- **Minor GC** — collects Young Gen only. Fast (ms). Frequent.
- **Major GC** — collects Old Gen. Slower (100ms–seconds).
- **Full GC** — collects entire heap + Metaspace. Slowest. Often a problem signal.
- **Concurrent cycle** (G1/ZGC/Shenandoah) — most work done concurrently, short STW pauses.

### 1.4 Essential GC Logging Flags

Always run with GC logging in production:

```bash
# Java 9+ unified GC logging
-Xlog:gc*:file=/var/log/app/gc.log:time,uptime,level,tags:filecount=10,filesize=50m

# Also useful
-Xlog:gc+heap=debug       # heap size changes
-Xlog:gc+phases=debug     # G1 phase details
-Xlog:safepoint=info      # safepoint/pause details
```

---

## 2. Common GC Problems and Fixes

### 2.1 Frequent Full GCs → Old Gen Too Small or Memory Leak

#### Symptoms

```
[2024-01-15T10:23:41] GC(142) Pause Full (Allocation Failure) 1024M->892M(1024M) 4.231s
[2024-01-15T10:23:46] GC(143) Pause Full (Allocation Failure) 1024M->891M(1024M) 4.289s
[2024-01-15T10:23:51] GC(144) Pause Full (Allocation Failure) 1024M->893M(1024M) 4.301s
```

Full GCs happening repeatedly, heap always near 100% after GC — classic sign of either:
1. Old gen is genuinely too small for the live data set
2. A memory leak is accumulating unreachable objects that aren't being freed

#### Diagnosis

```bash
# Check heap usage over time
jstat -gcutil <pid> 2000
# Output columns: S0  S1   E    O    M     CCS    YGC   YGCT   FGC   FGCT    CGC   CGCT    GCT
#                  0   85  100  100  95.1  92.3   1820  18.2    45   186.7     0    0.0   204.9
#                            ↑          ↑
#                  Eden full           Old full — bad

# Check if Old gen is growing over time (leak indicator)
jstat -gc <pid> 5000 20
# Watch OU (Old Used) column — if it never decreases after Full GC, you have a leak
```

#### Fixes

**Fix 1 — Increase heap size (if not a leak)**

```bash
# Increase total heap
-Xms4g -Xmx8g

# Increase Old gen ratio (G1)
# G1 dynamically manages, but you can hint:
-XX:NewRatio=2          # Old:Young = 2:1 (Young = 1/3 of heap)
-XX:NewSize=2g          # explicit Young gen minimum
-XX:MaxNewSize=2g       # explicit Young gen maximum
```

**Fix 2 — GC tuning (if allocation pattern is the issue)**

```bash
# G1: increase target heap occupancy before concurrent cycle starts
-XX:InitiatingHeapOccupancyPercent=35  # default 45; lower = start GC earlier

# G1: how much live data to try to collect per GC pause
-XX:G1HeapWastePercent=5               # allow 5% waste before mixed GC

# Force more frequent concurrent marking (G1)
-XX:G1MixedGCCountTarget=8
```

**Fix 3 — Find the leak (if heap never drops)**

Take heap dumps and compare (see Section 3). A growing `OU` that never recovers post-Full-GC = memory leak.

---

### 2.2 Long Pause Times → Switch to ZGC/Shenandoah

#### Symptoms

```
[2024-01-15T14:05:22] GC(89) Pause Young (G1 Evacuation Pause) 2048M->1536M(4096M) 2.847s
[2024-01-15T14:07:01] GC(90) Pause Full 4096M->2100M(4096M) 18.231s
```

Application freezes 2–18 seconds. Users experience timeouts. SLAs broken.

#### Diagnosis — Measuring Pause Times

```bash
# See all GC pauses in GC log
grep "Pause" gc.log | awk '{print $NF}' | sort -n | tail -20

# Get 99th percentile pause from jstat
jstat -gcutil <pid> 1000 3600  # every 1s for 1 hour, pipe to analysis

# Get safepoint pause times
-Xlog:safepoint=info  # shows time-to-safepoint + at-safepoint duration
```

#### Fix — Switch to ZGC (Recommended for Java 15+)

ZGC performs all major work concurrently. Max pause is typically <1ms regardless of heap size (even terabyte heaps).

```bash
# ZGC — sub-millisecond pauses, scales to TB heaps
-XX:+UseZGC
-Xmx16g                         # ZGC works best with generous headroom
-XX:ConcGCThreads=4             # concurrent GC threads (default: auto)
-XX:SoftMaxHeapSize=12g         # ZGC aggressively returns memory at this threshold

# ZGC tuning
-XX:ZCollectionInterval=5       # force GC every 5s even if not needed (keeps heap fresh)
-XX:ZAllocationSpikeTolerance=2.0  # handle allocation spikes (default 2.0)

# Verify ZGC is active
-Xlog:gc:stdout                 # should show "Using The Z Garbage Collector"
```

#### Fix — Switch to Shenandoah

```bash
# Shenandoah — low-pause, concurrent evacuation (OpenJDK / Red Hat builds)
-XX:+UseShenandoahGC
-XX:ShenandoahGCMode=adaptive    # default: adapts based on allocation rate
-XX:ShenandoahGCHeuristics=adaptive  # other options: static, passive, aggressive
```

#### G1 Pause Tuning (Without Switching)

If you must stay on G1:

```bash
# Reduce max GC pause target (default 200ms)
-XX:MaxGCPauseMillis=100

# Increase GC threads (more parallel work per pause)
-XX:ParallelGCThreads=8
-XX:ConcMarkNumThreads=4

# Prevent Full GC by starting concurrent mark earlier
-XX:InitiatingHeapOccupancyPercent=30

# Increase heap to give G1 more headroom
-Xmx16g
```

---

### 2.3 High Allocation Rate → Object Pooling, Escape Analysis

#### Symptoms

```
# jstat shows Eden filling and getting collected very frequently
jstat -gcutil <pid> 500
# S0     S1    E    O    M     YGC   YGCT
#  0.0   98.1  100  22.1  95   4200  42.1   ← 4200 YGCs in a short time = very high alloc rate
```

High allocation rate means:
- Eden fills up and triggers Minor GC very frequently
- GC threads doing constant work even if objects are short-lived
- CPU time wasted on GC instead of application work

#### Diagnosis

```bash
# JFR allocation profiling (best tool for this)
jcmd <pid> JFR.start duration=60s filename=alloc.jfr settings=profile
# Then open in JMC → Memory → Allocation in new TLAB / outside TLAB

# jmap object histogram (quick snapshot)
jmap -histo <pid> | head -30
# num     #instances         #bytes  class name
#   1:       1500000       48000000  com.myapp.RequestContext    ← 1.5M instances!
#   2:        800000       25600000  byte[]

# GC log allocation stats (Java 9+ with -Xlog:gc+heap)
grep "->.*MB" gc.log | awk '{print $5}' | sed 's/M.*//'  # allocated per cycle
```

#### Fix 1 — Object Pooling

For objects that are expensive to create and frequently short-lived:

```java
// BAD — allocating a new ByteBuffer for every request
public byte[] processRequest(Request req) {
    ByteBuffer buf = ByteBuffer.allocate(8192); // new allocation every time
    // ... use buf ...
    return buf.array();
}

// GOOD — pool and reuse
private static final ObjectPool<ByteBuffer> BUFFER_POOL =
    new ObjectPool<>(() -> ByteBuffer.allocate(8192), ByteBuffer::clear, 100);

public byte[] processRequest(Request req) {
    ByteBuffer buf = BUFFER_POOL.borrow();
    try {
        // ... use buf ...
        return Arrays.copyOf(buf.array(), buf.limit());
    } finally {
        BUFFER_POOL.release(buf);
    }
}
```

Common pooling libraries:
```xml
<!-- Apache Commons Pool -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
    <version>2.12.0</version>
</dependency>
```

#### Fix 2 — Escape Analysis and Stack Allocation

The JIT compiler performs **escape analysis**: if an object never leaves the method scope (doesn't escape to heap), it can be allocated on the stack (free allocation, no GC pressure). Help the JIT by:

```java
// Objects that DON'T escape — JIT may stack-allocate these
public int compute(int x) {
    Point p = new Point(x, x * 2); // p never returned or stored
    return p.x + p.y;              // JIT may eliminate this allocation entirely
}

// Objects that DO escape — must be heap-allocated
public Point createPoint(int x) {
    return new Point(x, x * 2);    // returned — escapes, must be on heap
}

// Enable scalar replacement (on by default in -server mode)
-XX:+DoEscapeAnalysis           # default true
-XX:+EliminateAllocations       # default true — scalar replacement
-XX:+EliminateScalarReplacements # true by default

# Verify escape analysis working
-XX:+PrintEscapeAnalysis        # diagnostic — shows EA decisions
-XX:+PrintEliminateAllocations  # shows eliminated allocations
```

#### Fix 3 — Reduce Unnecessary Allocations

```java
// BAD — StringBuilder in a loop creates many objects
String result = "";
for (String s : list) {
    result += s;  // new String on every iteration!
}

// GOOD — single StringBuilder
StringBuilder sb = new StringBuilder();
for (String s : list) sb.append(s);
String result = sb.toString();

// BAD — autoboxing in hot path
Map<String, Integer> counts = new HashMap<>();
for (String word : words) {
    counts.merge(word, 1, Integer::sum); // Integer boxing on every count
}

// BETTER — primitive collections for hot paths
// Use Eclipse Collections, Trove, or Koloboke for int-keyed/valued maps

// BAD — stream with many intermediate collections
list.stream()
    .filter(x -> x > 0)    // intermediate list
    .map(String::valueOf)   // intermediate list
    .collect(toList());     // final list

// BETTER — pipeline is lazy, but consider if simpler loop avoids stream overhead
List<String> result = new ArrayList<>();
for (int x : list) {
    if (x > 0) result.add(String.valueOf(x));
}
```

---

### 2.4 Humongous Allocation Pressure (G1) → Increase Region Size

#### What Are Humongous Allocations?

In G1, the heap is divided into equal-sized **regions** (1–32 MB each). An object larger than **50% of a region size** is a **humongous object**. Humongous objects:
- Are allocated directly in Old Gen (bypass Young Gen entirely)
- Trigger a concurrent marking cycle immediately
- Cannot be relocated by normal GC — only freed at end of full concurrent cycle
- Can cause memory fragmentation

#### Symptoms

```bash
# GC log shows humongous allocations
[2024-01-15] GC(23) Humongous allocation for object size (2097152) bytes
[2024-01-15] GC(23) Humongous allocation succeeded
[2024-01-15] GC(24) Pause Young (G1 Humongous Allocation) 2048M->1984M(4096M) 0.411s
#                                    ^^^^^^^^^^^^^^^^^^^^ — cause is humongous alloc

# Count humongous allocations in log
grep "Humongous allocation" gc.log | wc -l
```

#### Diagnosis — Find What's Allocating Large Objects

```bash
# JFR with object allocation outside TLAB (large objects bypass TLAB)
jcmd <pid> JFR.start duration=60s filename=humongous.jfr
# Open in JMC → Memory → Allocation Outside TLAB → filter by size > 500KB

# jmap histogram — look for large arrays
jmap -histo <pid> | awk '$3 > 1000000' | sort -k3 -n -r | head -20
# Shows classes where total bytes > 1MB
```

#### Fix — Increase G1 Region Size

```bash
# Increase region size so objects need to be even larger to be "humongous"
# Default: automatically calculated as heap/2048, min 1MB, max 32MB
-XX:G1HeapRegionSize=16m    # 16MB regions: objects must be >8MB to be humongous
-XX:G1HeapRegionSize=32m    # 32MB regions: objects must be >16MB to be humongous

# Calculate: with -Xmx8g and G1HeapRegionSize=4m: 8192/4 = 2048 regions (optimal)
# Rule of thumb: aim for ~2048 regions
```

#### Fix — Reduce Object Sizes in Code

```java
// Common source: byte arrays for request/response bodies
// BAD — reading entire response into byte[]
byte[] body = httpClient.get(url).bodyAsBytes(); // might be 2MB+

// BETTER — stream the response
httpClient.get(url).bodyAsStream().transferTo(outputStream);

// BAD — large String concatenation building huge intermediate strings
String csv = rows.stream()
    .map(Row::toCsv)
    .collect(Collectors.joining("\n")); // entire CSV as one String

// BETTER — stream directly to output
PrintWriter writer = new PrintWriter(outputStream);
rows.forEach(row -> writer.println(row.toCsv()));

// BAD — caching entire large objects
cache.put(key, hugeDocument); // HugeDocument might be 5MB+

// BETTER — cache only what's needed
cache.put(key, hugeDocument.getSummary()); // just the summary
```

---

### 2.5 Metaspace OOM → Class Loader Leak, Increase MetaspaceSize

#### What Is Metaspace?

Metaspace (Java 8+) stores class metadata: class structures, method bytecode, constant pools. Unlike the old PermGen (Java 7 and earlier), Metaspace is in **native memory** (off-heap). It grows automatically by default — but can still OOM the OS.

#### Symptoms

```
java.lang.OutOfMemoryError: Metaspace
    at java.lang.ClassLoader.defineClass1(ClassLoader.java) [native]
    at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
    at ...
```

```bash
# Monitor Metaspace usage
jstat -gcmetacapacity <pid> 5000
# MCMN  MCMX   MC    CCSMN  CCSMX  CCSC  YGC  FGC  CGC  GCT
# 0.0 1048576 245760 0.0 1048576 30720  120    2    0  1.234
#              ↑ MC = current committed metaspace (KB)

# Or from jstat -gcutil
jstat -gcutil <pid> 5000
# M column = Metaspace utilization %
# if M is consistently 98–99% → growing toward limit
```

#### Root Cause 1 — Class Loader Leak

The most common cause: `ClassLoader` objects are being created and not garbage collected. Each ClassLoader loads its own set of classes into Metaspace. When the ClassLoader is leaked (held by a reference), all its classes stay in Metaspace.

**Common sources of ClassLoader leaks:**
- JDBC drivers registered but not deregistered
- Application servers that don't clean up after webapp undeploy
- Scripting engines (Groovy, BeanShell) creating class loaders per script
- Dynamic code generation (cglib, ByteBuddy, ASM) without proper class loader management
- Logging frameworks with static references to app class loaders

```java
// CLASSIC LEAK — JDBC driver registration
// In a servlet: driver registers itself in DriverManager with app ClassLoader
Class.forName("com.mysql.cj.jdbc.Driver"); // registers with DriverManager

// On webapp undeploy: DriverManager still holds reference to Driver
// Driver holds reference to its ClassLoader
// ClassLoader holds all its loaded classes in Metaspace
// → Metaspace leak on every redeploy!

// FIX — deregister JDBC drivers in ServletContextListener
@WebListener
public class AppShutdownListener implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Deregister all JDBC drivers loaded by this webapp's ClassLoader
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == cl) {
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (SQLException e) {
                    log.warn("Failed to deregister JDBC driver: {}", driver, e);
                }
            }
        }
    }
}
```

```java
// COMMON LEAK — Groovy script engine creates ClassLoader per script
GroovyShell shell = new GroovyShell(); // new ClassLoader each time!
for (String script : scripts) {
    shell.evaluate(script); // each evaluation may load new classes
}

// FIX — reuse the shell, or clear class cache
GroovyShell shell = new GroovyShell(); // create once
shell.getClassLoader().clearCache();   // periodically clear
```

#### Root Cause 2 — Too Many Classes (Dynamic Generation)

Frameworks that generate classes at runtime (Hibernate proxies, Spring AOP, reflection-based serializers) can fill Metaspace if they generate many unique classes:

```bash
# Diagnose: count loaded classes
jcmd <pid> VM.class_stats | sort -k2 -n -r | head -30
# or
jmap -histo <pid> | grep -v "^\s*[0-9]" | wc -l  # class count proxy

# Better: JFR class loading events
jcmd <pid> JFR.start duration=60s settings=default filename=classes.jfr
# Open in JMC → Class Loading → look for repeated class definitions
```

#### Fixes

```bash
# Fix 1: Increase Metaspace limit (band-aid — find the leak!)
-XX:MaxMetaspaceSize=512m       # default: unlimited (bounded by OS)
-XX:MetaspaceSize=256m          # initial committed size (triggers GC at first hit)

# Fix 2: More aggressive Metaspace GC
-XX:MinMetaspaceFreeRatio=40   # keep 40% free after GC
-XX:MaxMetaspaceFreeRatio=70   # shrink if more than 70% free

# Fix 3: Diagnose class loader leaks
-Xlog:class+load=info          # log every class load (verbose!)
-Xlog:class+unload=info        # log every class unload (should match load on undeploy)
-XX:+TraceClassLoading          # alternative syntax
-XX:+TraceClassUnloading

# Verify classes ARE being unloaded
# If loading >> unloading over time → class loader leak confirmed
```

---

## 3. Memory Leak Detection — Full Workflow

### 3.1 The Memory Leak Investigation Process

```
1. DETECT:    Application OOM / heap growing without bound
2. CONFIRM:   jstat shows Old gen not recovering after Full GC
3. CAPTURE:   Take heap dump at high-memory moment
4. ANALYZE:   Eclipse MAT — dominator tree, leak suspects, GC roots
5. FIX:       Find the reference chain, remove the retention
6. VERIFY:    Re-run with load, confirm heap stabilizes
```

### 3.2 Automatic Heap Dump — `-XX:+HeapDumpOnOutOfMemoryError`

The most critical JVM flag for production — ensures you get a heap dump the moment OOM occurs:

```bash
# Enable automatic heap dump on OOM
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/dumps/heapdump.hprof   # path for the dump file

# Important: ensure the dump directory exists and has sufficient disk space
# A heap dump is roughly equal to the heap size (e.g., 4GB heap = ~4GB dump file)

# Also useful: print a message to GC log on OOM
-XX:+PrintGCDetails               # (Java 8)
-Xlog:gc*                         # (Java 9+)

# Full recommended production OOM flags:
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/dumps/
-XX:OnOutOfMemoryError="kill -9 %p"    # restart the process after OOM
# or for graceful shutdown:
-XX:OnOutOfMemoryError="systemctl restart myapp"
```

**Where does the dump go?**
- If `-XX:HeapDumpPath` is a **directory**: JVM creates `java_pidNNN.hprof` inside it
- If it's a **file path**: used exactly as given (fails silently if already exists)
- Default (no flag set): `java_pid<pid>.hprof` in the JVM's working directory

### 3.3 Manual Heap Dump — `jcmd`

`jcmd` is the preferred tool for manual heap dumps (single process, no agent required):

```bash
# Find the PID first
jps -l                              # lists Java processes
# or: ps aux | grep java

# Trigger heap dump with jcmd
jcmd <pid> GC.heap_dump /tmp/dumps/heapdump.hprof

# Options
jcmd <pid> GC.heap_dump /tmp/heap.hprof -all    # include all objects (even unreachable)
# Default: only live objects (post-GC sweep)
# Use -all to see unreachable objects too (important for some leak types)

# Example with timestamp in filename
jcmd 12345 GC.heap_dump /tmp/heap_$(date +%Y%m%d_%H%M%S).hprof
```

### 3.4 Manual Heap Dump — `jmap`

`jmap` is the older tool. Still works but `jcmd` is preferred:

```bash
# Standard heap dump (only live objects — runs GC first)
jmap -dump:format=b,file=/tmp/heap.hprof <pid>

# Include all objects (no GC before dump — faster but includes garbage)
jmap -dump:format=b,live=false,file=/tmp/heap_all.hprof <pid>

# Live objects only (same as default)
jmap -dump:format=b,live=true,file=/tmp/heap_live.hprof <pid>

# Quick object histogram (no full dump needed — just counts)
jmap -histo <pid>          # includes GC'd objects
jmap -histo:live <pid>     # live objects only (runs GC first)
```

**Output of `jmap -histo`:**
```
 num     #instances         #bytes  class name (module)
-------------------------------------------------------
   1:      1,523,041     97,474,624  [B                        ← byte arrays
   2:        823,511     26,352,352  java.lang.String
   3:        312,044     24,963,520  com.myapp.UserSession     ← 312K sessions?!
   4:        200,000     16,000,000  java.util.HashMap$Node
   5:        189,034      9,059,032  [Ljava.lang.Object;
```

### 3.5 Comparing Two Heap Histograms — Finding the Leak Object

```bash
# Take baseline histogram
jmap -histo:live <pid> > /tmp/histo_before.txt

# Wait 10 minutes (let the leak accumulate)
sleep 600

# Take second histogram
jmap -histo:live <pid> > /tmp/histo_after.txt

# Compare: find classes that grew significantly
# Simple diff approach:
diff /tmp/histo_before.txt /tmp/histo_after.txt

# Better: extract and compare the numbers
awk 'NR>3{print $4, $2}' /tmp/histo_before.txt | sort > /tmp/b.txt
awk 'NR>3{print $4, $2}' /tmp/histo_after.txt  | sort > /tmp/a.txt
join -j 1 /tmp/b.txt /tmp/a.txt | awk '{delta=$3-$2; if(delta>1000) print delta, $1}' | sort -rn | head -20
# Shows: classes whose instance count grew by >1000 in the interval
```

---

## 4. Eclipse MAT — Deep Analysis

Eclipse Memory Analyzer Tool (MAT) is the standard tool for heap dump analysis. Free, powerful, and handles multi-GB dumps.

### 4.1 Opening a Heap Dump

```
1. Download Eclipse MAT: https://eclipse.dev/mat/downloads.php
2. File → Open Heap Dump → select .hprof file
3. MAT parses the dump (may take minutes for large files)
4. MAT presents the "Getting Started Wizard" — choose analysis type
```

**MAT memory settings** (for large dumps):
```
# Edit MemoryAnalyzer.ini
-Xmx8g          # give MAT enough heap to analyze your dump
-Xms2g
```

### 4.2 Dominator Tree — Who Owns the Memory?

The **dominator tree** is the most important MAT view for leak detection. It shows the retention tree: which objects are "responsible" for keeping other objects alive, and how much memory each object "dominates" (keeps alive).

```
Concept: Object A dominates object B if ALL paths from GC root to B go through A.
If you removed A from the heap, B would become unreachable and could be collected.

Dominator Tree view:
├── static WeakReferenceSet  [67.3% of heap = 5.4GB]    ← This owns most memory!
│   └── HashMap$Entry[]      [67.3% of heap]
│       ├── UserSession      [0.02% each × 312,000]
│       │   ├── byte[]       (session data)
│       │   └── Connection   (DB connection not closed)
│       └── ...
├── ThreadGroup "main"       [18.1%]
└── ...
```

**How to use:**
1. Open `Window → Heap Dump Overview → Dominator Tree`
2. Sort by **Retained Heap** descending
3. Top entries are the biggest memory consumers
4. Expand entries to find what's holding the memory
5. Right-click → `Path to GC Roots` → reveals why it's not collected

### 4.3 Leak Suspects Report

MAT's automated leak detection. Let MAT do the initial analysis:

```
File → Run Expert System Test → Leak Suspects

Report includes:
- Problem 1: One instance of "com.myapp.SessionStore" loaded by "WebAppClassLoader"
  occupies 4,294,967,296 (67.3%) bytes.
  The memory is accumulated in:
    java.util.HashMap, loaded by "WebAppClassLoader"
  at com.myapp.SessionStore.<clinit>() line 23

- Shortest paths from GC roots:
  <class com.myapp.SessionStore>
      └── sessions : java.util.HashMap         ← static field!
              └── table : java.util.HashMap$Entry[]
                      └── [0] : UserSession × 312,044
```

### 4.4 GC Roots — Path to GC Root

"Why is this object not being collected?" — the `Path to GC Roots` answer reveals the reference chain:

```
Right-click any object → Path to GC Roots → exclude weak/soft references

Example output:
com.myapp.UserSession @ 0x7f80a1234  (retained: 12KB)
  └── [retained by]
      sessions : java.util.HashMap$Node
        └── [retained by]
            table : java.util.HashMap
              └── [retained by]
                  sessions (field) : com.myapp.SessionStore   ← static field
                    └── [retained by]
                        <class> com.myapp.SessionStore         ← class in Metaspace
                          └── [retained by]
                              WebAppClassLoader                ← GC root
```

**Reading the result:**
1. `SessionStore` has a `static` field `sessions` (a `HashMap`)
2. That HashMap holds 312,044 `UserSession` objects
3. Sessions are never removed from the map
4. **Fix**: ensure sessions are expired and removed from the map

### 4.5 OQL — Object Query Language

MAT supports SQL-like queries over the heap:

```sql
-- Find all UserSession objects
SELECT * FROM com.myapp.UserSession

-- Find sessions created more than 1 hour ago (createdAt is a long unix timestamp)
SELECT s FROM com.myapp.UserSession s
WHERE (s.createdAt < (System.currentTimeMillis() - 3600000))

-- Find all HashMap instances with more than 10,000 entries
SELECT h, h.size FROM java.util.HashMap h WHERE h.size > 10000

-- Find objects retained by a specific class loader
SELECT * FROM INSTANCEOF java.lang.Object o
WHERE classof(o).classLoader.toString().contains("WebAppClassLoader")

-- Find all strings containing "password" (data leak check)
SELECT s FROM java.lang.String s
WHERE s.toString().contains("password")
```

Access via: `Window → Heap Dump Overview → OQL`

### 4.6 Object Histogram

```
Window → Heap Dump Overview → Class Histogram

Shows:
Class Name                     | Objects    | Shallow Heap | Retained Heap
java.lang.String               | 3,412,441  | 81,898,584   | 189,233,760
byte[]                         | 3,504,221  | 540,123,456  | 540,123,456
com.myapp.UserSession          |   312,044  |  24,963,520  | 4,102,455,296 ← huge retained!
```

- **Shallow Heap**: memory used by the object itself (not its references)
- **Retained Heap**: total memory freed if this object were collected (including all dominated objects)

---

## 5. VisualVM — Live Monitoring

VisualVM is a free GUI tool bundled with the JDK (or available standalone). Best for development and staging environments.

### 5.1 Starting VisualVM

```bash
# Run VisualVM (bundled with JDK 8, standalone download for JDK 9+)
jvisualvm          # JDK 8
# Download from: https://visualvm.github.io/

# Enable JMX for remote connection
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=9090
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false
```

### 5.2 Live Heap Monitoring

**Monitor tab shows in real-time:**
- Heap size vs used (graph over time)
- GC activity (frequency and duration)
- Loaded classes count
- Thread count

```
Application → double-click process → Monitor tab
→ Watch "Heap" graph:
  - Saw-tooth pattern = healthy (allocate, GC, repeat)
  - Upward-trending floor after each GC = memory leak!
  - Flat line near top + frequent Full GC = Old gen full
```

### 5.3 Object Histogram (Live)

```
Plugins → Install "VisualVM-VisualGC" and "VisualVM-BufferMonitor"

Sampler tab → Memory → "Sample" button
→ Shows live object count and size per class
→ Watch for classes growing continuously
→ Snapshot → Compare → delta shows what grew
```

### 5.4 Heap Dump from VisualVM

```
Application → right-click process → "Heap Dump"
→ Creates .hprof in temp directory
→ Opens in VisualVM's built-in analyzer
   OR: Save to disk → open in Eclipse MAT for deep analysis
```

### 5.5 CPU and Memory Sampling

```
Sampler tab → CPU / Memory → Start → run workload → Stop

CPU Sampling output:
Method                                  | Self Time | Total Time
com.myapp.JsonParser.parseToken         |  34.2%    |  34.2%    ← hot method
com.myapp.UserService.loadProfile       |   8.1%    |  12.3%
java.util.regex.Pattern.matcher         |  12.1%    |  12.1%    ← regex overhead!

Memory Sampling output:
Allocated Bytes   | Class
  4.2 GB          | byte[]              ← huge byte[] allocation
  1.1 GB          | char[]
    800 MB         | com.myapp.Event    ← Event objects allocated heavily
```

---

## 6. Commercial Profilers — JProfiler and YourKit

### 6.1 JProfiler

JProfiler is the most comprehensive Java profiler. Key features for memory analysis:

```
Allocation hotspots:
  Profiling → Allocation → Live Objects
  → Shows call tree of where objects are being allocated
  → Drill down to the exact new Statement() call creating the leak

Heap Walker:
  Profiling → Heap Walker → Take Snapshot
  → Similar to MAT but integrated
  → "References" tab → "Incoming references" → shows who holds your object

TLAB allocation recording:
  → Shows objects too small to be individually tracked
  → Shows per-method allocation rates
```

**JProfiler startup flags (attach to running JVM):**
```bash
-agentpath:/path/to/jprofiler/bin/linux-x64/libjprofilerti.so=port=8849

# Or offline profiling (no GUI needed during run)
-agentpath:.../libjprofilerti.so=offline,id=168,config=/path/to/config.xml
```

### 6.2 YourKit

YourKit is strong at allocation tracking with very low overhead:

```
Memory profiling → Object allocation recording → Start
  → Run workload
  → Stop → Analyze allocation tree

Key views:
  "Biggest objects" → same as dominator tree concept
  "Memory allocations" → where objects are created (call tree)
  "Generation" → shows when objects were allocated (age)
  "Anti-patterns detector" → finds: large redundant arrays, strings, duplicates
```

**YourKit startup:**
```bash
-agentpath:/path/to/yourkit/bin/linux-x86-64/libyjpagent.so

# Capture heap snapshot programmatically
Controller controller = new Controller();
controller.captureMemorySnapshot();
```

### 6.3 Async-profiler (Free, Low-Overhead)

For production allocation profiling without commercial license:

```bash
# Download: https://github.com/async-profiler/async-profiler

# Attach to running process and profile allocations for 60s
./profiler.sh -e alloc -d 60 -f alloc.html <pid>

# Profile CPU
./profiler.sh -e cpu -d 60 -f cpu.html <pid>

# Profile with flamegraph output
./profiler.sh -d 60 -f flamegraph.html <pid>

# Capture via API in code
AsyncProfiler profiler = AsyncProfiler.getInstance();
profiler.execute("start,event=alloc,file=alloc.jfr");
// ... run workload ...
profiler.execute("stop");
```

---

## 7. Common Memory Leak Patterns

### 7.1 Static Collections Growing Without Bounds

The most common leak: a `static` data structure that accumulates entries but never removes them.

```java
// LEAK — static cache with no eviction
public class UserCache {
    // This grows forever — loaded classes and their ClassLoaders stay in memory
    private static final Map<Long, UserProfile> CACHE = new HashMap<>();

    public static UserProfile get(long userId) {
        return CACHE.computeIfAbsent(userId, id -> loadFromDB(id)); // never evicted!
    }
}

// FIX 1 — Use a size-bounded cache (evicts LRU)
private static final Map<Long, UserProfile> CACHE =
    Collections.synchronizedMap(new LinkedHashMap<Long, UserProfile>(1000, 0.75f, true) {
        @Override
        protected boolean removeEldestEntry(Map.Entry<Long, UserProfile> eldest) {
            return size() > 1000; // max 1000 entries
        }
    });

// FIX 2 — Use Caffeine (recommended)
private static final Cache<Long, UserProfile> CACHE = Caffeine.newBuilder()
    .maximumSize(10_000)
    .expireAfterWrite(Duration.ofMinutes(30))
    .build();

// FIX 3 — Use WeakReference values (auto-evicted when memory pressure occurs)
private static final Map<Long, WeakReference<UserProfile>> CACHE =
    new ConcurrentHashMap<>();
```

### 7.2 Unclosed Resources

Resources that hold native memory or prevent GC:

```java
// LEAK — Connection never closed
public List<User> getUsers() throws SQLException {
    Connection conn = dataSource.getConnection(); // not in try-with-resources
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM users");
    ResultSet rs = ps.executeQuery();
    List<User> users = new ArrayList<>();
    while (rs.next()) users.add(mapRow(rs));
    return users; // conn, ps, rs all leaked if exception thrown
}

// FIX — try-with-resources
public List<User> getUsers() throws SQLException {
    try (Connection conn = dataSource.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM users");
         ResultSet rs = ps.executeQuery()) {
        List<User> users = new ArrayList<>();
        while (rs.next()) users.add(mapRow(rs));
        return users;
    } // all closed automatically, even on exception
}

// LEAK — InputStream not closed
InputStream is = url.openStream();
byte[] data = is.readAllBytes(); // if readAllBytes() throws, is is never closed

// FIX
try (InputStream is = url.openStream()) {
    return is.readAllBytes();
}
```

### 7.3 Listener / Callback Accumulation

Event listeners registered but never removed:

```java
// LEAK — anonymous listener registered but never removed
public class MapWidget {
    private final EventBus bus;

    public MapWidget(EventBus bus) {
        this.bus = bus;
        // Anonymous listener holds a reference to MapWidget
        // MapWidget can't be GC'd until this listener is removed
        bus.subscribe(LocationUpdateEvent.class, event -> {
            this.updateLocation(event.getCoordinates()); // 'this' captured
        });
        // No unsubscribe when MapWidget is destroyed!
    }
}

// FIX — keep a reference to the listener and unsubscribe on destroy
public class MapWidget {
    private final EventBus bus;
    private final Consumer<LocationUpdateEvent> locationListener;

    public MapWidget(EventBus bus) {
        this.bus = bus;
        this.locationListener = event -> this.updateLocation(event.getCoordinates());
        bus.subscribe(LocationUpdateEvent.class, locationListener);
    }

    public void destroy() {
        bus.unsubscribe(LocationUpdateEvent.class, locationListener); // clean up!
    }
}
```

### 7.4 ClassLoader Leaks (Deep Dive)

```java
// LEAK pattern — thread context ClassLoader not restored
public void executeInContext(ClassLoader cl, Runnable task) {
    Thread thread = Thread.currentThread();
    ClassLoader original = thread.getContextClassLoader();
    thread.setContextClassLoader(cl); // set new ClassLoader
    task.run();
    // MISSING: thread.setContextClassLoader(original);
    // If task throws, ClassLoader is permanently changed on this thread
}

// FIX
public void executeInContext(ClassLoader cl, Runnable task) {
    Thread thread = Thread.currentThread();
    ClassLoader original = thread.getContextClassLoader();
    thread.setContextClassLoader(cl);
    try {
        task.run();
    } finally {
        thread.setContextClassLoader(original); // ALWAYS restore
    }
}

// DETECTION — Find number of live ClassLoaders in MAT
SELECT * FROM java.lang.ClassLoader
// Healthy: a few ClassLoaders (bootstrap, ext, app, per-webapp)
// Leaking: hundreds of ClassLoaders accumulating
```

### 7.5 ThreadLocal Leaks

```java
// LEAK — ThreadLocal value set but never removed in thread pool
private static final ThreadLocal<Connection> CONN = new ThreadLocal<>();

public void doWork() {
    CONN.set(dataSource.getConnection()); // set on thread
    try {
        // ... use CONN.get() ...
    } finally {
        // FIX: add CONN.remove() here
        // Without it: Connection is retained for the lifetime of the thread pool thread
    }
}

// DETECTION in MAT:
// Search for ThreadLocalMap$Entry objects
// Look for entries with non-null values on long-lived threads
SELECT * FROM java.lang.ThreadLocal$ThreadLocalMap$Entry e
WHERE e.value != null
```

### 7.6 `intern()` String Accumulation

```java
// LEAK — interning dynamic strings fills the String pool (heap, not PermGen in Java 8+)
public String processRequest(String userId) {
    return userId.intern(); // adds to String pool — never GC'd while pool exists
}
// If userId is unique per request, String pool grows indefinitely

// FIX: don't intern dynamic strings — only intern known-finite sets
// intern() is appropriate for: protocol constants, enum-like values, fixed set of tokens
```

---

## 8. Key JVM Monitoring Tools

### 8.1 `jstat -gcutil` — Live GC Statistics

`jstat` is a command-line tool for JVM statistics. The most useful variant for GC monitoring:

```bash
# Syntax: jstat -gcutil <pid> <interval_ms> [<count>]
jstat -gcutil <pid> 1000         # every 1 second, indefinitely
jstat -gcutil <pid> 1000 60      # every 1 second, 60 times (1 minute)

# Output columns:
# S0   S1   E    O    M    CCS  YGC  YGCT  FGC  FGCT  CGC  CGCT  GCT
# 0.0  75.1 90.2 55.3 96.1 91.2 1240 12.40   2  8.21    0  0.00  20.61

# Column meanings:
# S0/S1  — Survivor space 0/1 utilization (%)
# E      — Eden space utilization (%)
# O      — Old gen utilization (%)
# M      — Metaspace utilization (%)
# CCS    — Compressed class space utilization (%)
# YGC    — Young GC count since JVM start
# YGCT   — Young GC time total (seconds)
# FGC    — Full GC count since JVM start
# FGCT   — Full GC time total (seconds)
# GCT    — Total GC time (seconds)

# What to watch:
# O near 100% + FGC increasing rapidly → Old gen problem
# M near 100% + FGC increasing → Metaspace problem
# YGC rate very high (>10/s) → high allocation rate
```

**Other `jstat` options:**

```bash
jstat -gc <pid> 1000          # raw sizes in KB instead of percentages
jstat -gccapacity <pid> 1000  # min/max/current sizes for all spaces
jstat -gcnew <pid> 1000       # Young gen only (Eden, S0, S1)
jstat -gcold <pid> 1000       # Old gen only
jstat -gcmetacapacity <pid>   # Metaspace capacity details
jstat -class <pid> 1000       # Class loading statistics
jstat -compiler <pid> 1000    # JIT compilation stats
```

### 8.2 `jmap -histo` — Object Histogram

```bash
# Quick snapshot of object counts and sizes by class
jmap -histo <pid> | head -30           # top 30 classes by instance count
jmap -histo:live <pid> | head -30      # trigger GC first (live objects only)

# Redirect for later analysis
jmap -histo:live <pid> > /tmp/histo_$(date +%s).txt

# Sort by total bytes (column 3)
jmap -histo:live <pid> | sort -k3 -n -r | head -30

# Find all instances of a specific package
jmap -histo <pid> | grep "com.myapp"
```

### 8.3 `jcmd` — The Universal Diagnostic Tool

`jcmd` is the modern all-in-one JVM diagnostic tool. Prefer it over `jmap`, `jstack`, `jstat` where possible:

```bash
# List all Java processes
jcmd                          # shows all JVMs
jcmd <pid> help               # shows all available commands for a JVM

# GC operations
jcmd <pid> GC.run                              # trigger GC
jcmd <pid> GC.run_finalization                 # run finalizers
jcmd <pid> GC.heap_info                        # heap summary
jcmd <pid> GC.heap_dump /tmp/heap.hprof        # heap dump
jcmd <pid> GC.class_stats                      # per-class stats

# Thread operations
jcmd <pid> Thread.print                        # thread dump (like jstack)
jcmd <pid> Thread.dump_to_file /tmp/threads.txt  # thread dump to file

# VM info
jcmd <pid> VM.flags                            # all active JVM flags
jcmd <pid> VM.system_properties                # system properties
jcmd <pid> VM.native_memory                    # native memory tracking
jcmd <pid> VM.info                             # general VM info
jcmd <pid> VM.version                          # JDK version
jcmd <pid> VM.command_line                     # command line used to start JVM

# JFR operations (see Section 9)
jcmd <pid> JFR.start
jcmd <pid> JFR.stop
jcmd <pid> JFR.dump
```

### 8.4 `jconsole` — GUI JMX Monitor

```bash
# Start jconsole (connects via JMX)
jconsole              # shows local Java processes to connect to
jconsole <pid>        # connect directly
jconsole host:port    # connect to remote JMX

# Enable remote JMX on target application:
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=9999
-Dcom.sun.management.jmxremote.authenticate=false   # for dev only
-Dcom.sun.management.jmxremote.ssl=false            # for dev only
```

**jconsole tabs:**
- **Overview**: heap, threads, classes, CPU — live graphs
- **Memory**: detailed heap breakdown, GC button, histogram
- **Threads**: live thread list, deadlock detection
- **Classes**: loaded/unloaded class counts over time
- **MBeans**: browse and invoke JMX MBeans directly

### 8.5 `jstack` — Thread Dump

Thread dumps reveal: deadlocks, thread states, blocked threads, CPU-spinning threads.

```bash
# Generate thread dump
jstack <pid>                    # prints to stdout
jstack <pid> > /tmp/threads.txt # save to file
jstack -l <pid>                 # long form — includes lock info

# Multiple thread dumps with interval (deadlock detection)
for i in 1 2 3; do
    jstack <pid> > /tmp/threads_$i.txt
    sleep 5
done
# Compare: if threads are in the same state across dumps, they're stuck

# Example output showing a deadlock:
# Found one Java-level deadlock:
# =============================
# "Thread-1": waiting to lock monitor 0x00007f... (object 0x..., a java.lang.Object)
#   which is held by "Thread-2"
# "Thread-2": waiting to lock monitor 0x00007f...
#   which is held by "Thread-1"
```

---

## 9. Java Flight Recorder and Java Mission Control

### 9.1 What Is JFR?

Java Flight Recorder (JFR) is a **low-overhead, always-on production profiler** built into the JVM. It records JVM internals with <1% overhead (when not recording, ~0.01%).

JFR records:
- GC events (all GC cycles, pauses, allocation rates)
- JIT compilation events
- Thread state changes (blocking, sleeping, CPU usage)
- I/O events (file reads, network reads)
- Exception throws
- Memory allocation (sampled — every TLAB allocation)
- Class loading
- Safepoints
- Method profiling (CPU sample)

### 9.2 Starting JFR

```bash
# Option 1: Start at JVM launch (always-on circular buffer)
-XX:StartFlightRecording=duration=0,maxsize=250m,filename=recording.jfr,dumponexit=true

# Option 2: Start at launch with settings profile
-XX:StartFlightRecording=duration=0,settings=profile,maxsize=500m

# Settings profiles:
# default  — minimal overhead (~0.1%), production safe
# profile  — more detail (~1% overhead), for profiling sessions

# Option 3: Start recording via jcmd (can do at any time)
jcmd <pid> JFR.start name=my-recording duration=120s filename=/tmp/app.jfr

# Start without duration (run until manually stopped)
jcmd <pid> JFR.start name=my-recording maxsize=500m

# Check recording status
jcmd <pid> JFR.check

# Dump current in-memory recording to file
jcmd <pid> JFR.dump name=my-recording filename=/tmp/dump.jfr

# Stop recording
jcmd <pid> JFR.stop name=my-recording filename=/tmp/final.jfr

# Useful for production: circular buffer, dump on OOM
-XX:StartFlightRecording=maxsize=250m,dumponexit=true,filename=/tmp/oom.jfr
-XX:FlightRecorderOptions=dumponoutofmemoryerror=true,dumppath=/tmp/jfr_oom.jfr
```

### 9.3 JFR Configuration — Tuning What Gets Recorded

```bash
# Custom JFR settings file
jcmd <pid> JFR.start settings=/path/to/custom.jfc name=custom-recording

# Key settings in .jfc file (XML):
# <event name="jdk.ObjectAllocationInNewTLAB" ...>
#   <setting name="enabled">true</setting>
#   <setting name="stackTrace">true</setting>
# </event>
#
# <event name="jdk.GarbageCollection">
#   <setting name="enabled">true</setting>
# </event>
#
# <event name="jdk.JavaExceptionThrow">
#   <setting name="enabled">false</setting>  # disable noisy events
# </event>
```

### 9.4 Java Mission Control (JMC) — Analyzing JFR Recordings

JMC is the GUI for JFR analysis. Download separately from https://jdk.java.net/jmc/

```
Opening a recording:
  File → Open File → select .jfr file
  OR drag and drop .jfr file into JMC

Key views:
```

**JMC Navigation:**
```
General:
  Overview          → timeline of events, GC activity, CPU, thread count
  Automated Analysis → JMC detects common issues automatically (recommended first step)

Memory:
  Garbage Collections   → GC pause times, types, heap changes per GC
  GC Configuration      → what collector, what flags
  Object Statistics     → per-class allocation count/size (top allocators)
  Allocation Pressure   → where in code objects are allocated (call tree)
  Allocation in TLAB    → normal allocations (sampled)
  Allocation Outside TLAB → large object allocations (humongous)
  
  Heap:   live heap size over time
  
Threads:
  Thread Profiling     → CPU flame graph per thread (sampled stack traces)
  Thread Activity      → timeline showing when each thread was running/blocked/sleeping
  Lock Instances       → contended locks, wait times
  
I/O:
  File I/O             → file reads/writes by file, by thread
  Socket Read/Write    → network I/O by host:port
  
Code:
  Hot Methods          → top CPU-consuming methods (CPU sampled)
  Exception Statistics → exception types and rates
  Compiler             → JIT compilation events
```

### 9.5 JFR Automated Analysis

The most underused feature — JMC reads the recording and flags problems automatically:

```
Window → Automated Analysis Results

Example findings:
  ⚠ High Allocation Pressure
    Significant allocation rate detected: 8.2 GB/min
    Top allocator: com.myapp.JsonParser.parse() → byte[] (42% of allocations)

  ⚠ GC Pause Time
    Maximum GC pause 4.3s (at 10:23:41)
    Recommendation: consider switching to ZGC

  ⚠ Blocked Threads
    Thread "request-handler-12" blocked for 2.3s on:
      java.util.concurrent.locks.ReentrantLock.lock() 
      held by "db-connection-pool-cleaner"

  ✓ No deadlocks detected
  ✓ No OOME detected
```

---

## 10. Production Diagnostic Runbook

### 10.1 "Application Is Running Slow" — Investigation Steps

```bash
# Step 1: Check if GC is the cause
jstat -gcutil <pid> 1000 30
# Is GC time > 10% of wall time? Is FGC increasing?
# If GC is responsible: see Section 2

# Step 2: Check CPU usage
top -H -p <pid>          # show individual JVM threads
# Find threads consuming >80% CPU
# Convert TID to hex: printf '%x\n' <tid>
# Find in thread dump: jstack <pid> | grep -A 30 "nid=0x<hex_tid>"

# Step 3: Thread dump for blocked threads
jstack <pid> | grep -A 5 "BLOCKED"
jstack <pid> | grep -A 5 "WAITING"

# Step 4: JFR for method-level profiling
jcmd <pid> JFR.start duration=60s settings=profile filename=/tmp/slow.jfr
# Reproduce the slow behavior
# Analyze in JMC → Hot Methods
```

### 10.2 "Application Is Using Too Much Memory" — Investigation Steps

```bash
# Step 1: Confirm heap growth
jstat -gcutil <pid> 5000 12   # 1 minute
# Watch O (Old) column — does it grow and never decrease?

# Step 2: Quick object histogram (no dump needed)
jmap -histo:live <pid> | head -30
# Any suspicious classes with high instance count?

# Step 3: Compare two histograms 10 minutes apart
jmap -histo:live <pid> > /tmp/h1.txt; sleep 600; jmap -histo:live <pid> > /tmp/h2.txt
# Find growing classes

# Step 4: Take heap dump
jcmd <pid> GC.heap_dump /tmp/heap.hprof

# Step 5: Analyze in Eclipse MAT
# File → Open → heap.hprof
# Run → Leak Suspects Report
# OR: Dominator Tree → find biggest retained heap
# OR: Path to GC Roots on suspicious objects
```

### 10.3 "OutOfMemoryError Just Happened" — Post-Mortem

```bash
# Step 1: Locate the heap dump (if -XX:+HeapDumpOnOutOfMemoryError was set)
find /var/dumps -name "*.hprof" -newer /var/log/app/app.log
ls -lh java_pid*.hprof   # in JVM working directory if path not specified

# Step 2: Check which OOM type
grep "OutOfMemoryError" /var/log/app/app.log
# "Java heap space"      → heap exhausted
# "GC overhead limit"    → too much time in GC, not enough progress
# "Metaspace"            → class loader or dynamic class generation issue
# "Direct buffer memory" → native memory exhausted (ByteBuffer.allocateDirect)
# "Unable to create native thread" → too many threads

# Step 3: For "GC overhead limit exceeded"
-XX:-UseGCOverheadLimit    # disable the check (band-aid) 
# Better: fix the underlying OOM cause

# Step 4: For Direct buffer memory OOM
-XX:MaxDirectMemorySize=2g  # increase limit
# Also: ensure DirectByteBuffers are freed
```

### 10.4 Validate with Production-Like Load

Memory leaks often only manifest under sustained load. Use this approach:

```bash
# Step 1: Run load test with realistic traffic for 30+ minutes
# (Use: Apache JMeter, k6, Gatling, wrk, hey)

# Step 2: Monitor heap continuously during load
jstat -gcutil <pid> 10000 | tee /tmp/gc_under_load.txt

# Step 3: Take heap snapshots at regular intervals
for i in 1 2 3 4 5; do
    jcmd <pid> GC.heap_dump /tmp/heap_interval_$i.hprof
    echo "Snapshot $i taken at $(date)"
    sleep 600   # 10 minutes between snapshots
done

# Step 4: Compare histograms across snapshots
# Growing classes = potential leak
# Stable classes = no leak

# Step 5: Check GC log for Full GC trend
grep "Pause Full" gc.log | tail -50
# Increasing frequency of Full GC under sustained load = leak or undersizing

# Step 6: Heap floor check
# After each Full GC, note the heap size
# If floor is rising with each Full GC = definite leak
grep "Pause Full" gc.log | awk '{print $NF}' | sed 's/M.*//'
```

---

## 11. Quick Reference Cheat Sheet

### GC Problem Diagnosis & Fix

| Symptom | Likely Cause | Fix |
|---|---|---|
| Frequent Full GC, heap stays high | Memory leak OR Old gen too small | Heap dump → MAT analysis; or `+Xmx` |
| Full GC every few minutes, heap recovers | Old gen too small for live data | Increase `-Xmx`, tune `NewRatio` |
| Long STW pauses (>500ms) | Wrong GC collector | Switch to ZGC (`-XX:+UseZGC`) |
| Minor GC every few seconds | High allocation rate | JFR alloc profiling, reduce allocations |
| `Humongous allocation` in GC log | Objects > G1 region/2 | `-XX:G1HeapRegionSize=16m` |
| `OutOfMemoryError: Metaspace` | ClassLoader leak | JFR class loading, MAT classloader analysis |
| `GC overhead limit exceeded` | OOM in disguise | Find the heap/metaspace OOM cause |

### Heap Dump Commands

```bash
# Auto-dump on OOM (production must-have)
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/dumps/

# Manual dump
jcmd <pid> GC.heap_dump /tmp/heap.hprof          # preferred
jmap -dump:format=b,file=/tmp/heap.hprof <pid>   # legacy

# Quick histogram (no dump)
jmap -histo:live <pid> | head -30
```

### `jstat` Quick Reference

```bash
jstat -gcutil <pid> 1000          # % utilization of all spaces, every 1s
jstat -gc     <pid> 1000          # raw KB sizes, every 1s
jstat -gcnew  <pid> 1000          # Young gen stats
jstat -class  <pid> 1000          # class loading stats
```

### `jcmd` Quick Reference

```bash
jcmd <pid> GC.run                              # trigger GC
jcmd <pid> GC.heap_dump /tmp/h.hprof           # heap dump
jcmd <pid> GC.heap_info                        # heap summary
jcmd <pid> Thread.print                        # thread dump
jcmd <pid> VM.flags                            # active JVM flags
jcmd <pid> JFR.start duration=60s filename=x.jfr  # JFR recording
jcmd <pid> JFR.dump filename=x.jfr            # dump current recording
```

### JFR Quick Start

```bash
# Start immediately (production-safe, circular buffer)
-XX:StartFlightRecording=maxsize=250m,dumponexit=true,filename=/tmp/app.jfr

# Ad-hoc profiling
jcmd <pid> JFR.start duration=120s settings=profile filename=/tmp/profile.jfr
```

### Memory Leak Detection Workflow

```
1. Confirm: jstat -gcutil → Old gen floor rising after each Full GC
2. Snapshot: jmap -histo:live → compare two histograms 10min apart
3. Dump: jcmd <pid> GC.heap_dump /tmp/heap.hprof
4. Analyze: Eclipse MAT → Leak Suspects Report
5. Trace: Path to GC Roots → find the holding reference
6. Fix: Remove static reference / close resource / unregister listener
7. Verify: Load test → confirm heap stabilizes
```

### Key JVM Flags for Production

```bash
# GC logging (always enable)
-Xlog:gc*:file=/var/log/gc.log:time,uptime:filecount=10,filesize=50m

# OOM safety net (always enable)
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/dumps/

# Low-latency GC (Java 15+)
-XX:+UseZGC

# JFR always-on (minimal overhead)
-XX:StartFlightRecording=maxsize=250m,dumponexit=true

# Memory leak detection
-XX:NativeMemoryTracking=summary   # track native memory usage
```

---

*End of JVM GC Problems, Memory Leak Detection & Monitoring Tools Study Guide*
