package arrays;

public class BinarySearchOnArraySorted {

    static int binarySearch(int[] arr, int target) {
        int lo = 0, hi = arr.length - 1;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;   // NOTE: NOT (lo + hi)/2 — avoids overflow
            if (arr[mid] == target)  return mid;
            else if (arr[mid] < target) lo = mid + 1;  // discard left half
            else                        hi = mid - 1;  // discard right half
        }
        return -1; // not found
    }


    public static void main(String[] args) {
        int[] arr= new int[]{1, 3, 5, 7, 9, 11, 13};
        int target=7;
        int result = binarySearch(arr, target);
        System.out.println(result);




        // Classic iterative binary search
        // Trace on arr=[1,3,5,7,9,11,13], target=7:
// Step 1: lo=0, hi=6, mid=3, arr[3]=7 → FOUND at index 3. (1 step!)
// Trace with target=11:
// Step 1: lo=0, hi=6, mid=3, arr[3]=7 < 11 → lo=4
// Step 2: lo=4, hi=6, mid=5, arr[5]=11 → FOUND. (2 steps)
// Max steps for n=7: log2(7) ≈ 2.8 → 3 steps worst case


    }

    // Manual insert at index i in an array (fixed-size, with extra capacity)
    static void insertAt(int[] arr, int size, int index, int value) {
        // Shift elements from size-1 down to index+1
        for (int j = size; j > index; j--) {
            arr[j] = arr[j - 1];   // shift right
        }
        arr[index] = value;
    }

    // Manual delete at index i
    static int deleteAt(int[] arr, int size, int index) {
        int removed = arr[index];
        for (int j = index; j < size - 1; j++) {
            arr[j] = arr[j + 1];   // shift left
        }
        return removed;
    }

}
