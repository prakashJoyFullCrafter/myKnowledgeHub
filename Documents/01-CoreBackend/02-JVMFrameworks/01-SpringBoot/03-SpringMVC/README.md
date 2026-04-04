# Spring MVC - Curriculum

## Module 1: MVC Architecture
- [ ] `DispatcherServlet` - front controller pattern
- [ ] Request lifecycle: DispatcherServlet -> HandlerMapping -> Controller -> ViewResolver -> View
- [ ] `@Controller` vs `@RestController`
- [ ] `Model`, `ModelAndView`, `ModelMap`

## Module 2: Request Mapping
- [ ] `@RequestMapping` (method, path, params, headers, consumes, produces)
- [ ] Shortcut annotations: `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`
- [ ] `@PathVariable`, `@RequestParam`, `@RequestHeader`, `@CookieValue`
- [ ] `@RequestBody` and `@ResponseBody`
- [ ] `@ModelAttribute` - form binding

## Module 3: View Technologies
- [ ] Thymeleaf integration and syntax
- [ ] Template fragments and layouts
- [ ] Form handling and validation display
- [ ] Static resources configuration
- [ ] Content negotiation (JSON vs HTML)

## Module 4: Form Handling & Validation
- [ ] `@Valid` / `@Validated` with Bean Validation (JSR 380)
- [ ] Validation annotations: `@NotNull`, `@Size`, `@Email`, `@Pattern`, `@Min`, `@Max`
- [ ] Custom validators (`@Constraint`)
- [ ] `BindingResult` for error handling
- [ ] Group validation

## Module 5: Interceptors & Filters
- [ ] `HandlerInterceptor` - `preHandle`, `postHandle`, `afterCompletion`
- [ ] `Filter` vs `HandlerInterceptor` - when to use which
- [ ] `WebMvcConfigurer` - customizing MVC configuration
- [ ] CORS configuration
- [ ] `@ControllerAdvice` and `@ExceptionHandler`

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a CRUD web app with Thymeleaf |
| Modules 3-4 | Add form validation and error display |
| Module 5 | Add logging interceptor and global exception handling |

## Key Resources
- Spring MVC Reference Documentation
- Thymeleaf official documentation
