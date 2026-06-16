# 公开开发跟踪

MoonGeoKit 按公开仓库持续开发方式推进，核心证据包括提交记录、Issue、Pull Request、CHANGELOG、ROADMAP 和 CI。

## 当前提交主题

- 几何核心类型
- 线段相交检测
- AABB 包围盒
- AABB union 合并
- 多边形面积与周长
- 点在多边形内
- 点集凸包
- 折线长度与简化
- 点到线段距离
- 点到折线距离
- 轻量空间索引
- 点查询与范围查询
- 项目差异说明
- JSON 导出
- CLI 演示
- CI 与协作模板
- README、路线图和更新日志

## 与已有项目的差异证据

- `moon_rapier` 是刚体物理库，重点在 collision、dynamics、pipeline、control、RigidBody、Collider 和物理仿真 step。
- `geometry3d` 是 3D 几何/图形基础设施，重点在 mesh、transform、camera、projection、lighting 等三维能力。
- MoonGeoKit 当前仓库代码聚焦 2D 计算几何：Point、Segment、Bounds、Polygon、Polyline、convex_hull、contains_point、distance_to_segment、SpatialIndex 和 GeometrySummary。
- MoonGeoKit 不封装物理世界，不做刚体动力学，也不做 3D 场景渲染，适合作为绘图、地图、编辑器和可视化工具的轻量几何内核。

## 后续工单建议

1. 支持 RDP 折线简化
2. 支持多边形凸性判断
3. 支持 GeoJSON 导入导出
4. 增加最近点对算法
5. 增加 WebAssembly 示例

## 合并请求建议

- `feat/rdp-simplify`
- `feat/polygon-convexity`
- `io/geojson`
- `feat/closest-pair`
