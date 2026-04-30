# Object Storage — Use Cases Walkthrough

---

## 1. Image Hosting (e.g., Instagram)
**Scenario:** Users upload and view photos globally.

**Why this fits**
- Massive scalability for unstructured media
- High durability (user data must not be lost)
- CDN integration for global low-latency delivery

**Architecture sketch**
Client → Presigned URL → S3  
S3 → Event → Lambda (resize images)  
Processed images → S3 (variants)  
User → CDN (CloudFront) → S3  

**Scale numbers**
- Upload QPS: 10K–100K  
- Data: PB-scale  
- Latency: <100ms via CDN  

**Pitfalls**
- Not using CDN → high latency  
- No lifecycle → cost explosion  
- Storing originals only (no resized variants)

---

## 2. Video Platform (e.g., YouTube)
**Scenario:** Users upload large videos, stream globally.

**Why this fits**
- Handles very large objects (GBs)
- Multipart upload enables reliability
- Byte-range enables streaming

**Architecture sketch**
Client → Multipart Upload → S3  
S3 → Event → SQS → Lambda  
Lambda → Transcoding (HLS)  
User → CDN → Streaming  

**Scale numbers**
- Upload size: 100MB–10GB  
- QPS: 1K–10K uploads  
- Streaming latency: <200ms start  

**Pitfalls**
- Not using multipart → failed uploads  
- No async processing → slow UX  
- Incorrect chunk sizes  

---

## 3. Data Lake / Analytics (e.g., Uber logs)
**Scenario:** Store logs/events for analytics queries.

**Why this fits**
- Cheap storage for massive datasets
- Schema-on-read flexibility
- Works with query engines (Athena, Spark)

**Architecture sketch**
App → Firehose → S3 (Parquet)  
Partition by date  
Athena/Spark → Query  

**Scale numbers**
- Data: TB–PB per day  
- Query latency: seconds–minutes  
- Cost: $5/TB scanned (Athena)

**Pitfalls**
- Poor partitioning → full scans  
- Using CSV instead of Parquet  
- Too many small files  

---

## 4. Backup & Disaster Recovery (e.g., database backups)
**Scenario:** Daily DB backups stored for recovery.

**Why this fits**
- Extremely high durability
- Lifecycle for cost optimization
- Cross-region replication

**Architecture sketch**
DB → Backup → S3  
S3 → Lifecycle → Glacier  
Restore → DB  

**Scale numbers**
- Data: TBs per backup  
- Frequency: daily  
- Restore latency: minutes–hours  

**Pitfalls**
- No restore testing  
- No lifecycle → high cost  
- Storing backups in same region only  

---

## 5. Static Website Hosting (e.g., React SPA)
**Scenario:** Serve frontend without servers.

**Why this fits**
- Cheap + scalable hosting
- CDN integration
- Simple deployment

**Architecture sketch**
Build → S3  
S3 → CloudFront  
User → CDN → Site  

**Scale numbers**
- QPS: millions/day  
- Latency: ~20ms via CDN  
- Cost: very low  

**Pitfalls**
- No cache strategy  
- Broken routing (SPA issues)  
- Public bucket misconfigurations  

---

## 6. Secure File Sharing (e.g., Dropbox)
**Scenario:** Users upload/download private files.

**Why this fits**
- Presigned URLs for secure access
- Encryption support
- Fine-grained IAM control

**Architecture sketch**
Client → Server → Presigned URL  
Client → S3  
Client → Download via URL  

**Scale numbers**
- QPS: 1K–50K  
- File size: KB–GB  
- Latency: <100ms  

**Pitfalls**
- Long-lived URLs (security risk)  
- No encryption enforcement  
- Storing secrets in S3  
