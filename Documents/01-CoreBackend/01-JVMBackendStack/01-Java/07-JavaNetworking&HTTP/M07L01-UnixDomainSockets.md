# Unix Domain Sockets (Java 16+) — Complete Study Guide

> **JEP 380, Java 16+ | Brutally Detailed Reference**
> Covers `UnixDomainSocketAddress`, server and client patterns, performance vs TCP loopback, security model, integration with `SocketChannel`/`ServerSocketChannel`, and real-world IPC patterns. Every section includes full working examples.

---

## Table of Contents

1. [What Are Unix Domain Sockets and Why Use Them?](#1-what-are-unix-domain-sockets-and-why-use-them)
2. [`UnixDomainSocketAddress`](#2-unixdomainsocketaddress)
3. [Server Side — `ServerSocketChannel`](#3-server-side--serversocketchannel)
4. [Client Side — `SocketChannel`](#4-client-side--socketchannel)
5. [Blocking vs Non-Blocking Mode](#5-blocking-vs-non-blocking-mode)
6. [Full Duplex Communication Example](#6-full-duplex-communication-example)
7. [Performance — Unix Domain vs TCP Loopback](#7-performance--unix-domain-vs-tcp-loopback)
8. [Security Model](#8-security-model)
9. [Lifecycle and Cleanup](#9-lifecycle-and-cleanup)
10. [Real-World IPC Patterns](#10-real-world-ipc-patterns)
11. [Platform Considerations](#11-platform-considerations)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. What Are Unix Domain Sockets and Why Use Them?

### 1.1 The Problem with TCP Loopback for IPC

When two processes on the **same machine** need to communicate, the conventional approach is to use TCP on `localhost` (`127.0.0.1`):

```java
// Conventional IPC — TCP loopback
ServerSocket server = new ServerSocket(8080); // bind to localhost:8080
Socket client = new Socket("127.0.0.1", 8080); // connect to it
```

This works but has unnecessary overhead:

```
Process A ──► TCP stack ──► IP stack ──► loopback device
                                              │
                                              ▼
Process B ◄── TCP stack ◄── IP stack ◄── loopback device

Overhead:
- TCP handshake (3-way SYN/SYN-ACK/ACK)
- IP header processing
- Checksum computation
- Loopback network driver path
- Port allocation and management (ephemeral ports are a finite resource)
- TCP TIME_WAIT states after close (2MSL = 2 minutes by default)
- SELinux/firewall rules may apply even to loopback
```

### 1.2 What Unix Domain Sockets Are

A Unix Domain Socket (UDS) is a **socket whose address is a filesystem path** instead of an IP:port pair. Communication happens entirely within the kernel — data is copied directly from one process's buffer to another's, without going through any network stack:

```
Process A ──► kernel buffer (socket file: /tmp/myapp.sock)
                                    │
                                    ▼
                             Process B reads directly

No IP headers. No TCP handshake. No port numbers. No loopback device.
Data stays in kernel memory — never touches a NIC.
```

### 1.3 Key Advantages Over TCP Loopback

| Property | TCP Loopback | Unix Domain Socket |
|---|---|---|
| **Latency** | ~50–100µs | ~5–20µs (3–10× faster) |
| **Throughput** | Good | Higher (no protocol overhead) |
| **Port required** | Yes (0–65535 range) | No — filesystem path |
| **Connection setup** | 3-way handshake | Direct kernel path |
| **Security** | IP-based (all processes on host) | Filesystem permissions (owner/group/mode) |
| **TIME_WAIT** | Yes — port held 2 minutes after close | No — unlink and done |
| **Cross-machine** | Yes | No — same machine only |
| **OS support** | Universal | Unix/Linux/macOS; Windows 10+ (build 17063+) |

### 1.4 Java 16 — JEP 380

Before Java 16, Unix Domain Sockets required:
- JNA (Java Native Access) to call `libc` directly
- Third-party libraries
- `ProcessBuilder` launching native socket tools

Java 16 (JEP 380) added first-class support via `UnixDomainSocketAddress` and the `StandardProtocolFamily.UNIX` enum value for `SocketChannel` and `ServerSocketChannel`.

---

## 2. `UnixDomainSocketAddress`

### 2.1 Creating an Address

`UnixDomainSocketAddress` implements `SocketAddress` and holds a filesystem path:

```java
import java.net.UnixDomainSocketAddress;
import java.nio.file.Path;

// From a String path
UnixDomainSocketAddress addr = UnixDomainSocketAddress.of("/tmp/myapp.sock");

// From a Path object
UnixDomainSocketAddress addr = UnixDomainSocketAddress.of(Path.of("/tmp/myapp.sock"));

// Retrieve the path back
Path socketPath = addr.getPath();
System.out.println(socketPath); // /tmp/myapp.sock
```

### 2.2 Path Naming Conventions

```java
// Convention: use /tmp or /var/run for socket files
// /tmp — readable by any user (use permissions to restrict)
UnixDomainSocketAddress.of("/tmp/myapp.sock")

// /var/run — for system daemons and services (root-owned typically)
UnixDomainSocketAddress.of("/var/run/myapp/app.sock")

// Application-scoped: use a subdirectory
UnixDomainSocketAddress.of("/tmp/myapp/worker-1.sock")

// Relative path (relative to CWD — avoid, fragile)
UnixDomainSocketAddress.of("app.sock")  // not recommended

// Path length limit: 104 bytes on macOS, 108 bytes on Linux
// Keep paths short and predictable
```

### 2.3 Abstract Namespace (Linux Only)

Linux supports **abstract namespace** sockets — paths starting with `\0` (null byte) that exist only in the kernel and never touch the filesystem:

```java
// Abstract namespace — Linux only, no file created
// Not directly supported by UnixDomainSocketAddress in Java
// The API supports file-based paths only
// For abstract namespace: use JNA or Java Native Interface directly
```

---

## 3. Server Side — `ServerSocketChannel`

### 3.1 Basic Server Setup

```java
import java.net.UnixDomainSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.nio.file.*;
import java.net.StandardProtocolFamily;

public class UnixSocketServer {
    private static final Path SOCKET_PATH = Path.of("/tmp/myapp.sock");

    public static void main(String[] args) throws Exception {
        // Delete socket file if it exists from a previous run
        Files.deleteIfExists(SOCKET_PATH);

        UnixDomainSocketAddress address = UnixDomainSocketAddress.of(SOCKET_PATH);

        // Open with UNIX protocol family — key difference from TCP
        try (ServerSocketChannel server =
                ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {

            server.bind(address);
            System.out.println("Server listening on: " + SOCKET_PATH);

            // Accept loop
            while (true) {
                try (SocketChannel client = server.accept()) {
                    System.out.println("Client connected");
                    handleClient(client);
                }
            }
        } finally {
            // Clean up socket file
            Files.deleteIfExists(SOCKET_PATH);
        }
    }

    private static void handleClient(SocketChannel client) throws Exception {
        ByteBuffer buf = ByteBuffer.allocate(1024);

        // Read request
        int bytesRead = client.read(buf);
        if (bytesRead > 0) {
            buf.flip();
            String request = new String(buf.array(), 0, buf.limit());
            System.out.println("Received: " + request.trim());

            // Write response
            String response = "ACK: " + request.trim();
            client.write(ByteBuffer.wrap(response.getBytes()));
        }
    }
}
```

### 3.2 Multi-Client Server with Thread Pool

```java
import java.net.StandardProtocolFamily;
import java.net.UnixDomainSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.nio.file.*;
import java.util.concurrent.*;

public class MultiClientUnixServer {
    private static final Path SOCKET_PATH = Path.of("/tmp/myapp-multi.sock");
    private final ExecutorService executor =
        Executors.newVirtualThreadPerTaskExecutor(); // Java 21+ virtual threads

    public void start() throws Exception {
        Files.deleteIfExists(SOCKET_PATH);
        UnixDomainSocketAddress address = UnixDomainSocketAddress.of(SOCKET_PATH);

        // Set socket file permissions after binding
        try (ServerSocketChannel server =
                ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {

            server.bind(address);

            // Restrict access: owner-only (rw-------)
            try {
                Files.setPosixFilePermissions(SOCKET_PATH,
                    PosixFilePermissions.fromString("rw-------"));
            } catch (UnsupportedOperationException e) {
                // Windows doesn't support POSIX permissions — skip
            }

            System.out.println("Server ready: " + SOCKET_PATH);

            while (!Thread.currentThread().isInterrupted()) {
                SocketChannel client = server.accept(); // blocks until connection
                // Dispatch to thread pool — don't block the accept loop
                executor.submit(() -> {
                    try (client) {
                        handleRequest(client);
                    } catch (Exception e) {
                        System.err.println("Client error: " + e.getMessage());
                    }
                });
            }
        } finally {
            Files.deleteIfExists(SOCKET_PATH);
            executor.shutdown();
        }
    }

    private void handleRequest(SocketChannel channel) throws Exception {
        ByteBuffer readBuf = ByteBuffer.allocate(4096);
        int n = channel.read(readBuf);
        if (n <= 0) return;

        readBuf.flip();
        byte[] data = new byte[readBuf.remaining()];
        readBuf.get(data);
        String request = new String(data);

        // Process...
        String response = processRequest(request);

        // Write length-prefixed response
        byte[] responseBytes = response.getBytes();
        ByteBuffer writeBuf = ByteBuffer.allocate(4 + responseBytes.length);
        writeBuf.putInt(responseBytes.length);
        writeBuf.put(responseBytes);
        writeBuf.flip();
        channel.write(writeBuf);
    }

    private String processRequest(String req) {
        return "OK: " + req.trim();
    }
}
```

---

## 4. Client Side — `SocketChannel`

### 4.1 Basic Client

```java
import java.net.StandardProtocolFamily;
import java.net.UnixDomainSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.file.Path;

public class UnixSocketClient {
    public static void main(String[] args) throws Exception {
        UnixDomainSocketAddress address =
            UnixDomainSocketAddress.of(Path.of("/tmp/myapp.sock"));

        // Open with UNIX protocol family
        try (SocketChannel channel =
                SocketChannel.open(StandardProtocolFamily.UNIX)) {

            channel.connect(address);
            System.out.println("Connected to server");

            // Send a message
            String message = "Hello, server!";
            channel.write(ByteBuffer.wrap(message.getBytes()));

            // Read response
            ByteBuffer response = ByteBuffer.allocate(1024);
            int n = channel.read(response);
            if (n > 0) {
                response.flip();
                System.out.println("Response: " +
                    new String(response.array(), 0, response.limit()));
            }
        }
    }
}
```

### 4.2 Client with Connection Retry

```java
public class ResilientUnixClient {
    private static final Path SOCKET_PATH = Path.of("/tmp/myapp.sock");
    private static final int MAX_RETRIES = 5;
    private static final Duration RETRY_DELAY = Duration.ofMillis(500);

    public static SocketChannel connectWithRetry() throws Exception {
        UnixDomainSocketAddress address = UnixDomainSocketAddress.of(SOCKET_PATH);
        Exception lastException = null;

        for (int attempt = 1; attempt <= MAX_RETRIES; attempt++) {
            try {
                SocketChannel channel =
                    SocketChannel.open(StandardProtocolFamily.UNIX);
                channel.connect(address);
                return channel; // success
            } catch (Exception e) {
                lastException = e;
                System.err.printf("Connection attempt %d/%d failed: %s%n",
                    attempt, MAX_RETRIES, e.getMessage());
                if (attempt < MAX_RETRIES) {
                    Thread.sleep(RETRY_DELAY.toMillis() * attempt); // backoff
                }
            }
        }
        throw new RuntimeException("Failed after " + MAX_RETRIES + " attempts",
            lastException);
    }
}
```

### 4.3 Reusable Client Connection Pool

```java
public class UnixSocketConnectionPool implements AutoCloseable {
    private final UnixDomainSocketAddress address;
    private final BlockingQueue<SocketChannel> pool;
    private final int poolSize;

    public UnixSocketConnectionPool(Path socketPath, int size) throws Exception {
        this.address = UnixDomainSocketAddress.of(socketPath);
        this.poolSize = size;
        this.pool = new ArrayBlockingQueue<>(size);

        // Pre-connect all channels
        for (int i = 0; i < size; i++) {
            pool.offer(createChannel());
        }
    }

    private SocketChannel createChannel() throws Exception {
        SocketChannel ch = SocketChannel.open(StandardProtocolFamily.UNIX);
        ch.connect(address);
        return ch;
    }

    public SocketChannel borrow() throws InterruptedException {
        return pool.take();
    }

    public void release(SocketChannel channel) {
        if (channel != null && channel.isConnected()) {
            pool.offer(channel); // return to pool
        }
    }

    public String send(String request) throws Exception {
        SocketChannel ch = borrow();
        try {
            ch.write(ByteBuffer.wrap(request.getBytes()));
            ByteBuffer buf = ByteBuffer.allocate(4096);
            ch.read(buf);
            buf.flip();
            return new String(buf.array(), 0, buf.limit());
        } finally {
            release(ch);
        }
    }

    @Override
    public void close() throws Exception {
        SocketChannel ch;
        while ((ch = pool.poll()) != null) {
            ch.close();
        }
    }
}
```

---

## 5. Blocking vs Non-Blocking Mode

### 5.1 Blocking Mode (Default)

```java
// Default is blocking — read/write/accept block until data available
try (ServerSocketChannel server =
        ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
    server.bind(address);
    // server.isBlocking() == true by default

    SocketChannel client = server.accept(); // blocks until client connects
    ByteBuffer buf = ByteBuffer.allocate(1024);
    client.read(buf); // blocks until data arrives
}
```

### 5.2 Non-Blocking Mode with `Selector`

For handling many concurrent connections without a thread per connection:

```java
import java.nio.*;
import java.nio.channels.*;
import java.net.*;
import java.nio.file.*;

public class NonBlockingUnixServer {
    public static void main(String[] args) throws Exception {
        Path socketPath = Path.of("/tmp/nb-server.sock");
        Files.deleteIfExists(socketPath);
        UnixDomainSocketAddress address = UnixDomainSocketAddress.of(socketPath);

        Selector selector = Selector.open();

        ServerSocketChannel server =
            ServerSocketChannel.open(StandardProtocolFamily.UNIX);
        server.configureBlocking(false);
        server.bind(address);
        server.register(selector, SelectionKey.OP_ACCEPT);

        System.out.println("Non-blocking server ready");

        while (true) {
            selector.select(); // blocks until at least one channel is ready

            for (SelectionKey key : selector.selectedKeys()) {
                if (!key.isValid()) continue;

                if (key.isAcceptable()) {
                    // New client connecting
                    ServerSocketChannel ssc = (ServerSocketChannel) key.channel();
                    SocketChannel client = ssc.accept();
                    if (client != null) {
                        client.configureBlocking(false);
                        client.register(selector, SelectionKey.OP_READ,
                            ByteBuffer.allocate(4096));
                        System.out.println("New client accepted");
                    }

                } else if (key.isReadable()) {
                    // Data available from a client
                    SocketChannel client = (SocketChannel) key.channel();
                    ByteBuffer buf = (ByteBuffer) key.attachment();
                    buf.clear();

                    int n = client.read(buf);
                    if (n == -1) {
                        // Client disconnected
                        key.cancel();
                        client.close();
                        System.out.println("Client disconnected");
                    } else if (n > 0) {
                        buf.flip();
                        // Echo back
                        client.write(buf);
                        buf.clear();
                    }
                }
            }
            selector.selectedKeys().clear();
        }
    }
}
```

---

## 6. Full Duplex Communication Example

### 6.1 Request-Response Protocol with Length Prefixing

Real IPC protocols need framing — a way to know where one message ends and the next begins. Length-prefixing is the simplest approach:

```java
/**
 * Message framing protocol:
 * [4-byte int: message length][N bytes: message body]
 */
public class FramedUnixSocket {

    // Write a framed message
    public static void writeMessage(SocketChannel channel, String message)
            throws IOException {
        byte[] body = message.getBytes(StandardCharsets.UTF_8);
        ByteBuffer buf = ByteBuffer.allocate(4 + body.length);
        buf.putInt(body.length);    // length prefix
        buf.put(body);              // message body
        buf.flip();

        while (buf.hasRemaining()) {
            channel.write(buf); // loop: write may not send all bytes at once
        }
    }

    // Read a complete framed message
    public static String readMessage(SocketChannel channel) throws IOException {
        // Step 1: Read exactly 4 bytes for the length
        ByteBuffer lenBuf = ByteBuffer.allocate(4);
        while (lenBuf.hasRemaining()) {
            int n = channel.read(lenBuf);
            if (n == -1) throw new EOFException("Connection closed before length");
        }
        lenBuf.flip();
        int messageLength = lenBuf.getInt();

        // Step 2: Read exactly messageLength bytes
        ByteBuffer bodyBuf = ByteBuffer.allocate(messageLength);
        while (bodyBuf.hasRemaining()) {
            int n = channel.read(bodyBuf);
            if (n == -1) throw new EOFException("Connection closed mid-message");
        }
        bodyBuf.flip();
        return new String(bodyBuf.array(), StandardCharsets.UTF_8);
    }

    // ─── Server ────────────────────────────────────────────────────────────
    public static void runServer(Path socketPath) throws Exception {
        Files.deleteIfExists(socketPath);

        try (ServerSocketChannel server =
                ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
            server.bind(UnixDomainSocketAddress.of(socketPath));
            System.out.println("[Server] Listening");

            try (SocketChannel client = server.accept()) {
                System.out.println("[Server] Client connected");

                // Handle multiple messages in a session
                while (true) {
                    try {
                        String request = readMessage(client);
                        System.out.println("[Server] Received: " + request);

                        if ("QUIT".equals(request)) {
                            writeMessage(client, "BYE");
                            break;
                        }

                        writeMessage(client, "ECHO: " + request);
                    } catch (EOFException e) {
                        System.out.println("[Server] Client disconnected");
                        break;
                    }
                }
            }
        } finally {
            Files.deleteIfExists(socketPath);
        }
    }

    // ─── Client ────────────────────────────────────────────────────────────
    public static void runClient(Path socketPath) throws Exception {
        try (SocketChannel channel =
                SocketChannel.open(StandardProtocolFamily.UNIX)) {

            channel.connect(UnixDomainSocketAddress.of(socketPath));
            System.out.println("[Client] Connected");

            String[] messages = {"Hello", "World", "How are you?", "QUIT"};
            for (String msg : messages) {
                writeMessage(channel, msg);
                String response = readMessage(channel);
                System.out.println("[Client] Got: " + response);
                if ("BYE".equals(response)) break;
            }
        }
    }
}
```

---

## 7. Performance — Unix Domain vs TCP Loopback

### 7.1 Why Unix Domain Sockets Are Faster

```
TCP Loopback data path:
  write(fd, buf, n)
    → socket send buffer
      → TCP segment assembly (headers, sequence numbers)
        → IP packet assembly (IP headers)
          → loopback device (net_rx_action)
            → IP receive path (routing, defragmentation)
              → TCP receive path (ack, reassembly)
                → socket receive buffer
                  → read(fd, buf, n)

Unix Domain Socket data path:
  write(fd, buf, n)
    → socket send buffer
      → memcpy to peer receive buffer (in kernel)
        → read(fd, buf, n)

Removed for UDS:
✗ TCP segment creation (20+ byte TCP header per segment)
✗ IP packet creation (20+ byte IP header)
✗ Loopback device processing
✗ Routing table lookups
✗ Checksum computation
✗ TCP state machine (SYN, SYN-ACK, ACK, FIN, TIME_WAIT)
✗ Sequence number tracking
✗ Congestion control (not needed for intra-kernel copy)
```

### 7.2 Benchmark — Latency Comparison

A round-trip latency benchmark (ping-pong: send 1 byte, receive 1 byte, measure RTT):

```
Typical results (Linux, Java 21):

TCP Loopback (127.0.0.1):       Unix Domain Socket:
  Min:    28µs                    Min:     5µs
  Avg:    62µs                    Avg:    12µs
  p99:   180µs                    p99:    35µs
  Max:   450µs                    Max:    95µs

  UDS is approximately 3-5× faster for latency-sensitive IPC
```

### 7.3 Benchmark — Throughput

```
Large message throughput (1MB messages, Linux):

TCP Loopback:    ~8 GB/s
Unix Domain:    ~12 GB/s    (~50% higher throughput)

Throughput gap is smaller than latency gap because:
- For large messages, the memory copy dominates (same for both)
- Protocol overhead is amortized over large payloads
- UDS advantage is greatest for many small messages (latency-bound)
```

### 7.4 When the Performance Difference Matters

```
UDS is significantly better when:
- High-frequency IPC: > 10,000 messages/second
- Latency-sensitive: < 1ms budget per IPC call
- Many short-lived connections (no TIME_WAIT accumulation)
- Port exhaustion is a concern

TCP loopback is fine when:
- Low-frequency IPC: < 1,000 messages/second  
- You already have a TCP framework in place
- You need the code to work across machines too
- Simplicity > marginal performance gain
```

---

## 8. Security Model

### 8.1 Filesystem-Based Access Control

UDS security is entirely based on **filesystem permissions**. Only processes with read/write access to the socket file can connect:

```java
// After binding, set permissions to restrict access
try (ServerSocketChannel server =
        ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
    server.bind(UnixDomainSocketAddress.of("/tmp/myapp.sock"));

    // Owner read+write only (no group, no other)
    // On Unix/Linux/macOS:
    try {
        Files.setPosixFilePermissions(
            Path.of("/tmp/myapp.sock"),
            PosixFilePermissions.fromString("rw-------")
        );
    } catch (UnsupportedOperationException e) {
        // Windows — use ACLs instead (see Section 11)
    }
}

// Only the user who created the socket can connect
// sudo / other users cannot connect without explicit permission
```

### 8.2 Permission Levels

```
rw-------  (600)  Owner only — most restrictive, good for per-user daemons
rw-rw----  (660)  Owner + group — good for services sharing a unix group
rw-rw-rw-  (666)  Anyone — avoid for sensitive IPC

# Example: all processes in group "appgroup" can connect
chgrp appgroup /tmp/myapp.sock
chmod 660 /tmp/myapp.sock
```

### 8.3 No Network-Level Exposure

A crucial security advantage: **Unix Domain Sockets are never accessible from the network**. Even with `rw-rw-rw-` (world-accessible), no process on another machine can connect. Compare to TCP:

```
TCP loopback bind:
  server.bind(new InetSocketAddress("127.0.0.1", 8080))
  // Firewall rule misconfiguration can expose this to the network
  // e.g.: iptables PREROUTING redirect, Docker port mapping bug

Unix Domain Socket bind:
  server.bind(UnixDomainSocketAddress.of("/tmp/app.sock"))
  // Physically impossible to connect from another machine
  // No firewall rule, no port mapping can expose it
```

### 8.4 Credential Passing (Linux — JNI Required)

Linux supports `SO_PEERCRED` — the server can query the **PID, UID, and GID** of the connecting client without any authentication protocol. Java's API doesn't expose this directly, but it's accessible via JNI:

```java
// Java NIO doesn't expose SO_PEERCRED — need JNI or JNA for this
// Using JNA:
// import com.sun.jna.platform.unix.LibC;
// The getsockopt(fd, SOL_SOCKET, SO_PEERCRED, ...) call returns:
// struct ucred { pid_t pid; uid_t uid; gid_t gid; }

// Alternative: pass credentials explicitly in the message protocol
// (less elegant but portable)
record ClientCredentials(long pid, String username) {}
// Client sends: ProcessHandle.current().pid() + System.getProperty("user.name")
// Server can verify against /proc/PID/status (Linux only)
```

---

## 9. Lifecycle and Cleanup

### 9.1 The Stale Socket File Problem

When a process crashes or is killed without cleanup, the socket file **remains on disk**. The next startup attempt to bind the same path will throw `java.net.BindException: Address already in use`.

```java
// Pattern 1: Delete before bind (simple, correct for most cases)
Path socketPath = Path.of("/tmp/myapp.sock");
Files.deleteIfExists(socketPath); // delete stale file from previous run
server.bind(UnixDomainSocketAddress.of(socketPath));

// Pattern 2: Shutdown hook (delete on JVM exit)
Runtime.getRuntime().addShutdownHook(new Thread(() -> {
    try {
        Files.deleteIfExists(socketPath);
        System.out.println("Socket file cleaned up");
    } catch (IOException e) {
        System.err.println("Failed to clean up socket: " + e.getMessage());
    }
}));

// Pattern 3: Try-with-resources + finally (most robust)
Files.deleteIfExists(socketPath);
try (ServerSocketChannel server =
        ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
    server.bind(UnixDomainSocketAddress.of(socketPath));
    // ... run server ...
} finally {
    Files.deleteIfExists(socketPath); // always clean up
}
```

### 9.2 Checking if a Socket File is Live

```java
public static boolean isServerRunning(Path socketPath) {
    if (!Files.exists(socketPath)) return false;

    // Try to connect — if connection succeeds, server is alive
    try (SocketChannel ch = SocketChannel.open(StandardProtocolFamily.UNIX)) {
        ch.connect(UnixDomainSocketAddress.of(socketPath));
        return true; // connected successfully
    } catch (IOException e) {
        // Connection refused = file exists but server not listening
        // (stale socket file)
        return false;
    }
}

// Usage: clean up stale file and start fresh
if (!isServerRunning(socketPath)) {
    Files.deleteIfExists(socketPath); // remove stale socket
}
// Now start server
```

### 9.3 Graceful Shutdown

```java
public class GracefulUnixServer {
    private volatile boolean running = true;
    private ServerSocketChannel server;
    private final Path socketPath = Path.of("/tmp/myapp.sock");

    public void start() throws Exception {
        Files.deleteIfExists(socketPath);

        server = ServerSocketChannel.open(StandardProtocolFamily.UNIX);
        server.bind(UnixDomainSocketAddress.of(socketPath));

        // Register shutdown hook
        Runtime.getRuntime().addShutdownHook(new Thread(this::shutdown));

        while (running) {
            try {
                SocketChannel client = server.accept();
                handleClient(client);
            } catch (ClosedChannelException e) {
                break; // server was closed by shutdown()
            }
        }
    }

    public void shutdown() {
        running = false;
        try {
            if (server != null) server.close(); // unblocks accept()
        } catch (IOException e) { /* ignore */ }
        try {
            Files.deleteIfExists(socketPath); // remove socket file
        } catch (IOException e) { /* ignore */ }
        System.out.println("Server shut down cleanly");
    }
}
```

---

## 10. Real-World IPC Patterns

### 10.1 Sidecar Pattern — JVM + Native Process

Unix Domain Sockets are ideal for communicating with a native sidecar process (Python ML model, Go service, Rust library):

```java
/**
 * Java service communicating with a Python ML inference server
 * via Unix Domain Socket — avoids HTTP/gRPC overhead for co-located processes
 */
public class MLSidecarClient implements AutoCloseable {
    private final Path socketPath;
    private SocketChannel channel;

    public MLSidecarClient(Path socketPath) throws Exception {
        this.socketPath = socketPath;
        this.channel = SocketChannel.open(StandardProtocolFamily.UNIX);
        this.channel.connect(UnixDomainSocketAddress.of(socketPath));
    }

    public float[] getEmbedding(String text) throws Exception {
        // Send: length-prefixed JSON request
        String request = "{\"text\": \"" + text.replace("\"", "\\\"") + "\"}";
        FramedUnixSocket.writeMessage(channel, request);

        // Receive: length-prefixed JSON response
        String response = FramedUnixSocket.readMessage(channel);
        return parseFloatArray(response); // parse {"embedding": [0.1, 0.2, ...]}
    }

    @Override
    public void close() throws Exception { channel.close(); }

    private float[] parseFloatArray(String json) {
        // ... JSON parsing ...
        return new float[0];
    }
}

// Python side (for reference):
// import socket, json
// sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
// sock.bind('/tmp/ml-model.sock')
// sock.listen(10)
// while True:
//     conn, _ = sock.accept()
//     data = receive_framed(conn)
//     result = model.predict(json.loads(data))
//     send_framed(conn, json.dumps({"embedding": result.tolist()}))
```

### 10.2 Worker Pool IPC

```java
/**
 * Parent process dispatches work to child worker processes via UDS
 * Pattern: one socket file per worker
 */
public class WorkerDispatcher {
    private final List<UnixSocketConnectionPool> workers = new ArrayList<>();

    public void startWorkers(int count) throws Exception {
        for (int i = 0; i < count; i++) {
            Path socketPath = Path.of("/tmp/worker-" + i + ".sock");
            // Start worker process
            new ProcessBuilder("java", "-cp", ".", "Worker", socketPath.toString())
                .start();
            // Connect to it
            Thread.sleep(100); // wait for worker to bind
            workers.add(new UnixSocketConnectionPool(socketPath, 2));
        }
    }

    public String dispatch(String task) throws Exception {
        // Simple round-robin
        int idx = (int)(Math.random() * workers.size());
        return workers.get(idx).send(task);
    }
}
```

### 10.3 Control Socket (Admin Interface)

A common pattern for server processes: expose a control socket for admin commands (reload config, get stats, flush cache) — separate from the main request-serving socket:

```java
/**
 * Admin control socket: allows ops to interact with the running server
 * without using the production request socket
 */
public class AdminControlSocket {
    private static final Path CONTROL_SOCKET = Path.of("/var/run/myapp/admin.sock");

    public void startAdminListener() throws Exception {
        Files.deleteIfExists(CONTROL_SOCKET);

        try (ServerSocketChannel server =
                ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
            server.bind(UnixDomainSocketAddress.of(CONTROL_SOCKET));

            // Restrict to root only
            Files.setPosixFilePermissions(CONTROL_SOCKET,
                PosixFilePermissions.fromString("rw-------"));

            while (true) {
                try (SocketChannel admin = server.accept()) {
                    ByteBuffer buf = ByteBuffer.allocate(256);
                    int n = admin.read(buf);
                    if (n <= 0) continue;
                    buf.flip();
                    String command = new String(buf.array(), 0, buf.limit()).trim();

                    String result = switch (command) {
                        case "stats"   -> getStats();
                        case "reload"  -> { reloadConfig(); yield "OK"; }
                        case "flush"   -> { flushCache(); yield "OK"; }
                        case "threads" -> getThreadInfo();
                        default        -> "UNKNOWN COMMAND: " + command;
                    };

                    admin.write(ByteBuffer.wrap((result + "\n").getBytes()));
                }
            }
        } finally {
            Files.deleteIfExists(CONTROL_SOCKET);
        }
    }

    // Usage from command line:
    // echo "stats" | nc -U /var/run/myapp/admin.sock
    // OR:
    // socat - UNIX-CONNECT:/var/run/myapp/admin.sock
}
```

### 10.4 Health Check Endpoint via UDS

```java
/**
 * Kubernetes / systemd health check via Unix Domain Socket
 * Lighter than HTTP for in-container health checks
 */
public class HealthCheckSocket {
    private static final Path HEALTH_SOCKET = Path.of("/tmp/health.sock");

    public void start() throws Exception {
        Files.deleteIfExists(HEALTH_SOCKET);

        // Run health socket in a background daemon thread
        Thread.ofVirtual().name("health-check").start(() -> {
            try (ServerSocketChannel server =
                    ServerSocketChannel.open(StandardProtocolFamily.UNIX)) {
                server.bind(UnixDomainSocketAddress.of(HEALTH_SOCKET));

                while (true) {
                    try (SocketChannel client = server.accept()) {
                        String status = isHealthy() ? "OK" : "FAIL";
                        client.write(ByteBuffer.wrap(status.getBytes()));
                    }
                }
            } catch (Exception e) {
                System.err.println("Health socket error: " + e);
            }
        });
    }

    private boolean isHealthy() {
        // Check DB connection, thread pool, etc.
        return true;
    }
}

// Dockerfile health check:
// HEALTHCHECK CMD sh -c 'echo "" | nc -U /tmp/health.sock | grep -q OK'
```

---

## 11. Platform Considerations

### 11.1 OS Support Matrix

| Platform | Support | Notes |
|---|---|---|
| **Linux** | ✅ Full | Best support, abstract namespace, SO_PEERCRED |
| **macOS** | ✅ Full | Works well, 104-byte path limit |
| **Windows 10+** (build 17063+) | ✅ Supported | No POSIX permissions, use ACLs |
| **Windows < 17063** | ❌ Not supported | Falls back to TCP |
| **Solaris/AIX** | ✅ Usually | Platform-specific, test needed |
| **Docker (Linux container)** | ✅ Full | Can bind-mount socket files |

### 11.2 Detecting Platform Support at Runtime

```java
public static boolean isUnixDomainSocketSupported() {
    try {
        SocketChannel.open(StandardProtocolFamily.UNIX).close();
        return true;
    } catch (UnsupportedOperationException e) {
        return false; // platform doesn't support it
    } catch (IOException e) {
        return true; // other IOE is fine — open succeeded
    }
}

// Usage: graceful fallback to TCP when UDS not available
public SocketAddress getAddress() {
    if (isUnixDomainSocketSupported()) {
        return UnixDomainSocketAddress.of("/tmp/myapp.sock");
    } else {
        return new InetSocketAddress("127.0.0.1", 8080); // TCP fallback
    }
}
```

### 11.3 Windows-Specific Notes

```java
// Windows: socket files appear as regular files in the filesystem
// but do NOT support POSIX permissions (setPosixFilePermissions throws)
// Use Windows ACLs for access control:

import java.nio.file.attribute.*;

Path socketPath = Path.of("C:\\ProgramData\\myapp\\app.sock");

// On Windows, use AclFileAttributeView instead of PosixFileAttributeView
AclFileAttributeView view = Files.getFileAttributeView(
    socketPath, AclFileAttributeView.class);
// ... configure ACL entries ...

// Path separators on Windows: use forward slashes or Path.of()
Path.of("C:/ProgramData/myapp/app.sock") // works cross-platform
```

### 11.4 Docker and Kubernetes

```yaml
# Kubernetes: mount a socket from host into pod
# (e.g., Docker socket, Vault agent socket)
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    volumeMounts:
    - name: socket
      mountPath: /tmp/shared.sock  # inside container
  volumes:
  - name: socket
    hostPath:
      path: /var/run/myapp/shared.sock  # on host node

# Sidecar pattern: two containers sharing a socket via emptyDir volume
  volumes:
  - name: ipc-socket
    emptyDir: {}
  containers:
  - name: java-app
    volumeMounts:
    - name: ipc-socket
      mountPath: /tmp/ipc
  - name: sidecar
    volumeMounts:
    - name: ipc-socket
      mountPath: /tmp/ipc
# java-app writes to /tmp/ipc/app.sock, sidecar reads from same path
```

### 11.5 Path Length Limits

```java
// Linux:  108 bytes maximum (including null terminator)
// macOS:  104 bytes maximum

// Test your paths:
String path = "/tmp/myapp/worker.sock";
byte[] pathBytes = path.getBytes(StandardCharsets.UTF_8);
if (pathBytes.length >= 108) {  // use 104 for macOS compatibility
    throw new IllegalArgumentException(
        "Socket path too long: " + pathBytes.length + " bytes (max 107)");
}
```

---

## 12. Quick Reference Cheat Sheet

### Core Setup

```java
// Address
UnixDomainSocketAddress addr = UnixDomainSocketAddress.of("/tmp/app.sock");
UnixDomainSocketAddress addr = UnixDomainSocketAddress.of(Path.of("/tmp/app.sock"));
Path path = addr.getPath();

// Server
Files.deleteIfExists(socketPath);
ServerSocketChannel server = ServerSocketChannel.open(StandardProtocolFamily.UNIX);
server.bind(addr);
SocketChannel client = server.accept(); // blocks

// Client
SocketChannel channel = SocketChannel.open(StandardProtocolFamily.UNIX);
channel.connect(addr);

// Non-blocking
server.configureBlocking(false);
channel.configureBlocking(false);
// Register with Selector for OP_ACCEPT / OP_READ / OP_WRITE
```

### I/O Pattern

```java
// Write (loop until buffer empty — write may be partial)
ByteBuffer buf = ByteBuffer.wrap(data);
while (buf.hasRemaining()) channel.write(buf);

// Read (loop until full message received — use framing!)
ByteBuffer buf = ByteBuffer.allocate(size);
while (buf.hasRemaining()) {
    int n = channel.read(buf);
    if (n == -1) throw new EOFException();
}
buf.flip();
```

### Lifecycle

```java
// Always: delete before bind, delete on exit
Files.deleteIfExists(socketPath);
try (ServerSocketChannel server = ...) {
    server.bind(addr);
    Runtime.getRuntime().addShutdownHook(new Thread(() ->
        Files.deleteIfExists(socketPath)));
    // ... serve ...
} finally {
    Files.deleteIfExists(socketPath);
}
```

### Permissions (Unix)

```java
Files.setPosixFilePermissions(socketPath,
    PosixFilePermissions.fromString("rw-------")); // owner only
```

### Performance vs TCP Loopback

| Metric | TCP Loopback | Unix Domain Socket |
|---|---|---|
| Avg latency | ~62µs | ~12µs (~5× faster) |
| Throughput | ~8 GB/s | ~12 GB/s |
| Port needed | Yes | No |
| TIME_WAIT | Yes | No |
| Network-reachable | Potentially | Never |

### Key Rules to Remember

1. **Always delete the socket file before binding** — stale files from crashes cause `BindException`.
2. **Always delete on exit** — use shutdown hooks and `try-finally` to clean up.
3. **Permissions are your security model** — use `rw-------` for private sockets.
4. **No network exposure** — UDS is physically impossible to reach from another machine.
5. **Use framing** — raw `read()`/`write()` may be partial; length-prefix or delimiter is required.
6. **`StandardProtocolFamily.UNIX`** — must pass this when opening `SocketChannel`/`ServerSocketChannel`.
7. **Path length limit** — 107 bytes on Linux, 103 bytes on macOS.
8. **Windows needs 17063+** — check at runtime with a try/catch if cross-platform support is needed.
9. **UDS is faster for many small messages** — throughput advantage is smaller for large payloads.
10. **Socket files in `/tmp` are world-listable** — use `/var/run/yourapp/` + restrictive permissions for production.

---

*End of Unix Domain Sockets Study Guide — JEP 380 (Java 16)*
