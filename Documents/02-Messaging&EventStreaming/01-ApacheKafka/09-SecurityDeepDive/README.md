# Kafka Security Deep Dive - Curriculum

How to secure a Kafka cluster: authentication, authorization, encryption, and multi-tenant isolation.

---

## Module 1: Security Threat Model
- [ ] **Threats to consider**:
  - [ ] Unauthorized access to topics (read/write)
  - [ ] Eavesdropping on network traffic
  - [ ] Impersonation (rogue broker or client)
  - [ ] Data tampering in transit
  - [ ] Privileged insider abuse
- [ ] **Kafka security primitives**:
  - [ ] **Authentication**: who are you? (SASL, mTLS)
  - [ ] **Authorization**: what can you do? (ACLs)
  - [ ] **Encryption**: protect data in transit (TLS) and at rest (disk encryption)
  - [ ] **Auditing**: track what happened (audit logs)
- [ ] **Default Kafka = insecure**: plaintext, no auth, no ACLs — must be configured explicitly
- [ ] **Security is layered**: don't rely on one mechanism alone

## Module 2: Encryption in Transit (TLS/SSL)
- [ ] **TLS encryption**: protects broker-client and broker-broker traffic
- [ ] **Listener configuration**: each broker listener has a security protocol
  - [ ] `PLAINTEXT`: no encryption (development only)
  - [ ] `SSL`: TLS encryption
  - [ ] `SASL_PLAINTEXT`: SASL auth without encryption (avoid)
  - [ ] `SASL_SSL`: SASL auth over TLS (recommended)
- [ ] **Server-side TLS config**:
  - [ ] `ssl.keystore.location`, `ssl.keystore.password` — broker's certificate
  - [ ] `ssl.truststore.location` — trusted CAs
  - [ ] `ssl.key.password` — key password
  - [ ] `ssl.endpoint.identification.algorithm=https` — verify hostname
- [ ] **Client-side TLS config**:
  - [ ] `security.protocol=SSL` or `SASL_SSL`
  - [ ] `ssl.truststore.*` to verify broker certificate
- [ ] **Certificate management**:
  - [ ] Use internal CA or commercial CA
  - [ ] Rotate certificates before expiry — plan for this
  - [ ] Monitor certificate expiry dates

## Module 3: SASL Authentication Mechanisms
- [ ] **SASL (Simple Authentication and Security Layer)**: pluggable auth framework
- [ ] **SASL/PLAIN**:
  - [ ] Username + password in plaintext
  - [ ] MUST use TLS (else password is exposed)
  - [ ] Simple but passwords stored in JAAS config files
- [ ] **SASL/SCRAM** (SCRAM-SHA-256, SCRAM-SHA-512):
  - [ ] Salted Challenge Response — no plaintext passwords on wire
  - [ ] Credentials stored in ZooKeeper/KRaft metadata
  - [ ] Recommended for production (vs PLAIN)
  - [ ] `kafka-configs.sh --alter --add-config 'SCRAM-SHA-512=[password=...]' --entity-type users`
- [ ] **SASL/GSSAPI (Kerberos)**:
  - [ ] Enterprise SSO integration
  - [ ] Complex but widely used in enterprises
  - [ ] Requires KDC infrastructure
- [ ] **SASL/OAUTHBEARER**:
  - [ ] OAuth 2.0 / OIDC tokens
  - [ ] Integrates with Keycloak, Okta, Azure AD
  - [ ] Modern cloud-native choice
- [ ] **SASL/DELEGATION**: short-lived tokens issued to clients (for long-running jobs)

## Module 4: mTLS Authentication
- [ ] **Mutual TLS**: both broker and client present certificates
- [ ] **Identity from certificate**: client's identity = certificate Subject DN (or CN)
- [ ] **Configuration**:
  - [ ] `ssl.client.auth=required` on broker
  - [ ] Client provides keystore with its certificate + private key
- [ ] **Principal mapping**: `ssl.principal.mapping.rules` — extract identity from DN
  - [ ] Example: `RULE:^CN=(.*?)$/$1/L` maps `CN=alice` to `alice`
- [ ] **Advantages**: no passwords, strong cryptographic identity, widely supported
- [ ] **Disadvantages**: certificate lifecycle management, harder to rotate at scale
- [ ] **Use cases**: service-to-service auth, internal clusters

## Module 5: Authorization with ACLs
- [ ] **ACL (Access Control List)**: who can do what on which resource
- [ ] **Resource types**:
  - [ ] `Topic`: read, write, describe, delete, create, alter
  - [ ] `Group`: read (consume), describe, delete
  - [ ] `Cluster`: create, describe, alter, cluster-action
  - [ ] `TransactionalId`: write, describe (for transactional producers)
  - [ ] `DelegationToken`: describe
