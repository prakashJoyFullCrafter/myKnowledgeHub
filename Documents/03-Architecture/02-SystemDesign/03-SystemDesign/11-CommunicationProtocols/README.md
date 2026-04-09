# Communication Protocols - Curriculum

## Module 1: HTTP Versions
- [ ] **HTTP/1.1**: text-based, one request per TCP connection (or keep-alive pipelining)
  - [ ] Head-of-line blocking: one slow response blocks all behind it
- [ ] **HTTP/2**: binary framing, multiplexing (multiple streams on one connection)
  - [ ] Header compression (HPACK), server push, stream prioritization
  - [ ] Still TCP — head-of-line blocking at TCP level
- [ ] **HTTP/3 (QUIC)**: UDP-based, no TCP head-of-line blocking
  - [ ] 0-RTT connection establishment, built-in TLS 1.3
  - [ ] Independent streams — one stream's packet loss doesn't block others
- [ ] When to care: HTTP/2 is standard, HTTP/3 for latency-sensitive global apps

## Module 2: Request-Response Patterns
- [ ] **Short Polling**: client repeatedly requests server at intervals
  - [ ] Simple, wasteful (many empty responses), high latency
- [ ] **Long Polling**: client requests, server holds until data available or timeout
  - [ ] Lower latency than short polling, but still HTTP overhead per message
  - [ ] Used by: early chat systems, legacy real-time apps
- [ ] **Server-Sent Events (SSE)**: server pushes events over persistent HTTP connection
  - [ ] Unidirectional (server → client), auto-reconnect, simple
  - [ ] Use case: live feeds, notifications, dashboards
  - [ ] `Content-Type: text/event-stream`
- [ ] **WebSocket**: full-duplex bidirectional over single TCP connection
  - [ ] Starts as HTTP upgrade, then persistent binary/text frames
  - [ ] Use case: chat, gaming, collaborative editing, real-time trading
  - [ ] Higher complexity: connection management, scaling with load balancers

## Module 3: API Communication Styles
- [ ] **REST**: resource-oriented, HTTP methods, JSON, stateless
  - [ ] Best for: CRUD APIs, public APIs, browser clients
  - [ ] Limitations: over-fetching, under-fetching, multiple round trips
- [ ] **GraphQL**: client specifies exact fields needed, single endpoint
  - [ ] Best for: mobile apps (bandwidth-sensitive), BFF, complex nested data
  - [ ] Limitations: caching complexity, N+1 at resolver level, security (query depth)
- [ ] **gRPC**: HTTP/2, Protocol Buffers (binary), code generation, streaming
  - [ ] Best for: internal microservice communication, high throughput, polyglot
  - [ ] Limitations: not browser-friendly (needs grpc-web proxy), binary not human-readable
- [ ] **REST vs GraphQL vs gRPC** decision guide:
  - [ ] External/public API → REST
  - [ ] Frontend BFF → GraphQL
  - [ ] Internal service-to-service → gRPC

## Module 4: Synchronous vs Asynchronous
- [ ] **Synchronous** (REST, gRPC): caller waits for response
  - [ ] Simple, immediate feedback, easier debugging
  - [ ] Risk: cascading failures, tight coupling, latency accumulation
- [ ] **Asynchronous** (message queues, events): caller doesn't wait
  - [ ] Decoupled, resilient, handles spikes
  - [ ] Risk: eventual consistency, harder debugging, message ordering
- [ ] **Hybrid**: sync for queries, async for commands (CQRS style)
- [ ] When to go async: long-running tasks, fan-out, cross-service writes, spike absorption

## Module 5: Serialization Formats
- [ ] **JSON**: human-readable, universal, larger size
- [ ] **Protocol Buffers (Protobuf)**: binary, schema-defined, compact, fast — used by gRPC
- [ ] **Avro**: binary, schema evolution, used with Kafka Schema Registry
- [ ] **MessagePack**: binary JSON, compact, no schema needed
- [ ] **Thrift**: Facebook's RPC + serialization (largely replaced by gRPC/Protobuf)
- [ ] Comparison: JSON (simplicity) vs Protobuf (performance) vs Avro (schema evolution)
- [ ] Schema evolution: backward/forward compatibility, required vs optional fields

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Benchmark HTTP/1.1 vs HTTP/2 for loading a page with 50 assets |
| Module 2 | Implement same real-time notification: polling vs SSE vs WebSocket — compare resource usage |
| Module 3 | Build same API in REST, GraphQL, and gRPC — compare developer experience and performance |
| Module 4 | Design an order system: sync for order placement, async for payment + inventory + notification |
| Module 5 | Serialize 10K records as JSON vs Protobuf vs Avro — compare size and parse speed |

## Key Resources
- Designing Data-Intensive Applications - Martin Kleppmann (Chapter 4: Encoding)
- gRPC documentation (grpc.io)
- GraphQL specification (graphql.org)
- "HTTP/3 explained" - Daniel Stenberg (curl author)
- MDN Web Docs - HTTP, WebSocket, SSE
