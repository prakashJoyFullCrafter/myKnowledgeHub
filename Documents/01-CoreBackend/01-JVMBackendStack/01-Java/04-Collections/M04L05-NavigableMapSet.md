# Java NavigableMap & NavigableSet — Complete Study Guide

> **Brutally Detailed Reference**
> Covers the full `NavigableMap` and `NavigableSet` interfaces — navigation methods, range views with inclusive/exclusive bounds, `TreeMap`/`TreeSet` internals, custom comparators, and real-world patterns. Every method explained with full working examples.

---

## Table of Contents

1. [Overview — The Navigable Hierarchy](#1-overview--the-navigable-hierarchy)
2. [`NavigableSet` — Navigation Methods](#2-navigableset--navigation-methods)
3. [`NavigableSet` — Descending Views](#3-navigableset--descending-views)
4. [`NavigableSet` — Range Views](#4-navigableset--range-views)
5. [`NavigableMap` — Navigation Methods](#5-navigablemap--navigation-methods)
6. [`NavigableMap` — Range Views](#6-navigablemap--range-views)
7. [`TreeSet` — Implementation Deep Dive](#7-treeset--implementation-deep-dive)
8. [`TreeMap` — Implementation Deep Dive](#8-treemap--implementation-deep-dive)
9. [Custom Comparators](#9-custom-comparators)
10. [Real-World Patterns and Use Cases](#10-real-world-patterns-and-use-cases)
11. [Performance Characteristics](#11-performance-characteristics)
12. [Edge Cases and Gotchas](#12-edge-cases-and-gotchas)
13. [Quick Reference Cheat Sheet](#13-quick-reference-cheat-sheet)

---

## 1. Overview — The Navigable Hierarchy

### 1.1 The Interface Chain

```
Collection<E>
    └── Set<E>
            └── SortedSet<E>          ← adds first(), last(), comparator()
                    └── NavigableSet<E>   ← adds floor/ceiling/lower/higher + range views
                                └── (implemented by) TreeSet<E>

Map<K,V>
    └── SortedMap<K,V>               ← adds firstKey(), lastKey(), comparator()
            └── NavigableMap<K,V>        ← adds floor/ceiling/lower/higher + range views
                        └── (implemented by) TreeMap<K,V>
```

Both `NavigableSet` and `NavigableMap` extend their `Sorted*` parents and add:
1. **Proximity navigation** — find the closest element/key to a given value
2. **Finer range views** — head/tail/sub views with explicit inclusive/exclusive bounds
3. **Descending views** — reverse-ordered live views

### 1.2 The Four Navigation Directions

The navigation methods come in four flavors, and understanding the naming is the key to remembering them all:

| Method prefix | Meaning | Inclusive? | Direction |
|---|---|---|---|
| `floor` | ≤ given value (greatest element that is ≤) | Yes | Down |
| `lower` | < given value (greatest element that is strictly <) | No | Down |
| `ceiling` | ≥ given value (smallest element that is ≥) | Yes | Up |
| `higher` | > given value (smallest element that is strictly >) | No | Up |

**Memory trick:** Think of a number line.
- `floor(5)` → round **down** to the nearest present value (5 itself if present, else next below)
- `ceiling(5)` → round **up** to the nearest present value (5 itself if present, else next above)
- `lower(5)` → strictly **below** 5 (never 5 itself)
- `higher(5)` → strictly **above** 5 (never 5 itself)

---

## 2. `NavigableSet` — Navigation Methods

### 2.1 Interface Overview

```java
public interface NavigableSet<E> extends SortedSet<E> {

    // Proximity search — return null if no match
    E floor(E e);    // greatest element ≤ e
    E ceiling(E e);  // smallest element ≥ e
    E lower(E e);    // greatest element strictly < e
    E higher(E e);   // smallest element strictly > e

    // Retrieval + removal
    E pollFirst();   // remove and return first (smallest) element
    E pollLast();    // remove and return last (largest) element

    // Descending views
    NavigableSet<E> descendingSet();
    Iterator<E> descendingIterator();

    // Range views (override SortedSet versions with inclusive/exclusive control)
    NavigableSet<E> headSet(E toElement, boolean inclusive);
    NavigableSet<E> tailSet(E fromElement, boolean inclusive);
    NavigableSet<E> subSet(E fromElement, boolean fromInclusive,
                           E toElement,   boolean toInclusive);

    // Inherited from SortedSet (still available)
    // headSet(E toElement)               — exclusive upper bound
    // tailSet(E fromElement)             — inclusive lower bound
    // subSet(E fromElement, E toElement) — inclusive lower, exclusive upper
    // first(), last(), comparator(), iterator()
}
```

### 2.2 `floor(E e)` — Greatest Element ≤ e

Returns the greatest element that is less than or equal to `e`. Returns `null` if no such element exists.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));
//  Contents: [10, 20, 30, 40, 50]

System.out.println(set.floor(30));  // 30  — 30 is present, exact match
System.out.println(set.floor(25));  // 20  — no 25, greatest below is 20
System.out.println(set.floor(50));  // 50  — exact match at top
System.out.println(set.floor(55));  // 50  — 55 not present, greatest below is 50
System.out.println(set.floor(5));   // null — nothing ≤ 5 in the set
System.out.println(set.floor(10));  // 10  — exact match at bottom
```

### 2.3 `ceiling(E e)` — Smallest Element ≥ e

Returns the smallest element that is greater than or equal to `e`. Returns `null` if no such element exists.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));

System.out.println(set.ceiling(30)); // 30  — exact match
System.out.println(set.ceiling(25)); // 30  — no 25, smallest above is 30
System.out.println(set.ceiling(10)); // 10  — exact match at bottom
System.out.println(set.ceiling(5));  // 10  — 5 not present, smallest above is 10
System.out.println(set.ceiling(55)); // null — nothing ≥ 55 in the set
System.out.println(set.ceiling(50)); // 50  — exact match at top
```

### 2.4 `lower(E e)` — Greatest Element Strictly < e

Like `floor` but **never** returns `e` itself, even if `e` is in the set.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));

System.out.println(set.lower(30));  // 20  — 30 is present but excluded; greatest below is 20
System.out.println(set.lower(25));  // 20  — no 25, greatest strictly below is 20
System.out.println(set.lower(10));  // null — nothing strictly < 10
System.out.println(set.lower(11));  // 10  — 11 not present; greatest below is 10
System.out.println(set.lower(50));  // 40  — 50 is present but excluded; greatest below is 40
System.out.println(set.lower(5));   // null — nothing < 5
```

### 2.5 `higher(E e)` — Smallest Element Strictly > e

Like `ceiling` but **never** returns `e` itself.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));

System.out.println(set.higher(30)); // 40  — 30 is present but excluded; smallest above is 40
System.out.println(set.higher(25)); // 30  — no 25, smallest strictly above is 30
System.out.println(set.higher(50)); // null — nothing strictly > 50
System.out.println(set.higher(49)); // 50  — 49 not present; smallest above is 50
System.out.println(set.higher(10)); // 20  — 10 present but excluded; next is 20
System.out.println(set.higher(55)); // null — nothing > 55
```

### 2.6 Side-by-Side Comparison

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));

// Query: 30 (present in set)
System.out.println("floor(30)   = " + set.floor(30));    // 30  (≤, inclusive → self)
System.out.println("ceiling(30) = " + set.ceiling(30));  // 30  (≥, inclusive → self)
System.out.println("lower(30)   = " + set.lower(30));    // 20  (strict < → below)
System.out.println("higher(30)  = " + set.higher(30));   // 40  (strict > → above)

System.out.println("---");

// Query: 25 (NOT in set)
System.out.println("floor(25)   = " + set.floor(25));    // 20  (greatest ≤ 25)
System.out.println("ceiling(25) = " + set.ceiling(25));  // 30  (smallest ≥ 25)
System.out.println("lower(25)   = " + set.lower(25));    // 20  (greatest < 25, same result as floor here)
System.out.println("higher(25)  = " + set.higher(25));   // 30  (smallest > 25, same result as ceiling here)
// floor == lower and ceiling == higher when query value is NOT in the set
```

### 2.7 `pollFirst()` and `pollLast()`

Remove and return the smallest/largest element. Return `null` if the set is empty (unlike `first()`/`last()` which throw `NoSuchElementException`).

```java
TreeSet<String> set = new TreeSet<>(Set.of("banana", "apple", "cherry", "date"));
// Sorted: [apple, banana, cherry, date]

String first = set.pollFirst(); // "apple" — removed from set
String last  = set.pollLast();  // "date"  — removed from set
System.out.println(set);        // [banana, cherry]

// Contrast with first()/last() on empty:
TreeSet<Integer> empty = new TreeSet<>();
System.out.println(empty.pollFirst()); // null — no exception
try {
    empty.first(); // throws NoSuchElementException
} catch (NoSuchElementException e) {
    System.out.println("Throws: " + e.getClass().getSimpleName());
}
```

**`pollFirst()` / `pollLast()` use cases:**

```java
// Priority-queue style processing — process smallest first
TreeSet<Integer> tasks = new TreeSet<>(Set.of(5, 2, 8, 1, 9, 3));
System.out.print("Processing order: ");
Integer task;
while ((task = tasks.pollFirst()) != null) {
    System.out.print(task + " "); // 1 2 3 5 8 9
}
```

---

## 3. `NavigableSet` — Descending Views

### 3.1 `descendingSet()`

Returns a **live reverse-ordered view** of the set. All operations on the descending view are reflected in the original, and vice versa.

```java
TreeSet<Integer> asc = new TreeSet<>(Set.of(1, 3, 5, 7, 9));
NavigableSet<Integer> desc = asc.descendingSet();

System.out.println(asc);  // [1, 3, 5, 7, 9]
System.out.println(desc); // [9, 7, 5, 3, 1]

// Operations on descending set reflect in original
desc.add(11);
System.out.println(asc);  // [1, 3, 5, 7, 9, 11]
System.out.println(desc); // [11, 9, 7, 5, 3, 1]

// first()/last() are swapped in perspective
System.out.println(asc.first());   // 1
System.out.println(desc.first());  // 11  — "first" in descending order = largest

// Navigation methods work in the descending set's perspective
System.out.println(desc.higher(5)); // 3  — "higher" in descending = next smaller value!
System.out.println(desc.lower(5));  // 7  — "lower"  in descending = next larger value!
```

**Key insight:** Navigation methods on a descending set are relative to the descending order. `higher` in a descending set moves toward smaller numbers. This catches many developers off guard.

### 3.2 `descendingIterator()`

Returns an `Iterator` that traverses the set from largest to smallest, without creating a full view object:

```java
TreeSet<String> set = new TreeSet<>(Set.of("alpha", "beta", "gamma", "delta"));

Iterator<String> descIter = set.descendingIterator();
while (descIter.hasNext()) {
    System.out.print(descIter.next() + " "); // gamma delta beta alpha
}
```

### 3.3 Java 21 — `reversed()` on `TreeSet`

Java 21's `SequencedCollection.reversed()` on `TreeSet` returns a `SequencedSet` view, effectively the same as `descendingSet()` but with the unified `SequencedCollection` API:

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(1, 3, 5, 7));

// Pre-Java-21
NavigableSet<Integer> desc1 = set.descendingSet();

// Java 21+
SequencedSet<Integer> desc2 = set.reversed();

// Both are live descending views — functionally equivalent
```

---

## 4. `NavigableSet` — Range Views

`NavigableSet` overloads the `SortedSet` range view methods with `boolean inclusive` parameters, giving you full control over whether the boundary is included.

### 4.1 `SortedSet` Range Views (Inherited — Fixed Inclusivity)

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50, 60, 70));

// SortedSet versions — fixed inclusivity
SortedSet<Integer> head = set.headSet(40);          // [10, 20, 30]     — exclusive upper
SortedSet<Integer> tail = set.tailSet(40);          // [40, 50, 60, 70] — inclusive lower
SortedSet<Integer> sub  = set.subSet(20, 50);       // [20, 30, 40]     — inclusive lower, exclusive upper
```

### 4.2 `headSet(E toElement, boolean inclusive)` — Upper-Bounded View

Returns all elements that are **less than** (or equal to if `inclusive=true`) `toElement`.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50, 60, 70));

// Exclusive upper bound (inclusive=false) — same as SortedSet.headSet(40)
NavigableSet<Integer> headExcl = set.headSet(40, false);
System.out.println(headExcl); // [10, 20, 30] — 40 excluded

// Inclusive upper bound (inclusive=true)
NavigableSet<Integer> headIncl = set.headSet(40, true);
System.out.println(headIncl); // [10, 20, 30, 40] — 40 included

// Boundary value NOT in set — inclusive/exclusive makes no difference
NavigableSet<Integer> headMid = set.headSet(35, true);
System.out.println(headMid);  // [10, 20, 30] — 35 not in set, inclusive doesn't matter
NavigableSet<Integer> headMid2 = set.headSet(35, false);
System.out.println(headMid2); // [10, 20, 30] — same result
```

### 4.3 `tailSet(E fromElement, boolean inclusive)` — Lower-Bounded View

Returns all elements that are **greater than** (or equal to if `inclusive=true`) `fromElement`.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50, 60, 70));

// Inclusive lower bound (inclusive=true) — same as SortedSet.tailSet(40)
NavigableSet<Integer> tailIncl = set.tailSet(40, true);
System.out.println(tailIncl); // [40, 50, 60, 70] — 40 included

// Exclusive lower bound (inclusive=false)
NavigableSet<Integer> tailExcl = set.tailSet(40, false);
System.out.println(tailExcl); // [50, 60, 70] — 40 excluded
```

### 4.4 `subSet(E from, boolean fromIncl, E to, boolean toIncl)` — Both Bounds Controlled

The most powerful range view — independently control both bounds.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50, 60, 70));
// Contents: [10, 20, 30, 40, 50, 60, 70]

// [20, 50] — both inclusive (closed interval)
System.out.println(set.subSet(20, true,  50, true));  // [20, 30, 40, 50]

// (20, 50) — both exclusive (open interval)
System.out.println(set.subSet(20, false, 50, false)); // [30, 40]

// [20, 50) — inclusive lower, exclusive upper (most common, matches SortedSet)
System.out.println(set.subSet(20, true,  50, false)); // [20, 30, 40]

// (20, 50] — exclusive lower, inclusive upper
System.out.println(set.subSet(20, false, 50, true));  // [30, 40, 50]
```

### 4.5 Range Views Are Live Backed Views

Any modification to a range view is reflected in the backing set, and vice versa. Adding an element outside the range to the view throws `IllegalArgumentException`.

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));
NavigableSet<Integer> sub = set.subSet(20, true, 40, true); // [20, 30, 40]

// Add through view — reflected in original
sub.add(25);
System.out.println(set); // [10, 20, 25, 30, 40, 50] — 25 in original too

// Remove through view — reflected in original
sub.remove(30);
System.out.println(set); // [10, 20, 25, 40, 50]

// Add OUTSIDE range — throws
try {
    sub.add(50); // 50 > 40 (upper bound) — out of range
} catch (IllegalArgumentException e) {
    System.out.println("Out of range: " + e.getMessage());
}

// Modify original — reflected in view
set.add(35);
System.out.println(sub); // [20, 25, 35, 40] — 35 appears in view
```

### 4.6 Chaining Range + Navigation Methods

Range views return `NavigableSet`, so you can chain navigation methods on them:

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50, 60, 70, 80));

// Get elements in [30, 70], then find the floor of 55 within that range
NavigableSet<Integer> range = set.subSet(30, true, 70, true); // [30, 40, 50, 60, 70]
System.out.println(range.floor(55));   // 50 — floor within [30, 70]
System.out.println(range.ceiling(55)); // 60 — ceiling within [30, 70]
System.out.println(range.higher(70));  // null — 70 is the upper bound, nothing higher in range
System.out.println(range.first());     // 30
System.out.println(range.last());      // 70
```

---

## 5. `NavigableMap` — Navigation Methods

### 5.1 Interface Overview

```java
public interface NavigableMap<K, V> extends SortedMap<K, V> {

    // Entry-returning navigation
    Map.Entry<K,V> floorEntry(K key);    // entry with greatest key ≤ k
    Map.Entry<K,V> ceilingEntry(K key);  // entry with smallest key ≥ k
    Map.Entry<K,V> lowerEntry(K key);    // entry with greatest key strictly < k
    Map.Entry<K,V> higherEntry(K key);   // entry with smallest key strictly > k

    // Key-only navigation
    K floorKey(K key);    // greatest key ≤ k
    K ceilingKey(K key);  // smallest key ≥ k
    K lowerKey(K key);    // greatest key strictly < k
    K higherKey(K key);   // smallest key strictly > k

    // First/last entry access + removal
    Map.Entry<K,V> firstEntry();       // first entry (null if empty)
    Map.Entry<K,V> lastEntry();        // last entry (null if empty)
    Map.Entry<K,V> pollFirstEntry();   // remove + return first entry
    Map.Entry<K,V> pollLastEntry();    // remove + return last entry

    // Descending views
    NavigableMap<K,V> descendingMap();
    NavigableSet<K>   descendingKeySet();

    // Range views (add inclusive/exclusive control)
    NavigableMap<K,V> headMap(K toKey, boolean inclusive);
    NavigableMap<K,V> tailMap(K fromKey, boolean inclusive);
    NavigableMap<K,V> subMap(K fromKey, boolean fromInclusive,
                              K toKey,   boolean toInclusive);

    // Sequenced views (Java 21+)
    NavigableSet<K>   navigableKeySet();  // same as keySet() but NavigableSet
}
```

### 5.2 `floorKey()` / `floorEntry()` — Greatest Key ≤ k

```java
TreeMap<Integer, String> map = new TreeMap<>();
map.put(10, "ten");
map.put(20, "twenty");
map.put(30, "thirty");
map.put(40, "forty");
map.put(50, "fifty");

// floorKey — returns just the key
System.out.println(map.floorKey(30));  // 30  — exact match
System.out.println(map.floorKey(25));  // 20  — greatest key ≤ 25
System.out.println(map.floorKey(5));   // null — nothing ≤ 5
System.out.println(map.floorKey(55));  // 50  — greatest key ≤ 55

// floorEntry — returns the full entry
Map.Entry<Integer, String> entry = map.floorEntry(25);
System.out.println(entry.getKey());   // 20
System.out.println(entry.getValue()); // twenty

// Null when no match
Map.Entry<Integer, String> noEntry = map.floorEntry(5);
System.out.println(noEntry); // null
```

### 5.3 `ceilingKey()` / `ceilingEntry()` — Smallest Key ≥ k

```java
TreeMap<Integer, String> map = new TreeMap<>();
map.put(10, "ten"); map.put(20, "twenty"); map.put(30, "thirty");
map.put(40, "forty"); map.put(50, "fifty");

System.out.println(map.ceilingKey(30));  // 30  — exact match
System.out.println(map.ceilingKey(25));  // 30  — smallest key ≥ 25
System.out.println(map.ceilingKey(55));  // null — nothing ≥ 55
System.out.println(map.ceilingKey(5));   // 10  — smallest key ≥ 5

Map.Entry<Integer, String> e = map.ceilingEntry(25);
System.out.println(e.getKey() + " → " + e.getValue()); // 30 → thirty
```

### 5.4 `lowerKey()` / `lowerEntry()` — Greatest Key Strictly < k

```java
TreeMap<Integer, String> map = new TreeMap<>();
map.put(10, "ten"); map.put(20, "twenty"); map.put(30, "thirty");
map.put(40, "forty"); map.put(50, "fifty");

System.out.println(map.lowerKey(30));  // 20  — 30 excluded; greatest strictly below
System.out.println(map.lowerKey(25));  // 20  — greatest strictly below 25
System.out.println(map.lowerKey(10));  // null — nothing strictly < 10
System.out.println(map.lowerKey(11));  // 10

Map.Entry<Integer, String> e = map.lowerEntry(30);
System.out.println(e.getKey() + " → " + e.getValue()); // 20 → twenty
```

### 5.5 `higherKey()` / `higherEntry()` — Smallest Key Strictly > k

```java
TreeMap<Integer, String> map = new TreeMap<>();
map.put(10, "ten"); map.put(20, "twenty"); map.put(30, "thirty");
map.put(40, "forty"); map.put(50, "fifty");

System.out.println(map.higherKey(30));  // 40  — 30 excluded; smallest strictly above
System.out.println(map.higherKey(25));  // 30  — smallest strictly above 25
System.out.println(map.higherKey(50));  // null — nothing strictly > 50
System.out.println(map.higherKey(49));  // 50

Map.Entry<Integer, String> e = map.higherEntry(30);
System.out.println(e.getKey() + " → " + e.getValue()); // 40 → forty
```

### 5.6 `firstEntry()`, `lastEntry()`, `pollFirstEntry()`, `pollLastEntry()`

These are the `SequencedMap` methods (also in `NavigableMap`). All return `null` if empty.

```java
TreeMap<String, Integer> scores = new TreeMap<>();
scores.put("Alice", 95);
scores.put("Bob",   87);
scores.put("Carol", 92);

// Peek without removing
System.out.println(scores.firstEntry()); // Alice=95 (smallest key alphabetically)
System.out.println(scores.lastEntry());  // Carol=92

// Remove-and-return
Map.Entry<String, Integer> removed = scores.pollFirstEntry();
System.out.println(removed);       // Alice=95
System.out.println(scores);        // {Bob=87, Carol=92}

Map.Entry<String, Integer> last = scores.pollLastEntry();
System.out.println(last);          // Carol=92
System.out.println(scores);        // {Bob=87}

System.out.println(scores.pollFirstEntry()); // Bob=87
System.out.println(scores.pollFirstEntry()); // null — empty
```

---

## 6. `NavigableMap` — Range Views

### 6.1 `SortedMap` Range Views (Inherited — Fixed Inclusivity)

```java
TreeMap<Integer, String> map = new TreeMap<>();
for (int i = 10; i <= 70; i += 10) map.put(i, "val" + i);
// Keys: [10, 20, 30, 40, 50, 60, 70]

// SortedMap versions — fixed inclusivity
SortedMap<Integer, String> head = map.headMap(40);       // keys < 40: {10,20,30}
SortedMap<Integer, String> tail = map.tailMap(40);       // keys ≥ 40: {40,50,60,70}
SortedMap<Integer, String> sub  = map.subMap(20, 50);    // keys [20,50): {20,30,40}
```

### 6.2 `headMap(K toKey, boolean inclusive)` — Upper-Bounded View

```java
TreeMap<Integer, String> map = new TreeMap<>();
for (int i = 10; i <= 70; i += 10) map.put(i, "val" + i);

// Exclusive (same as SortedMap.headMap(40))
NavigableMap<Integer, String> headExcl = map.headMap(40, false);
System.out.println(headExcl.keySet()); // [10, 20, 30]

// Inclusive
NavigableMap<Integer, String> headIncl = map.headMap(40, true);
System.out.println(headIncl.keySet()); // [10, 20, 30, 40]

// Common use: all entries UP TO AND INCLUDING a deadline
TreeMap<LocalDate, String> events = new TreeMap<>();
events.put(LocalDate.of(2024, 1, 10), "Meeting");
events.put(LocalDate.of(2024, 1, 15), "Deadline");
events.put(LocalDate.of(2024, 1, 20), "Review");
events.put(LocalDate.of(2024, 2,  1), "Launch");

LocalDate cutoff = LocalDate.of(2024, 1, 15);
NavigableMap<LocalDate, String> upToDeadline = events.headMap(cutoff, true);
System.out.println(upToDeadline); // {2024-01-10=Meeting, 2024-01-15=Deadline}
```

### 6.3 `tailMap(K fromKey, boolean inclusive)` — Lower-Bounded View

```java
TreeMap<Integer, String> map = new TreeMap<>();
for (int i = 10; i <= 70; i += 10) map.put(i, "val" + i);

// Inclusive (same as SortedMap.tailMap(40))
NavigableMap<Integer, String> tailIncl = map.tailMap(40, true);
System.out.println(tailIncl.keySet()); // [40, 50, 60, 70]

// Exclusive
NavigableMap<Integer, String> tailExcl = map.tailMap(40, false);
System.out.println(tailExcl.keySet()); // [50, 60, 70]

// Use case: events AFTER a certain date (not including that date)
NavigableMap<LocalDate, String> afterCutoff = events.tailMap(cutoff, false);
System.out.println(afterCutoff); // {2024-01-20=Review, 2024-02-01=Launch}
```

### 6.4 `subMap(K from, boolean fromIncl, K to, boolean toIncl)` — Full Control

The most versatile range view. All four combinations:

```java
TreeMap<Integer, String> map = new TreeMap<>();
for (int i = 10; i <= 70; i += 10) map.put(i, "val" + i);
// Keys: [10, 20, 30, 40, 50, 60, 70]

// [20, 50] closed interval — both inclusive
NavigableMap<Integer, String> closed = map.subMap(20, true, 50, true);
System.out.println(closed.keySet()); // [20, 30, 40, 50]

// (20, 50) open interval — both exclusive
NavigableMap<Integer, String> open = map.subMap(20, false, 50, false);
System.out.println(open.keySet()); // [30, 40]

// [20, 50) half-open — inclusive lower, exclusive upper (standard SortedMap behavior)
NavigableMap<Integer, String> halfOpen = map.subMap(20, true, 50, false);
System.out.println(halfOpen.keySet()); // [20, 30, 40]

// (20, 50] — exclusive lower, inclusive upper
NavigableMap<Integer, String> revHalf = map.subMap(20, false, 50, true);
System.out.println(revHalf.keySet()); // [30, 40, 50]
```

### 6.5 Range Views Are Live

```java
TreeMap<Integer, String> map = new TreeMap<>();
for (int i = 10; i <= 50; i += 10) map.put(i, "val" + i);

NavigableMap<Integer, String> sub = map.subMap(20, true, 40, true);
System.out.println(sub.keySet()); // [20, 30, 40]

// Add within range — reflected in original
sub.put(25, "twenty-five");
System.out.println(map.keySet()); // [10, 20, 25, 30, 40, 50]

// Remove via original — reflected in view
map.remove(30);
System.out.println(sub.keySet()); // [20, 25, 40]

// Add outside range — throws
try {
    sub.put(50, "fifty"); // 50 > 40 upper bound
} catch (IllegalArgumentException e) {
    System.out.println("Out of range!"); // thrown
}
```

### 6.6 `descendingMap()`

Returns a live view of the map in reverse key order:

```java
TreeMap<String, Integer> map = new TreeMap<>();
map.put("apple", 1); map.put("banana", 2); map.put("cherry", 3);

NavigableMap<String, Integer> desc = map.descendingMap();
System.out.println(desc); // {cherry=3, banana=2, apple=1}

// Navigation methods flip in descending map
System.out.println(desc.firstKey()); // cherry (largest key = "first" in descending)
System.out.println(desc.lastKey());  // apple  (smallest key = "last" in descending)

// Mutations are live
desc.put("date", 4);
System.out.println(map); // {apple=1, banana=2, cherry=3, date=4}
```

### 6.7 `descendingKeySet()` and `navigableKeySet()`

```java
TreeMap<Integer, String> map = new TreeMap<>();
map.put(1, "one"); map.put(3, "three"); map.put(5, "five");

// navigableKeySet() — ascending NavigableSet view of keys
NavigableSet<Integer> ascKeys = map.navigableKeySet();
System.out.println(ascKeys);          // [1, 3, 5]
System.out.println(ascKeys.floor(4)); // 3
System.out.println(ascKeys.higher(3)); // 5

// descendingKeySet() — descending NavigableSet view of keys
NavigableSet<Integer> descKeys = map.descendingKeySet();
System.out.println(descKeys);          // [5, 3, 1]
System.out.println(descKeys.first());  // 5
```

---

## 7. `TreeSet` — Implementation Deep Dive

### 7.1 Internals

`TreeSet` is backed by a `TreeMap` (the set elements are stored as keys with a dummy value). All operations that modify the set translate to modifications of the backing `TreeMap`.

```java
// TreeSet's actual backing (from JDK source):
// private transient NavigableMap<E, Object> m;
// private static final Object PRESENT = new Object();
// public boolean add(E e) { return m.put(e, PRESENT) == null; }
```

This means `TreeSet` and `TreeMap` share the same O(log n) red-black tree implementation.

### 7.2 Natural Ordering vs Custom Comparator

```java
// Natural ordering — elements must implement Comparable
TreeSet<String> natural = new TreeSet<>();
natural.add("banana"); natural.add("apple"); natural.add("cherry");
System.out.println(natural); // [apple, banana, cherry] — lexicographic

// Custom comparator — reverse order
TreeSet<String> reversed = new TreeSet<>(Comparator.reverseOrder());
reversed.add("banana"); reversed.add("apple"); reversed.add("cherry");
System.out.println(reversed); // [cherry, banana, apple]

// Custom comparator — by length, then lexicographic
TreeSet<String> byLength = new TreeSet<>(
    Comparator.comparingInt(String::length).thenComparing(Comparator.naturalOrder())
);
byLength.add("banana"); byLength.add("fig"); byLength.add("apple"); byLength.add("kiwi");
System.out.println(byLength); // [fig, kiwi, apple, banana] — by length then alpha
```

### 7.3 `TreeSet` Equality — Comparator, Not `equals()`

**Critical gotcha:** `TreeSet` uses its comparator (or `Comparable`) to determine equality, **not** `equals()`. Two objects that compare as 0 are treated as equal even if `equals()` returns false.

```java
// Comparator that only compares by length
TreeSet<String> set = new TreeSet<>(Comparator.comparingInt(String::length));
set.add("hello");
set.add("world"); // same length as "hello" — treated as DUPLICATE!
System.out.println(set); // [hello] — "world" was not added!
System.out.println(set.size()); // 1

// "world".equals("hello") is false, but comparator says they're equal
// The set uses the comparator result (0), not equals()
```

### 7.4 `TreeSet` With Non-Comparable Elements

If elements don't implement `Comparable` and no comparator is provided, `add()` throws `ClassCastException` at runtime:

```java
class Point { int x, y; Point(int x, int y) { this.x=x; this.y=y; } }

TreeSet<Point> bad = new TreeSet<>();
bad.add(new Point(1, 2));
bad.add(new Point(3, 4)); // ClassCastException: Point cannot be cast to Comparable

// Fix: provide a comparator
TreeSet<Point> good = new TreeSet<>(
    Comparator.comparingInt((Point p) -> p.x).thenComparingInt(p -> p.y)
);
good.add(new Point(1, 2));
good.add(new Point(3, 4));
good.add(new Point(1, 5));
System.out.println(good.first()); // Point(1,2)
```

---

## 8. `TreeMap` — Implementation Deep Dive

### 8.1 Red-Black Tree Structure

`TreeMap` is implemented as a **red-black tree** — a self-balancing binary search tree. Every key is a node. Left children have smaller keys, right children have larger keys. The tree stays balanced after insertions/deletions, guaranteeing O(log n) for all operations.

```
              30(B)
             /     \
          20(R)    40(R)
         /    \      \
       10(B) 25(B)  50(B)
```

- Lookup: traverse left/right based on comparisons — O(log n)
- Insert: like BST insert, then rebalance — O(log n)  
- Delete: BST delete, then rebalance — O(log n)
- Navigation (floor/ceiling): traverse and track best-so-far — O(log n)

### 8.2 `computeIfAbsent` + `TreeMap` Pattern

A common idiom: `TreeMap` as a sorted multimap (map of sorted key → list of values):

```java
TreeMap<String, List<String>> index = new TreeMap<>();

String[] words = {"apple", "ant", "bat", "ball", "banana", "cherry"};
for (String w : words) {
    // Group words by first letter, sorted by first letter
    index.computeIfAbsent(String.valueOf(w.charAt(0)),
                          k -> new ArrayList<>()).add(w);
}

System.out.println(index);
// {a=[apple, ant], b=[bat, ball, banana], c=[cherry]}

// Get all words starting with 'b' or later
System.out.println(index.tailMap("b"));
// {b=[bat, ball, banana], c=[cherry]}
```

### 8.3 Custom `Comparator` with `null` Handling

By default, `TreeMap` throws `NullPointerException` on `null` keys (it calls `compareTo` which NPEs). Use a custom comparator to allow nulls:

```java
// Null-safe comparator — nulls sort first
TreeMap<String, Integer> nullSafeMap = new TreeMap<>(
    Comparator.nullsFirst(Comparator.naturalOrder())
);
nullSafeMap.put(null, 0);
nullSafeMap.put("b", 2);
nullSafeMap.put("a", 1);

System.out.println(nullSafeMap); // {null=0, a=1, b=2}
System.out.println(nullSafeMap.firstKey()); // null
```

### 8.4 `TreeMap` vs `HashMap` vs `LinkedHashMap`

| Feature | `HashMap` | `LinkedHashMap` | `TreeMap` |
|---|---|---|---|
| Order | None | Insertion order | Sorted (key order) |
| `get`/`put` | O(1) avg | O(1) avg | O(log n) |
| `floorKey()` etc. | ❌ | ❌ | ✅ |
| Range views | ❌ | ❌ | ✅ |
| `null` keys | 1 allowed | 1 allowed | ❌ (throws) |
| Memory | Low | Medium | Higher (tree nodes) |
| Best for | General lookup | Order-preserving | Sorted/range queries |

---

## 9. Custom Comparators

### 9.1 Comparator Composition

```java
// Multi-key sort: primary by department, secondary by salary descending
record Employee(String name, String dept, int salary) {}

TreeMap<Employee, String> empMap = new TreeMap<>(
    Comparator.comparing(Employee::dept)
              .thenComparing(Comparator.comparingInt(Employee::salary).reversed())
);

empMap.put(new Employee("Alice", "Engineering", 90000), "eng-alice");
empMap.put(new Employee("Bob",   "Engineering", 85000), "eng-bob");
empMap.put(new Employee("Carol", "HR",           70000), "hr-carol");
empMap.put(new Employee("Dave",  "Engineering", 95000), "eng-dave");

// Ordered: Engineering(95k Dave, 90k Alice, 85k Bob), then HR(Carol)
empMap.forEach((e, v) -> System.out.println(e.dept() + " " + e.name() + " " + e.salary()));
```

### 9.2 Case-Insensitive `TreeMap`

```java
// Case-insensitive key lookup
TreeMap<String, Integer> caseInsensitive = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
caseInsensitive.put("Hello", 1);
caseInsensitive.put("WORLD", 2);

System.out.println(caseInsensitive.get("hello")); // 1 — case-insensitive lookup
System.out.println(caseInsensitive.get("world")); // 2

// Navigation also case-insensitive
System.out.println(caseInsensitive.floorKey("hello")); // Hello
System.out.println(caseInsensitive.ceilingKey("hi"));  // WORLD
```

### 9.3 Reverse-Ordered `TreeMap`

```java
// Descending order by key
TreeMap<Integer, String> descMap = new TreeMap<>(Comparator.reverseOrder());
descMap.put(10, "ten"); descMap.put(30, "thirty"); descMap.put(20, "twenty");

System.out.println(descMap);          // {30=thirty, 20=twenty, 10=ten}
System.out.println(descMap.firstKey()); // 30 — largest key is "first" in descending map
System.out.println(descMap.lastKey());  // 10

// Navigation semantics flip with reverse comparator
System.out.println(descMap.floorKey(25));   // 20 — greatest ≤ 25 in descending = 20
System.out.println(descMap.ceilingKey(25)); // 30 — smallest ≥ 25 in descending = 30
```

---

## 10. Real-World Patterns and Use Cases

### 10.1 Event Scheduler — Range Query by Time

```java
TreeMap<LocalDateTime, String> schedule = new TreeMap<>();
schedule.put(LocalDateTime.of(2024, 1, 15, 9,  0), "Standup");
schedule.put(LocalDateTime.of(2024, 1, 15, 11, 0), "Code Review");
schedule.put(LocalDateTime.of(2024, 1, 15, 14, 0), "Design Meeting");
schedule.put(LocalDateTime.of(2024, 1, 15, 16, 0), "1-on-1");
schedule.put(LocalDateTime.of(2024, 1, 16, 9,  0), "Sprint Planning");

LocalDateTime now = LocalDateTime.of(2024, 1, 15, 12, 30);

// What is the NEXT event from now?
Map.Entry<LocalDateTime, String> next = schedule.higherEntry(now);
System.out.println("Next event: " + next.getValue() + " at " + next.getKey());
// Next event: Design Meeting at 2024-01-15T14:00

// What was the MOST RECENT past event?
Map.Entry<LocalDateTime, String> last = schedule.floorEntry(now);
System.out.println("Last event: " + last.getValue() + " at " + last.getKey());
// Last event: Code Review at 2024-01-15T11:00

// All events today (inclusive both ends)
LocalDateTime startOfDay = LocalDateTime.of(2024, 1, 15, 0, 0);
LocalDateTime endOfDay   = LocalDateTime.of(2024, 1, 15, 23, 59);
NavigableMap<LocalDateTime, String> today = schedule.subMap(startOfDay, true, endOfDay, true);
System.out.println("Today's events: " + today.values());
// [Standup, Code Review, Design Meeting, 1-on-1]
```

### 10.2 Price Tier Lookup — Floor for "Best Matching Price"

```java
// Pricing tiers: minimum quantity → unit price
TreeMap<Integer, Double> priceTiers = new TreeMap<>();
priceTiers.put(1,    9.99);  // 1-9 units:   $9.99 each
priceTiers.put(10,   8.49);  // 10-49 units:  $8.49 each
priceTiers.put(50,   7.29);  // 50-99 units:  $7.29 each
priceTiers.put(100,  5.99);  // 100+ units:   $5.99 each

// For a given quantity, find the applicable tier using floor
public static double getPricePerUnit(TreeMap<Integer, Double> tiers, int qty) {
    Map.Entry<Integer, Double> tier = tiers.floorEntry(qty);
    if (tier == null) throw new IllegalArgumentException("Quantity too small: " + qty);
    return tier.getValue();
}

System.out.println(getPricePerUnit(priceTiers, 1));    // 9.99
System.out.println(getPricePerUnit(priceTiers, 7));    // 9.99 (floor of 7 = tier at 1)
System.out.println(getPricePerUnit(priceTiers, 10));   // 8.49 (exact match)
System.out.println(getPricePerUnit(priceTiers, 75));   // 7.29 (floor of 75 = tier at 50)
System.out.println(getPricePerUnit(priceTiers, 250));  // 5.99 (floor of 250 = tier at 100)
```

### 10.3 IP Address Routing Table — Longest Prefix Match with `floorKey`

```java
// Route table: network prefix (as long) → destination
TreeMap<Long, String> routeTable = new TreeMap<>();
routeTable.put(ipToLong("0.0.0.0"),       "default-gateway");
routeTable.put(ipToLong("10.0.0.0"),      "private-10-net");
routeTable.put(ipToLong("10.1.0.0"),      "office-subnet");
routeTable.put(ipToLong("192.168.0.0"),   "home-net");
routeTable.put(ipToLong("192.168.1.0"),   "printer-vlan");

// Find the route for an IP: floor gives the largest prefix ≤ destination IP
long destIP = ipToLong("10.1.0.45");
Map.Entry<Long, String> route = routeTable.floorEntry(destIP);
System.out.println("Route: " + route.getValue()); // office-subnet
```

### 10.4 Sliding Window / Time-Series Cleanup

```java
// Keep only entries within the last 5 minutes
TreeMap<Instant, Integer> metrics = new TreeMap<>();
// ... populated with time-series data ...

public void cleanup(TreeMap<Instant, Integer> data, Duration window) {
    Instant cutoff = Instant.now().minus(window);
    // headMap gives all entries BEFORE cutoff — remove them all
    data.headMap(cutoff, false).clear(); // live view — clearing it removes from original
}

// Keep the last N entries
public void keepLast(TreeMap<Instant, Integer> data, int n) {
    while (data.size() > n) {
        data.pollFirstEntry(); // remove oldest
    }
}
```

### 10.5 Auto-Complete / Prefix Search

```java
// Find all keys with a given prefix using ceiling + iteration
TreeSet<String> dictionary = new TreeSet<>(
    Set.of("apple", "application", "apply", "apt", "banana", "band", "bar")
);

public static List<String> findByPrefix(TreeSet<String> dict, String prefix) {
    // ceiling(prefix) gives the first word >= prefix
    // We iterate while the word still starts with prefix
    List<String> results = new ArrayList<>();
    String start = dict.ceiling(prefix);
    if (start == null) return results;

    // subSet from prefix to prefix+"~" (~ is high ASCII, after all lowercase letters)
    // More robust: use headSet/tailSet trick
    for (String word : dict.tailSet(prefix)) {
        if (!word.startsWith(prefix)) break;
        results.add(word);
    }
    return results;
}

System.out.println(findByPrefix(dictionary, "app"));
// [apple, application, apply]

System.out.println(findByPrefix(dictionary, "ba"));
// [banana, band, bar]
```

### 10.6 Histogram Bucketing

```java
// Count values into buckets defined by bucket boundaries
TreeMap<Integer, Integer> histogram = new TreeMap<>();
int[] buckets = {0, 10, 20, 50, 100, 200, 500, 1000};
for (int b : buckets) histogram.put(b, 0);

int[] data = {5, 15, 7, 85, 23, 450, 12, 310, 99, 1};

for (int value : data) {
    // floorKey finds which bucket this value belongs to
    Integer bucket = histogram.floorKey(value);
    if (bucket != null) {
        histogram.merge(bucket, 1, Integer::sum);
    }
}

histogram.forEach((bucket, count) ->
    System.out.printf("≥%4d : %s%n", bucket, "#".repeat(count))
);
// ≥   0 : ###   (5, 7, 1)
// ≥  10 : ###   (15, 23, 12)
// ≥  20 : #     (... etc)
```

### 10.7 Ordered Deduplication — `TreeSet` as Sorted Unique Filter

```java
// Process a stream of events, keep only unique IDs in sorted order
List<Integer> rawIds = Arrays.asList(5, 2, 8, 2, 5, 1, 9, 3, 8, 1);

TreeSet<Integer> uniqueSorted = new TreeSet<>(rawIds);
System.out.println(uniqueSorted); // [1, 2, 3, 5, 8, 9]

// Find the three smallest IDs not yet processed
List<Integer> nextThree = new ArrayList<>();
NavigableSet<Integer> remaining = uniqueSorted;
for (int i = 0; i < 3; i++) {
    nextThree.add(remaining.pollFirst());
}
System.out.println(nextThree); // [1, 2, 3]
```

---

## 11. Performance Characteristics

### 11.1 Time Complexity

| Operation | `TreeSet` / `TreeMap` | `HashSet` / `HashMap` |
|---|---|---|
| `add` / `put` | O(log n) | O(1) amortized |
| `remove` | O(log n) | O(1) amortized |
| `contains` / `get` | O(log n) | O(1) amortized |
| `first()` / `last()` | O(log n) | N/A |
| `floor()` / `ceiling()` | O(log n) | N/A |
| `lower()` / `higher()` | O(log n) | N/A |
| `subSet()` / `subMap()` view creation | O(log n) | N/A |
| Iteration over n elements | O(n) | O(n) |
| `pollFirst()` / `pollLast()` | O(log n) | N/A |

### 11.2 Space Complexity

Each `TreeMap` entry stores: key reference, value reference, parent pointer, left child, right child, color bit ≈ 5 object references + 1 boolean per entry. Significantly more memory than `HashMap`'s array+linked-list structure.

### 11.3 When to Use `TreeMap`/`TreeSet` vs Alternatives

**Use `TreeMap`/`TreeSet` when:**
- You need sorted iteration order
- You need range queries (subMap, subSet, headMap, tailMap)
- You need floor/ceiling/lower/higher navigation
- You need first()/last() access
- You need `pollFirst()`/`pollLast()` for priority-queue-like processing

**Use `HashMap`/`HashSet` when:**
- You only need O(1) lookup, no ordering required
- Memory is constrained

**Use `LinkedHashMap`/`LinkedHashSet` when:**
- You need insertion order (not sorted order)
- You need LRU cache behavior (override `removeEldestEntry`)

---

## 12. Edge Cases and Gotchas

### 12.1 All Navigation Methods Return `null` for "Not Found" — Not Exceptions

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30));

