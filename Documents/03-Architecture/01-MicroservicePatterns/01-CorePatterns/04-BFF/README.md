# Backend for Frontend (BFF) - Curriculum

## Module 1: The Problem BFF Solves
- [ ] Different clients need different data shapes: mobile (minimal), web (rich), IoT (tiny)
- [ ] Single general-purpose API leads to: over-fetching, under-fetching, client-specific logic in backend
- [ ] BFF: **dedicated backend per frontend type** — tailored API for each client

## Module 2: BFF Architecture
- [ ] **Web BFF**: rich responses, SSR support, full data
- [ ] **Mobile BFF**: smaller payloads, paginated, optimized for bandwidth
- [ ] **Third-party/Partner BFF**: stable public API, versioned, documented
- [ ] Each BFF calls downstream microservices and aggregates/transforms responses
- [ ] BFF owned by the frontend team (not the backend team)
- [ ] BFF as specialized API Gateway: routing + aggregation + transformation

## Module 3: BFF vs Alternatives
- [ ] **BFF vs GraphQL**: both solve over-fetching/under-fetching — GraphQL with one endpoint, BFF with dedicated APIs
- [ ] **BFF vs API Gateway**: gateway is infrastructure (routing, auth), BFF is application-level (aggregation, transformation)
- [ ] **BFF vs general-purpose API**: BFF trades duplication for client optimization
- [ ] When BFF wins: very different client needs, separate frontend teams, performance-critical mobile
- [ ] When GraphQL wins: many clients with varying needs, rapid iteration, single schema

## Module 4: Anti-Patterns & Best Practices
- [ ] **Anti-pattern: shared BFF** — one BFF for all clients defeats the purpose
- [ ] **Anti-pattern: business logic in BFF** — BFF should aggregate, not compute
- [ ] **Anti-pattern: BFF calling BFF** — leads to distributed monolith
- [ ] **Best practice**: keep BFF thin — orchestration + transformation only
- [ ] **Best practice**: BFF per team, not per technology
- [ ] Implementation: Spring Cloud Gateway, Node.js/Express, Kotlin + Ktor

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build web BFF (full product detail) + mobile BFF (summary only) calling same microservices |
| Module 3 | Rebuild BFF use case with GraphQL — compare developer experience |
| Module 4 | Audit a BFF for anti-patterns: business logic creep, shared BFF smell |

## Key Resources
- "Backends for Frontends" - Sam Newman (blog)
- Building Microservices - Sam Newman
- "BFF @ SoundCloud" - engineering blog
