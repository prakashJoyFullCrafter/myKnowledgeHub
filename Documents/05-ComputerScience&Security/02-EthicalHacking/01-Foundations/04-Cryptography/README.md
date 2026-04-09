# Cryptography Basics - Curriculum

## Module 1: Hashing
- [ ] **Hash function**: one-way, deterministic, fixed-size output
- [ ] Properties: pre-image resistance, second pre-image resistance, collision resistance
- [ ] **Insecure for passwords**: MD5, SHA-1, SHA-256 — too fast (GPU brute-force)
- [ ] **Password hashing**: Bcrypt, Argon2, scrypt, PBKDF2 — designed to be slow
- [ ] **Salt**: random per-user value mixed into hash to prevent rainbow tables
- [ ] **Pepper**: server-side secret added to password before hashing
- [ ] HMAC: keyed hash for message authentication
- [ ] When to use which: SHA-256 for integrity, Bcrypt/Argon2 for passwords, HMAC for auth

## Module 2: Symmetric Encryption
- [ ] **Symmetric**: same key encrypts and decrypts
- [ ] **AES** (Advanced Encryption Standard): 128/192/256-bit keys, industry standard
- [ ] **Block cipher modes**:
  - [ ] **ECB** (Electronic Codebook) — INSECURE, never use (patterns visible)
  - [ ] **CBC** (Cipher Block Chaining) — needs IV, padding oracle attacks
  - [ ] **GCM** (Galois/Counter Mode) — authenticated encryption, recommended
  - [ ] **CTR** (Counter) — parallelizable
- [ ] **AEAD** (Authenticated Encryption with Associated Data): AES-GCM, ChaCha20-Poly1305
- [ ] **IV (Initialization Vector)**: must be unique per encryption, never reuse with same key
- [ ] Key management: rotation, storage (KMS, Vault, HSM)

## Module 3: Asymmetric Encryption (Public Key)
- [ ] **Asymmetric**: public key encrypts, private key decrypts (or sign with private, verify with public)
- [ ] **RSA**: traditional, key sizes 2048/4096 bits, slower than symmetric
- [ ] **ECC** (Elliptic Curve Cryptography): smaller keys, faster, modern (Curve25519, P-256)
- [ ] **Hybrid encryption**: use RSA/ECC to exchange symmetric key, then AES for bulk encryption
- [ ] **Digital signatures**: sign hash with private key, verify with public key
- [ ] Algorithms: RSA-PSS, ECDSA, EdDSA (Ed25519)

## Module 4: TLS / HTTPS
- [ ] **TLS handshake** (1.3 simplified):
  1. Client hello → cipher suites supported
  2. Server hello → chosen cipher, certificate
  3. Client verifies certificate (CA chain)
  4. Key exchange (ECDHE for perfect forward secrecy)
  5. Encrypted application data
- [ ] **Certificate Authority (CA)**: trusted third party signs server certificates
- [ ] **Certificate chain**: server cert → intermediate → root CA
- [ ] **Self-signed certificates**: for development only, browsers warn
- [ ] **Let's Encrypt**: free CA with ACME protocol for automation
- [ ] **mTLS** (mutual TLS): both client and server present certificates
- [ ] **Certificate pinning**: app trusts only specific certificate (mobile apps)
- [ ] **TLS 1.0/1.1**: deprecated, TLS 1.2 minimum, TLS 1.3 recommended

## Module 5: JWT & Token Security
- [ ] **JWT structure**: `header.payload.signature` (Base64url encoded)
- [ ] **Algorithms**: HS256 (HMAC), RS256 (RSA), ES256 (ECDSA)
- [ ] **`alg: none` vulnerability**: never accept unsigned tokens
- [ ] **Algorithm confusion attack**: server expects RSA but accepts HMAC with public key as secret
- [ ] **Sensitive data in payload**: payload is BASE64-ENCODED, not encrypted — never put secrets
- [ ] **Token expiration**: short-lived access tokens (15 min) + refresh tokens
- [ ] **Token storage**: HttpOnly cookie (XSS-safe) vs localStorage (XSS-vulnerable)
- [ ] **JWT vs sessions**: stateless vs stateful trade-offs

## Module 6: Common Crypto Mistakes
- [ ] **Rolling your own crypto** — use battle-tested libraries (Bouncy Castle, Tink, libsodium)
- [ ] **Hardcoded keys/secrets** in source code
- [ ] **Weak random number generation**: `Random` instead of `SecureRandom`
- [ ] **Timing attacks**: use constant-time comparison for secrets (`MessageDigest.isEqual()`)
- [ ] **MD5/SHA-1 for passwords** — broken, use Bcrypt/Argon2
- [ ] **ECB mode** — never use
- [ ] **Reusing IVs/nonces** with same key — catastrophic
- [ ] **Storing encrypted secrets without authenticating ciphertext** — use AEAD modes
- [ ] **Trusting client-side validation** for security checks

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Hash password with Bcrypt + Argon2, measure time, brute-force attempt |
| Module 2 | Encrypt/decrypt with AES-GCM in Java, demonstrate ECB pattern leak |
| Module 3 | Generate RSA keypair, sign and verify a message |
| Module 4 | Set up Let's Encrypt + nginx, configure mTLS between two services |
| Module 5 | Issue JWT, attempt `alg: none` attack, verify rejection |
| Module 6 | Audit a project for hardcoded secrets, weak random, MD5 usage |

## Key Resources
- "Cryptography Engineering" - Ferguson, Schneier, Kohno
- "Serious Cryptography" - JP Aumasson
- OWASP Cryptographic Storage Cheat Sheet
- Cryptopals Crypto Challenges (cryptopals.com)