// These all return null, not throw:
System.out.println(set.floor(5));    // null — nothing ≤ 5
System.out.println(set.ceiling(40)); // null — nothing ≥ 40
System.out.println(set.lower(10));   // null — nothing < 10
System.out.println(set.higher(30));  // null — nothing > 30

// Guard against null before using result
Integer nextUp = set.higher(25);
if (nextUp != null) {
    System.out.println("Next: " + nextUp);
}
```

### 12.2 `SortedSet.subSet` vs `NavigableSet.subSet` — Different Signatures

```java
TreeSet<Integer> set = new TreeSet<>(Set.of(10, 20, 30, 40, 50));

// SortedSet.subSet(from, to) — from inclusive, to EXCLUSIVE (fixed)
SortedSet<Integer> s1 = set.subSet(20, 40); // [20, 30] — 40 excluded

// NavigableSet.subSet(from, fromIncl, to, toIncl) — explicit control
NavigableSet<Integer> s2 = set.subSet(20, true, 40, true);  // [20, 30, 40]
NavigableSet<Integer> s3 = set.subSet(20, true, 40, false); // [20, 30]   (same as SortedSet version)

// The two-arg version is always [inclusive, exclusive) — matches SortedSet contract
```

### 12.3 Descending View — Navigation Methods Flip

When you call navigation methods on a descending view, "higher" and "lower" are relative to the descending order:

```java
TreeSet<Integer> asc = new TreeSet<>(Set.of(1, 3, 5, 7, 9));
NavigableSet<Integer> desc = asc.descendingSet();

