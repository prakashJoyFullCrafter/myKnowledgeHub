# Bit Manipulation - Curriculum

## Module 1: Bitwise Operators
- [ ] AND (`&`): both bits 1 → 1
- [ ] OR (`|`): either bit 1 → 1
- [ ] XOR (`^`): bits differ → 1, same → 0
- [ ] NOT (`~`): flip all bits
- [ ] Left shift (`<<`): multiply by 2
- [ ] Right shift (`>>`): divide by 2 (arithmetic, preserves sign)
- [ ] Unsigned right shift (`>>>`): logical shift, fills with 0 (Java-specific)

## Module 2: Common Tricks
- [ ] **Check if even/odd**: `n & 1` — 0 = even, 1 = odd (faster than `n % 2`)
- [ ] **Check if power of 2**: `n > 0 && (n & (n - 1)) == 0`
- [ ] **Get ith bit**: `(n >> i) & 1`
- [ ] **Set ith bit**: `n | (1 << i)`
- [ ] **Clear ith bit**: `n & ~(1 << i)`
- [ ] **Toggle ith bit**: `n ^ (1 << i)`
- [ ] **Count set bits (popcount)**: `Integer.bitCount(n)` or Brian Kernighan's algorithm
- [ ] **Swap without temp**: `a ^= b; b ^= a; a ^= b;`
- [ ] **XOR properties**: `a ^ a = 0`, `a ^ 0 = a`, commutative, associative

## Module 3: Classic Problems
- [ ] **Single Number**: all appear twice except one → XOR all elements
- [ ] **Single Number II**: all appear three times except one → count bits mod 3
- [ ] **Single Number III**: two unique numbers → XOR all, split by differentiating bit
- [ ] **Missing Number**: XOR 0..n with array elements → missing number remains
- [ ] **Reverse Bits**: bit-by-bit reversal
- [ ] **Number of 1 Bits** (Hamming Weight): `n & (n - 1)` removes lowest set bit
- [ ] **Hamming Distance**: XOR two numbers, count set bits
- [ ] **Power of Two / Four**: bit pattern checks

## Module 4: Bitmask DP & Advanced
- [ ] **Bitmask as set representation**: each bit = include/exclude element
- [ ] **Subsets via bitmask**: iterate 0 to `2^n - 1`, check each bit
- [ ] **Traveling Salesman Problem (TSP)**: `dp[mask][i]` = min cost to visit cities in mask, ending at i
- [ ] **Bitmask DP template**: `for mask in 0..2^n`, `for bit in mask`
- [ ] **Bitmask + intersection/union**: `mask1 & mask2` (intersection), `mask1 | mask2` (union)
- [ ] **Enumerate submasks**: `for s = mask; s > 0; s = (s - 1) & mask`
- [ ] When to use bitmask DP: small N (≤ 20), combinatorial state tracking

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement all tricks, verify with binary representation output |
| Module 3 | Single Number I/II/III, Missing Number, Reverse Bits, Hamming Distance |
| Module 4 | Subsets via bitmask, TSP with bitmask DP |

## Key Resources
- LeetCode Bit Manipulation tag
- "Bit Twiddling Hacks" — Stanford Graphics
- CP-Algorithms — Bit manipulation
