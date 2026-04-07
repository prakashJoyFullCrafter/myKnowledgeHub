# WebSocket with Spring — Complete Study Guide

> **Module 9 | Brutally Detailed Reference**
> Covers raw WebSocket, STOMP over WebSocket, user-specific messaging, external broker relay, security, SockJS fallback, and real-world patterns. Every section includes full working examples with client-side JavaScript.

---

## Table of Contents

1. [WebSocket Protocol Fundamentals](#1-websocket-protocol-fundamentals)
2. [Raw WebSocket — `@EnableWebSocket`](#2-raw-websocket--enablewebsocket)
3. [STOMP over WebSocket — Why and How](#3-stomp-over-websocket--why-and-how)
4. [STOMP Server Configuration](#4-stomp-server-configuration)
5. [`@MessageMapping` and `@SendTo` — Receive and Broadcast](#5-messagemapping-and-sendto--receive-and-broadcast)
6. [`SimpMessagingTemplate` — Push from Anywhere](#6-simpMessagingtemplate--push-from-anywhere)
7. [User-Specific Messages — `@SendToUser` and `convertAndSendToUser()`](#7-user-specific-messages--sendtouser-and-convertandsendtouser)
8. [External Broker — RabbitMQ / ActiveMQ Relay](#8-external-broker--rabbitmq--activemq-relay)
9. [WebSocket Security](#9-websocket-security)
10. [SockJS Fallback](#10-sockjs-fallback)
11. [Real-World Use Cases with Full Examples](#11-real-world-use-cases-with-full-examples)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. WebSocket Protocol Fundamentals

### 1.1 How WebSocket Works

WebSocket starts as HTTP and upgrades:

```
1. Client sends HTTP Upgrade request:
   GET /ws HTTP/1.1
   Host: localhost:8080
   Upgrade: websocket
   Connection: Upgrade
   Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
   Sec-WebSocket-Version: 13

2. Server accepts upgrade:
   HTTP/1.1 101 Switching Protocols
   Upgrade: websocket
   Connection: Upgrade
   Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=

3. TCP connection is now a WebSocket connection:
   ← full-duplex bidirectional messaging →
   Server can push anytime, Client can send anytime
   No polling needed
```

### 1.2 WebSocket vs HTTP Polling

```
HTTP Short Polling:               HTTP Long Polling:           WebSocket:
Client ──GET /updates──► Server   Client ──GET──► Server       Client ─── WS ──► Server
Server ──"no data"──► Client      Server waits...              Server ──push──► Client (instant)
(repeat every 2 seconds)          Server ──data──► Client      Client ──message──► Server
                                  Client ──GET──► Server       (persistent connection)

Overhead:   High (headers/conn)   Medium                       Minimal (framing only)
Latency:    polling interval      near real-time               real-time
Server load: constant polling     moderate                     event-driven
```

### 1.3 WebSocket Message Framing

Raw WebSocket messages are unstructured byte arrays or strings. STOMP adds structure (see Section 3).

### 1.4 Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>
```

---

## 2. Raw WebSocket — `@EnableWebSocket`

### 2.1 When to Use Raw WebSocket

Raw WebSocket is appropriate when:
- You control both client and server and need a simple binary or custom protocol
- Your messaging pattern doesn't fit pub-sub or point-to-point
- You need maximum performance with minimal overhead
- You're building something like a game server or file streaming endpoint

For most application use cases (chat, notifications, dashboards), **STOMP is recommended** instead.

### 2.2 Handler Implementation

```java
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // Track all connected sessions (thread-safe)
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    // 1. Called when a client connects
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.put(session.getId(), session);
        log.info("Client connected: {} (total: {})", session.getId(), sessions.size());

        // Read attributes set during handshake (e.g., from URL params or HTTP headers)
        String username = (String) session.getAttributes().get("username");
        log.info("User: {}", username);

        // Send welcome message
        session.sendMessage(new TextMessage(
            "{\"type\":\"CONNECTED\",\"message\":\"Welcome to the chat!\"}"));
    }

    // 2. Called when a text message arrives
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message)
            throws Exception {
        String payload = message.getPayload();
        log.debug("Received: {} from {}", payload, session.getId());

        // Parse message (assuming JSON)
        // In raw WebSocket, you define your own protocol
        ChatMessage chat = objectMapper.readValue(payload, ChatMessage.class);

        // Broadcast to all connected clients
        broadcast(new TextMessage(objectMapper.writeValueAsString(
            new ChatMessage(chat.username(), chat.content(), Instant.now()))));
    }

    // 3. Called when a binary message arrives
    @Override
    protected void handleBinaryMessage(WebSocketSession session, BinaryMessage message) {
        ByteBuffer payload = message.getPayload();
        // Handle binary data (images, audio, etc.)
    }

    // 4. Called on transport error
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception)
            throws Exception {
        log.error("Transport error for session {}: {}", session.getId(), exception.getMessage());
        if (session.isOpen()) {
            session.close(CloseStatus.SERVER_ERROR);
        }
        sessions.remove(session.getId());
    }

    // 5. Called when connection closes (both clean and error)
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status)
            throws Exception {
        sessions.remove(session.getId());
        log.info("Client disconnected: {} (status: {}, total: {})",
            session.getId(), status, sessions.size());
    }

    @Override
    public boolean supportsPartialMessages() {
        return false; // true for large messages split into fragments
    }

    // Broadcast to all sessions
    private void broadcast(TextMessage message) {
        sessions.values().forEach(session -> {
            try {
                if (session.isOpen()) {
                    synchronized (session) { // synchronize per session for thread safety
                        session.sendMessage(message);
                    }
                }
            } catch (IOException e) {
                log.error("Error sending to session {}", session.getId(), e);
                sessions.remove(session.getId());
            }
        });
    }

    // Send to specific session
    public void sendToSession(String sessionId, String message) throws IOException {
        WebSocketSession session = sessions.get(sessionId);
        if (session != null && session.isOpen()) {
            synchronized (session) {
                session.sendMessage(new TextMessage(message));
            }
        }
    }
}
```

### 2.3 `WebSocketConfigurer` — Registration

```java
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Autowired
    private ChatWebSocketHandler chatHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry
            .addHandler(chatHandler, "/ws/chat")    // WebSocket endpoint path
            .addHandler(chatHandler, "/ws/chat")
            .setAllowedOrigins("https://myapp.com", "http://localhost:3000") // CORS
            .addInterceptors(new HttpSessionHandshakeInterceptor(),            // carry HTTP session
                             new AuthHandshakeInterceptor());                   // custom interceptor

        // SockJS fallback at a different path:
        registry
            .addHandler(chatHandler, "/ws/chat-sockjs")
            .withSockJS(); // enables SockJS fallback (see Section 10)
    }
}
```

### 2.4 Handshake Interceptor — Pass Data from HTTP to WebSocket

```java
@Component
public class AuthHandshakeInterceptor extends HttpSessionHandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request,
                                    ServerHttpResponse response,
                                    WebSocketHandler wsHandler,
                                    Map<String, Object> attributes) throws Exception {

        // This runs during the HTTP upgrade — Authentication is available here
        if (request instanceof ServletServerHttpRequest servletRequest) {
            HttpSession session = servletRequest.getServletRequest().getSession(false);
            if (session != null) {
                String username = (String) session.getAttribute("username");
                attributes.put("username", username);
            }

            // Or from JWT parameter: /ws/chat?token=eyJ...
            String token = servletRequest.getServletRequest().getParameter("token");
            if (token != null) {
                Principal principal = jwtService.getPrincipal(token);
                attributes.put("principal", principal);
                attributes.put("username", principal.getName());
            }
        }

        // Return false to reject the handshake
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                WebSocketHandler wsHandler, Exception exception) {
        // Post-handshake cleanup if needed
    }
}
```

### 2.5 JavaScript Client for Raw WebSocket

```javascript
// Raw WebSocket client
const socket = new WebSocket('ws://localhost:8080/ws/chat');

socket.onopen = (event) => {
    console.log('Connected');
    socket.send(JSON.stringify({
        username: 'Alice',
        content: 'Hello everyone!'
    }));
};

socket.onmessage = (event) => {
    const message = JSON.parse(event.data);
    console.log('Received:', message);
    displayMessage(message);
};

socket.onclose = (event) => {
    console.log('Disconnected:', event.code, event.reason);
};

socket.onerror = (error) => {
    console.error('Error:', error);
};

// Send a message
function sendMessage(content) {
    if (socket.readyState === WebSocket.OPEN) {
        socket.send(JSON.stringify({ username: 'Alice', content }));
    }
}
```

---

## 3. STOMP over WebSocket — Why and How

### 3.1 Why STOMP?

Raw WebSocket gives you a bidirectional channel but no message routing, subscription management, or structured messaging. You'd have to build all of that yourself.

**STOMP (Simple Text Oriented Messaging Protocol)** adds:

```
Raw WebSocket:                    STOMP over WebSocket:
"hello world"                     SEND
                                   destination:/app/chat
No routing                         content-type:application/json
No subscription                    
No ack                            {"message":"hello world"}
                                   ^^^^^^^
                                   ↑ structured message with destination routing
                                   
                                  SUBSCRIBE
                                   destination:/topic/chat-room
                                   id:sub-0
                                   ^^^^^^^
                                   ↑ subscribe to a topic — receive all messages there
```

### 3.2 STOMP Message Flow

```
                         Spring Server
                    ┌─────────────────────────────────────┐
                    │                                     │
Client ─SEND──────► │ /app/* → @MessageMapping methods   │
       destination  │   @MessageMapping("/chat")          │
       /app/chat    │     processes message               │
                    │     publishes to /topic/messages    │
                    │                                     │
Client ◄─MESSAGE──  │ /topic/* → subscribed clients      │
       destination  │   all subscribers of /topic/messages│
       /topic/msg   │   receive the message               │
                    │                                     │
Client ─SUBSCRIBE─► │ /topic/messages                    │
                    └─────────────────────────────────────┘
```

---

## 4. STOMP Server Configuration

### 4.1 `@EnableWebSocketMessageBroker` Configuration

```java
@Configuration
@EnableWebSocketMessageBroker
public class StompWebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 1. In-memory message broker for these destination prefixes
        registry.enableSimpleBroker(
            "/topic",   // pub-sub: broadcast to all subscribers
            "/queue"    // point-to-point: send to specific user
        );

        // 2. Prefix for messages that go to @MessageMapping methods
        registry.setApplicationDestinationPrefixes("/app");

        // 3. Prefix for user-specific destinations (see Section 7)
        registry.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry
            .addEndpoint("/ws")                          // WebSocket handshake endpoint
            .setAllowedOriginPatterns("*")               // CORS — restrict in production!
            .withSockJS();                               // SockJS fallback (see Section 10)
    }

    // Optional: configure message size limits
    @Override
    public void configureWebSocketTransport(WebSocketTransportRegistration registration) {
        registration
            .setMessageSizeLimit(64 * 1024)     // max message size: 64KB
            .setSendTimeLimit(20 * 1000)          // 20 seconds to send a message
            .setSendBufferSizeLimit(512 * 1024);  // 512KB send buffer
    }
}
```

### 4.2 Destination Prefix Summary

```
/app/*      → Routed to @MessageMapping methods (application logic)
/topic/*    → Simple broker pub-sub (broadcast to subscribers)
/queue/*    → Simple broker point-to-point (per-user queues)
/user/*     → Resolved to user-specific destination (/user/queue/reply → /queue/reply-username)

Client SEND:        destination=/app/chat.send  → goes to @MessageMapping("/chat.send")
Client SUBSCRIBE:   destination=/topic/chat-room → receives all messages published there
Server broadcast:   simpBroker.convertAndSend("/topic/chat-room", msg)
Server private:     simpBroker.convertAndSendToUser("alice", "/queue/reply", msg)
```

---

## 5. `@MessageMapping` and `@SendTo` — Receive and Broadcast

### 5.1 Basic Message Handling

```java
@Controller
public class ChatController {

    // @MessageMapping: receives messages sent to /app/chat.send
    // @SendTo: broadcasts return value to all subscribers of /topic/public
    @MessageMapping("/chat.send")
    @SendTo("/topic/public")
    public ChatMessage sendMessage(
            @Payload ChatMessage message,            // deserialized from JSON
            @Header("simpSessionId") String sessionId, // STOMP session ID
            Principal principal) {                   // authenticated user

        // Enrich the message with server-side data
        return new ChatMessage(
            principal.getName(),    // username from authentication
            message.content(),
            Instant.now()
        );
        // Return value is automatically serialized to JSON
        // and published to /topic/public for all subscribers
    }

    // Handle user joining the chat
    @MessageMapping("/chat.join")
    @SendTo("/topic/public")
    public ChatMessage addUser(
            @Payload ChatMessage message,
            SimpMessageHeaderAccessor headerAccessor) {

        // Store username in WebSocket session
        headerAccessor.getSessionAttributes()
            .put("username", message.username());

        return new ChatMessage(message.username(), "joined the chat", Instant.now());
    }
}

// Message DTO
public record ChatMessage(
    String username,
    String content,
    Instant timestamp
) {}
```

### 5.2 `@Payload` and `@Header` Annotations

```java
@MessageMapping("/orders")
public void processOrder(
        @Payload OrderRequest order,                  // message body (JSON deserialized)
        @Header("Authorization") String authToken,    // STOMP header
        @Header("simpSessionId") String sessionId,    // auto-added by Spring
        @Header(value = "requestId", required = false) String requestId, // optional
        @Headers Map<String, Object> allHeaders,      // all headers as map
        SimpMessageHeaderAccessor accessor,           // full accessor
        Principal principal) {                        // authenticated user
    // ...
}
```

### 5.3 `@SubscribeMapping` — Handle Subscribe Event

```java
// Called when a client subscribes — send initial data
@SubscribeMapping("/initial-data")
public InitialData onSubscribe(Principal principal) {
    // Return value goes directly to the subscribing client (not broadcast)
    return dataService.getInitialData(principal.getName());
}
// Client subscribes to /app/initial-data and immediately receives the data
// (NOTE: @SubscribeMapping returns directly to subscriber by default,
//  unlike @MessageMapping which routes through the broker)
```

### 5.4 `@SendTo` with Dynamic Destinations

```java
@MessageMapping("/room/{roomId}/chat")
@SendTo("/topic/room/{roomId}")
public ChatMessage chatInRoom(
        @Payload ChatMessage message,
        @DestinationVariable String roomId,   // like @PathVariable for WebSocket
        Principal principal) {
    return new ChatMessage(principal.getName(), message.content(), Instant.now());
}
// Client sends to: /app/room/general/chat
// Message broadcast to: /topic/room/general
```

---

## 6. `SimpMessagingTemplate` — Push from Anywhere

### 6.1 What `SimpMessagingTemplate` Is

`SimpMessagingTemplate` is the WebSocket equivalent of `RestTemplate` for pushing messages. It can be injected anywhere in the application layer — services, scheduled tasks, event listeners — not just controllers.

```java
@Service
public class NotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public NotificationService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    // Broadcast to ALL subscribers of a topic
    public void broadcastPriceUpdate(PriceUpdate update) {
        messagingTemplate.convertAndSend("/topic/prices", update);
    }

    // Send to a SPECIFIC user (see Section 7)
    public void sendOrderConfirmation(String username, OrderConfirmation confirmation) {
        messagingTemplate.convertAndSendToUser(username, "/queue/orders", confirmation);
    }

    // With custom headers
    public void broadcastWithHeaders(Object payload) {
        SimpMessageHeaderAccessor headers = SimpMessageHeaderAccessor.create();
        headers.setNativeHeader("event-type", "PRICE_UPDATE");
        headers.setNativeHeader("timestamp", Instant.now().toString());

        messagingTemplate.convertAndSend("/topic/prices", payload, headers.getMessageHeaders());
    }
}
```

### 6.2 Pushing from Scheduled Tasks

```java
@Component
public class LiveDashboardScheduler {

    private final SimpMessagingTemplate template;
    private final MetricsService metricsService;

    // Push live metrics every 2 seconds
    @Scheduled(fixedDelay = 2000)
    public void pushMetrics() {
        DashboardMetrics metrics = metricsService.getCurrentMetrics();
        template.convertAndSend("/topic/dashboard", metrics);
    }

    // Push stock prices every 500ms
    @Scheduled(fixedDelay = 500)
    public void pushStockPrices() {
        List<StockPrice> prices = stockService.getAllCurrentPrices();
        template.convertAndSend("/topic/stocks", prices);
    }
}
```

### 6.3 Pushing from Event Listeners

```java
@Component
public class OrderEventListener {

    private final SimpMessagingTemplate template;

    // Listen to Spring application events and push to WebSocket clients
    @EventListener
    public void onOrderPlaced(OrderPlacedEvent event) {
        // Notify all users watching the orders dashboard
        template.convertAndSend("/topic/orders/new", event.getOrder());

        // Notify the specific customer who placed the order
        template.convertAndSendToUser(
            event.getOrder().getCustomerUsername(),
            "/queue/my-orders",
            new OrderNotification("Your order #" + event.getOrder().getId() + " was placed!")
        );
    }

    @EventListener
    @Async
    public void onOrderShipped(OrderShippedEvent event) {
        template.convertAndSendToUser(
            event.getOrder().getCustomerUsername(),
            "/queue/my-orders",
            new OrderNotification("Order #" + event.getOrder().getId() + " has shipped!")
        );
    }
}
```

---

## 7. User-Specific Messages — `@SendToUser` and `convertAndSendToUser()`

### 7.1 How User Routing Works

```
/user/{username}/queue/reply
       ↑
       Spring resolves this to the specific session(s) for that user
       (a user may have multiple tabs open = multiple sessions)
```

### 7.2 `@SendToUser` on Controller Methods

```java
@Controller
public class PrivateMessageController {

    // Client sends to /app/private-message
    // Response goes ONLY to the sending user's /queue/reply
    @MessageMapping("/private-message")
    @SendToUser("/queue/reply")            // only the sender receives this
    public PrivateMessage handlePrivateMessage(
            @Payload PrivateMessage message,
            Principal principal) {

        // Return value goes to /user/{sender}/queue/reply
        return new PrivateMessage(
            "server",
            principal.getName(),
            "Your message was received: " + message.content()
        );
    }

    // Server sends a private message to another user
    @MessageMapping("/send-to-user")
    public void sendToUser(@Payload DirectMessage dm, Principal principal) {
        // Spring will route this to /user/{dm.recipient}/queue/messages
        messagingTemplate.convertAndSendToUser(
            dm.recipient(),
            "/queue/messages",
            new DirectMessage(principal.getName(), dm.recipient(), dm.content())
        );
    }
}
```

### 7.3 `convertAndSendToUser()` from Service Layer

```java
@Service
public class AlertService {

    private final SimpMessagingTemplate template;

    // Send a personal alert to a specific user
    public void sendAlert(String username, String alertMessage) {
        template.convertAndSendToUser(
            username,                 // username — must match Principal.getName()
            "/queue/alerts",          // user's personal queue (prefixed with /user internally)
            new Alert(alertMessage, Instant.now())
        );
        // This delivers to: /user/{username}/queue/alerts
        // Spring finds all sessions for this username and delivers to each
    }

    // Send to multiple users (e.g., all admins)
    public void notifyAdmins(String message) {
        adminRepository.findAllAdminUsernames()
            .forEach(admin -> sendAlert(admin, message));
    }
}
```

### 7.4 JavaScript Client for User-Specific Messages

```javascript
const client = new Client({
    brokerURL: 'ws://localhost:8080/ws',
    onConnect: () => {
        // Subscribe to personal queue
        client.subscribe('/user/queue/alerts', (message) => {
            const alert = JSON.parse(message.body);
            showAlert(alert);
        });

        // Subscribe to personal order updates
        client.subscribe('/user/queue/my-orders', (message) => {
            const notification = JSON.parse(message.body);
            updateOrderStatus(notification);
        });
    }
});
```

### 7.5 User Identity — How Spring Knows the User

```java
// Spring uses Principal.getName() to identify the user
// The Principal comes from Spring Security authentication

// Config: tell Spring to pass authentication as Principal
@Override
public void configureClientInboundChannel(ChannelRegistration registration) {
    registration.interceptors(new UserInterceptor());
}

public class UserInterceptor implements ChannelInterceptor {
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(
            message, StompHeaderAccessor.class);

        if (StompCommand.CONNECT.equals(accessor.getCommand())) {
            // Extract user from JWT or session — see Section 9 for full auth
            Authentication auth = getAuthFromHeaders(accessor);
            accessor.setUser(auth);
        }
        return message;
    }
}
```

---

## 8. External Broker — RabbitMQ / ActiveMQ Relay

### 8.1 Why External Broker?

The in-memory simple broker works only for a **single server instance**. In a horizontally-scaled environment:

```
Without external broker:
  Server 1 ← User Alice connected
  Server 2 ← User Bob connected

  Message sent to /topic/chat on Server 1:
  → Alice sees it (connected to Server 1)
  → Bob does NOT see it (connected to Server 2)
  → Messages are NOT shared between instances!

With external broker (RabbitMQ/ActiveMQ):
  Server 1 ──STOMP──► RabbitMQ ──STOMP──► Server 1 → Alice
                             └──STOMP──► Server 2 → Bob
  → Both Alice and Bob see all messages
  → Works across any number of server instances
```

### 8.2 RabbitMQ STOMP Relay Configuration

```xml
<!-- Enable STOMP plugin in RabbitMQ -->
<!-- rabbitmq-plugins enable rabbitmq_stomp -->

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>
<!-- No extra dependency needed — Spring uses STOMP over TCP to connect to RabbitMQ -->
```

```java
@Configuration
@EnableWebSocketMessageBroker
public class RabbitMQWebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Value("${rabbitmq.host:localhost}")
    private String rabbitHost;

    @Value("${rabbitmq.stomp.port:61613}")
    private int rabbitStompPort;

    @Value("${rabbitmq.username:guest}")
    private String rabbitUser;

    @Value("${rabbitmq.password:guest}")
    private String rabbitPassword;

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // Replace in-memory broker with RabbitMQ as STOMP relay
        registry.enableStompBrokerRelay("/topic", "/queue")
            .setRelayHost(rabbitHost)
            .setRelayPort(rabbitStompPort)
            .setClientLogin(rabbitUser)
            .setClientPasscode(rabbitPassword)
            .setSystemLogin(rabbitUser)
            .setSystemPasscode(rabbitPassword)
            // System subscription for server → broker messages (SimpMessagingTemplate)
            .setSystemHeartbeatSendInterval(10_000)    // heartbeat to broker every 10s
            .setSystemHeartbeatReceiveInterval(10_000); // expect heartbeat from broker every 10s

        registry.setApplicationDestinationPrefixes("/app");
        registry.setUserDestinationPrefix("/user");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
            .setAllowedOriginPatterns("*")
            .withSockJS();
    }
}
```

### 8.3 ActiveMQ Relay Configuration

```java
// Same configuration pattern as RabbitMQ — change port and credentials
registry.enableStompBrokerRelay("/topic", "/queue")
    .setRelayHost("activemq.internal")
    .setRelayPort(61613)   // ActiveMQ's STOMP port (same as RabbitMQ STOMP plugin)
    .setClientLogin("admin")
    .setClientPasscode("admin")
    .setSystemLogin("admin")
    .setSystemPasscode("admin");
```

### 8.4 Durable Subscriptions with RabbitMQ

```java
// RabbitMQ with durable queues: messages survive broker restart
// Client subscribes to: /queue/notifications (RabbitMQ durable queue)
// vs. /topic/notifications (RabbitMQ fanout — non-durable)

// Configure durable subscription headers:
@Override
public void configureClientInboundChannel(ChannelRegistration registration) {
    registration.interceptors(new DurableSubscriptionInterceptor());
}

public class DurableSubscriptionInterceptor implements ChannelInterceptor {
    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(
            message, StompHeaderAccessor.class);

        if (StompCommand.SUBSCRIBE.equals(accessor.getCommand())) {
            // RabbitMQ durable queue headers
            accessor.setNativeHeader("durable", "true");
            accessor.setNativeHeader("auto-delete", "false");
        }
        return message;
    }
}
```

---

## 9. WebSocket Security

### 9.1 Authentication on CONNECT

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketSecurityConfig extends AbstractSecurityWebSocketMessageBrokerConfigurer {

    @Override
    protected void configureInbound(MessageSecurityMetadataSourceRegistry messages) {
        messages
            // Allow unauthenticated CONNECT (auth happens in interceptor)
            .simpTypeMatchers(SimpMessageType.CONNECT).permitAll()
            // Require authentication for all subscriptions and message sends
            .simpTypeMatchers(SimpMessageType.SUBSCRIBE, SimpMessageType.MESSAGE)
                .authenticated()
            // Destination-based authorization
            .simpDestMatchers("/app/**").authenticated()
            .simpDestMatchers("/topic/public").permitAll()         // public topic
            .simpDestMatchers("/topic/admin/**").hasRole("ADMIN")  // admin only
            .simpSubscribeDestMatchers("/user/**").authenticated() // user-specific subscriptions
            .anyMessage().denyAll(); // deny everything else
    }

    @Override
    protected boolean sameOriginDisabled() {
        // Disable CSRF check for WebSocket (CSRF attacks don't work the same way)
        return true;
    }
}
```

### 9.2 JWT Authentication in WebSocket CONNECT

```java
@Component
public class JwtChannelInterceptor implements ChannelInterceptor {

    private final JwtService jwtService;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(
            message, StompHeaderAccessor.class);

        if (StompCommand.CONNECT.equals(accessor.getCommand())) {
            // Extract JWT from STOMP CONNECT header
            String authHeader = accessor.getFirstNativeHeader("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                try {
                    Authentication auth = jwtService.getAuthentication(token);
                    accessor.setUser(auth);  // set user for this WebSocket session
                    log.debug("WebSocket authenticated: {}", auth.getName());
                } catch (JwtException e) {
                    log.warn("Invalid JWT in WebSocket CONNECT: {}", e.getMessage());
                    throw new MessagingException("Invalid token");
                }
            } else {
                throw new MessagingException("Authorization header required");
            }
        }
        return message;
    }
}

// Register the interceptor:
@Override
public void configureClientInboundChannel(ChannelRegistration registration) {
    registration.interceptors(jwtChannelInterceptor);
}
```

### 9.3 JavaScript Client Authentication

```javascript
import { Client } from '@stomp/stompjs';

const token = localStorage.getItem('jwt-token');

const client = new Client({
    brokerURL: 'ws://localhost:8080/ws',

    connectHeaders: {
        // Sent in the STOMP CONNECT frame headers
        Authorization: `Bearer ${token}`,
        login: username,
        passcode: password
    },

    reconnectDelay: 5000,

    onConnect: (frame) => {
        console.log('Connected:', frame);
        subscribeToTopics();
    },

    onStompError: (frame) => {
        console.error('STOMP error:', frame.headers['message'], frame.body);
    },

    onDisconnect: () => {
        console.log('Disconnected');
    }
});

client.activate();
```

### 9.4 Session Management and Disconnect Events

```java
@Component
public class WebSocketEventListener {

    private final SimpMessagingTemplate messagingTemplate;

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String username = accessor.getUser() != null
            ? accessor.getUser().getName() : "anonymous";
        log.info("New WebSocket connection: {}", username);
    }

    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String username = (String) Objects.requireNonNull(accessor.getSessionAttributes())
            .get("username");

        if (username != null) {
            log.info("User disconnected: {}", username);
            // Notify others
            messagingTemplate.convertAndSend("/topic/public",
                new ChatMessage("Server", username + " left the chat", Instant.now()));
        }
    }
}
```

---

## 10. SockJS Fallback

### 10.1 What SockJS Does

Some corporate firewalls and proxies block WebSocket connections (they inspect HTTP upgrades). SockJS provides a fallback with the same API:

```
SockJS fallback chain (tried in order):
  1. WebSocket (native, fastest)
  2. xhr-streaming (EventSource-like, no WebSocket)
  3. xhr-polling (HTTP long polling, works everywhere)

Client code is identical regardless of transport chosen.
SockJS negotiates the best available transport automatically.
```

### 10.2 Server Configuration

```java
@Override
public void registerStompEndpoints(StompEndpointRegistry registry) {
    registry.addEndpoint("/ws")
        .setAllowedOriginPatterns("https://myapp.com", "http://localhost:3000")
        .withSockJS()                              // enable SockJS
            .setHeartbeatTime(25_000)              // 25s heartbeat to keep connection alive
            .setDisconnectDelay(5_000)             // 5s grace period before considering disconnected
            .setHttpMessageCacheSize(1000)         // messages to buffer during reconnect
            .setStreamBytesLimit(512 * 1024);      // 512KB stream limit before cycling
}
```

### 10.3 JavaScript Client with SockJS + STOMP

```javascript
import SockJS from 'sockjs-client';
import { Client } from '@stomp/stompjs';

const client = new Client({
    // Use SockJS as the WebSocket factory instead of native WebSocket
    webSocketFactory: () => new SockJS('http://localhost:8080/ws'),

    connectHeaders: {
        Authorization: `Bearer ${getToken()}`
    },

    reconnectDelay: 5000,   // auto-reconnect after 5s

    onConnect: (frame) => {
        console.log('Connected via:', frame.headers['heart-beat']);

        // Subscribe to topics
        client.subscribe('/topic/public', (message) => {
            displayMessage(JSON.parse(message.body));
        });

        client.subscribe('/user/queue/alerts', (message) => {
            showAlert(JSON.parse(message.body));
        });

        // Send a message
        client.publish({
            destination: '/app/chat.send',
            body: JSON.stringify({ content: 'Hello!' }),
            headers: { priority: '5' }
        });
    },

    onStompError: (frame) => {
        console.error('Broker error:', frame.headers['message']);
    }
});

client.activate();

// Graceful disconnect
function disconnect() {
    client.deactivate();
}
```

---

## 11. Real-World Use Cases with Full Examples

### 11.1 Live Chat Application

```java
@Controller
public class ChatController {

    @MessageMapping("/chat.send")
    @SendTo("/topic/room.{roomId}")
    public ChatMessage sendMessage(
            @Payload ChatMessage message,
            @DestinationVariable String roomId,
            Principal principal) {
        return new ChatMessage(
            principal.getName(),
            sanitize(message.content()),  // XSS prevention
            roomId,
            Instant.now()
        );
    }

    @MessageMapping("/chat.join")
    public void joinRoom(
            @Payload JoinMessage join,
            Principal principal,
            SimpMessageHeaderAccessor headerAccessor) {
        headerAccessor.getSessionAttributes()
            .put("currentRoom", join.roomId());

        messagingTemplate.convertAndSend(
            "/topic/room." + join.roomId(),
            new ChatMessage("System",
                principal.getName() + " joined", join.roomId(), Instant.now()));
    }

    private String sanitize(String content) {
        // Remove HTML tags, escape special characters
        return HtmlUtils.htmlEscape(content);
    }
}
```

### 11.2 Real-Time Dashboard (Server Push)

```java
@Service
public class RealtimeDashboardService {

    private final SimpMessagingTemplate template;
    private final MetricsCollector metrics;

    @Scheduled(fixedRate = 1000)  // push every second
    public void pushDashboardMetrics() {
        DashboardData data = DashboardData.builder()
            .activeUsers(metrics.getActiveUserCount())
            .requestsPerSecond(metrics.getCurrentRps())
            .errorRate(metrics.getErrorRate())
            .cpuUsage(metrics.getCpuUsage())
            .memoryUsage(metrics.getMemoryUsage())
            .timestamp(Instant.now())
            .build();

        template.convertAndSend("/topic/dashboard/metrics", data);
    }

    @Scheduled(fixedRate = 5000)  // push every 5 seconds
    public void pushTopErrors() {
        List<ErrorSummary> errors = metrics.getTopErrors(10);
        template.convertAndSend("/topic/dashboard/errors", errors);
    }
}
```

### 11.3 Live Notifications

```java
// Send notification to specific user from any service
@Service
public class NotificationService {

    private final SimpMessagingTemplate template;
    private final NotificationRepository repository;

    public void sendNotification(String username, NotificationType type, String message) {
        Notification notification = Notification.builder()
            .id(UUID.randomUUID().toString())
            .type(type)
            .message(message)
            .read(false)
            .createdAt(Instant.now())
            .build();

        // Persist
        repository.save(notification.withUsername(username));

        // Push to connected client (no-op if user is offline — they'll see it on next login)
        template.convertAndSendToUser(username, "/queue/notifications", notification);
    }
}

// Controller to acknowledge notifications
@MessageMapping("/notifications.read")
public void markAsRead(@Payload String notificationId, Principal principal) {
    notificationService.markRead(principal.getName(), notificationId);
    // No response needed — fire and forget
}
```

### 11.4 Collaborative Editing (Operational Transform)

```java
@Controller
public class CollaborativeEditorController {

    private final DocumentService documentService;
    private final SimpMessagingTemplate template;

    // User edits a document
    @MessageMapping("/doc/{docId}/edit")
    public void handleEdit(
            @Payload DocumentEdit edit,
            @DestinationVariable String docId,
            Principal principal) {

        // Apply operation transformation to prevent conflicts
        DocumentEdit transformed = documentService.transform(docId, edit);
        documentService.applyEdit(docId, transformed);

        // Broadcast the edit to all editors of this document
        // EXCLUDING the sender (they already applied it locally)
        template.convertAndSend(
            "/topic/doc." + docId,
            new EditBroadcast(
                principal.getName(),
                transformed,
                documentService.getVersion(docId)
            )
        );
    }

    // Client subscribes to a document's changes
    @SubscribeMapping("/doc/{docId}/state")
    public DocumentState getDocumentState(@DestinationVariable String docId) {
        // Sent directly to the subscribing client as initial state
        return documentService.getCurrentState(docId);
    }
}
```

---

## 12. Quick Reference Cheat Sheet

### Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>
```

### Configuration Pattern

```java
// Raw WebSocket
@Configuration
@EnableWebSocket
public class Config implements WebSocketConfigurer {
    void registerWebSocketHandlers(registry) {
        registry.addHandler(handler, "/ws").withSockJS();
    }
}

// STOMP
@Configuration
@EnableWebSocketMessageBroker
public class Config implements WebSocketMessageBrokerConfigurer {
    void configureMessageBroker(registry) {
        registry.enableSimpleBroker("/topic", "/queue");  // in-memory
        // OR: registry.enableStompBrokerRelay("/topic", "/queue")  // RabbitMQ/ActiveMQ
        registry.setApplicationDestinationPrefixes("/app");
        registry.setUserDestinationPrefix("/user");
    }
    void registerStompEndpoints(registry) {
        registry.addEndpoint("/ws").withSockJS();
    }
}
```

### Controller Annotations

```java
@MessageMapping("/path")      // receives messages sent to /app/path
@SendTo("/topic/dest")        // broadcast return value to all subscribers
@SendToUser("/queue/reply")   // send return value to sender only
@SubscribeMapping("/init")    // handle SUBSCRIBE, return initial data
@DestinationVariable          // like @PathVariable for WebSocket destinations
@Payload                      // message body (deserialized)
@Header("name")               // specific STOMP header
```

### `SimpMessagingTemplate`

```java
// Broadcast
template.convertAndSend("/topic/name", payload);

// User-specific
template.convertAndSendToUser("username", "/queue/name", payload);

// With headers
template.convertAndSend("/topic/name", payload, headers);
```

### Destination Reference

```
Client sends to:        /app/chat           → @MessageMapping("/chat")
Client subscribes to:   /topic/public       → receives broadcasts
                        /queue/user-123     → receives user-specific
                        /user/queue/replies → receives @SendToUser responses
Server broadcasts to:   /topic/public       → all subscribers
Server targets to:      convertAndSendToUser("alice", "/queue/x", msg) → /user/alice/queue/x
```

### External Broker (Multi-Instance)

```java
registry.enableStompBrokerRelay("/topic", "/queue")
    .setRelayHost("rabbitmq.host").setRelayPort(61613)
    .setClientLogin("user").setClientPasscode("pass")
    .setSystemLogin("user").setSystemPasscode("pass");
```

### JavaScript STOMP Client

```javascript
const client = new Client({
    webSocketFactory: () => new SockJS('/ws'),
    connectHeaders: { Authorization: `Bearer ${token}` },
    onConnect: () => {
        client.subscribe('/topic/public', msg => console.log(JSON.parse(msg.body)));
        client.subscribe('/user/queue/alerts', msg => showAlert(JSON.parse(msg.body)));
        client.publish({ destination: '/app/chat', body: JSON.stringify({text: 'hi'}) });
    }
});
client.activate();
```

### Key Rules to Remember

1. **`/app/*` → controller, `/topic/*` → broker** — don't confuse client send destination with subscribe destination.
2. **`convertAndSendToUser` uses `Principal.getName()`** — the username must match exactly.
3. **`@SendToUser` on controller = only the sender gets it** — for private responses to the requester.
4. **In-memory broker = single instance only** — use RabbitMQ/ActiveMQ relay for horizontal scaling.
5. **JWT auth happens in CONNECT interceptor** — not in HTTP security filter.
6. **SockJS requires `http://` not `ws://`** — the SockJS client handles the upgrade.
7. **Synchronize on `session.sendMessage()`** — WebSocket sessions are not thread-safe for concurrent sends.
8. **`@SubscribeMapping` returns directly to subscriber** — unlike `@MessageMapping` which routes through broker.
9. **`sameOriginDisabled=true`** — required in `AbstractSecurityWebSocketMessageBrokerConfigurer` because CSRF tokens don't apply to WebSocket.
10. **`/user/{username}/queue/x` delivers to ALL sessions for that user** — a user with 3 browser tabs gets 3 copies.

---

*End of WebSocket with Spring Study Guide — Module 9*