- [ ] **ACL structure**: (Principal, Operation, Resource, PermissionType, Host)
- [ ] **`kafka-acls.sh`**:
  - [ ] `--add --allow-principal User:alice --operation Read --topic orders`
  - [ ] `--remove --deny-principal User:bob --operation Write --topic orders`
  - [ ] `--list --topic orders`
- [ ] **Authorizer implementations**:
  - [ ] `AclAuthorizer` (default): ACLs stored in ZooKeeper/metadata
  - [ ] Custom authorizers: integrate with LDAP, RBAC systems
- [ ] **`super.users`**: bypass all ACLs (use sparingly)
- [ ] **`allow.everyone.if.no.acl.found`**: default-deny vs default-allow (default-deny recommended)
- [ ] **Prefix ACLs**: `--resource-pattern-type prefixed` — grant to `team-a-*`

## Module 6: Encryption at Rest
- [ ] **Disk-level encryption**:
  - [ ] LUKS (Linux), BitLocker (Windows), EBS encryption (AWS)
  - [ ] Transparent to Kafka, OS handles
  - [ ] Protects against physical theft
- [ ] **Filesystem encryption**: XFS with encryption, ext4 with fscrypt
- [ ] **Cloud provider encryption**: EBS, GCE persistent disks, Azure disks
- [ ] **Kafka does NOT support built-in end-to-end encryption**
- [ ] **Client-side encryption** (if needed):
  - [ ] Encrypt sensitive fields before producing
  - [ ] Use KMS for key management
  - [ ] Decrypt in consumer
  - [ ] Trade-off: breaks search, compaction by encrypted field
- [ ] **Compliance**: check whether encryption at rest is mandated (HIPAA, PCI, etc.)

## Module 7: Multi-Tenant Isolation
- [ ] **Logical tenant separation**:
  - [ ] Topic prefix per tenant: `tenant-a.orders`, `tenant-b.orders`
  - [ ] ACLs scoped to tenant prefix
  - [ ] Consumer groups prefixed: `tenant-a.consumer-group-1`
- [ ] **Physical isolation**:
  - [ ] Separate clusters per tenant (strongest isolation)
  - [ ] Expensive, more operational overhead
- [ ] **Quota isolation**: prevent noisy neighbors
  - [ ] **Client quotas**: bytes/sec per client or user
  - [ ] **Request rate quotas**: request-handler time per client
  - [ ] `kafka-configs.sh --alter --entity-type clients --entity-name client-1 --add-config 'producer_byte_rate=1048576'`
- [ ] **Storage quotas**: control per-topic retention, size limits
- [ ] **Naming conventions**: enforce topic naming to prevent collision
- [ ] **Schema Registry isolation**: separate registries or subject-prefix ACLs

## Module 8: Audit Logging & Compliance
- [ ] **Audit logging**: track security-relevant events
  - [ ] Authentication attempts (success/fail)
  - [ ] Authorization denials
  - [ ] ACL changes
  - [ ] Topic creation/deletion
  - [ ] Configuration changes
- [ ] **Kafka authorizer logs**: `kafka.authorizer.logger` log4j category
  - [ ] Log denied requests to find misconfigurations or attacks
- [ ] **Commercial options**:
  - [ ] Confluent Audit Logs: structured audit events to a dedicated topic
  - [ ] Third-party integrations: Splunk, Datadog, Elastic
- [ ] **Compliance considerations**:
  - [ ] GDPR: right to deletion (hard in Kafka — use compaction with tombstones)
  - [ ] PCI DSS: protect card data (avoid in Kafka, or encrypt fields)
  - [ ] SOC 2: demonstrate access controls and monitoring
- [ ] **Best practices**:
  - [ ] Least privilege: grant minimal ACLs
  - [ ] Regular ACL audit
  - [ ] Rotate credentials (SCRAM passwords, certificates)
  - [ ] Separate prod/staging credentials

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Document threat model for your Kafka cluster |
| Module 2 | Enable TLS on a broker, connect client with truststore |
| Module 3 | Configure SASL/SCRAM-SHA-512, create users, test authentication |
| Module 4 | Enable mTLS, configure principal mapping, test with client cert |
| Module 5 | Create ACLs for a producer (write) and consumer (read), test allow/deny |
| Module 6 | Enable disk encryption on broker storage, verify performance impact |
| Module 7 | Design multi-tenant setup: prefix ACLs + quotas for 3 tenants |
| Module 8 | Enable audit logging, inspect denied requests, tune ACLs |

## Key Resources
- Apache Kafka Security documentation
- "Kafka Security Deep Dive" — Confluent blog
- KIP-11: Authorization Interface
- "Kafka SASL/OAUTHBEARER" — Confluent blog
- OWASP Secure Configuration for Kafka
