# Quarkus RESTEasy - Curriculum

## Module 1: RESTEasy Reactive Basics
- [ ] RESTEasy Reactive vs RESTEasy Classic
- [ ] `@Path`, `@GET`, `@POST`, `@PUT`, `@DELETE`
- [ ] `@PathParam`, `@QueryParam`, `@HeaderParam`
- [ ] `@Consumes`, `@Produces` media types
- [ ] JSON serialization with Jackson / JSON-B

## Module 2: Request/Response Handling
- [ ] `@RestForm` for form data
- [ ] `@BeanParam` for parameter aggregation
- [ ] `RestResponse<T>` for full response control
- [ ] File upload and download
- [ ] Server-Sent Events (SSE)

## Module 3: Reactive Endpoints
- [ ] `Uni<T>` and `Multi<T>` (Mutiny reactive types)
- [ ] Blocking vs non-blocking endpoints
- [ ] `@Blocking` annotation for blocking code
- [ ] Reactive REST client
- [ ] Streaming responses with `Multi<T>`

## Module 4: Validation & Error Handling
- [ ] Bean Validation integration
- [ ] `ExceptionMapper<T>` for custom error responses
- [ ] `@ServerExceptionMapper` (simplified)
- [ ] Problem Details (RFC 7807)

## Module 5: Filters & Interceptors
- [ ] `@ServerRequestFilter` and `@ServerResponseFilter`
- [ ] `ContainerRequestFilter` / `ContainerResponseFilter`
- [ ] `@NameBinding` for selective filtering
- [ ] CORS configuration

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a REST API with all HTTP methods |
| Module 3 | Convert blocking endpoints to reactive with Mutiny |
| Modules 4-5 | Add validation, error handling, and request logging |
