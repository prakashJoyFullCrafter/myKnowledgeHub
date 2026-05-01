# Docker - Curriculum

## Module 1: Container Fundamentals
- [ ] **Container vs VM**: kernel-level isolation vs hypervisor-level
  - [ ] VMs: full OS per VM, GB-scale, minutes to boot
  - [ ] Containers: shared kernel, MB-scale, seconds to boot
- [ ] **Linux primitives** behind containers:
  - [ ] **Namespaces**: PID, NET, MNT, UTS, IPC, USER — isolation
  - [ ] **cgroups**: CPU, memory, I/O — resource limits
  - [ ] **Union filesystems**: overlay2 — layered images
  - [ ] **seccomp, AppArmor, SELinux** — additional security
- [ ] **OCI (Open Container Initiative)**: standards for image format, runtime, distribution
- [ ] **Docker vs containerd vs runc**: the stack
  - [ ] `runc`: low-level runtime (actually creates container)
  - [ ] `containerd`: container runtime daemon
  - [ ] `Docker`: user-facing tooling on top

## Module 2: Dockerfile Deep Dive
- [ ] **Instructions**:
  - [ ] `FROM` — base image (prefer specific tag, not `latest`)
  - [ ] `RUN` — execute commands during build
  - [ ] `COPY` vs `ADD` — prefer COPY (ADD has magic: URLs, tar extraction)
  - [ ] `WORKDIR` — set working directory
  - [ ] `ENV` — environment variables
  - [ ] `ARG` — build-time variables
  - [ ] `EXPOSE` — documentation of listening ports (doesn't actually publish)
  - [ ] `CMD` vs `ENTRYPOINT` — default command vs executable
  - [ ] `USER` — non-root user
  - [ ] `HEALTHCHECK` — container health probe
  - [ ] `LABEL` — metadata
- [ ] **CMD vs ENTRYPOINT patterns**:
  - [ ] `ENTRYPOINT ["app"]` + `CMD ["--flag"]` — fixed executable, default args
  - [ ] Shell form vs exec form — prefer exec form (`["cmd", "arg"]`)
- [ ] **`.dockerignore`**: exclude files from build context (critical for speed)

## Module 3: Layers & Caching
- [ ] **Every instruction creates a layer** — layers are cached, stacked, immutable
- [ ] **Layer cache**: identical instruction + context → reuse from cache
- [ ] **Cache invalidation**: once a layer changes, all subsequent layers invalidate
- [ ] **Order matters**: put frequently-changing instructions LATER
  - [ ] Bad: `COPY . /app` then `RUN pip install` (every change busts pip cache)
  - [ ] Good: `COPY requirements.txt .` → `RUN pip install` → `COPY . /app`
- [ ] **Layer inspection**: `docker history <image>` shows layers and sizes
- [ ] **Squashing**: combine layers to reduce count (deprecated in favor of multi-stage)

## Module 4: Multi-Stage Builds
- [ ] **Problem**: build dependencies bloat production image
- [ ] **Solution**: separate build stage from runtime stage
- [ ] **Example** (Go):
  ```dockerfile
  FROM golang:1.21 AS builder
  WORKDIR /src
  COPY . .
  RUN go build -o /app

  FROM gcr.io/distroless/static
  COPY --from=builder /app /app
  ENTRYPOINT ["/app"]
  ```
- [ ] **Benefits**: small final image, no build tools in production
- [ ] **Advanced**: named stages, multiple targets, shared stages
- [ ] **`--target`** build option: build only specific stage (testing, debugging)

## Module 5: Image Optimization
- [ ] **Base image choices**:
  - [ ] `alpine` (5 MB): small but musl libc differences
  - [ ] `debian-slim`, `ubuntu` (~30-80 MB): standard glibc
  - [ ] `distroless`: no shell, no package manager — minimal attack surface
  - [ ] `scratch`: empty — only for statically compiled binaries
  - [ ] `chainguard/*`: secure, minimal, maintained distroless alternatives
- [ ] **Reduce layers**: combine related RUN commands with `&&`
- [ ] **Clean up in same layer**: `apt install ... && rm -rf /var/lib/apt/lists/*`
- [ ] **Size optimization**:
  - [ ] Multi-stage builds
  - [ ] Use smaller base images
  - [ ] Remove package caches
  - [ ] `docker image ls` to compare
- [ ] **Target**: < 100 MB for most apps

## Module 6: BuildKit & Advanced Builds
- [ ] **BuildKit**: modern Docker build system (default in Docker 23+)
- [ ] **Features**:
  - [ ] Parallel build stages
  - [ ] Better caching
  - [ ] Secrets in builds (not embedded in image)
  - [ ] SSH forwarding for private repos
  - [ ] Cache mounts for package managers
- [ ] **Cache mounts**:
  ```dockerfile
  RUN --mount=type=cache,target=/root/.m2 mvn package
  ```
  - [ ] Persist cache across builds without bloating image
- [ ] **Secret mounts**:
  ```dockerfile
  RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm install
  ```
- [ ] **`docker buildx`**: extended CLI for BuildKit
  - [ ] Multi-platform builds (amd64, arm64 in one image)
  - [ ] `--platform linux/amd64,linux/arm64`
- [ ] **Alternatives to Dockerfile**:
  - [ ] **Buildpacks** (Paketo, heroku): no Dockerfile needed
  - [ ] **Jib** (Java): Maven/Gradle plugin, no daemon needed
  - [ ] **ko** (Go): fast Go container builds

## Module 7: Runtime Operations
- [ ] **`docker run` essentials**:
  - [ ] `-d` detached, `-it` interactive, `--rm` auto-remove
  - [ ] `-p host:container` port mapping
  - [ ] `-v host:container` volume mount
  - [ ] `-e VAR=value` environment variable
  - [ ] `--name` container name
  - [ ] `--restart always|unless-stopped|on-failure`
  - [ ] `--memory 512m --cpus 1.5` resource limits
- [ ] **Common commands**:
  - [ ] `docker ps [-a]` — list containers
  - [ ] `docker logs [-f] <id>` — view logs
  - [ ] `docker exec -it <id> bash` — shell into container
  - [ ] `docker inspect <id>` — detailed info
  - [ ] `docker stats` — live resource usage
- [ ] **Lifecycle**: create → start → stop → remove

## Module 8: Networking
- [ ] **Network drivers**:
  - [ ] `bridge` (default): NAT, private subnet per Docker host
  - [ ] `host`: share host's network stack (no isolation)
  - [ ] `none`: no networking
  - [ ] `overlay`: multi-host networks (Docker Swarm)
  - [ ] `macvlan`: container gets its own MAC address
- [ ] **Port publishing**: `-p 8080:80` → host:container
- [ ] **DNS**: containers in same network can resolve each other by name
- [ ] **`docker network` commands**: create, inspect, connect, disconnect
- [ ] **Custom networks**: isolate groups of containers
- [ ] **Internal networks**: no external access (`--internal`)

## Module 9: Volumes & Storage
- [ ] **Volume types**:
  - [ ] **Bind mount**: host directory → container (`-v /host:/container`)
  - [ ] **Named volume**: managed by Docker (`-v myvol:/data`)
  - [ ] **tmpfs**: in-memory, container-scoped
- [ ] **When to use**:
  - [ ] Named volumes: persistent data, databases
  - [ ] Bind mounts: development (source code), config files
  - [ ] tmpfs: secrets, scratch space
- [ ] **Volume drivers**: NFS, CIFS, cloud storage
- [ ] **Backup**: `docker run --rm -v myvol:/data -v $(pwd):/backup alpine tar cvf /backup/backup.tar /data`
- [ ] **Anonymous volumes**: created automatically by `VOLUME` in Dockerfile

## Module 10: Docker Compose
- [ ] **Compose**: define multi-container apps in `docker-compose.yml`
- [ ] **Key sections**:
  - [ ] `services`: each container definition
  - [ ] `networks`: custom networks
  - [ ] `volumes`: named volumes
  - [ ] `configs`, `secrets`: shared config/secrets
- [ ] **Common fields per service**:
  - [ ] `image` or `build`
  - [ ] `ports`, `environment`, `volumes`
  - [ ] `depends_on` (with health check conditions)
  - [ ] `healthcheck`, `restart`, `deploy` (for Swarm)
- [ ] **Commands**:
  - [ ] `docker compose up [-d]` — start services
  - [ ] `docker compose down [-v]` — stop and remove
  - [ ] `docker compose logs [-f] <service>`
  - [ ] `docker compose exec <service> bash`
  - [ ] `docker compose ps`, `restart`, `pull`, `build`
- [ ] **Profiles**: `--profile dev` to enable optional services
- [ ] **Environment files**: `.env` auto-loaded
- [ ] **Override files**: `docker-compose.override.yml` for local dev

## Module 11: Image Security
- [ ] **Non-root user**: `USER 1000:1000` in Dockerfile — NEVER run as root
- [ ] **Minimal base images**: distroless, chainguard, alpine (small attack surface)
- [ ] **Image scanning**:
  - [ ] **Trivy** (aquasec): fast CVE scanner
  - [ ] **Grype** (anchore): similar capabilities
  - [ ] **Snyk**, **Docker Scout**: commercial options
  - [ ] Scan in CI pipeline, fail on critical CVEs
- [ ] **Signed images**: cosign, Notary (see Supply Chain Security module)
- [ ] **Read-only rootfs**: `--read-only` flag
- [ ] **Drop capabilities**: `--cap-drop=ALL --cap-add=NET_BIND_SERVICE`
- [ ] **No new privileges**: `--security-opt=no-new-privileges`
- [ ] **User namespaces**: map container root to unprivileged host user
- [ ] **Secrets**: NEVER bake into image — use runtime secrets

## Module 12: Docker for JVM / Spring Boot
- [ ] **JVM in containers considerations**:
  - [ ] JVM honors cgroup memory limits (Java 10+): `-XX:+UseContainerSupport` (default)
  - [ ] `-XX:MaxRAMPercentage=75` to use most of container memory
  - [ ] `-XX:InitialRAMPercentage=50` for warm-up
- [ ] **Spring Boot layered JAR** (since 2.3):
  - [ ] `java -Djarmode=layertools -jar app.jar extract`
  - [ ] Dependencies layer changes rarely, app code changes often → better cache
- [ ] **Jib** (Google): no Dockerfile, reproducible, fast
  - [ ] `mvn compile jib:build`
  - [ ] Reuses layers, no Docker daemon needed
- [ ] **Cloud Native Buildpacks** (Paketo): `pack build myapp`
- [ ] **GraalVM native image**: compile to native binary, use distroless/scratch base
  - [ ] Tiny image, fast startup, less memory

## Module 13: Best Practices & Anti-Patterns
- [ ] **Do**:
  - [ ] One process per container (mostly)
  - [ ] Pin image versions (avoid `:latest`)
  - [ ] Use multi-stage builds
  - [ ] Run as non-root
  - [ ] Set `HEALTHCHECK`
  - [ ] Use `.dockerignore`
  - [ ] Scan images in CI
  - [ ] Sign images
  - [ ] Minimize layers and image size
- [ ] **Don't**:
  - [ ] Store secrets in images or env vars at build time
  - [ ] Run `apt-get upgrade` in Dockerfile
  - [ ] Use `sudo` in Dockerfile
  - [ ] Mount `/var/run/docker.sock` casually (full host access)
  - [ ] Put data in containers (use volumes)
  - [ ] Run as root without reason
  - [ ] Use `latest` tag in production

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Inspect namespaces and cgroups of a running container |
| Modules 2-3 | Write optimized Dockerfile with proper layer ordering |
| Module 4 | Convert a single-stage build to multi-stage, compare image size |
| Module 5 | Switch base images: alpine → distroless, measure size + vulnerabilities |
| Module 6 | Use BuildKit cache mount for Maven/npm, measure rebuild time |
| Module 7 | Run containers with resource limits, observe enforcement |
| Module 8 | Build 3-container app with custom bridge network |
| Module 9 | Back up and restore a named volume |
| Module 10 | Docker Compose for Spring Boot + PostgreSQL + Redis |
| Module 11 | Scan an image with Trivy, fix critical CVEs |
| Module 12 | Containerize a Spring Boot app using Jib |
| Module 13 | Audit a Dockerfile for anti-patterns, refactor |

## Key Resources
- docs.docker.com
- "Docker Deep Dive" — Nigel Poulton
- "Container Security" — Liz Rice
- Docker best practices guide (docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- github.com/wagoodman/dive (image layer inspector)
- Trivy (aquasecurity/trivy)
