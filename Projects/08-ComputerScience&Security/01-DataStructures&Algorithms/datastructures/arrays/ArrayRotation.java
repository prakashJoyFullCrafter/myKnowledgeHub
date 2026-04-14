package arrays;

public class ArrayRotation {

    // Right-rotate arr by k positions in-place: O(n) time, O(1) space
    public static void rotateRight(int[] arr, int k) {
        int n = arr.length;
        if (n == 0) return;
        k = k % n;           // normalize: rotating by n is a no-op
        if (k == 0) return;  // no work needed

        reverse(arr, 0, n - 1);   // Step 1: reverse entire array
        reverse(arr, 0, k - 1);   // Step 2: reverse first k elements
        reverse(arr, k, n - 1);   // Step 3: reverse remaining n-k elements
    }

    // Left-rotate by k = right-rotate by (n - k)
    public static void rotateLeft(int[] arr, int k) {
        int n = arr.length;
        if (n == 0) return;
        k = k % n;
        rotateRight(arr, n - k);
    }

    // Helper: in-place reverse of arr[lo..hi] using two-pointer swap
    private static void reverse(int[] arr, int lo, int hi) {
        while (lo < hi) {
            int tmp = arr[lo];
            arr[lo] = arr[hi];
            arr[hi] = tmp;
            lo++;
            hi--;
        }
    }

    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5, 6, 7};
        rotateRight(arr, 3);
        System.out.println(java.util.Arrays.toString(arr));
        // Output: [5, 6, 7, 1, 2, 3, 4]

        int[] arr2 = {1, 2, 3, 4, 5, 6, 7};
        rotateLeft(arr2, 2);
        System.out.println(java.util.Arrays.toString(arr2));
        // Output: [3, 4, 5, 6, 7, 1, 2]
    }
}