# MoonGeoKit

MoonGeoKit 是面向 MoonBit 的二维计算几何与可观测空间查询基础库，适用于地图编辑、
图形标注、游戏关卡、可视化拾取和碰撞预筛选。项目强调跨后端、确定性以及真实可量化
的空间索引性能。

## 核心能力

- `Point`、`Segment`、`Bounds`、`Polygon`、`Polyline`
- 向量、距离、面积、周长、凸包和点包含
- 带 epsilon 的稳健方向、点在线段上和线段相交谓词
- 线性 `SpatialIndex`，适合小数据和基准对照
- 均匀网格 `GridSpatialIndex`，适合已知世界范围的高频查询
- 查询诊断：命中对象、扫描候选数、访问网格数
- JSON 导出和确定性命令行基准

## 可观测空间索引

```mbt
test {
  let index = GridSpatialIndex::new(
    Bounds::new(0.0, 0.0, 1000.0, 1000.0),
    100,
    100,
  )
  ignore(
    index.insert(
      SpatialItem::new(1, Bounds::new(10.0, 10.0, 14.0, 14.0)),
    ),
  )

  let result = index.query_point(Point::new(12.0, 12.0))
  assert_eq(result.items.length(), 1)
  assert_eq(result.buckets_visited, 1)
}
```

`candidates_scanned` 让应用和评审能够观察索引是否真正减少候选检查。跨多个网格的对象
会被查询去重，再执行精确 AABB 判断。

## 容差几何谓词

```mbt
test {
  let edge = Segment::new(Point::new(0.0, 0.0), Point::new(10.0, 0.0))
  let measured = Point::new(5.0, 0.00000001)

  assert_false(point_on_segment_eps(measured, edge, 0.000000001))
  assert_true(point_on_segment_eps(measured, edge, 0.000001))
}
```

旧的 `point_on_segment` 和 `segments_intersect` API 保持兼容，并使用默认容差。

## 运行与验收

```bash
moon check --target all
moon test --target wasm
moon run cmd/main
moon run cmd/bench
```

详见 [验收证据](docs/ACCEPTANCE.md)、
[相关工作](docs/RELATED_WORK.md) 和 [路线图](ROADMAP.md)。
