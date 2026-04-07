# Java Regular Expressions — Complete Study Guide

> **Module 12 | Brutally Detailed Reference**
> Covers every concept from basic pattern matching to catastrophic backtracking, ReDoS, and performance engineering. Every section includes full working examples.

---

## Table of Contents

1. [Overview & The `java.util.regex` Package](#1-overview--the-javautilregex-package)
2. [The `Pattern` Class — Compiling Regex Patterns](#2-the-pattern-class--compiling-regex-patterns)
3. [The `Matcher` Class — find(), matches(), group(), start(), end()](#3-the-matcher-class--find-matches-group-start-end)
4. [Character Classes](#4-character-classes)
5. [Quantifiers — Greedy, Reluctant, Possessive](#5-quantifiers--greedy-reluctant-possessive)
6. [Anchors — `^`, `$`, `\b`](#6-anchors----b)
7. [Groups and Capturing — Backreferences](#7-groups-and-capturing--backreferences)
8. [Named Groups](#8-named-groups)
9. [Non-Capturing Groups](#9-non-capturing-groups)
10. [Lookahead and Lookbehind](#10-lookahead-and-lookbehind)
11. [String Regex Methods](#11-string-regex-methods)
12. [Pattern.compile() Flags](#12-patterncompile-flags)
13. [Pre-Compiling Patterns — Performance Best Practice](#13-pre-compiling-patterns--performance-best-practice)
14. [Catastrophic Backtracking & ReDoS](#14-catastrophic-backtracking--redos)
15. [Performance: Pattern+Matcher vs String.matches()](#15-performance-patternmatcher-vs-stringmatches)
16. [Additional Topics Not in the Module Outline](#16-additional-topics-not-in-the-module-outline)
17. [Quick Reference Cheat Sheet](#17-quick-reference-cheat-sheet)

---

## 1. Overview & The `java.util.regex` Package

Java's regular expression engine lives in the `java.util.regex` package and has been part of the standard library since Java 1.4. It is a **NFA (Nondeterministic Finite Automaton)**-based engine, which means it uses backtracking. This gives it great flexibility (lookaheads, backreferences, etc.) but also exposes it to catastrophic backtracking if patterns are poorly written (covered in Section 14).

### Core Classes

| Class | Purpose |
|---|---|
| `Pattern` | An immutable, compiled representation of a regex |
| `Matcher` | A stateful engine that performs match operations on a `CharSequence` using a `Pattern` |
| `PatternSyntaxException` | Thrown when a regex syntax is illegal |

### Minimal Hello World

```java
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class RegexHello {
    public static void main(String[] args) {
        String input = "Hello, World! Hello, Java!";
        Pattern pattern = Pattern.compile("Hello");
        Matcher matcher = pattern.matcher(input);

        while (matcher.find()) {
            System.out.println("Found '" + matcher.group()
                + "' at index " + matcher.start()
                + " to " + matcher.end());
        }
    }
}
```

**Output:**
```
Found 'Hello' at index 0 to 5
Found 'Hello' at index 14 to 19
```

---

## 2. The `Pattern` Class — Compiling Regex Patterns

`Pattern` is the heart of Java regex. It compiles a regex string into an internal representation that can be reused efficiently by many `Matcher` instances.

### 2.1 `Pattern.compile(String regex)`

The standard factory method. Compiles the given regular expression into a pattern.

```java
Pattern p = Pattern.compile("\\d{3}-\\d{4}");
```

> **Why compile?** Raw strings like `"\d"` are Java strings. In Java, `\d` must be written as `\\d` because `\` is Java's escape character. The regex engine then sees `\d` and interprets it as "a digit."

### 2.2 `Pattern.compile(String regex, int flags)`

Compiles with one or more flags (see Section 12).

```java
Pattern p = Pattern.compile("hello", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE);
```

### 2.3 `Pattern.matches(String regex, CharSequence input)` — Static Shortcut

A static convenience method. Returns `true` if the **entire** input matches the pattern. Internally compiles the pattern every time — **never use in loops**.

```java
boolean result = Pattern.matches("\\d+", "12345"); // true
boolean result2 = Pattern.matches("\\d+", "123abc"); // false — not full match
```

### 2.4 `Pattern.matcher(CharSequence input)`

Creates a `Matcher` instance for the given input. This is the primary way to use a compiled pattern.

```java
Pattern p = Pattern.compile("\\b\\w+\\b");
Matcher m = p.matcher("Hello World");
```

### 2.5 `Pattern.split(CharSequence input)`

Splits the input string around matches of the pattern. Equivalent to `String.split()` but reuses a compiled pattern.

```java
Pattern p = Pattern.compile("\\s+");
String[] tokens = p.split("one  two   three");
// ["one", "two", "three"]
```

### 2.6 `Pattern.split(CharSequence input, int limit)`

- `limit > 0`: At most `limit` substrings; trailing empty strings kept.
- `limit < 0`: Unlimited splits; trailing empty strings kept.
- `limit == 0` (default): Unlimited splits; trailing empty strings discarded.

```java
Pattern p = Pattern.compile(",");
String[] a = p.split("a,b,c,,", 0);  // ["a", "b", "c"]      — trailing empties dropped
String[] b = p.split("a,b,c,,", -1); // ["a", "b", "c", "", ""] — all kept
String[] c = p.split("a,b,c,,", 2);  // ["a", "b,c,,"]        — max 2 parts
```

### 2.7 `Pattern.pattern()` — Retrieve Original Regex String

```java
Pattern p = Pattern.compile("\\d+");
System.out.println(p.pattern()); // prints: \d+
```

### 2.8 `Pattern.flags()` — Retrieve Active Flags

```java
Pattern p = Pattern.compile("abc", Pattern.CASE_INSENSITIVE);
System.out.println(p.flags()); // prints: 2 (bitmask value of CASE_INSENSITIVE)
```

### 2.9 `Pattern.quote(String s)` — Literal Pattern from String

Escapes a string so it is treated as a literal regex. Useful when the user provides dynamic input.

```java
String userInput = "1+1=2 (really?)";
Pattern p = Pattern.compile(Pattern.quote(userInput));
// Matches the literal string "1+1=2 (really?)"
```

---

## 3. The `Matcher` Class — find(), matches(), group(), start(), end()

A `Matcher` is created by `pattern.matcher(input)`. It is **stateful**: it tracks its current position within the input string.

### 3.1 `find()` — Scan for Next Match

Finds the next subsequence that matches the pattern. Returns `true` if found, advances the internal cursor.

```java
Pattern p = Pattern.compile("\\d+");
Matcher m = p.matcher("abc 123 def 456 ghi 789");

while (m.find()) {
    System.out.println("Found: " + m.group()); // 123, 456, 789
}
```

### 3.2 `find(int start)` — Find from a Specific Position

Resets the matcher and starts searching from the given index.

```java
Matcher m = Pattern.compile("\\d+").matcher("abc 123 def 456");
m.find(8); // start search after index 8
System.out.println(m.group()); // 456
```

### 3.3 `matches()` — Full Input Must Match

Attempts to match the **entire** input against the pattern. Returns `true` only if the whole string matches.

```java
Pattern p = Pattern.compile("\\d{5}");
System.out.println(p.matcher("12345").matches());   // true
System.out.println(p.matcher("123456").matches());  // false — 6 digits, full match fails
System.out.println(p.matcher("1234").matches());    // false — only 4 digits
```

### 3.4 `lookingAt()` — Match at the Beginning Only

Like `matches()` but doesn't require the entire string to match — only the beginning.

```java
Pattern p = Pattern.compile("\\d+");
Matcher m = p.matcher("123abc");
System.out.println(m.lookingAt()); // true  — starts with digits
System.out.println(m.matches());   // false — doesn't match entirely
```

### 3.5 `group()` — Get the Matched Text

Returns the input subsequence matched by the previous successful `find()` or `matches()` call.

```java
Pattern p = Pattern.compile("(\\w+)@(\\w+\\.\\w+)");
Matcher m = p.matcher("user@example.com");
if (m.find()) {
    System.out.println(m.group());    // user@example.com (entire match)
    System.out.println(m.group(1));   // user (group 1)
    System.out.println(m.group(2));   // example.com (group 2)
}
```

### 3.6 `group(int group)` — Specific Capture Group

- `group(0)` is the same as `group()` — the entire match.
- `group(1)`, `group(2)`, … refer to numbered capture groups left to right by opening parenthesis.

```java
Pattern p = Pattern.compile("(\\d{4})-(\\d{2})-(\\d{2})");
Matcher m = p.matcher("Date: 2024-07-15");
if (m.find()) {
    System.out.println("Year:  " + m.group(1)); // 2024
    System.out.println("Month: " + m.group(2)); // 07
    System.out.println("Day:   " + m.group(3)); // 15
}
```

### 3.7 `start()` and `end()` — Match Position

- `start()` — index of the first character of the match.
- `end()` — index **after** the last character (exclusive). This follows Java's convention of half-open intervals.
- `start(int group)` and `end(int group)` work on capture groups.

```java
Pattern p = Pattern.compile("cat");
Matcher m = p.matcher("The cat sat on the cat mat");

while (m.find()) {
    System.out.printf("Found '%s' [%d, %d)%n", m.group(), m.start(), m.end());
}
// Found 'cat' [4, 7)
// Found 'cat' [19, 22)
```

> **Tip:** `input.substring(m.start(), m.end())` always equals `m.group()`.

### 3.8 `reset()` — Restart the Matcher

Resets the matcher to its initial state (position 0 in the input).

```java
Matcher m = p.matcher("abc 123");
m.find(); // positions at 123
m.reset(); // back to start
m.find(); // finds 123 again
```

### 3.9 `reset(CharSequence newInput)` — Change Input

Resets and attaches a new input string without creating a new `Matcher`.

```java
Matcher m = p.matcher("first input");
// ... operations ...
m.reset("second input"); // reuse matcher with new input
```

### 3.10 `replaceAll(String replacement)` and `replaceFirst(String replacement)`

These work like the `String` methods but allow reuse of the compiled pattern.

```java
Pattern p = Pattern.compile("\\b\\d+\\b");
Matcher m = p.matcher("I have 3 cats and 7 dogs");
System.out.println(m.replaceAll("many")); // I have many cats and many dogs
System.out.println(m.replaceFirst("X"));  // I have X cats and 7 dogs
```

### 3.11 `appendReplacement()` and `appendTail()` — Custom Replacement Logic

These methods enable powerful replacement with transformation logic.

```java
// Double every number found in the string
Pattern p = Pattern.compile("\\d+");
Matcher m = p.matcher("I have 3 cats and 7 dogs");
StringBuffer sb = new StringBuffer();

while (m.find()) {
    int val = Integer.parseInt(m.group());
    m.appendReplacement(sb, String.valueOf(val * 2));
}
m.appendTail(sb);
System.out.println(sb.toString()); // I have 6 cats and 14 dogs
```

### 3.12 `groupCount()` — Number of Capturing Groups

Returns the number of capturing groups in the pattern (does not count group 0).

```java
Pattern p = Pattern.compile("(a)(b(c))");
Matcher m = p.matcher("abc");
System.out.println(m.groupCount()); // 3 — groups: (a), (b(c)), (c)
```

### 3.13 `hitEnd()` and `requireEnd()`

- `hitEnd()` — `true` if the last match attempt reached the end of input.
- `requireEnd()` — `true` if more input could change a positive match into a negative one (relevant for streaming/incremental input).

---

## 4. Character Classes

Character classes define a **set** of characters that can match at a single position.

### 4.1 Simple Character Class `[abc]`

Matches any single character that is `a`, `b`, or `c`.

```java
Pattern p = Pattern.compile("[aeiou]");
Matcher m = p.matcher("Hello World");
while (m.find()) System.out.print(m.group() + " "); // e o o
```

### 4.2 Range `[a-z]`, `[A-Z]`, `[0-9]`

A hyphen inside `[]` denotes a range.

```java
Pattern lower  = Pattern.compile("[a-z]+");
Pattern upper  = Pattern.compile("[A-Z]+");
Pattern digits = Pattern.compile("[0-9]+");
Pattern alnum  = Pattern.compile("[a-zA-Z0-9]+");
Pattern hex    = Pattern.compile("[0-9a-fA-F]+");
```

### 4.3 Negated Class `[^...]`

`^` as the **first** character inside `[]` negates the class — matches any character **not** in the set.

```java
Pattern p = Pattern.compile("[^aeiou]+"); // one or more non-vowels
Matcher m = p.matcher("Hello World");
while (m.find()) System.out.print("[" + m.group() + "]");
// [H][ll][ W][rld]
```

> If `^` is not the first character, it is treated literally: `[a^b]` matches `a`, `^`, or `b`.

### 4.4 Union `[a-z[A-Z]]`

Character class union — matches chars in either class. (Nested `[]` are treated as union.)

```java
Pattern p = Pattern.compile("[a-z[A-Z]]"); // same as [a-zA-Z]
```

### 4.5 Intersection `[a-z&&[^aeiou]]`

`&&` inside character classes performs intersection.

```java
// Lowercase consonants only
Pattern p = Pattern.compile("[a-z&&[^aeiou]]+");
Matcher m = p.matcher("hello");
while (m.find()) System.out.print(m.group()); // hll
```

### 4.6 Subtraction `[a-z&&[^m-p]]`

Subtracts one set from another using `&&[^...]`.

```java
// Lowercase letters except m, n, o, p
Pattern p = Pattern.compile("[a-z&&[^m-p]]+");
```

### 4.7 Predefined (POSIX-style) Character Classes

These are shorthand for common sets:

| Shorthand | Equivalent | Meaning |
|---|---|---|
| `\d` | `[0-9]` | Any digit |
| `\D` | `[^0-9]` | Any non-digit |
| `\w` | `[a-zA-Z_0-9]` | Word character (letter, digit, underscore) |
| `\W` | `[^\w]` | Non-word character |
| `\s` | `[ \t\n\x0B\f\r]` | Whitespace |
| `\S` | `[^\s]` | Non-whitespace |
| `.`  | `[^\n]` (default) | Any character except newline (unless DOTALL flag is set) |

```java
Pattern ip = Pattern.compile("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");
Matcher m = ip.matcher("IP: 192.168.1.255 is valid");
if (m.find()) System.out.println(m.group()); // 192.168.1.255
```

### 4.8 POSIX Classes (via `\p{...}`)

Java supports POSIX classes in the `\p{Name}` syntax:

| Class | Meaning |
|---|---|
| `\p{Lower}` | Lowercase ASCII `[a-z]` |
| `\p{Upper}` | Uppercase ASCII `[A-Z]` |
| `\p{Alpha}` | Alphabetic `[a-zA-Z]` |
| `\p{Digit}` | Digit `[0-9]` |
| `\p{Alnum}` | Alphanumeric |
| `\p{Space}` | Whitespace `[ \t\n\x0B\f\r]` |
| `\p{Punct}` | Punctuation |
| `\p{Print}` | Printable characters |
| `\p{Blank}` | Space or tab |

```java
Pattern p = Pattern.compile("\\p{Upper}\\p{Lower}+"); // Word starting with capital
```

### 4.9 Unicode Properties

```java
Pattern p = Pattern.compile("\\p{L}+");    // Any Unicode letter
Pattern q = Pattern.compile("\\p{N}+");    // Any Unicode number
Pattern r = Pattern.compile("\\p{InGreek}"); // Greek Unicode block
```

### 4.10 Full Example — Character Class Showcase

```java
public class CharClassDemo {
    public static void main(String[] args) {
        String text = "Java8 is gr8! Phone: +1 (800) 555-0123";

        // All digits
        printAll("\\d+", text);           // 8, 8, 1, 800, 555, 0123

        // All non-digits (runs)
        printAll("\\D+", text);           // "Java", " is gr", "! Phone: +", " (", ") ", "-"

        // All word characters (runs)
        printAll("\\w+", text);           // Java8, is, gr8, Phone, 1, 800, 555, 0123

        // Only vowels
        printAll("[aeiouAEIOU]", text);   // a, i, o, e

        // Hex-like sequences
        printAll("[0-9a-fA-F]+", text);   // 8, 8, 1, 800, 555, 0123
    }

    static void printAll(String regex, String input) {
        Matcher m = Pattern.compile(regex).matcher(input);
        StringBuilder sb = new StringBuilder(regex + " -> ");
        while (m.find()) sb.append("[").append(m.group()).append("]");
        System.out.println(sb);
    }
}
```

---

## 5. Quantifiers — Greedy, Reluctant, Possessive

Quantifiers specify **how many times** the preceding element can match.

### 5.1 Basic Quantifiers

| Quantifier | Meaning |
|---|---|
| `*` | 0 or more |
| `+` | 1 or more |
| `?` | 0 or 1 (optional) |
| `{n}` | Exactly n times |
| `{n,}` | At least n times |
| `{n,m}` | At least n, at most m times |

```java
Pattern p1 = Pattern.compile("\\d*");     // zero or more digits
Pattern p2 = Pattern.compile("\\d+");     // one or more digits
Pattern p3 = Pattern.compile("\\d?");     // zero or one digit
Pattern p4 = Pattern.compile("\\d{3}");   // exactly 3 digits
Pattern p5 = Pattern.compile("\\d{3,}");  // 3 or more digits
Pattern p6 = Pattern.compile("\\d{3,5}"); // between 3 and 5 digits
```

### 5.2 Greedy Quantifiers (Default)

Greedy quantifiers try to match **as much as possible** first. They then "give back" characters one by one if the overall match fails (backtracking).

```java
// Greedy — matches the LARGEST possible string
Pattern greedy = Pattern.compile("<.+>");
Matcher m = greedy.matcher("<b>bold</b> and <i>italic</i>");
if (m.find()) {
    System.out.println(m.group()); // <b>bold</b> and <i>italic</i>
}
// The greedy .+ consumed everything up to the LAST >
```

**Step-by-step trace of greedy `<.+>` on `<b>bold</b>`:**
1. `<` matches `<`
2. `.+` greedily consumes `b>bold</b>` (everything to end)
3. `>` needs to match — end of string, fails
4. `.+` gives back one char: `b>bold</b` — `>` still doesn't match `b`
5. Keeps giving back until `>` matches the final `>`
6. Result: `<b>bold</b>`

### 5.3 Reluctant (Lazy) Quantifiers — `*?`, `+?`, `??`, `{n,m}?`

Append `?` to any quantifier to make it **reluctant** (lazy). It tries to match **as little as possible** first.

```java
Pattern lazy = Pattern.compile("<.+?>");
Matcher m = lazy.matcher("<b>bold</b> and <i>italic</i>");
while (m.find()) {
    System.out.println(m.group());
}
// <b>
// </b>
// <i>
// </i>
```

**Step-by-step trace of lazy `<.+?>` on `<b>bold</b>`:**
1. `<` matches `<`
2. `.+?` tries to match just 1 char: `b`
3. `>` needs to match — `>` is next — success!
4. Match: `<b>`

### 5.4 Possessive Quantifiers — `*+`, `++`, `?+`, `{n,m}+`

Append `+` to any quantifier to make it **possessive**. It matches as much as possible and **never gives back** characters. This prevents backtracking entirely.

- Possessive quantifiers are useful for performance when you know backtracking isn't needed.
- They can cause an overall match to fail when a greedy quantifier would have succeeded (because greedy eventually backtracks).

```java
// Greedy — succeeds
Pattern greedy = Pattern.compile("\\d+[a-z]");
System.out.println(greedy.matcher("123a").matches()); // true
// \d+ matches 123, then tries [a-z] on 'a' — success

// Possessive — FAILS
Pattern possessive = Pattern.compile("\\d++[a-z]");
System.out.println(possessive.matcher("123a").matches()); // false
// \d++ gobbles 123 AND 'a' (because 'a' doesn't match \d, stops at 3)
// Wait — 'a' is not a digit. \d++ matches "123". Then [a-z] matches 'a'. TRUE!
// Let's use a trickier example:
Pattern p2 = Pattern.compile("[a-z]++[a-z]");
System.out.println(p2.matcher("abc").matches()); // false
// [a-z]++ consumes ALL of "abc" — nothing left for the trailing [a-z]
// Greedy would backtrack and give back 'c', but possessive won't
Pattern p3 = Pattern.compile("[a-z]+[a-z]");
System.out.println(p3.matcher("abc").matches()); // true (greedy backtracks)
```

### 5.5 Comparison Table

| Type | Syntax | Strategy | Backtrack? |
|---|---|---|---|
| Greedy | `*`, `+`, `?`, `{n,m}` | Match most, give back if needed | Yes |
| Reluctant | `*?`, `+?`, `??`, `{n,m}?` | Match least, expand if needed | Yes |
| Possessive | `*+`, `++`, `?+`, `{n,m}+` | Match most, never give back | No |

### 5.6 Practical Example — Parsing HTML Tags

```java
String html = "<div><p>Hello</p><p>World</p></div>";

// Greedy — wrong result
Pattern greedy = Pattern.compile("<p>.*</p>");
Matcher m1 = greedy.matcher(html);
if (m1.find()) System.out.println("Greedy: " + m1.group());
// <p>Hello</p><p>World</p>  — too much!

// Reluctant — correct result, finds each tag separately
Pattern lazy = Pattern.compile("<p>.*?</p>");
Matcher m2 = lazy.matcher(html);
while (m2.find()) System.out.println("Lazy: " + m2.group());
// <p>Hello</p>
// <p>World</p>
```

### 5.7 Full Quantifier Example

```java
public class QuantifierDemo {
    public static void main(String[] args) {
        String input = "aXXXb aXb aXXb";

        // Greedy: matches aXXXb first (biggest), then shorter ones
        System.out.println("Greedy a.*b:");
        find(Pattern.compile("a.*b"), input);

        // Lazy: matches first a...b with fewest chars
        System.out.println("Lazy a.*?b:");
        find(Pattern.compile("a.*?b"), input);

        // Exact
        System.out.println("Exact aX{2}b:");
        find(Pattern.compile("aX{2}b"), input);

        // Range
        System.out.println("Range aX{1,3}b:");
        find(Pattern.compile("aX{1,3}b"), input);
    }

    static void find(Pattern p, String input) {
        Matcher m = p.matcher(input);
        while (m.find()) System.out.println("  [" + m.group() + "]");
    }
}
```

---

## 6. Anchors — `^`, `$`, `\b`

Anchors do not consume characters. They assert a **position** in the string.

### 6.1 `^` — Start of Line/Input

- In default mode: matches the **start of the entire input**.
- With `Pattern.MULTILINE`: matches the start of **each line**.

```java
// Default: ^ means start of entire input
Pattern p = Pattern.compile("^\\d+");
System.out.println(p.matcher("123 abc").find()); // true  — starts with digits
System.out.println(p.matcher("abc 123").find()); // false — doesn't start with digits
```

### 6.2 `$` — End of Line/Input

- In default mode: matches the **end of the entire input** (or before a final newline).
- With `Pattern.MULTILINE`: matches the end of **each line**.

```java
Pattern p = Pattern.compile("\\d+$");
System.out.println(p.matcher("abc 123").find()); // true
System.out.println(p.matcher("123 abc").find()); // false
```

### 6.3 `\b` — Word Boundary

A zero-width assertion that matches the position between a word character (`\w`) and a non-word character (`\W`), or between a word character and the start/end of the string.

```java
Pattern p = Pattern.compile("\\bcat\\b");
Matcher m = p.matcher("The cat concatenate catfish cat.");

while (m.find()) {
    System.out.println("Found 'cat' at " + m.start());
}
// Found 'cat' at 4   (the standalone word "cat")
// Found 'cat' at 27  (the second standalone "cat")
// "concatenate" and "catfish" are NOT matched because 'cat' is not at a word boundary there
```

### 6.4 `\B` — Non-Word Boundary

Matches any position that is **not** a word boundary.

```java
Pattern p = Pattern.compile("\\Bcat\\B"); // cat in the MIDDLE of a word
Matcher m = p.matcher("concatenate");
if (m.find()) System.out.println("Found: " + m.group()); // cat (inside "conCATenate")
```

### 6.5 `\A`, `\Z`, `\z` — Absolute Start/End Anchors

These are not affected by `MULTILINE` mode:

| Anchor | Meaning |
|---|---|
| `\A` | Absolute start of input (same as `^` without MULTILINE) |
| `\Z` | End of input, except for final newline |
| `\z` | Absolute end of input (nothing after, not even newline) |

```java
Pattern p = Pattern.compile("\\A\\d+\\z");
System.out.println(p.matcher("12345").matches());   // true
System.out.println(p.matcher("12345\n").matches()); // false (\z is strict)

Pattern q = Pattern.compile("\\A\\d+\\Z");
System.out.println(q.matcher("12345\n").matches()); // true (\Z allows trailing newline)
```

### 6.6 Multiline Anchor Example

```java
String text = "First line\nSecond line\nThird line";

// Without MULTILINE: ^ only matches start of entire input
Pattern p1 = Pattern.compile("^\\w+");
Matcher m1 = p1.matcher(text);
while (m1.find()) System.out.println(m1.group()); // Only: First

// With MULTILINE: ^ matches start of each line
Pattern p2 = Pattern.compile("^\\w+", Pattern.MULTILINE);
Matcher m2 = p2.matcher(text);
while (m2.find()) System.out.println(m2.group()); // First, Second, Third
```

---

## 7. Groups and Capturing — Backreferences

Parentheses serve two purposes: **grouping** (applying quantifiers to a sequence) and **capturing** (saving the matched text for later use).

### 7.1 Basic Capturing Group `(abc)`

```java
Pattern p = Pattern.compile("(\\d+)\\.(\\d+)");
Matcher m = p.matcher("Version 3.14.2");
if (m.find()) {
    System.out.println("Full match: " + m.group(0)); // 3.14
    System.out.println("Group 1:    " + m.group(1)); // 3
    System.out.println("Group 2:    " + m.group(2)); // 14
}
```

### 7.2 Group Numbering Rules

Groups are numbered **left to right by their opening parenthesis**:

```
Pattern:   ( a ( b ( c ) ) ( d ) )
Group:      1   2   3     4
```

```java
Pattern p = Pattern.compile("(a(b(c))(d))");
Matcher m = p.matcher("abcd");
if (m.matches()) {
    System.out.println(m.group(0)); // abcd
    System.out.println(m.group(1)); // abcd
    System.out.println(m.group(2)); // bc
    System.out.println(m.group(3)); // c
    System.out.println(m.group(4)); // d
}
```

### 7.3 Backreferences in the Pattern `\1`, `\2`, …

A backreference `\N` matches the **same text** that was matched by group N. Use `\\1` in Java strings.

```java
// Match repeated words: "the the", "a a", etc.
Pattern p = Pattern.compile("\\b(\\w+)\\s+\\1\\b");
Matcher m = p.matcher("This is is a test of the the regex");
while (m.find()) {
    System.out.println("Duplicate: '" + m.group(1) + "' at " + m.start());
}
// Duplicate: 'is' at 5
// Duplicate: 'the' at 22
```

```java
// Match HTML tags with matching open/close
Pattern p = Pattern.compile("<(\\w+)>[^<]*</\\1>");
Matcher m = p.matcher("<b>bold</b> and <i>italic</x>");
while (m.find()) {
    System.out.println("Valid tag: " + m.group()); // <b>bold</b>   only!
}
// <i>italic</x> does NOT match because </x> != </i>
```

### 7.4 Backreferences in Replacements

In `replaceAll()` and `replaceFirst()`, use `$1`, `$2`, … to refer to capture groups.

```java
// Swap first and last name
Pattern p = Pattern.compile("(\\w+),\\s*(\\w+)");
String result = p.matcher("Smith, John").replaceAll("$2 $1");
System.out.println(result); // John Smith
```

```java
// Wrap all numbers in [brackets]
Pattern p = Pattern.compile("(\\d+)");
String result = p.matcher("I have 3 cats and 7 dogs").replaceAll("[$1]");
System.out.println(result); // I have [3] cats and [7] dogs
```

### 7.5 Groups with Quantifiers

When a group has a quantifier, `group()` returns the **last iteration's** capture only:

```java
Pattern p = Pattern.compile("(\\d+,?)+");
Matcher m = p.matcher("1,2,3,4");
if (m.find()) {
    System.out.println(m.group());    // 1,2,3,4 (whole match)
    System.out.println(m.group(1));   // 4        (last iteration of the group)
}
```

### 7.6 Optional Groups — May Be `null`

If a group is optional and didn't participate in the match, `group(n)` returns `null`.

```java
Pattern p = Pattern.compile("(\\+1)?\\s*(\\d{3})-(\\d{4})");
Matcher m = p.matcher("800-5551234");
// Wait, let me use a cleaner example:
Pattern p2 = Pattern.compile("(\\d{3})-(\\d{4})");
Matcher m2 = p2.matcher("555-1234");
if (m2.find()) {
    System.out.println(m2.group(1)); // 555
    System.out.println(m2.group(2)); // 1234
}

// Optional country code
Pattern p3 = Pattern.compile("(\\+\\d)?-(\\d{3})-(\\d{4})");
Matcher m3 = p3.matcher("-555-1234");
if (m3.find()) {
    System.out.println(m3.group(1)); // null — country code didn't match
    System.out.println(m3.group(2)); // 555
    System.out.println(m3.group(3)); // 1234
}
```

---

## 8. Named Groups

Named groups assign a name to a capture group, making patterns more readable and the code more maintainable.

### 8.1 Syntax: `(?<name>pattern)`

```java
Pattern p = Pattern.compile("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})");
Matcher m = p.matcher("Event on 2024-07-15");

if (m.find()) {
    System.out.println("Year:  " + m.group("year"));  // 2024
    System.out.println("Month: " + m.group("month")); // 07
    System.out.println("Day:   " + m.group("day"));   // 15

    // Named groups still have numeric indices
    System.out.println("Group 1: " + m.group(1)); // 2024
}
```

### 8.2 Named Groups vs Numbered Groups

Named groups are simply numbered groups with an alias — they still get a number and can be referenced both ways.

```java
Pattern p = Pattern.compile("(?<first>\\w+)\\s+(?<last>\\w+)");
Matcher m = p.matcher("John Smith");
if (m.find()) {
    System.out.println(m.group("first")); // John
    System.out.println(m.group(1));       // John — same group
    System.out.println(m.group("last"));  // Smith
    System.out.println(m.group(2));       // Smith — same group
}
```

### 8.3 Named Backreferences in Pattern: `\k<name>`

```java
// Use named backreference to detect repeated words
Pattern p = Pattern.compile("\\b(?<word>\\w+)\\s+\\k<word>\\b");
Matcher m = p.matcher("the the quick brown fox fox");
while (m.find()) {
    System.out.println("Repeated word: " + m.group("word"));
}
// Repeated word: the
// Repeated word: fox
```

### 8.4 Named Groups in Replacement: `${name}`

```java
Pattern p = Pattern.compile("(?<last>\\w+),\\s*(?<first>\\w+)");
String result = p.matcher("Doe, Jane").replaceAll("${first} ${last}");
System.out.println(result); // Jane Doe
```

### 8.5 Real-World Example — Parsing Log Entries

```java
String log = "2024-07-15 14:23:01 ERROR NullPointerException in UserService.java:42";

Pattern p = Pattern.compile(
    "(?<date>\\d{4}-\\d{2}-\\d{2})\\s+" +
    "(?<time>\\d{2}:\\d{2}:\\d{2})\\s+" +
    "(?<level>\\w+)\\s+" +
    "(?<message>.+)"
);

Matcher m = p.matcher(log);
if (m.matches()) {
    System.out.println("Date:    " + m.group("date"));    // 2024-07-15
    System.out.println("Time:    " + m.group("time"));    // 14:23:01
    System.out.println("Level:   " + m.group("level"));   // ERROR
    System.out.println("Message: " + m.group("message")); // NullPointerException...
}
```

---

## 9. Non-Capturing Groups

A non-capturing group `(?:...)` groups elements (to apply quantifiers or alternation) **without** saving the matched text. This is both a performance optimization and a way to keep group numbering clean.

### 9.1 Syntax: `(?:pattern)`

```java
// We want to repeat "ab" but don't need to capture it
Pattern capturing    = Pattern.compile("(ab)+");
Pattern nonCapturing = Pattern.compile("(?:ab)+");

Matcher m1 = capturing.matcher("ababab");
Matcher m2 = nonCapturing.matcher("ababab");

if (m1.matches()) {
    System.out.println("Capturing group 1:     " + m1.group(1)); // "ab" (last iteration)
    System.out.println("Capturing groupCount:  " + m1.groupCount()); // 1
}

if (m2.matches()) {
    System.out.println("Non-cap groupCount:    " + m2.groupCount()); // 0 — no groups
}
```

### 9.2 Avoiding Group Number Pollution

When you have many groups, non-capturing keeps numbering clean:

```java
// With capturing: phone group = 3 (after two (?:) groups)
Pattern p1 = Pattern.compile("(\\d{4})-(\\d{2})-(\\d{2})\\s+(\\d{3}-\\d{4})");
// date groups 1,2,3 and phone group 4

// If we only care about the phone number, use (?:) for date parts
Pattern p2 = Pattern.compile("(?:\\d{4})-(?:\\d{2})-(?:\\d{2})\\s+(\\d{3}-\\d{4})");
// phone is now group 1!
Matcher m = p2.matcher("2024-07-15 555-1234");
if (m.find()) {
    System.out.println("Phone: " + m.group(1)); // 555-1234
}
```

### 9.3 Non-Capturing Group with Alternation

Use `(?:a|b)` to group alternatives without creating a capture group:

```java
// Match "color" or "colour" (British/American spelling)
Pattern p = Pattern.compile("colo(?:u?)r");
// Or: Pattern.compile("colou?r"); // even simpler in this case

// More useful with longer alternatives:
Pattern p2 = Pattern.compile("(?:Monday|Tuesday|Wednesday|Thursday|Friday)");
Matcher m = p2.matcher("See you on Wednesday afternoon");
if (m.find()) System.out.println(m.group()); // Wednesday
```

### 9.4 Non-Capturing Group with Quantifier

```java
// Match IP address pattern
Pattern p = Pattern.compile("(?:\\d{1,3}\\.){3}\\d{1,3}");
Matcher m = p.matcher("Connect to 192.168.1.100 now");
if (m.find()) System.out.println(m.group()); // 192.168.1.100
```

---

## 10. Lookahead and Lookbehind

Lookaround assertions are **zero-width** — they check what is ahead or behind the current position **without consuming any characters**. This makes them extremely powerful for context-sensitive matching.

### 10.1 Positive Lookahead `(?=...)`

Asserts that what follows the current position **matches** the lookahead pattern.

**Syntax:** `X(?=Y)` — match X **only if** followed by Y.

```java
// Match digits only if followed by "px"
Pattern p = Pattern.compile("\\d+(?=px)");
Matcher m = p.matcher("12px and 14em and 8px");
while (m.find()) {
    System.out.println(m.group()); // 12, 8   (not 14, because it's followed by "em")
}
// NOTE: "px" is NOT included in the match
```

### 10.2 Negative Lookahead `(?!...)`

Asserts that what follows does **NOT** match.

**Syntax:** `X(?!Y)` — match X **only if NOT** followed by Y.

```java
// Match digits NOT followed by "px"
Pattern p = Pattern.compile("\\d+(?!px)");
Matcher m = p.matcher("12px and 14em and 8px");
while (m.find()) {
    System.out.println(m.group()); // 1, 14, 1, 1 — (watch out for partial matches!)
}
// To avoid partial matches, use word boundaries or be more specific
Pattern p2 = Pattern.compile("\\b\\d+\\b(?!px)");
Matcher m2 = p2.matcher("12px and 14em and 8px");
while (m2.find()) {
    System.out.println(m2.group()); // 14  (only 14 is not followed by px)
}
```

### 10.3 Positive Lookbehind `(?<=...)`

Asserts that what **precedes** the current position matches.

**Syntax:** `(?<=Y)X` — match X **only if preceded by** Y.

```java
// Match numbers preceded by "$"
Pattern p = Pattern.compile("(?<=\\$)\\d+\\.\\d{2}");
Matcher m = p.matcher("Price: $29.99 and €15.50 and $5.00");
while (m.find()) {
    System.out.println(m.group()); // 29.99, 5.00  (not 15.50 — preceded by €)
}
```

### 10.4 Negative Lookbehind `(?<!...)`

Asserts that what precedes does **NOT** match.

**Syntax:** `(?<!Y)X` — match X **only if NOT preceded by** Y.

```java
// Match numbers NOT preceded by "$"
Pattern p = Pattern.compile("(?<!\\$)\\b\\d+\\.\\d{2}\\b");
Matcher m = p.matcher("$29.99 and 15.50 and $5.00");
while (m.find()) {
    System.out.println(m.group()); // 15.50
}
```

### 10.5 Lookbehind Limitations in Java

Java requires lookbehind patterns to have a **finite, deterministic width** (or at least a bounded maximum length). Variable-length lookbehinds work up to Java 8 only for some cases; from Java 13+ improvements were made.

```java
// WORKS — fixed length lookbehind
Pattern p = Pattern.compile("(?<=\\$)\\d+");

// WORKS — alternation with same length
Pattern p2 = Pattern.compile("(?<=cat|dog)s");

// FAILS in older Java — variable length
// Pattern p3 = Pattern.compile("(?<=\\w+)\\d+"); // PatternSyntaxException
```

### 10.6 Combining Lookahead and Lookbehind

```java
// Extract content between quotes, without including the quotes
Pattern p = Pattern.compile("(?<=\")[^\"]+(?=\")");
Matcher m = p.matcher("She said \"hello\" and \"goodbye\"");
while (m.find()) {
    System.out.println(m.group()); // hello, goodbye
}
```

### 10.7 Practical Password Validation Example

```java
// Password must be 8-20 chars, have at least one digit, one uppercase, one lowercase
Pattern p = Pattern.compile(
    "^" +
    "(?=.*[A-Z])" +     // positive lookahead: at least one uppercase
    "(?=.*[a-z])" +     // positive lookahead: at least one lowercase
    "(?=.*\\d)" +       // positive lookahead: at least one digit
    "(?!.*\\s)" +       // negative lookahead: no whitespace
    ".{8,20}" +         // actual match: 8-20 any chars
    "$"
);

String[] passwords = {"password", "Password1", "P@ss1", "ValidPass1", "no digits"};
for (String pw : passwords) {
    System.out.printf("%-15s : %s%n", pw, p.matcher(pw).matches() ? "VALID" : "INVALID");
}
// password        : INVALID (no uppercase, no digit)
// Password1       : VALID
// P@ss1           : INVALID (too short)
// ValidPass1      : VALID
// no digits       : INVALID (has space, no digit)
```

### 10.8 Lookaround Summary Table

| Syntax | Name | Meaning |
|---|---|---|
| `(?=X)` | Positive lookahead | What follows matches X |
| `(?!X)` | Negative lookahead | What follows does NOT match X |
| `(?<=X)` | Positive lookbehind | What precedes matches X |
| `(?<!X)` | Negative lookbehind | What precedes does NOT match X |

---

## 11. String Regex Methods

`java.lang.String` provides convenience regex methods. These are simple wrappers that internally compile a new `Pattern` every time — **avoid in loops**.

### 11.1 `String.matches(String regex)`

Returns `true` if the **entire string** matches the regex (equivalent to `Pattern.matches()`).

```java
String email = "user@example.com";
boolean valid = email.matches("[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}");
System.out.println(valid); // true

// TRAP: matches() requires full match
"abc".matches("b"); // false — 'b' is not the entire string
"abc".matches(".*b.*"); // true — .* allows anything around 'b'
```

### 11.2 `String.split(String regex)`

Splits the string around matches of the given regex.

```java
// Split on whitespace
String[] words = "Hello   World   Java".split("\\s+");
// ["Hello", "World", "Java"]

// Split on comma-space
String[] parts = "one, two, three".split(",\\s*");
// ["one", "two", "three"]

// Split on period (must escape it!)
String[] segments = "192.168.1.1".split("\\.");
// ["192", "168", "1", "1"]
// BAD: "192.168.1.1".split(".")  → empty array! '.' matches everything.
```

### 11.3 `String.split(String regex, int limit)`

Same limit semantics as `Pattern.split()` with limit.

```java
"a:b:c:d".split(":", 2);  // ["a", "b:c:d"]
"a:b:c:d".split(":", -1); // ["a", "b", "c", "d"]
"a:b::".split(":");       // ["a", "b"]         — trailing empties dropped
"a:b::".split(":", -1);   // ["a", "b", "", ""] — trailing empties kept
```

### 11.4 `String.replaceAll(String regex, String replacement)`

Replaces **all** occurrences of the regex match with the replacement string.

```java
// Remove all digits
"abc123def456".replaceAll("\\d+", "");  // "abcdef"

// Replace multiple spaces with single space
"one  two   three".replaceAll("\\s+", " "); // "one two three"

// Use $1 to reference capture groups
"John Smith".replaceAll("(\\w+)\\s+(\\w+)", "$2, $1"); // "Smith, John"

// Escape literal $ or \ in replacement with \$ and \\
"price: 100".replaceAll("(\\d+)", "\\$$1"); // "price: $100"
```

### 11.5 `String.replaceFirst(String regex, String replacement)`

Replaces only the **first** occurrence.

```java
"aabbcc".replaceFirst("[a-z]+", "X"); // "Xbbcc"
"123 456 789".replaceFirst("\\d+", "NUM"); // "NUM 456 789"
```

### 11.6 Replacement String Escaping

In replacement strings, `$` and `\` have special meanings:

| In replacement | Meaning |
|---|---|
| `$0` | Entire match |
| `$1`, `$2`, … | Capture group N |
| `${name}` | Named capture group |
| `\$` | Literal `$` |
| `\\` | Literal `\` |

```java
// Use Matcher.quoteReplacement() for dynamic replacements that may contain $ or \
String dynamic = "some$thing\\here";
String safe = Matcher.quoteReplacement(dynamic);
"test".replaceAll("test", safe); // works correctly
```

### 11.7 `String` vs `Pattern`+`Matcher` — When to Use Which

| Use Case | Recommendation |
|---|---|
| One-off check in non-critical code | `String.matches()` is fine |
| Loop with many strings | Pre-compile `Pattern` |
| Need match positions | `Pattern` + `Matcher` |
| Need capture groups | `Pattern` + `Matcher` |
| Need all matches | `Pattern` + `Matcher` |
| Simple replacement, called once | `String.replaceAll()` is fine |
| Complex replacement or loop | Pre-compile `Pattern` |

---

## 12. `Pattern.compile()` Flags

Flags modify how the regex engine interprets patterns.

### 12.1 `Pattern.CASE_INSENSITIVE` (flag `i`)

Makes matching case-insensitive for ASCII characters.

```java
Pattern p = Pattern.compile("hello", Pattern.CASE_INSENSITIVE);
System.out.println(p.matcher("Hello").matches());  // true
System.out.println(p.matcher("HELLO").matches());  // true
System.out.println(p.matcher("HeLlO").matches());  // true

// Also works as inline flag: (?i)
Pattern p2 = Pattern.compile("(?i)hello");
```

For Unicode case-insensitive matching, combine with `UNICODE_CASE`:
```java
Pattern p = Pattern.compile("straße", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
```

### 12.2 `Pattern.MULTILINE` (flag `m`)

Makes `^` and `$` match at the start and end of **each line** rather than the entire input.

```java
String text = "line1\nline2\nline3";

// Without MULTILINE: only matches "line1"
Pattern p1 = Pattern.compile("^line\\d$");
System.out.println(p1.matcher(text).find()); // false — "line1" doesn't end at ^ match

// With MULTILINE: matches each line
Pattern p2 = Pattern.compile("^line\\d$", Pattern.MULTILINE);
Matcher m = p2.matcher(text);
while (m.find()) System.out.println(m.group()); // line1, line2, line3

// Inline flag: (?m)
Pattern p3 = Pattern.compile("(?m)^line\\d$");
```

### 12.3 `Pattern.DOTALL` (flag `s`)

Makes `.` match **any character including newlines** (by default `.` does not match `\n`).

```java
String html = "<div>\n  <p>Hello</p>\n</div>";

// Without DOTALL: . doesn't match \n — fails to span lines
Pattern p1 = Pattern.compile("<div>.*</div>");
System.out.println(p1.matcher(html).find()); // false

// With DOTALL: . matches everything including \n
Pattern p2 = Pattern.compile("<div>.*</div>", Pattern.DOTALL);
System.out.println(p2.matcher(html).find()); // true

// Inline flag: (?s)
Pattern p3 = Pattern.compile("(?s)<div>.*</div>");
```

### 12.4 `Pattern.COMMENTS` (flag `x`)

Enables **verbose mode**. Whitespace in the pattern is ignored (must escape it with `\ ` or put in `[]`). Comments with `#` are allowed to end of line.

```java
Pattern p = Pattern.compile(
    """
    (?x)          # Enable comments mode
    \\d{4}        # Year
    -             # Literal hyphen
    \\d{2}        # Month
    -             # Literal hyphen
    \\d{2}        # Day
    """);

System.out.println(p.matcher("2024-07-15").matches()); // true
```

Inline flag:
```java
Pattern p = Pattern.compile(
    "(?x)" +
    "\\d{4}" +   // year
    "-\\d{2}" +  // month
    "-\\d{2}"    // day
);
```

### 12.5 `Pattern.UNICODE_CASE`

When combined with `CASE_INSENSITIVE`, extends case-insensitive matching to Unicode characters.

```java
Pattern p = Pattern.compile("ä", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
System.out.println(p.matcher("Ä").matches()); // true
```

### 12.6 `Pattern.UNICODE_CHARACTER_CLASS`

Makes predefined character classes (`\d`, `\w`, `\s`) and POSIX classes (`\p{Alpha}`, etc.) conform to Unicode.

```java
// Without: \w = [a-zA-Z_0-9] only (ASCII)
// With: \w includes Unicode letters and digits
Pattern p = Pattern.compile("\\w+", Pattern.UNICODE_CHARACTER_CLASS);
```

### 12.7 `Pattern.LITERAL`

Treats the entire pattern as a literal string (all metacharacters lose their special meaning). Equivalent to wrapping in `\Q...\E`.

```java
Pattern p = Pattern.compile("1+1=2", Pattern.LITERAL);
System.out.println(p.matcher("1+1=2").matches()); // true — treats + as literal
System.out.println(p.matcher("111=2").matches()); // false — + is not a quantifier here

// Equivalent:
Pattern p2 = Pattern.compile("\\Q1+1=2\\E");
```

### 12.8 `Pattern.CANON_EQ`

Enables canonical equivalence. Two characters match if their full canonical decomposition matches. Useful for Unicode normalization.

```java
// 'é' can be represented as U+00E9 or as e + U+0301 (combining accent)
Pattern p = Pattern.compile("\u00E9", Pattern.CANON_EQ);
```

### 12.9 Combining Flags

Flags are OR'd together with `|`:

```java
Pattern p = Pattern.compile(
    "^hello.*world$",
    Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL
);
```

### 12.10 Inline Flags

Flags can be embedded in the pattern with `(?flags)` or applied to part of the pattern with `(?flags:pattern)`:

| Inline | Flag | Meaning |
|---|---|---|
| `(?i)` | `CASE_INSENSITIVE` | Case-insensitive |
| `(?m)` | `MULTILINE` | `^`/`$` per line |
| `(?s)` | `DOTALL` | `.` matches newline |
| `(?x)` | `COMMENTS` | Verbose, whitespace ignored |
| `(?u)` | `UNICODE_CASE` | Unicode-aware case |
| `(?d)` | `UNIX_LINES` | Only `\n` as line terminator |

Turn off a flag with `(?-i)`. Enable and disable: `(?is-m)`.

```java
// Case-insensitive for "hello" only, then back to case-sensitive
Pattern p = Pattern.compile("(?i)hello(?-i) WORLD");
System.out.println(p.matcher("HELLO WORLD").matches()); // true
System.out.println(p.matcher("HELLO world").matches()); // false — 'world' must be uppercase
```

---

## 13. Pre-Compiling Patterns — Performance Best Practice

### 13.1 The Problem with `String.matches()` in Loops

Every call to `String.matches()`, `String.split()`, `String.replaceAll()`, or `String.replaceFirst()` internally calls `Pattern.compile()` — which parses and compiles the regex **every single time**.

```java
// SLOW — recompiles the pattern on every iteration
List<String> emails = getMillionEmails();
for (String email : emails) {
    if (email.matches("[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}")) {
        process(email);
    }
}
// Pattern.compile() is called 1,000,000 times!
```

### 13.2 The Solution — `private static final Pattern`

Compile the pattern **once** as a static final field:

```java
public class EmailValidator {

    // ✅ CORRECT: compiled once, reused forever
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}"
    );

    public static boolean isValidEmail(String email) {
        return EMAIL_PATTERN.matcher(email).matches();
    }
}
```

### 13.3 Thread Safety

`Pattern` is **immutable and thread-safe** — the same instance can be shared across threads. `Matcher` is **NOT thread-safe** — always create a new `Matcher` per thread (which `pattern.matcher(input)` does naturally).

```java
public class LogParser {
    // Safe to share — Pattern is immutable
    private static final Pattern LOG_PATTERN = Pattern.compile(
        "(?<timestamp>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2})" +
        "\\s+(?<level>\\w+)\\s+(?<message>.+)"
    );

    // Each call creates its own Matcher — thread-safe
    public LogEntry parse(String line) {
        Matcher m = LOG_PATTERN.matcher(line); // new Matcher every time — OK
        if (m.matches()) {
            return new LogEntry(m.group("timestamp"), m.group("level"), m.group("message"));
        }
        return null;
    }
}
```

### 13.4 Benchmark — String.matches() vs Pre-compiled Pattern

```java
import java.util.regex.*;

public class RegexBenchmark {
    private static final Pattern COMPILED = Pattern.compile("\\d{5}(-\\d{4})?");

    public static void main(String[] args) {
        String[] inputs = new String[100_000];
        for (int i = 0; i < inputs.length; i++) {
            inputs[i] = String.valueOf(10000 + i);
        }

        // Warm up JIT
        for (String s : inputs) s.matches("\\d{5}(-\\d{4})?");

        // Benchmark String.matches()
        long start = System.nanoTime();
        for (String s : inputs) s.matches("\\d{5}(-\\d{4})?");
        long stringTime = System.nanoTime() - start;

        // Benchmark pre-compiled
        start = System.nanoTime();
        for (String s : inputs) COMPILED.matcher(s).matches();
        long compiledTime = System.nanoTime() - start;

        System.out.printf("String.matches():  %d ms%n", stringTime / 1_000_000);
        System.out.printf("Pre-compiled:      %d ms%n", compiledTime / 1_000_000);
        System.out.printf("Speedup:           %.1fx%n", (double) stringTime / compiledTime);
        // Typical result: Pre-compiled is 3-10x faster
    }
}
```

### 13.5 Common Patterns to Pre-Compile

```java
public final class Patterns {
    private Patterns() {}

    public static final Pattern EMAIL =
        Pattern.compile("[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}");

    public static final Pattern URL =
        Pattern.compile("https?://[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\._~:/?#\\[\\]@!\\$&'\\(\\)\\*\\+,;=.]+)?");

    public static final Pattern IPV4 =
        Pattern.compile("\\b(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\b");

    public static final Pattern ZIP_CODE =
        Pattern.compile("\\d{5}(-\\d{4})?");

    public static final Pattern ISO_DATE =
        Pattern.compile("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})");

    public static final Pattern WHITESPACE =
        Pattern.compile("\\s+");

    public static final Pattern NON_WORD =
        Pattern.compile("\\W+");
}
```

---

## 14. Catastrophic Backtracking & ReDoS

**ReDoS (Regular Expression Denial of Service)** is a vulnerability class where a carefully crafted input causes the regex engine to take exponential time, effectively hanging the application.

### 14.1 How Backtracking Works (Recap)

Java's NFA engine tries all possible paths to find a match. When a path fails, it **backtracks** and tries the next alternative. In most well-written patterns, this is fast. But certain patterns cause an **exponential explosion** of paths.

### 14.2 The Classic ReDoS Pattern — Nested Quantifiers

The canonical catastrophic pattern is: `(a+)+`

This matches one or more groups of one or more `a`s. The ambiguity: the string `aaaa` can be divided as:
- `(aaaa)` — one group of 4
- `(aaa)(a)` — two groups
- `(aa)(aa)` — two groups
- `(aa)(a)(a)` — three groups
- `(a)(aaa)` — two groups
- … many more combinations

When the overall match fails (e.g., input is `aaaab`), the engine must try **all** combinations before giving up.

```java
// CATASTROPHIC — never do this
Pattern catastrophic = Pattern.compile("(a+)+b");

// Test with increasing non-matching input:
// "aaab"       — fast
// "aaaab"      — slightly slower
// "aaaaab"     — noticeably slower
// "aaaaaaaaaaaaaaaaaab" — hangs for seconds/minutes

long start = System.currentTimeMillis();
boolean result = "aaaaaaaaaaaaaaaaaab".matches("(a+)+b"); // HANGS
System.out.println("Time: " + (System.currentTimeMillis() - start) + "ms");
// Could be 60000ms+ or OutOfMemoryError
```

### 14.3 Why It's Exponential

For a string of N `a`s followed by a non-matching char, the number of ways to partition N `a`s into groups is `2^(N-1)`. Each partition is tried. So:
- N=10: 512 paths
- N=20: 524,288 paths
- N=30: 536,870,912 paths

### 14.4 More ReDoS Examples

```java
// Ambiguous alternation
Pattern bad1 = Pattern.compile("(a|aa)+b");
// Input "aaaaaaaaaaaaaaaaac" — exponential

// Overlapping alternatives
Pattern bad2 = Pattern.compile("(\\d+)+\\.");
// Input "1234567890!" — exponential

// Common real-world vulnerable pattern (email validation gone wrong)
Pattern bad3 = Pattern.compile("([a-zA-Z0-9]*)([a-zA-Z0-9]+\\.)+[a-zA-Z]{2,}");
// Crafted input can trigger explosion
```

### 14.5 How to Detect Potential ReDoS

Look for these patterns:
1. **Nested quantifiers**: `(a+)+`, `(a*)*`, `(a+)*`
2. **Ambiguous alternation under a quantifier**: `(a|a)+`, `(a|ab)+`
3. **Multiple optional groups that can match the same characters**

### 14.6 Prevention Strategies

#### Strategy 1: Use Possessive Quantifiers

Possessive quantifiers never backtrack, eliminating the explosion:

```java
// Vulnerable
Pattern bad = Pattern.compile("(a+)+b");

// Safe — possessive inner quantifier
Pattern safe = Pattern.compile("(a++)++b");
// Or use atomic group: (?>a+)
```

#### Strategy 2: Use Atomic Groups `(?>...)`

An atomic group is like a non-capturing group that, once matched, never gives back characters. Java supports atomic groups.

```java
Pattern safe = Pattern.compile("(?>a+)+b");
// The (?>a+) matches greedily and atomically — no backtracking inside the group
```

#### Strategy 3: Rewrite the Pattern

Eliminate ambiguity:

```java
// Instead of (a+)+ just use a+
Pattern safe = Pattern.compile("a+b"); // equivalent, no ambiguity

// Instead of (\d+)+\. use \d+\.
Pattern safe2 = Pattern.compile("\\d+\\.");
```

#### Strategy 4: Input Validation Before Regex

Limit input length to prevent abuse:

```java
public boolean validate(String input) {
    if (input == null || input.length() > 1000) {
        return false; // Don't even try regex on huge input
    }
    return PATTERN.matcher(input).matches();
}
```

#### Strategy 5: Use a Timeout (Java 8+)

Wrap regex in a thread with a timeout. Java's built-in regex has no native timeout, so you need:

```java
import java.util.concurrent.*;

public class SafeRegex {
    private static final ExecutorService executor = Executors.newCachedThreadPool();

    public static boolean matchesWithTimeout(Pattern pattern, String input,
                                              long timeoutMs) throws TimeoutException {
        Future<Boolean> future = executor.submit(() -> pattern.matcher(input).matches());
        try {
            return future.get(timeoutMs, TimeUnit.MILLISECONDS);
        } catch (TimeoutException e) {
            future.cancel(true);
            throw e;
        } catch (ExecutionException | InterruptedException e) {
            return false;
        }
    }

    public static void main(String[] args) {
        Pattern p = Pattern.compile("(a+)+b");
        String input = "aaaaaaaaaaaaaaaaaaa";
        try {
            boolean result = matchesWithTimeout(p, input, 100); // 100ms timeout
        } catch (TimeoutException e) {
            System.out.println("Regex timed out! Possible ReDoS attempt.");
        }
    }
}
```

### 14.7 Real-World ReDoS Incidents

- **2016 Stack Overflow outage**: A poorly written regex caused ~34 minutes of downtime.
- **2019 Cloudflare outage**: A ReDoS bug in their WAF took down 27 minutes of traffic.
- The pattern that caused Cloudflare's outage:
  ```
  (?:(?:\"|'|\]|\}|\\|\d|(?:nan|infinity|true|false|null|undefined|symbol|math)|\`|\-|\+)+[)]*;?((?:\s|-|~|!|{}|\|\||\+)*.*(?:.*=.*)))
  ```

### 14.8 Catastrophic vs Safe Pattern Comparison

```java
// All of these are potentially CATASTROPHIC for non-matching input:
"(a+)+"          // nested quantifier
"(a*)*"          // nested quantifier with zero-match
"(a|b|ab)+"      // ambiguous alternation under quantifier
"([a-z]+\\s*)+"  // overlapping match possibilities

// Safe equivalents:
"a+"             // no nesting
"a*"             // simple
"[ab]+"          // character class instead of alternation
"[a-z\\s]+"      // combined class
```

---

## 15. Performance: `Pattern` + `Matcher` vs `String.matches()`

### 15.1 Internal Anatomy of `String.matches()`

```java
// What String.matches() actually does internally:
public boolean matches(String regex) {
    return Pattern.matches(regex, this);
}

// And Pattern.matches() does:
public static boolean matches(String regex, CharSequence input) {
    Pattern p = Pattern.compile(regex);  // ← EXPENSIVE: compiles every time
    Matcher m = p.matcher(input);
    return m.matches();
}
```

### 15.2 Cost of `Pattern.compile()`

`Pattern.compile()` must:
1. Parse the regex string character by character
2. Build an internal state machine (NFA)
3. Allocate multiple data structures

This is orders of magnitude more expensive than the actual matching phase for simple patterns.

### 15.3 When `String.matches()` Is Acceptable

- Called once per application run
- Called in non-critical path code
- Simple validation on small input

### 15.4 When to Always Pre-Compile

- Inside any loop (even small ones)
- In request-handling code in a server (each request calls it)
- Any hot path
- When processing files line-by-line

### 15.5 Matcher Reuse with `reset()`

You can reuse a `Matcher` instance with different inputs to avoid even the small cost of creating a new `Matcher`:

```java
// Option A: New Matcher each time (fine for most purposes)
Pattern p = COMPILED_PATTERN;
for (String line : lines) {
    Matcher m = p.matcher(line);  // cheap — much cheaper than compiling
    if (m.find()) { /* ... */ }
}

// Option B: Reuse Matcher with reset() (micro-optimization for ultra-hot paths)
Pattern p = COMPILED_PATTERN;
Matcher m = p.matcher("");        // dummy initial input
for (String line : lines) {
    m.reset(line);                // reuse matcher, change input
    if (m.find()) { /* ... */ }
}
```

### 15.6 Performance Comparison Table

| Method | Pattern Compile | Matcher Create | When to Use |
|---|---|---|---|
| `String.matches(regex)` | Every call | Every call | Once, non-critical |
| `Pattern.compile(regex).matcher(s).matches()` | Every call | Every call | Never — worst of both |
| `STATIC_PATTERN.matcher(s).matches()` | Once | Every call | ✅ Standard best practice |
| Reuse `Matcher` with `reset()` | Once | Once | Ultra-hot paths |

### 15.7 Full Performance Test

```java
import java.util.regex.*;

public class PerfTest {

    private static final int N = 500_000;
    private static final String REGEX = "\\d{3}-\\d{3}-\\d{4}";
    private static final Pattern PATTERN = Pattern.compile(REGEX);
    private static final String INPUT = "555-123-4567";

    public static void main(String[] args) {
        // Warm up
        for (int i = 0; i < 10_000; i++) {
            INPUT.matches(REGEX);
            PATTERN.matcher(INPUT).matches();
        }

        long t1 = time(() -> {
            for (int i = 0; i < N; i++) INPUT.matches(REGEX);
        });

        long t2 = time(() -> {
            for (int i = 0; i < N; i++) PATTERN.matcher(INPUT).matches();
        });

        Matcher m = PATTERN.matcher(INPUT);
        long t3 = time(() -> {
            for (int i = 0; i < N; i++) { m.reset(INPUT); m.matches(); }
        });

        System.out.printf("String.matches():    %5d ms%n", t1);
        System.out.printf("PATTERN.matcher():   %5d ms%n", t2);
        System.out.printf("Matcher.reset():     %5d ms%n", t3);
    }

    static long time(Runnable r) {
        long s = System.currentTimeMillis();
        r.run();
        return System.currentTimeMillis() - s;
    }
}
// Typical results (JVM warmed up):
// String.matches():    ~1200 ms
// PATTERN.matcher():   ~120  ms  ← 10x faster
// Matcher.reset():     ~90   ms  ← slightly faster still
```

---

## 16. Additional Topics Not in the Module Outline

### 16.1 Alternation `a|b`

The `|` operator matches either the left or the right alternative. It has the **lowest precedence** of all regex operators.

```java
Pattern p = Pattern.compile("cat|dog|fish");
Matcher m = p.matcher("I have a dog and a fish");
while (m.find()) System.out.println(m.group()); // dog, fish
```

**Pitfall: Alternation order matters.** The engine tries alternatives left to right and stops at the first one that succeeds.

```java
// PROBLEM: "cat" matches before "catfish" gets a chance
Pattern bad = Pattern.compile("cat|catfish");
Matcher m = bad.matcher("catfish");
m.find();
System.out.println(m.group()); // "cat" — not "catfish"!

// FIX: Put longer alternative first
Pattern good = Pattern.compile("catfish|cat");
m = good.matcher("catfish");
m.find();
System.out.println(m.group()); // "catfish"
```

### 16.2 Escape Sequences

| Escape | Meaning |
|---|---|
| `\.` | Literal dot |
| `\*` | Literal asterisk |
| `\+` | Literal plus |
| `\?` | Literal question mark |
| `\(` `\)` | Literal parentheses |
| `\[` `\]` | Literal brackets |
| `\{` `\}` | Literal braces |
| `\\` | Literal backslash |
| `\^` | Literal caret |
| `\$` | Literal dollar |
| `\|` | Literal pipe |
| `\n` | Newline |
| `\t` | Tab |
| `\r` | Carriage return |
| `\f` | Form feed |
| `\0` | Null character |
| `\uHHHH` | Unicode character |
| `\xHH` | Hex character |

### 16.3 `\Q...\E` — Literal Quoting

Everything between `\Q` and `\E` is treated as a literal string:

```java
Pattern p = Pattern.compile("\\Q$100.00\\E"); // matches literal "$100.00"
System.out.println(p.matcher("Price: $100.00").find()); // true

// Equivalent to Pattern.LITERAL flag but allows mixing with metacharacters:
Pattern p2 = Pattern.compile("\\Q(a+b)\\E\\s*=\\s*\\d+"); // literal "(a+b)" then =digit
```

### 16.4 Atomic Groups `(?>...)`

Atomic groups prevent the regex engine from backtracking into the group once it has matched. Semantically equivalent to possessive quantifiers but more flexible:

```java
// (?>a+) is atomic: once it matches "aaa", it won't give any back
Pattern p = Pattern.compile("(?>a+)b");
System.out.println(p.matcher("aaab").matches());  // true  — a+ matches "aaa", then b matches
System.out.println(p.matcher("aaac").matches());  // false — a+ matches "aaa", b fails, atomic: no backtrack
```

### 16.5 Conditional Patterns `(?(condition)yes|no)`

Java does NOT support conditional patterns. This is a Perl/PCRE feature. Attempting it throws `PatternSyntaxException`.

### 16.6 Possessive vs Atomic Group Equivalence

```java
// These are equivalent:
Pattern p1 = Pattern.compile("a++");
Pattern p2 = Pattern.compile("(?>a+)");
```

### 16.7 `\G` — End of Previous Match Anchor

`\G` matches where the last match ended. Useful with `find()` to force matches to be contiguous:

```java
Pattern p = Pattern.compile("\\G\\d+,?");
Matcher m = p.matcher("123,456,789 abc");
while (m.find()) System.out.print(m.group() + " "); // 123, 456, 789   — stops at space
// \G ensures each match starts exactly where the last one ended
```

### 16.8 Horizontal & Vertical Whitespace

```java
\h    // Horizontal whitespace: [ \t\xA0\u1680\u180e\u2000-\u200a\u202f\u205f\u3000]
\H    // Non-horizontal whitespace
\v    // Vertical whitespace: [\n\x0B\f\r\x85\u2028\u2029]
\V    // Non-vertical whitespace
```

### 16.9 `Matcher.results()` — Java 9+ Stream API

Java 9 added `Matcher.results()` which returns a `Stream<MatchResult>`:

```java
// Java 9+
Pattern p = Pattern.compile("\\d+");
List<String> numbers = p.matcher("I have 3 cats and 7 dogs and 12 fish")
    .results()
    .map(MatchResult::group)
    .collect(Collectors.toList());
System.out.println(numbers); // [3, 7, 12]
```

### 16.10 `Pattern.asMatchPredicate()` and `Pattern.asPredicate()` — Java 8+

```java
// asPredicate: returns true if ANY part of the string matches
Predicate<String> containsDigit = Pattern.compile("\\d").asPredicate();
// asMatchPredicate: returns true only if the ENTIRE string matches
Predicate<String> allDigits = Pattern.compile("\\d+").asMatchPredicate();

List<String> inputs = List.of("abc", "abc123", "12345");
inputs.stream().filter(containsDigit).forEach(System.out::println); // abc123, 12345
inputs.stream().filter(allDigits).forEach(System.out::println);     // 12345
```

### 16.11 `Pattern.splitAsStream()` — Java 8+

Returns a lazy `Stream<String>` instead of an array:

```java
Pattern.compile("\\s+")
    .splitAsStream("one  two   three")
    .map(String::toUpperCase)
    .forEach(System.out::println); // ONE, TWO, THREE
```

### 16.12 Common Regex Patterns Reference

```java
// Email (simplified)
"[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}"

// URL
"https?://[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\._~:/?#\\[\\]@!\\$&'\\(\\)\\*\\+,;=]*)"

// IPv4
"\\b(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\b"

// ISO 8601 Date
"\\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\\d|3[01])"

// Time HH:MM:SS
"(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d"

// US Phone
"(?:\\+1\\s?)?(?:\\(\\d{3}\\)|\\d{3})[\\s\\-]?\\d{3}[\\s\\-]?\\d{4}"

// ZIP Code US
"\\d{5}(?:-\\d{4})?"

// Credit Card (basic)
"\\b(?:\\d{4}[\\s\\-]?){3}\\d{4}\\b"

// HTML Tag
"</?([a-zA-Z][a-zA-Z0-9]*)(?:\\s[^>]*)?/?>"

// UUID
"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"

// Hex Color
"#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\\b"

// Java Identifier
"[a-zA-Z_$][a-zA-Z0-9_$]*"

// Non-empty String (no whitespace-only)
"\\S+(\\s+\\S+)*"
```

### 16.13 Debugging Regex

```java
// Enable debug output (prints internal NFA state)
System.setProperty("java.util.regex.Matcher.debug", "true"); // Not standard, depends on JVM

// Better approach: test incrementally
Pattern p = Pattern.compile("(\\d{4})-(\\d{2})-(\\d{2})");
String test = "2024-07-15";
Matcher m = p.matcher(test);
System.out.println("Pattern:     " + p.pattern());
System.out.println("Input:       " + test);
System.out.println("Matches:     " + m.matches());
if (m.matches()) {
    for (int i = 0; i <= m.groupCount(); i++) {
        System.out.printf("Group %d:     '%s' [%d,%d)%n",
            i, m.group(i), m.start(i), m.end(i));
    }
}
```

### 16.14 `PatternSyntaxException`

Thrown when `Pattern.compile()` encounters an illegal regex:

```java
try {
    Pattern p = Pattern.compile("[invalid");
} catch (PatternSyntaxException e) {
    System.out.println("Error at index: " + e.getIndex());     // position in pattern
    System.out.println("Description:   " + e.getDescription()); // error description
    System.out.println("Pattern:       " + e.getPattern());     // the regex that failed
    // e.getMessage() gives all three in a formatted string
}
```

### 16.15 Zero-Length Matches and Edge Cases

Patterns like `.*` or `a*` can produce zero-length matches:

```java
Pattern p = Pattern.compile("a*");
Matcher m = p.matcher("aabca");
while (m.find()) {
    System.out.printf("[%d,%d) = '%s'%n", m.start(), m.end(), m.group());
}
// [0,2) = 'aa'
// [2,2) = ''    ← zero-length match between 'b' and 'c'? Actually at index 2 (the 'b' position)
// [2,3) = ''    Actually let me clarify: a* at each non-a position matches empty string
// Java advances by 1 when a zero-length match is found to avoid infinite loops
```

---

## 17. Quick Reference Cheat Sheet

### Character Classes

| Pattern | Matches |
|---|---|
| `[abc]` | `a`, `b`, or `c` |
| `[^abc]` | Any char except `a`, `b`, `c` |
| `[a-z]` | Any lowercase letter |
| `[a-zA-Z]` | Any letter |
| `[a-z&&[^aeiou]]` | Lowercase consonants |
| `\d` | Digit `[0-9]` |
| `\D` | Non-digit |
| `\w` | Word char `[a-zA-Z0-9_]` |
| `\W` | Non-word char |
| `\s` | Whitespace |
| `\S` | Non-whitespace |
| `.` | Any char (except `\n` by default) |

### Quantifiers

| Pattern | Greedy | Reluctant | Possessive |
|---|---|---|---|
| Zero or more | `*` | `*?` | `*+` |
| One or more | `+` | `+?` | `++` |
| Zero or one | `?` | `??` | `?+` |
| Exactly n | `{n}` | `{n}?` | `{n}+` |
| n or more | `{n,}` | `{n,}?` | `{n,}+` |
| n to m | `{n,m}` | `{n,m}?` | `{n,m}+` |

### Anchors

| Pattern | Meaning |
|---|---|
| `^` | Start of input (or line with MULTILINE) |
| `$` | End of input (or line with MULTILINE) |
| `\b` | Word boundary |
| `\B` | Non-word boundary |
| `\A` | Absolute start of input |
| `\Z` | End of input (allows trailing `\n`) |
| `\z` | Absolute end of input |
| `\G` | End of previous match |

### Groups

| Syntax | Type |
|---|---|
| `(abc)` | Capturing group |
| `(?:abc)` | Non-capturing group |
| `(?<name>abc)` | Named capturing group |
| `(?>abc)` | Atomic group |
| `\1`, `\2` | Backreference (in pattern) |
| `\k<name>` | Named backreference (in pattern) |
| `$1`, `$2` | Backreference (in replacement) |
| `${name}` | Named backreference (in replacement) |

### Lookaround

| Syntax | Type |
|---|---|
| `(?=X)` | Positive lookahead |
| `(?!X)` | Negative lookahead |
| `(?<=X)` | Positive lookbehind |
| `(?<!X)` | Negative lookbehind |

### Flags

| Constant | Inline | Effect |
|---|---|---|
| `CASE_INSENSITIVE` | `(?i)` | Case-insensitive |
| `MULTILINE` | `(?m)` | `^`/`$` per line |
| `DOTALL` | `(?s)` | `.` matches `\n` |
| `COMMENTS` | `(?x)` | Whitespace/comments in pattern |
| `UNICODE_CASE` | `(?u)` | Unicode-aware case |
| `LITERAL` | — | Entire pattern is literal |

### Key Rules to Remember

1. **Always pre-compile:** `private static final Pattern P = Pattern.compile(...);`
2. **Escape dots and special chars:** `\\.` not `.` for a literal period.
3. **Double-escape in Java strings:** `\\d` in Java string = `\d` in regex.
4. **`matches()` = full match; `find()` = partial match.**
5. **`group(0)` = entire match; `group(1)` = first capture group.**
6. **Greedy by default; append `?` for lazy, `+` for possessive.**
7. **`Pattern` is thread-safe; `Matcher` is NOT.**
8. **Never use nested quantifiers on overlapping classes** (risk of ReDoS).
9. **Use `Pattern.quote()` for user-supplied literal patterns.**
10. **Java lookbehind requires fixed/bounded width.**

---

*End of Java Regular Expressions Study Guide — Module 12*
