# Java Networking & HTTP - Curriculum

## Module 1: Socket Programming
- [ ] TCP sockets: `Socket` and `ServerSocket`
- [ ] Client-server communication model
- [ ] Multi-threaded server (thread-per-connection)
- [ ] `InputStream` / `OutputStream` over sockets
- [ ] UDP sockets: `DatagramSocket` and `DatagramPacket`
- [ ] Socket timeouts and connection management
- [ ] Non-blocking I/O with `SocketChannel` (NIO)
- [ ] **Unix Domain Sockets** (Java 16+): `UnixDomainSocketAddress` - faster IPC than TCP loopback
- [ ] Use cases: communicating with Docker daemon, local database connections, microservice sidecar

## Module 2: Java NIO (Non-Blocking I/O)
- [ ] `Channel` and `Buffer` architecture
- [ ] `ByteBuffer`: allocate, flip, clear, compact
- [ ] `Selector` - multiplexing multiple channels on single thread
- [ ] `SelectionKey` - interest ops (OP_READ, OP_WRITE, OP_ACCEPT, OP_CONNECT)
- [ ] Building a non-blocking server with NIO
- [ ] NIO vs traditional I/O: when to use which
- [ ] `AsynchronousSocketChannel` (NIO.2) - callback-based async I/O

## Module 3: HTTP Client (Java 11+)
- [ ] `HttpClient` - modern HTTP client (replaces `HttpURLConnection`)
- [ ] `HttpRequest` builder: GET, POST, PUT, DELETE
- [ ] `HttpResponse` and `BodyHandlers` (string, byte[], inputStream, file)
- [ ] Synchronous: `client.send(request, handler)`
- [ ] Asynchronous: `client.sendAsync(request, handler)` → `CompletableFuture`
- [ ] Request headers, timeouts, redirects
- [ ] HTTP/2 support and server push
- [ ] Sending JSON with `HttpRequest.BodyPublishers.ofString()`
- [ ] File upload with multipart
- [ ] **HTTP/3 & QUIC** awareness: UDP-based transport, 0-RTT connection, built-in TLS 1.3
- [ ] Java's HTTP/3 status: no built-in support yet, third-party options (Netty, Jetty)

## Module 4: WebSocket
- [ ] WebSocket protocol: full-duplex over single TCP connection
- [ ] Java WebSocket API (`java.net.http.WebSocket`)
- [ ] `WebSocket.Builder` and `WebSocket.Listener`
- [ ] `onOpen`, `onText`, `onBinary`, `onClose`, `onError`
- [ ] Sending and receiving messages
- [ ] Use cases: real-time chat, live updates, notifications

## Module 5: TLS/SSL & Security
- [ ] HTTPS: TLS handshake overview
- [ ] `SSLContext` and `SSLSocketFactory`
- [ ] Trust stores and key stores (`keytool`)
- [ ] Self-signed certificates for development
- [ ] Mutual TLS (mTLS) - client certificate authentication
- [ ] Certificate pinning
- [ ] `HttpClient` with custom `SSLContext`

## Module 6: URL & URI Handling
- [ ] `URL` vs `URI` classes
- [ ] URL parsing: protocol, host, port, path, query
- [ ] URL encoding/decoding (`URLEncoder`, `URLDecoder`)
- [ ] `HttpURLConnection` (legacy) - why to avoid
- [ ] DNS resolution: `InetAddress`, `InetSocketAddress`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a multi-threaded echo server/client |
| Module 2 | Build a non-blocking chat server with NIO Selector |
| Module 3 | REST API client consuming a public API (GitHub, weather) |
| Module 4 | Real-time notification system with WebSocket |
| Module 5 | Configure mTLS between two Java services |

## Key Resources
- Java Networking documentation (Oracle)
- Java NIO - Ron Hitchens
- JEP 321: HTTP Client API
