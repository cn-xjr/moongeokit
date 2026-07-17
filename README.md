# MoonGeoKit

MoonGeoKit is a MoonBit-native 2D geometry and observable uniform-grid spatial
index for map editors, GIS-style overlays, simulations, and WebAssembly
clients. It is a reusable library, not a rendering demo: callers own the map
data and use the library for deterministic geometry, incremental index changes,
and inspectable query costs.

## Production-facing capabilities

- Points, segments, bounds, polylines, polygons, convex hulls, containment,
  intersections, nearest points, distances, and tolerant predicates.
- Area-weighted polygon centroid with a defined fallback for degenerate rings.
- Fixed-world uniform-grid index with point/range queries, cross-cell
  deduplication, candidate/bucket diagnostics, and out-of-world protection.
- Editor/simulation mutations: single and batched insert, update, and delete;
  batch mutations rebuild bucket membership once.
- Bounded nearest-item lookup using grid candidate reduction plus exact
  point-to-AABB distance.
- Standard GeoJSON Point, LineString, Polygon, bounds, and Feature export for
  browser/Wasm hand-off without a runtime dependency.

## Install

```bash
moon add cn-xjr/moongeokit
```

## Minimal example

```moonbit
let index = @geo.GridSpatialIndex::new(@geo.Bounds::new(0.0, 0.0, 100.0, 100.0), 10, 10)
ignore(index.insert(@geo.SpatialItem::new(7, @geo.Bounds::new(10.0, 10.0, 15.0, 15.0))))
match index.query_nearest(@geo.Point::new(18.0, 12.0), 20.0) {
  Some(item) => println(item.to_geojson_feature())
  None => println("no nearby feature")
}
```

Run the repository demo (including GeoJSON output) with:

```bash
moon run cmd/main --target js
```

## Reproducible verification

MoonBit 0.10.4 does not accept `--deny-warn` for `moon fmt` or `moon info`.
The commands below are the supported strict equivalents and are exactly the
quality gates used by CI:

```bash
moon fmt --check
moon check --deny-warn --target all
moon info && git diff --exit-code -- '*.mbti'
moon test --deny-warn --target all
moon run cmd/main --target js
moon run cmd/bench --target js
```

`cmd/bench` prints deterministic candidate/bucket counts for 1k, 10k, and
roughly 100k indexed records. It deliberately does not publish wall-clock
claims because elapsed time depends on the native/JS/Wasm host.

## Scope and compatibility

The index is a mutable, fixed-world AABB index. It is appropriate for dynamic
editor entities and bounded simulation worlds; it is not a replacement for an
R-tree, polygon topology engine, coordinate-reference transformation library,
or a GeoJSON parser. GeoJSON output is provided for integration; input parsing
and application-specific feature properties remain in the host application.

See [README.mbt.md](README.mbt.md) for API notes, [docs/ACCEPTANCE.md](docs/ACCEPTANCE.md)
for verification evidence, and [docs/RELATED_WORK.md](docs/RELATED_WORK.md)
for scope and prior-art notes.
