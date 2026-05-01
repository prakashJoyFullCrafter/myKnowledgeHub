# Strategic DDD - Curriculum

The big-picture toolkit: how to carve up a complex domain into manageable, autonomous pieces.

## Topics
- [ ] **Domain** - the business problem space
- [ ] **Subdomain** - distinct area within the domain
  - [ ] Core domain - the strategic differentiator
  - [ ] Supporting subdomain - enables core, not differentiating
  - [ ] Generic subdomain - solved problem, can buy/use OSS
- [ ] **Bounded Context** - explicit linguistic and model boundary
  - [ ] Same word, different meaning across contexts (e.g., "Customer" in Sales vs Billing)
  - [ ] Each BC has its own ubiquitous language
  - [ ] BC ≠ Microservice (related but not identical)
- [ ] **Ubiquitous Language** - shared vocabulary between domain experts and devs
  - [ ] Encoded in code: class names, method names, package names
  - [ ] No translation between domain experts and developers
- [ ] **Context Map** - relationships between bounded contexts
- [ ] BC sizing: too big (linguistic conflict) vs too small (anemic)
- [ ] BC and team boundaries (Conway's Law)
- [ ] Identifying BCs from business capabilities, not org charts
- [ ] Strategic patterns vs tactical patterns - when to apply which
- [ ] Distilling the Core Domain - focus engineering investment where it matters
- [ ] Big Ball of Mud as the anti-pattern DDD fights