// In the ASCENDING set:
System.out.println(asc.higher(5));  // 7 — next element above 5 in ascending order

// In the DESCENDING set — "higher" means higher in the descending iteration, i.e., numerically LOWER:
System.out.println(desc.higher(5)); // 3 — next element "above" 5 in descending = smaller number!
System.out.println(desc.lower(5));  // 7 — next element "below" 5 in descending = larger number!
```

### 12.4 Comparator Consistency With `equals()`

For correct `Set` semantics, a comparator should be **consistent with equals**: `comparator.compare(a, b) == 0` iff `a.equals(b)`. If they disagree, the set behaves "oddly":

```java
// Inconsistent: comparator says strings of same length are equal
// but String.equals() considers "hello" != "world"
TreeSet<String> set = new TreeSet<>(Comparator.comparingInt(String::length));
set.add("hello");
set.add("world"); // silently NOT added — comparator says same as "hello"

System.out.println(set.contains("world")); // false — "world" not actually in set
System.out.println(set.contains("hello")); // true
// The set contract says contains(x) is true iff x was successfully added
// This is technically violated — the Set contract says if add(x) returns false,
// the set contains an element e where (e==null ? x==null : e.equals(x))
// But "world".equals("hello") is false, so this is inconsistent!
```

### 12.5 Range View Bounds Must Be Consistent with Comparator

```java
TreeSet<Integer> set = new TreeSet<>(Comparator.reverseOrder()); // descending order
set.add(10); set.add(20); set.add(30); set.add(40); set.add(50);
// In the set's order: [50, 40, 30, 20, 10]

