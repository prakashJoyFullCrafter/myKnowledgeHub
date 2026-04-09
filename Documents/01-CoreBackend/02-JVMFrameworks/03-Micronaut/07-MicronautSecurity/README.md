# Micronaut Security - Curriculum

## Module 1: Security Fundamentals
- [ ] `micronaut-security` dependency
- [ ] `@Secured(SecurityRule.IS_AUTHENTICATED)` — require authentication
- [ ] `@Secured({"ROLE_ADMIN"})` — role-based access
- [ ] `@Secured(SecurityRule.IS_ANONYMOUS)` — public endpoint
- [ ] Intercept URL map: config-based security rules (`micronaut.security.intercept-url-map`)
- [ ] `SecurityContext` and `Authentication` — access current user info

## Module 2: Authentication Mechanisms
- [ ] **Basic auth**: `micronaut-security-annotations` + `AuthenticationProvider`
  - [ ] Custom `AuthenticationProvider<HttpRequest<?>>` — validate credentials against DB
- [ ] **Session-based**: `micronaut-security-session` — server-side session with cookies
- [ ] **JWT (Bearer token)**: `micronaut-security-jwt`
  - [ ] Token generation: `AccessRefreshTokenGenerator`
  - [ ] Token validation: signature, expiration, claims
  - [ ] Refresh token flow: `/oauth/access_token` endpoint
  - [ ] JWT claims: `@Claim` injection, custom claims
  - [ ] Signed (JWS) and encrypted (JWE) tokens
- [ ] **OAuth2 / OpenID Connect**: `micronaut-security-oauth2`
  - [ ] Authorization Code flow
  - [ ] Client Credentials flow
  - [ ] Keycloak, Auth0, Okta, Google integration
  - [ ] `micronaut.security.oauth2.clients.keycloak.openid.issuer`

## Module 3: Authorization
- [ ] **Role-based**: `@Secured({"ROLE_ADMIN", "ROLE_MANAGER"})`
- [ ] **Permission-based**: custom `SecurityRule` implementation
- [ ] **IP-based**: `IpPatternRule` for restricting by IP range
- [ ] `@Secured` at controller level vs method level — inheritance rules
- [ ] Programmatic checks: `SecurityContext.getAuthentication()` in service layer
- [ ] Sensitive endpoints: `micronaut.security.endpoints` configuration

## Module 4: Login & Token Endpoints
- [ ] **Login controller**: auto-generated `/login` endpoint (POST username/password → JWT)
- [ ] **Refresh endpoint**: `/oauth/access_token` with refresh token
- [ ] **Logout**: `/logout` for session-based, token blacklisting for JWT
- [ ] Custom login response: include user details, permissions in token response
- [ ] Password encoding: `PasswordEncoder` with BCrypt
- [ ] CORS configuration for SPA authentication flows

## Module 5: Testing & Best Practices
- [ ] `@MicronautTest` with `@MockBean` for `AuthenticationProvider`
- [ ] `@Client` with `@Header("Authorization", "Bearer ...")` for authenticated test requests
- [ ] `SecurityRule.IS_ANONYMOUS` on test endpoints
- [ ] Token generation in tests for integration testing protected endpoints
- [ ] HTTPS configuration: `micronaut.ssl`
- [ ] Security headers: CSP, X-Frame-Options, HSTS
- [ ] Micronaut Security vs Spring Security:
  - [ ] Both: annotation-based, JWT, OAuth2
  - [ ] Micronaut: compile-time processing, lighter, fewer features
  - [ ] Spring: richer ecosystem, filter chain, more customization options

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build JWT auth: login endpoint → token → protected API |
| Module 3 | Role-based access: admin, user, public endpoints |
| Module 4 | Full auth flow: login, refresh, logout with access + refresh tokens |
| Module 5 | Security tests for all roles + unauthorized access scenarios |

## Key Resources
- Micronaut Security documentation
- Micronaut Security JWT guide
- Micronaut Guides — "Secure a Micronaut App" tutorials
