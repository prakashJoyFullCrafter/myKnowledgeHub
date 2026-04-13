# BFS & DFS - Curriculum

## Module 1: Graph Traversal Fundamentals
- [ ] **Graph traversal**: visit every vertex reachable from a starting vertex
- [ ] **Two fundamental approaches**:
  - [ ] **BFS (Breadth-First Search)**: level-by-level
  - [ ] **DFS (Depth-First Search)**: go deep first
- [ ] **Visited set**: avoid revisiting, prevent infinite loops
- [ ] **Time complexity**: O(V + E) for both
- [ ] **Space complexity**: O(V) for visited + frontier
- [ ] **Graph representations**:
  - [ ] **Adjacency list**: most common, `List<List<Integer>>`
  - [ ] **Adjacency matrix**: O(V²) space, O(1) edge check

## Module 2: BFS Fundamentals
- [ ] **BFS**: uses a **queue** (FIFO)
- [ ] **Template**:
  ```
  queue.offer(start); visited.add(start);
  while (!queue.isEmpty()):
      node = queue.poll()
      for neighbor in adj[node]:
          if not visited:
              visited.add(neighbor)
              queue.offer(neighbor)
  ```
- [ ] **Level-by-level**: process all nodes at current distance before moving farther
- [ ] **Shortest path in unweighted graph**: BFS gives it free
- [ ] **Track distance**: increment each level, or store distance per node
- [ ] **Parent map**: for path reconstruction

## Module 3: BFS on Trees
- [ ] **Level-order traversal**: BFS on tree from root
- [ ] **Level-by-level processing**: `size = queue.size()` at start of each level
- [ ] **Use cases**:
  - [ ] **Zigzag level-order traversal**: alternate direction per level
  - [ ] **Right-side view**: last node of each level
  - [ ] **Tree width / max level size**
  - [ ] **Min depth of tree**
  - [ ] **Connect level-order next pointers**

## Module 4: BFS on Graphs
- [ ] **Shortest path** (unweighted): BFS from source
- [ ] **Connected components**: BFS from each unvisited node
- [ ] **Bipartite graph check**: 2-color with BFS
- [ ] **Word Ladder**: transform word step-by-step (BFS on implicit graph)
- [ ] **Knight on chessboard**: shortest knight moves
- [ ] **Rotten Oranges**: multi-source BFS
- [ ] **01 BFS**: BFS variant with deque for 0/1 edge weights

## Module 5: Multi-Source BFS
- [ ] **Problem**: BFS from multiple starting points simultaneously
- [ ] **Technique**: initialize queue with ALL sources, then standard BFS
- [ ] **Use cases**:
  - [ ] **Walls and Gates**: distance from any gate to each cell
  - [ ] **Rotting Oranges**: time to rot all oranges
  - [ ] **As Far From Land As Possible**: BFS from all land cells
- [ ] **Time**: still O(V + E) — touches each cell once

## Module 6: DFS Fundamentals
- [ ] **DFS**: uses a **stack** (recursion or explicit)
- [ ] **Recursive template**:
  ```
  def dfs(node):
      if visited[node]: return
      visited[node] = true
      for neighbor in adj[node]:
          dfs(neighbor)
  ```
- [ ] **Iterative with stack**: avoid recursion depth limit
- [ ] **Go deep first**: explore one path fully before backtracking
- [ ] **Space**: O(V) for recursion stack (worst case)
- [ ] **Not optimal for shortest path** (but good for many other things)

## Module 7: Tree Traversals (DFS)
- [ ] **Preorder**: root → left → right
- [ ] **Inorder**: left → root → right (BST gives sorted)
- [ ] **Postorder**: left → right → root
- [ ] **Morris traversal**: O(1) space using threaded binary tree
- [ ] **Applications**:
  - [ ] **Validate BST**: inorder should be sorted
  - [ ] **Kth smallest in BST**: inorder, stop at K
  - [ ] **LCA (Lowest Common Ancestor)**: recursive DFS
  - [ ] **Path sum**: DFS with running sum
  - [ ] **Serialize/deserialize tree**: preorder or level-order
  - [ ] **Invert binary tree**: DFS with swap

## Module 8: DFS on Graphs
- [ ] **Cycle detection**:
  - [ ] **Undirected**: DFS, check back edge excluding parent
  - [ ] **Directed**: DFS with 3 colors (white/gray/black)
- [ ] **Topological sort**:
  - [ ] DFS-based: post-order reverse
  - [ ] Kahn's: BFS-based (indegree)
- [ ] **Connected components**: DFS from each unvisited
- [ ] **Strongly connected components**: Tarjan's, Kosaraju's
- [ ] **Path finding**: DFS with backtracking
- [ ] **Islands count**: DFS on grid, mark visited
- [ ] **Flood fill**: DFS or BFS

## Module 9: Grid BFS/DFS
- [ ] **Grid as graph**: each cell is a vertex, neighbors are adjacent cells
- [ ] **Directions**: 4-directional (`dx = {-1,1,0,0}, dy = {0,0,-1,1}`)
- [ ] **8-directional**: includes diagonals
- [ ] **Bounds check**: `0 <= r < rows && 0 <= c < cols`
- [ ] **Visited marker**: separate set, or modify grid in-place (if allowed)
- [ ] **Common problems**:
  - [ ] **Number of Islands**: DFS/BFS on '1' cells
  - [ ] **Max Area of Island**: return count from DFS
  - [ ] **Surrounded Regions**: mark from edges, flip rest
  - [ ] **Word Search**: DFS + backtracking
  - [ ] **Shortest Path in Binary Matrix**: BFS (shortest path)

## Module 10: BFS vs DFS — When to Use
- [ ] **BFS**:
  - [ ] Shortest path in unweighted graph
  - [ ] Level-by-level processing
  - [ ] Closest/earliest
  - [ ] Widest-first exploration
- [ ] **DFS**:
  - [ ] Path existence / all paths
  - [ ] Cycle detection
  - [ ] Topological sort
  - [ ] Connected components
  - [ ] Backtracking
  - [ ] Tree traversals (except level-order)
- [ ] **Space trade-off**:
  - [ ] BFS: O(width) — wide graph can be expensive
  - [ ] DFS: O(depth) — deep graph can cause stack overflow
- [ ] **Iterative deepening DFS**: BFS benefits with DFS space

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement BFS with queue and visited set |
| Module 3 | Level-order traversal, zigzag, right side view |
| Module 4 | Connected components, bipartite check, Word Ladder |
| Module 5 | Rotten Oranges, Walls and Gates |
| Module 6 | Implement recursive and iterative DFS |
| Module 7 | All 3 tree traversals, validate BST, kth smallest |
| Module 8 | Cycle detection (directed and undirected), topological sort |
| Module 9 | Number of Islands, Word Search, Flood Fill |
| Module 10 | Choose BFS or DFS for 10 scenarios |

## Key Resources
- LeetCode Graph tag, Tree tag
- NeetCode.io — Graph patterns
- "Introduction to Algorithms" (CLRS) — Chapters 22-24
- CP-Algorithms — Graph algorithms
