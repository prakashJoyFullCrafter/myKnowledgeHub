package arrays;

public class DeclaringInitializingArray {
    public static void main(String[] args) {
        // --- Declaration (no memory allocated yet) ---
        int[] arr;          // preferred Java style
        int arr2[];         // C-style (valid but discouraged)

// --- Allocation (memory allocated, elements zero-initialized) ---
        arr = new int[5];   // [0, 0, 0, 0, 0]

// --- Combined Declaration + Allocation ---
        double[] prices = new double[3];    // [0.0, 0.0, 0.0]
        boolean[] flags = new boolean[4];   // [false, false, false, false]
        String[] names = new String[2];     // [null, null]

// --- Array Initializer (declare + allocate + populate) ---
        int[] scores = {95, 87, 72, 100, 68};
        String[] days = {"Mon", "Tue", "Wed", "Thu", "Fri"};

// --- Anonymous array (useful for passing inline) ---
        printArray(new int[]{1, 2, 3, 4, 5});

// --- Access length ---
        int len = scores.length;  // 5 (field, NOT a method — no parentheses)
    }

    private static void printArray(int[] arr) {
        for (int i = 0; i < arr.length; i++) {
            System.out.print(arr[i] + " ");
        }
    }
}
