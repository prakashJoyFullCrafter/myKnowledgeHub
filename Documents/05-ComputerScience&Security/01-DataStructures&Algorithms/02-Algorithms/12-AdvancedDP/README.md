# Advanced Dynamic Programming - Curriculum

Beyond standard DP: optimizations, bitmask, digit, tree, and game-theoretic DP.

---

## Module 1: DP Optimization Overview
- [ ] **Standard DP** often has O(n²) or O(n³) complexity
- [ ] **Optimizations can reduce this** with structural properties:
  - [ ] Monotonic optimality
  - [ ] Convexity / Concavity
  - [ ] Divide & Conquer applicability
- [ ] **Common optimizations**:
  - [ ] Space reduction (rolling array)
  - [ ] Knuth optimization
  - [ ] Divide & Conquer DP optimization
  - [ ] Convex Hull Trick
  - [ ] SOS (sum over subsets)
- [ ] **Competitive programming territory**: rarely in interviews, essential for contests

## Module 2: Bitmask DP
- [ ] **Key idea**: represent subset as bitmask (integer)
- [ ] **State**: `dp[mask]` or `dp[mask][i]`
- [ ] **When to use**: combinatorial problems with small N (≤ 20)
- [ ] **Traveling Salesman Problem (TSP)**:
  - [ ] `dp[mask][i]` = min cost to visit cities in mask, ending at i
  - [ ] Transition: from dp[mask ^ (1 << i)][j] for all j in mask, j != i
  - [ ] O(n² · 2ⁿ)
- [ ] **Assignment problem**: assign n tasks to n people
- [ ] **Subset sum variations**
- [ ] **Shortest Hamilton Path**: similar to TSP

## Module 3: Iterating Bitmask Subsets
- [ ] **All subsets of mask**:
  ```
  for s = mask; s > 0; s = (s - 1) & mask:
      process(s)
  ```
- [ ] **Why it works**: decrements through submasks only
- [ ] **Complexity**: sum over all masks of (number of submasks) = 3ⁿ total
- [ ] **Sum Over Subsets (SOS) DP**:
  - [ ] Compute `f[mask] = sum of g[s] for all s subset of mask`
  - [ ] Naive: O(3ⁿ), SOS: O(n · 2ⁿ)
  - [ ] Each bit processed independently

## Module 4: Digit DP
- [ ] **Problem**: count numbers in [L, R] with digit constraint
- [ ] **State**: `dp[pos][tight][started][state]`
  - [ ] `pos`: current digit position
  - [ ] `tight`: if prefix equals upper bound prefix
  - [ ] `started`: leading zeros vs started number
  - [ ] Other state: accumulated constraint info
- [ ] **Transition**: try each digit 0-9 (or 0 to upper if tight)
- [ ] **Classic problems**:
  - [ ] Count numbers with sum of digits = S
  - [ ] Count numbers not containing digit 4
  - [ ] Count numbers with given remainder
- [ ] **Technique**: compute f(R) - f(L-1)

## Module 5: DP on Trees
- [ ] **Tree DP**: bottom-up DP using DFS on tree
- [ ] **State**: `dp[node]` or `dp[node][extra]`
- [ ] **Classic problems**:
  - [ ] **Diameter of tree**: longest path
  - [ ] **Max path sum**: any path
  - [ ] **House Robber III**: rob nodes, no adjacent
  - [ ] **Tree subset sum**: subset with given sum
  - [ ] **Number of subtrees**: counting
- [ ] **Rerooting technique**:
  - [ ] Two DFS passes to compute answer with each node as root
  - [ ] O(n) total
- [ ] **Tree + bitmask**: small leaf sets

## Module 6: Interval DP
- [ ] **Template**: `dp[i][j]` represents optimal over range [i..j]
- [ ] **Iteration**: outer loop by length, inner by start
- [ ] **Classic problems**:
  - [ ] **Matrix Chain Multiplication**: min scalar multiplications
  - [ ] **Burst Balloons**: max coins from bursting
  - [ ] **Minimum Cost to Merge Stones**
  - [ ] **Optimal Binary Search Tree**
  - [ ] **Stone Game series**
- [ ] **Knuth optimization applies** to some interval DPs
  - [ ] Reduces O(n³) to O(n²)
  - [ ] Requires certain monotonicity

