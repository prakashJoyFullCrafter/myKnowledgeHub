# Blob / Object Storage - Curriculum

## Module 1: Object Storage Fundamentals
- [ ] What is object storage? Flat namespace, key-value (key = path, value = binary blob + metadata)
- [ ] Object storage vs file storage vs block storage
- [ ] Objects are immutable — no append, no partial update (replace entire object)
- [ ] Metadata: content-type, custom headers, tags, encryption info
- [ ] Virtually unlimited storage, pay per GB + requests

## Module 2: Amazon S3 (& Compatible APIs)
- [ ] **Buckets**: global namespace containers
- [ ] **Objects**: key (path), value (data), metadata, version ID
- [ ] Storage classes: Standard, Infrequent Access, Glacier, Deep Archive
- [ ] **Lifecycle policies**: auto-transition to cheaper storage, auto-delete after N days
- [ ] **Versioning**: keep multiple versions of same object
- [ ] **Cross-region replication**: replicate to another region for DR
- [ ] S3-compatible alternatives: MinIO (self-hosted), GCS, Azure Blob Storage, DigitalOcean Spaces

## Module 3: Access Patterns
- [ ] **Pre-signed URLs**: time-limited signed URL for upload/download without exposing credentials
  - [ ] Upload: `PUT` pre-signed URL for client-side direct upload to S3
  - [ ] Download: `GET` pre-signed URL for temporary access to private objects
- [ ] **Multipart upload**: upload large files in parts (parallel, resume on failure)
  - [ ] Required for files > 5GB, recommended for > 100MB
- [ ] **Transfer Acceleration**: route uploads through CloudFront edge for faster global uploads
- [ ] **S3 Select / Glacier Select**: query inside objects (CSV, JSON, Parquet) without downloading
- [ ] **Byte-range fetches**: download specific byte ranges (parallel download, resume)

## Module 4: Architecture Patterns
- [ ] **Direct upload**: client → pre-signed URL → S3 (bypass your server for large files)
- [ ] **CDN + S3**: CloudFront in front of S3 for global low-latency delivery
- [ ] **Data lake**: S3 as central store for raw data, query with Athena/Spark/Presto
- [ ] **Event notifications**: S3 triggers Lambda/SQS/SNS on upload/delete (image processing, indexing)
- [ ] **Static website hosting**: S3 + CloudFront for SPAs (React, Next.js export)
- [ ] **Backup and archival**: database dumps, log archives → Glacier for cost savings

## Module 5: Security & Best Practices
- [ ] **Bucket policies**: JSON policy for bucket-level access rules
- [ ] **IAM policies**: user/role-level access to S3 operations
- [ ] **Block public access**: enable by default, only open for static hosting
- [ ] **Encryption**: SSE-S3 (S3-managed keys), SSE-KMS (customer-managed keys), client-side encryption
- [ ] **Access logging**: track who accessed what
- [ ] **Object lock**: WORM (Write Once Read Many) for compliance
- [ ] **Cost optimization**: choose correct storage class, lifecycle policies, request batching
- [ ] Never store secrets in S3 without encryption, never make sensitive buckets public

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Set up S3 bucket with versioning, lifecycle policy to Glacier after 90 days |
| Module 3 | Implement pre-signed URL upload from a Spring Boot API |
| Module 4 | Build image upload flow: client → pre-signed URL → S3 → Lambda resize → CloudFront serve |
| Module 5 | Security audit: bucket policy, block public access, encryption, access logs |

## Key Resources
- AWS S3 documentation
- MinIO documentation (for self-hosted S3-compatible storage)
- "Building a Scalable File Upload Service" - system design exercise
- AWS Well-Architected Framework - Storage lens
