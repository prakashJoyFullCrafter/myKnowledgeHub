package arrays;

public class ArrayShift {

    // Shift left by d positions. arr[0..d-1] are discarded.
    // Traverse L→R: safe because we read arr[i+d] before writing arr[i].
    public static void shiftLeft(int[] arr, int d) {
        int n = arr.length;
        d = d % n;
        if (d == 0) return;
        for (int i = 0; i < n - d; i++) {
            arr[i] = arr[i + d];
        }
        for (int i = n - d; i < n; i++) {
            arr[i] = 0;    // fill tail with zero (or sentinel)
        }
    }

    // Shift right by d positions. arr[n-d..n-1] are discarded.
    // Traverse R→L: CRITICAL — prevents overwriting source data.
    public static void shiftRight(int[] arr, int d) {
        int n = arr.length;
        d = d % n;
        if (d == 0) return;
        for (int i = n - 1; i >= d; i--) {
            arr[i] = arr[i - d];
        }
        for (int i = 0; i < d; i++) {
            arr[i] = 0;    // fill head with zero
        }
    }

    // Shift one element right starting at index 'start', stopping at 'end'.
    // Used internally for insertion sort and ArrayList.add(index, value).
    public static void shiftOneRight(int[] arr, int start, int end) {
        for (int i = end; i > start; i--) {
            arr[i] = arr[i - 1];   // R→L
        }
    }
}