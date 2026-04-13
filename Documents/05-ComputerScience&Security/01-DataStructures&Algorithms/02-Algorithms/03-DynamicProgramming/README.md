# Dynamic Programming - Curriculum

## Module 1: DP Fundamentals
- [ ] **Dynamic Programming**: solve problems by combining solutions to subproblems
- [ ] **When DP applies**:
  - [ ] **Optimal substructure**: optimal solution built from optimal solutions to subproblems
  - [ ] **Overlapping subproblems**: same subproblems solved multiple times
- [ ] **Without DP**: exponential (recursive)
- [ ] **With DP**: polynomial via memoization
- [ ] **Not every recursive problem is DP**: needs overlapping subproblems
- [ ] **DP vs Divide & Conquer**: D&C has disjoint subproblems, DP has overlap
- [ ] **DP vs Greedy**: DP considers all options, greedy locally optimal

## Module 2: Top-Down (Memoization) vs Bottom-Up (Tabulation)
- [ ] **Top-down (memoization)**:
  - [ ] Recursive with cache
  - [ ] Natural formulation
  - [ ] Only computes needed subproblems
  - [ ] Risk of stack overflow
- [ ] **Bottom-up (tabulation)**:
  - [ ] Iterative, fill table
  - [ ] No recursion overhead
  - [ ] Computes all subproblems (even unused)
  - [ ] Easier to optimize space
- [ ] **Recognizing DP**: recursive formulation + `cache[state]` = done
- [ ] **State definition**: what identifies a subproblem?
- [ ] **Transition**: how do subproblems combine?

## Module 3: Recognizing DP Problems
- [ ] **Signals**:
  - [ ] "Find min/max/count of paths/ways/arrangements"
  - [ ] "Optimal" or "best" solution
  - [ ] Can break into choices at each step
  - [ ] Same subproblem recurs
- [ ] **Steps to solve**:
  1. [ ] Identify state (parameters to recursive function)
  2. [ ] Write recurrence (how to compute state from smaller states)
  3. [ ] Find base cases
  4. [ ] Determine order of computation
  5. [ ] Optimize space (often possible)

## Module 4: 1D DP — Linear
- [ ] **Climbing Stairs**: `dp[i] = dp[i-1] + dp[i-2]` (Fibonacci)
- [ ] **House Robber**: `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`
  - [ ] Variant: House Robber II (circular)
- [ ] **Coin Change** (min coins): `dp[amount] = min(dp[amount-coin] + 1)`
- [ ] **Word Break**: `dp[i] = OR over j: dp[j] && s[j..i] in dict`
- [ ] **Decode Ways**: `dp[i] = dp[i-1] (if valid) + dp[i-2] (if valid)`
- [ ] **Longest Increasing Subsequence** (LIS): O(n²) DP, O(n log n) with binary search
- [ ] **Maximum Subarray** (Kadane): `dp[i] = max(nums[i], dp[i-1] + nums[i])`

## Module 5: 2D DP — Grid & String
- [ ] **Unique Paths**: `dp[i][j] = dp[i-1][j] + dp[i][j-1]`
- [ ] **Minimum Path Sum**: `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`
- [ ] **Longest Common Subsequence** (LCS): `dp[i][j] = dp[i-1][j-1]+1 if match else max(dp[i-1][j], dp[i][j-1])`
- [ ] **Edit Distance** (Levenshtein):
  - [ ] Insert, delete, replace operations
  - [ ] `dp[i][j] = dp[i-1][j-1] if match else 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])`
- [ ] **Distinct Subsequences**: count ways to form T from S
- [ ] **Interleaving String**: is s3 interleaving of s1, s2?
- [ ] **Regular Expression / Wildcard Matching**

## Module 6: Knapsack Patterns
- [ ] **0/1 Knapsack**: each item used at most once
  - [ ] `dp[i][w] = max(dp[i-1][w], dp[i-1][w-weight[i]] + value[i])`
  - [ ] Space optimization: 1D array, iterate backward
