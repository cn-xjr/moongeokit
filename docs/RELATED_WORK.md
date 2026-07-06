# 相关工作与项目边界

检索日期：2026-07-06。

- [`Milky2018/moon_rapier`](https://mooncakes.io/docs/Milky2018/moon_rapier)
  是刚体物理与碰撞系统。MoonGeoKit 不实现物理世界、动力学或约束求解，而提供可被
  地图和编辑器独立使用的二维几何与空间预筛选。
- [`Milky2018/moon_zeno`](https://mooncakes.io/docs/Milky2018/moon_zeno)
  是二维路径光栅化库，重点是填充、描边和像素掩码。MoonGeoKit 重点是几何关系、
  AABB 查询和空间索引。
- [`Luna-Flow/geometry3d`](https://mooncakes.io/docs/Luna-Flow/geometry3d)
  面向三维网格、变换和相机。MoonGeoKit 专注二维平面数据。

项目的独立价值在于：提供平台无关的二维几何内核、容差谓词、可观测网格索引和
可复现候选缩减基准，而不是绑定渲染器或物理引擎。
