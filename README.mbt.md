# MoonGeoKit

MoonGeoKit 是一个面向 MoonBit 的二维计算几何与轻量空间查询基础库。

项目方向和前面的 MoonNavKit、MoonSketchKit、MoonLexKit、MoonChartKit、MoonSignalKit、MoonMatrixKit 都不同。它聚焦 2D 平面几何对象、几何关系判断、包围盒索引和数据交换，适合图形工具、地图处理、游戏编辑器、可视化布局、交互式标注和教学算法复用。

GitHub 仓库地址：[cn-xjr/moongeokit](https://github.com/cn-xjr/moongeokit)。

## 当前能力

- 基础类型：Point、Segment、Bounds、Polygon、Polyline、SpatialItem、SpatialIndex、GeometrySummary
- 向量运算：加减、缩放、点积、叉积、长度、距离、方向判断
- 线段能力：点在线段上、线段相交、最近点、点到线段距离
- 包围盒：从点集生成、宽高、包含判断、相交判断、union 合并
- 多边形：顶点数、符号面积、面积、周长、平均质心、点在多边形内
- 点集算法：Jarvis March 凸包
- 折线算法：长度计算、按距离阈值简化、最近点、点到折线距离
- 空间查询：基于 AABB 的点查询、范围查询和整体 bounds 汇总
- 数据输出：Point、Bounds、Polygon、SpatialItem、SpatialIndex、GeometrySummary JSON
- CLI 演示：`moon run cmd/main`

## 与已有项目的关系

MoonGeoKit 不定位为物理引擎，也不定位为 3D 渲染/场景几何库，而是补齐 MoonBit 生态里更基础的 2D 计算几何与空间查询层。

- 与 `Milky2018/moon_rapier` 的区别：`moon_rapier` 面向刚体物理，包含 collision、dynamics、pipeline、control 等物理仿真模块；MoonGeoKit 不提供刚体、关节、重力、积分、碰撞世界或物理 step，而提供可被编辑器、地图工具和可视化工具复用的 2D 几何对象与查询函数。
- 与 `Luna-Flow/geometry3d` 的区别：`geometry3d` 面向 3D 基础设施，关注 mesh、transform、camera、projection、lighting 等三维图形能力；MoonGeoKit 专注 2D 平面数据，包括点、线段、多边形、折线、凸包、AABB 和轻量空间索引。
- 独立价值：上层库可以把 MoonGeoKit 当作“无平台依赖的几何内核”，用于 SVG/Canvas 编辑器、GIS 前处理、路径碰撞预检查、图形标注、关卡编辑器和算法教学，而不需要引入完整物理引擎或 3D 渲染栈。

## 快速开始

```bash
moon test
moon run cmd/main
```

```moonbit nocheck
let points = [
  @moongeokit.Point::new(0.0, 0.0),
  @moongeokit.Point::new(4.0, 0.0),
  @moongeokit.Point::new(4.0, 3.0),
  @moongeokit.Point::new(0.0, 3.0),
]

let hull = @moongeokit.convex_hull(points)
let area = hull.area()

let index = @moongeokit.SpatialIndex::new()
index.insert(@moongeokit.SpatialItem::new(1, hull.bounds()))
let hits = index.query_point(@moongeokit.Point::new(2.0, 1.0))
```

## 设计原则

- 后端中立：核心库不依赖浏览器、Canvas、DOM 或文件系统
- 行为明确：边界点、退化输入和越界情况有稳定返回
- 可组合：点、线段、包围盒、多边形和折线能力可以自由组合
- 可追踪开发：提交记录、Issue、PR、CHANGELOG 和 CI 围绕公开仓库维护
