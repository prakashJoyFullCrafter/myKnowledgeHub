# Randomized Algorithms & Probabilistic Data Structures - Curriculum

Algorithms that use randomness for efficiency, simplicity, or correctness guarantees.

---

## Module 1: Why Randomize?
- [ ] **Benefits**:
  - [ ] Avoid worst-case inputs (adversary)
  - [ ] Simpler than deterministic counterparts
  - [ ] Better expected performance
  - [ ] Enable approximations with quality guarantees
- [ ] **Two categories**:
  - [ ] **Las Vegas**: always correct, random runtime
  - [ ] **Monte Carlo**: random correctness, always fast
- [ ] **Examples**:
  - [ ] Las Vegas: randomized quicksort
  - [ ] Monte Carlo: Miller-Rabin primality test
- [ ] **Trade-off**: accept small failure probability for speed

## Module 2: Randomized Quicksort
- [ ] **Idea**: random pivot makes worst-case inputs unlikely
- [ ] **Expected time**: O(n log n)
- [ ] **Worst case**: O(n²) (but vanishingly rare)
- [ ] **Proof sketch**: expected depth O(log n)
- [ ] **Variants**:
  - [ ] Median-of-three (deterministic pseudo-random)
  - [ ] Random index pivot
- [ ] **Practical performance**: one of the fastest sorting algorithms

## Module 3: Randomized Quickselect (Kth Element)
- [ ] **Problem**: find kth smallest element
- [ ] **Randomized quickselect**:
  - [ ] Random pivot, partition
  - [ ] Recurse only on the side containing kth
- [ ] **Expected**: O(n)
- [ ] **Worst**: O(n²) (rare)
- [ ] **Median of medians**: guaranteed O(n) but complex
- [ ] **In practice**: randomized is almost always used

## Module 4: Reservoir Sampling
- [ ] **Problem**: select K random items from stream of unknown length
- [ ] **Algorithm (k=1)**:
  - [ ] For item i: replace current sample with probability 1/i
  - [ ] Result: each item has equal probability 1/n
- [ ] **Algorithm (k≥1)**:
  - [ ] Store first K items
  - [ ] For item i > K: replace random one with probability K/i
- [ ] **Time**: O(n), **Space**: O(k)
- [ ] **Applications**: sampling log data, randomized algorithms on streams

## Module 5: Fisher-Yates Shuffle
- [ ] **Problem**: uniform random shuffle of array
- [ ] **Algorithm**:
  ```
  for i from n-1 down to 1:
      j = random(0, i)
      swap(a[i], a[j])
  ```
- [ ] **Proof**: each permutation has probability 1/n!
- [ ] **Time**: O(n)
- [ ] **Watch out**: naive shuffling ("for each i, swap with random") is biased
- [ ] **Java**: `Collections.shuffle()` uses Fisher-Yates

## Module 6: Miller-Rabin Primality Test
- [ ] **Deterministic trial division**: O(√n) — slow for huge numbers
- [ ] **Miller-Rabin**: probabilistic, based on Fermat's little theorem
- [ ] **Key: witnesses to compositeness**
- [ ] **Iteration**:
  - [ ] Pick random witness a
  - [ ] Check if `a^d mod n = 1` or `a^(d·2^r) mod n = n-1` for some r
- [ ] **Probability of false positive**: ≤ 1/4 per iteration
- [ ] **K iterations**: probability ≤ 1/4^K
- [ ] **Deterministic for n < 3.3·10^14** with specific witnesses
- [ ] **Applications**: cryptography, number theory

## Module 7: Bloom Filter
- [ ] **Bloom filter**: probabilistic set — "maybe in set" or "definitely not"
- [ ] **Space**: much smaller than storing full set
- [ ] **Operations**:
  - [ ] **Add**: set k bits (chosen by k hash functions)
  - [ ] **Contains**: check all k bits set?
- [ ] **False positives**: possible (bits set by other items)
- [ ] **False negatives**: IMPOSSIBLE
- [ ] **Parameters**:
  - [ ] m = bits, n = items, k = hash functions
  - [ ] Optimal k ≈ (m/n) * ln(2)
  - [ ] False positive rate ≈ (1 - e^(-kn/m))^k
