# myKnowledgeHub - Project Context

## Vision
A comprehensive, self-contained knowledge management system that serves as both a **learning curriculum** and a **hands-on project repository** — covering the full spectrum of modern software engineering from backend fundamentals to cloud-native deployment.

## Goal
To build and maintain a structured knowledge base that:
1. **Documents everything** needed to become an expert-level full-stack engineer
2. **Pairs theory with practice** — every concept has a corresponding hands-on project
3. **Tracks progress** with checkboxes across all curricula
4. **Serves as a reference** — a personal engineering handbook to revisit while working

## Who This Is For
A backend-focused software engineer aiming for **solution architect / senior engineer** level, with primary expertise in JVM technologies (Java, Kotlin, Spring Boot) and expanding into frontend, data science, cloud, and enterprise architecture.

---

## Repository Structure

```
myKnowledgeHub/
├── Documents/      → Theory, curricula, notes (learn)
├── Projects/       → Hands-on code, labs, apps (build)
└── context/        → Project meta: goals, scope, roadmap (this folder)
```

### Documents (Theory & Curricula)
Organized into 7 major sections with **266 README files** containing detailed curricula with checkboxes.

| # | Section | Scope | README Files |
|---|---------|-------|-------------|
| 01 | **Core Backend** | Java (11 topics), Kotlin (9 topics), Spring Boot (16 topics), Quarkus (4), Micronaut (4), Comparison (3), SQL, PostgreSQL (5), Redis (5) | 70 |
| 02 | **Messaging & Event Streaming** | Apache Kafka (10 topics), RabbitMQ (10 topics) | 29 |
| 03 | **Architecture** | Microservice Patterns (9), System Design (8), Enterprise Architecture (8: TOGAF, Solution Arch, Problem Solving) | 50 |
| 04 | **Frontend & Fullstack** | ES6+ (6), TypeScript (4), React.js (4), Next.js (5) | 24 |
| 05 | **Computer Science & Security** | Data Structures (5), Algorithms (5), Complexity (3), Ethical Hacking (12) | 34 |
| 06 | **DevOps & Delivery** | CI/CD (4), Containers (4), Cloud (4), Observability (4), Testing (4), Quality Practices (5), AI-Assisted Coding (2) | 37 |
| 07 | **Python & Data Science** | Python Core (5), Data Analysis (4), Machine Learning (4), Deep Learning (4) | 22 |

### Projects (Hands-On Code)
Matching project structure for building real code alongside the theory.

| # | Section | Approach |
|---|---------|----------|
| 01 | Core Backend | Mini projects per Java/Kotlin concept |
| 02 | JVM Frameworks | **One master app per framework** (Spring Boot, Quarkus, Micronaut) — multi-module projects covering all topics |
| 03 | Frontend | Single app per framework (React, Next.js) — add features as you learn |
| 04 | Data & Persistence | PostgreSQL exercises, Redis lab |
| 05 | Messaging | Standalone Kafka and RabbitMQ projects |
| 06 | DevOps | Docker Compose files, K8s manifests, GitHub Actions, Terraform configs |
| 07 | Python & Data Science | Python labs, data analysis projects, ML projects, deep learning projects |

---

## Key Numbers

| Metric | Count |
|--------|-------|
| Document sections | 7 |
| Document folders | 267 |
| Curricula (README files) | 266 |
| Project folders | 66 |
| Java topics | 11 (97+ modules) |
| Kotlin topics | 9 (55 modules) |
| Spring Boot topics | 16 (expert level) |
| Total estimated modules | 500+ |

---

## Primary Technology Stack

### Backend (Primary Focus)
- **Languages**: Java (21+), Kotlin
- **Frameworks**: Spring Boot, Quarkus, Micronaut
- **Data**: PostgreSQL, Redis, SQL
- **Messaging**: Apache Kafka, RabbitMQ
- **Build**: Maven, Gradle

### Frontend
- **Languages**: ES6+, TypeScript
- **Frameworks**: React.js, Next.js

### Architecture
- **Patterns**: Microservices, CQRS, Event Sourcing, Saga, Outbox
- **Design**: SOLID, DDD, GoF Patterns, System Design
- **Enterprise**: TOGAF, Solution Architecture, ArchiMate

### DevOps & Cloud
- **Containers**: Docker, Kubernetes, Helm
- **CI/CD**: GitHub Actions, Jenkins, ArgoCD, GitOps
- **Cloud**: AWS, GCP, Azure, Terraform
- **Observability**: Prometheus, Grafana, ELK, Jaeger

### Data Science
- **Language**: Python
- **Libraries**: NumPy, Pandas, Scikit-Learn, TensorFlow, PyTorch
- **Domains**: ML, Deep Learning, NLP, Computer Vision

### Security
- **OWASP Top 10**, Ethical Hacking, CTF, Burp Suite, Nmap

---

## Learning Approach

### Phase 1: Foundation (Core Backend)
Java Core → OOP → Generics → Collections → Concurrency → JVM Internals

### Phase 2: Framework Mastery
Spring Boot (all 16 topics) → Quarkus → Micronaut → Comparison

### Phase 3: Data & Messaging
PostgreSQL → Redis → Kafka → RabbitMQ

### Phase 4: Architecture
Microservice Patterns → System Design → Design Patterns → DDD → TOGAF

### Phase 5: Frontend
ES6+ → TypeScript → React → Next.js

### Phase 6: DevOps
Docker → Kubernetes → CI/CD → Cloud → Observability

### Phase 7: Advanced
Kotlin Expert → Python & Data Science → Ethical Hacking

---

## Principles
1. **Theory + Practice** — every document has a matching project
2. **Checkbox tracking** — mark `[x]` as you complete each item
3. **Expert-level depth** — not just "hello world" but production-grade knowledge
4. **Reference-first** — organized for quick lookup while working, not just sequential learning
5. **Living document** — continuously updated as new topics are explored
