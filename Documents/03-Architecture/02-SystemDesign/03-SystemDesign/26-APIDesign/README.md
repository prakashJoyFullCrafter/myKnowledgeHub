# API Design (System-Level) - Curriculum

System-level concerns for designing public, partner, and internal APIs at scale. Complements `11-CommunicationProtocols` (transport-level) and `18-SecurityInSystemDesign` (security architecture) — this module focuses on the **API surface contract** itself.

---

## Module 1: API Fundamentals
- [ ] **Endpoint** — a URL identifying a resource (`/api/v1/users/{id}`)
  - [ ] Resource-oriented vs action-oriented (RPC-style) URIs
  - [ ] Plural vs singular nouns, hierarchy depth, query params vs path params
- [ ] **HTTP Methods** (verbs)
  - [ ] `GET` (safe, idempotent), `POST` (create, non-idempotent), `PUT` (replace, idempotent)
  - [ ] `PATCH` (partial update), `DELETE` (idempotent), `HEAD`, `OPTIONS`
  - [ ] Safe vs idempotent — and why both matter for retries
- [ ] **Request-Response anatomy**
  - [ ] Request line, headers, body (request); status line, headers, body (response)
  - [ ] Common headers: `Content-Type`, `Accept`, `Authorization`, `If-Match`, `Idempotency-Key`
  - [ ] Query params, path params, body — when to use which
- [ ] **Status Codes** (semantic correctness matters)
  - [ ] `2xx` success: 200 OK, 201 Created, 202 Accepted, 204 No Content
  - [ ] `3xx` redirect: 301 Moved Permanently, 304 Not Modified
  - [ ] `4xx` client error: 400, 401 (unauth), 403 (forbidden), 404, 409 (conflict), 422, 429 (rate limit)
  - [ ] `5xx` server error: 500, 502 (bad gateway), 503 (unavailable), 504 (timeout)
  - [ ] Common mistakes: returning 200 with `{ "error": ... }`, conflating 401 and 403

📄 See: [M26-L01-APIFundamentals.md](M26-L01-APIFundamentals.md)

## Module 2: Authentication & Authorization
- [ ] **Authentication** — verifying *who* is calling
  - [ ] Basic Auth (rare in modern APIs), API keys, bearer tokens
  - [ ] Mutual TLS (mTLS) for service-to-service
  - [ ] Session vs token-based auth
- [ ] **Authorization** — verifying *what* the caller can do
  - [ ] RBAC (role-based) vs ABAC (attribute-based) vs ReBAC (relationship-based, e.g., Zanzibar)
  - [ ] Scope-based authorization in OAuth tokens
  - [ ] Resource-level vs action-level checks
- [ ] **Access Tokens**
  - [ ] **Opaque tokens** — random string, requires introspection (DB/cache lookup)
  - [ ] **JWT (self-contained)** — signed, no DB hit, but revocation is hard
  - [ ] Token lifetime: short-lived access + long-lived refresh tokens
  - [ ] Token storage: cookies (with `HttpOnly`, `SameSite`) vs localStorage (XSS risk)
- [ ] **OAuth 2.0 / OIDC**
  - [ ] Grant types: Authorization Code (+ PKCE), Client Credentials, Device Code
  - [ ] OIDC adds identity layer (`id_token`) on top of OAuth2 (authorization)
  - [ ] When to use which: web app (auth code + PKCE), service-to-service (client credentials)

📄 See: [M26-L02-AuthN-AuthZ.md](M26-L02-AuthN-AuthZ.md)
🔗 Cross-ref: `01-CoreBackend/02-JVMFrameworks/01-SpringBoot/05-SpringSecurity/`

## Module 3: API Reliability
- [ ] **Idempotency**
  - [ ] What it means: same request N times = same result as 1 time
  - [ ] **Idempotency Key** pattern: client sends `Idempotency-Key` header, server stores result
  - [ ] Storage: Redis with TTL (24h common), or DB table with unique constraint
  - [ ] Where it matters: payments, order creation, any non-idempotent verb (`POST`)
  - [ ] Stripe-style idempotency: replay returns cached response
- [ ] **Rate Limiting** (server enforces)
  - [ ] Why: protect from abuse, ensure fair usage, capacity protection
  - [ ] Algorithms: fixed window, sliding window log, sliding window counter, token bucket, leaky bucket
  - [ ] Where to enforce: API Gateway (preferred), application layer, both
  - [ ] Per-user, per-IP, per-API-key, per-endpoint
  - [ ] Response: `429 Too Many Requests` + `Retry-After` + `X-RateLimit-*` headers
- [ ] **Throttling** (slowing down vs rejecting)
  - [ ] Hard limit (reject): rate limiting
  - [ ] Soft limit (slow down): queue requests, increase latency artificially
  - [ ] Backpressure signaling to clients
  - [ ] Adaptive throttling based on downstream health
- [ ] **Error Handling**
  - [ ] **Problem Details (RFC 7807)** — standardized error format: `type`, `title`, `status`, `detail`, `instance`
  - [ ] Error codes (machine-readable) vs messages (human-readable)
  - [ ] Don't leak stack traces, internal IDs, or DB errors to clients
  - [ ] Correlation IDs for cross-service debugging
  - [ ] Retry guidance in errors (which 5xx is retryable?)

📄 See: [M26-L03-APIReliability.md](M26-L03-APIReliability.md)
🔗 Cross-ref: `01-MicroservicePatterns/02-Resilience/04-RateLimiting/`, `19-DistributedTransactions&Correctness/` (idempotency end-to-end)

