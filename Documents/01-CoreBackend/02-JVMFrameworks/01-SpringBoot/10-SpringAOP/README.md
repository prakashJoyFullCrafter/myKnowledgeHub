# Spring AOP - Curriculum

## Module 1: AOP Concepts
- [ ] Cross-cutting concerns: logging, security, transactions, caching
- [ ] AOP terminology: Aspect, Advice, Pointcut, JoinPoint, Weaving
- [ ] Spring AOP vs AspectJ (proxy-based vs bytecode weaving)
- [ ] Spring AOP limitations: only method-level, only Spring beans

## Module 2: Advice Types
- [ ] `@Before` - run before method execution
- [ ] `@After` - run after method (regardless of outcome)
- [ ] `@AfterReturning` - run after successful return
- [ ] `@AfterThrowing` - run after exception
- [ ] `@Around` - wrap entire method (most powerful)
- [ ] `ProceedingJoinPoint` in `@Around` advice

## Module 3: Pointcut Expressions
- [ ] `execution()` - match method signatures
- [ ] `within()` - match all methods in class/package
- [ ] `@annotation()` - match methods with specific annotation
- [ ] `@within()` - match classes with specific annotation
- [ ] `args()` - match by argument types
- [ ] `bean()` - match by bean name
- [ ] Combining pointcuts with `&&`, `||`, `!`
- [ ] Reusable pointcuts with `@Pointcut`

## Module 4: Practical AOP
- [ ] Logging aspect: method entry/exit, execution time
- [ ] Audit aspect: track who did what and when
- [ ] Performance monitoring aspect
- [ ] Custom annotation + aspect (e.g., `@RateLimit`, `@Cacheable`)
- [ ] Exception translation aspect
- [ ] Security aspect for method-level authorization

## Module 5: AOP Internals
- [ ] JDK dynamic proxy vs CGLIB proxy
- [ ] `proxyTargetClass = true` (force CGLIB)
- [ ] Self-invocation problem (calling `this.method()` bypasses proxy)
- [ ] Ordering aspects with `@Order`
- [ ] AOP and `@Transactional` (how transactions use AOP)
- [ ] Performance impact of AOP

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a logging aspect for all service methods |
| Module 3 | Write pointcuts for different matching scenarios |
| Module 4 | Build `@ExecutionTime` and `@AuditLog` custom annotations |
| Module 5 | Debug self-invocation issue, understand proxy behavior |

## Key Resources
- Spring AOP Reference Documentation
- Spring in Action - Craig Walls (AOP chapter)
