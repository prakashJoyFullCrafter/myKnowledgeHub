# HashMaps - Curriculum

## Module 1: Hash Table Fundamentals
- [ ] **Hash table**: key → value map with near-O(1) average operations
- [ ] **Hash function**: maps key to integer bucket index
  - [ ] Good hash: uniform, deterministic, fast
- [ ] **Load factor**: `entries / buckets` — typically 0.75 threshold
- [ ] **Rehashing**: grow table when load factor exceeded
- [ ] **Amortized O(1) insert** despite occasional O(n) rehash
- [ ] **Worst case**: O(n) if all keys collide
- [ ] **Memory overhead**: more than an equivalent array

## Module 2: Collision Resolution
- [ ] **Separate chaining**: linked list (or tree) per bucket
  - [ ] Java `HashMap`: chain → red-black tree when chain > 8 (Java 8+)
  - [ ] Pros: simple; Cons: cache unfriendly
- [ ] **Open addressing**: probe for next slot
  - [ ] **Linear probing**: cache-friendly, clustering
  - [ ] **Quadratic probing**: try 1, 4, 9, 16 positions
  - [ ] **Double hashing**: second hash determines step
  - [ ] Cons: harder deletes, needs lower load factor (~0.5)
- [ ] **Robin Hood hashing**: variant minimizing variance

## Module 3: Hash Function Design
- [ ] **Requirements**: deterministic, uniform, fast
- [ ] **Common approaches**:
  - [ ] Integer: multiplication + shift
  - [ ] String: polynomial rolling hash
  - [ ] MurmurHash, CityHash, xxHash (non-crypto)
- [ ] **`hashCode()` in Java**:
  - [ ] Default: object identity
  - [ ] Override when overriding `equals()`
  - [ ] Contract: equal objects → equal hash codes
- [ ] **Security**: cryptographic hashes (SipHash) prevent DoS
- [ ] **`Objects.hash()`**: convenient helper

## Module 4: Java Collections
- [ ] **`HashMap<K, V>`**: not thread-safe, allows null
  - [ ] `put`, `get`, `remove`, `containsKey`, `getOrDefault`
  - [ ] `compute`, `computeIfAbsent`, `merge` (Java 8+)
- [ ] **`HashSet<T>`**: backed by HashMap
- [ ] **`LinkedHashMap`**: maintains insertion order (or access order)
- [ ] **`ConcurrentHashMap`**: thread-safe, locks segments/buckets
- [ ] **`TreeMap`**: red-black tree, O(log n), sorted keys
- [ ] **Primitive maps**: Eclipse Collections, HPPC — faster, less memory

## Module 5: Two-Sum Pattern (Complement Lookup)
- [ ] **Classic Two Sum**: `target - nums[i]` lookup in hash set
  - [ ] O(n) time vs O(n²) brute force
- [ ] **Variations**:
  - [ ] **Two Sum II (sorted)**: two pointers
  - [ ] **3Sum**: outer loop + Two Sum
  - [ ] **4Sum**: two nested loops + Two Sum
- [ ] **Pattern**: hash set for membership, hash map for index

## Module 6: Frequency Counting
- [ ] **Counting with HashMap**: `map.merge(key, 1, Integer::sum)` or `getOrDefault`
- [ ] **Applications**:
  - [ ] **Top K Frequent Elements**: HashMap + heap or bucket sort
  - [ ] **First Unique Character**: frequency + scan
  - [ ] **Find All Anagrams in String**: sliding window frequency
  - [ ] **Majority Element**: Boyer-Moore or HashMap
  - [ ] **Group Anagrams**: sorted string as key
- [ ] **Character frequency**: array (size 26) faster than HashMap for lowercase

## Module 7: LRU Cache
- [ ] **LRU**: evict entry not accessed recently
- [ ] **Requirements**: O(1) get, O(1) put
- [ ] **Implementation**: HashMap + Doubly Linked List
  - [ ] HashMap: key → node (O(1) lookup)
  - [ ] DLL: order by recency (O(1) move to front/remove tail)
- [ ] **Operations**:
  - [ ] `get(key)`: find node, move to head, return value
  - [ ] `put(key, value)`: update or insert, evict tail if full
- [ ] **Java shortcut**: `LinkedHashMap` with `accessOrder=true`
- [ ] **LFU Cache**: additional frequency tracking

## Module 8: Consistent Hashing
- [ ] **Problem**: simple `hash(key) % N` remaps everything on server change
- [ ] **Consistent hashing**: only `K/N` keys remap
- [ ] **How it works**:
  - [ ] Hash keys and servers onto a ring (0 to 2^32-1)
  - [ ] Key → nearest clockwise server
- [ ] **Virtual nodes**: each server placed multiple times for even distribution
- [ ] **Use cases**: distributed caches (Memcached), partitioning (Cassandra, DynamoDB)
- [ ] **Alternatives**: jump consistent hashing, rendezvous hashing

## Module 9: Advanced Patterns
- [ ] **Hash map + set intersection**: compare contents
- [ ] **Sliding window frequency**: add/remove as window moves
- [ ] **Counting subarrays**: prefix sum hashmap (Subarray Sum Equals K)
- [ ] **Detect cycle in linked list**: hash visited (or Floyd's)
- [ ] **Longest consecutive sequence**: hash set + smart iteration
- [ ] **Happy Number**: hash cycle detection
- [ ] **Isomorphic Strings**: bidirectional two HashMaps
- [ ] **Copy list with random pointer**: HashMap<original, clone>

## Module 10: Performance & Pitfalls
- [ ] **Mutable keys**: if hashCode changes after insertion → silent bugs
  - [ ] Always use immutable keys
- [ ] **Autoboxing**: `HashMap<Integer, Integer>` boxes primitives
  - [ ] Use primitive collections for hot loops
- [ ] **Worst-case attacks**: crafted collisions → O(n²) DoS
  - [ ] Java 8+ mitigates with tree conversion
- [ ] **Iteration order**:
  - [ ] HashMap: NO order guarantee
  - [ ] LinkedHashMap: insertion (or access) order
  - [ ] TreeMap: sorted by key
- [ ] **ConcurrentModificationException** in foreach during mutation

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement HashMap from scratch with chaining |
| Module 3 | Implement rolling hash for strings |
| Module 4 | Use Java HashMap, ConcurrentHashMap, TreeMap appropriately |
| Module 5 | Two Sum, 3Sum, Two Sum II |
| Module 6 | Top K Frequent, Group Anagrams, Majority Element |
| Module 7 | Implement LRU Cache, LFU Cache |
| Module 8 | Implement consistent hashing with 3 nodes + keys |
| Module 9 | Longest Consecutive Sequence |
| Module 10 | Reproduce HashMap DoS attack with colliding keys |

## Key Resources
- LeetCode Hash Table tag
- "Hashing in Practice" — CP-Algorithms
- "Introduction to Algorithms" (CLRS) — Chapter 11
- Java HashMap source code (OpenJDK)
