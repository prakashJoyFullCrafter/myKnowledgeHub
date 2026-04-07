# JVM Production Troubleshooting Toolkit — Complete Study Guide

> **Brutally Detailed Reference**
> Covers every JVM diagnostic command, Arthas live profiling, all four OOM patterns with root cause analysis, and a structured on-call incident runbook. Every section includes real command output, flags, and actionable fixes.

---

## Table of Contents

1. [Overview — The Production Diagnostic Stack](#1-overview--the-production-diagnostic-stack)
2. [`jcmd VM.info` — Full JVM Configuration Dump](#2-jcmd-vminfo--full-jvm-configuration-dump)
3. [`jcmd VM.flags` — All Active JVM Flags](#3-jcmd-vmflags--all-active-jvm-flags)
4. [`jcmd VM.system_properties` — System Properties](#4-jcmd-vmsystem_properties--system-properties)
5. [`jinfo` — Inspect and Modify JVM Flags at Runtime](#5-jinfo--inspect-and-modify-jvm-flags-at-runtime)
6. [`jstat -gcutil` — Live GC Statistics](#6-jstat--gcutil--live-gc-statistics)
7. [Arthas — Production Diagnostics Without Restart](#7-arthas--production-diagnostics-without-restart)
8. [Common OOM Patterns — All Four Types](#8-common-oom-patterns--all-four-types)
9. [On-Call Checklist — Structured Incident Response](#9-on-call-checklist--structured-incident-response)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. Overview — The Production Diagnostic Stack

### 1.1 Tool Selection Matrix

When an incident occurs, the right tool depends on what you're observing:

| Symptom | First Tool | Second Tool | Deep Dive |
|---|---|---|---|
| Application slow / high latency | `jstat -gcutil` | Thread dump | JFR |
| OutOfMemoryError | GC logs | `jmap -histo` | Heap dump + MAT |
| High CPU, no progress | Thread dump + `top -H` | JFR CPU profile | Arthas `trace` |
| Specific method slow | Arthas `trace` | JFR method sampling | JProfiler |
| Unknown config (new deploy) | `jcmd VM.flags` | `jcmd VM.info` | — |
| Class loading issue | `jstat -class` | `jcmd VM.flags` | JFR class events |
| Thread pool exhausted | Thread dump | `jcmd Thread.print` | Arthas `dashboard` |
| Memory climbing slowly | `jstat -gcutil` over time | `jmap -histo` diff | Heap dump + MAT |

### 1.2 The Diagnostic Pyramid

```
Level 5 (Slowest, Most Invasive)    Heap Dump + Eclipse MAT
                                    JFR Recording + JMC
Level 4                             Thread Dump Analysis
                                    jmap -histo
Level 3                             Arthas trace/watch/stack
Level 2                             jstat, jinfo, VM.flags
Level 1 (Fastest, Zero Overhead)    jcmd VM.info, GC logs, jps
```

Start at Level 1. Move up only when needed. Each level has higher overhead and impact risk.

### 1.3 Connecting to a JVM Process

```bash
# List all Java processes
jps -l                       # PID + main class
jps -lvm                     # PID + main class + JVM args + system props
ps aux | grep java           # OS-level view

# All jcmd commands use the same PID
jcmd                         # lists all local Java processes with PIDs
jcmd <pid> help              # shows ALL available commands for that JVM
```

---

## 2. `jcmd VM.info` — Full JVM Configuration Dump

### 2.1 What It Provides

`VM.info` produces a comprehensive dump of the JVM's full configuration and state at the moment of invocation. It is the single most information-dense command available.

```bash
jcmd <pid> VM.info
# Also redirect to file for sharing/archiving
jcmd <pid> VM.info > /tmp/jvm_info_$(date +%Y%m%d_%H%M%S).txt
```

### 2.2 Full Output Sections Explained

```
# ===== VM.info output breakdown =====

# --- Section 1: JVM Version ---
Java HotSpot(TM) 64-Bit Server VM (21.0.1+12-LTS)
for linux-amd64 JRE (21.0.1+12-LTS), built on 2023-10-17T12:14:20Z

# --- Section 2: Command-line arguments (how the JVM was started) ---
VM Arguments:
jvm_args: -Xms2g -Xmx8g -XX:+UseZGC -XX:MaxMetaspaceSize=512m
          -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/dumps/
          -Xlog:gc*:file=/var/log/gc.log:time,uptime:filecount=10,filesize=50m
          -javaagent:/opt/agents/opentelemetry-agent.jar
java_command: com.myapp.Application --spring.profiles.active=prod
java_class_path (initial): /opt/app/myapp.jar

# --- Section 3: OS information ---
OS:
 Linux
 OS version: 5.15.0-1049-aws #55-Ubuntu SMP x86_64
 CPU: total 16 (initial active 16) (2 performance, 14 efficiency) cycles: 2400000000 Hz

# --- Section 4: Memory ---
Memory: 4k page, physical 32768M(18432M free), swap 0M(0M free)
# physical total = 32GB, 18GB free = under moderate memory pressure

# --- Section 5: Heap configuration ---
Heap address: 0x0000000080000000, size: 8192 MB, Compressed Oops mode: Zero based
ZGC Heap
 ZHeap           used 2048M, capacity 4096M, max capacity 8192M
 Metaspace       used 256M, committed 268M, reserved 512M

# --- Section 6: Active GC ---
Garbage Collectors:
 ZGC: 1 full collections, 42 minor cycles
 last GC: 2.3s ago, pause: 0.2ms (ZGC is concurrent — very low pause)

# --- Section 7: Thread counts ---
Threads class SMR info:
 _java_thread_list=0x..., length=312, elements={...}
# 312 platform threads

# --- Section 8: JIT compiler ---
Compilation events (1,234 since startup)
Deoptimization events (23 since startup)   ← high count here = JIT instability

# --- Section 9: Internal event log (last N significant events) ---
Events (250 events):
Event: 3601.234 loading class 'com/myapp/ServiceImpl' (1)
Event: 3601.789 Executing VM operation: G1CollectFull
Event: 3602.100 GC heap after
```

### 2.3 Key Things to Look For

```bash
# 1. Verify heap settings match expectations
grep "jvm_args" <(jcmd <pid> VM.info)
# Was -Xmx actually set? Is it what the deploy script intended?

# 2. Check GC collector actually in use
grep "Garbage Collector" <(jcmd <pid> VM.info) -A 2
# Sometimes G1 is running when ZGC was intended (flag was missing)

# 3. Confirm agents are loaded
grep "javaagent" <(jcmd <pid> VM.info)
# Missing agent = missing metrics/tracing = blind monitoring

# 4. Check deoptimization count
grep "Deoptimization" <(jcmd <pid> VM.info)
# High count (>100/minute) = JIT instability, possibly caused by unloaded classes

# 5. Memory pressure
grep "physical" <(jcmd <pid> VM.info)
# If free << total: OS is memory-starved, may be swapping
```

---

## 3. `jcmd VM.flags` — All Active JVM Flags

### 3.1 What It Shows

`VM.flags` shows **every JVM flag that differs from its compiled-in default** — flags set explicitly on the command line, set via management APIs, or ergonomically set by the JVM itself.

```bash
jcmd <pid> VM.flags

# Output:
-XX:CICompilerCount=12                   # JIT compiler thread count (ergonomic)
-XX:ConcGCThreads=3                      # GC concurrent threads (ergonomic)
-XX:GCDrainStackTargetSize=64
-XX:+HeapDumpOnOutOfMemoryError          # explicitly set
-XX:HeapDumpPath=/var/dumps/             # explicitly set
-XX:InitialHeapSize=2147483648           # = -Xms2g (JVM translates to bytes)
-XX:MaxHeapSize=8589934592               # = -Xmx8g
-XX:MaxMetaspaceSize=536870912           # = 512m
-XX:MaxNewSize=5726953472
-XX:MinHeapDeltaBytes=2097152
-XX:NonNMethodCodeHeapSize=5839372
-XX:NonProfiledCodeHeapSize=122909434
-XX:ProfiledCodeHeapSize=122909434
-XX:+UseCompressedClassPointers
-XX:+UseCompressedOops
-XX:+UseZGC                             # explicitly set
```

### 3.2 All Flags Including Defaults

```bash
# -all shows EVERY flag including unchanged defaults (very verbose — hundreds of lines)
jcmd <pid> VM.flags -all | grep -v "= false" | grep -v "= 0$" | head -60
# Filtered: show only non-false, non-zero flags

# Save full set for comparison
jcmd <pid> VM.flags -all > /tmp/flags_before.txt
# After a change:
jcmd <pid> VM.flags -all > /tmp/flags_after.txt
diff /tmp/flags_before.txt /tmp/flags_after.txt
```

### 3.3 Key Flags to Verify After Deploy

```bash
# Memory
grep -E "HeapSize|Metaspace|Direct" <(jcmd <pid> VM.flags)

# GC collector
grep -E "UseG1GC|UseZGC|UseShenandoah|UseParallelGC|UseSerialGC" <(jcmd <pid> VM.flags)

# GC logging (is it actually on?)
grep "Xlog\|PrintGC\|GCLog" <(jcmd <pid> VM.flags)

# OOM safety net
grep "HeapDump" <(jcmd <pid> VM.flags)
# Missing HeapDumpOnOutOfMemoryError = flying blind on OOM

# Compressed oops (important for heap > 32GB)
grep "CompressedOops" <(jcmd <pid> VM.flags)
# If heap > 32GB: CompressedOops is disabled = all object pointers are 8 bytes not 4
# Significant memory overhead. Keep heap < 31GB to retain compressed oops benefit
```

### 3.4 Flag Categories

```bash
# Ergonomic flags (JVM chose them automatically based on hardware)
# These start with {ergonomic} in the -all output
jcmd <pid> VM.flags -all | grep "ergonomic"
# Output:
# -XX:InitialHeapSize=536870912 {ergonomic} [uintx]        ← JVM chose 512m
# -XX:MaxHeapSize=8589934592 {ergonomic} [uintx]           ← JVM chose 8g (1/4 physical RAM)
# -XX:+UseG1GC {ergonomic} [bool]                          ← JVM chose G1

# Command-line set flags
jcmd <pid> VM.flags -all | grep "command line"

# Management API set flags (changed at runtime)
jcmd <pid> VM.flags -all | grep "management"
```

---

## 4. `jcmd VM.system_properties` — System Properties

### 4.1 What It Shows

System properties are key-value pairs set via `-D` flags or `System.setProperty()`. They control framework behavior, feature flags, library configuration, and operational parameters.

```bash
jcmd <pid> VM.system_properties

# Output (selected important entries):
java.version=21.0.1
java.vendor=Eclipse Adoptium
java.home=/usr/lib/jvm/temurin-21-amd64

# Application framework
spring.profiles.active=production
spring.config.location=/etc/myapp/config/
server.port=8080

# Your custom flags
myapp.feature.new-checkout=true        ← feature flags
myapp.cache.ttl=300
myapp.db.pool.size=50

# Networking
http.proxyHost=proxy.internal.com
http.proxyPort=3128
java.net.preferIPv4Stack=true

# File encoding (critical for correctness)
file.encoding=UTF-8
stdout.encoding=UTF-8
stderr.encoding=UTF-8

# Logging
log4j.configuration=file:///etc/myapp/log4j2.xml

# Security
javax.net.ssl.trustStore=/etc/ssl/java/cacerts
javax.net.ssl.trustStoreType=JKS
```

### 4.2 Key Diagnostic Uses

```bash
# Verify active profile (wrong profile = wrong DB, wrong config)
jcmd <pid> VM.system_properties | grep "spring.profiles"

# Confirm feature flags in effect
jcmd <pid> VM.system_properties | grep "myapp.feature"

# Check file encoding (UTF-8 problems are often a system property issue)
jcmd <pid> VM.system_properties | grep "encoding"

# Find proxy configuration (network timeout issues)
jcmd <pid> VM.system_properties | grep -i "proxy"

# Verify trust store (SSL handshake failures)
jcmd <pid> VM.system_properties | grep "trustStore\|keyStore"

# Check temp directory (disk full issues with temp files)
jcmd <pid> VM.system_properties | grep "java.io.tmpdir"

# Full comparison between two instances (config drift check)
jcmd <pid1> VM.system_properties | sort > /tmp/props1.txt
jcmd <pid2> VM.system_properties | sort > /tmp/props2.txt
diff /tmp/props1.txt /tmp/props2.txt
# Diffs = config inconsistency between instances
```

---

## 5. `jinfo` — Inspect and Modify JVM Flags at Runtime

### 5.1 What `jinfo` Does

`jinfo` is the runtime JVM configuration inspector that also supports **live flag modification** without restarting the JVM. Critical for production tuning without downtime.

```bash
# Show all flags (same as jcmd VM.flags but different format)
jinfo -flags <pid>

# Show a specific flag value
jinfo -flag MaxHeapSize <pid>
# Output: -XX:MaxHeapSize=8589934592

# Show all system properties
jinfo -sysprops <pid>

# Show everything (flags + system properties)
jinfo <pid>
```

### 5.2 Runtime Flag Modification — `jinfo -flag`

Some flags are **manageable** — they can be changed at runtime. Others are fixed at JVM startup.

```bash
# Syntax: enable a boolean flag
jinfo -flag +FlagName <pid>

# Syntax: disable a boolean flag
jinfo -flag -FlagName <pid>

# Syntax: set a value flag
jinfo -flag FlagName=value <pid>
```

### 5.3 Manageable Flags — Commonly Used at Runtime

```bash
# 1. Enable GC logging on a running JVM (when you forgot to add it at startup)
#    Note: Java 9+ uses -Xlog; jinfo works for boolean flags only
#    For GC logging, use jcmd instead:
jcmd <pid> VM.log output=/tmp/gc.log what=gc*

# 2. Trigger heap dump for OOM (enable it before OOM happens if not set)
jinfo -flag +HeapDumpOnOutOfMemoryError <pid>
jinfo -flag HeapDumpPath=/var/dumps/ <pid>

# 3. Enable/disable PrintGCDetails (Java 8 style)
jinfo -flag +PrintGCDetails <pid>         # enable
jinfo -flag -PrintGCDetails <pid>         # disable

# 4. Change GC pause target at runtime (G1)
jinfo -flag MaxGCPauseMillis=100 <pid>    # change target pause

# 5. Change heap size (not all flags are settable post-startup)
# MaxHeapSize is NOT manageable — can only be set at startup

# 6. Enable class histogram in GC log
jinfo -flag +PrintClassHistogramAfterFullGC <pid>
jinfo -flag +PrintClassHistogramBeforeFullGC <pid>

# 7. Disable biased locking (sometimes helps with lock contention)
jinfo -flag -UseBiasedLocking <pid>

# 8. Change compilation threshold (make JIT more/less aggressive)
jinfo -flag CompileThreshold=500 <pid>    # recompile after 500 invocations (default 10000)
```

### 5.4 Checking If a Flag Is Manageable

```bash
# -all output shows flag type and manageability
jcmd <pid> VM.flags -all | grep "MaxGCPauseMillis"
# -XX:MaxGCPauseMillis=200 {manageable} [uintx]   ← {manageable} = can change at runtime

jcmd <pid> VM.flags -all | grep "MaxHeapSize"
# -XX:MaxHeapSize=8589934592 {product} [uintx]     ← {product} = NOT manageable at runtime

# Flag categories:
# {product}      — standard production flag, set at startup only
# {manageable}   — can be changed at runtime via jinfo or JMX
# {diagnostic}   — requires -XX:+UnlockDiagnosticVMOptions to use
# {experimental} — requires -XX:+UnlockExperimentalVMOptions to use
# {ergonomic}    — JVM chose this value automatically
```

### 5.5 Unlock Diagnostic and Experimental Flags

Some advanced flags are locked behind unlock flags:

```bash
# Unlock diagnostic flags (needed for some low-level tuning)
-XX:+UnlockDiagnosticVMOptions

# Then at runtime:
jinfo -flag +LogCompilation <pid>          # log JIT compilation decisions
jinfo -flag +PrintAssembly <pid>          # print JIT-generated assembly

# Unlock experimental flags
-XX:+UnlockExperimentalVMOptions

# Then use experimental flags
-XX:+UseEpsilonGC                         # no-op GC for benchmarking
```

---

## 6. `jstat -gcutil` — Live GC Statistics

### 6.1 The Core Command

```bash
# Syntax: jstat -gcutil <pid> <interval_ms> [<count>]
jstat -gcutil <pid> 1000          # every 1 second, run forever (Ctrl+C to stop)
jstat -gcutil <pid> 1000 60       # every 1 second, 60 samples = 1 minute
jstat -gcutil <pid> 500 120       # every 500ms, 120 samples = 1 minute

# Redirect for later analysis
jstat -gcutil <pid> 2000 300 | tee /tmp/gc_stats_$(date +%Y%m%d_%H%M).txt
```

### 6.2 Output Column Reference

```
S0     S1     E      O      M      CCS    YGC    YGCT    FGC    FGCT    CGC    CGCT    GCT
 0.00  85.31  100.0  67.23  96.12  91.45  1842   18.42     2    8.21     0    0.00   26.63

Columns:
S0    — Survivor space 0 utilization (%)      — 0% here = S1 is the active survivor
S1    — Survivor space 1 utilization (%)      — 85.31% = about 85% full
E     — Eden space utilization (%)            — 100.0% = Eden full, GC imminent
O     — Old Gen utilization (%)               — 67.23% = moderate, watch for growth
M     — Metaspace utilization (%)             — 96.12% = near limit, investigate!
CCS   — Compressed Class Space utilization (%)
YGC   — Young GC count (since JVM start)
YGCT  — Young GC total time (seconds)
FGC   — Full GC count (since JVM start)
FGCT  — Full GC total time (seconds)
CGC   — Concurrent GC cycles (G1/ZGC)
CGCT  — Concurrent GC time
GCT   — Grand total GC time (seconds)
```

### 6.3 Interpreting Patterns

```
HEALTHY PATTERN:
S0     S1     E      O      M      YGC   YGCT    FGC   FGCT    GCT
 0.00  15.23  23.45  34.12  75.23  1240  12.40     0    0.00  12.40
→ E fluctuates (allocate-then-GC cycles), O stable, FGC=0, M under 85%

EDEN CHURN (high allocation rate):
 0.00  98.12  100.0  22.14  75.23  4521  45.21     0    0.00  45.21
→ E always near 100%, YGC count very high → high allocation pressure

OLD GEN LEAK:
 0.00  85.31  45.23  99.87  75.23  1842  18.42    45  186.50 204.92
→ O at 99.87%, FGC count high and rising, FGCT large → classic leak

METASPACE PROBLEM:
 0.00  22.14  55.23  44.12  99.87  1240  12.40     2    8.21  20.61
→ M at 99.87% → Metaspace nearly full → classloader leak or too small

ALL GOOD ON ZGC:
# ZGC doesn't use S0/S1/E/O in the same way
# Use: jstat -gc (not gcutil) for ZGC heap details
# Or: -Xlog:gc*:stdout to see ZGC-specific output
```

### 6.4 GC Overhead Calculation

```bash
# Calculate GC overhead percentage from jstat output
# GC overhead = (delta_GCT / elapsed_time) × 100

# Using awk to compute GC overhead from jstat stream
jstat -gc <pid> 1000 | awk '
NR==1 { prev_gct=$17; prev_ts=systime(); next }
{
  curr_gct = $17
  curr_ts = systime()
  delta_gct = curr_gct - prev_gct
  delta_t = curr_ts - prev_ts
  if (delta_t > 0) {
    overhead = (delta_gct / delta_t) * 100
    printf "GC overhead: %.2f%%  (Old: %.1f%%)\n", overhead, $8/($7+0.001)*100
  }
  prev_gct = curr_gct; prev_ts = curr_ts
}'
# > 10% GC overhead = GC is taking significant time
# > 50% GC overhead = "GC thrashing" — process mostly doing GC
```

### 6.5 Other `jstat` Variants

```bash
jstat -gc <pid> 1000           # raw KB values (not %)
# S0C S1C S0U S1U  EC   EU   OC   OU  MC   MU  CCSC CCSU   YGC YGCT FGC FGCT CGC CGCT  GCT
# (C = Capacity, U = Used, all in KB)

jstat -gccapacity <pid>        # min/max/current for all spaces
jstat -gcnew <pid> 1000        # young gen details only
jstat -gcold <pid> 1000        # old gen details only
jstat -gcmetacapacity <pid>    # metaspace capacity breakdown

jstat -class <pid> 1000        # class loading stats
# Loaded  Bytes  Unloaded  Bytes     Time
#  15234  28456.7      34   68.2    3.456
# If Loaded grows but Unloaded doesn't: classloader leak

jstat -compiler <pid> 1000     # JIT compilation
# Compiled Failed Invalid  Time   FailedType FailedMethod
#    12345      2       0  34.23           1 com/myapp/Foo foo
```

---

## 7. Arthas — Production Diagnostics Without Restart

### 7.1 What Arthas Is

Arthas (阿尔萨斯) is Alibaba's open-source Java diagnostic tool. It attaches to a running JVM and provides **live code-level diagnostics** that no other free tool offers:
- Watch method arguments, return values, exceptions — without modifying code
- Trace method execution time — pinpoint exactly which line is slow
- Monitor method call rate and error rate
- Decompile a running class to see the exact bytecode being executed
- Search class hierarchy, fields, method signatures

**Safety**: Arthas uses Java Instrument API (bytecode instrumentation). It is designed for production but should be used with care — aggressive tracing adds overhead.

### 7.2 Installation and Attachment

```bash
# Download and run (auto-attaches to selected JVM)
curl -O https://arthas.aliyun.com/arthas-boot.jar
java -jar arthas-boot.jar       # lists Java processes, select one

# Or: attach to specific PID directly
java -jar arthas-boot.jar <pid>

# Or: one-liner
curl -L https://arthas.aliyun.com/install.sh | sh
./as.sh <pid>

# Arthas starts and shows the prompt:
# [arthas@12345]$
```

### 7.3 `dashboard` — Real-Time JVM Overview

The first command to run on any incident. Shows live metrics across threads, memory, GC, and system:

```
[arthas@12345]$ dashboard

ID    NAME                      GROUP          PRIORITY  STATE      %CPU   DELTA_TIME  TIME        INTERRUPTED  DAEMON
10    http-nio-8080-exec-1      main           5         RUNNABLE   45.23  0.015s      0:12:34     false        true
11    http-nio-8080-exec-2      main           5         BLOCKED    0.00   0.000s      0:00:01     false        true
...

Memory                          used        total      max         usage
heap                            2048M       4096M      8192M       25.0%
├── ZHeap                       2048M       4096M      8192M       25.0%
│   └── ...
nonheap                          256M        268M       512M       50.0%
├── Metaspace                    248M        260M       512M       48.4%
└── CodeCache                      8M          8M       240M        3.3%

GC                                   GC Time          GC Count
└── ZGC                              0.234s           42

Runtime
os.name                              Linux
os.arch                              amd64
jvm.version                          21.0.1+12
```

```
# dashboard refreshes every 5 seconds by default
# -i: interval in ms, -n: number of iterations
[arthas@12345]$ dashboard -i 2000 -n 10    # refresh every 2s, 10 times
```

### 7.4 `watch` — Observe Method Arguments, Return Values, Exceptions

`watch` intercepts method calls and prints arguments, return values, or exceptions **in real time** without modifying code or restarting.

```bash
# Syntax: watch <class> <method> <expression> [condition]
# Expression uses OGNL — an expression language operating on method context:
#   {params}    — array of all parameters
#   {returnObj} — return value
#   {throwExp}  — thrown exception
#   {target}    — the object (`this`) the method was called on
#   {clazz}     — the class

# Watch UserService.findUser — show args and return value
[arthas@12345]$ watch com.myapp.UserService findUser "{params, returnObj}" -x 2
# Output when findUser(42L) is called:
method=com.myapp.UserService.findUser location=AtExit
ts=2024-01-15 10:23:41; [cost=23.45ms] result=@ArrayList[
  @Object[][                          ← params: [42L]
    @Long[42],
  ],
  @User[                              ← returnObj: the User returned
    id=@Long[42],
    name=@String[Alice],
    email=@String[alice@example.com],
  ],
]

# Watch for exceptions only (don't show successful calls)
[arthas@12345]$ watch com.myapp.UserService findUser "{params, throwExp}" -e
# -e = only trigger on exception

# Watch with condition (only trigger if first param is null)
[arthas@12345]$ watch com.myapp.Service process "{params}" "params[0] == null"

# Watch and show execution time
[arthas@12345]$ watch com.myapp.OrderService placeOrder "{params, returnObj, cost}" -x 3
# cost = execution time in ms

# Limit to N invocations then stop
[arthas@12345]$ watch com.myapp.Service process "{params}" -n 5
```

### 7.5 `trace` — Method Execution Timing Tree

`trace` instruments a method and shows a **call tree with timing** for every invocation. The most powerful tool for finding which line of code is slow.

```bash
# Trace OrderService.placeOrder — shows all child calls with timing
[arthas@12345]$ trace com.myapp.OrderService placeOrder

# Output when placeOrder() is called:
`---ts=2024-01-15 10:23:41;thread_name=http-exec-5;id=0xa;is_daemon=true;
    `---[234.56ms] com.myapp.OrderService:placeOrder()
        +---[0.12ms] com.myapp.UserService:validateUser()
        +---[2.34ms] com.myapp.InventoryService:checkStock()
        +---[230.45ms] com.myapp.PaymentService:charge()   ← 98% of time here!
        |   +---[0.89ms] com.stripe.StripeClient:createCharge()... wait no:
        |   `---[229.12ms] java.net.SocketInputStream:read()  ← blocking on network!
        `---[1.65ms] com.myapp.OrderRepository:save()

# Trace with threshold (only show calls taking > 100ms)
[arthas@12345]$ trace com.myapp.OrderService placeOrder '#cost > 100'

# Trace multiple methods at once
[arthas@12345]$ trace com.myapp.*Service *

# Trace with call depth limit
[arthas@12345]$ trace com.myapp.OrderService placeOrder --depth 3

# Skip JDK internal frames
[arthas@12345]$ trace com.myapp.OrderService placeOrder --skipJDKMethod true
```

### 7.6 `monitor` — Method Call Rate and Error Rate

`monitor` shows aggregate statistics over a time window: calls/sec, success rate, average time, 95th percentile time.

```bash
# Monitor UserService.findUser every 5 seconds
[arthas@12345]$ monitor com.myapp.UserService findUser -c 5

# Output every 5 seconds:
timestamp            class                  method     total   success  fail   avg      fail-rate
2024-01-15 10:23:45  com.myapp.UserService  findUser     127      125     2    23.4ms    1.57%
2024-01-15 10:23:50  com.myapp.UserService  findUser     134      134     0    18.2ms    0.00%
2024-01-15 10:23:55  com.myapp.UserService  findUser      98       91     7    45.6ms    7.14%   ← spike!

# Monitor all methods in a class
[arthas@12345]$ monitor com.myapp.OrderService * -c 5

# Monitor with cycle count (run for 10 cycles then stop)
[arthas@12345]$ monitor com.myapp.UserService findUser -c 5 -n 10
```

### 7.7 `stack` — Who Called This Method

`stack` shows the call stack at the moment a method is invoked — tells you WHO is calling a method without modifying code.

```bash
# Find who calls UserService.findUser
[arthas@12345]$ stack com.myapp.UserService findUser

# Output:
ts=2024-01-15 10:23:41;thread_name=http-exec-5
`---thread_name=http-exec-5;id=0x1a;is_daemon=true
    `---[23.45ms] com.myapp.UserService:findUser()
        at com.myapp.OrderController.placeOrder(OrderController.java:87)  ← caller
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1089)
        at ...

# With condition: only show stack when param equals specific value
[arthas@12345]$ stack com.myapp.UserService findUser 'params[0] == 42'
```

### 7.8 `tt` — Time Tunnel (Record and Replay)

`tt` records method invocations and lets you inspect them later or even replay them:

```bash
# Record 100 invocations of placeOrder
[arthas@12345]$ tt -t com.myapp.OrderService placeOrder -n 100

# List recorded invocations
[arthas@12345]$ tt -l
# INDEX  TIMESTAMP            COST     IS-RET  IS-EXP  OBJECT      CLASS                   METHOD
# 1000   2024-01-15 10:23:41  234.56ms  true    false   0x7f80a1    com.myapp.OrderService  placeOrder
# 1001   2024-01-15 10:23:42  1234.5ms  false   true    0x7f80a1    com.myapp.OrderService  placeOrder
#                              ↑ slow                    ↑ threw!

# Inspect a specific invocation (index 1001 — the one that threw)
[arthas@12345]$ tt -i 1001
# Shows: all params, thrown exception, return value

# Replay invocation 1001 (re-run the method with same args)
[arthas@12345]$ tt -i 1001 -p
# Useful: replay a failing invocation to diagnose intermittent bugs
```

### 7.9 `jad` — Decompile Running Class

Sometimes you need to confirm which version of a class is actually loaded in the JVM:

```bash
# Decompile the running bytecode of UserService
[arthas@12345]$ jad com.myapp.UserService

# Decompile specific method only
[arthas@12345]$ jad com.myapp.UserService findUser

# Output: decompiled Java source of the currently loaded class
# This tells you: what version is actually running (not what's in the JAR)
# Useful when: multiple JARs might provide the same class (classloading conflict)
```

### 7.10 Other Useful Arthas Commands

```bash
# Thread analysis
[arthas@12345]$ thread             # top CPU-consuming threads
[arthas@12345]$ thread -n 5       # top 5 CPU threads
[arthas@12345]$ thread -b         # show blocked threads and their blockers
[arthas@12345]$ thread <id>       # show specific thread's stack

# Class/classloader info
[arthas@12345]$ sc com.myapp.*    # search loaded classes matching pattern
[arthas@12345]$ sm com.myapp.UserService  # search methods of class
[arthas@12345]$ classloader       # show classloader hierarchy and stats

# Memory/GC
[arthas@12345]$ memory            # memory pools summary (same as dashboard memory section)
[arthas@12345]$ heapdump /tmp/heap.hprof    # take heap dump

# JVM info
[arthas@12345]$ sysprop           # system properties
[arthas@12345]$ sysenv            # environment variables
[arthas@12345]$ version           # JVM version
[arthas@12345]$ ognl '@System@currentTimeMillis()'    # execute any Java/OGNL expression

# Profiling (async-profiler integration)
[arthas@12345]$ profiler start    # start CPU profiling
[arthas@12345]$ profiler getSamples    # check sample count
[arthas@12345]$ profiler stop --format html --file /tmp/flamegraph.html
```

---

## 8. Common OOM Patterns — All Four Types

Every `OutOfMemoryError` message tells you exactly which memory region failed. Understanding the four regions and their leak patterns is essential.

### 8.1 OOM Pattern 1 — Heap: `Java heap space`

**Error:**
```
java.lang.OutOfMemoryError: Java heap space
    at java.util.Arrays.copyOf(Arrays.java:3512)
    at java.util.ArrayList.grow(ArrayList.java:265)
    at com.myapp.SessionStore.addSession(SessionStore.java:42)
```

**What it means:** The Java heap (young + old gen) is exhausted. Either a memory leak or the heap is genuinely too small for the application's live data set.

**Diagnosis:**
```bash
# Step 1: Check heap utilization over time
jstat -gcutil <pid> 5000 12
# O column growing and never recovering after Full GC = leak

# Step 2: Quick histogram (what's using the memory)
jmap -histo:live <pid> | head -30

# Step 3: Heap dump + MAT analysis
jcmd <pid> GC.heap_dump /tmp/heap.hprof
# Open in Eclipse MAT → Leak Suspects Report

# Step 4: Find GC roots path to the biggest object cluster
# MAT → Dominator Tree → Path to GC Roots
```

**Common causes:**
```java
// CAUSE 1 — Static collection growing forever
private static final Map<String, Session> SESSIONS = new HashMap<>();
// sessions added but never expired/removed

// CAUSE 2 — Unbounded cache
// Cache without eviction policy
private static final Map<Key, Value> CACHE = new ConcurrentHashMap<>();

// CAUSE 3 — Event listener accumulation
eventBus.subscribe(handler); // but never unsubscribe → handler holds GC root

// CAUSE 4 — String interning of dynamic values
String key = userId.toString().intern(); // grows String pool forever

// CAUSE 5 — Large object graph (LazyInitializationException workaround)
// Fetching entire entity graphs from ORM
List<Order> orders = em.createQuery("FROM Order o JOIN FETCH o.items").getResultList();
// Loads all orders + all items + all products into heap
```

**Fix signals in heap dump:**
```
MAT Dominator Tree top entry owns > 50% of heap
→ Path to GC Roots shows: static field → HashMap → millions of entries
→ Fix: add eviction (Caffeine), size limit, or TTL
```

---

### 8.2 OOM Pattern 2 — Metaspace: `Metaspace`

**Error:**
```
java.lang.OutOfMemoryError: Metaspace
    at java.lang.ClassLoader.defineClass1(Native Method)
    at java.lang.ClassLoader.defineClass(ClassLoader.java:756)
    at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:142)
    at com.myapp.DynamicCodeGenerator.generate(DynamicCodeGenerator.java:87)
```

**What it means:** Native memory for class metadata is exhausted. Classes are being loaded faster than they're being unloaded — classic classloader leak.

**Diagnosis:**
```bash
# Step 1: Monitor Metaspace utilization
jstat -gcutil <pid> 5000
# M column at 98-99% and growing = Metaspace OOM imminent

# Step 2: Count loaded classes over time
jstat -class <pid> 5000 12
# Loaded column growing, Unloaded barely moving = leak
# OUTPUT:
# Loaded  Bytes       Unloaded  Bytes       Time
#  15234  28456.7K        34   68.2K      3.456
#  16891  31234.5K        34   68.2K      4.123   ← 1657 more classes, still only 34 unloaded!
#  18504  34056.2K        34   68.2K      4.890   ← another 1613 classes loaded, none unloaded!

# Step 3: Find classloader count in heap
# In MAT or jmap:
jmap -histo <pid> | grep ClassLoader | sort -k3 -n -r | head -10
# High count of ClassLoader instances = leak

# Step 4: JFR class loading events
jcmd <pid> JFR.start duration=60s filename=/tmp/meta.jfr
# JMC → Class Loading → find repeated class loads of same class
```

**Common causes:**
```java
// CAUSE 1 — JDBC driver not deregistered on webapp reload
// Each deploy: new ClassLoader loads the driver → old ClassLoader can't be GC'd
// Fix: deregister in ServletContextListener.contextDestroyed()

// CAUSE 2 — Groovy/BeanShell script creating ClassLoader per execution
for (String script : dynamicScripts) {
    GroovyShell shell = new GroovyShell(); // new ClassLoader per script!
    shell.evaluate(script);
    // ClassLoader leaked → its classes stay in Metaspace
}
// Fix: reuse GroovyShell, clear class cache periodically

// CAUSE 3 — Dynamic proxy generation without ClassLoader management
// cglib, ByteBuddy, Spring AOP creating anonymous proxy classes
// In frameworks: ensure proxy class caching is enabled

// CAUSE 4 — OSGi/application server bundle with class leak
// Framework loads bundle → bundle ClassLoader held by framework registry
// Fix: ensure framework cleanup hooks are called on undeploy

// CAUSE 5 — Groovy MetaClass registry
// Groovy registers metaclasses globally; clearing them releases metaspace
GroovySystem.getMetaClassRegistry().removeMetaClass(SomeClass.class);
```

**Metaspace settings:**
```bash
# Increase limit (band-aid — fix the leak!)
-XX:MaxMetaspaceSize=512m

# Earlier GC trigger for Metaspace (default: triggers at first limit hit)
-XX:MetaspaceSize=256m          # trigger concurrent marking when metaspace hits 256m

# More aggressive Metaspace reclamation
-XX:MinMetaspaceFreeRatio=20    # GC if < 20% free (default: 40%)
-XX:MaxMetaspaceFreeRatio=70    # shrink if > 70% free (reclaim native memory)
```

---

### 8.3 OOM Pattern 3 — Direct Buffer: `Direct buffer memory`

**Error:**
```
java.lang.OutOfMemoryError: Direct buffer memory
    at java.nio.Bits.reserveMemory(Bits.java:175)
    at java.nio.DirectByteBuffer.<init>(DirectByteBuffer.java:118)
    at java.nio.ByteBuffer.allocateDirect(ByteBuffer.java:318)
    at io.netty.buffer.UnpooledByteBufAllocator.newDirectBuffer(UnpooledByteBufAllocator.java:72)
```

**What it means:** Off-heap direct memory (allocated via `ByteBuffer.allocateDirect()` or native memory) is exhausted. The heap is fine but native memory is full.

**Key difference from heap OOM:** Direct memory is **not** managed by the GC in the same way. It's freed when the `DirectByteBuffer` Java object is GC'd AND `Cleaner` runs, or when `System.gc()` is called.

**Diagnosis:**
```bash
# Step 1: Check direct memory usage
# Native Memory Tracking (requires startup flag)
-XX:NativeMemoryTracking=summary    # or =detail

jcmd <pid> VM.native_memory summary
# Output:
# Native Memory Tracking:
# Total: reserved=8143MB, committed=4028MB
# -              Java Heap (reserved=8192MB, committed=4096MB)
# -          Class (reserved=1056MB, committed=44MB)
# -         Thread (reserved=60MB, committed=60MB)
# -           Code (reserved=240MB, committed=12MB)
# -            GC (reserved=310MB, committed=310MB)
# -  Internal (reserved=12MB, committed=12MB)
# -    Other (reserved=10002MB, committed=10002MB)   ← huge "Other" = direct memory!

# Step 2: Check direct memory limit
jcmd <pid> VM.flags | grep "MaxDirectMemorySize"
# Not set = defaults to max heap size (-Xmx value)

# Step 3: Count DirectByteBuffer instances
jmap -histo:live <pid> | grep "DirectByteBuffer"
#  1:     500000       12000000  java.nio.DirectByteBuffer   ← 500K instances!
# vs healthy:
#  1:         50        1200     java.nio.DirectByteBuffer
```

**Common causes:**
```java
// CAUSE 1 — Netty buffer not released
// Netty buffers are reference-counted; forgetting to release = leak
ByteBuf buf = ctx.alloc().directBuffer(1024);
try {
    buf.writeBytes(data);
    channel.writeAndFlush(buf); // WRONG: flush takes ownership but you didn't retain
} finally {
    // buf.release(); ← should be called if you didn't flush
}
// Fix: always balance retain/release; use ReferenceCountUtil.release()

// CAUSE 2 — Pooled allocator misconfiguration (Netty)
// Netty uses pooled direct buffers by default
// If pool chunks aren't reclaimed: OOM
// Fix: check netty allocator stats
// io.netty.buffer.PooledByteBufAllocator.DEFAULT.metric().numDirectArenas()

// CAUSE 3 — FileChannel / SocketChannel without explicit close
FileChannel channel = FileChannel.open(path);
// ... use channel ...
// channel.close() never called → internal DirectByteBuffer not freed

// CAUSE 4 — Direct buffer with no GC pressure (GC never runs to free Cleaners)
// Heap is small → GC runs often → Cleaners run → direct memory freed
// Heap is large → GC rare → Cleaners don't run → direct memory accumulates
// Fix:
System.gc();  // explicitly trigger GC to run Cleaners (use sparingly)
// OR: increase MaxDirectMemorySize
// OR: reduce heap size to trigger more frequent GC (counterintuitive!)
```

**Fixes:**
```bash
# Fix 1: Increase direct memory limit
-XX:MaxDirectMemorySize=4g     # allow up to 4GB direct memory

# Fix 2: Force GC to run Cleaners (emergency only)
jcmd <pid> GC.run             # manually trigger GC

# Fix 3: Arthas watch to find leak source
[arthas@12345]$ watch java.nio.ByteBuffer allocateDirect "{params, new java.lang.Exception().getStackTrace()}" -x 3
# Shows stack trace for every direct buffer allocation
```

---

### 8.4 OOM Pattern 4 — Stack: Two Variants

**Error Variant A — Deep Recursion:**
```
java.lang.StackOverflowError
    at com.myapp.RecursiveProcessor.process(RecursiveProcessor.java:42)
    at com.myapp.RecursiveProcessor.process(RecursiveProcessor.java:47)
    at com.myapp.RecursiveProcessor.process(RecursiveProcessor.java:47)
    at com.myapp.RecursiveProcessor.process(RecursiveProcessor.java:47)
    ... 500 more lines of the same frame ...
```

**Error Variant B — Thread Explosion:**
```
java.lang.OutOfMemoryError: unable to create native thread: possibly out of memory or process/resource limits reached
    at java.lang.Thread.start0(Native Method)
    at java.lang.Thread.start(Thread.java:1525)
    at com.myapp.RequestHandler.handle(RequestHandler.java:78)
```

**Diagnosis — StackOverflowError:**
```java
// Deep recursion — typically > 500-1000 frames depending on stack frame size
// In thread dump: same frame repeated hundreds of times
// Check: is this supposed to be recursive? Is there a base case?

// CAUSE 1 — Infinite mutual recursion
class A { void foo() { new B().bar(); } }
class B { void bar() { new A().foo(); } } // A calls B calls A calls B...

// CAUSE 2 — toString() triggering serialization loop
@Entity
class Order {
    List<Item> items;
    @Override
    public String toString() {
        return "Order{items=" + items + "}"; // calls Item.toString()
    }
}
@Entity
class Item {
    Order order; // back-reference
    @Override
    public String toString() {
        return "Item{order=" + order + "}"; // calls Order.toString() → INFINITE LOOP
    }
}

// CAUSE 3 — Infinite loop in recursive data structure traversal
// Linked list with cycle: node.next = node (circular reference)
```

**Diagnosis — Thread Explosion OOM:**
```bash
# Count current threads
cat /proc/<pid>/status | grep Threads
# Threads:	32768

# System thread limit
cat /proc/sys/kernel/threads-max
# 32768    ← at the limit!

# Per-user thread limit
ulimit -u
# 4096

# Find which code creates threads
# In thread dump: look for threads with same name pattern
grep "^\"" thread_dump.txt | sed 's/ #.*//' | sort | uniq -c | sort -rn | head -10
```

**Fixes:**
```bash
# Fix StackOverflowError: increase thread stack size (careful — more memory per thread)
-Xss2m    # increase stack from default 512k to 2MB
-Xss512k  # decrease if you have many threads and don't need deep stacks

# Fix Thread OOM: convert to virtual threads (Java 21+)
# Old: new Thread(task).start() per request
# New: Thread.ofVirtual().start(task) — millions possible, no stack-per-thread issue
# Or: use bounded ExecutorService
ExecutorService pool = Executors.newFixedThreadPool(200); // max 200 threads

# Increase OS thread limit (emergency)
echo 65536 > /proc/sys/kernel/threads-max     # temporary, not persistent
# Persistent: edit /etc/sysctl.conf
# kernel.threads-max = 65536
```

---

## 9. On-Call Checklist — Structured Incident Response

### 9.1 The Decision Tree

```
INCIDENT REPORTED
       │
       ▼
Is the JVM still alive?
  NO → check -XX:+HeapDumpOnOutOfMemoryError dump,
       check GC logs for last entries before crash
  YES → continue ↓
       │
       ▼
Is it responding to requests?
  NO (timeout/hang) → Thread dump (→ deadlock? all-blocked?)
  SLOW (high latency) → jstat + JFR → GC or thread contention?
  CRASHING (OOM) → jmap -histo + heap dump + GC logs
       │
       ▼
Is GC the cause? (jstat -gcutil)
  O near 100% / FGC high → memory leak → heap dump → MAT
  O stable, long pauses → switch to ZGC or tune G1
  M near 100% → classloader leak → jstat -class
  No GC issue → thread/code issue
       │
       ▼
Is it a code/logic issue? (Thread dump)
  Many BLOCKED → lock contention → find hot lock address
  Deadlock → jstack finds it automatically
  CPU 100% → top -H + jstack nid → Arthas trace
  Thread count growing → thread leak
```

### 9.2 Step 1 — GC Log Triage

```bash
# Check most recent GC log entries (last 50 lines)
tail -50 /var/log/app/gc.log

# Find Full GC events (should be rare)
grep "Pause Full" /var/log/app/gc.log | tail -20
# Many Full GCs recently = Old gen problem

# Find longest pauses
grep "Pause" /var/log/app/gc.log | \
    awk '{print $NF, $0}' | sort -n | tail -10
# Sort by pause duration — top 10 longest

# Check if OOM occurred
grep -i "OutOfMemory\|OOM" /var/log/app/gc.log

# Check allocation failure pattern
grep "Allocation Failure" /var/log/app/gc.log | wc -l
# Frequent = high allocation pressure

# Get GC overhead estimate
grep "Pause" /var/log/app/gc.log | tail -1000 | \
    awk '{sum += $(NF)} END {print "Total pause time (last 1000 GCs): " sum "ms"}'
```

### 9.3 Step 2 — Thread Dump

```bash
# Capture three thread dumps 15s apart
for i in 1 2 3; do
    echo "=== DUMP $i $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" >> /tmp/incident_threads.txt
    jcmd <pid> Thread.dump_to_file -format=plain /dev/stdout >> /tmp/incident_threads.txt 2>&1
    [ $i -lt 3 ] && sleep 15
done

# Quick triage on combined dump
# 1. Check for deadlocks
grep "Found.*deadlock" /tmp/incident_threads.txt

# 2. Count thread states
grep "java.lang.Thread.State" /tmp/incident_threads.txt | sort | uniq -c | sort -rn

# 3. Find hot lock (most contended)
grep "waiting to lock" /tmp/incident_threads.txt | \
    grep -oP '<0x[0-9a-f]+>' | sort | uniq -c | sort -rn | head -5

# 4. Correlate high-CPU thread (from top -H)
printf '%x\n' <tid_from_top>  # convert to hex
grep "nid=0x<hex>" /tmp/incident_threads.txt -A 20
```

### 9.4 Step 3 — Heap Dump (If Memory Suspected)

```bash
# Only take heap dump if memory is the suspected issue
# (Dump = ~= heap size in disk space + time to write + JVM pauses during write)

# Option A: jcmd (preferred)
jcmd <pid> GC.heap_dump /var/dumps/incident_$(date +%Y%m%d_%H%M%S).hprof

# Option B: jmap
jmap -dump:format=b,file=/var/dumps/incident.hprof <pid>

# Quick triage without full dump
jmap -histo:live <pid> | head -30 > /tmp/histo.txt
# Look for unexpected high-instance-count classes

# Compare to baseline (if you have one)
diff /tmp/histo_baseline.txt /tmp/histo.txt | grep "^>" | sort -k3 -n -r | head -20
```

### 9.5 Step 4 — JFR Recording (Ongoing or Triggered)

```bash
# If JFR was running (always-on recommended):
jcmd <pid> JFR.dump filename=/var/dumps/incident_$(date +%Y%m%d_%H%M).jfr

# If JFR was NOT running (start now for ongoing issue):
jcmd <pid> JFR.start duration=300s settings=profile filename=/var/dumps/incident.jfr
echo "JFR recording started — wait 5 minutes..."
# (JFR runs in background, auto-saves after 300s)

# What JFR tells you that nothing else can:
# - Exactly which methods are consuming CPU (flame graph)
# - Which code paths are allocating the most objects
# - Which locks are most contended (and for how long)
# - I/O latency breakdown (file vs network)
# - Safepoint pause breakdown
```

### 9.6 Quick Diagnostic Script — Run at Start of Every Incident

```bash
#!/bin/bash
# incident_diag.sh — run at start of every production JVM incident
# Usage: ./incident_diag.sh <pid>

PID=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="/var/dumps/incident_${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"

echo "[$(date)] Starting incident diagnostics for PID $PID"

# 1. JVM configuration snapshot
echo "[$(date)] Capturing JVM config..."
jcmd $PID VM.info    > "$OUTPUT_DIR/vm_info.txt"    2>&1
jcmd $PID VM.flags   > "$OUTPUT_DIR/vm_flags.txt"   2>&1
jcmd $PID VM.system_properties > "$OUTPUT_DIR/vm_sysprops.txt" 2>&1

# 2. GC stats snapshot (30 seconds of data)
echo "[$(date)] Capturing GC stats (30s)..."
jstat -gcutil $PID 2000 15 > "$OUTPUT_DIR/gc_stats.txt" 2>&1 &
JSTAT_PID=$!

# 3. Three thread dumps
echo "[$(date)] Capturing thread dumps..."
for i in 1 2 3; do
    echo "=== DUMP $i $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" >> "$OUTPUT_DIR/thread_dumps.txt"
    jcmd $PID Thread.dump_to_file /dev/stdout >> "$OUTPUT_DIR/thread_dumps.txt" 2>&1
    [ $i -lt 3 ] && sleep 15
done

# 4. Object histogram
echo "[$(date)] Capturing object histogram..."
jmap -histo:live $PID > "$OUTPUT_DIR/object_histo.txt" 2>&1

# Wait for jstat
wait $JSTAT_PID

# 5. Quick analysis summary
echo "[$(date)] Quick analysis:"
echo "Deadlocks:"
grep "Found.*deadlock" "$OUTPUT_DIR/thread_dumps.txt" || echo "  None detected"

echo "Thread states:"
grep "java.lang.Thread.State" "$OUTPUT_DIR/thread_dumps.txt" | sort | uniq -c | sort -rn

echo "Top 5 contended locks:"
grep "waiting to lock" "$OUTPUT_DIR/thread_dumps.txt" | \
    grep -oP '<0x[0-9a-f]+>' | sort | uniq -c | sort -rn | head -5

echo "GC summary (from jstat):"
tail -3 "$OUTPUT_DIR/gc_stats.txt"

echo "Top 10 object classes by instance count:"
head -12 "$OUTPUT_DIR/object_histo.txt"

echo "[$(date)] Diagnostics saved to $OUTPUT_DIR"
echo "Next steps:"
echo "  If GC issue: open gc_stats.txt, check O/M columns"
echo "  If thread issue: open thread_dumps.txt, look for BLOCKED pattern"
echo "  If memory issue: jcmd $PID GC.heap_dump $OUTPUT_DIR/heap.hprof"
echo "  For deep analysis: jcmd $PID JFR.start duration=300s filename=$OUTPUT_DIR/recording.jfr"
```

### 9.7 Post-Incident Checklist

After resolving an incident, ensure these are in place before closing:

```
□ GC logging enabled with rotation:
  -Xlog:gc*:file=/var/log/gc.log:time,uptime:filecount=10,filesize=50m

□ OOM dump enabled:
  -XX:+HeapDumpOnOutOfMemoryError
  -XX:HeapDumpPath=/var/dumps/

□ JFR always-on circular buffer:
  -XX:StartFlightRecording=maxsize=250m,dumponexit=true,filename=/var/dumps/exit.jfr

□ Process restart on OOM:
  -XX:OnOutOfMemoryError="systemctl restart myapp"
  # Or use container restartPolicy

□ Monitoring alert thresholds set:
  - GC pause > 1s → alert
  - Old gen > 80% → warning
  - Old gen > 95% → alert
  - Metaspace > 85% → warning
  - Thread count > 1000 → warning

□ Heap dump directory has sufficient disk space:
  df -h /var/dumps
  # Needs: 2 × heap size free space (for heap dump + analysis copy)

□ Root cause documented with fix applied
□ Regression test added (if code change)
```

---

## 10. Quick Reference Cheat Sheet

### Diagnostic Commands at a Glance

```bash
# JVM configuration
jcmd <pid> VM.info                          # full config: JVM args, heap, GC, OS
jcmd <pid> VM.flags                         # all non-default flags
jcmd <pid> VM.flags -all | grep "manageable" # flags changeable at runtime
jcmd <pid> VM.system_properties             # -D system properties
jinfo -flag FlagName <pid>                  # get specific flag value
jinfo -flag +FlagName <pid>                 # enable boolean flag at runtime
jinfo -flag FlagName=value <pid>            # set value flag at runtime

# GC monitoring
jstat -gcutil <pid> 1000                    # % utilization, every 1s
jstat -gc <pid> 1000                        # raw KB sizes, every 1s
jstat -class <pid> 5000                     # class loading: Loaded vs Unloaded

# Arthas quick commands
dashboard                                    # live JVM overview
thread -n 5                                 # top 5 CPU threads
thread -b                                   # blocked threads + their blockers
trace com.myapp.Service method              # call tree with timings
watch com.myapp.Service method "{params,returnObj,cost}" -x 2
monitor com.myapp.Service method -c 5       # call rate + error rate + avg time
stack com.myapp.Service method              # who called this method?
jad com.myapp.Service                       # decompile currently loaded class
heapdump /tmp/heap.hprof                    # take heap dump from Arthas
profiler start && sleep 60 && profiler stop --format html --file /tmp/flame.html
```

### OOM Quick Identification

| Error Message | Region | Root Cause | First Step |
|---|---|---|---|
| `Java heap space` | Heap | Object leak or heap too small | `jmap -histo:live` |
| `GC overhead limit exceeded` | Heap | OOM disguised as GC thrashing | Heap dump + MAT |
| `Metaspace` | Metaspace | ClassLoader leak | `jstat -class` over time |
| `Direct buffer memory` | Native | NIO/Netty buffer leak | `jcmd VM.native_memory` |
| `unable to create native thread` | Native / OS | Thread explosion or OS limit | Thread dump count |
| `StackOverflowError` | Stack | Infinite recursion | Stack trace in exception |

### On-Call Priority Order

```
1. GC logs → Are we in GC thrashing? OOM occurred?
2. jstat -gcutil → Is memory pressure happening NOW?
3. Thread dump → Deadlock? Contention? Thread leak?
4. Arthas dashboard → Quick overview without restart
5. Arthas trace → Find which method is slow
6. jmap -histo → What objects are consuming memory?
7. Heap dump → Full memory analysis (last resort — large overhead)
8. JFR dump → Profile recording if started earlier
```

### Key Flags for Every Production JVM

```bash
# MUST HAVE
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/var/dumps/
-Xlog:gc*:file=/var/log/gc.log:time,uptime:filecount=10,filesize=50m
-XX:StartFlightRecording=maxsize=250m,dumponexit=true

# STRONGLY RECOMMENDED
-XX:OnOutOfMemoryError="systemctl restart myapp"
-XX:+UseZGC                              # Java 15+ low-latency
-XX:NativeMemoryTracking=summary         # for direct memory OOM diagnosis
-XX:MetaspaceSize=256m                   # explicit Metaspace trigger point
-XX:MaxMetaspaceSize=512m                # prevent unbounded growth
```

---

*End of JVM Production Troubleshooting Toolkit Study Guide*
