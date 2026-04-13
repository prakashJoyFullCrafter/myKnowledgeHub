# Arrays & Strings - Curriculum

## Module 1: Array Fundamentals
- [ ] **Array**: contiguous block of memory, fixed size, O(1) random access
- [ ] **Dynamic array** (ArrayList, vector): auto-resizing, amortized O(1) append
- [ ] **Java arrays**: `int[]`, multi-dimensional (`int[][]`)
- [ ] **Operations and complexity**:
  - [ ] Access by index: O(1)
  - [ ] Search: O(n) unsorted, O(log n) sorted
  - [ ] Insert/delete at end: O(1) amortized
  - [ ] Insert/delete at arbitrary index: O(n) (shifting)
- [ ] **Amortized analysis**: ArrayList doubling strategy
- [ ] **2D arrays in memory**: row-major layout, cache implications
- [ ] **Memory layout**: cache locality makes arrays fast in practice

## Module 2: Array Manipulation Patterns
- [ ] **Rotation**: in-place rotation by k (reverse thrice trick)
- [ ] **Reverse**: iterative two-pointer swap
- [ ] **Shift left/right**: in-place element movement
- [ ] **Merge sorted arrays**: two-pointer merge
- [ ] **Partition**: Dutch National Flag (sort 0s, 1s, 2s)
- [ ] **In-place modifications**: remove duplicates from sorted array
- [ ] **Cyclic sort**: O(n) sort when values in range [1..n]
- [ ] **Duplicate detection**: multiple approaches (set, sort, Floyd's on values)

## Module 3: Two-Pointer Technique
- [ ] **Opposite-end pointers**: converge from both sides
  - [ ] **Two Sum (sorted)**: O(n) vs O(n²) brute force
  - [ ] **3Sum**: sort + two pointers for O(n²)
  - [ ] **Container With Most Water**: move pointer with smaller height
  - [ ] **Palindrome check**
  - [ ] **Reverse array/string in-place**
- [ ] **Same-direction pointers** (fast/slow):
  - [ ] **Remove duplicates**
  - [ ] **Move zeros to end**
  - [ ] **Partition array**
- [ ] Pattern recognition: sorted arrays, target sum, palindromes

## Module 4: Sliding Window
- [ ] **Fixed-size window**: slide a window of size K
  - [ ] **Max sum subarray of size K**
  - [ ] **Max in sliding window** (with deque)
- [ ] **Variable-size window**: expand/shrink based on condition
  - [ ] **Longest substring without repeating characters**
  - [ ] **Minimum window substring**
  - [ ] **Longest substring with K distinct characters**
- [ ] **Template**: `while (right < n) { ... while (invalid) shrink; update }`
- [ ] **Time complexity**: O(n) even though it looks like O(n²)

## Module 5: Prefix Sum & Difference Array
- [ ] **Prefix sum**: `prefix[i] = arr[0] + ... + arr[i]`
  - [ ] Range sum query: `prefix[j] - prefix[i-1]` in O(1)
- [ ] **2D prefix sum**: inclusion-exclusion for submatrix sum
- [ ] **Difference array**: range update in O(1), point query in O(n)
- [ ] **Applications**:
  - [ ] **Subarray Sum Equals K**: prefix sum + hashmap
  - [ ] **Range Sum Query - Immutable**: precompute once
  - [ ] **Product of Array Except Self**: prefix/suffix products
- [ ] **Pattern**: constant-time range queries after O(n) preprocessing

## Module 6: Kadane's Algorithm & Subarray Problems
- [ ] **Kadane's Algorithm**: maximum subarray sum in O(n)
  ```
  maxEnd = max(arr[i], maxEnd + arr[i])
  maxSoFar = max(maxSoFar, maxEnd)
  ```
- [ ] **Variations**:
  - [ ] **Max subarray sum** (classic)
  - [ ] **Max product subarray** (track min and max)
  - [ ] **Max circular subarray sum**
- [ ] **Minimum subarray**: negate and apply Kadane
- [ ] **Divide and conquer alternative**: O(n log n)

## Module 7: String Fundamentals
- [ ] **String immutability in Java**: new object on every modification
- [ ] **StringBuilder** / **StringBuffer**: mutable, use for concatenation loops
- [ ] **String pool**: literal strings interned
- [ ] **Character encoding**: UTF-16 in Java, UTF-8 in Python 3
- [ ] **Common operations**: `charAt`, `substring`, `indexOf`, `split`
- [ ] **String comparison**: `equals` vs `==`
- [ ] **Complexity of concatenation**: O(n²) with `+`, O(n) with StringBuilder

## Module 8: String Manipulation Patterns
- [ ] **Palindrome**:
  - [ ] Check: two pointers
  - [ ] **Longest palindromic substring**: expand around center O(n²), Manacher's O(n)
  - [ ] **Longest palindromic subsequence**: DP O(n²)
- [ ] **Anagrams**: sort + compare, or frequency count
  - [ ] **Group Anagrams**: sorted string as key
  - [ ] **Valid Anagram**: frequency count
- [ ] **String reversal**: words vs characters
- [ ] **Character frequency**: count array or HashMap
- [ ] **Encoding**: run-length, string-to-integer (atoi)

## Module 9: Common Interview Patterns
- [ ] **First unique character**: frequency count + index scan
- [ ] **String compression**: run-length encoding
- [ ] **Longest common prefix**: vertical or horizontal scan
- [ ] **Integer to Roman / Roman to Integer**: lookup + greedy
- [ ] **Zigzag Conversion**: simulation or math
- [ ] **Valid Parentheses**: stack (see Stacks & Queues)
- [ ] **String permutations**: backtracking

## Module 10: Matrix Patterns
- [ ] **2D matrix traversal**: row-major, column-major, spiral, diagonal
- [ ] **Matrix rotation**:
  - [ ] 90° rotation in-place (transpose + reverse)
- [ ] **Matrix search**:
  - [ ] Sorted matrix: binary search
  - [ ] Row/column sorted: O(m + n) staircase
- [ ] **BFS/DFS on grid**:
  - [ ] **Number of islands**
  - [ ] **Flood fill**
  - [ ] **Shortest path in binary matrix**
  - [ ] **Rotting oranges** (multi-source BFS)
- [ ] **Set Matrix Zeros**: in-place marking

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Remove duplicates, rotate array, Dutch flag |
| Module 3 | Two Sum II, 3Sum, Container With Most Water |
| Module 4 | Longest substring without repeat, minimum window substring |
| Module 5 | Subarray Sum Equals K, Product Except Self |
| Module 6 | Maximum Subarray, Max Product Subarray |
| Modules 7-8 | Longest Palindromic Substring, Group Anagrams |
| Module 9 | String compression, atoi |
| Module 10 | Spiral Matrix, Rotate Image, Number of Islands |

## Key Resources
- LeetCode Array tag, String tag
- NeetCode.io — Arrays & Strings patterns
- "Cracking the Coding Interview" — Chapter 1
