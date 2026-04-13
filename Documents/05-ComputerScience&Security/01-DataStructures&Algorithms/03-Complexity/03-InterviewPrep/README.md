# Interview Prep - Curriculum

## Module 1: Problem-Solving Framework
- [ ] **Four-step approach**:
  1. [ ] **Understand**: clarify the problem, ask questions
  2. [ ] **Plan**: discuss approach(es), trade-offs
  3. [ ] **Implement**: write clean code
  4. [ ] **Verify**: test with examples, edge cases
- [ ] **Understand phase questions**:
  - [ ] Input constraints (size, values, types)
  - [ ] Edge cases (empty, single, duplicates, negatives)
  - [ ] Expected output format
  - [ ] Performance constraints
- [ ] **Don't jump to code**: plan first

## Module 2: Pattern Recognition
- [ ] **Common patterns**:
  - [ ] **Two pointers**: sorted arrays, palindromes
  - [ ] **Sliding window**: substring/subarray
  - [ ] **Fast & slow pointers**: linked list cycle, middle
  - [ ] **Merge intervals**: sorted intervals
  - [ ] **Binary search**: sorted or answer-space
  - [ ] **BFS/DFS**: graph, tree
  - [ ] **Backtracking**: permutations, combinations
  - [ ] **Dynamic programming**: optimal substructure + overlapping subproblems
  - [ ] **Greedy**: locally optimal
  - [ ] **Union-Find**: connectivity, components
  - [ ] **Topological sort**: DAG ordering
  - [ ] **Monotonic stack/queue**: next greater element
  - [ ] **Top-K**: heap
  - [ ] **Trie**: prefix search
- [ ] **Learn the pattern, not the problem**

## Module 3: Communication
- [ ] **Think out loud**: walk through your reasoning
- [ ] **Clarify first**: ask questions before coding
- [ ] **Discuss trade-offs**: multiple approaches, why you chose one
- [ ] **Explain complexity**: time and space
- [ ] **Admit uncertainty**: "I'm not sure — let me think"
- [ ] **Don't silently struggle**: ask for hints
- [ ] **Respond to hints**: incorporate feedback quickly
- [ ] **Narrate code**: what you're writing and why
- [ ] **Active listening**: interviewers give clues

## Module 4: Time Management
- [ ] **Typical 45-60 min interview**:
  - [ ] 5 min: understand + clarify
  - [ ] 10 min: plan + discuss
  - [ ] 25-30 min: code
  - [ ] 5-10 min: test + discuss
- [ ] **Don't rush to code**: thinking saves rewrites
- [ ] **Manage your clock**: watch pace
- [ ] **If stuck**: ask for hints rather than silent struggle
- [ ] **Multiple problems**: don't get stuck on one too long

## Module 5: Edge Cases & Testing
- [ ] **Common edge cases**:
  - [ ] Empty input: `[]`, `""`, `null`
  - [ ] Single element
  - [ ] Duplicates
  - [ ] All same elements
  - [ ] Already sorted / reverse sorted
  - [ ] Negative numbers
  - [ ] Zero
  - [ ] Very large / very small
  - [ ] Overflow
- [ ] **Walk through example**: line by line
- [ ] **Dry run with test case**: verify correctness
- [ ] **Trace edge cases**: not just happy path
- [ ] **Boundary conditions**: `<` vs `<=`, off-by-one

## Module 6: Clean Code in Interviews
- [ ] **Meaningful names**: `left`, `right`, `count` — not `a`, `b`, `x`
- [ ] **Small functions**: extract helpers when logical
- [ ] **Consistent style**: indentation, brackets, spacing
- [ ] **Comments sparingly**: explain why, not what
- [ ] **Error handling**: mention what you'd handle in production
- [ ] **Don't over-engineer**: simple solution first
- [ ] **Iterate**: brute force → optimize if time

## Module 7: System Design Interviews
- [ ] **Different from coding**: design a scalable system
- [ ] **Typical 45-60 min**
- [ ] **Framework**:
  1. [ ] Requirements (functional + non-functional)
  2. [ ] Estimation (QPS, storage, bandwidth)
  3. [ ] High-level design (draw boxes)
  4. [ ] Deep dive (one key component)
  5. [ ] Trade-offs and scaling
