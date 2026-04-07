# Defensive Copies for Mutable Types — Complete Study Guide

> **Brutally Detailed Reference**
> Covers defensive copying for every mutable type (arrays, `Date`, `Calendar`, collections, custom objects), the attack vectors exposed by not copying, `java.time` replacements, and every pattern needed to build genuinely immutable classes. Full broken vs fixed code comparisons throughout.

---

## Table of Contents

1. [The Problem — What "Defensive Copy" Means and Why It Matters](#1-the-problem--what-defensive-copy-means-and-why-it-matters)
2. [Arrays — The Most Common Violation](#2-arrays--the-most-common-violation)
3. [`Date` and `Calendar` — Legacy Mutable Types](#3-date-and-calendar--legacy-mutable-types)
4. [Replace with `java.time` Immutables](#4-replace-with-javatime-immutables)
5. [Mutable Collections](#5-mutable-collections)
6. [Custom Mutable Objects](#6-custom-mutable-objects)
7. [Building a Genuinely Immutable Class — Full Checklist](#7-building-a-genuinely-immutable-class--full-checklist)
8. [Records and Immutability](#8-records-and-immutability)
9. [Performance Considerations](#9-performance-considerations)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. The Problem — What "Defensive Copy" Means and Why It Matters

### 1.1 The Core Vulnerability

An immutable-looking class that holds **references to mutable objects** is not truly immutable. A caller who holds a reference to one of those mutable objects can change the class's internal state without its knowledge or consent:

```java
// LOOKS immutable — but is NOT
public final class Period {
    private final Date start;  // Date is mutable!
    private final Date end;

    public Period(Date start, Date end) {
        this.start = start;   // stores the reference directly — WRONG
        this.end = end;
    }

    public Date getStart() { return start; }  // exposes internals — WRONG
    public Date getEnd()   { return end; }
}

// Attack 1: Mutate via constructor argument after construction
Date start = new Date();
Date end   = new Date();
Period p = new Period(start, end);

end.setYear(78);   // Jill modifies the Date object after Period was constructed
System.out.println(p.getEnd()); // Period's "immutable" end date is now 1978!
// p.start and p.end point to the SAME Date objects the caller holds

// Attack 2: Mutate via getter return value
Date d = p.getStart();
d.setYear(95);              // modifies the returned Date
System.out.println(p.getStart()); // Period's start is now 1995!
```

Both attacks work because `Period` stores and exposes **the same `Date` objects** that callers control.

### 1.2 Why This Matters

```
Security:    An attacker can bypass validation by mutating input after it passes checks
Correctness: Invariants established at construction time are silently broken later
Concurrency: Shared mutable state without synchronization = data races
Debugging:   Class state changes without any code inside the class changing it
             → Extremely difficult to trace
API contract: "Immutable" in your Javadoc becomes a lie
```

### 1.3 The Two Places You Must Copy

Defensive copies are needed in **exactly two places** whenever a class holds mutable fields:

```
1. CONSTRUCTOR / FACTORY METHOD:
   When the caller passes a mutable object in, copy it immediately.
   Never store the reference the caller gave you.
   Reason: caller might mutate their copy after construction.

2. GETTER / ACCESSOR:
   When returning a mutable field, return a copy.
   Never return the actual internal reference.
   Reason: caller might mutate the returned reference.
```

---

## 2. Arrays — The Most Common Violation

### 2.1 Why Arrays Are Always Mutable

In Java, arrays are **objects**, but their elements are always directly accessible via the `[]` operator. There is no such thing as an immutable array in Java. `final int[] arr` means the variable `arr` cannot be reassigned, but `arr[0] = 99` is still perfectly legal.

```java
final int[] arr = {1, 2, 3};
arr[0] = 999;      // compiles and runs — final doesn't protect elements
System.out.println(arr[0]); // 999

arr = new int[]{4, 5, 6}; // compile error — ONLY this is prevented by final
```

### 2.2 Broken: Storing the Input Array Directly

```java
// BROKEN — stores reference to the caller's array
public final class Statistics {
    private final double[] data;

    public Statistics(double[] data) {
        this.data = data;  // ← WRONG: caller still holds this reference
    }

    public double mean() {
        return Arrays.stream(data).average().orElse(0);
    }
}

// Caller can corrupt the object after construction:
double[] readings = {1.0, 2.0, 3.0, 4.0};
Statistics stats = new Statistics(readings);
System.out.println(stats.mean()); // 2.5

readings[0] = 1000.0;             // caller mutates their array
System.out.println(stats.mean()); // 252.25 — statistics object silently corrupted!
```

### 2.3 Broken: Returning the Internal Array Directly

```java
public final class Statistics {
    private final double[] data;

    public Statistics(double[] data) {
        this.data = Arrays.copyOf(data, data.length); // constructor is fixed
    }

    public double[] getData() {
        return data;    // ← WRONG: returns reference to internal array
    }
}

// Even with a defensive copy in the constructor, getter exposes internals:
Statistics stats = new Statistics(new double[]{1.0, 2.0, 3.0});
double[] got = stats.getData();
got[0] = 999.0;                   // caller modifies through returned reference
System.out.println(stats.mean()); // internal data mutated!
```

### 2.4 Fixed: Defensive Copies in Both Constructor and Getter

```java
public final class Statistics {
    private final double[] data;

    public Statistics(double[] data) {
        // DEFENSIVE COPY ON INPUT: copy before storing
        // Note: null check BEFORE copy — copyOf(null, ...) throws NullPointerException
        Objects.requireNonNull(data, "data must not be null");
        this.data = Arrays.copyOf(data, data.length);  // ← copy, not reference
    }

    public double mean() {
        return Arrays.stream(data).average().orElse(0);
    }

    public double[] getData() {
        // DEFENSIVE COPY ON OUTPUT: return copy, not internal reference
        return Arrays.copyOf(data, data.length);  // ← copy, not reference
    }

    public int size() {
        return data.length;
    }

    // Expose individual elements safely (no array exposure needed)
    public double get(int index) {
        return data[index]; // primitive copy — primitives are always safe
    }
}

// Now all mutation attempts fail:
double[] input = {1.0, 2.0, 3.0};
Statistics stats = new Statistics(input);
input[0] = 999.0;                    // no effect on stats
double[] got = stats.getData();
got[0] = 999.0;                      // no effect on stats — got is a copy
System.out.println(stats.mean());    // always 2.0 — immutable
```

### 2.5 `Arrays.copyOf` vs `System.arraycopy` vs `.clone()`

All three produce a **shallow copy** — correct for arrays of primitives or immutable objects, but not for arrays of mutable objects (see Section 2.6):

```java
// Three equivalent ways to copy a 1D array:
int[] original = {1, 2, 3, 4, 5};

int[] copy1 = Arrays.copyOf(original, original.length);          // most readable
int[] copy2 = original.clone();                                   // also fine
int[] copy3 = new int[original.length];
System.arraycopy(original, 0, copy3, 0, original.length);        // most explicit

// Arrays.copyOf also works for partial copy and range:
int[] first3 = Arrays.copyOf(original, 3);                       // [1, 2, 3]
int[] range  = Arrays.copyOfRange(original, 1, 4);               // [2, 3, 4]
```

### 2.6 Arrays of Mutable Objects — Deep Copy Required

A shallow copy of an array that contains mutable objects is **not sufficient**. The copy contains the same object references:

```java
// STILL BROKEN — shallow copy of array of mutable objects
public final class Schedule {
    private final Date[] appointments;

    public Schedule(Date[] appointments) {
        // Shallow copy — copies the Date references, not the Date objects
        this.appointments = appointments.clone();  // ← NOT ENOUGH
    }

    public Date[] getAppointments() {
        return appointments.clone(); // ← also not enough
    }
}

Schedule schedule = new Schedule(new Date[]{new Date()});
Date[] got = schedule.getAppointments();
got[0].setYear(78);    // modifies the Date object inside the schedule!
// Because both the returned array and the internal array
// contain REFERENCES to the same Date objects
```

**Fix — deep copy for arrays of mutable objects:**

```java
public final class Schedule {
    private final Date[] appointments;

    public Schedule(Date[] appointments) {
        Objects.requireNonNull(appointments, "appointments must not be null");
        // Deep copy: copy the array AND copy each Date inside it
        this.appointments = new Date[appointments.length];
        for (int i = 0; i < appointments.length; i++) {
            // Copy each Date individually (Date has a copy constructor)
            this.appointments[i] = appointments[i] == null
                ? null
                : new Date(appointments[i].getTime());
        }
    }

    public Date[] getAppointments() {
        // Deep copy on output too
        Date[] copy = new Date[appointments.length];
        for (int i = 0; i < appointments.length; i++) {
            copy[i] = appointments[i] == null
                ? null
                : new Date(appointments[i].getTime());
        }
        return copy;
    }
}
```

**Best fix — use `java.time` instead of `Date` (see Section 4):**

```java
// Using LocalDate (immutable) — no deep copy needed at all
public final class Schedule {
    private final LocalDate[] appointments;

    public Schedule(LocalDate[] appointments) {
        Objects.requireNonNull(appointments, "appointments must not be null");
        this.appointments = appointments.clone(); // shallow is fine — LocalDate is immutable
    }

    public LocalDate[] getAppointments() {
        return appointments.clone(); // shallow copy is enough
    }
}
```

### 2.7 2D and Multi-Dimensional Arrays

Multi-dimensional arrays require recursive deep copying:

```java
public final class Matrix {
    private final int[][] data;

    public Matrix(int[][] data) {
        Objects.requireNonNull(data, "data must not be null");
        // Each row is a separate array — must copy each row
        this.data = new int[data.length][];
        for (int i = 0; i < data.length; i++) {
            this.data[i] = Arrays.copyOf(data[i], data[i].length);
        }
    }

    public int[][] getData() {
        int[][] copy = new int[data.length][];
        for (int i = 0; i < data.length; i++) {
            copy[i] = Arrays.copyOf(data[i], data[i].length);
        }
        return copy;
    }

    // Prefer: expose elements without exposing the array
    public int get(int row, int col) {
        return data[row][col]; // safe — int is a primitive
    }
}
```

---

## 3. `Date` and `Calendar` — Legacy Mutable Types

### 3.1 Why `Date` and `Calendar` Are Dangerous

`java.util.Date` and `java.util.Calendar` are among the most pervasive mutable types in legacy Java code:

```java
Date d = new Date();
d.setYear(78);         // change the year
d.setMonth(5);         // change the month
d.setTime(0L);         // set to Unix epoch (1970-01-01)

Calendar c = Calendar.getInstance();
c.set(Calendar.YEAR, 2000);   // mutable
c.set(Calendar.MONTH, 0);     // mutable
c.add(Calendar.DAY_OF_MONTH, 7); // mutable
```

Every `Date` or `Calendar` reference is a handle that anyone can use to change the date.

### 3.2 The `Date` Copy Idiom

`Date` provides a copy constructor `new Date(long time)` that takes the millisecond epoch value. This is the correct way to copy a `Date`:

```java
// WRONG: store the reference
this.createdAt = date;

// CORRECT: copy the Date
this.createdAt = new Date(date.getTime());  // copy constructor

// Also correct: Date.clone() — but new Date(date.getTime()) is clearer
this.createdAt = (Date) date.clone();
```

### 3.3 Full `Date` Defensive Copy Example

```java
public final class Appointment {
    private final String title;
    private final Date scheduledAt;  // stores a Date safely

    public Appointment(String title, Date scheduledAt) {
        Objects.requireNonNull(title, "title must not be null");
        Objects.requireNonNull(scheduledAt, "scheduledAt must not be null");
        this.title = title;
        // COPY ON INPUT: never store the reference
        this.scheduledAt = new Date(scheduledAt.getTime());
    }

    public String getTitle() {
        return title; // String is immutable — safe to return directly
    }

    public Date getScheduledAt() {
        // COPY ON OUTPUT: never return the internal reference
        return new Date(scheduledAt.getTime());
    }

    @Override
    public String toString() {
        return "Appointment{title='" + title + "', at=" + scheduledAt + "}";
    }
}

// Verification that it's truly immutable:
Date d = new Date();
Appointment appt = new Appointment("Dentist", d);

// Attack 1: mutate constructor argument
d.setTime(0L);
System.out.println(appt.getScheduledAt()); // ← still the original date, unaffected

// Attack 2: mutate getter result
Date returned = appt.getScheduledAt();
returned.setTime(0L);
System.out.println(appt.getScheduledAt()); // ← still the original date, unaffected
```

### 3.4 Why Validate AFTER Copying in Constructors

The defensive copy in the constructor must be made **before validation**, not after. This prevents a subtle race condition called **TOCTOU** (Time-Of-Check-Time-Of-Use):

```java
// WRONG ORDER — TOCTOU vulnerability
public Period(Date start, Date end) {
    if (start.compareTo(end) > 0)      // 1. check: start is before end ← OK
        throw new IllegalArgumentException("start after end");
    this.start = new Date(start.getTime()); // 3. copy after validation
    this.end   = new Date(end.getTime());
    // In a multithreaded environment:
    // 2. Another thread mutates start BETWEEN the check and the copy!
    // The validation passes but the stored value is invalid.
}

// CORRECT ORDER — copy THEN validate
public Period(Date start, Date end) {
    // 1. COPY FIRST — now we own the data and no one else can mutate it
    this.start = new Date(start.getTime());
    this.end   = new Date(end.getTime());
    // 2. VALIDATE the copies — the originals can change now but it doesn't matter
    if (this.start.compareTo(this.end) > 0)
        throw new IllegalArgumentException("start after end: "
            + this.start + " > " + this.end);
}
```

### 3.5 `Calendar` Defensive Copy

`Calendar` requires `clone()` — there is no copy constructor:

```java
public final class Event {
    private final Calendar startTime;

    public Event(Calendar startTime) {
        Objects.requireNonNull(startTime, "startTime must not be null");
        this.startTime = (Calendar) startTime.clone();  // copy on input
    }

    public Calendar getStartTime() {
        return (Calendar) startTime.clone();  // copy on output
    }
}
```

**Recommendation:** Avoid `Calendar` in new code entirely. Use `java.time` (see Section 4).

---

## 4. Replace with `java.time` Immutables

The best solution for `Date`/`Calendar` is to avoid them entirely. The `java.time` package (Java 8+) provides immutable date/time types that eliminate the need for defensive copying:

### 4.1 `java.time` Immutable Types — No Defensive Copies Needed

```java
// All of these are immutable — safe to store and return directly
import java.time.*;

LocalDate     date     = LocalDate.of(2024, 1, 15);      // date only, no time
LocalTime     time     = LocalTime.of(14, 30);            // time only, no date
LocalDateTime dateTime = LocalDateTime.of(date, time);   // date + time, no zone
ZonedDateTime zoned    = ZonedDateTime.of(dateTime, ZoneId.of("America/New_York")); // with zone
Instant       instant  = Instant.now();                  // point on timeline (UTC)
Duration      dur      = Duration.ofMinutes(90);          // amount of time
Period        period   = Period.ofDays(30);               // calendar period

// Immutability: all mutation methods return NEW objects
LocalDate tomorrow = date.plusDays(1);      // date is unchanged
LocalDate modified = date.withYear(2025);   // date is unchanged
// 'date' is still 2024-01-15 — these create new instances
```

### 4.2 Migration: Replace `Date`/`Calendar` Fields with `java.time`

```java
// BEFORE — with Date (mutable, defensive copies everywhere)
public final class Task {
    private final Date deadline;

    public Task(Date deadline) {
        this.deadline = new Date(deadline.getTime());  // copy needed
    }

    public Date getDeadline() {
        return new Date(deadline.getTime());            // copy needed
    }
}

// AFTER — with Instant (immutable, no copies needed)
public final class Task {
    private final Instant deadline;

    public Task(Instant deadline) {
        this.deadline = Objects.requireNonNull(deadline); // no copy — already immutable
    }

    public Instant getDeadline() {
        return deadline;   // safe to return directly — caller cannot mutate it
    }
}

// AFTER — with LocalDate for date-only fields
public final class Task {
    private final LocalDate deadline;

    public Task(LocalDate deadline) {
        this.deadline = Objects.requireNonNull(deadline);
    }

    public LocalDate getDeadline() {
        return deadline;  // immutable — return directly
    }
}
```

### 4.3 Interoperability — Converting Between `Date` and `java.time`

When you receive `Date` from legacy APIs and want to store it safely:

```java
// Date → Instant (safest conversion — always use Instant as the bridge)
Date legacyDate = getLegacyDate();
Instant instant = legacyDate.toInstant();        // ← store this (immutable)

// Date → LocalDate (if you only need the date, not time/zone)
LocalDate localDate = legacyDate.toInstant()
    .atZone(ZoneId.systemDefault())
    .toLocalDate();

// Date → ZonedDateTime
ZonedDateTime zdt = legacyDate.toInstant()
    .atZone(ZoneId.of("America/New_York"));

// java.time → Date (when passing back to legacy APIs)
Date backToDate = Date.from(instant);
Date fromLocalDate = Date.from(
    localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
```

### 4.4 The Full Refactored Class

```java
// BEFORE — many defensive copies needed
public final class EmployeeRecord {
    private final String name;
    private final Date hireDate;
    private final Date[] performanceReviewDates;
    private final Calendar lastLogin;

    public EmployeeRecord(String name, Date hireDate,
                          Date[] reviews, Calendar lastLogin) {
        this.name = Objects.requireNonNull(name);
        this.hireDate = new Date(hireDate.getTime());
        this.performanceReviewDates = new Date[reviews.length];
        for (int i = 0; i < reviews.length; i++) {
            this.performanceReviewDates[i] = new Date(reviews[i].getTime());
        }
        this.lastLogin = (Calendar) lastLogin.clone();
    }

    public Date getHireDate() {
        return new Date(hireDate.getTime());
    }

    public Date[] getPerformanceReviewDates() {
        Date[] copy = new Date[performanceReviewDates.length];
        for (int i = 0; i < copy.length; i++) {
            copy[i] = new Date(performanceReviewDates[i].getTime());
        }
        return copy;
    }

    public Calendar getLastLogin() {
        return (Calendar) lastLogin.clone();
    }
}

// AFTER — java.time types, no defensive copies needed
public final class EmployeeRecord {
    private final String name;
    private final LocalDate hireDate;            // was Date
    private final List<LocalDate> reviewDates;   // was Date[] (use unmodifiable list)
    private final Instant lastLogin;             // was Calendar

    public EmployeeRecord(String name, LocalDate hireDate,
                          List<LocalDate> reviews, Instant lastLogin) {
        this.name       = Objects.requireNonNull(name);
        this.hireDate   = Objects.requireNonNull(hireDate);  // no copy — immutable
        this.reviewDates = List.copyOf(reviews);             // unmodifiable snapshot
        this.lastLogin  = Objects.requireNonNull(lastLogin); // no copy — immutable
    }

    public String      getName()        { return name; }
    public LocalDate   getHireDate()    { return hireDate; }        // safe — immutable
    public List<LocalDate> getReviewDates() { return reviewDates; } // safe — unmodifiable
    public Instant     getLastLogin()   { return lastLogin; }       // safe — immutable
}
```

---

## 5. Mutable Collections

### 5.1 `List`, `Set`, `Map` Are Mutable

Standard Java collections are mutable by default. Storing a caller-provided collection directly exposes internal state:

```java
// BROKEN — stores reference to caller's list
public final class Team {
    private final List<String> members;

    public Team(List<String> members) {
        this.members = members;  // caller can add/remove members!
    }

    public List<String> getMembers() {
        return members;  // callers can modify through this reference!
    }
}

List<String> m = new ArrayList<>(Arrays.asList("Alice", "Bob"));
Team team = new Team(m);
m.add("Charlie");              // modifies the Team's internal state!
team.getMembers().remove("Alice"); // also modifies internal state!
```

### 5.2 `List.copyOf` / `Set.copyOf` / `Map.copyOf` (Java 10+)

The cleanest solution for collections: copy the input and store as an **unmodifiable** collection:

```java
// FIXED — defensive copy + unmodifiable storage
public final class Team {
    private final List<String> members;

    public Team(List<String> members) {
        Objects.requireNonNull(members, "members must not be null");
        // List.copyOf: creates a new unmodifiable list with the same elements
        // null elements throw NullPointerException — check elements if needed
        this.members = List.copyOf(members);  // ← copy + unmodifiable
    }

    public List<String> getMembers() {
        // List stored as unmodifiable — safe to return directly
        return members;  // ← no copy needed since it's already unmodifiable
    }
}

// Verify immutability:
List<String> input = new ArrayList<>(Arrays.asList("Alice", "Bob"));
Team team = new Team(input);
input.add("Charlie");              // no effect — team has its own copy
team.getMembers().add("Dave");     // throws UnsupportedOperationException
```

### 5.3 `Collections.unmodifiableList` vs `List.copyOf`

```java
List<String> original = new ArrayList<>(List.of("Alice", "Bob"));

// Collections.unmodifiableList — WRAPS the original, does NOT copy
List<String> wrapped = Collections.unmodifiableList(original);
original.add("Charlie");         // wrapped now contains Charlie! Not a copy!
// unmodifiableList creates a VIEW, not a snapshot.
// Use it only when you want to prevent the RECEIVER from modifying it
// but don't mind the original changing.

// List.copyOf — creates a NEW unmodifiable list with a snapshot of elements
List<String> copied = List.copyOf(original);
original.add("Dave");            // copied is unchanged — it's a separate snapshot
// Use List.copyOf when you need a true independent copy.
```

**Rule of thumb:**
- `List.copyOf()` in **constructors** — independent snapshot, immune to caller mutations
- `Collections.unmodifiableList()` in **getters** when you want to expose a live view but prevent modification through the returned reference

### 5.4 Mutable Elements Inside Collections

`List.copyOf` is a shallow copy — if the list contains mutable objects, those are still shared:

```java
// Still broken if elements are mutable:
public final class Registry {
    private final List<Date> dates;

    public Registry(List<Date> dates) {
        this.dates = List.copyOf(dates); // unmodifiable list — but Date elements are mutable!
    }

    public List<Date> getDates() {
        return dates; // safe from add/remove, but elements can still be mutated!
    }
}

List<Date> input = new ArrayList<>();
input.add(new Date());
Registry r = new Registry(input);
r.getDates().get(0).setTime(0L);  // UnsupportedOperationException on the list
                                  // BUT: if you had a reference to the Date itself:
Date d = r.getDates().get(0);
d.setTime(0L);  // WORKS — modifies the Date inside the registry!
```

**Fix: use `java.time` types as elements, or deep-copy:**

```java
// Fix 1: java.time (preferred)
public final class Registry {
    private final List<Instant> dates;

    public Registry(List<Instant> dates) {
        this.dates = List.copyOf(dates); // shallow copy is fine — Instant is immutable
    }

    public List<Instant> getDates() {
        return dates;
    }
}

// Fix 2: deep copy each Date element
public final class Registry {
    private final List<Date> dates;

    public Registry(List<Date> dates) {
        Objects.requireNonNull(dates, "dates must not be null");
        this.dates = dates.stream()
            .map(d -> new Date(d.getTime()))   // copy each Date
            .collect(Collectors.toUnmodifiableList());
    }

    public List<Date> getDates() {
        return dates.stream()
            .map(d -> new Date(d.getTime()))   // copy each Date on output
            .collect(Collectors.toUnmodifiableList());
    }
}
```

---

## 6. Custom Mutable Objects

### 6.1 When to Defensive-Copy Custom Classes

Custom classes need defensive copying if they are **mutable** — i.e., they have methods that change their state after creation. Check:

```java
// Mutable custom class — has setter methods
public class Address {
    private String street;
    private String city;

    public void setStreet(String s) { this.street = s; }  // mutable!
    public void setCity(String c)   { this.city = c; }    // mutable!
}

// Immutable custom class — no state change after construction
public final class ImmutableAddress {
    private final String street;
    private final String city;

    public ImmutableAddress(String street, String city) {
        this.street = Objects.requireNonNull(street);
        this.city   = Objects.requireNonNull(city);
    }

    public String getStreet() { return street; }
    public String getCity()   { return city; }
    // No setters — cannot be mutated
}
```

If your field type is an immutable class (no setters, all fields final), no defensive copy is needed. If it has any mutable state, you must copy.

### 6.2 Copy Constructors

The standard pattern for defensive-copying custom objects: provide a **copy constructor**:

```java
public class Address {
    private String street;
    private String city;

    // Regular constructor
    public Address(String street, String city) {
        this.street = street;
        this.city   = city;
    }

    // Copy constructor — creates an independent copy
    public Address(Address other) {
        this.street = other.street; // String is immutable — no need to copy
        this.city   = other.city;
    }

    // Setters (making this a mutable class)
    public void setStreet(String s) { this.street = s; }
    public void setCity(String c)   { this.city = c; }
}

// Using copy constructor for defensive copy:
public final class Person {
    private final String name;
    private final Address address;

    public Person(String name, Address address) {
        this.name    = Objects.requireNonNull(name);
        this.address = new Address(address);  // copy constructor — defensive copy
    }

    public Address getAddress() {
        return new Address(address);  // copy constructor — defensive copy
    }
}
```

### 6.3 `Cloneable` and `clone()` — Approach with Caution

`Object.clone()` can be used but is fragile:

```java
// clone() approach — works but has pitfalls
public Address getAddress() {
    return address.clone(); // must cast from Object — unchecked warning
}

// Problems with clone():
// 1. Must implement Cloneable — easy to forget
// 2. Returns Object — requires cast
// 3. Shallow by default — subclasses may not override for deep copy
// 4. Can't be used if class doesn't implement Cloneable (throws CloneNotSupportedException)

// Prefer: copy constructor, factory method, or switch to immutable types
```

### 6.4 Nested Mutable Objects — Deep Copy

If your mutable class itself contains mutable objects, the copy constructor must copy those too:

```java
public class Order {
    private String id;
    private List<String> items;  // mutable list of mutable (in theory) items
    private Date placedAt;

    // Copy constructor — deep copy
    public Order(Order other) {
        this.id       = other.id;                                  // String — immutable
        this.items    = new ArrayList<>(other.items);              // new list (Strings are immutable)
        this.placedAt = new Date(other.placedAt.getTime());        // copy each Date
    }
}
```

---

## 7. Building a Genuinely Immutable Class — Full Checklist

### 7.1 The Complete Immutability Checklist

```
□ 1. Class is declared `final` (prevents subclasses overriding behavior)
□ 2. All fields are `private final`
□ 3. No setter methods
□ 4. For each mutable field type (array, Date, Calendar, mutable collection,
     mutable custom object):
     □ 4a. Defensive copy in constructor: store a copy, not the caller's reference
     □ 4b. Defensive copy in getter: return a copy, not the internal reference
□ 5. Copy-before-validate in constructor (prevent TOCTOU)
□ 6. Deep copy arrays of mutable objects (not just shallow clone)
□ 7. Deep copy multi-dimensional arrays
□ 8. For collections of mutable objects: copy each element, not just the collection
□ 9. Prefer java.time over Date/Calendar (eliminates entire category of problem)
□ 10. Prefer List.copyOf / Set.copyOf / Map.copyOf over Collections.unmodifiableX
      for independent snapshots
```

### 7.2 A Complete, Genuinely Immutable Class

```java
import java.time.*;
import java.util.*;

/**
 * Genuinely immutable employee record.
 * All mutation attempts are structurally impossible.
 */
public final class ImmutableEmployee {                    // ① final class

    private final long id;                                // ② final primitive — always safe
    private final String name;                            // ② String is immutable
    private final LocalDate hireDate;                     // ② LocalDate is immutable
    private final Instant lastModified;                   // ② Instant is immutable
    private final int[] performanceScores;                // ② final reference BUT array is mutable
    private final List<String> roles;                     // ② final reference BUT list is mutable

    public ImmutableEmployee(long id, String name, LocalDate hireDate,
                              Instant lastModified, int[] performanceScores,
                              List<String> roles) {

        // ③ validate before storing (for immutable types — OK to validate then store)
        if (id <= 0) throw new IllegalArgumentException("id must be positive");
        Objects.requireNonNull(name, "name must not be null");
        if (name.isBlank()) throw new IllegalArgumentException("name must not be blank");
        Objects.requireNonNull(hireDate, "hireDate must not be null");
        Objects.requireNonNull(lastModified, "lastModified must not be null");
        Objects.requireNonNull(performanceScores, "performanceScores must not be null");
        Objects.requireNonNull(roles, "roles must not be null");

        this.id           = id;
        this.name         = name;           // immutable — no copy needed
        this.hireDate     = hireDate;       // immutable — no copy needed
        this.lastModified = lastModified;   // immutable — no copy needed

        // ④ DEFENSIVE COPY for mutable types on INPUT:
        this.performanceScores = Arrays.copyOf(performanceScores,
                                               performanceScores.length); // ④a array copy
        this.roles = List.copyOf(roles);    // ④b list copy (unmodifiable snapshot)
    }

    // ⑤ No setters — ever

    // Getters for immutable types — safe to return directly
    public long      getId()           { return id; }
    public String    getName()         { return name; }
    public LocalDate getHireDate()     { return hireDate; }
    public Instant   getLastModified() { return lastModified; }

    // ④ DEFENSIVE COPY for mutable types on OUTPUT:
    public int[] getPerformanceScores() {
        return Arrays.copyOf(performanceScores, performanceScores.length); // ④a copy
    }

    public List<String> getRoles() {
        // Already unmodifiable — safe to return directly
        // List.copyOf stores an unmodifiable list, so no further copying needed
        return roles; // ④b: unmodifiable list — safe to expose
    }

    // Utility: element access without exposing array
    public int getScoreCount() { return performanceScores.length; }
    public int getScore(int i) { return performanceScores[i]; }  // primitive — always safe

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ImmutableEmployee e)) return false;
        return id == e.id &&
               name.equals(e.name) &&
               hireDate.equals(e.hireDate) &&
               lastModified.equals(e.lastModified) &&
               Arrays.equals(performanceScores, e.performanceScores) &&
               roles.equals(e.roles);
    }

    @Override
    public int hashCode() {
        int result = Long.hashCode(id);
        result = 31 * result + name.hashCode();
        result = 31 * result + hireDate.hashCode();
        result = 31 * result + lastModified.hashCode();
        result = 31 * result + Arrays.hashCode(performanceScores);
        result = 31 * result + roles.hashCode();
        return result;
    }

    @Override
    public String toString() {
        return "ImmutableEmployee{id=" + id +
               ", name='" + name + '\'' +
               ", hireDate=" + hireDate +
               ", roles=" + roles + '}';
    }
}
```

---

## 8. Records and Immutability

### 8.1 Records Are Not Automatically Fully Immutable

Java records (`record`) are often described as "immutable," but they have the same vulnerability with mutable component types:

```java
// BROKEN record — not truly immutable despite being a record
record Snapshot(LocalDate date, int[] values) {}

Snapshot s = new Snapshot(LocalDate.now(), new int[]{1, 2, 3});
// The record's canonical accessor returns the actual array:
s.values()[0] = 999;   // modifies the record's internal array!
```

### 8.2 Compact Constructors for Records

Use a **compact constructor** to add defensive copies in records:

```java
// FIXED record — genuinely immutable
record Snapshot(LocalDate date, int[] values) {

    // Compact constructor: runs before the canonical constructor assigns fields
    Snapshot {
        // Validate
        Objects.requireNonNull(date, "date must not be null");
        Objects.requireNonNull(values, "values must not be null");

        // DEFENSIVE COPY: reassign the compact constructor parameter
        // The canonical constructor will then assign this.values = values (the copy)
        values = Arrays.copyOf(values, values.length);
        // Note: date is LocalDate — immutable, no copy needed
    }

    // Override the generated accessor to return a copy
    @Override
    public int[] values() {
        return Arrays.copyOf(values, values.length);
    }
}

// Now truly immutable:
int[] input = {1, 2, 3};
Snapshot s = new Snapshot(LocalDate.now(), input);
input[0] = 999;          // no effect on s
s.values()[0] = 999;     // no effect on s — accessor returns a copy
```

### 8.3 Record with Collection Fields

```java
record TeamSnapshot(String teamName, List<String> members) {

    TeamSnapshot {
        Objects.requireNonNull(teamName, "teamName must not be null");
        Objects.requireNonNull(members, "members must not be null");
        // List.copyOf handles the defensive copy + makes it unmodifiable
        members = List.copyOf(members);
    }

    // accessor already returns the unmodifiable list — no override needed
    // BUT if you want to be extra explicit:
    @Override
    public List<String> members() {
        return members; // already unmodifiable from List.copyOf
    }
}
```

---

## 9. Performance Considerations

### 9.1 Cost of Defensive Copies

Defensive copies are not free. Each copy allocates a new object and copies elements:

```java
// Array copy cost:
// - int[1000]:  ~1µs   (just a System.arraycopy call)
// - Date[100]:  ~10µs  (100 new Date allocations + 100 getTime() calls)
// - int[10]:    ~50ns  (negligible)

// Collection copy cost:
// - List.copyOf(list with 10 elements):   negligible
// - List.copyOf(list with 10,000 elements): ~100µs
```

### 9.2 When the Cost Is Worth It

```
Almost always worth it:
- Security-sensitive code (authentication, authorization, financial)
- Public API methods (called by code you don't control)
- Shared state in multithreaded code
- Any truly immutable type

Possibly skip when:
- Private internal methods in performance-critical inner loops
- Both caller and class are in same package under your control
- Profiler shows copy as a real bottleneck
- After measuring — not before
```

### 9.3 Alternatives to Copying

```java
// Alternative 1: Return unmodifiable wrapper (no copy, but caller sees live changes)
public List<String> getMembers() {
    return Collections.unmodifiableList(members); // wrap, don't copy
    // Caller can't add/remove, but if you modify members, they see the change
}

// Alternative 2: Expose elements without exposing the container
// Avoids copying entirely:
public int memberCount() { return members.size(); }
public String getMember(int i) { return members.get(i); } // String is immutable
public Stream<String> members() { return members.stream(); } // lazy, no copy

// Alternative 3: Use immutable types from the start
// If LocalDate, String, Integer etc. — no copy needed, ever.
// The best optimization is having nothing to copy.

// Alternative 4: For arrays, expose an IntStream / stream of primitives
public IntStream scores() {
    return Arrays.stream(performanceScores); // no array copy — stream reads elements
}
```

---

## 10. Quick Reference Cheat Sheet

### When Is a Copy Needed?

| Type | Mutable? | Constructor | Getter |
|---|---|---|---|
| `int`, `long`, `double`, etc. (primitives) | No | No copy | No copy (copied by value) |
| `String` | No | No copy | No copy |
| `LocalDate`, `LocalDateTime`, `Instant`, `Duration` | No | No copy | No copy |
| `Integer`, `Long`, `Double` (wrappers) | No | No copy | No copy |
| `BigDecimal`, `BigInteger` | No | No copy | No copy |
| `java.util.Date` | **Yes** | `new Date(d.getTime())` | `new Date(d.getTime())` |
| `java.util.Calendar` | **Yes** | `(Calendar) c.clone()` | `(Calendar) c.clone()` |
| `int[]`, `String[]`, any array | **Yes** | `Arrays.copyOf(a, a.length)` | `Arrays.copyOf(a, a.length)` |
| `int[][]` (2D array) | **Yes** | Copy each row | Copy each row |
| `ArrayList`, `LinkedList` | **Yes** | `List.copyOf(list)` | `List.copyOf(list)` or return unmodifiable |
| `HashMap`, `HashSet` | **Yes** | `Map.copyOf(map)` | `Map.copyOf(map)` |
| Custom mutable class | **Yes** | Copy constructor | Copy constructor |
| Custom immutable class (all final, no setters) | No | No copy | No copy |

### Copy Recipes

```java
// Primitives — no copy needed (passed by value)
int x = this.x;                   // already a copy

// String — no copy needed (immutable)
String s = this.name;             // safe

// java.time types — no copy needed (immutable)
LocalDate d = this.date;          // safe

// Date — copy using epoch milliseconds
Date copy = new Date(original.getTime());

// Calendar — clone
Calendar copy = (Calendar) original.clone();

// 1D array of primitives
int[] copy = Arrays.copyOf(original, original.length);

// 1D array of immutable objects (String, LocalDate, etc.)
String[] copy = Arrays.copyOf(original, original.length);  // shallow is fine

// 1D array of mutable objects (Date, etc.)
Date[] copy = new Date[original.length];
for (int i = 0; i < original.length; i++)
    copy[i] = original[i] == null ? null : new Date(original[i].getTime());

// 2D array of primitives
int[][] copy = new int[original.length][];
for (int i = 0; i < original.length; i++)
    copy[i] = Arrays.copyOf(original[i], original[i].length);

// List (snapshot, unmodifiable)
List<T> copy = List.copyOf(original);

// List (snapshot, modifiable copy)
List<T> copy = new ArrayList<>(original);

// Map
Map<K,V> copy = Map.copyOf(original);
```

### Key Rules to Remember

1. **Always copy mutable constructor arguments before storing** — caller may mutate after construction.
2. **Always copy mutable fields before returning** — caller may mutate the returned reference.
3. **Copy before validate** in constructors (TOCTOU prevention in concurrent code).
4. **`final` on a field does not make the object immutable** — only prevents reassigning the reference.
5. **`List.copyOf` ≠ `Collections.unmodifiableList`** — `copyOf` is a snapshot; `unmodifiable` is a live view.
6. **Shallow copy is only safe when elements are immutable** — arrays/collections of `Date` need deep copy.
7. **`java.time` types eliminate the entire problem** — prefer `LocalDate`/`Instant` over `Date`/`Calendar`.
8. **Records need compact constructors** — the generated constructor does NOT copy mutable components.
9. **Returning an unmodifiable wrapper is not the same as defensive copying** — caller sees future mutations to the internal collection through the wrapper.
10. **Declare classes `final`** unless inheritance is intentional — prevents subclasses breaking immutability guarantees.

---

*End of Defensive Copies for Mutable Types Study Guide*
