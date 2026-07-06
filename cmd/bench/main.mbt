///|
fn main {
  let side = 100
  let total = side * side
  let index = @geo.GridSpatialIndex::new(
    @geo.Bounds::new(0.0, 0.0, 1000.0, 1000.0),
    100,
    100,
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
  let point = index.query_point(@geo.Point::new(502.5, 502.5))
  let range = index.query_bounds(
    @geo.Bounds::new(490.0, 490.0, 520.0, 520.0),
  )
  println("scenario,items,hits,candidates,buckets")
  println("linear-point-baseline,\{total},1,\{total},1")
  println(
    "grid-point,\{total},\{point.items.length()},\{point.candidates_scanned},\{point.buckets_visited}",
  )
  println(
    "grid-range,\{total},\{range.items.length()},\{range.candidates_scanned},\{range.buckets_visited}",
  )
}
