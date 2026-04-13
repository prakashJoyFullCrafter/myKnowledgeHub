# Space vs Time Trade-offs - Curriculum

## Module 1: The Fundamental Trade-off
- [ ] **Space-time trade-off**: sacrifice one resource for gains in the other
- [ ] **Use more space to save time**: caching, precomputation, lookup tables
- [ ] **Use more time to save space**: in-place algorithms, recomputation
- [ ] **Both matter**: memory limits, large datasets
- [ ] **Modern context**: memory is cheap and abundant, but cache misses are expensive
- [ ] **Not always exchangeable**: some problems need both optimal

## Module 2: Caching & Memoization
- [ ] **Memoization**: cache function results for reuse
- [ ] **Trade**: O(n) space for O(n) → O(1) amortized
- [ ] **Example**: Fibonacci
  - [ ] Naive: O(2ⁿ) time, O(n) space (recursion)
  - [ ] Memoized: O(n) time, O(n) space
  - [ ] Iterative: O(n) time, O(1) space
- [ ] **DP**: systematic memoization
- [ ] **Cache-aside pattern**: explicit cache management
- [ ] **LRU Cache**: bounded space, best trade-off for hot data

## Module 3: Precomputation
- [ ] **Idea**: do expensive work once, reuse cheaply
- [ ] **Examples**:
  - [ ] **Prefix sum**: O(n) precompute → O(1) range sum
  - [ ] **Sparse table**: O(n log n) precompute → O(1) range min/max
  - [ ] **Suffix array**: O(n log n) precompute → O(m log n) substring search
  - [ ] **Sieve of Eratosthenes**: O(n log log n) → O(1) primality check for ≤ n
- [ ] **When to use**: many queries on same data
- [ ] **When NOT to use**: one-off query, data changes frequently

## Module 4: Hash Tables — Space for Time
- [ ] **O(n) space** to achieve **O(1) lookup**
- [ ] **Examples**:
  - [ ] Two Sum: hash for O(n) vs O(n²)
  - [ ] Visited tracking: hash set instead of scanning
  - [ ] Frequency counting: hash vs sort + count
- [ ] **Trade-off cost**:
  - [ ] Memory overhead (per-entry)
  - [ ] Cache miss cost
  - [ ] Hashing cost
- [ ] **When hash is overkill**: small input, sorted data, integer range

## Module 5: Lookup Tables
- [ ] **Precomputed answers**: array-based cache
- [ ] **Examples**:
  - [ ] `popcount`: precompute 256-byte table
  - [ ] Trigonometric tables: sin/cos for discrete angles
  - [ ] Character classification: `isalpha`, `isdigit` tables
- [ ] **Advantages**: O(1) lookup, no branching
- [ ] **Disadvantages**: memory footprint
- [ ] **Cache-friendly**: small tables fit in L1

## Module 6: In-Place Algorithms
- [ ] **In-place**: O(1) auxiliary space (sometimes O(log n) for recursion)
- [ ] **Examples**:
  - [ ] **In-place quicksort, heap sort**: sort without extra array
  - [ ] **Reverse array in place**: two-pointer swap
  - [ ] **Rotate array in place**: triple reverse
  - [ ] **Remove duplicates from sorted array**
  - [ ] **Kadane's algorithm**: O(1) extra space
- [ ] **When needed**: embedded systems, huge arrays, memory-bound processing
- [ ] **Trade-off**: may be slower, trickier to implement

## Module 7: Streaming Algorithms
- [ ] **Problem**: process data too large for memory
- [ ] **Approach**: single pass, limited memory
- [ ] **Examples**:
  - [ ] **Reservoir sampling**: pick K random items from stream
  - [ ] **Count-Min sketch**: approximate frequency counts
  - [ ] **HyperLogLog**: approximate distinct count
  - [ ] **Bloom filter**: probabilistic set membership
- [ ] **Trade-off**: exact answers (more space) vs approximate (less space)
- [ ] **Applications**: log processing, network monitoring, real-time analytics

## Module 8: Recomputation
- [ ] **Idea**: don't store intermediate results, recompute as needed
- [ ] **Examples**:
  - [ ] **Reverse a number**: recompute digits instead of storing
  - [ ] **Nth Fibonacci**: iterative with 2 variables
  - [ ] **Huffman decode**: walk tree, no lookup table
- [ ] **When to prefer**: memory constrained, simple operations
- [ ] **Trade-off**: more CPU, less memory
- [ ] **Checkpoint/recovery**: recompute state from checkpoint

## Module 9: Space Optimization in DP
- [ ] **Rolling array**: 2D DP → 1D when only last row needed
  - [ ] Knapsack: `dp[w] = max(dp[w], dp[w-weight] + value)`
- [ ] **Two variables**: 1D DP → O(1) when only two previous values needed
  - [ ] Fibonacci, Climbing Stairs
- [ ] **Sliding window in DP**: keep only recent K values
- [ ] **Rules**:
  - [ ] Identify dependency — often only previous row/column matters
  - [ ] Watch update order (forward vs backward) to avoid overwrites
- [ ] **Example**: LCS 2D O(mn) → O(min(m,n)) with rolling

## Module 10: Real-World Examples
- [ ] **Database indexes**: extra storage for faster queries
- [ ] **CDN caching**: network data stored closer → faster response
- [ ] **Compiled code vs interpretation**: memory for bytecode vs slow interpretation
- [ ] **Precomputed tables in games**: lookup vs runtime computation
- [ ] **Materialized views**: storage vs query time
- [ ] **Bloom filter in Bigtable/Cassandra**: small space to avoid disk lookups
- [ ] **CPU caches**: hardware-level space-time trade-off
- [ ] **Choosing**: depends on query pattern, constraints, cost

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement Fibonacci in 3 ways (naive, memo, iterative) |
| Module 3 | Implement sieve of Eratosthenes, use for prime queries |
| Module 4 | Solve Two Sum in O(n²) and O(n) with hash |
| Module 5 | Implement popcount with 256-entry lookup table |
| Module 6 | Reverse array and rotate array in place |
| Module 7 | Implement reservoir sampling |
| Module 8 | Compute Nth Fibonacci with O(1) space |
| Module 9 | Convert a 2D DP solution to O(n) space |
| Module 10 | Analyze space-time trade-offs in 5 system designs |

## Key Resources
- "Introduction to Algorithms" (CLRS)
- "Programming Pearls" — Jon Bentley
- LeetCode tag: space optimization
- CP-Algorithms — Precomputation
