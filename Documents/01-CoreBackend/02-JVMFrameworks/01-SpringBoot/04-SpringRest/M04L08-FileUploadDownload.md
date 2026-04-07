# File Upload & Download — Complete Study Guide

> **Module 8 | Brutally Detailed Reference**
> Covers `MultipartFile`, `@RequestPart`, size limits, local/S3/database storage, streaming large files with `StreamingResponseBody`, `Resource` return types, response headers, file validation, virus scanning, and S3 multipart uploads. Every section includes full working examples.

---

## Table of Contents

1. [`MultipartFile` — Receiving File Uploads](#1-multipartfile--receiving-file-uploads)
2. [`@RequestPart` — Multipart with JSON + File](#2-requestpart--multipart-with-json--file)
3. [File Size Limits and Configuration](#3-file-size-limits-and-configuration)
4. [Storing Files — Local Filesystem, S3, Database](#4-storing-files--local-filesystem-s3-database)
5. [`StreamingResponseBody` — Large File Downloads](#5-streamingresponsebody--large-file-downloads)
6. [`Resource` Return Types for Downloads](#6-resource-return-types-for-downloads)
7. [Response Headers — Content-Disposition, Content-Type, Content-Length](#7-response-headers--content-disposition-content-type-content-length)
8. [File Validation — Type, Size, Virus Scanning](#8-file-validation--type-size-virus-scanning)
9. [Multipart Upload to S3](#9-multipart-upload-to-s3)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. `MultipartFile` — Receiving File Uploads

### 1.1 The `MultipartFile` Interface

`MultipartFile` is Spring's representation of an uploaded file from an HTTP multipart request:

```java
public interface MultipartFile {
    String  getName();             // form field name (e.g., "file")
    String  getOriginalFilename(); // client-provided filename (UNTRUSTED — see Section 8)
    String  getContentType();      // MIME type from browser (UNTRUSTED — see Section 8)
    boolean isEmpty();             // true if no file was uploaded or file is 0 bytes
    long    getSize();             // file size in bytes
    byte[]  getBytes();            // entire file as byte[] — loads into memory!
    InputStream getInputStream();  // stream — preferred for large files
    void    transferTo(File dest); // write to file on disk
    void    transferTo(Path dest); // write to Path (Java NIO)
    Resource getResource();        // as a Spring Resource
}
```

### 1.2 Single File Upload

```java
@RestController
@RequestMapping("/api/files")
public class FileUploadController {

    @PostMapping("/upload")
    public ResponseEntity<FileUploadResponse> uploadFile(
            @RequestParam("file") MultipartFile file) {

        // 1. Validate before processing
        if (file.isEmpty()) {
            return ResponseEntity.badRequest()
                .body(new FileUploadResponse(null, "No file provided"));
        }

        // 2. Log metadata (NEVER trust these values for security)
        log.info("Received file: name={}, contentType={}, size={}",
            file.getOriginalFilename(),
            file.getContentType(),
            file.getSize());

        // 3. Process the file
        String storedFileName = fileService.store(file);

        return ResponseEntity.ok(new FileUploadResponse(storedFileName, "Upload successful"));
    }

    record FileUploadResponse(String filename, String message) {}
}
```

### 1.3 Multiple Files Upload

```java
// Multiple files with same field name
@PostMapping("/upload-multiple")
public ResponseEntity<List<String>> uploadMultiple(
        @RequestParam("files") List<MultipartFile> files) {

    if (files.isEmpty()) {
        return ResponseEntity.badRequest().build();
    }

    List<String> storedNames = files.stream()
        .filter(f -> !f.isEmpty())
        .map(fileService::store)
        .collect(Collectors.toList());

    return ResponseEntity.ok(storedNames);
}

// Multiple files with different field names
@PostMapping("/upload-avatar-and-resume")
public ResponseEntity<String> uploadUserFiles(
        @RequestParam("avatar") MultipartFile avatar,
        @RequestParam("resume") MultipartFile resume,
        @RequestParam("userId") Long userId) {

    fileService.storeAvatar(userId, avatar);
    fileService.storeResume(userId, resume);
    return ResponseEntity.ok("Files uploaded");
}
```

### 1.4 Accessing the Raw Stream (Preferred for Large Files)

```java
@PostMapping("/upload-large")
public ResponseEntity<String> uploadLarge(@RequestParam("file") MultipartFile file)
        throws IOException {

    // Use InputStream for large files — avoids loading entire file into heap
    try (InputStream inputStream = file.getInputStream()) {
        // Process stream — e.g., hash it, count lines, stream to S3
        long checksum = computeChecksum(inputStream);
        return ResponseEntity.ok("Checksum: " + checksum);
    }
    // InputStream closed automatically by try-with-resources
}

// BAD for large files — loads entire file into memory:
byte[] allBytes = file.getBytes(); // OutOfMemoryError for 500MB file!

// GOOD — use stream:
try (InputStream in = file.getInputStream()) {
    // process in chunks
}
```

---

## 2. `@RequestPart` — Multipart with JSON + File

### 2.1 Why `@RequestPart`

When you need to send **structured metadata (JSON) AND a file** in the same request, `@RequestPart` allows each part to be independently bound:

```
HTTP multipart request:
  Content-Type: multipart/form-data; boundary=----WebKitBoundary

  ------WebKitBoundary
  Content-Disposition: form-data; name="metadata"
  Content-Type: application/json

  {"title": "Project Report", "description": "Q4 2024 financials", "tags": ["finance"]}
  ------WebKitBoundary
  Content-Disposition: form-data; name="file"; filename="report.pdf"
  Content-Type: application/pdf

  [binary PDF data]
  ------WebKitBoundary--
```

### 2.2 Controller with `@RequestPart`

```java
@RestController
@RequestMapping("/api/documents")
public class DocumentController {

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<DocumentDto> uploadDocument(
            @RequestPart("metadata") DocumentMetadata metadata,  // deserialized as JSON
            @RequestPart("file") MultipartFile file) {           // the file

        // metadata is fully deserialized by Jackson
        log.info("Uploading: title={}, tags={}", metadata.title(), metadata.tags());

        // Validate the file
        fileValidator.validate(file);

        // Store and create document record
        String storedPath = fileService.store(file);
        DocumentDto doc = documentService.create(metadata, storedPath, file.getSize());

        return ResponseEntity.status(HttpStatus.CREATED).body(doc);
    }
}

// The metadata DTO — deserialized from JSON part
public record DocumentMetadata(
    @NotBlank String title,
    String description,
    @NotEmpty List<String> tags,
    @NotNull Long folderId
) {}
```

### 2.3 Bean Validation on `@RequestPart`

```java
@PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<DocumentDto> uploadDocument(
        @RequestPart("metadata") @Valid DocumentMetadata metadata,  // @Valid triggers validation
        @RequestPart("file") MultipartFile file) {
    // If metadata is invalid, MethodArgumentNotValidException is thrown
    // Spring returns 400 Bad Request automatically
}

// Exception handler for validation errors:
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<Map<String, String>> handleValidation(MethodArgumentNotValidException ex) {
    Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
        .collect(Collectors.toMap(
            FieldError::getField,
            fe -> fe.getDefaultMessage() != null ? fe.getDefaultMessage() : "invalid"
        ));
    return ResponseEntity.badRequest().body(errors);
}
```

### 2.4 Client-Side Request Construction

```java
// Java client (WebClient / RestTemplate)
MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

// Add JSON metadata as a StringHttpEntity with application/json content type
HttpHeaders metaHeaders = new HttpHeaders();
metaHeaders.setContentType(MediaType.APPLICATION_JSON);
HttpEntity<String> metaPart = new HttpEntity<>(
    objectMapper.writeValueAsString(metadata), metaHeaders);
body.add("metadata", metaPart);

// Add file part
body.add("file", new FileSystemResource(Path.of("/tmp/report.pdf")));

// Send with RestTemplate
HttpHeaders requestHeaders = new HttpHeaders();
requestHeaders.setContentType(MediaType.MULTIPART_FORM_DATA);
HttpEntity<MultiValueMap<String, Object>> requestEntity =
    new HttpEntity<>(body, requestHeaders);

ResponseEntity<DocumentDto> response = restTemplate.postForEntity(
    "/api/documents", requestEntity, DocumentDto.class);
```

---

## 3. File Size Limits and Configuration

### 3.1 Spring Boot Multipart Properties

```yaml
# application.yml
spring:
  servlet:
    multipart:
      enabled: true                          # enable multipart support (default: true)
      max-file-size: 10MB                    # per-file limit (default: 1MB)
      max-request-size: 50MB                 # total request limit (default: 10MB)
      file-size-threshold: 2KB              # files smaller than this are kept in memory
                                             # larger files are written to temp disk
      location: /tmp/uploads                 # temp directory for threshold-exceeded files
      resolve-lazily: false                 # parse multipart eagerly (default)
```

### 3.2 What Happens When Limits Are Exceeded

```java
// MaxUploadSizeExceededException is thrown by Spring
// (wraps the underlying Tomcat/Jetty exception)
@ExceptionHandler(MaxUploadSizeExceededException.class)
public ResponseEntity<Map<String, String>> handleMaxSize(MaxUploadSizeExceededException ex) {
    long maxFileSizeMB = ex.getMaxUploadSize() / (1024 * 1024);
    return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
        .body(Map.of(
            "error", "File too large",
            "message", "Maximum allowed file size is " + maxFileSizeMB + " MB",
            "maxSize", String.valueOf(maxFileSizeMB) + "MB"
        ));
}
```

### 3.3 Per-Endpoint Size Override

```java
// Override the global limit for a specific endpoint using a custom filter:
@Configuration
public class MultipartConfig {

    // High-limit endpoint for video uploads
    @Bean
    public MultipartConfigElement largeFileMultipartConfig() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize(DataSize.ofGigabytes(2));
        factory.setMaxRequestSize(DataSize.ofGigabytes(2));
        return factory.createMultipartConfig();
    }
}

// Or configure at Tomcat level for entire app:
@Bean
public TomcatServletWebServerFactory tomcatFactory() {
    return new TomcatServletWebServerFactory() {
        @Override
        protected void customizeConnector(Connector connector) {
            super.customizeConnector(connector);
            // Allow 2GB request body
            connector.setMaxPostSize(2 * 1024 * 1024 * 1024); // 2GB
        }
    };
}
```

### 3.4 `file-size-threshold` and Temp Files

```
file-size-threshold: 2KB  means:
  - Files ≤ 2KB:  kept in memory (byte[])
  - Files > 2KB:  written to temp file on disk

Implications:
  - Small files: faster (no disk I/O) but consume heap memory
  - Large files: slower (disk write) but prevents OOM
  - Temp files are in spring.servlet.multipart.location directory
  - Cleaned up by the JVM after the request, OR on shutdown
  - If JVM crashes: orphaned temp files remain — need cleanup job
```

---

## 4. Storing Files — Local Filesystem, S3, Database

### 4.1 Local Filesystem Storage

```java
@Service
public class LocalFileStorageService {

    private final Path storageRoot;

    public LocalFileStorageService(@Value("${app.storage.path:/var/data/uploads}") String path) {
        this.storageRoot = Path.of(path);
    }

    @PostConstruct
    public void init() throws IOException {
        Files.createDirectories(storageRoot);
    }

    public String store(MultipartFile file) {
        // NEVER use getOriginalFilename() as the storage name — path traversal attack risk!
        // "../../etc/passwd" is a valid filename on some OS
        String originalName = StringUtils.cleanPath(
            Objects.requireNonNull(file.getOriginalFilename()));

        // Generate a safe, unique filename
        String extension = getExtension(originalName);
        String storedName = UUID.randomUUID().toString() + "." + extension;

        // Organize by date to avoid too many files in one directory
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        Path targetDir = storageRoot.resolve(datePath);

        try {
            Files.createDirectories(targetDir);
            Path targetPath = targetDir.resolve(storedName);

            // Validate resolved path stays within storage root (path traversal prevention)
            if (!targetPath.normalize().startsWith(storageRoot.normalize())) {
                throw new SecurityException("Path traversal attempt detected: " + storedName);
            }

            file.transferTo(targetPath);
            return datePath + "/" + storedName;

        } catch (IOException e) {
            throw new FileStorageException("Failed to store file: " + e.getMessage(), e);
        }
    }

    public Resource loadAsResource(String relativePath) {
        try {
            Path filePath = storageRoot.resolve(relativePath).normalize();

            // Security check: file must be inside storage root
            if (!filePath.startsWith(storageRoot)) {
                throw new SecurityException("Access denied: " + relativePath);
            }

            Resource resource = new UrlResource(filePath.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                throw new FileNotFoundException("File not found: " + relativePath);
            }
            return resource;
        } catch (MalformedURLException e) {
            throw new FileStorageException("Invalid file path: " + relativePath, e);
        }
    }

    public void delete(String relativePath) throws IOException {
        Path filePath = storageRoot.resolve(relativePath).normalize();
        if (!filePath.startsWith(storageRoot)) {
            throw new SecurityException("Access denied: " + relativePath);
        }
        Files.deleteIfExists(filePath);
    }

    private String getExtension(String filename) {
        int dotIndex = filename.lastIndexOf('.');
        return (dotIndex >= 0) ? filename.substring(dotIndex + 1).toLowerCase() : "bin";
    }
}
```

### 4.2 Amazon S3 Storage with Spring Cloud AWS

```java
@Service
public class S3FileStorageService {

    private final S3Client s3Client;
    private final String bucketName;

    public S3FileStorageService(S3Client s3Client,
                                 @Value("${app.s3.bucket}") String bucketName) {
        this.s3Client = s3Client;
        this.bucketName = bucketName;
    }

    public String store(MultipartFile file) {
        String key = "uploads/" +
            LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd")) +
            "/" + UUID.randomUUID() + "." + getExtension(file);

        try {
            PutObjectRequest request = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType(detectMimeType(file))    // use detected type, not browser-provided
                .contentLength(file.getSize())
                .metadata(Map.of(
                    "original-filename", file.getOriginalFilename(),
                    "uploaded-by",       SecurityContextHolder.getContext()
                                            .getAuthentication().getName()
                ))
                .build();

            s3Client.putObject(request,
                RequestBody.fromInputStream(file.getInputStream(), file.getSize()));

            return key;

        } catch (IOException e) {
            throw new FileStorageException("Failed to upload to S3: " + e.getMessage(), e);
        }
    }

    // Generate a pre-signed URL for direct download (bypasses your server)
    public URL generatePresignedUrl(String key, Duration expiresIn) {
        S3Presigner presigner = S3Presigner.create();
        GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
            .signatureDuration(expiresIn)
            .getObjectRequest(r -> r.bucket(bucketName).key(key))
            .build();

        return presigner.presignGetObject(presignRequest)
            .url();
    }

    // Stream file from S3 directly to response (no temp file)
    public InputStream getInputStream(String key) {
        GetObjectRequest request = GetObjectRequest.builder()
            .bucket(bucketName)
            .key(key)
            .build();
        return s3Client.getObject(request);  // ResponseInputStream<GetObjectResponse>
    }

    // Delete from S3
    public void delete(String key) {
        s3Client.deleteObject(DeleteObjectRequest.builder()
            .bucket(bucketName)
            .key(key)
            .build());
    }

    private String getExtension(MultipartFile file) {
        String original = file.getOriginalFilename();
        if (original == null || !original.contains(".")) return "bin";
        return original.substring(original.lastIndexOf('.') + 1).toLowerCase();
    }
}
```

### 4.3 Database BLOB Storage

```java
// Entity for storing file metadata + content
@Entity
@Table(name = "stored_files")
public class StoredFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "original_name", nullable = false)
    private String originalName;

    @Column(name = "content_type", nullable = false)
    private String contentType;

    @Column(name = "file_size", nullable = false)
    private long fileSize;

    @Lob
    @Column(name = "content", nullable = false)
    @Basic(fetch = FetchType.LAZY)  // CRITICAL: don't load BLOB when listing files
    private byte[] content;

    @Column(name = "uploaded_at", nullable = false)
    private Instant uploadedAt = Instant.now();
}

// Repository
public interface StoredFileRepository extends JpaRepository<StoredFile, Long> {
    // Projection for listing (no content loaded):
    @Query("SELECT new com.myapp.dto.FileMetadata(f.id, f.originalName, f.contentType, f.fileSize, f.uploadedAt) FROM StoredFile f")
    List<FileMetadata> findAllMetadata();
}

// Service
@Service
@Transactional
public class DatabaseFileStorageService {

    private final StoredFileRepository repository;

    public Long store(MultipartFile file) throws IOException {
        StoredFile stored = new StoredFile();
        stored.setOriginalName(file.getOriginalFilename());
        stored.setContentType(detectMimeType(file));
        stored.setFileSize(file.getSize());
        stored.setContent(file.getBytes()); // loads into memory — OK for small files
        return repository.save(stored).getId();
    }

    @Transactional(readOnly = true)
    public StoredFile load(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new FileNotFoundException("File not found: " + id));
    }
}
```

**When to use BLOB storage:**
```
✅ Good for:
  - Files that must be transactional with other data
  - Audit-critical files (contracts, signed documents)
  - Files < 1MB (small images, thumbnails, signatures)

❌ Bad for:
  - Large files (video, large PDFs) — bloats DB backup
  - High-volume files — strains DB connections
  - Files needing CDN delivery
```

---

## 5. `StreamingResponseBody` — Large File Downloads

### 5.1 Why `StreamingResponseBody`

Without streaming, Spring loads the entire file into memory before sending:

```
Without streaming:
  File (5GB) → byte[] in heap → HTTP response
  Problem: 5GB heap usage, likely OutOfMemoryError

With StreamingResponseBody:
  File (5GB) → 8KB buffer → written to HTTP response → next 8KB → ...
  Memory usage: ~8KB regardless of file size
```

### 5.2 Basic `StreamingResponseBody`

```java
@GetMapping("/download/{fileId}")
public ResponseEntity<StreamingResponseBody> downloadFile(@PathVariable Long fileId) {

    FileRecord record = fileService.getMetadata(fileId); // metadata only, no content

    StreamingResponseBody body = outputStream -> {
        // This lambda runs in a separate thread
        // Write file content in chunks to the outputStream
        try (InputStream inputStream = fileService.openStream(fileId)) {
            byte[] buffer = new byte[8192]; // 8KB buffer
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
                outputStream.flush(); // flush periodically for responsive downloads
            }
        }
    };

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment()
                .filename(record.getOriginalName(), StandardCharsets.UTF_8)
                .build().toString())
        .header(HttpHeaders.CONTENT_TYPE, record.getContentType())
        .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(record.getFileSize()))
        .body(body);
}
```

### 5.3 Streaming from S3

```java
@GetMapping("/download/s3/{key}")
public ResponseEntity<StreamingResponseBody> downloadFromS3(
        @PathVariable String key) {

    // Get metadata from S3 (HEAD request — no file content)
    HeadObjectResponse meta = s3Client.headObject(
        HeadObjectRequest.builder().bucket(bucketName).key(key).build());

    StreamingResponseBody body = outputStream -> {
        // Stream directly from S3 to HTTP response — never loads entire file
        try (ResponseInputStream<GetObjectResponse> s3Stream =
                s3Client.getObject(GetObjectRequest.builder()
                    .bucket(bucketName).key(key).build())) {

            s3Stream.transferTo(outputStream); // Java 9+ transferTo is optimized
        }
    };

    String filename = key.substring(key.lastIndexOf('/') + 1);

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION,
            "attachment; filename=\"" + filename + "\"")
        .header(HttpHeaders.CONTENT_TYPE,
            meta.contentType() != null ? meta.contentType() : "application/octet-stream")
        .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(meta.contentLength()))
        .body(body);
}
```

### 5.4 Streaming with Range Support (Resume Downloads)

```java
@GetMapping("/download/{fileId}")
public ResponseEntity<StreamingResponseBody> downloadWithRange(
        @PathVariable Long fileId,
        @RequestHeader(value = HttpHeaders.RANGE, required = false) String rangeHeader) {

    FileRecord record = fileService.getMetadata(fileId);
    long fileSize = record.getFileSize();

    // Parse Range header: "bytes=0-1023" or "bytes=1024-"
    long start = 0;
    long end = fileSize - 1;
    HttpStatus status = HttpStatus.OK;

    if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
        String[] ranges = rangeHeader.substring(6).split("-");
        start = Long.parseLong(ranges[0]);
        end = (ranges.length > 1 && !ranges[1].isEmpty())
            ? Long.parseLong(ranges[1])
            : fileSize - 1;
        status = HttpStatus.PARTIAL_CONTENT;
    }

    final long finalStart = start;
    final long finalEnd = end;
    long contentLength = finalEnd - finalStart + 1;

    StreamingResponseBody body = outputStream -> {
        try (InputStream in = fileService.openStream(fileId)) {
            in.skip(finalStart);
            byte[] buffer = new byte[8192];
            long remaining = finalEnd - finalStart + 1;
            int bytesRead;
            while (remaining > 0 &&
                   (bytesRead = in.read(buffer, 0, (int) Math.min(buffer.length, remaining))) != -1) {
                outputStream.write(buffer, 0, bytesRead);
                remaining -= bytesRead;
            }
        }
    };

    ResponseEntity.BodyBuilder builder = ResponseEntity.status(status)
        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + record.getOriginalName() + "\"")
        .header(HttpHeaders.CONTENT_TYPE, record.getContentType())
        .header(HttpHeaders.CONTENT_LENGTH, String.valueOf(contentLength))
        .header(HttpHeaders.ACCEPT_RANGES, "bytes");

    if (status == HttpStatus.PARTIAL_CONTENT) {
        builder.header(HttpHeaders.CONTENT_RANGE,
            "bytes " + start + "-" + end + "/" + fileSize);
    }

    return builder.body(body);
}
```

### 5.5 Async Configuration for `StreamingResponseBody`

`StreamingResponseBody` runs on a separate thread. Ensure your async configuration can handle concurrent downloads:

```java
@Configuration
@EnableAsync
public class AsyncConfig implements AsyncConfigurer {

    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(4);
        executor.setMaxPoolSize(20);           // max concurrent streams
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("stream-");
        executor.initialize();
        return executor;
    }
}

// In application.yml: set the MVC async request timeout
# spring.mvc.async.request-timeout=300000  # 5 minutes (for large file downloads)
```

---

## 6. `Resource` Return Types for Downloads

### 6.1 `InputStreamResource` vs `ByteArrayResource`

```java
// InputStreamResource: wraps an InputStream — streaming, doesn't load into memory
// Use for: files from disk, S3, database
InputStreamResource resource = new InputStreamResource(new FileInputStream("/path/file.pdf"));
// Caveat: content-length requires knowing the size beforehand
// InputStreamResource.contentLength() throws — you must set header manually

// ByteArrayResource: wraps a byte[] — entire file in memory
// Use for: small files, thumbnails, dynamically generated content
ByteArrayResource resource = new ByteArrayResource(generatedPdfBytes);
// content-length is available: resource.contentLength()

// UrlResource: wraps a URL — for files served from known URLs/classpath
UrlResource resource = new UrlResource("file:///var/data/uploads/report.pdf");
UrlResource classpath = new UrlResource("classpath:static/template.docx");
// resource.exists(), resource.getFilename(), resource.contentLength() all work

// FileSystemResource: wraps a File/Path — for local disk files
FileSystemResource resource = new FileSystemResource(Path.of("/var/data/uploads/file.pdf"));
// content-length available, readable
```

### 6.2 Download with `InputStreamResource`

```java
@GetMapping("/files/{filename}")
public ResponseEntity<InputStreamResource> downloadFile(
        @PathVariable String filename) throws IOException {

    Resource storedFile = fileStorageService.loadAsResource(filename);

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment()
                .filename(storedFile.getFilename(), StandardCharsets.UTF_8)
                .build()
                .toString())
        .contentType(MediaType.APPLICATION_OCTET_STREAM)
        .contentLength(storedFile.contentLength())
        .body(new InputStreamResource(storedFile.getInputStream()));
}
```

### 6.3 Download with `ByteArrayResource` (Generated Files)

```java
@GetMapping("/reports/{reportId}/export")
public ResponseEntity<ByteArrayResource> exportReport(
        @PathVariable Long reportId,
        @RequestParam(defaultValue = "pdf") String format) {

    byte[] reportBytes = switch (format.toLowerCase()) {
        case "pdf"  -> reportService.generatePdf(reportId);
        case "xlsx" -> reportService.generateExcel(reportId);
        case "csv"  -> reportService.generateCsv(reportId);
        default     -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Unsupported format: " + format);
    };

    String contentType = switch (format.toLowerCase()) {
        case "pdf"  -> "application/pdf";
        case "xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        case "csv"  -> "text/csv";
        default     -> "application/octet-stream";
    };

    String filename = "report-" + reportId + "." + format;

    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION,
            ContentDisposition.attachment()
                .filename(filename, StandardCharsets.UTF_8)
                .build().toString())
        .contentType(MediaType.parseMediaType(contentType))
        .contentLength(reportBytes.length)
        .body(new ByteArrayResource(reportBytes));
}
```

---

## 7. Response Headers — Content-Disposition, Content-Type, Content-Length

### 7.1 `Content-Disposition`

Controls whether the browser downloads or displays the file:

```java
// ATTACHMENT: browser downloads the file (download dialog)
"Content-Disposition: attachment; filename=\"report.pdf\""

// INLINE: browser tries to display the file (PDF viewer, image, etc.)
"Content-Disposition: inline; filename=\"image.jpg\""

// With special characters or non-ASCII filename — use RFC 5987 encoding:
// Content-Disposition: attachment; filename*=UTF-8''Resum%C3%A9%202024.pdf
ContentDisposition.attachment()
    .filename("Résumé 2024.pdf", StandardCharsets.UTF_8)
    .build()
    .toString();
// → attachment; filename="=?UTF-8?Q?R=C3=A9sum=C3=A9_2024.pdf?="; filename*=UTF-8''R%C3%A9sum%C3%A9%202024.pdf

// Spring's ContentDisposition builder handles encoding correctly:
String disposition = ContentDisposition
    .attachment()
    .filename("filename with spaces & special chars.pdf", StandardCharsets.UTF_8)
    .build()
    .toString();
```

### 7.2 `Content-Type`

```java
// Always set an explicit Content-Type — never trust browser-provided MIME type
// Detect from actual file content (magic bytes), not the filename extension:

@Component
public class MimeTypeDetector {

    public String detect(MultipartFile file) throws IOException {
        // Use Apache Tika for reliable detection from file content
        Tika tika = new Tika();
        return tika.detect(file.getInputStream());
    }

    public String detect(byte[] bytes) {
        Tika tika = new Tika();
        return tika.detect(bytes);
    }
}

// Common content types:
"application/pdf"                           // PDF
"application/json"                          // JSON
"text/plain; charset=UTF-8"                 // Plain text
"text/csv"                                  // CSV
"image/jpeg"                                // JPEG image
"image/png"                                 // PNG image
"image/gif"                                 // GIF (may animate)
"application/zip"                           // ZIP archive
"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"  // XLSX
"application/vnd.openxmlformats-officedocument.wordprocessingml.document" // DOCX
"application/octet-stream"                  // unknown/binary — use as fallback
```

### 7.3 `Content-Length`

```java
// Set Content-Length for known-size files — enables progress bars and resume
response.setHeader(HttpHeaders.CONTENT_LENGTH, String.valueOf(fileSizeInBytes));

// When Content-Length is NOT known (dynamically compressed, dynamically generated):
// Omit it — browser will use chunked transfer encoding instead

// ResponseEntity builder:
ResponseEntity.ok()
    .contentLength(file.getSize())     // sets Content-Length
    .contentType(MediaType.APPLICATION_PDF)
    .body(resource);
```

### 7.4 Cache Control Headers

```java
// Prevent caching of sensitive files:
.header(HttpHeaders.CACHE_CONTROL, "no-store, no-cache, must-revalidate")
.header(HttpHeaders.PRAGMA, "no-cache")
.header(HttpHeaders.EXPIRES, "0")

// Allow caching of public files:
.header(HttpHeaders.CACHE_CONTROL, "public, max-age=86400")  // 1 day
.header(HttpHeaders.ETAG, computeETag(file))  // for conditional requests

// Spring's CacheControl helper:
.cacheControl(CacheControl.noStore())
.cacheControl(CacheControl.maxAge(Duration.ofDays(1)).cachePublic())
```

### 7.5 Security Headers for File Downloads

```java
// Prevent MIME sniffing (browser treating .txt as executable):
.header("X-Content-Type-Options", "nosniff")

// For inline content: prevent cross-frame attacks:
.header("X-Frame-Options", "SAMEORIGIN")

// Content Security Policy for inline files:
.header("Content-Security-Policy", "default-src 'none'")
```

---

## 8. File Validation — Type, Size, Virus Scanning

### 8.1 Why Browser-Provided Values Are Untrusted

```
Attack scenario:
  Attacker renames malware.exe to innocentphoto.jpg
  Uploads it with Content-Type: image/jpeg

  Server trusts content-type header → saves .jpg file
  Server trusts filename extension → .jpg appears safe
  
  Actual file content: Windows PE executable
  If server executes this "image": RCE vulnerability

Defense: detect MIME type from file CONTENT (magic bytes), not headers/extension
```

### 8.2 Complete File Validator

```java
@Component
public class FileValidator {

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

    // Allowed MIME types by use case
    private static final Set<String> ALLOWED_IMAGE_TYPES = Set.of(
        "image/jpeg", "image/png", "image/gif", "image/webp", "image/svg+xml"
    );
    private static final Set<String> ALLOWED_DOCUMENT_TYPES = Set.of(
        "application/pdf",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document", // docx
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",       // xlsx
        "text/plain",
        "text/csv"
    );

    private final Tika tika = new Tika();

    public void validateImage(MultipartFile file) {
        validate(file, ALLOWED_IMAGE_TYPES, MAX_FILE_SIZE);
    }

    public void validateDocument(MultipartFile file) {
        validate(file, ALLOWED_DOCUMENT_TYPES, 50 * 1024 * 1024L); // 50MB for docs
    }

    private void validate(MultipartFile file, Set<String> allowedTypes, long maxSize) {
        // 1. Empty check
        if (file == null || file.isEmpty()) {
            throw new FileValidationException("File is empty or not provided");
        }

        // 2. Size check (application-level, before spring's limit catches it)
        if (file.getSize() > maxSize) {
            throw new FileValidationException(
                "File too large: " + file.getSize() + " bytes (max: " + maxSize + ")");
        }

        // 3. MIME type detection from CONTENT (not headers/extension)
        String detectedType;
        try {
            detectedType = tika.detect(file.getInputStream());
        } catch (IOException e) {
            throw new FileValidationException("Cannot read file for type detection");
        }

        // 4. Check detected type against allowlist
        if (!allowedTypes.contains(detectedType)) {
            throw new FileValidationException(
                "File type not allowed: " + detectedType +
                ". Allowed types: " + allowedTypes);
        }

        // 5. Filename validation (sanitize for storage)
        String originalName = file.getOriginalFilename();
        if (originalName != null && containsPathTraversal(originalName)) {
            throw new FileValidationException("Invalid filename: " + originalName);
        }

        // 6. For ZIP files: check for zip bombs
        if ("application/zip".equals(detectedType)) {
            validateZipNotBomb(file);
        }
    }

    private boolean containsPathTraversal(String filename) {
        return filename.contains("..") ||
               filename.contains("/") ||
               filename.contains("\\") ||
               filename.startsWith(".");
    }

    private void validateZipNotBomb(MultipartFile file) {
        try (ZipInputStream zip = new ZipInputStream(file.getInputStream())) {
            ZipEntry entry;
            long totalUncompressedSize = 0;
            int entryCount = 0;
            while ((entry = zip.getNextEntry()) != null) {
                entryCount++;
                totalUncompressedSize += entry.getSize();
                if (entryCount > 1000) {
                    throw new FileValidationException("ZIP file contains too many entries");
                }
                if (totalUncompressedSize > 1024 * 1024 * 1024L) { // 1GB
                    throw new FileValidationException("ZIP file uncompressed size too large");
                }
            }
        } catch (IOException e) {
            throw new FileValidationException("Cannot validate ZIP file");
        }
    }
}
```

### 8.3 Virus Scanning with ClamAV

```java
// Maven dependency
// <dependency>
//     <groupId>fi.solita.clamav</groupId>
//     <artifactId>clamav-client</artifactId>
//     <version>1.0.1</version>
// </dependency>

@Service
@ConditionalOnProperty("app.virus-scan.enabled")
public class VirusScanService {

    private final String clamavHost;
    private final int clamavPort;

    public VirusScanService(
            @Value("${app.virus-scan.host:localhost}") String host,
            @Value("${app.virus-scan.port:3310}") int port) {
        this.clamavHost = host;
        this.clamavPort = port;
    }

    public void scan(MultipartFile file) throws IOException {
        ClamAVClient client = new ClamAVClient(clamavHost, clamavPort);

        byte[] scanResult = client.scan(file.getInputStream());
        String result = new String(scanResult, StandardCharsets.UTF_8).trim();

        if (!ClamAVClient.isCleanReply(scanResult)) {
            log.warn("Virus detected in uploaded file: {}", result);
            throw new VirusDetectedException(
                "File rejected: potential virus detected (" + result + ")");
        }
        log.debug("File scan clean: {}", file.getOriginalFilename());
    }

    // Async scanning — accept upload first, scan asynchronously, quarantine if infected
    @Async
    public CompletableFuture<ScanResult> scanAsync(String storedFilePath) {
        try {
            // scan the stored file
            byte[] fileBytes = Files.readAllBytes(Path.of(storedFilePath));
            byte[] result = new ClamAVClient(clamavHost, clamavPort).scan(
                new ByteArrayInputStream(fileBytes));
            boolean clean = ClamAVClient.isCleanReply(result);
            return CompletableFuture.completedFuture(
                new ScanResult(storedFilePath, clean, new String(result)));
        } catch (Exception e) {
            return CompletableFuture.failedFuture(e);
        }
    }
}
```

### 8.4 Image-Specific Validation (Re-encoding)

```java
// Re-encode images to strip potentially malicious metadata/polyglot content
@Service
public class ImageSanitizationService {

    public byte[] sanitize(MultipartFile file, String targetType) throws IOException {
        // Read image (validates it's actually an image)
        BufferedImage image = ImageIO.read(file.getInputStream());
        if (image == null) {
            throw new FileValidationException("File is not a valid image");
        }

        // Re-encode as the target type — strips EXIF data, removes embedded scripts
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        String formatName = targetType.equals("image/png") ? "png" : "jpg";
        ImageIO.write(image, formatName, output);

        return output.toByteArray();
        // Re-encoded image: safe to store and serve
        // Original file: discarded — any malicious content is gone
    }
}
```

---

## 9. Multipart Upload to S3

### 9.1 When to Use S3 Multipart Upload

```
Standard upload (PutObject):
  All-in-one: load entire file into memory, send in single request
  Good for: files < 100MB
  Limitation: if network fails halfway: restart from beginning

S3 Multipart Upload (CreateMultipartUpload → UploadPart × N → CompleteMultipartUpload):
  File split into parts (5MB minimum per part, except last)
  Each part uploaded independently
  If a part fails: retry just that part
  Good for: files > 100MB, or when network reliability is a concern
  Benefit: parallel part uploads (higher throughput)
```

### 9.2 Manual S3 Multipart Upload with AWS SDK v2

```java
@Service
public class S3MultipartUploadService {

    private final S3Client s3Client;
    private final String bucket;

    private static final int PART_SIZE_BYTES = 10 * 1024 * 1024; // 10MB per part

    public String multipartUpload(MultipartFile file, String key) throws IOException {
        // 1. Initiate multipart upload
        CreateMultipartUploadResponse initResponse = s3Client.createMultipartUpload(
            CreateMultipartUploadRequest.builder()
                .bucket(bucket)
                .key(key)
                .contentType(detectMimeType(file))
                .build());
        String uploadId = initResponse.uploadId();

        List<CompletedPart> completedParts = new ArrayList<>();

        try (InputStream inputStream = file.getInputStream()) {
            byte[] buffer = new byte[PART_SIZE_BYTES];
            int bytesRead;
            int partNumber = 1;

            while ((bytesRead = inputStream.readNBytes(buffer, 0, PART_SIZE_BYTES)) > 0) {
                // 2. Upload each part
                UploadPartResponse partResponse = s3Client.uploadPart(
                    UploadPartRequest.builder()
                        .bucket(bucket)
                        .key(key)
                        .uploadId(uploadId)
                        .partNumber(partNumber)
                        .contentLength((long) bytesRead)
                        .build(),
                    RequestBody.fromBytes(Arrays.copyOf(buffer, bytesRead))
                );

                completedParts.add(CompletedPart.builder()
                    .partNumber(partNumber)
                    .eTag(partResponse.eTag())
                    .build());

                log.debug("Uploaded part {} ({} bytes)", partNumber, bytesRead);
                partNumber++;
            }

            // 3. Complete the multipart upload
            s3Client.completeMultipartUpload(
                CompleteMultipartUploadRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .uploadId(uploadId)
                    .multipartUpload(CompletedMultipartUpload.builder()
                        .parts(completedParts)
                        .build())
                    .build());

            log.info("Multipart upload complete: {} ({} parts)", key, completedParts.size());
            return key;

        } catch (Exception e) {
            // IMPORTANT: abort the incomplete upload to avoid storage charges
            s3Client.abortMultipartUpload(
                AbortMultipartUploadRequest.builder()
                    .bucket(bucket)
                    .key(key)
                    .uploadId(uploadId)
                    .build());
            throw new FileStorageException("Multipart upload failed: " + e.getMessage(), e);
        }
    }
}
```

### 9.3 Parallel S3 Multipart Upload (Higher Throughput)

```java
@Service
public class ParallelS3UploadService {

    private final S3Client s3Client;
    private final ExecutorService uploadExecutor =
        Executors.newFixedThreadPool(4); // 4 parallel part uploads

    public String parallelMultipartUpload(Path localFilePath, String key) throws Exception {
        long fileSize = Files.size(localFilePath);
        int partSize = 10 * 1024 * 1024; // 10MB
        int totalParts = (int) Math.ceil((double) fileSize / partSize);

        // Initiate upload
        String uploadId = s3Client.createMultipartUpload(
            CreateMultipartUploadRequest.builder()
                .bucket(bucket).key(key).build())
            .uploadId();

        // Upload all parts in parallel
        List<Future<CompletedPart>> futures = new ArrayList<>();
        for (int i = 0; i < totalParts; i++) {
            final int partNumber = i + 1;
            final long offset = (long) i * partSize;
            final long length = Math.min(partSize, fileSize - offset);

            futures.add(uploadExecutor.submit(() -> {
                UploadPartResponse response = s3Client.uploadPart(
                    UploadPartRequest.builder()
                        .bucket(bucket).key(key)
                        .uploadId(uploadId)
                        .partNumber(partNumber)
                        .contentLength(length)
                        .build(),
                    RequestBody.fromFile(localFilePath)  // S3 SDK handles offset/length
                );
                return CompletedPart.builder()
                    .partNumber(partNumber).eTag(response.eTag()).build();
            }));
        }

        // Collect results (sorted by part number)
        List<CompletedPart> parts = new ArrayList<>();
        for (Future<CompletedPart> f : futures) {
            parts.add(f.get(5, TimeUnit.MINUTES));
        }
        parts.sort(Comparator.comparingInt(CompletedPart::partNumber));

        // Complete upload
        s3Client.completeMultipartUpload(
            CompleteMultipartUploadRequest.builder()
                .bucket(bucket).key(key).uploadId(uploadId)
                .multipartUpload(m -> m.parts(parts))
                .build());

        return key;
    }
}
```

### 9.4 S3 Transfer Manager (Recommended for Production)

AWS SDK v2's `S3TransferManager` handles multipart automatically:

```java
@Service
public class S3TransferService {

    private final S3TransferManager transferManager;

    public S3TransferService(S3AsyncClient s3AsyncClient) {
        this.transferManager = S3TransferManager.builder()
            .s3Client(s3AsyncClient)
            .build();
    }

    public String upload(MultipartFile file, String key) throws Exception {
        // TransferManager automatically chooses:
        // - PutObject for small files (< 8MB by default)
        // - Multipart upload for large files
        UploadFileRequest request = UploadFileRequest.builder()
            .putObjectRequest(r -> r
                .bucket(bucket)
                .key(key)
                .contentType(detectMimeType(file)))
            .source(writeToTempFile(file)) // must be a Path, not InputStream
            .build();

        Upload upload = transferManager.uploadFile(request);

        // Wait for completion with progress tracking
        upload.completionFuture()
            .whenComplete((result, ex) -> {
                if (ex != null) log.error("Upload failed: {}", ex.getMessage());
                else log.info("Upload complete: {}", result.response().eTag());
            })
            .get(10, TimeUnit.MINUTES); // block with timeout

        return key;
    }

    public void download(String key, Path destination) throws Exception {
        DownloadFileRequest request = DownloadFileRequest.builder()
            .getObjectRequest(r -> r.bucket(bucket).key(key))
            .destination(destination)
            .build();

        FileDownload download = transferManager.downloadFile(request);
        download.completionFuture().get(10, TimeUnit.MINUTES);
    }
}
```

---

## 10. Quick Reference Cheat Sheet

### Upload Endpoints

```java
// Single file
@PostMapping("/upload")
public ResponseEntity<String> upload(@RequestParam("file") MultipartFile file) {}

// Multiple files
@PostMapping("/upload-multiple")
public ResponseEntity<List<String>> uploadMultiple(
    @RequestParam("files") List<MultipartFile> files) {}

// File + JSON metadata
@PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
public ResponseEntity<Dto> uploadWithMeta(
    @RequestPart("metadata") @Valid MetadataDto meta,
    @RequestPart("file") MultipartFile file) {}
```

### Download Patterns

```java
// StreamingResponseBody (large files — no memory pressure)
StreamingResponseBody body = out -> {
    try (InputStream in = getInputStream()) { in.transferTo(out); }
};
return ResponseEntity.ok().headers(headers).body(body);

// InputStreamResource (small-medium files)
return ResponseEntity.ok()
    .contentLength(size).contentType(mediaType)
    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"file.pdf\"")
    .body(new InputStreamResource(inputStream));

// ByteArrayResource (generated content)
return ResponseEntity.ok()
    .contentLength(bytes.length)
    .body(new ByteArrayResource(bytes));
```

### Response Headers

```java
// Download dialog
HttpHeaders.CONTENT_DISPOSITION → "attachment; filename=\"file.pdf\""

// Browser display
HttpHeaders.CONTENT_DISPOSITION → "inline; filename=\"image.jpg\""

// Non-ASCII filename (RFC 5987)
ContentDisposition.attachment().filename("Ré.pdf", StandardCharsets.UTF_8).build().toString()

// Prevent MIME sniffing
"X-Content-Type-Options" → "nosniff"
```

### Configuration

```yaml
spring.servlet.multipart:
  max-file-size: 10MB          # per file
  max-request-size: 50MB       # total request
  file-size-threshold: 2KB     # memory vs temp file threshold
```

### File Validation Order

```
1. isEmpty()              → 400 Bad Request
2. getSize() > maxSize    → 413 Payload Too Large
3. Tika.detect(stream)    → detect ACTUAL MIME type from bytes
4. detectedType in allowList → 415 Unsupported Media Type
5. filename path traversal → 400 Bad Request
6. virus scan (async)     → quarantine if infected
```

### Key Rules to Remember

1. **Never trust `getOriginalFilename()` or `getContentType()`** — both are user-controlled; use Tika to detect from content.
2. **Generate UUID-based storage filenames** — never use original filename as the storage key.
3. **Validate path stays within storage root** — check `path.normalize().startsWith(storageRoot)`.
4. **`StreamingResponseBody` for files > a few MB** — avoids OOM, enables progress bars.
5. **`InputStreamResource.contentLength()` throws** — set `Content-Length` header manually.
6. **Set `X-Content-Type-Options: nosniff`** — prevents browsers from MIME-sniffing served files.
7. **`Content-Disposition: attachment`** prevents inline execution of uploaded files.
8. **Abort S3 multipart uploads on failure** — orphaned multipart uploads cost money.
9. **`S3TransferManager` auto-selects multipart vs single upload** — prefer it over manual multipart.
10. **`@RequestPart` metadata part needs `Content-Type: application/json`** — or Jackson won't deserialize it.

---

*End of File Upload & Download Study Guide — Module 8*
