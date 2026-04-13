# Union-Find (Disjoint Set Union) - Curriculum

Deep dive into Union-Find: the surprisingly powerful data structure for connectivity.

---

## Module 1: Union-Find Fundamentals
- [ ] **Union-Find / Disjoint Set Union (DSU)**: tracks partitioning of elements into disjoint sets
- [ ] **Two operations**:
  - [ ] **find(x)**: which set does x belong to? (returns representative)
  - [ ] **union(x, y)**: merge the sets containing x and y
- [ ] **Use cases**: connectivity, components, Kruskal's MST, cycle detection, offline LCA
- [ ] **Representation**: parent pointer per element, root as representative
- [ ] **Forest of trees**: each set is a tree, root points to itself

## Module 2: Naive Implementation
- [ ] **parent array**: `parent[i] = parent of i` (or `i` if root)
- [ ] **find(x)**: walk up until parent[x] == x
- [ ] **union(x, y)**: `parent[find(x)] = find(y)`
- [ ] **Complexity**:
  - [ ] Worst case: O(n) per operation (degenerate linked-list)
  - [ ] Happens when you naively union everything in order
- [ ] **Unacceptable for large inputs** without optimization

## Module 3: Union by Rank / Size
- [ ] **Problem**: long trees slow down `find`
- [ ] **Solution**: attach smaller tree under bigger tree
- [ ] **Union by size**: track size, attach smaller under larger
- [ ] **Union by rank**: track upper bound on tree height
- [ ] **Effect**: keeps trees balanced, depth O(log n)
- [ ] **Time**: O(log n) per operation with union by rank alone

## Module 4: Path Compression
- [ ] **Idea**: flatten tree during `find`
- [ ] **Implementation**: during find, point every visited node directly to root
  ```
  find(x):
      if parent[x] != x:
          parent[x] = find(parent[x])  // compress
      return parent[x]
  ```
- [ ] **Alternative — halving**: `parent[x] = parent[parent[x]]` during traversal
- [ ] **Alternative — splitting**: two-pass flatten
- [ ] **Alone**: amortized O(log n)

## Module 5: Combining Optimizations
- [ ] **Union by rank + path compression**: nearly O(1) amortized
- [ ] **Precise complexity**: **O(α(n))** where α is inverse Ackermann
  - [ ] α(n) < 5 for any practical n (α(10^80) < 5)
  - [ ] Effectively constant
- [ ] **Proof**: Tarjan's analysis — one of algorithm theory's highlights
- [ ] **Practical**: implement both together for maximum efficiency

## Module 6: Complete Java Implementation
- [ ] **Typical implementation**:
  ```java
  class UnionFind {
      int[] parent, rank;
      int count;  // number of components
      
      UnionFind(int n) {
          parent = new int[n];
          rank = new int[n];
          count = n;
          for (int i = 0; i < n; i++) parent[i] = i;
      }
      
      int find(int x) {
          if (parent[x] != x)
              parent[x] = find(parent[x]);
          return parent[x];
      }
      
      boolean union(int x, int y) {
          int rx = find(x), ry = find(y);
          if (rx == ry) return false;
          if (rank[rx] < rank[ry]) { parent[rx] = ry; }
          else if (rank[rx] > rank[ry]) { parent[ry] = rx; }
          else { parent[ry] = rx; rank[rx]++; }
          count--;
          return true;
      }
  }
  ```
- [ ] **Component count**: track count, decrement on successful union

## Module 7: Classic Problems
- [ ] **Number of Connected Components**: union all edges, return count
- [ ] **Number of Islands II**: add lands incrementally, union with neighbors
- [ ] **Graph Valid Tree**: n nodes, n-1 edges, no cycle, all connected
- [ ] **Redundant Connection**: find edge that creates cycle
- [ ] **Accounts Merge**: union emails with same owner
- [ ] **Satisfiability of Equality Equations**: union equal variables
- [ ] **Most Stones Removed**: group by row/column via union
- [ ] **Smallest String With Swaps**: union swappable positions

## Module 8: Kruskal's MST
- [ ] **Minimum Spanning Tree**: subset of edges connecting all vertices with min weight
- [ ] **Kruskal's algorithm**:
  1. [ ] Sort edges by weight
  2. [ ] For each edge (u, v): if find(u) != find(v), union them, add to MST
  3. [ ] Stop when MST has n-1 edges
- [ ] **Time**: O(E log E) for sort + O(E α(V)) for DSU
- [ ] **Why Union-Find**: efficient cycle detection

## Module 9: Advanced Techniques
- [ ] **Union-Find with rollback**: support undo operations
  - [ ] Stack of changes, roll back on request
  - [ ] Used in offline problems
- [ ] **Weighted Union-Find**: maintain additional info (e.g., distance to root)
  - [ ] Use case: equations, relative positions
- [ ] **Union-Find with small-to-large**: general technique
- [ ] **Offline LCA (Tarjan's)**: process queries offline using DSU
- [ ] **Persistent Union-Find**: retain history (advanced)
- [ ] **DSU on tree (small-to-large merging)**: answer subtree queries

## Module 10: Complexity Proof Sketch
- [ ] **Amortized α(n)**: inverse Ackermann function
- [ ] **Ackermann function**: grows incredibly fast
- [ ] **Inverse**: grows incredibly slow
- [ ] **Proof idea**: accounting method, levels in rank
- [ ] **Practical**: treat as O(1) in interview discussions
- [ ] **Lower bound**: Ω(α(n)) is actually tight (Fredman-Saks)
- [ ] **Impressive result**: near-constant for all practical purposes

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement naive union-find |
| Module 3 | Add union by rank, measure improvement |
| Module 4 | Add path compression |
| Module 5 | Combine both, verify near-constant |
| Module 6 | Generic implementation supporting any number of elements |
| Module 7 | Number of Islands II, Accounts Merge, Redundant Connection |
| Module 8 | Implement Kruskal's MST |
| Module 9 | Read about weighted UF, implement for equations |
| Module 10 | Read Tarjan's amortized proof |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapter 21
- CP-Algorithms — DSU
- Tarjan's paper on Union-Find analysis
- LeetCode Union-Find tag
