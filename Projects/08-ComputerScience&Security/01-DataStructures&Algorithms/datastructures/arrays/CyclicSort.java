package arrays;

public class CyclicSort {

    // Basic cyclic sort: arr contains distinct values in [1..n]
    public static void cyclicSort(int[] arr) {
        int i = 0;
        while (i < arr.length) {
            int correct = arr[i] - 1;  // where arr[i] SHOULD be
            if (arr[i] != arr[correct]) {  // not in right place
                // swap arr[i] with arr[correct]
                int tmp = arr[i]; arr[i] = arr[correct]; arr[correct] = tmp;
                // Do NOT advance i — recheck arr[i] (now a new value)
            } else {
                i++;  // already in correct position
            }
        }
    }

    // LeetCode 268: Find the missing number in [0..n]
    // Cyclic sort values [1..n] to indices [0..n-1]; missing = index where arr[i]!=i+1
    public static int missingNumber(int[] nums) {
        int i = 0;
        while (i < nums.length) {
            int j = nums[i];
            if (j < nums.length && nums[j] != nums[i]) {
                int tmp = nums[i]; nums[i] = nums[j]; nums[j] = tmp;
            } else {
                i++;
            }
        }
        for (int k = 0; k < nums.length; k++) {
            if (nums[k] != k) return k;  // first mismatch = missing value
        }
        return nums.length;  // n itself is missing
    }

    // LeetCode 442: Find all duplicates in [1..n], each appears once or twice
    public static java.util.List<Integer> findDuplicates(int[] nums) {
        java.util.List<Integer> result = new java.util.ArrayList<>();
        int i = 0;
        while (i < nums.length) {
            int correct = nums[i] - 1;
            if (nums[i] != nums[correct]) {  // not in right place AND not duplicate
                int tmp = nums[i]; nums[i] = nums[correct]; nums[correct] = tmp;
            } else {
                i++;
            }
        }
        for (int j = 0; j < nums.length; j++) {
            if (nums[j] != j + 1) result.add(nums[j]);  // misplaced = duplicate
        }
        return result;
    }
}