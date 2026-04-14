package arrays;

import java.util.Arrays;

public class JavaArrayExample01 {

    public static void main(String[] args) {
        // Reference semantics — IMPORTANT pitfall
        int[] a = {1, 2, 3};
        int[] b = a;          // b points to the SAME array as a
        b[0] = 99;
        System.out.println(a[0]);  // prints 99 — a was modified too!

// To get an independent copy:
        int[] c = Arrays.copyOf(a, a.length);
        c[0] = 0;
        System.out.println(a[0]);  // still 99 — a is unaffected
    }
}
