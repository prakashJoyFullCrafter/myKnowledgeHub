package com.pepbits.core.modernjava.l01.patthernmatching;

public class DominanceRulesOrderOfCaseLabels extends RuntimeException {
    public static void main(String[] args) {
        System.out.println("******************Dominance Rules Order of Case Labels******************");
         new DominanceRulesOrderOfCaseLabels().dominanceDemo(123);
         System.out.println("******************Bad example******************");
         new DominanceRulesOrderOfCaseLabels().bad(123);
        }

    public void  dominanceDemo(Object obj) {
        switch (obj) {
            // CORRECT ordering – more specific before more general
            case Integer i  -> System.out.println("Integer: " + i);
            case Number n   -> System.out.println("Other Number: " + n); // matches Long, Float…
            case Object o   -> System.out.println("Any Object: " + o);  // catch-all
        }
    }

    // COMPILE ERROR example:
    void bad(Object obj) {
        switch (obj) {
            case Object o  -> System.out.println(o); // this matches EVERYTHING
         //   case String s  -> System.out.println(s); // DEAD CODE – compile error  Label is dominated by a preceding case label 'Object o'
        }
    }


}
