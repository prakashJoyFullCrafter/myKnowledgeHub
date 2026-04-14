package arrays;

public class TwoSum {

    // LeetCode 167: Two Sum II (1-indexed output, exactly one solution guaranteed)
    public static int[] twoSumSorted(int[] numbers, int target) {
        int lo = 0, hi = numbers.length - 1;
        while (lo < hi) {
            int sum = numbers[lo] + numbers[hi];
            if (sum == target)      return new int[]{lo + 1, hi + 1};
            else if (sum < target)  lo++;   // sum too small: need bigger left
            else                    hi--;   // sum too big:  need smaller right
        }
        return new int[]{};  // guaranteed to find by problem statement
    }

    // Variant: return ALL pairs (multiple solutions possible)
    public static java.util.List<int[]> allTwoSumPairs(int[] arr, int target) {
        java.util.List<int[]> result = new java.util.ArrayList<>();
        int lo = 0, hi = arr.length - 1;
        while (lo < hi) {
            int sum = arr[lo] + arr[hi];
            if (sum == target) {
                result.add(new int[]{arr[lo], arr[hi]});
                lo++; hi--;                    // both must advance
                // Skip duplicates to avoid repeat pairs:
                while (lo < hi && arr[lo] == arr[lo-1]) lo++;
                while (lo < hi && arr[hi] == arr[hi+1]) hi--;
            } else if (sum < target) {
                lo++;
            } else {
                hi--;
            }
        }
        return result;
    }

    // Variant: unsorted array — use HashMap for O(n) time, O(n) space
    // (Two-pointer doesn't work on unsorted — must sort first: O(n log n))
    public static int[] twoSumUnsorted(int[] nums, int target) {
        java.util.HashMap<Integer,Integer> map = new java.util.HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[]{map.get(complement), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}