- [ ] **Unbounded Knapsack**: unlimited copies
  - [ ] `dp[w] = max(dp[w], dp[w-weight[i]] + value[i])` — iterate forward
- [ ] **Bounded Knapsack**: limited copies per item
- [ ] **Variants**:
  - [ ] **Subset Sum**: can subset sum to target?
  - [ ] **Partition Equal Subset Sum**
  - [ ] **Coin Change** (count ways): unbounded knapsack count variant
  - [ ] **Target Sum**: assign +/- to reach target
- [ ] **Fractional Knapsack**: NOT DP (greedy)

## Module 7: String DP
- [ ] **Palindromes**:
  - [ ] **Longest Palindromic Substring**: expand around center O(n²), DP O(n²)
  - [ ] **Longest Palindromic Subsequence**: LCS(s, reverse(s))
  - [ ] **Palindrome Partitioning (min cuts)**
  - [ ] **Count Palindromic Substrings**
- [ ] **Subsequences**:
  - [ ] **LCS** (Longest Common Subsequence)
  - [ ] **Shortest Common Supersequence**
  - [ ] **Longest Palindromic Subsequence**
- [ ] **Substrings**:
  - [ ] **Longest Common Substring**: reset on mismatch
  - [ ] **Longest Repeating Substring**
- [ ] **Transformation**:
  - [ ] **Edit Distance**
  - [ ] **Minimum Deletions to Make Palindrome**

## Module 8: Interval DP
- [ ] **Template**: `dp[i][j]` represents optimal for range [i..j]
- [ ] **Iteration**: outer loop by length, inner by start
- [ ] **Matrix Chain Multiplication**: min cost to multiply chain
- [ ] **Burst Balloons**: max coins from bursting balloons
- [ ] **Minimum Cost Tree From Leaf Values**
- [ ] **Stone Game** variations
- [ ] **Guess Number Higher or Lower II**: min cost worst case

## Module 9: State Machine / Stock Problems
- [ ] **Best Time to Buy and Sell Stock** (with variations):
  - [ ] I: one transaction
  - [ ] II: unlimited transactions
  - [ ] III: at most 2 transactions
  - [ ] IV: at most k transactions
  - [ ] With cooldown
  - [ ] With transaction fee
- [ ] **State machine approach**:
  - [ ] States: holding, not holding, in cooldown
  - [ ] Transitions: buy, sell, do nothing

## Module 10: Advanced & Optimizations
- [ ] **Bitmask DP**: represent subset as bitmask
  - [ ] **Traveling Salesman Problem**: `dp[mask][i]`
  - [ ] Works for small N (≤ 20)
- [ ] **Digit DP**: count numbers with digit constraint
  - [ ] State: position, tight, started, additional constraints
- [ ] **DP on Trees**: DFS computing dp per subtree
  - [ ] **House Robber III**: tree version
  - [ ] **Longest Path in Tree**
- [ ] **Space optimization**:
  - [ ] Rolling array (only need last row)
  - [ ] Two variables for 1D DP
- [ ] **DP on graphs**: Bellman-Ford, Floyd-Warshall are DP
- [ ] **Divide & conquer DP optimization**: Knuth, convex hull trick

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Solve climbing stairs, Fibonacci, house robber |
| Module 4 | LIS, Coin Change, Word Break |
| Module 5 | Unique Paths, Min Path Sum, LCS, Edit Distance |
| Module 6 | 0/1 and Unbounded Knapsack, Partition Equal Subset Sum |
| Module 7 | Longest Palindromic Substring/Subsequence |
| Module 8 | Matrix Chain Multiplication, Burst Balloons |
| Module 9 | All 6 stock problems |
| Module 10 | TSP (small), Digit DP problem |

## Key Resources
- LeetCode DP tag
- NeetCode.io — DP patterns
- "Introduction to Algorithms" (CLRS) — Chapter 15
- "Competitive Programming Handbook" — Antti Laaksonen
- CP-Algorithms — DP
