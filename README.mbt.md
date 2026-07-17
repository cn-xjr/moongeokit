# MoonGeoKit

MoonGeoKit provides deterministic two-dimensional geometry and a mutable
uniform-grid spatial index for MoonBit. It runs with the same public API on
native, JavaScript, Wasm, and Wasm-GC targets.

## Geometry

- `Point`, `Segment`, `Bounds`, `Polyline`, and `Polygon` primitives.
- Vector arithmetic, projections, distance, intersections, convex hulls,
  containment, area/perimeter, and area-weighted polygon centroids.
- Tolerant geometry predicates (`*_eps`) for measured coordinates.
- GeoJSON export for Point, LineString, Polygon, bounds, and indexed features.

## Spatial indexing

`SpatialIndex` is a simple linear baseline. `GridSpatialIndex` is intended for
bounded map/editor worlds: it stores AABBs in every intersected grid cell,
deduplicates range candidates, and reports both candidates scanned and buckets
visited. It supports incremental single operations as well as batched insert,
update, and delete operations. A batch rebuilds the bucket table once.

```mbt nocheck
///|
test {
  let index = GridSpatialIndex::new(Bounds::new(0.0, 0.0, 100.0, 100.0), 10, 10)
  ignore(
    index.insert_many([
      SpatialItem::new(1, Bounds::new(10.0, 10.0, 14.0, 14.0)),
      SpatialItem::new(2, Bounds::new(40.0, 40.0, 42.0, 42.0)),
    ]),
  )
  match index.query_nearest(Point::new(16.0, 12.0), 10.0) {
    Some(item) => assert_eq(item.id, 1)
    None => fail("expected an item")
  }
}
```

## Verification

```bash
moon fmt --check
moon check --deny-warn --target all
moon info && git diff --exit-code -- '*.mbti'
moon test --deny-warn --target all
moon run cmd/main --target js
moon run cmd/bench --target js
```

MoonBit 0.10.4 does not support `--deny-warn` on `moon fmt` or `moon info`;
the first and third commands are the supported strict equivalents. The CI file
runs these exact commands. The benchmark reports deterministic 1k, 10k, and
~100k candidate/bucket evidence instead of machine-specific elapsed-time
claims.
