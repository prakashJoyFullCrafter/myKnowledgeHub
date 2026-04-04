# Spring Security - Curriculum

## Module 1: Security Fundamentals
- [ ] Authentication vs Authorization
- [ ] Spring Security filter chain architecture
- [ ] `SecurityFilterChain` bean configuration (Spring Security 6+)
- [ ] `HttpSecurity` configuration DSL
- [ ] Default security (auto-configured)

## Module 2: Authentication
- [ ] In-memory authentication
- [ ] Database authentication with `UserDetailsService`
- [ ] `PasswordEncoder` - `BCryptPasswordEncoder`, `Argon2`
- [ ] Custom `AuthenticationProvider`
- [ ] Form-based login and HTTP Basic
- [ ] Remember-me authentication

## Module 3: JWT Authentication
- [ ] JWT structure: header, payload, signature
- [ ] Generating JWT tokens (access + refresh)
- [ ] `OncePerRequestFilter` for JWT validation
- [ ] Token refresh flow
- [ ] Storing tokens securely (HttpOnly cookies vs localStorage)
- [ ] JWT with Spring Security filter chain

## Module 4: Authorization
- [ ] Role-based access: `hasRole()`, `hasAuthority()`
- [ ] Method-level security: `@PreAuthorize`, `@PostAuthorize`, `@Secured`
- [ ] `@EnableMethodSecurity`
- [ ] SpEL expressions in security annotations
- [ ] Custom permission evaluator

## Module 5: OAuth2 & OpenID Connect
- [ ] OAuth2 flows: Authorization Code, Client Credentials, PKCE
- [ ] `spring-boot-starter-oauth2-client`
- [ ] `spring-boot-starter-oauth2-resource-server`
- [ ] Social login (Google, GitHub)
- [ ] Keycloak / Auth0 integration
- [ ] JWT decoder for resource server

## Module 6: Security Best Practices
- [ ] CORS configuration
- [ ] CSRF protection (when to enable/disable)
- [ ] Security headers (CSP, X-Frame-Options, HSTS)
- [ ] Rate limiting
- [ ] Audit logging for security events
- [ ] Common vulnerabilities and mitigations

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Secure an app with database users and BCrypt |
| Module 3 | Implement complete JWT auth with access + refresh tokens |
| Module 4 | Add role-based access: ADMIN, USER, MODERATOR |
| Module 5 | Add Google OAuth2 login |
| Module 6 | Security audit - fix CORS, CSRF, headers |

## Key Resources
- Spring Security Reference Documentation
- Spring Security in Action - Laurentiu Spilca
