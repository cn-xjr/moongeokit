///|
fn main {
  let points = [
    @geo.Point::new(0.0, 0.0),
    @geo.Point::new(4.0, 0.0),
    @geo.Point::new(4.0, 3.0),
    @geo.Point::new(0.0, 3.0),
    @geo.Point::new(2.0, 1.0),
  ]
  let hull = @geo.convex_hull(points)
  let bounds = @geo.Bounds::from_points(points)
  let river = @geo.Polyline::new([
    @geo.Point::new(0.0, 0.0),
    @geo.Point::new(2.0, 1.0),
    @geo.Point::new(5.0, 1.0),
  ])
  let index = @geo.SpatialIndex::new()
  index.insert(@geo.SpatialItem::new(1, hull.bounds()))
  index.insert(@geo.SpatialItem::new(2, river.bounds()))
  let summary = @geo.GeometrySummary::new(
    points.length(),
    1,
    1,
    bounds.union(river.bounds()),
  )
  println("hull_area=\{hull.area()}")
  println("bounds=\{bounds.to_json()}")
  println("contains=\{hull.contains_point(@geo.Point::new(2.0, 1.0))}")
  println("river_distance=\{river.distance_to(@geo.Point::new(4.0, 3.0))}")
  println("query_hits=\{index.query_point(@geo.Point::new(2.0, 1.0)).length()}")
  println("summary=\{summary.to_json()}")
}
