# Greedy Algorithms - Curriculum

## Module 1: Greedy Fundamentals
- [ ] **Greedy algorithm**: make locally optimal choice at each step, hoping for global optimum
- [ ] **When it works**:
  - [ ] **Greedy choice property**: local optimum leads to global optimum
  - [ ] **Optimal substructure**: optimal includes optimal subproblems
- [ ] **Not always optimal**: greedy can fail, need to prove correctness
- [ ] **Greedy vs DP**: greedy = one choice per step, DP = explore all choices
- [ ] **When greedy fails**: use DP or other approaches
- [ ] **Proving correctness**:
  - [ ] **Exchange argument**: show any optimal can be transformed to greedy's output
  - [ ] **Staying ahead**: show greedy keeps best partial solution
  - [ ] **Matroid theory**: theoretical framework

## Module 2: Interval Scheduling
- [ ] **Activity Selection**: pick max non-overlapping activities
  - [ ] Greedy: sort by end time, pick earliest-ending first
  - [ ] Proof: exchange argument
- [ ] **Meeting Rooms**: can attend all meetings?
  - [ ] Sort by start time, check overlap
- [ ] **Meeting Rooms II**: min rooms needed
  - [ ] Heap by end time, or sweep line
- [ ] **Non-overlapping Intervals**: remove min intervals
- [ ] **Interval Merge**: sort, merge overlapping
- [ ] **Insert Interval**: merge into sorted intervals

## Module 3: Classical Greedy Problems
- [ ] **Fractional Knapsack**: value per weight ratio
  - [ ] Sort by ratio desc, take greedily
  - [ ] (0/1 knapsack is DP, not greedy)
- [ ] **Minimum Number of Coins** (greedy works for canonical coin systems like USD)
  - [ ] Take largest coin ≤ remaining, repeat
  - [ ] Fails for non-canonical systems → use DP
- [ ] **Jump Game**: can reach end?
  - [ ] Track max reachable
- [ ] **Jump Game II**: min jumps to reach end
  - [ ] BFS-like: track current furthest + next furthest
- [ ] **Gas Station**: can complete circuit?
  - [ ] Total sum check + running sum tracking

## Module 4: Huffman Coding
- [ ] **Problem**: build prefix-free binary code minimizing total bits
- [ ] **Algorithm**:
  1. [ ] Frequency count
  2. [ ] Build min-heap of (freq, char)
  3. [ ] Repeat: extract two smallest, combine into internal node with sum, insert back
  4. [ ] Result: Huffman tree (left = 0, right = 1)
- [ ] **Greedy choice**: always merge two smallest
- [ ] **Time**: O(n log n)
- [ ] **Optimal**: Huffman produces shortest prefix-free codes
- [ ] **Used in**: gzip, JPEG, MP3

## Module 5: Graph Greedy — MST
- [ ] **Minimum Spanning Tree**: subset of edges connecting all vertices with min total weight
- [ ] **Kruskal's algorithm**:
  - [ ] Sort edges by weight
  - [ ] Pick each edge if it doesn't form cycle (use Union-Find)
  - [ ] O(E log E)
- [ ] **Prim's algorithm**:
  - [ ] Grow tree from starting vertex
  - [ ] At each step, pick cheapest edge from tree to non-tree
  - [ ] Use priority queue: O(E log V)
- [ ] **Both greedy**: proof by cut property
- [ ] **Boruvka's**: parallel-friendly alternative

## Module 6: Dijkstra's Shortest Path
- [ ] **Problem**: single-source shortest path, non-negative weights
- [ ] **Greedy approach**:
  - [ ] Maintain set of "settled" vertices with known min distance
  - [ ] Pick unsettled with smallest distance, settle it
  - [ ] Relax outgoing edges
- [ ] **Time**: O((V+E) log V) with binary heap
- [ ] **Why it works**: non-negative weights ensure settled distances are final
- [ ] **Fails with negative weights**: need Bellman-Ford
- [ ] **Variants**:
  - [ ] Dial's algorithm (bucket queue)
  - [ ] Fibonacci heap (theoretical O(E + V log V))

## Module 7: Task Scheduling Problems
- [ ] **Task Scheduler**: execute tasks with cooldown between same tasks
  - [ ] Greedy: schedule most frequent first, fill with others
- [ ] **Reorganize String**: no adjacent same characters
  - [ ] Greedy: frequency sort, alternate
- [ ] **Minimum Time to Finish Tasks** with constraints
- [ ] **Two City Scheduling**: send N people to each city
  - [ ] Sort by cost difference
- [ ] **Assign Cookies**: satisfy most kids
  - [ ] Sort both, two pointers

## Module 8: Greedy on Strings
- [ ] **Remove K Digits**: smallest number after removal
  - [ ] Monotonic stack: remove when current < stack top
- [ ] **Largest Number**: concatenate to form largest
  - [ ] Custom comparator: `(a + b).compareTo(b + a)`
- [ ] **Partition Labels**: partition so each letter appears in at most one
  - [ ] Track last occurrence, greedy extend partition
- [ ] **Candy**: minimum candies with rating constraints
  - [ ] Two passes (left-to-right and right-to-left)

## Module 9: Greedy vs DP — Examples
- [ ] **Where greedy works**:
  - [ ] Activity selection
  - [ ] Fractional knapsack
  - [ ] Huffman coding
  - [ ] Dijkstra (non-negative)
  - [ ] MST
- [ ] **Where greedy fails, use DP**:
  - [ ] 0/1 knapsack
  - [ ] Coin change (non-canonical)
  - [ ] Longest common subsequence
  - [ ] Edit distance
  - [ ] Matrix chain multiplication
- [ ] **Proving greedy**: always test counterexamples first

## Module 10: Greedy Pitfalls
- [ ] **Overconfidence**: assuming greedy works without proof
- [ ] **Counterexamples**: coin change with [1, 3, 4] for amount 6
  - [ ] Greedy: 4+1+1 (3 coins)
  - [ ] Optimal: 3+3 (2 coins)
- [ ] **Sort order**: wrong sort → wrong answer
- [ ] **Tie-breaking**: secondary criteria matter
- [ ] **Test on small examples** before coding

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Activity Selection, Meeting Rooms II, Non-overlapping Intervals |
| Module 3 | Jump Game, Jump Game II, Gas Station |
| Module 4 | Implement Huffman coding |
| Module 5 | Implement Kruskal's and Prim's |
| Module 6 | Implement Dijkstra with priority queue |
| Module 7 | Task Scheduler, Reorganize String |
| Module 8 | Remove K Digits, Largest Number, Partition Labels, Candy |
| Module 9 | Identify greedy vs DP for 10 problems |
| Module 10 | Find counterexample for a naive greedy approach |

## Key Resources
- LeetCode Greedy tag
- "Introduction to Algorithms" (CLRS) — Chapter 16
- "Algorithms" — Sedgewick & Wayne
- CP-Algorithms — Greedy
