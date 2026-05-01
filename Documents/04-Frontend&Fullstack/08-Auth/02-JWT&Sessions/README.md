# JWT & Sessions - Curriculum

## Topics
- [ ] Stateful sessions (cookie + server store) vs stateless JWT
- [ ] JWT structure: header, payload, signature
- [ ] Signing algorithms: HS256 vs RS256
- [ ] Where to store JWT: `httpOnly` cookie vs localStorage (XSS risk)
- [ ] Cookie attributes: `HttpOnly`, `Secure`, `SameSite`, `Path`, `Domain`
- [ ] Access token + refresh token pattern
- [ ] Refresh token rotation and reuse detection
- [ ] Silent refresh strategies
- [ ] Token expiration: short-lived access, long-lived refresh
- [ ] CSRF protection: SameSite cookies, double-submit, anti-CSRF tokens
- [ ] XSS as the dominant frontend auth risk
- [ ] Logout: server-side revocation (denylist) vs cookie clear
- [ ] Encoding identity claims, scopes, roles in JWT
- [ ] JWT pitfalls: `alg: none`, key confusion, expiration not enforced