- [ ] **Common problems**: URL shortener, Twitter, rate limiter, chat, newsfeed
- [ ] **Cross-reference**: see System Design curriculum in 03-Architecture

## Module 8: Behavioral Questions
- [ ] **STAR method**:
  - [ ] **Situation**: context
  - [ ] **Task**: what needed to be done
  - [ ] **Action**: what YOU did
  - [ ] **Result**: outcome
- [ ] **Common questions**:
  - [ ] Tell me about yourself
  - [ ] Biggest challenge / failure
  - [ ] Conflict with coworker
  - [ ] Proudest achievement
  - [ ] Why this company?
- [ ] **Prepare 5-10 stories**: adapt to different questions
- [ ] **Be specific**: measurable outcomes, not vague
- [ ] **Own your mistakes**: what you learned

## Module 9: Top Problems to Practice
- [ ] **LeetCode Top 75 / Blind 75**: curated list
- [ ] **NeetCode 150**: progression beyond Blind 75
- [ ] **Grind 75** (Blind 75 author's newer list)
- [ ] **Company-specific lists**: check LeetCode Company tags
- [ ] **By pattern**: practice one pattern at a time
- [ ] **Target progression**:
  - [ ] Easy: 50-100 problems
  - [ ] Medium: 150-250 problems
  - [ ] Hard: 30-50 problems (enough to not be surprised)
- [ ] **Focus on mediums**: most interview problems are medium
- [ ] **Quality over quantity**: understand, don't memorize

## Module 10: Mock Interviews & Practice Strategy
- [ ] **Mock interviews**:
  - [ ] Interviewing.io (free)
  - [ ] Pramp (free peer mocks)
  - [ ] With friends or coworkers
- [ ] **Simulate real conditions**: time limit, whiteboard/shared doc, talk out loud
- [ ] **Review after**: what went well, what to improve
- [ ] **Record yourself**: watch for communication issues
- [ ] **Spaced repetition**: revisit problems weeks later
- [ ] **Don't just read solutions**: try solving before peeking
- [ ] **Journal progress**: track weak areas

## Module 11: Company Interview Processes
- [ ] **Phone screen**: 1 coding problem, 45 min
- [ ] **On-site / virtual on-site**: 4-6 rounds
  - [ ] Coding (multiple)
  - [ ] System design (senior+)
  - [ ] Behavioral
  - [ ] Architecture / domain-specific
- [ ] **Bar raiser** (Amazon): objective interviewer
- [ ] **Hiring committee**: decision by committee after feedback
- [ ] **Levels matter**: L4 vs L5 vs L6 have different expectations
- [ ] **Know the company**: research culture, products, tech stack

## Module 12: Salary Negotiation & Offers
- [ ] **Never accept first offer**: always negotiate
- [ ] **Know your worth**: levels.fyi, Glassdoor
- [ ] **Competing offers**: strongest leverage
- [ ] **Compensation components**:
  - [ ] Base salary
  - [ ] Sign-on bonus
  - [ ] Equity (RSUs, options)
  - [ ] Annual bonus
  - [ ] Benefits (401k, health, PTO)
- [ ] **Total comp**: consider 4-year total
- [ ] **Get offers in writing**
- [ ] **Be professional**: don't burn bridges

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Practice four-step framework on 10 problems |
| Module 2 | Identify pattern for 20 random problems |
| Module 3 | Record yourself solving a problem, review |
| Module 4 | Time yourself on a medium problem (30 min target) |
| Module 5 | List edge cases for 5 problems before coding |
| Module 6 | Rewrite a messy solution to be clean |
| Module 7 | Practice system design: URL shortener, Twitter |
| Module 8 | Prepare 10 behavioral stories using STAR |
| Module 9 | Work through Blind 75 or NeetCode 150 |
| Module 10 | Do 5 mock interviews (Pramp or friends) |
| Module 11 | Research target companies' processes |
| Module 12 | Practice negotiation scripts |

## Key Resources
- **LeetCode**: primary practice platform
- **NeetCode.io**: structured learning with videos
- **"Cracking the Coding Interview"** — Gayle McDowell
- **"Elements of Programming Interviews"** — Aziz, Lee, Prakash
- **interviewing.io**: free mock interviews
- **Grokking the Coding Interview**: pattern-based
- **levels.fyi**: compensation data
- **Blind 75** on LeetCode
