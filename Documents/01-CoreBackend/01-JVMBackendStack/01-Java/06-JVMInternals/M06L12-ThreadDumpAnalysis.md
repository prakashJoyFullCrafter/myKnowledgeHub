# Thread Dump Analysis & Virtual Threads — Complete Study Guide

> **Brutally Detailed Reference**
> Covers capturing thread dumps, reading every field in a thread dump, deadlock detection, thread contention diagnosis, thread leak detection, online analysis tools, and virtual threads with safepoint mechanics in Java 21+. Every section includes real thread dump output and diagnostic commands.

---

## Table of Contents

1. [What Is a Thread Dump and When to Use One](#1-what-is-a-thread-dump-and-when-to-use-one)
2. [Capturing Thread Dumps](#2-capturing-thread-dumps)
3. [Anatomy of a Thread Dump — Reading Every Field](#3-anatomy-of-a-thread-dump--reading-every-field)
4. [Thread States — Complete Reference](#4-thread-states--complete-reference)
5. [Lock Ownership and Waiting-On](#5-lock-ownership-and-waiting-on)
6. [Deadlock Detection](#6-deadlock-detection)
7. [Diagnosing Thread Contention](#7-diagnosing-thread-contention)
8. [Diagnosing Thread Leaks](#8-diagnosing-thread-leaks)
9. [Analysis Tools — fastthread.io and IntelliJ](#9-analysis-tools--fastthreadio-and-intellij)
10. [Virtual Threads and Safepoints (Java 21+)](#10-virtual-threads-and-safepoints-java-21)
11. [Production Runbook — Thread Dump Workflow](#11-production-runbook--thread-dump-workflow)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. What Is a Thread Dump and When to Use One

### 1.1 What a Thread Dump Contains

A thread dump is a **snapshot of every thread in the JVM at a single point in time**. For each thread it shows:
- Thread name, ID, state
- Full stack trace (what code it is executing)
- Locks it holds
- Locks it is waiting to acquire
- Monitor and synchronizer state

Thread dumps answer these questions:
- Why is the application hanging / not responding?
- Why is CPU at 100% but nothing useful is happening?
- Why are requests timing out?
- Is there a deadlock?
- Are threads piling up (thread leak)?

### 1.2 When to Take a Thread Dump

| Symptom | Likely Thread Cause |
|---|---|
| Application hangs, no response | Deadlock or all threads blocked |
| Request latency spikes | Thread contention on a shared lock |
| CPU at 100%, no progress | Thread spinning in a tight loop |
| CPU at 0%, nothing happening | All threads blocked/waiting |
| Thread pool exhausted errors | Thread leak or long-running blocked tasks |
| Slow under high load only | Lock contention scales with concurrency |

### 1.3 The "Three Dumps" Rule

A single thread dump is a snapshot in time. To diagnose a stuck or slow system, **take 3 dumps 10–15 seconds apart**:
- If threads are in the same state and same stack trace across all three → they are **stuck** (deadlock, blocked, infinite loop)
- If threads change position on each dump → they are making progress (may just be slow)

```bash
# Script: three thread dumps at 15-second intervals
for i in 1 2 3; do
    echo "=== Dump $i at $(date) ===" >> /tmp/threads.txt
    jstack <pid> >> /tmp/threads.txt
    [ $i -lt 3 ] && sleep 15
done
```

---

## 2. Capturing Thread Dumps

### 2.1 `jstack <pid>` — Classic Tool

```bash
# Basic thread dump to stdout
jstack <pid>

# Save to file (essential for large applications)
jstack <pid> > /tmp/thread_dump_$(date +%Y%m%d_%H%M%S).txt

# Long format — includes extra lock info (ownable synchronizers)
jstack -l <pid>

# Force dump even if JVM is hung (use carefully — may destabilize JVM)
jstack -F <pid>       # force attach, even if JVM is not responding

# Mixed mode — includes native frame info
jstack -m <pid>
```

**Getting the PID:**
```bash
# List all Java processes
jps -l
# Output:
# 12345 com.myapp.MainApplication
# 23456 org.apache.tomcat.TomcatEmbedded

# Alternative
ps aux | grep java | grep -v grep

# By application name
pgrep -f "MainApplication"
```

### 2.2 `jcmd Thread.dump_to_file` — Java 19+ Preferred

`jcmd` is the modern preferred tool. Unlike `jstack`, it runs inside the JVM process (no separate attach), which works even when the JVM is under stress:

```bash
# Dump to a file (text format — plain thread dump)
jcmd <pid> Thread.dump_to_file /tmp/threads.txt

# JSON format (Java 21+ — machine-parseable, includes virtual threads)
jcmd <pid> Thread.dump_to_file -format=json /tmp/threads.json

# Plain text (explicit — same as default)
jcmd <pid> Thread.dump_to_file -format=plain /tmp/threads.txt

# Example: multiple dumps with timestamps
for i in $(seq 1 3); do
    jcmd 12345 Thread.dump_to_file /tmp/dump_${i}_$(date +%s).txt
    echo "Dump $i taken"
    sleep 10
done
```

**JSON format advantages (Java 21+):**
- Captures virtual threads individually (not just their carriers)
- Machine-parseable for scripted analysis
- Includes virtual thread container hierarchy

```json
{
  "threadDump": {
    "processId": 12345,
    "time": "2024-01-15T10:23:41.123Z",
    "runtimeVersion": "21.0.1+12",
    "threads": [
      {
        "name": "request-handler-1",
        "tid": 42,
        "state": "BLOCKED",
        "blockedOn": "java.util.concurrent.locks.ReentrantLock$NonfairSync@7f80a1",
        "frames": [...]
      }
    ],
    "virtualThreads": [...]
  }
}
```

### 2.3 Other Capture Methods

```bash
# Kill signal (Unix/Linux) — works even when JVM is completely hung
# Sends SIGQUIT which JVM handles by printing thread dump to stdout
kill -3 <pid>
# Thread dump appears in: application stdout / logs (not a separate file)

# For Tomcat: dump appears in catalina.out
# For Spring Boot jar: dump appears in console/systemd journal

# jcmd Thread.print (quick, to stdout — no file)
jcmd <pid> Thread.print

# JConsole / VisualVM GUI
# Threads tab → "Thread Dump" button → saves or displays

# Programmatic (in code — for custom triggers)
Map<Thread, StackTraceElement[]> allStacks = Thread.getAllStackTraces();
ThreadMXBean mxBean = ManagementFactory.getThreadMXBean();
ThreadInfo[] threadInfos = mxBean.dumpAllThreads(true, true); // lock info included
```

### 2.4 Continuous Thread Dump Collection (Production Monitoring)

```bash
# Collect dumps every 30s for 10 minutes (useful during incident)
for i in $(seq 1 20); do
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    jstack <pid> > /tmp/thread_dump_${TIMESTAMP}.txt 2>&1
    echo "[$TIMESTAMP] Dump $i of 20 captured"
    sleep 30
done

# Compact: one file, delimited sections
PID=12345
for i in $(seq 1 5); do
    echo "=== DUMP $i $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" >> /tmp/dumps.txt
    jstack $PID >> /tmp/dumps.txt 2>&1
    echo "" >> /tmp/dumps.txt
    sleep 15
done
```

---

## 3. Anatomy of a Thread Dump — Reading Every Field

### 3.1 JVM Header

Every thread dump starts with metadata about the JVM:

```
Full thread dump OpenJDK 64-Bit Server VM (21.0.1+12 mixed mode, sharing):
```

### 3.2 Platform Thread Entry — Full Annotation

```
"http-nio-8080-exec-5" #47 daemon prio=5 os_prio=0 cpu=1234.56ms elapsed=3601.23s tid=0x00007f80a1234560 nid=0x3d12 waiting for monitor entry [0x00007f7f9c000000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at com.myapp.OrderService.processOrder(OrderService.java:142)
        - waiting to lock <0x000000076b35e1f8> (a com.myapp.OrderRepository)
        at com.myapp.OrderController.placeOrder(OrderController.java:87)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at java.lang.reflect.Method.invoke(Method.java:568)
        at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1089)

   Locked ownable synchronizers:
        - <0x000000076a112340> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
```

**Field-by-field breakdown:**

| Field | Example | Meaning |
|---|---|---|
| Thread name | `"http-nio-8080-exec-5"` | Name given at `Thread(name)` or by thread factory |
| Thread number | `#47` | JVM-internal sequence number (not OS thread ID) |
| `daemon` | `daemon` | Is this a daemon thread? (omitted if not daemon) |
| `prio` | `prio=5` | Java thread priority (1–10, default 5) |
| `os_prio` | `os_prio=0` | OS-level thread priority |
| `cpu` | `cpu=1234.56ms` | **Total CPU time consumed by this thread** (Java 9+) |
| `elapsed` | `elapsed=3601.23s` | Wall-clock time since thread started (Java 9+) |
| `tid` | `tid=0x00007f80a...` | JVM thread ID (hex pointer to thread object) |
| `nid` | `nid=0x3d12` | **OS native thread ID** (hex — convert to decimal for `top`) |
| State description | `waiting for monitor entry` | Human-readable state description |
| Address | `[0x00007f7f9c000000]` | Stack base address |

**The `nid` is critical for CPU correlation:**

```bash
# Find the thread consuming most CPU
top -H -p <pid>   # -H shows individual threads

# Identify thread by TID (in decimal from top)
# Example: top shows TID 15634 consuming 99% CPU
# Convert decimal to hex:
printf '%x\n' 15634      # → 3d12

# Find in thread dump by nid
grep "nid=0x3d12" thread_dump.txt -A 20
# Shows exactly which Java method is burning CPU!
```

### 3.3 Lock Lines in Stack Trace

```
at com.myapp.OrderService.processOrder(OrderService.java:142)
- waiting to lock <0x000000076b35e1f8> (a com.myapp.OrderRepository)
at com.myapp.OrderService.saveOrder(OrderService.java:180)  
- locked <0x000000076b35e1f8> (a com.myapp.OrderRepository)
at com.myapp.OrderService.updateInventory(OrderService.java:210)
- waiting on <0x000000076c112340> (a java.lang.Object)
```

| Lock line | Meaning |
|---|---|
| `- locked <addr> (a TypeName)` | This thread **holds** this monitor (owns the lock) |
| `- waiting to lock <addr>` | This thread is **blocked** trying to acquire this monitor |
| `- waiting on <addr>` | This thread called `wait()` on this monitor — currently sleeping, waiting for `notify()` |
| `- parking to wait for <addr>` | Parked via `LockSupport.park()` — waiting for this object (typically a `java.util.concurrent` lock) |
| `- eliminated <addr>` | Lock was eliminated by JIT (scalar replacement) |

**The address `<0x000000076b35e1f8>` is the object's identity hash** — matching addresses across threads reveals lock relationships.

### 3.4 `Locked ownable synchronizers` Section

```
   Locked ownable synchronizers:
        - <0x000000076a112340> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
        - None
```

This section lists `java.util.concurrent` locks (`ReentrantLock`, `ReadWriteLock`, `Semaphore`, etc.) held by this thread. These are separate from `synchronized` monitors and only appear with `jstack -l` or `jcmd Thread.dump_to_file`.

---

## 4. Thread States — Complete Reference

### 4.1 Java Thread States (`Thread.State` enum)

```
Thread lifecycle:

NEW ──► RUNNABLE ──► TERMINATED
            │
            ├──► BLOCKED         (waiting to enter synchronized block)
            ├──► WAITING         (Object.wait(), LockSupport.park(), Thread.join())
            └──► TIMED_WAITING   (Thread.sleep(n), wait(n), parkNanos(n))
```

### 4.2 State Details

**`RUNNABLE`** — Thread is executing or ready to execute. On CPU or in the OS run queue.

```
"http-nio-8080-exec-3" #45 prio=5 os_prio=0 cpu=12.34ms tid=0x... nid=0x3b00 runnable [0x...]
   java.lang.Thread.State: RUNNABLE
        at java.net.SocketInputStream.socketRead0(Native Method)   ← I/O wait
        at java.net.SocketInputStream.socketRead(SocketInputStream.java:115)
        at com.mysql.cj.protocol.FullReadInputStream.readFully(...)
```

> **Important:** RUNNABLE includes threads blocked on **I/O** (network reads, file reads) — the JVM considers I/O-blocked threads RUNNABLE because they hold a CPU slot from the OS perspective. Don't assume RUNNABLE = busy.

**`BLOCKED`** — Thread is waiting to enter a `synchronized` block or method held by another thread.

```
"http-nio-8080-exec-7" #49 prio=5 os_prio=0 cpu=0.12ms tid=0x... nid=0x3d22 waiting for monitor entry [0x...]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at com.myapp.UserService.getUser(UserService.java:78)
        - waiting to lock <0x000000076b3c1120> (a com.myapp.UserRepository)
```

**`WAITING`** — Thread is waiting indefinitely for another thread to perform an action.

```
"pool-1-thread-3" #23 prio=5 os_prio=0 cpu=0.05ms tid=0x... nid=0x2f10 in Object.wait() [0x...]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        - waiting on <0x000000076c112200> (a java.util.LinkedList)
        at java.lang.Object.wait(Object.java:338)
        at java.util.LinkedList.isEmpty(...)  ← waiting for work queue entry

"ForkJoinPool-1-worker-3" prio=5 os_prio=0 cpu=1.23ms tid=0x... nid=0x2a20 waiting on condition [0x...]
   java.lang.Thread.State: WAITING (parking)
        at jdk.internal.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x000000076a112340> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
        at java.util.concurrent.locks.LockSupport.park(LockSupport.java:341)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:914)
```

**`TIMED_WAITING`** — Thread is waiting for a specified time.

```
"pool-1-thread-1" #20 prio=5 os_prio=0 cpu=0.23ms tid=0x... nid=0x2e02 sleeping [0x...]
   java.lang.Thread.State: TIMED_WAITING (sleeping)
        at java.lang.Thread.sleep(Native Method)
        at com.myapp.PollingService.poll(PollingService.java:45)

"http-nio-8080-Poller" prio=5 os_prio=0 cpu=234.56ms tid=0x... nid=0x2200 in Object.wait() [0x...]
   java.lang.Thread.State: TIMED_WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        - waiting on <0x000000076c500180> (a org.apache.tomcat.util.net.NioBlockingSelector$BlockPoller)
```

**`TERMINATED`** — Thread has finished. Rarely appears in dumps (done threads are usually removed).

### 4.3 State at a Glance — Diagnostic Interpretation

| State | Appears Often? | What It Usually Means |
|---|---|---|
| `RUNNABLE` (non-I/O stack) | Many | Normal — working. If CPU 100%: one may be spinning |
| `RUNNABLE` (I/O stack) | Expected | Waiting for network/disk. Expected for web servers |
| `BLOCKED` | A few | Normal. Many = contention problem |
| `WAITING (parking)` | Many | Thread pool threads waiting for work — healthy |
| `WAITING (on object monitor)` | A few | `wait()/notify()` pattern — check if stuck |
| `TIMED_WAITING (sleeping)` | Some | Scheduled polling — usually fine |
| `TIMED_WAITING (parking)` | Many | Normal for `CompletableFuture`, `ScheduledExecutor` |

---

## 5. Lock Ownership and Waiting-On

### 5.1 Following the Lock Chain

The most important diagnostic skill: given a BLOCKED thread, find the thread that holds the lock it wants.

```
# Thread A is BLOCKED on lock 0x...e1f8
"http-exec-5" BLOCKED
    - waiting to lock <0x000000076b35e1f8> (a com.myapp.OrderRepository)

# Search for who holds 0x...e1f8
grep "locked <0x000000076b35e1f8>" thread_dump.txt

# Found: Thread B holds it
"http-exec-2" RUNNABLE
    at com.myapp.OrderService.processOrder(OrderService.java:142)
    - locked <0x000000076b35e1f8> (a com.myapp.OrderRepository)
```

Now check: what is Thread B doing with the lock? Is it stuck too?

```bash
# Script: for each BLOCKED thread, find lock holders
grep "waiting to lock" thread_dump.txt | \
    grep -oP '<0x[0-9a-f]+>' | \
    while read addr; do
        echo "=== Lock $addr held by: ==="
        grep -B 5 "locked $addr" thread_dump.txt | grep '"'
    done
```

### 5.2 `synchronized` vs `java.util.concurrent` Locks

```
# synchronized — appears as "locked" / "waiting to lock" in stack trace
synchronized (orderRepository) {    // lock on the object itself
    ...
}
# In dump: - locked <0x000000076b35e1f8> (a com.myapp.OrderRepository)

# ReentrantLock — appears as "parking to wait for" + "Locked ownable synchronizers"
private final ReentrantLock lock = new ReentrantLock();
lock.lock();
// In dump:
//   - parking to wait for <0x000000076a112340>
//                           (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
// AND in "Locked ownable synchronizers" of the holder thread
```

### 5.3 `Object.wait()` vs Lock Contention

These look similar but mean different things:

```
# Thread WAITING on a monitor — called wait(), voluntarily released the lock
"consumer-1" WAITING (on object monitor)
    at java.lang.Object.wait(Native Method)
    - waiting on <0x000000076c112200> (a java.util.LinkedList)
    at java.lang.Object.wait(Object.java:338)
    at com.myapp.WorkQueue.take(WorkQueue.java:45)
# This thread: RELEASED the lock and is sleeping until notify() — intentional wait

# Thread BLOCKED — fighting for the lock (lock contention)
"http-exec-7" BLOCKED (on object monitor)
    at com.myapp.UserService.getUser(UserService.java:78)
    - waiting to lock <0x000000076b3c1120> (a com.myapp.UserRepository)
# This thread: WANTS the lock but can't get it — contention
```

---

## 6. Deadlock Detection

### 6.1 What Is a Deadlock?

A deadlock occurs when two or more threads each hold a lock that another needs, forming a circular wait:

```
Thread A holds Lock 1, waiting for Lock 2
Thread B holds Lock 2, waiting for Lock 1
                                          ← neither can proceed
```

### 6.2 `jstack` Automatic Deadlock Detection

`jstack` automatically detects deadlock cycles and reports them at the end of the thread dump:

```
Found one Java-level deadlock:
=============================
"Thread-B":
  waiting to lock monitor 0x000000076b35e1f8 (object 0x000000076c112340, a com.myapp.Account),
  which is held by "Thread-A"

"Thread-A":
  waiting to lock monitor 0x000000076c112340 (object 0x000000076b35e1f8, a com.myapp.Account),
  which is held by "Thread-B"

Java stack information for the threads listed above:
===================================================
"Thread-B":
        at com.myapp.AccountService.transfer(AccountService.java:78)
        - waiting to lock <0x000000076b35e1f8> (a com.myapp.Account) [to=account]
        at com.myapp.AccountService.transfer(AccountService.java:75)
        - locked <0x000000076c112340> (a com.myapp.Account) [from=account]

"Thread-A":
        at com.myapp.AccountService.transfer(AccountService.java:78)
        - waiting to lock <0x000000076c112340> (a com.myapp.Account)
        at com.myapp.AccountService.transfer(AccountService.java:75)
        - locked <0x000000076b35e1f8> (a com.myapp.Account)

Found 1 deadlock.
```

**Reading the deadlock report:**
1. Thread-A holds `0x...e1f8` (Account from=A), wants `0x...2340` (Account to=B)
2. Thread-B holds `0x...2340` (Account from=B), wants `0x...e1f8` (Account to=A)
3. Two threads doing `transfer(A→B)` and `transfer(B→A)` simultaneously → deadlock

### 6.3 The Classic Deadlock — Bank Transfer

```java
// DEADLOCK — lock order depends on argument order
public void transfer(Account from, Account to, BigDecimal amount) {
    synchronized (from) {           // Thread-A locks Account-1 first
        synchronized (to) {         // Thread-B locked Account-2 first
            from.debit(amount);     // Thread-A waits for Account-2...
            to.credit(amount);      // Thread-B waits for Account-1...
        }
    }
    // Thread-A holds Account-1, waiting for Account-2
    // Thread-B holds Account-2, waiting for Account-1 → DEADLOCK
}

// FIX 1 — Consistent lock ordering (always lock lower ID first)
public void transfer(Account from, Account to, BigDecimal amount) {
    Account first  = from.id() < to.id() ? from : to;
    Account second = from.id() < to.id() ? to : from;
    synchronized (first) {
        synchronized (second) {
            from.debit(amount);
            to.credit(amount);
        }
    }
    // Both threads always lock in same order → no deadlock
}

// FIX 2 — Use tryLock with timeout (java.util.concurrent)
public boolean transfer(Account from, Account to, BigDecimal amount)
        throws InterruptedException {
    while (true) {
        if (from.lock.tryLock(100, TimeUnit.MILLISECONDS)) {
            try {
                if (to.lock.tryLock(100, TimeUnit.MILLISECONDS)) {
                    try {
                        from.debit(amount);
                        to.credit(amount);
                        return true;
                    } finally {
                        to.lock.unlock();
                    }
                }
            } finally {
                from.lock.unlock();
            }
        }
        Thread.sleep(10); // back off and retry
    }
}
```

### 6.4 `ReentrantLock` Deadlocks

`jstack` detects these too when using `-l` flag (ownable synchronizers):

```
Found one Java-level deadlock:
=============================
"Thread-B":
  waiting for ownable synchronizer 0x000000076a112340,
  (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
  which is held by "Thread-A"

"Thread-A":
  waiting for ownable synchronizer 0x000000076b223450,
  (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
  which is held by "Thread-B"
```

### 6.5 Programmatic Deadlock Detection

```java
ThreadMXBean mxBean = ManagementFactory.getThreadMXBean();

// Find deadlocked threads (synchronized only)
long[] deadlockedIds = mxBean.findDeadlockedThreads();

// Find all deadlocked threads (including java.util.concurrent locks)
long[] allDeadlocked = mxBean.findDeadlockedThreads(); // Java 6+

if (deadlockedIds != null) {
    ThreadInfo[] infos = mxBean.getThreadInfo(deadlockedIds, true, true);
    for (ThreadInfo info : infos) {
        System.out.println("DEADLOCK: " + info.getThreadName());
        System.out.println("  Waiting for: " + info.getLockName());
        System.out.println("  Held by: " + info.getLockOwnerName());
        for (StackTraceElement frame : info.getStackTrace()) {
            System.out.println("    " + frame);
        }
    }
}
```

### 6.6 Multi-Thread Deadlock (3+ Threads)

```
Found one Java-level deadlock:
Thread-A holds Lock-1, waiting for Lock-2
Thread-B holds Lock-2, waiting for Lock-3
Thread-C holds Lock-3, waiting for Lock-1
                       ← 3-way circular wait
```

`jstack` detects cycles of any length. The fix is the same: establish a total ordering across all locks.

---

## 7. Diagnosing Thread Contention

### 7.1 The Contention Pattern

Contention looks like this in a thread dump: **many threads BLOCKED on the same lock address**, with one thread holding it:

```
"http-exec-5"  BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
"http-exec-7"  BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
"http-exec-9"  BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
"http-exec-11" BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
"http-exec-13" BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
"http-exec-15" BLOCKED - waiting to lock <0x00000007631a1f80> (a UserService)
    ...12 more threads...

"http-exec-3"  RUNNABLE
    at com.myapp.UserService.loadProfile(UserService.java:142)
    - locked <0x00000007631a1f80> (a UserService)   ← the ONE holder
    at com.mysql.cj.jdbc.ConnectionImpl.executeQuery(...)  ← doing a slow DB query!
```

**Interpretation:** One thread is doing a slow DB query while holding a lock on `UserService`. All other threads pile up waiting. Under load this creates a "thundering herd" of blocked threads.

### 7.2 Identifying the Contended Lock

```bash
# Extract all "waiting to lock" addresses
grep "waiting to lock" thread_dump.txt | \
    grep -oP '<0x[0-9a-f]+>' | \
    sort | uniq -c | sort -rn | head -10

# Output — the hot lock:
# 47 <0x00000007631a1f80>    ← 47 threads waiting on this ONE lock!
#  3 <0x000000076b3c1120>
#  1 <0x000000076c112200>

# Now find who holds the hot lock
grep "locked <0x00000007631a1f80>" thread_dump.txt -B 10 | \
    grep -v "waiting to lock" | head -20
```

### 7.3 Common Sources of Lock Contention

```java
// CONTENTION 1 — synchronized method on a singleton/shared service
@Component
public class UserService {
    public synchronized User loadProfile(long id) { // ← synchronized on `this`
        return db.query("SELECT * FROM users WHERE id = ?", id); // slow DB call
    }
}
// Fix: remove synchronized, use connection pool + stateless service
// Or: move locking down to per-user granularity

// CONTENTION 2 — synchronized block on a shared collection
private final List<Event> events = new ArrayList<>();
public void addEvent(Event e) {
    synchronized (events) {           // ← all writers block here
        events.add(e);
    }
}
// Fix: use ConcurrentLinkedQueue or CopyOnWriteArrayList

// CONTENTION 3 — static synchronized method
public static synchronized String generateId() { // ← class-level lock
    return UUID.randomUUID().toString();
}
// Fix: UUID.randomUUID() is thread-safe — no synchronization needed!

// CONTENTION 4 — HashMap in a shared cache
private final Map<String, Object> cache = new HashMap<>();
public synchronized Object get(String key) { // ← coarse lock
    return cache.get(key);
}
// Fix: ConcurrentHashMap — lock-free reads, fine-grained segment locks for writes
```

### 7.4 Fixing Contention

```java
// FIX 1 — ConcurrentHashMap (fine-grained locking, lock-free reads)
private final Map<String, User> cache = new ConcurrentHashMap<>();
// No synchronization needed on reads; puts use segment locks

// FIX 2 — Read-Write Lock (multiple concurrent readers, exclusive writer)
private final ReadWriteLock lock = new ReentrantReadWriteLock();
private final Map<String, User> cache = new HashMap<>();

public User get(String key) {
    lock.readLock().lock();     // multiple threads can read simultaneously
    try {
        return cache.get(key);
    } finally {
        lock.readLock().unlock();
    }
}

public void put(String key, User user) {
    lock.writeLock().lock();    // exclusive write access
    try {
        cache.put(key, user);
    } finally {
        lock.writeLock().unlock();
    }
}

// FIX 3 — Lock striping (reduce lock granularity)
private final Object[] stripes = new Object[32];
{ for (int i = 0; i < stripes.length; i++) stripes[i] = new Object(); }

public void process(String key) {
    int stripe = Math.abs(key.hashCode() % stripes.length);
    synchronized (stripes[stripe]) {  // only 1/32 of keys share a lock
        doWork(key);
    }
}

// FIX 4 — Non-blocking with Atomic operations
private final AtomicLong counter = new AtomicLong();
public long nextId() {
    return counter.incrementAndGet(); // CAS — no blocking
}

// FIX 5 — ThreadLocal to eliminate sharing
private final ThreadLocal<StringBuilder> tlBuilder =
    ThreadLocal.withInitial(StringBuilder::new);
public String formatMessage(String msg) {
    StringBuilder sb = tlBuilder.get();
    sb.setLength(0); // reset
    sb.append("[").append(Instant.now()).append("] ").append(msg);
    return sb.toString(); // no sharing needed
}
```

### 7.5 JFR Lock Contention Analysis

JFR is the best tool for quantifying contention (rather than just observing it):

```bash
# Record with lock contention events
jcmd <pid> JFR.start duration=60s settings=profile filename=/tmp/contention.jfr

# In JMC → Threads → Lock Instances
# Shows: which lock, total blocked time, average blocked time, top waiters
#
# Example JMC output:
# Lock Class                    | Blocked Threads | Total Blocked Time
# com.myapp.UserService         |              47 |          123.4s    ← HOT LOCK
# com.myapp.OrderRepository     |               3 |            1.2s
```

---

## 8. Diagnosing Thread Leaks

### 8.1 What Is a Thread Leak?

A thread leak occurs when new threads are created but never terminated, causing the thread count to grow continuously. Consequences:
- Memory: each thread has a stack (default 512KB–1MB) → 1000 extra threads = 500MB–1GB wasted
- CPU: thread scheduling overhead
- OS limits: `ulimit -u` (max processes/threads per user)
- Application errors: "unable to create native thread" OOM

### 8.2 Detecting Thread Leaks

```bash
# Monitor thread count over time
jstat -gcutil <pid> 5000   # check Thread column isn't available here
# Better: use jconsole or monitor via JMX

# Quick: count threads in a thread dump
jstack <pid> | grep "^\"" | wc -l

# Compare thread counts over time
for i in $(seq 1 10); do
    COUNT=$(jstack <pid> 2>/dev/null | grep "^\"" | wc -l)
    echo "$(date +%H:%M:%S) Thread count: $COUNT"
    sleep 30
done
# Growing count = thread leak

# jcmd gives exact count
jcmd <pid> Thread.print | grep "^\"" | wc -l

# Via JMX programmatically
ThreadMXBean mxBean = ManagementFactory.getThreadMXBean();
System.out.println("Live threads: " + mxBean.getThreadCount());
System.out.println("Peak threads: " + mxBean.getPeakThreadCount()); // max since JVM start
System.out.println("Total started: " + mxBean.getTotalStartedThreadCount()); // ever created
// If totalStarted keeps climbing with mxBean.getThreadCount(): threads aren't dying
```

### 8.3 Finding Leaked Threads in the Dump

Leaked threads often have recognizable names or stack patterns:

```
# Pattern: many threads with same name prefix and growing numbers
"request-worker-1234" daemon WAITING
"request-worker-1235" daemon WAITING
"request-worker-1236" daemon WAITING
"request-worker-1237" daemon WAITING
    ... 800 more request-worker-NNNN threads ...

# Count threads by name prefix
grep "^\"" thread_dump.txt | \
    sed 's/".*//' | sed 's/"[0-9]*//' | \
    sort | uniq -c | sort -rn | head -20

# Output:
# 847 "request-worker-    ← 847 threads with "request-worker-" prefix
#  20 "http-nio-8080-exec-
#  10 "pool-1-thread-
#   4 "GC Thread#
```

### 8.4 Common Thread Leak Patterns

```java
// LEAK 1 — Creating threads without managing lifecycle
public void handleRequest(Request req) {
    new Thread(() -> processAsync(req)).start(); // new thread per request — never tracked!
}
// Fix: use an ExecutorService with bounded thread pool

// LEAK 2 — ExecutorService never shut down
public class RequestHandler {
    public Response handle(Request req) {
        ExecutorService executor = Executors.newFixedThreadPool(10); // created per request!
        // ... submit tasks ...
        return result;
        // executor.shutdown() never called — 10 threads leaked per request!
    }
}
// Fix: share a single executor as a class field

// LEAK 3 — Thread pool tasks that never complete (blocking forever)
ExecutorService pool = Executors.newFixedThreadPool(20);
for (Request req : requests) {
    pool.submit(() -> {
        String result = slowExternalService.call(req); // no timeout — hangs forever
        processResult(result);
    });
}
// All 20 threads WAITING on slowExternalService — pool "full", new tasks rejected
// Fix: add timeouts to all blocking calls

// LEAK 4 — Scheduled tasks that throw and get resubmitted
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(5);
scheduler.scheduleAtFixedRate(() -> {
    try {
        pollDatabase();
    } catch (Exception e) {
        // swallowed — ScheduledExecutorService SILENTLY STOPS the task on exception!
        // No retry, no leak here actually — but a different bug (task stops)
    }
}, 0, 10, TimeUnit.SECONDS);
// Note: uncaught exception in scheduleAtFixedRate cancels the task!

// LEAK 5 — Thread stored in a list and never joined
List<Thread> threads = new ArrayList<>();
for (Job job : jobs) {
    Thread t = new Thread(() -> execute(job));
    threads.add(t); // stored, but never joined or cleaned up
    t.start();
}
// threads list grows, old Thread objects can't be GC'd
// Fix: join each thread, or use ExecutorService + Future
```

### 8.5 Thread Stack Frame Analysis

Count unique stack frames to identify thread leak source:

```bash
# Extract all thread stack tops (first frame after state line)
grep -A 3 "java.lang.Thread.State" thread_dump.txt | \
    grep "^\s*at" | head -1 | \
    sort | uniq -c | sort -rn | head -20

# Or use awk to get first frame per thread
awk '/^"/{thread=$0} /^\s+at /{if(!printed){print thread; print; printed=1; next}} /^$/{printed=0}' thread_dump.txt | \
    grep "^\s*at" | sort | uniq -c | sort -rn

# Output — where leaked threads are stuck:
# 847 at java.net.SocketInputStream.socketRead0(Native Method)
#     ← 847 threads blocked reading from a socket with no timeout
```

---

## 9. Analysis Tools — fastthread.io and IntelliJ

### 9.1 `fastthread.io` — Online Thread Dump Analyzer

**fastthread.io** is a free online tool that parses and visualizes thread dumps. It handles large dumps (100MB+) and provides automatic analysis.

**What it provides:**

```
Upload: paste thread dump text or upload .txt file

Analysis output:
  1. Summary
     Total threads: 312
     Runnable:      45
     Blocked:       187   ← flagged as concerning
     Waiting:        72
     Timed Waiting:   8

  2. Thread Groups (by name pattern)
     "http-nio-8080-exec-*"  (200 threads)
     "pool-1-thread-*"       (50 threads)
     "GC Thread#*"           (8 threads)

  3. Stack Trace Groups (identical stacks collapsed)
     Stack group A (187 threads — all BLOCKED):
       at com.myapp.UserService.loadProfile(UserService.java:142)
       - waiting to lock <0x...1f80> (a com.myapp.UserService)
     → All 187 threads are blocked on the SAME lock!

  4. Monitor/Lock Analysis
     Most Contended Locks:
     <0x...1f80> com.myapp.UserService — 187 threads waiting
     <0x...2340> com.myapp.OrderService — 12 threads waiting

  5. Deadlock Detection
     → No deadlocks found (or deadlock cycle visualized)

  6. CPU Hotspot (if cpu= field present)
     "http-exec-3" cpu=45,231ms   ← this thread is burning CPU
```

**Privacy note:** fastthread.io is a public web service. Don't upload thread dumps containing sensitive production data (user IDs, connection strings, internal class names). For sensitive systems: use IntelliJ (local) or `tda` (command-line, see below).

### 9.2 IntelliJ IDEA Thread Dump Analyzer

IntelliJ has a built-in thread dump analyzer that runs entirely locally.

```
How to use:
1. Run → Analyze Thread Dump...
2. Paste thread dump text OR click "Open file" → select .txt file
3. IntelliJ parses and displays:

Left panel — Thread groups:
  ▼ BLOCKED (187)
      http-nio-8080-exec-5
      http-nio-8080-exec-7
      http-nio-8080-exec-9
      ... 184 more
  ▼ RUNNABLE (45)
  ▼ WAITING (72)

Right panel — Selected thread detail:
  Thread: "http-nio-8080-exec-5"
  State: BLOCKED
  Waiting on: com.myapp.UserService
  Held by: "http-nio-8080-exec-3"
  Stack trace:
    com.myapp.UserService.loadProfile(UserService.java:142)
    ← click to navigate directly to source code!

Bottom — Lock/Monitor Analysis:
  Lock <0x...1f80>: Held by http-exec-3, waited by 187 threads
```

**Key IntelliJ advantages:**
- Click stack frames to navigate directly to source code
- Fully local — no data leaves your machine
- Integrates with your current project code

### 9.3 Other Tools

**`tda` (Thread Dump Analyzer)** — open source, CLI + GUI, handles multiple dumps for comparison:
```bash
# Download: https://github.com/irockel/tda
java -jar tda.jar thread_dump_1.txt thread_dump_2.txt   # compare two dumps
# Shows: threads present in dump 1 but not dump 2 (ended)
#        threads present in dump 2 but not dump 1 (new — potential leak)
```

**`jvmtop`** — top-like live thread monitor:
```bash
# Shows thread count, state, CPU per thread in real time
# Download: https://github.com/patric-r/jvmtop
java -jar jvmtop.jar <pid>
```

**Samurai** — visualizes multiple thread dumps over time as a matrix, shows thread state changes:
```bash
# Good for: "was this thread always blocked, or just temporarily?"
# Download: https://github.com/yusuke/samurai
```

---

## 10. Virtual Threads and Safepoints (Java 21+)

### 10.1 Virtual Threads in Thread Dumps

Virtual threads appear differently in thread dumps. With `jstack` (text format):

```
# Platform (OS) threads — always appear, as before
"http-nio-8080-exec-1" #28 daemon prio=5 os_prio=0 cpu=1234ms tid=0x... nid=0x... RUNNABLE
   ...

# Virtual thread carrier thread — appears as a platform thread
"ForkJoinPool-1-worker-1" #35 daemon prio=5 os_prio=0 cpu=500ms tid=0x... nid=0x... RUNNABLE
   java.lang.Thread.State: RUNNABLE
        at com.myapp.UserService.loadProfile(UserService.java:142)
        at ...
   Carrying virtual thread #52   ← indicates a virtual thread is mounted

# Virtual threads in jstack (Java 21+) — appear at the end
#<virtual> (tid=52)
   java.lang.Thread.State: RUNNABLE
        at com.myapp.UserService.loadProfile(UserService.java:142)
        at java.net.SocketInputStream.socketRead0(Native Method)
        ...
```

With `jcmd Thread.dump_to_file -format=json` (full virtual thread support):

```json
{
  "virtualThreads": [
    {
      "name": "",
      "tid": 52,
      "state": "RUNNABLE",
      "mount": "ForkJoinPool-1-worker-1",
      "frames": [
        "com.myapp.UserService.loadProfile(UserService.java:142)",
        "java.net.SocketInputStream.socketRead0(Native Method)"
      ]
    },
    {
      "name": "",
      "tid": 53,
      "state": "WAITING",
      "frames": [
        "jdk.internal.misc.Unsafe.park(Native Method)",
        "java.util.concurrent.locks.LockSupport.park(...)"
      ]
    }
  ]
}
```

### 10.2 Virtual Thread States

Virtual threads have additional states beyond platform threads:

| State | Meaning |
|---|---|
| `RUNNING` | Mounted on a carrier thread, executing |
| `PARKING` | About to unmount (blocking operation starting) |
| `PARKED` | Unmounted, waiting to be rescheduled |
| `PINNED` | **Mounted but cannot unmount** — carrier thread is blocked (see below) |
| `WAITING` | Waiting for a signal (like platform thread WAITING) |
| `TIMED_WAITING` | Timed wait |
| `BLOCKED` | Waiting for a monitor (`synchronized`) |

### 10.3 Virtual Thread Pinning

**Pinning** is the most important virtual thread performance issue. A virtual thread is **pinned** when it cannot unmount from its carrier OS thread:

```java
// PINNING — synchronized blocks pin the virtual thread to its carrier
public void handleRequest() {
    synchronized (lock) {           // ← virtual thread PINS here
        externalService.call();     // ← blocking I/O — can't unmount!
        // Carrier OS thread is BLOCKED for the duration of externalService.call()
        // This eliminates virtual thread scalability benefit for this operation
    }
}

// Evidence in thread dump:
"ForkJoinPool-1-worker-2" RUNNABLE
    at java.net.SocketInputStream.socketRead0(Native Method)   ← carrier doing I/O
    Carrying virtual thread #87 (PINNED)   ← pinned virtual thread

// Count pinned events with JFR
-Djdk.tracePinnedThreads=full   // log pinning to stdout
-Djdk.tracePinnedThreads=short  // log without full stack trace
```

**When does pinning occur?**
1. Virtual thread is inside a `synchronized` block or method
2. Virtual thread calls a native method (`JNI`)
3. Virtual thread is in a stack frame that prevents unmounting (rare internal cases)

**How to detect pinning:**

```bash
# JFR event for pinning
jcmd <pid> JFR.start duration=60s settings=profile filename=/tmp/pinning.jfr
# In JMC → Threads → Virtual Thread Pinned
# Shows: which code caused pinning, how long, how many times

# JVM flag — print pinning to console
-Djdk.tracePinnedThreads=full

# Output:
# Thread[#52,ForkJoinPool-1-worker-1,5,CarrierThreads]
#     com.myapp.UserService.loadProfile(UserService.java:142) <== monitors:1
#       [Ljava.lang.Object;.wait
```

**Fix pinning:** Replace `synchronized` with `ReentrantLock`:

```java
// BEFORE — synchronized (causes pinning)
private final Object lock = new Object();
public void processRequest() {
    synchronized (lock) {
        externalService.call(); // virtual thread PINNED during entire call
    }
}

// AFTER — ReentrantLock (no pinning)
private final ReentrantLock lock = new ReentrantLock();
public void processRequest() {
    lock.lock();
    try {
        externalService.call(); // virtual thread CAN unmount here
    } finally {
        lock.unlock();
    }
}
// Virtual thread unmounts during externalService.call() → carrier is freed
// → other virtual threads can use the carrier → full scalability restored
```

### 10.4 Safepoints and Virtual Threads

**What is a safepoint?**

A safepoint is a moment when ALL JVM threads are paused for a JVM operation (GC, code deoptimization, class redefinition, biased lock revocation, etc.). Reaching a safepoint requires every thread to:
1. Finish its current bytecode instruction
2. Check the safepoint flag
3. Pause at the safepoint

```
JVM signals safepoint needed
    ↓
All threads: reach a safepoint-safe location
    ↓
All threads parked
    ↓
JVM operation executes (GC root scan, etc.)
    ↓
All threads resumed
```

**Safepoint overhead = Time-to-safepoint (TTSP)**. If any thread is slow to reach a safepoint, everything waits.

```bash
# Monitor safepoint times
-Xlog:safepoint=info

# Output:
# [info][safepoint] Safepoint "GCRunOperation", Time since last: 1234567890 ns,
#                  Reaching safepoint: 12 ms,    ← TTSP — time for all threads to stop
#                  At safepoint: 8 ms,            ← time spent at safepoint
#                  Total: 20 ms
```

**Virtual threads and safepoints:**

Virtual threads improve safepoint behavior significantly:
- Only **carrier threads** (platform OS threads) need to reach safepoints
- Mounted virtual threads reach safepoint when their carrier does
- **Unmounted** virtual threads (parked, waiting) are already at a safepoint-safe state — they contribute **zero** TTSP overhead

```
Traditional model: 10,000 OS threads → all 10,000 must reach safepoint
Virtual thread model: 200 carrier threads → only 200 must reach safepoint
                      9,800 virtual threads parked → already at safepoint

Result: TTSP reduced by ~50x
```

### 10.5 Diagnosing Virtual Thread Issues

```bash
# 1. Count virtual threads
jcmd <pid> Thread.dump_to_file -format=json /tmp/vthreads.json
cat /tmp/vthreads.json | python3 -c "
import json, sys
d = json.load(sys.stdin)
vt = d.get('virtualThreads', [])
from collections import Counter
states = Counter(t['state'] for t in vt)
print(f'Total virtual threads: {len(vt)}')
for state, count in states.most_common():
    print(f'  {state}: {count}')
"

# 2. Find pinned virtual threads
grep "PINNED" thread_dump.txt
# or in JSON:
cat /tmp/vthreads.json | python3 -c "
import json, sys
d = json.load(sys.stdin)
pinned = [t for t in d.get('virtualThreads', []) if t.get('state') == 'PINNED']
print(f'Pinned: {len(pinned)}')
for t in pinned[:5]:
    print(t['frames'][:3])
"

# 3. Check if virtual threads are enabled on executor
# Look for: ExecutorService using Thread.ofVirtual()
# Or: -Djdk.defaultScheduler.parallelism=N to tune carrier pool size
```

### 10.6 Virtual Thread Carrier Pool Tuning

```bash
# The virtual thread carrier pool is a ForkJoinPool
# Default parallelism: Runtime.getRuntime().availableProcessors()

# Tune carrier pool parallelism (default = CPU cores)
-Djdk.virtualThreadScheduler.parallelism=16       # more carriers for CPU-bound work
-Djdk.virtualThreadScheduler.maxPoolSize=256      # max carrier threads (for I/O pinning)

# If you have pinning that can't be eliminated, increase max pool size
# so that even when carriers are pinned, others are available
```

---

## 11. Production Runbook — Thread Dump Workflow

### 11.1 Application Hanging — Investigation Steps

```bash
# Step 1: Capture 3 thread dumps, 15s apart
for i in 1 2 3; do
    echo "=== DUMP $i $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" >> /tmp/hang_dumps.txt
    jstack <pid> >> /tmp/hang_dumps.txt 2>&1
    [ $i -lt 3 ] && sleep 15
done

# Step 2: Check for deadlock (jstack reports it automatically)
grep "Found.*deadlock" /tmp/hang_dumps.txt

# Step 3: Count BLOCKED threads (high count = contention)
grep "BLOCKED" /tmp/hang_dumps.txt | wc -l

# Step 4: Find the most contended lock
grep "waiting to lock" /tmp/hang_dumps.txt | \
    grep -oP '<0x[0-9a-f]+>' | sort | uniq -c | sort -rn | head -5

# Step 5: Find who holds that lock
HOTLOCK="<0x00000007631a1f80>"  # replace with actual address from step 4
grep "locked $HOTLOCK" /tmp/hang_dumps.txt -B 20 | grep '"' | head -5

# Step 6: Check if holder is also stuck
grep '"http-exec-3"' /tmp/hang_dumps.txt -A 20  # check the holder's stack
```

### 11.2 CPU 100% but No Progress — Investigation Steps

```bash
# Step 1: Find the high-CPU thread using top
top -H -p <pid>   # shows individual threads
# Note the TID of the high-CPU thread (in decimal)

# Step 2: Convert TID to hex
TID_DEC=15634
TID_HEX=$(printf '%x' $TID_DEC)   # → 3d12

# Step 3: Find thread in dump by nid
jstack <pid> | grep "nid=0x$TID_HEX" -A 25
# Shows the exact stack trace of the spinning thread

# Common patterns:
# - Infinite loop with no blocking operation (bad loop condition)
# - Regex catastrophic backtracking (Pattern.matches in tight loop)
# - HashMap infinite loop (old Java 7 bug with concurrent HashMap.put)
# - JIT compilation (unusual — check with jstat -compiler)
```

### 11.3 Thread Count Growing — Thread Leak

```bash
# Step 1: Monitor thread count
for i in $(seq 1 20); do
    COUNT=$(jstack <pid> | grep "^\"" | wc -l)
    echo "$(date +%H:%M:%S) - $COUNT threads"
    sleep 30
done

# Step 2: If growing, capture large dump
jstack <pid> > /tmp/thread_leak_dump.txt

# Step 3: Find most common thread name patterns
grep "^\"" /tmp/thread_leak_dump.txt | \
    sed 's/#[0-9]*.*//' | sort | uniq -c | sort -rn | head -20

# Step 4: Find common stack pattern for leaked threads
grep -A 5 "daemon prio=5" /tmp/thread_leak_dump.txt | \
    grep "at com.myapp" | sort | uniq -c | sort -rn | head -10
```

---

## 12. Quick Reference Cheat Sheet

### Capture Commands

```bash
# Recommended for Java 19+
jcmd <pid> Thread.dump_to_file /tmp/threads.txt           # text format
jcmd <pid> Thread.dump_to_file -format=json /tmp/t.json   # JSON (Java 21+ virtual threads)

# Classic
jstack <pid>                              # stdout
jstack -l <pid> > /tmp/threads.txt       # with ownable synchronizers
jstack -F <pid>                          # force (JVM hung)

# Signal (Unix)
kill -3 <pid>                            # to stdout/catalina.out

# Three dumps, 15s apart
for i in 1 2 3; do jstack <pid>; sleep 15; done > /tmp/three_dumps.txt
```

### Thread States Quick Reference

| State | What It Means |
|---|---|
| `RUNNABLE` | Running or ready (includes I/O wait!) |
| `BLOCKED` | Waiting to enter `synchronized` block — lock contention |
| `WAITING` | Waiting for `notify()`, `unpark()`, or `join()` to complete |
| `TIMED_WAITING` | Like WAITING, but with a timeout |
| `TERMINATED` | Done |

### Lock Line Quick Reference

```
- locked <0x...>              → this thread HOLDS this lock
- waiting to lock <0x...>     → this thread WANTS this lock (BLOCKED)
- waiting on <0x...>          → called wait(), lock released (WAITING)
- parking to wait for <0x...> → j.u.c. lock park (WAITING)
```

### Diagnostic Patterns

```bash
# Find deadlock
grep "Found.*deadlock" dump.txt

# Find most contended lock
grep "waiting to lock" dump.txt | grep -oP '<0x[0-9a-f]+>' | sort | uniq -c | sort -rn

# Find lock holder
grep "locked <0x000000ADDR>" dump.txt -B 10 | grep '"'

# Correlate CPU thread with dump
printf '%x\n' <TID_DECIMAL>              # convert to hex
grep "nid=0x<HEX>" dump.txt -A 20       # find in dump

# Count thread states
grep "java.lang.Thread.State" dump.txt | sort | uniq -c | sort -rn

# Count by name prefix (thread leak detection)
grep "^\"" dump.txt | sed 's/#.*//' | sort | uniq -c | sort -rn
```

### Virtual Thread Pinning Fix

```java
// BEFORE — pins virtual thread (avoid)
synchronized (lock) { blockingCall(); }

// AFTER — no pinning (use instead)
reentrantLock.lock();
try { blockingCall(); }
finally { reentrantLock.unlock(); }
```

### Key JVM Flags

```bash
-Xlog:safepoint=info                    # monitor safepoint pause times
-Djdk.tracePinnedThreads=full           # log virtual thread pinning
-Djdk.virtualThreadScheduler.parallelism=N  # tune carrier pool size
```

### Key Rules to Remember

1. **Take 3 dumps** 15s apart — threads in same state/stack across all 3 = stuck.
2. **`nid=` is the OS thread ID** — correlate with `top -H` to find CPU-hot threads.
3. **RUNNABLE ≠ using CPU** — threads blocked on I/O show as RUNNABLE.
4. **BLOCKED = contention** — many BLOCKED threads on same address = hot lock.
5. **`jstack` auto-detects deadlocks** — always check for "Found N deadlocks" at end.
6. **Lock at address `<0x...>`** — same address in multiple threads = they share the lock.
7. **Virtual threads: use `ReentrantLock` not `synchronized`** to avoid pinning.
8. **`jcmd Thread.dump_to_file -format=json`** is the only way to see unmounted virtual threads individually.
9. **Thread leak**: growing thread count + same stack pattern in new threads = leak source.
10. **Safepoints**: virtual threads dramatically reduce TTSP because unmounted threads are already safe.

---

*End of Thread Dump Analysis & Virtual Threads Study Guide*
