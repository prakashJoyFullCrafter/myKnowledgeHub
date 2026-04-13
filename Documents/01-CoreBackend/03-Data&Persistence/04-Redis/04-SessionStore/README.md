# Redis Session Store - Curriculum

## Module 1: The Distributed Session Problem
- [ ] **HTTP is stateless**: each request independent
- [ ] **Sessions**: remember user state across requests (login, cart, preferences)
- [ ] **Traditional session storage**: in-memory on the app server
  - [ ] Problem: doesn't work with multiple instances (one instance → no session)
  - [ ] Partial fix: **sticky sessions** — route user to same server
  - [ ] Issues with sticky: uneven load, server restart loses sessions, blue-green deploy hard
- [ ] **Distributed session store**: shared state accessible to all instances
  - [ ] Redis is the standard choice (fast, shared, TTL support)
  - [ ] Alternatives: database (slow), Memcached (no persistence), Hazelcast

## Module 2: Sticky Sessions vs Shared Sessions
- [ ] **Sticky sessions**:
  - [ ] Load balancer routes user to same instance based on cookie/IP
  - [ ] Simpler app code (no shared store)
  - [ ] Problems: imbalanced load, instance restart = session loss, harder to scale/deploy
  - [ ] OK for: small deployments, legacy apps
- [ ] **Shared sessions (Redis)**:
  - [ ] Any instance can serve any request
  - [ ] True horizontal scaling
  - [ ] Graceful restart / blue-green deploy works
  - [ ] Cost: network round-trip per session access, shared-state complexity
- [ ] **Recommendation**: use shared sessions for anything beyond trivial deployment

## Module 3: Spring Session with Redis
- [ ] **`spring-session-data-redis`** dependency
- [ ] **`@EnableRedisHttpSession`**: auto-configures session filter
- [ ] **How it works**:
  - [ ] Session stored in Redis hash
  - [ ] Session ID in cookie (default: `SESSION`)
  - [ ] Filter intercepts requests, loads/saves session via Redis
- [ ] **Configuration**:
  - [ ] `spring.session.redis.namespace` (default `spring:session`)
  - [ ] `spring.session.timeout` (default 30 min)
  - [ ] `spring.session.redis.flush-mode` — immediate vs on-save
- [ ] **Works transparently**: any `HttpSession` API automatically uses Redis
- [ ] **Alternative**: reactive sessions with `@EnableRedisWebSession` for WebFlux

## Module 4: Session Storage Structure
- [ ] **Redis keys used**:
  - [ ] `spring:session:sessions:<session-id>` — hash with session attributes
  - [ ] `spring:session:expirations:<timestamp>` — TTL management
  - [ ] `spring:session:sessions:expires:<session-id>` — TTL key
- [ ] **Session data**:
  - [ ] `sessionAttr:<attribute-name>` fields in the hash
  - [ ] `creationTime`, `lastAccessedTime`, `maxInactiveInterval`
- [ ] **Inspect**: `redis-cli KEYS 'spring:session:*'`, `HGETALL <key>`
- [ ] **Session events**: Spring fires events on create/destroy — subscribe for custom logic

## Module 5: Serialization
- [ ] **Default**: JDK serialization (`JdkSerializationRedisSerializer`)
  - [ ] Works with any Serializable object
  - [ ] Verbose, Java-specific, ugly in redis-cli
- [ ] **JSON**: `GenericJackson2JsonRedisSerializer`
  - [ ] Human-readable
  - [ ] Cross-language compatible
  - [ ] Requires objects to be Jackson-serializable
- [ ] **Custom**: implement `RedisSerializer<Object>`
- [ ] **Configuration**:
  ```java
  @Bean
  public RedisSerializer<Object> springSessionDefaultRedisSerializer() {
      return new GenericJackson2JsonRedisSerializer();
  }
  ```
- [ ] **Trade-off**: JSON (readable, interop) vs JDK (simple, Java-only)
- [ ] **Security warning**: deserialization vulnerabilities — never deserialize untrusted data

## Module 6: Session Expiration & Cleanup
- [ ] **Session TTL**: Spring Session sets Redis TTL matching `maxInactiveInterval`
- [ ] **Auto-extend**: each session access extends TTL
- [ ] **Expiration cleanup**:
  - [ ] Passive: expired session removed on access
  - [ ] Active: Spring Session uses keyspace notifications to detect expirations
  - [ ] Requires: `notify-keyspace-events Egx` in Redis config
