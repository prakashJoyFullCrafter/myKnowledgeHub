# Number Theory & Math - Curriculum

Mathematical foundations for algorithms: GCD, primes, modular arithmetic, and combinatorics.

---

## Module 1: Divisibility & GCD
- [ ] **Divisibility**: a | b means b is divisible by a
- [ ] **GCD (greatest common divisor)**: largest integer dividing both
- [ ] **LCM (least common multiple)**: `lcm(a, b) = a * b / gcd(a, b)`
- [ ] **Euclidean algorithm**: `gcd(a, b) = gcd(b, a mod b)`, base case `gcd(a, 0) = a`
- [ ] **Binary GCD (Stein's)**: uses shifts instead of division, potentially faster
- [ ] **Time**: O(log min(a, b))
- [ ] **Java**: `BigInteger.gcd()`
- [ ] **Applications**: simplifying fractions, lattice problems, modular inverse

## Module 2: Extended Euclidean Algorithm
- [ ] **Bezout's identity**: for any a, b, there exist x, y with `a*x + b*y = gcd(a, b)`
- [ ] **Extended Euclidean**: computes (gcd, x, y)
  ```
  if b == 0: return (a, 1, 0)
  (g, x', y') = extgcd(b, a mod b)
  return (g, y', x' - (a / b) * y')
  ```
- [ ] **Applications**:
  - [ ] Solve linear Diophantine equations `ax + by = c`
  - [ ] Compute modular inverse
  - [ ] CRT (Chinese Remainder Theorem)
- [ ] **Solution exists iff gcd(a, b) divides c**

## Module 3: Primes & Sieves
- [ ] **Prime**: integer > 1 with only 1 and itself as divisors
- [ ] **Primality test**:
  - [ ] Trial division: O(√n)
  - [ ] Miller-Rabin: probabilistic, fast
  - [ ] AKS: polynomial, theoretically interesting
- [ ] **Sieve of Eratosthenes**:
  - [ ] Find all primes up to n in O(n log log n)
  - [ ] Mark multiples of each prime starting from p²
- [ ] **Linear sieve**: O(n), also gives smallest prime factor
- [ ] **Segmented sieve**: primes in range [L, R] with limited memory
- [ ] **Applications**: factorization, number theory competitions

## Module 4: Prime Factorization
- [ ] **Trial division**: O(√n)
- [ ] **With precomputed smallest prime factor**: O(log n) per number
- [ ] **Pollard's rho**: O(n^(1/4)) for factoring large numbers
- [ ] **Fundamental theorem**: unique factorization into primes
- [ ] **Number of divisors**: product of (exponent + 1) over all prime factors
- [ ] **Sum of divisors**: multiplicative function of prime factors
- [ ] **Euler's totient φ(n)**: count of integers ≤ n coprime to n
  - [ ] `φ(p^k) = p^k - p^(k-1)`
  - [ ] Multiplicative

## Module 5: Modular Arithmetic
- [ ] **Modulo**: `a mod n` = remainder when a divided by n
- [ ] **Congruence**: `a ≡ b (mod n)` means n | (a - b)
- [ ] **Properties**:
  - [ ] Addition: `(a + b) mod n = ((a mod n) + (b mod n)) mod n`
  - [ ] Multiplication: same
  - [ ] Subtraction: add n to avoid negative
- [ ] **Watch for overflow**: use long, or BigInteger for huge values
- [ ] **Modular exponentiation**: `a^b mod n` in O(log b)
  - [ ] Fast power algorithm (binary exponentiation)
- [ ] **Large powers**: essential for cryptography, hashing

## Module 6: Modular Inverse
- [ ] **Problem**: find x such that `a * x ≡ 1 (mod n)`
- [ ] **Exists iff** gcd(a, n) = 1
- [ ] **Methods**:
  - [ ] **Extended Euclidean**: O(log n)
  - [ ] **Fermat's little theorem** (prime n): `a^(n-2) mod n`
  - [ ] **Euler's theorem** (general): `a^(φ(n) - 1) mod n`
- [ ] **Use case**: division in modular arithmetic
- [ ] **Example**: `(a / b) mod p = (a * inverse(b, p)) mod p`

## Module 7: Chinese Remainder Theorem (CRT)
- [ ] **Problem**: find x satisfying system of congruences
  - [ ] `x ≡ a₁ (mod n₁)`, `x ≡ a₂ (mod n₂)`, ...
- [ ] **CRT**: unique solution mod `n₁ * n₂ * ...` when moduli are pairwise coprime
- [ ] **Construction**: using extended Euclidean
- [ ] **General CRT**: works with non-coprime moduli (if consistent)
- [ ] **Applications**: cryptography, competitive programming, calendar calculations

## Module 8: Combinatorics
- [ ] **Permutations**: `n! / (n-k)!` — order matters
- [ ] **Combinations**: `C(n, k) = n! / (k! * (n-k)!)` — order doesn't
- [ ] **Pascal's triangle**: `C(n, k) = C(n-1, k-1) + C(n-1, k)`
- [ ] **Precompute factorials** + modular inverses for fast C(n, k) mod p
- [ ] **Multinomial**: `n! / (k₁! * k₂! * ...)`
- [ ] **Inclusion-exclusion**: count using |A ∪ B| = |A| + |B| - |A ∩ B|
- [ ] **Stars and bars**: count distributions of n identical into k boxes
- [ ] **Catalan numbers**: count parenthesizations, binary trees, valid path patterns
- [ ] **Derangements**: permutations with no fixed points

## Module 9: Probability Basics
- [ ] **Sample space**: set of outcomes
- [ ] **Event**: subset of outcomes
- [ ] **Probability**: |event| / |sample space| (uniform)
- [ ] **Conditional probability**: `P(A | B) = P(A ∩ B) / P(B)`
- [ ] **Bayes' theorem**: `P(A | B) = P(B | A) * P(A) / P(B)`
- [ ] **Expectation**: average value
- [ ] **Linearity of expectation**: `E[X + Y] = E[X] + E[Y]` (even if dependent)
- [ ] **Applications**: probabilistic algorithms, game theory, randomized analysis

## Module 10: Competitive Number Theory Tricks
- [ ] **Matrix exponentiation**: O(k³ log n) for linear recurrences
  - [ ] Fibonacci in O(log n)
- [ ] **Mobius function μ(n)**: multiplicative inversion
- [ ] **Dirichlet convolution**: operation on multiplicative functions
- [ ] **Number of divisors, sum of divisors**: fast computation
- [ ] **Prime counting function π(n)**: Meissel-Mertens, Lucy_Hedgehog algorithm
- [ ] **Legendre symbol, quadratic residues**
- [ ] **Discrete logarithm**: Baby-step giant-step
- [ ] **Primitive root**
- [ ] **FFT and NTT** (number theoretic transform) for polynomial multiplication

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement GCD, LCM, extended Euclidean |
| Module 3 | Implement Sieve of Eratosthenes, Miller-Rabin |
| Module 4 | Prime factorization, count divisors |
| Module 5 | Fast power (binary exponentiation) |
| Module 6 | Modular inverse (Fermat + extended Euclidean) |
| Module 7 | Apply CRT to a small system |
| Module 8 | Precompute n! mod p, compute C(n, k) mod p |
| Module 9 | Solve classic probability problems |
| Module 10 | Matrix exponentiation for Fibonacci in O(log n) |

## Key Resources
- CP-Algorithms — Number theory section
- "Concrete Mathematics" — Graham, Knuth, Patashnik
- "Competitive Programming Handbook" — Laaksonen
- "Number Theory: Modular Arithmetic" — tutorials
- Codeforces EDU: Math
