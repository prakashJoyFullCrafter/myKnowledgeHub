# Spring REST API - Curriculum

## Module 1: RESTful API Design
- [ ] REST principles: resources, HTTP methods, status codes
- [ ] URI design best practices (`/api/v1/users/{id}`)
- [ ] `@RestController` = `@Controller` + `@ResponseBody`
- [ ] `ResponseEntity<T>` - full control over response (status, headers, body)
- [ ] Content negotiation (JSON, XML)

## Module 2: Request/Response Handling
- [ ] `@RequestBody` with Jackson serialization/deserialization
- [ ] `@JsonProperty`, `@JsonIgnore`, `@JsonFormat`
- [ ] `@JsonNaming` strategies (snake_case, camelCase)
- [ ] Custom serializers/deserializers
- [ ] DTOs vs Entities - why to separate
- [ ] MapStruct / ModelMapper for DTO mapping

## Module 3: Validation & Error Handling
- [ ] `@Valid` on `@RequestBody`
- [ ] Custom validation annotations
- [ ] Global exception handling with `@RestControllerAdvice`
- [ ] `@ExceptionHandler` for specific exceptions
- [ ] Problem Details (RFC 7807) - standardized error responses
- [ ] Custom error response structure

## Module 4: Pagination, Sorting & Filtering
- [ ] `Pageable` parameter in controllers
- [ ] HATEOAS pagination links
- [ ] Custom `PageResponse<T>` wrapper
- [ ] Sort parameters (`?sort=name,asc`)
- [ ] Filter strategies (query params, Specification pattern)

## Module 5: API Documentation
- [ ] SpringDoc OpenAPI (Swagger UI)
- [ ] `@Operation`, `@ApiResponse`, `@Schema` annotations
- [ ] Grouping APIs with tags
- [ ] Auto-generating API clients from spec

## Module 6: Versioning & HATEOAS
- [ ] Versioning strategies: URI, header, media type
- [ ] Spring HATEOAS - `EntityModel`, `CollectionModel`, `Link`
- [ ] `WebMvcLinkBuilder` for link generation
- [ ] HAL format

## Module 7: RestClient & WebClient
- [ ] `RestClient` (Spring 6.1+) - synchronous HTTP client
- [ ] `WebClient` (reactive) - non-blocking HTTP client
- [ ] `RestTemplate` (legacy) - why to migrate
- [ ] Request/response interceptors
- [ ] Error handling and retry

## Module 8: File Upload & Download
- [ ] `MultipartFile` - receiving file uploads
- [ ] `@RequestPart` - multipart with JSON + file in same request
- [ ] File size limits: `spring.servlet.multipart.max-file-size`, `max-request-size`
- [ ] Storing files: local filesystem, S3, database (BLOB)
- [ ] Streaming large files: `StreamingResponseBody` for download without loading into memory
- [ ] `Resource` return type for file download: `InputStreamResource`, `ByteArrayResource`
- [ ] Setting response headers: `Content-Disposition`, `Content-Type`, `Content-Length`
- [ ] File validation: type checking, size limits, virus scanning considerations
- [ ] Multipart upload to S3 with `AmazonS3Client` or `S3Template`

## Module 9: WebSocket with Spring
- [ ] WebSocket protocol: full-duplex over single TCP connection
- [ ] `spring-boot-starter-websocket` dependency
- [ ] **Raw WebSocket**:
  - [ ] `@EnableWebSocket` and `WebSocketConfigurer`
  - [ ] `WebSocketHandler` - handle connections, messages, errors
  - [ ] `WebSocketSession.sendMessage()` - push to client
- [ ] **STOMP over WebSocket** (recommended for most apps):
  - [ ] `@EnableWebSocketMessageBroker`
  - [ ] `@MessageMapping("/chat")` - receive messages from clients
  - [ ] `@SendTo("/topic/messages")` - broadcast to subscribers
  - [ ] `SimpMessagingTemplate` - send from anywhere (service layer, scheduled tasks)
  - [ ] `/topic` (pub-sub) vs `/queue` (point-to-point) destinations
- [ ] **User-specific messages**: `@SendToUser`, `convertAndSendToUser()`
- [ ] External broker: RabbitMQ / ActiveMQ as STOMP relay for multi-instance
- [ ] WebSocket security: authentication on CONNECT, authorization per destination
- [ ] SockJS fallback for browsers without WebSocket support
- [ ] Use cases: chat, live notifications, real-time dashboards, collaborative editing

## Module 10: gRPC with Spring
- [ ] gRPC overview: HTTP/2, Protocol Buffers, service definition
- [ ] Why gRPC? Performance, strong typing, streaming, code generation
- [ ] **Protocol Buffers** (`.proto` files):
  - [ ] Message definitions, field types, enums, nested messages
  - [ ] Service definitions: unary, server-streaming, client-streaming, bidirectional
  - [ ] `protoc` compiler for Java/Kotlin code generation
- [ ] **Spring Boot gRPC** (`spring-boot-starter-grpc`):
  - [ ] `@GrpcService` - expose gRPC service
  - [ ] `@GrpcClient` - consume gRPC service
  - [ ] Auto-configuration and server setup
- [ ] gRPC interceptors: authentication, logging, metrics
- [ ] Error handling: `Status` codes, `StatusRuntimeException`
- [ ] gRPC + Spring Security: token-based auth in metadata
- [ ] gRPC vs REST: when to use which
  - [ ] gRPC: internal service-to-service, high throughput, streaming
  - [ ] REST: external APIs, browser clients, simplicity
- [ ] gRPC reflection and health checks
- [ ] Testing gRPC services: `GrpcCleanupRule`, in-process server

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a REST API for a bookstore with DTOs |
| Module 3 | Add global error handling with RFC 7807 |
| Module 4 | Add pagination and filtering to list endpoints |
| Module 5 | Generate Swagger docs for all endpoints |
| Modules 6-7 | Add HATEOAS links + consume external API with RestClient |
| Module 8 | Add profile picture upload + document download to user API |
| Module 9 | Build real-time notification system with STOMP WebSocket |
| Module 10 | Build gRPC service for internal order-inventory communication |

## Key Resources
- Spring REST Documentation
- RESTful Web Services - Leonard Richardson
- RFC 7807 - Problem Details for HTTP APIs
- Spring WebSocket Reference Documentation
- gRPC official documentation (grpc.io)
- Protocol Buffers Language Guide
