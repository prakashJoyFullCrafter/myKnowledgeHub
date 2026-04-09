# Binary Search - Curriculum

## Module 1: Classic Binary Search
- [ ] Binary search on sorted array: O(log n)
- [ ] Template: `left = 0, right = n-1`, while `left <= right`, `mid = left + (right - left) / 2`
- [ ] Avoid overflow: `mid = left + (right - left) / 2` not `(left + right) / 2`
- [ ] Find exact target: return `mid` when `arr[mid] == target`
- [ ] **Lower bound** (first occurrence): `left <= right`, move `right = mid - 1` on match
- [ ] **Upper bound** (last occurrence): `left <= right`, move `left = mid + 1` on match
- [ ] Java: `Arrays.binarySearch()`, `Collections.binarySearch()`

## Module 2: Binary Search on Answer (Search Space Reduction)
- [ ] **Key insight**: if answer has monotonic property (feasible/not-feasible boundary), binary search applies
- [ ] Template: binary search on the ANSWER, not on an array
- [ ] **Koko Eating Bananas**: search on eating speed (1 to max), check if can finish in H hours
- [ ] **Capacity to Ship Packages**: search on ship capacity, check if can ship in D days
- [ ] **Split Array Largest Sum**: search on max sum, check if can split into M subarrays
- [ ] **Minimum Days to Make Bouquets**: search on days, check if enough adjacent flowers
- [ ] Pattern: define `canAchieve(value)` predicate, binary search on value range

## Module 3: Binary Search Variations
- [ ] **Search in Rotated Sorted Array**: identify sorted half, decide which half to search
- [ ] **Find Minimum in Rotated Sorted Array**: compare `mid` with `right`
- [ ] **Search in 2D Matrix**: treat as 1D array, `row = mid / cols`, `col = mid % cols`
- [ ] **Peak Element**: `arr[mid] > arr[mid+1]` → peak is left side (including mid)
- [ ] **First Bad Version**: binary search on boolean predicate
- [ ] **Median of Two Sorted Arrays**: binary search on partition point — O(log(min(m,n)))
- [ ] **Square Root**: binary search on integers, `mid * mid <= x`

## Module 4: Binary Search in Practice
- [ ] Binary search on floating point: `while (right - left > 1e-6)` for precision
- [ ] Binary search + prefix sum: count elements in range
- [ ] Binary search + greedy: optimize parameter for greedy algorithm
- [ ] **Bisect in Java**: `Arrays.binarySearch()` returns `-(insertion point) - 1` on miss
- [ ] **TreeMap** as sorted structure: `floorKey()`, `ceilingKey()` use binary search internally
- [ ] Common mistake: off-by-one errors — practice with `left < right` vs `left <= right`
- [ ] When NOT to use: unsorted data, no monotonic property

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Basic binary search, find first/last occurrence, search insert position |
| Module 2 | Koko Eating Bananas, Capacity to Ship, Split Array Largest Sum |
| Module 3 | Search in Rotated Array, Find Peak Element, Median of Two Sorted Arrays |
| Module 4 | Sqrt(x), find Kth smallest element in sorted matrix |

## Key Resources
- LeetCode Binary Search tag (study plan)
- NeetCode.io — Binary Search patterns
- "Binary Search" — CP-Algorithms
