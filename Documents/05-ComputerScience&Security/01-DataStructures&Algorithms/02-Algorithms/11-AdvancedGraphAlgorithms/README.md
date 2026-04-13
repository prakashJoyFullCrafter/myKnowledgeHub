# Advanced Graph Algorithms - Curriculum

Beyond BFS/DFS and Dijkstra: max flow, matching, connectivity, and more.

---

## Module 1: Strongly Connected Components (SCC)
- [ ] **SCC**: maximal subset where every vertex reaches every other
- [ ] **Only for directed graphs**
- [ ] **Tarjan's algorithm**: one DFS pass
  - [ ] Uses discovery time and low-link
  - [ ] Stack-based tracking
  - [ ] O(V + E)
- [ ] **Kosaraju's algorithm**:
  - [ ] DFS on graph, record finish times
  - [ ] DFS on transpose in reverse finish order
  - [ ] Each tree is an SCC
  - [ ] O(V + E)
- [ ] **Applications**: 2-SAT, compiler analysis, web graph analysis
- [ ] **Condensation**: contract each SCC to a single node → DAG

## Module 2: Articulation Points & Bridges
- [ ] **Articulation point (cut vertex)**: removing it disconnects the graph
- [ ] **Bridge**: edge whose removal disconnects the graph
- [ ] **Detection**: DFS with discovery time and low-link
- [ ] **Articulation point condition**:
  - [ ] Root with ≥ 2 DFS children
  - [ ] Non-root where some child has no back edge above current
- [ ] **Bridge condition**: `low[child] > disc[current]`
- [ ] **Time**: O(V + E)
- [ ] **Applications**: network reliability, critical connections

## Module 3: Biconnected Components
- [ ] **Biconnected component**: maximal subgraph with no articulation point
- [ ] **Related to articulation points**: decompose graph into biconnected components
- [ ] **Tarjan's BCC algorithm**: similar DFS approach
- [ ] **Block-cut tree**: tree of biconnected components and articulation points
- [ ] **Use case**: reliability analysis

## Module 4: Bellman-Ford
- [ ] **Problem**: shortest paths with possibly negative weights
- [ ] **Algorithm**: relax all edges V-1 times
- [ ] **Time**: O(V·E)
- [ ] **Negative cycle detection**: extra relaxation pass — if any edge relaxes, negative cycle exists
- [ ] **SPFA (Shortest Path Faster Algorithm)**: queue-based Bellman-Ford optimization
  - [ ] Average faster but worst-case same
- [ ] **Not as efficient as Dijkstra**: use only when negative weights
- [ ] **Applications**: currency arbitrage, routing with variable weights

## Module 5: Floyd-Warshall
- [ ] **Problem**: all-pairs shortest path
- [ ] **Algorithm**: DP over intermediate vertices
  ```
  for k in V:
      for i in V:
          for j in V:
              dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
  ```
- [ ] **Time**: O(V³)
- [ ] **Space**: O(V²)
- [ ] **Handles negative edges** (but not negative cycles)
- [ ] **Detect negative cycles**: `dist[i][i] < 0`
- [ ] **When to use**: dense graph, need all pairs, small V
- [ ] **Alternatives**: V × Dijkstra for sparse graphs

## Module 6: Max Flow
- [ ] **Max flow problem**: ship max units from source to sink
- [ ] **Flow network**: directed graph with edge capacities
- [ ] **Ford-Fulkerson method**: augmenting paths
  - [ ] Find path with available capacity, push flow, repeat
- [ ] **Edmonds-Karp**: BFS for shortest augmenting path → O(V·E²)
- [ ] **Dinic's algorithm**: level graphs + blocking flows → O(V²·E)
- [ ] **Push-relabel**: different approach, O(V³) or O(V²√E)
- [ ] **Max-flow min-cut theorem**: max flow = min cut
- [ ] **Applications**: bipartite matching, network reliability, image segmentation

## Module 7: Bipartite Matching
- [ ] **Bipartite graph**: vertices split into two sets with edges only between sets
- [ ] **Matching**: subset of edges with no shared endpoints
- [ ] **Maximum bipartite matching**: maximum size matching
- [ ] **Hungarian algorithm**: O(V³) for assignment problem
- [ ] **Max flow reduction**: source → left → right → sink with unit capacities
  - [ ] Max flow = max matching
- [ ] **Hopcroft-Karp**: O(E·√V) for unweighted bipartite matching
- [ ] **König's theorem**: max matching = min vertex cover (bipartite)
- [ ] **Applications**: job assignment, marriage problem

