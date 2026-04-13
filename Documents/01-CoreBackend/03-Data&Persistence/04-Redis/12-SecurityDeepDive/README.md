# Redis Security Deep Dive - Curriculum

How to secure Redis in production: AUTH, ACLs, TLS, protected mode, and threat mitigation.

---

## Module 1: Redis Security Threat Model
- [ ] **Common threats**:
  - [ ] Unauthenticated access over network
  - [ ] Eavesdropping on plaintext traffic
  - [ ] Command injection via user input
  - [ ] Resource exhaustion (memory, connections)
  - [ ] Data exfiltration
  - [ ] Backdoor installation (CONFIG SET dir/dbfilename attacks)
- [ ] **Historical context**: Redis was designed to be inside a trusted network
  - [ ] Default: no auth, bind to all interfaces (for dev convenience)
  - [ ] This caused massive exposure when cloud instances went to production
- [ ] **First rule of Redis security**: NEVER expose Redis directly to the internet

## Module 2: Protected Mode
- [ ] **Protected mode** (Redis 3.2+): default-deny when no explicit config
- [ ] **Behavior**: if Redis binds to all interfaces AND no password set, refuses remote connections
- [ ] **Bypass**: set `bind`, set `requirepass`, or explicitly `protected-mode no`
- [ ] **Purpose**: prevent accidentally exposing Redis with default config
- [ ] **Configuration**:
  - [ ] `protected-mode yes` (default)
  - [ ] Always keep enabled unless you've explicitly secured network + auth
- [ ] **Still possible to mess up**: binding to 0.0.0.0 + disabling protected mode

## Module 3: Binding & Network Isolation
- [ ] **`bind` directive**: which interfaces to listen on
  - [ ] `bind 127.0.0.1` — localhost only (safest)
  - [ ] `bind 10.0.0.5 127.0.0.1` — specific internal IP + localhost
  - [ ] `bind 0.0.0.0` — ALL interfaces (dangerous without auth)
- [ ] **Port**: default 6379, change to reduce automated scanning (`port 7000`)
- [ ] **Network defenses**:
  - [ ] Firewall rules (iptables, security groups)
  - [ ] Private subnet with no public IP
  - [ ] VPN or bastion host for admin access
- [ ] **Cloud best practices**:
  - [ ] Managed Redis (ElastiCache, Memorystore) inside VPC
  - [ ] No public IP assigned
  - [ ] Security group restricted to app instances

## Module 4: AUTH (Password Authentication)
- [ ] **`requirepass <password>`**: simple password auth
- [ ] **Client usage**: `AUTH <password>` before any command
- [ ] **Password requirements**:
  - [ ] LONG (50+ random characters) — Redis processes commands fast, brute force is real
  - [ ] Never hardcode in app code — use environment variables or secret manager
- [ ] **Replication password** (`masterauth`): replicas use to auth to master
- [ ] **Limitations of requirepass**:
  - [ ] Single password for all users
  - [ ] No per-user permissions
  - [ ] Can't revoke a compromised password without affecting all clients
- [ ] **Superseded by ACLs** (Redis 6+) — prefer ACLs for new deployments

## Module 5: ACL (Access Control Lists) — Redis 6+
- [ ] **ACL**: multi-user access control with granular permissions
- [ ] **User definition**: `ACL SETUSER username [rules]`
- [ ] **Rule examples**:
  - [ ] `on` / `off` — enable/disable user
  - [ ] `>password` — add password (hashed internally)
  - [ ] `+command` / `-command` — allow/deny specific command
  - [ ] `+@category` — allow command category (e.g., `+@read`, `+@write`, `+@admin`)
  - [ ] `~pattern` — key pattern restriction (`~user:*`)
  - [ ] `&pattern` — pub/sub channel pattern
- [ ] **Categories**:
  - [ ] `@read` (read commands), `@write`, `@admin`, `@dangerous`, `@connection`, `@keyspace`
  - [ ] `@all` (everything), `@fast`, `@slow`
