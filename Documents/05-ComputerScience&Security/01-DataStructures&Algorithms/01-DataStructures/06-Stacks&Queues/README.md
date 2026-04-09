# Stacks & Queues - Curriculum

## Module 1: Stack
- [ ] Stack: LIFO (Last In, First Out)
- [ ] Operations: `push`, `pop`, `peek`, `isEmpty` — all O(1)
- [ ] Java: `ArrayDeque` as stack (NOT `Stack` class — legacy, synchronized)
- [ ] Use cases: function call stack, undo/redo, expression evaluation
- [ ] **Parentheses matching**: `()[]{}` — classic stack problem
- [ ] **Infix to postfix conversion** (Shunting Yard algorithm)
- [ ] **Postfix expression evaluation**: operand stack
- [ ] **Min Stack**: `getMin()` in O(1) — auxiliary stack or store (value, min) pairs
- [ ] **Next Greater Element**: iterate right-to-left, stack holds candidates

## Module 2: Monotonic Stack
- [ ] **Monotonic stack**: stack that maintains increasing or decreasing order
- [ ] **Next Greater Element** (right): push indices, pop when current > top
- [ ] **Next Smaller Element** (left/right): monotonic increasing stack
- [ ] **Largest Rectangle in Histogram**: classic monotonic stack problem
- [ ] **Trapping Rain Water**: monotonic stack or two-pointer approach
- [ ] **Daily Temperatures**: days until warmer temperature
- [ ] **Stock Span Problem**: consecutive days with price <= today
- [ ] Pattern: O(n) time by processing each element at most twice (push + pop)

## Module 3: Queue & Deque
- [ ] Queue: FIFO (First In, First Out)
- [ ] Operations: `offer`, `poll`, `peek` — all O(1)
- [ ] Java: `ArrayDeque` as queue, `LinkedList` as queue
- [ ] **Circular Queue** (Ring Buffer): fixed-size, wrap-around with modulo
- [ ] **Deque** (Double-Ended Queue): add/remove from both ends
- [ ] **Sliding Window Maximum**: deque holds indices of candidates in decreasing order
- [ ] **BFS uses queue**: level-order traversal, shortest path
- [ ] **Queue with two stacks**: implement queue using two stacks (interview classic)
- [ ] **Stack with two queues**: implement stack using two queues

## Module 4: Priority Queue
- [ ] Priority Queue: highest priority element dequeued first (heap-backed)
- [ ] Java: `PriorityQueue<T>` — min-heap by default, custom `Comparator` for max-heap
- [ ] **Top-K elements**: maintain heap of size K — O(n log K)
- [ ] **Kth Largest Element**: min-heap of size K
- [ ] **Merge K Sorted Lists**: min-heap of list heads
- [ ] **Median of Data Stream**: max-heap (lower half) + min-heap (upper half)
- [ ] **Task Scheduler**: greedy + priority queue
- [ ] **Dijkstra's Algorithm**: priority queue for shortest path

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Valid Parentheses, Min Stack, evaluate reverse polish notation |
| Module 2 | Next Greater Element I/II, Largest Rectangle in Histogram, Trapping Rain Water |
| Module 3 | Sliding Window Maximum, implement queue with stacks |
| Module 4 | Top K Frequent Elements, Find Median from Data Stream, Merge K Sorted Lists |

## Key Resources
- LeetCode Stack tag, Queue tag
- NeetCode.io — Stack patterns
- "Monotonic Stack" — a]gorithms wiki