## Module 8: 2-SAT
- [ ] **SAT (Satisfiability)**: NP-complete in general
- [ ] **2-SAT**: each clause has 2 literals — solvable in polynomial time
- [ ] **Reduction to graph**:
  - [ ] For clause (a OR b): add edges `¬a → b` and `¬b → a`
  - [ ] Implication graph
- [ ] **Algorithm**:
  - [ ] Compute SCCs
  - [ ] For each variable x: if x and ¬x in same SCC → unsatisfiable
  - [ ] Otherwise: SCC in reverse topological order
- [ ] **Time**: O(V + E)
- [ ] **Applications**: constraint satisfaction, some competitive programming problems

## Module 9: Euler Path & Circuit
- [ ] **Euler path**: visits every edge exactly once
- [ ] **Euler circuit**: Euler path that returns to start
- [ ] **Existence** (undirected):
  - [ ] Euler circuit: all vertices have even degree
  - [ ] Euler path: exactly 0 or 2 vertices have odd degree
- [ ] **Existence** (directed):
  - [ ] Euler circuit: in-degree == out-degree for all vertices
  - [ ] Euler path: one vertex with `out - in = 1`, one with `in - out = 1`
- [ ] **Hierholzer's algorithm**: O(E) construction
- [ ] **Applications**: Königsberg bridges, DNA sequencing
- [ ] **Contrast with Hamilton path**: visits every vertex (NP-complete!)

## Module 10: Minimum Spanning Tree (Deep Dive)
- [ ] **MST**: subset of edges connecting all vertices with min total weight
- [ ] **Kruskal's**: sort edges + union-find
  - [ ] O(E log E)
- [ ] **Prim's**: BFS-like with priority queue
  - [ ] O(E log V) with binary heap
  - [ ] O(E + V log V) with Fibonacci heap
- [ ] **Borůvka's**: parallel-friendly, each round connects every component to nearest
- [ ] **Cut property**: min edge crossing any cut is in some MST
- [ ] **Cycle property**: max edge in any cycle is NOT in any MST
- [ ] **Variants**:
  - [ ] **Minimum bottleneck spanning tree**
  - [ ] **Second-best MST**
  - [ ] **Steiner tree** (NP-hard)

## Module 11: Topological Sort (Deep Dive)
- [ ] **Problem**: linear ordering of DAG respecting dependencies
- [ ] **Kahn's algorithm** (BFS):
  - [ ] Start with zero-indegree nodes
  - [ ] Remove, add to order, decrement neighbors' indegree
- [ ] **DFS-based**: post-order reverse
- [ ] **Cycle detection**: if Kahn's can't process all nodes, cycle exists
- [ ] **Applications**: build order, course scheduling, spreadsheet dependencies
- [ ] **Lexicographically smallest topological sort**: priority queue in Kahn's
- [ ] **All topological sorts**: backtracking

## Module 12: A\* Search & Heuristic
- [ ] **A\***: Dijkstra with heuristic toward goal
- [ ] **f(n) = g(n) + h(n)**:
  - [ ] g(n): cost from start to n
  - [ ] h(n): estimated cost to goal (heuristic)
- [ ] **Admissibility**: h never overestimates → optimal
- [ ] **Consistency (monotonic)**: h(n) ≤ cost(n, n') + h(n')
- [ ] **With consistent heuristic**: behaves like Dijkstra on modified weights
- [ ] **Examples**: Manhattan distance, Euclidean distance, zero (becomes Dijkstra)
- [ ] **Applications**: pathfinding (games, robots, maps), puzzle solving

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Module 1 | Implement Tarjan's SCC |
| Module 2 | Find all articulation points and bridges |
| Module 3 | Read about biconnected components |
| Module 4 | Implement Bellman-Ford, detect negative cycle |
| Module 5 | Implement Floyd-Warshall for all-pairs shortest path |
| Module 6 | Implement Edmonds-Karp max flow |
| Module 7 | Solve bipartite matching via max flow |
| Module 8 | Implement 2-SAT solver |
| Module 9 | Find Euler circuit with Hierholzer's |
| Module 10 | Implement Prim's with Fibonacci heap concept |
| Module 11 | Implement both Kahn's and DFS-based topological sort |
| Module 12 | Implement A\* for grid pathfinding |

## Key Resources
- "Introduction to Algorithms" (CLRS) — Chapters 22-26
- CP-Algorithms — Graph section
- "Competitive Programming Handbook" — Laaksonen
- "Graph Algorithms" — Shimon Even