- [ ] **Default user**: initial user, configured via `requirepass` or `ACL`
- [ ] **Example**:
  ```
  ACL SETUSER app1 on >strongpass ~cache:* +@read +@write -flushdb -flushall
  ```
- [ ] **Commands**:
  - [ ] `ACL LIST` — show users
  - [ ] `ACL GETUSER name` — user details
  - [ ] `ACL WHOAMI` — current user
  - [ ] `ACL CAT` — command categories
- [ ] **Persistence**: ACLs in `aclfile` or in redis.conf

## Module 6: TLS Encryption (Redis 6+)
- [ ] **Redis native TLS support** (Redis 6+)
- [ ] **Before 6.0**: use stunnel or redis-proxy for TLS
- [ ] **Configuration**:
  ```
  tls-port 6380
  port 0                  # disable plain text (or keep both)
  tls-cert-file /path/cert.pem
  tls-key-file /path/key.pem
  tls-ca-cert-file /path/ca.pem
  tls-auth-clients yes    # require client certificate (mTLS)
  ```
- [ ] **Replication over TLS**:
  - [ ] `tls-replication yes`
  - [ ] Requires certificates trusted by both master and replicas
- [ ] **Cluster bus over TLS**: `tls-cluster yes`
- [ ] **Client config**: use `rediss://` URL or TLS-enabled client
- [ ] **Performance cost**: ~10-20% overhead — acceptable for most workloads
- [ ] **mTLS**: client presents certificate → stronger auth

## Module 7: Command Renaming & Disabling
- [ ] **`rename-command`**: hide or disable dangerous commands
- [ ] **Example**:
  ```
  rename-command FLUSHDB ""            # disable entirely
  rename-command FLUSHALL ""
  rename-command CONFIG "SECRET_CFG_9x2" # hide, only admins know the name
  rename-command DEBUG ""
  ```
- [ ] **Dangerous commands to consider**:
  - [ ] `FLUSHDB`, `FLUSHALL` — delete all data
  - [ ] `CONFIG SET` — can modify runtime config, attackers love this
  - [ ] `DEBUG` — internal debugging
  - [ ] `KEYS` — blocks server
  - [ ] `SHUTDOWN` — stops Redis
  - [ ] `SCRIPT`, `EVAL` — can be abused
- [ ] **With ACLs**: prefer ACL restrictions over command renaming
- [ ] **Trade-off**: renamed commands still work for admins who know the name
- [ ] **Cannot rename**: some commands cannot be renamed (basic ones)

## Module 8: The Classic Redis Attack (CVE-style)
- [ ] **Background**: thousands of Redis instances exposed publicly, no auth
- [ ] **Attack scenario**:
  1. [ ] Attacker scans port 6379
  2. [ ] Redis without auth accepts commands
  3. [ ] `CONFIG SET dir /root/.ssh`
  4. [ ] `CONFIG SET dbfilename authorized_keys`
  5. [ ] `SET payload "SSH public key"`
  6. [ ] `SAVE` → writes file with attacker's SSH key
  7. [ ] Attacker SSHes in as root
- [ ] **Variants**: write cron jobs, startup scripts, web shells
- [ ] **Why it worked**: no auth + CONFIG command allowed
- [ ] **Mitigation**:
  - [ ] Never expose Redis publicly
  - [ ] Always enable authentication
  - [ ] Run as non-root user
  - [ ] Disable or restrict CONFIG SET via ACL
  - [ ] Protected mode catches accidental exposures

## Module 9: Running Redis Safely
- [ ] **Run as non-root user**:
  - [ ] Create dedicated `redis` user
  - [ ] Package managers do this by default
  - [ ] Custom installs: `chown redis:redis` data dir, run via systemd as redis user
- [ ] **File permissions**:
  - [ ] `aclfile`, `redis.conf`: readable only by redis user (no world-read)
  - [ ] Data directory: redis user only
