# Session Management & Spring Session — Complete Study Guide

> **Module 7 | Brutally Detailed Reference**
> Covers `HttpSession` fundamentals, JSESSIONID, session security (fixation, concurrent, policies), Spring Session with Redis and JDBC, session serialization, WebSocket session integration, and remember-me with persistent tokens. Full working examples throughout.

---

## Table of Contents

1. [Session Fundamentals](#1-session-fundamentals)
2. [Session Security](#2-session-security)
3. [Stateless (JWT) vs Stateful (Sessions)](#3-stateless-jwt-vs-stateful-sessions)
4. [Spring Session — Why and How](#4-spring-session--why-and-how)
5. [Redis-Backed Sessions](#5-redis-backed-sessions)
6. [JDBC-Backed Sessions](#6-jdbc-backed-sessions)
7. [Session Serialization](#7-session-serialization)
8. [TTL, Cleanup, and `FindByIndexNameSessionRepository`](#8-ttl-cleanup-and-findbyindexnamesessionrepository)
9. [Session + WebSocket](#9-session--websocket)
10. [Remember-Me with Persistent Tokens](#10-remember-me-with-persistent-tokens)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. Session Fundamentals

### 1.1 What Is `HttpSession`?

`HttpSession` is a server-side object that stores data across multiple HTTP requests from the same client. HTTP is stateless — sessions are how servers remember state between requests.

```
Request 1:  GET /login  → server creates session, returns JSESSIONID cookie
Request 2:  POST /login → browser sends JSESSIONID → server finds session → stores user
Request 3:  GET /profile → browser sends JSESSIONID → server finds session → reads user

Without sessions: server can't tell requests 1, 2, 3 are from the same browser.
With sessions:    server maintains per-user state between stateless HTTP requests.
```

### 1.2 `HttpSession` API

```java
@RestController
public class SessionDemoController {

    @PostMapping("/login")
    public ResponseEntity<String> login(
            HttpServletRequest request,
            @RequestBody LoginRequest loginRequest) {

        // Get existing session or create a new one
        HttpSession session = request.getSession();           // create if absent
        HttpSession existing = request.getSession(false);    // null if no session

        // Store attributes
        session.setAttribute("userId", authenticatedUser.getId());
        session.setAttribute("username", authenticatedUser.getUsername());
        session.setAttribute("roles", authenticatedUser.getRoles());
        session.setAttribute("loginTime", Instant.now());

        // Session metadata
        String sessionId = session.getId();
        long created = session.getCreationTime();              // milliseconds epoch
        long lastAccess = session.getLastAccessedTime();       // milliseconds epoch
        int timeout = session.getMaxInactiveInterval();        // seconds (-1 = never)

        return ResponseEntity.ok("Logged in. Session: " + sessionId);
    }

    @GetMapping("/profile")
    public ResponseEntity<UserProfile> getProfile(HttpSession session) {
        // Read from session
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(userService.getProfile(userId));
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(HttpSession session) {
        // Invalidate session — removes all attributes, deletes server-side state
        session.invalidate();
        return ResponseEntity.ok("Logged out");
    }

    // Modify session timeout per-session
    @PostMapping("/extend-session")
    public void extendSession(HttpSession session) {
        session.setMaxInactiveInterval(60 * 60); // 1 hour for this session
    }
}
```

### 1.3 `JSESSIONID` Cookie

When a session is created, the server sends a `Set-Cookie` header:

```
HTTP/1.1 200 OK
Set-Cookie: JSESSIONID=5A7D3E8F0B2C1D4E6A9B0C2D; Path=/; HttpOnly

Attributes:
  JSESSIONID=5A7D3E8F0B2C1D4E6A9B0C2D   — the session identifier
  Path=/                                  — sent with every request
  HttpOnly                               — not accessible from JavaScript (XSS protection)
  Secure                                  — only sent over HTTPS (should ALWAYS be set in production)
  SameSite=Lax                           — CSRF protection

On subsequent requests:
  Cookie: JSESSIONID=5A7D3E8F0B2C1D4E6A9B0C2D
```

### 1.4 Session Timeout Configuration

```yaml
# application.yml
server:
  servlet:
    session:
      timeout: 30m              # 30 minutes inactivity timeout (default: 30m)
      cookie:
        name: JSESSIONID        # cookie name (default)
        http-only: true         # prevent JavaScript access (default: true)
        secure: true            # HTTPS only (default: false — set true in production!)
        same-site: strict       # CSRF protection: strict, lax, none
        max-age: -1             # -1 = session cookie (deleted when browser closes)
        path: /                 # cookie path
      tracking-modes: cookie    # cookie (default), url (path param), ssl (SSL session)
```

```java
// Programmatic per-session timeout override
@Bean
public HttpSessionListener sessionListener() {
    return new HttpSessionListener() {
        @Override
        public void sessionCreated(HttpSessionEvent se) {
            se.getSession().setMaxInactiveInterval(1800); // 30 minutes
        }
    };
}

// Detect session expiry
@Bean
public HttpSessionListener sessionExpiryListener() {
    return new HttpSessionListener() {
        @Override
        public void sessionDestroyed(HttpSessionEvent se) {
            HttpSession session = se.getSession();
            Long userId = (Long) session.getAttribute("userId");
            if (userId != null) {
                log.info("Session expired for user: {}", userId);
                // Cleanup: release locks, update last-seen, etc.
            }
        }
    };
}
```

### 1.5 URL-Based Session Tracking (Avoid in Production)

```
URL rewriting: http://example.com/page;jsessionid=ABC123
  - Used when cookies are disabled
  - NEVER use in production: session ID visible in browser history, logs, referrer headers
  - Disable explicitly:
server.servlet.session.tracking-modes=cookie  # cookie only, no URL rewriting
```

---

## 2. Session Security

### 2.1 Session Fixation Attack and Protection

**Session fixation** is an attack where an attacker sets a known session ID before the victim logs in:

```
Attack scenario:
1. Attacker gets a session ID: JSESSIONID=ATTACKER_KNOWN_ID
2. Attacker tricks victim into using that session ID (link, form)
3. Victim logs in at /login — server authenticates the victim
4. If server keeps the SAME session ID after login...
5. Attacker's cookie ATTACKER_KNOWN_ID now has victim's session → account takeover!

Protection: After login, CREATE A NEW SESSION with a new ID.
            The old session ID becomes invalid.
```

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .sessionManagement(session -> session
                // MIGRATE_SESSION (default): create new session, copy attributes from old
                // Most secure: old ID is invalidated, attributes preserved
                .sessionFixation(sf -> sf.migrateSession())

                // Other options:
                // .newSession()     — new session, DON'T copy old attributes (most secure)
                // .changeSessionId() — same session, change ID only (Servlet 3.1+, efficient)
                // .none()           — don't change session on login (INSECURE)
            )
            .build();
    }
}
```

**What `migrateSession()` does:**
```
Before login:   Session ID = AAAA, attributes = {visitorId=123}
User logs in:
After login:    Session ID = BBBB (new!), attributes = {visitorId=123, userId=42} (migrated)
Old session AAAA is invalidated — attacker's known ID no longer works.
```

### 2.2 Concurrent Session Control

Prevent a user from being logged in from multiple locations simultaneously:

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    return http
        .sessionManagement(session -> session
            .maximumSessions(1)                     // allow only 1 concurrent session per user
            .maxSessionsPreventsLogin(false)         // false = expire OLD session (default)
                                                     // true = prevent NEW login
            .expiredUrl("/login?session=expired")    // redirect when session is expired by new login
            .sessionRegistry(sessionRegistry())      // track sessions (required)
        )
        .build();
}

@Bean
public SessionRegistry sessionRegistry() {
    return new SessionRegistryImpl();
}

// Required: Spring Security needs to know about session creation/destruction
@Bean
public HttpSessionEventPublisher httpSessionEventPublisher() {
    return new HttpSessionEventPublisher();
    // This publishes HttpSessionCreatedEvent / HttpSessionDestroyedEvent
    // SessionRegistryImpl listens to these to track active sessions
}
```

**Behavior difference:**
```
maxSessionsPreventsLogin(false) — default "kick old session":
  User logs in on phone → session A created
  User logs in on laptop → session A EXPIRED, session B created
  Phone: next request → redirected to /login?session=expired
  Laptop: actively logged in

maxSessionsPreventsLogin(true) — "reject new login":
  User logs in on phone → session A created
  User tries to log in on laptop → LOGIN REJECTED with error
  Phone: still actively logged in
```

### 2.3 Listing and Managing Active Sessions

```java
@Service
public class SessionManagementService {

    private final SessionRegistry sessionRegistry;

    // Find all active sessions for a specific user
    public List<SessionInformation> getSessionsForUser(String username) {
        return sessionRegistry.getAllSessions(username, false); // false = exclude expired
    }

    // Force logout a user (expire all their sessions)
    public void forceLogout(String username) {
        sessionRegistry.getAllSessions(username, false)
            .forEach(SessionInformation::expireNow);
    }

    // Get all currently logged-in users
    public List<String> getAllLoggedInUsers() {
        return sessionRegistry.getAllPrincipals().stream()
            .filter(p -> !sessionRegistry.getAllSessions(p, false).isEmpty())
            .map(p -> ((UserDetails) p).getUsername())
            .collect(Collectors.toList());
    }
}
```

### 2.4 Session Creation Policies

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    return http
        .sessionManagement(session -> session
            .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED) // default
        )
        .build();
}
```

| Policy | Behavior | Use Case |
|---|---|---|
| `ALWAYS` | Always create a session | Legacy apps, tracking anonymous users |
| `IF_REQUIRED` | Create only when needed (default) | Standard web applications |
| `NEVER` | Never create, but USE if it exists | Microservice that should be stateless but allows gateway-created sessions |
| `STATELESS` | Never create, never use | Pure REST APIs with JWT, completely stateless |

```java
// STATELESS — for REST APIs with JWT
http.sessionManagement(session ->
    session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
// No session created, no JSESSIONID cookie sent
// Every request must carry its own credentials (JWT in header)

// IF_REQUIRED — for web apps (default)
http.sessionManagement(session ->
    session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED));
// Session created when needed (first authenticated request, CSRF token, etc.)
```

---

## 3. Stateless (JWT) vs Stateful (Sessions)

### 3.1 Comparison

| Aspect | Sessions (Stateful) | JWT (Stateless) |
|---|---|---|
| **Server storage** | Server stores session state | No server storage needed |
| **Scalability** | Requires session sharing (Redis) | Inherently scalable |
| **Token size** | Small cookie (session ID only) | Larger (JWT contains claims) |
| **Revocation** | Immediate (invalidate session) | Hard (must blacklist or wait for expiry) |
| **Logout** | Reliable — delete server state | Unreliable without blacklist |
| **Data access** | Single DB/Redis lookup per request | Token contains data (no lookup) |
| **Cross-domain** | Cookie limitations (SameSite) | Works cross-domain |
| **Mobile clients** | Less natural (cookies) | Natural (Authorization header) |
| **Security** | HttpOnly cookie prevents XSS theft | Stored in localStorage = XSS risk |
| **Concurrent session control** | Easy (track in session store) | Hard (requires server state) |

### 3.2 When to Use Each

```
USE SESSIONS (Stateful) when:
  ✓ Traditional web application with server-rendered pages
  ✓ Need immediate revocation (security-sensitive: banking, admin)
  ✓ Need concurrent session control (1 session per user)
  ✓ Complex session data (shopping cart, wizard state)
  ✓ Browser-based clients only

USE JWT (Stateless) when:
  ✓ REST API consumed by mobile/SPA clients
  ✓ Microservices architecture (service-to-service)
  ✓ Horizontal scaling without shared infrastructure
  ✓ Third-party API integration
  ✓ Short-lived tokens (minutes, not hours)
  ✓ Cross-domain or cross-origin scenarios

HYBRID (common in practice):
  - Session for browser-based authentication
  - JWT for API access tokens within the session
  - Or: JWT for stateless API + Redis blacklist for revocation
```

---

## 4. Spring Session — Why and How

### 4.1 The Problem

Standard `HttpSession` is stored in JVM memory — tied to a single server instance:

```
Without Spring Session (single server works fine):
  Browser → App Server 1 → Session in Server 1 memory
  All requests → App Server 1 → Session always found ✓

Without Spring Session (multiple servers — BROKEN):
  Browser → Load Balancer → App Server 1 → Session created in Server 1 memory
  Browser → Load Balancer → App Server 2 → SESSION NOT FOUND → user logged out!

  Both App Server 1 and 2 have their own independent session stores.
  Load balancer sends requests to any server — session mismatch = auth failure.
```

### 4.2 The Solution — External Session Store

```
With Spring Session (Redis or JDBC):
  Browser → Load Balancer → App Server 1 → Session saved to REDIS
  Browser → Load Balancer → App Server 2 → Session found in REDIS ✓
  Browser → Load Balancer → App Server 3 → Session found in REDIS ✓

  All servers share the same session store — any server can handle any request.
```

### 4.3 Spring Session Transparently Replaces `HttpSession`

Spring Session's magic: it replaces the standard `HttpSession` with its own implementation **transparently**. Your application code calls `httpSession.setAttribute(...)` exactly as before — Spring Session intercepts it and stores in Redis/DB instead:

```java
// This code works identically with in-memory, Redis, or JDBC sessions:
@PostMapping("/login")
public void login(HttpSession session, @RequestBody LoginRequest req) {
    session.setAttribute("user", authenticatedUser); // stored to configured backend
}
// No code changes needed when switching from in-memory to distributed sessions!
```

---

## 5. Redis-Backed Sessions

### 5.1 Dependencies

```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### 5.2 `@EnableRedisHttpSession` Configuration

```java
// Explicit configuration (optional — Spring Boot auto-configures with the dependency)
@Configuration
@EnableRedisHttpSession(
    maxInactiveIntervalInSeconds = 1800,  // 30 minutes
    redisNamespace = "myapp:session",     // Redis key prefix (avoid collisions)
    flushMode = FlushMode.IMMEDIATE,      // IMMEDIATE (sync on every write) or ON_SAVE (on response commit)
    cleanupCron = "0 * * * * *"           // cleanup expired sessions every minute
)
public class RedisSessionConfig {

    // All configuration is done via @EnableRedisHttpSession
    // RedisConnectionFactory is auto-configured from spring.data.redis.*

    // Optional: customize cookie configuration
    @Bean
    public CookieSerializer cookieSerializer() {
        DefaultCookieSerializer serializer = new DefaultCookieSerializer();
        serializer.setCookieName("SESSION");            // custom cookie name
        serializer.setHttpOnly(true);
        serializer.setUseSecureCookie(true);            // HTTPS only
        serializer.setSameSite("Strict");               // CSRF protection
        serializer.setCookieMaxAge(-1);                 // -1 = session cookie (browser close = delete)
        serializer.setDomainNamePattern("^.+?\\.(\\w+\\.[a-z]+)$"); // share across subdomains
        return serializer;
    }
}
```

### 5.3 application.yml for Redis Sessions

```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password: ${REDIS_PASSWORD}
      timeout: 2000ms
      # Connection pool
      lettuce:
        pool:
          max-active: 10
          max-idle: 5
          min-idle: 1

  session:
    store-type: redis           # explicitly choose Redis (auto-detected but good to be explicit)
    redis:
      namespace: myapp:session  # Redis key prefix
      flush-mode: immediate     # or: on-save
      cleanup-cron: "0 * * * * *"  # cron: run cleanup every minute
    timeout: 30m                # session timeout
```

### 5.4 What Redis Stores

```
Redis keys created by Spring Session:

spring:session:sessions:{sessionId}       — Hash with all session attributes
spring:session:sessions:expires:{sessionId} — String with expiry (TTL-based)
spring:session:expirations:{minuteBucket}   — Set of session IDs expiring in this minute

Inspecting in Redis CLI:
  HGETALL spring:session:sessions:5A7D3E8F0B2C1D4E6A9B0C2D
  → {
      "lastAccessedTime": "1705320600000",
      "maxInactiveInterval": "1800",
      "creationTime": "1705317000000",
      "sessionAttr:userId": "42",
      "sessionAttr:username": "\"alice\"",
      "sessionAttr:loginTime": "\"2024-01-15T10:30:00Z\""
    }
  
  TTL spring:session:sessions:expires:5A7D3E8F0B2C1D4E6A9B0C2D
  → 1800  (seconds until expiry)
```

### 5.5 Auto-Configuration (Spring Boot — No `@EnableRedisHttpSession` needed)

```yaml
# With spring-session-data-redis on classpath, just set:
spring:
  session:
    store-type: redis    # auto-configures RedisHttpSession

# Spring Boot will:
# 1. Create a RedisIndexedSessionRepository
# 2. Register the SessionRepositoryFilter
# 3. Start using Redis for all sessions
# No @EnableRedisHttpSession annotation needed!
```

---

## 6. JDBC-Backed Sessions

### 6.1 Dependencies

```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<!-- + your database driver -->
```

### 6.2 Schema — Required Tables

Spring Session JDBC requires two tables. Spring Boot can create them automatically:

```yaml
spring:
  session:
    store-type: jdbc
    jdbc:
      initialize-schema: always    # always, embedded, never
      schema: classpath:sql/session-schema.sql  # custom schema location
      table-name: SPRING_SESSION   # default table name
      cleanup-cron: "0 * * * * *"  # run cleanup every minute
  datasource:
    url: jdbc:postgresql://localhost/mydb
```

```sql
-- PostgreSQL schema (auto-created by Spring Session)
CREATE TABLE SPRING_SESSION (
    PRIMARY_ID            CHAR(36)     NOT NULL,
    SESSION_ID            CHAR(36)     NOT NULL,
    CREATION_TIME         BIGINT       NOT NULL,
    LAST_ACCESS_TIME      BIGINT       NOT NULL,
    MAX_INACTIVE_INTERVAL INT          NOT NULL,
    EXPIRY_TIME           BIGINT       NOT NULL,
    PRINCIPAL_NAME        VARCHAR(100),
    CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (PRIMARY_ID)
);

CREATE UNIQUE INDEX SPRING_SESSION_IX1 ON SPRING_SESSION (SESSION_ID);
CREATE INDEX SPRING_SESSION_IX2 ON SPRING_SESSION (EXPIRY_TIME);
CREATE INDEX SPRING_SESSION_IX3 ON SPRING_SESSION (PRINCIPAL_NAME);

-- Session attributes table (one row per attribute per session)
CREATE TABLE SPRING_SESSION_ATTRIBUTES (
    SESSION_PRIMARY_ID CHAR(36)     NOT NULL,
    ATTRIBUTE_NAME     VARCHAR(200) NOT NULL,
    ATTRIBUTE_BYTES    BYTEA        NOT NULL,  -- PostgreSQL
    -- ATTRIBUTE_BYTES    BLOB        NOT NULL,  -- MySQL/Oracle
    CONSTRAINT SPRING_SESSION_ATTRIBUTES_PK
        PRIMARY KEY (SESSION_PRIMARY_ID, ATTRIBUTE_NAME),
    CONSTRAINT SPRING_SESSION_ATTRIBUTES_FK
        FOREIGN KEY (SESSION_PRIMARY_ID) REFERENCES SPRING_SESSION(PRIMARY_ID)
        ON DELETE CASCADE
);
```

### 6.3 JDBC Session Configuration

```java
@Configuration
@EnableJdbcHttpSession(
    maxInactiveIntervalInSeconds = 1800,
    tableName = "SPRING_SESSION",
    cleanupCron = "0 * * * * *"
)
public class JdbcSessionConfig {
    // JdbcTemplate is auto-configured from spring.datasource.*
    // No additional beans needed for basic configuration
}
```

### 6.4 Transactional Session Operations

```yaml
spring:
  session:
    jdbc:
      # Wrap session operations in transactions (default: true)
      # Prevents partial updates (attribute partially saved then rolled back)
      save-mode: on-set-attribute    # or: on-get-attribute, always
```

### 6.5 Redis vs JDBC Comparison

| Aspect | Redis | JDBC |
|---|---|---|
| **Performance** | Fast in-memory (sub-ms) | Slower (DB round-trip) |
| **Additional infrastructure** | Requires Redis server | Reuses existing DB |
| **Persistence** | Configurable (AOF/RDB) | ACID persistence |
| **Clustering** | Redis Cluster supported | DB clustering |
| **Cost** | Additional service | Reuse existing DB |
| **Best for** | High-traffic apps | Existing RDBMS infrastructure |
| **Session data** | JSON or JDK serialized | JDK serialized (BLOB) |

---

## 7. Session Serialization

### 7.1 JDK Serialization (Default)

By default, Spring Session serializes attributes using Java's built-in serialization:

```java
// Session attribute must be Serializable
session.setAttribute("user", authenticatedUser); // UserDetails must implement Serializable

// UserDetails implementation:
public class MyUserDetails implements UserDetails, Serializable {
    private static final long serialVersionUID = 1L;
    // ...
}
```

**Problems with JDK serialization:**
```
1. Classes must implement Serializable (easy to forget)
2. Not human-readable (BLOB in DB, binary in Redis)
3. Sensitive to class changes — adding/removing fields can cause deserialization failure
4. Security risk: deserialization of untrusted data can lead to remote code execution
5. serialVersionUID mismatch after class changes = InvalidClassException
```

### 7.2 JSON Serialization (Recommended)

```java
@Configuration
@EnableRedisHttpSession
public class RedisSessionConfig {

    // Replace JDK serializer with Jackson JSON serializer
    @Bean
    public RedisSerializer<Object> springSessionDefaultRedisSerializer() {
        return new GenericJackson2JsonRedisSerializer(configureObjectMapper());
    }

    private ObjectMapper configureObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();

        // Enable type information so deserialization works for polymorphic types
        mapper.activateDefaultTyping(
            BasicPolymorphicTypeValidator.builder()
                .allowIfSubType(Object.class)
                .build(),
            ObjectMapper.DefaultTyping.NON_FINAL
        );

        mapper.registerModule(new JavaTimeModule());           // for Instant, LocalDate, etc.
        mapper.registerModule(new SimpleModule()               // for Spring Security types
            .addSerializer(new GrantedAuthoritySerializer())
            .addDeserializer(GrantedAuthority.class, new GrantedAuthorityDeserializer()));
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        return mapper;
    }
}
```

**Resulting Redis value with JSON:**
```json
// Before: JDK binary blob (unreadable)
// After: JSON (human-readable, debuggable)
{
  "@class": "com.myapp.security.SessionUser",
  "id": 42,
  "username": "alice",
  "email": "alice@example.com",
  "roles": ["ROLE_USER"],
  "loginTime": "2024-01-15T10:30:00Z"
}
```

### 7.3 Handling Security Principal Serialization

Spring Security's `Authentication` object contains `UserDetails`, which must serialize correctly:

```java
// Configuration for proper Spring Security JSON serialization
@Bean
public ObjectMapper sessionObjectMapper() {
    ObjectMapper mapper = new ObjectMapper();
    mapper.activateDefaultTyping(
        BasicPolymorphicTypeValidator.builder()
            .allowIfSubType(Object.class)
            .build(),
        ObjectMapper.DefaultTyping.NON_FINAL,
        JsonTypeInfo.As.PROPERTY
    );

    // Spring Security Jackson module — handles Authentication, GrantedAuthority, etc.
    mapper.registerModules(SecurityJackson2Modules.getModules(getClass().getClassLoader()));
    mapper.registerModule(new JavaTimeModule());
    return mapper;
}

@Bean
public RedisSerializer<Object> springSessionDefaultRedisSerializer(ObjectMapper mapper) {
    return new GenericJackson2JsonRedisSerializer(mapper);
}
```

---

## 8. TTL, Cleanup, and `FindByIndexNameSessionRepository`

### 8.1 Session TTL Configuration

```yaml
spring:
  session:
    timeout: 30m      # global default

# Redis: TTL is set directly on the Redis key (Redis handles expiry natively)
# JDBC:  EXPIRY_TIME column + cleanup cron job deletes expired rows
```

```java
// Per-session TTL override (Redis)
@Autowired
private SessionRepository<?> sessionRepository;

public void extendSessionTtl(String sessionId) {
    Session session = sessionRepository.findById(sessionId);
    if (session != null) {
        session.setMaxInactiveInterval(Duration.ofHours(2)); // extend to 2 hours
        sessionRepository.save(session);
    }
}
```

### 8.2 JDBC Session Cleanup

```yaml
spring:
  session:
    jdbc:
      cleanup-cron: "0 * * * * *"   # run every minute (default)
      # Cleanup deletes rows where EXPIRY_TIME < currentTimeMillis

# For high-traffic apps: use less frequent cleanup to reduce DB load
# cleanup-cron: "0 0 * * * *"   # every hour
# Or: offload cleanup to a separate scheduled job
```

### 8.3 `FindByIndexNameSessionRepository` — Query Sessions by Principal

This allows finding ALL sessions for a given username — useful for forced logout, concurrent session management, and admin functions:

```java
import org.springframework.session.FindByIndexNameSessionRepository;
import org.springframework.session.Session;

@Service
public class SessionAdminService {

    private final FindByIndexNameSessionRepository<? extends Session> sessionRepository;

    public SessionAdminService(FindByIndexNameSessionRepository<? extends Session> repo) {
        this.sessionRepository = repo;
    }

    // Find all sessions for a given username
    public Map<String, ? extends Session> getSessionsForUser(String username) {
        return sessionRepository.findByPrincipalName(username);
        // Returns: Map<sessionId, Session>
    }

    // Force logout by invalidating all of a user's sessions
    public void forceLogout(String username) {
        Map<String, ? extends Session> sessions =
            sessionRepository.findByPrincipalName(username);

        sessions.keySet().forEach(sessionRepository::deleteById);

        log.info("Force logged out user: {} ({} sessions)", username, sessions.size());
    }

    // Get session count for a user (active sessions)
    public int getActiveSessionCount(String username) {
        return sessionRepository.findByPrincipalName(username).size();
    }

    // Admin endpoint: view all sessions for a user
    public List<SessionInfo> getSessionDetails(String username) {
        return sessionRepository.findByPrincipalName(username)
            .values().stream()
            .map(session -> new SessionInfo(
                session.getId(),
                session.getCreationTime(),
                session.getLastAccessedTime(),
                session.getMaxInactiveInterval()
            ))
            .collect(Collectors.toList());
    }
}
```

### 8.4 How Principal Indexing Works

For `findByPrincipalName()` to work, Spring Session must know which attribute contains the principal name:

```
Redis: Spring Session creates an additional index key:
  spring:session:index:org.springframework.session.FindByIndexNameSessionRepository.PRINCIPAL_NAME_INDEX_NAME:alice
  → Set of session IDs for user "alice"

JDBC:  PRINCIPAL_NAME column in SPRING_SESSION table
  SELECT SESSION_ID FROM SPRING_SESSION WHERE PRINCIPAL_NAME = 'alice'
```

```java
// For custom session attributes to be indexed:
session.setAttribute(
    FindByIndexNameSessionRepository.PRINCIPAL_NAME_INDEX_NAME,
    username
);
// Spring Security sets this automatically for authenticated users via
// SpringSessionBackedSessionRegistry
```

---

## 9. Session + WebSocket

### 9.1 The Challenge

HTTP sessions and WebSocket connections have different lifecycles. A WebSocket connection starts as HTTP (which has a session), then upgrades. The session should remain accessible within the WebSocket context.

### 9.2 Sharing Session Between HTTP and WebSocket

```java
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketSessionConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
            .addInterceptors(new HttpSessionHandshakeInterceptor()) // KEY: copy HTTP session to WS
            .withSockJS();
    }
}
```

`HttpSessionHandshakeInterceptor` copies all HTTP session attributes into the WebSocket session attributes map during the handshake upgrade:

```java
// After the interceptor runs, WebSocket session attributes contain:
// Everything from the HTTP session:
// - "SPRING_SECURITY_CONTEXT" → the user's SecurityContext
// - "userId" → whatever you stored in HTTP session
// - etc.

// Access in WebSocket handler:
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    @Override
    public void afterConnectionEstablished(WebSocketSession wsSession) {
        // Access HTTP session attributes via WebSocket session
        Object springSecurityContext =
            wsSession.getAttributes().get(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_ATTR_NAME);

        Long userId = (Long) wsSession.getAttributes().get("userId");
        log.info("WebSocket connected for user: {}", userId);
    }
}
```

### 9.3 Session Events During WebSocket

```java
@Component
public class WebSocketSessionEventListener
        implements ApplicationListener<SessionDestroyedEvent> {

    private final WebSocketSessionRegistry wsSessionRegistry;

    @Override
    public void onApplicationEvent(SessionDestroyedEvent event) {
        // HTTP session expired — close associated WebSocket connections
        String sessionId = event.getId();
        log.info("HTTP session expired: {} — closing WebSocket connections", sessionId);
        wsSessionRegistry.closeConnectionsForSession(sessionId);
    }
}
```

### 9.4 Maintaining Spring Session Across WebSocket with STOMP

```java
@Configuration
@EnableWebSocketMessageBroker
public class StompSessionConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(
                    message, StompHeaderAccessor.class);

                if (StompCommand.CONNECT.equals(accessor.getCommand())) {
                    // Get the HTTP session from WebSocket session attributes
                    // (copied there by HttpSessionHandshakeInterceptor)
                    Map<String, Object> sessionAttributes =
                        SimpMessageHeaderAccessor.getSessionAttributes(message.getHeaders());

                    if (sessionAttributes != null) {
                        SecurityContext ctx = (SecurityContext) sessionAttributes
                            .get(HttpSessionSecurityContextRepository
                                .SPRING_SECURITY_CONTEXT_ATTR_NAME);
                        if (ctx != null) {
                            accessor.setUser(ctx.getAuthentication());
                        }
                    }
                }
                return message;
            }
        });
    }
}
```

---

## 10. Remember-Me with Persistent Tokens

### 10.1 Two Remember-Me Implementations

```
1. Token-Based (Simple Hash) — stateless:
   Cookie = base64(username:expiryTime:md5Hash(username+expiryTime+password+key))
   INSECURE: if cookie is stolen, can be used until expiry even after password change

2. Persistent Token (Database) — stateful and more secure:
   Cookie = series:token (random values)
   Server stores: series, hashed_token, username, last_used
   On each login: token is rotated (new token for same series)
   Stolen token detection: if series matches but token doesn't → ATTACK DETECTED → all sessions invalidated
```

### 10.2 Database Schema for Persistent Tokens

```sql
-- Required table for JdbcTokenRepositoryImpl
CREATE TABLE persistent_logins (
    username    VARCHAR(64) NOT NULL,
    series      VARCHAR(64) NOT NULL PRIMARY KEY,    -- random, identifies the device
    token       VARCHAR(64) NOT NULL,                 -- rotated on each use
    last_used   TIMESTAMP   NOT NULL
);
CREATE INDEX idx_persistent_logins_username ON persistent_logins(username);
```

### 10.3 Spring Security Configuration

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private UserDetailsService userDetailsService;

    @Bean
    public PersistentTokenRepository persistentTokenRepository() {
        JdbcTokenRepositoryImpl tokenRepo = new JdbcTokenRepositoryImpl();
        tokenRepo.setDataSource(dataSource);
        // tokenRepo.setCreateTableOnStartup(true);  // create table automatically (dev only)
        return tokenRepo;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .rememberMe(rm -> rm
                .tokenRepository(persistentTokenRepository())     // use persistent tokens
                .userDetailsService(userDetailsService)            // required
                .rememberMeParameter("remember-me")               // form field name
                .rememberMeCookieName("remember-me")              // cookie name
                .tokenValiditySeconds(30 * 24 * 60 * 60)         // 30 days
                .useSecureCookie(true)                             // HTTPS only
                .alwaysRemember(false)                             // only when box is checked
            )
            .build();
    }
}
```

### 10.4 Login Form with Remember-Me

```html
<form action="/login" method="post">
    <input type="text"     name="username"/>
    <input type="password" name="password"/>
    <!-- "remember-me" must match rememberMeParameter -->
    <input type="checkbox" name="remember-me" value="true"/>
    <label>Remember me for 30 days</label>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <button type="submit">Login</button>
</form>
```

### 10.5 Token Rotation and Theft Detection

```
First "remember me" login:
  Series = RANDOM_A, Token = RANDOM_1
  Cookie: RANDOM_A:RANDOM_1
  DB: {username=alice, series=RANDOM_A, token=HASH(RANDOM_1)}

Second visit (token presented):
  Cookie: RANDOM_A:RANDOM_1
  DB lookup by series RANDOM_A → found, HASH(RANDOM_1) matches
  Issue new token: RANDOM_A:RANDOM_2
  New cookie: RANDOM_A:RANDOM_2
  DB: {username=alice, series=RANDOM_A, token=HASH(RANDOM_2)}

If cookie is stolen and attacker uses it first:
  Attacker cookie: RANDOM_A:RANDOM_1
  DB lookup: series=RANDOM_A, token=HASH(RANDOM_2) — MISMATCH!
  → Spring Security detects possible theft!
  → Deletes ALL persistent tokens for alice (all devices logged out)
  → Exception thrown, user must re-authenticate

Legitimate user (now with stale token):
  Cookie: RANDOM_A:RANDOM_1 (stale — attacker already cycled it)
  DB lookup: series=RANDOM_A → no longer exists (deleted)
  → Forced to log in again (which they should — they may have been compromised)
```

### 10.6 Managing Persistent Tokens (Admin)

```java
@Service
public class RememberMeService {

    private final JdbcTokenRepositoryImpl tokenRepository;

    // Force logout from all "remember me" devices
    public void revokeAllRememberMeTokens(String username) {
        tokenRepository.removeUserTokens(username);
        log.info("Revoked all remember-me tokens for: {}", username);
    }

    // Called after password change — invalidate all tokens for security
    public void onPasswordChange(String username) {
        revokeAllRememberMeTokens(username);
        // User must re-login on all devices — old remember-me cookies are invalid
    }

    // List active remember-me devices
    public List<PersistentRememberMeToken> getActiveTokens(String username) {
        // JdbcTokenRepositoryImpl doesn't expose this directly
        // Query the table directly:
        return jdbcTemplate.query(
            "SELECT * FROM persistent_logins WHERE username = ?",
            new BeanPropertyRowMapper<>(PersistentRememberMeToken.class),
            username
        );
    }
}
```

---

## 11. Quick Reference Cheat Sheet

### Session Timeout Configuration

```yaml
server.servlet.session.timeout: 30m
server.servlet.session.cookie.secure: true      # HTTPS only
server.servlet.session.cookie.http-only: true   # no JS access
server.servlet.session.cookie.same-site: strict  # CSRF
```

### Session Security

```java
http.sessionManagement(s -> s
    .sessionFixation(sf -> sf.migrateSession())    // new ID on login
    .maximumSessions(1)                            // 1 session per user
        .maxSessionsPreventsLogin(false)           // kick old
        .expiredUrl("/login?expired=true")
    .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
);

// Required bean for concurrent sessions:
@Bean public SessionRegistry sessionRegistry() { return new SessionRegistryImpl(); }
@Bean public HttpSessionEventPublisher httpSessionEventPublisher() { return new HttpSessionEventPublisher(); }
```

### Spring Session — Backend Choice

```yaml
# Redis (recommended for performance)
spring.session.store-type: redis
spring.data.redis.host: localhost

# JDBC (simpler, reuse existing DB)
spring.session.store-type: jdbc
spring.session.jdbc.initialize-schema: always
```

### `FindByIndexNameSessionRepository`

```java
Map<String, ? extends Session> sessions =
    sessionRepository.findByPrincipalName("alice");
sessions.keySet().forEach(sessionRepository::deleteById); // force logout
```

### Remember-Me Persistent Tokens

```java
http.rememberMe(rm -> rm
    .tokenRepository(jdbcTokenRepository())
    .tokenValiditySeconds(30 * 24 * 3600)  // 30 days
    .useSecureCookie(true)
);
```

### Session Creation Policy Cheat Sheet

```
ALWAYS          → always create (legacy apps)
IF_REQUIRED     → create when needed (default, web apps)
NEVER           → never create, use existing (microservice)
STATELESS       → never create, never use (REST + JWT)
```

### Key Rules to Remember

1. **Always use HTTPS with sessions** — `secure: true` prevents cookie theft over plain HTTP.
2. **`migrateSession()` is the default** — but be explicit; protects against session fixation.
3. **`HttpSessionEventPublisher` is required** for concurrent session control — without it, `SessionRegistry` doesn't track sessions.
4. **Spring Session is transparent** — swap from in-memory to Redis with zero application code changes.
5. **JSON serialization over JDK** — human-readable, no `Serializable` requirement, resilient to class changes.
6. **`findByPrincipalName` requires indexing** — Spring Security sets this automatically for authenticated users.
7. **Remember-me token theft detection** — series match + token mismatch → all user tokens revoked.
8. **Revoke remember-me tokens on password change** — old tokens are still valid otherwise.
9. **`HttpSessionHandshakeInterceptor`** — required to carry HTTP session attributes (including `SecurityContext`) into WebSocket.
10. **`STATELESS` + JWT = no server session** — make sure your security filters don't create sessions; use `SessionCreationPolicy.STATELESS` explicitly.

---

*End of Session Management & Spring Session Study Guide — Module 7*
