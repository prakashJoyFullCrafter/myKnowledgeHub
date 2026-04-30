# Core Microservice Patterns

Fundamental patterns for microservice architecture.

1. **API Gateway** - Single entry point, routing, auth, rate limiting, aggregation (4 modules)
2. **Service Mesh** - East-west communication, mTLS, traffic management, Istio/Linkerd (4 modules)
3. **Sidecar** - Auxiliary containers, proxy/logging/config sidecars, ambassador/adapter patterns (4 modules)
4. **BFF** - Backend per frontend, tailored APIs, BFF vs GraphQL (4 modules)
5. **Saga Pattern** - Distributed transactions, choreography vs orchestration, compensation (5 modules)
6. **Database per Service** - Data ownership, private DB, cross-service queries/transactions (4 modules)
7. **Service Decomposition** - Boundary identification, DDD, event storming, sizing (5 modules)
8. **Leader Election** - Singleton workers, consensus, lease/fencing, ZooKeeper/etcd/ShedLock (5 modules)
9. **Service Discovery** - Client/server-side, registration models, Eureka/Consul/K8s, health & failure modes (5 modules)
10. **Health Check & Heartbeat** - Liveness/readiness/startup, deep vs shallow, heartbeat patterns, graceful shutdown (5 modules)
11. **API Composition** - Cross-service queries, fan-out strategies, partial failure, N+1/DataLoader, GraphQL federation (7 modules)
