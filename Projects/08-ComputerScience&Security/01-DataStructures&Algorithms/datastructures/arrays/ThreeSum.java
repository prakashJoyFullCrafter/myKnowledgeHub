package arrays;

import java.util.*;

public class ThreeSum {

    // LeetCode 15: 3Sum — O(n²) time, O(1) extra space (output excluded)
    public static List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();
        Arrays.sort(nums);  // O(n log n) — enables two-pointer + dedup

        for (int i = 0; i < nums.length - 2; i++) {
            // Skip duplicate values for i to avoid duplicate triplets
            if (i > 0 && nums[i] == nums[i - 1]) continue;

            // Early termination: smallest possible triple sum > 0
            if (nums[i] > 0) break;

            int lo = i + 1, hi = nums.length - 1;
            int target = -nums[i];  // need lo+hi == target

            while (lo < hi) {
                int sum = nums[lo] + nums[hi];
                if (sum == target) {
                    result.add(Arrays.asList(nums[i], nums[lo], nums[hi]));
                    // Skip duplicates for lo
                    while (lo < hi && nums[lo] == nums[lo + 1]) lo++;
                    // Skip duplicates for hi
                    while (lo < hi && nums[hi] == nums[hi - 1]) hi--;
                    lo++; hi--;  // move past the pair we just used
                } else if (sum < target) {
                    lo++;
                } else {
                    hi--;
                }
            }
        }
        return result;
    }

    // Extension: 3Sum Closest (LeetCode 16)
    // Find triplet sum closest to target.
    public static int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int closest = nums[0] + nums[1] + nums[2];
        for (int i = 0; i < nums.length - 2; i++) {
            int lo = i + 1, hi = nums.length - 1;
            while (lo < hi) {
                int sum = nums[i] + nums[lo] + nums[hi];
                if (Math.abs(sum - target) < Math.abs(closest - target))
                    closest = sum;
                if (sum < target)       lo++;
                else if (sum > target)  hi--;
                else                    return sum;  // exact match
            }
        }
        return closest;
    }

    // Extension: 4Sum (LeetCode 18) — add one more fixed loop: O(n³)
    public static List<List<Integer>> fourSum(int[] nums, int target) {
        List<List<Integer>> result = new ArrayList<>();
        Arrays.sort(nums);
        for (int i = 0; i < nums.length - 3; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue;
            for (int j = i+1; j < nums.length - 2; j++) {
                if (j > i+1 && nums[j] == nums[j-1]) continue;
                int lo = j+1, hi = nums.length-1;
                long need = (long)target - nums[i] - nums[j];
                while (lo < hi) {
                    long s = nums[lo] + nums[hi];
                    if (s == need) {
                        result.add(Arrays.asList(nums[i],nums[j],nums[lo],nums[hi]));
                        while (lo<hi && nums[lo]==nums[lo+1]) lo++;
                        while (lo<hi && nums[hi]==nums[hi-1]) hi--;
                        lo++; hi--;
                    } else if (s < need) lo++;
                    else hi--;
                }
            }
        }
        return result;
    }
}