- [ ] **Resource limits**:
  - [ ] `maxmemory`: prevent memory exhaustion
  - [ ] `maxclients`: prevent connection flood
  - [ ] `client-output-buffer-limit`: prevent slow client buffering attack
- [ ] **SELinux / AppArmor**: additional sandboxing
- [ ] **Regular updates**: apply security patches promptly
- [ ] **Vulnerability scanning**: monitor CVE database for Redis

## Module 10: Input Validation & Injection
- [ ] **Command injection**: rare in Redis (no SQL-like syntax) but possible
- [ ] **Scenarios**:
  - [ ] User input in key name → unauthorized access to other keys
  - [ ] User input in Lua script → arbitrary command execution
  - [ ] User input in routing key → pub/sub exploitation
- [ ] **Prevention**:
  - [ ] Parameterize: pass user input as ARGV, not in script body
  - [ ] Validate: whitelist allowed characters
  - [ ] Sanitize: escape special characters in patterns
- [ ] **Example vulnerable Lua**:
  ```lua
  -- DANGEROUS: user input inline
  return redis.call('GET', 'user:' .. ARGV[1])  -- OK (ARGV is parameterized)
  ```
- [ ] **Example vulnerable client code**:
  ```java
  jedis.get("user:" + userInput);  // if userInput = "x\r\nDEL *" → injection (prevented by protocol framing)
  ```

## Module 11: Audit Logging & Monitoring
- [ ] **Redis doesn't have built-in audit logs** (unlike enterprise DBs)
- [ ] **Workarounds**:
  - [ ] `MONITOR` command — stream all commands (huge performance cost, don't use in production)
  - [ ] Slow log — captures slow commands only
  - [ ] ACL log — `ACL LOG` captures authentication failures and rule violations (Redis 6+)
- [ ] **External auditing**:
  - [ ] Log from proxy or client library
  - [ ] Use Redis Enterprise or cloud-managed Redis with audit features
- [ ] **Alerting**:
  - [ ] ACL violations
  - [ ] Unusual command patterns (FLUSHDB, CONFIG SET)
  - [ ] Failed auth attempts
- [ ] **Compliance**: GDPR, PCI, HIPAA often require audit trails — plan for them

## Module 12: Hardening Checklist
- [ ] Bind to specific internal interface (not 0.0.0.0)
- [ ] Set strong authentication (ACL with per-user passwords)
- [ ] Enable TLS for client and replication traffic
- [ ] Configure maxmemory + non-destructive eviction policy
- [ ] Set maxclients and output buffer limits
- [ ] Disable or restrict CONFIG SET, FLUSHDB, FLUSHALL
- [ ] Run as non-root user
- [ ] Network isolation (private subnet, firewall)
- [ ] Keep Redis patched (monitor security advisories)
- [ ] Enable protected mode
- [ ] Separate credentials per application
- [ ] Regular backup + restore testing
- [ ] Monitor for ACL violations and unusual patterns
- [ ] Document access control policy

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Review protected mode behavior with and without auth |
| Module 3 | Bind Redis to specific interface, test access from allowed/blocked IPs |
| Module 4 | Set strong password, verify AUTH required |
| Module 5 | Create 3 ACL users with different permissions, test restrictions |
| Module 6 | Enable TLS, connect client over TLS, verify encryption |
| Module 7 | Rename CONFIG and FLUSHDB, test renamed commands |
| Module 8 | Reproduce the classic attack (in isolated env!), apply mitigations |
| Module 9 | Set up Redis with non-root user, proper file permissions |
| Module 10 | Write secure Lua script that handles user input safely |
| Module 11 | Enable ACL LOG, trigger auth failures, inspect log |
| Module 12 | Audit a Redis config against the hardening checklist |

## Key Resources
- redis.io/docs/management/security/
- redis.io/docs/management/security/acl/
- redis.io/docs/management/security/encryption/
- "Redis Security" — redis.io
- "Hundreds of thousands of Redis servers exposed" — security blog posts
