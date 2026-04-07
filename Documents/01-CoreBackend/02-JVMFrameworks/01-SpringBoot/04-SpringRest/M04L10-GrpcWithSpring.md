# gRPC with Spring — Complete Study Guide

> **Module 10 | Brutally Detailed Reference**
> Covers Protocol Buffers, all four gRPC call types, Spring Boot gRPC setup, interceptors, error handling, security, gRPC vs REST, reflection, health checks, and testing. Every section includes `.proto` files, generated Java, and full working examples.

---

## Table of Contents

1. [gRPC Overview](#1-grpc-overview)
2. [Protocol Buffers — `.proto` Files](#2-protocol-buffers--proto-files)
3. [Service Definitions — All Four Call Types](#3-service-definitions--all-four-call-types)
4. [`protoc` Code Generation](#4-protoc-code-generation)
5. [Spring Boot gRPC Setup](#5-spring-boot-grpc-setup)
6. [`@GrpcService` — Exposing a gRPC Service](#6-grpcservice--exposing-a-grpc-service)
7. [`@GrpcClient` — Consuming a gRPC Service](#7-grpcclient--consuming-a-grpc-service)
8. [gRPC Interceptors — Auth, Logging, Metrics](#8-grpc-interceptors--auth-logging-metrics)
9. [Error Handling — `Status` Codes](#9-error-handling--status-codes)
10. [gRPC + Spring Security](#10-grpc--spring-security)
11. [gRPC vs REST](#11-grpc-vs-rest)
12. [gRPC Reflection and Health Checks](#12-grpc-reflection-and-health-checks)
13. [Testing gRPC Services](#13-testing-grpc-services)
14. [Quick Reference Cheat Sheet](#14-quick-reference-cheat-sheet)

---

## 1. gRPC Overview

### 1.1 What gRPC Is

gRPC (Google Remote Procedure Call) is a high-performance RPC framework that uses:
- **HTTP/2** as the transport (multiplexing, binary framing, header compression, streaming)
- **Protocol Buffers** (protobuf) as the serialization format (compact binary, strongly typed)
- **Code generation** from `.proto` service definitions (client stubs + server interfaces in any language)

```
REST/JSON call:
  POST /api/users HTTP/1.1
  Content-Type: application/json
  
  {"name":"Alice","email":"alice@example.com"}   ← verbose text

  → HTTP/1.1, text headers, JSON body (~50 bytes)

gRPC call:
  POST /com.myapp.UserService/CreateUser HTTP/2
  content-type: application/grpc
  grpc-encoding: gzip
  
  [binary protobuf: 12 bytes]   ← compact binary

  → HTTP/2, binary headers, protobuf body (~12 bytes) — 4× smaller
```

### 1.2 Why gRPC?

```
Performance:     Binary protobuf vs JSON — 3-10× smaller, faster to serialize/deserialize
HTTP/2:          Multiplexed streams, header compression, persistent connections
Strong typing:   .proto defines contract — type mismatch = compile error, not runtime error
Code generation: Client stubs auto-generated in Java, Go, Python, Ruby, C++, etc.
Streaming:       Server-streaming, client-streaming, bidirectional streaming (not possible with REST)
Cross-language:  Client in Python, server in Java — protocol is the contract

gRPC weaknesses:
  Not human-readable (binary)
  Not supported natively by browsers (requires gRPC-Web proxy)
  Harder to debug (need tooling like grpcurl, Postman gRPC)
  .proto schema must be shared/versioned
```

### 1.3 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    gRPC Call Flow                               │
│                                                                  │
│  Client (Java)          │          Server (Java/Go/Python)       │
│  ──────────────         │          ─────────────────────         │
│  Generated Stub         │          Generated Service Interface   │
│  userStub.getUser(req)  │          @GrpcService UserServiceImpl  │
│         │               │                  │                     │
│  Serialize to protobuf  │          Deserialize from protobuf     │
│         │               │                  │                     │
│  HTTP/2 POST ───────────┼──────────────────►                     │
│                         │  binary protobuf  │                    │
│  ◄──────────────────────┼───────────────────                     │
│  Deserialize response   │  HTTP/2 response                       │
│         │               │                                        │
│  UserResponse object    │                                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Protocol Buffers — `.proto` Files

### 2.1 Basic Message Definitions

```protobuf
// src/main/proto/user.proto
syntax = "proto3";    // always use proto3

package com.myapp.user;   // determines Java package path

// Options for Java code generation
option java_package = "com.myapp.grpc.user";
option java_outer_classname = "UserProto";
option java_multiple_files = true;    // one file per message (recommended)

// Basic message
message User {
  int64  id           = 1;    // field number (1-15 = 1 byte, 16-2047 = 2 bytes)
  string username     = 2;    // proto3 default: "" for string
  string email        = 3;
  bool   active       = 4;    // default: false
  int32  age          = 5;    // default: 0
  double balance      = 6;    // default: 0.0
  bytes  avatar       = 7;    // binary data, default: empty
}

// Request/response messages
message GetUserRequest {
  int64 id = 1;
}

message GetUserResponse {
  User user = 1;         // embedded message
}

message CreateUserRequest {
  string username = 1;
  string email    = 2;
  int32  age      = 3;
}

message CreateUserResponse {
  User    user    = 1;
  bool    success = 2;
  string  message = 3;
}

message ListUsersRequest {
  int32  page      = 1;
  int32  page_size = 2;
  string filter    = 3;
}

message ListUsersResponse {
  repeated User users      = 1;   // repeated = List<User> in Java
  int32         total_count = 2;
  bool          has_more   = 3;
}
```

### 2.2 Field Types

```protobuf
message TypeExamples {
  // Numeric types
  int32    small_int    = 1;    // 32-bit int (variable encoding)
  int64    large_int    = 2;    // 64-bit int
  uint32   unsigned_int = 3;    // unsigned 32-bit
  sint32   signed_int   = 4;    // zigzag encoding (efficient for negatives)
  fixed32  fixed_int    = 5;    // always 4 bytes (efficient for large values)
  float    float_val    = 6;    // 32-bit float
  double   double_val   = 7;    // 64-bit double

  // Other
  bool   flag   = 8;
  string text   = 9;    // UTF-8 string
  bytes  data   = 10;   // arbitrary binary data

  // Collections
  repeated string tags   = 11;   // List<String>
  repeated User   users  = 12;   // List<User>

  // Maps
  map<string, int32>  scores     = 13;   // Map<String, Integer>
  map<int64, User>    user_map   = 14;   // Map<Long, User>

  // Optional fields (proto3)
  optional string nickname = 15;   // null vs "" distinction
  // Without optional: you can't tell if value was set or is default
}
```

### 2.3 Enums

```protobuf
enum UserStatus {
  USER_STATUS_UNSPECIFIED = 0;    // proto3 REQUIRES 0 as default
  USER_STATUS_ACTIVE      = 1;
  USER_STATUS_INACTIVE    = 2;
  USER_STATUS_SUSPENDED   = 3;
  USER_STATUS_DELETED     = 4;
}

message User {
  int64      id     = 1;
  string     name   = 2;
  UserStatus status = 3;    // defaults to USER_STATUS_UNSPECIFIED (0)
}
```

### 2.4 Nested Messages

```protobuf
message Order {
  message Address {              // nested message definition
    string street     = 1;
    string city       = 2;
    string postal_code = 3;
    string country    = 4;
  }

  message LineItem {
    string product_id = 1;
    int32  quantity   = 2;
    double unit_price = 3;
  }

  int64              id           = 1;
  string             customer_id  = 2;
  Address            shipping     = 3;    // use nested message
  repeated LineItem  items        = 4;
  double             total        = 5;

  enum Status {
    STATUS_UNSPECIFIED = 0;
    STATUS_PENDING     = 1;
    STATUS_PROCESSING  = 2;
    STATUS_SHIPPED     = 3;
    STATUS_DELIVERED   = 4;
  }
  Status status = 6;
}
```

### 2.5 `oneof` — Union Type

```protobuf
message SearchRequest {
  oneof search_type {
    string keyword  = 1;
    int64  user_id  = 2;
    string email    = 3;
  }
  int32 page      = 4;
  int32 page_size = 5;
}

// In Java: request.hasKeyword(), request.hasUserId(), etc.
// Only one field can be set at a time
```

### 2.6 Timestamps and Well-Known Types

```protobuf
import "google/protobuf/timestamp.proto";
import "google/protobuf/duration.proto";
import "google/protobuf/wrappers.proto";   // nullable primitives
import "google/protobuf/any.proto";
import "google/protobuf/empty.proto";

message Event {
  string                   id         = 1;
  google.protobuf.Timestamp created_at = 2;   // maps to java.time.Instant
  google.protobuf.Duration  ttl        = 3;   // maps to java.time.Duration
  google.protobuf.StringValue optional_name = 4; // nullable String (vs "" default)
  google.protobuf.Empty     no_data    = 5;   // for void responses
}
```

---

## 3. Service Definitions — All Four Call Types

### 3.1 The Four gRPC Call Patterns

```protobuf
// src/main/proto/user_service.proto
syntax = "proto3";
package com.myapp.user;
option java_package = "com.myapp.grpc.user";
option java_multiple_files = true;

import "user.proto";
import "google/protobuf/empty.proto";

service UserService {

  // 1. UNARY — one request, one response (like HTTP REST)
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc DeleteUser(DeleteUserRequest) returns (google.protobuf.Empty);

  // 2. SERVER STREAMING — one request, stream of responses
  // Use case: subscribe to live updates, large result sets, progress reporting
  rpc StreamUserUpdates(StreamRequest) returns (stream UserUpdate);
  rpc ListAllUsers(ListUsersRequest) returns (stream User);

  // 3. CLIENT STREAMING — stream of requests, one response
  // Use case: bulk upload, aggregation of client data
  rpc BatchCreateUsers(stream CreateUserRequest) returns (BatchCreateResponse);
  rpc UploadUserData(stream UserDataChunk) returns (UploadResult);

  // 4. BIDIRECTIONAL STREAMING — stream of requests AND responses
  // Use case: real-time chat, collaborative editing, games
  rpc Chat(stream ChatMessage) returns (stream ChatMessage);
  rpc SyncData(stream DataRequest) returns (stream DataResponse);
}

message StreamRequest { string filter = 1; }
message UserUpdate {
  string    user_id = 1;
  User      user    = 2;
  string    event   = 3;    // CREATED, UPDATED, DELETED
}
message BatchCreateResponse {
  int32          created = 1;
  int32          failed  = 2;
  repeated string errors = 3;
}
message UserDataChunk { bytes data = 1; int32 sequence = 2; }
message UploadResult   { bool success = 1; int64 bytes_received = 2; }
message ChatMessage    { string user = 1; string text = 2; }
message DataRequest    { string key = 1; }
message DataResponse   { string key = 1; string value = 2; }
message DeleteUserRequest { int64 id = 1; }
```

---

## 4. `protoc` Code Generation

### 4.1 Maven Plugin Configuration

```xml
<!-- pom.xml -->
<dependencies>
    <dependency>
        <groupId>io.grpc</groupId>
        <artifactId>grpc-stub</artifactId>
        <version>${grpc.version}</version>
    </dependency>
    <dependency>
        <groupId>io.grpc</groupId>
        <artifactId>grpc-protobuf</artifactId>
        <version>${grpc.version}</version>
    </dependency>
    <dependency>
        <groupId>com.google.protobuf</groupId>
        <artifactId>protobuf-java</artifactId>
        <version>${protobuf.version}</version>
    </dependency>
</dependencies>

<build>
    <extensions>
        <extension>
            <groupId>kr.motd.maven</groupId>
            <artifactId>os-maven-plugin</artifactId>
            <version>1.7.1</version>
        </extension>
    </extensions>
    <plugins>
        <plugin>
            <groupId>org.xolstice.maven.plugins</groupId>
            <artifactId>protobuf-maven-plugin</artifactId>
            <version>0.6.1</version>
            <configuration>
                <protocArtifact>
                    com.google.protobuf:protoc:${protobuf.version}:exe:${os.detected.classifier}
                </protocArtifact>
                <pluginId>grpc-java</pluginId>
                <pluginArtifact>
                    io.grpc:protoc-gen-grpc-java:${grpc.version}:exe:${os.detected.classifier}
                </pluginArtifact>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>compile</goal>
                        <goal>compile-custom</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 4.2 What Gets Generated

```java
// From user.proto, protoc generates:

// 1. Message classes (immutable builders)
User user = User.newBuilder()
    .setId(1L)
    .setUsername("alice")
    .setEmail("alice@example.com")
    .setActive(true)
    .build();

// Access fields
long id     = user.getId();
String name = user.getUsername();

// Repeated fields → List
List<User> users = listResponse.getUsersList();

// 2. Service base class (extend this in your implementation)
// UserServiceGrpc.UserServiceImplBase

// 3. Stub classes (use these in clients)
// UserServiceGrpc.UserServiceBlockingStub   — synchronous
// UserServiceGrpc.UserServiceStub           — async with callbacks
// UserServiceGrpc.UserServiceFutureStub     — returns ListenableFuture
```

---

## 5. Spring Boot gRPC Setup

### 5.1 Dependencies — `grpc-spring-boot-starter`

The most widely used Spring Boot gRPC starter is from **net.devh** (grpc-spring-boot-starter):

```xml
<properties>
    <grpc.version>1.64.0</grpc.version>
</properties>

<dependencies>
    <!-- gRPC Spring Boot Starter (server + client) -->
    <dependency>
        <groupId>net.devh</groupId>
        <artifactId>grpc-spring-boot-starter</artifactId>
        <version>3.1.0.RELEASE</version>
    </dependency>

    <!-- OR: server only -->
    <dependency>
        <groupId>net.devh</groupId>
        <artifactId>grpc-server-spring-boot-starter</artifactId>
        <version>3.1.0.RELEASE</version>
    </dependency>

    <!-- OR: client only -->
    <dependency>
        <groupId>net.devh</groupId>
        <artifactId>grpc-client-spring-boot-starter</artifactId>
        <version>3.1.0.RELEASE</version>
    </dependency>
</dependencies>
```

### 5.2 Server Configuration

```yaml
# application.yml
grpc:
  server:
    port: 9090                    # gRPC server port (default: 9090)
    address: 0.0.0.0             # listen on all interfaces
    enable-reflection: true       # enable gRPC reflection (see Section 12)
    max-inbound-message-size: 4MB # max message size
    max-inbound-metadata-size: 8KB

  # Optional TLS configuration
  # server:
  #   security:
  #     certificate-chain: classpath:server.crt
  #     private-key: classpath:server.key
```

### 5.3 Client Configuration

```yaml
grpc:
  client:
    user-service:                    # matches @GrpcClient("user-service")
      address: static://localhost:9090  # static address
      # OR: address: discovery:///user-service  # Consul/Eureka discovery
      negotiation-type: plaintext    # no TLS (use tls for production)
      keep-alive-time: 30s
      keep-alive-timeout: 5s
      deadline: 5s                   # default timeout for all calls to this service

    order-service:
      address: static://order-service:9090
      negotiation-type: plaintext
```

---

## 6. `@GrpcService` — Exposing a gRPC Service

### 6.1 Unary Service Implementation

```java
import net.devh.boot.grpc.server.service.GrpcService;
import io.grpc.stub.StreamObserver;
import com.myapp.grpc.user.*;

@GrpcService  // registers this as a gRPC service bean + auto-configures with the server
public class UserGrpcService extends UserServiceGrpc.UserServiceImplBase {

    private final UserRepository userRepository;
    private final UserMapper mapper;

    public UserGrpcService(UserRepository userRepository, UserMapper mapper) {
        this.userRepository = userRepository;
        this.mapper = mapper;
    }

    // 1. Unary RPC implementation
    @Override
    public void getUser(GetUserRequest request,
                        StreamObserver<GetUserResponse> responseObserver) {
        try {
            // Find user
            User user = userRepository.findById(request.getId())
                .orElseThrow(() -> Status.NOT_FOUND
                    .withDescription("User not found: " + request.getId())
                    .asRuntimeException());

            // Build and send response
            GetUserResponse response = GetUserResponse.newBuilder()
                .setUser(mapper.toProto(user))
                .build();

            responseObserver.onNext(response);     // send the response
            responseObserver.onCompleted();         // signal completion (REQUIRED)

        } catch (StatusRuntimeException e) {
            responseObserver.onError(e);            // send error to client
        } catch (Exception e) {
            responseObserver.onError(Status.INTERNAL
                .withDescription("Internal error: " + e.getMessage())
                .withCause(e)
                .asRuntimeException());
        }
    }

    // 2. Create user
    @Override
    public void createUser(CreateUserRequest request,
                           StreamObserver<CreateUserResponse> responseObserver) {
        // Validate
        if (request.getUsername().isBlank()) {
            responseObserver.onError(Status.INVALID_ARGUMENT
                .withDescription("Username cannot be blank")
                .asRuntimeException());
            return;
        }

        // Check duplicate
        if (userRepository.existsByUsername(request.getUsername())) {
            responseObserver.onError(Status.ALREADY_EXISTS
                .withDescription("Username already taken: " + request.getUsername())
                .asRuntimeException());
            return;
        }

        // Create
        com.myapp.entity.User saved = userRepository.save(
            new com.myapp.entity.User(request.getUsername(), request.getEmail()));

        responseObserver.onNext(CreateUserResponse.newBuilder()
            .setUser(mapper.toProto(saved))
            .setSuccess(true)
            .setMessage("User created successfully")
            .build());
        responseObserver.onCompleted();
    }
}
```

### 6.2 Server Streaming Implementation

```java
@Override
public void streamUserUpdates(StreamRequest request,
                               StreamObserver<UserUpdate> responseObserver) {
    // Subscribe to an internal event stream and forward to gRPC client
    String listenerId = UUID.randomUUID().toString();

    userEventService.subscribe(listenerId, event -> {
        try {
            if (!responseObserver.isReady()) {
                // Client is applying back-pressure — pause sending
                return;
            }
            UserUpdate update = UserUpdate.newBuilder()
                .setUserId(event.getUserId())
                .setUser(mapper.toProto(event.getUser()))
                .setEvent(event.getEventType())
                .build();
            responseObserver.onNext(update);  // push each update to client
        } catch (StatusRuntimeException e) {
            // Client disconnected
            userEventService.unsubscribe(listenerId);
        }
    });

    // When the stream ends (either by client cancellation or error):
    Context.current().addListener(ctx -> {
        userEventService.unsubscribe(listenerId);
    }, Runnable::run);
}

// Simpler example: stream all users in pages
@Override
public void listAllUsers(ListUsersRequest request,
                          StreamObserver<com.myapp.grpc.user.User> responseObserver) {
    // Stream results from database without loading all into memory
    userRepository.streamAll().forEach(user -> {
        responseObserver.onNext(mapper.toProto(user));
    });
    responseObserver.onCompleted();
}
```

### 6.3 Client Streaming Implementation

```java
@Override
public StreamObserver<CreateUserRequest> batchCreateUsers(
        StreamObserver<BatchCreateResponse> responseObserver) {

    // Return a StreamObserver that accumulates client messages
    return new StreamObserver<>() {
        final List<CreateUserRequest> batch = new ArrayList<>();
        int created = 0;
        int failed  = 0;
        final List<String> errors = new ArrayList<>();

        @Override
        public void onNext(CreateUserRequest request) {
            // Called for each item the client sends
            batch.add(request);
            if (batch.size() >= 100) {
                processBatch(); // flush every 100 items
            }
        }

        @Override
        public void onError(Throwable t) {
            // Client sent an error or disconnected
            log.error("Client streaming error: {}", t.getMessage());
        }

        @Override
        public void onCompleted() {
            // Client finished sending — process remaining and send response
            processBatch(); // process remaining items
            responseObserver.onNext(BatchCreateResponse.newBuilder()
                .setCreated(created)
                .setFailed(failed)
                .addAllErrors(errors)
                .build());
            responseObserver.onCompleted();
        }

        private void processBatch() {
            for (CreateUserRequest req : batch) {
                try {
                    userRepository.save(new com.myapp.entity.User(
                        req.getUsername(), req.getEmail()));
                    created++;
                } catch (Exception e) {
                    failed++;
                    errors.add(req.getUsername() + ": " + e.getMessage());
                }
            }
            batch.clear();
        }
    };
}
```

### 6.4 Bidirectional Streaming Implementation

```java
@Override
public StreamObserver<ChatMessage> chat(
        StreamObserver<ChatMessage> responseObserver) {

    // Return a StreamObserver for messages FROM the client
    return new StreamObserver<>() {

        @Override
        public void onNext(ChatMessage message) {
            // Received a message from one client — broadcast to all
            ChatMessage broadcast = ChatMessage.newBuilder()
                .setUser(message.getUser())
                .setText(message.getText())
                .build();

            // Push to all connected chat clients
            activeChatSessions.forEach(session -> {
                try {
                    session.onNext(broadcast);
                } catch (StatusRuntimeException e) {
                    activeChatSessions.remove(session);
                }
            });
        }

        @Override
        public void onError(Throwable t) {
            activeChatSessions.remove(responseObserver);
            log.warn("Chat client disconnected with error: {}", t.getMessage());
        }

        @Override
        public void onCompleted() {
            activeChatSessions.remove(responseObserver);
            responseObserver.onCompleted();
        }
    };
}
```

---

## 7. `@GrpcClient` — Consuming a gRPC Service

### 7.1 Injecting a gRPC Client Stub

```java
import net.devh.boot.grpc.client.inject.GrpcClient;

@Service
public class UserClientService {

    // Inject blocking stub (synchronous) — most common for request/response
    @GrpcClient("user-service")   // matches grpc.client.user-service in application.yml
    private UserServiceGrpc.UserServiceBlockingStub userStub;

    // Or async stub
    @GrpcClient("user-service")
    private UserServiceGrpc.UserServiceStub asyncUserStub;

    // Or future stub
    @GrpcClient("user-service")
    private UserServiceGrpc.UserServiceFutureStub futureUserStub;
}
```

### 7.2 Making Unary Calls

```java
@Service
public class UserClientService {

    @GrpcClient("user-service")
    private UserServiceGrpc.UserServiceBlockingStub userStub;

    // Simple unary call
    public UserDto getUser(long userId) {
        GetUserRequest request = GetUserRequest.newBuilder()
            .setId(userId)
            .build();

        try {
            GetUserResponse response = userStub.getUser(request);
            return mapper.fromProto(response.getUser());

        } catch (StatusRuntimeException e) {
            Status status = e.getStatus();
            if (status.getCode() == Status.Code.NOT_FOUND) {
                throw new UserNotFoundException("User not found: " + userId);
            }
            throw new ServiceException("gRPC call failed: " + status.getDescription(), e);
        }
    }

    // With deadline (per-call timeout)
    public UserDto getUserWithTimeout(long userId) {
        GetUserRequest request = GetUserRequest.newBuilder().setId(userId).build();

        try {
            return userStub
                .withDeadlineAfter(3, TimeUnit.SECONDS)  // override default deadline
                .withCompression("gzip")                  // enable compression
                .getUser(request)
                .getUser()
                .toDto();
        } catch (StatusRuntimeException e) {
            if (e.getStatus().getCode() == Status.Code.DEADLINE_EXCEEDED) {
                throw new TimeoutException("User service timed out");
            }
            throw e;
        }
    }
}
```

### 7.3 Consuming Server-Streaming

```java
@Service
public class UserEventConsumer {

    @GrpcClient("user-service")
    private UserServiceGrpc.UserServiceStub asyncUserStub;   // must use async stub for streaming

    public void subscribeToUserUpdates(Consumer<UserUpdate> handler) {
        StreamRequest request = StreamRequest.newBuilder()
            .setFilter("active")
            .build();

        asyncUserStub.streamUserUpdates(request, new StreamObserver<UserUpdate>() {
            @Override
            public void onNext(UserUpdate update) {
                // Called for each streamed message
                handler.accept(update);
            }

            @Override
            public void onError(Throwable t) {
                log.error("Stream error: {}", t.getMessage());
                // Implement reconnection logic here
            }

            @Override
            public void onCompleted() {
                log.info("Stream completed");
            }
        });
        // asyncUserStub.streamUserUpdates returns immediately — streaming runs in background
    }
}
```

### 7.4 Consuming Client Streaming

```java
public BatchCreateResponse batchCreate(List<CreateUserRequest> users) throws Exception {
    CompletableFuture<BatchCreateResponse> future = new CompletableFuture<>();

    StreamObserver<BatchCreateResponse> responseObserver = new StreamObserver<>() {
        @Override
        public void onNext(BatchCreateResponse response) {
            future.complete(response);
        }
        @Override
        public void onError(Throwable t) {
            future.completeExceptionally(t);
        }
        @Override
        public void onCompleted() { /* response already handled in onNext */ }
    };

    // Get the request stream observer
    StreamObserver<CreateUserRequest> requestObserver =
        asyncUserStub.batchCreateUsers(responseObserver);

    // Send each user
    for (CreateUserRequest user : users) {
        requestObserver.onNext(user);
    }
    requestObserver.onCompleted(); // signal end of client stream

    return future.get(30, TimeUnit.SECONDS);
}
```

---

## 8. gRPC Interceptors — Auth, Logging, Metrics

### 8.1 Server-Side Interceptor

```java
import io.grpc.*;
import net.devh.boot.grpc.server.interceptor.GrpcGlobalServerInterceptor;

// @GrpcGlobalServerInterceptor: applied to ALL gRPC services automatically
@GrpcGlobalServerInterceptor
@Component
public class LoggingServerInterceptor implements ServerInterceptor {

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(
            ServerCall<ReqT, RespT> call,
            Metadata headers,
            ServerCallHandler<ReqT, RespT> next) {

        String method = call.getMethodDescriptor().getFullMethodName();
        long startTime = System.currentTimeMillis();

        log.info("gRPC call started: {}", method);

        // Delegate to the actual service, wrapping the call
        return new ForwardingServerCallListener.SimpleForwardingServerCallListener<>(
                next.startCall(new ForwardingServerCall.SimpleForwardingServerCall<>(call) {
                    @Override
                    public void close(Status status, Metadata trailers) {
                        long elapsed = System.currentTimeMillis() - startTime;
                        log.info("gRPC call completed: {} status={} duration={}ms",
                            method, status.getCode(), elapsed);
                        super.close(status, trailers);
                    }
                }, headers)) {

            @Override
            public void onMessage(ReqT message) {
                log.debug("gRPC request message: {}", message);
                super.onMessage(message);
            }
        };
    }
}
```

### 8.2 Authentication Interceptor

```java
// Context key for carrying the authenticated principal
public static final Context.Key<String> USER_ID_KEY =
    Context.key("userId");

@GrpcGlobalServerInterceptor
@Component
public class AuthenticationInterceptor implements ServerInterceptor {

    private final JwtService jwtService;

    // Metadata key for the Authorization header
    private static final Metadata.Key<String> AUTH_HEADER =
        Metadata.Key.of("Authorization", Metadata.ASCII_STRING_MARSHALLER);

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(
            ServerCall<ReqT, RespT> call,
            Metadata headers,
            ServerCallHandler<ReqT, RespT> next) {

        // Skip auth for health checks and reflection
        String method = call.getMethodDescriptor().getFullMethodName();
        if (method.startsWith("grpc.health") || method.startsWith("grpc.reflection")) {
            return next.startCall(call, headers);
        }

        String authHeader = headers.get(AUTH_HEADER);
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            call.close(Status.UNAUTHENTICATED
                .withDescription("Authorization header required"), new Metadata());
            return new ServerCall.Listener<>() {}; // no-op listener
        }

        String token = authHeader.substring(7);
        try {
            String userId = jwtService.validateAndGetUserId(token);

            // Attach userId to the gRPC Context (available throughout the call)
            Context ctx = Context.current().withValue(USER_ID_KEY, userId);
            return Contexts.interceptCall(ctx, call, headers, next);

        } catch (JwtException e) {
            call.close(Status.UNAUTHENTICATED
                .withDescription("Invalid token: " + e.getMessage()), new Metadata());
            return new ServerCall.Listener<>() {};
        }
    }
}

// Reading the user ID in service methods:
@Override
public void getUser(GetUserRequest request, StreamObserver<GetUserResponse> observer) {
    String currentUserId = AuthenticationInterceptor.USER_ID_KEY.get(); // from Context
    // ...
}
```

### 8.3 Client-Side Interceptor (Attaching Auth Token)

```java
@Component
public class AuthClientInterceptor implements ClientInterceptor {

    private final TokenProvider tokenProvider;

    private static final Metadata.Key<String> AUTH_HEADER =
        Metadata.Key.of("Authorization", Metadata.ASCII_STRING_MARSHALLER);

    @Override
    public <ReqT, RespT> ClientCall<ReqT, RespT> interceptCall(
            MethodDescriptor<ReqT, RespT> method,
            CallOptions callOptions,
            Channel next) {

        return new ForwardingClientCall.SimpleForwardingClientCall<>(
                next.newCall(method, callOptions)) {

            @Override
            public void start(Listener<RespT> responseListener, Metadata headers) {
                // Attach JWT to every outbound request
                headers.put(AUTH_HEADER, "Bearer " + tokenProvider.getToken());
                super.start(responseListener, headers);
            }
        };
    }
}

// Register with the client channel:
@Bean
public GrpcChannelConfigurer channelConfigurer(AuthClientInterceptor authInterceptor) {
    return (channelBuilder, name) -> channelBuilder.intercept(authInterceptor);
}
```

---

## 9. Error Handling — `Status` Codes

### 9.1 gRPC Status Codes

```java
// gRPC has 16 status codes mapped to HTTP status analogues:
Status.OK                  // Success (HTTP 200)
Status.CANCELLED           // Client cancelled (HTTP 499)
Status.UNKNOWN             // Unknown error (HTTP 500)
Status.INVALID_ARGUMENT    // Bad request (HTTP 400) — client's fault
Status.DEADLINE_EXCEEDED   // Timeout (HTTP 504)
Status.NOT_FOUND           // Not found (HTTP 404)
Status.ALREADY_EXISTS      // Conflict (HTTP 409)
Status.PERMISSION_DENIED   // Forbidden (HTTP 403)
Status.RESOURCE_EXHAUSTED  // Rate limit / quota (HTTP 429)
Status.FAILED_PRECONDITION // Precondition failed (HTTP 400/412)
Status.ABORTED             // Concurrency conflict (HTTP 409)
Status.OUT_OF_RANGE        // Invalid range (HTTP 400)
Status.UNIMPLEMENTED       // Not implemented (HTTP 501)
Status.INTERNAL            // Server error (HTTP 500)
Status.UNAVAILABLE         // Service unavailable (HTTP 503)
Status.DATA_LOSS           // Unrecoverable data loss (HTTP 500)
Status.UNAUTHENTICATED     // Not authenticated (HTTP 401)
```

### 9.2 Throwing Status Exceptions in Services

```java
@Override
public void getUser(GetUserRequest request, StreamObserver<GetUserResponse> observer) {

    // Validation error
    if (request.getId() <= 0) {
        observer.onError(Status.INVALID_ARGUMENT
            .withDescription("User ID must be positive, got: " + request.getId())
            .asRuntimeException());
        return;
    }

    // Not found
    User user = userRepository.findById(request.getId()).orElse(null);
    if (user == null) {
        observer.onError(Status.NOT_FOUND
            .withDescription("No user with id: " + request.getId())
            .asRuntimeException());
        return;
    }

    // With additional details (using google.rpc.Status extensions)
    // Requires: implementation 'io.grpc:grpc-protobuf:...'
    com.google.rpc.Status status = com.google.rpc.Status.newBuilder()
        .setCode(com.google.rpc.Code.NOT_FOUND_VALUE)
        .setMessage("User not found")
        .addDetails(Any.pack(ResourceInfo.newBuilder()
            .setResourceType("User")
            .setResourceName(String.valueOf(request.getId()))
            .setDescription("The requested user does not exist")
            .build()))
        .build();
    observer.onError(StatusProto.toStatusRuntimeException(status));
}
```

### 9.3 Handling Errors on the Client Side

```java
try {
    UserDto user = userClientService.getUser(userId);
} catch (StatusRuntimeException e) {
    Status status = e.getStatus();
    switch (status.getCode()) {
        case NOT_FOUND ->
            throw new EntityNotFoundException("User " + userId + " not found");
        case INVALID_ARGUMENT ->
            throw new BadRequestException(status.getDescription());
        case UNAVAILABLE ->
            throw new ServiceUnavailableException("User service is down");
        case DEADLINE_EXCEEDED ->
            throw new TimeoutException("Request timed out after configured deadline");
        case UNAUTHENTICATED ->
            throw new UnauthorizedException("Authentication required");
        case PERMISSION_DENIED ->
            throw new ForbiddenException("Insufficient permissions");
        default ->
            throw new ServiceException("gRPC error: " + status, e);
    }
}
```

### 9.4 Global Exception Handler with `GrpcAdvice`

```java
import net.devh.boot.grpc.server.advice.GrpcAdvice;
import net.devh.boot.grpc.server.advice.GrpcExceptionHandler;

@GrpcAdvice  // Spring Boot gRPC global exception handler
public class GrpcExceptionAdvice {

    @GrpcExceptionHandler(UserNotFoundException.class)
    public Status handleUserNotFound(UserNotFoundException e) {
        return Status.NOT_FOUND.withDescription(e.getMessage()).withCause(e);
    }

    @GrpcExceptionHandler(ValidationException.class)
    public Status handleValidation(ValidationException e) {
        return Status.INVALID_ARGUMENT.withDescription(e.getMessage()).withCause(e);
    }

    @GrpcExceptionHandler(AccessDeniedException.class)
    public Status handleAccessDenied(AccessDeniedException e) {
        return Status.PERMISSION_DENIED.withDescription("Access denied").withCause(e);
    }

    @GrpcExceptionHandler
    public Status handleGeneral(Exception e) {
        log.error("Unhandled exception in gRPC service", e);
        return Status.INTERNAL.withDescription("An internal error occurred");
        // Don't expose internal details to clients!
    }
}
```

---

## 10. gRPC + Spring Security

### 10.1 Token-Based Auth in Metadata

```java
// Server configuration with Spring Security
@Configuration
public class GrpcSecurityConfig extends GrpcSecurityConfigurerAdapter {

    @Override
    public void configure(GrpcSecurity builder) throws Exception {
        builder.authorizeRequests()
            .methods(UserServiceGrpc.getGetUserMethod())
                .hasAnyRole("USER", "ADMIN")
            .methods(UserServiceGrpc.getCreateUserMethod())
                .hasRole("ADMIN")
            .methods(UserServiceGrpc.getDeleteUserMethod())
                .hasRole("ADMIN")
            // Allow health checks without auth
            .methods(HealthGrpc.getCheckMethod())
                .permitAll()
            .anyMethod()
                .authenticated();
    }
}
```

### 10.2 JWT Authentication Provider for gRPC

```java
@Bean
public GrpcAuthenticationReader grpcAuthenticationReader() {
    // Read token from Authorization metadata header
    return new BearerAuthenticationReader(token -> {
        // Parse JWT and return Spring Security Authentication
        Claims claims = jwtParser.parseClaimsJws(token).getBody();
        List<GrantedAuthority> authorities = ((List<String>) claims.get("roles"))
            .stream()
            .map(SimpleGrantedAuthority::new)
            .collect(Collectors.toList());

        return new UsernamePasswordAuthenticationToken(
            claims.getSubject(),
            null,
            authorities
        );
    });
}
```

---

## 11. gRPC vs REST

### 11.1 Decision Matrix

| Criterion | gRPC | REST |
|---|---|---|
| **Protocol** | HTTP/2 (binary) | HTTP/1.1 or HTTP/2 (text) |
| **Payload format** | Protocol Buffers (binary) | JSON/XML (text) |
| **Performance** | 3-10× faster, smaller payloads | Slower, larger payloads |
| **Streaming** | All 4 patterns natively | SSE, chunked (limited) |
| **Browser support** | ❌ Requires gRPC-Web proxy | ✅ Native |
| **Human readability** | ❌ Binary (need tools) | ✅ curl, browser DevTools |
| **Code generation** | ✅ Client stubs generated | Manual or OpenAPI codegen |
| **Schema** | Required (`.proto`) | Optional (OpenAPI) |
| **Language support** | ✅ All major languages | ✅ Universal |
| **Versioning** | Field numbers (backward compat) | URL versions, content negotiation |
| **Error handling** | Status codes (16 standard) | HTTP status codes (many) |
| **Learning curve** | Higher | Lower |
| **Ecosystem** | Growing | Mature |

### 11.2 When to Use gRPC

```
✅ USE gRPC FOR:

Internal service-to-service:
  Microservice A → Microservice B
  → No browser involved, both in your control
  → Benefit from binary efficiency and type safety

High-throughput internal APIs:
  Payment processing engine
  Real-time data pipelines
  High-frequency trading systems
  → Every millisecond and byte matters

Streaming:
  Live data feeds (stock prices, sensor data)
  Large file uploads/downloads chunked
  Real-time bidirectional communication between services
  → REST cannot do this natively

Polyglot microservices:
  Java service, Go service, Python ML model all communicating
  → .proto is the universal contract

✅ USE REST FOR:

Public/external APIs:
  Third-party developers consuming your API
  Mobile app clients
  → Universal HTTP knowledge, curl-testable

Browser-facing APIs:
  JavaScript/TypeScript frontend
  → Browsers can't use gRPC directly (gRPC-Web exists but adds complexity)

Simple CRUD services:
  Basic resource operations
  → REST is simpler to implement and debug

Third-party integrations:
  Webhooks, payment gateways, OAuth callbacks
  → REST is the universal standard
```

### 11.3 Hybrid Approach (Recommended)

```
         External clients          Internal services
         ─────────────────         ─────────────────
         Browser (SPA)             UserService (Java)
         Mobile app         ──►    OrderService (Java)    ◄── gRPC
         Third-party        REST ► InventoryService (Go)
         Webhook receiver          NotificationService (Python)
               │
               ▼
         API Gateway / BFF
         (Backend-for-Frontend)
         ─────────────────────────────
         Translates REST → gRPC
         Handles auth, rate limiting
         Aggregates responses
```

---

## 12. gRPC Reflection and Health Checks

### 12.1 gRPC Reflection

Reflection allows clients (like `grpcurl`) to discover your service schema at runtime without needing the `.proto` file:

```yaml
# application.yml
grpc:
  server:
    enable-reflection: true   # enables ProtoReflectionService
```

```bash
# grpcurl — curl for gRPC
# Install: brew install grpcurl  OR  go install github.com/fullstorydev/grpcurl/...

# List services
grpcurl -plaintext localhost:9090 list

# Describe a service
grpcurl -plaintext localhost:9090 describe com.myapp.user.UserService

# Make a call
grpcurl -plaintext -d '{"id": 1}' localhost:9090 com.myapp.user.UserService/GetUser

# With auth header
grpcurl -plaintext \
  -H 'Authorization: Bearer eyJhbGc...' \
  -d '{"id": 1}' \
  localhost:9090 com.myapp.user.UserService/GetUser
```

### 12.2 Health Checks

```java
// Add health check dependency
// implementation 'io.grpc:grpc-services:...'

@Component
public class GrpcHealthIndicator implements HealthCheckService.HealthStatusProvider {

    @Override
    public ServingStatus getServingStatus(String serviceName) {
        // Check dependencies
        if (isDatabaseHealthy() && isExternalServiceHealthy()) {
            return ServingStatus.SERVING;
        }
        return ServingStatus.NOT_SERVING;
    }
}
```

```yaml
# Health check configuration (grpc-spring-boot-starter)
grpc:
  server:
    health-check-enabled: true   # enables grpc.health.v1.Health service
```

```bash
# Check health with grpcurl
grpcurl -plaintext localhost:9090 grpc.health.v1.Health/Check

# Response: {"status": "SERVING"}
# Or: {"status": "NOT_SERVING"}
```

### 12.3 gRPC Server Reflection + Postman

Postman (v10+) supports gRPC natively:
1. New Request → gRPC
2. Enter URL: `localhost:9090`
3. Click "Import Protobuf" or use "Service reflection" if enabled
4. Select method and invoke

---

## 13. Testing gRPC Services

### 13.1 In-Process Server (No Network)

```java
@ExtendWith(GrpcCleanupExtension.class)
class UserGrpcServiceTest {

    private UserServiceGrpc.UserServiceBlockingStub stub;

    @BeforeEach
    void setUp(GrpcCleanup grpcCleanup) throws IOException {
        // 1. Create the service implementation
        UserGrpcService service = new UserGrpcService(
            mock(UserRepository.class),
            new UserMapper()
        );

        // 2. Start an in-process server (no actual network — much faster)
        String serverName = InProcessServerBuilder.generateName();
        grpcCleanup.register(
            InProcessServerBuilder.forName(serverName)
                .directExecutor()              // run in test thread for determinism
                .addService(service)
                .build()
                .start()
        );

        // 3. Create a client connected to the in-process server
        stub = UserServiceGrpc.newBlockingStub(
            grpcCleanup.register(
                InProcessChannelBuilder.forName(serverName)
                    .directExecutor()
                    .build()
            )
        );
    }

    @Test
    void getUser_found_returnsUser() {
        // Arrange: stub the repository
        UserRepository repo = mock(UserRepository.class);
        when(repo.findById(1L)).thenReturn(Optional.of(
            new com.myapp.entity.User(1L, "alice", "alice@example.com")));

        // Act
        GetUserResponse response = stub.getUser(
            GetUserRequest.newBuilder().setId(1L).build());

        // Assert
        assertThat(response.getUser().getUsername()).isEqualTo("alice");
        assertThat(response.getUser().getEmail()).isEqualTo("alice@example.com");
    }

    @Test
    void getUser_notFound_throwsNotFound() {
        GetUserRequest request = GetUserRequest.newBuilder().setId(999L).build();

        StatusRuntimeException exception = assertThrows(
            StatusRuntimeException.class,
            () -> stub.getUser(request)
        );

        assertThat(exception.getStatus().getCode()).isEqualTo(Status.Code.NOT_FOUND);
        assertThat(exception.getStatus().getDescription()).contains("999");
    }

    @Test
    void createUser_invalidArgument_throwsInvalidArgument() {
        CreateUserRequest request = CreateUserRequest.newBuilder()
            .setUsername("")   // blank — should fail validation
            .setEmail("alice@example.com")
            .build();

        StatusRuntimeException exception = assertThrows(
            StatusRuntimeException.class,
            () -> stub.createUser(request)
        );

        assertThat(exception.getStatus().getCode()).isEqualTo(Status.Code.INVALID_ARGUMENT);
    }
}
```

### 13.2 Spring Boot Integration Test

```java
@SpringBootTest(properties = {
    "grpc.server.port=0",          // random port to avoid conflicts
    "grpc.server.in-process-name=test"
})
@ExtendWith(GrpcCleanupExtension.class)
class UserGrpcServiceIntegrationTest {

    @Autowired
    private UserRepository userRepository;

    private UserServiceGrpc.UserServiceBlockingStub stub;

    @BeforeEach
    void setUp(GrpcCleanup grpcCleanup, @Autowired ApplicationContext context) {
        stub = UserServiceGrpc.newBlockingStub(
            grpcCleanup.register(
                InProcessChannelBuilder.forName("test").directExecutor().build()
            )
        );
    }

    @Test
    @Transactional
    void fullRoundTrip_createAndFetch() {
        // Create via gRPC
        CreateUserResponse createResponse = stub.createUser(
            CreateUserRequest.newBuilder()
                .setUsername("integration-test-user")
                .setEmail("it@example.com")
                .build()
        );
        assertThat(createResponse.getSuccess()).isTrue();
        long createdId = createResponse.getUser().getId();

        // Fetch via gRPC
        GetUserResponse getResponse = stub.getUser(
            GetUserRequest.newBuilder().setId(createdId).build()
        );
        assertThat(getResponse.getUser().getUsername()).isEqualTo("integration-test-user");
    }
}
```

### 13.3 Testing Streaming with `TestStreamObserver`

```java
class StreamingTest {

    // Helper: collect streamed responses into a list
    static class TestStreamObserver<T> implements StreamObserver<T> {
        final List<T> values   = new ArrayList<>();
        Throwable     error    = null;
        boolean       completed = false;

        @Override public void onNext(T value)       { values.add(value); }
        @Override public void onError(Throwable t)  { error = t; }
        @Override public void onCompleted()         { completed = true; }
    }

    @Test
    void serverStreaming_sendsAllUsers() throws Exception {
        TestStreamObserver<User> observer = new TestStreamObserver<>();

        // Call server streaming method
        service.listAllUsers(ListUsersRequest.newBuilder().build(), observer);

        // Wait for completion (in real tests use CountDownLatch or awaitility)
        Awaitility.await().atMost(5, TimeUnit.SECONDS)
            .until(() -> observer.completed);

        assertThat(observer.error).isNull();
        assertThat(observer.values).hasSize(expectedUserCount);
        assertThat(observer.completed).isTrue();
    }
}
```

---

## 14. Quick Reference Cheat Sheet

### Proto File Structure

```protobuf
syntax = "proto3";
package com.myapp;
option java_package = "com.myapp.grpc";
option java_multiple_files = true;

message MyMessage {
  int64         id      = 1;
  string        name    = 2;
  repeated Tags tags    = 3;
  optional int32 optional = 4;
  map<string, string> meta = 5;
}

enum MyEnum {
  MY_ENUM_UNSPECIFIED = 0;   // 0 REQUIRED as default
  MY_ENUM_VALUE_A     = 1;
}

service MyService {
  rpc Unary(Req) returns (Resp);                  // 1:1
  rpc ServerStream(Req) returns (stream Resp);    // 1:N
  rpc ClientStream(stream Req) returns (Resp);    // N:1
  rpc BidiStream(stream Req) returns (stream Resp); // N:N
}
```

### Spring Boot gRPC

```java
// Server: implement generated base class
@GrpcService
public class MyServiceImpl extends MyServiceGrpc.MyServiceImplBase {
    @Override
    public void myMethod(Req req, StreamObserver<Resp> obs) {
        obs.onNext(buildResponse(req));
        obs.onCompleted();
        // OR on error: obs.onError(Status.NOT_FOUND.withDescription("...").asRuntimeException())
    }
}

// Client: inject stub
@GrpcClient("service-name")  // matches grpc.client.service-name in yaml
private MyServiceGrpc.MyServiceBlockingStub stub;
```

### Status Code Mapping

```
INVALID_ARGUMENT  → bad input (HTTP 400)
UNAUTHENTICATED   → no auth (HTTP 401)
PERMISSION_DENIED → forbidden (HTTP 403)
NOT_FOUND         → missing (HTTP 404)
ALREADY_EXISTS    → conflict (HTTP 409)
RESOURCE_EXHAUSTED→ rate limit (HTTP 429)
INTERNAL          → server error (HTTP 500)
UNIMPLEMENTED     → not supported (HTTP 501)
UNAVAILABLE       → down (HTTP 503)
DEADLINE_EXCEEDED → timeout (HTTP 504)
```

### Testing Pattern

```java
@ExtendWith(GrpcCleanupExtension.class)
class MyTest {
    @BeforeEach void setUp(GrpcCleanup gc) throws IOException {
        String name = InProcessServerBuilder.generateName();
        gc.register(InProcessServerBuilder.forName(name)
            .directExecutor().addService(new MyServiceImpl()).build().start());
        stub = MyServiceGrpc.newBlockingStub(
            gc.register(InProcessChannelBuilder.forName(name).directExecutor().build()));
    }

    @Test void test() {
        assertThrows(StatusRuntimeException.class, () -> stub.myMethod(req));
    }
}
```

### Key Rules to Remember

1. **Proto field numbers are forever** — once published, never change field numbers. Add new fields, never remove/renumber.
2. **Proto3 default = empty/zero** — no null distinction for non-optional fields. Use `optional` keyword for nullable semantics.
3. **`onCompleted()` is required** — always call it after `onNext()` in unary/server-streaming; forgetting it hangs the client.
4. **Never call `onNext()` after `onCompleted()` or `onError()`** — undefined behavior.
5. **Blocking stub for request/response, async stub for streaming** — `BlockingStub` can't handle streams.
6. **`@GrpcGlobalServerInterceptor` applies to all services** — order interceptors carefully; auth must run before business logic.
7. **`Context.key()` carries values through gRPC call** — like `ThreadLocal` but for the gRPC execution context.
8. **`GrpcAdvice` catches domain exceptions** — converts them to `Status` without polluting service code.
9. **`InProcessServer` for tests** — no ports, no network, much faster than a real server.
10. **`enable-reflection: true` only in dev** — exposing schema in production is a security concern.

---

*End of gRPC with Spring Study Guide — Module 10*
