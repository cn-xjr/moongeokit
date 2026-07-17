///|
fn run_case(side : Int, grid_side : Int) -> Unit {
  let total = side * side
  let extent = side.to_double() * 10.0
  let index = @geo.GridSpatialIndex::new(
    @geo.Bounds::new(0.0, 0.0, extent, extent),
    grid_side,
    grid_side,
  )
  for y = 0; y < side; y = y + 1 {
    for x = 0; x < side; x = x + 1 {
      let min_x = x.to_double() * 10.0 + 2.0
      let min_y = y.to_double() * 10.0 + 2.0
      ignore(
        index.insert(
          @geo.SpatialItem::new(
            y * side + x,
            @geo.Bounds::new(min_x, min_y, min_x + 3.0, min_y + 3.0),
          ),
        ),
      )
    }
  }
  let center = extent / 2.0
  let point = index.query_point(@geo.Point::new(center + 2.5, center + 2.5))
  let range = index.query_bounds(
    @geo.Bounds::new(center - 10.0, center - 10.0, center + 20.0, center + 20.0),
  )
  println("linear-point-baseline,\{total},1,\{total},1")
  println(
    "grid-point,\{total},\{point.items.length()},\{point.candidates_scanned},\{point.buckets_visited}",
  )
  println(
    "grid-range,\{total},\{range.items.length()},\{range.candidates_scanned},\{range.buckets_visited}",
  )
}

///|
fn main {
  println("scenario,items,hits,candidates,buckets")
  // Deterministic 1k / 10k / 100k workloads; candidate and bucket counts are
  // backend-independent evidence, while wall-clock time is intentionally not
  // printed because it is machine-dependent.
  run_case(32, 32)
  run_case(100, 100)
  run_case(316, 158)
}
