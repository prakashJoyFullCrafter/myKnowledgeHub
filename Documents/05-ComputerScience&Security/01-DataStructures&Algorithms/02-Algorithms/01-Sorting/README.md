# Sorting Algorithms - Curriculum

## Module 1: Sorting Fundamentals
- [ ] **Why sort**: enables binary search, grouping, deduplication, ordering
- [ ] **Properties**:
  - [ ] **In-place**: constant extra memory
  - [ ] **Stable**: preserves relative order of equal elements
  - [ ] **Online**: can sort as elements arrive
  - [ ] **Adaptive**: faster on partially sorted input
  - [ ] **Comparison-based** vs **non-comparison**
- [ ] **Lower bound**: any comparison sort is Ω(n log n)
- [ ] **Decision tree proof**: n! permutations → tree height ≥ log(n!) = Ω(n log n)

## Module 2: Simple Sorts (O(n²))
- [ ] **Bubble Sort**: swap adjacent if out of order, repeat
  - [ ] Stable, in-place, adaptive with early exit
  - [ ] O(n²) worst, O(n) best (sorted)
- [ ] **Selection Sort**: find min, swap to front, repeat
  - [ ] In-place, NOT stable
  - [ ] O(n²) always (not adaptive)
- [ ] **Insertion Sort**: insert each element into sorted prefix
  - [ ] Stable, in-place, adaptive
  - [ ] O(n²) worst, O(n) best, very fast for nearly-sorted or small arrays
  - [ ] Used as base case in Timsort, Introsort

## Module 3: Merge Sort
- [ ] **Divide and conquer**: split in half, sort each, merge
- [ ] **Merge step**: walk both halves with two pointers
- [ ] **Time**: O(n log n) always (best/worst/avg)
- [ ] **Space**: O(n) for auxiliary array
- [ ] **Stable**: yes (when merging, favor left on ties)
- [ ] **NOT in-place**: needs extra array
- [ ] **External sorting**: excellent for sorting data that doesn't fit in memory
- [ ] **Bottom-up variant**: iterative, no recursion
- [ ] **Recurrence**: T(n) = 2T(n/2) + O(n) → O(n log n) by Master Theorem

## Module 4: Quick Sort
- [ ] **Divide and conquer**: pick pivot, partition into less/greater, recurse
- [ ] **Partitioning**: Lomuto scheme, Hoare scheme (Hoare is faster)
- [ ] **Pivot selection**:
  - [ ] First/last element: bad for sorted input
  - [ ] Random: good average case
  - [ ] **Median-of-three**: first, middle, last (practical)
- [ ] **Time**: O(n log n) average, O(n²) worst
- [ ] **Space**: O(log n) average recursion, O(n) worst
- [ ] **NOT stable**
- [ ] **In-place**: yes
- [ ] **Practical performance**: usually fastest in practice
- [ ] **Tail recursion optimization**: recurse on smaller half, loop on larger

## Module 5: Heap Sort
- [ ] **Algorithm**: build max-heap, extract max repeatedly
- [ ] **Time**: O(n log n) guaranteed
- [ ] **Space**: O(1) in-place
- [ ] **NOT stable**
- [ ] **Not cache-friendly**: jumps around in memory
- [ ] **Practical speed**: slower than quicksort despite same complexity
- [ ] **Used when**: guaranteed O(n log n) needed, constant space required

## Module 6: Non-Comparison Sorts
- [ ] **Counting Sort**: count occurrences, reconstruct
  - [ ] O(n + k) where k is value range
  - [ ] Works for small integer ranges
  - [ ] Stable
- [ ] **Radix Sort**: sort by digit, least significant to most
  - [ ] O(d × (n + k)) where d is number of digits
  - [ ] Great for fixed-length integers or strings
- [ ] **Bucket Sort**: distribute into buckets, sort each
  - [ ] O(n) average for uniform distribution
  - [ ] Used for floating point in [0, 1) range
- [ ] **Not bound by Ω(n log n)**: don't compare elements

## Module 7: Hybrid & Practical Sorts
- [ ] **Timsort** (Python, Java Collections):
  - [ ] Merge sort + insertion sort
  - [ ] Detects existing runs
  - [ ] Stable, adaptive
  - [ ] O(n) best (sorted), O(n log n) worst
- [ ] **Introsort** (C++ std::sort):
  - [ ] Quicksort + heap sort fallback + insertion sort for small
  - [ ] Guaranteed O(n log n)
- [ ] **Pdqsort** (Rust, newer C++):
  - [ ] Pattern-defeating quicksort
  - [ ] Adaptive, handles many patterns fast
- [ ] **Dual-pivot quicksort** (Java `Arrays.sort` for primitives):
  - [ ] Two pivots, three partitions
  - [ ] Better cache behavior

## Module 8: Comparison Table
- [ ] | Algorithm | Best | Avg | Worst | Space | Stable | In-place |
  |-----------|------|-----|-------|-------|--------|----------|
  | Bubble | n | n² | n² | 1 | ✓ | ✓ |
  | Selection | n² | n² | n² | 1 | ✗ | ✓ |
  | Insertion | n | n² | n² | 1 | ✓ | ✓ |
  | Merge | n log n | n log n | n log n | n | ✓ | ✗ |
  | Quick | n log n | n log n | n² | log n | ✗ | ✓ |
  | Heap | n log n | n log n | n log n | 1 | ✗ | ✓ |
  | Counting | n+k | n+k | n+k | n+k | ✓ | ✗ |
  | Radix | n×d | n×d | n×d | n+k | ✓ | ✗ |
  | Timsort | n | n log n | n log n | n | ✓ | ✗ |

## Module 9: Choosing a Sort
- [ ] **Small array (< 20)**: insertion sort
- [ ] **Need stability**: merge sort, Timsort, insertion
- [ ] **Need guarantee O(n log n)**: merge sort, heap sort
- [ ] **Cache efficiency**: quicksort
- [ ] **Fast in practice**: Timsort / Introsort / Pdqsort
- [ ] **Integers with small range**: counting sort
- [ ] **Fixed-length keys**: radix sort
- [ ] **External (disk)**: merge sort variants
- [ ] **Already nearly sorted**: insertion sort (adaptive) or Timsort
- [ ] **Just use the library**: `Arrays.sort()`, `Collections.sort()`, `std::sort()` unless you have a specific reason

## Module 10: Language-Specific
- [ ] **Java**:
  - [ ] `Arrays.sort(int[])`: dual-pivot quicksort
  - [ ] `Arrays.sort(Object[])`: Timsort (modified merge sort)
  - [ ] `Collections.sort()`: Timsort
  - [ ] `List.sort(comparator)` (Java 8+)
  - [ ] `stream.sorted()`
- [ ] **Custom Comparator**: `Comparator.comparing(X::getField).thenComparing(...)`
- [ ] **Natural ordering**: class implements `Comparable`
- [ ] **Parallel sort**: `Arrays.parallelSort()` for large arrays

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Explain lower bound proof with decision tree |
| Module 2 | Implement all 3 simple sorts from scratch |
| Module 3 | Implement merge sort, use for merging sorted arrays |
| Module 4 | Implement quicksort with random pivot |
| Module 5 | Implement heap sort |
| Module 6 | Implement counting sort, radix sort |
| Module 7 | Read Timsort algorithm overview |
| Module 8 | Memorize the comparison table |
| Module 9 | Choose correct sort for 5 scenarios |
| Module 10 | Sort with custom Comparator (multi-field) |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapters 6, 7, 8
- LeetCode Sorting tag
- "Algorithms" — Sedgewick & Wayne
- visualgo.net/en/sorting (visualization)
