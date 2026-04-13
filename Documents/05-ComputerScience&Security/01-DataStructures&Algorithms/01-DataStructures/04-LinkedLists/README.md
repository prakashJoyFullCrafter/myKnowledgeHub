# Linked Lists - Curriculum

## Module 1: Linked List Fundamentals
- [ ] **Linked list**: sequence of nodes, each with data and pointer(s)
- [ ] **Singly linked list**: one pointer per node (`next`)
- [ ] **Doubly linked list**: two pointers (`prev`, `next`)
- [ ] **Circular linked list**: tail points back to head
- [ ] **Operations and complexity**:
  - [ ] Access by index: O(n)
  - [ ] Insert/delete at head: O(1)
  - [ ] Insert/delete at tail: O(1) with tail pointer, O(n) otherwise
  - [ ] Insert/delete in middle: O(1) if node known, O(n) by value
- [ ] **Memory**: pointer overhead, scattered (cache-unfriendly)

## Module 2: Array vs Linked List
- [ ] **Array pros**: O(1) random access, cache-friendly
- [ ] **Array cons**: O(n) middle insert/delete, fixed size
- [ ] **Linked list pros**: O(1) insert/delete with known node
- [ ] **Linked list cons**: no random access, cache misses
- [ ] **When to use each**:
  - [ ] Random access → array
  - [ ] Frequent middle operations (known nodes) → linked list
  - [ ] LRU cache → doubly linked list + HashMap

## Module 3: Common Operations
- [ ] **Insert at head**: create node, point to head, update head
- [ ] **Insert at tail**: traverse, point to new node
- [ ] **Insert after node**: `new.next = curr.next; curr.next = new`
- [ ] **Delete by node reference**:
  - [ ] Singly: copy next value, skip next (if not tail)
  - [ ] Doubly: `prev.next = next; next.prev = prev` — O(1)
- [ ] **Search**: linear scan, O(n)
- [ ] **Dummy head / sentinel**: simplify edge cases

## Module 4: Reverse a Linked List
- [ ] **Iterative**: three pointers (prev, curr, next)
  ```
  prev = null
  while curr != null:
      next = curr.next
      curr.next = prev
      prev = curr
      curr = next
  return prev
  ```
- [ ] **Recursive**: reverse rest, fix pointer
- [ ] **Reverse in groups of K**
- [ ] **Reverse between positions m and n**
- [ ] **Palindrome via reverse**: reverse second half, compare
- [ ] **Time O(n), iterative space O(1)**, recursive O(n)

## Module 5: Fast & Slow Pointers (Floyd's)
- [ ] **Technique**: two pointers, 1x and 2x speed
- [ ] **Find middle**: slow at middle when fast at end
- [ ] **Detect cycle**: fast eventually meets slow if cycle exists
- [ ] **Find cycle start**:
  - [ ] After meeting, reset one pointer to head
  - [ ] Move both at 1x, they meet at cycle start
- [ ] **Cycle length**: count steps until re-meet
- [ ] **Use cases**: cycle detection, middle, palindrome

## Module 6: Two-Pointer Patterns
- [ ] **Remove Nth from end**: fast pointer N steps ahead
- [ ] **Intersection of two lists**: align lengths, step together
- [ ] **Merge two sorted lists**: walk both, attach smaller
- [ ] **Palindrome linked list**: find middle, reverse second half
- [ ] **Swap nodes in pairs**
- [ ] **Odd-even list**: reorder with two pointers

## Module 7: Advanced Operations
- [ ] **Sort a linked list**: merge sort — O(n log n) time
  - [ ] Slow/fast to find middle
  - [ ] Recursively sort halves, merge
- [ ] **Merge K sorted lists**: min-heap of list heads
- [ ] **Reorder list**: split, reverse second half, interleave
- [ ] **Rotate list by K**: find new tail, connect old tail to head
- [ ] **Partition list**: split by pivot value
- [ ] **Add two numbers**: simulate digit addition with carry

## Module 8: LRU Cache Implementation
- [ ] **Design**: HashMap (key → node) + DLL (order)
- [ ] **Get**: lookup, move to head, return
- [ ] **Put**: update or insert, evict tail if full
- [ ] **Why doubly linked**: O(1) remove from middle requires `prev`
- [ ] **Java shortcut**: `LinkedHashMap` with `accessOrder=true`
- [ ] **LFU Cache**: additional frequency buckets

## Module 9: Skip Lists
- [ ] **Skip list**: probabilistic alternative to balanced BST
- [ ] **Structure**: multiple levels, higher levels skip elements
- [ ] **Search/Insert/Delete**: O(log n) expected
- [ ] **Used by**: Redis Sorted Sets, LevelDB, `ConcurrentSkipListMap`
- [ ] **Why over balanced BST**: simpler concurrent implementation, no rotations
- [ ] **Level determination**: random

## Module 10: Tricky Problems & Gotchas
- [ ] **Null checks**: always guard `curr.next` dereference
- [ ] **Dummy head**: simplifies insert/delete at head
- [ ] **Save `next` before modifying `curr.next`**
- [ ] **Cycle creation**: null the new tail when reversing
- [ ] **Off-by-one errors**: very common
- [ ] **Classic problems**:
  - [ ] Copy list with random pointer
  - [ ] LRU Cache
  - [ ] Merge K sorted lists
  - [ ] Flatten multi-level DLL
  - [ ] Linked list cycle II (find start)

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Implement singly and doubly linked list from scratch |
| Module 4 | Reverse linked list, reverse in K groups |
| Module 5 | Find middle, detect cycle, find cycle start |
| Module 6 | Remove Nth from end, merge two sorted lists |
| Module 7 | Sort linked list, reorder list, add two numbers |
| Module 8 | Implement LRU Cache |
| Module 9 | Read about Skip List structure |
| Module 10 | Copy list with random pointer |

## Key Resources
- LeetCode Linked List tag
- NeetCode.io — Linked List patterns
- "Cracking the Coding Interview" — Chapter 2
- Java `LinkedList`, `ConcurrentSkipListMap` source
