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
  println("hull_area=\{hull.area()}")
  println("bounds=\{bounds.to_json()}")
  println("contains=\{hull.contains_point(@geo.Point::new(2.0, 1.0))}")
}
