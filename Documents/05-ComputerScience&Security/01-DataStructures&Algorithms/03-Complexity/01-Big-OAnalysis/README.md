# Big-O Analysis - Curriculum

## Module 1: Asymptotic Notation
- [ ] **Big-O (O)**: upper bound on growth rate — "no worse than"
- [ ] **Big-Omega (Ω)**: lower bound — "no better than"
- [ ] **Big-Theta (Θ)**: tight bound — both O and Ω
- [ ] **little-o (o)**: strict upper bound — "strictly less than"
- [ ] **little-omega (ω)**: strict lower bound
- [ ] **Formal definitions**:
  - [ ] `f = O(g)` iff ∃ c, n₀: `f(n) ≤ c·g(n)` for all `n ≥ n₀`
  - [ ] `f = Ω(g)` iff ∃ c, n₀: `f(n) ≥ c·g(n)` for all `n ≥ n₀`
- [ ] **In interviews**: people say "Big-O" but usually mean Θ (tight bound)

## Module 2: Common Complexities
- [ ] **O(1)** — constant: hash lookup, array access
- [ ] **O(log n)** — logarithmic: binary search, balanced BST ops
- [ ] **O(n)** — linear: array traversal, single loop
- [ ] **O(n log n)** — linearithmic: merge sort, heap sort, efficient comparison sorts
- [ ] **O(n²)** — quadratic: nested loops, bubble/insertion sort
- [ ] **O(n³)** — cubic: triple nested loops, Floyd-Warshall
- [ ] **O(2ⁿ)** — exponential: subsets, recursive Fibonacci
- [ ] **O(n!)** — factorial: permutations, brute-force TSP
- [ ] **Growth rate**: log n < √n < n < n log n < n² < n³ < 2ⁿ < n! < nⁿ

## Module 3: Analyzing Loops
- [ ] **Single loop**: O(n)
- [ ] **Nested loops** (independent): O(n²), O(n³)
- [ ] **Loop with halving/doubling**: O(log n)
  - [ ] `while (i < n) { i *= 2; }` → O(log n)
  - [ ] `while (n > 1) { n /= 2; }` → O(log n)
- [ ] **Loop with conditional break**: analyze worst case
- [ ] **Triangular loops**: `for i; for j = i..n` → O(n²/2) = O(n²)
- [ ] **Sliding window / amortized**: may look O(n²) but actually O(n)

## Module 4: Analyzing Recursion
- [ ] **Recurrence relation**: express T(n) in terms of smaller T(k)
- [ ] **Examples**:
  - [ ] Factorial: T(n) = T(n-1) + O(1) → O(n)
  - [ ] Binary search: T(n) = T(n/2) + O(1) → O(log n)
  - [ ] Merge sort: T(n) = 2T(n/2) + O(n) → O(n log n)
  - [ ] Recursive Fibonacci: T(n) = T(n-1) + T(n-2) → O(2ⁿ)
- [ ] **Master Theorem**: solve `T(n) = a·T(n/b) + f(n)`
  - [ ] Case 1: `f(n) = O(n^(log_b a - ε))` → `T(n) = Θ(n^(log_b a))`
  - [ ] Case 2: `f(n) = Θ(n^(log_b a))` → `T(n) = Θ(n^(log_b a) · log n)`
  - [ ] Case 3: `f(n) = Ω(n^(log_b a + ε))` → `T(n) = Θ(f(n))`
- [ ] **Recursion tree method**: draw call tree, sum work per level

## Module 5: Amortized Analysis
- [ ] **Amortized**: average cost over sequence of operations
- [ ] **Aggregate method**: total cost / number of operations
- [ ] **Accounting method**: charge extra per cheap op to pay for expensive ones
- [ ] **Potential method**: define potential function
- [ ] **Classic examples**:
  - [ ] **ArrayList insert**: amortized O(1) despite occasional O(n) resize
  - [ ] **HashMap insert**: amortized O(1) despite rehash
  - [ ] **Union-Find with path compression**: amortized α(n) (near-constant)
