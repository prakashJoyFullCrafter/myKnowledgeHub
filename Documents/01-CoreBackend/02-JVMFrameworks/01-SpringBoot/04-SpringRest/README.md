# Spring REST API - Curriculum

## Module 1: RESTful API Design
- [ ] REST principles: resources, HTTP methods, status codes
- [ ] URI design best practices (`/api/v1/users/{id}`)
- [ ] `@RestController` = `@Controller` + `@ResponseBody`
- [ ] `ResponseEntity<T>` - full control over response (status, headers, body)
- [ ] Content negotiation (JSON, XML)

## Module 2: Request/Response Handling
- [ ] `@RequestBody` with Jackson serialization/deserialization
- [ ] `@JsonProperty`, `@JsonIgnore`, `@JsonFormat`
- [ ] `@JsonNaming` strategies (snake_case, camelCase)
- [ ] Custom serializers/deserializers
- [ ] DTOs vs Entities - why to separate
- [ ] MapStruct / ModelMapper for DTO mapping

## Module 3: Validation & Error Handling
- [ ] `@Valid` on `@RequestBody`
- [ ] Custom validation annotations
- [ ] Global exception handling with `@RestControllerAdvice`
- [ ] `@ExceptionHandler` for specific exceptions
- [ ] Problem Details (RFC 7807) - standardized error responses
- [ ] Custom error response structure

## Module 4: Pagination, Sorting & Filtering
- [ ] `Pageable` parameter in controllers
- [ ] HATEOAS pagination links
- [ ] Custom `PageResponse<T>` wrapper
- [ ] Sort parameters (`?sort=name,asc`)
- [ ] Filter strategies (query params, Specification pattern)

## Module 5: API Documentation
- [ ] SpringDoc OpenAPI (Swagger UI)
- [ ] `@Operation`, `@ApiResponse`, `@Schema` annotations
- [ ] Grouping APIs with tags
- [ ] Auto-generating API clients from spec

## Module 6: Versioning & HATEOAS
- [ ] Versioning strategies: URI, header, media type
- [ ] Spring HATEOAS - `EntityModel`, `CollectionModel`, `Link`
- [ ] `WebMvcLinkBuilder` for link generation
- [ ] HAL format

## Module 7: RestClient & WebClient
- [ ] `RestClient` (Spring 6.1+) - synchronous HTTP client
- [ ] `WebClient` (reactive) - non-blocking HTTP client
- [ ] `RestTemplate` (legacy) - why to migrate
- [ ] Request/response interceptors
- [ ] Error handling and retry

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a REST API for a bookstore with DTOs |
| Module 3 | Add global error handling with RFC 7807 |
| Module 4 | Add pagination and filtering to list endpoints |
| Module 5 | Generate Swagger docs for all endpoints |
| Modules 6-7 | Add HATEOAS links + consume external API with RestClient |

## Key Resources
- Spring REST Documentation
- RESTful Web Services - Leonard Richardson
- RFC 7807 - Problem Details for HTTP APIs