// With reverseOrder comparator, "from" must be >= "to" in natural terms:
// subSet(from, to) requires from <= to according to the COMPARATOR
// With reverseOrder, 50 comes before 20, so:
NavigableSet<Integer> sub = set.subSet(50, true, 20, true); // [50, 40, 30, 20]
System.out.println(sub); // [50, 40, 30, 20] — valid with reverseOrder comparator

// This would throw IllegalArgumentException:
// set.subSet(20, true, 50, true); // 20 > 50 in reverseOrder → fromKey > toKey
```

### 12.6 `pollFirst()`/`pollLast()` Return `null` on Empty, But `first()`/`last()` Throw

```java
TreeSet<Integer> set = new TreeSet<>();

// poll* — null on empty
System.out.println(set.pollFirst()); // null
System.out.println(set.pollLast());  // null

// first/last — throw on empty
try {
    set.first(); // NoSuchElementException
} catch (NoSuchElementException e) {
    System.out.println("Throws!");
}
```

---

## 13. Quick Reference Cheat Sheet

### `NavigableSet<E>` Methods

```java
// Proximity navigation — return null if no match
set.floor(e)     // greatest element ≤ e  (inclusive)
set.ceiling(e)   // smallest element ≥ e  (inclusive)
set.lower(e)     // greatest element < e  (exclusive — never returns e)
set.higher(e)    // smallest element > e  (exclusive — never returns e)