- [ ] **Intuition**: resize doubles, so cost of previous n inserts covers one O(n) resize

## Module 6: Best / Average / Worst Case
- [ ] **Best case**: most favorable input
- [ ] **Average case**: expected over input distribution
- [ ] **Worst case**: most unfavorable (safety-critical analysis)
- [ ] **Quicksort example**:
  - [ ] Best: O(n log n) — balanced partitions
  - [ ] Average: O(n log n) — random pivot
  - [ ] Worst: O(n²) — already sorted with bad pivot
- [ ] **Hash table example**:
  - [ ] Best/average: O(1)
  - [ ] Worst: O(n) with collisions
- [ ] **Why care**: real systems operate on unpredictable inputs

## Module 7: Big-O Rules
- [ ] **Drop constants**: O(2n) = O(n)
- [ ] **Drop non-dominant terms**: O(n² + n) = O(n²)
- [ ] **Log base doesn't matter**: O(log₂ n) = O(log₁₀ n) = O(log n)
  - [ ] Different bases differ by constant factor
- [ ] **Addition**: sequential operations sum
  - [ ] Loop 1 (n) + Loop 2 (m) = O(n + m)
- [ ] **Multiplication**: nested operations multiply
  - [ ] Outer (n) × inner (m) = O(n·m)
- [ ] **Different inputs**: keep variables distinct (e.g., O(V + E) for graphs)

## Module 8: Space Complexity
- [ ] **Total space**: all memory used
- [ ] **Auxiliary space**: extra space beyond input
- [ ] **In-place algorithm**: O(1) auxiliary space (or O(log n) for recursion)
- [ ] **Recursive space**: O(depth) for call stack
- [ ] **DP space optimization**: reduce 2D to 1D by rolling arrays
- [ ] **Common pitfalls**:
  - [ ] Forgetting recursion stack
  - [ ] Implicit space in sort/hash

## Module 9: Common Complexity Mistakes
- [ ] **String concatenation in loop**: O(n²) not O(n)
  - [ ] Use StringBuilder for O(n)
- [ ] **`list.contains()` in loop**: O(n) per call → O(n²)
  - [ ] Use HashSet for O(1)
- [ ] **Nested map lookups**: O(n) per lookup × n iterations = O(n²)
- [ ] **Stream operations**: chained stream is still O(n), not O(n²)
- [ ] **Forgetting Big-O of library functions**: `String.substring()` may be O(n)

## Module 10: Practical Complexity Analysis
- [ ] **Input size matters**: O(n²) may be fine for n=100, bad for n=10⁶
- [ ] **Rough guidelines** (1 second, ~10⁸ ops):
  - [ ] n ≤ 10: anything (brute force OK)
  - [ ] n ≤ 100: O(n³)
  - [ ] n ≤ 10,000: O(n²)
  - [ ] n ≤ 10⁶: O(n log n) or O(n)
  - [ ] n ≤ 10⁹: O(log n) or O(1)
- [ ] **Constants matter in practice**: O(n) with cache-friendly access beats O(n) with random access
- [ ] **Measure, don't guess**: profile real code
- [ ] **Theoretical vs practical**: sometimes simpler algorithm wins despite worse Big-O

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Memorize common complexities, order them by growth |
| Module 3 | Analyze 10 loops and report Big-O |
| Module 4 | Apply Master Theorem to 5 recurrences |
| Module 5 | Explain ArrayList amortized cost |
| Module 6 | Identify best/average/worst for quicksort and hashmap |
| Module 7 | Simplify 10 Big-O expressions |
| Module 8 | Distinguish total vs auxiliary space in 5 algorithms |
| Module 9 | Spot and fix 5 complexity mistakes |
| Module 10 | Estimate max input size for 1-second runtime at each complexity |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapters 3-4
- "Algorithm Design Manual" — Skiena
- "Big-O Cheat Sheet" (bigocheatsheet.com)
- CP-Algorithms — Complexity
