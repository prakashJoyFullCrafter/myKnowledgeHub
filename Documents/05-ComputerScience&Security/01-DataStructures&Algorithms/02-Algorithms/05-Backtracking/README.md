# Backtracking - Curriculum

## Module 1: Backtracking Fundamentals
- [ ] **Backtracking**: systematic search through solution space by trying partial solutions
- [ ] **Key idea**: build candidates incrementally, abandon ("backtrack") when can't lead to valid solution
- [ ] **Differs from brute force**: prunes invalid branches early
- [ ] **Differs from DP**: no memoization; explores all solutions
- [ ] **Template**:
  ```
  def backtrack(state):
      if is_solution(state):
          record(state)
          return
      for choice in choices(state):
          if valid(state, choice):
              apply(state, choice)
              backtrack(state)
              undo(state, choice)  # the "backtrack"
  ```
- [ ] **Time complexity**: usually exponential, pruning helps

## Module 2: Permutations
- [ ] **Permutations I**: all permutations of distinct elements
  - [ ] State: current permutation, used set
  - [ ] Choose element, recurse, unchoose
- [ ] **Permutations II** (with duplicates):
  - [ ] Sort + skip duplicates: `if i > 0 && nums[i] == nums[i-1] && !used[i-1]: continue`
- [ ] **Next Permutation**: lexicographically next (not backtracking — in-place)
- [ ] **Kth Permutation**: math-based or backtracking
- [ ] **Letter Case Permutation**: toggle case

## Module 3: Combinations
- [ ] **Combinations**: C(n, k)
  - [ ] State: current combo, start index
  - [ ] No repetition: pass start + 1 to next call
- [ ] **Combination Sum**: numbers sum to target (with reuse)
  - [ ] State: remaining target, start index, current list
- [ ] **Combination Sum II**: no reuse, may have duplicates
- [ ] **Combination Sum III**: k numbers summing to n from 1-9

## Module 4: Subsets
- [ ] **Subsets** (power set): all 2^n subsets
  - [ ] Backtracking: include / exclude each element
  - [ ] Or: iterate 0..2^n and check bits
- [ ] **Subsets II** (with duplicates):
  - [ ] Sort + skip duplicates
- [ ] **Partition Equal Subset Sum**: DP preferred, but backtracking works for small input

## Module 5: N-Queens
- [ ] **N-Queens**: place N queens on N×N board with no attacks
- [ ] **State**: array where `queens[row] = col`
- [ ] **Constraint check**:
  - [ ] Column: track used columns
  - [ ] Diagonal: track `row - col` and `row + col`
- [ ] **Efficient with bitmasks**: 3 bitmasks for col + both diagonals
- [ ] **N-Queens II**: count solutions only
- [ ] **Time**: O(N!), pruning makes it much faster

## Module 6: Sudoku Solver
- [ ] **Problem**: fill 9×9 grid satisfying row, column, box constraints
- [ ] **Backtracking approach**:
  1. [ ] Find empty cell
  2. [ ] Try digits 1-9
  3. [ ] If valid, recurse
  4. [ ] If no digit works, backtrack
- [ ] **Optimization**:
  - [ ] Pick cell with fewest candidates (most constrained variable)
  - [ ] Bitmask for row/col/box used digits
- [ ] **Constraint propagation**: advanced — update candidates globally

## Module 7: Word Search & Grid Backtracking
- [ ] **Word Search**: find word in 2D board
  - [ ] DFS + backtracking
  - [ ] Mark cell visited, recurse, unmark
- [ ] **Word Search II** (many words):
  - [ ] Use Trie for efficient multi-word search
- [ ] **Robot Room Cleaner**: explore grid with limited API
- [ ] **Path finding in grid with constraints**

## Module 8: Palindrome Partitioning
- [ ] **Palindrome Partitioning**: split string into palindrome substrings
  - [ ] For each cut point: if prefix is palindrome, recurse on rest
- [ ] **Palindrome Partitioning II**: min cuts (DP is better)
- [ ] **Restore IP Addresses**: partition into 4 valid octets
  - [ ] Try 1-3 character prefix, validate (0-255, no leading zero)
- [ ] **Valid IPv6 addresses**

## Module 9: Constraint Satisfaction Problems
- [ ] **CSP**: variables, domains, constraints
- [ ] **Examples**:
  - [ ] N-Queens
  - [ ] Sudoku
  - [ ] Graph coloring
  - [ ] Cryptarithmetic (SEND + MORE = MONEY)
- [ ] **Techniques**:
  - [ ] **Backtracking** (baseline)
  - [ ] **Forward checking**: prune after each assignment
  - [ ] **Arc consistency** (AC-3): maintain consistency
  - [ ] **Variable ordering**: most constrained first
  - [ ] **Value ordering**: least constraining first

## Module 10: Optimization & Pruning
- [ ] **Pruning techniques**:
  - [ ] **Early termination**: found enough solutions, return
  - [ ] **Bound pruning**: partial solution can't beat best so far
  - [ ] **Constraint propagation**: deduce forced assignments
  - [ ] **Symmetry breaking**: skip rotations/reflections
- [ ] **Branch and bound**: backtracking with upper/lower bound tracking
- [ ] **Memoization**: cache partial results if applicable
- [ ] **Iterative deepening**: limit depth, increase gradually
- [ ] **Common anti-patterns**:
  - [ ] Not restoring state (forgetting "unchoose")
  - [ ] Duplicating work (no pruning)
  - [ ] Copying state unnecessarily (mutate + restore instead)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Write backtracking template from memory |
| Module 2 | Permutations I, Permutations II |
| Module 3 | Combinations, Combination Sum I/II/III |
| Module 4 | Subsets, Subsets II |
| Module 5 | N-Queens, N-Queens II with bitmask |
| Module 6 | Sudoku Solver |
| Module 7 | Word Search I, Word Search II (with Trie) |
| Module 8 | Palindrome Partitioning, Restore IP Addresses |
| Module 9 | Solve a cryptarithmetic problem |
| Module 10 | Optimize a backtracking solution with pruning |

## Key Resources
- LeetCode Backtracking tag
- "Introduction to Algorithms" (CLRS) — coverage in NP/search
- NeetCode.io — Backtracking patterns
- "Artificial Intelligence: A Modern Approach" — CSP chapter
