# Geometry Pipeline Example

一个典型几何处理流程：

```moonbit
let bounds = @moongeokit.Bounds::from_points(points)
let hull = @moongeokit.convex_hull(points)
let simplified = @moongeokit.Polyline::new(points).simplify_by_distance(1.0)
let inside = hull.contains_point(@moongeokit.Point::new(2.0, 1.0))
```

适合地图轨迹、图形编辑器、游戏关卡工具和可视化预处理。
