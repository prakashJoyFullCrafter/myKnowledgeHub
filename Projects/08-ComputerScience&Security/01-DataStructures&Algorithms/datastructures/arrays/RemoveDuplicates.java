package arrays;

public class RemoveDuplicates {

    // LeetCode 26: Remove all duplicates, keep each value once
    public static int removeDuplicates(int[] nums) {
        if (nums.length == 0) return 0;
        int write = 1;  // next write position (index 0 is always kept)
        for (int read = 1; read < nums.length; read++) {
            if (nums[read] != nums[write - 1]) {  // new unique value found
                nums[write++] = nums[read];
            }
        }
        return write;  // number of unique elements
    }

    // LeetCode 80: Allow at most 2 duplicates of each value
    // Generalization: allow at most k occurrences
    public static int removeDuplicatesII(int[] nums) {
        int write = 0;
        for (int num : nums) {
            // Allow write if fewer than 2 elements written, or new unique
            if (write < 2 || nums[write - 2] != num) {
                nums[write++] = num;
            }
        }
        return write;
    }

    // General: allow at most k occurrences of each value
    public static int removeDuplicatesK(int[] nums, int k) {
        int write = 0;
        for (int num : nums) {
            if (write < k || nums[write - k] != num) {
                nums[write++] = num;
            }
        }
        return write;
    }

    // Remove all occurrences of a given value (LeetCode 27)
    public static int removeElement(int[] nums, int val) {
        int write = 0;
        for (int num : nums) {
            if (num != val) nums[write++] = num;
        }
        return write;
    }
}
