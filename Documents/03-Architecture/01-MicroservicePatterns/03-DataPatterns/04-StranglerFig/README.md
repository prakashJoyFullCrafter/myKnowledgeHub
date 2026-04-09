# Strangler Fig Pattern - Curriculum

## Module 1: Concept
- [ ] Named after strangler fig tree: grows around host tree, eventually replaces it
- [ ] **Incrementally migrate** from monolith to microservices — not a big-bang rewrite
- [ ] Build new service alongside old → route traffic to new → eventually remove old code
- [ ] Low risk: old system remains functional throughout, rollback is always possible

## Module 2: Step-by-Step Process
- [ ] **Step 1: Identify boundary** — find a module with clear boundaries (DDD bounded context)
  - [ ] Start with: low coupling to rest of monolith, clear data ownership, high change frequency
- [ ] **Step 2: Build new service** — implement the same functionality as a standalone microservice
- [ ] **Step 3: Create facade/proxy** — route requests to old or new based on feature flag or path
  - [ ] API Gateway, NGINX, or reverse proxy handles routing
- [ ] **Step 4: Migrate traffic** — gradually shift traffic: 10% → 50% → 100% to new service
- [ ] **Step 5: Remove old code** — once new service handles 100%, delete old module from monolith
- [ ] **Step 6: Decompose data** — migrate data ownership to new service's database

## Module 3: Key Techniques
- [ ] **Anti-corruption layer (ACL)**: translation layer between old and new — prevents old model from leaking into new
- [ ] **Feature toggles**: enable new service for subset of users/requests
- [ ] **Parallel run**: both old and new process requests, compare results (shadow traffic)
- [ ] **Database decomposition strategies**:
  - [ ] Shared database (temporary): both access same DB during migration
  - [ ] Database view: new service reads from view, old writes to table
  - [ ] Data sync: replicate relevant data to new service's DB
  - [ ] Eventually: new service owns its data, old service calls new service API

## Module 4: When & Anti-Patterns
- [ ] **When to strangle**: large monolith, need incremental migration, can't afford downtime
- [ ] **When to rewrite**: monolith is small, tech stack is completely obsolete, team is small
- [ ] **Anti-pattern: never finishing** — strangler becomes permanent dual system
- [ ] **Anti-pattern: too many services too fast** — extract one at a time, stabilize, then next
- [ ] **Anti-pattern: ignoring data** — extracting code without decomposing data = distributed monolith
- [ ] Risk mitigation: rollback capability at every step, monitoring old vs new performance

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Identify a module in a monolith, extract as microservice, route via API Gateway |
| Module 3 | Implement anti-corruption layer between old and new service |
| Module 4 | Plan strangler strategy for a real monolith: prioritize modules, estimate timeline |

## Key Resources
- "Strangler Fig Application" - Martin Fowler (blog)
- Building Microservices - Sam Newman (Chapter: Decomposition)
- Monolith to Microservices - Sam Newman (entire book on this topic)
- Microservices Patterns - Chris Richardson
