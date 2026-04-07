# Java Agents & Instrumentation — Complete Study Guide

> **Module 8 | Brutally Detailed Reference**
> Covers `premain()` load-time agents, `agentmain()` runtime attach, the `Instrumentation` API, `ClassFileTransformer`, bytecode manipulation with ASM and Byte Buddy, MANIFEST.MF configuration, and every real-world agent use case from APM to hot reload. Every section includes full working examples.

---

## Table of Contents

1. [What Is a Java Agent?](#1-what-is-a-java-agent)
2. [`premain()` Agent — Load-Time Instrumentation](#2-premain-agent--load-time-instrumentation)
3. [`agentmain()` Agent — Runtime Attach](#3-agentmain-agent--runtime-attach)
4. [The `Instrumentation` API](#4-the-instrumentation-api)
5. [`ClassFileTransformer` — Intercepting Class Loading](#5-classfiletransformer--intercepting-class-loading)
6. [Bytecode Manipulation — ASM](#6-bytecode-manipulation--asm)
7. [Bytecode Manipulation — Byte Buddy](#7-bytecode-manipulation--byte-buddy)
8. [`MANIFEST.MF` Attributes — Complete Reference](#8-manifestmf-attributes--complete-reference)
9. [Building and Packaging an Agent JAR](#9-building-and-packaging-an-agent-jar)
10. [Real-World Agent Use Cases](#10-real-world-agent-use-cases)
11. [Limitations, Security, and Java 9+ Module System](#11-limitations-security-and-java-9-module-system)
12. [Quick Reference Cheat Sheet](#12-quick-reference-cheat-sheet)

---

## 1. What Is a Java Agent?

### 1.1 Definition

A Java agent is a **special JAR that hooks into the JVM** and can observe or modify the bytecode of any class as it is loaded. Agents run in the same JVM process as your application but have privileged access to JVM internals via the `java.lang.instrument` package.

```
Without agent:                    With -javaagent:myagent.jar:
┌──────────────────┐              ┌──────────────────────────────────────┐
│  JVM starts      │              │  JVM starts                          │
│  main() runs     │              │  premain() runs  ← YOUR AGENT CODE   │
│  app code runs   │              │  (registers ClassFileTransformer)     │
└──────────────────┘              │  main() runs                         │
                                  │  (every class loaded → transformer   │
                                  │   intercepts, optionally modifies)   │
                                  └──────────────────────────────────────┘
```

### 1.2 What Agents Can Do

```
Agents can:
✓ Intercept every class as it is loaded (ClassFileTransformer)
✓ Modify bytecode before a class is defined (add logging, inject counters, etc.)
✓ Re-instrument already-loaded classes (retransformClasses)
✓ Completely replace a class's bytecode (redefineClasses)
✓ Query all loaded classes (getAllLoadedClasses)
✓ Measure object sizes (getObjectSize)
✓ Access any class regardless of module visibility (Boot-Class-Path)
✓ Attach to a running JVM without restarting (agentmain + Attach API)

Agents cannot (in the default model):
✗ Change a class's superclass or implemented interfaces
✗ Add or remove fields on an already-loaded class (via retransform/redefine)
✗ Change method signatures on already-loaded classes
✗ Violate the JVM security manager (when one is present)
```

### 1.3 Two Agent Lifecycle Modes

```
Mode 1: Load-time (premain)
  Agent JAR is specified at JVM startup: java -javaagent:agent.jar MyApp
  premain() runs BEFORE main()
  Transformer registered → intercepts ALL subsequent class loads

Mode 2: Runtime attach (agentmain)
  JVM is already running
  External process uses Attach API to load agent into running JVM
  agentmain() runs in the target JVM
  Can retransform already-loaded classes
```

---

## 2. `premain()` Agent — Load-Time Instrumentation

### 2.1 The Entry Point

The agent class must have a `premain` static method. The JVM calls it before `main()`:

```java
import java.lang.instrument.Instrumentation;

public class MyAgent {

    /**
     * Called by the JVM before main().
     * @param agentArgs  the string after '=' in -javaagent:agent.jar=ARGS
     * @param inst       the Instrumentation instance — your gateway to JVM internals
     */
    public static void premain(String agentArgs, Instrumentation inst) {
        System.out.println("[Agent] premain called. Args: " + agentArgs);

        // Register a transformer — called for every class that is loaded
        inst.addTransformer(new MyTransformer(), true); // true = can retransform

        // Store inst for later use (e.g., retransformClasses)
        AgentState.instrumentation = inst;
    }

    // Optional overload — JVM tries the two-arg version first, falls back to this
    public static void premain(String agentArgs) {
        System.out.println("[Agent] premain (no Instrumentation) called");
    }
}
```

### 2.2 Activation

```bash
# Basic: agent with no args
java -javaagent:/path/to/myagent.jar com.myapp.Main

# With args string (received as agentArgs parameter)
java -javaagent:/path/to/myagent.jar=verbose=true,sampling=100 com.myapp.Main

# Multiple agents (all run in order, before main())
java -javaagent:agent1.jar -javaagent:agent2.jar com.myapp.Main

# Agent on classpath is NOT enough — must use -javaagent flag
```

### 2.3 Timing — When premain Runs

```
JVM initializes
  ↓
Bootstrap classloader loads agent JAR
  ↓
premain(String, Instrumentation) is called    ← YOUR CODE
  (ClassFileTransformers are registered here)
  ↓
Application ClassLoader is created
  ↓
main(String[]) is called                      ← APPLICATION CODE
  ↓
Every subsequent class load passes through registered transformers
```

**Critical implication:** Any classes loaded **by the agent itself** during `premain()` will also pass through any transformer you register in `premain()`. Be careful of infinite recursion or transformers that transform themselves.

---

## 3. `agentmain()` Agent — Runtime Attach

### 3.1 The Entry Point

```java
import java.lang.instrument.Instrumentation;

public class AttachAgent {

    /**
     * Called by the JVM when the agent is loaded into a running process.
     * @param agentArgs  arguments passed to loadAgent()
     * @param inst       the Instrumentation instance
     */
    public static void agentmain(String agentArgs, Instrumentation inst) {
        System.out.println("[AttachAgent] Loaded into running JVM. Args: " + agentArgs);

        // Register transformer for future class loads
        inst.addTransformer(new ProfilingTransformer(), true);

        // Also retransform already-loaded classes if needed
        try {
            Class<?>[] loaded = inst.getAllLoadedClasses();
            List<Class<?>> retransformable = Arrays.stream(loaded)
                .filter(inst::isModifiableClass)
                .filter(c -> c.getName().startsWith("com.myapp."))
                .collect(Collectors.toList());

            if (!retransformable.isEmpty()) {
                inst.retransformClasses(retransformable.toArray(new Class[0]));
            }
        } catch (UnmodifiableClassException e) {
            System.err.println("[AttachAgent] Cannot retransform: " + e.getMessage());
        }
    }

    public static void agentmain(String agentArgs) { /* fallback */ }
}
```

### 3.2 The Attach API — Connecting to a Running JVM

The Attach API (`com.sun.tools.attach`) is how you inject an agent into a running process. It lives in `tools.jar` (Java 8) or the `jdk.attach` module (Java 9+):

```java
import com.sun.tools.attach.VirtualMachine;
import com.sun.tools.attach.VirtualMachineDescriptor;

public class AgentAttacher {

    public static void main(String[] args) throws Exception {
        // Target PID — either from args, jps, or discovered programmatically
        String targetPid = args[0]; // e.g., "12345"
        String agentJarPath = "/path/to/attach-agent.jar";
        String agentArgs = "samplingRate=100";

        // Step 1: Attach to the target JVM
        VirtualMachine vm = VirtualMachine.attach(targetPid);
        System.out.println("Attached to: " + vm.id());

        try {
            // Step 2: Load the agent into the target JVM
            // This triggers agentmain() in the target process
            vm.loadAgent(agentJarPath, agentArgs);
            System.out.println("Agent loaded successfully");

        } finally {
            // Step 3: Detach (IMPORTANT — releases file handles and resources)
            vm.detach();
        }
    }
}
```

**Finding target JVMs programmatically:**

```java
// List all JVMs on this machine
List<VirtualMachineDescriptor> vms = VirtualMachine.list();
for (VirtualMachineDescriptor vmd : vms) {
    System.out.printf("PID: %-8s  DisplayName: %s%n",
        vmd.id(), vmd.displayName());
}

// Find a specific application by name
Optional<VirtualMachineDescriptor> target = vms.stream()
    .filter(vmd -> vmd.displayName().contains("MyApplication"))
    .findFirst();

if (target.isPresent()) {
    VirtualMachine vm = VirtualMachine.attach(target.get());
    vm.loadAgent("/path/to/agent.jar");
    vm.detach();
} else {
    System.err.println("Target JVM not found");
}
```

### 3.3 Java 9+ Module Access for Attach API

```java
// Module path: jdk.attach is required
// Either add to module-info.java:
// requires jdk.attach;

// Or use --add-modules on command line:
// java --add-modules jdk.attach com.myapp.AgentAttacher <pid>
```

### 3.4 Attach API vs JMX

```
Attach API:
  - Low-level — directly load a JAR into another JVM
  - Works even without JMX enabled on target
  - Used by: jcmd, jstack, jmap, jconsole, VisualVM, profilers

JMX:
  - Higher-level — expose MBeans for management
  - Better for application-level monitoring
  - Requires JMX port open on target

For agent injection: use Attach API
For operational metrics: use JMX
```

---

## 4. The `Instrumentation` API

### 4.1 Complete API Reference

```java
import java.lang.instrument.*;

public interface Instrumentation {

    // ── Transformer registration ──────────────────────────────────────────
    void addTransformer(ClassFileTransformer transformer);
    void addTransformer(ClassFileTransformer transformer, boolean canRetransform);
    boolean removeTransformer(ClassFileTransformer transformer);

    // ── Class retransformation ────────────────────────────────────────────
    // Re-triggers load-time transformation on already-loaded classes
    // Calls all registered retransformable transformers on each class
    void retransformClasses(Class<?>... classes) throws UnmodifiableClassException;
    boolean isRetransformClassesSupported(); // true if Can-Retransform-Classes: true

    // ── Class redefinition ────────────────────────────────────────────────
    // Replaces bytecode entirely — more powerful than retransform
    // Does NOT go through ClassFileTransformer
    void redefineClasses(ClassDefinition... definitions)
        throws ClassNotFoundException, UnmodifiableClassException;
    boolean isRedefineClassesSupported(); // true if Can-Redefine-Classes: true

    // ── Class inspection ──────────────────────────────────────────────────
    Class<?>[] getAllLoadedClasses();
    Class<?>[] getInitiatedClasses(ClassLoader loader);
    boolean isModifiableClass(Class<?> theClass);

    // ── Memory sizing ─────────────────────────────────────────────────────
    // "Shallow" size — just the object itself, not its references
    long getObjectSize(Object objectToSize);

    // ── Classpath manipulation ────────────────────────────────────────────
    void appendToBootstrapClassLoaderSearch(JarFile jarfile);
    void appendToSystemClassLoaderSearch(JarFile jarfile);
    boolean isBootstrapClassLoaderSearch... // etc.

    // ── Native method prefixing ───────────────────────────────────────────
    void setNativeMethodPrefix(ClassFileTransformer transformer, String prefix);
    boolean isNativeMethodPrefixSupported();
}
```

### 4.2 `addTransformer(ClassFileTransformer, canRetransform)`

Registers a transformer that will be called on every subsequent class load:

```java
// canRetransform = false (default): transformer only called on new class loads
inst.addTransformer(myTransformer);

// canRetransform = true: transformer is also called when retransformClasses() is invoked
// Required if you want to instrument classes that are already loaded
inst.addTransformer(myTransformer, true);

// Important: multiple transformers are called in registration order
// Each gets the output of the previous transformer as its input (pipeline)
inst.addTransformer(transformer1, true);
inst.addTransformer(transformer2, true); // gets transformer1's output
```

### 4.3 `retransformClasses(Class<?>...)`

Triggers the transformation pipeline again on already-loaded classes. Use this after attaching at runtime to instrument classes that loaded before the agent:

```java
// Retransform a specific class
try {
    inst.retransformClasses(String.class, Integer.class);
} catch (UnmodifiableClassException e) {
    // Some classes cannot be retransformed (e.g., bootstrap classes in some configs)
}

// Retransform all loaded application classes
Class<?>[] allClasses = inst.getAllLoadedClasses();
List<Class<?>> toRetransform = new ArrayList<>();
for (Class<?> c : allClasses) {
    if (c.getName().startsWith("com.myapp.") && inst.isModifiableClass(c)) {
        toRetransform.add(c);
    }
}

if (!toRetransform.isEmpty()) {
    inst.retransformClasses(toRetransform.toArray(new Class[0]));
}
```

**Retransform vs Redefine:**

```
retransformClasses:
  - Goes through all registered retransformable ClassFileTransformers
  - Original bytecode is the starting point for each retransformation
  - Use: when transformers should re-run on loaded classes
  - Limitation: cannot add/remove fields or change class structure

redefineClasses:
  - Bypasses ClassFileTransformer pipeline
  - You supply the new bytecode directly
  - Use: hot-patching a specific class with known new bytecode
  - Limitation: same structural constraints as retransform
  - Example: IDE hot swap, JRebel, Spring DevTools
```

### 4.4 `redefineClasses(ClassDefinition...)`

```java
// Load new bytecode from file (e.g., recompiled class)
byte[] newBytecode = Files.readAllBytes(Path.of("MyService.class"));
ClassDefinition def = new ClassDefinition(MyService.class, newBytecode);

try {
    inst.redefineClasses(def);
    System.out.println("MyService hot-swapped successfully");
} catch (ClassNotFoundException e) {
    System.err.println("Class not found: " + e.getMessage());
} catch (UnmodifiableClassException e) {
    System.err.println("Cannot redefine: " + e.getMessage());
}

// Redefine multiple classes atomically
ClassDefinition[] defs = {
    new ClassDefinition(ServiceA.class, bytesA),
    new ClassDefinition(ServiceB.class, bytesB)
};
inst.redefineClasses(defs); // all-or-nothing: either all succeed or none change
```

### 4.5 `getAllLoadedClasses()` — Inspect What's Loaded

```java
// Diagnostic: print all loaded classes from a specific package
Class<?>[] allClasses = inst.getAllLoadedClasses();
System.out.println("Total loaded classes: " + allClasses.length);

// Group by ClassLoader
Map<String, Long> byLoader = Arrays.stream(allClasses)
    .collect(Collectors.groupingBy(
        c -> c.getClassLoader() == null ? "bootstrap" : c.getClassLoader().getClass().getName(),
        Collectors.counting()
    ));
byLoader.forEach((loader, count) ->
    System.out.printf("  %-60s: %d classes%n", loader, count));

// Find duplicate class names (classloader conflicts)
Map<String, List<Class<?>>> byName = Arrays.stream(allClasses)
    .collect(Collectors.groupingBy(Class::getName));
byName.entrySet().stream()
    .filter(e -> e.getValue().size() > 1)
    .forEach(e -> System.out.println("DUPLICATE: " + e.getKey()
        + " loaded by " + e.getValue().size() + " classloaders"));
```

### 4.6 `getObjectSize(Object)` — Shallow Object Size

```java
// Returns the "shallow" size of an object — just the object header + fields
// Does NOT include the size of referenced objects
long stringSize = inst.getObjectSize("hello world");
System.out.println("String object size: " + stringSize + " bytes");
// Typically 24 bytes (header + char[] ref + int hash + int coder)
// The actual char[] data is NOT included

// Measure all sizes
long integerSize  = inst.getObjectSize(Integer.valueOf(42));  // ~16 bytes
long longSize     = inst.getObjectSize(Long.valueOf(42L));    // ~24 bytes
long arrayRefSize = inst.getObjectSize(new int[]{1, 2, 3});  // ~24 bytes (header + length + 3 ints)

// Deep size requires walking the object graph yourself:
public static long deepSize(Instrumentation inst, Object root) {
    Set<Object> visited = Collections.newSetFromMap(new IdentityHashMap<>());
    Queue<Object> queue = new ArrayDeque<>();
    queue.add(root);
    long total = 0;

    while (!queue.isEmpty()) {
        Object obj = queue.poll();
        if (obj == null || !visited.add(obj)) continue;
        total += inst.getObjectSize(obj);

        // Enqueue all referenced objects
        Class<?> c = obj.getClass();
        while (c != null) {
            for (Field f : c.getDeclaredFields()) {
                if (!Modifier.isStatic(f.getModifiers())
                        && !f.getType().isPrimitive()) {
                    f.setAccessible(true);
                    try { queue.add(f.get(obj)); }
                    catch (IllegalAccessException ignored) {}
                }
            }
            c = c.getSuperclass();
        }
    }
    return total;
}
```

---

## 5. `ClassFileTransformer` — Intercepting Class Loading

### 5.1 The Interface

```java
@FunctionalInterface
public interface ClassFileTransformer {
    /**
     * Called by the JVM every time a class is about to be loaded or retransformed.
     *
     * @param loader              the classloader loading this class (null = bootstrap)
     * @param className           internal name with slashes: "com/myapp/UserService"
     * @param classBeingRedefined the Class object if retransforming, null if new load
     * @param protectionDomain    the protection domain of the class
     * @param classfileBuffer     the raw .class file bytes (original, from disk or network)
     *
     * @return  modified bytes to use instead of classfileBuffer,
     *          OR null to leave the class unchanged (most common return value)
     */
    byte[] transform(
        ClassLoader loader,
        String className,              // e.g., "com/myapp/UserService" NOT "com.myapp.UserService"
        Class<?> classBeingRedefined,  // null for initial load
        ProtectionDomain protectionDomain,
        byte[] classfileBuffer         // the original bytecode
    ) throws IllegalClassFormatException;
}
```

### 5.2 The Filtering Pattern — Only Touch Target Classes

**The most important rule:** Return `null` for any class you don't want to modify. This is critical for performance — if your transformer accidentally parses and processes every single class, it will massively slow down JVM startup.

```java
public class SelectiveTransformer implements ClassFileTransformer {

    private static final String TARGET_PREFIX = "com/myapp/service/";

    @Override
    public byte[] transform(ClassLoader loader, String className,
                             Class<?> classBeingRedefined,
                             ProtectionDomain protectionDomain,
                             byte[] classfileBuffer) {

        // FILTER 1: null means "pass through unchanged" — do this for everything else
        if (className == null) return null;

        // FILTER 2: Only instrument our application classes
        if (!className.startsWith(TARGET_PREFIX)) return null;

        // FILTER 3: Skip inner classes / anonymous classes if desired
        if (className.contains("$")) return null;

        // FILTER 4: Skip already-processed classes (idempotency check)
        // (implement with a Set<String> of already-transformed class names)

        // Now we know we want to transform this class
        try {
            return transformClass(className, classfileBuffer);
        } catch (Exception e) {
            System.err.println("[Transformer] Failed to transform " + className
                + ": " + e.getMessage());
            // CRITICAL: return null on failure — don't crash the class load
            return null;
        }
    }

    private byte[] transformClass(String className, byte[] original) {
        // ... use ASM or Byte Buddy to modify bytes ...
        return modified;
    }
}
```

### 5.3 A Complete Minimal Transformer — Timing Every Method

```java
import org.objectweb.asm.*;
import org.objectweb.asm.commons.*;
import java.lang.instrument.*;
import java.security.ProtectionDomain;

public class TimingTransformer implements ClassFileTransformer {

    @Override
    public byte[] transform(ClassLoader loader, String className,
                             Class<?> classBeingRedefined,
                             ProtectionDomain protectionDomain,
                             byte[] bytes) {

        // Filter: only instrument application classes
        if (className == null || !className.startsWith("com/myapp/")) return null;

        try {
            ClassReader cr = new ClassReader(bytes);
            ClassWriter cw = new ClassWriter(cr, ClassWriter.COMPUTE_FRAMES);
            ClassVisitor cv = new TimingClassVisitor(cw, className);
            cr.accept(cv, ClassReader.EXPAND_FRAMES);
            return cw.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
            return null; // return null = use original bytes
        }
    }
}

class TimingClassVisitor extends ClassVisitor {
    private final String className;

    TimingClassVisitor(ClassVisitor cv, String className) {
        super(Opcodes.ASM9, cv);
        this.className = className;
    }

    @Override
    public MethodVisitor visitMethod(int access, String name, String desc,
                                      String signature, String[] exceptions) {
        MethodVisitor mv = super.visitMethod(access, name, desc, signature, exceptions);

        // Skip constructors, static initializers, abstract/native methods
        if (name.equals("<init>") || name.equals("<clinit>") || mv == null) return mv;
        if ((access & Opcodes.ACC_ABSTRACT) != 0) return mv;
        if ((access & Opcodes.ACC_NATIVE) != 0) return mv;

        return new TimingMethodVisitor(mv, className, name, desc, access);
    }
}

class TimingMethodVisitor extends AdviceAdapter {
    private final String className;
    private final String methodName;
    private int startTimeVar; // local variable slot for start time

    TimingMethodVisitor(MethodVisitor mv, String className,
                         String methodName, String desc, int access) {
        super(Opcodes.ASM9, mv, access, methodName, desc);
        this.className  = className;
        this.methodName = methodName;
    }

    @Override
    protected void onMethodEnter() {
        // Inject: long _startTime = System.nanoTime();
        startTimeVar = newLocal(Type.LONG_TYPE);
        mv.visitMethodInsn(Opcodes.INVOKESTATIC,
            "java/lang/System", "nanoTime", "()J", false);
        mv.visitVarInsn(Opcodes.LSTORE, startTimeVar);
    }

    @Override
    protected void onMethodExit(int opcode) {
        if (opcode == Opcodes.ATHROW) return; // skip on exception exit

        // Inject:
        // long _elapsed = System.nanoTime() - _startTime;
        // System.out.println("TIMING " + className + "." + methodName + ": " + _elapsed + "ns");
        mv.visitMethodInsn(Opcodes.INVOKESTATIC,
            "java/lang/System", "nanoTime", "()J", false);
        mv.visitVarInsn(Opcodes.LLOAD, startTimeVar);
        mv.visitInsn(Opcodes.LSUB);
        // For brevity: print to System.out using a helper (real code would use SLF4J)
        // ... (see Section 6 for full ASM instruction sequences)
    }
}
```

---

## 6. Bytecode Manipulation — ASM

### 6.1 ASM Overview

ASM is the de-facto standard for bytecode manipulation. It uses the **Visitor pattern**: `ClassReader` pushes events to `ClassVisitor`, which in turn calls `MethodVisitor`, `FieldVisitor`, etc.

```xml
<!-- Maven dependency -->
<dependency>
    <groupId>org.ow2.asm</groupId>
    <artifactId>asm</artifactId>
    <version>9.7</version>
</dependency>
<dependency>
    <groupId>org.ow2.asm</groupId>
    <artifactId>asm-commons</artifactId>
    <version>9.7</version>
</dependency>
```

### 6.2 The Read → Modify → Write Pattern

```java
// Always: ClassReader → ClassVisitor chain → ClassWriter
public byte[] addLoggingToMethod(byte[] originalBytes, String targetMethod) {
    ClassReader cr = new ClassReader(originalBytes);

    // ClassWriter options:
    // 0                  — no automatic computation (you must maintain stack/frames)
    // COMPUTE_MAXS       — auto-compute max stack and max locals
    // COMPUTE_FRAMES     — auto-compute all stack map frames (needed for Java 7+)
    ClassWriter cw = new ClassWriter(cr, ClassWriter.COMPUTE_FRAMES);

    // Build the visitor chain: cr → your visitor → cw
    ClassVisitor cv = new AddLoggingVisitor(cw, targetMethod);

    // Process
    cr.accept(cv, ClassReader.EXPAND_FRAMES);

    // Result
    return cw.toByteArray();
}
```

### 6.3 `AdviceAdapter` — Injecting at Method Entry/Exit

`AdviceAdapter` (from `asm-commons`) handles the tricky details of method entry/exit detection — particularly for constructors (which require a `super()` call before any other action):

```java
import org.objectweb.asm.commons.AdviceAdapter;

class LoggingMethodVisitor extends AdviceAdapter {
    private final String label;

    LoggingMethodVisitor(MethodVisitor mv, int access, String name, String desc) {
        super(Opcodes.ASM9, mv, access, name, desc);
        this.label = name + desc;
    }

    @Override
    protected void onMethodEnter() {
        // Called at method entry (after super() for constructors)
        // This is where you inject "before" code

        // Inject: System.out.println("ENTER: " + label)
        mv.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
        mv.visitLdcInsn("ENTER: " + label);
        mv.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream",
            "println", "(Ljava/lang/String;)V", false);
    }

    @Override
    protected void onMethodExit(int opcode) {
        // Called at method exit (before each return instruction, and before athrow)
        // opcode: RETURN, ARETURN, IRETURN, LRETURN, FRETURN, DRETURN, or ATHROW

        if (opcode == ATHROW) {
            // Method is exiting due to exception
            mv.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
            mv.visitLdcInsn("EXIT (exception): " + label);
            mv.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream",
                "println", "(Ljava/lang/String;)V", false);
        } else {
            mv.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
            mv.visitLdcInsn("EXIT: " + label);
            mv.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream",
                "println", "(Ljava/lang/String;)V", false);
        }
    }
}
```

### 6.4 Injecting a Try-Catch for Exception Capture

```java
// Use GeneratorAdapter for easier bytecode generation
import org.objectweb.asm.commons.GeneratorAdapter;

class ExceptionCapturingMethodAdapter extends AdviceAdapter {
    private Label tryStart;
    private Label tryEnd;
    private Label catchBlock;

    ExceptionCapturingMethodAdapter(MethodVisitor mv, int access, String name, String desc) {
        super(Opcodes.ASM9, mv, access, name, desc);
    }

    @Override
    protected void onMethodEnter() {
        tryStart = newLabel();
        tryEnd   = newLabel();
        catchBlock = newLabel();

        // Mark try block start
        visitLabel(tryStart);
    }

    @Override
    public void visitMaxs(int maxStack, int maxLocals) {
        // Mark try block end and define exception handler
        visitLabel(tryEnd);

        // Add exception handler: catch (Throwable t) { handle; rethrow; }
        visitTryCatchBlock(tryStart, tryEnd, catchBlock, "java/lang/Throwable");

        visitLabel(catchBlock);
        // Stack has the exception on top here
        // Duplicate it (we'll print it then rethrow)
        visitInsn(DUP);
        visitFieldInsn(GETSTATIC, "java/lang/System", "err", "Ljava/io/PrintStream;");
        visitInsn(SWAP);
        visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream",
            "println", "(Ljava/lang/Object;)V", false);
        visitInsn(ATHROW); // rethrow

        super.visitMaxs(maxStack, maxLocals);
    }
}
```

---

## 7. Bytecode Manipulation — Byte Buddy

### 7.1 Why Byte Buddy

ASM is powerful but verbose. Byte Buddy provides a high-level DSL over ASM that makes agent development dramatically simpler, especially for the common patterns of APM agents:

```xml
<!-- Maven dependency -->
<dependency>
    <groupId>net.bytebuddy</groupId>
    <artifactId>byte-buddy</artifactId>
    <version>1.14.18</version>
</dependency>
<dependency>
    <groupId>net.bytebuddy</groupId>
    <artifactId>byte-buddy-agent</artifactId>
    <version>1.14.18</version>
</dependency>
```

### 7.2 `AgentBuilder` — The Byte Buddy Agent DSL

```java
import net.bytebuddy.agent.builder.AgentBuilder;
import net.bytebuddy.asm.Advice;
import net.bytebuddy.matcher.ElementMatchers;
import java.lang.instrument.Instrumentation;

public class ByteBuddyAgent {

    public static void premain(String args, Instrumentation inst) {
        new AgentBuilder.Default()
            // Step 1: Select which classes to instrument
            .type(ElementMatchers.nameStartsWith("com.myapp.service"))

            // Step 2: Define what to do with matched classes
            .transform((builder, typeDescription, classLoader, module, domain) ->
                builder
                    // Step 3: Select which methods to instrument
                    .method(ElementMatchers.isPublic()
                        .and(ElementMatchers.not(ElementMatchers.isConstructor())))

                    // Step 4: Apply advice
                    .intercept(Advice.to(TimingAdvice.class))
            )

            // Step 5: Install into the JVM
            .installOn(inst);
    }
}
```

### 7.3 `@Advice` — The Clean Way to Inject Code

`@Advice` lets you write the "before" and "after" code as plain Java methods in a regular class. Byte Buddy copies (inlines) the advice bytecode into the target method — it does NOT call your advice as a method:

```java
public class TimingAdvice {

    // @OnMethodEnter: injected at method entry
    // Returned value is passed as parameter to @OnMethodExit
    @Advice.OnMethodEnter
    public static long onEnter(@Advice.Origin String methodSignature) {
        System.out.println("ENTER: " + methodSignature);
        return System.nanoTime(); // return value passed to onExit
    }

    // @OnMethodExit: injected at method exit (all return paths including exceptions)
    @Advice.OnMethodExit(onThrowable = Throwable.class) // also intercept exceptions
    public static void onExit(
            @Advice.Origin String methodSignature,
            @Advice.Enter long startTime,             // from @OnMethodEnter return
            @Advice.Return Object returnValue,        // the return value (null for void)
            @Advice.Thrown Throwable throwable) {     // non-null if exception thrown

        long elapsed = System.nanoTime() - startTime;
        if (throwable != null) {
            System.out.printf("EXIT (exception): %s threw %s [%dns]%n",
                methodSignature, throwable.getClass().getSimpleName(), elapsed);
        } else {
            System.out.printf("EXIT: %s returned %s [%dns]%n",
                methodSignature, returnValue, elapsed);
        }
    }
}
```

### 7.4 `@Advice` Annotations Reference

```java
public class ComprehensiveAdvice {

    @Advice.OnMethodEnter(suppress = Throwable.class) // suppress exceptions from advice
    public static void enter(
        @Advice.Origin String          signature,      // e.g., "com.myapp.Foo#bar"
        @Advice.Origin Class<?>        declaringClass, // the class containing the method
        @Advice.Origin Method          method,         // the Method object
        @Advice.This Object            thiz,           // 'this' (null for static)
        @Advice.Argument(0) String     firstArg,       // first parameter
        @Advice.AllArguments Object[]  allArgs,        // all parameters as array
        @Advice.Local("key") Object    localVar        // injects a new local variable
    ) {
        // Assign local variable (passed to @OnMethodExit via @Local)
        // ...
    }

    @Advice.OnMethodExit(onThrowable = Throwable.class, suppress = Throwable.class)
    public static void exit(
        @Advice.Return(readOnly = false) Object returnVal, // can modify return value
        @Advice.Thrown(readOnly = false) Throwable thrown, // can suppress exception
        @Advice.Local("key") Object localVar               // the value set in onEnter
    ) {
        // Modify return value:
        // returnVal = "modified";   // if readOnly = false

        // Suppress exception:
        // thrown = null;            // if readOnly = false — will suppress the exception
    }
}
```

### 7.5 Byte Buddy for APM-Style Instrumentation

```java
public class HttpClientInstrumentation {

    public static void premain(String args, Instrumentation inst) {
        new AgentBuilder.Default()
            // Instrument Apache HttpClient execute method
            .type(ElementMatchers.named("org.apache.http.impl.client.CloseableHttpClient"))
            .transform((builder, type, cl, module, domain) ->
                builder.method(
                    ElementMatchers.named("execute")
                        .and(ElementMatchers.takesArgument(0,
                            ElementMatchers.named("org.apache.http.client.methods.HttpUriRequest")))
                )
                .intercept(Advice.to(HttpClientAdvice.class))
            )
            .with(AgentBuilder.RedefinitionStrategy.RETRANSFORMATION)
            .with(AgentBuilder.InitializationStrategy.NoOp.INSTANCE)
            .installOn(inst);
    }
}

public class HttpClientAdvice {

    @Advice.OnMethodEnter
    public static long enter(@Advice.Argument(0) Object request) {
        // In real APM agent: start a span, record URL, method, etc.
        System.out.println("[APM] HTTP request starting: " + request);
        return System.currentTimeMillis();
    }

    @Advice.OnMethodExit(onThrowable = Throwable.class)
    public static void exit(
            @Advice.Enter long startTime,
            @Advice.Return Object response,
            @Advice.Thrown Throwable throwable) {
        long duration = System.currentTimeMillis() - startTime;
        if (throwable != null) {
            System.out.println("[APM] HTTP request failed after " + duration + "ms: " + throwable);
        } else {
            System.out.println("[APM] HTTP request completed in " + duration + "ms: " + response);
        }
    }
}
```

---

## 8. `MANIFEST.MF` Attributes — Complete Reference

### 8.1 All Agent-Related Attributes

```
Manifest-Version: 1.0

# ── Load-time agent (premain) ──────────────────────────────────────────
Premain-Class: com.myagent.AgentMain
  # The class containing the premain() method
  # Required for -javaagent: to work

# ── Runtime-attach agent (agentmain) ──────────────────────────────────
Agent-Class: com.myagent.AgentMain
  # The class containing the agentmain() method
  # Required for VirtualMachine.loadAgent() to work
  # Can be the same class as Premain-Class

# ── Retransformation support ───────────────────────────────────────────
Can-Retransform-Classes: true
  # Default: false
  # Set to true if your transformers are registered with canRetransform=true
  # AND you will call inst.retransformClasses()
  # Required for agents that need to instrument already-loaded classes

# ── Redefinition support ───────────────────────────────────────────────
Can-Redefine-Classes: true
  # Default: false
  # Set to true if you call inst.redefineClasses()
  # Required for hot-swap agents

# ── Bootstrap classpath addition ───────────────────────────────────────
Boot-Class-Path: helper.jar
  # JAR(s) to add to the bootstrap classloader search path
  # Use when agent classes need to be accessible to all classloaders
  # Relative to agent JAR location
  # Multiple: Boot-Class-Path: helper1.jar helper2.jar

# ── Native method prefix ───────────────────────────────────────────────
Can-Set-Native-Method-Prefix: true
  # Required if calling inst.setNativeMethodPrefix()
  # Rarely needed
```

### 8.2 Complete `MANIFEST.MF` Example

```
Manifest-Version: 1.0
Premain-Class: com.myagent.MyAgent
Agent-Class: com.myagent.MyAgent
Can-Retransform-Classes: true
Can-Redefine-Classes: true
Boot-Class-Path: myagent-bootstrap.jar
```

**Critical formatting rules:**

```
1. The file MUST end with a newline — if the last line has no trailing newline,
   the JVM silently ignores it, leading to "Premain-Class not found" errors.

2. Each header: value pair must be on its own line.

3. Continuation lines start with a SPACE (for long values), but
   Boot-Class-Path can have space-separated values on one line.

4. No spaces around the colon: "Premain-Class: com.myagent.MyAgent" ✓
                                "Premain-Class:com.myagent.MyAgent" ✗ (no space after colon)
```

### 8.3 `Boot-Class-Path` — When You Need It

The bootstrap classloader loads the JDK's core classes. Your transformer typically runs in the app classloader. If your transformer references classes that are not visible to the classloader of the class being transformed, you get `NoClassDefFoundError`:

```java
// Problem: Your helper class is in the agent JAR (app classloader)
// But you're transforming java.lang.String (loaded by bootstrap classloader)
// The transformed String bytecode references YourHelper → NCDFE at runtime

// Solution: put classes referenced by transformed bytecode on the bootstrap path
Boot-Class-Path: agent-helpers.jar
// Now YourHelper is visible to ALL classloaders, including bootstrap
```

---

## 9. Building and Packaging an Agent JAR

### 9.1 Maven Build Configuration

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <configuration>
                <archive>
                    <manifestEntries>
                        <Premain-Class>com.myagent.MyAgent</Premain-Class>
                        <Agent-Class>com.myagent.MyAgent</Agent-Class>
                        <Can-Retransform-Classes>true</Can-Retransform-Classes>
                        <Can-Redefine-Classes>true</Can-Redefine-Classes>
                    </manifestEntries>
                </archive>
            </configuration>
        </plugin>

        <!-- Fat JAR: shade all dependencies into the agent JAR -->
        <!-- Required because agent needs ASM/ByteBuddy at the right classloader level -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals><goal>shade</goal></goals>
                    <configuration>
                        <!-- Relocate ASM to avoid conflicts with app's ASM version -->
                        <relocations>
                            <relocation>
                                <pattern>org.objectweb.asm</pattern>
                                <shadedPattern>com.myagent.shaded.asm</shadedPattern>
                            </relocation>
                            <relocation>
                                <pattern>net.bytebuddy</pattern>
                                <shadedPattern>com.myagent.shaded.bytebuddy</shadedPattern>
                            </relocation>
                        </relocations>
                        <!-- Keep the manifest entries through shading -->
                        <transformers>
                            <transformer implementation=
                                "org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <manifestEntries>
                                    <Premain-Class>com.myagent.MyAgent</Premain-Class>
                                    <Agent-Class>com.myagent.MyAgent</Agent-Class>
                                    <Can-Retransform-Classes>true</Can-Retransform-Classes>
                                </manifestEntries>
                            </transformer>
                        </transformers>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

**Why shade + relocate?** If your agent uses ASM version X and the application also uses ASM version Y, there will be a classloader conflict. Relocation renames your ASM packages to `com.myagent.shaded.asm.*` so they don't conflict.

### 9.2 Verifying the Manifest

```bash
# Inspect the manifest inside a JAR
jar tf myagent.jar | grep MANIFEST
unzip -p myagent.jar META-INF/MANIFEST.MF

# Expected output:
# Manifest-Version: 1.0
# Premain-Class: com.myagent.MyAgent
# Agent-Class: com.myagent.MyAgent
# Can-Retransform-Classes: true
# Can-Redefine-Classes: true
#                                ← trailing newline required
```

---

## 10. Real-World Agent Use Cases

### 10.1 APM Tools — Datadog, New Relic, Elastic APM

These agents auto-instrument application frameworks without any code changes:

```bash
# Datadog APM agent
java -javaagent:/opt/datadog/dd-java-agent.jar \
     -Ddd.service=myapp \
     -Ddd.env=production \
     -Ddd.version=1.2.3 \
     com.myapp.Main

# New Relic agent
java -javaagent:/opt/newrelic/newrelic.jar \
     -Dnewrelic.config.file=/etc/newrelic/newrelic.yml \
     com.myapp.Main
```

**What they instrument:**
```
HTTP servers:    Spring MVC, Tomcat, Jetty, Netty — intercept request/response
HTTP clients:    OkHttp, Apache HttpClient — trace outbound calls
JDBC:            All JDBC drivers — capture query SQL, duration, row count
Messaging:       Kafka, RabbitMQ, SQS — trace message producers/consumers
Caching:         Redis (Jedis, Lettuce), Memcached — cache hit/miss rate
Database ORMs:   Hibernate, MyBatis — ORM-level span creation
Custom metrics:  Automatically create traces across service boundaries
```

**How they work (simplified):**
1. `premain()` registers `ClassFileTransformer` and Byte Buddy `AgentBuilder`
2. For each framework class (e.g., `DispatcherServlet.doDispatch()`), inject entry/exit advice
3. At entry: start a new span, capture request metadata, inject trace context into thread locals
4. At exit: finish the span, record duration, status code, any exceptions
5. Spans sent asynchronously to APM backend (Datadog Agent, New Relic Collector, etc.)

### 10.2 JaCoCo — Code Coverage

JaCoCo injects counter probes into bytecode to track which lines and branches execute:

```bash
# JaCoCo agent — attach for test coverage
java -javaagent:jacoco-agent.jar=destfile=coverage.exec,includes=com.myapp.* \
     com.myapp.tests.TestRunner

# Coverage data written to coverage.exec on JVM exit
# Analyzed by JaCoCo report tool to produce HTML/XML coverage reports
```

**How JaCoCo works:**
1. For each Java statement and branch, JaCoCo inserts a boolean counter (a probe)
2. Probes are stored in a static boolean[] on each class: `boolean[] $jacocoData`
3. When a line executes, the corresponding probe is set to `true`
4. At JVM exit, probes are written to `destfile` (`.exec` file)
5. JaCoCo report tool reads `.exec` and class files to calculate coverage %

### 10.3 Mockito Inline Mocking — Mocking `final` Classes

Mockito uses an agent to allow mocking of `final` classes and methods:

```java
// Before Java agent: this throws MockitoException — cannot mock final class
final class PaymentService {
    public final String process(String payment) { return "processed"; }
}
PaymentService mock = Mockito.mock(PaymentService.class); // THROWS without agent

// With MockMaker inline (uses agent to redefine the class):
// mockito-extensions/org.mockito.plugins.MockMaker: mock-maker-inline
PaymentService mock = Mockito.mock(PaymentService.class); // works!
when(mock.process("payment")).thenReturn("mocked");
```

**How Mockito inline works:**
1. During test startup, Mockito loads an agent via Byte Buddy Agent
2. When `Mockito.mock(FinalClass.class)` is called, the agent uses `redefineClasses()` to replace `FinalClass`'s bytecode with a subclass-friendly version (removes `final` modifier in bytecode)
3. Mockito can now create a subclass proxy of the "un-finalized" class
4. After the test, the class is redefined back to its original form

### 10.4 Async Profiler — CPU and Allocation Profiling

Async Profiler attaches via the Attach API to sample CPU usage and allocations with very low overhead:

```bash
# Attach to running JVM (via agentmain + Attach API)
./profiler.sh -e cpu -d 30 -f flamegraph.html <pid>

# Programmatic attach:
VirtualMachine vm = VirtualMachine.attach(String.valueOf(pid));
vm.loadAgent("/path/to/libasyncProfiler.so", "start,event=cpu,file=out.jfr");
vm.detach();
```

**What Async Profiler instruments:**
- **CPU profiling**: Uses `AsyncGetCallTrace` JVM TI API to sample stacks without safepoints (no bias toward safepoint-heavy code)
- **Allocation profiling**: Uses TLAB (Thread-Local Allocation Buffer) event notifications
- **Lock profiling**: Uses `MonitorEnter` JVM TI events
- **Wall-clock profiling**: Times all threads including those blocked on I/O

### 10.5 JRebel / Spring DevTools — Hot Reload

Hot reload agents watch the filesystem for class file changes and redefine them in the running JVM:

```bash
# JRebel: commercial hot-reload agent
java -javaagent:/path/to/jrebel.jar -Drebel.log=true com.myapp.Main

# Spring DevTools: built-in restart mechanism (uses two classloaders)
# Add to pom.xml:
# <dependency>
#   <groupId>org.springframework.boot</groupId>
#   <artifactId>spring-boot-devtools</artifactId>
# </dependency>
```

**JRebel approach:**
1. `premain()` wraps every classloader with a `ClassFileTransformer`
2. Transformer adds a check hook to every class: "has this class been updated on disk?"
3. When files change, JRebel uses `redefineClasses()` to swap in new bytecode in place
4. Unlike Spring DevTools restart (full context restart), JRebel patches individual classes
5. Method body changes work; structural changes (new fields) require restart

---

## 11. Limitations, Security, and Java 9+ Module System

### 11.1 What Retransform/Redefine Cannot Change

```
ALLOWED by retransformClasses / redefineClasses:
  ✓ Method body changes (any bytecode within a method)
  ✓ Constant pool entries
  ✓ Attribute changes (annotations, debug info, etc.)

NOT ALLOWED (throws UnsupportedOperationException):
  ✗ Add or remove fields
  ✗ Add or remove methods
  ✗ Change a method's signature (name, parameter types, return type)
  ✗ Change a class's superclass
  ✗ Add or remove implemented interfaces
  ✗ Change access modifiers of class (public → private etc.)

These restrictions exist because existing compiled references to a class
are baked into other classes' bytecode. Changing the structure would
require recompiling all callers.
```

### 11.2 Java 9+ Module System Restrictions

The module system restricts agent access to non-exported packages:

```bash
# Agents accessing non-public APIs need --add-opens
java -javaagent:myagent.jar \
     --add-opens java.base/java.lang=ALL-UNNAMED \
     --add-opens java.base/java.util=ALL-UNNAMED \
     com.myapp.Main

# Agents in named modules need module-info adjustments
# Most agents use unnamed module (JAR without module-info.java)
# which gets --add-opens via their own manifest or startup script
```

**In `premain()`, you can programmatically open modules:**

```java
public static void premain(String args, Instrumentation inst) {
    // Open java.lang to allow deep reflection
    Module javaLang = String.class.getModule();
    Module unnamed  = AgentMain.class.getModule();
    // inst.redefineModule can open packages in Java 9+
    // (requires Can-Redefine-Classes: true or the module API)
}
```

### 11.3 Bootstrap vs System vs App Classloader

```
Bootstrap ClassLoader         → loads java.*, javax.*
System ClassLoader            → loads -classpath JARs
App ClassLoader               → loads your application
   (inherits from System)

Agent JAR classloader levels:
  - Agent code runs in the system/app classloader by default
  - If you need agent helper classes visible to all class loads:
    use Boot-Class-Path in MANIFEST.MF
  - If agent instruments JDK classes (java.lang, etc.):
    helper classes must be on bootstrap path, or use Unsafe tricks
```

---

## 12. Quick Reference Cheat Sheet

### Agent Entry Points

```java
// Load-time: runs before main()
public static void premain(String agentArgs, Instrumentation inst) { }

// Runtime attach: runs in already-running JVM
public static void agentmain(String agentArgs, Instrumentation inst) { }
```

### Instrumentation API Key Methods

```java
// Register transformer for future class loads
inst.addTransformer(transformer, true);          // true = retransformable

// Re-run transformers on already-loaded classes
inst.retransformClasses(MyClass.class, Other.class);

// Replace bytecode directly (bypasses transformers)
inst.redefineClasses(new ClassDefinition(MyClass.class, newBytes));

// Inspect loaded classes
inst.getAllLoadedClasses();                        // all classes
inst.isModifiableClass(SomeClass.class);          // can we retransform it?

// Memory sizing (shallow)
inst.getObjectSize(someObject);
```

### `ClassFileTransformer` Template

```java
public class MyTransformer implements ClassFileTransformer {
    @Override
    public byte[] transform(ClassLoader loader, String className,
                             Class<?> classBeingRedefined,
                             ProtectionDomain protectionDomain,
                             byte[] classfileBuffer) {
        // className uses slashes: "com/myapp/Foo" (not dots)
        if (className == null || !className.startsWith("com/myapp/")) return null; // pass through

        try {
            ClassReader cr = new ClassReader(classfileBuffer);
            ClassWriter cw = new ClassWriter(cr, ClassWriter.COMPUTE_FRAMES);
            cr.accept(new MyClassVisitor(cw), ClassReader.EXPAND_FRAMES);
            return cw.toByteArray();
        } catch (Exception e) {
            return null; // ALWAYS return null on error — don't break class loading
        }
    }
}
```

### Byte Buddy Agent Template

```java
public class MyByteBuddyAgent {
    public static void premain(String args, Instrumentation inst) {
        new AgentBuilder.Default()
            .type(ElementMatchers.nameStartsWith("com.myapp."))
            .transform((builder, type, cl, module, domain) ->
                builder.method(ElementMatchers.isPublic()
                               .and(ElementMatchers.not(ElementMatchers.isConstructor())))
                       .intercept(Advice.to(MyAdvice.class))
            )
            .installOn(inst);
    }
}

public class MyAdvice {
    @Advice.OnMethodEnter
    public static long enter(@Advice.Origin String method) {
        return System.nanoTime();
    }

    @Advice.OnMethodExit(onThrowable = Throwable.class)
    public static void exit(@Advice.Enter long start, @Advice.Thrown Throwable t) {
        System.out.printf("[%s] %s in %dns%n",
            t == null ? "OK" : "ERR",
            "method",
            System.nanoTime() - start);
    }
}
```

### MANIFEST.MF Minimum

```
Manifest-Version: 1.0
Premain-Class: com.myagent.Agent
Agent-Class: com.myagent.Agent
Can-Retransform-Classes: true
Can-Redefine-Classes: true

```
*(trailing blank line required)*

### Attach API Template

```java
VirtualMachine vm = VirtualMachine.attach(pidString);
try {
    vm.loadAgent("/path/to/agent.jar", "optionalArgs");
} finally {
    vm.detach();  // ALWAYS detach
}
```

### Real-World Agent Use Cases Summary

| Agent | Mechanism | What It Does |
|---|---|---|
| Datadog / New Relic | `premain` + Byte Buddy `@Advice` | Auto-instrument HTTP/JDBC/messaging |
| JaCoCo | `premain` + ASM probe injection | Insert coverage counters |
| Mockito inline | `agentmain` + `redefineClasses` | Remove `final` from target classes |
| Async Profiler | `agentmain` via Attach API | Low-overhead CPU/alloc sampling |
| JRebel | `premain` + `redefineClasses` on change | Hot-swap class bodies on file change |
| Spring DevTools | Classloader restart (lighter approach) | Restart Spring context on change |

### Key Rules to Remember

1. **Return `null` from transformer to pass through unchanged** — never return the original `classfileBuffer`.
2. **Filter aggressively in `transform()`** — transforming every class dramatically slows startup.
3. **Return `null` on errors** — never let transformer exceptions propagate; they break class loading.
4. **className uses slashes** — `"com/myapp/Foo"` not `"com.myapp.Foo"` in `transform()`.
5. **Copy before validate in compact constructor** — N/A here; instead: shade + relocate ASM/Byte Buddy to avoid classpath conflicts with the app.
6. **`MANIFEST.MF` must end with a newline** — missing trailing newline silently breaks agent loading.
7. **`Boot-Class-Path`** — needed when transformed bytecode references your helper classes.
8. **`Can-Retransform-Classes: true`** — required in manifest AND `addTransformer(t, true)` for retransformation to work.
9. **`retransform` re-runs transformers; `redefine` bypasses them** — choose based on whether your transformer pipeline should run.
10. **Byte Buddy `@Advice` inlines code, not calls** — advice methods are copied into target, so `System.out` in advice literally becomes part of the target method's bytecode.

---

*End of Java Agents & Instrumentation Study Guide — Module 8*
