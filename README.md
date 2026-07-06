# MoonGeoKit

MoonGeoKit 是面向 MoonBit 的二维计算几何与可观测空间查询基础库。

项目不仅提供点、线段、包围盒、多边形、凸包等基础算法，还实现了固定世界范围的均匀网格索引。查询结果会同时返回命中对象、实际扫描候选数和访问网格数，使正确性与性能收益都可以直接验证。

## 主要能力

- 二维点、线段、包围盒与多边形关系计算。
- 凸包、点到线段距离、折线长度等常用算法。
- 带调用方容差的方向、点在线段上和线段相交谓词。
- 支持点查询与范围查询的均匀网格空间索引。
- 跨网格对象去重、越界保护和可观测查询统计。
- Native、JavaScript、Wasm、Wasm-GC 四后端 CI。

## 验收命令

```bash
moon fmt --check
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/main
moon run cmd/bench
```

详细 API 示例见 [README.mbt.md](README.mbt.md)，社区差异见
[docs/RELATED_WORK.md](docs/RELATED_WORK.md)。
