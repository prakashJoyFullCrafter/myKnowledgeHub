# API Security (OWASP API Top 10) - Curriculum

The most relevant security topic for backend developers — APIs are the modern attack surface.

---

## Module 1: API1 - Broken Object Level Authorization (BOLA / IDOR)
- [ ] **Most common API vulnerability**: user A can access user B's data by changing ID in URL
- [ ] Example: `GET /api/orders/12345` — change to `12346`, see another user's order
- [ ] Root cause: server doesn't verify the authenticated user owns the requested resource
- [ ] **Defense**: always check `resource.user_id == authenticated_user.id` server-side
- [ ] **Defense**: use UUIDs instead of sequential IDs (defense in depth, not the fix itself)
- [ ] Spring example: `@PreAuthorize("@orderService.isOwner(#id, principal)")`

## Module 2: API2 - Broken Authentication
- [ ] **Weaknesses**: no rate limiting on login, weak passwords, no MFA, predictable tokens
- [ ] **JWT attacks**: `alg: none`, algorithm confusion, expired token reuse, weak signing secrets
- [ ] **Token storage**: secure cookies vs localStorage (XSS risk)
- [ ] **Refresh token rotation**: detect token theft via reuse detection
- [ ] **Defense**: strong password policies, MFA, rate limiting, short token TTL, refresh token rotation
- [ ] **Account enumeration**: different responses for "user not found" vs "wrong password"

## Module 3: API3 - Broken Object Property Level Authorization
- [ ] Combines old API3 (excessive data exposure) and API6 (mass assignment)
- [ ] **Excessive data exposure**: API returns ALL fields, frontend filters — server must filter sensitive fields
  - [ ] Example: `/api/users/me` returns password hash, internal flags
  - [ ] **Defense**: explicit DTOs, never return entity directly
- [ ] **Mass assignment**: client sends `{"role": "admin"}`, server blindly maps to entity
  - [ ] Example: signup endpoint accepts `is_admin` field
  - [ ] **Defense**: explicit allowlist of bindable fields, separate request DTO from entity

## Module 4: API4 - Unrestricted Resource Consumption
- [ ] **Lack of rate limiting**: brute force, DoS, expensive operations
- [ ] **Pagination abuse**: `?limit=999999` — forces server to load all records
- [ ] **No request size limits**: huge JSON payloads exhaust memory
- [ ] **Expensive operations**: complex search, file processing, SMS sending
- [ ] **Defense**: rate limiting (per user, per IP, per endpoint), max payload size, max page size, timeouts
- [ ] **Defense**: CAPTCHA on sensitive endpoints, exponential backoff on failed login

## Module 5: API5 - Broken Function Level Authorization
- [ ] Regular user can access admin endpoints by guessing URLs: `/api/admin/users/delete`
- [ ] Different from BOLA: BOLA is "wrong object", BFLA is "wrong function/role"
- [ ] **Defense**: deny by default — admin endpoints require explicit role check
- [ ] **Defense**: `@PreAuthorize("hasRole('ADMIN')")` on all admin methods
- [ ] **Test**: try every endpoint as a regular user, verify 403 Forbidden

## Module 6: API6 - Server-Side Request Forgery (SSRF)
- [ ] App fetches URL provided by user → attacker provides internal URL
- [ ] **Targets**: cloud metadata service (`169.254.169.254`), internal services, localhost
- [ ] **Capital One breach**: SSRF → AWS metadata → IAM credentials → S3 data
- [ ] **Defense**: allowlist of allowed URLs, block private IPs (RFC 1918), IMDSv2 in AWS
- [ ] **Defense**: validate URL after DNS resolution (not just the input string — DNS rebinding)
- [ ] Common vulnerable features: URL preview, image fetcher, webhook configuration, PDF generation

## Module 7: API7 - Security Misconfiguration
- [ ] **Default credentials**: admin/admin, no password set
- [ ] **Verbose error messages**: stack traces exposing framework, paths, database type
- [ ] **CORS misconfiguration**: `Access-Control-Allow-Origin: *` with credentials
- [ ] **Missing security headers**: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- [ ] **Outdated frameworks**: known CVEs in Spring, libraries
- [ ] **Exposed actuator/debug endpoints**: `/actuator/env`, `/actuator/heapdump` exposed publicly
- [ ] **Defense**: hardening checklist, automated scanning (OWASP ZAP), proper error handling

## Module 8: API8 - Injection
- [ ] **SQL injection**: parameterized queries (never string concatenation)
- [ ] **NoSQL injection**: MongoDB query operators in user input
- [ ] **Command injection**: `Runtime.exec()` with user input
- [ ] **LDAP injection**: special characters in LDAP filters
- [ ] **GraphQL injection**: query complexity attacks, introspection abuse
- [ ] **Header injection**: CRLF injection in response headers
- [ ] **Defense**: input validation, output encoding, parameterized queries, allowlists

## Module 9: API9 - Improper Inventory Management
- [ ] **Old API versions still exposed**: `/api/v1/` with known vulnerabilities while `/v2/` is fixed
- [ ] **Undocumented endpoints**: dev/staging endpoints exposed in production
- [ ] **Forgotten subdomains**: `staging.example.com` with default creds, no TLS
- [ ] **Shadow APIs**: created by teams, not in inventory
- [ ] **Defense**: API gateway as single entry, deprecation policy, regular discovery scans
- [ ] **Defense**: API inventory in CMDB, OpenAPI spec for every endpoint

## Module 10: API10 - Unsafe Consumption of APIs
- [ ] **Trusting third-party APIs**: assuming responses are safe
- [ ] **Following redirects blindly**: third-party redirects to malicious URL
- [ ] **No input validation on third-party data**: SQLi via data from "trusted" partner
- [ ] **No TLS verification**: accepting any certificate (`verify=false`)
- [ ] **Defense**: validate ALL data, even from trusted sources — defense in depth
- [ ] **Defense**: timeout, rate limit, circuit breaker on outbound calls

---

## Testing API Security
- [ ] **Burp Suite**: intercept API calls, modify, replay
- [ ] **Postman / Insomnia**: test endpoints with different roles
- [ ] **OWASP ZAP**: automated API security scanning
- [ ] **API fuzzing**: ffuf, kiterunner — discover hidden endpoints
- [ ] **JWT testing**: jwt_tool for algorithm confusion attacks
- [ ] **Authorization testing**: AuthMatrix Burp extension

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Build a vulnerable app with BOLA, then fix with proper authz check |
| Module 3 | Demo mass assignment: signup form + `is_admin` injection, then fix with DTO |
| Module 5 | Audit a Spring REST API for missing `@PreAuthorize` on admin methods |
| Module 6 | Lab: vulnerable URL fetcher → SSRF → block with allowlist |
| Module 7 | Run OWASP ZAP against a Spring Boot app, fix all findings |
| Module 8 | Test SQLi, command injection, header injection against own app |

## Key Resources
- **OWASP API Security Top 10** (2023) - owasp.org/API-Security
- **OWASP API Security Cheat Sheet**
- **PortSwigger Web Security Academy** — free, excellent labs (portswigger.net/web-security)
- **HackTricks** — Pentesting Web → API
- **APIsec University** — free API security courses
- "API Security in Action" - Neil Madden