// Retrieval and removal
set.pollFirst()  // remove + return smallest — null if empty
set.pollLast()   // remove + return largest  — null if empty

// Descending views
set.descendingSet()         // NavigableSet in reverse order (live view)
set.descendingIterator()    // Iterator from largest to smallest

// Range views — NavigableSet (live backed views)
set.headSet(to, inclusive)                           // elements < to (or ≤ if inclusive)
set.tailSet(from, inclusive)                         // elements > from (or ≥ if inclusive)
set.subSet(from, fromIncl, to, toIncl)               // full control both bounds

// Inherited from SortedSet (fixed inclusivity)
set.headSet(to)              // elements strictly < to
set.tailSet(from)            // elements ≥ from
set.subSet(from, to)         // [from, to) — inclusive lower, exclusive upper
set.first()                  // smallest — throws NoSuchElementException if empty
set.last()                   // largest  — throws NoSuchElementException if empty
```

### `NavigableMap<K,V>` Methods

```java
// Key-only navigation — return null if no match
map.floorKey(k)    // greatest key ≤ k
map.ceilingKey(k)  // smallest key ≥ k
map.lowerKey(k)    // greatest key < k  (strict)
map.higherKey(k)   // smallest key > k  (strict)

// Entry navigation — return null if no match
map.floorEntry(k)    // entry with greatest key ≤ k
map.ceilingEntry(k)  // entry with smallest key ≥ k
map.lowerEntry(k)    // entry with greatest key < k
map.higherEntry(k)   // entry with smallest key > k

