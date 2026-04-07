# Java 21 Sequenced Collections — Complete Study Guide

> **JEP 431 | Brutally Detailed Reference**
> Covers the new `SequencedCollection`, `SequencedSet`, and `SequencedMap` interfaces introduced in Java 21, the updated collection hierarchy, every method, and the problems they solve. Full working examples throughout.

---

## Table of Contents

1. [The Problem Being Solved](#1-the-problem-being-solved)
2. [The New Interface Hierarchy](#2-the-new-interface-hierarchy)
3. [`SequencedCollection`](#3-sequencedcollection)
4. [`SequencedSet`](#4-sequencedset)
5. [`SequencedMap`](#5-sequencedmap)
6. [Updated Implementations](#6-updated-implementations)
7. [Collections Utility Methods](#7-collections-utility-methods)
8. [Migration — Before vs After Java 21](#8-migration--before-vs-after-java-21)
9. [Edge Cases and Gotchas](#9-edge-cases-and-gotchas)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. The Problem Being Solved

Before Java 21, there was **no uniform way** to access the first or last element of a collection, even though many collections have a well-defined encounter order (a *sequence*). Every collection type required a different, often awkward idiom.

### 1.1 The Pre-Java 21 Pain

```java
// Getting the FIRST element — four different ways:
List<String>       list      = List.of("a", "b", "c");
Deque<String>      deque     = new ArrayDeque<>(list);
SortedSet<String>  sorted    = new TreeSet<>(list);
LinkedHashSet<String> linked = new LinkedHashSet<>(list);

String first1 = list.get(0);                  // List — index-based
String first2 = deque.peekFirst();             // Deque — peek
String first3 = sorted.first();               // SortedSet — .first()
String first4 = linked.iterator().next();     // LinkedHashSet — manual iterator!

// Getting the LAST element — just as inconsistent:
String last1 = list.get(list.size() - 1);     // List — error-prone arithmetic
String last2 = deque.peekLast();              // Deque — peek
String last3 = sorted.last();                 // SortedSet — .last()
String last4 = ???;                           // LinkedHashSet — NO CLEAN WAY
// You had to do: new ArrayList<>(linked).get(linked.size() - 1)
// or iterate the whole thing: String tmp; for(String s : linked) tmp = s; // tmp = last

// Getting reversed view — also inconsistent:
List<String> rev1   = ???;                    // No built-in reverse view for List
Deque<String> rev2  = deque.descendingIterator()...  // Deque has descendingIterator
SortedSet<String> rev3 = sorted.descendingSet();     // SortedSet — .descendingSet()
```

There was **no common interface** capturing "a collection with a defined first element, last element, and order." Java 21 fixes this.

### 1.2 The Solution — Three New Interfaces

```
SequencedCollection<E>   — any ordered sequence with first/last access + reversed()
SequencedSet<E>          — a SequencedCollection with no duplicates
SequencedMap<K,V>        — a Map with defined encounter order for entries
```

---

## 2. The New Interface Hierarchy

### 2.1 Full Updated Hierarchy Diagram

```
                     Iterable<E>
                         │
                    Collection<E>
                    /            \
         SequencedCollection<E>   ...
          /         |          \
       List<E>   Deque<E>   SequencedSet<E>
                                /       \
                          Set<E>        ...
                         /     \
                   SortedSet<E>  LinkedHashSet
                        │
                    NavigableSet<E>


         SequencedMap<K,V>
          /           \
       Map<K,V>      ...
        /    \
 SortedMap<K,V>  LinkedHashMap
      │
 NavigableMap<K,V>
```

### 2.2 Which Implementations Now Implement What

| Class | Implements | Notes |
|---|---|---|
| `ArrayList` | `SequencedCollection` | via `List` |
| `LinkedList` | `SequencedCollection` | via both `List` and `Deque` |
| `ArrayDeque` | `SequencedCollection` | via `Deque` |
| `Vector` | `SequencedCollection` | via `List` |
| `LinkedHashSet` | `SequencedSet` | **New in Java 21** |
| `TreeSet` | `SequencedSet` | via `SortedSet → NavigableSet` |
| `LinkedHashMap` | `SequencedMap` | **New in Java 21** |
| `TreeMap` | `SequencedMap` | via `SortedMap → NavigableMap` |

---

## 3. `SequencedCollection`

### 3.1 Interface Definition

```java
public interface SequencedCollection<E> extends Collection<E> {

    // The one abstract method — returns a REVERSED VIEW
    SequencedCollection<E> reversed();

    // Default methods — implemented in terms of existing collection operations
    default E getFirst() { ... }
    default E getLast()  { ... }
    default void addFirst(E e) { throw new UnsupportedOperationException(); }
    default void addLast(E e)  { throw new UnsupportedOperationException(); }
    default E removeFirst() { ... }
    default E removeLast()  { ... }
}
```

`reversed()` is the only **abstract** method that implementations must provide. All other methods have default implementations that delegate to `iterator()` and other existing methods.

### 3.2 `getFirst()` and `getLast()`

Return the first and last elements respectively. Throw `NoSuchElementException` if the collection is empty.

```java
import java.util.*;

List<String> list = new ArrayList<>(List.of("alpha", "beta", "gamma", "delta"));

// Java 21 — clean, uniform API
String first = list.getFirst(); // "alpha"
String last  = list.getLast();  // "delta"

System.out.println(first); // alpha
System.out.println(last);  // delta

// Works on ALL SequencedCollection implementations:
Deque<Integer> deque = new ArrayDeque<>(List.of(10, 20, 30));
System.out.println(deque.getFirst()); // 10
System.out.println(deque.getLast());  // 30

LinkedHashSet<String> lhs = new LinkedHashSet<>(List.of("x", "y", "z"));
System.out.println(lhs.getFirst()); // x
System.out.println(lhs.getLast());  // z

TreeSet<String> tree = new TreeSet<>(List.of("banana", "apple", "cherry"));
System.out.println(tree.getFirst()); // apple  (sorted order)
System.out.println(tree.getLast());  // cherry
```

**Empty collection throws:**

```java
List<String> empty = new ArrayList<>();
try {
    empty.getFirst(); // throws NoSuchElementException
} catch (NoSuchElementException e) {
    System.out.println("Empty collection: " + e.getMessage());
}
```

### 3.3 `addFirst(E e)` and `addLast(E e)`

Insert elements at the beginning or end of the sequence.

```java
// ArrayList — addFirst prepends (shifts all elements right — O(n))
List<String> list = new ArrayList<>(List.of("b", "c", "d"));
list.addFirst("a"); // prepend
list.addLast("e");  // append
System.out.println(list); // [a, b, c, d, e]

// ArrayDeque — addFirst/addLast are O(1)
Deque<String> deque = new ArrayDeque<>(List.of("b", "c"));
deque.addFirst("a"); // O(1)
deque.addLast("d");  // O(1)
System.out.println(deque); // [a, b, c, d]

// LinkedList — addFirst/addLast are O(1)
LinkedList<String> linked = new LinkedList<>(List.of("b", "c"));
linked.addFirst("a");
linked.addLast("d");
System.out.println(linked); // [a, b, c, d]
```

**Unmodifiable / fixed-size collections throw:**

```java
List<String> immutable = List.of("a", "b", "c");
immutable.addFirst("z"); // throws UnsupportedOperationException

List<String> fixed = Arrays.asList("a", "b", "c");
fixed.addFirst("z"); // throws UnsupportedOperationException
```

### 3.4 `removeFirst()` and `removeLast()`

Remove and return the first or last element. Throw `NoSuchElementException` if empty.

```java
List<String> list = new ArrayList<>(List.of("a", "b", "c", "d"));

String removedFirst = list.removeFirst(); // "a"
String removedLast  = list.removeLast();  // "d"
System.out.println(list);         // [b, c]
System.out.println(removedFirst); // a
System.out.println(removedLast);  // d

// Deque — was already O(1) for these operations
Deque<Integer> deque = new ArrayDeque<>(List.of(1, 2, 3, 4, 5));
int first = deque.removeFirst(); // 1
int last  = deque.removeLast();  // 5
System.out.println(deque); // [2, 3, 4]
```

### 3.5 `reversed()` — The Reversed View

Returns a **view** (not a copy) of the collection in reverse encounter order. Mutations through the reversed view are reflected in the original, and vice versa.

```java
List<String> list = new ArrayList<>(List.of("a", "b", "c", "d", "e"));

// Get reversed view
SequencedCollection<String> rev = list.reversed();

// Iterate in reverse
for (String s : rev) {
    System.out.print(s + " "); // e d c b a
}
System.out.println();

// getFirst() on reversed = getLast() on original
System.out.println(rev.getFirst()); // e — the last of the original
System.out.println(rev.getLast());  // a — the first of the original

// It is a LIVE VIEW — mutate original, reversed reflects it
list.add("f");
System.out.println(rev.getFirst()); // f — now the last added is first in reversed

// Mutate through the reversed view — affects original
rev.addFirst("Z"); // adds "Z" to the END of the original list (first of reversed = last of original)
System.out.println(list); // [a, b, c, d, e, f, Z]
```

**Reversed view type specifics:**

```java
// List.reversed() returns List<E>
List<String> origList = new ArrayList<>(List.of("a", "b", "c"));
List<String> revList = origList.reversed();  // typed as List<String>
System.out.println(revList.get(0)); // c — index 0 of reversed = last of original

// SortedSet.reversed() returns SortedSet<E>
TreeSet<Integer> treeSet = new TreeSet<>(Set.of(1, 3, 5, 7));
SortedSet<Integer> revSet = treeSet.reversed();
System.out.println(revSet); // [7, 5, 3, 1]

// Deque.reversed() returns Deque<E>
Deque<String> deque = new ArrayDeque<>(List.of("x", "y", "z"));
Deque<String> revDeque = deque.reversed();
System.out.println(revDeque.peekFirst()); // z
```

### 3.6 Chaining `reversed()` Calls

Double-reversal returns the original order (same object in some implementations):

```java
List<String> list = new ArrayList<>(List.of("a", "b", "c"));
List<String> doubleReversed = list.reversed().reversed();
System.out.println(doubleReversed); // [a, b, c] — original order
```

### 3.7 Using `reversed()` for Reverse Iteration Without Copying

Before Java 21, reversing a `List` for iteration required either mutating it (`Collections.reverse()`) or copying it. Now:

```java
List<String> processLog = List.of("step1", "step2", "step3", "step4");

// Java 21 — no copy, no mutation, clean reversed iteration
System.out.println("Reverse order:");
for (String step : processLog.reversed()) {
    System.out.println("  " + step);
}
// step4, step3, step2, step1

// Also works in streams
processLog.reversed().stream()
    .filter(s -> s.startsWith("step"))
    .forEach(System.out::println);
```

---

## 4. `SequencedSet`

### 4.1 Interface Definition

```java
public interface SequencedSet<E> extends SequencedCollection<E>, Set<E> {

    // Covariant override — returns SequencedSet<E>, not just SequencedCollection<E>
    @Override
    SequencedSet<E> reversed();
}
```

`SequencedSet` adds nothing new beyond covariant narrowing of `reversed()` return type. The key insight is that it combines both `SequencedCollection` (ordered) and `Set` (no duplicates) contracts.

### 4.2 `LinkedHashSet` Now Implements `SequencedSet`

`LinkedHashSet` maintains **insertion order** and now exposes that order through the full `SequencedSet` API:

```java
LinkedHashSet<String> set = new LinkedHashSet<>();
set.add("banana");
set.add("apple");
set.add("cherry");
set.add("date");

// Java 21 — previously impossible without iterating
System.out.println(set.getFirst()); // banana (first inserted)
System.out.println(set.getLast());  // date   (last inserted)

// addFirst / addLast
set.addFirst("AARDVARK"); // goes to front — insertion order updated
System.out.println(set.getFirst()); // AARDVARK
System.out.println(set); // [AARDVARK, banana, apple, cherry, date]

set.addLast("ZEBRA");
System.out.println(set.getLast()); // ZEBRA
```

**Duplicate behavior with `addFirst`/`addLast` on `LinkedHashSet`:**

This is subtle and important. If the element already exists, `addFirst`/`addLast` **moves** it to the front/back:

```java
LinkedHashSet<String> set = new LinkedHashSet<>(List.of("a", "b", "c", "d"));
System.out.println(set); // [a, b, c, d]

// "c" already exists — it gets MOVED to the front
set.addFirst("c");
System.out.println(set); // [c, a, b, d]   ← c moved to front

// "b" already exists — it gets MOVED to the back
set.addLast("b");
System.out.println(set); // [c, a, d, b]   ← b moved to back
```

### 4.3 `reversed()` on `LinkedHashSet`

```java
LinkedHashSet<String> set = new LinkedHashSet<>(List.of("first", "second", "third"));

SequencedSet<String> reversed = set.reversed();

// Iterate in reverse insertion order
reversed.forEach(System.out::println);
// third
// second
// first

// getFirst on reversed = getLast of original
System.out.println(reversed.getFirst()); // third
System.out.println(reversed.getLast());  // first
```

### 4.4 `TreeSet` as `SequencedSet`

`TreeSet` implements `NavigableSet` which extends `SortedSet` which now extends `SequencedSet`. Its "sequence" is the **sorted order**:

```java
TreeSet<Integer> tree = new TreeSet<>(Set.of(5, 1, 8, 3, 9, 2));
System.out.println(tree); // [1, 2, 3, 5, 8, 9] — sorted ascending

// Java 21
System.out.println(tree.getFirst()); // 1 — smallest
System.out.println(tree.getLast());  // 9 — largest

// reversed() returns descending view
SequencedSet<Integer> desc = tree.reversed();
System.out.println(desc.getFirst()); // 9 — largest (first in descending)
System.out.println(desc.getLast());  // 1 — smallest (last in descending)

// Iteration in reverse sorted order
for (int n : tree.reversed()) {
    System.out.print(n + " "); // 9 8 5 3 2 1
}
```

---

## 5. `SequencedMap`

### 5.1 Interface Definition

```java
public interface SequencedMap<K, V> extends Map<K, V> {

    // Abstract — must be implemented
    SequencedMap<K, V> reversed();

    // Entry access
    default Map.Entry<K, V> firstEntry() { ... }
    default Map.Entry<K, V> lastEntry()  { ... }

    // Entry removal
    default Map.Entry<K, V> pollFirstEntry() { ... }
    default Map.Entry<K, V> pollLastEntry()  { ... }

    // Key access
    default K firstKey() { ... }
    default K lastKey()  { ... }

    // Insertion at position
    default V putFirst(K k, V v) { throw new UnsupportedOperationException(); }
    default V putLast(K k, V v)  { throw new UnsupportedOperationException(); }

    // Sequenced views
    default SequencedSet<K>              sequencedKeySet()   { ... }
    default SequencedCollection<V>       sequencedValues()   { ... }
    default SequencedSet<Map.Entry<K,V>> sequencedEntrySet() { ... }
}
```

### 5.2 `firstEntry()` and `lastEntry()`

Return `Map.Entry<K,V>` snapshots (not live views). Return `null` if the map is empty (unlike `getFirst()`/`getLast()` which throw).

```java
LinkedHashMap<String, Integer> scores = new LinkedHashMap<>();
scores.put("Alice", 95);
scores.put("Bob",   87);
scores.put("Carol", 92);
scores.put("Dave",  78);

// Java 21 — direct access
Map.Entry<String, Integer> first = scores.firstEntry();
Map.Entry<String, Integer> last  = scores.lastEntry();

System.out.println(first.getKey() + " = " + first.getValue()); // Alice = 95
System.out.println(last.getKey()  + " = " + last.getValue());  // Dave  = 78

// Null check for empty map
LinkedHashMap<String, Integer> empty = new LinkedHashMap<>();
System.out.println(empty.firstEntry()); // null — does NOT throw
System.out.println(empty.lastEntry());  // null
```

**The returned `Entry` is a snapshot:**

```java
Map.Entry<String, Integer> entry = scores.firstEntry();
scores.put("Alice", 999); // update Alice's score
System.out.println(entry.getValue()); // still 95 — snapshot, not live
```

### 5.3 `pollFirstEntry()` and `pollLastEntry()`

Remove and return the first/last entry. Return `null` if empty. Mutates the map.

```java
LinkedHashMap<String, Integer> queue = new LinkedHashMap<>();
queue.put("task-1", 1);
queue.put("task-2", 2);
queue.put("task-3", 3);

// Process first-in, first-out
while (!queue.isEmpty()) {
    Map.Entry<String, Integer> entry = queue.pollFirstEntry();
    System.out.println("Processing: " + entry.getKey() + " (priority " + entry.getValue() + ")");
}
// Processing: task-1 (priority 1)
// Processing: task-2 (priority 2)
// Processing: task-3 (priority 3)

// Map is now empty
System.out.println(queue.pollLastEntry()); // null — empty map returns null
```

### 5.4 `firstKey()` and `lastKey()`

Convenience methods that return just the key (not the full entry). Throw `NoSuchElementException` if empty.

```java
LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
map.put("first-key", 1);
map.put("middle-key", 2);
map.put("last-key", 3);

System.out.println(map.firstKey()); // first-key
System.out.println(map.lastKey());  // last-key

// TreeMap — firstKey/lastKey give smallest/largest key
TreeMap<String, Integer> tree = new TreeMap<>();
tree.put("banana", 2);
tree.put("apple", 1);
tree.put("cherry", 3);

System.out.println(tree.firstKey()); // apple  (smallest alphabetically)
System.out.println(tree.lastKey());  // cherry (largest alphabetically)
```

### 5.5 `putFirst(K, V)` and `putLast(K, V)`

Insert an entry at the beginning or end of the map's encounter order. If the key already exists, it is moved to the requested position (similar to `LinkedHashSet.addFirst`).

```java
LinkedHashMap<String, Integer> config = new LinkedHashMap<>();
config.put("timeout",   30);
config.put("retries",   3);
config.put("batchSize", 100);

System.out.println(config); // {timeout=30, retries=3, batchSize=100}

// Put a new entry at the FRONT
config.putFirst("priority", 1);
System.out.println(config); // {priority=1, timeout=30, retries=3, batchSize=100}

// Put a new entry at the END
config.putLast("debug", 0);
System.out.println(config); // {priority=1, timeout=30, retries=3, batchSize=100, debug=0}

// Key already exists — MOVES it to the front and updates value
config.putFirst("retries", 5);
System.out.println(config); // {retries=5, priority=1, timeout=30, batchSize=100, debug=0}
// "retries" moved to front with updated value 5

System.out.println(config.firstKey()); // retries
System.out.println(config.firstEntry().getValue()); // 5
```

**`TreeMap` throws `UnsupportedOperationException` for `putFirst`/`putLast`** because sorted maps don't allow you to override their natural ordering:

```java
TreeMap<String, Integer> tree = new TreeMap<>();
tree.put("b", 2);
tree.putFirst("a", 1); // throws UnsupportedOperationException
// TreeMap's order is determined by comparator, not insertion
```

### 5.6 `reversed()` on Maps

Returns a **live view** of the map in reverse encounter order. All operations on the reversed view are reflected in the original:

```java
LinkedHashMap<String, Integer> original = new LinkedHashMap<>();
original.put("a", 1);
original.put("b", 2);
original.put("c", 3);

SequencedMap<String, Integer> rev = original.reversed();

// Iterate in reverse insertion order
rev.forEach((k, v) -> System.out.println(k + "=" + v));
// c=3, b=2, a=1

// firstEntry on reversed = lastEntry on original
System.out.println(rev.firstEntry()); // c=3
System.out.println(rev.lastEntry());  // a=1

// Mutate through reversed view — reflected in original
rev.putFirst("Z", 99); // adds "Z" to end of original (start of reversed)
System.out.println(original); // {a=1, b=2, c=3, Z=99}
System.out.println(rev);      // {Z=99, c=3, b=2, a=1}
```

### 5.7 Sequenced Views — `sequencedKeySet()`, `sequencedValues()`, `sequencedEntrySet()`

These return **sequenced** versions of the standard `keySet()`, `values()`, and `entrySet()` views. The difference is the return types implement `SequencedSet` or `SequencedCollection`, enabling `getFirst()`, `getLast()`, `reversed()` etc.

```java
LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
map.put("one",   1);
map.put("two",   2);
map.put("three", 3);

// sequencedKeySet() — SequencedSet<K>
SequencedSet<String> keys = map.sequencedKeySet();
System.out.println(keys.getFirst()); // one
System.out.println(keys.getLast());  // three
keys.reversed().forEach(System.out::println); // three, two, one

// sequencedValues() — SequencedCollection<V>
SequencedCollection<Integer> values = map.sequencedValues();
System.out.println(values.getFirst()); // 1
System.out.println(values.getLast());  // 3
values.reversed().forEach(System.out::println); // 3, 2, 1

// sequencedEntrySet() — SequencedSet<Map.Entry<K,V>>
SequencedSet<Map.Entry<String, Integer>> entries = map.sequencedEntrySet();
System.out.println(entries.getFirst()); // one=1
System.out.println(entries.getLast());  // three=3
entries.reversed().forEach(System.out::println); // three=3, two=2, one=1
```

### 5.8 `TreeMap` as `SequencedMap`

`TreeMap` implements `NavigableMap → SortedMap → SequencedMap`. Its encounter order is **sorted key order**:

```java
TreeMap<String, Integer> tree = new TreeMap<>();
tree.put("banana", 2);
tree.put("apple",  1);
tree.put("cherry", 3);
tree.put("date",   4);

System.out.println(tree.firstEntry()); // apple=1  (lowest key)
System.out.println(tree.lastEntry());  // date=4   (highest key)
System.out.println(tree.firstKey());   // apple
System.out.println(tree.lastKey());    // date

// pollFirstEntry — removes and returns smallest key entry
Map.Entry<String, Integer> smallest = tree.pollFirstEntry();
System.out.println(smallest); // apple=1
System.out.println(tree);     // {banana=2, cherry=3, date=4}

// Reversed view — descending key order
tree.reversed().forEach((k, v) -> System.out.print(k + " "));
// date cherry banana
```

---

## 6. Updated Implementations

### 6.1 `List` Implementations

All `List` implementations inherit `SequencedCollection` via the `List` interface.

```java
// ArrayList
ArrayList<String> arrayList = new ArrayList<>(List.of("a", "b", "c"));
arrayList.getFirst(); // "a" — same as arrayList.get(0)
arrayList.getLast();  // "c" — same as arrayList.get(arrayList.size()-1)
arrayList.addFirst("Z"); // O(n) — shifts all elements right
arrayList.reversed();    // live reversed view

// LinkedList (implements both List and Deque)
LinkedList<String> linkedList = new LinkedList<>(List.of("a", "b", "c"));
linkedList.getFirst();    // "a"
linkedList.getLast();     // "c"
linkedList.addFirst("Z"); // O(1) — prepend to doubly-linked list
linkedList.addLast("Z");  // O(1)
linkedList.removeFirst(); // O(1)
linkedList.removeLast();  // O(1)

// Arrays.asList — fixed size, addFirst/addLast throw
List<String> fixed = Arrays.asList("a", "b", "c");
fixed.getFirst();  // "a" — works
fixed.getLast();   // "c" — works
fixed.addFirst("Z"); // UnsupportedOperationException

// List.of — immutable, all mutations throw
List<String> immutable = List.of("a", "b", "c");
immutable.getFirst();  // "a" — works
immutable.addFirst("Z"); // UnsupportedOperationException
```

### 6.2 `Deque` Implementations

`Deque` extends `SequencedCollection`. `ArrayDeque` is the preferred `Deque` implementation.

```java
ArrayDeque<String> deque = new ArrayDeque<>(List.of("a", "b", "c"));

// New API (Java 21) — uniform with other collections
deque.getFirst();    // "a"
deque.getLast();     // "c"
deque.addFirst("Z"); // O(1)
deque.addLast("Z");  // O(1)

// Old API (still works — Deque already had these)
deque.peekFirst();  // same as getFirst() but returns null on empty
deque.peekLast();   // same as getLast()  but returns null on empty
deque.offerFirst("Z");
deque.offerLast("Z");

// Comparison: getFirst() vs peekFirst()
ArrayDeque<String> empty = new ArrayDeque<>();
empty.getFirst();   // throws NoSuchElementException
empty.peekFirst();  // returns null (no exception)
```

### 6.3 `LinkedHashSet` — Key Upgrade

`LinkedHashSet` previously had **no** convenient first/last access. This was the most painful gap:

```java
// Before Java 21 — getting last element of LinkedHashSet
LinkedHashSet<String> set = new LinkedHashSet<>(List.of("a", "b", "c"));
String last = null;
for (String s : set) last = s; // had to iterate the entire set!
// or: new ArrayList<>(set).get(set.size() - 1) — creates a copy!

// Java 21 — clean and O(1)
String first = set.getFirst(); // "a"
String lastJ21 = set.getLast(); // "c" — no iteration, no copy
```

### 6.4 `LinkedHashMap` — Key Upgrade

```java
// Before Java 21 — getting first/last entry of LinkedHashMap
LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
map.put("first", 1); map.put("second", 2); map.put("third", 3);

// Getting first entry — previously needed:
Map.Entry<String, Integer> firstEntry = map.entrySet().iterator().next();

// Getting last entry — previously needed:
Map.Entry<String, Integer> lastEntry = null;
for (Map.Entry<String, Integer> e : map.entrySet()) lastEntry = e;
// or use a stream: map.entrySet().stream().reduce((a, b) -> b).orElse(null);

// Java 21 — clean
Map.Entry<String, Integer> first21 = map.firstEntry(); // instant
Map.Entry<String, Integer> last21  = map.lastEntry();  // instant
```

---

## 7. `Collections` Utility Methods

Java 21 added three new static methods to `java.util.Collections` to wrap ordinary collections as `SequencedCollection`, `SequencedSet`, and `SequencedMap`:

### 7.1 `Collections.unmodifiableSequencedCollection()`

```java
List<String> list = new ArrayList<>(List.of("a", "b", "c"));
SequencedCollection<String> unmod = Collections.unmodifiableSequencedCollection(list);

System.out.println(unmod.getFirst()); // a — read works
unmod.addFirst("Z");  // throws UnsupportedOperationException — write blocked
unmod.reversed();     // returns unmodifiable reversed view
```

### 7.2 `Collections.unmodifiableSequencedSet()`

```java
LinkedHashSet<String> set = new LinkedHashSet<>(List.of("x", "y", "z"));
SequencedSet<String> unmodSet = Collections.unmodifiableSequencedSet(set);

System.out.println(unmodSet.getFirst()); // x
unmodSet.addFirst("W"); // throws UnsupportedOperationException
```

### 7.3 `Collections.unmodifiableSequencedMap()`

```java
LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
map.put("a", 1); map.put("b", 2);

SequencedMap<String, Integer> unmodMap = Collections.unmodifiableSequencedMap(map);
System.out.println(unmodMap.firstEntry()); // a=1
unmodMap.putFirst("Z", 99); // throws UnsupportedOperationException
```

---

## 8. Migration — Before vs After Java 21

### 8.1 Accessing First Element

```java
List<String> list = getList();
LinkedHashSet<String> set = getSet();
LinkedHashMap<String, Integer> map = getMap();

// ❌ Before Java 21
String listFirst = list.get(0);
String setFirst  = set.iterator().next();
Map.Entry<String, Integer> mapFirst = map.entrySet().iterator().next();

// ✅ Java 21
String listFirst21 = list.getFirst();
String setFirst21  = set.getFirst();
Map.Entry<String, Integer> mapFirst21 = map.firstEntry();
```

### 8.2 Accessing Last Element

```java
// ❌ Before Java 21 — error-prone and verbose
String listLast = list.get(list.size() - 1);       // off-by-one risk
String setLast  = null;
for (String s : set) setLast = s;                  // O(n) iteration!
Map.Entry<String, Integer> mapLast = null;
for (var e : map.entrySet()) mapLast = e;           // O(n) iteration!

// ✅ Java 21 — clean and clear
String listLast21 = list.getLast();
String setLast21  = set.getLast();                  // O(1) now
Map.Entry<String, Integer> mapLast21 = map.lastEntry();
```

### 8.3 Reverse Iteration

```java
// ❌ Before Java 21
List<String> copy = new ArrayList<>(list);
Collections.reverse(copy); // MUTATES or requires copy
for (String s : copy) { ... }

ListIterator<String> it = list.listIterator(list.size());
while (it.hasPrevious()) { String s = it.previous(); }  // awkward

// ✅ Java 21 — live view, no copy, no mutation
for (String s : list.reversed()) { ... }

// For LinkedHashSet — previously truly no clean way
for (String s : set.reversed()) { ... } // now works!
```

### 8.4 Adding at the Front

```java
// ❌ Before Java 21
list.add(0, "newFirst");         // List.add(int, E) — valid but indirect
deque.addFirst("newFirst");      // Deque only

// ✅ Java 21 — uniform across types
list.addFirst("newFirst");
deque.addFirst("newFirst");
map.putFirst("newKey", value);
```

### 8.5 Writing Generic Utility Methods

The new interfaces enable writing methods that work on any ordered collection:

```java
// ✅ Generic method that works for List, Deque, LinkedHashSet, TreeSet
public static <T> void printFirstAndLast(SequencedCollection<T> sc) {
    if (sc.isEmpty()) {
        System.out.println("(empty)");
        return;
    }
    System.out.println("First: " + sc.getFirst() + ", Last: " + sc.getLast());
}

// Works for all of these:
printFirstAndLast(new ArrayList<>(List.of(1, 2, 3)));      // First: 1, Last: 3
printFirstAndLast(new ArrayDeque<>(List.of("a", "b")));    // First: a, Last: b
printFirstAndLast(new LinkedHashSet<>(List.of("x", "z"))); // First: x, Last: z
printFirstAndLast(new TreeSet<>(Set.of(5, 1, 9)));         // First: 1, Last: 9

// Generic method over SequencedMap
public static <K, V> void printBounds(SequencedMap<K, V> map) {
    System.out.println("First key: " + map.firstKey() + " Last key: " + map.lastKey());
}

printBounds(new LinkedHashMap<>(Map.of("a", 1, "b", 2)));
printBounds(new TreeMap<>(Map.of("z", 1, "a", 2)));
```

---

## 9. Edge Cases and Gotchas

### 9.1 `getFirst()` / `getLast()` vs `peekFirst()` / `peekLast()`

`Deque` already had `peekFirst()`/`peekLast()` which return `null` on empty. The new `getFirst()`/`getLast()` throw `NoSuchElementException`:

```java
Deque<String> empty = new ArrayDeque<>();

empty.peekFirst(); // null — no exception
empty.peekLast();  // null — no exception
empty.getFirst();  // NoSuchElementException ← new behavior
empty.getLast();   // NoSuchElementException ← new behavior
```

**`SequencedMap.firstEntry()` returns `null` on empty** (consistent with `Map.get()` convention):

```java
LinkedHashMap<String, Integer> emptyMap = new LinkedHashMap<>();
emptyMap.firstEntry(); // null — NOT an exception (Map convention)
emptyMap.firstKey();   // NoSuchElementException (Collection convention)
// This inconsistency is intentional in the JEP design
```

### 9.2 `reversed()` Is a View — Mutations Are Shared

```java
List<String> list = new ArrayList<>(List.of("a", "b", "c"));
List<String> rev = list.reversed();

// Mutating original affects reversed view
list.add("d");
System.out.println(rev.getFirst()); // d — reflects the new last element

// Mutating reversed view affects original
rev.removeFirst(); // removes "d" from both
System.out.println(list); // [a, b, c]

// addFirst on reversed view = addLast on original
rev.addFirst("LAST");
System.out.println(list); // [a, b, c, LAST]
```

### 9.3 `LinkedHashSet.addFirst()` Moves Existing Elements

This is the most surprising behavior:

```java
LinkedHashSet<String> set = new LinkedHashSet<>(List.of("a", "b", "c"));

// "b" already in set — addFirst MOVES it, doesn't add a duplicate
set.addFirst("b");
System.out.println(set); // [b, a, c] — b was moved to front, NOT added twice
System.out.println(set.size()); // 3 — still 3 elements, not 4
```

Same for `addLast` and `putFirst`/`putLast` on `LinkedHashMap`.

### 9.4 `Collections.sort()` vs `reversed()` — Different Semantics

```java
List<Integer> list = new ArrayList<>(List.of(3, 1, 4, 1, 5, 9));

// reversed() — reverses ENCOUNTER ORDER (whatever order elements happen to be in)
// Does NOT sort first
List<Integer> rev = list.reversed();
System.out.println(rev); // [9, 5, 1, 4, 1, 3] — just reversal of original

// To get sorted-descending, you need to sort AND reverse:
List<Integer> sortedDesc = new ArrayList<>(list);
Collections.sort(sortedDesc, Comparator.reverseOrder());
System.out.println(sortedDesc); // [9, 5, 4, 3, 1, 1]

// Or: sort then use reversed view (no extra copy)
List<Integer> sorted = new ArrayList<>(list);
Collections.sort(sorted);
for (int n : sorted.reversed()) System.out.print(n + " "); // 9 5 4 3 1 1
```

### 9.5 `SortedSet`/`SortedMap` — `addFirst`/`addLast`/`putFirst`/`putLast` Throw

These methods throw `UnsupportedOperationException` on sorted collections because you cannot dictate position — the comparator controls order:

```java
TreeSet<Integer> tree = new TreeSet<>();
tree.add(5);
tree.addFirst(1);  // UnsupportedOperationException — TreeSet decides order!
tree.addLast(10);  // UnsupportedOperationException

TreeMap<String, Integer> treeMap = new TreeMap<>();
treeMap.put("b", 2);
treeMap.putFirst("a", 1);  // UnsupportedOperationException
```

### 9.6 Immutable Collections via `List.of()`, `Set.of()`, `Map.of()`

Factory-created immutable collections support `getFirst()`/`getLast()` (read-only operations) but throw on mutations:

```java
List<String> immutable = List.of("a", "b", "c");
immutable.getFirst();    // "a" — OK
immutable.getLast();     // "c" — OK
immutable.reversed();    // OK — returns immutable reversed view
immutable.addFirst("z"); // UnsupportedOperationException
immutable.removeFirst(); // UnsupportedOperationException
```

### 9.7 Performance Notes

| Operation | `ArrayList` | `LinkedList` / `ArrayDeque` |
|---|---|---|
| `getFirst()` | O(1) | O(1) |
| `getLast()` | O(1) | O(1) |
| `addFirst(e)` | O(n) — shifts | O(1) |
| `addLast(e)` | O(1) amortized | O(1) |
| `removeFirst()` | O(n) — shifts | O(1) |
| `removeLast()` | O(1) | O(1) |
| `reversed()` | O(1) — view | O(1) — view |

> If you need frequent `addFirst()`/`removeFirst()`, use `ArrayDeque` or `LinkedList`, not `ArrayList`.

---

## 10. Quick Reference Cheat Sheet

### `SequencedCollection<E>` Methods

```java
sc.getFirst()        // first element — NoSuchElementException if empty
sc.getLast()         // last element  — NoSuchElementException if empty
sc.addFirst(e)       // insert at front
sc.addLast(e)        // insert at back
sc.removeFirst()     // remove and return first — NoSuchElementException if empty
sc.removeLast()      // remove and return last  — NoSuchElementException if empty
sc.reversed()        // LIVE reversed VIEW (not a copy)
```

### `SequencedMap<K,V>` Methods

```java
sm.firstEntry()         // Map.Entry or null if empty (does NOT throw)
sm.lastEntry()          // Map.Entry or null if empty (does NOT throw)
sm.pollFirstEntry()     // remove + return first entry, null if empty
sm.pollLastEntry()      // remove + return last entry,  null if empty
sm.firstKey()           // first key — NoSuchElementException if empty
sm.lastKey()            // last key  — NoSuchElementException if empty
sm.putFirst(k, v)       // insert/move to front
sm.putLast(k, v)        // insert/move to back
sm.reversed()           // LIVE reversed VIEW
sm.sequencedKeySet()    // SequencedSet<K>
sm.sequencedValues()    // SequencedCollection<V>
sm.sequencedEntrySet()  // SequencedSet<Map.Entry<K,V>>
```

### Which Collections Support Which

| Class | Interface | addFirst/addLast | putFirst/putLast | Notes |
|---|---|---|---|---|
| `ArrayList` | `SequencedCollection` | ✅ (O(n)) | — | |
| `LinkedList` | `SequencedCollection` | ✅ (O(1)) | — | |
| `ArrayDeque` | `SequencedCollection` | ✅ (O(1)) | — | |
| `LinkedHashSet` | `SequencedSet` | ✅ (moves if exists) | — | |
| `TreeSet` | `SequencedSet` | ❌ throws | — | Order is fixed by comparator |
| `LinkedHashMap` | `SequencedMap` | — | ✅ (moves if exists) | |
| `TreeMap` | `SequencedMap` | — | ❌ throws | Order is fixed by comparator |
| `List.of(...)` | `SequencedCollection` | ❌ throws | — | Immutable |

### Key Rules to Remember

1. **`reversed()` returns a live view** — not a copy. Mutations in either direction are shared.
2. **`firstEntry()`/`lastEntry()` return `null` on empty** — unlike `getFirst()`/`getLast()` which throw.
3. **`addFirst`/`addLast` on `LinkedHashSet` moves existing elements** — set semantics (no duplicates).
4. **`putFirst`/`putLast` on sorted collections throw** — they cannot override comparator-driven order.
5. **`addFirst` on `ArrayList` is O(n)** — use `ArrayDeque` or `LinkedList` for frequent front insertions.
6. **`reversed()` on `reversed()` gives back the original order** — double negation.
7. **Generic APIs now possible** — write methods accepting `SequencedCollection` or `SequencedMap` that work for all ordered types.

---

*End of Java 21 Sequenced Collections Study Guide — JEP 431*
