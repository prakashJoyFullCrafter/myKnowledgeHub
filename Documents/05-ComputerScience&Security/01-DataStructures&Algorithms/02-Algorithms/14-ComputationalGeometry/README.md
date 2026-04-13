# Computational Geometry - Curriculum

Algorithms on points, lines, polygons, and more.

---

## Module 1: Points, Vectors, Basics
- [ ] **Point**: (x, y) in 2D, (x, y, z) in 3D
- [ ] **Vector**: same representation, different interpretation
- [ ] **Basic operations**:
  - [ ] Addition/subtraction
  - [ ] Scalar multiplication
  - [ ] Dot product: `a·b = ax*bx + ay*by` — relates to angle
  - [ ] Cross product: `a×b = ax*by - ay*bx` (2D scalar) — relates to orientation, area
- [ ] **Distance**: `sqrt((x₁-x₂)² + (y₁-y₂)²)`
- [ ] **Squared distance**: avoid sqrt when comparing
- [ ] **Floating point**: beware precision issues; use integer arithmetic when possible

## Module 2: Orientation & Cross Product
- [ ] **Orientation of 3 points (p, q, r)**: collinear, clockwise, counter-clockwise
- [ ] **Cross product trick**: `(q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)`
  - [ ] > 0: CW
  - [ ] < 0: CCW
  - [ ] = 0: collinear
- [ ] **Why it matters**: foundation for many geometry algorithms
- [ ] **Signed area of triangle**: half of cross product
- [ ] **Polygon area**: shoelace formula (sum of cross products)

## Module 3: Line Segments
- [ ] **Line segment intersection**:
  - [ ] Check orientations of endpoints vs other segment
  - [ ] Handle collinear special case
- [ ] **Line equations**: ax + by + c = 0
- [ ] **Parametric form**: `p = p₀ + t * direction`
- [ ] **Intersection of two lines**: solve linear system
- [ ] **Distance from point to line**: formula with cross product
- [ ] **Closest point on segment to given point**

## Module 4: Polygons
- [ ] **Polygon**: sequence of vertices forming closed path
- [ ] **Convex vs concave (simple) polygon**
- [ ] **Check convexity**: all cross products same sign
- [ ] **Area of polygon (shoelace formula)**:
  ```
  area = |Σ (x[i] * y[i+1] - x[i+1] * y[i])| / 2
  ```
- [ ] **Point-in-polygon**:
  - [ ] **Ray casting**: count intersections
  - [ ] **Winding number**
- [ ] **Point-in-convex polygon**: binary search, O(log n)
- [ ] **Perimeter**: sum of edge lengths

## Module 5: Convex Hull
- [ ] **Convex hull**: smallest convex polygon containing all given points
- [ ] **Algorithms**:
  - [ ] **Graham scan**: O(n log n), sort by angle
  - [ ] **Andrew's monotone chain**: O(n log n), simpler than Graham
  - [ ] **Jarvis march (gift wrapping)**: O(nh) where h is hull size
  - [ ] **Quickhull**: divide and conquer, O(n log n) average
  - [ ] **Chan's algorithm**: O(n log h), optimal
- [ ] **Andrew's algorithm** (recommended):
  - [ ] Sort points by x
  - [ ] Build lower hull, then upper hull
  - [ ] Remove non-left turns
- [ ] **Applications**: smallest enclosing shape, computational geometry primitives

## Module 6: Closest Pair of Points
- [ ] **Problem**: find closest pair among n points
- [ ] **Brute force**: O(n²)
- [ ] **Divide and conquer**: O(n log n)
  1. [ ] Sort by x
  2. [ ] Divide at middle x
  3. [ ] Recursively find min distance in each half
  4. [ ] Check "strip" across middle (bounded 7 candidates)
- [ ] **Elegant classic result**
- [ ] **Applications**: collision detection, clustering

## Module 7: Line Sweep
- [ ] **Line sweep**: imaginary line sweeps across points/intervals
- [ ] **Event-based**: sort events, process in order
- [ ] **Classic problems**:
  - [ ] **Count line segment intersections** (Bentley-Ottmann): O((n + k) log n)
  - [ ] **Max overlapping intervals**: O(n log n)
  - [ ] **Skyline problem**: O(n log n)
  - [ ] **Rectangle union area**
- [ ] **Active set**: sorted set of currently-intersecting objects
- [ ] **Technique**: convert 2D problem to ordered 1D events

## Module 8: Rectangles & Axis-Aligned
- [ ] **Axis-aligned rectangles**: simpler than general polygons
- [ ] **Intersection**: compute overlap region
- [ ] **Area of union of rectangles**: sweep line
- [ ] **Bounding box**: min/max x and y
- [ ] **R-tree**: spatial index for rectangles
- [ ] **Interval scheduling**: 1D version, related algorithms

## Module 9: Polygon Triangulation
- [ ] **Triangulate polygon**: decompose into triangles
- [ ] **Ear clipping**: O(n²) simple method
- [ ] **Monotone polygon triangulation**: O(n log n) via line sweep
- [ ] **Delaunay triangulation**: maximizes minimum angle
- [ ] **Voronoi diagram**: dual of Delaunay
- [ ] **Applications**: mesh generation, rendering, GIS

## Module 10: Useful Formulas & Tricks
- [ ] **Rotation**: rotate point (x, y) by angle θ around origin
- [ ] **Scaling, translation, reflection**: matrix operations
- [ ] **Barycentric coordinates**: for point in triangle
- [ ] **Pick's theorem**: area of lattice polygon via boundary + interior points
- [ ] **Great circle distance**: between points on sphere
- [ ] **Convex polygon area maximization**
- [ ] **Minimum enclosing circle**: Welzl's algorithm

---

## Recommended Practice
| Module | Practice |
|--------|----------|
| Modules 1-2 | Implement point/vector with dot and cross product |
| Module 3 | Segment intersection detection |
| Module 4 | Polygon area, point-in-polygon |
| Module 5 | Implement Andrew's monotone chain convex hull |
| Module 6 | Implement closest pair with divide and conquer |
| Module 7 | Implement skyline problem with line sweep |
| Module 8 | Rectangle intersection, union area |
| Module 9 | Implement ear clipping |
| Module 10 | Apply Pick's theorem |

## Key Resources
- CP-Algorithms — Geometry section
- "Computational Geometry: Algorithms and Applications" — de Berg et al.
- "Algorithm Design Manual" — Skiena (geometry chapter)
- LeetCode — Geometry tag (limited but exists)
