package arrays;
import java.util.Arrays;

public class CommonArrayOperation {

    public static void main(String[] args) {

        int[] a = {5, 3, 8, 1, 9, 2};

// Sorting — O(n log n) using Dual-Pivot Quicksort
        Arrays.sort(a);                    // a = [1, 2, 3, 5, 8, 9] (in-place)

// Binary search — O(log n), MUST sort first
        int idx = Arrays.binarySearch(a, 5);  // idx = 3

// Filling all elements
        Arrays.fill(a, 0);                 // a = [0, 0, 0, 0, 0, 0]

// Copying — creates NEW array
        int[] copy = Arrays.copyOf(a, a.length);         // full copy
        int[] partial = Arrays.copyOfRange(a, 1, 4);     // elements [1..3]

// Comparing
        boolean equal = Arrays.equals(a, copy);          // true

// Pretty printing
        System.out.println(Arrays.toString(a));  // [0, 0, 0, 0, 0, 0]

// Manual copy (for teaching purposes)
        int[] manual = new int[a.length];
        System.arraycopy(a, 0, manual, 0, a.length); // fast native copy
    }
}
