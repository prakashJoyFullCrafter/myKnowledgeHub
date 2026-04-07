# HTTP/3 & QUIC — Complete Study Guide for Java Developers

> **Protocol Awareness + Java Ecosystem Status | Brutally Detailed Reference**
> Covers QUIC transport mechanics, HTTP/3 framing, 0-RTT connection establishment, built-in TLS 1.3, the problems solved over HTTP/2, Java's current HTTP/3 status, and third-party options (Netty, Jetty, others). Every section includes architecture diagrams, real-world context, and Java-specific guidance.

---

## Table of Contents

1. [Why HTTP/3 Exists — Problems with HTTP/1.1 and HTTP/2](#1-why-http3-exists--problems-with-http11-and-http2)
2. [QUIC — The UDP-Based Transport](#2-quic--the-udp-based-transport)
3. [0-RTT Connection Establishment](#3-0-rtt-connection-establishment)
4. [Built-In TLS 1.3](#4-built-in-tls-13)
5. [HTTP/3 Over QUIC — Framing and Streams](#5-http3-over-quic--framing-and-streams)
6. [Protocol Evolution Summary](#6-protocol-evolution-summary)
7. [Java's HTTP/3 Status — No Built-In Support Yet](#7-javas-http3-status--no-built-in-support-yet)
8. [Third-Party Options — Netty, Jetty, and Others](#8-third-party-options--netty-jetty-and-others)
9. [Deployment and Infrastructure Considerations](#9-deployment-and-infrastructure-considerations)
10. [When HTTP/3 Matters (and When It Doesn't)](#10-when-http3-matters-and-when-it-doesnt)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. Why HTTP/3 Exists — Problems with HTTP/1.1 and HTTP/2

### 1.1 HTTP/1.1 — Sequential Requests

HTTP/1.1 over TCP processes requests sequentially on a single connection. Browsers worked around this by opening **6 parallel TCP connections** per origin:

```
TCP Connection 1:  GET /style.css   ──────► response
TCP Connection 2:  GET /script.js   ──────► response
TCP Connection 3:  GET /image1.jpg  ──────► response
TCP Connection 4:  GET /image2.jpg  ──────► response
TCP Connection 5:  GET /font.woff2  ──────► response
TCP Connection 6:  (waiting)

Problems:
- 6 × TCP handshake overhead
- 6 × TLS handshake overhead
- Head-of-line blocking within each connection
- Server push impossible
```

### 1.2 HTTP/2 — Multiplexing (But Still TCP)

HTTP/2 introduced **multiplexing**: multiple request/response pairs (streams) over a single TCP connection. A single TCP connection replaces the 6 parallel connections:

```
Single TCP Connection (HTTP/2):

Stream 1: GET /style.css   ──► [frame][frame]──► response
Stream 2: GET /script.js   ──► [frame][frame]──► response
Stream 3: GET /image1.jpg  ──► [frame][frame]──► response
Stream 4: GET /font.woff2  ──► [frame]──────────► response

Better than HTTP/1.1:
✓ One TCP + TLS handshake for all requests
✓ No artificial 6-connection limit
✓ Header compression (HPACK)
✓ Server push
✓ Stream prioritization
```

**But HTTP/2 introduced a new problem: TCP Head-of-Line Blocking.**

### 1.3 The TCP Head-of-Line Blocking Problem

TCP guarantees **ordered, reliable delivery** at the byte-stream level. When a packet is lost, TCP must retransmit it and **hold all subsequent data** until the gap is filled — even if that data belongs to completely unrelated HTTP/2 streams:

```
HTTP/2 over TCP — Packet Loss Scenario:

Network:  [Stream1-data][Stream2-data][LOST PKT][Stream3-data][Stream4-data]
                                           │
                          TCP detects gap──┘
                          BLOCKS ALL streams!

TCP receive buffer:
  Stream1: ████████ (waiting for LOST PKT to be retransmitted)
  Stream2: ████████ (waiting — even though its data arrived fine!)
  Stream3: ████████ (waiting — even though its data arrived fine!)
  Stream4: ████████ (waiting — even though its data arrived fine!)

Result: 2% packet loss can cause ALL HTTP/2 streams to stall
        In lossy networks (mobile, satellite, congested WiFi): severe degradation
```

This is worse than HTTP/1.1 with 6 connections! A packet loss on one TCP connection blocks 1/6 of requests. A packet loss on HTTP/2's single TCP connection blocks ALL requests.

### 1.4 The TLS Handshake Latency Problem

Every new connection requires round trips before any application data flows:

```
TCP + TLS 1.2 handshake:
  Client ──SYN──────────────────────► Server        RTT 0
  Client ◄──SYN-ACK─────────────────  Server
  Client ──ACK + TLS ClientHello────► Server        RTT 1
  Client ◄──TLS ServerHello──────────  Server
  Client ──TLS ClientKeyExchange────► Server        RTT 2
  Client ◄──TLS Finished─────────────  Server
  Client ──GET /page────────────────► Server        RTT 3
                                                    ← 3 RTTs before first byte
TCP + TLS 1.3:
  Client ──SYN──────────────────────► Server        RTT 0
  Client ◄──SYN-ACK─────────────────  Server
  Client ──TLS ClientHello──────────► Server        RTT 1
  Client ◄──TLS ServerHello─────────  Server
  Client ──GET /page (with Finished)► Server        RTT 2
                                                    ← 2 RTTs before first byte
QUIC (1-RTT, first connection):
  Client ──Initial + ClientHello────► Server        RTT 0
  Client ◄──Handshake + ServerHello─  Server
  Client ──GET /page ───────────────► Server        RTT 1
                                                    ← 1 RTT before first byte
QUIC (0-RTT, resumed connection):
  Client ──0-RTT + GET /page────────► Server        RTT 0
  (first byte sent with connection)                 ← 0 additional RTTs!
```

---

## 2. QUIC — The UDP-Based Transport

### 2.1 QUIC Is Not "TCP Over UDP"

QUIC is a completely new transport protocol designed from scratch, implemented in **user space** and running over UDP. It reimplements everything TCP provides (reliability, ordering, congestion control, flow control) but at the **stream level**, not the connection level:

```
Protocol Stack Comparison:

HTTP/1.1 & HTTP/2:          HTTP/3:
┌──────────────────┐        ┌──────────────────┐
│ HTTP (app layer) │        │ HTTP/3           │
├──────────────────┤        ├──────────────────┤
│ TLS (security)   │        │ QUIC             │  ← TLS 1.3 is BUILT IN
├──────────────────┤        │ (includes TLS)   │
│ TCP (transport)  │        ├──────────────────┤
├──────────────────┤        │ UDP (thin layer) │  ← just packet delivery
├──────────────────┤        ├──────────────────┤
│ IP               │        │ IP               │
└──────────────────┘        └──────────────────┘
```

### 2.2 Why UDP?

TCP's design is baked into the **operating system kernel**. Adding new features (like per-stream ordering) would require changes to every OS kernel in the world and years of deployment.

UDP is just "send a packet, best effort." By running over UDP, QUIC can be:
- **Updated without OS kernel changes** — it's user-space code
- **Deployed quickly** — just update the library
- **Customized per-application** — different apps can tune QUIC differently

```
TCP modifications require:
  Linux kernel PR → review → merge → stable release → distro package → deployment
  Timeline: years

QUIC modifications require:
  Update the user-space QUIC library
  Timeline: days to weeks
```

### 2.3 QUIC Solves TCP Head-of-Line Blocking

QUIC multiplexes independent streams with **per-stream reliability**. A lost packet only blocks the stream that data belongs to — other streams continue unaffected:

```
HTTP/3 over QUIC — Same Packet Loss Scenario:

Network:  [Stream1-data][Stream2-data][LOST PKT][Stream3-data][Stream4-data]
                                           │
                          QUIC detects gap──┘
                          Only Stream2 pauses! (the lost packet was Stream2 data)

QUIC stream delivery:
  Stream1: ████████ → delivered immediately ✓
  Stream2: ████████ → waiting for retransmit (its packet was lost)
  Stream3: ████████ → delivered immediately ✓ (not blocked!)
  Stream4: ████████ → delivered immediately ✓ (not blocked!)

Result: Only the stream with the lost packet stalls
        All other streams continue at full speed
```

### 2.4 Connection Migration

QUIC connections are identified by a **Connection ID** (a random token), not by the IP:port 4-tuple like TCP. This enables **connection migration**:

```
Scenario: Mobile user switches from WiFi to cellular mid-download

TCP:
  WiFi  IP:port ──► Server
  (switch to cellular)
  New   IP:port ──► Server  ← TCP sees this as a NEW connection!
                              Must complete 3-way handshake again
                              Download restarts or fails

QUIC:
  Connection ID: ABC123
  WiFi  IP:port, CID=ABC123 ──► Server
  (switch to cellular)
  New   IP:port, CID=ABC123 ──► Server  ← Same connection! Continues seamlessly
                                          No handshake needed
                                          Download continues from where it left off
```

This is critical for mobile applications where network transitions are frequent.

### 2.5 QUIC Packet Structure

A QUIC packet contains:
- Connection ID
- Packet number (per-path, not global like TCP sequence numbers)
- Frames (data frames, ACK frames, STREAM frames, CRYPTO frames, etc.)
- Authentication tag (all QUIC packets are authenticated)

```
QUIC Packet (simplified):
┌──────────────────────────────────────────────────────────┐
│ Header                                                    │
│  ├── Packet Type (Initial / Handshake / 1-RTT / etc.)    │
│  ├── Connection ID                                       │
│  └── Packet Number                                       │
├──────────────────────────────────────────────────────────┤
│ Payload (one or more frames):                            │
│  ├── STREAM frame: stream_id=3, offset=0, data=[...]     │
│  ├── STREAM frame: stream_id=7, offset=512, data=[...]   │
│  └── ACK frame: ack_ranges=[1-15, 17-23]                 │
├──────────────────────────────────────────────────────────┤
│ AEAD Authentication Tag (16 bytes)                       │
└──────────────────────────────────────────────────────────┘
```

---

## 3. 0-RTT Connection Establishment

### 3.1 How 0-RTT Works

QUIC supports **resuming connections** with zero additional round trips. When a client has previously connected to a server, the server provides a **session ticket** (containing pre-shared key material). On the next connection, the client can send application data (HTTP requests) in the **very first packet**:

```
QUIC 0-RTT Resumption:

Client (has session ticket)          Server

──── QUIC Initial + 0-RTT data ────►
     ├── Connection setup            ├── Server decrypts 0-RTT data
     ├── TLS ClientHello             ├── Processes request IMMEDIATELY
     └── HTTP GET /page (0-RTT)      └── starts preparing response

◄─── QUIC Handshake + Response ─────
     ├── TLS ServerHello             
     ├── Complete TLS handshake      
     └── HTTP response               

──── Handshake Complete ────────────►

Total: 0 RTTs of extra latency before receiving response data
       (the request flew with the connection setup)
```

### 3.2 0-RTT Security Trade-offs

0-RTT has an important security limitation: **replay attacks**.

```
Replay Attack on 0-RTT:

Attacker intercepts 0-RTT packet containing:
  POST /transfer-money  {"amount": 1000, "to": "attacker"}

Attacker replays this packet multiple times:
  → Server processes POST 3 times → $3000 transferred!

Root cause: 0-RTT data is encrypted with a pre-shared key from a previous session.
            The server cannot distinguish the original packet from replays
            (packet number anti-replay only works within a session).
```

**Therefore:**

```
✅ Safe for 0-RTT:
   GET requests (read-only, idempotent)
   Idempotent PUT requests
   Requests that are naturally safe to replay

❌ Not safe for 0-RTT:
   POST requests with side effects (payments, submissions)
   DELETE requests
   Any non-idempotent operation

HTTP/3 specification: servers MUST reject 0-RTT data for non-idempotent methods
                      OR applications must be designed to be replay-safe.
```

### 3.3 0-RTT at the QUIC Layer vs Application Layer

```java
// At the application level: you don't directly control 0-RTT
// The QUIC library handles it transparently
// What you CAN do: configure it in your Netty/Jetty/Quiche setup

// Netty QUIC example (conceptual):
QuicSslContext sslContext = QuicSslContextBuilder.forClient()
    .sessionCacheSize(100)           // cache session tickets for 100 servers
    .sessionTimeout(3600)            // cache for 1 hour
    .earlyData()                     // enable 0-RTT (early data)
    .build();

// For servers: indicate which requests are safe for 0-RTT
// HTTP/3 server implementations accept or reject early data
// based on the request method (GET = accept, POST = reject/retry)
```

---

## 4. Built-In TLS 1.3

### 4.1 TLS Is Part of QUIC, Not a Layer on Top

In HTTP/2, TLS sits as a separate layer between TCP and HTTP. In QUIC, **TLS 1.3 is woven into the QUIC handshake itself**. You cannot use QUIC without TLS — there is no option for unencrypted QUIC. There is no equivalent of HTTP (non-S) over QUIC.

```
HTTP/2:                         HTTP/3 / QUIC:
┌──────────┐                    ┌──────────────────────────┐
│ HTTP/2   │                    │ HTTP/3                   │
├──────────┤                    ├──────────────────────────┤
│ TLS 1.3  │ ← separate layer   │ QUIC                     │
├──────────┤                    │  ┌────────────────────┐  │
│ TCP      │                    │  │ TLS 1.3 (built in) │  │
└──────────┘                    │  └────────────────────┘  │
                                ├──────────────────────────┤
                                │ UDP                      │
                                └──────────────────────────┘

Result: All QUIC traffic is always encrypted. Always.
        Certificate verification, ALPN negotiation, key exchange
        all happen as part of the QUIC handshake.
```

### 4.2 Advantages of Integrated TLS 1.3

**1. Fewer Round Trips (Combined Handshake)**

```
TCP + TLS 1.3 (separate):
  RTT 0: TCP SYN / SYN-ACK
  RTT 1: TLS ClientHello / ServerHello (now on established TCP)
  RTT 2: Application data
  Total: 2 RTTs to first application data

QUIC (combined):
  RTT 0: QUIC Initial (includes TLS ClientHello in CRYPTO frame)
          Server responds with TLS ServerHello in same handshake
  RTT 1: Application data (1-RTT) OR 0-RTT with cached session
  Total: 1 RTT to first application data (0 with resumption)
```

**2. Encrypted Packet Numbers**

In TCP+TLS, TCP headers (including sequence numbers) are sent in cleartext. An attacker can observe flow patterns even without decrypting data. QUIC encrypts most of its header including packet numbers, making traffic analysis harder.

**3. Forward Secrecy by Design**

TLS 1.3 (and therefore all QUIC connections) uses **ephemeral key exchange** (ECDHE only). There are no static RSA key exchange modes. This means past session recordings cannot be decrypted even if the server's private key is later compromised.

**4. ALPN Integration**

Application-Layer Protocol Negotiation happens inside the QUIC/TLS handshake:

```
QUIC ClientHello includes:
  ALPN extension: ["h3", "h3-29"]   ← "I speak HTTP/3"

Server responds with:
  ALPN: "h3"                        ← "Agreed, we'll use HTTP/3"

HTTP version negotiation happens before any data is sent.
```

---

## 5. HTTP/3 Over QUIC — Framing and Streams

### 5.1 QUIC Streams and HTTP/3

HTTP/3 runs over QUIC streams. Each HTTP request/response pair uses its own bidirectional QUIC stream:

```
QUIC Connection:
  ├── Stream 0 (bidir): HTTP GET /page     → HTTP response
  ├── Stream 4 (bidir): HTTP GET /style.css → HTTP response
  ├── Stream 8 (bidir): HTTP GET /api/data  → HTTP response
  ├── Stream 2 (unidir, server→client): QPACK encoder instructions
  ├── Stream 3 (unidir, client→server): QPACK decoder instructions
  └── Stream 6 (unidir, server→client): HTTP/3 control stream

Bidirectional streams: client requests + server responses
Unidirectional streams: HTTP/3 control frames, QPACK header compression
```

### 5.2 HTTP/3 Frame Types

HTTP/3 defines its own frame format (not the same as HTTP/2 frames):

```
HTTP/3 Frame structure:
┌──────────────────────────────────────────┐
│ Type (variable-length int)               │
│ Length (variable-length int)             │
│ Payload (length bytes)                   │
└──────────────────────────────────────────┘

Key frame types:
  DATA (0x0):     Request or response body
  HEADERS (0x1):  Request/response headers (QPACK compressed)
  CANCEL_PUSH (0x3): Cancel a server push
  SETTINGS (0x4): Connection-level settings (sent once on control stream)
  PUSH_PROMISE (0x5): Server push promise
  GOAWAY (0x7):   Graceful shutdown (like HTTP/2 GOAWAY)
```

### 5.3 QPACK — Header Compression

HTTP/2 uses HPACK for header compression, which maintains a **shared compression state** between request and response. This creates a head-of-line blocking problem for compression: if a header table update is lost, all future headers cannot be decoded.

HTTP/3 uses **QPACK** — a redesigned header compression scheme that works correctly over QUIC's independent streams:

```
HPACK (HTTP/2):                         QPACK (HTTP/3):
Shared dynamic table                    Dynamic table updates via
Updated with each request               separate unidirectional streams

If table update is lost:                If table update is lost:
→ ALL future headers blocked            → Only that update stream stalls
  (HOL blocking at header level)          Headers using static table or
                                          known entries continue flowing
```

### 5.4 HTTP Version Discovery — Alt-Svc Header

Browsers and clients don't know in advance if a server supports HTTP/3. The discovery mechanism uses the `Alt-Svc` (Alternative Services) HTTP header:

```
Client first connects via HTTP/2 (or HTTP/1.1):
  GET https://example.com/

Server responds:
  HTTP/2 200 OK
  Alt-Svc: h3=":443"; ma=86400
           ↑   ↑           ↑
           │   │           └── max-age: remember this for 24 hours
           │   └── on port 443
           └── HTTP/3 (QUIC) is available

Client (next request):
  "I know this server supports HTTP/3 on port 443"
  → Uses QUIC/HTTP/3 instead!
```

```
Also communicated via DNS HTTPS record (faster, no first HTTP/2 round trip needed):
  _https._tcp.example.com HTTPS 1 . alpn="h3,h2" ...
  → Client knows HTTP/3 is available before making ANY connection
```

---

## 6. Protocol Evolution Summary

```
Protocol   Year   Transport   Encryption    Multiplexing    HOL Blocking
─────────────────────────────────────────────────────────────────────────
HTTP/1.0   1996   TCP         Optional      No              Per-connection
HTTP/1.1   1997   TCP         Optional      Pipelining(*)   Per-connection
HTTP/2     2015   TCP         Mandatory†    Yes (streams)   TCP-level ← problem
HTTP/3     2022   UDP/QUIC    Mandatory     Yes (streams)   None ✓

(*) Pipelining was rarely used due to implementation bugs and HOL blocking
(†) Required in practice though not in the spec — all browsers require TLS for HTTP/2
```

---

## 7. Java's HTTP/3 Status — No Built-In Support Yet

### 7.1 Current State (as of Java 24)

Java's built-in HTTP client (`java.net.http.HttpClient`, introduced in Java 11) does **not** support HTTP/3 or QUIC. There is no HTTP/3 support in the JDK standard library.

```java
// Java's HttpClient: HTTP/1.1 and HTTP/2 only
HttpClient client = HttpClient.newHttpClient();

HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://example.com"))
    .build();

HttpResponse<String> response = client.send(request,
    HttpResponse.BodyHandlers.ofString());

// The client negotiates HTTP/2 if the server supports it (via ALPN)
// But it will NEVER use HTTP/3 — QUIC is not implemented
System.out.println(response.version()); // HTTP_1_1 or HTTP_2, never HTTP_3
```

### 7.2 Why HTTP/3 Is Not in the JDK Yet

**1. QUIC requires a fundamentally different I/O model**

Java's existing `java.nio.channels` is built entirely around TCP and UDP sockets. QUIC's connection and stream management is significantly more complex than TCP and would require either:
- New kernel-level APIs (not available on all platforms)
- User-space QUIC implementation integrated into the JDK

**2. QUIC requires UDP at scale**

Many enterprise networks and load balancers still block or shape UDP traffic in ways that don't affect TCP. The operational picture for QUIC is still maturing.

**3. JEP track**

There is active work in the OpenJDK community, but as of Java 24, no finalized JEP has been accepted for HTTP/3 in the standard `HttpClient`. The situation is tracked in [JDK-8238798](https://bugs.openjdk.org/browse/JDK-8238798).

**4. TLS 1.3 integration complexity**

QUIC uses TLS 1.3 in a non-standard way (TLS crypto engine without the TLS record layer). Integrating this with JSSE (Java's TLS implementation) requires new internal APIs.

### 7.3 What Java's HttpClient CAN Do Today

```java
// HTTP/2 with connection coalescing (closest to HTTP/3 benefit)
HttpClient client = HttpClient.newBuilder()
    .version(HttpClient.Version.HTTP_2)    // prefer HTTP/2
    .build();

// HTTP/2 push promises (server push)
client.sendAsync(request, HttpResponse.BodyHandlers.ofString(),
    pushPromiseHandler); // handle server push

// The ALPN negotiation to HTTP/2 happens transparently
// Multiple requests reuse the same HTTP/2 connection (multiplexing)
// BUT: still subject to TCP head-of-line blocking
```

---

## 8. Third-Party Options — Netty, Jetty, and Others

### 8.1 Netty — `netty-incubator-codec-quic`

Netty is the leading Java networking library for high-performance servers. It provides HTTP/3 support via the **netty-incubator-codec-quic** project, which wraps **quiche** (Cloudflare's Rust QUIC implementation) via JNI.

```xml
<!-- Maven dependency -->
<dependency>
    <groupId>io.netty.incubator</groupId>
    <artifactId>netty-incubator-codec-http3</artifactId>
    <version>0.0.28.Final</version>
</dependency>
```

**Netty HTTP/3 Server (conceptual structure):**

```java
import io.netty.incubator.codec.http3.*;
import io.netty.incubator.codec.quic.*;

public class NettyHttp3Server {

    public void start() throws Exception {
        // 1. Configure QUIC SSL context
        QuicSslContext sslContext = QuicSslContextBuilder.forServer(
                new File("cert.pem"), null, new File("key.pem"))
            .applicationProtocols("h3")    // ALPN: HTTP/3
            .build();

        // 2. Configure QUIC codec
        ChannelHandler codec = Http3.newQuicServerCodecBuilder()
            .sslContext(sslContext)
            .maxIdleTimeout(5000, TimeUnit.MILLISECONDS)
            .initialMaxData(10_000_000)
            .initialMaxStreamDataBidirectionalLocal(1_000_000)
            .initialMaxStreamDataBidirectionalRemote(1_000_000)
            .initialMaxStreamsBidirectional(100)
            .tokenHandler(InsecureQuicTokenHandler.INSTANCE) // not for production!
            .handler(new ChannelInitializer<QuicChannel>() {
                @Override
                protected void initChannel(QuicChannel ch) {
                    ch.pipeline().addLast(new Http3ServerConnectionHandler(
                        new ChannelInitializer<QuicStreamChannel>() {
                            @Override
                            protected void initChannel(QuicStreamChannel ch) {
                                ch.pipeline().addLast(new Http3RequestStreamInboundHandler() {
                                    @Override
                                    protected void channelRead(ChannelHandlerContext ctx,
                                            Http3HeadersFrame headersFrame, boolean isLast) {
                                        // Handle HTTP/3 request headers
                                        String path = headersFrame.headers().path().toString();

                                        // Send response
                                        Http3Headers headers = new DefaultHttp3Headers()
                                            .status("200")
                                            .add("content-type", "text/plain");
                                        ctx.write(new DefaultHttp3HeadersFrame(headers));
                                        ctx.writeAndFlush(new DefaultHttp3DataFrame(
                                            Unpooled.copiedBuffer("Hello HTTP/3!", UTF_8)));
                                        Http3.writeShutdown(ctx, QuicStreamChannel.SHUTDOWN_OUTPUT, 0);
                                    }
                                });
                            }
                        }
                    ));
                }
            })
            .build();

        // 3. Bootstrap on UDP port
        NioEventLoopGroup group = new NioEventLoopGroup(1);
        Bootstrap bs = new Bootstrap();
        bs.group(group)
          .channel(NioDatagramChannel.class)           // ← UDP, not TCP!
          .handler(codec);

        Channel channel = bs.bind(443).sync().channel();
        channel.closeFuture().sync();
    }
}
```

**Netty HTTP/3 Client:**

```java
QuicSslContext sslContext = QuicSslContextBuilder.forClient()
    .trustManager(InsecureTrustManagerFactory.INSTANCE) // not for production
    .applicationProtocols("h3")
    .build();

NioEventLoopGroup group = new NioEventLoopGroup(1);
Bootstrap bs = new Bootstrap()
    .group(group)
    .channel(NioDatagramChannel.class)
    .handler(new ChannelInitializer<Channel>() {
        @Override
        protected void initChannel(Channel ch) {
            ch.pipeline().addLast(
                Http3.newQuicClientCodecBuilder()
                    .sslContext(sslContext)
                    .maxIdleTimeout(5000, TimeUnit.MILLISECONDS)
                    .build());
        }
    });

Channel channel = bs.bind(0).sync().channel(); // bind to any local UDP port

// Connect
QuicChannelBootstrap quicBootstrap = QuicChannel.newBootstrap(channel)
    .streamHandler(new Http3ClientConnectionHandler())
    .remoteAddress(new InetSocketAddress("example.com", 443));

QuicChannel quicChannel = quicBootstrap.connect().get();
QuicStreamChannel streamChannel = Http3.newRequestStream(quicChannel,
    new Http3RequestStreamInboundHandler() { /* handle response */ }).get();

// Send request
Http3Headers headers = new DefaultHttp3Headers()
    .method("GET")
    .path("/")
    .scheme("https")
    .authority("example.com");
streamChannel.writeAndFlush(new DefaultHttp3HeadersFrame(headers));
Http3.writeShutdown(streamChannel, QuicStreamChannel.SHUTDOWN_OUTPUT, 0);
```

**Netty HTTP/3 characteristics:**
- Wraps quiche (Rust) via JNI — native performance
- Actively developed, used in production by major companies
- Lower-level API — requires significant boilerplate
- Suitable for building frameworks on top of, not direct application use

### 8.2 Eclipse Jetty — HTTP/3 Module

Jetty has native HTTP/3 support since Jetty 11/12. It uses a different QUIC implementation:

```xml
<dependency>
    <groupId>org.eclipse.jetty.http3</groupId>
    <artifactId>jetty-http3-server</artifactId>
    <version>12.0.9</version>
</dependency>
<dependency>
    <groupId>org.eclipse.jetty.http3</groupId>
    <artifactId>jetty-http3-client</artifactId>
    <version>12.0.9</version>
</dependency>
```

**Jetty HTTP/3 Server:**

```java
import org.eclipse.jetty.http3.server.*;
import org.eclipse.jetty.server.*;
import org.eclipse.jetty.servlet.*;
import org.eclipse.jetty.util.ssl.*;

public class JettyHttp3Server {

    public static void main(String[] args) throws Exception {
        Server server = new Server();

        // SSL/TLS configuration
        SslContextFactory.Server ssl = new SslContextFactory.Server();
        ssl.setKeyStorePath("keystore.p12");
        ssl.setKeyStorePassword("password");

        // HTTP/3 connector (UDP-based)
        HTTP3ServerConnector connector = new HTTP3ServerConnector(server, ssl,
            new HTTP3ServerConnectionFactory(new HttpConfiguration()));
        connector.setPort(8443);
        server.addConnector(connector);

        // Also add HTTP/2 connector (for Alt-Svc fallback)
        ServerConnector http2Connector = new ServerConnector(server,
            new HTTP2ServerConnectionFactory(new HttpConfiguration()));
        http2Connector.setPort(8080);
        server.addConnector(http2Connector);

        // Servlet handler
        ServletContextHandler context = new ServletContextHandler();
        context.addServlet(new ServletHolder(new HttpServlet() {
            @Override
            protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                    throws IOException {
                resp.setContentType("text/plain");
                resp.getWriter().println("Hello from Jetty HTTP/3!");
                // Add Alt-Svc header to advertise HTTP/3 to clients
                resp.addHeader("Alt-Svc", "h3=\":8443\"; ma=86400");
            }
        }), "/");
        server.setHandler(context);

        server.start();
        server.join();
    }
}
```

**Jetty HTTP/3 Client:**

```java
import org.eclipse.jetty.http3.client.*;
import org.eclipse.jetty.http3.client.transport.*;

HTTP3Client http3Client = new HTTP3Client();
http3Client.start();

HttpClient httpClient = new HttpClient(
    new HttpClientTransportDynamic(
        new ClientConnectionFactoryOverHTTP3.HTTP3(http3Client)
    )
);
httpClient.start();

// Use exactly like the regular Jetty HttpClient
ContentResponse response = httpClient
    .newRequest("https://example.com/api/data")
    .send();

System.out.println(response.getStatus());      // 200
System.out.println(response.getContentAsString());
```

**Jetty HTTP/3 characteristics:**
- Pure Java implementation of QUIC (no native dependencies)
- Integrates naturally with Jetty's servlet container
- `HttpClient` API hides HTTP/3 details behind familiar interface
- Good choice for Jetty-based applications

### 8.3 Vert.x — HTTP/3 Support

Vert.x (reactive toolkit) has HTTP/3 client support via its Netty integration:

```java
// Vert.x HTTP client with HTTP/3
HttpClientOptions options = new HttpClientOptions()
    .setUseAlpn(true)
    .setSsl(true)
    .setProtocolVersion(HttpVersion.HTTP_3); // HTTP_3 in Vert.x 5+

HttpClient client = vertx.createHttpClient(options);
client.request(HttpMethod.GET, 443, "example.com", "/")
    .compose(req -> req.send())
    .compose(response -> {
        System.out.println("Version: " + response.version());
        return response.body();
    })
    .onSuccess(body -> System.out.println(body));
```

### 8.4 gRPC over QUIC (HTTP/3 Transport)

gRPC currently uses HTTP/2 as its transport. Work is ongoing to support HTTP/3 as an alternative transport:

```java
// Standard gRPC (HTTP/2 today)
ManagedChannel channel = ManagedChannelBuilder
    .forAddress("api.example.com", 443)
    .build();
// gRPC over HTTP/3: not yet mainstream in grpc-java
// Watch: https://github.com/grpc/grpc-java for HTTP/3 transport support
```

### 8.5 Spring Boot and HTTP/3

Spring Boot 3.3+ has HTTP/3 support for embedded Tomcat and Jetty:

```java
// application.properties
server.http3.enabled=true
server.ssl.key-store=classpath:keystore.p12
server.ssl.key-store-password=password
server.port=8443

// application.yml
server:
  http3:
    enabled: true
  ssl:
    key-store: classpath:keystore.p12
    key-store-password: password
  port: 8443
```

```xml
<!-- pom.xml: Spring Boot + Jetty with HTTP/3 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <!-- Exclude Tomcat — Jetty has better HTTP/3 support -->
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jetty</artifactId>
</dependency>
```

### 8.6 Other QUIC Libraries for Java

| Library | Approach | Status | Notes |
|---|---|---|---|
| **Netty incubator QUIC** | Wraps quiche (Rust/JNI) | Active | Best performance |
| **Jetty HTTP/3** | Pure Java QUIC | Stable | Best servlet integration |
| **Vert.x** | Via Netty | Active | Reactive-friendly |
| **Quarkus** | Via Vert.x/Netty | Active | Cloud-native |
| **Kwik** | Pure Java QUIC | Research-grade | Academic use |
| **quic-java** | Pure Java | Experimental | Not production |

---

## 9. Deployment and Infrastructure Considerations

### 9.1 Load Balancers and Proxies

Most production Java applications sit behind a reverse proxy. The proxy handles HTTP/3 termination:

```
Internet                 Your Network
           QUIC/HTTP/3
Client ────────────────► Nginx/Caddy/HAProxy ──TCP/HTTP/2──► Java App
                         (terminates QUIC)      (backend)

This means:
- Your Java app doesn't need HTTP/3 support if the proxy handles it
- The proxy speaks QUIC to clients, HTTP/2 to your Java app
- Java App sees normal HTTP/2 connections
- Easiest path to HTTP/3 for most Java services!
```

**Nginx HTTP/3 configuration:**
```nginx
http {
    server {
        listen 443 quic reuseport;    # UDP for QUIC
        listen 443 ssl;               # TCP for HTTP/1.1 and HTTP/2

        ssl_certificate     cert.pem;
        ssl_certificate_key key.pem;
        ssl_protocols       TLSv1.3;  # QUIC requires TLS 1.3

        http3 on;
        http2 on;

        add_header Alt-Svc 'h3=":443"; ma=86400';  # advertise HTTP/3

        location / {
            proxy_pass http://java_backend:8080;   # HTTP/2 to Java
        }
    }
}
```

### 9.2 Firewall and UDP Port 443

A significant adoption challenge: **many corporate firewalls block UDP port 443**:

```
% of HTTP/3 connections that fail due to UDP blocking:
  Consumer internet: ~5-10%
  Corporate networks: ~20-30%
  Some enterprise networks: up to 50%

QUIC handles this via connection fallback:
  1. Try QUIC (UDP/443)
  2. If blocked: fall back to HTTP/2 (TCP/443) or HTTP/1.1
  3. Remember the failure and avoid QUIC for this server in future

Your Java service: if behind a proxy, this is transparent.
                   If direct HTTP/3: implement proper fallback.
```

### 9.3 Docker and Kubernetes

```yaml
# Kubernetes: expose UDP port for QUIC alongside TCP
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  ports:
  - name: https-tcp         # HTTP/2 and HTTP/1.1
    protocol: TCP
    port: 443
    targetPort: 8443
  - name: https-udp         # QUIC / HTTP/3
    protocol: UDP
    port: 443
    targetPort: 8443

# Note: Many Kubernetes ingress controllers do NOT support UDP
# Check your ingress controller's HTTP/3 support before relying on it
# ingress-nginx: HTTP/3 support added in recent versions
# Traefik: HTTP/3 experimental support
# Kong: HTTP/3 support via nginx
```

---

## 10. When HTTP/3 Matters (and When It Doesn't)

### 10.1 HTTP/3 Provides the Most Benefit When

```
1. Mobile / lossy networks
   - Packet loss is common (4G, 5G, WiFi hand-offs)
   - TCP HOL blocking is crippling on 2% packet loss
   - QUIC connection migration handles cell tower switches
   - Improvement: 20-50% reduction in page load time on bad networks

2. High-latency connections (satellite, distant CDN nodes)
   - 0-RTT saves 1-2 RTTs per new connection
   - On 100ms RTT: saves 200ms (noticeable)
   - On 1ms RTT (same datacenter): saves 1ms (negligible)

3. Many parallel resources (SPAs, media-heavy pages)
   - HTTP/2 was already good here, HTTP/3 eliminates residual HOL blocking
   - API endpoints called in parallel all complete independently

4. Long-lived connections that migrate
   - Mobile apps with keep-alive connections
   - Video streaming with network transitions
```

### 10.2 HTTP/3 Provides Little Benefit When

```
1. Server-to-server IPC on the same machine or same datacenter
   - Round-trip latency is < 1ms — QUIC's 1-RTT vs TCP's 2-RTT saves <1ms
   - Packet loss is essentially 0 — no HOL blocking in practice
   - Use Unix Domain Sockets or HTTP/2 instead

2. Behind a reverse proxy (for the Java app itself)
   - Your Java app speaks HTTP/2 to nginx, which speaks HTTP/3 to clients
   - Java app doesn't benefit from HTTP/3 at all
   - The proxy handles QUIC complexity

3. Batch processing / streaming large files
   - HTTP/3 advantage is latency reduction, not throughput
   - Large sequential transfers benefit little from 0-RTT

4. When your network is already perfect
   - No packet loss, low latency, stable connection
   - HTTP/2 and HTTP/3 perform similarly in ideal conditions
```

### 10.3 Should You Add HTTP/3 to Your Java Service Today?

```
Decision flowchart:

Is your service behind a reverse proxy (nginx, Caddy, HAProxy)?
  YES → Configure HTTP/3 on the proxy. Java app needs nothing.
         Done. Come back in 2 years when JDK support is stable.

Are your clients on mobile networks with potential packet loss?
  YES → Consider HTTP/3 on proxy or via Jetty/Spring Boot embedded.

Are your clients in the same datacenter as your Java service?
  YES → Don't bother. HTTP/2 is effectively equivalent.

Do you have hard latency SLAs for external users?
  YES, < 50ms budget → HTTP/3 with 0-RTT could help.
  NO (> 200ms budget) → HTTP/2 is fine.

Are you building a CDN, reverse proxy, or network-facing library?
  YES → Seriously evaluate Netty QUIC or Jetty HTTP/3 now.
  NO  → Wait for JDK built-in support.
```

---

## 11. Quick Reference Cheat Sheet

### Protocol Comparison

| Feature | HTTP/2 | HTTP/3 |
|---|---|---|
| Transport | TCP | QUIC (UDP) |
| Encryption | TLS (optional in spec, required by browsers) | TLS 1.3 (mandatory, built-in) |
| Multiplexing | Yes — TCP streams | Yes — QUIC streams |
| HOL blocking | TCP-level (packet loss blocks all streams) | None — per-stream reliability |
| Handshake | 2 RTTs (TCP+TLS) | 1 RTT (first) / 0 RTT (resumed) |
| Connection migration | No — tied to IP:port | Yes — via Connection ID |
| Header compression | HPACK | QPACK |
| Port | TCP 443 | UDP 443 |

### Java Support Summary

```
java.net.http.HttpClient (JDK built-in)
  HTTP/1.1: ✅  HTTP/2: ✅  HTTP/3: ❌ (not planned for near future)

Netty incubator-codec-http3
  Client: ✅  Server: ✅  Production-ready: ✅  Native JNI (quiche)

Eclipse Jetty 12
  Client: ✅  Server: ✅  Production-ready: ✅  Pure Java

Spring Boot 3.3+ (Jetty embedded)
  Server: ✅  Pure Java, config-based

Vert.x 5+
  Client: ✅  Server: ✅  Reactive API
```

### Key Concepts

```
QUIC            = UDP-based transport with per-stream reliability + built-in TLS 1.3
HTTP/3          = HTTP application layer running over QUIC streams
0-RTT           = Send request with the connection packet (resumptions only, replay risk)
1-RTT           = Normal new connection: 1 round trip to first response
HOL blocking    = TCP problem: one lost packet blocks ALL streams on the connection
Connection ID   = QUIC's connection identifier (not IP:port) enabling migration
ALPN            = TLS extension negotiating "h3" (HTTP/3) vs "h2" (HTTP/2)
Alt-Svc header  = Server tells client "I also support HTTP/3 on this port"
QPACK           = HTTP/3's header compression (replaces HPACK, no HOL blocking)
```

### When Each Option Makes Sense

| Scenario | Recommendation |
|---|---|
| Java app behind nginx/Caddy | Configure HTTP/3 on proxy — Java unchanged |
| Spring Boot embedded server | Spring Boot 3.3+ + Jetty module |
| High-performance server (framework building) | Netty incubator HTTP/3 |
| Jetty-based application | Jetty HTTP/3 module native integration |
| Internal microservices | Stick with HTTP/2 — marginal HTTP/3 benefit |
| Mobile-facing APIs | Proxy-based HTTP/3 or Jetty embedded |

### Key Rules to Remember

1. **HTTP/3 = QUIC + TLS 1.3** — inseparable. All HTTP/3 is always encrypted.
2. **QUIC runs over UDP** — firewalls that block UDP will block HTTP/3. Clients fall back to HTTP/2.
3. **Java JDK has no built-in HTTP/3** — `HttpClient` stops at HTTP/2.
4. **Reverse proxy is the easiest path** — let nginx/Caddy handle QUIC, Java speaks HTTP/2.
5. **0-RTT has replay risk** — safe for GET, dangerous for POST/DELETE without idempotency guarantee.
6. **Connection migration is QUIC-only** — critical advantage for mobile. Not possible with TCP.
7. **HOL blocking is eliminated at transport level** — packet loss affects only its own stream.
8. **Datacenter-to-datacenter: HTTP/3 adds little** — latency is already <1ms, packet loss ~0.
9. **Spring Boot 3.3+ makes HTTP/3 easy** — config-based, no networking code needed.
10. **UDP port 443 must be open** — check firewall rules; many enterprises block it.

---

*End of HTTP/3 & QUIC Study Guide — RFC 9000 (QUIC), RFC 9114 (HTTP/3)*
