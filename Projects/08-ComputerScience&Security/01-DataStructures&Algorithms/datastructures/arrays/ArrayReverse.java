package arrays;

public class ArrayReverse {

    // Reverse entire array in-place: O(n) time, O(1) space
    public static void reverse(int[] arr) {
        reverse(arr, 0, arr.length - 1);
    }

    // Reverse subarray arr[lo..hi] in-place
    public static void reverse(int[] arr, int lo, int hi) {
        while (lo < hi) {
            // Swap without temporary variable (XOR trick — shown for completeness)
            // NOTE: Use tmp variable in practice — XOR fails if lo==hi
            int tmp = arr[lo];
            arr[lo] = arr[hi];
            arr[hi] = tmp;
            lo++;
            hi--;
        }
    }

    // Reverse a String (immutable in Java — must use char array)
    public static String reverseString(String s) {
        char[] chars = s.toCharArray();
        int lo = 0, hi = chars.length - 1;
        while (lo < hi) {
            char tmp = chars[lo];
            chars[lo++] = chars[hi];
            chars[hi--] = tmp;
        }
        return new String(chars);
    }

    // Check if array is a palindrome using two pointers
    public static boolean isPalindrome(int[] arr) {
        int lo = 0, hi = arr.length - 1;
        while (lo < hi) {
            if (arr[lo] != arr[hi]) return false;
            lo++; hi--;
        }
        return true;
    }
}