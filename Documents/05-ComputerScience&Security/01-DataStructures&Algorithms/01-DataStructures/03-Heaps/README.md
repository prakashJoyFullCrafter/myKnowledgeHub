# Heaps - Curriculum

## Module 1: Binary Heap Fundamentals
- [ ] **Binary heap**: complete binary tree with heap property
- [ ] **Min-heap**: parent ≤ children — min at root
- [ ] **Max-heap**: parent ≥ children — max at root
- [ ] **Complete tree**: all levels full except possibly last, filled left-to-right
- [ ] **Array representation**: parent of `i` is `(i-1)/2`, children at `2i+1`, `2i+2`
- [ ] **No pointers**: space-efficient
- [ ] **Not a BST**: no total ordering of siblings/cousins

## Module 2: Heap Operations
- [ ] **Insert** (sift up / bubble up): O(log n)
  - [ ] Add at end → compare with parent → swap → repeat
- [ ] **Extract min/max** (sift down / bubble down): O(log n)
  - [ ] Remove root → replace with last → sift down
- [ ] **Peek**: O(1) — root is min/max
- [ ] **Decrease key**: O(log n)
- [ ] **Delete at arbitrary position**: O(log n) if position known
- [ ] **Find/search**: O(n)

## Module 3: Build Heap (Heapify)
- [ ] **Naive**: insert n items → O(n log n)
- [ ] **Floyd's build heap**: start from last non-leaf, sift down → O(n)
- [ ] **Why O(n)**: sum of heights is linear (geometric series)
- [ ] **Use case**: convert array to heap in-place
- [ ] **Heap sort**: build max-heap (O(n)) + extract max repeatedly → O(n log n)

## Module 4: Priority Queue
- [ ] **Priority Queue**: ADT with `insert` and `extract-min/max`
- [ ] **Most common implementation**: binary heap
- [ ] **Java `PriorityQueue<T>`**:
  - [ ] Min-heap by default
  - [ ] Max-heap: `new PriorityQueue<>(Collections.reverseOrder())`
  - [ ] Custom: `new PriorityQueue<>((a, b) -> a.x - b.x)`
- [ ] **Thread-safe variant**: `PriorityBlockingQueue`
- [ ] **Python**: `heapq` (min-heap only, negate for max-heap)

## Module 5: Top-K Patterns
- [ ] **Top-K largest**: min-heap of size K
  - [ ] Time: O(n log K) — better than sorting when K ≪ n
- [ ] **Top-K smallest**: max-heap of size K
- [ ] **Kth element**: same idea, return top of heap
- [ ] **Alternatives for Kth**:
  - [ ] Quickselect: O(n) average, O(n²) worst
  - [ ] Median of medians: guaranteed O(n)
- [ ] **Top-K frequent elements**: HashMap + min-heap by frequency
- [ ] **K closest points to origin**: max-heap of distances

## Module 6: Merge K Sorted
- [ ] **Merge K sorted lists**:
  - [ ] Min-heap: insert one from each list, extract min, insert next
  - [ ] Time: O(N log k), Space: O(k)
- [ ] **External sort**: heap to merge sorted chunks from disk
- [ ] **Smallest range covering K lists**: heap-based
- [ ] **K pairs with smallest sums**: heap with pair tracking

## Module 7: Two-Heaps Pattern (Median of Stream)
- [ ] **Problem**: median of data stream
- [ ] **Solution**: two heaps
  - [ ] **Max-heap**: lower half
  - [ ] **Min-heap**: upper half
  - [ ] Balance sizes within 1
- [ ] **Median**: top of larger (or average of tops if equal)
- [ ] **Insert**: O(log n), **median**: O(1)
- [ ] **Sliding window median**: add/remove from heaps

## Module 8: Heap Sort
- [ ] **Algorithm**:
  1. [ ] Build max-heap: O(n)
  2. [ ] Swap root with last, reduce heap size, sift down: O(log n)
  3. [ ] Repeat → sorted descending, reverse for ascending
- [ ] **Time**: O(n log n) worst case
- [ ] **Space**: O(1) in-place
- [ ] **Not stable**
- [ ] **Not cache-friendly**
- [ ] **Rarely fastest**: Quicksort or Timsort usually win in practice

## Module 9: Advanced Heaps
- [ ] **d-ary heap**: shallower, cache-friendlier
- [ ] **Binomial heap**: O(log n) merge
- [ ] **Fibonacci heap**: amortized O(1) insert and decrease-key
  - [ ] Theoretical improvement for Dijkstra
- [ ] **Pairing heap**: simpler than Fibonacci, good practical performance
- [ ] **Leftist heap**: efficient merge
- [ ] **Interview note**: binary heap is typically all you need

## Module 10: Heap Use Cases
- [ ] **Dijkstra's shortest path**: priority queue for min distance
- [ ] **Prim's MST**: priority queue for min edge
- [ ] **A\* search**: priority queue by `g + h`
- [ ] **Huffman coding**: min-heap for building tree
- [ ] **Event-driven simulation**: min-heap by event time
- [ ] **Task scheduling**: priority-based execution
- [ ] **Load balancing**: min-heap of server load

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Implement binary heap from scratch |
| Module 4 | Use Java PriorityQueue with custom comparator |
| Module 5 | Top K Frequent, Kth Largest, K Closest Points |
| Module 6 | Merge K Sorted Lists, Smallest Range Covering K Lists |
| Module 7 | Find Median from Data Stream |
| Module 8 | Implement heap sort |
| Module 9 | Read about Fibonacci heap concept |
| Module 10 | Implement Dijkstra with priority queue |

## Key Resources
- LeetCode Heap tag
- "Introduction to Algorithms" (CLRS) — Chapter 6
- Java `PriorityQueue` documentation
- NeetCode.io — Heap patterns
