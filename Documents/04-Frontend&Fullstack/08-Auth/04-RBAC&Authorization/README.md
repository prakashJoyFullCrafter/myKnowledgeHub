# RBAC & Authorization - Curriculum

## Topics
- [ ] Authentication vs Authorization (who vs what allowed)
- [ ] **RBAC** (Role-Based Access Control) - users → roles → permissions
- [ ] **ABAC** (Attribute-Based) - rules over user/resource attributes
- [ ] **ReBAC** (Relationship-Based) - Google Zanzibar model
- [ ] PBAC (Policy-Based) and OPA (Open Policy Agent)
- [ ] Role hierarchies and permission inheritance
- [ ] Encoding roles/scopes in JWT claims
- [ ] Server-side enforcement (never trust client)
- [ ] Frontend UX: hiding/disabling unauthorized actions
- [ ] Route guards in Next.js middleware
- [ ] Per-component permission gating (`<Can action="edit" />`)
- [ ] CASL library for isomorphic permissions
- [ ] Multi-tenancy: tenant-scoped permissions
- [ ] Audit logging of authz decisions
- [ ] Common pitfalls: IDOR (Insecure Direct Object Reference), missing checks on mutation paths
