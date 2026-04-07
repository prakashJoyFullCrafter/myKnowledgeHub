# ClassFile API & Compact Object Headers — Complete Study Guide

> **Java 24+ | Brutally Detailed Reference**
> Covers the `java.lang.classfile` API (JEP 484, finalized Java 24) for reading, writing, and transforming `.class` files without third-party libraries, and Compact Object Headers (Project Lilliput, JEP 450, experimental Java 24) for reducing per-object memory overhead. Every section includes full working examples.

---

## Table of Contents

1. [ClassFile API Overview](#1-classfile-api-overview)
2. [Core Abstractions — ClassFile, ClassModel, Elements](#2-core-abstractions--classfile-classmodel-elements)
3. [Reading Class Files](#3-reading-class-files)
4. [Writing Class Files from Scratch](#4-writing-class-files-from-scratch)
5. [Transforming Class Files](#5-transforming-class-files)
6. [Code Model — Reading Bytecode](#6-code-model--reading-bytecode)
7. [Generating Bytecode Instructions](#7-generating-bytecode-instructions)
8. [ClassFile API vs ASM — Migration and Comparison](#8-classfile-api-vs-asm--migration-and-comparison)
9. [Compact Object Headers (Project Lilliput)](#9-compact-object-headers-project-lilliput)
10. [Memory Layout Deep Dive](#10-memory-layout-deep-dive)
11. [Quick Reference Cheat Sheet](#11-quick-reference-cheat-sheet)

---

## 1. ClassFile API Overview

### 1.1 What Is the ClassFile API?

The ClassFile API (`java.lang.classfile`) is a standard JDK library for **reading, writing, and transforming Java `.class` files** at the bytecode level. It was introduced as a preview in Java 22 (JEP 457), refined in Java 23 (JEP 466), and **finalized in Java 24 (JEP 484)**.

Before this API, anyone working with bytecode — compiler writers, instrumentation agents, frameworks generating code at runtime — had to use third-party libraries like **ASM**, **Javassist**, or **Byte Buddy**. The JDK itself used an internal fork of ASM. The ClassFile API replaces all of this with a standard, supported API.

### 1.2 Why a New API?

**Problems with ASM (and similar libraries):**

```
1. Not in the JDK — every project must bundle it (JAR bloat, version conflicts)
2. Not kept in sync with class file versions — new JDK features require ASM updates
3. ASM tracks a separate version matrix from the JDK
4. Low-level API design — easy to produce invalid bytecode
5. Visitor pattern is error-prone — hard to reason about what you've built
6. No compile-time safety — wrong instruction sequences compile fine, fail at runtime
```

**ClassFile API design goals:**

```
1. Built into the JDK — always in sync with the latest class file format
2. Versioned with the JDK — Java 25 class files work with Java 25's ClassFile API
3. Immutable models — read a class as an immutable tree (ClassModel)
4. Builder pattern — build bytecode incrementally with type-safe builders
5. Transformation-oriented — designed for the common case of "read, modify, write"
6. Lazy parsing — parse only what you need, not the entire file upfront
```

### 1.3 Architecture Overview

```
                    ┌─────────────────────────────────────────┐
                    │            ClassFile API                 │
                    │         (java.lang.classfile)           │
                    │                                          │
  byte[]  ─────────►│  ClassFile.of().parse(bytes)            │
  .class file        │         │                               │
                    │         ▼                               │
                    │    ClassModel (immutable tree)           │
                    │    ├── MethodModel                      │
                    │    │   └── CodeModel                    │
                    │    │       └── List<CodeElement>        │
                    │    ├── FieldModel                       │
                    │    └── AttributeModel(s)                │
                    │                                          │
  ClassModel ────►  │  ClassFile.of().build(classDesc, cb -> │
                    │      cb.withMethod(...) {...} )         │
                    │         │                               │
                    │         ▼                               │
                    │       byte[]                            │──► .class file
                    └─────────────────────────────────────────┘
```

---

## 2. Core Abstractions — ClassFile, ClassModel, Elements

### 2.1 The Entry Point: `ClassFile`

`ClassFile` is the entry point for all operations. Obtain an instance via `ClassFile.of()`:

```java
import java.lang.classfile.*;
import java.lang.classfile.attribute.*;
import java.lang.classfile.instruction.*;
import java.lang.constant.*;

// Get the default ClassFile instance
ClassFile cf = ClassFile.of();

// Or with options
ClassFile cf = ClassFile.of(
    ClassFile.StackMapsOption.DROP_STACK_MAPS,  // regenerate stack maps
    ClassFile.LineNumbersOption.DROP_LINE_NUMBERS // strip debug info
);
```

**Available `ClassFile` options:**

| Option | Values | Effect |
|---|---|---|
| `StackMapsOption` | `GENERATE_STACK_MAPS` (default), `DROP_STACK_MAPS`, `PATCH_DEAD_CODE` | How to handle StackMapTable attribute |
| `DeadCodeOption` | `PATCH_DEAD_CODE` (default), `KEEP_DEAD_CODE` | Handle unreachable code |
| `LineNumbersOption` | `PASS_LINE_NUMBERS` (default), `DROP_LINE_NUMBERS` | Include/exclude line number tables |
| `LocalVariablesOption` | `PASS_LOCAL_VARIABLES` (default), `DROP_LOCAL_VARIABLES` | Include/exclude local variable tables |
| `AttributesProcessingOption` | `PROCESS_UNKNOWN_ATTRIBUTES` (default), `DROP_UNKNOWN_ATTRIBUTES` | Handle unrecognized attributes |

### 2.2 `ClassModel` — Immutable Class Representation

`ClassModel` is an **immutable tree** representing a parsed `.class` file. All elements are lazily parsed:

```java
// Parse from byte array
byte[] classBytes = Files.readAllBytes(Path.of("MyClass.class"));
ClassModel classModel = ClassFile.of().parse(classBytes);

// Top-level metadata
classModel.thisClass()                    // ClassEntry — the class descriptor
classModel.superclass()                   // Optional<ClassEntry>
classModel.interfaces()                   // List<ClassEntry>
classModel.flags()                        // AccessFlags (public, final, abstract, etc.)
classModel.majorVersion()                 // class file version (e.g., 65 = Java 21)
classModel.minorVersion()

// Members
classModel.methods()                      // List<MethodModel>
classModel.fields()                       // List<FieldModel>

// Attributes (annotations, source file, inner classes, etc.)
classModel.attributes()                   // List<Attribute<?>>
classModel.findAttribute(Attributes.sourceFile())  // Optional<SourceFileAttribute>
classModel.findAttribute(Attributes.runtimeVisibleAnnotations()) // Optional<...>
```

### 2.3 The Element Visitor Pattern — `forEach`

Every `ClassModel`, `MethodModel`, and `CodeModel` is also an `Iterable` of **elements**. Elements are a sealed hierarchy:

```java
// ClassModel elements — one per "thing" in the class
classModel.forEach(element -> {
    switch (element) {
        case MethodModel mm   -> System.out.println("Method: " + mm.methodName().stringValue());
        case FieldModel fm    -> System.out.println("Field:  " + fm.fieldName().stringValue());
        case Attribute<?> a   -> System.out.println("Attr:   " + a.attributeName());
    }
});
```

### 2.4 `ClassDesc` — Type Descriptors

`ClassDesc` (from `java.lang.constant`) is how you refer to types in the ClassFile API:

```java
// Built-in primitive descriptors
ClassDesc INT    = ClassDesc.of("int");          // actually use ConstantDescs.CD_int
ClassDesc VOID   = ConstantDescs.CD_void;
ClassDesc STRING = ConstantDescs.CD_String;
ClassDesc OBJECT = ConstantDescs.CD_Object;

// Descriptor for a class by binary name
ClassDesc myClass = ClassDesc.of("com.myapp.UserService");
ClassDesc myClass2 = ClassDesc.ofDescriptor("Lcom/myapp/UserService;");

// Array descriptors
ClassDesc stringArray = ClassDesc.of("java.lang.String").arrayType();  // [Ljava/lang/String;
ClassDesc intArray = ClassDesc.of("int").arrayType();                   // [I

// Method descriptors
MethodTypeDesc voidNoArgs   = MethodTypeDesc.of(ConstantDescs.CD_void);
MethodTypeDesc stringToInt  = MethodTypeDesc.of(ConstantDescs.CD_int, ConstantDescs.CD_String);
MethodTypeDesc complexSig   = MethodTypeDesc.of(
    ConstantDescs.CD_String,             // return type
    ConstantDescs.CD_long,               // param 1
    ClassDesc.of("java.util.List")       // param 2
);
```

---

## 3. Reading Class Files

### 3.1 Basic Class Inspection

```java
import java.lang.classfile.*;
import java.lang.classfile.attribute.*;
import java.nio.file.*;

public class ClassInspector {
    public static void inspect(Path classFile) throws Exception {
        byte[] bytes = Files.readAllBytes(classFile);
        ClassModel cm = ClassFile.of().parse(bytes);

        System.out.println("Class:       " + cm.thisClass().asInternalName());
        System.out.println("Super:       " + cm.superclass()
            .map(c -> c.asInternalName()).orElse("none"));
        System.out.println("Interfaces:  " + cm.interfaces().stream()
            .map(ClassEntry::asInternalName).toList());
        System.out.println("Version:     " + cm.majorVersion()
            + " (Java " + (cm.majorVersion() - 44) + ")");

        // Access flags
        System.out.println("Public:      " + cm.flags().has(AccessFlag.PUBLIC));
        System.out.println("Abstract:    " + cm.flags().has(AccessFlag.ABSTRACT));
        System.out.println("Interface:   " + cm.flags().has(AccessFlag.INTERFACE));

        // Methods
        System.out.println("\nMethods:");
        for (MethodModel method : cm.methods()) {
            System.out.printf("  %s %s%n",
                method.flags().flags().stream()
                    .map(f -> f.name().toLowerCase())
                    .collect(java.util.stream.Collectors.joining(" ")),
                method.methodName().stringValue() +
                method.methodType().stringValue()
            );
        }

        // Fields
        System.out.println("\nFields:");
        for (FieldModel field : cm.fields()) {
            System.out.printf("  %s %s : %s%n",
                field.flags().flags().stream()
                    .map(f -> f.name().toLowerCase())
                    .collect(java.util.stream.Collectors.joining(" ")),
                field.fieldName().stringValue(),
                field.fieldType().stringValue()
            );
        }

        // Source file attribute
        cm.findAttribute(Attributes.sourceFile())
            .ifPresent(sf -> System.out.println("\nSource: " + sf.sourceFile().stringValue()));
    }
}
```

### 3.2 Reading Annotations

```java
ClassModel cm = ClassFile.of().parse(classBytes);

// Runtime-visible class-level annotations
cm.findAttribute(Attributes.runtimeVisibleAnnotations())
    .ifPresent(rva -> {
        for (Annotation annotation : rva.annotations()) {
            System.out.println("Annotation: " + annotation.className().stringValue());
            for (AnnotationElement elem : annotation.elements()) {
                System.out.println("  " + elem.name().stringValue()
                    + " = " + elem.value());
            }
        }
    });

// Runtime-invisible (class-retained) annotations
cm.findAttribute(Attributes.runtimeInvisibleAnnotations())
    .ifPresent(ria -> { /* same structure */ });

// Method-level annotations
for (MethodModel method : cm.methods()) {
    method.findAttribute(Attributes.runtimeVisibleAnnotations())
        .ifPresent(rva -> {
            System.out.println("Method " + method.methodName().stringValue()
                + " has annotations:");
            rva.annotations().forEach(a ->
                System.out.println("  @" + a.className().stringValue()));
        });
}
```

### 3.3 Reading Constant Pool Entries

```java
ClassModel cm = ClassFile.of().parse(classBytes);
ConstantPool pool = cm.constantPool();

// Iterate all constant pool entries
for (PoolEntry entry : pool) {
    System.out.printf("[%3d] %s: %s%n",
        entry.index(),
        entry.tag(),
        entry);
}

// Find all string constants used in this class
pool.entryByIndex(1); // specific index
```

---

## 4. Writing Class Files from Scratch

### 4.1 Hello World Class Generation

```java
import java.lang.classfile.*;
import java.lang.classfile.attribute.*;
import java.lang.constant.*;
import java.nio.file.*;

public class ClassGenerator {
    public static void main(String[] args) throws Exception {

        // Generate a class equivalent to:
        // public class HelloWorld {
        //     public static void main(String[] args) {
        //         System.out.println("Hello from generated class!");
        //     }
        // }

        ClassDesc helloWorldClass = ClassDesc.of("HelloWorld");

        byte[] bytes = ClassFile.of().build(
            helloWorldClass,         // class descriptor (name)
            classBuilder -> {
                // Set superclass (default: Object)
                classBuilder
                    .withFlags(ClassFile.ACC_PUBLIC)
                    .withSuperclass(ConstantDescs.CD_Object);

                // Add main method
                classBuilder.withMethod(
                    "main",
                    MethodTypeDesc.of(
                        ConstantDescs.CD_void,
                        ClassDesc.of("java.lang.String").arrayType()
                    ),
                    ClassFile.ACC_PUBLIC | ClassFile.ACC_STATIC,
                    methodBuilder -> methodBuilder.withCode(codeBuilder -> {
                        // getstatic System.out
                        codeBuilder.getstatic(
                            ClassDesc.of("java.lang.System"),
                            "out",
                            ClassDesc.of("java.io.PrintStream")
                        );
                        // ldc "Hello from generated class!"
                        codeBuilder.ldc("Hello from generated class!");
                        // invokevirtual PrintStream.println(String)
                        codeBuilder.invokevirtual(
                            ClassDesc.of("java.io.PrintStream"),
                            "println",
                            MethodTypeDesc.of(
                                ConstantDescs.CD_void,
                                ConstantDescs.CD_String
                            )
                        );
                        // return
                        codeBuilder.return_();
                    })
                );
            }
        );

        // Write to file
        Files.write(Path.of("HelloWorld.class"), bytes);

        // Or load and run directly
        ClassLoader loader = new ClassLoader() {
            @Override
            protected Class<?> findClass(String name) {
                return defineClass(name, bytes, 0, bytes.length);
            }
        };
        Class<?> clazz = loader.loadClass("HelloWorld");
        clazz.getMethod("main", String[].class)
             .invoke(null, (Object) new String[0]);
        // Output: Hello from generated class!
    }
}
```

### 4.2 Adding Fields

```java
byte[] bytes = ClassFile.of().build(
    ClassDesc.of("com.myapp.GeneratedBean"),
    classBuilder -> {
        classBuilder.withFlags(ClassFile.ACC_PUBLIC);

        // private String name;
        classBuilder.withField(
            "name",
            ConstantDescs.CD_String,
            ClassFile.ACC_PRIVATE
        );

        // private final int id;
        classBuilder.withField(
            "id",
            ConstantDescs.CD_int,
            ClassFile.ACC_PRIVATE | ClassFile.ACC_FINAL
        );

        // public static final String CONSTANT = "VERSION_1";
        classBuilder.withField(
            "CONSTANT",
            ConstantDescs.CD_String,
            fb -> fb
                .withFlags(ClassFile.ACC_PUBLIC | ClassFile.ACC_STATIC | ClassFile.ACC_FINAL)
                .with(ConstantValueAttribute.of("VERSION_1"))
        );
    }
);
```

### 4.3 Generating a Constructor

```java
ClassDesc beanClass = ClassDesc.of("com.myapp.GeneratedBean");

classBuilder.withMethod(
    ConstantDescs.INIT_NAME,   // "<init>"
    MethodTypeDesc.of(
        ConstantDescs.CD_void,
        ConstantDescs.CD_String,   // String name
        ConstantDescs.CD_int       // int id
    ),
    ClassFile.ACC_PUBLIC,
    methodBuilder -> methodBuilder.withCode(codeBuilder -> {
        // aload_0 (this)
        codeBuilder.aload(0);
        // invokespecial Object.<init>()
        codeBuilder.invokespecial(
            ConstantDescs.CD_Object,
            ConstantDescs.INIT_NAME,
            MethodTypeDesc.of(ConstantDescs.CD_void)
        );
        // this.name = name; (aload_0, aload_1, putfield)
        codeBuilder.aload(0);
        codeBuilder.aload(1);
        codeBuilder.putfield(beanClass, "name", ConstantDescs.CD_String);
        // this.id = id; (aload_0, iload_2, putfield)
        codeBuilder.aload(0);
        codeBuilder.iload(2);
        codeBuilder.putfield(beanClass, "id", ConstantDescs.CD_int);
        // return
        codeBuilder.return_();
    })
);
```

### 4.4 Adding Attributes — SourceFile, InnerClasses, Annotations

```java
classBuilder
    // Add source file debug info
    .with(SourceFileAttribute.of("GeneratedBean.java"))

    // Add a @Deprecated annotation
    .with(RuntimeVisibleAnnotationsAttribute.of(
        Annotation.of(ClassDesc.of("java.lang.Deprecated"))
    ))

    // Add @SuppressWarnings("unchecked")
    .with(RuntimeVisibleAnnotationsAttribute.of(
        Annotation.of(
            ClassDesc.of("java.lang.SuppressWarnings"),
            AnnotationElement.of("value",
                AnnotationValue.ofString("unchecked"))
        )
    ));
```

---

## 5. Transforming Class Files

Transformation is the most common use case: read an existing class, modify some part of it, produce new bytecode. The ClassFile API has a dedicated `ClassTransform` abstraction for this.

### 5.1 `ClassTransform` — The Transformation Model

```java
// A ClassTransform processes each ClassElement and decides what to emit
ClassTransform transform = (classBuilder, classElement) -> {
    // classElement: the current element being visited
    // classBuilder: where you write output elements

    // Pattern: inspect, optionally modify, then pass through or replace
    switch (classElement) {
        case MethodModel mm when mm.methodName().stringValue().equals("oldMethod") ->
            // Skip this method entirely (don't call classBuilder.with(mm))
            System.out.println("Dropping method: " + mm.methodName().stringValue());

        default ->
            classBuilder.with(classElement); // pass through unchanged
    }
};

// Apply the transform
byte[] originalBytes = Files.readAllBytes(Path.of("Original.class"));
byte[] transformed = ClassFile.of().transform(
    ClassFile.of().parse(originalBytes),
    transform
);
```

### 5.2 Common Transform — Add Method to Every Class

```java
// Add a toString() method to every class that doesn't have one
public static byte[] addToStringIfMissing(byte[] classBytes) {
    ClassModel cm = ClassFile.of().parse(classBytes);
    ClassDesc thisClass = cm.thisClass().asSymbol();

    // Check if toString already exists
    boolean hasToString = cm.methods().stream()
        .anyMatch(m -> m.methodName().stringValue().equals("toString")
                    && m.methodType().stringValue().equals("()Ljava/lang/String;"));

    if (hasToString) return classBytes; // no change needed

    return ClassFile.of().transform(cm,
        ClassTransform.endHandler(classBuilder -> {
            // endHandler: called after all elements are processed — add at end
            classBuilder.withMethod(
                "toString",
                MethodTypeDesc.of(ConstantDescs.CD_String),
                ClassFile.ACC_PUBLIC,
                mb -> mb.withCode(cb -> {
                    cb.ldc(thisClass.displayName() + "@generated");
                    cb.areturn();
                })
            );
        })
    );
}
```

### 5.3 Method-Level Transform — Instrument Every Method

A very common use case: add entry/exit logging to every method.

```java
public static byte[] addMethodLogging(byte[] classBytes) {
    ClassModel cm = ClassFile.of().parse(classBytes);
    ClassDesc thisClass = cm.thisClass().asSymbol();

    return ClassFile.of().transform(cm,
        ClassTransform.transformingMethods(methodTransform(thisClass))
    );
}

private static MethodTransform methodTransform(ClassDesc classDesc) {
    return (methodBuilder, methodElement) -> {
        if (methodElement instanceof CodeModel codeModel) {
            // Wrap the code: inject entry log at start
            methodBuilder.transformCode(codeModel, (codeBuilder, codeElement) -> {
                if (codeElement instanceof ReturnInstruction ri) {
                    // Inject log BEFORE every return
                    codeBuilder.getstatic(
                        ClassDesc.of("java.lang.System"), "out",
                        ClassDesc.of("java.io.PrintStream")
                    );
                    codeBuilder.ldc("EXIT: " + classDesc.displayName()
                        + "." + methodBuilder.methodName());
                    codeBuilder.invokevirtual(
                        ClassDesc.of("java.io.PrintStream"), "println",
                        MethodTypeDesc.of(ConstantDescs.CD_void, ConstantDescs.CD_String)
                    );
                    // Then emit the original return
                    codeBuilder.with(codeElement);
                } else {
                    // Pass all other code elements through unchanged
                    codeBuilder.with(codeElement);
                }
            });
        } else {
            methodBuilder.with(methodElement);
        }
    };
}
```

### 5.4 Stripping Debug Information

```java
// Remove all debug info (line numbers, local variable names) to reduce class size
public static byte[] stripDebugInfo(byte[] classBytes) {
    ClassFile cf = ClassFile.of(
        ClassFile.LineNumbersOption.DROP_LINE_NUMBERS,
        ClassFile.LocalVariablesOption.DROP_LOCAL_VARIABLES
    );
    // Simply re-parse and re-emit with drop options
    return cf.transform(cf.parse(classBytes), ClassTransform.ACCEPT_ALL);
}
```

### 5.5 Version Upgrading

```java
// Upgrade class file version (e.g., recompiled but older major version)
public static byte[] upgradeVersion(byte[] classBytes, int newMajorVersion) {
    ClassModel cm = ClassFile.of().parse(classBytes);
    ClassDesc thisClass = cm.thisClass().asSymbol();

    return ClassFile.of().build(thisClass, classBuilder -> {
        // Copy all elements, then override version
        cm.forEach(classBuilder::with);
    });
    // Note: version is set by ClassFile.of() based on the running JDK
    // For explicit version control, you'd need the low-level API
}
```

---

## 6. Code Model — Reading Bytecode

### 6.1 Iterating Instructions

`CodeModel` is an `Iterable<CodeElement>`. `CodeElement` is a sealed hierarchy covering every bytecode instruction type:

```java
ClassModel cm = ClassFile.of().parse(classBytes);

for (MethodModel method : cm.methods()) {
    method.code().ifPresent(code -> {
        System.out.println("=== " + method.methodName().stringValue() + " ===");
        for (CodeElement element : code) {
            switch (element) {
                // Instruction types — all sealed, exhaustive matching possible
                case LoadInstruction li ->
                    System.out.printf("  %s slot=%d%n", li.opcode(), li.slot());
                case StoreInstruction si ->
                    System.out.printf("  %s slot=%d%n", si.opcode(), si.slot());
                case FieldInstruction fi ->
                    System.out.printf("  %s %s.%s : %s%n",
                        fi.opcode(),
                        fi.owner().asInternalName(),
                        fi.name().stringValue(),
                        fi.type().stringValue());
                case InvokeInstruction ii ->
                    System.out.printf("  %s %s.%s%s%n",
                        ii.opcode(),
                        ii.owner().asInternalName(),
                        ii.name().stringValue(),
                        ii.type().stringValue());
                case ReturnInstruction ri ->
                    System.out.printf("  %s%n", ri.opcode());
                case BranchInstruction bi ->
                    System.out.printf("  %s -> label%n", bi.opcode());
                case LabelTarget lt ->
                    System.out.printf("  LABEL: %s%n", lt.label());
                case LineNumber ln ->
                    System.out.printf("  // line %d%n", ln.line());
                default ->
                    System.out.printf("  %s%n", element);
            }
        }
    });
}
```

### 6.2 Finding Method Calls

```java
// Find all invocations of a specific method (e.g., find all System.out.println calls)
public static List<String> findCalls(byte[] classBytes,
                                      String targetClass,
                                      String targetMethod) {
    List<String> callers = new ArrayList<>();
    ClassModel cm = ClassFile.of().parse(classBytes);

    for (MethodModel method : cm.methods()) {
        method.code().ifPresent(code -> {
            for (CodeElement element : code) {
                if (element instanceof InvokeInstruction ii
                        && ii.owner().asInternalName().replace('/', '.').equals(targetClass)
                        && ii.name().stringValue().equals(targetMethod)) {
                    callers.add(method.methodName().stringValue()
                        + method.methodType().stringValue());
                }
            }
        });
    }
    return callers;
}

// Usage
List<String> callers = findCalls(classBytes, "java.lang.System", "currentTimeMillis");
// Returns: ["main([Ljava/lang/String;)V", "computeTimeout()J"]
```

### 6.3 Code Analysis — Dead Code Detection

```java
// Find methods with unreachable code after return
public static void findDeadCode(byte[] classBytes) {
    ClassModel cm = ClassFile.of().parse(classBytes);

    for (MethodModel method : cm.methods()) {
        method.code().ifPresent(code -> {
            boolean afterReturn = false;
            for (CodeElement element : code) {
                if (afterReturn && !(element instanceof LabelTarget)) {
                    System.out.println("DEAD CODE in "
                        + method.methodName().stringValue() + ": " + element);
                }
                if (element instanceof ReturnInstruction
                        || element instanceof ThrowInstruction) {
                    afterReturn = true;
                } else if (element instanceof LabelTarget) {
                    afterReturn = false; // branch target = reachable again
                }
            }
        });
    }
}
```

---

## 7. Generating Bytecode Instructions

### 7.1 `CodeBuilder` — The Instruction Emitter

`CodeBuilder` provides high-level methods for each instruction category. It handles label creation, stack frame calculation, and local variable slot management.

```java
methodBuilder.withCode(codeBuilder -> {
    // ─────────────────────────────────────────────────────────
    // LOAD instructions
    codeBuilder.aload(0);         // aload_0 (load reference from slot 0 = this)
    codeBuilder.iload(1);         // iload_1 (load int from slot 1)
    codeBuilder.lload(2);         // lload_2 (load long — occupies slots 2 and 3)
    codeBuilder.fload(1);         // fload
    codeBuilder.dload(1);         // dload
    codeBuilder.aload(10);        // aload 10 (wide form for slots > 3)

    // STORE instructions
    codeBuilder.astore(0);        // astore_0
    codeBuilder.istore(3);        // istore_3
    codeBuilder.lstore(4);        // lstore

    // CONSTANTS
    codeBuilder.ldc("hello");             // push String constant
    codeBuilder.ldc(42);                  // push int constant
    codeBuilder.ldc(3.14d);              // push double constant
    codeBuilder.ldc(ClassDesc.of("java.lang.String")); // push Class constant
    codeBuilder.iconst_0();               // push 0
    codeBuilder.iconst_1();               // push 1
    codeBuilder.aconst_null();            // push null

    // ARITHMETIC
    codeBuilder.iadd();  codeBuilder.isub();
    codeBuilder.imul();  codeBuilder.idiv();  codeBuilder.irem();
    codeBuilder.ineg();
    codeBuilder.ladd();  codeBuilder.dadd();  codeBuilder.fadd();
    codeBuilder.ishl();  codeBuilder.ishr();  codeBuilder.iushr();
    codeBuilder.iand();  codeBuilder.ior();   codeBuilder.ixor();

    // TYPE CONVERSION
    codeBuilder.i2l();  codeBuilder.i2d();  codeBuilder.i2f();
    codeBuilder.l2i();  codeBuilder.d2i();  codeBuilder.f2i();
    codeBuilder.i2b();  codeBuilder.i2c();  codeBuilder.i2s();
    codeBuilder.checkcast(ClassDesc.of("java.lang.String"));
    codeBuilder.instanceof_(ClassDesc.of("java.util.List"));

    // FIELD ACCESS
    codeBuilder.getfield(ownerClass, "fieldName", ConstantDescs.CD_int);
    codeBuilder.putfield(ownerClass, "fieldName", ConstantDescs.CD_int);
    codeBuilder.getstatic(ClassDesc.of("java.lang.System"), "out",
                          ClassDesc.of("java.io.PrintStream"));
    codeBuilder.putstatic(ownerClass, "staticField", ConstantDescs.CD_String);

    // METHOD INVOCATION
    codeBuilder.invokevirtual(ownerClass, "method",
        MethodTypeDesc.of(ConstantDescs.CD_String));
    codeBuilder.invokespecial(ConstantDescs.CD_Object, ConstantDescs.INIT_NAME,
        MethodTypeDesc.of(ConstantDescs.CD_void));
    codeBuilder.invokestatic(ownerClass, "staticMethod",
        MethodTypeDesc.of(ConstantDescs.CD_int, ConstantDescs.CD_int));
    codeBuilder.invokeinterface(ClassDesc.of("java.util.List"), "size",
        MethodTypeDesc.of(ConstantDescs.CD_int));

    // OBJECT CREATION
    codeBuilder.new_(ClassDesc.of("java.util.ArrayList"));
    codeBuilder.dup();     // duplicate top of stack (for new + invokespecial)
    codeBuilder.invokespecial(ClassDesc.of("java.util.ArrayList"),
        ConstantDescs.INIT_NAME, MethodTypeDesc.of(ConstantDescs.CD_void));

    // ARRAY OPERATIONS
    codeBuilder.anewarray(ConstantDescs.CD_String);   // new String[...]
    codeBuilder.newarray(Opcode.NEWARRAY_INT);        // new int[...]
    codeBuilder.arraylength();
    codeBuilder.aaload();   // load reference from array
    codeBuilder.aastore();  // store reference to array
    codeBuilder.iaload();   // load int from array
    codeBuilder.iastore();  // store int to array

    // STACK MANIPULATION
    codeBuilder.pop();      // discard top value
    codeBuilder.pop2();     // discard top long/double
    codeBuilder.dup();      // duplicate
    codeBuilder.dup_x1();   // duplicate and insert below second value
    codeBuilder.swap();     // swap top two values

    // RETURN
    codeBuilder.return_();  // void return
    codeBuilder.areturn();  // reference return
    codeBuilder.ireturn();  // int/boolean/byte/char/short return
    codeBuilder.lreturn();  // long return
    codeBuilder.dreturn();  // double return
    codeBuilder.freturn();  // float return
    codeBuilder.athrow();   // throw exception
});
```

### 7.2 Control Flow — Labels and Branches

```java
methodBuilder.withCode(codeBuilder -> {
    // Labels are pre-created, then bound at a position
    Label elseLabel  = codeBuilder.newLabel();
    Label endLabel   = codeBuilder.newLabel();

    // if (param == 0) { ... } else { ... }
    codeBuilder.iload(1);               // load param
    codeBuilder.ifeq(elseLabel);        // if == 0, jump to else

    // then branch
    codeBuilder.ldc("was zero");
    codeBuilder.areturn();

    // else branch
    codeBuilder.labelBinding(elseLabel);  // bind label here
    codeBuilder.ldc("was not zero");
    codeBuilder.areturn();

    // Other branch instructions:
    // ifne, iflt, ifle, ifgt, ifge (compare with 0)
    // if_icmpeq, if_icmpne, if_icmplt, ... (compare two ints)
    // ifnull, ifnonnull
    // goto_(label)
});
```

### 7.3 Local Variable Helpers

```java
methodBuilder.withCode(codeBuilder -> {
    // Declare a local variable slot
    // Slots 0..n where:
    //   slot 0 = this (for instance methods)
    //   slot 1..n = parameters (longs/doubles take 2 slots)
    //   then: local variables follow

    // Allocate a local variable slot
    int resultSlot = 3; // after this + 2 params (one is long → 2 slots)

    codeBuilder.ldc(42);
    codeBuilder.istore(resultSlot);    // store 42 in local var

    // ... later ...
    codeBuilder.iload(resultSlot);    // reload it
    codeBuilder.ireturn();
});
```

---

## 8. ClassFile API vs ASM — Migration and Comparison

### 8.1 Conceptual Differences

| Concept | ASM | ClassFile API |
|---|---|---|
| Entry point | `ClassReader` + `ClassWriter` | `ClassFile.of()` |
| Reading | Visitor pattern (push-based) | Iterator/element tree (pull-based) |
| Writing | `ClassWriter.visitMethod()` etc. | `ClassFile.of().build()` with builders |
| Transformation | `ClassReader` → `ClassVisitor` chain → `ClassWriter` | `ClassFile.of().transform(model, transform)` |
| Instruction access | `MethodVisitor.visitMethodInsn()` etc. | Pattern matching on `InvokeInstruction` etc. |
| Labels | `Label` (created, then visited) | `Label` (created, then bound at position) |
| Stack frames | Must manage manually or use `COMPUTE_FRAMES` | Handled automatically |
| Thread safety | `ClassWriter` is not thread-safe | `ClassFile` is immutable, builders not shared |

### 8.2 ASM → ClassFile API Migration Examples

```java
// ─────────────────────────────────────────────────────────
// ASM: Read class name
ClassReader cr = new ClassReader(bytes);
String[] nameHolder = new String[1];
cr.accept(new ClassVisitor(Opcodes.ASM9) {
    @Override
    public void visit(int version, int access, String name, ...) {
        nameHolder[0] = name;
    }
}, 0);
String className = nameHolder[0];

// ClassFile API: Read class name
ClassModel cm = ClassFile.of().parse(bytes);
String className = cm.thisClass().asInternalName();

// ─────────────────────────────────────────────────────────
// ASM: Add a field
ClassWriter cw = new ClassWriter(0);
cr.accept(new ClassVisitor(Opcodes.ASM9, cw) {
    @Override
    public void visitEnd() {
        cw.visitField(Opcodes.ACC_PRIVATE, "counter",
            Type.INT_TYPE.getDescriptor(), null, null).visitEnd();
        super.visitEnd();
    }
}, 0);
byte[] newBytes = cw.toByteArray();

// ClassFile API: Add a field
byte[] newBytes = ClassFile.of().transform(
    ClassFile.of().parse(bytes),
    ClassTransform.endHandler(cb ->
        cb.withField("counter", ConstantDescs.CD_int, ClassFile.ACC_PRIVATE)
    )
);

// ─────────────────────────────────────────────────────────
// ASM: Instrument method entry
cr.accept(new ClassVisitor(Opcodes.ASM9, cw) {
    @Override
    public MethodVisitor visitMethod(int access, String name,
            String descriptor, String signature, String[] exceptions) {
        MethodVisitor mv = super.visitMethod(access, name, descriptor, ...);
        return new MethodVisitor(Opcodes.ASM9, mv) {
            @Override
            public void visitCode() {
                // Inject: System.out.println("ENTER: " + name)
                mv.visitFieldInsn(GETSTATIC, "java/lang/System", "out",
                    "Ljava/io/PrintStream;");
                mv.visitLdcInsn("ENTER: " + name);
                mv.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream",
                    "println", "(Ljava/lang/String;)V", false);
                super.visitCode();
            }
        };
    }
}, 0);

// ClassFile API: Instrument method entry
byte[] newBytes = ClassFile.of().transform(
    ClassFile.of().parse(bytes),
    ClassTransform.transformingMethods((mb, me) -> {
        if (me instanceof CodeModel code) {
            String methodName = mb.methodName().stringValue();
            mb.transformCode(code, (cb, ce) -> {
                if (ce instanceof PseudoInstruction) {
                    // Inject at very first real instruction
                    cb.getstatic(ClassDesc.of("java.lang.System"), "out",
                        ClassDesc.of("java.io.PrintStream"));
                    cb.ldc("ENTER: " + methodName);
                    cb.invokevirtual(ClassDesc.of("java.io.PrintStream"),
                        "println",
                        MethodTypeDesc.of(ConstantDescs.CD_void, ConstantDescs.CD_String));
                }
                cb.with(ce);
            });
        } else {
            mb.with(me);
        }
    })
);
```

### 8.3 When to Still Use ASM

The ClassFile API covers most use cases, but ASM still has advantages in some scenarios:

| Scenario | Use ClassFile API | Use ASM |
|---|---|---|
| JDK projects, agents, annotation processors | ✅ Always | Only if legacy code |
| New Java features (records, sealed, etc.) | ✅ Always in sync | Requires ASM update |
| Complex existing codegen framework on ASM | Maybe migrate | ✅ If migration cost is high |
| Java 8–21 compatibility required | ❌ ClassFile API is Java 24+ | ✅ ASM runs on Java 8+ |
| Extremely low-level bytecode control | ✅ ClassFile API handles it | ✅ Both capable |

---

## 9. Compact Object Headers (Project Lilliput)

### 9.1 What Are Object Headers?

Every Java object in the heap has an **object header** prepended to its fields. The header stores metadata the JVM needs at runtime.

In the standard HotSpot JVM (Java 8–24, non-experimental), the header is **12 bytes on 64-bit JVMs with compressed oops**:

```
Standard Object Header (12 bytes with compressed oops):
┌─────────────────────────────────────────────────────────┐
│  Mark Word          (8 bytes)                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Hash code (31 bits)                              │   │
│  │ GC age (4 bits)                                  │   │
│  │ Lock state (3 bits: unlocked/biased/thin/fat/GC) │   │
│  │ Biased lock data (when biased)                   │   │
│  └──────────────────────────────────────────────────┘   │
│  Klass pointer      (4 bytes, compressed)               │
│  (points to class metadata — what type is this?)        │
└─────────────────────────────────────────────────────────┘
  = 12 bytes per object BEFORE any fields
```

Because Java mandates 8-byte object alignment, this rounds up to **16 bytes minimum** for objects with no fields:

```java
// Object with no fields:
new Object()  // header: 12 bytes + 4 bytes padding = 16 bytes minimum
```

### 9.2 Memory Impact of 12-Byte Headers

The header overhead is significant for small objects:

```java
// Integer wrapper object:
// - header: 12 bytes
// - int value: 4 bytes
// Total: 16 bytes (vs 4 bytes for primitive int — 4× overhead)

// Small record:
record Point(int x, int y) {}
// - header: 12 bytes
// - int x: 4 bytes
// - int y: 4 bytes
// Total: 24 bytes (after padding)

// For 10 million Point objects: 240 MB
// The int data itself: 80 MB (10M × 2 × 4 bytes)
// Header overhead: 160 MB — 67% of memory is just headers!
```

### 9.3 Compact Object Headers — 8-Byte Headers (Project Lilliput)

**JEP 450 (Java 24, experimental)** introduces Compact Object Headers: reduce the standard header from 12 bytes to **8 bytes** by repacking the mark word and klass pointer into a single 8-byte word.

```
Compact Object Header (8 bytes):
┌─────────────────────────────────────────────────────────┐
│  Combined 8-byte word:                                  │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Klass pointer   (compressed, 22 bits)            │   │
│  │ Forwarding bits (for GC, 2 bits)                 │   │
│  │ Lock bits       (3 bits: unlocked/thin/fat)      │   │
│  │ GC age          (4 bits)                         │   │
│  │ Hash code       (31 bits)                        │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
  = 8 bytes per object (saving 4 bytes per object!)
```

**Key design change:** The klass pointer is compressed from 32 bits to 22 bits (sufficient to address up to 4 million distinct classes, more than enough for any JVM workload), freeing space for hash code and lock data.

### 9.4 Enabling Compact Object Headers

```bash
# Java 24 (experimental — must explicitly unlock)
-XX:+UnlockExperimentalVMOptions
-XX:+UseCompactObjectHeaders

# Verify it's active
java -XX:+UnlockExperimentalVMOptions -XX:+UseCompactObjectHeaders \
     -XX:+PrintFlagsFinal -version 2>&1 | grep CompactObjectHeaders
# bool UseCompactObjectHeaders = true {experimental} {command line}
```

### 9.5 Memory Savings — Quantified

```java
// With compact headers enabled:
new Object()            // 8 bytes (was 16 = header 12 + 4 pad → now 8, no padding needed)

record Point(int x, int y) {}
// header: 8 bytes + int x: 4 + int y: 4 = 16 bytes (was 24 bytes — 33% reduction)

// Benchmark: 10 million Integer objects
// Standard headers:  16 bytes × 10M = 160 MB
// Compact headers:   12 bytes × 10M = 120 MB  (8 header + 4 int, aligned to 12? No, 16 for Integer)
// Actually Integer: 8 (header) + 4 (int value) = 12 bytes, padded to 16 still due to alignment
// The savings are most visible for objects where header was a larger fraction

// Where savings are greatest: arrays of small objects
// Object[] of 10M Point(int,int) records:
// Standard: 10M × 24 bytes = 240 MB
// Compact:  10M × 16 bytes = 160 MB  — 33% savings!

// Real-world: 5–20% total heap savings for typical workloads
// Best case: memory-intensive apps with millions of small objects
```

### 9.6 What Changes Under Compact Headers

```
Standard:                          Compact:
Object layout (12-byte header):    Object layout (8-byte header):
┌──────────────────────┐          ┌──────────────────────┐
│ Mark Word  [8 bytes] │          │ Combined   [8 bytes] │
│ Klass ptr  [4 bytes] │          └──────────────────────┘
└──────────────────────┘          │ field1     [N bytes] │
│ field1     [N bytes] │          │ field2     [M bytes] │
│ field2     [M bytes] │          └──────────────────────┘
└──────────────────────┘
```

**Implications:**
1. Objects that were 16 bytes (e.g., `new Object()`) are now 8 bytes — a 50% reduction for empty objects
2. Objects that were 24 bytes (e.g., `Point(int,int)`) are now 16 bytes — 33% reduction
3. Objects with many fields: savings are proportionally smaller (header is smaller fraction)

### 9.7 Compatibility Considerations

```java
// sun.misc.Unsafe absolute field offsets may change
// (fields start at offset 8 instead of 12)
long fieldOffset = unsafe.objectFieldOffset(field);
// This changes with compact headers — any code hardcoding "12" as base offset breaks

// Serialization frameworks that probe object layout (Kryo, FST)
// may need updates when compact headers change field start offset

// JNI code that accesses object fields via raw offsets
// will be broken if it hardcodes offsets

// Safe code (uses Field.get(), VarHandles, standard APIs):
// ✅ Unaffected — JVM handles offset translation transparently
```

### 9.8 Project Lilliput Roadmap

```
Java 21 (2023): Lilliput prototype, experiments
Java 24 (2024): JEP 450 — Compact Object Headers as EXPERIMENTAL feature
                -XX:+UnlockExperimentalVMOptions -XX:+UseCompactObjectHeaders
Future (TBD):   Standardize compact headers (non-experimental)
Future (TBD):   Further header reductions (Project Lilliput target: 4-byte headers)
```

**Project Lilliput's longer-term goal** is to reduce headers further, possibly to 4 bytes, by moving more data out of the object header (e.g., hash codes stored in a side table for the rare objects that need them).

---

## 10. Memory Layout Deep Dive

### 10.1 Object Alignment and Padding

Java objects are aligned to 8-byte boundaries (by default). Fields are laid out to minimize padding:

```java
// Example: field layout optimization
class Suboptimal {
    boolean a;  // 1 byte at offset 12 (standard header end)
                // 7 bytes padding
    long    b;  // 8 bytes at offset 20 → total: 28, pads to 32
    byte    c;  // 1 byte at offset 28
                // 3 bytes padding
    int     d;  // 4 bytes at offset 24 (moved by JVM for alignment)
}
// JVM actually reorders fields for optimal packing — so actual layout may differ

// With compact headers (8-byte header):
// boolean a: offset 8  (1 byte)
// 3 bytes padding (to align int)
// int d: offset 12 (4 bytes)
// long b: offset 16 (8 bytes)
// byte c: offset 24 (1 byte)
// 7 bytes padding
// Total: 32 bytes

// To inspect actual layout: use -XX:+PrintFieldLayout (JVM diagnostic flag)
java -XX:+UnlockDiagnosticVMOptions -XX:+PrintFieldLayout MyClass
```

### 10.2 Measuring Object Sizes

```java
// Use JOL (Java Object Layout) library to measure actual sizes
// <dependency>
//   <groupId>org.openjdk.jol</groupId>
//   <artifactId>jol-core</artifactId>
//   <version>0.17</version>
// </dependency>

import org.openjdk.jol.info.ClassLayout;
import org.openjdk.jol.info.GraphLayout;

// Print layout of a class
System.out.println(ClassLayout.parseClass(Point.class).toPrintable());
// Output:
// com.myapp.Point object internals:
//  OFFSET  SIZE   TYPE DESCRIPTION                VALUE
//       0     4        (object header: mark)      0x0000000000000001
//       4     4        (object header: class)     0x0001c0a0
//       8     4    int Point.x                    0
//      12     4    int Point.y                    0
// Instance size: 16 bytes

// Total size of an object graph
System.out.println(GraphLayout.parseInstance(new ArrayList<>()).toFootprint());
```

### 10.3 Arrays and Compact Headers

```java
// Array header in standard layout:
// - 8 bytes: mark word
// - 4 bytes: klass pointer
// - 4 bytes: array length
// = 16 bytes array header

// With compact headers:
// - 8 bytes: combined header (klass + mark)
// - 4 bytes: array length
// = 12 bytes → but 8-byte aligned → still effectively 16 bytes for most arrays
// Savings for arrays are less dramatic than for regular objects

int[] arr = new int[0];
// Standard: 16 bytes header + 0 elements = 16 bytes
// Compact:  16 bytes (12 header + 4 align) = 16 bytes (same for empty array)

int[] arr100 = new int[100];
// Standard: 16 + (100 × 4) = 416 bytes
// Compact:  same (header overhead is small relative to data)
```

---

## 11. Quick Reference Cheat Sheet

### ClassFile API — Core Operations

```java
// Setup
ClassFile cf = ClassFile.of();
ClassFile cf = ClassFile.of(ClassFile.StackMapsOption.DROP_STACK_MAPS);

// Read
ClassModel cm = cf.parse(bytes);
cm.thisClass().asInternalName()          // "com/myapp/Foo"
cm.methods()                             // List<MethodModel>
cm.fields()                              // List<FieldModel>
cm.findAttribute(Attributes.sourceFile()) // Optional<SourceFileAttribute>

// Write from scratch
byte[] bytes = cf.build(classDesc, classBuilder -> {
    classBuilder.withFlags(ClassFile.ACC_PUBLIC);
    classBuilder.withField(name, typeDesc, flags);
    classBuilder.withMethod(name, methodTypeDesc, flags, mb -> mb.withCode(cb -> {
        cb.ldc("value");
        cb.areturn();
    }));
});

// Transform
byte[] newBytes = cf.transform(cm,
    ClassTransform.transformingMethods((mb, me) -> {
        mb.with(me); // pass through, or modify
    })
);

// Common ClassTransform factories
ClassTransform.ACCEPT_ALL                         // pass everything through
ClassTransform.endHandler(cb -> { /* add at end */ })
ClassTransform.transformingMethods(methodTransform)
ClassTransform.dropping(e -> e instanceof MethodModel mm
    && mm.methodName().stringValue().equals("debug"))
```

### ClassFile API — Type Descriptors

```java
ConstantDescs.CD_void / CD_int / CD_long / CD_double / CD_float
ConstantDescs.CD_String / CD_Object / CD_Class
ClassDesc.of("com.myapp.Foo")                 // reference type
ClassDesc.of("com.myapp.Foo").arrayType()     // array type
MethodTypeDesc.of(returnDesc, paramDesc...)   // method signature
ConstantDescs.INIT_NAME                       // "<init>"
```

### ClassFile API — Instruction Quick Reference

```java
// Load/Store: aload, iload, lload, fload, dload / astore, istore, ...
// Constants:  ldc(val), iconst_0/1, aconst_null
// Fields:     getfield, putfield, getstatic, putstatic
// Methods:    invokevirtual, invokespecial, invokestatic, invokeinterface
// Objects:    new_, dup, checkcast, instanceof_
// Arrays:     anewarray, newarray, arraylength, aaload, aastore
// Arithmetic: iadd, isub, imul, idiv, irem, ineg, ishl, ...
// Branches:   ifeq, ifne, iflt, ifge, goto_, LabelTarget, newLabel(), labelBinding()
// Return:     return_(), areturn(), ireturn(), lreturn(), freturn(), dreturn(), athrow()
```

### Compact Object Headers

```bash
# Enable (Java 24+)
-XX:+UnlockExperimentalVMOptions -XX:+UseCompactObjectHeaders

# Effect: 12-byte header → 8-byte header
# Savings: 4 bytes per object
# Typical heap savings: 5–20% for object-heavy workloads
# Best case: millions of small objects (POJOs, records, wrappers)
```

### Key Rules to Remember

1. **ClassFile API is JDK-bundled** — no third-party dependency, always in sync with latest class file version.
2. **`ClassModel` is immutable** — reading is safe; use `ClassTransform` for modification.
3. **`ClassFile.of()` is reusable** — it's an immutable value; share it.
4. **Stack frames are auto-computed** — don't manually track stack depth; the API handles it.
5. **Labels are pre-declared, then bound** — `newLabel()` then `labelBinding(label)` at target position.
6. **`ConstantDescs` has all primitive/common type descriptors** — use them instead of `ClassDesc.of("int")`.
7. **Compact headers are experimental** in Java 24 — requires `+UnlockExperimentalVMOptions`.
8. **Compact headers save 4 bytes per object** — from 12-byte header to 8-byte combined header.
9. **Compact headers change field base offset** — code using `Unsafe` with hardcoded offset 12 will break.
10. **JOL (Java Object Layout)** is the tool for measuring actual object sizes in a running JVM.

---

*End of ClassFile API & Compact Object Headers Study Guide — JEP 484 + JEP 450 (Java 24)*
