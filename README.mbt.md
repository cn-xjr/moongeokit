# MoonGeoKit

MoonGeoKit 是一个面向 MoonBit 的二维计算几何基础库。

项目方向和前面的 MoonNavKit、MoonSketchKit、MoonLexKit、MoonChartKit、MoonSignalKit、MoonMatrixKit 都不同。它聚焦点、向量、线段、包围盒、多边形、凸包和几何简化算法，适合图形工具、地图处理、游戏编辑器、可视化布局和教学算法复用。

GitHub 仓库地址：[cn-xjr/moongeokit](https://github.com/cn-xjr/moongeokit)。

## 当前能力

- 基础类型：Point、Segment、Bounds、Polygon、Polyline
- 向量运算：加减、缩放、点积、叉积、长度、距离、方向判断
- 线段能力：点在线段上、线段相交、最近点、点到线段距离
- 包围盒：从点集生成、宽高、包含判断、相交判断
- 多边形：顶点数、符号面积、面积、周长、平均质心、点在多边形内
- 点集算法：Jarvis March 凸包
- 折线算法：长度计算、按距离阈值简化
- 数据输出：Point、Bounds、Polygon JSON
- CLI 演示：`moon run cmd/main`

## 快速开始

```bash
moon test
moon run cmd/main
```

```moonbit
let points = [
  @moongeokit.Point::new(0.0, 0.0),
  @moongeokit.Point::new(4.0, 0.0),
  @moongeokit.Point::new(4.0, 3.0),
  @moongeokit.Point::new(0.0, 3.0),
]

let hull = @moongeokit.convex_hull(points)
let area = hull.area()
```

## 设计原则

- 后端中立：核心库不依赖浏览器、Canvas、DOM 或文件系统
- 行为明确：边界点、退化输入和越界情况有稳定返回
- 可组合：点、线段、包围盒、多边形和折线能力可以自由组合
- 可追踪开发：提交记录、Issue、PR、CHANGELOG 和 CI 围绕公开仓库维护