- [ ] **Applications**:
  - [ ] Cache prefilter (avoid expensive lookup)
  - [ ] Database row existence check
  - [ ] Duplicate detection in streams
  - [ ] DNS cache, network routers
- [ ] **Variants**: Counting Bloom, Cuckoo Filter (supports delete)

## Module 8: HyperLogLog (HLL)
- [ ] **Problem**: count distinct items in massive stream
- [ ] **HyperLogLog**: probabilistic cardinality estimator
- [ ] **Space**: ~12 KB for any cardinality
- [ ] **Error**: ~0.81% standard error
- [ ] **Algorithm sketch**:
  - [ ] Hash each item
  - [ ] Count leading zeros
  - [ ] Use "max leading zeros seen" to estimate log(cardinality)
  - [ ] Average across buckets (bias correction)
- [ ] **Operations**:
  - [ ] Add: O(1)
  - [ ] Count: O(1)
  - [ ] Merge: O(m) — can merge two HLLs
- [ ] **Applications**:
  - [ ] Unique visitors per day
  - [ ] Distinct IPs, distinct search queries
  - [ ] Redis `PFADD`, `PFCOUNT`

## Module 9: Count-Min Sketch
- [ ] **Problem**: estimate frequency of items in stream
- [ ] **Count-Min**: matrix of counters, each row hashed differently
- [ ] **Add**: increment `count[i][h_i(x)]` for each row i
- [ ] **Query**: return `min` over all rows (conservative estimate)
- [ ] **Error**: always ≥ true count (no false negatives)
- [ ] **Parameters**: width w, depth d → error ≤ n/w with probability ≥ 1 - 1/2^d
- [ ] **Applications**:
  - [ ] Heavy hitters (most frequent)
  - [ ] Frequency estimation in streams
  - [ ] Network traffic monitoring
  - [ ] Search query frequencies

## Module 10: Other Randomized Techniques
- [ ] **Simulated annealing**: probabilistic optimization
- [ ] **Monte Carlo tree search (MCTS)**: game AI (AlphaGo)
- [ ] **Randomized load balancing**: power of two choices
- [ ] **Random hashing**: universal hash families, prevents worst-case collisions
- [ ] **Randomized linear algebra**: sketching for fast approximations
- [ ] **Las Vegas algorithms**:
  - [ ] Randomized Kruskal's (for expected faster MST)
  - [ ] Randomized primality testing variants
- [ ] **Chernoff bounds, Markov's inequality**: analyze probabilistic algorithms

## Module 11: When to Use Randomization
- [ ] **Good for**:
  - [ ] Massive data (streams, big data)
  - [ ] Approximate answers acceptable
  - [ ] Adversarial inputs (hash tables, load balancing)
  - [ ] Simpler implementation than deterministic
- [ ] **Not good for**:
  - [ ] Cryptographic applications (need true random)
  - [ ] Reproducibility required (or seed the RNG)
  - [ ] Correctness critical with no tolerance for error (unless Las Vegas)
- [ ] **Quality of randomness**: `Random` vs `SecureRandom` in Java

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-3 | Implement randomized quicksort and quickselect |
| Module 4 | Implement reservoir sampling for k=1 and k≥1 |
| Module 5 | Implement Fisher-Yates shuffle, verify uniformity |
| Module 6 | Implement Miller-Rabin primality test |
| Module 7 | Implement Bloom filter, measure false positive rate |
| Module 8 | Implement HyperLogLog, compare with exact count |
| Module 9 | Implement Count-Min sketch, find heavy hitters |
| Module 10 | Read about MCTS overview |
| Module 11 | Decide randomized vs deterministic for 5 scenarios |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapter 5
- "Randomized Algorithms" — Motwani & Raghavan
- "Probability and Computing" — Mitzenmacher & Upfal
- Redis source (for HLL, Bloom)
- "Sketching Algorithms" — course notes
