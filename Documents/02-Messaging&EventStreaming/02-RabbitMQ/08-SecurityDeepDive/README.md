# RabbitMQ Security Deep Dive - Curriculum

How to secure a RabbitMQ cluster: authentication, authorization, encryption, and multi-tenant isolation.

---

## Module 1: Security Threat Model
- [ ] **Threats to consider**:
  - [ ] Unauthorized access (wrong credentials, no auth)
  - [ ] Network eavesdropping (plaintext AMQP traffic)
  - [ ] Cross-tenant access (vhost boundary violations)
  - [ ] Privileged insider abuse
  - [ ] Management UI exposure
  - [ ] Inter-node traffic (cluster communication)
- [ ] **Security layers**:
  - [ ] **Authentication**: who are you?
  - [ ] **Authorization**: what can you do?
  - [ ] **Encryption**: transport security
  - [ ] **Isolation**: vhost boundaries
  - [ ] **Auditing**: track who did what
- [ ] **Default RabbitMQ is INSECURE**: default `guest`/`guest` user, no TLS, localhost-only fallback
- [ ] **First-day hardening**: delete default user, create real users, enable TLS

## Module 2: Authentication Mechanisms
- [ ] **Internal authentication** (default):
  - [ ] Username/password stored in Mnesia
  - [ ] `rabbitmqctl add_user alice password123`
  - [ ] Passwords hashed (SHA-256 by default)
  - [ ] **Suitable for small deployments**
- [ ] **SASL mechanisms supported**:
  - [ ] `PLAIN`: username + password (requires TLS)
  - [ ] `AMQPLAIN`: RabbitMQ legacy variant of PLAIN
  - [ ] `EXTERNAL`: identity from TLS certificate (mTLS)
  - [ ] `RABBIT-CR-DEMO`: demo challenge-response (not for production)
- [ ] **LDAP authentication**:
  - [ ] Plugin: `rabbitmq_auth_backend_ldap`
  - [ ] Authenticate against corporate LDAP/AD
  - [ ] Configurable user DN pattern, group lookup
- [ ] **HTTP authentication**:
  - [ ] Plugin: `rabbitmq_auth_backend_http`
  - [ ] Delegate to external HTTP service
  - [ ] Useful for custom auth integrations
- [ ] **OAuth 2.0 / JWT**:
  - [ ] Plugin: `rabbitmq_auth_backend_oauth2`
  - [ ] Validate JWT tokens from Keycloak, Okta, Azure AD
  - [ ] Scope-based authorization
- [ ] **Multi-backend**: chain multiple backends (try LDAP, fall back to internal)

## Module 3: User Management & Tags
- [ ] **Creating users**:
  - [ ] `rabbitmqctl add_user username password`
  - [ ] `rabbitmqctl change_password username newpassword`
  - [ ] `rabbitmqctl delete_user username`
- [ ] **User tags**: grant broad permissions
  - [ ] `administrator`: full access, manage cluster
  - [ ] `monitoring`: read-only for metrics
  - [ ] `policymaker`: can set policies
  - [ ] `management`: access management UI
  - [ ] No tag: only AMQP protocol access (no management UI)
- [ ] **Set tags**: `rabbitmqctl set_user_tags alice monitoring`
- [ ] **Password hashing algorithms**: SHA-256 (default), SHA-512
  - [ ] Configurable via `auth_backends.1.rabbit_password_hashing_module`
- [ ] **Best practice**: separate users per service (not shared), unique strong passwords

## Module 4: Permissions & Authorization
- [ ] **Permissions are per-vhost, per-user**
- [ ] **Three permission types** (regex-based):
  - [ ] `configure`: create/delete queues, exchanges
  - [ ] `write`: publish to exchange
  - [ ] `read`: consume from queue
- [ ] **Setting permissions**:
  - [ ] `rabbitmqctl set_permissions -p /my-vhost alice ".*" ".*" ".*"` (full access)
  - [ ] `rabbitmqctl set_permissions -p /my-vhost alice "^alice-.*" "^alice-.*" "^alice-.*"` (prefix scope)
  - [ ] `rabbitmqctl set_permissions -p /my-vhost alice "" "^amq\\..*" "^amq\\..*"` (default exchange read/write only)
- [ ] **Regex matching**: matches against resource names (queues, exchanges)
- [ ] **Best practices**:
  - [ ] Least privilege: grant minimal permissions
  - [ ] Prefix-based scoping for multi-service brokers
  - [ ] Separate users per producer and consumer if possible
- [ ] **Topic-level permissions**: newer feature for topic exchanges
  - [ ] Regex-based routing key authorization
  - [ ] `rabbitmqctl set_topic_permissions -p /vhost alice amq.topic "^order\\..*" ".*"`

## Module 5: TLS/SSL Configuration
- [ ] **Why TLS**: encrypt AMQP traffic (otherwise plaintext passwords on wire)
- [ ] **AMQPS (AMQP over TLS)**: default port 5671
- [ ] **Certificate setup**:
  - [ ] Private key + certificate + CA chain
  - [ ] Self-signed for dev, real CA for production
