# Strangler Fig Pattern - Curriculum

## Topics
- [ ] Incremental migration from monolith to microservices
- [ ] Inspired by strangler fig tree (wraps around host tree)
- [ ] Steps: identify boundary -> build new service -> route traffic -> remove old code
- [ ] Facade/proxy layer for routing (old vs new)
- [ ] Anti-corruption layer between old and new
- [ ] Feature toggles for gradual rollout
- [ ] Database decomposition strategies
- [ ] When to strangle vs when to rewrite
- [ ] Risk mitigation: rollback capability at each step
