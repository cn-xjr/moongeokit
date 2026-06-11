///|
test "point vector operations are deterministic" {
  let a = @moongeokit.Point::new(3.0, 4.0)
  let b = @moongeokit.Point::new(1.0, 2.0)
  assert_eq(a.add(b).x, 4.0)
  assert_eq(a.sub(b).y, 2.0)
  assert_eq(a.scale(2.0).x, 6.0)
  assert_eq(a.length(), 5.0)
}

///|
test "dot cross distance and orientation" {
  let a = @moongeokit.Point::new(0.0, 0.0)
  let b = @moongeokit.Point::new(4.0, 0.0)
  let c = @moongeokit.Point::new(4.0, 3.0)
  assert_eq(b.dot(c), 16.0)
  assert_eq(b.cross(c), 12.0)
  assert_eq(a.distance_to(c), 5.0)
  assert_eq(@moongeokit.orientation(a, b, c), 12.0)
}

///|
test "segment intersection detects crossing segments" {
  let a = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 4.0),
  )
  let b = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 4.0),
    @moongeokit.Point::new(4.0, 0.0),
  )
  assert_true(@moongeokit.segments_intersect(a, b))
}

///|
test "point on segment handles collinear bounds" {
  let segment = @moongeokit.Segment::new(
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
  )
  assert_true(
    @moongeokit.point_on_segment(@moongeokit.Point::new(2.0, 0.0), segment),
  )
  assert_false(
    @moongeokit.point_on_segment(@moongeokit.Point::new(5.0, 0.0), segment),
  )
}

///|
test "bounds from points computes extent" {
  let bounds = @moongeokit.Bounds::from_points([
    @moongeokit.Point::new(2.0, 4.0),
    @moongeokit.Point::new(-1.0, 5.0),
    @moongeokit.Point::new(3.0, -2.0),
  ])
  assert_eq(bounds.min_x, -1.0)
  assert_eq(bounds.max_y, 5.0)
  assert_eq(bounds.width(), 4.0)
  assert_eq(bounds.height(), 7.0)
}

///|
test "bounds containment and intersection" {
  let bounds = @moongeokit.Bounds::new(0.0, 0.0, 4.0, 4.0)
  assert_true(bounds.contains(@moongeokit.Point::new(2.0, 2.0)))
  assert_false(bounds.contains(@moongeokit.Point::new(5.0, 2.0)))
  assert_true(bounds.intersects(@moongeokit.Bounds::new(3.0, 3.0, 5.0, 5.0)))
  assert_false(bounds.intersects(@moongeokit.Bounds::new(5.0, 5.0, 6.0, 6.0)))
}

///|
test "polygon computes area and perimeter" {
  let polygon = @moongeokit.Polygon::new([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
    @moongeokit.Point::new(4.0, 3.0),
    @moongeokit.Point::new(0.0, 3.0),
  ])
  assert_eq(polygon.vertex_count(), 4)
  assert_eq(polygon.area(), 12.0)
  assert_eq(polygon.perimeter(), 14.0)
}

///|
test "polygon average centroid uses all vertices" {
  let polygon = @moongeokit.Polygon::new([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(2.0, 0.0),
    @moongeokit.Point::new(2.0, 2.0),
    @moongeokit.Point::new(0.0, 2.0),
  ])
  let center = polygon.centroid_average()
  assert_eq(center.x, 1.0)
  assert_eq(center.y, 1.0)
}

///|
test "polygon contains point uses ray casting" {
  let polygon = @moongeokit.Polygon::new([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
    @moongeokit.Point::new(4.0, 4.0),
    @moongeokit.Point::new(0.0, 4.0),
  ])
  assert_true(polygon.contains_point(@moongeokit.Point::new(2.0, 2.0)))
  assert_true(polygon.contains_point(@moongeokit.Point::new(0.0, 2.0)))
  assert_false(polygon.contains_point(@moongeokit.Point::new(5.0, 2.0)))
}

///|
test "convex hull removes interior point" {
  let hull = @moongeokit.convex_hull([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
    @moongeokit.Point::new(4.0, 4.0),
    @moongeokit.Point::new(0.0, 4.0),
    @moongeokit.Point::new(2.0, 2.0),
  ])
  assert_eq(hull.vertex_count(), 4)
  assert_eq(hull.area(), 16.0)
}

///|
test "polyline length sums consecutive distances" {
  let line = @moongeokit.Polyline::new([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(3.0, 4.0),
    @moongeokit.Point::new(6.0, 8.0),
  ])
  assert_eq(line.length(), 10.0)
}

///|
test "polyline simplify keeps endpoints and distant points" {
  let line = @moongeokit.Polyline::new([
    @moongeokit.Point::new(0.0, 0.0),
    @moongeokit.Point::new(0.2, 0.0),
    @moongeokit.Point::new(2.0, 0.0),
    @moongeokit.Point::new(2.1, 0.0),
    @moongeokit.Point::new(4.0, 0.0),
  ])
  let simplified = line.simplify_by_distance(1.0)
  assert_eq(simplified.points.length(), 3)
  assert_eq(simplified.points[1].x, 2.0)
  assert_eq(simplified.points[2].x, 4.0)
}
