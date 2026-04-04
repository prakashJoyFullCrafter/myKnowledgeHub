# Java Collections Framework - Curriculum

## Module 1: Collections Overview
- [ ] Collections hierarchy (`Collection`, `List`, `Set`, `Queue`, `Map`)
- [ ] `Iterable` -> `Collection` -> specific interfaces
- [ ] `Map` is separate (not part of `Collection`)
- [ ] Why we program to interfaces (`List` not `ArrayList`)
- [ ] Unmodifiable vs immutable collections
- [ ] `Collections` utility class vs `Collection` interface

## Module 2: List Implementations
- [ ] `ArrayList` - dynamic array, O(1) random access, O(n) insert/delete
- [ ] `LinkedList` - doubly linked, O(1) insert/delete at ends, O(n) access
- [ ] `Vector` and `Stack` - legacy, why to avoid
- [ ] `CopyOnWriteArrayList` - thread-safe reads
- [ ] `List.of()`, `List.copyOf()` - immutable factory methods (Java 9+)
- [ ] ArrayList vs LinkedList - when to use which
- [ ] `ListIterator` - bidirectional iteration

## Module 3: Set Implementations
- [ ] `HashSet` - O(1) operations, unordered, uses `hashCode()`/`equals()`
- [ ] `LinkedHashSet` - insertion order preserved
- [ ] `TreeSet` - sorted, O(log n), uses `Comparable`/`Comparator`
- [ ] `EnumSet` - optimized for enums (bit vector)
- [ ] `Set.of()` - immutable factory method (Java 9+)
- [ ] Importance of correct `hashCode()` and `equals()` implementation

## Module 4: Queue & Deque
- [ ] `Queue` interface - FIFO operations (`offer`, `poll`, `peek`)
- [ ] `LinkedList` as Queue
- [ ] `PriorityQueue` - min-heap by default, custom `Comparator`
- [ ] `Deque` interface - double-ended queue
- [ ] `ArrayDeque` - faster than `LinkedList` for stack/queue use
- [ ] `BlockingQueue` (intro - detailed in Concurrency)

## Module 5: Map Implementations
- [ ] `HashMap` - O(1) average, null keys allowed, unordered
- [ ] `HashMap` internals: buckets, load factor, rehashing, treeification (Java 8+)
- [ ] `LinkedHashMap` - insertion/access order, great for LRU cache
- [ ] `TreeMap` - sorted by keys, O(log n), `NavigableMap`
- [ ] `EnumMap` - optimized for enum keys
- [ ] `Hashtable` - legacy, synchronized, avoid
- [ ] `ConcurrentHashMap` (intro - detailed in Concurrency)
- [ ] `Map.of()`, `Map.entry()` - immutable factory methods (Java 9+)
- [ ] `compute()`, `merge()`, `computeIfAbsent()`, `getOrDefault()` (Java 8+)

## Module 6: Sorting & Ordering
- [ ] `Comparable<T>` - natural ordering (`compareTo`)
- [ ] `Comparator<T>` - custom ordering
- [ ] `Comparator.comparing()`, `thenComparing()`, `reversed()` (Java 8+)
- [ ] `Collections.sort()` vs `List.sort()`
- [ ] Sorting with streams
- [ ] Consistent with equals - why it matters for `TreeSet`/`TreeMap`

## Module 7: Iteration Patterns
- [ ] `for-each` loop (enhanced for)
- [ ] `Iterator` and `ListIterator`
- [ ] `ConcurrentModificationException` - why it happens and how to avoid
- [ ] `Spliterator` (Java 8+)
- [ ] `forEach()` with lambdas
- [ ] When to use streams vs loops

## Module 8: Collections with Streams
- [ ] Collecting to `List`, `Set`, `Map`
- [ ] `Collectors.groupingBy()` - SQL GROUP BY equivalent
- [ ] `Collectors.partitioningBy()` - split into two groups
- [ ] `Collectors.toMap()` - handling merge conflicts
- [ ] `Collectors.toUnmodifiableList()` (Java 10+)
- [ ] Stream to array and back

## Module 9: Performance & Choosing the Right Collection
- [ ] Big-O comparison table for all implementations
- [ ] Memory overhead comparison
- [ ] Decision guide:
  - [ ] Need order? -> `ArrayList` / `LinkedHashSet` / `LinkedHashMap`
  - [ ] Need sorting? -> `TreeSet` / `TreeMap`
  - [ ] Need uniqueness? -> `HashSet`
  - [ ] Need key-value? -> `HashMap`
  - [ ] Need thread safety? -> `ConcurrentHashMap` / `CopyOnWriteArrayList`
  - [ ] Need FIFO? -> `ArrayDeque`
  - [ ] Need priority? -> `PriorityQueue`
- [ ] Common interview patterns using collections

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Remove duplicates, find frequency of elements |
| Modules 4-5 | Build an LRU cache using `LinkedHashMap`, implement a task scheduler with `PriorityQueue` |
| Module 6 | Sort a list of employees by multiple fields |
| Modules 7-8 | Process a large dataset - group, filter, aggregate using streams |
| Module 9 | Benchmark `ArrayList` vs `LinkedList` vs `ArrayDeque` for different operations |

## Key Resources
- Effective Java - Joshua Bloch (Chapter 4: Generics, Chapter 6: Enums and Annotations)
- Java Collections Framework documentation (Oracle)
- Baeldung - Java Collections guides
