# Spring Core & Dependency Injection - Curriculum

## Module 1: Spring IoC Container
- [ ] What is Inversion of Control (IoC)?
- [ ] `ApplicationContext` vs `BeanFactory`
- [ ] Bean lifecycle: instantiation -> populate -> init -> use -> destroy
- [ ] `@PostConstruct` and `@PreDestroy`
- [ ] Bean scopes: `singleton`, `prototype`, `request`, `session`
- [ ] Lazy initialization (`@Lazy`)

## Module 2: Dependency Injection
- [ ] Constructor injection (recommended)
- [ ] Setter injection
- [ ] Field injection (`@Autowired` on fields - why to avoid)
- [ ] `@Autowired` and `@Inject` - differences
- [ ] `@Qualifier` - resolving multiple beans of same type
- [ ] `@Primary` - default bean selection

## Module 3: Configuration
- [ ] `@Configuration` and `@Bean` - Java-based config
- [ ] `@Component`, `@Service`, `@Repository`, `@Controller` stereotypes
- [ ] `@ComponentScan` - package scanning
- [ ] `@Value` - injecting properties
- [ ] `@ConfigurationProperties` - type-safe config binding
- [ ] `@PropertySource` and `application.yml` / `application.properties`
- [ ] Profiles (`@Profile`, `spring.profiles.active`)

## Module 4: Advanced DI
- [ ] `@Conditional` annotations (`@ConditionalOnProperty`, `@ConditionalOnClass`)
- [ ] `ObjectProvider<T>` - lazy/optional dependency resolution
- [ ] Circular dependencies - detection and resolution
- [ ] `FactoryBean` - custom bean creation logic
- [ ] `BeanPostProcessor` and `BeanFactoryPostProcessor`
- [ ] Event system: `ApplicationEvent`, `@EventListener`, `@Async` events

## Module 5: Spring Boot Auto-Configuration
- [ ] How `@SpringBootApplication` works
- [ ] `@EnableAutoConfiguration` and `spring.factories` / `AutoConfiguration.imports`
- [ ] Overriding auto-configuration
- [ ] Creating custom auto-configuration (starters)
- [ ] Understanding the debug output (`--debug`)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a service layer with constructor injection |
| Module 3 | Multi-profile app (dev/staging/prod) with different configs |
| Module 4 | Custom `@Conditional` bean + application events |
| Module 5 | Create a custom Spring Boot starter library |

## Key Resources
- Spring Framework Reference - Core Technologies
- Spring Boot Reference Documentation
- Spring in Action - Craig Walls
