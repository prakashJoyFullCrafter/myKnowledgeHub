# Segment Tree & Fenwick Tree - Curriculum

Range query data structures for competitive programming and beyond.

---

## Module 1: Range Query Problems
- [ ] **Problem**: given an array, perform queries on subarrays (sum, min, max, GCD, etc.)
- [ ] **Naive**: O(n) per query, O(n × q) total
- [ ] **Prefix sum**: O(n) preprocess → O(1) range sum, but NO updates
- [ ] **Sorted structures**: O(log n) queries but costly inserts
- [ ] **Segment tree / Fenwick tree**: O(log n) for both queries and updates
- [ ] **Use cases**: dynamic range queries with updates

## Module 2: Fenwick Tree (Binary Indexed Tree / BIT)
- [ ] **Fenwick tree**: compact tree for prefix sums with updates
- [ ] **Operations**:
  - [ ] **Update** index by delta: O(log n)
  - [ ] **Prefix sum** up to index: O(log n)
  - [ ] **Range sum** `[l, r]`: `prefix(r) - prefix(l-1)`
- [ ] **Space**: O(n)
- [ ] **Implementation** (1-indexed):
  ```
  update(i, delta):
      while i <= n:
          tree[i] += delta
          i += i & -i   // add lowest set bit
  
  query(i):  // prefix sum [1..i]
      sum = 0
      while i > 0:
          sum += tree[i]
          i -= i & -i   // remove lowest set bit
      return sum
  ```
- [ ] **`i & -i`** trick: isolates lowest set bit
- [ ] **Elegant**: very short code, very fast

## Module 3: Fenwick Tree Applications
- [ ] **Dynamic prefix sum**: add/remove and query sums
- [ ] **Count inversions**: process right-to-left, query + update
- [ ] **Kth smallest element in a dynamic set**: Fenwick over value range
- [ ] **Range updates / point query**: use difference array concept
- [ ] **2D Fenwick tree**: rectangle sums, 2D updates
- [ ] **Fenwick for non-sum operations**: GCD, XOR (operations with inverse)
  - [ ] Doesn't work for min/max (no inverse)

## Module 4: Segment Tree Fundamentals
- [ ] **Segment tree**: binary tree where each node represents a segment of the array
- [ ] **Structure**: 4n space, recursive
- [ ] **Operations**:
  - [ ] **Build**: O(n)
  - [ ] **Point update**: O(log n)
  - [ ] **Range query**: O(log n)
- [ ] **Supports any associative operation**: sum, min, max, GCD, XOR, product...
- [ ] **More powerful than Fenwick**: handles min/max, range updates with lazy propagation
- [ ] **Cost**: more code, more memory

## Module 5: Segment Tree Implementation
- [ ] **Build** (recursive):
  ```
  build(node, start, end):
      if start == end:
          tree[node] = arr[start]
          return
      mid = (start + end) / 2
      build(2*node, start, mid)
      build(2*node+1, mid+1, end)
      tree[node] = tree[2*node] + tree[2*node+1]
  ```
- [ ] **Point update**: descend to leaf, update, propagate up
- [ ] **Range query**: descend, combine intersecting segments
- [ ] **Iterative segment tree**: non-recursive, faster constant factor
- [ ] **Memory-efficient variant**: use `2n` array instead of `4n`

## Module 6: Lazy Propagation
- [ ] **Problem**: naive range updates are O(n log n) per update
- [ ] **Lazy propagation**: defer updates until a descendant needs them
- [ ] **Lazy array**: pending updates stored per node
- [ ] **Push down**: when visiting a node with lazy, apply to children and clear
- [ ] **Enables**: **range updates in O(log n)**
- [ ] **Examples**:
  - [ ] Range add + range sum
  - [ ] Range assign + range max
  - [ ] Range flip (XOR) + range sum
- [ ] **Critical for**: many competitive programming problems

## Module 7: Advanced Segment Tree Variants
- [ ] **Persistent segment tree**: keep versions after updates (O(log n) per update)
  - [ ] Use case: range queries on historical versions
- [ ] **Segment tree with merging**: merge two trees (e.g., small-to-large trick)
- [ ] **Segment tree beats**: handles tricky operations (chmin, chmax)
- [ ] **2D segment tree**: rectangular queries
- [ ] **Dynamic segment tree**: node lazily allocated, for huge coordinate ranges
- [ ] **Wavelet tree**: alternative for certain queries

## Module 8: Choosing Between Fenwick and Segment Tree
- [ ] **Fenwick tree**:
  - [ ] Simpler, shorter code
  - [ ] Lower constant factor
  - [ ] Supports: sum, XOR, GCD (invertible operations)
  - [ ] Point update, prefix query
- [ ] **Segment tree**:
  - [ ] Supports min, max, any associative operation
  - [ ] Range updates via lazy propagation
  - [ ] More flexible but more code
- [ ] **Rule**: use Fenwick if sum-like works, segment tree if you need more

## Module 9: Common Problems
- [ ] **Range Sum Query — Mutable** (LeetCode 307): classic segment tree or Fenwick
- [ ] **Count Inversions**: Fenwick over coordinate compression
- [ ] **Count Smaller Numbers After Self**: Fenwick
- [ ] **Range Max**: segment tree (Fenwick doesn't work for max)
- [ ] **The Skyline Problem**: segment tree approach exists
- [ ] **Falling Squares**: segment tree with lazy propagation
- [ ] **Number of Longest Increasing Subsequence**: segment tree over values
- [ ] **Count of Range Sum**: merge sort or Fenwick

## Module 10: Performance & Pitfalls
- [ ] **Size**: segment tree array `4n`, Fenwick `n+1`
- [ ] **0-indexed vs 1-indexed**: Fenwick traditionally 1-indexed
- [ ] **Coordinate compression**: when values are sparse but large, map to 0..k-1
- [ ] **Off-by-one errors**: very common; test boundaries carefully
- [ ] **Lazy propagation bugs**: pushing down not correctly, order of operations
- [ ] **Avoid recursion when possible**: iterative is faster and avoids stack overflow
- [ ] **Practice**: implement both from scratch multiple times

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Compare naive, prefix sum, and BIT for range sum problem |
| Modules 2-3 | Implement Fenwick tree from scratch, solve Count Inversions |
| Module 4 | Implement recursive segment tree for range sum |
| Module 5 | Implement iterative segment tree |
| Module 6 | Add lazy propagation for range updates |
| Module 7 | Read about persistent segment tree |
| Module 8 | Decide BIT vs segtree for 5 problems |
| Module 9 | Solve 5 classic range query problems |
| Module 10 | Debug off-by-one errors in segment tree |

## Key Resources
- CP-Algorithms: Fenwick tree, Segment tree
- "Competitive Programming Handbook" — Antti Laaksonen
- USACO Guide: range queries
- Codeforces EDU: Segment Tree (free course)