- [ ] **Session invalidation**: `session.invalidate()` → `DEL` in Redis
- [ ] **Logout**: invalidate session + clear cookie
- [ ] **Cleanup job**: Spring Session has built-in cleanup task

## Module 7: Multi-Tenant & Cross-Service Sessions
- [ ] **Cross-service sessions**: same session ID across microservices
  - [ ] All services use same Redis + same cookie domain
  - [ ] Each service can read user identity from shared session
- [ ] **Alternative**: JWT tokens — stateless, no shared store
  - [ ] Pros: scale infinitely, no Redis dependency
  - [ ] Cons: can't revoke mid-session, token larger than session ID
- [ ] **Hybrid**: JWT for auth + Redis for per-service session state
- [ ] **Multi-tenant**: namespace per tenant
  - [ ] `spring.session.redis.namespace=tenant-abc:session`
- [ ] **Security boundaries**: one tenant's session must not leak to another

## Module 8: Security Considerations
- [ ] **Session fixation**: attacker sets known session ID before victim logs in
  - [ ] Fix: regenerate session ID on authentication (`HttpSession.changeSessionId()`)
- [ ] **Session hijacking**: stolen session cookie
  - [ ] Fix: HTTPS only, `Secure` cookie flag, `HttpOnly` flag
- [ ] **CSRF (Cross-Site Request Forgery)**: attacker tricks browser into using valid session
  - [ ] Fix: CSRF tokens, `SameSite=Lax/Strict` cookie
- [ ] **Session data exposure**: anyone with Redis access can read all sessions
  - [ ] Fix: Redis AUTH, TLS, network isolation, ACL (Redis 6+)
- [ ] **Never store**: passwords, payment info, PII unnecessarily
- [ ] **Encrypt sensitive session data** before storing in Redis if needed
- [ ] **Timeout**: short idle timeout for sensitive apps (banking), longer for consumer apps

## Module 9: Performance & Scale
- [ ] **Per-request Redis call**: session load/save adds latency
- [ ] **Optimizations**:
  - [ ] `flush-mode=on-save` — don't flush on every change
  - [ ] Lazy loading — only load session when needed
  - [ ] Local cache with invalidation — risky, breaks consistency
- [ ] **Session size matters**:
  - [ ] Large sessions (MB) → slow load/save
  - [ ] Keep sessions small (few KB max)
  - [ ] Store heavy data in DB, keep only IDs in session
- [ ] **Redis capacity**:
  - [ ] 1M active sessions × 1KB = 1 GB
  - [ ] Plan for peak concurrent users × avg session size
- [ ] **HA**: Sentinel or Cluster for production session store

## Module 10: Anti-Patterns
- [ ] **Storing too much in session**: memory bloat, slow serialization
  - [ ] Fix: store IDs, fetch full objects on demand
- [ ] **Sessions without TTL**: grow forever
- [ ] **Not regenerating session on login**: session fixation vulnerability
- [ ] **Storing sensitive data unencrypted**: data exposure risk
- [ ] **No HTTPS**: session hijacking via cookie sniffing
- [ ] **Non-serializable session attributes**: runtime crash
- [ ] **Single Redis instance for sessions**: SPOF, whole app down if Redis down

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare behavior of sticky vs shared sessions during instance restart |
| Module 2 | Set up shared session in multi-instance Spring Boot app |
| Module 3 | Enable Spring Session + Redis, verify session across instances |
| Module 4 | Inspect Redis keys for an active session |
| Module 5 | Switch to JSON serializer, observe readable session data |
| Module 6 | Configure keyspace notifications, verify expiration events |
| Module 7 | Build cross-service session for 2 microservices |
| Module 8 | Apply session hardening: regenerate on login, Secure/HttpOnly flags |
| Module 9 | Benchmark session performance with varying sizes |
| Module 10 | Audit a session config for security issues |

## Key Resources
- docs.spring.io/spring-session/reference/
- "Spring Session with Redis" — Spring Guides
- OWASP Session Management Cheat Sheet
- redis.io/docs/manual/keyspace-notifications/
