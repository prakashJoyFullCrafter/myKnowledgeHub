# Context Integration Patterns - Curriculum

How Bounded Contexts relate and integrate. These patterns describe both technical and team-organizational relationships.

## Topics
### Relationship Patterns (downstream → upstream)
- [ ] **Shared Kernel** - two BCs share a small subset of model
  - [ ] Requires close coordination between teams
  - [ ] Risky - tight coupling; use sparingly
- [ ] **Customer / Supplier** - upstream provides what downstream needs
  - [ ] Downstream priorities influence upstream backlog
- [ ] **Conformist** - downstream blindly conforms to upstream model
  - [ ] When you can't influence upstream (vendor APIs, legacy)
- [ ] **Anti-Corruption Layer (ACL)** - translation layer protecting downstream
  - [ ] Pure win when integrating with messy/legacy upstream
- [ ] **Open Host Service** - upstream publishes a stable, public protocol
  - [ ] One protocol serves many downstreams
- [ ] **Published Language** - well-documented shared format (often paired with OHS)
- [ ] **Separate Ways** - no integration; intentional decoupling
- [ ] **Big Ball of Mud** (anti-pattern) - sometimes pragmatic, document and contain it
- [ ] **Partnership** - mutual dependency, joint planning

### Context Mapping in Practice
- [ ] Drawing a Context Map - boxes (BCs) and labeled arrows (relationships)
- [ ] U/D notation: Upstream and Downstream direction of influence
- [ ] Mapping team relationships, not just code dependencies
- [ ] Using ContextMapper DSL or simple diagrams
- [ ] Spotting toxic integrations early
- [ ] Strategic refactoring: changing relationship patterns over time
- [ ] Microservice boundaries that follow Context Maps
