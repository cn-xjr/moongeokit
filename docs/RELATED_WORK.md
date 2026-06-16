# 相关项目差异说明

本文件用于回应报名初审中关于 MoonGeoKit 与社区已有几何/物理项目关系的疑问。

## 与 moon_rapier 的关系

`Milky2018/moon_rapier` 是基于 Rapier 思路的 MoonBit 刚体物理库，主要模块覆盖 `core`、`collision`、`dynamics`、`pipeline`、`control`，核心对象包括刚体、碰撞体、物理管线、积分参数、关节和控制器。

MoonGeoKit 不做刚体仿真，不提供重力、速度、质量、关节、约束、碰撞世界或 physics step。它提供的是更小粒度的 2D 平面几何基础件：点、线段、包围盒、多边形、折线、凸包、点包含、线段相交、距离查询和轻量空间索引。

## 与 geometry3d 的关系

`Luna-Flow/geometry3d` 面向 3D 几何和图形基础设施，重点在 mesh、transform、camera、perspective projection、lighting 等三维场景能力。

MoonGeoKit 不做三维网格、相机、投影、光照、场景图或渲染绑定。它专注二维平面数据处理，服务于 SVG/Canvas 编辑器、地图预处理、2D 关卡编辑器、可视化布局和教学算法。

## MoonGeoKit 的独立价值

- 作为无平台依赖的 2D 几何内核，可同时服务 MoonBit 的 JS、Wasm 和 Native 场景。
- API 面向基础算法复用，而不是绑定某个渲染器、物理引擎或外部数据源。
- 当前已实现 SpatialIndex，用 AABB 支持点查询和范围查询，后续可扩展到网格索引、R-tree 风格批量查询和 GeoJSON 数据交换。
- 适合被上层项目组合使用：地图编辑、图形标注、路径碰撞预检查、可视化元素拾取、几何教学和自动化测试。
