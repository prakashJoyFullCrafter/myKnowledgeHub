package com.pepbits.core.modernjava.l01.patthernmatching;

public class InstanceofExample {

    public static void main(String[] args) {


        InstanceofExample instanceOfExample = new InstanceofExample();

        System.out.println("******************Traditional instanceof******************");
        instanceOfExample.traditionalInstanceOf();

        System.out.println("******************New style instanceof******************");
        instanceOfExample.newStyleInstanceOf();
        System.out.println("******************Pattern variable in compound statement******************");
        instanceOfExample.patternVariableInCompoundStatement();
        System.out.println("******************Flow scoping******************");
        instanceOfExample.flowSCoping(null);


        System.out.println("----------------------------");


    }


    public void traditionalInstanceOf() {

        // ─── BEFORE Java 16 (Traditional approach) ───────────────────────────────
        Object obj = "Hello, World!";
        // Step 1: type check
        if (obj instanceof String) {
            // Step 2: explicit cast (redundant – the check already proved it)
            String s = (String) obj;
            // Step 3: use the value
            System.out.println(s.toUpperCase()); // "HELLO, WORLD!"
        }
        // The cast is provably safe but the compiler cannot remove it for you
        // so it clutters every such block throughout a real codebase.

    }

    public void newStyleInstanceOf() {

        // ─── AFTER Java 16 (Pattern matching) ────────────────────────────────────
        Object obj = "Hello, World!";
        // Single expression: check + bind in one shot
        if (obj instanceof String s) {
            // 's' is already bound and typed as String – no cast needed
            System.out.println(s.toUpperCase()); // "HELLO, WORLD!"
            System.out.println(s.length());      // 13
        }
        // The pattern variable 's' is NOT in scope outside the if-block
        // (Compiler enforces this through "flow scoping" – see 1.4)

    }

    public void patternVariableInCompoundStatement() {
        // Using the bound variable in the same condition
        Object obj = "Java 21";
        // 's' is in scope for the right-hand side of && because &
        // short-circuits: if instanceof fails, the RHS is never evaluated.
        if (obj instanceof String s && s.startsWith("Java")) {
            System.out.println("Version string: " + s); // "Version string: Java 21"
        }
        // IMPORTANT: || does NOT work this wa
        // if (obj instanceof String s || s.isEmpty())   // COMPILE ERRO
        // Because if instanceof returns false, 's' would not be bound
        // yet the || would still try to evaluate s.isEmpty().
    }

    public void flowSCoping(Object obj) {
        // ── Positive branch ──────────────────────────────────────────────────
        if (obj instanceof String s) {
            // 's' IS in scope here – pattern was matched
            System.out.println(s.length());
        }
        // 's' is NOT in scope here – outside the if block

        // ── Negation branch ──────────────────────────────────────────────────
        // When you negate the check, the variable is in scope in the ELSE branch
        if (!(obj instanceof String s)) {
            // 's' is NOT in scope – pattern did not match
            System.out.println("Not a string");
        } else {
            // 's' IS in scope – the else proves the pattern matched
            System.out.println(s.toUpperCase());
        }

        // ── Early return guard ────────────────────────────────────────────────
        if (!(obj instanceof String s)) {
            return; // leave method early
        }
        // After the guard, 's' IS in scope for the rest of the method
        // because the compiler proves the only way to reach this line
        // is if the pattern matched.
        System.out.println("Length: " + s.length());


    }
}
