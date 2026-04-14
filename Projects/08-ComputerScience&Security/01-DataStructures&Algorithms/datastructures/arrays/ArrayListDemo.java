package arrays;

import java.util.ArrayList;
import java.util.Collections;

public class ArrayListDemo {
    public static void main(String[] args) {
        // Construction
        ArrayList<Integer> list = new ArrayList<>();          // default capacity 10
        ArrayList<Integer> list2 = new ArrayList<>(100);     // hint: pre-allocate 100

        // Adding elements — O(1) amortized
        list.add(10);   list.add(20);   list.add(30);   list.add(40);

        // Random access — O(1)
        int val = list.get(2);     // val = 30

        // Insert at index — O(n) (shifts elements)
        list.add(1, 15);           // list = [10, 15, 20, 30, 40]

        // Remove by index — O(n)
        list.remove(0);            // removes 10; list = [15, 20, 30, 40]

        // Remove by value — O(n)
        list.remove(Integer.valueOf(20)); // list = [15, 30, 40]

        // Size
        int sz = list.size();      // 3

        // Contains — O(n) linear search
        boolean has = list.contains(30);  // true

        // Sort — O(n log n)
        Collections.sort(list);

        // Iterate — O(n)
        for (int x : list) System.out.println(x);

        // Convert array → ArrayList
        Integer[] arr = {5, 3, 8};
        ArrayList<Integer> fromArr = new ArrayList<>(java.util.Arrays.asList(arr));

        // Convert ArrayList → array
        Integer[] backToArr = list.toArray(new Integer[0]);
    }
}