## Module 7: Game Theory DP
- [ ] **Two-player games**: DP over game states
- [ ] **Minimax**: player maximizes, opponent minimizes
- [ ] **State**: `dp[state]` = score difference for current player
- [ ] **Examples**:
  - [ ] **Stone Game**: take stones from ends
  - [ ] **Nim Game**: XOR-based analysis (Sprague-Grundy)
  - [ ] **Predict the Winner**
- [ ] **Sprague-Grundy theorem**: every impartial game is equivalent to a Nim pile
  - [ ] Grundy number (nimber): XOR of game states
- [ ] **Mex function**: minimum excludant

## Module 8: Knuth Optimization
- [ ] **Applicable when**: `dp[i][j] = min over k: dp[i][k-1] + dp[k][j] + cost(i, j)`
- [ ] **Quadrangle inequality** condition on cost:
  - [ ] `cost(a,c) + cost(b,d) ≤ cost(a,d) + cost(b,c)` for a ≤ b ≤ c ≤ d
- [ ] **Result**: reduces O(n³) to O(n²)
- [ ] **Optimal k** is monotonic in i and j
- [ ] **Applications**: Optimal BST, certain partition problems
- [ ] **Verification**: prove quadrangle inequality for the cost function

## Module 9: Convex Hull Trick (CHT)
- [ ] **Problem**: optimize DP transition of form `dp[i] = min over j: dp[j] + a[j]*b[i]`
- [ ] **Idea**: treat each `(dp[j], a[j])` as a line `y = a[j]·x + dp[j]`
- [ ] **Query**: evaluate all lines at `x = b[i]`, take min → lower envelope
- [ ] **Data structure**: dynamic lower/upper hull
- [ ] **Reduces**: O(n²) to O(n log n) or O(n) amortized
- [ ] **Li Chao tree**: alternative for arbitrary query order
- [ ] **Applications**:
  - [ ] Batch scheduling
  - [ ] Many optimization DP problems in competitive programming

## Module 10: Divide & Conquer DP Optimization
- [ ] **Applicable when**: optimal split point is monotonic
- [ ] **Idea**: recursively compute dp[l..r] given that optimal splits lie in [optL..optR]
- [ ] **Reduces**: O(kn²) to O(kn log n)
- [ ] **Example**: partition n elements into k groups minimizing total cost
- [ ] **Monotonicity check**: if `opt(i) ≤ opt(j)` for i < j

## Module 11: Expectation / Probability DP
- [ ] **State**: expected value or probability
- [ ] **Transition**: weighted sum over choices
- [ ] **Examples**:
  - [ ] **Knight on chessboard probability of survival**
  - [ ] **Dice sum probability**
  - [ ] **Expected number of coin flips**
- [ ] **Linearity of expectation**: simplifies many problems
- [ ] **Often simpler than combinatorics**: avoid complex counting

## Module 12: SOS DP (Sum Over Subsets)
- [ ] **Goal**: compute `f[S] = sum over T ⊆ S of g[T]` for all S
- [ ] **Naive**: O(3ⁿ)
- [ ] **SOS DP**: O(n · 2ⁿ) by processing bits one at a time
- [ ] **Template**:
  ```
  f[mask] = g[mask]
  for b in 0..n-1:
      for mask in 0..(1<<n)-1:
          if mask has bit b:
              f[mask] += f[mask ^ (1 << b)]
  ```
- [ ] **Dual**: superset sum (loop differently)
- [ ] **Applications**: zeta transform, Mobius transform, enumeration

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Identify optimization potential in 5 standard DP problems |
| Module 2 | Implement TSP with bitmask DP |
| Module 3 | Implement submask enumeration |
| Module 4 | Solve "count numbers with sum of digits S in [L, R]" |
| Module 5 | Diameter of tree, House Robber III, rerooting problem |
| Module 6 | Matrix Chain Multiplication, Burst Balloons |
| Module 7 | Stone Game with minimax |
| Module 8 | Read Knuth optimization proof |
| Module 9 | Implement Convex Hull Trick |
| Module 10 | Implement D&C DP optimization |
| Module 11 | Expected dice sum problem |
| Module 12 | Implement SOS DP |

## Key Resources
- "Competitive Programming Handbook" — Laaksonen
- CP-Algorithms — DP section
- "Guide to Competitive Programming"
- Codeforces EDU: DP optimizations
- "Advanced Dynamic Programming" — USACO Guide
