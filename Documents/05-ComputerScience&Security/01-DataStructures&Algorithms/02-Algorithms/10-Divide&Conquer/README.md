# Divide & Conquer - Curriculum

A paradigm that breaks problems into disjoint subproblems.

---

## Module 1: Divide & Conquer Fundamentals
- [ ] **Divide & Conquer (D&C)**: solve by
  1. [ ] **Divide** problem into subproblems
  2. [ ] **Conquer** subproblems recursively
  3. [ ] **Combine** subresults into final answer
- [ ] **Differs from DP**: D&C has **disjoint** subproblems, DP has overlapping ones
- [ ] **Typical recurrence**: T(n) = a · T(n/b) + O(f(n))
- [ ] **Solve with Master Theorem** or recursion tree
- [ ] **Key advantage**: can often reduce O(n²) or O(n³) to O(n log n)
- [ ] **Not a panacea**: subproblems must be independent

## Module 2: Classic Algorithms
- [ ] **Merge Sort**:
  - [ ] Divide: split in half
  - [ ] Conquer: sort each half
  - [ ] Combine: merge sorted halves
  - [ ] T(n) = 2T(n/2) + O(n) = O(n log n)
- [ ] **Quick Sort**:
  - [ ] Divide: partition around pivot
  - [ ] Conquer: sort left and right
  - [ ] Combine: nothing (in-place)
  - [ ] Avg O(n log n), worst O(n²)
- [ ] **Binary Search**:
  - [ ] Divide: check mid, narrow search
  - [ ] O(log n)
- [ ] **Karatsuba Multiplication**: multiply large numbers in O(n^1.585) instead of O(n²)
- [ ] **Strassen's Matrix Multiplication**: O(n^2.807) instead of O(n³)
- [ ] **Fast Fourier Transform (FFT)**: polynomial multiplication in O(n log n)

## Module 3: Master Theorem Deep Dive
- [ ] **Recurrence**: `T(n) = a·T(n/b) + f(n)`
- [ ] **a** ≥ 1: subproblems count, **b** > 1: size shrinkage
- [ ] **Critical exponent**: `c = log_b(a)`
- [ ] **Three cases**:
  - [ ] **Case 1**: `f(n) = O(n^(c-ε))` → `T(n) = Θ(n^c)`
  - [ ] **Case 2**: `f(n) = Θ(n^c · log^k n)` → `T(n) = Θ(n^c · log^(k+1) n)`
  - [ ] **Case 3**: `f(n) = Ω(n^(c+ε))` and regularity → `T(n) = Θ(f(n))`
- [ ] **Examples**:
  - [ ] Merge sort: a=2, b=2, f(n)=n → c=1, Case 2, O(n log n)
  - [ ] Binary search: a=1, b=2, f(n)=1 → c=0, Case 2, O(log n)
  - [ ] Strassen's: a=7, b=2, f(n)=n² → c=log₂7, Case 1, O(n^log₂7)

## Module 4: Quickselect (Find Kth)
- [ ] **Problem**: find kth smallest element
- [ ] **Quickselect**: like quicksort but only recurse on one side
- [ ] **Average**: O(n)
- [ ] **Worst**: O(n²) with bad pivot
- [ ] **Median of medians**: guaranteed O(n) pivot selection
  - [ ] Theoretically optimal, practically slower
- [ ] **Random pivot**: simpler, nearly always fast
- [ ] **Applications**:
  - [ ] Kth largest element
  - [ ] Top K closest points
  - [ ] Median finding

## Module 5: Maximum Subarray via D&C
- [ ] **Problem**: max subarray sum (Kadane's O(n) is better, but D&C is instructive)
- [ ] **D&C approach**: O(n log n)
- [ ] **Divide**: split at middle
- [ ] **Conquer**: recurse on both halves
- [ ] **Combine**: max crossing middle — linear scan left + right
- [ ] **Answer**: max of left, right, crossing
- [ ] **Recurrence**: T(n) = 2T(n/2) + O(n) = O(n log n)
- [ ] **Kadane's is simpler AND faster**: this is mainly an exercise

## Module 6: Closest Pair of Points
- [ ] **Problem**: given n points in plane, find closest pair
- [ ] **Brute force**: O(n²) by checking all pairs
- [ ] **D&C approach**: O(n log n)
  1. [ ] Sort points by x-coordinate
  2. [ ] Divide into left and right halves
  3. [ ] Recurse to find min distance in each
  4. [ ] Check "strip" in the middle for cross-pair candidates
  5. [ ] Use y-sorted order in strip, check only ≤ 7 points per candidate
- [ ] **Classic computational geometry D&C**

## Module 7: Count Inversions
- [ ] **Inversion**: pair (i, j) where i < j but arr[i] > arr[j]
- [ ] **Naive**: O(n²)
- [ ] **D&C with merge sort**: O(n log n)
  - [ ] Count inversions within left half (recursive)
  - [ ] Count inversions within right half (recursive)
  - [ ] Count cross-inversions during merge (when taking from right, add remaining left)
- [ ] **Applications**: sortedness measure, collaborative filtering

## Module 8: D&C DP Optimizations
- [ ] **Standard DP**: O(n²) or O(n³) for many problems
- [ ] **D&C optimization**: when transition has "monotonic optimality"
- [ ] **Idea**: split by optimal choice, each D&C call pays for its range
- [ ] **Time**: O(n² log n) or O(n log² n) in some cases
- [ ] **Applications**:
  - [ ] Post-office problem
  - [ ] Certain partitioning DPs
- [ ] **Advanced**: Knuth optimization, convex hull trick, SMAWK
- [ ] **Competitive programming territory**: rare in interviews

## Module 9: Meet in the Middle
- [ ] **Technique**: split problem into two halves, solve each, combine
- [ ] **Classic use**: reduce O(2^n) to O(2^(n/2))
- [ ] **Example: 4Sum variants**:
  - [ ] Compute all pair sums for first half, all for second half
  - [ ] Look up complement
- [ ] **Subset sum with meet in the middle**: O(2^(n/2)) for n ≤ 40
- [ ] **Not strictly D&C, but related**

## Module 10: Divide & Conquer vs DP vs Greedy
- [ ] **D&C**:
  - [ ] Subproblems are disjoint
  - [ ] Pays for combining at each level
  - [ ] Examples: merge sort, FFT, closest pair
- [ ] **DP**:
  - [ ] Subproblems overlap
  - [ ] Memoize to avoid recomputation
  - [ ] Examples: LCS, knapsack, Floyd-Warshall
- [ ] **Greedy**:
  - [ ] One choice at each step, no backtracking
  - [ ] Examples: Dijkstra, Kruskal, activity selection
- [ ] **Knowing which to use**: pattern recognition, practice

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement merge sort and quicksort |
| Module 3 | Apply Master Theorem to 5 recurrences |
| Module 4 | Implement quickselect for Kth largest |
| Module 5 | Solve Maximum Subarray with D&C and Kadane |
| Module 6 | Implement closest pair of points |
| Module 7 | Count inversions using merge sort |
| Module 8 | Read about Knuth DP optimization |
| Module 9 | Meet in the middle for subset sum (n=40) |
| Module 10 | Classify 10 problems as D&C / DP / Greedy |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapter 4
- "Algorithm Design Manual" — Skiena
- CP-Algorithms — Divide and Conquer
- Codeforces EDU