## Module 4: API Scaling
- [ ] **Pagination**
  - [ ] **Offset/Limit**: simple, but slow for deep pages (`OFFSET 1000000` scans 1M rows)
  - [ ] **Cursor-based (keyset)**: `?after=<encoded_cursor>` — O(log n), stable across inserts
  - [ ] **Page-based**: `?page=2&size=20` — same problem as offset
  - [ ] Total count: expensive at scale, often omitted or estimated
  - [ ] HATEOAS pagination links (`next`, `prev`, `first`, `last`)
- [ ] **Caching at the API layer**
  - [ ] HTTP caching: `Cache-Control`, `ETag`, `Last-Modified`, `304 Not Modified`
  - [ ] Cache scopes: private (per-user) vs public (CDN-cacheable)
  - [ ] Conditional requests: `If-None-Match`, `If-Modified-Since`
  - [ ] Vary header for content negotiation
  - [ ] CDN caching for public GETs, edge cache invalidation
- [ ] **API Gateway** (single entry point)
  - [ ] Cross-cutting: auth, rate limiting, logging, transformation, routing, caching
  - [ ] Tools: Kong, AWS API Gateway, Apigee, Tyk, Spring Cloud Gateway, Envoy
  - [ ] BFF (Backend-for-Frontend) — gateway tailored per client (web, mobile, partner)
  - [ ] Trade-offs: single point of failure, latency overhead, vendor lock-in

📄 See: [M26-L04-APIScaling.md](M26-L04-APIScaling.md)
🔗 Cross-ref: `06-Caching/`, `01-MicroservicePatterns/01-CorePatterns/01-APIGateway/`

## Module 5: API Evolution
- [ ] **API Versioning**
  - [ ] **URI versioning**: `/v1/users` — most visible, easiest to route
  - [ ] **Header versioning**: `Accept: application/vnd.api+json;version=1` — clean URIs
  - [ ] **Query param**: `?version=1` — least common, easy to forget
  - [ ] **Media type versioning**: content negotiation, RESTful purist choice
  - [ ] Deprecation policy: sunset headers, deprecation timeline, migration guides
  - [ ] Breaking vs non-breaking changes (additive is non-breaking)
- [ ] **OpenAPI Specification** (formerly Swagger)
  - [ ] Schema-first vs code-first generation
  - [ ] Tools: SpringDoc, Swashbuckle, Stoplight, Redoc, Swagger UI
  - [ ] Contract testing from OpenAPI specs
  - [ ] Client/server code generation (`openapi-generator`)
  - [ ] AsyncAPI for event-driven APIs (parallel spec)
- [ ] **REST vs GraphQL**
  - [ ] **REST**: resource-oriented, multiple endpoints, HTTP-cacheable, over/under-fetching
  - [ ] **GraphQL**: single endpoint, client picks fields, no over-fetch, harder to cache
  - [ ] **GraphQL pain points**: N+1 at resolver, query depth attacks, caching complexity
  - [ ] **gRPC** (third option): binary, code-gen, streaming, internal services
  - [ ] Decision: external/public → REST, BFF/mobile → GraphQL, internal → gRPC
- [ ] **API contract testing** & consumer-driven contracts (Pact, Spring Cloud Contract)

📄 See: [M26-L05-APIEvolution.md](M26-L05-APIEvolution.md)
🔗 Cross-ref: `11-CommunicationProtocols/` (REST/GraphQL/gRPC details)

## Module 6: Async / Event-Driven APIs
- [ ] **Webhooks** (server-to-server callbacks)
  - [ ] Why: invert the polling model — provider notifies consumer on events
  - [ ] Subscription model: consumer registers callback URL with provider
  - [ ] **Signing**: HMAC signature (`X-Signature`) — verify provider authenticity
  - [ ] **Replay protection**: timestamps + nonces, reject old/duplicate deliveries
  - [ ] **Retry policy**: exponential backoff, max attempts, dead-letter queue
  - [ ] **Idempotency on receiver side**: webhook may fire duplicates
  - [ ] Examples: Stripe, GitHub, Slack — study their webhook contracts
- [ ] **Async APIs** (long-running operations)
  - [ ] `202 Accepted` + polling endpoint pattern
  - [ ] Job/operation resource: client polls `/operations/{id}` for status
  - [ ] Webhook callback on completion (alternative to polling)
  - [ ] Server-Sent Events (SSE) or WebSocket for real-time progress
- [ ] **Event-driven integration patterns**
  - [ ] Outbox pattern (transactional event publication)
  - [ ] Event schema management (Schema Registry)
  - [ ] Sync vs async API mix in microservices

📄 See: [M26-L06-AsyncAPIs.md](M26-L06-AsyncAPIs.md)
🔗 Cross-ref: `01-MicroservicePatterns/03-DataPatterns/03-OutboxPattern/`, `09-MessageQueues/`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Design a REST API for a bookstore — pick correct verbs, status codes, URIs for each operation |
| Module 2 | Implement OAuth2 Authorization Code + PKCE flow end-to-end with refresh tokens |
| Module 3 | Add idempotency-key support to a payment endpoint, simulate double-submit |
| Module 4 | Build cursor-based pagination on a 10M-row table, benchmark vs offset |
| Module 5 | Generate OpenAPI spec, version an endpoint via header, deprecate v1 with sunset header |
| Module 6 | Implement webhook delivery with HMAC signing + retry queue + dead-letter handling |

## Key Resources
- "API Design Patterns" - JJ Geewax (Google)
- "Web API Design: The Missing Link" - Google Cloud whitepaper
- RFC 7807 - Problem Details for HTTP APIs
- RFC 6749 - OAuth 2.0 Authorization Framework
- RFC 9457 - Problem Details (updated)
- Stripe API documentation (gold standard for idempotency, pagination, webhooks)
- GitHub REST API documentation (versioning, pagination, webhooks)
- OpenAPI Specification (openapis.org)
- "Designing Web APIs" - Brenda Jin et al.
