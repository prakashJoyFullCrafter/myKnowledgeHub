package arrays;

public class ArrayFundamentals {
    public static void main(String[] args) {
        // --- Declaration and Initialization ---
        int[] arr = new int[5];          // Fixed size: 5 elements, all zero by default
        int[] primes = {2, 3, 5, 7, 11}; // Inline initialization

        // --- O(1) Access ---
        int x = primes[3];   // x = 7   (address = base + 3*4, one step)
        primes[0] = 99;      // mutate  (write to base + 0*4, one step)

        // --- O(n) Linear Search ---
        int target = 5;
        int foundAt = -1;
        for (int i = 0; i < primes.length; i++) {  // Worst case: scan all n
            if (primes[i] == target) {
                foundAt = i;
                break;
            }
        }
        // foundAt = 2

        // --- O(log n) Binary Search (array must be SORTED) ---
        int lo = 0, hi = primes.length - 1;
        int searchFor = 7;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;   // avoid integer overflow
            if (primes[mid] == searchFor) {
                System.out.println("Found at " + mid);
                break;
            } else if (primes[mid] < searchFor) lo = mid + 1;
            else hi = mid - 1;
        }

        // --- O(n) Insert at arbitrary index ---
        // Insert 4 at index 2 (shift elements 2,3,4 right by one)
        int[] bigger = new int[6]; // need extra space
        for (int i = 0; i < 2; i++) bigger[i] = primes[i];       // copy [0,1]
        bigger[2] = 4;                                            // new element
        for (int i = 2; i < primes.length; i++) bigger[i + 1] = primes[i]; // shift
        // bigger = {2, 3, 4, 5, 7, 11}
    }
}