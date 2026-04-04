# Object-Oriented Programming (OOP) - Curriculum

## Module 1: Classes & Objects
- [ ] Class definition, fields, methods, constructors
- [ ] `this` keyword
- [ ] Constructor overloading & constructor chaining (`this()`)
- [ ] Object creation and memory allocation (`new` keyword)
- [ ] `toString()`, `equals()`, `hashCode()` contract
- [ ] Object cloning (`Cloneable`, shallow vs deep copy)
- [ ] Immutable objects - how and why

## Module 2: Encapsulation
- [ ] Access modifiers: `private`, `default`, `protected`, `public`
- [ ] Getters and setters
- [ ] Data hiding vs abstraction
- [ ] Builder pattern for complex object creation
- [ ] Why public fields are dangerous
- [ ] JavaBeans convention

## Module 3: Inheritance
- [ ] `extends` keyword
- [ ] `super` keyword and `super()` constructor call
- [ ] Method overriding rules (`@Override`)
- [ ] Constructor chain in inheritance
- [ ] `Object` class - the root of all classes
- [ ] Why Java doesn't support multiple class inheritance
- [ ] Fragile base class problem
- [ ] Composition vs inheritance - when to prefer composition

## Module 4: Polymorphism
- [ ] Compile-time polymorphism (method overloading)
- [ ] Runtime polymorphism (method overriding + dynamic dispatch)
- [ ] Upcasting and downcasting
- [ ] `instanceof` operator and pattern matching (Java 16+)
- [ ] Covariant return types
- [ ] Why polymorphism matters in real-world design

## Module 5: Abstraction
- [ ] Abstract classes and abstract methods
- [ ] When to use abstract classes
- [ ] Interfaces: methods, default methods (Java 8+), static methods, private methods (Java 9+)
- [ ] Multiple interface implementation
- [ ] Interface vs abstract class - decision guide
- [ ] Functional interfaces and `@FunctionalInterface`
- [ ] Marker interfaces (`Serializable`, `Cloneable`)
- [ ] Sealed interfaces (Java 17+)

## Module 6: Inner Classes
- [ ] Member inner class
- [ ] Static nested class
- [ ] Local inner class (inside a method)
- [ ] Anonymous inner class
- [ ] When to use each type
- [ ] Lambda expressions as replacement for anonymous classes

## Module 7: SOLID Principles (OOP Applied)
- [ ] **S** - Single Responsibility Principle
- [ ] **O** - Open/Closed Principle
- [ ] **L** - Liskov Substitution Principle
- [ ] **I** - Interface Segregation Principle
- [ ] **D** - Dependency Inversion Principle
- [ ] Real-world code examples for each

## Module 8: OOP Design Patterns (Intro)
- [ ] Creational: Singleton, Factory, Builder
- [ ] Structural: Adapter, Decorator, Proxy
- [ ] Behavioral: Strategy, Observer, Template Method
- [ ] When patterns help vs when they over-engineer

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Build a `BankAccount` class with encapsulation |
| Modules 3-4 | Build a shape hierarchy (`Shape` -> `Circle`, `Rectangle`) with polymorphic area calculation |
| Module 5 | Design a payment system using interfaces (`PayPal`, `CreditCard`, `Crypto`) |
| Module 6 | Refactor anonymous classes to lambdas |
| Modules 7-8 | Refactor a monolithic class using SOLID + patterns |

## Key Resources
- Head First Design Patterns
- Effective Java - Joshua Bloch (Items on inheritance, composition, interfaces)
- Clean Code - Robert C. Martin
