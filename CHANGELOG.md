# Changelog

## 0.3.0 - 2026-07-17

- Add area-weighted polygon centroids, point-to-bounds distance, and standard
  GeoJSON geometry/feature export for WebAssembly and GIS consumers.
- Add batch grid insertion, update, and deletion APIs that rebuild membership
  once, plus bounded nearest-item lookup with exact AABB distances.
- Expand the reproducible benchmark to deterministic 1k, 10k, and ~100k
  workloads, and expose GeoJSON in the runnable CLI example.
- Make CI contain explicit format, warning-free check, generated-interface,
  and warning-free test gates compatible with MoonBit 0.10.4.

## 0.2.1

- 修复公开文档乱码与 MoonBit 格式检查。
- 补充可复现验收命令、复杂度边界和社区项目差异。
- 保持 22 项几何与空间索引回归测试通过。

## 0.2.0 - 2026-07-06

### Added

- 新增均匀网格 `GridSpatialIndex`。
- 新增 `SpatialQueryResult` 候选扫描量和网格访问量。
- 新增带 epsilon 的稳健方向与线段谓词。
- 新增 10,000 对象确定性空间查询基准。
- 新增四后端 CI、相关工作和验收证据。

### Changed

- 原有线段 API 使用默认容差，避免直接比较浮点零值。
- 修复 README、路线图和跟踪文档中文乱码。
- 明确线性索引与网格索引的适用边界。

## 0.1.1 - 2026-06-16

- 增加 AABB 查询、几何边界和 JSON 导出。

## 0.1.0 - 2026-06-11

- 初始化二维几何类型、基本算法、测试和 CLI。
