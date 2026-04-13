# Two Pointers & Sliding Window - Curriculum

Two of the most frequently appearing interview patterns — deserve first-class treatment.

---

## Module 1: Two-Pointer Fundamentals
- [ ] **Two-pointer technique**: use two indices to traverse data
- [ ] **Benefit**: often reduces O(n²) to O(n)
- [ ] **Two main variants**:
  - [ ] **Opposite ends** (converging): left=0, right=n-1
  - [ ] **Same direction** (fast/slow): both start at 0 or head
- [ ] **Key property**: maintain an invariant as you move
- [ ] **Common in**: sorted arrays, linked lists, palindromes
- [ ] **Not a panacea**: requires problem structure (sorted, monotonic, etc.)

## Module 2: Opposite-End Two Pointers
- [ ] **Pattern**: move pointers from both ends toward center
- [ ] **Template**:
  ```
  left = 0, right = n - 1
  while left < right:
      if condition(arr[left], arr[right]):
          update_answer()
          left++, right--
      elif move_left:
          left++
      else:
          right--
  ```
- [ ] **Classic problems**:
  - [ ] **Two Sum II (sorted)**: sum too small → left++, too large → right--
  - [ ] **3Sum**: fix one, use two pointers on the rest
  - [ ] **Container With Most Water**: move pointer with smaller height
  - [ ] **Trapping Rain Water**: two pointers tracking max heights
  - [ ] **Valid Palindrome**: compare characters, skip non-alphanumeric
  - [ ] **Reverse array/string**: swap ends, converge

## Module 3: Same-Direction Two Pointers (Fast/Slow)
- [ ] **Pattern**: both pointers move same direction at different speeds
- [ ] **Fast/slow on linked list**:
  - [ ] Find middle: slow 1x, fast 2x
  - [ ] Detect cycle (Floyd's): fast eventually meets slow
  - [ ] Find cycle start: after detection, reset one to head
- [ ] **Fast/slow on arrays**:
  - [ ] **Remove duplicates**: slow writes, fast reads
  - [ ] **Move zeros to end**: slow for non-zero, fast scans
  - [ ] **Partition array**: slow for one group, fast scans
- [ ] **Remove Nth from end (linked list)**: fast N steps ahead, then both move

## Module 4: Fast/Slow Pointer Theory (Floyd's)
- [ ] **Floyd's cycle detection**: classic two-pointer algorithm
- [ ] **Why fast meets slow**: gap decreases by 1 per step in cycle
- [ ] **Finding cycle start**: math trick
  - [ ] Let `d` = distance from head to cycle start
  - [ ] Let `L` = cycle length
  - [ ] When slow meets fast, slow has traveled `k` steps where `k ≡ d (mod L)`
  - [ ] Reset one to head, move both at 1x → meet at cycle start
- [ ] **Applications beyond linked lists**:
  - [ ] **Find Duplicate Number**: treat array as functional graph
  - [ ] **Happy Number**: cycle detection on digit sum

## Module 5: Sliding Window Fundamentals
- [ ] **Sliding window**: maintain a window of contiguous elements
- [ ] **Two variants**:
  - [ ] **Fixed-size window**: window size K is given
  - [ ] **Variable-size window**: window grows/shrinks based on condition
- [ ] **Key operations**:
  - [ ] **Expand**: move `right` pointer, add element
  - [ ] **Shrink**: move `left` pointer, remove element
  - [ ] **Update answer**: after expand or shrink
- [ ] **Time complexity**: O(n) despite two nested loops — each element visited at most twice

## Module 6: Fixed-Size Sliding Window
- [ ] **Template**:
  ```
  for right in 0..n:
      add(arr[right])
      if right >= k - 1:
          update_answer()
          remove(arr[right - k + 1])
  ```
- [ ] **Problems**:
  - [ ] **Max Sum Subarray of Size K**: running sum
  - [ ] **Average of K-length subarrays**
  - [ ] **Max in Sliding Window**: deque of indices
  - [ ] **Anagrams of Pattern in String**: frequency window
  - [ ] **Permutation in String**: frequency comparison

## Module 7: Variable-Size Sliding Window
- [ ] **Template**:
  ```
  left = 0
  for right in 0..n:
      add(arr[right])
      while invalid():
          remove(arr[left])
          left++
      update_answer(right - left + 1)
  ```
- [ ] **Problems**:
  - [ ] **Longest Substring Without Repeating Characters**
  - [ ] **Minimum Window Substring**: expand until valid, shrink while valid
  - [ ] **Longest Substring with At Most K Distinct Characters**
  - [ ] **Fruit Into Baskets**: longest window with ≤ 2 distinct
  - [ ] **Longest Repeating Character Replacement**
  - [ ] **Subarrays with Product Less Than K**
- [ ] **Key**: define "invalid" condition, shrink until valid

## Module 8: Sliding Window with Deque
- [ ] **Problem**: maintain max/min of window efficiently
- [ ] **Deque**: double-ended queue storing indices in monotonic order
- [ ] **Sliding Window Maximum**:
  - [ ] Deque holds indices of candidates in decreasing order
  - [ ] Remove front if out of window
  - [ ] Remove back if smaller than current (won't be max)
  - [ ] Front is max
- [ ] **Time**: O(n) — each element pushed/popped once
- [ ] **Generalizes**: min with increasing deque, sum with prefix, etc.

## Module 9: Hybrid Techniques
- [ ] **Sliding window + hash map**: frequency tracking
  - [ ] **Longest substring with all unique characters**
  - [ ] **Substring with concatenation of all words**
- [ ] **Two pointers + sort**: enables two-pointer on unordered
  - [ ] **3Sum, 4Sum**: sort first
- [ ] **Sliding window + binary search**: when window condition is monotonic
- [ ] **Sliding window + sorted set**: find K-smallest in window

## Module 10: Recognizing Patterns
- [ ] **Signals for two pointers**:
  - [ ] Sorted array with target sum / comparison
  - [ ] Palindrome or reverse problems
  - [ ] Linked list cycle or middle
  - [ ] "Pair with property X"
- [ ] **Signals for sliding window**:
  - [ ] "Longest/shortest subarray/substring with property X"
  - [ ] "Subarray with sum/product target"
  - [ ] "All subarrays of size K"
  - [ ] "At most K distinct / exactly K distinct"
- [ ] **Contiguous constraint**: both techniques require contiguous elements
- [ ] **Non-contiguous**: subset/subsequence problems need different approach (DP, backtracking)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Two Sum II, 3Sum, Container With Most Water, Trapping Rain Water |
| Modules 3-4 | Linked list cycle, find middle, Find Duplicate Number |
| Modules 5-6 | Max Sum Subarray of Size K, Anagrams in String |
| Module 7 | Longest Substring Without Repeat, Minimum Window Substring |
| Module 8 | Sliding Window Maximum (deque) |
| Module 9 | Longest Substring with K Distinct, 3Sum |
| Module 10 | Identify pattern for 10 problems |

## Key Resources
- NeetCode.io — Two Pointers and Sliding Window playlists
- LeetCode — Two Pointers and Sliding Window tags
- "Grokking the Coding Interview" — sliding window chapter
- educative.io patterns course
