# Jenkins - Curriculum

## Module 1: Jenkins Fundamentals
- [ ] **Jenkins**: open-source automation server, de facto standard for self-hosted CI/CD
- [ ] **Architecture**: Controller + Agents + Workspaces
- [ ] **Installation**: war file, Docker, Kubernetes operator
- [ ] **Pipeline vs Freestyle**:
  - [ ] Freestyle (legacy): UI-configured, hard to version control
  - [ ] Pipeline (modern): code in `Jenkinsfile`, declarative or scripted
- [ ] **Plugins**: 1800+ plugins (both strength and weakness)

## Module 2: Jenkinsfile (Declarative Pipeline)
- [ ] **Jenkinsfile**: pipeline-as-code in repo
- [ ] **Declarative syntax**:
  ```groovy
  pipeline {
    agent any
    stages {
      stage('Build') { steps { sh 'mvn clean package' } }
      stage('Test')  { steps { sh 'mvn test' } }
      stage('Deploy'){ steps { sh './deploy.sh' } }
    }
  }
  ```
- [ ] **Key blocks**: `agent`, `stages`, `stage`, `steps`, `environment`, `options`, `post`
- [ ] **Post actions**: `always`, `success`, `failure`, `unstable`, `changed`
- [ ] **Environment variables**, credentials binding
- [ ] **Parallel stages**: `parallel { stage(...) { } stage(...) { } }`

## Module 3: Scripted Pipelines
- [ ] **Scripted syntax**: Groovy-based, more flexible
- [ ] **When to use**: complex logic, dynamic stages
- [ ] **Trade-off**: power vs readability — declarative preferred
- [ ] **Mixing**: `script { ... }` block inside declarative as escape hatch

## Module 4: Agents & Distributed Builds
- [ ] **Controller should not run jobs** in production
- [ ] **Static agents**: always-on machines labeled by capability
- [ ] **Dynamic agents**:
  - [ ] **Docker agents**: spin up container per build
  - [ ] **Kubernetes plugin**: pod per build (preferred for cloud-native)
  - [ ] **Cloud**: EC2, Azure VMs on-demand
- [ ] **Agent labels**: route jobs (`agent { label 'linux && jdk17' }`)
- [ ] **Workspace cleanup**: `cleanWs()`

## Module 5: Multibranch Pipelines & Shared Libraries
- [ ] **Multibranch Pipeline**: one pipeline per branch, auto-discovers
- [ ] **Organization Folders**: scan whole GitHub org
- [ ] **Shared Libraries**: reusable Groovy code across pipelines
  - [ ] `vars/`, `src/`, `resources/` structure
  - [ ] `@Library('my-lib@v1.0') _`
- [ ] **Use case**: shared deploy logic, notification helpers

## Module 6: Credentials & Secrets
- [ ] **Credentials store**: encrypted, accessible via bindings
- [ ] **Types**: username/password, secret text, SSH key, certificate
- [ ] **Usage**:
  ```groovy
  withCredentials([string(credentialsId: 'api-token', variable: 'TOKEN')]) {
    sh 'curl -H "Auth: $TOKEN" ...'
  }
  ```
- [ ] **Integration**: Vault, AWS Secrets Manager, Azure Key Vault plugins

## Module 7: Security
- [ ] **Authentication**: LDAP, SAML, OIDC, local users
- [ ] **Authorization**: Matrix-based, Role-based (plugin)
- [ ] **Script approval**: sandbox for Groovy pipelines
- [ ] **Plugin updates**: keep current (main attack surface)
- [ ] **Controller lockdown**: don't expose to internet
- [ ] **Well-known vulnerabilities**: Jenkins has had many CVEs — stay patched

## Module 8: JCasC (Jenkins Configuration as Code)
- [ ] **JCasC**: configure Jenkins via YAML
- [ ] Avoid UI-driven configuration drift
- [ ] Version-controllable, reproducible setup
- [ ] Example: users, credentials, plugins, jobs all as code
- [ ] **Combined with Helm chart**: reproducible Jenkins deployment on K8s

## Module 9: Migration from Jenkins
- [ ] **Why teams migrate**: plugin burden, Groovy complexity, scaling, cloud-native alternatives
- [ ] **Modern alternatives**: GitHub Actions, GitLab CI, Tekton, Drone, CircleCI, Buildkite, Argo Workflows
- [ ] **Migration strategies**: parallel (gradual) vs big bang (risky)
- [ ] **Jenkins still relevant**: mature plugins, on-prem, complex workflows

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Install Jenkins (Docker), run first declarative pipeline |
| Module 3 | Write a scripted pipeline with dynamic stages |
| Module 4 | Configure Kubernetes agent plugin, run job in ephemeral pod |
| Module 5 | Create shared library, use from 2 pipelines |
| Module 6 | Store API token in credentials, use in pipeline |
| Module 7 | Configure LDAP auth, matrix authorization |
| Module 8 | Deploy Jenkins with JCasC and Helm |
| Module 9 | Compare same pipeline in Jenkins vs GitHub Actions |

## Key Resources
- jenkins.io/doc/
- "Jenkins 2: Up and Running" — Brent Laster
- Jenkins Configuration as Code (JCasC) plugin
- Jenkins Kubernetes plugin documentation
