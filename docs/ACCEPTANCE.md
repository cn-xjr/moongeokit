# Acceptance evidence

## Functional coverage

- Geometry regression tests cover vector arithmetic, tolerant segment
  predicates, polygon containment, convex hulls, polyline projection,
  area-weighted centroids, and degenerate geometry fallbacks.
- Spatial-index tests cover point/range queries, cross-cell de-duplication,
  rejected out-of-world input, single update/delete, batch mutations, and
  bounded nearest-item queries.
- The CLI runs an end-to-end geometry pipeline and emits a GeoJSON Polygon.
  This output can be passed to a browser map or a Wasm host as plain JSON.

## Complexity and boundaries

| Operation | Cost |
| --- | --- |
| Linear index query | `O(n)` |
| Grid point query | `O(k)` |
| Grid range query | `O(b + k)` |
| Insert | `O(c)` |
| Batch update/delete | `O(n + total cell coverage)` (one rebuild) |
| Bounded nearest query | `O(b + k)` plus exact candidate distances |

`b` is visited buckets, `k` is de-duplicated candidates, and `c` is the
number of cells covered by an inserted item. The fixed-world grid deliberately
trades global rebalancing for predictable mutation behavior.

## Reproducible commands

```bash
moon fmt --check
moon check --deny-warn --target all
moon info && git diff --exit-code -- '*.mbti'
moon test --deny-warn --target all
moon run cmd/main --target js
moon run cmd/bench --target js
```

For MoonBit 0.10.4, `moon fmt --deny-warn` and `moon info --deny-warn` are not
valid CLI forms. The format check and generated-interface drift check above
are their strict supported equivalents; CI runs the same commands explicitly.

The benchmark creates deterministic 1k, 10k, and ~100k record workloads and
reports candidate/bucket counts. This is portable evidence across native, JS,
Wasm, and Wasm-GC; wall-clock time is intentionally recorded by the evaluator
on their own target rather than represented as a universal claim.
