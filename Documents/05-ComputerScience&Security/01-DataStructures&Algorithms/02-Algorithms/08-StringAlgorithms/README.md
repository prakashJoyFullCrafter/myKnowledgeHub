# String Algorithms - Curriculum

Efficient string matching and processing — far beyond naive O(n*m).

---

## Module 1: String Matching Problem
- [ ] **Problem**: find pattern P of length m in text T of length n
- [ ] **Naive approach**: O(n*m) — check each starting position
- [ ] **Better algorithms**: O(n + m)
- [ ] **Applications**: search engines, DNA matching, intrusion detection, compilers
- [ ] **Key insight**: use pattern structure to skip work

## Module 2: KMP Algorithm
- [ ] **KMP (Knuth-Morris-Pratt)**: first O(n + m) string matching
- [ ] **Key idea**: precompute failure function (partial match table)
- [ ] **Failure function `π[i]`**: length of longest proper prefix of P[0..i] that is also suffix
- [ ] **Build failure function**: O(m) using the pattern itself
- [ ] **Matching**: O(n) using failure function to skip on mismatch
- [ ] **No backtracking in text**: key insight
- [ ] **Applications**: exact match, count occurrences, find all matches
- [ ] **Hard to implement correctly**: practice needed

## Module 3: Z-Algorithm
- [ ] **Z-function**: for each i, length of longest substring starting at i matching prefix
- [ ] **`z[i]`**: `z[i]` = max k such that `s[0..k-1] == s[i..i+k-1]`
- [ ] **Build in O(n)**: amortized using Z-box
- [ ] **Use for matching**: concatenate `P + '$' + T`, compute Z, find Z values ≥ m
- [ ] **Simpler than KMP**: often easier to implement
- [ ] **Same complexity**: O(n + m)
- [ ] **More intuitive**: direct prefix comparisons

## Module 4: Rabin-Karp (Rolling Hash)
- [ ] **Hash-based string matching**
- [ ] **Idea**: hash the pattern, slide window of text, compare hashes
- [ ] **Rolling hash**: O(1) update when window slides
  - [ ] `new_hash = (old_hash - old_char * p^(m-1)) * p + new_char`
- [ ] **Polynomial hash**: `hash(s) = s[0] + s[1]*p + s[2]*p² + ...` mod M
- [ ] **Collision handling**: verify actual match on hash match
- [ ] **Average case**: O(n + m); **worst case**: O(n*m) (rare)
- [ ] **Best for**: multiple pattern matching, long texts
- [ ] **Double hashing**: two moduli to reduce collision probability

## Module 5: Suffix Array
- [ ] **Suffix array**: sorted array of all suffixes of a string
- [ ] **Naive construction**: O(n² log n) by sorting
- [ ] **DC3 / SA-IS**: O(n) optimal construction
- [ ] **O(n log n) construction**: doubling + radix sort
- [ ] **LCP array**: longest common prefix between consecutive sorted suffixes
  - [ ] Kasai's algorithm: O(n) given suffix array
- [ ] **Applications**:
  - [ ] Substring search: binary search on suffix array, O(m log n)
  - [ ] Longest repeated substring: max LCP
  - [ ] Longest common substring of two strings
  - [ ] Number of distinct substrings

## Module 6: Suffix Tree
- [ ] **Suffix tree**: trie of all suffixes, compacted
- [ ] **Size**: O(n) nodes (with edge labels as substrings)
- [ ] **Ukkonen's algorithm**: O(n) online construction
- [ ] **Complex to implement**: harder than suffix array
- [ ] **Applications**: same as suffix array, plus:
  - [ ] Longest common substring in linear time
  - [ ] Generalized suffix tree for multiple strings
- [ ] **Memory**: higher constant factor than suffix array
- [ ] **Practice**: suffix array usually preferred for contests

## Module 7: Aho-Corasick
- [ ] **Multi-pattern matching**: find multiple patterns in one pass
- [ ] **Idea**: KMP generalized to a trie of patterns
- [ ] **Structure**: trie + failure links (like KMP failure function)
- [ ] **Construction**: O(total pattern length)
- [ ] **Matching**: O(n + matches) for text of length n
- [ ] **Applications**:
  - [ ] Anti-virus scanning
  - [ ] Content filtering
  - [ ] Grep with multiple patterns
  - [ ] Dictionary matching

## Module 8: Manacher's Algorithm
- [ ] **Problem**: longest palindromic substring
- [ ] **Naive**: expand around center, O(n²)
- [ ] **Manacher's**: O(n) using palindrome property
- [ ] **Key insight**: reuse information from previously found palindromes
- [ ] **Trick**: insert special characters between chars to unify odd/even cases
- [ ] **Implementation**: dense but ~20 lines
- [ ] **Applications**:
  - [ ] Longest palindromic substring
  - [ ] Count palindromic substrings
  - [ ] Palindrome partitioning

## Module 9: Trie (Prefix Tree)
- [ ] **Trie**: tree where edges are characters, paths spell words
- [ ] **Operations**:
  - [ ] Insert: O(m) where m is word length
  - [ ] Search: O(m)
  - [ ] StartsWith (prefix search): O(m)
  - [ ] Delete: O(m)
- [ ] **Space**: O(total chars × alphabet size) — can be large
- [ ] **Memory optimization**:
  - [ ] HashMap children instead of fixed array
  - [ ] Compressed trie (radix tree / patricia trie)
- [ ] **Applications**:
  - [ ] Autocomplete
  - [ ] Spell checker
  - [ ] IP routing (longest prefix match)
  - [ ] Word search in grid (DFS + trie)
  - [ ] Word break problem

## Module 10: Classic Interview Problems
- [ ] **Longest Palindromic Substring**: Manacher's O(n) or expand O(n²)
- [ ] **Implement strStr() / indexOf**: KMP or Z
- [ ] **Shortest Palindrome**: KMP on `s + '#' + reverse(s)`
- [ ] **Repeated Substring Pattern**: check if s[1:m] + s[:-1] contains s
- [ ] **Distinct Subsequences**: DP on strings
- [ ] **Edit Distance**: DP
- [ ] **Word Search II**: trie + backtracking
- [ ] **Implement Trie**: insert, search, startsWith
- [ ] **Add and Search Word**: trie with wildcards (DFS)
- [ ] **Palindrome Pairs**: trie + Manacher or hashing

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Implement naive string matching |
| Module 2 | Implement KMP with failure function |
| Module 3 | Implement Z-algorithm |
| Module 4 | Implement Rabin-Karp with rolling hash |
| Module 5 | Implement suffix array (naive first, then O(n log n)) |
| Module 6 | Read about suffix tree concept |
| Module 7 | Implement Aho-Corasick for dictionary matching |
| Module 8 | Implement Manacher's algorithm |
| Module 9 | Implement Trie class from scratch |
| Module 10 | Solve 5 classic string problems |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapter 32
- CP-Algorithms — String processing
- "Algorithms on Strings, Trees, and Sequences" — Gusfield
- Codeforces EDU: String algorithms