- [ ] **RabbitMQ config** (`rabbitmq.conf`):
  ```
  listeners.ssl.default = 5671
  ssl_options.cacertfile = /path/to/ca_certificate.pem
  ssl_options.certfile = /path/to/server_certificate.pem
  ssl_options.keyfile = /path/to/server_key.pem
  ssl_options.verify = verify_peer
  ssl_options.fail_if_no_peer_cert = false
  ```
- [ ] **Client config**: point at `amqps://` URL, provide truststore
- [ ] **TLS versions**: disable old TLS 1.0/1.1, use TLS 1.2+
- [ ] **Cipher suites**: restrict to strong ciphers (AES-GCM, ChaCha20)
- [ ] **Test**: `openssl s_client -connect host:5671` to verify
- [ ] **Management UI over HTTPS**: separate TLS config for `rabbitmq_management`

## Module 6: mTLS (Mutual TLS) Authentication
- [ ] **mTLS**: both client and broker present certificates
- [ ] **Client identity from certificate**: Subject Alternative Name (SAN) or CN
- [ ] **Config**:
  ```
  ssl_options.verify = verify_peer
  ssl_options.fail_if_no_peer_cert = true
  auth_mechanisms.1 = EXTERNAL
  ```
- [ ] **Principal extraction** (`ssl_cert_login_from`):
  - [ ] `common_name`: use CN from certificate
  - [ ] `distinguished_name`: use full DN
  - [ ] `subject_alternative_name`: use SAN
- [ ] **Client setup**: provide its own certificate + private key
- [ ] **Use cases**: service-to-service auth, no passwords, certificate-based identity
- [ ] **Certificate lifecycle**: rotation, revocation (CRL/OCSP), renewal automation
- [ ] **Management UI mTLS**: configure separately for HTTPS

## Module 7: Vhost-Based Multi-Tenancy
- [ ] **Vhost**: logical grouping — exchanges, queues, bindings, users, policies
- [ ] **Isolation**: exchanges/queues in different vhosts cannot interact
- [ ] **Per-vhost resources**: policies, federation, limits
- [ ] **Per-vhost permissions**: users get configure/write/read per vhost
- [ ] **Vhost limits** (since 3.11):
  - [ ] `max-connections` — prevent tenant from hogging connections
  - [ ] `max-queues` — limit queue count
- [ ] **Naming convention**: use descriptive vhost names (e.g., `/tenant-abc`, `/analytics`)
- [ ] **Isolation levels**:
  - [ ] Shared broker + vhost-per-tenant: strong logical isolation, shared resources
  - [ ] Separate broker per tenant: strongest isolation, highest cost
  - [ ] Shared vhost + naming prefixes: weakest, avoid for untrusted tenants
- [ ] **Cross-vhost communication**: federation or shovel (controlled bridging)

## Module 8: Inter-Node Security & Audit
- [ ] **Inter-node traffic**: Erlang distribution protocol between cluster nodes
- [ ] **Erlang cookie**: shared secret, must be identical across cluster
  - [ ] Generate random: `openssl rand -base64 32`
  - [ ] Store in `~/.erlang.cookie` (permissions 400)
  - [ ] **Security risk if leaked**: attacker can control the cluster
- [ ] **Inter-node TLS**: encrypt Erlang distribution protocol
  - [ ] `inter_node_tls.cacertfile`, `.certfile`, `.keyfile`
  - [ ] Important for multi-DC or untrusted networks
- [ ] **Audit logging**:
  - [ ] Connection events (open, close, auth failure)
  - [ ] Access denials
  - [ ] Policy and user changes
  - [ ] Log plugin: `rabbitmq_event_exchange` — events as messages
  - [ ] Forward to SIEM (Splunk, ELK)
- [ ] **Hardening checklist**:
  - [ ] Delete default `guest` user
  - [ ] Enable TLS on all listeners
  - [ ] mTLS for production inter-service auth
  - [ ] Audit logs to external system
  - [ ] Regular security patches
  - [ ] Management UI behind VPN or auth proxy

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Document threat model for your RabbitMQ deployment |
| Module 2 | Set up LDAP auth backend, test with real directory |
| Module 3 | Create users with different tags, verify access levels |
| Module 4 | Set up prefix-based permissions for a multi-service broker |
| Module 5 | Enable TLS, connect client with truststore, verify encryption |
| Module 6 | Configure mTLS with EXTERNAL auth, extract identity from certificate |
| Module 7 | Create 3 vhosts for 3 tenants, verify isolation |
| Module 8 | Enable audit logging via event exchange, forward to external store |

## Key Resources
- RabbitMQ documentation — Access Control, Authentication, TLS
- rabbitmq.com/access-control.html
- rabbitmq.com/ssl.html
- "RabbitMQ Security Guide" — rabbitmq.com
- "TLS-Enabled RabbitMQ" — CloudAMQP blog
- rabbitmq.com/oauth2.html
