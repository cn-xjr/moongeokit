# Geometry Pipeline Example

典型的批量几何处理流水线：

```moonbit
let bounds = Bounds::from_points(points)
let hull = convex_hull(points)
let simplified = Polyline::new(points).simplify_by_distance(1.0)
let inside = hull.contains_point(Point::new(2.0, 1.0))
```

需要高频拾取或范围查询时，可以将对象边界放入网格索引：

```moonbit
let index = GridSpatialIndex::new(world_bounds, 64, 64)
for item in items {
  ignore(index.insert(item))
}
let hits = index.query_bounds(selection_bounds)
println("candidates=\{hits.candidates_scanned}")
```

适合地图轨迹、图形编辑器、游戏关卡工具和可视化预处理。
