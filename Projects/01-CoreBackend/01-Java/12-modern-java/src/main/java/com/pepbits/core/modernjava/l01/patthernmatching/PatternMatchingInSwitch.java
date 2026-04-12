package com.pepbits.core.modernjava.l01.patthernmatching;

public class PatternMatchingInSwitch {


    public static void main(String[] args) {
        System.out.println("******************Traditional switch******************");
        System.out.println(new PatternMatchingInSwitch().traditionalSwitch(123));
        System.out.println("******************New style switch******************");
        System.out.println(new PatternMatchingInSwitch().newStyleSwitch(123));

    }


    public  String traditionalSwitch( Object obj) {

        if (obj instanceof Integer i) return "int: " + i;
        else if (obj instanceof Double d) return "double: " + d;
        else if (obj instanceof String s) return "string: " + s;
        else return "unknown";

    }

    public String newStyleSwitch(Object obj) {

        return switch (obj) {
            case Integer i -> "int: " + i;
            case Double d -> "double: " + d;
            case String s -> "string: " + s;
            default -> "unknown";
        };
    }

    public String handlingNullInSwitch(Object obj){
        return switch (obj) {
            case null            -> "null was passed";
            case String s        -> "String: " + s;
            case Integer i       -> "Integer: " + i;
            default     -> "null or other";  // combined label form
            // Note: cannot use case null AND case null,default in same switch
        };

    }
}
