# 相关工作与项目边界

检索日期：2026-07-06。

- [`Milky2018/moon_rapier`](https://mooncakes.io/docs/Milky2018/moon_rapier) 是刚体物理与碰撞系统。MoonGeoKit 不实现动力学、约束求解或物理世界，而提供地图、编辑器和分析工具可独立使用的二维几何与空间预筛选。
- [`Milky2018/moon_zeno`](https://mooncakes.io/docs/Milky2018/moon_zeno) 是二维路径光栅化库，重点是填充、描边和像素掩码。MoonGeoKit 关注几何关系、AABB 查询与空间索引。
- [`Luna-Flow/geometry3d`](https://mooncakes.io/docs/Luna-Flow/geometry3d) 面向三维网格、变换和相机。MoonGeoKit 专注二维平面数据。

## 独立价值

MoonGeoKit 提供平台无关的二维几何内核、显式容差谓词和可观测网格索引。调用方不仅得到查询结果，还能读取候选扫描数和访问网格数，用相同数据集比较索引与线性扫描。它不绑定渲染器、物理引擎或特定 GIS 文件格式，因此可作为这些上层项目的公共基础。
