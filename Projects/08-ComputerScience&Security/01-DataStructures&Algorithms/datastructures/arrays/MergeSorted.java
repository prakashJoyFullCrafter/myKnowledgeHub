package arrays;

import java.util.Arrays;

public class MergeSorted {

    // Merge a[0..m-1] and b[0..n-1] into a new sorted array: O(m+n) time & space
    public static int[] merge(int[] a, int[] b) {
        int m = a.length, n = b.length;
        int[] result = new int[m + n];
        int i = 0, j = 0, k = 0;
        while (i < m && j < n) {
            if (a[i] <= b[j]) result[k++] = a[i++];  // <= keeps merge stable
            else result[k++] = b[j++];
        }
        while (i < m) result[k++] = a[i++];  // drain remaining a
        while (j < n) result[k++] = b[j++];  // drain remaining b
        return result;
    }

    // LeetCode 88: Merge nums1 (has m+n space, m real values) and nums2 (n values)
    // Merge IN-PLACE into nums1. Key: fill from the BACK to avoid overwriting.
    public static void mergeInPlace(int[] nums1, int m, int[] nums2, int n) {
        int i = m - 1;        // pointer to last real element of nums1
        int j = n - 1;        // pointer to last element of nums2
        int k = m + n - 1;    // pointer to last position in nums1

        while (i >= 0 && j >= 0) {
            if (nums1[i] >= nums2[j]) nums1[k--] = nums1[i--];
            else nums1[k--] = nums2[j--];
        }
        // If nums2 still has elements, copy them (nums1 elements already in place)
        while (j >= 0) nums1[k--] = nums2[j--];
        // No need to drain nums1 — its remaining elements are already in position
    }
}

// Merge k sorted arrays — O(N log k) using a min-heap  [concept shown]
// N = total elements across all arrays, k = number of arrays
// Each element is inserted/extracted from the heap once: O(log k) per element