// First/last — firstEntry/lastEntry return null if empty; firstKey/lastKey throw
map.firstEntry()     // null if empty
map.lastEntry()      // null if empty
map.firstKey()       // NoSuchElementException if empty
map.lastKey()        // NoSuchElementException if empty
map.pollFirstEntry() // remove + return first, null if empty
map.pollLastEntry()  // remove + return last,  null if empty

// Descending views
map.descendingMap()         // NavigableMap in reverse key order (live)
map.descendingKeySet()      // NavigableSet of keys in reverse order (live)
map.navigableKeySet()       // NavigableSet of keys in ascending order (live)

// Range views — NavigableMap (live backed views)
map.headMap(to, inclusive)                        // keys < to (or ≤ if inclusive)
map.tailMap(from, inclusive)                      // keys > from (or ≥ if inclusive)
map.subMap(from, fromIncl, to, toIncl)            // full control both bounds

// Inherited SortedMap range views (fixed inclusivity)
map.headMap(to)              // keys strictly < to
map.tailMap(from)            // keys ≥ from
map.subMap(from, to)         // [from, to) keys
```

### Floor/Ceiling/Lower/Higher — One-Line Memory Aid

```
[10, 20, 30, 40, 50]  query = 30

floor(30)   = 30   ← ≤ query, closest from below (returns self if present)
ceiling(30) = 30   ← ≥ query, closest from above (returns self if present)
lower(30)   = 20   ← < query, strictly below (never self)
higher(30)  = 40   ← > query, strictly above (never self)

floor(25)   = 20   ← ≤ 25, largest present
ceiling(25) = 30   ← ≥ 25, smallest present
lower(25)   = 20   ← same as floor when query not in set
higher(25)  = 30   ← same as ceiling when query not in set
```

### Key Rules to Remember

1. **All four navigation methods return `null`** when no qualifying element exists — they never throw.
2. **`floor`/`ceiling` are inclusive** — they return the query value itself if present.
3. **`lower`/`higher` are exclusive** — they never return the query value itself.
4. **Range views are live** — mutations through them affect the backing collection, and vice versa.
5. **Adding out-of-range to a range view throws `IllegalArgumentException`**.
6. **`descendingSet()`/`descendingMap()` flip navigation semantics** — `higher` in a descending set returns a numerically smaller value.
7. **`TreeSet` uses comparator for equality, not `equals()`** — elements comparing as 0 are duplicates.
8. **`TreeMap` rejects `null` keys** by default — use `Comparator.nullsFirst()` to allow them.
9. **`subSet(from, to)` (2-arg) is always `[from, to)`** — the 4-arg version gives full control.
10. **With a custom comparator, range view bounds must obey the comparator's order**, not natural order.

---

*End of Java NavigableMap & NavigableSet Study Guide*
