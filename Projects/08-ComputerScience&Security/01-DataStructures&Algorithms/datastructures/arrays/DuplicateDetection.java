package arrays;

import java.util.HashSet;

public class DuplicateDetection {

    // Method 1: HashSet — O(n) time, O(n) space
    // Returns true if ANY duplicate exists
    public static boolean hasDuplicate(int[] nums) {
        HashSet<Integer> seen = new HashSet<>();
        for (int num : nums) {
            if (!seen.add(num)) return true;  // add() returns false if already present
        }
        return false;
    }

    // Returns the first duplicate found (or -1)
    public static int firstDuplicate(int[] nums) {
        HashSet<Integer> seen = new HashSet<>();
        for (int num : nums) {
            if (!seen.add(num)) return num;
        }
        return -1;
    }

    // Returns all duplicates (each reported once)
    public static java.util.List<Integer> allDuplicates(int[] nums) {
        HashSet<Integer> seen = new HashSet<>();
        HashSet<Integer> dups = new HashSet<>();
        for (int num : nums) {
            if (!seen.add(num)) dups.add(num);
        }
        return new java.util.ArrayList<>(dups);
    }
}