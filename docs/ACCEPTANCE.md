# 验收证据

## 正确性

- 基础几何、凸包、点包含和折线算法均有确定性测试。
- 网格索引覆盖点查询、范围查询、跨格去重和越界输入。
- 容差谓词覆盖严格与宽松 epsilon。
- 当前共 22 项测试；Wasm 与 Wasm-GC 本地执行通过，CI 额外验证 Native 与 JavaScript。

## 性能模型

| 操作 | 时间复杂度 |
| --- | --- |
| 线性扫描查询 | O(n) |
| 网格点查询 | O(k) |
| 网格范围查询 | O(b + k) |
| 插入 | O(c) |

`b` 是查询覆盖的网格数，`k` 是去重后的候选数，`c` 是对象覆盖的网格数。

运行 `moon run cmd/bench` 会构建 10,000 个规则分布对象。线性基线每次需要检查 10,000 个对象，网格索引则输出实际 `candidates_scanned` 与 `buckets_visited`。项目不使用单台机器的偶然耗时宣称跨平台性能。

## 可复现命令

```bash
moon fmt --check
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon run cmd/bench
moon info
git diff --check
```
