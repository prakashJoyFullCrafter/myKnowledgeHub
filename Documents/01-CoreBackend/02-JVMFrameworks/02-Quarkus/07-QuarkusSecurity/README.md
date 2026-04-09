# Quarkus Security - Curriculum

## Module 1: Security Fundamentals
- [ ] Quarkus security architecture: `HttpAuthenticationMechanism` → `IdentityProvider` → `SecurityIdentity`
- [ ] `@Authenticated` — require any authenticated user
- [ ] `@RolesAllowed("admin")` — role-based access (Jakarta standard annotation)
- [ ] `@PermitAll` / `@DenyAll` — open or closed access
- [ ] `SecurityIdentity` — current user info (principal, roles, attributes)
- [ ] HTTP permissions in config: `quarkus.http.auth.policy` and `quarkus.http.auth.permission`

## Module 2: Authentication Mechanisms
- [ ] **Basic auth**: `quarkus-elytron-security-properties-file` — users in config file (dev only)
- [ ] **Form-based auth**: traditional login form
- [ ] **JWT (Bearer token)**: `quarkus-smallrye-jwt` — MicroProfile JWT
  - [ ] `@Claim` — inject JWT claims
  - [ ] `JsonWebToken` — programmatic access to token
  - [ ] Token validation: issuer, audience, expiration
  - [ ] RBAC from JWT roles claim
- [ ] **OIDC (OpenID Connect)**: `quarkus-oidc` — recommended for production
  - [ ] Authorization Code flow (web apps)
  - [ ] Bearer token validation (API/resource server)
  - [ ] Keycloak, Auth0, Okta integration
  - [ ] `quarkus.oidc.auth-server-url`, `quarkus.oidc.client-id`
- [ ] **API Key**: custom `HttpAuthenticationMechanism` implementation

## Module 3: Keycloak Integration
- [ ] Keycloak as identity provider: realms, clients, users, roles
- [ ] Dev Services for Keycloak: auto-provisioned Keycloak container in dev mode
- [ ] `quarkus-oidc` + Keycloak: zero-config OIDC in dev
- [ ] Realm roles vs client roles mapping
- [ ] Token exchange and service-to-service auth
- [ ] Admin CLI: create realms, users, roles programmatically

## Module 4: Authorization
- [ ] **Role-based**: `@RolesAllowed({"admin", "manager"})`
- [ ] **Permission-based**: custom `SecurityIdentity` augmentor
- [ ] **Path-based**: config-driven permissions (`quarkus.http.auth.permission.admin.paths=/api/admin/*`)
- [ ] Programmatic security: `SecurityContext.isCallerInRole()`, `SecurityIdentity.hasRole()`
- [ ] **Tenant-aware security**: multi-tenant OIDC (`quarkus-oidc` tenant resolver)

## Module 5: Security Testing & Best Practices
- [ ] `@TestSecurity(user = "admin", roles = "admin")` — inject test identity
- [ ] `@OidcSecurity` — mock OIDC tokens in tests
- [ ] Testing with Keycloak Dev Service: real OIDC flow in integration tests
- [ ] CORS configuration: `quarkus.http.cors`
- [ ] CSRF protection: `quarkus-csrf-reactive`
- [ ] Security headers: CSP, HSTS, X-Frame-Options
- [ ] Quarkus Security vs Spring Security: annotation-based (similar), config approach (different)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Secure REST API with JWT: issue token, validate on endpoints, role-based access |
| Module 3 | Set up Keycloak with Dev Services, implement OIDC login flow |
| Module 4 | Path-based + role-based authorization for admin/user/public endpoints |
| Module 5 | Write security tests with `@TestSecurity`, test all roles and unauthorized access |

## Key Resources
- Quarkus Security Reference Guide
- Quarkus OIDC Guide
- SmallRye JWT documentation
- Keycloak documentation
